unit DsnProp;

// Runtime Design System Version 2.x   1998/06/08-
// Copyright Kazuhiro Sasaki 1997-1998.

interface

uses
  Windows, SysUtils, Classes, Forms, Controls, Messages, Dialogs,
  TypInfo, DsnList, DsnInfo, DsnFunc, DsnMes;

type
  TCustomInspector = class;

  TMultiProps = class(TReceiveTargets)
  private
    FClassList:TStringList;
    FInspectList:TStringList;
    FCaptionList:TStringList;
    FOutList:TStringList;
    FPropList:TStringList;
    FValueList:TStringList;
    FSuperList:TStringList;
    FList:TList;
    FInspector:TCustomInspector;
  protected
    procedure ItemDeath(Index:Integer); override;
    procedure Add(Item:Pointer); override;
    procedure Clear; override;
    procedure Delete(Index:Integer); override;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SetPosition; override;
    procedure GetValues;
    procedure SetInspectList(Strings:TStrings);
    procedure SetCaptionList(Strings:TStrings);
    procedure SetOutList(Strings:TStrings);
    procedure SetInspector(Inspector:TCustomInspector);
    property PropList:TStringList read FPropList;
    property ValueList:TStringList read FValueList;
    property InspectList:TStringList read FInspectList;
    property CaptionList:TStringList read FCaptionList;
    property List:TList read FList;
  end;

  TSelectedComponents = class
  private
    FList: TList;
  protected
    function GetComponents(Index:Integer):TComponent;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AssignList(Targets:TList);
    function Count:Integer;
    property Items[Index:Integer]:TComponent read GetComponents;default;
    property List:TList read FList;
  end;

  TCallPropEditor = procedure
                    (Sender:TObject;Targets:TSelectedComponents;
                                 PropName:String;var Value:String)
                                                          of Object;
  TCustomInspector = class(TComponent)
  private   //The ansister will be changed to TDsnPartner.
    FSelfProps:TStrings;
    FBtnProps:TStrings;
    FOutProps:TStrings;
    FDesigning:Boolean;
    FOnBtnClick:TCallPropEditor;
    FMultiProps:TMultiProps;
  protected
    procedure SetSelfProps(Value: TStrings);
    procedure SetBtnProps(Value: TStrings);
    procedure SetOutProps(Value: TStrings);
    procedure SetDesigning(Value: Boolean);virtual;
    procedure Show;virtual;abstract;
    procedure Hide;virtual;abstract;
    procedure SetProperty(PropName,Value:String);virtual;
    procedure BtnClick(PropName:String;var Value:String);virtual;abstract;
    procedure SetPosition;virtual;abstract;
    property MultiProps:TMultiProps read FMultiProps;
    property SelfProps:TStrings read FSelfProps write SetSelfProps;
    property BtnProps:TStrings read FBtnProps write SetBtnProps;
    property OutProps:TStrings read FOutProps write SetOutProps;
    property OnBtnClick:TCallPropEditor read FOnBtnClick write FOnBtnClick;
  public
    StageHandle: THandle;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure ChangeTarget(Control: TControl);virtual;
    procedure GetPropLists(InspectList,CaptionList:TStrings);virtual;abstract;
    function GetOutProps:TStrings;
    property Designing:Boolean read FDesigning write SetDesigning;
  end;

  TContextProps = class
  private
    FInspectList:TStringList;
    FCaptionList:TStringList;
    FOutList:TStrings;
    FPropList:TStringList;
    FValueList:TStringList;
    FList:TList;
  protected
    function GetCaption(Index:Integer):String;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure CreateTable(SelfProps,OutList:TStrings;List:TList);
    property PropList: TStringList read FPropList;
    property ValueList: TStringList read FValueList;
    property Caption[Index:Integer]: String read GetCaption;
  end;


implementation

constructor TMultiProps.Create;
begin
  FClassList:= TStringList.Create;
  FInspectList:= TStringList.Create;
  FCaptionList:= TStringList.Create;
  FOutList:= TStringList.Create;
  FPropList:= TStringList.Create;
  FValueList:= TStringList.Create;
  FSuperList:= TStringList.Create;
  FList:= TList.Create;
end;

destructor TMultiProps.Destroy;
begin
  FClassList.Free;
  FInspectList.Free;
  FCaptionList.Free;
  FOutList.Free;
  FSuperList.Free;
  FPropList.Free;
  FValueList.Free;
  FList.Free;
  inherited Destroy;
end;

procedure TMultiProps.ItemDeath(Index:Integer);
begin
  if Assigned(FList) then
    FList[Index]:= nil;
end;

procedure TMultiProps.Add(Item:Pointer);
var
  ObjInfo:TObjInfo;
  i,n: integer;
begin
  if FList.IndexOf(Item) > -1 then
    Exit;
  FList.Add(Item);

  ObjInfo:= TObjInfo.Create(TObject(Item));

  //First Item Entry
  if FList.Count = 1 then
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
    FSuperList.Assign(FPropList);
  end;

  //Reference to OutList
  if FList.Count = 2 then
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

    //Collect All Property
    for i:= 0 to ObjInfo.PropCount -1 do
      if FSuperList.IndexOf(ObjInfo[i].Name) = -1 then
        if FInspectList.IndexOf(ObjInfo[i].Name) > -1 then
          FSuperList.Add(ObjInfo[i].Name);
  end;

  //Comparison of Values
  if FList.Count > 1 then
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
  OderProps(FInspectList,FPropList,FValueList);
