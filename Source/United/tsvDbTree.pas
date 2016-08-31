unit tsvDbTree;

interface

uses Windows, Messages, Classes, Controls, Graphics, Db, VirtualTrees, VirtualDBTreeEx;

type
  TtsvDbTree=class;
  TDBTreeColumns=class;

  TDBTreeColumn=class(TCollectionItem)
  private
    FColumns: TDBTreeColumns;
    FTreeColumn: TVirtualTreeColumn;
    FFieldName: string;
    FWidthChanged: Boolean;
    function GetCaption: string;
    procedure SetCaption(Value: String);
    function GetTree: TtsvDbTree;
    function GetWidth: Integer;
    procedure SetWidth(Value: Integer);
  protected
    property Tree: TtsvDbTree read GetTree;
    property TreeColumn: TVirtualTreeColumn read FTreeColumn write FTreeColumn;

    property WidthChanged: Boolean read FWidthChanged; 
  public
    constructor Create(Collection: TCollection); override;
    property Caption: String read GetCaption write SetCaption;
    property Width: Integer read GetWidth write SetWidth;
    property FieldName: string read FFieldName write FFieldName;
  end;

  TDBTreeColumnClass=class Of TDBTreeColumn;

  TDBTreeColumns=class(TCollection)
  private
    FTree: TtsvDbTree;
    function GetItem(Index: Integer): TDBTreeColumn;
    procedure SetItem(Index: Integer; Value: TDBTreeColumn);
  public
    constructor Create(AOwner: TtsvDbTree; ADBTreeColumnClass: TDBTreeColumnClass);
    function Add: TDBTreeColumn; reintroduce;
    procedure Clear; reintroduce;

    function GetColumnByTreeColumn(Value: TVirtualTreeColumn): TDBTreeColumn;
    property Items[Index: Integer]: TDBTreeColumn read GetItem write SetItem; default;
  end;

  TDBTreeColumnsClass=class of TDBTreeColumns;

  TDBVTHeader=class(TVTHeader)
  end;

  TDBTreeBookmarkList=class(TList)
  end;

  TtsvDbTree=class(TVirtualDBTreeEx)
  private
    FBookmarks: TDBTreeBookmarkList;
    FColumns: TDBTreeColumns;
    FIndicators: TImageList;
    FVisibleRowNumber: Boolean;
    FColumnSortColor: TColor;
    FOldColumnSortColor: TColor;
    FOffsetText, FOffsetIndicator: Integer;
    procedure SetVisibleRowNumber(Value: Boolean);

    function GetHeader: TDBVTHeader;
    function GetColumns: TDBTreeColumns;
    procedure WMMouseWheel(var Message: TWMMouseWheel);message WM_MOUSEWHEEL;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
    function GetMainColumn: TColumnIndex;
    function GetSelectedField: TField;
    function GetDataSet: TDataSet;
    procedure RebuilColumns;

    property Header: TDBVTHeader read GetHeader;
    property DataSet: TDataSet read GetDataSet;
  protected
    function GetHeaderClass: TVTHeaderClass; override;
    procedure DoAfterCellPaint(Canvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect); override;
    procedure DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var Text: WideString); override;
    function DoCompare(Node1, Node2: PVirtualNode; Column: TColumnIndex): Integer; override;
    procedure DoHeaderClick(Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    Procedure DataLinkScrolled; override;
    Procedure DataLinkActiveChanged; Override;
    procedure DoFocusChange(Node: PVirtualNode; Column: TColumnIndex); override;
    procedure DoFocusNode(Node: PVirtualNode; Ask: Boolean); override;
    function DoKeyAction(var CharCode: Word; var Shift: TShiftState): Boolean; override;
    procedure Click; override;
    procedure SetWidthRowNumber(Node: PVirtualNode);
    function GetDefaultColumnWidth(Field: TField; Column: TColumnIndex): Integer;
    function GetSelectedRows: TDBTreeBookmarkList;

  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); reintroduce;


    procedure UpdateRowNumber;

    function Last: Boolean;
    function First: Boolean;
    function Prior: Boolean;
    function Next: Boolean;

    property Columns: TDBTreeColumns read GetColumns;
    property MainColumn: TColumnIndex read GetMainColumn;
    property VisibleRowNumber: Boolean read FVisibleRowNumber write SetVisibleRowNumber;
    property ColumnSortColor: TColor read FColumnSortColor write FColumnSortColor;
    property SelectedField: TField read GetSelectedField;
    property SelectedRows: TDBTreeBookmarkList read GetSelectedRows;
  end;

