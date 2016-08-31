unit DsnFunc;

// Runtime Design System Version 2.x   1998/06/08-
// Copyright Kazuhiro Sasaki 1997-1998.

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, Controls, Dialogs,
  TypInfo, DsnInfo, DsnList, DsnLgMes;

  procedure SepareteStringsByBar(St,St1,St2:TStrings);
  procedure GetPropTable(FList:TList;FInspectList,FOutList,FPropList,FValueList:TStrings);
  procedure AddObjctProp(AObject:TObject;ItemOrder:Integer;FInspectList,FOutList,FPropList,FValueList,FClassList:TStrings);
  function GetPropCaption(PropNane:String; InspectList,FCaptionList: TStringList):String;
  procedure OderProps(FInspectList,FPropList,FValueList:TStrings);
  procedure SetProp(Targets:TList;PropName,Value:String);
  procedure DsnCheckName(aOwner:TComponent; Reader:TReader; Component:TComponent; var Name:String);
  function DsnCheckNameNew(aOwner:TComponent;Component:TComponent; Name:String): String;

implementation

procedure SepareteStringsByBar(St,St1,St2:TStrings);
var
  i,n:integer;
begin
  if Assigned(St1) and Assigned(St2) then
  begin
    St1.Clear;
    St2.Clear;
    for i:= 0 to St.Count-1 do
    begin
      n:=AnsiPos('|',St[i]);
      if n = 0 then
      begin
        St1.Add(St[i]);
        St2.Add(St[i]);
      end
      else
      begin
        St1.Add(Copy(St[i],1,n-1));
        St2.Add(Copy(St[i],n+1,Length(St[i])-n));
      end;
    end;
  end;
end;

procedure GetPropTable(FList:TList;FInspectList,FOutList,FPropList,FValueList:TStrings);
var
  i,ItemOrder: integer;
  FClassList: TStringList;
begin
  FClassList:= TStringList.Create;
  for i:= 0 to FList.Count -1 do
  begin
    ItemOrder:= i+1;
    AddObjctProp(TObject(FList[i]),ItemOrder,FInspectList,FOutList,FPropList,FValueList,FClassList);
  end;
  FClassList.Free;
end;

procedure AddObjctProp(AObject:TObject;ItemOrder:Integer;FInspectList,FOutList,FPropList,FValueList,FClassList:TStrings);
var
  ObjInfo:TObjInfo;
  i,n: integer;
begin
  ObjInfo:= TObjInfo.Create(AObject);

  //First Item Entry
  if ItemOrder = 1 then
  begin
    FClassList.Add(ObjInfo.Name);
    for i:= 0 to ObjInfo.PropCount -1 do
      if FInspectList.IndexOf(ObjInfo[i].Name) >= 0 then
        FPropList.Add(ObjInfo[i].Name);
    for i:= 0 to FPropList.Count -1 do
    begin
      n:= ObjInfo.IndexOfProp(FPropList[i]);
      FValueList.Add(ObjInfo[n].Value);
    end;
  end;

  //Reference to OutList
  if ItemOrder = 2 then
    for i:= FPropList.Count -1 downto 0 do
      if FOutList.IndexOf(FPropList[i]) >= 0 then
      begin
        FPropList.Delete(i);
        FValueList.Delete(i);
      end;

  //Selection of Common Property
  if FClassList.IndexOf(ObjInfo.Name) = -1 then
  begin
    FClassList.Add(ObjInfo.Name);

    for i:= FPropList.Count -1 downto 0 do
      if ObjInfo.IndexOfProp(FPropList[i]) = -1 then
      begin
        FPropList.Delete(i);
        FValueList.Delete(i);
      end;

  end;

  //Comparison of Values
  if ItemOrder > 1 then
    for i:= 0 to FValueList.Count -1 do
    begin
      n:= ObjInfo.IndexOfProp(FPropList[i]);
      case ObjInfo[n].Kind of
        tkInteger, tkChar, tkEnumeration, tkSet, tkFloat:
          if ObjInfo[n].Value <> FValueList[i] then
            FValueList[i] := '';
        tkString,tkLString:
          FValueList[i] := FValueList[i];
        tkClass, tkMethod:
          FValueList[i] := '';
        else
          FValueList[i] := '';
      end;
    end;

  ObjInfo.Free;
end;

function GetPropCaption(PropNane:String; InspectList,FCaptionList: TStringList):String;
var
  n:integer;
begin
  n:= InspectList.IndexOf(PropNane);
  Result:= FCaptionList[n];
end;

procedure OderProps(FInspectList,FPropList,FValueList:TStrings);
var
  i,n:integer;
begin
  for i:= FInspectList.Count -1 downto 0 do
  begin
    n:= FPropList.IndexOf(FInspectList[i]);
    if n > -1 then
    begin
      FPropList.Move(n,0);
      FValueList.Move(n,0);
    end;
  end;
end;

procedure SetProp(Targets:TList;PropName,Value:String);
var
  PropInfo:PPropInfo;
  Component:TComponent;
  i:integer;
begin
  if PropName = '' then
    Exit;
    
  for i:= 0 to Targets.Count -1 do
  begin
    Component:= TComponent(Targets[i]);
    PropInfo:= GetPropInfo(Component.ClassInfo,PropName);

    try
      if Value = '' then
      begin
        case PropInfo^.PropType^.Kind of
          tkString, tkLString, tkWString:
            SetStrProp(Component,PropInfo,Value);
        end;
      end
      else
      begin
        case PropInfo^.PropType^.Kind of
          tkInteger:
            SetOrdProp(Component,PropInfo,StrToInt(Value));
          tkChar:
            SetOrdProp(Component,PropInfo,Ord(Value[1]));
          tkEnumeration:
            SetOrdProp(Component,PropInfo,GetEnumValue(PropInfo^.PropType^,Value));
          tkFloat:
            SetFloatProp(Component,PropInfo,StrToFloat(Value));
          tkString, tkLString, tkWString:
            SetStrProp(Component,PropInfo,Value);
          {tkSet:}
          {tkClass: }
          {tkMethod:}
        end;
      end;
    except
      Raise Exception.Create(Value + PROP_VALUEERROR + PropName + ')');
    end;
  end;
end;

procedure DsnCheckName(aOwner:TComponent; Reader:TReader; Component:TComponent; var Name:String);
var
 i:integer;
 S:String;
begin
  i := 0;
  S:=Component.ClassName;
  Delete(S,1,1);
  while aOwner.FindComponent(Name) <> nil do
  begin
    Inc(I);
    Name := Format('%s%d', [S, I]);
  end;
end;

function DsnCheckNameNew(aOwner:TComponent;Component:TComponent; Name:String): String;
var
 i:integer;
 S:String;
begin
  i := 0;
  S:=Component.ClassName;
  Delete(S,1,1);
  Result:=Name;
  while aOwner.FindComponent(Result) <> nil do
  begin
    Inc(I);
    Result := Format('%s%d', [S, I]);
  end;
end;

end.
