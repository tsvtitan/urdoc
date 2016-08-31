unit SeoClientDataSet;

interface

uses DB, DbClient, Classes;

type

  TSeoTypeSort=(tsNone,tsAsc,tsDesc);

  TSeoClientDataSet=class(TClientDataSet)
  private
    FDefaultIndexName: string;
    function GetTypeSortStr(TypeSort: TSeoTypeSort): string;
    function GetMasterFields: String;
    procedure SetMasterFileds(Value: string);
    procedure SaveOptParams;
    procedure LoadOptParams;
  public
    procedure CreateDataSetBySource(Source: TDataSet);
    procedure FieldValuesBySource(Source: TDataSet);
    function CreateFieldBySource(const FieldName: string; Source: TDataSet; Required: Boolean=false): TField;
    procedure SetIndexBySort(FieldName: string; TypeSort: TSeoTypeSort);
    procedure InitDefaultIndexDefs;
    function AddIndexDef(const FieldName: string; TypeSort: TSeoTypeSort): TIndexDef;
    procedure LoadFromFile(const FileName: string = '');
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: string = ''; Format: TDataPacketFormat = dfBinary);
    procedure SaveToStream(Stream: TStream; Format: TDataPacketFormat = dfBinary);


    property DefaultIndexName: string read FDefaultIndexName;
    property MasterFields: string read GetMasterFields write SetMasterFileds;
  end;

implementation

uses SysUtils,
     SeoUtils; 

const
  SSortIndexName='SORT_%s_%s';
  SMasterIndexName='MASTER_';
  SFieldOptParam='FIELD_%s';

{ TSeoClientDataSet }

procedure TSeoClientDataSet.CreateDataSetBySource(Source: TDataSet);
var
  i: Integer;
begin
  Close;
  FieldDefs.Clear;
  for i:=0 to Source.Fields.Count-1 do begin
    with FieldDefs.AddFieldDef do begin
      Name:=Source.Fields[i].FieldName;
      DataType:=Source.Fields[i].DataType;
      Size:=Source.Fields[i].Size;
    end;
  end;
  CreateDataSet;
end;

procedure TSeoClientDataSet.FieldValuesBySource(Source: TDataSet);
var
  i: Integer;
  Field: TField;
begin
  CheckBrowseMode;
  Append;
  try
    for i:=0 to Source.Fields.Count-1 do begin
      with Source.Fields[i] do begin
        Field:=FindField(FieldName);
        if Assigned(Field) then
           Field.Value:=Value;
      end;  
    end;
  finally
    Post;
  end;
end;

function TSeoClientDataSet.CreateFieldBySource(const FieldName: string; Source: TDataSet; Required: Boolean): TField;
var
  FieldDef: TFieldDef;
begin
  FieldDef:=FieldDefs.AddFieldDef;
  FieldDef.Name:=FieldName;
  FieldDef.DataType:=Source.FieldByName(FieldName).DataType;
  FieldDef.Size:=Source.FieldByName(FieldName).Size;
  FieldDef.Required:=Required;
  Result:=FieldDef.CreateField(nil);
end;

procedure TSeoClientDataSet.SetIndexBySort(FieldName: string; TypeSort: TSeoTypeSort);
begin
  CheckActive;
  if TypeSort<>tsNone then
    IndexName:=Format(SSortIndexName,[FieldName,GetTypeSortStr(TypeSort)])
  else IndexName:=DefaultIndexName;
end;

function TSeoClientDataSet.GetTypeSortStr(TypeSort: TSeoTypeSort): string;
var
  S: string;
begin
  S:='';
  case TypeSort of
    tsNone: S:='';
    tsAsc: S:='ASC';
    tsDesc: S:='DESC';
  end;
  Result:=S;
end;

procedure TSeoClientDataSet.InitDefaultIndexDefs;
var
  val: Integer;
begin
  if Trim(MasterFields)<>'' then begin
    val:=IndexDefs.IndexOf(FDefaultIndexName);
    if val<>-1 then
      IndexDefs.Delete(val);
    with IndexDefs.AddIndexDef do begin
      Fields:=MasterFields;
      Name:=SMasterIndexName;
      FDefaultIndexName:=Name;
    end;
    if not Active then
      IndexName:=FDefaultIndexName;
  end;
end;

function TSeoClientDataSet.AddIndexDef(const FieldName: string; TypeSort: TSeoTypeSort): TIndexDef;
var
  S: string;
begin
  Result:=nil;
  if TypeSort<>tsNone then begin
    S:=Format(SSortIndexName,[FieldName,GetTypeSortStr(TypeSort)]);
    if IndexDefs.IndexOf(S)=-1 then begin
      Result:=IndexDefs.AddIndexDef;
      Result.Name:=S;
      Result.Fields:=iff(Trim(MasterFields)<>'',MasterFields+';','')+FieldName;
      if TypeSort=tsDesc then
        Result.Options:=Result.Options+[ixDescending];
    end;    
  end;
end;

function TSeoClientDataSet.GetMasterFields: String;
begin
  Result:=inherited MasterFields;
end;

procedure TSeoClientDataSet.SetMasterFileds(Value: string);
begin
  inherited MasterFields:=Value;
  InitDefaultIndexDefs;
end;

procedure TSeoClientDataSet.LoadFromFile(const FileName: string = '');
begin
  inherited LoadFromFile(FileName);
  LoadOptParams;
end;

procedure TSeoClientDataSet.LoadFromStream(Stream: TStream);
begin
  inherited LoadFromStream(Stream);
  LoadOptParams;
end;

procedure TSeoClientDataSet.SaveToFile(const FileName: string = ''; Format: TDataPacketFormat = dfBinary);
begin
  SaveOptParams;
  inherited SaveToFile(FileName,Format);
end;

procedure TSeoClientDataSet.SaveToStream(Stream: TStream; Format: TDataPacketFormat = dfBinary);
begin
  SaveOptParams;
  inherited SaveToStream(Stream,Format);
end;

procedure TSeoClientDataSet.SaveOptParams;
var
  i: Integer;
begin
  if Active then begin
    for i:=0 to FieldCount-1 do begin
      if not AnsiSameText(Fields[i].DisplayLabel,Fields[i].FieldName) then begin
        SetOptionalParam(Format(SFieldOptParam,[Fields[i].FieldName]),Fields[i].DisplayLabel);
      end;
    end;
  end;
end;

procedure TSeoClientDataSet.LoadOptParams;
var
  i: Integer;
  S: String;
begin
  if Active then begin
    for i:=0 to FieldCount-1 do begin
      S:=GetOptionalParam(Format(SFieldOptParam,[Fields[i].FieldName]));
      if Trim(S)<>'' then
        Fields[i].DisplayLabel:=S;
    end;
  end;
end;


end.