implementation

uses SysUtils, Math, Variants, ImgList, Types, Forms;

{$R *.res}

const
  STextNumber='¹';
  bmArrow = 'DBTVARROW';
  DefaultColumnWidth=0;

{ TDBTreeColumn }

constructor TDBTreeColumn.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FWidthChanged:=false;
  if Collection is TDBTreeColumns then
    FColumns:=TDBTreeColumns(Collection);
end;

function TDBTreeColumn.GetTree: TtsvDbTree;
begin
  Result:=FColumns.FTree;
end;

function TDBTreeColumn.GetCaption: string;
begin
  Result:='';
  if Assigned(FTreeColumn) then
    Result:=FTreeColumn.Text; 
end;

procedure TDBTreeColumn.SetCaption(Value: String);
begin
  if Assigned(FTreeColumn) then
    FTreeColumn.Text:=Value; 
end;

function TDBTreeColumn.GetWidth: Integer;
begin
  Result:=0;
  if Assigned(FTreeColumn) then
    Result:=FTreeColumn.Width;
end;

procedure TDBTreeColumn.SetWidth(Value: Integer);
begin
  if Assigned(FTreeColumn) then begin
    FWidthChanged:=true;
    FTreeColumn.Width:=Value;
  end;  
end;

{ TDBTreeColumns }

constructor TDBTreeColumns.Create(AOwner: TtsvDbTree; ADBTreeColumnClass: TDBTreeColumnClass);
begin
  inherited Create(ADBTreeColumnClass);
  FTree:=AOwner;
end;

function TDBTreeColumns.GetItem(Index: Integer): TDBTreeColumn;
begin
  Result:=TDBTreeColumn(inherited Items[Index]);
end;

procedure TDBTreeColumns.SetItem(Index: Integer; Value: TDBTreeColumn);
begin
  Items[Index]:=Value;
end;

function TDBTreeColumns.Add: TDBTreeColumn;
begin
  Result:=TDBTreeColumn(inherited Add);
  Result.TreeColumn:=FTree.Header.Columns.Add;
  with Result.TreeColumn do begin
    Options:=Options+[coAllowClick,coEnabled,coVisible,coDraggable,coResizable,coShowDropMark];
    Width:=DefaultColumnWidth;
    Margin:=0;
    Spacing:=0;
  end;
  if (Count>0) then
    FTree.Header.MainColumn:=1;
end;

procedure TDBTreeColumns.Clear;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    if Assigned(Items[i].TreeColumn) then
      Items[i].TreeColumn.Free;
  end;
  inherited Clear;
end;

function TDBTreeColumns.GetColumnByTreeColumn(Value: TVirtualTreeColumn): TDBTreeColumn;
var
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    if Items[i].TreeColumn=Value then begin
      Result:=Items[i];
      exit;
    end;
  end;
end;

{ TDBVTHeader }

{ TtsvDbTree }

constructor TtsvDbTree.Create(Owner: TComponent);
var
  bmp: TBitmap;
begin
  inherited Create(Owner);
  FBookmarks:=TDBTreeBookmarkList.Create;
  bmp:=TBitmap.Create;
  try
    bmp.LoadFromResourceName(HInstance, bmArrow);
    FIndicators:=TImageList.CreateSize(bmp.Width,bmp.Height);
    FIndicators.AddMasked(Bmp, clWhite);
  finally
    bmp.Free;
  end;
  FOffsetText:=2;
  FOffsetIndicator:=3;
  FColumnSortColor:=clInfoBk;
  FOldColumnSortColor:=clWindow;
  FColumns:=TDBTreeColumns.Create(Self,TDBTreeColumn);
  Margin:=0;
  LineMode:=lmBands;
  LineStyle:=lsSolid;
  DefaultText:='';
  Colors.FocusedSelectionColor:=clBlack;
  Colors.FocusedSelectionBorderColor:=clBlack;
  Colors.UnfocusedSelectionColor:=clBlack;
  Colors.UnfocusedSelectionBorderColor:=clBlack;
  Colors.FocusedCellSelectionColor:=clHighlight;
  Colors.FocusedCellSelectionBorderColor:=clHighlight;
  Colors.UnFocusedCellSelectionColor:=clBtnShadow;
  Colors.UnFocusedCellSelectionBorderColor:=clBtnShadow;
  DBOptions:=DBOptions+[dboCheckChildren,dboCheckDBStructure,dboParentStructure,dboTrackActive,
                        dboTrackChanges,dboTrackCursor,dboViewAll,dboWriteLevel,dboWriteSecondary];
  TreeOptions.SelectionOptions:=TreeOptions.SelectionOptions+[toExtendedFocus,toFullRowSelect,toRightClickSelect,
                                                              toLevelSelectConstraint,toSiblingSelectConstraint];

  TreeOptions.MiscOptions:=TreeOptions.MiscOptions-[toToggleOnDblClick];

  with Header do begin
    Options:=[hoColumnResize,hoDblClickResize,hoDrag,hoShowSortGlyphs,hoVisible];
    Height:=18;
    Background:=Color;
    with Columns.Add do begin
      Options:=Options-[coAllowClick,coDraggable,coResizable,coShowDropMark];
      Text:=STextNumber;
      MinWidth:=FIndicators.Width;
      Margin:=0;
      Spacing:=0;
    end;
  end;

  FVisibleRowNumber:=false;