end;

procedure TMultiProps.Clear;
begin
  FClassList.Clear;
  FSuperList.Clear;
  FList.Clear;
  FPropList.Clear;
  FValueList.Clear;
end;

procedure TMultiProps.Delete(Index:Integer);
var
  i,j,n:integer;
  Instance:TObject;
  ObjInfo:TObjInfo;
  Temp,NewProp:TStringList;
begin
  if FList[Index] = nil then
    Exit;
    
  Instance:=TObject(FList[Index]);
  FList.Delete(Index);

  if FList.Count = 0 then
  begin
    Clear;
    Exit;
  end;
  
  Temp:=TStringList.Create;
  Temp.Assign(FSuperList);
  FSuperList.Clear;

  //Delete Property, whose Deleted Instance, that is out of Common, from Temp(FSuperList)
  ObjInfo:=TObjInfo.Create(Instance);
  for i:= 0 to ObjInfo.PropCount -1 do
    if FPropList.IndexOf(ObjInfo[i].Name) = -1 then
      if FInspectList.IndexOf(ObjInfo[i].Name) > -1 then
      begin
        n:= Temp.IndexOf(ObjInfo[i].Name);
        if FOutList.IndexOf(ObjInfo[i].Name) = -1 then
          Temp.Delete(n);
      end;
  ObjInfo.Free;

  //Delete Property in FPropList from Temp
  for i:= 0 to FPropList.Count -1 do
  begin
    n:= Temp.IndexOf(FPropList[i]);
    Temp.Delete(n);
  end;

  //Make New Common Property List
  if FList.Count > 0 then
  begin
    ObjInfo:=TObjInfo.Create(TObject(FList[0]));
    FClassList.Clear;
    FClassList.Add(ObjInfo.Name);
    NewProp:=TStringList.Create;
    for i:= 0 to Temp.Count -1 do
      if ObjInfo.IndexOfProp(Temp[i]) > -1 then
        NewProp.Add(Temp[i]);
    for i:= 0 to ObjInfo.PropCount -1 do
      if FInspectList.IndexOf(ObjInfo[i].Name) > -1 then
        FSuperList.Add(ObjInfo[i].Name);
    ObjInfo.Free;
    Temp.Free;
  end
  else
    Exit;

  if FList.Count > 1 then
  begin
    for i:= NewProp.Count -1 downto 0 do
      if FOutList.IndexOf(NewProp[i]) > -1 then
        NewProp.Delete(i);

    for i:= 1 to FList.Count -1 do
    begin
      ObjInfo:=TObjInfo.Create(TObject(FList[i]));
      if FClassList.IndexOf(ObjInfo.Name) = -1 then
      begin
        FClassList.Add(ObjInfo.Name);
        for j:= NewProp.Count -1 downto 0 do
          if ObjInfo.IndexOfProp(NewProp[j]) = -1 then
            NewProp.Delete(j);

       //Collect All Property
       for j:= 0 to ObjInfo.PropCount -1 do
         if FSuperList.IndexOf(ObjInfo[j].Name) = -1 then
           if FInspectList.IndexOf(ObjInfo[j].Name) > -1 then
             FSuperList.Add(ObjInfo[j].Name);
      end;
      ObjInfo.Free;
    end;
  end;

  //FPropList + NewProp
  FPropList.AddStrings(NewProp);
  NewProp.Free;

  //Value Listup
  FValueList.Clear;
  ObjInfo:=TObjInfo.Create(TObject(FList[0]));
  for i:= 0 to FPropList.Count -1 do
  begin
    n:= ObjInfo.IndexOfProp(FPropList[i]);
    FValueList.Add(ObjInfo[n].Value);
  end;
  ObjInfo.Free;

  if FList.Count > 1 then
    for i:= 1 to FList.Count -1 do
    begin
      ObjInfo:=TObjInfo.Create(TObject(FList[i]));
      for j:= 0 to FValueList.Count -1 do
      begin
        n:= ObjInfo.IndexOfProp(FPropList[j]);
        case ObjInfo[n].Kind of
          tkInteger, tkChar, tkEnumeration, tkSet, tkFloat:
            if ObjInfo[n].Value <> FValueList[j] then
              FValueList[j] := '';
          tkString,tkLString:
            FValueList[j] := FValueList[j];
          tkClass, tkMethod:
            FValueList[j] := '';
          else
            FValueList[j] := '';
        end;
      end;
      ObjInfo.Free;
    end;
  OderProps(FInspectList,FPropList,FValueList);
end;

procedure TMultiProps.GetValues;
var
  i,j,n:integer;
  ObjInfo:TObjInfo;
