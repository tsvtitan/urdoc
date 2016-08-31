unit DsnInfo;

// Runtime Design System Version 2.x   June/08/1998
// Copyright(c) 1998 Kazuhiro Sasaki.

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, Controls, Dialogs,
  TypInfo;

type

  TMyPropInfo = record
    Name:String;
    Value:String;
    Kind: TTypeKind;
  end;

  TObjInfo = class
  private
    FInstance:TObject;
    FName: String;
    FCount:Integer;
    FPropList: PPropList;
    HaveInstance:Boolean;
    procedure ListUpProps(Instance:TObject);
    function GetItems(Index:Integer):TMyPropInfo;
  public
    constructor Create(Instance: TObject);
    destructor Destroy; override;
    function IndexOfProp(const S:String):Integer;
    property Name:String read FName;
    property Items[Index:Integer]: TMyPropInfo read GetItems; default;
    property PropCount: Integer read FCount;
  end;

  function PropValueToStr(Instance: TPersistent;
                        PropInfo: PPropInfo):string;

implementation

type
  TIntegerSet = set of 0..SizeOf(Integer) * 8 - 1;

function PropValueToStr(Instance: TPersistent;
                        PropInfo: PPropInfo):string;
var
  PropType: PTypeInfo;

  function SetPropToStr(Value: Cardinal):string;
  var
    I: Integer;
    BaseType: PTypeInfo;
  begin
    BaseType := GetTypeData(PropType)^.CompType^;
    Result := '[';
    for I := 0 to 15 do
      if I in TIntegerSet(Value) then begin
        if Result <> '[' then
          Result := Result + ',';
        Result := Result + GetEnumName(BaseType, I);
      end;
    Result := Result + ']';
  end;

  function OrdPropToStr:string;
  var
    Value: Longint;
  begin
    Value := GetOrdProp(Instance, PropInfo);
    case PropType^.Kind of
        tkInteger:
          Result := IntToStr(Value);
        tkChar:
          Result := Chr(Value);
        tkSet:
          Result := SetPropToStr(Value);
        tkEnumeration:
          Result := GetEnumName(PropType, Value);
    end;
  end;

  function FloatPropToStr:string;
  var
    Value: Extended;
  begin
    Value := GetFloatProp(Instance, PropInfo);
    Result := FloatToStr(Value);
  end;

  function StrPropToStr:string;
  begin
    Result := GetStrProp(Instance, PropInfo);
  end;

  function ClassPropToStr:string;
  var
    Component: TComponent;
  begin
    if GetTypeData(PropInfo^.PropType^)^.ClassType.InheritsFrom(TComponent)
    then begin
      Component := TComponent(GetOrdProp(Instance, PropInfo));
      if Component = nil then
        Result := ''
      else
        Result := Component.Name;
    end else begin
      FmtStr(Result, '(%s)', [PropInfo^.PropType^.Name]);
    end;
  end;

  function MethodPropToStr: string;
  var
    Value: TMethod;
    Root: TComponent;
  begin
    Value := GetMethodProp(Instance, PropInfo);
    if Value.Code <> nil then
    begin
      if Instance is TForm then
        Root := TComponent(Instance)
      else
        Root := TComponent(Instance).Owner;
      Result := Root.MethodName(Value.Code);
    end else begin
      Result := '';
    end;
  end;

begin
  begin
    PropType := PropInfo^.PropType^;
    case PropType^.Kind of
      tkInteger, tkChar, tkEnumeration, tkSet:
        Result := OrdPropToStr;
      tkFloat:
        Result := FloatPropToStr;
      tkString,tkLString:
        Result := StrPropToStr;
      tkClass:
        Result := ClassPropToStr;
      tkMethod:
        Result := MethodPropToStr;
     else
        Result := 'Unknown';
    end;
  end;
end;

{TObjInfo}
constructor TObjInfo.Create(Instance: TObject);
begin
  HaveInstance:= False;
  if Assigned(Instance) then
  begin
    FInstance:= Instance;
    FName:= Instance.ClassName;
    ListUpProps(Instance);
  end;
end;

destructor TObjInfo.Destroy;
begin
  if HaveInstance then
    FreeMem(FPropList, PropCount * SizeOf(Pointer));

  inherited Destroy;
end;

function TObjInfo.GetItems(Index:Integer):TMyPropInfo;
var
  PropInfo: PPropInfo;
  PropType: PTypeInfo;
  PropName, PropValue: string;
begin
  PropInfo := FPropList^[Index];
  if PropInfo = nil then
  begin
    Raise Exception.Create('Invalid Index');
    Exit;
  end;
  PropName := PropInfo^.Name;
  Result.Name:= PropName;
  PropValue := PropValueToStr(TPersistent(FInstance),PropInfo);
  Result.Value:= PropValue;
  PropType := PropInfo^.PropType^;
  Result.Kind:= PropType^.Kind;
end;

function TObjInfo.IndexOfProp(const S:String):Integer;
var
  i:integer;
  St:TStringList;
begin
  St:=TStringList.Create;
  for i:= 0 to FCount -1 do
    St.Add(Self[i].Name);

  Result:= St.IndexOf(S);
  St.Free;
end;

procedure TObjInfo.ListUpProps(Instance:TObject);
begin
  FCount := GetTypeData(Instance.ClassInfo)^.PropCount;
  if FCount > 0 then
  begin
    GetMem(FPropList, FCount * SizeOf(Pointer));
    HaveInstance:= True;
    try
      GetPropInfos(Instance.ClassInfo, FPropList);
    except
    end;
  end;
end;

end.