end;

destructor TtsvDbTree.Destroy;
begin
  FreeAndNil(FColumns);
  FreeAndNil(FIndicators);
  FReeAndNIl(FBookmarks);
  inherited Destroy;
end;

function TtsvDbTree.GetDefaultColumnWidth(Field: TField; Column: TColumnIndex): Integer;
var
  W: Integer;
  RestoreCanvas: Boolean;
  TM: TTextMetric;
begin
  Result:=100;
  if Assigned(Field) then begin
    RestoreCanvas := not HandleAllocated;
    if RestoreCanvas then
      Canvas.Handle := GetDC(0);
    try
      Canvas.Font := Self.Font;
      GetTextMetrics(Canvas.Handle, TM);
      Result := Field.DisplayWidth * (Canvas.TextWidth('0') - TM.tmOverhang) + TM.tmOverhang + 4;
      Canvas.Font := Header.Font;
      W := Canvas.TextWidth(Header.Columns[Column].Text) + 4;
      if Result < W then
        Result := W;
    finally
      if RestoreCanvas then
      begin
        ReleaseDC(0,Canvas.Handle);
        Canvas.Handle := 0;
      end;
    end;
  end
end;

function TtsvDbTree.GetHeaderClass: TVTHeaderClass;
begin
  Result:=TDBVTHeader;
end;

function TtsvDbTree.GetHeader: TDBVTHeader;
begin
  Result:=TDBVTHeader(inherited Header);
end;

function TtsvDbTree.GetColumns: TDBTreeColumns;
begin
  Result:=FColumns;
end;

procedure TtsvDbTree.SetVisibleRowNumber(Value: Boolean);
begin
  if Assigned(Columns) then begin
    FVisibleRowNumber:=Value;
    UpdateRowNumber;
  end;
end;

procedure TtsvDbTree.DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var Text: WideString); 
var
  CellData: Variant;
  Data: PDBNodeData;
  NewCol: TColumnIndex;
begin
  if (Column=0) then begin
    Text:=Inttostr(AbsoluteIndex(Node)+1);
  end else begin
    NewCol:=Column;
    NewCol:=NewCol-1;
    Data:=GetDBNodeData(Node);
    CellData:=Data.DBData;
    if VarIsArray(CellData) then begin
      if not VarIsNull(CellData[NewCol]) then
         Text:=CellData[NewCol];
    end else  begin
      Text:=Celldata;
    end;
  end;
  inherited DoGetText(Node,Column,TextType,Text);
end;