begin
  FValueList.Clear;
  if FList.Count = 0 then
    Exit;
  ObjInfo:=TObjInfo.Create(TObject(FList[0]));
  for i:= 0 to FPropList.Count -1 do
  begin
    n:= ObjInfo.IndexOfProp(FPropList[i]);
    if n > -1 then
      FValueList.Add(ObjInfo[n].Value);
  end;
  ObjInfo.Free;

  if FList.Count > 1 then
    for i:= 1 to FList.Count -1 do
    begin
      ObjInfo:=TObjInfo.Create(TObject(FList[i]));
      for j:= 0 to FValueList.Count -1 do
      begin
        n:= ObjInfo.IndexOfProp(FPropList[j]);
        if n > -1 then
          case ObjInfo[n].Kind of
            tkInteger, tkChar, tkEnumeration, tkSet, tkFloat:
              if ObjInfo[n].Value <> FValueList[j] then
                FValueList[j] := '';
            tkString,tkLString:
              FValueList[j] := FValueList[j];
            tkClass, tkMethod:
              FValueList[j] := '';
            else
              FValueList[j] := '';
          end;
      end;
      ObjInfo.Free;
    end;
end;

procedure TMultiProps.SetPosition;
begin
  GetValues;
  if Assigned(FInspector) then
    FInspector.SetPosition;
end;

procedure TMultiProps.SetInspectList(Strings:TStrings);
begin
  FInspectList.Assign(Strings);
end;

procedure TMultiProps.SetCaptionList(Strings:TStrings);
begin
  FCaptionList.Assign(Strings);
end;

procedure TMultiProps.SetOutList(Strings:TStrings);
begin
  FOutList.Assign(Strings);
end;

procedure TMultiProps.SetInspector(Inspector:TCustomInspector);
begin
  if Assigned(Inspector) then
  begin
    FInspector:= Inspector;
    FInspector.FMultiProps:= Self;
  end
  else
    FInspector:= nil;
end;


{TSelectedComponents}
constructor TSelectedComponents.Create;
begin
  FList:= TList.Create;
end;

destructor TSelectedComponents.Destroy;
begin
  FList.Free;
end;

function TSelectedComponents.GetComponents(Index:Integer):TComponent;
begin
  Result:= TComponent(FList[Index]);
end;

procedure TSelectedComponents.AssignList(Targets:TList);
var
  i:integer;
begin
  for i:= 0 to Targets.Count -1 do
    FList.Add(Targets[i]);
end;

function TSelectedComponents.Count:Integer;
begin
  Result:= FList.Count;
end;

{TDsnInspector}
constructor TCustomInspector.Create(AOwner: TComponent);
begin
  inherited;
  FSelfProps:= TStringList.Create;
  FBtnProps:= TStringList.Create;
  FOutProps:= TStringList.Create;
  FDesigning:= False;
  StageHandle:= 0;
end;

destructor  TCustomInspector.Destroy;
begin
  FSelfProps.Free;
  FBtnProps.Free;
  FOutProps.Free;
  inherited;
end;

procedure TCustomInspector.SetSelfProps(Value: TStrings);
begin
  FSelfProps.Assign(Value);
end;

procedure TCustomInspector.SetBtnProps(Value: TStrings);
begin
  FBtnProps.Assign(Value);
end;

procedure TCustomInspector.SetOutProps(Value: TStrings);
begin
  FOutProps.Assign(Value);
end;

procedure TCustomInspector.SetProperty(PropName,Value:String);
begin
  SetProp(MultiProps.List,PropName,Value);
  if StageHandle <> 0 then
    PostMessage(StageHandle,CI_SETPROPERTY,0,0);
  FMultiProps.GetValues;
end;

procedure TCustomInspector.ChangeTarget(Control: TControl);
var
  Parent: TWinControl;
begin
  if Control is TWinControl then
    Parent:= TWinControl(Control)
  else
    Parent:= Control.Parent;
  SendMessage(Parent.Handle, CI_SELECT, Integer(Control),0);
end;

procedure TCustomInspector.SetDesigning(Value: Boolean);
begin
  if FDesigning = Value then Exit;
  FDesigning:=Value;
  if FDesigning then
    Show
  else
    Hide;
end;

function TCustomInspector.GetOutProps:TStrings;
begin
  Result:= FOutProps;
end;

{TContextProps}
constructor TContextProps.Create;
begin
  FInspectList:= TStringList.Create;
  FCaptionList:= TStringList.Create;
  FPropList:= TStringList.Create;
  FValueList:= TStringList.Create;
end;

destructor TContextProps.Destroy;
begin
  FInspectList.Free;
  FCaptionList.Free;
  FPropList.Free;
  FValueList.Free;
end;

procedure TContextProps.CreateTable(SelfProps,OutList:TStrings;List:TList);
begin
  FOutList:= OutList;
  FList:= List;
  SepareteStringsByBar(SelfProps,FInspectList,FCaptionList);
  GetPropTable(FList,FInspectList,FOutList,FPropList,FValueList);
  OderProps(FInspectList,FPropList,FValueList);
end;

function TContextProps.GetCaption(Index:Integer):String;
begin
  Result:= GetPropCaption(FPropList[Index],FInspectList,FCaptionList);
end;

end.