procedure TtsvDbTree.DoAfterCellPaint(Canvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
var
  X,Y: Integer;
  S: string;
  W,H: Integer;
  R: TRect;
begin
  if Column<>0 then exit;
  R:=CellRect;
  Canvas.Brush.Color:=clBtnFace;
  Canvas.FillRect(R);
  X:=R.Left;
  Y:=R.Top;
  if FVisibleRowNumber then begin
    S:=Inttostr(AbsoluteIndex(Node)+1);
    with Canvas do begin
      Font.Color:=clWindowText;
      H:=TextHeight(S);
      W:=TextWidth(S);
      X:=X+FOffsetText;
      Y:=Y+(R.Bottom-R.Top) div 2 - H div 2;
      TextRect(CellRect,X,Y,S);
    end;
    X:=X+W+FOffsetIndicator;
  end else X:=X+FOffsetIndicator;
  if Node=FocusedNode then begin
    H:=FIndicators.Height;
    Y:=R.Top+(R.Bottom-R.Top) div 2 - H div 2;
    FIndicators.Draw(Canvas,X,Y,0);
  end;
  R.Right:=R.Right+1;
  R.Bottom:=R.Bottom+1;
  DrawEdge(Canvas.Handle,R,BDR_RAISEDINNER or BDR_RAISEDOUTER,BF_RECT or BF_SOFT or BF_ADJUST);
end;

procedure TtsvDbTree.DoHeaderClick(Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
type
  TSortDirectionEx=(sdeNone,sdeAsc,sdeDesc);
var
  NextSort: TSortDirectionEx;
  OldColumn: TColumnIndex;
begin
  NextSort:=sdeAsc;
  OldColumn:=Header.SortColumn;
  if (Header.SortColumn<>Column) then begin
     if OldColumn<>-1 then
       Header.Columns.Items[OldColumn].Color:=FOldColumnSortColor;
     FOldColumnSortColor:=Header.Columns.Items[Column].Color;
     Header.SortColumn:=Column;
  end else begin
    case Header.SortDirection of
      sdAscending: NextSort:=sdeDesc;
      sdDescending: NextSort:=sdeNone;
    end;
  end;

  case NextSort of
    sdeNone: begin
      Header.SortColumn:=-1;
      Header.Columns.Items[Column].Color:=FOldColumnSortColor;
      RefreshNodes;
    end;
    sdeAsc: begin
      Header.SortDirection:=sdAscending;
      Header.Columns.Items[Column].Color:=FColumnSortColor;
      SortTree(Column,sdAscending,true);
    end;
    sdeDesc: begin
      Header.SortDirection:=sdDescending;
      Header.Columns.Items[Column].Color:=FColumnSortColor;
      SortTree(Column,sdDescending,true);
    end;
  end;
  
end;

function TtsvDbTree.DoCompare(Node1, Node2: PVirtualNode; Column: TColumnIndex): Integer; 
var
  Value1,Value2: Variant;
  Data1,Data2: PDBNodeData;
  vt: DWord;
  NewCol: TColumnIndex;
begin
  Result:=0;
  
  NewCol:=Column;
  NewCol:=NewCol-1;
  
  Data1:=GetDBNodeData(Node1);
  Data2:=GetDBNodeData(Node2);

  if VarIsArray(Data1.DBData) then begin
    Value1:=Data1.DBData[NewCol];
    if VarIsNull(Value1) then exit;
    Value2:=Data2.DBData[NewCol];
    if VarIsNull(Value2) then exit;
    vt:=TVarData(Value1).VType;
    case vt of
      varString,varOleStr: begin
        Result:=CompareText(Value1,Value2);
      end;
      varInteger,varSmallint,varSingle,
      varDouble,varCurrency,varDate,varShortInt,
      varByte,varWord,varLongWord,varInt64: begin
        if Value1>Value2 then
          Result:=1
        else if Value1<Value2 then
          Result:=-1;
      end;
    end;
  end;
end;

procedure TtsvDbTree.WMMouseWheel(var Message: TWMMouseWheel);
const
  CountWheel=1;
begin
  with Message do begin
    if WheelDelta<0 then
      Next
    else Prior; 
    Result:=1;
  end;
end;

function TtsvDbTree.Last: Boolean;
var
  Node: PVirtualNode;
  Data: PDBVTData;
begin
  Node:=GetLast(nil);
  if Assigned(Node) then begin
    Data:=GetNodeData(Node);
    if Assigned(Data) then
      GoToRec(Data.ID);
  end;
  Result:=Assigned(Node);
end;

function TtsvDbTree.First: Boolean;
var
  Node: PVirtualNode;
  Data: PDBVTData;
begin
  Node:=GetFirst;
  if Assigned(Node) then begin
    Data:=GetNodeData(Node);
    if Assigned(Data) then
      GoToRec(Data.ID);
  end;
  Result:=Assigned(Node);
end;

function TtsvDbTree.Prior: Boolean;
var
  Node: PVirtualNode;
  Data: PDBVTData;
begin
  Node:=GetPrevious(GetFirstSelected);
  if Assigned(Node) then begin
    Data:=GetNodeData(Node);
    if Assigned(Data) then
      GoToRec(Data.ID);
  end;
  Result:=Assigned(Node);
end;

function TtsvDbTree.Next: Boolean;
var
  Node: PVirtualNode;
  Data: PDBVTData;
begin
  Node:=GetNext(GetFirstSelected);
  if Assigned(Node) then begin
    Data:=GetNodeData(Node);
    if Assigned(Data) then
      GoToRec(Data.ID);
  end;
  Result:=Assigned(Node);
end;

function TtsvDbTree.GetMainColumn: TColumnIndex;
begin
  Result:=Header.MainColumn;
end;

procedure TtsvDbTree.WMKeyDown(var Message: TWMKeyDown);
begin
  inherited;
end;

procedure TtsvDbTree.KeyDown(var Key: Word; Shift: TShiftState);
begin
  SendMessage(Handle,WM_KEYDOWN,Key,0);
end;

function TtsvDbTree.DoKeyAction(var CharCode: Word; var Shift: TShiftState): Boolean; 
begin
  if Shift=[] then begin
    case CharCode of
      VK_LEFT: begin
        Result:=FocusedColumn<>1;
        exit;
      end;  
      VK_HOME: begin
        FocusedColumn:=1;
        Result:=false;
        exit;
      end;
      VK_END: begin
        FocusedColumn:=Header.Columns.Count-1;
        Result:=false;
        exit;
      end;
    end;
  end;
  Result:=inherited DoKeyAction(CharCode,Shift);
end;

procedure TtsvDbTree.Click; 
begin
  inherited;
end;

procedure TtsvDbTree.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
  if FocusedColumn=0 then
    FocusedColumn:=1;
end;

procedure TtsvDbTree.WMRButtonDown(var Message: TWMRButtonDown);
begin
  inherited;
  if FocusedColumn=0 then
    FocusedColumn:=1;
end;

procedure TtsvDbTree.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Header.Font:=Font;
  SetWidthRowNumber(GetFirstSelected);
end;

procedure TtsvDbTree.SetWidthRowNumber(Node: PVirtualNode);
var
  ARow: Integer;
  W: Integer;
begin
  W:=FIndicators.Width+3;
  if FVisibleRowNumber then begin
    if Assigned(Node) then begin
      ARow:=AbsoluteIndex(Node)+1;
      W:=W+FOffsetText+Canvas.TextWidth(Inttostr(ARow))+FOffsetIndicator;
    end;
  end else W:=W+FOffsetIndicator;
  Header.Columns[0].Width:=W;
end;

Procedure TtsvDbTree.DataLinkScrolled;
begin
  inherited;
  SetWidthRowNumber(GetFirstSelected);
end;

procedure TtsvDbTree.DoFocusChange(Node: PVirtualNode; Column: TColumnIndex);
begin
  SetWidthRowNumber(Node);
  inherited DoFocusChange(Node,Column);
  SetWidthRowNumber(Node);
end;

procedure TtsvDbTree.DoFocusNode(Node: PVirtualNode; Ask: Boolean);
begin
  SetWidthRowNumber(Node);
  inherited DoFocusNode(Node,Ask);
  SetWidthRowNumber(Node);
end;

procedure TtsvDbTree.UpdateRowNumber;
begin
  SetWidthRowNumber(GetFirstSelected);
end;

function TtsvDbTree.GetDataSet: TDataSet;
begin
  Result:=nil;
  if Assigned(DataSource) then
    if Assigned(DataSource.DataSet) then
      Result:=DataSource.DataSet;
end;

function TtsvDbTree.GetSelectedField: TField;
var
  HeaderColumn: TVirtualTreeColumn;
  Column: TDBTreeColumn;
begin
  Result:=nil;
  if Assigned(DataSet) then
    if (Header.Columns.Count>0) and (FocusedColumn>0) then begin
      HeaderColumn:=Header.Columns[FocusedColumn];
      Column:=Columns.GetColumnByTreeColumn(HeaderColumn);
      Result:=DataSet.FieldByName(Column.FieldName);
    end;
end;

procedure TtsvDbTree.DataLinkActiveChanged;
begin
  inherited;
  RebuilColumns;
end;

procedure TtsvDbTree.RebuilColumns;
var
  i: Integer;
  Field: TField;
begin
  if Assigned(DataSet) then
    if DataSet.Active then
      with Columns do
        for i:=0 to Count-1 do begin
          Field:=DataSet.FieldByName(Items[i].FieldName);
          if Assigned(Field) then
            if not Items[i].WidthChanged then
              Items[i].Width:=GetDefaultColumnWidth(Field,Items[i].TreeColumn.Position);
        end;
end;

function TtsvDbTree.GetSelectedRows: TDBTreeBookmarkList;
{var
  Node: PVirtualNode;}
begin
  Result:=nil;
{  if not Assigned(DataSet) then exit;
  if DataSet.Active then begin
    FBookmarks.Clear;
    Node:=GetFirstSelected;
    While Assigned(Node) do begin
      FBookmarks.Add()
      Node:=GetNextSelected(Node);
    end;
    Result:=FBookmarks;
  end;}
end;

end.

