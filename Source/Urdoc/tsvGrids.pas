unit tsvGrids;


interface

uses SysUtils,Messages,Windows,Classes,Graphics, Menus, Controls, Forms, StdCtrls,
  Grids,Buttons, Dialogs, Mask, extctrls,typinfo,ComCtrls,Commctrl,
  StrLEdit, tsvPicEdit, Yupack, Udm, {Jpeg,} URBMask, db, UNewControls,
  ULinksEdit, Variants, MaskUtils;


type
  PStructGrid = ^TStructGrid;
  TStructGrid = record
     PTI: PTypeInfo;
     PropName: String;
     Obj: Pointer;
     RusName: string;
     EngName: string;
     Info: String;
  end;

  TtsvCustomGrid = class;

  TtsvButton = class(TSpeedbutton)
  public
    property Align;
  end;

  TtsvPnlInspector = class;

  TtsvList = Class(TListBox)
  private
    FInspector: TtsvPnlInspector;
    procedure SetInspector(Value: TtsvPnlInspector);
    procedure SetItem;
  public
    DefItemHeight: Integer;
    procedure ListMouseUp(Sender: TObject;
                Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListDrawItem(Control: TWinControl;  Index: Integer;
                             Rect: TRect; State: TOwnerDrawState);

  end;

  TtsvCombo =class(TComboBox)
  private
    FInspector: TtsvPnlInspector;
    FStatus: Boolean;
    procedure SetInspector(Value: TtsvPnlInspector);
//    procedure CBGETCURSEL(var Msg: TMsg);message  CB_GETCURSEL;
 //   procedure UpdateInsp;
  protected
  public
    Constructor Create(AOwner: TComponent);override;
    procedure ComboKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ComboClick(Sender: TObject);
    procedure ComboMouseDown(Sender: TObject;
                Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GoUpdate;            
    property Align;
  end;

  TtsvInplaceEdit = class(TCustomMaskEdit)
  private
    FGrid: TtsvCustomGrid;
    FClickTime: Longint;
    procedure InternalMove(const Loc,RLoc: TRect; Redraw: Boolean);
    procedure SetGrid(Value: TtsvCustomGrid);
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMPaste(var Message); message WM_PASTE;
    procedure WMCut(var Message); message WM_CUT;
    procedure WMClear(var Message); message WM_CLEAR;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DblClick; override;
    function EditCanModify: Boolean;override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure BoundsChanged; virtual;
    procedure UpdateContents; virtual;
    procedure WndProc(var Message: TMessage); override;

    property  Grid: TtsvCustomGrid read FGrid;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Deselect;
    procedure Hide;
    procedure Invalidate; reintroduce;
    procedure Move(const Loc,RLoc: TRect);
    function PosEqual(const Rect: TRect): Boolean;
    procedure SetFocus; reintroduce;
    procedure UpdateLoc(const Loc,RLoc: TRect);
    function Visible: Boolean;
  end;

  TEditType = (edNormal,edList,edPointer,edNormalSet,edPointerChange);

  TGridScrollDirections = set of (gsdLeft, gsdRight, gsdUp, gsdDown);

  TtsvCustomGrid = class(TCustomControl)
  private
    FDecButtonH: Integer;
    FWidthDef: Integer;
    FOldText: string;
    FEditType: TEditType;
    FAnchor: TGridCoord;
    FBorderStyle: TBorderStyle;
    FCanEditModify: Boolean;
    FColCount: Longint;
    FColWidths: Pointer;
    FTabStops: Pointer;
    FCurrent: TGridCoord;
    FDefaultColWidth: Integer;
    FDefaultRowHeight: Integer;
    FFixedCols: Integer;
    FFixedRows: Integer;
    FFixedColor: TColor;
    FGridLineWidth: Integer;
    FOptions: TGridOptions;
    FRowCount: Longint;
    FRowHeights: Pointer;
    FScrollBars: TScrollStyle;
    FTopLeft: TGridCoord;
    FSizingIndex: Longint;
    FSizingPos, FSizingOfs: Integer;
    FMoveIndex, FMovePos: Longint;
    FHitTest: TPoint;
    FInplaceEdit: TtsvInplaceEdit;
    FInplaceCol, FInplaceRow: Longint;
    FColOffset: Integer;
    FDefaultDrawing: Boolean;
    FEditorMode: Boolean;
    PStGd: PStructGrid;
    FInspector: TtsvPnlInspector;
    procedure SetInspector(Value: TtsvPnlInspector);
    function CalcCoordFromPoint(X, Y: Integer;
      const DrawInfo: TGridDrawInfo): TGridCoord;
    procedure CalcDrawInfo(var DrawInfo: TGridDrawInfo);
    procedure CalcDrawInfoXY(var DrawInfo: TGridDrawInfo;
      UseWidth, UseHeight: Integer);
    procedure CalcFixedInfo(var DrawInfo: TGridDrawInfo);
    function CalcMaxTopLeft(const Coord: TGridCoord;
      const DrawInfo: TGridDrawInfo): TGridCoord;
    procedure CalcSizingState(X, Y: Integer; var State: TGridState;
      var Index: Longint; var SizingPos, SizingOfs: Integer;
      var FixedInfo: TGridDrawInfo);
    procedure ChangeSize(NewColCount, NewRowCount: Longint);
    procedure ClampInView(const Coord: TGridCoord);
    procedure DrawSizingLine(const DrawInfo: TGridDrawInfo);
    procedure DrawMove;
    procedure GridRectToScreenRect(GridRect: TGridRect;
      var ScreenRect: TRect; IncludeLine: Boolean);
    procedure HideEdit;
    procedure Initialize;
    procedure InvalidateGrid;
    procedure InvalidateRect(ARect: TGridRect);
    procedure ModifyScrollBar(ScrollBar, ScrollCode, Pos: Cardinal);
    procedure MoveAdjust(var CellPos: Longint; FromIndex, ToIndex: Longint);
    procedure MoveAnchor(const NewAnchor: TGridCoord);
    procedure MoveAndScroll(Mouse, CellHit: Integer; var DrawInfo: TGridDrawInfo;
      var Axis: TGridAxisDrawInfo; Scrollbar: Integer);
    procedure MoveCurrent(ACol, ARow: Longint; MoveAnchor, Show: Boolean);
    procedure MoveTopLeft(ALeft, ATop: Longint);
    procedure ResizeCol(Index: Longint; OldSize, NewSize: Integer);
    procedure ResizeRow(Index: Longint; OldSize, NewSize: Integer);
    procedure SelectionMoved(const OldSel: TGridRect);
    procedure ScrollDataInfo(DX, DY: Integer; var DrawInfo: TGridDrawInfo);
    procedure TopLeftMoved(const OldTopLeft: TGridCoord);
    procedure UpdateScrollPos;
    procedure UpdateScrollRange;
    function GetColWidths(Index: Longint): Integer;
    function GetRowHeights(Index: Longint): Integer;
    function GetSelection: TGridRect;
    function GetTabStops(Index: Longint): Boolean;
    function GetVisibleColCount: Integer;
    function GetVisibleRowCount: Integer;
    function IsActiveControl: Boolean;
    procedure ReadColWidths(Reader: TReader);
    procedure ReadRowHeights(Reader: TReader);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetCol(Value: Longint);
    procedure SetColCount(Value: Longint);
    procedure SetColWidths(Index: Longint; Value: Integer);
    procedure SetDefaultColWidth(Value: Integer);
    procedure SetDefaultRowHeight(Value: Integer);
    procedure SetEditorMode(Value: Boolean);
    procedure SetEditType(Value: TEditType);
    procedure SetFixedColor(Value: TColor);
    procedure SetFixedCols(Value: Integer);
    procedure SetFixedRows(Value: Integer);
    procedure SetGridLineWidth(Value: Integer);
    procedure SetLeftCol(Value: Longint);
    procedure SetOptions(Value: TGridOptions);
    procedure SetRow(Value: Longint);
    procedure SetRowCount(Value: Longint);
    procedure SetRowHeights(Index: Longint; Value: Integer);
    procedure SetScrollBars(Value: TScrollStyle);
    procedure SetSelection(Value: TGridRect);
    procedure SetTabStops(Index: Longint; Value: Boolean);
    procedure SetTopRow(Value: Longint);
//    procedure MoveTop(NewTop: Integer);
    function SelectCell(ACol, ARow: Longint): Boolean; virtual;
    procedure UpdateText;
    procedure WriteColWidths(Writer: TWriter);
    procedure WriteRowHeights(Writer: TWriter);
    procedure CMCancelMode(var Msg: TMessage); message CM_CANCELMODE;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMDesignHitTest(var Msg: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure WMChar(var Msg: TWMChar); message WM_CHAR;
    procedure WMCommand(var Message: TWMCommand); message WM_COMMAND;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMLButtonDown(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMTimer(var Msg: TWMTimer); message WM_TIMER;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
  protected
    Button: TtsvButton;
    FBmpEdList:TBitmap;
    FBmpEdPointer:TBitmap;
    FGridState: TGridState;
    FSaveCellExtents: Boolean;
    DesignOptionsBoost: TGridOptions;
    VirtualView: Boolean;
    function CreateEditor: TtsvInplaceEdit; virtual;
    procedure UpdateScrollBar;
    procedure CreateWnd; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure AdjustSize(Index, Amount: Longint; Rows: Boolean); reintroduce; dynamic;
    function BoxRect(ALeft, ATop, ARight, ABottom: Longint): TRect;
    procedure DoExit; override;
    function CellRect(ACol, ARow: Longint): TRect;
    function CanEditAcceptKey(Key: Char): Boolean; dynamic;
    function CanGridAcceptKey(Key: Word; Shift: TShiftState): Boolean; dynamic;
    function CanEditModify: Boolean; dynamic;
    function CanEditShow: Boolean; virtual;
    function GetEditText(ACol, ARow: Longint): string; dynamic;
    procedure SetEditText(ACol, ARow: Longint; const Value: string); dynamic;
    function GetEditMask(ACol, ARow: Longint): string; dynamic;
    function GetEditLimit: Integer; dynamic;
    function GetGridWidth: Integer;
    function GetGridHeight: Integer;
    procedure HideEditor;
    procedure ShowEditor;
    procedure ShowEditorChar(Ch: Char);
    procedure InvalidateEditor;
    procedure MoveColumn(FromIndex, ToIndex: Longint);
    procedure ColumnMoved(FromIndex, ToIndex: Longint); dynamic;
    procedure Notification(AComponent: Tcomponent; Operation: TOperation); override;
    procedure MoveRow(FromIndex, ToIndex: Longint);
    procedure RowMoved(FromIndex, ToIndex: Longint); dynamic;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); virtual; abstract;
    procedure DefineProperties(Filer: TFiler); override;
    procedure MoveColRow(ACol, ARow: Longint; MoveAnchor, Show: Boolean);
    procedure SizeChanged(OldColCount, OldRowCount: Longint); dynamic;
    function Sizing(X, Y: Integer): Boolean;
    procedure ScrollData(DX, DY: Integer);
    procedure InvalidateCol(ACol: Longint);
    procedure InvalidateRow(ARow: Longint);
    procedure TopLeftChanged; dynamic;
    procedure TimedScroll(Directions: TGridScrollDirections); dynamic;
    procedure Paint; override;
    procedure ColWidthsChanged; dynamic;
    procedure RowHeightsChanged; dynamic;
    procedure DeleteColumn(ACol: Longint);
    procedure DeleteRow(ARow: Longint);
    procedure UpdateDesigner;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Col: Longint read FCurrent.X write SetCol;
    property Color default clWindow;
    property ColCount: Longint read FColCount write SetColCount default 5;
    property ColWidths[Index: Longint]: Integer read GetColWidths write SetColWidths;
    property DefaultColWidth: Integer read FDefaultColWidth write SetDefaultColWidth default 64;
    property DefaultDrawing: Boolean read FDefaultDrawing write FDefaultDrawing default True;
    property DefaultRowHeight: Integer read FDefaultRowHeight write SetDefaultRowHeight default 24;
    property EditorMode: Boolean read FEditorMode write SetEditorMode;
    property FixedColor: TColor read FFixedColor write SetFixedColor default clBtnFace;
    property FixedCols: Integer read FFixedCols write SetFixedCols default 1;
    property FixedRows: Integer read FFixedRows write SetFixedRows default 1;
    property GridHeight: Integer read GetGridHeight;
    property GridLineWidth: Integer read FGridLineWidth write SetGridLineWidth default 1;
    property GridWidth: Integer read GetGridWidth;
    property HitTest: TPoint read FHitTest;
    property LeftCol: Longint read FTopLeft.X write SetLeftCol;
    property Options: TGridOptions read FOptions write SetOptions
      default [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine,
      goRangeSelect];
    property ParentColor default False;
    property Row: Longint read FCurrent.Y write SetRow;
    property RowCount: Longint read FRowCount write SetRowCount default 5;
    property RowHeights[Index: Longint]: Integer read GetRowHeights write SetRowHeights;
    property ScrollBars: TScrollStyle read FScrollBars write SetScrollBars default ssBoth;
    property Selection: TGridRect read GetSelection write SetSelection;
    property TabStops[Index: Longint]: Boolean read GetTabStops write SetTabStops;
    property TopRow: Longint read FTopLeft.Y write SetTopRow;
    property VisibleColCount: Integer read GetVisibleColCount;
    property VisibleRowCount: Integer read GetVisibleRowCount;
    property EditType: TEditType read FEditType write SetEditType;
  public
    OldRow: LongInt;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function MouseCoord(X, Y: Integer): TGridCoord;
    procedure SetPlace;
    procedure SetNormal(Rect: TRect);
    procedure SetNormalSet(Rect: TRect);
    procedure SetPointer(Rect: TRect);
    procedure SetPointerChange(Rect: TRect);
    procedure SetList(Rect: TRect);
    procedure ChangeCell(ACol,ARow: Longint);
    procedure UpdateEdit;
    procedure InvalidateCell(ACol, ARow: Longint);
    procedure FocusCell(ACol, ARow: Longint; MoveAnchor: Boolean);
    property InplaceEditor: TtsvInplaceEdit read FInplaceEdit;
    property OldText: String read FOldText write FOldText;
  published
    property TabStop default True;
  end;

  TtsvDrawGrid = class(TtsvCustomGrid)
  private
    FOnColumnMoved: TMovedEvent;
    FOnDrawCell: TDrawCellEvent;
    FOnGetEditMask: TGetEditEvent;
    FOnGetEditText: TGetEditEvent;
    FOnRowMoved: TMovedEvent;
    FOnSelectCell: TSelectCellEvent;
    FOnSetEditText: TSetEditEvent;
    FOnTopLeftChanged: TNotifyEvent;
  protected
    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    function GetEditMask(ACol, ARow: Longint): string; override;
    function GetEditText(ACol, ARow: Longint): string; override;
    procedure RowMoved(FromIndex, ToIndex: Longint); override;
    function SelectCell(ACol, ARow: Longint): Boolean; override;
    procedure SetEditText(ACol, ARow: Longint; const Value: string); override;
    procedure TopLeftChanged; override;
  public
    function CellRect(ACol, ARow: Longint): TRect;
    procedure MouseToCell(X, Y: Integer; var ACol, ARow: Longint);
    property Canvas;
    property Col;
    property ColWidths;
    property EditorMode;
    property GridHeight;
    property GridWidth;
    property LeftCol;
    property Selection;
    property Row;
    property RowHeights;
    property TabStops;
    property TopRow;
  published
    property Align;
    property BorderStyle;
    property Color;
    property ColCount;
    property Ctl3D;
    property DefaultColWidth;
    property DefaultRowHeight;
    property DefaultDrawing;
    property DragCursor;
    property DragMode;
    property Enabled;
    property EditType;
    property FixedColor;
    property FixedCols;
    property RowCount;
    property FixedRows;
    property Font;
    property GridLineWidth;
    property Options;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property VisibleColCount;
    property VisibleRowCount;
    property OnClick;
    property OnColumnMoved: TMovedEvent read FOnColumnMoved write FOnColumnMoved;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawCell: TDrawCellEvent read FOnDrawCell write FOnDrawCell;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetEditMask: TGetEditEvent read FOnGetEditMask write FOnGetEditMask;
    property OnGetEditText: TGetEditEvent read FOnGetEditText write FOnGetEditText;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnRowMoved: TMovedEvent read FOnRowMoved write FOnRowMoved;
    property OnSelectCell: TSelectCellEvent read FOnSelectCell write FOnSelectCell;
    property OnSetEditText: TSetEditEvent read FOnSetEditText write FOnSetEditText;
    property OnStartDrag;
    property OnTopLeftChanged: TNotifyEvent read FOnTopLeftChanged write FOnTopLeftChanged;
  end;

  TtsvStringGrid= class;

  TtsvStringGridStrings = class(TStrings)
  private
    FGrid: TtsvStringGrid;
    FIndex: Integer;
    procedure CalcXY(Index: Integer; var X, Y: Integer);
  protected
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
    function GetObject(Index: Integer): TObject; override;
    procedure Put(Index: Integer; const S: string); override;
    procedure PutObject(Index: Integer; AObject: TObject); override;
    procedure SetUpdateState(Updating: Boolean); override;
  public
    constructor Create(AGrid: TtsvStringGrid; AIndex: Longint);
    procedure Clear; override;
    function Add(const S: string): Integer; override;
    procedure Assign(Source: TPersistent); override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
  end;


  TtsvStringGrid = class(TtsvDrawGrid)
  private
    FData: Pointer;
    FRows: Pointer;
    FCols: Pointer;
    FUpdating: Boolean;
    FNeedsUpdating: Boolean;
    FEditUpdate: Integer;
    FSorted: Boolean;
    procedure SetSorted(Value: Boolean);
    procedure DisableEditUpdate;
    procedure EnableEditUpdate;
    procedure Initialize;
    procedure Update(ACol, ARow: Integer); reintroduce;
    procedure SetUpdateState(Updating: Boolean);
    function GetCells(ACol, ARow: Integer): string;
    function GetCols(Index: Integer): TStrings;
    function GetObjects(ACol, ARow: Integer): TObject;
    function GetRows(Index: Integer): TStrings;
    procedure SetCells(ACol, ARow: Integer; const Value: string);
    procedure SetCols(Index: Integer; Value: TStrings);
    procedure SetObjects(ACol, ARow: Integer; Value: TObject);
    procedure SetRows(Index: Integer; Value: TStrings);
    function EnsureColRow(Index: Integer; IsCol: Boolean): TtsvStringGridStrings;
    function EnsureDataRow(ARow: Integer): Pointer;
  protected
    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    function GetEditText(ACol, ARow: Longint): string; override;
    procedure SetEditText(ACol, ARow: Longint; const Value: string); override;
    procedure RowMoved(FromIndex, ToIndex: Longint); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Sort;
    procedure QuickSort(L, R: Integer);
    procedure ExchangeItems(Index1, Index2: Integer);
    property Cells[ACol, ARow: Integer]: string read GetCells write SetCells;
    property Cols[Index: Integer]: TStrings read GetCols write SetCols;
    property Objects[ACol, ARow: Integer]: TObject read GetObjects write SetObjects;
    property Rows[Index: Integer]: TStrings read GetRows write SetRows;
  published
    property Sorted: Boolean read FSorted write SetSorted;
  end;

  TtsvLang=(lgNone,lgEnglish,lgRussian);

  TtsvPnlInspector = class(TWinControl)
  private
    FMemoInfo: TMemo;
    FListCursorImages: TImageList;
    FLanguage: TtsvLang;
    FValueObj: TObject;
    FList: TtsvList;
    FfmList: TForm;
    FCombo: TtsvCombo;
    FGridP: TtsvStringGrid;
    FGridE: TtsvStringGrid;
    FPage: TPageControl;
    FTSProp: TTabSheet;
    FTSEven: TTabSheet;
    FTableMethod: TStringList;
    FTableMethodPPI: TStringList;
    FIDName: Longint;
    FFilter: Boolean;
    FFilterItems: TStringList;
    FLabel: TLabel;
    FUncoveredList: TStringList;

    procedure InvalidProperty;
    procedure FillListCursorImages;
    procedure SetFilterForCreate;
    procedure SetTranslateForCreate;
    procedure SetLanguage(Value: TtsvLang);
    procedure ChangeSetText(Ob: TObject; PTD: PTypeData; PTI: PTypeInfo; PPI:PPropInfo; Index: integer);
    procedure SetFilter(Value: Boolean);
    procedure SetFilterItems(Value: TStringList);
    Procedure AddStructGrid(TmpG: TTsvStringGrid; Index: Integer; PTI: PTypeInfo; PropName: String;
                                 Obj:Pointer);
    Procedure ReplaceStructGrid(TmpG: TTsvStringGrid; Index:Integer; PTI: PTypeInfo;
              PropName: String; Obj:Pointer);
    procedure FillUncoveredProperty;
    procedure LocateLastProp;
  protected
    procedure SetListProp;
    procedure SetTypeProp;
    procedure SetPropDialog(PTInfo: PTypeInfo);
    procedure InsertRow(Index,CP: Integer);
    procedure DelRow(Index,CP: Integer; tmpG: TtsvStringGrid);
    procedure Notification(AComponent: Tcomponent; Operation: TOperation); override;
  public
    FCurHint: String;
    FLastProp: String;
    OldName,NewName: String;
    LinksList: TList;
    AllControlList: TList;
    ListRus: TStringList;
    ListEng: TStringList;
    ListLang: TStringList;
    ListInfo: TStringLIst;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage); override;
    procedure UpdateLangLists(tmpG: TtsvStringGrid);
    procedure FilterForList;
    function ReadLangName(Index: integer; tmpG: TtsvStringGrid): String;
    procedure GridPDblClick(Sender: TObject);
    procedure UpdateInspector(Value: TComponent);
    procedure RefreshInspector;
    procedure RefreshLang(Lang: TtsvLang);
    procedure UpdateTypeInfo;
    procedure ButtonDClick(Sender: TObject);
    function TextExtent(const Text: string): TSize;
    procedure RefreshWithLanguageAndFilter(Lan: Boolean; Fil: Boolean);
    procedure GridPOnSelectCell(Sender: TObject; ACol, ARow: Longint;
                var CanSelect: Boolean);
    property IDName: Longint read FIDName write FIDName;
    property ValueObj: TObject read FValueObj write FValueObj;
    property List: TtsvList read FList write FList;
    property fmList: TForm read FfmList write FfmList;
    property Combo: TtsvCombo read FCombo write FCombo;
    property GridP: TtsvStringGrid read FGridP write FGridP;
    property GridE: TtsvStringGrid read FGridE write FGridE;
    property Page: TPageControl read FPage write FPage;
    property TSProp: TTabSheet read FTSProp write FTSProp;
    property TSEven: TTabSheet read FTSEven write FTSEven;
    property cmLabel: TLabel read FLabel write FLabel;
    property MemoInfo: TMemo read FMemoInfo write FMemoInfo;

   published
    property Align;
    property Filter: Boolean read FFilter write SetFilter;
    property FilterItems: TStringList read FFilterItems write SetFilterItems;
    Property Language: TtsvLang read FLanguage write SetLanguage;
  end;


const
  Colors: array[0..41] of TIdentMapEntry = (
    (Value: clBlack; Name: 'clBlack'),
    (Value: clMaroon; Name: 'clMaroon'),
    (Value: clGreen; Name: 'clGreen'),
    (Value: clOlive; Name: 'clOlive'),
    (Value: clNavy; Name: 'clNavy'),
    (Value: clPurple; Name: 'clPurple'),
    (Value: clTeal; Name: 'clTeal'),
    (Value: clGray; Name: 'clGray'),
    (Value: clSilver; Name: 'clSilver'),
    (Value: clRed; Name: 'clRed'),
    (Value: clLime; Name: 'clLime'),
    (Value: clYellow; Name: 'clYellow'),
    (Value: clBlue; Name: 'clBlue'),
    (Value: clFuchsia; Name: 'clFuchsia'),
    (Value: clAqua; Name: 'clAqua'),
    (Value: clWhite; Name: 'clWhite'),
    (Value: clScrollBar; Name: 'clScrollBar'),
    (Value: clBackground; Name: 'clBackground'),
    (Value: clActiveCaption; Name: 'clActiveCaption'),
    (Value: clInactiveCaption; Name: 'clInactiveCaption'),
    (Value: clMenu; Name: 'clMenu'),
    (Value: clWindow; Name: 'clWindow'),
    (Value: clWindowFrame; Name: 'clWindowFrame'),
    (Value: clMenuText; Name: 'clMenuText'),
    (Value: clWindowText; Name: 'clWindowText'),
    (Value: clCaptionText; Name: 'clCaptionText'),
    (Value: clActiveBorder; Name: 'clActiveBorder'),
    (Value: clInactiveBorder; Name: 'clInactiveBorder'),
    (Value: clAppWorkSpace; Name: 'clAppWorkSpace'),
    (Value: clHighlight; Name: 'clHighlight'),
    (Value: clHighlightText; Name: 'clHighlightText'),
    (Value: clBtnFace; Name: 'clBtnFace'),
    (Value: clBtnShadow; Name: 'clBtnShadow'),
    (Value: clGrayText; Name: 'clGrayText'),
    (Value: clBtnText; Name: 'clBtnText'),
    (Value: clInactiveCaptionText; Name: 'clInactiveCaptionText'),
    (Value: clBtnHighlight; Name: 'clBtnHighlight'),
    (Value: cl3DDkShadow; Name: 'cl3DDkShadow'),
    (Value: cl3DLight; Name: 'cl3DLight'),
    (Value: clInfoText; Name: 'clInfoText'),
    (Value: clInfoBk; Name: 'clInfoBk'),
    (Value: clNone; Name: 'clNone'));

  CountCursors=22;
  NameCursors: array[0..CountCursors-1] of TIdentMapEntry = (
    (Value: crAppStart;     Name: 'crAppStart'),
    (Value: crArrow;        Name: 'crArrow'),
    (Value: crCross;        Name: 'crCross'),
    (Value: crDefault;      Name: 'crDefault'),
    (Value: crDrag;         Name: 'crDrag'),
    (Value: crHandPoint;    Name: 'crHandPoint'),
    (Value: crHelp;         Name: 'crHelp'),
    (Value: crHourGlass;    Name: 'crHourGlass'),
    (Value: crHSplit;       Name: 'crHSplit'),
    (Value: crIBeam;        Name: 'crIBeam'),
    (Value: crMultiDrag;    Name: 'crMultiDrag'),
    (Value: crNo;           Name: 'crNo'),
    (Value: crNoDrop;       Name: 'crNoDrop'),
    (Value: crSizeAll;       Name: 'crSizeAll'),
    (Value: crSizeNESW;     Name: 'crSizeNESW'),
    (Value: crSizeNS;       Name: 'crSizeNS'),
    (Value: crSizeNWSE;     Name: 'crSizeNWSE'),
    (Value: crSizeWE;       Name: 'crSizeWE'),
    (Value: crSQLWait;      Name: 'crSQLWait'),
    (Value: crUpArrow;      Name: 'crUpArrow'),
    (Value: crVSplit;       Name: 'crVSplit'),
    { Dead cursors }
    (Value: crSize;         Name: 'crSize'));

  FontCharsets: array[0..17] of TIdentMapEntry = (
    (Value: 0; Name: 'ANSI_CHARSET'),
    (Value: 1; Name: 'DEFAULT_CHARSET'),
    (Value: 2; Name: 'SYMBOL_CHARSET'),
    (Value: 77; Name: 'MAC_CHARSET'),
    (Value: 128; Name: 'SHIFTJIS_CHARSET'),
    (Value: 129; Name: 'HANGEUL_CHARSET'),
    (Value: 130; Name: 'JOHAB_CHARSET'),
    (Value: 134; Name: 'GB2312_CHARSET'),
    (Value: 136; Name: 'CHINESEBIG5_CHARSET'),
    (Value: 161; Name: 'GREEK_CHARSET'),
    (Value: 162; Name: 'TURKISH_CHARSET'),
    (Value: 177; Name: 'HEBREW_CHARSET'),
    (Value: 178; Name: 'ARABIC_CHARSET'),
    (Value: 186; Name: 'BALTIC_CHARSET'),
    (Value: 204; Name: 'RUSSIAN_CHARSET'),
    (Value: 222; Name: 'THAI_CHARSET'),
    (Value: 238; Name: 'EASTEUROPE_CHARSET'),
    (Value: 255; Name: 'OEM_CHARSET'));

implementation


uses Consts,RTLConsts, ComStrs,UMain, UrbSubs;

type
  PIntArray = ^TIntArray;
  TIntArray = array[0..MaxCustomExtents] of Integer;

function DelChars(const S: string; Chr: Char): string;
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do begin
    if Result[I] = Chr then Delete(Result, I, 1);
  end;
end;

function GetClassParent(ATypeIn: TClass; AType: TClass):boolean;
var
  AncestorClass: TClass;
begin
//  AncestorClass := AClass.ClassType;
  AncestorClass := ATypeIn;
  while (AncestorClass <> AType) do
  begin
    if AncestorClass=nil then begin Result:=false; exit;end;
    AncestorClass := AncestorClass.ClassParent;
  end;
  result:=true;
end;

function GetParentNew(ct: TControl):TWinControl;
var
  Prn: TWinControl;
begin
  Prn:=ct.Parent;
  result:=Prn;
  if Prn<>nil then begin
   while Prn.Parent<>nil do begin
     Prn:=Prn.Parent;
     Result:=Prn;
     if Prn.Parent=nil then exit;
   end;
  end; 
end;

procedure InvalidOp(const id: string);
begin
  raise EInvalidGridOperation.Create(id);
end;

function IMin(A, B: Integer): Integer;
begin
  Result := B;
  if A < B then Result := A;
end;

function IMax(A, B: Integer): Integer;
begin
  Result := B;
  if A > B then Result := A;
end;

function GridRect(Coord1, Coord2: TGridCoord): TGridRect;
begin
  with Result do
  begin
    Left := Coord2.X;
    if Coord1.X < Coord2.X then Left := Coord1.X;
    Right := Coord1.X;
    if Coord1.X < Coord2.X then Right := Coord2.X;
    Top := Coord2.Y;
    if Coord1.Y < Coord2.Y then Top := Coord1.Y;
    Bottom := Coord1.Y;
    if Coord1.Y < Coord2.Y then Bottom := Coord2.Y;
  end;
end;


function PointInGridRect(Col, Row: Longint; const Rect: TGridRect): Boolean;
begin
  Result := (Col >= Rect.Left) and (Col <= Rect.Right) and (Row >= Rect.Top)
    and (Row <= Rect.Bottom);
end;

type
  TXorRects = array[0..3] of TRect;

procedure XorRects(const R1, R2: TRect; var XorRects: TXorRects);
var
  Intersect, Union: TRect;

  function PtInRect(X, Y: Integer; const Rect: TRect): Boolean;
  begin
    with Rect do Result := (X >= Left) and (X <= Right) and (Y >= Top) and
      (Y <= Bottom);
  end;

  function Includes(const P1: TPoint; var P2: TPoint): Boolean;
  begin
    with P1 do
    begin
      Result := PtInRect(X, Y, R1) or PtInRect(X, Y, R2);
      if Result then P2 := P1;
    end;
  end;

  function Build(var R: TRect; const P1, P2, P3: TPoint): Boolean;
  begin
    Build := True;
    with R do
      if Includes(P1, TopLeft) then
      begin
        if not Includes(P3, BottomRight) then BottomRight := P2;
      end
      else if Includes(P2, TopLeft) then BottomRight := P3
      else Build := False;
  end;

begin
  FillChar(XorRects, SizeOf(XorRects), 0);
  if not Bool(IntersectRect(Intersect, R1, R2)) then
  begin
    { Don't intersect so its simple }
    XorRects[0] := R1;
    XorRects[1] := R2;
  end
  else
  begin
    UnionRect(Union, R1, R2);
    if Build(XorRects[0],
      Point(Union.Left, Union.Top),
      Point(Union.Left, Intersect.Top),
      Point(Union.Left, Intersect.Bottom)) then
      XorRects[0].Right := Intersect.Left;
    if Build(XorRects[1],
      Point(Intersect.Left, Union.Top),
      Point(Intersect.Right, Union.Top),
      Point(Union.Right, Union.Top)) then
      XorRects[1].Bottom := Intersect.Top;
    if Build(XorRects[2],
      Point(Union.Right, Intersect.Top),
      Point(Union.Right, Intersect.Bottom),
      Point(Union.Right, Union.Bottom)) then
      XorRects[2].Left := Intersect.Right;
    if Build(XorRects[3],
      Point(Union.Left, Union.Bottom),
      Point(Intersect.Left, Union.Bottom),
      Point(Intersect.Right, Union.Bottom)) then
      XorRects[3].Top := Intersect.Bottom;
  end;
end;

procedure ModifyExtents(var Extents: Pointer; Index, Amount: Longint;
  Default: Integer);
var
  LongSize: LongInt;
  NewSize: Cardinal;
  OldSize: Cardinal;
  I: Cardinal;
begin
  if Amount <> 0 then
  begin
    if not Assigned(Extents) then OldSize := 0
    else OldSize := PIntArray(Extents)^[0];
    if (Index < 0) or (LongInt(OldSize) < Index) then InvalidOp(SIndexOutOfRange);
    LongSize := LongInt(OldSize) + Amount;
    if LongSize < 0 then InvalidOp(STooManyDeleted)
    else if LongSize >= MaxListSize - 1 then InvalidOp(SGridTooLarge);
    NewSize := Cardinal(LongSize);
    if NewSize > 0 then Inc(NewSize);
    ReallocMem(Extents, NewSize * SizeOf(Integer));
    if Assigned(Extents) then
    begin
      I := Index;
      while I < NewSize do
      begin
        PIntArray(Extents)^[I] := Default;
        Inc(I);
      end;
      PIntArray(Extents)^[0] := NewSize-1;
    end;
  end;
end;

procedure UpdateExtents(var Extents: Pointer; NewSize: Longint;
  Default: Integer);
var
  OldSize: Integer;
begin
  OldSize := 0;
  if Assigned(Extents) then OldSize := PIntArray(Extents)^[0];
  ModifyExtents(Extents, OldSize, NewSize - OldSize, Default);
end;

procedure MoveExtent(var Extents: Pointer; FromIndex, ToIndex: Longint);
var
  Extent: Integer;
begin
  if Assigned(Extents) then
  begin
    Extent := PIntArray(Extents)^[FromIndex];
    if FromIndex < ToIndex then
      Move(PIntArray(Extents)^[FromIndex + 1], PIntArray(Extents)^[FromIndex],
        (ToIndex - FromIndex) * SizeOf(Integer))
    else if FromIndex > ToIndex then
      Move(PIntArray(Extents)^[ToIndex], PIntArray(Extents)^[ToIndex + 1],
        (FromIndex - ToIndex) * SizeOf(Integer));
    PIntArray(Extents)^[ToIndex] := Extent;
  end;
end;

function CompareExtents(E1, E2: Pointer): Boolean;
var
  I: Integer;
begin
  Result := False;
  if E1 <> nil then
  begin
    if E2 <> nil then
    begin
      for I := 0 to PIntArray(E1)^[0] do
        if PIntArray(E1)^[I] <> PIntArray(E2)^[I] then Exit;
      Result := True;
    end
  end
  else Result := E2 = nil;
end;

function LongMulDiv(Mult1, Mult2, Div1: Longint): Longint; stdcall;
  external 'kernel32.dll' name 'MulDiv';

type
  TSelection = record
    StartPos, EndPos: Integer;
  end;

constructor TtsvInplaceEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ParentColor:=false;
  ParentFont:=False;
  ParentCTL3D:=false;
  CTL3D:=false;
  BorderStyle:=bsNone;
//  Color:=clBlack;
end;

destructor TtsvInplaceEdit.Destroy;
begin
  inherited Destroy;
end;

function TtsvInplaceEdit.EditCanModify: Boolean;
begin
  Result := Grid.CanEditModify;
end;

procedure TtsvInplaceEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE;
end;

procedure TtsvInplaceEdit.SetGrid(Value: TtsvCustomGrid);
begin
  FGrid := Value;
end;

procedure TtsvInplaceEdit.CMShowingChanged(var Message: TMessage);
begin
  { Ignore showing using the Visible property }
end;

procedure TtsvInplaceEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if goTabs in Grid.Options then
    Message.Result := Message.Result or DLGC_WANTTAB;
end;

procedure TtsvInplaceEdit.WMPaste(var Message);
begin
  if not EditCanModify then Exit;
  inherited
end;

procedure TtsvInplaceEdit.WMClear(var Message);
begin
  if not EditCanModify then Exit;
  FGrid.OldText:=text;
  inherited;
end;

procedure TtsvInplaceEdit.WMCut(var Message);
begin
  if not EditCanModify then Exit;
  FGrid.OldText:=text;
  inherited;
end;

procedure TtsvInplaceEdit.DblClick;
var
   i:integer;
   PTI:PTypeInfo;
   tmpG: TtsvStringGrid;
   PSG: PStructGrid;
begin
  with FGrid.FInspector do begin
     SetTypeProp;
     if Page.ActivePage=TSProp then tmpG:=GridP
     else tmpG:=GridE;
     PSG:=Pointer(tmpG.Objects[0,tmpG.Row]);
     PTI:=PSG.PTI;
     case tmpG.EditType of
          edList: begin
             if PTI=TypeInfo(TColor)then begin SetPropDialog(PTI);
             end else begin
              if List.Items.Count=0 then exit;
              if List.ItemIndex=List.items.Count-1 then List.ItemIndex:=-1;
              if (List.ItemIndex+1<List.items.Count-1)and(List.ItemIndex<>-1)then
                if List.Items.Strings[List.ItemIndex]=List.Items.Strings[List.ItemIndex+1]then
                  List.ItemIndex:=List.ItemIndex+1;
              i:=List.ItemIndex;
              inc(i);
              List.ItemIndex:=i;
              Self.Text:=List.Items.Strings[List.ItemIndex];
              tmpG.OldText:=Self.Text;
              UpdateTypeInfo;
             end;
          end;
          edPointer:begin
             if PTI=TypeInfo(TFont)then SetPropDialog(PTI);
             if PTI=TypeInfo(TBitmap)then SetPropDialog(PTI);
             if PTI=TypeInfo(TPicture)then SetPropDialog(PTI);
             if PTI=TypeInfo(TStrings)then SetPropDialog(PTI);
             if PTI=TypeInfo(TTypeLinks)then SetPropDialog(PTI);
          end;
          edPointerChange:begin
             If PTI=TypeInfo(TFileName)then  SetPropDialog(PTI);
             if PSG.PropName='Hint' then SetPropDialog(PTI);
             if PSG.PropName='LabelCaption' then SetPropDialog(PTI);
             if PSG.PropName='Caption' then SetPropDialog(PTI);
             if PSG.PropName='EditMask' then SetPropDialog(PTI);
             if PSG.PropName='Subs' then SetPropDialog(PTI);

          end;
     end;
  end;
end;

procedure TtsvInplaceEdit.KeyDown(var Key: Word; Shift: TShiftState);

  procedure SendToParent;
  begin
    Grid.KeyDown(Key, Shift);
    Key := 0;
  end;

  procedure ParentEvent;
  var
    GridKeyDown: TKeyEvent;
  begin
    GridKeyDown := Grid.OnKeyDown;
    if Assigned(GridKeyDown) then GridKeyDown(Grid, Key, Shift);
  end;

  function ForwardMovement: Boolean;
  begin
    Result := goAlwaysShowEditor in Grid.Options;
  end;

  function Ctrl: Boolean;
  begin
    Result := ssCtrl in Shift;
  end;

  function Selection: TSelection;
  begin
    SendMessage(Handle, EM_GETSEL, Longint(@Result.StartPos), Longint(@Result.EndPos));
  end;

  function RightSide: Boolean;
  begin
    with Selection do
      Result := ((StartPos = 0) or (EndPos = StartPos)) and
        (EndPos = GetTextLen);
   end;

  function LeftSide: Boolean;
  begin
    with Selection do
      Result := (StartPos = 0) and ((EndPos = 0) or (EndPos = GetTextLen));
  end;

var
 tmps: string;
 P:PStructGrid;
 tmpG:TtsvStringGrid;
begin
  case Key of
    VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT, VK_ESCAPE: SendToParent;
    VK_INSERT:
      if Shift = [] then SendToParent
      else if (Shift = [ssShift]) and not Grid.CanEditModify then Key := 0;
    VK_LEFT: ;//if ForwardMovement and (Ctrl or LeftSide) then SendToParent;
    VK_RIGHT: ;//if ForwardMovement and (Ctrl or RightSide) then SendToParent;
    VK_HOME: if ForwardMovement and (Ctrl or LeftSide) then SendToParent;
    VK_END: if ForwardMovement and (Ctrl or RightSide) then SendToParent;
    VK_F2:
      begin
        ParentEvent;
        if Key = VK_F2 then
        begin
          Deselect;
          Exit;
        end;
      end;
    VK_TAB: if not (ssAlt in Shift) then SendToParent;
    VK_RETURN: begin
      Self.SelectAll;
//      if PTypeInfo(FGrid.ClassN[FGrid.Row]).Kind<>tkSet then
      FGrid.FInspector.UpdateTypeInfo;
    end;
    VK_F3: begin
       if FGrid.FInspector.Page.ActivePage=FGrid.FInspector.TSProp then
        tmpG:=FGrid.FInspector.GridP
       else tmpG:=FGrid.FInspector.GridE;
       P:=Pointer(tmpG.Objects[0,tmpG.Row]);
       if P.Obj<>nil then
        tmps:='Name: '+P.PropName+#13+
              'RusName: '+P.RusName+#13+
              'Parent Object: '+TObject(P.Obj).ClassName+#13+
              'ClassName: '+p.PTI.Name
       else
        tmps:='Name: '+P.PropName+#13+
              'RusName: '+P.RusName+#13+
              'Parent Object: nil'+#13+
              'ClassName: '+p.PTI.Name;
       showmessage(tmps);
     end;

  end;
  if (Key = VK_DELETE) and not Grid.CanEditModify then Key := 0;
  if Key <> 0 then
  begin
    ParentEvent;
    inherited KeyDown(Key, Shift);
  end;
end;

procedure TtsvInplaceEdit.KeyPress(var Key: Char);
var
  Selection: TSelection;
begin
  Grid.KeyPress(Key);
  if (Key in [#32..#255]) and not Grid.CanEditAcceptKey(Key) then
  begin
    Key := #0;
    MessageBeep(0);
  end;
  case Key of
    #9, #27: Key := #0;
    #13:
      begin
        SendMessage(Handle, EM_GETSEL, Longint(@Selection.StartPos), Longint(@Selection.EndPos));
        if (Selection.StartPos = 0) and (Selection.EndPos = GetTextLen) then
          {Deselect} else
          SelectAll;
        Key := #0;
      end;
    ^H, ^V, ^X, #32..#255:
      if not Grid.CanEditModify then Key := #0;
  end;
  if Key <> #0 then inherited KeyPress(Key);
end;

procedure TtsvInplaceEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  Grid.KeyUp(Key, Shift);
end;

procedure TtsvInplaceEdit.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_SETFOCUS:
      begin
        if (GetParentForm(Self) = nil) or GetParentForm(Self).SetFocusedControl(Grid) then Dispatch(Message);
        Exit;
      end;
    WM_LBUTTONDOWN:
      begin
        if LongInt(GetMessageTime) - FClickTime < LongInt(GetDoubleClickTime) then
          Message.Msg := WM_LBUTTONDBLCLK;
        FClickTime := 0;
      end;
  end;
  inherited WndProc(Message);
end;

procedure TtsvInplaceEdit.Deselect;
begin
  SendMessage(Handle, EM_SETSEL, $7FFFFFFF, Longint($FFFFFFFF));
end;

procedure TtsvInplaceEdit.Invalidate;
var
  Cur: TRect;
begin
  ValidateRect(Handle, nil);
  InvalidateRect(Handle, nil, True);
  Windows.GetClientRect(Handle, Cur);
  MapWindowPoints(Handle, Grid.Handle, Cur, 2);
  ValidateRect(Grid.Handle, @Cur);
  InvalidateRect(Grid.Handle, @Cur, False);
end;

procedure TtsvInplaceEdit.Hide;
begin
  if HandleAllocated and IsWindowVisible(Handle) then
  begin
    Invalidate;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOZORDER or
      SWP_NOREDRAW);
    if Focused then Windows.SetFocus(Grid.Handle);
  end;
end;

function TtsvInplaceEdit.PosEqual(const Rect: TRect): Boolean;
var
  Cur: TRect;
begin
  GetWindowRect(Handle, Cur);
  MapWindowPoints(HWND_DESKTOP, Grid.Handle, Cur, 2);
  Result := EqualRect(Rect, Cur);
end;

procedure TtsvInplaceEdit.InternalMove(const Loc,RLoc: TRect; Redraw: Boolean);
begin
  if IsRectEmpty(Loc) then Hide
  else
  begin
    CreateHandle;
    Redraw := Redraw or not IsWindowVisible(Handle);
    Invalidate;
    with Loc do begin
      SetWindowPos(Handle, HWND_TOP, Left, Top, Right - Left , Bottom - Top,
        SWP_SHOWWINDOW or SWP_NOREDRAW);
    end;
    BoundsChanged;
    if Redraw then Invalidate;
    if Grid.Focused then
      Windows.SetFocus(Handle);
  end;
end;

procedure TtsvInplaceEdit.BoundsChanged;
var
  R: TRect;
begin
  R := Rect(2, 2, Width - 2, Height);
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@R));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TtsvInplaceEdit.UpdateLoc(const Loc,RLoc: TRect);
begin
  InternalMove(Loc,RLoc, False);
end;

function TtsvInplaceEdit.Visible: Boolean;
begin
  Result := IsWindowVisible(Handle);
end;

procedure TtsvInplaceEdit.Move(const Loc,RLoc: TRect);
begin
  InternalMove(Loc,RLoc, True);
end;

procedure TtsvInplaceEdit.SetFocus;
begin
  if IsWindowVisible(Handle) then
    Windows.SetFocus(Handle);
end;

procedure TtsvInplaceEdit.UpdateContents;
begin
  Text := '';
  EditMask := Grid.GetEditMask(Grid.Col, Grid.Row);
  Text := Grid.GetEditText(Grid.Col, Grid.Row);
  MaxLength := Grid.GetEditLimit;
end;

{ TtsvCustomGrid }

constructor TtsvCustomGrid.Create(AOwner: TComponent);
const
  GridStyle = [csCaptureMouse, csOpaque, csDoubleClicks];
begin
  if AOwner = nil then begin MessageDlg('AOwner is not nil',mtError,[mbOK],0);exit;end;
  inherited Create(AOwner);
  if NewStyleControls then
    ControlStyle := GridStyle else
    ControlStyle := GridStyle + [csFramed];
  FCanEditModify := True;
  FWidthDef:=45;
  FColCount := 5;
  FRowCount := 5;
  FFixedCols := 1;
  FFixedRows := 1;
  FDecButtonH:=1;
  FGridLineWidth := 1;
  FOptions := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine,
    goRangeSelect,goThumbTracking];
  DesignOptionsBoost := [goColSizing, goRowSizing];
  FFixedColor := clBtnFace;
  FScrollBars := ssBoth;
  FBorderStyle := bsSingle;
  FDefaultColWidth := 64;
  FDefaultRowHeight := 17;
  FDefaultDrawing := True;
  FSaveCellExtents := True;
  FEditorMode := False;
  Color := clWindow;
  ParentColor := False;
  TabStop := True;
  if AOwner<>nil then  Parent:=AOwner as TWinControl;
  SetBounds(Left, Top, FColCount * FDefaultColWidth,
    FRowCount * FDefaultRowHeight);
  Button:=TtsvButton.Create(Self);
  Button.parent:=Self;
  Button.Visible:=false;

  FBmpEdList:=TBitmap.Create;
  FBmpEdPointer:=TBitmap.Create;
  {$R gridbutton.res}
  FBmpEdList.LoadFromResourceName(HInstance,'EDLIST');
  FBmpEdPointer.LoadFromResourceName(HInstance,'EDPOINTER');
  Initialize;

end;

procedure TtsvCustomGrid.CreateWnd;
begin
  inherited CreateWnd;
  UpdateScrollBar;
end;

destructor TtsvCustomGrid.Destroy;
begin
  if PSTGD<>nil then
    Dispose(PStGd);
  FBmpEdList.Free;
  FBmpEdPointer.Free;
  Button.free;
  FInplaceEdit.Free;
  inherited Destroy;
  FreeMem(FColWidths);
  FreeMem(FRowHeights);
  FreeMem(FTabStops);
end;

procedure TtsvCustomGrid.ChangeCell(ACol,ARow: Longint);
var
   rt:TRect;
begin
     rt:=Cellrect(ACol,ARow);
      with Canvas do begin
//        Font.Color:=clActiveCaption;
         Font.Color:=clBlack;
         Font.Style:=[fsBold];
      end;
      DrawCell(ACol,ARow,rt,[]);
end;

procedure TtsvCustomGrid.UpdateScrollBar;
var
  SIOld, SINew: TScrollInfo;
begin

      SIOld.cbSize := sizeof(SIOld);
      SIOld.fMask := SIF_ALL;
      GetScrollInfo(Self.Handle, SB_VERT, SIOld);
      SINew := SIOld;
      SINew.nMin := 1;
      SINew.nPage := VisibleRowCount;
      SINew.nMax :=RowCount;
      if (SINew.nMin <> SIOld.nMin) or (SINew.nMax <> SIOld.nMax) or
        (SINew.nPage <> SIOld.nPage) or (SINew.nPos <> SIOld.nPos) then
        SetScrollInfo(Self.Handle, SB_VERT, SINew, True);
end;

procedure TtsvCustomGrid.SetPlace;
var
   rt:Trect;
   PTI:PTypeInfo;
   CTD:PTypeData;
   tmps:String;
   PSG:PStructGrid;
   tmpG: TTsvStringGrid;
begin
   if FInplaceEdit=nil then exit;
   if OldRow<>Row then begin
    InvalidateCell(0,OldRow);
    ChangeCell(0,Row);
   end;
   if Col=0 then Col:=ColCount-1;
   rt:=TRect(CellRect(Col, Row));
   if CanEditShow then begin

     with FInspector do begin
      if Page.ActivePage=TSProp then tmpG:=GridP
      else tmpG:=GridE;
     end;
     if (tmpg.RowCount=0)or(tmpg.Objects[0,Row]=nil)then exit;
     if FInspector.fmList.Visible then FInspector.fmList.Visible:=false;

      PSG:=Pointer(tmpg.Objects[0,Row]);
      if Trim(PSG.RusName)<>'' then begin
       FInspector.FCurHint:=PSG.RusName+': '+tmpg.Cells[1,Row];
      end else begin
       FInspector.FCurHint:=PSG.PropName+': '+tmpg.Cells[1,Row];
      end;
      if Assigned(FInspector.MemoInfo) then begin
        FInspector.MemoInfo.Clear;
        FInspector.MemoInfo.Lines.Text:=PSG.Info;
      end;  
      Hint:=FInspector.FCurHint;
      if PSG.PropName='PasswordChar' then begin
        tmps:='';
      end;
      PTI:=PSG.PTI;
      tmps:=PSG.PropName;
      case PTI.Kind of
       tkInteger,tkFloat,tkString,tkLString,tkWString,tkChar:begin
          FEditType:=edNormal;
          if PTI=TypeInfo(TColor)then FEditType:=edList;
          if PTI=TypeInfo(TCursor)then FEditType:=edList;
          if PTI=TypeInfo(TShortCut)then FEditType:=edList;
          If PTI=TypeInfo(TFontCharset) then FEditType:=edList;
          if PTI=TypeInfo(TFontName) then FEditType:=edList;
          if PTI=TypeInfo(String)then begin
             if (tmps='FileName')or(tmps='DefaultExt')then
                FEditType:=edPointerChange;
             if (tmps='Hint')then
                FEditType:=edPointerChange;
             if (tmps='LabelCaption')then
                FEditType:=edPointerChange;
             if (tmps='EditMask')then
                FEditType:=edPointerChange;
             if (tmps='Subs')then
                FEditType:=edPointerChange;
             if (tmps='WordStyle')then
                FEditType:=edList;
          end;
          if PTI=TypeInfo(TEditMask)then
            FEditType:=edPointerChange;
          if (tmps='Caption')then
                FEditType:=edPointerChange;

          //       FEditType:=edPointer;
//          if PTI=TypeInfo(TComponentName)then FIDName:=Row;
//          FInspector.Current:=FInspector.ValueObj;
       end;
       tkEnumeration: FEditType:=edList;
       tkClass:begin
            CTD:=GetTypeData(PTI);
            if GetClassParent(CTD.ClassType,TPersistent)then FEditType:=edPointer;
            if GetClassParent(CTD.ClassType,TCollection)then FEditType:=edPointer;
            if GetClassParent(CTD.ClassType,TMenu)then FEditType:=edList;
            if GetClassParent(CTD.ClassType,TWinControl)then FEditType:=edList;
            if GetClassParent(CTD.ClassType,TComponent)then FEditType:=edList;
            if PTI=TypeInfo(TmenuItem)then FEditType:=edPointer;
            if GetClassParent(CTD.ClassType,TList)then FEditType:=edPointer;
            if PTI.Name='TTPDLinks' then FEditType:=edPointer;
            if PTI=TypeInfo(TDateTimeColors)then FEditType:=edNormalSet;
            if PTI.Name='TTPDStateColors' then FEditType:=edNormalSet;
            if PTI.Name='TCriticalValues' then FEditType:=edNormalSet;
            if PTI=TypeInfo(TBrush)then FEditType:=edNormalSet;
            if PTI=TypeInfo(TPen)then FEditType:=edNormalSet;
            if PTI=TypeInfo(TControlScrollBar)then FEditType:=edNormalSet;
            if PTI=TypeInfo(TLabelState)then FEditType:=edNormalSet;
            if PTI=TypeInfo(TSizeConstraints)then FEditType:=edNormalSet;
            if PTI=TypeInfo(TMonthCalColors) then FEditType:=edNormalSet;

       end;
       tkSet: FEditType:=edNormalSet;
       tkMethod: FEditType:=edList;
      end;
      rt.Left:=rt.Left;
      rt.Top:=rt.Top+1;
      rt.Right:=rt.Right;
      rt.Bottom:=rt.Top+FDefaultRowHeight;
      case FEditType of
         edNormal:SetNormal(rt);
         edPointer:SetPointer(rt);
         edList:SetList(rt);
         edNormalSet:SetNormalSet(rt);
         edPointerChange:SetPointerChange(rt);
      end;
   end;
end;

procedure TtsvCustomGrid.SetInspector(Value: TtsvPnlInspector);
begin
   FInspector:=Value;
end;

procedure TtsvCustomGrid.SetNormal(rect:Trect);
begin
   Button.Visible:=false;
   FInplaceEdit.ReadOnly:=false;
   FInplaceEdit.Move(rect,rect);
   FOldText:=FInplaceEdit.Text;
end;

procedure TtsvCustomGrid.SetNormalSet(rect:Trect);
begin
   Button.Visible:=false;
   FInplaceEdit.ReadOnly:=true;
   FInplaceEdit.Move(rect,rect);
   FOldText:=FInplaceEdit.Text;
end;

procedure TtsvCustomGrid.SetPointer(rect:Trect);
begin
   FInplaceEdit.ReadOnly:=true;
   Button.Glyph.Assign(FBmpEdPointer);
   Button.Height:=FDefaultRowHeight-FDecButtonH;
   Button.Width:=Button.Height;
   rect.Right:=rect.Right-Button.Width;
   Button.Left:=rect.Right;
   Button.top:=rect.top;
   Button.Visible:=true;
   FInplaceEdit.Move(rect,rect);
   FOldText:=FInplaceEdit.Text;
end;

procedure TtsvCustomGrid.SetPointerChange(rect:Trect);
begin
   FInplaceEdit.ReadOnly:=false;
   Button.Glyph.Assign(FBmpEdPointer);
   Button.Height:=FDefaultRowHeight-FDecButtonH;
   Button.Width:=Button.Height;
   rect.Right:=rect.Right-Button.Width;
   Button.Left:=rect.Right;
   Button.top:=rect.top;
   Button.Visible:=true;
   FInplaceEdit.Move(rect,rect);
   FOldText:=FInplaceEdit.Text;
end;

procedure TtsvCustomGrid.SetList(rect:Trect);
begin
   FInplaceEdit.ReadOnly:=false;
   Button.Glyph.Assign(FBmpEdList);
   Button.Height:=FDefaultRowHeight-FDecButtonH;
   Button.Width:=Button.Height;
   rect.Right:=rect.Right-Button.Width;
   Button.Left:=rect.Right;
   Button.top:=rect.top;
   Button.Visible:=true;
   FInplaceEdit.Move(rect,rect);
   FOldText:=FInplaceEdit.Text;
end;

procedure TtsvCustomGrid.AdjustSize(Index, Amount: Longint; Rows: Boolean);
var
  NewCur: TGridCoord;
  OldRows, OldCols: Longint;
  MovementX, MovementY: Longint;
  MoveRect: TGridRect;
  ScrollArea: TRect;
  AbsAmount: Longint;

  function DoSizeAdjust(var Count: Longint; var Extents: Pointer;
    DefaultExtent: Integer; var Current: Longint): Longint;
  var
    I: Integer;
    NewCount: Longint;
  begin
    NewCount := Count + Amount;
    if NewCount < Index then InvalidOp(STooManyDeleted);
    if (Amount < 0) and Assigned(Extents) then
    begin
      Result := 0;
      for I := Index to Index - Amount - 1 do
        Inc(Result, PIntArray(Extents)^[I]);
    end
    else
      Result := Amount * DefaultExtent;
    if Extents <> nil then
      ModifyExtents(Extents, Index, Amount, DefaultExtent);
    Count := NewCount;
    if Current >= Index then
      if (Amount < 0) and (Current < Index - Amount) then Current := Index
      else Inc(Current, Amount);
  end;

begin
  if Amount = 0 then Exit;
  NewCur := FCurrent;
  OldCols := ColCount;
  OldRows := RowCount;
  MoveRect.Left := FixedCols;
  MoveRect.Right := ColCount - 1;
  MoveRect.Top := FixedRows;
  MoveRect.Bottom := RowCount - 1;
  MovementX := 0;
  MovementY := 0;
  AbsAmount := Amount;
  if AbsAmount < 0 then AbsAmount := -AbsAmount;
  if Rows then
  begin
    MovementY := DoSizeAdjust(FRowCount, FRowHeights, DefaultRowHeight, NewCur.Y);
    MoveRect.Top := Index;
    if Index + AbsAmount <= TopRow then MoveRect.Bottom := TopRow - 1;
  end
  else
  begin
    MovementX := DoSizeAdjust(FColCount, FColWidths, DefaultColWidth, NewCur.X);
    MoveRect.Left := Index;
    if Index + AbsAmount <= LeftCol then MoveRect.Right := LeftCol - 1;
  end;
  GridRectToScreenRect(MoveRect, ScrollArea, True);
  if not IsRectEmpty(ScrollArea) then
  begin
    ScrollWindow(Handle, MovementX, MovementY, @ScrollArea, @ScrollArea);
    UpdateWindow(Handle);
  end;
  SizeChanged(OldCols, OldRows);
  if (NewCur.X <> FCurrent.X) or (NewCur.Y <> FCurrent.Y) then
    MoveCurrent(NewCur.X, NewCur.Y, True, True);
end;

function TtsvCustomGrid.BoxRect(ALeft, ATop, ARight, ABottom: Longint): TRect;
var
  GridRect: TGridRect;
begin
  GridRect.Left := ALeft;
  GridRect.Right := ARight;
  GridRect.Top := ATop;
  GridRect.Bottom := ABottom;
  GridRectToScreenRect(GridRect, Result, False);
end;

procedure TtsvCustomGrid.DoExit;
begin
  inherited DoExit;
  if not (goAlwaysShowEditor in Options) then HideEditor;
end;

function TtsvCustomGrid.CellRect(ACol, ARow: Longint): TRect;
begin
  Result := BoxRect(ACol, ARow, ACol, ARow);
end;

function TtsvCustomGrid.CanEditAcceptKey(Key: Char): Boolean;
begin
  Result := True;
end;

function TtsvCustomGrid.CanGridAcceptKey(Key: Word; Shift: TShiftState): Boolean;
begin
  Result := True;
end;

function TtsvCustomGrid.CanEditModify: Boolean;
begin
  Result := FCanEditModify;
end;

function TtsvCustomGrid.CanEditShow: Boolean;
begin
  Result := ([goRowSelect, goEditing] * Options = [goEditing]) and
    FEditorMode and not (csDesigning in ComponentState) and HandleAllocated and
    ((goAlwaysShowEditor in Options) or IsActiveControl);
end;

function TtsvCustomGrid.IsActiveControl: Boolean;
var
  H: Hwnd;
  ParentForm: TCustomForm;
begin
  Result := False;
  ParentForm := GetParentForm(Self);
  if Assigned(ParentForm) then
  begin
    if (ParentForm.ActiveControl = Self) then
      Result := True
  end
  else
  begin
    H := GetFocus;
    while IsWindow(H) and (Result = False) do
    begin
      if H = WindowHandle then
        Result := True
      else
        H := GetParent(H);
    end;
  end;
end;

function TtsvCustomGrid.GetEditMask(ACol, ARow: Longint): string;
begin
  Result := '';
end;

function TtsvCustomGrid.GetEditText(ACol, ARow: Longint): string;
begin
  Result := '';
end;

procedure TtsvCustomGrid.SetEditText(ACol, ARow: Longint; const Value: string);
begin
end;

function TtsvCustomGrid.GetEditLimit: Integer;
begin
  Result := 0;
end;

procedure TtsvCustomGrid.HideEditor;
begin
  FEditorMode := False;
  HideEdit;
end;

procedure TtsvCustomGrid.ShowEditor;
begin
  FEditorMode := True;
  UpdateEdit;
end;

procedure TtsvCustomGrid.ShowEditorChar(Ch: Char);
begin
  ShowEditor;
  if FInplaceEdit <> nil then
    PostMessage(FInplaceEdit.Handle, WM_CHAR, Word(Ch), 0);
end;

procedure TtsvCustomGrid.InvalidateEditor;
begin
  FInplaceCol := -1;
  FInplaceRow := -1;
  UpdateEdit;
end;

procedure TtsvCustomGrid.ReadColWidths(Reader: TReader);
var
  I: Integer;
begin
  with Reader do
  begin
    ReadListBegin;
    for I := 0 to ColCount - 1 do ColWidths[I] := ReadInteger;
    ReadListEnd;
  end;
end;

procedure TtsvCustomGrid.ReadRowHeights(Reader: TReader);
var
  I: Integer;
begin
  with Reader do
  begin
    ReadListBegin;
    for I := 0 to RowCount - 1 do RowHeights[I] := ReadInteger;
    ReadListEnd;
  end;
end;

procedure TtsvCustomGrid.WriteColWidths(Writer: TWriter);
var
  I: Integer;
begin
  with Writer do
  begin
    WriteListBegin;
    for I := 0 to ColCount - 1 do WriteInteger(ColWidths[I]);
    WriteListEnd;
  end;
end;

procedure TtsvCustomGrid.WriteRowHeights(Writer: TWriter);
var
  I: Integer;
begin
  with Writer do
  begin
    WriteListBegin;
    for I := 0 to RowCount - 1 do WriteInteger(RowHeights[I]);
    WriteListEnd;
  end;
end;

procedure TtsvCustomGrid.DefineProperties(Filer: TFiler);

  function DoColWidths: Boolean;
  begin
    if Filer.Ancestor <> nil then
      Result := not CompareExtents(TtsvCustomGrid(Filer.Ancestor).FColWidths, FColWidths)
    else
      Result := FColWidths <> nil;
  end;

  function DoRowHeights: Boolean;
  begin
    if Filer.Ancestor <> nil then
      Result := not CompareExtents(TtsvCustomGrid(Filer.Ancestor).FRowHeights, FRowHeights)
    else
      Result := FRowHeights <> nil;
  end;


begin
  inherited DefineProperties(Filer);
  if FSaveCellExtents then
    with Filer do
    begin
      DefineProperty('ColWidths', ReadColWidths, WriteColWidths, DoColWidths);
      DefineProperty('RowHeights', ReadRowHeights, WriteRowHeights, DoRowHeights);
    end;
end;

procedure TtsvCustomGrid.MoveColumn(FromIndex, ToIndex: Longint);
var
  Rect: TGridRect;
begin
  if FromIndex = ToIndex then Exit;
  if Assigned(FColWidths) then
  begin
    MoveExtent(FColWidths, FromIndex + 1, ToIndex + 1);
    MoveExtent(FTabStops, FromIndex + 1, ToIndex + 1);
  end;
  MoveAdjust(FCurrent.X, FromIndex, ToIndex);
  MoveAdjust(FAnchor.X, FromIndex, ToIndex);
  MoveAdjust(FInplaceCol, FromIndex, ToIndex);
  Rect.Top := 0;
  Rect.Bottom := VisibleRowCount;
  if FromIndex < ToIndex then
  begin
    Rect.Left := FromIndex;
    Rect.Right := ToIndex;
  end
  else
  begin
    Rect.Left := ToIndex;
    Rect.Right := FromIndex;
  end;
  InvalidateRect(Rect);
  ColumnMoved(FromIndex, ToIndex);
  if Assigned(FColWidths) then
    ColWidthsChanged;
  UpdateEdit;
end;

procedure TtsvCustomGrid.ColumnMoved(FromIndex, ToIndex: Longint);
begin
end;

procedure TtsvCustomGrid.MoveRow(FromIndex, ToIndex: Longint);
begin
  if Assigned(FRowHeights) then
    MoveExtent(FRowHeights, FromIndex + 1, ToIndex + 1);
  MoveAdjust(FCurrent.Y, FromIndex, ToIndex);
  MoveAdjust(FAnchor.Y, FromIndex, ToIndex);
  MoveAdjust(FInplaceRow, FromIndex, ToIndex);
  RowMoved(FromIndex, ToIndex);
  if Assigned(FRowHeights) then
    RowHeightsChanged;
  UpdateEdit;
end;

procedure TtsvCustomGrid.RowMoved(FromIndex, ToIndex: Longint);
begin
end;

function TtsvCustomGrid.MouseCoord(X, Y: Integer): TGridCoord;
var
  DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  Result := CalcCoordFromPoint(X, Y, DrawInfo);
  if Result.X < 0 then Result.Y := -1
  else if Result.Y < 0 then Result.X := -1;
end;

procedure TtsvCustomGrid.MoveColRow(ACol, ARow: Longint; MoveAnchor,
  Show: Boolean);
begin
  MoveCurrent(ACol, ARow, MoveAnchor, Show);
end;

function TtsvCustomGrid.SelectCell(ACol, ARow: Longint): Boolean;
begin
  Result := True;
end;

procedure TtsvCustomGrid.SizeChanged(OldColCount, OldRowCount: Longint);
begin
end;

function TtsvCustomGrid.Sizing(X, Y: Integer): Boolean;
var
  DrawInfo: TGridDrawInfo;
  State: TGridState;
  Index: Longint;
  Pos, Ofs: Integer;
begin
  State := FGridState;
  if State = gsNormal then
  begin
    CalcDrawInfo(DrawInfo);
    CalcSizingState(X, Y, State, Index, Pos, Ofs, DrawInfo);
  end;
  Result := State <> gsNormal;
end;

procedure TtsvCustomGrid.TopLeftChanged;
begin
  if FEditorMode and (FInplaceEdit <> nil) then setPlace;
//  FInplaceEdit.UpdateLoc(CellRect(Col, Row),CellRect(0, Row));
end;

procedure FillDWord(var Dest; Count, Value: Integer); register;
asm
  XCHG  EDX, ECX
  PUSH  EDI
  MOV   EDI, EAX
  MOV   EAX, EDX
  REP   STOSD
  POP   EDI
end;

{ StackAlloc allocates a 'small' block of memory from the stack by
  decrementing SP.  This provides the allocation speed of a local variable,
  but the runtime size flexibility of heap allocated memory.  }
function StackAlloc(Size: Integer): Pointer; register;
asm
  POP   ECX          { return address }
  MOV   EDX, ESP
  ADD   EAX, 3
  AND   EAX, not 3   // round up to keep ESP dword aligned
  CMP   EAX, 4092
  JLE   @@2
@@1:
  SUB   ESP, 4092
  PUSH  EAX          { make sure we touch guard page, to grow stack }
  SUB   EAX, 4096
  JNS   @@1
  ADD   EAX, 4096
@@2:
  SUB   ESP, EAX
  MOV   EAX, ESP     { function result = low memory address of block }
  PUSH  EDX          { save original SP, for cleanup }
  MOV   EDX, ESP
  SUB   EDX, 4
  PUSH  EDX          { save current SP, for sanity check  (sp = [sp]) }
  PUSH  ECX          { return to caller }
end;

{ StackFree pops the memory allocated by StackAlloc off the stack.
- Calling StackFree is optional - SP will be restored when the calling routine
  exits, but it's a good idea to free the stack allocated memory ASAP anyway.
- StackFree must be called in the same stack context as StackAlloc - not in
  a subroutine or finally block.
- Multiple StackFree calls must occur in reverse order of their corresponding
  StackAlloc calls.
- Built-in sanity checks guarantee that an improper call to StackFree will not
  corrupt the stack. Worst case is that the stack block is not released until
  the calling routine exits. }
procedure StackFree(P: Pointer); register;
asm
  POP   ECX                     { return address }
  MOV   EDX, DWORD PTR [ESP]
  SUB   EAX, 8
  CMP   EDX, ESP                { sanity check #1 (SP = [SP]) }
  JNE   @@1
  CMP   EDX, EAX                { sanity check #2 (P = this stack block) }
  JNE   @@1
  MOV   ESP, DWORD PTR [ESP+4]  { restore previous SP  }
@@1:
  PUSH  ECX                     { return to caller }
end;

procedure TtsvCustomGrid.Paint;
var
  LineColor: TColor;
  DrawInfo: TGridDrawInfo;
  Sel: TGridRect;
  UpdateRect: TRect;
  FocRect: TRect;
  PointsList: PIntArray;
  StrokeList: PIntArray;
  MaxStroke: Integer;
  FrameFlags1, FrameFlags2: DWORD;

  procedure DrawLines(DoHorz, DoVert: Boolean; Col, Row: Longint;
    const CellBounds: array of Integer; OnColor, OffColor: TColor);

  { Cellbounds is 4 integers: StartX, StartY, StopX, StopY
    Horizontal lines:  MajorIndex = 0
    Vertical lines:    MajorIndex = 1 }

  const
    FlatPenStyle = PS_Geometric or PS_Solid or PS_EndCap_Flat or PS_Join_Miter;

    procedure DrawAxisLines(const AxisInfo: TGridAxisDrawInfo;
      Cell, MajorIndex: Integer; UseOnColor: Boolean);
    var
      Line: Integer;
      LogBrush: TLOGBRUSH;
      Index: Integer;
      Points: PIntArray;
      StopMajor, StartMinor, StopMinor: Integer;
    begin
      with Canvas, AxisInfo do
      begin
        if EffectiveLineWidth <> 0 then
        begin
          Pen.Width := GridLineWidth;
          if UseOnColor then
            Pen.Color := OnColor
          else
            Pen.Color := OffColor;
          if Pen.Width > 1 then
          begin

            LogBrush.lbStyle := BS_Solid;
            LogBrush.lbColor := Pen.Color;
            LogBrush.lbHatch := 0;
            Pen.Handle := ExtCreatePen(FlatPenStyle, Pen.Width, LogBrush, 0, nil);
          end;
          Points := PointsList;
          Line := CellBounds[MajorIndex] + EffectiveLineWidth shr 1 +
            GetExtent(Cell);
          StartMinor := CellBounds[MajorIndex xor 1];
          StopMinor := CellBounds[2 + (MajorIndex xor 1)];
          StopMajor := CellBounds[2 + MajorIndex] + EffectiveLineWidth;
          Index := 0;
          repeat
            Points^[Index + MajorIndex] := Line;         { MoveTo }
            Points^[Index + (MajorIndex xor 1)] := StartMinor;
            Inc(Index, 2);
            Points^[Index + MajorIndex] := Line;         { LineTo }
            Points^[Index + (MajorIndex xor 1)] := StopMinor;
            Inc(Index, 2);
            Inc(Cell);
            Inc(Line, GetExtent(Cell) + EffectiveLineWidth);
          until Line > StopMajor;
           { 2 integers per point, 2 points per line -> Index div 4 }
          PolyPolyLine(Canvas.Handle, Points^, StrokeList^, Index shr 2);
        end;
      end;
    end;

  begin
    if (CellBounds[0] = CellBounds[2]) or (CellBounds[1] = CellBounds[3]) then Exit;
    if not DoHorz then
    begin
      DrawAxisLines(DrawInfo.Vert, Row, 1, DoHorz);
      DrawAxisLines(DrawInfo.Horz, Col, 0, DoVert);
    end
    else
    begin
      DrawAxisLines(DrawInfo.Horz, Col, 0, DoVert);
      DrawAxisLines(DrawInfo.Vert, Row, 1, DoHorz);
    end;
  end;

  procedure DrawCells(ACol, ARow: Longint; StartX, StartY, StopX, StopY: Integer;
    Color: TColor; IncludeDrawState: TGridDrawState);
  var
    CurCol, CurRow: Longint;
    Where, TempRect: TRect;
    DrawState: TGridDrawState;
    Focused: Boolean;
  begin
    CurRow := ARow;
    Where.Top := StartY;
    while (Where.Top < StopY) and (CurRow < RowCount) do
    begin
      CurCol := ACol;
      Where.Left := StartX;
      Where.Bottom := Where.Top + RowHeights[CurRow];
      while (Where.Left < StopX) and (CurCol < ColCount) do
      begin
        Where.Right := Where.Left + ColWidths[CurCol];
        if RectVisible(Canvas.Handle, Where) then
        begin
          DrawState := IncludeDrawState;
          Focused := IsActiveControl;
          if Focused and (CurRow = Row) and (CurCol = Col)  then
            Include(DrawState, gdFocused);
          if PointInGridRect(CurCol, CurRow, Sel) then
            Include(DrawState, gdSelected);
          if not (gdFocused in DrawState) or not (goEditing in Options) or
            not FEditorMode or (csDesigning in ComponentState) then
          begin
            if DefaultDrawing or (csDesigning in ComponentState) then begin
              with Canvas do
              begin
                Font := Self.Font;
                if (gdSelected in DrawState) and
                  (not (gdFocused in DrawState) or
                  ([goDrawFocusSelected, goRowSelect] * Options <> [])) then
                begin
                  Brush.Color := clHighlight;
                  Font.Color := clHighlightText;
                end
                else begin
                  Brush.Color := Color;
                end;
                //FillRect(Where);
                DrawCell(CurCol, CurRow, Where, DrawState);
              end;
            end;
            if DefaultDrawing and (gdFixed in DrawState) and Ctl3D and
              ((FrameFlags1 or FrameFlags2) <> 0) then
            begin
              TempRect := Where;
              if (FrameFlags1 and BF_RIGHT) = 0 then
                Inc(TempRect.Right, DrawInfo.Horz.EffectiveLineWidth)
              else if (FrameFlags1 and BF_BOTTOM) = 0 then
                Inc(TempRect.Bottom, DrawInfo.Vert.EffectiveLineWidth);
              DrawEdge(Canvas.Handle, TempRect, BDR_SUNKENOUTER, BF_RIGHT);
 //             DrawEdge(Canvas.Handle, TempRect, EDGE_ETCHED, FrameFlags2);
            end;
            if DefaultDrawing and not (csDesigning in ComponentState) and
              (gdFocused in DrawState) and
              ([goEditing, goAlwaysShowEditor] * Options <>
              [goEditing, goAlwaysShowEditor])
              and not (goRowSelect in Options) then
              DrawFocusRect(Canvas.Handle, Where);
          end;
        end;
        Where.Left := Where.Right + DrawInfo.Horz.EffectiveLineWidth;
        Inc(CurCol);
      end;
      Where.Top := Where.Bottom + DrawInfo.Vert.EffectiveLineWidth;
      Inc(CurRow);
    end;
  end;

begin
  UpdateRect := Canvas.ClipRect;
  CalcDrawInfo(DrawInfo);
  with DrawInfo do
  begin
    if (Horz.EffectiveLineWidth > 0) or (Vert.EffectiveLineWidth > 0) then
    begin
      { Draw the grid line in the four areas (fixed, fixed), (variable, fixed),
        (fixed, variable) and (variable, variable) }
      LineColor := clSilver;
      MaxStroke := IMax(Horz.LastFullVisibleCell - LeftCol + FixedCols,
                        Vert.LastFullVisibleCell - TopRow + FixedRows) + 3;
      PointsList := StackAlloc(MaxStroke * sizeof(TPoint) * 2);
      StrokeList := StackAlloc(MaxStroke * sizeof(Integer));
      FillDWord(StrokeList^, MaxStroke, 2);

      if ColorToRGB(Color) = clSilver then LineColor := clGray;
      DrawLines(goFixedHorzLine in Options, goFixedVertLine in Options,
        0, 0, [0, 0, Horz.FixedBoundary, Vert.FixedBoundary], LineColor, FixedColor);
      DrawLines(goFixedHorzLine in Options, goFixedVertLine in Options,
        LeftCol, 0, [Horz.FixedBoundary, 0, Horz.GridBoundary,
        Vert.FixedBoundary], LineColor, FixedColor);

    if FRowCount<>0 then begin
      DrawLines(goFixedHorzLine in Options, goFixedVertLine in Options,
        0, TopRow, [0, Vert.FixedBoundary, Horz.FixedBoundary,
        Vert.GridBoundary], LineColor, FixedColor);
      DrawLines(goHorzLine in Options, goVertLine in Options, LeftCol,
        TopRow, [Horz.FixedBoundary, Vert.FixedBoundary, Horz.GridBoundary,
        Vert.GridBoundary], LineColor, Color);
     end else begin
        FInplaceEdit.Hide;
        Button.Visible:=false;
     end;

      StackFree(StrokeList);
      StackFree(PointsList);
    end;

    { Draw the cells in the four areas }
    Sel := Selection;
    FrameFlags1 := 0;
    FrameFlags2 := 0;
    if goFixedVertLine in Options then
    begin
      FrameFlags1 := BF_RIGHT;
      FrameFlags2 := BF_LEFT;
    end;
    if goFixedHorzLine in Options then
    begin
      FrameFlags1 := FrameFlags1 or BF_BOTTOM;
      FrameFlags2 := FrameFlags2 or BF_TOP;
    end;
    DrawCells(0, 0, 0, 0, Horz.FixedBoundary, Vert.FixedBoundary, FixedColor,
      [gdFixed]);
    DrawCells(LeftCol, 0, Horz.FixedBoundary - FColOffset, 0, Horz.GridBoundary,  //!! clip
      Vert.FixedBoundary, FixedColor, [gdFixed]);
   if FRowCount<>0 then begin
    if TopRow<0 then TopRow:=0;
    DrawCells(0, TopRow, 0, Vert.FixedBoundary, Horz.FixedBoundary,
      Vert.GridBoundary, FixedColor, [gdFixed]);
    DrawCells(LeftCol, TopRow, Horz.FixedBoundary - FColOffset,                   //!! clip
      Vert.FixedBoundary, Horz.GridBoundary, Vert.GridBoundary, Color, []);
    end else begin
      FInplaceEdit.Hide;
      Button.Visible:=false;
    end;

    if not (csDesigning in ComponentState) and
      (goRowSelect in Options) and DefaultDrawing and Focused then
    begin
      GridRectToScreenRect(GetSelection, FocRect, False);
      Canvas.DrawFocusRect(FocRect);
    end;

    { Fill in area not occupied by cells }
    if Horz.GridBoundary < Horz.GridExtent then
    begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(Rect(Horz.GridBoundary, 0, Horz.GridExtent, Vert.GridBoundary));
    end;
    if Vert.GridBoundary < Vert.GridExtent then
    begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(Rect(0, Vert.GridBoundary, Horz.GridExtent, Vert.GridExtent));
    end;
  end;
end;

function TtsvCustomGrid.CalcCoordFromPoint(X, Y: Integer;
  const DrawInfo: TGridDrawInfo): TGridCoord;

  function DoCalc(const AxisInfo: TGridAxisDrawInfo; N: Integer): Integer;
  var
    I, Start, Stop: Longint;
    Line: Integer;
  begin
    with AxisInfo do
    begin
      if N < FixedBoundary then
      begin
        Start := 0;
        Stop :=  FixedCellCount - 1;
        Line := 0;
      end
      else
      begin
        Start := FirstGridCell;
        Stop := GridCellCount - 1;
        Line := FixedBoundary;
      end;
      Result := -1;
      for I := Start to Stop do
      begin
        Inc(Line, GetExtent(I) + EffectiveLineWidth);
        if N < Line then
        begin
          Result := I;
          Exit;
        end;
      end;
    end;
  end;

begin
  Result.X := DoCalc(DrawInfo.Horz, X);
  Result.Y := DoCalc(DrawInfo.Vert, Y);
end;

procedure TtsvCustomGrid.CalcDrawInfo(var DrawInfo: TGridDrawInfo);
begin
  CalcDrawInfoXY(DrawInfo, ClientWidth, ClientHeight);
end;

procedure TtsvCustomGrid.CalcDrawInfoXY(var DrawInfo: TGridDrawInfo;
  UseWidth, UseHeight: Integer);

  procedure CalcAxis(var AxisInfo: TGridAxisDrawInfo; UseExtent: Integer);
  var
    I: Integer;
  begin
    with AxisInfo do
    begin
      GridExtent := UseExtent;
      GridBoundary := FixedBoundary;
      FullVisBoundary := FixedBoundary;
      LastFullVisibleCell := FirstGridCell;
      for I := FirstGridCell to GridCellCount - 1 do
      begin
        Inc(GridBoundary, GetExtent(I) + EffectiveLineWidth);
        if GridBoundary > GridExtent + EffectiveLineWidth then
        begin
          GridBoundary := GridExtent;
          Break;
        end;
        LastFullVisibleCell := I;
        FullVisBoundary := GridBoundary;
      end;
    end;
  end;

begin
  CalcFixedInfo(DrawInfo);
  CalcAxis(DrawInfo.Horz, UseWidth);
  CalcAxis(DrawInfo.Vert, UseHeight);
end;

procedure TtsvCustomGrid.CalcFixedInfo(var DrawInfo: TGridDrawInfo);

  procedure CalcFixedAxis(var Axis: TGridAxisDrawInfo; LineOptions: TGridOptions;
    FixedCount, FirstCell, CellCount: Integer; GetExtentFunc: TGetExtentsFunc);
  var
    I: Integer;
  begin
    with Axis do
    begin
      if LineOptions * Options = [] then
        EffectiveLineWidth := 0
      else
        EffectiveLineWidth := GridLineWidth;

      FixedBoundary := 0;
      for I := 0 to FixedCount - 1 do
        Inc(FixedBoundary, GetExtentFunc(I) + EffectiveLineWidth);

      FixedCellCount := FixedCount;
      FirstGridCell := FirstCell;
      GridCellCount := CellCount;
      GetExtent := GetExtentFunc;
    end;
  end;

begin
  CalcFixedAxis(DrawInfo.Horz, [goFixedVertLine, goVertLine], FixedCols,
    LeftCol, ColCount, GetColWidths);
  CalcFixedAxis(DrawInfo.Vert, [goFixedHorzLine, goHorzLine], FixedRows,
    TopRow, RowCount, GetRowHeights);
end;

{ Calculates the TopLeft that will put the given Coord in view }
function TtsvCustomGrid.CalcMaxTopLeft(const Coord: TGridCoord;
  const DrawInfo: TGridDrawInfo): TGridCoord;

  function CalcMaxCell(const Axis: TGridAxisDrawInfo; Start: Integer): Integer;
  var
    Line: Integer;
    I: Longint;
  begin
    Result := Start;
    with Axis do
    begin
      Line := GridExtent + EffectiveLineWidth;
      for I := Start downto FixedCellCount do
      begin
        Dec(Line, GetExtent(I));
        Dec(Line, EffectiveLineWidth);
        if Line < FixedBoundary then Break;
        Result := I;
      end;
    end;
  end;

begin
  Result.X := CalcMaxCell(DrawInfo.Horz, Coord.X);
  Result.Y := CalcMaxCell(DrawInfo.Vert, Coord.Y);
end;

procedure TtsvCustomGrid.CalcSizingState(X, Y: Integer; var State: TGridState;
  var Index: Longint; var SizingPos, SizingOfs: Integer;
  var FixedInfo: TGridDrawInfo);

  procedure CalcAxisState(const AxisInfo: TGridAxisDrawInfo; Pos: Integer;
    NewState: TGridState);
  var
    I, Line, Back, Range: Integer;
  begin
    with AxisInfo do
    begin
//      Line:=FixedBoundary;
      Line:=0;
      Range := EffectiveLineWidth;
      Back := 0;
      if Range < 7 then
      begin
        Range := 7;
        Back := (Range - EffectiveLineWidth) shr 1;
      end;
      for I := FirstGridCell-1 to GridCellCount - 1 do
      begin
        Inc(Line, GetExtent(I));
        if Line > GridBoundary then Break;
        if (Pos >= Line - Back) and (Pos <= Line - Back + Range) then
        begin
          State := NewState;
           SizingPos := Pos;
          if  (Pos >= FixedBoundary - Back) and (Pos <= FixedBoundary - Back + Range) then begin
           SizingOfs := Pos;
          end else begin
           SizingOfs := Line - Pos;
          end;
          Index := I;
          Exit;
        end;
        Inc(Line, EffectiveLineWidth);
      end;
      if (GridBoundary = GridExtent) and (Pos >= GridExtent - Back)
        and (Pos <= GridExtent) then
      begin
        State := NewState;
        SizingPos := GridExtent;
        SizingOfs := GridExtent - Pos;
        Index := LastFullVisibleCell + 1;
      end;
    end;
  end;

var
  EffectiveOptions: TGridOptions;
begin
  State := gsNormal;
  Index := -1;
  EffectiveOptions := Options;
  if csDesigning in ComponentState then
    EffectiveOptions := EffectiveOptions + DesignOptionsBoost;
  if [goColSizing, goRowSizing] * EffectiveOptions <> [] then
    with FixedInfo do
    begin
      Vert.GridExtent := ClientHeight;
      Horz.GridExtent := ClientWidth;
      if (X<ClientWidth-FWidthDef)and
      {(X > Horz.FixedBoundary) and} (goColSizing in EffectiveOptions) then
      begin
        //if Y >= Vert.FixedBoundary then Exit;
        if FRowCount<>0 then
        CalcAxisState(Horz, X, gsColSizing);
      end
      else if (Y > Vert.FixedBoundary) and (goRowSizing in EffectiveOptions) then
      begin
        if X >= Horz.FixedBoundary then Exit;
        CalcAxisState(Vert, Y, gsRowSizing);
      end;
    end;
end;

procedure TtsvCustomGrid.ChangeSize(NewColCount, NewRowCount: Longint);
var
  OldColCount, OldRowCount: Longint;
  OldDrawInfo: TGridDrawInfo;

  procedure MinRedraw(const OldInfo, NewInfo: TGridAxisDrawInfo; Axis: Integer);
  var
    R: TRect;
    First: Integer;
  begin
    if (OldInfo.LastFullVisibleCell = NewInfo.LastFullVisibleCell) then Exit;
    First := IMin(OldInfo.LastFullVisibleCell, NewInfo.LastFullVisibleCell);
    // Get the rectangle around the leftmost or topmost cell in the target range.
    R := CellRect(First and not Axis, First and Axis);
    R.Bottom := Height;
    R.Right := Width;
    Windows.InvalidateRect(Handle, @R, False);
  end;

  procedure DoChange;
  var
    Coord: TGridCoord;
    NewDrawInfo: TGridDrawInfo;
  begin
    if FColWidths <> nil then
    begin
      UpdateExtents(FColWidths, ColCount, DefaultColWidth);
      UpdateExtents(FTabStops, ColCount, Integer(True));
    end;
    if FRowHeights <> nil then
      UpdateExtents(FRowHeights, RowCount, DefaultRowHeight);
    Coord := FCurrent;
    if Row >= RowCount then Coord.Y := RowCount - 1;
    if Col >= ColCount then Coord.X := ColCount - 1;
    if Coord.Y<0 then Coord.Y:=0;
    if Coord.X<0 then Coord.X:=0;

    if (FCurrent.X <> Coord.X) or (FCurrent.Y <> Coord.Y) then
      MoveCurrent(Coord.X, Coord.Y, True, True);
    if (FAnchor.X <> Coord.X) or (FAnchor.Y <> Coord.Y) then
      MoveAnchor(Coord);
    if VirtualView or
      (LeftCol <> OldDrawInfo.Horz.FirstGridCell) or
      (TopRow <> OldDrawInfo.Vert.FirstGridCell) then
      InvalidateGrid
    else if HandleAllocated then
    begin
      CalcDrawInfo(NewDrawInfo);
      MinRedraw(OldDrawInfo.Horz, NewDrawInfo.Horz, 0);
      MinRedraw(OldDrawInfo.Vert, NewDrawInfo.Vert, -1);
    end;
    UpdateScrollRange;
    SizeChanged(OldColCount, OldRowCount);
  end;

begin
  if HandleAllocated then
    CalcDrawInfo(OldDrawInfo);
  OldColCount := FColCount;
  OldRowCount := FRowCount;
  FColCount := NewColCount;
  FRowCount := NewRowCount;
  if FixedCols > NewColCount then FFixedCols := NewColCount - 1;
  if FixedRows > NewRowCount then FFixedRows := NewRowCount - 1;
  try
    DoChange;
  //  UpdateScrollBar;
  except
    { Could not change size so try to clean up by setting the size back }
    FColCount := OldColCount;
    FRowCount := OldRowCount;
    DoChange;
    InvalidateGrid;
    raise;
  end;
end;

{ Will move TopLeft so that Coord is in view }
procedure TtsvCustomGrid.ClampInView(const Coord: TGridCoord);
var
  DrawInfo: TGridDrawInfo;
  MaxTopLeft: TGridCoord;
  OldTopLeft: TGridCoord;
begin
  if not HandleAllocated then Exit;
  CalcDrawInfo(DrawInfo);
  with DrawInfo, Coord do
  begin
    if (X > Horz.LastFullVisibleCell) or
      (Y > Vert.LastFullVisibleCell) or (X < LeftCol) or (Y < TopRow) then
    begin
      OldTopLeft := FTopLeft;
      MaxTopLeft := CalcMaxTopLeft(Coord, DrawInfo);
      Update;
      if X < LeftCol then FTopLeft.X := X
      else if X > Horz.LastFullVisibleCell then FTopLeft.X := MaxTopLeft.X;
      if Y < TopRow then FTopLeft.Y := Y
      else if Y > Vert.LastFullVisibleCell then FTopLeft.Y := MaxTopLeft.Y;
      TopLeftMoved(OldTopLeft);
    end;
  end;
end;

procedure TtsvCustomGrid.DrawSizingLine(const DrawInfo: TGridDrawInfo);
var
  OldPen: TPen;
begin
  OldPen := TPen.Create;
  try
    with Canvas, DrawInfo do
    begin
      OldPen.Assign(Pen);
//      Pen.Style := psDot;
      Pen.Mode := pmNotXor;
      Pen.Width := 1;
      Pen.Color:=clBlack;
      try
        if FGridState = gsRowSizing then
        begin
          MoveTo(0, FSizingPos);
          LineTo(Horz.GridBoundary, FSizingPos);
        end
        else
        begin
          MoveTo(FSizingPos, 0);
          LineTo(FSizingPos, Vert.GridBoundary);
        end;
      finally
        Pen := OldPen;
      end;
    end;
  finally
    OldPen.Free;
  end;
end;

procedure TtsvCustomGrid.DrawMove;
var
  OldPen: TPen;
  Pos: Integer;
  R: TRect;
begin
  OldPen := TPen.Create;
  try
    with Canvas do
    begin
      OldPen.Assign(Pen);
      try
        Pen.Style := psDot;
        Pen.Mode := pmXor;
        Pen.Width := 5;
        if FGridState = gsRowMoving then
        begin
          R := CellRect(0, FMovePos);
          if FMovePos > FMoveIndex then
            Pos := R.Bottom else
            Pos := R.Top;
          MoveTo(0, Pos);
          LineTo(ClientWidth, Pos);
        end
        else
        begin
          R := CellRect(FMovePos, 0);
          if FMovePos > FMoveIndex then
            Pos := R.Right else
            Pos := R.Left;
          MoveTo(Pos, 0);
          LineTo(Pos, ClientHeight);
        end;
      finally
        Canvas.Pen := OldPen;
      end;
    end;
  finally
    OldPen.Free;
  end;
end;

procedure TtsvCustomGrid.FocusCell(ACol, ARow: Longint; MoveAnchor: Boolean);
begin
  MoveCurrent(ACol, ARow, MoveAnchor, True);
  UpdateEdit;
  Click;
end;

procedure TtsvCustomGrid.GridRectToScreenRect(GridRect: TGridRect;
  var ScreenRect: TRect; IncludeLine: Boolean);

  function LinePos(const AxisInfo: TGridAxisDrawInfo; Line: Integer): Integer;
  var
    Start, I: Longint;
  begin
    with AxisInfo do
    begin
      Result := 0;
      if Line < FixedCellCount then
        Start := 0
      else
      begin
        if Line >= FirstGridCell then
          Result := FixedBoundary;
        Start := FirstGridCell;
      end;
      for I := Start to Line - 1 do
      begin
        Inc(Result, GetExtent(I) + EffectiveLineWidth);
        if Result > GridExtent then
        begin
          Result := 0;
          Exit;
        end;
      end;
    end;
  end;

  function CalcAxis(const AxisInfo: TGridAxisDrawInfo;
    GridRectMin, GridRectMax: Integer;
    var ScreenRectMin, ScreenRectMax: Integer): Boolean;
  begin
    Result := False;
    with AxisInfo do
    begin
      if (GridRectMin >= FixedCellCount) and (GridRectMin < FirstGridCell) then
        if GridRectMax < FirstGridCell then
        begin
          FillChar(ScreenRect, SizeOf(ScreenRect), 0); { erase partial results }
          Exit;
        end
        else
          GridRectMin := FirstGridCell;
      if GridRectMax > LastFullVisibleCell then
      begin
        GridRectMax := LastFullVisibleCell;
        if GridRectMax < GridCellCount - 1 then Inc(GridRectMax);
        if LinePos(AxisInfo, GridRectMax) = 0 then
          Dec(GridRectMax);
      end;

      ScreenRectMin := LinePos(AxisInfo, GridRectMin);
      ScreenRectMax := LinePos(AxisInfo, GridRectMax);
      if ScreenRectMax = 0 then
        ScreenRectMax := ScreenRectMin + GetExtent(GridRectMin)
      else
        Inc(ScreenRectMax, GetExtent(GridRectMax));
      if ScreenRectMax > GridExtent then
        ScreenRectMax := GridExtent;
      if IncludeLine then Inc(ScreenRectMax, EffectiveLineWidth);
    end;
    Result := True;
  end;

var
  DrawInfo: TGridDrawInfo;
begin
  FillChar(ScreenRect, SizeOf(ScreenRect), 0);
  if (GridRect.Left > GridRect.Right) or (GridRect.Top > GridRect.Bottom) then
    Exit;
  CalcDrawInfo(DrawInfo);
  with DrawInfo do
  begin
    if GridRect.Left > Horz.LastFullVisibleCell + 1 then Exit;
    if GridRect.Top > Vert.LastFullVisibleCell + 1 then Exit;

    if CalcAxis(Horz, GridRect.Left, GridRect.Right, ScreenRect.Left,
      ScreenRect.Right) then
    begin
      CalcAxis(Vert, GridRect.Top, GridRect.Bottom, ScreenRect.Top,
        ScreenRect.Bottom);
    end;
  end;
end;

procedure TtsvCustomGrid.Initialize;
begin
  FTopLeft.X := FixedCols;
  FTopLeft.Y := FixedRows;
  FCurrent := FTopLeft;
  FAnchor := FCurrent;
  if goRowSelect in Options then FAnchor.X := ColCount - 1;
end;

procedure TtsvCustomGrid.InvalidateCell(ACol, ARow: Longint);
var
  Rect: TGridRect;
begin
  Rect.Top := ARow;
  Rect.Left := ACol;
  Rect.Bottom := ARow;
  Rect.Right := ACol;
  InvalidateRect(Rect);
end;

procedure TtsvCustomGrid.InvalidateCol(ACol: Longint);
var
  Rect: TGridRect;
begin
  if not HandleAllocated then Exit;
  Rect.Top := 0;
  Rect.Left := ACol;
  Rect.Bottom := VisibleRowCount+1;
  Rect.Right := ACol;
  InvalidateRect(Rect);
end;

procedure TtsvCustomGrid.InvalidateRow(ARow: Longint);
var
  Rect: TGridRect;
begin
  if not HandleAllocated then Exit;
  Rect.Top := ARow;
  Rect.Left := 0;
  Rect.Bottom := ARow;
  Rect.Right := VisibleColCount+1;
  InvalidateRect(Rect);
end;

procedure TtsvCustomGrid.InvalidateGrid;
begin
  Invalidate;
end;

procedure TtsvCustomGrid.InvalidateRect(ARect: TGridRect);
var
  InvalidRect: TRect;
begin
  if not HandleAllocated then Exit;
  GridRectToScreenRect(ARect, InvalidRect, True);
  Windows.InvalidateRect(Handle, @InvalidRect, False);
end;

procedure TtsvCustomGrid.ModifyScrollBar(ScrollBar, ScrollCode, Pos: Cardinal);
var
  NewTopLeft, MaxTopLeft: TGridCoord;
  DrawInfo: TGridDrawInfo;

  function Min: Longint;
  begin
    if ScrollBar = SB_HORZ then Result := FixedCols
    else Result := FixedRows;
  end;

  function Max: Longint;
  begin
    if ScrollBar = SB_HORZ then Result := MaxTopLeft.X
    else Result := MaxTopLeft.Y;
  end;

  function PageUp: Longint;
  var
    MaxTopLeft: TGridCoord;
  begin
    MaxTopLeft := CalcMaxTopLeft(FTopLeft, DrawInfo);
    if ScrollBar = SB_HORZ then
      Result := FTopLeft.X - MaxTopLeft.X else
      Result := FTopLeft.Y - MaxTopLeft.Y;
    if Result < 1 then Result := 1;
  end;

  function PageDown: Longint;
  var
    DrawInfo: TGridDrawInfo;
  begin
    CalcDrawInfo(DrawInfo);
    with DrawInfo do
      if ScrollBar = SB_HORZ then
        Result := Horz.LastFullVisibleCell - FTopLeft.X else
        Result := Vert.LastFullVisibleCell - FTopLeft.Y;
    if Result < 1 then Result := 1;
  end;

  function CalcScrollBar(Value: Longint): Longint;
  var
   ScrollArea: TRect;
  begin
    Result := Value;
    case ScrollCode of
      SB_LINEUP:
        Result := Value - 1;
      SB_LINEDOWN:
        Result := Value + 1;
      SB_PAGEUP:
        Result := Value - PageUp;
      SB_PAGEDOWN:
        Result := Value + PageDown;
      SB_THUMBPOSITION, SB_THUMBTRACK:
        begin
//      if (goThumbTracking in Options) or (ScrollCode = SB_THUMBPOSITION) then
//          Result := Min + LongMulDiv(Pos, Max - Min, MaxShortInt);
          Result := Min + LongInt(Pos)-1;
          ScrollArea := ClientRect;
          //Windows.InvalidateRect(Handle, @ScrollArea, True)
        end;
      SB_BOTTOM:
        Result := Min;
      SB_TOP:
        Result := Min;
    end;
  end;

  procedure ModifyPixelScrollBar(Code, Pos: Cardinal);
  var
    NewOffset: Integer;
    OldOffset: Integer;
    R: TGridRect;
    GridSpace, ColWidth: Integer;
  begin
    NewOffset := FColOffset;
    ColWidth := ColWidths[DrawInfo.Horz.FirstGridCell];
    GridSpace := ClientWidth - DrawInfo.Horz.FixedBoundary;
    case Code of
      SB_LINEUP: Dec(NewOffset, Canvas.TextWidth('0'));
      SB_LINEDOWN: Inc(NewOffset, Canvas.TextWidth('0'));
      SB_PAGEUP: Dec(NewOffset, GridSpace);
      SB_PAGEDOWN: Inc(NewOffset, GridSpace);
      SB_THUMBPOSITION: NewOffset := Pos;
      SB_THUMBTRACK: if goThumbTracking in Options then NewOffset := Pos;
      SB_BOTTOM: NewOffset := 0;
      SB_TOP: NewOffset := ColWidth - GridSpace;
    end;
    if NewOffset < 0 then
      NewOffset := 0
    else if NewOffset >= ColWidth - GridSpace then
      NewOffset := ColWidth - GridSpace;
    if NewOffset <> FColOffset then
    begin
      OldOffset := FColOffset;
      FColOffset := NewOffset;
      ScrollData(OldOffset - NewOffset, 0);
      FillChar(R, SizeOf(R), 0);
      R.Bottom := FixedRows;
      InvalidateRect(R);
      Update;
      UpdateScrollPos;
    end;
  end;

begin
  OldRow:=Row;
  if Visible and CanFocus and TabStop and not (csDesigning in ComponentState) then
    SetFocus;
  CalcDrawInfo(DrawInfo);
  if (ScrollBar = SB_HORZ) and (ColCount = 1) then
  begin
    ModifyPixelScrollBar(ScrollCode, Pos);
    Exit;
  end;
  MaxTopLeft.X := ColCount - 1;
  MaxTopLeft.Y := RowCount - 1;
  MaxTopLeft := CalcMaxTopLeft(MaxTopLeft, DrawInfo);
  NewTopLeft := FTopLeft;
  if ScrollBar = SB_HORZ then NewTopLeft.X := CalcScrollBar(NewTopLeft.X)
  else NewTopLeft.Y := CalcScrollBar(NewTopLeft.Y);
  if NewTopLeft.X < FixedCols then NewTopLeft.X := FixedCols
  else if NewTopLeft.X > MaxTopLeft.X then NewTopLeft.X := MaxTopLeft.X;
  if NewTopLeft.Y < FixedRows then NewTopLeft.Y := FixedRows
  else if NewTopLeft.Y > MaxTopLeft.Y then NewTopLeft.Y := MaxTopLeft.Y;
  if (NewTopLeft.X <> FTopLeft.X) or (NewTopLeft.Y <> FTopLeft.Y) then
    MoveTopLeft(NewTopLeft.X, NewTopLeft.Y);
end;

procedure TtsvCustomGrid.MoveAdjust(var CellPos: Longint; FromIndex, ToIndex: Longint);
var
  Min, Max: Longint;
begin
  if CellPos = FromIndex then CellPos := ToIndex
  else
  begin
    Min := FromIndex;
    Max := ToIndex;
    if FromIndex > ToIndex then
    begin
      Min := ToIndex;
      Max := FromIndex;
    end;
    if (CellPos >= Min) and (CellPos <= Max) then
      if FromIndex > ToIndex then
        Inc(CellPos) else
        Dec(CellPos);
  end;
end;

procedure TtsvCustomGrid.MoveAnchor(const NewAnchor: TGridCoord);
var
  OldSel: TGridRect;
begin
  if [goRangeSelect, goEditing] * Options = [goRangeSelect] then
  begin
    OldSel := Selection;
    FAnchor := NewAnchor;
    if goRowSelect in Options then FAnchor.X := ColCount - 1;
    ClampInView(NewAnchor);
    SelectionMoved(OldSel);
  end
  else MoveCurrent(NewAnchor.X, NewAnchor.Y, True, True);
end;

procedure TtsvCustomGrid.MoveCurrent(ACol, ARow: Longint; MoveAnchor,
  Show: Boolean);
var
  OldSel: TGridRect;
  OldCurrent: TGridCoord;
begin
{      if ARow<0 then ARow:=0;
      if ACol<0 then ACol:=0;}
  if (ACol < 0) or (ARow < 0) or (ACol >= ColCount) or (ARow >= RowCount) then
  begin
   if FRowCount<>0 then
    InvalidOp(SIndexOutOfRange);
  end;
  if SelectCell(ACol, ARow) then
  begin
    OldSel := Selection;
    OldCurrent := FCurrent;
    FCurrent.X := ACol;
    FCurrent.Y := ARow;
    if not (goAlwaysShowEditor in Options) then HideEditor;
    if MoveAnchor or not (goRangeSelect in Options) then
    begin
      FAnchor := FCurrent;
      if goRowSelect in Options then FAnchor.X := ColCount - 1;
    end;
    if goRowSelect in Options then FCurrent.X := FixedCols;
    if Show then ClampInView(FCurrent);
    SelectionMoved(OldSel);
    with OldCurrent do InvalidateCell(X, Y);
    with FCurrent do InvalidateCell(ACol, ARow);
  end;
end;

procedure TtsvCustomGrid.MoveTopLeft(ALeft, ATop: Longint);
var
  OldTopLeft: TGridCoord;
begin
  if (ALeft = FTopLeft.X) and (ATop = FTopLeft.Y) then Exit;
  Update;
  OldTopLeft := FTopLeft;
  FTopLeft.X := ALeft;
  FTopLeft.Y := ATop;
  TopLeftMoved(OldTopLeft);
end;

procedure TtsvCustomGrid.ResizeCol(Index: Longint; OldSize, NewSize: Integer);
begin
  InvalidateGrid;
end;

procedure TtsvCustomGrid.ResizeRow(Index: Longint; OldSize, NewSize: Integer);
begin
  InvalidateGrid;
end;

procedure TtsvCustomGrid.SelectionMoved(const OldSel: TGridRect);
var
  OldRect, NewRect: TRect;
  AXorRects: TXorRects;
  I: Integer;
begin
  if not HandleAllocated then Exit;
  GridRectToScreenRect(OldSel, OldRect, True);
  GridRectToScreenRect(Selection, NewRect, True);
  XorRects(OldRect, NewRect, AXorRects);
  for I := Low(AXorRects) to High(AXorRects) do
    Windows.InvalidateRect(Handle, @AXorRects[I], False);
end;

procedure TtsvCustomGrid.ScrollDataInfo(DX, DY: Integer;
  var DrawInfo: TGridDrawInfo);
var
  ScrollArea: TRect;
  ScrollFlags: Integer;
begin
  with DrawInfo do
  begin
    ScrollFlags := SW_Invalidate;
    if not DefaultDrawing then
      ScrollFlags := ScrollFlags or SW_ERASE;
    { Scroll the area }
    if DY = 0 then
    begin
      { Scroll both the column titles and data area at the same time }
      ScrollArea := Rect(Horz.FixedBoundary, 0, Horz.GridExtent, Vert.GridExtent);
      ScrollWindowEx(Handle, DX, 0, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
    end
    else if DX = 0 then
    begin
      { Scroll both the row titles and data area at the same time }
      ScrollArea := Rect(0, Vert.FixedBoundary, Horz.GridExtent, Vert.GridExtent);
      ScrollWindowEx(Handle, 0, DY, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
    end
    else
    begin
      { Scroll titles and data area separately }
      { Column titles }
      ScrollArea := Rect(Horz.FixedBoundary, 0, Horz.GridExtent, Vert.FixedBoundary);
      ScrollWindowEx(Handle, DX, 0, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
      { Row titles }
      ScrollArea := Rect(0, Vert.FixedBoundary, Horz.FixedBoundary, Vert.GridExtent);
      ScrollWindowEx(Handle, 0, DY, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
      { Data area }
      ScrollArea := Rect(Horz.FixedBoundary, Vert.FixedBoundary, Horz.GridExtent,
        Vert.GridExtent);
      ScrollWindowEx(Handle, DX, DY, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
    end;
  end;
end;

procedure TtsvCustomGrid.ScrollData(DX, DY: Integer);
var
  DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  ScrollDataInfo(DX, DY, DrawInfo);
end;

procedure TtsvCustomGrid.TopLeftMoved(const OldTopLeft: TGridCoord);

  function CalcScroll(const AxisInfo: TGridAxisDrawInfo;
    OldPos, CurrentPos: Integer; var Amount: Longint): Boolean;
  var
    Start, Stop: Longint;
    I: Longint;
  begin
    Result := False;
    with AxisInfo do
    begin
      if OldPos < CurrentPos then
      begin
        Start := OldPos;
        Stop := CurrentPos;
      end
      else
      begin
        Start := CurrentPos;
        Stop := OldPos;
      end;
      Amount := 0;
      for I := Start to Stop - 1 do
      begin
        Inc(Amount, GetExtent(I) + EffectiveLineWidth);
        if Amount > (GridBoundary - FixedBoundary) then
        begin
          { Scroll amount too big, redraw the whole thing }
          InvalidateGrid;
          Exit;
        end;
      end;
      if OldPos < CurrentPos then Amount := -Amount;
    end;
    Result := True;
  end;

var
  DrawInfo: TGridDrawInfo;
  Delta: TGridCoord;
begin
  UpdateScrollPos;
  CalcDrawInfo(DrawInfo);
  if CalcScroll(DrawInfo.Horz, OldTopLeft.X, FTopLeft.X, Delta.X) and
    CalcScroll(DrawInfo.Vert, OldTopLeft.Y, FTopLeft.Y, Delta.Y) then
    ScrollDataInfo(Delta.X, Delta.Y, DrawInfo);
  TopLeftChanged;
end;

procedure TtsvCustomGrid.UpdateScrollPos;
var
  DrawInfo: TGridDrawInfo;
  MaxTopLeft: TGridCoord;

  procedure SetScroll(Code: Word; Value: Integer);
  begin
    if GetScrollPos(Handle, Code) <> Value then
      SetScrollPos(Handle, Code, Value, True);
  end;

var
  GridSpace, ColWidth: Integer;

begin
  if (not HandleAllocated) or (ScrollBars = ssNone) then Exit;
  CalcDrawInfo(DrawInfo);
  MaxTopLeft.X := ColCount - 1;
  MaxTopLeft.Y := RowCount - 1;
  MaxTopLeft := CalcMaxTopLeft(MaxTopLeft, DrawInfo);
  if ScrollBars in [ssHorizontal, ssBoth] then
    if ColCount = 1 then
    begin
      ColWidth := ColWidths[DrawInfo.Horz.FirstGridCell];
      GridSpace := ClientWidth - DrawInfo.Horz.FixedBoundary;
      if (FColOffset > 0) and (GridSpace > (ColWidth - FColOffset)) then
        ModifyScrollbar(SB_HORZ, SB_THUMBPOSITION, ColWidth - GridSpace)
      else
        SetScroll(SB_HORZ, FColOffset)
    end
    else
      SetScroll(SB_HORZ, LongMulDiv(FTopLeft.X - FixedCols, MaxShortInt,
        MaxTopLeft.X - FixedCols));

  if ScrollBars in [ssVertical, ssBoth] then
{    SetScroll(SB_VERT, LongMulDiv(FTopLeft.Y - FixedRows, MaxShortInt,
      MaxTopLeft.Y - FixedRows));}
    SetScroll(SB_VERT, FTopLeft.Y- FixedRows+1);

end;

procedure TtsvCustomGrid.UpdateScrollRange;
var
  MaxTopLeft, OldTopLeft: TGridCoord;
  DrawInfo: TGridDrawInfo;
  OldScrollBars: TScrollStyle;
  Updated: Boolean;
  i,CW:integer;

  procedure DoUpdate;
  begin
    if not Updated then
    begin
      Update;
      Updated := True;
    end;
  end;

  function ScrollBarVisible(Code: Word): Boolean;
  var
    Min, Max: Integer;
  begin
    Result := False;
    if (ScrollBars = ssBoth) or
      ((Code = SB_HORZ) and (ScrollBars = ssHorizontal)) or
      ((Code = SB_VERT) and (ScrollBars = ssVertical)) then
    begin
      GetScrollRange(Handle, Code, Min, Max);
      Result := Min <> Max;
    end;
  end;

  procedure CalcSizeInfo;
  begin
    CalcDrawInfoXY(DrawInfo, DrawInfo.Horz.GridExtent, DrawInfo.Vert.GridExtent);
    MaxTopLeft.X := ColCount - 1;
    MaxTopLeft.Y := RowCount - 1;
    MaxTopLeft := CalcMaxTopLeft(MaxTopLeft, DrawInfo);
  end;

  procedure SetAxisRange(var Max, Old, Current: Longint; Code: Word;
    Fixeds: Integer);
  begin
    CalcSizeInfo;
    if Fixeds < Max then begin
      SetScrollRange(Handle, Code, 0, MaxShortInt, True)
    end else begin
      SetScrollRange(Handle, Code, 0, 0, True);
    end;
    if Old > Max then
    begin
      DoUpdate;
      Current := Max;
    end;
  end;

  procedure SetHorzRange;
  var
    Range: Integer;
  begin
    if OldScrollBars in [ssHorizontal, ssBoth] then
      if ColCount = 1 then
      begin
        Range := ColWidths[0] - ClientWidth;
        if Range < 0 then Range := 0;
        SetScrollRange(Handle, SB_HORZ, 0, Range, True);
      end
      else
        SetAxisRange(MaxTopLeft.X, OldTopLeft.X, FTopLeft.X, SB_HORZ, FixedCols);
  end;

  procedure SetVertRange;
  begin
    if OldScrollBars in [ssVertical, ssBoth] then
      SetAxisRange(MaxTopLeft.Y, OldTopLeft.Y, FTopLeft.Y, SB_VERT, FixedRows);
  end;

begin
  OldRow:=Row;
  if (ScrollBars = ssNone) or not HandleAllocated then Exit;
  with DrawInfo do
  begin
    Horz.GridExtent := ClientWidth;
    Vert.GridExtent := ClientHeight;
    { Ignore scroll bars for initial calculation }
    if ScrollBarVisible(SB_HORZ) then
      Inc(Vert.GridExtent, GetSystemMetrics(SM_CYHSCROLL));
    if ScrollBarVisible(SB_VERT) then
      Inc(Horz.GridExtent, GetSystemMetrics(SM_CXVSCROLL));
  end;
  OldTopLeft := FTopLeft;
  { Temporarily mark us as not having scroll bars to avoid recursion }
  OldScrollBars := FScrollBars;
  FScrollBars := ssNone;
  Updated := False;
  try
    { Update scrollbars }
    SetHorzRange;
    DrawInfo.Vert.GridExtent := ClientHeight;
    SetVertRange;
    if DrawInfo.Horz.GridExtent <> ClientWidth then
    begin
      DrawInfo.Horz.GridExtent := ClientWidth;
      SetHorzRange;
    end;
  finally
    FScrollBars := OldScrollBars;
  end;
  UpdateScrollPos;
  if (FTopLeft.X <> OldTopLeft.X) or (FTopLeft.Y <> OldTopLeft.Y) then
    TopLeftMoved(OldTopLeft);

  CW:=0;
  for i:=0 to FColCount-2 do begin
     CW:=CW+ColWidths[i];
  end;
  ColWidths[FColCount-1]:=Width-CW-6;
  UpdateScrollBar;
end;

function TtsvCustomGrid.CreateEditor: TtsvInplaceEdit;
begin
  Result := TtsvInplaceEdit.Create(Self);
end;

procedure TtsvCustomGrid.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_TABSTOP;
    if FScrollBars in [ssVertical, ssBoth] then Style := Style + WS_VSCROLL;
    if FScrollBars in [ssHorizontal, ssBoth] then Style := Style + WS_HSCROLL;
    WindowClass.style := CS_DBLCLKS;
    if FBorderStyle = bsSingle then
      if NewStyleControls and Ctl3D then
      begin
        Style := Style and not WS_BORDER;
        ExStyle := ExStyle or WS_EX_CLIENTEDGE;
      end
      else
        Style := Style or WS_BORDER;
  end;

end;

procedure TtsvCustomGrid.KeyDown(var Key: Word; Shift: TShiftState);
var
  NewTopLeft, NewCurrent, MaxTopLeft: TGridCoord;
  DrawInfo: TGridDrawInfo;
  PageWidth, PageHeight: Integer;

  procedure CalcPageExtents;
  begin
    CalcDrawInfo(DrawInfo);
    PageWidth := DrawInfo.Horz.LastFullVisibleCell - LeftCol;
    if PageWidth < 1 then PageWidth := 1;
    PageHeight := DrawInfo.Vert.LastFullVisibleCell - TopRow;
    if PageHeight < 1 then PageHeight := 1;
  end;

  procedure Restrict(var Coord: TGridCoord; MinX, MinY, MaxX, MaxY: Longint);
  begin
    with Coord do
    begin
      if X > MaxX then X := MaxX
      else if X < MinX then X := MinX;
      if Y > MaxY then Y := MaxY
      else if Y < MinY then Y := MinY;
    end;
  end;

begin
  inherited KeyDown(Key, Shift);
  OldRow:=Row;
  if not CanGridAcceptKey(Key, Shift) then Key := 0;
  NewCurrent := FCurrent;
  NewTopLeft := FTopLeft;
  CalcPageExtents;
  if ssCtrl in Shift then
    case Key of
      VK_UP: Dec(NewTopLeft.Y);
      VK_DOWN: Inc(NewTopLeft.Y);
      VK_LEFT:
        if not (goRowSelect in Options) then
        begin
          Dec(NewCurrent.X, PageWidth);
          Dec(NewTopLeft.X, PageWidth);
        end;
      VK_RIGHT:
        if not (goRowSelect in Options) then
        begin
          Inc(NewCurrent.X, PageWidth);
          Inc(NewTopLeft.X, PageWidth);
        end;
      VK_PRIOR: NewCurrent.Y := TopRow;
      VK_NEXT: NewCurrent.Y := DrawInfo.Vert.LastFullVisibleCell;
      VK_HOME:
        begin
          NewCurrent.X := FixedCols;
          NewCurrent.Y := FixedRows;
        end;
      VK_END:
        begin
          NewCurrent.X := ColCount - 1;
          NewCurrent.Y := RowCount - 1;
        end;
    end
  else
    case Key of
      VK_UP: Dec(NewCurrent.Y);
      VK_DOWN: Inc(NewCurrent.Y);
      VK_LEFT:
        if goRowSelect in Options then
          Dec(NewCurrent.Y) else
          Dec(NewCurrent.X);
      VK_RIGHT:
        if goRowSelect in Options then
          Inc(NewCurrent.Y) else
          Inc(NewCurrent.X);
      VK_NEXT:
        begin
          Inc(NewCurrent.Y, PageHeight);
          Inc(NewTopLeft.Y, PageHeight);
        end;
      VK_PRIOR:
        begin
          Dec(NewCurrent.Y, PageHeight);
          Dec(NewTopLeft.Y, PageHeight);
        end;
      VK_HOME:
        if goRowSelect in Options then
          NewCurrent.Y := FixedRows else
          NewCurrent.X := FixedCols;
      VK_END:
        if goRowSelect in Options then
          NewCurrent.Y := RowCount - 1 else
          NewCurrent.X := ColCount - 1;
      VK_TAB:
        if not (ssAlt in Shift) then
        repeat
          if ssShift in Shift then
          begin
            Dec(NewCurrent.X);
            if NewCurrent.X < FixedCols then
            begin
              NewCurrent.X := ColCount - 1;
              Dec(NewCurrent.Y);
              if NewCurrent.Y < FixedRows then NewCurrent.Y := RowCount - 1;
            end;
            Shift := [];
          end
          else
          begin
            Inc(NewCurrent.X);
            if NewCurrent.X >= ColCount then
            begin
              NewCurrent.X := FixedCols;
              Inc(NewCurrent.Y);
              if NewCurrent.Y >= RowCount then NewCurrent.Y := FixedRows;
            end;
          end;
        until TabStops[NewCurrent.X] or (NewCurrent.X = FCurrent.X);
      VK_F2: EditorMode := True;
    end;
  MaxTopLeft.X := ColCount - 1;
  MaxTopLeft.Y := RowCount - 1;
  if RowCount>0 then begin
   MaxTopLeft := CalcMaxTopLeft(MaxTopLeft, DrawInfo);
   Restrict(NewTopLeft, FixedCols, FixedRows, MaxTopLeft.X, MaxTopLeft.Y);
   if (NewTopLeft.X <> LeftCol) or (NewTopLeft.Y <> TopRow) then
    MoveTopLeft(NewTopLeft.X, NewTopLeft.Y);
   Restrict(NewCurrent, FixedCols, FixedRows, ColCount - 1, RowCount - 1);
   if (NewCurrent.X <> Col) or (NewCurrent.Y <> Row) then
    FocusCell(NewCurrent.X, NewCurrent.Y, not (ssShift in Shift));
  end;  
end;

procedure TtsvCustomGrid.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if not (goAlwaysShowEditor in Options) and (Key = #13) then
  begin
    if FEditorMode then
      HideEditor else
      ShowEditor;
    Key := #0;
  end;
end;

procedure TtsvCustomGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  CellHit: TGridCoord;
  DrawInfo: TGridDrawInfo;
  MoveDrawn: Boolean;
begin
  MoveDrawn := False;
  HideEdit;
  OldRow:=Row;
  if not (csDesigning in ComponentState) and
    (CanFocus or (GetParentForm(Self) = nil)) then
  begin
    SetFocus;
    if not IsActiveControl then
    begin
      MouseCapture := False;
      Exit;
    end;
  end;
  if (Button = mbLeft) and (ssDouble in Shift) then
    DblClick
  else if Button = mbLeft then
  begin
    CalcDrawInfo(DrawInfo);
    { Check grid sizing }
    CalcSizingState(X, Y, FGridState, FSizingIndex, FSizingPos, FSizingOfs,
      DrawInfo);
    if FGridState <> gsNormal then
    begin
      DrawSizingLine(DrawInfo);
      Exit;
    end;
    CellHit := CalcCoordFromPoint(X, Y, DrawInfo);
    if CellHit.X=0 then CellHit.X:=FColCount-1;
    if (CellHit.X >= FixedCols) and (CellHit.Y >= FixedRows) then
    begin
      if goEditing in Options then
      begin
        if (CellHit.X = FCurrent.X) and (CellHit.Y = FCurrent.Y) then
          ShowEditor
        else
        begin
          MoveCurrent(CellHit.X, CellHit.Y, True, True);
          UpdateEdit;
        end;
        Click;
      end
      else
      begin
        FGridState := gsSelecting;
        SetTimer(Handle, 1, 60, nil);
        if ssShift in Shift then
          MoveAnchor(CellHit)
        else
          MoveCurrent(CellHit.X, CellHit.Y, True, True);
      end;
    end
    else if (goRowMoving in Options) and (CellHit.X >= 0) and
      (CellHit.X < FixedCols) and (CellHit.Y >= FixedRows) then
    begin
      FGridState := gsRowMoving;
      FMoveIndex := CellHit.Y;
      FMovePos := FMoveIndex;
      Update;
      DrawMove;
      MoveDrawn := True;
      SetTimer(Handle, 1, 60, nil);
    end
    else if (goColMoving in Options) and (CellHit.Y >= 0) and
      (CellHit.Y < FixedRows) and (CellHit.X >= FixedCols) then
    begin
      FGridState := gsColMoving;
      FMoveIndex := CellHit.X;
      FMovePos := FMoveIndex;
      Update;
      DrawMove;
      MoveDrawn := True;
      SetTimer(Handle, 1, 60, nil);
    end;
  end;
  try
    inherited MouseDown(Button, Shift, X, Y);
  except
    if MoveDrawn then DrawMove;
  end;
end;

procedure TtsvCustomGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  DrawInfo: TGridDrawInfo;
  CellHit: TGridCoord;
begin
  CalcDrawInfo(DrawInfo);

  case FGridState of
    gsSelecting, gsColMoving, gsRowMoving:
      begin
        CellHit := CalcCoordFromPoint(X, Y, DrawInfo);
        if (CellHit.X >= FixedCols) and (CellHit.Y >= FixedRows) and
          (CellHit.X <= DrawInfo.Horz.LastFullVisibleCell+1) and
          (CellHit.Y <= DrawInfo.Vert.LastFullVisibleCell+1) then
          case FGridState of
            gsSelecting:
              if ((CellHit.X <> FAnchor.X) or (CellHit.Y <> FAnchor.Y)) then
                MoveAnchor(CellHit);
            gsColMoving:
              MoveAndScroll(X, CellHit.X, DrawInfo, DrawInfo.Horz, SB_HORZ);
            gsRowMoving:
              MoveAndScroll(Y, CellHit.Y, DrawInfo, DrawInfo.Vert, SB_VERT);
          end;
      end;
    gsRowSizing, gsColSizing:
      begin
        if FRowCount=0 then exit;
        DrawSizingLine(DrawInfo); { XOR it out }
        if FGridState = gsRowSizing then
          FSizingPos := Y + FSizingOfs
        else begin
          if (X>=35)and(X<=ClientWidth-FWidthDef)then
            FSizingPos := X// + FSizingOfs;
           else begin
            if (X<35)then FSizingPos:=35;
            if (X>ClientWidth-FWidthDef)then FSizingPos:=ClientWidth-FWidthDef;
            DrawSizingLine(DrawInfo);
            exit;
           end;
        end;
        DrawSizingLine(DrawInfo); { XOR it back in }
      end;
    else begin
      if ssLeft in Shift then begin
       CellHit := MouseCoord(X,Y);
       if (CellHit.Y>=0)and(CellHit.Y<=RowCount) then begin
       Row:=CellHit.Y;
       SetPlace;
       OldRow:=Row;
      end else begin
       if (Row>0) and (Row<RowCount-1) then begin
        Row:=Row-1;
        SetPlace;
        OldRow:=Row;
       end;
      end;

     end;

    end;

  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TtsvCustomGrid.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  DrawInfo: TGridDrawInfo;
  NewSize: Integer;

  function ResizeLine(const AxisInfo: TGridAxisDrawInfo): Integer;
  var
    I: Integer;
  begin
    with AxisInfo do
    begin
      Result := 0;
      for I := FirstGridCell-1 to FSizingIndex - 1 do
        Inc(Result, GetExtent(I) + EffectiveLineWidth);
      Result := FSizingPos-Result;
    end;
  end;

begin
  try
    case FGridState of
      gsSelecting:
        begin
          MouseMove(Shift, X, Y);
          KillTimer(Handle, 1);
          UpdateEdit;
          Click;
        end;
      gsRowSizing, gsColSizing:
        begin
          CalcDrawInfo(DrawInfo);
          DrawSizingLine(DrawInfo);
          if FGridState = gsColSizing then
          begin
            NewSize := ResizeLine(DrawInfo.Horz);
            if NewSize > 1 then
            begin
              ColWidths[FSizingIndex] := NewSize;
              UpdateDesigner;
            end;
          end
          else
          begin
            NewSize := ResizeLine(DrawInfo.Vert);
            if NewSize > 1 then
            begin
              RowHeights[FSizingIndex] := NewSize;
              UpdateDesigner;
            end;
          end;
        end;
      gsColMoving, gsRowMoving:
        begin
          DrawMove;
          KillTimer(Handle, 1);
          if FMoveIndex <> FMovePos then
          begin
            if FGridState = gsColMoving then
              MoveColumn(FMoveIndex, FMovePos)
            else
              MoveRow(FMoveIndex, FMovePos);
            UpdateDesigner;
          end;
          UpdateEdit;
        end;
    else
//      UpdateEdit;
    end;
    inherited MouseUp(Button, Shift, X, Y);
  finally
    FGridState := gsNormal;
  end;
end;

procedure TtsvCustomGrid.MoveAndScroll(Mouse, CellHit: Integer;
  var DrawInfo: TGridDrawInfo; var Axis: TGridAxisDrawInfo; ScrollBar: Integer);
begin
  if (CellHit <> FMovePos) and
    not((FMovePos = Axis.FixedCellCount) and (Mouse < Axis.FixedBoundary)) and
    not((FMovePos = Axis.GridCellCount-1) and (Mouse > Axis.GridBoundary)) then
  begin
    DrawMove;
    if (Mouse < Axis.FixedBoundary) then
    begin
      if (FMovePos > Axis.FixedCellCount) then
      begin
        ModifyScrollbar(ScrollBar, SB_LINEUP, 0);
        Update;
        CalcDrawInfo(DrawInfo);    // this changes contents of Axis var
      end;
      CellHit := Axis.FirstGridCell;
    end
    else if (Mouse >= Axis.FullVisBoundary) then
    begin
      if (FMovePos = Axis.LastFullVisibleCell) and
        (FMovePos < Axis.GridCellCount -1) then
      begin
        ModifyScrollBar(Scrollbar, SB_LINEDOWN, 0);
        Update;
        CalcDrawInfo(DrawInfo);    // this changes contents of Axis var
      end;
      CellHit := Axis.LastFullVisibleCell;
    end
    else if CellHit < 0 then CellHit := FMovePos;
    FMovePos := CellHit;
    DrawMove;
  end;
end;

function TtsvCustomGrid.GetColWidths(Index: Longint): Integer;
begin
  if (FColWidths = nil) or (Index >= ColCount) then
    Result := DefaultColWidth
  else
    Result := PIntArray(FColWidths)^[Index + 1];
end;

function TtsvCustomGrid.GetRowHeights(Index: Longint): Integer;
begin
  if (FRowHeights = nil) or (Index >= RowCount) then
    Result := DefaultRowHeight
  else
    Result := PIntArray(FRowHeights)^[Index + 1];
end;

function TtsvCustomGrid.GetGridWidth: Integer;
var
  DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  Result := DrawInfo.Horz.GridBoundary;
end;

function TtsvCustomGrid.GetGridHeight: Integer;
var
  DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  Result := DrawInfo.Vert.GridBoundary;
end;

function TtsvCustomGrid.GetSelection: TGridRect;
begin
  Result := GridRect(FCurrent, FAnchor);
end;

function TtsvCustomGrid.GetTabStops(Index: Longint): Boolean;
begin
  if FTabStops = nil then Result := True
  else Result := Boolean(PIntArray(FTabStops)^[Index + 1]);
end;

function TtsvCustomGrid.GetVisibleColCount: Integer;
var
  DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  Result := DrawInfo.Horz.LastFullVisibleCell - LeftCol + 1;
end;

function TtsvCustomGrid.GetVisibleRowCount: Integer;
var
  DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  Result := DrawInfo.Vert.LastFullVisibleCell - TopRow + 1;
end;

procedure TtsvCustomGrid.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TtsvCustomGrid.SetCol(Value: Longint);
begin
  if Col <> Value then FocusCell(Value, Row, True);
end;

procedure TtsvCustomGrid.SetColCount(Value: Longint);
begin
  if FColCount <> Value then
  begin
//    if Value < 1 then Value := 1;
    if Value = 0 then
     FixedCols := Value;
    if Value <= FixedCols then FixedCols := Value - 1;
    ChangeSize(Value, RowCount);
    if goRowSelect in Options then
    begin
      if Value >= 1 then
      FAnchor.X := ColCount - 1;
      Invalidate;
    end;
  end;
end;

procedure TtsvCustomGrid.SetColWidths(Index: Longint; Value: Integer);
begin
  if FColWidths = nil then
    UpdateExtents(FColWidths, ColCount, DefaultColWidth);
  if Index >= ColCount then InvalidOp(SIndexOutOfRange);
  if Value <> PIntArray(FColWidths)^[Index + 1] then
  begin
    ResizeCol(Index, PIntArray(FColWidths)^[Index + 1], Value);
    PIntArray(FColWidths)^[Index + 1] := Value;
    ColWidthsChanged;
  end;
end;

procedure TtsvCustomGrid.SetDefaultColWidth(Value: Integer);
begin
  if FColWidths <> nil then UpdateExtents(FColWidths, 0, 0);
  FDefaultColWidth := Value;
  ColWidthsChanged;
  InvalidateGrid;
end;

procedure TtsvCustomGrid.SetDefaultRowHeight(Value: Integer);
begin
  if FRowHeights <> nil then UpdateExtents(FRowHeights, 0, 0);
  FDefaultRowHeight := Value;
  RowHeightsChanged;
  InvalidateGrid;
end;

procedure TtsvCustomGrid.SetFixedColor(Value: TColor);
begin
  if FFixedColor <> Value then
  begin
    FFixedColor := Value;
    InvalidateGrid;
  end;
end;

procedure TtsvCustomGrid.SetFixedCols(Value: Integer);
begin
  if FFixedCols <> Value then
  begin
    if Value < 0 then InvalidOp(SIndexOutOfRange);
    if Value >= ColCount then InvalidOp(SFixedColTooBig);
    FFixedCols := Value;
    Initialize;
    InvalidateGrid;
  end;
end;

procedure TtsvCustomGrid.SetFixedRows(Value: Integer);
begin
  if FFixedRows <> Value then
  begin
    if Value<0 then Value:=0;
    if Value < 0 then InvalidOp(SIndexOutOfRange);
    if Value >= RowCount then InvalidOp(SFixedRowTooBig);
    FFixedRows := Value;
    Initialize;
    InvalidateGrid;
  end;
end;

procedure TtsvCustomGrid.SetEditorMode(Value: Boolean);
begin
  if not Value then
    HideEditor
  else
  begin
    ShowEditor;
    if FInplaceEdit <> nil then FInplaceEdit.Deselect;
  end;
end;

procedure TtsvCustomGrid.SetGridLineWidth(Value: Integer);
begin
  if FGridLineWidth <> Value then
  begin
    FGridLineWidth := Value;
    InvalidateGrid;
  end;
end;

procedure TtsvCustomGrid.SetLeftCol(Value: Longint);
begin
  if FTopLeft.X <> Value then MoveTopLeft(Value, TopRow);
end;

procedure TtsvCustomGrid.SetOptions(Value: TGridOptions);
begin
  if FOptions <> Value then
  begin
    if goRowSelect in Value then
      Exclude(Value, goAlwaysShowEditor);
    FOptions := Value;
    if not FEditorMode then
      if goAlwaysShowEditor in Value then
        ShowEditor else
        HideEditor;
    if goRowSelect in Value then MoveCurrent(Col, Row,  True, False);
    InvalidateGrid;
  end;
end;

procedure TtsvCustomGrid.SetRow(Value: Longint);
begin
  if Row <> Value then FocusCell(Col, Value, True);
end;

procedure TtsvCustomGrid.SetRowCount(Value: Longint);
begin
  if FRowCount <> Value then
  begin
//   if Value < 1 then Value := 1;
    if Value=0 then
     FixedRows := Value;
    if Value <= FixedRows then FixedRows := Value - 1;
    ChangeSize(ColCount, Value);
  end;
end;

procedure TtsvCustomGrid.SetRowHeights(Index: Longint; Value: Integer);
begin
  if FRowHeights = nil then
    UpdateExtents(FRowHeights, RowCount, DefaultRowHeight);
  if Index >= RowCount then InvalidOp(SIndexOutOfRange);
  if Value <> PIntArray(FRowHeights)^[Index + 1] then
  begin
    ResizeRow(Index, PIntArray(FRowHeights)^[Index + 1], Value);
    PIntArray(FRowHeights)^[Index + 1] := Value;
    RowHeightsChanged;
  end;
end;

procedure TtsvCustomGrid.SetScrollBars(Value: TScrollStyle);
begin
  if FScrollBars <> Value then
  begin
    FScrollBars := Value;
    RecreateWnd;
  end;
end;

procedure TtsvCustomGrid.SetSelection(Value: TGridRect);
var
  OldSel: TGridRect;
begin
  OldSel := Selection;
  FAnchor := Value.TopLeft;
  FCurrent := Value.BottomRight;
  SelectionMoved(OldSel);
end;

procedure TtsvCustomGrid.SetTabStops(Index: Longint; Value: Boolean);
begin
  if FTabStops = nil then
    UpdateExtents(FTabStops, ColCount, Integer(True));
  if Index >= ColCount then InvalidOp(SIndexOutOfRange);
  PIntArray(FTabStops)^[Index + 1] := Integer(Value);
end;

procedure TtsvCustomGrid.SetTopRow(Value: Longint);
begin
  if FTopLeft.Y <> Value then MoveTopLeft(LeftCol, Value);
end;

procedure TtsvCustomGrid.HideEdit;
begin
  if FInplaceEdit <> nil then
    try
      UpdateText;
    finally
      FInplaceCol := -1;
      FInplaceRow := -1;
      FInplaceEdit.Hide;
      Button.Visible:=false;
    end;
end;

procedure TtsvCustomGrid.UpdateEdit;

  procedure UpdateEditor;
  begin
    FInplaceCol := Col;
    FInplaceRow := Row;
    FInplaceEdit.UpdateContents;
    if FInplaceEdit.MaxLength = -1 then FCanEditModify := False
    else FCanEditModify := True;
    FInplaceEdit.SelectAll;
  end;
begin
  if CanEditShow then
  begin
    if FInplaceEdit = nil then
    begin
      FInplaceEdit := CreateEditor;
      FInplaceEdit.SetGrid(Self);
      FInplaceEdit.Parent := Self;
      UpdateEditor;
    end
    else
    begin
      if (Col <> FInplaceCol) or (Row <> FInplaceRow) then
      begin
        HideEdit;
        UpdateEditor;
      end;
    end;
    if CanEditShow then begin
      SetPlace;
    end;
  end;
end;

procedure TtsvCustomGrid.UpdateText;
begin
  if (FInplaceCol <> -1) and (FInplaceRow <> -1) then
    SetEditText(FInplaceCol, FInplaceRow, FInplaceEdit.Text);
end;

procedure TtsvCustomGrid.WMChar(var Msg: TWMChar);
begin
  if (goEditing in Options) and (Char(Msg.CharCode) in [^H, #32..#255]) then
    ShowEditorChar(Char(Msg.CharCode))
  else
    inherited;
end;

procedure TtsvCustomGrid.WMCommand(var Message: TWMCommand);
begin
  with Message do
  begin
    if (FInplaceEdit <> nil) and (Ctl = FInplaceEdit.Handle) then
      case NotifyCode of
        EN_CHANGE: UpdateText;
      end;
  end;
end;

procedure TtsvCustomGrid.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  Msg.Result := DLGC_WANTARROWS;
  if goRowSelect in Options then Exit;
  if goTabs in Options then Msg.Result := Msg.Result or DLGC_WANTTAB;
  if goEditing in Options then Msg.Result := Msg.Result or DLGC_WANTCHARS;
end;

procedure TtsvCustomGrid.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  InvalidateRect(Selection);
  try
    if (FInplaceEdit <> nil) and (Msg.FocusedWnd <> FInplaceEdit.Handle) then
      HideEdit;
  except on EAccessViolation do HideEdit;
  end;
end;

procedure TtsvCustomGrid.WMLButtonDown(var Message: TMessage);
begin
  inherited;
  if FInplaceEdit <> nil then FInplaceEdit.FClickTime := GetMessageTime;
end;

procedure TtsvCustomGrid.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  DefaultHandler(Msg);
  FHitTest := ScreenToClient(SmallPointToPoint(Msg.Pos));
end;

procedure TtsvCustomGrid.WMSetCursor(var Msg: TWMSetCursor);
var
  DrawInfo: TGridDrawInfo;
  State: TGridState;
  Index: Longint;
  Pos, Ofs: Integer;
  Cur: HCURSOR;
begin
  Cur := 0;
  with Msg do
  begin
    if HitTest = HTCLIENT then
    begin
      if FGridState = gsNormal then
      begin
        CalcDrawInfo(DrawInfo);
        CalcSizingState(FHitTest.X, FHitTest.Y, State, Index, Pos, Ofs,
          DrawInfo);
      end else State := FGridState;
      if State = gsRowSizing then
         Cur := Screen.Cursors[crVSplit]
      else if State = gsColSizing then
        Cur := Screen.Cursors[crHSplit]
    end;
  end;
  if Cur <> 0 then SetCursor(Cur)
  else inherited;
end;

procedure TtsvCustomGrid.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;                       
  if (FInplaceEdit = nil) or (Msg.FocusedWnd <> FInplaceEdit.Handle) then
  begin
    InvalidateRect(Selection);
    UpdateEdit;
  end;
end;

procedure TtsvCustomGrid.WMSize(var Msg: TWMSize);
begin
  inherited;
  UpdateScrollRange;
  UpdateScrollBar;
  if ColWidths[ColCount-1]<FWidthDef then begin
     ColWidths[0]:=ClientWidth-FWidthDef;
     if ClientWidth<FWidthDef then begin
      ColWidths[0]:=FWidthDef div 2;
//      ColWidths[ColCount-1]:=
     end;
  end;
  setPlace;
end;

procedure TtsvCustomGrid.WMVScroll(var Msg: TWMVScroll);
begin
  ModifyScrollBar(SB_VERT, Msg.ScrollCode, Msg.Pos);
  setPlace;
end;

procedure TtsvCustomGrid.WMHScroll(var Msg: TWMHScroll);
begin
  ModifyScrollBar(SB_HORZ, Msg.ScrollCode, Msg.Pos);
  setPlace;
end;

{procedure TtsvCustomGrid.MoveTop(NewTop: Integer);
var
  VertCount, ShiftY: Integer;
  ScrollArea: TRect;
begin
  if NewTop < 0 then NewTop := 0;
  VertCount := VisibleRowCount;
  if NewTop + VertCount > RowCount then
    NewTop := RowCount - VertCount;

  if NewTop = TopRow then Exit;

  ShiftY := (TopRow - NewTop) * FDefaultRowHeight;
  TopRow := NewTop;
  ScrollArea := ClientRect;
  SetScrollPos(Handle, SB_VERT, NewTop, True);
  if Abs(ShiftY) >= VertCount * FDefaultRowHeight then
    Windows.InvalidateRect(Handle, @ScrollArea, True)
  else
    ScrollWindowEx(Handle, 0, ShiftY,
      @ScrollArea, @ScrollArea, 0, nil, SW_INVALIDATE);

  
end;}

procedure TtsvCustomGrid.CMCancelMode(var Msg: TMessage);
begin
  if Assigned(FInplaceEdit) then FInplaceEdit.WndProc(Msg);
  inherited;
end;

procedure TtsvCustomGrid.CMFontChanged(var Message: TMessage);
begin
  if FInplaceEdit <> nil then FInplaceEdit.Font := Font;
  inherited;
end;

procedure TtsvCustomGrid.CMCtl3DChanged(var Message: TMessage);
begin
  inherited;
  RecreateWnd;
end;

procedure TtsvCustomGrid.CMDesignHitTest(var Msg: TCMDesignHitTest);
begin
  Msg.Result := Longint(BOOL(Sizing(Msg.Pos.X, Msg.Pos.Y)));
end;

procedure TtsvCustomGrid.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if (goEditing in Options) and (Char(Msg.CharCode) = #13) then Msg.Result := 1;
end;

procedure TtsvCustomGrid.TimedScroll(Directions: TGridScrollDirections);
var
  MaxAnchor, NewAnchor: TGridCoord;
begin
  NewAnchor := FAnchor;
  MaxAnchor.X := ColCount - 1;
  MaxAnchor.Y := RowCount - 1;
  if (gsdLeft in Directions) and (FAnchor.X > FixedCols) then Dec(NewAnchor.X);
  if (gsdRight in Directions) and (FAnchor.X < MaxAnchor.X) then Inc(NewAnchor.X);
  if (gsdUp in Directions) and (FAnchor.Y > FixedRows) then Dec(NewAnchor.Y);
  if (gsdDown in Directions) and (FAnchor.Y < MaxAnchor.Y) then Inc(NewAnchor.Y);
  if (FAnchor.X <> NewAnchor.X) or (FAnchor.Y <> NewAnchor.Y) then
    MoveAnchor(NewAnchor);
end;

procedure TtsvCustomGrid.WMTimer(var Msg: TWMTimer);
var
  Point: TPoint;
  DrawInfo: TGridDrawInfo;
  ScrollDirection: TGridScrollDirections;
  CellHit: TGridCoord;
begin
  if not (FGridState in [gsSelecting, gsRowMoving, gsColMoving]) then Exit;
  GetCursorPos(Point);
  Point := ScreenToClient(Point);
  CalcDrawInfo(DrawInfo);
  ScrollDirection := [];
  with DrawInfo do
  begin
    CellHit := CalcCoordFromPoint(Point.X, Point.Y, DrawInfo);
    case FGridState of
      gsColMoving:
        MoveAndScroll(Point.X, CellHit.X, DrawInfo, Horz, SB_HORZ);
      gsRowMoving:
        MoveAndScroll(Point.Y, CellHit.Y, DrawInfo, Vert, SB_VERT);
      gsSelecting:
      begin
        if Point.X < Horz.FixedBoundary then Include(ScrollDirection, gsdLeft)
        else if Point.X > Horz.FullVisBoundary then Include(ScrollDirection, gsdRight);
        if Point.Y < Vert.FixedBoundary then Include(ScrollDirection, gsdUp)
        else if Point.Y > Vert.FullVisBoundary then Include(ScrollDirection, gsdDown);
        if ScrollDirection <> [] then  TimedScroll(ScrollDirection);
      end;
    end;
  end;
end;

procedure TtsvCustomGrid.ColWidthsChanged;
begin
  UpdateScrollRange;
  UpdateEdit;
end;

procedure TtsvCustomGrid.RowHeightsChanged;
begin
  UpdateScrollRange;
  UpdateEdit;
end;

procedure TtsvCustomGrid.DeleteColumn(ACol: Longint);
begin
  MoveColumn(ACol, ColCount-1);
  ColCount := ColCount - 1;
end;

procedure TtsvCustomGrid.DeleteRow(ARow: Longint);
begin
  MoveRow(ARow, RowCount - 1);
  RowCount := RowCount - 1;
end;

procedure TtsvCustomGrid.UpdateDesigner;
var
  ParentForm: TCustomForm;
begin
  if (csDesigning in ComponentState) and HandleAllocated and
    not (csUpdating in ComponentState) then
  begin
    ParentForm := GetParentForm(Self);
    if Assigned(ParentForm) and Assigned(ParentForm.Designer) then
      ParentForm.Designer.Modified;
  end;
end;

procedure TtsvCustomGrid.SetEditType(Value: TEditType);
begin
  if Value<>FEditType then
  begin
     FEditType:=Value;
     UpdateEdit;
  end;
end;

procedure TtsvCustomGrid.Notification(AComponent: Tcomponent; Operation: TOperation);
begin
    inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FInplaceEdit) then
  begin
      FInplaceEdit:=nil;
  end;
end;

{ TtsvDrawGrid }

function TtsvDrawGrid.CellRect(ACol, ARow: Longint): TRect;
begin
  Result := inherited CellRect(ACol, ARow);
end;

procedure TtsvDrawGrid.MouseToCell(X, Y: Integer; var ACol, ARow: Longint);
var
  Coord: TGridCoord;
begin
  Coord := MouseCoord(X, Y);
  ACol := Coord.X;
  ARow := Coord.Y;
end;

procedure TtsvDrawGrid.ColumnMoved(FromIndex, ToIndex: Longint);
begin
  if Assigned(FOnColumnMoved) then FOnColumnMoved(Self, FromIndex, ToIndex);
end;

function TtsvDrawGrid.GetEditMask(ACol, ARow: Longint): string;
begin
  Result := '';
  if Assigned(FOnGetEditMask) then FOnGetEditMask(Self, ACol, ARow, Result);
end;

function TtsvDrawGrid.GetEditText(ACol, ARow: Longint): string;
begin
  Result := '';
  if Assigned(FOnGetEditText) then FOnGetEditText(Self, ACol, ARow, Result);
end;

procedure TtsvDrawGrid.RowMoved(FromIndex, ToIndex: Longint);
begin
  if Assigned(FOnRowMoved) then FOnRowMoved(Self, FromIndex, ToIndex);
end;

function TtsvDrawGrid.SelectCell(ACol, ARow: Longint): Boolean;
begin
  Result := True;
  if Assigned(FOnSelectCell) then FOnSelectCell(Self, ACol, ARow, Result);
end;

procedure TtsvDrawGrid.SetEditText(ACol, ARow: Longint; const Value: string);
begin
  if Assigned(FOnSetEditText) then FOnSetEditText(Self, ACol, ARow, Value);
end;

procedure TtsvDrawGrid.DrawCell(ACol, ARow: Longint; ARect: TRect;
  AState: TGridDrawState);
begin
  if Assigned(FOnDrawCell) then FOnDrawCell(Self, ACol, ARow, ARect, AState);
end;

procedure TtsvDrawGrid.TopLeftChanged;
begin
  inherited TopLeftChanged;
  if Assigned(FOnTopLeftChanged) then FOnTopLeftChanged(Self);
end;

{ StrItem management for TStringSparseList }

type
  PStrItem = ^TStrItem;
  TStrItem = record
    FObject: TObject;
    FString: string;
  end;

function NewStrItem(const AString: string; AObject: TObject): PStrItem;
begin
  New(Result);
  Result^.FObject := AObject;
  Result^.FString := AString;
end;

procedure DisposeStrItem(P: PStrItem);
begin
  Dispose(P);
end;

{ Sparse array classes for TtsvStringGrid }

type

  PPointer = ^Pointer;

{ Exception classes }

  EStringSparseListError = class(Exception);

{ TSparsePointerArray class}

{ Used by TSparseList.  Based on Sparse1Array, but has Pointer elements
  and Integer index, just like TPointerList/TList, and less indirection }

  { Apply function for the applicator:
        TheIndex        Index of item in array
        TheItem         Value of item (i.e pointer element) in section
        Returns: 0 if success, else error code. }
  TSPAApply = function(TheIndex: Integer; TheItem: Pointer): Integer;

  TSecDir = array[0..4095] of Pointer;  { Enough for up to 12 bits of sec }
  PSecDir = ^TSecDir;
  TSPAQuantum = (SPASmall, SPALarge);   { Section size }

  TSparsePointerArray = class(TObject)
  private
    secDir: PSecDir;
    slotsInDir: Word;
    indexMask, secShift: Word;
    FHighBound: Integer;
    FSectionSize: Word;
    cachedIndex: Integer;
    cachedPointer: Pointer;
    { Return item[i], nil if slot outside defined section. }
    function  GetAt(Index: Integer): Pointer;
    { Return address of item[i], creating slot if necessary. }
    function  MakeAt(Index: Integer): PPointer;
    { Store item at item[i], creating slot if necessary. }
    procedure PutAt(Index: Integer; Item: Pointer);
  public
    constructor Create(Quantum: TSPAQuantum);
    destructor  Destroy; override;

    { Traverse SPA, calling apply function for each defined non-nil
      item.  The traversal terminates if the apply function returns
      a value other than 0. }
    { NOTE: must be static method so that we can take its address in
      TSparseList.ForAll }
    function  ForAll(ApplyFunction: Pointer {TSPAApply}): Integer;

    { Ratchet down HighBound after a deletion }
    procedure ResetHighBound;

    property HighBound: Integer read FHighBound;
    property SectionSize: Word read FSectionSize;
    property Items[Index: Integer]: Pointer read GetAt write PutAt; default;
  end;

{ TtsvSparseList class }

  TtsvSparseList = class(TObject)
  private
    FList: TSparsePointerArray;
    FCount: Integer;    { 1 + HighBound, adjusted for Insert/Delete }
    FQuantum: TSPAQuantum;
    procedure NewList(Quantum: TSPAQuantum);
  protected
    procedure Error; virtual;
    function  Get(Index: Integer): Pointer;
    procedure Put(Index: Integer; Item: Pointer);
  public
    constructor Create(Quantum: TSPAQuantum);
    destructor  Destroy; override;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    function ForAll(ApplyFunction: Pointer {TSPAApply}): Integer;
    procedure Insert(Index: Integer; Item: Pointer);
    procedure Move(CurIndex, NewIndex: Integer);
    property Count: Integer read FCount;
    property Items[Index: Integer]: Pointer read Get write Put; default;
  end;

{ TStringSparseList class }

  TStringSparseList = class(TStrings)
  private
    FList: TtsvSparseList;                 { of StrItems }
    FOnChange: TNotifyEvent;
  protected
    function  Get(Index: Integer): String; override;
    function  GetCount: Integer; override;
    function  GetObject(Index: Integer): TObject; override;

    procedure Put(Index: Integer; const S: String); override;
    procedure PutObject(Index: Integer; AObject: TObject); override;
    procedure Changed; virtual;
    procedure Error; virtual;
  public
    constructor Create(Quantum: TSPAQuantum);
    destructor  Destroy; override;
    procedure ReadData(Reader: TReader);
    procedure WriteData(Writer: TWriter);
    procedure DefineProperties(Filer: TFiler); override;
    procedure Delete(Index: Integer); override;
    procedure Exchange(Index1, Index2: Integer); override;
    procedure Insert(Index: Integer; const S: String); override;
    procedure Clear; override;
    property List: TtsvSparseList read FList;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

{ TSparsePointerArray }

const
  SPAIndexMask: array[TSPAQuantum] of Byte = (15, 255);
  SPASecShift: array[TSPAQuantum] of Byte = (4, 8);

{ Expand Section Directory to cover at least `newSlots' slots. Returns: Possibly
  updated pointer to the Section Directory. }
function  ExpandDir(secDir: PSecDir; var slotsInDir: Word;
  newSlots: Word): PSecDir;
begin
  Result := secDir;
  ReallocMem(Result, newSlots * SizeOf(Pointer));
  FillChar(Result^[slotsInDir], (newSlots - slotsInDir) * SizeOf(Pointer), 0);
  slotsInDir := newSlots;
end;

{ Allocate a section and set all its items to nil. Returns: Pointer to start of
  section. }
function  MakeSec(SecIndex: Integer; SectionSize: Word): Pointer;
var
  SecP: Pointer;
  Size: Word;
begin
  Size := SectionSize * SizeOf(Pointer);
  GetMem(secP, size);
  FillChar(secP^, size, 0);
  MakeSec := SecP
end;

constructor TSparsePointerArray.Create(Quantum: TSPAQuantum);
begin
  SecDir := nil;
  SlotsInDir := 0;
  FHighBound := -1;
  FSectionSize := Word(SPAIndexMask[Quantum]) + 1;
  IndexMask := Word(SPAIndexMask[Quantum]);
  SecShift := Word(SPASecShift[Quantum]);
  CachedIndex := -1
end;

destructor TSparsePointerArray.Destroy;
var
  i:  Integer;
  size: Word;
begin
  { Scan section directory and free each section that exists. }
  i := 0;
  size := FSectionSize * SizeOf(Pointer);
  while i < slotsInDir do begin
    if secDir^[i] <> nil then
      FreeMem(secDir^[i], size);
    Inc(i)
  end;

  { Free section directory. }
  if secDir <> nil then
    FreeMem(secDir, slotsInDir * SizeOf(Pointer));
end;

function  TSparsePointerArray.GetAt(Index: Integer): Pointer;
var
  byteP: PChar;
  secIndex: Cardinal;
begin
  { Index into Section Directory using high order part of
    index.  Get pointer to Section. If not null, index into
    Section using low order part of index. }
  if Index = cachedIndex then
    Result := cachedPointer
  else begin
    secIndex := Index shr secShift;
    if secIndex >= slotsInDir then
      byteP := nil
    else begin
      byteP := secDir^[secIndex];
      if byteP <> nil then begin
        Inc(byteP, (Index and indexMask) * SizeOf(Pointer));
      end
    end;
    if byteP = nil then Result := nil else Result := PPointer(byteP)^;
    cachedIndex := Index;
    cachedPointer := Result
  end
end;

function  TSparsePointerArray.MakeAt(Index: Integer): PPointer;
var
  dirP: PSecDir;
  p: Pointer;
  byteP: PChar;
  secIndex: Word;
begin
  { Expand Section Directory if necessary. }
  secIndex := Index shr secShift;       { Unsigned shift }
  if secIndex >= slotsInDir then
    dirP := expandDir(secDir, slotsInDir, secIndex + 1)
  else
    dirP := secDir;

  { Index into Section Directory using high order part of
    index.  Get pointer to Section. If null, create new
    Section.  Index into Section using low order part of index. }
  secDir := dirP;
  p := dirP^[secIndex];
  if p = nil then begin
    p := makeSec(secIndex, FSectionSize);
    dirP^[secIndex] := p
  end;
  byteP := p;
  Inc(byteP, (Index and indexMask) * SizeOf(Pointer));
  if Index > FHighBound then
    FHighBound := Index;
  Result := PPointer(byteP);
  cachedIndex := -1
end;

procedure TSparsePointerArray.PutAt(Index: Integer; Item: Pointer);
begin
  if (Item <> nil) or (GetAt(Index) <> nil) then
  begin
    MakeAt(Index)^ := Item;
    if Item = nil then
      ResetHighBound
  end
end;

function  TSparsePointerArray.ForAll(ApplyFunction: Pointer {TSPAApply}):
  Integer;
var
  itemP: PChar;                         { Pointer to item in section }
  item: Pointer;
  i, callerBP: Cardinal;
  j, index: Integer;
begin
  { Scan section directory and scan each section that exists,
    calling the apply function for each non-nil item.
    The apply function must be a far local function in the scope of
    the procedure P calling ForAll.  The trick of setting up the stack
    frame (taken from TurboVision's TCollection.ForEach) allows the
    apply function access to P's arguments and local variables and,
    if P is a method, the instance variables and methods of P's class }
  Result := 0;
  i := 0;
  asm
    mov   eax,[ebp]                     { Set up stack frame for local }
    mov   callerBP,eax
  end;
  while (i < slotsInDir) and (Result = 0) do begin
    itemP := secDir^[i];
    if itemP <> nil then begin
      j := 0;
      index := i shl SecShift;
      while (j < FSectionSize) and (Result = 0) do begin
        item := PPointer(itemP)^;
        if item <> nil then
          { ret := ApplyFunction(index, item.Ptr); }
          asm
            mov   eax,index
            mov   edx,item
            push  callerBP
            call  ApplyFunction
            pop   ecx
            mov   @Result,eax
          end;
        Inc(itemP, SizeOf(Pointer));
        Inc(j);
        Inc(index)
      end
    end;
    Inc(i)
  end;
end;

procedure TSparsePointerArray.ResetHighBound;
var
  NewHighBound: Integer;

  function  Detector(TheIndex: Integer; TheItem: Pointer): Integer; far;
  begin
    if TheIndex > FHighBound then
      Result := 1
    else
    begin
      Result := 0;
      if TheItem <> nil then NewHighBound := TheIndex
    end
  end;

begin
  NewHighBound := -1;
  ForAll(@Detector);
  FHighBound := NewHighBound
end;

{ TtsvSparseList }

constructor TtsvSparseList.Create(Quantum: TSPAQuantum);
begin
  NewList(Quantum)
end;

destructor TtsvSparseList.Destroy;
begin
  if FList <> nil then FList.Destroy
end;


procedure TtsvSparseList.Clear;
begin
  FList.Destroy;
  NewList(FQuantum);
  FCount := 0
end;

procedure TtsvSparseList.Delete(Index: Integer);
var
  I: Integer;
begin
  if (Index < 0) or (Index >= FCount) then Exit;
  for I := Index to FCount - 1 do
    FList[I] := FList[I + 1];
  FList[FCount] := nil;
  Dec(FCount);
end;

procedure TtsvSparseList.Error;
begin
  raise EListError.Create(SListIndexError);
end;

procedure TtsvSparseList.Exchange(Index1, Index2: Integer);
var
  temp: Pointer;
begin
  temp := Get(Index1);
  Put(Index1, Get(Index2));
  Put(Index2, temp);
end;

{ Jump to TSparsePointerArray.ForAll so that it looks like it was called
  from our caller, so that the BP trick works. }

function TtsvSparseList.ForAll(ApplyFunction: Pointer {TSPAApply}): Integer; assembler;
asm
        MOV     EAX,[EAX].TtsvSparseList.FList
        JMP     TSparsePointerArray.ForAll
end;

function  TtsvSparseList.Get(Index: Integer): Pointer;
begin
  Result:=nil;
  if Index < 0 then exit;
//  error;
  Result := FList[Index]
end;

procedure TtsvSparseList.Insert(Index: Integer; Item: Pointer);
var
  i: Integer;
begin
  if Index < 0 then Error;
  I := FCount;
  while I > Index do
  begin
    FList[i] := FList[i - 1];
    Dec(i)
  end;
  FList[Index] := Item;
  if Index > FCount then FCount := Index;
  Inc(FCount)
end;

procedure TtsvSparseList.Move(CurIndex, NewIndex: Integer);
var
  Item: Pointer;
begin
  if CurIndex <> NewIndex then
  begin
    Item := Get(CurIndex);
    Delete(CurIndex);
    Insert(NewIndex, Item);
  end;
end;

procedure TtsvSparseList.NewList(Quantum: TSPAQuantum);
begin
  FQuantum := Quantum;
  FList := TSparsePointerArray.Create(Quantum)
end;

procedure TtsvSparseList.Put(Index: Integer; Item: Pointer);
begin
  if Index < 0 then Error;
  FList[Index] := Item;
  FCount := FList.HighBound + 1
end;

{ TStringSparseList }

constructor TStringSparseList.Create(Quantum: TSPAQuantum);
begin
  FList := TtsvSparseList.Create(Quantum)
end;

destructor  TStringSparseList.Destroy;
begin
  if FList <> nil then begin
    Clear;
    FList.Destroy
  end
end;

procedure TStringSparseList.ReadData(Reader: TReader);
var
  i: Integer;
begin
  with Reader do begin
    i := Integer(ReadInteger);
    while i > 0 do begin
      InsertObject(Integer(ReadInteger), ReadString, nil);
      Dec(i)
    end
  end
end;

procedure TStringSparseList.WriteData(Writer: TWriter);
var
  itemCount: Integer;

  function  CountItem(TheIndex: Integer; TheItem: Pointer): Integer; far;
  begin
    Inc(itemCount);
    Result := 0
  end;

  function  StoreItem(TheIndex: Integer; TheItem: Pointer): Integer; far;
  begin
    with Writer do
    begin
      WriteInteger(TheIndex);           { Item index }
      WriteString(PStrItem(TheItem)^.FString);
    end;
    Result := 0
  end;

begin
  with Writer do
  begin
    itemCount := 0;
    FList.ForAll(@CountItem);
    WriteInteger(itemCount);
    FList.ForAll(@StoreItem);
  end
end;

procedure TStringSparseList.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('List', ReadData, WriteData, True);
end;

function  TStringSparseList.Get(Index: Integer): String;
var
  p: PStrItem;
begin
  p := PStrItem(FList[Index]);
  if p = nil then Result := '' else Result := p^.FString
end;

function  TStringSparseList.GetCount: Integer;
begin
  Result := FList.Count
end;

function  TStringSparseList.GetObject(Index: Integer): TObject;
var
  p: PStrItem;
begin
  p := PStrItem(FList[Index]);
  if p = nil then Result := nil else Result := p^.FObject
end;


procedure TStringSparseList.Put(Index: Integer; const S: String);
var
  p: PStrItem;
  obj: TObject;
begin
  p := PStrItem(FList[Index]);
  if p = nil then obj := nil else obj := p^.FObject;
  if (S = '') and (obj = nil) then   { Nothing left to store }
    FList[Index] := nil
  else
    FList[Index] := NewStrItem(S, obj);
  if p <> nil then DisposeStrItem(p);
  Changed
end;

procedure TStringSparseList.PutObject(Index: Integer; AObject: TObject);
var
  p: PStrItem;
begin
  p := PStrItem(FList[Index]);
  if p <> nil then
    p^.FObject := AObject
  else if AObject <> nil then
    FList[Index] := NewStrItem('',AObject);
  Changed
end;

procedure TStringSparseList.Changed;
begin
  if Assigned(FOnChange) then FOnChange(Self)
end;

procedure TStringSparseList.Error;
begin
  raise EStringSparseListError.Create(SPutObjectError);
end;

procedure TStringSparseList.Delete(Index: Integer);
var
  p: PStrItem;
begin
  p := PStrItem(FList[Index]);
  if p <> nil then DisposeStrItem(p);
  FList.Delete(Index);
  Changed
end;

procedure TStringSparseList.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange(Index1, Index2);
end;

procedure TStringSparseList.Insert(Index: Integer; const S: String);
begin
  FList.Insert(Index, NewStrItem(S, nil));
  Changed
end;

procedure TStringSparseList.Clear;

  function  ClearItem(TheIndex: Integer; TheItem: Pointer): Integer; far;
  begin
    DisposeStrItem(PStrItem(TheItem));    { Item guaranteed non-nil }
    Result := 0
  end;

begin
  FList.ForAll(@ClearItem);
  FList.Clear;
  Changed
end;

{ TtsvStringGridStrings }

{ AIndex < 0 is a column (for column -AIndex - 1)
  AIndex > 0 is a row (for row AIndex - 1)
  AIndex = 0 denotes an empty row or column }

constructor TtsvStringGridStrings.Create(AGrid: TtsvStringGrid; AIndex: Longint);
begin
  inherited Create;
  FGrid := AGrid;
  FIndex := AIndex;
end;

procedure TtsvStringGridStrings.Assign(Source: TPersistent);
var
  I, Max: Integer;
begin
  if Source is TStrings then
  begin
    BeginUpdate;
    Max := TStrings(Source).Count - 1;
    if Max >= Count then Max := Count - 1;
    try
      for I := 0 to Max do
      begin
        Put(I, TStrings(Source).Strings[I]);
        PutObject(I, TStrings(Source).Objects[I]);
      end;
    finally
      EndUpdate;
    end;
    Exit;
  end;
  inherited Assign(Source);
end;

procedure TtsvStringGridStrings.CalcXY(Index: Integer; var X, Y: Integer);
begin
  if FIndex = 0 then
  begin
    X := -1; Y := -1;
  end else if FIndex > 0 then
  begin
    X := Index;
    Y := FIndex - 1;
  end else
  begin
    X := -FIndex - 1;
    Y := Index;
  end;
end;

{ Changes the meaning of Add to mean copy to the first empty string }
function TtsvStringGridStrings.Add(const S: string): Integer;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Strings[I] = '' then
    begin
      Strings[I] := S;
      Result := I;
      Exit;
    end;
  Result := -1;
end;

procedure TtsvStringGridStrings.Clear;
var
  SSList: TStringSparseList;
  I: Integer;

  function BlankStr(TheIndex: Integer; TheItem: Pointer): Integer; far;
  begin
    Objects[TheIndex] := nil;
    Strings[TheIndex] := '';
    Result := 0;
  end;

begin
  if FIndex > 0 then
  begin
    SSList := TStringSparseList(TtsvSparseList(FGrid.FData)[FIndex - 1]);
    if SSList <> nil then SSList.List.ForAll(@BlankStr);
  end
  else if FIndex < 0 then
    for I := Count - 1 downto 0 do
    begin
      Objects[I] := nil;
      Strings[I] := '';
    end;
end;

procedure TtsvStringGridStrings.Delete(Index: Integer);
begin
  InvalidOp(sInvalidStringGridOp);
end;

function TtsvStringGridStrings.Get(Index: Integer): string;
var
  X, Y: Integer;
begin
  CalcXY(Index, X, Y);
  if X < 0 then Result := '' else Result := FGrid.Cells[X, Y];
end;

function TtsvStringGridStrings.GetCount: Integer;
begin
  { Count of a row is the column count, and vice versa }
  if FIndex = 0 then Result := 0
  else if FIndex > 0 then Result := Integer(FGrid.ColCount)
  else Result := Integer(FGrid.RowCount);
end;

function TtsvStringGridStrings.GetObject(Index: Integer): TObject;
var
  X, Y: Integer;
begin
  CalcXY(Index, X, Y);
  if X < 0 then Result := nil else Result := FGrid.Objects[X, Y];
end;

procedure TtsvStringGridStrings.Insert(Index: Integer; const S: string);
begin
  InvalidOp(sInvalidStringGridOp);
end;

procedure TtsvStringGridStrings.Put(Index: Integer; const S: string);
var
  X, Y: Integer;
begin
  CalcXY(Index, X, Y);
  FGrid.Cells[X, Y] := S;
end;

procedure TtsvStringGridStrings.PutObject(Index: Integer; AObject: TObject);
var
  X, Y: Integer;
begin
  CalcXY(Index, X, Y);
  FGrid.Objects[X, Y] := AObject;
end;

procedure TtsvStringGridStrings.SetUpdateState(Updating: Boolean);
begin
  FGrid.SetUpdateState(Updating);
end;

{ TtsvStringGrid }

constructor TtsvStringGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Initialize;
  FixedCols:=1;
  FSorted:=false;
  RowCount:=0;
  ColCount:=2;
  FixedRows:=0;
  Color:=clBtnface;
  DefaultRowHeight:=16;
  Options:=[goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine,{goRowMoving,}
  goEditing, goTabs, goAlwaysShowEditor, goColSizing,goThumbTracking];
end;

destructor TtsvStringGrid.Destroy;
  function FreeItem(TheIndex: Integer; TheItem: Pointer): Integer; far;
  begin
    TObject(TheItem).Free;
    Result := 0;
  end;

begin
  if FRows <> nil then
  begin
    TtsvSparseList(FRows).ForAll(@FreeItem);
    TtsvSparseList(FRows).Free;
  end;
  if FCols <> nil then
  begin
    TtsvSparseList(FCols).ForAll(@FreeItem);
    TtsvSparseList(FCols).Free;
  end;
  if FData <> nil then
  begin
    TtsvSparseList(FData).ForAll(@FreeItem);
    TtsvSparseList(FData).Free;
  end;
  inherited Destroy;
end;

procedure TtsvStringGrid.SetSorted(Value: Boolean);
begin
  if FSorted <> Value then
  begin
    if Value then Sort;
    FSorted := Value;
  end;
end;

procedure TtsvStringGrid.Sort;
begin
  if not Sorted and (RowCount > 1) then
  begin
    QuickSort(0, RowCount-1);
  end;
end;

procedure TtsvStringGrid.QuickSort(L, R: Integer);
var
  I, J: Integer;
  P,str,str1: string;
  ch,chp:char;
begin
  repeat
    I := L;
    J := R;
    P :=DelChars(Cells[0,(L+R) shr 1],' ');
      IF Length(P)<>0 then begin
       chp:=P[1];
       if (chp='+')or(chp='-')then Delete(P,1,1)
      end;

    repeat
        str:=DelChars(Cells[0,i],' ');
        IF Length(str)<>0 then begin
          ch:=str[1];
          if (ch='+')or(Ch='-')then begin
           Delete(str,1,1);
          end;
        end;
        str1:=DelChars(Cells[0,j],' ');
        IF Length(str1)<>0 then begin
          ch:=str1[1];
          if (ch='+')or(Ch='-')then begin
           Delete(str1,1,1);
          end;
        end;

      while AnsiCompareText(str,P) < 0 do begin
        Inc(I);
        str:=DelChars(Cells[0,I],' ');
        IF Length(str)<>0 then begin
          ch:=str[1];
          if (ch='+')or(Ch='-')then begin
           Delete(str,1,1);
          end;
        end;
      end;
      while AnsiCompareText(str1,P) > 0 do begin
       Dec(J);
       str1:=DelChars(Cells[0,J],' ');
        IF Length(str1)<>0 then begin
          ch:=str1[1];
          if (ch='+')or(Ch='-')then begin
           Delete(str1,1,1);
          end;
        end;
      end;
      if I <= J then
      begin
        ExchangeItems(I, J);
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    L := I;
  until I >= R;
end;

procedure TtsvStringGrid.ExchangeItems(Index1, Index2: Integer);
var
  Temp: string;
  TmpO:TObject;
  i:integer;
  str:string;
begin
  for i:=0 to ColCount-1 do begin
    str:=Cells[i,Index1];
    Temp:=str;
    Cells[i,Index1]:=Cells[i,Index2];
    Cells[i,Index2]:=Temp;
    TmpO:=Objects[i,index1];
    Objects[i,Index1]:=Objects[i,Index2];
    Objects[i,Index2]:=TmpO;
  end;
end;

procedure TtsvStringGrid.ColumnMoved(FromIndex, ToIndex: Longint);

  function MoveColData(Index: Integer; ARow: TStringSparseList): Integer; far;
  begin
    ARow.Move(FromIndex, ToIndex);
    Result := 0;
  end;

begin
  TtsvSparseList(FData).ForAll(@MoveColData);
  Invalidate;
  inherited ColumnMoved(FromIndex, ToIndex);
end;

procedure TtsvStringGrid.RowMoved(FromIndex, ToIndex: Longint);
begin
  TtsvSparseList(FData).Move(FromIndex, ToIndex);
  Invalidate;
  inherited RowMoved(FromIndex, ToIndex);
end;

function TtsvStringGrid.GetEditText(ACol, ARow: Longint): string;
begin
  Result := Cells[ACol, ARow];
  if Assigned(FOnGetEditText) then FOnGetEditText(Self, ACol, ARow, Result);
end;

procedure TtsvStringGrid.SetEditText(ACol, ARow: Longint; const Value: string);
begin
  DisableEditUpdate;
  try
    if Value <> Cells[ACol, ARow] then Cells[ACol, ARow] := Value;
  finally
    EnableEditUpdate;
  end;
  inherited SetEditText(ACol, ARow, Value);
end;

procedure TtsvStringGrid.DrawCell(ACol, ARow: Longint; ARect: TRect;
  AState: TGridDrawState);

  procedure DrawCellText;
  var
    S: string;
    temprect:trect;
  begin
    if ACol<0 then ACol:=0;
    if ARow<0 then ARow:=0;
    S := Cells[ACol, ARow];
    if ACol=ColCount-1 then Canvas.Font.Color:=clActiveCaption;
    temprect:=Cellrect(0,ARow);
    if (ACol=0) and (ARow=Row)then begin
//      Canvas.Font.Color:=clActiveCaption;
{      Canvas.Brush.Style:=bsSolid;
      Canvas.Brush.Color:=clBlack;}
//      Canvas.FillRect();
      Canvas.Font.Color:=clBlue;
      Canvas.Font.Style:=[];
      Canvas.Brush.Style:=bsSolid;
      Canvas.Fillrect(temprect);
    end;
    if FRowCount<>0 then begin

     ExtTextOut(Canvas.Handle, ARect.Left + 2, ARect.Top + 2, ETO_CLIPPED or
      ETO_OPAQUE, @ARect, PChar(S), Length(S), nil);
    end;
////////////////
    DrawEdge(Canvas.Handle, TempRect, BDR_SUNKENOUTER, BF_RIGHT);
 {   temprect:=Cellrect(0,Row);
    temprect.Right:=temprect.Right+Cellrect(Col,Row).Right;
    temprect.Top:=temprect.Top-1;
    temprect.Bottom:=temprect.Bottom+1;
    DrawEdge(Canvas.Handle, TempRect,EDGE_SUNKEN,BF_TOP);
    DrawEdge(Canvas.Handle, TempRect,EDGE_SUNKEN, BF_BOTTOM);}
  end;

begin
  inherited DrawCell(ACol, ARow, ARect, AState);
  if DefaultDrawing then DrawCellText;
end;

procedure TtsvStringGrid.DisableEditUpdate;
begin
  Inc(FEditUpdate);
end;

procedure TtsvStringGrid.EnableEditUpdate;
begin
  Dec(FEditUpdate);
end;

procedure TtsvStringGrid.Initialize;
var
  quantum: TSPAQuantum;
begin
  if FCols = nil then
  begin
    if ColCount > 512 then quantum := SPALarge else quantum := SPASmall;
    FCols := TtsvSparseList.Create(quantum);
  end;
  if RowCount > 256 then quantum := SPALarge else quantum := SPASmall;
  if FRows = nil then FRows := TtsvSparseList.Create(quantum);
  if FData = nil then FData := TtsvSparseList.Create(quantum);
end;

procedure TtsvStringGrid.SetUpdateState(Updating: Boolean);
begin
  FUpdating := Updating;
  if not Updating and FNeedsUpdating then
  begin
    InvalidateGrid;
    FNeedsUpdating := False;
  end;
end;

procedure TtsvStringGrid.Update(ACol, ARow: Integer);
begin
  if not FUpdating then InvalidateCell(ACol, ARow)
  else FNeedsUpdating := True;
  if (ACol = Col) and (ARow = Row) and (FEditUpdate = 0) then InvalidateEditor;
end;

function  TtsvStringGrid.EnsureColRow(Index: Integer; IsCol: Boolean):
  TtsvStringGridStrings;
var
  RCIndex: Integer;
  PList: ^TtsvSparseList;
begin
  if IsCol then PList := @FCols else PList := @FRows;
  Result := TtsvStringGridStrings(PList^[Index]);
  if Result = nil then
  begin
    if IsCol then RCIndex := -Index - 1 else RCIndex := Index + 1;
    Result := TtsvStringGridStrings.Create(Self, RCIndex);
    PList^[Index] := Result;
  end;
end;

function  TtsvStringGrid.EnsureDataRow(ARow: Integer): Pointer;
var
  quantum: TSPAQuantum;
begin
  Result := TStringSparseList(TtsvSparseList(FData)[ARow]);
  if Result = nil then
  begin
    if ColCount > 512 then quantum := SPALarge else quantum := SPASmall;
    Result := TStringSparseList.Create(quantum);
    TtsvSparseList(FData)[ARow] := Result;
  end;
end;

function TtsvStringGrid.GetCells(ACol, ARow: Integer): string;
var
  ssl: TStringSparseList;
begin
  if RowCount<>0 then begin
   ssl := TStringSparseList(TtsvSparseList(FData)[ARow]);
   if ssl = nil then Result := '' else Result := ssl[ACol];
  end; 
end;

function TtsvStringGrid.GetCols(Index: Integer): TStrings;
begin
  Result := EnsureColRow(Index, True);
end;

function TtsvStringGrid.GetObjects(ACol, ARow: Integer): TObject;
var
  ssl: TStringSparseList;
begin
 Result:=nil; 
 if RowCount<>0 then begin
  ssl := TStringSparseList(TtsvSparseList(FData)[ARow]);
  if ssl = nil then Result := nil else Result := ssl.Objects[ACol];
 end; 
end;

function TtsvStringGrid.GetRows(Index: Integer): TStrings;
begin
  Result := EnsureColRow(Index, False);
end;

procedure TtsvStringGrid.SetCells(ACol, ARow: Integer; const Value: string);
begin
  TtsvStringGridStrings(EnsureDataRow(ARow))[ACol] := Value;
  EnsureColRow(ACol, True);
  EnsureColRow(ARow, False);
  Update(ACol, ARow);
end;

procedure TtsvStringGrid.SetCols(Index: Integer; Value: TStrings);
begin
  EnsureColRow(Index, True).Assign(Value);
end;

procedure TtsvStringGrid.SetObjects(ACol, ARow: Integer; Value: TObject);
begin
  TtsvStringGridStrings(EnsureDataRow(ARow)).Objects[ACol] := Value;
  EnsureColRow(ACol, True);
  EnsureColRow(ARow, False);
  Update(ACol, ARow);
end;

procedure TtsvStringGrid.SetRows(Index: Integer; Value: TStrings);
begin
  EnsureColRow(Index, False).Assign(Value);
end;

{TtsvList}

procedure TtsvList.SetInspector(Value: TtsvPnlInspector);
begin
   FInspector := Value;
end;

procedure TtsvList.ListMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   SetItem;
end;

procedure TtsvList.ListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
      VK_RETURN: begin
         SetItem;
      end;
      VK_ESCAPE: FInspector.FfmList.Close;
  end;
end;

procedure TtsvList.SetItem;
var
  tmpG:TtsvStringGrid;
begin
  if ItemIndex<>-1 then begin
    if FInspector.Page.ActivePage=FInspector.TSProp then
       tmpG:=FInspector.GridP
    else tmpG:=FInspector.GridE;
  tmpG.InplaceEditor.Text:=Items.Strings[ItemIndex];
  FInspector.UpdateTypeInfo;
  FInspector.fmList.Visible:=false;
  end;
end;

procedure TtsvList.ListDrawItem(Control: TWinControl;  Index: Integer;
                             Rect: TRect; State: TOwnerDrawState);

  procedure DRawListColor;
  var
    tmps: string;
    rc: TRect;
    cl: TColor;
  begin
    tmps:=Items.Strings[Index];
    cl:=StringToColor(tmps);
    rc.TopLeft:=Rect.TopLeft;
    rc.BottomRight:=Rect.BottomRight;
    rc.Right:=rc.Left+16;
    with Canvas do begin
     Brush.Style:=bsClear;
     Brush.Color:=clWindow;
     FillRect(Rect);
     if State<>[odFocused,odSelected] then begin
      Brush.Style:=bsSolid;
      Brush.Color:=cl;
      inflateRect(rc,-1,-1);
      Rectangle(rc);
      Brush.Style:=bsClear;
      TextOut(rc.Right+1,rc.Top,tmps);
     end else begin
      Brush.Style:=bsSolid;
      Brush.Color:=clHighlight;
      Font.Color:=clHighlightText;
      FillRect(rect);
      Brush.Color:=cl;
      inflateRect(rc,-1,-1);
      Rectangle(rc);
      Brush.Style:=bsClear;
      TextOut(rc.Right+1,rc.Top,tmps);
     end;
    end;
  end;

  procedure DrawDefaultText;
  var
    tmps: string;
  begin
    tmps:=Items.Strings[Index];
    with Canvas do begin
     Brush.Style:=bsClear;
     Brush.Color:=clWindow;
     FillRect(Rect);
     if State<>[odFocused,odSelected] then begin
      Brush.Style:=bsClear;
      TextOut(Rect.Left+1,Rect.Top,tmps);
     end else begin
      Brush.Style:=bsSolid;
      Brush.Color:=clHighlight;
      Font.Color:=clHighlightText;
      FillRect(rect);
      Brush.Style:=bsClear;
      TextOut(Rect.Left+1,Rect.Top,tmps);
     end;
    end;
  end;

  procedure DrawListCursor;
  var
    tmps: string;
    rc: TRect;
    t: Integer;
  begin
    tmps:=Items.Strings[Index];
    rc.TopLeft:=Rect.TopLeft;
    rc.BottomRight:=Rect.BottomRight;
    rc.Left:=rc.Left+1;
    rc.Right:=rc.Left+32;
    with Canvas do begin
     Brush.Style:=bsClear;
     Brush.Color:=clWindow;
     FillRect(Rect);
     if State<>[odFocused,odSelected] then begin
      Brush.Style:=bsSolid;
      FInspector.FListCursorImages.Draw(Canvas,rc.Left,rc.Top,Index);
      Brush.Style:=bsClear;
      t:=(rc.Bottom-rc.Top)div 2 -(TextHeight(tmps) div 2);
      t:=rc.top+t;
      TextOut(rc.Right+1,t,tmps);
     end else begin
      Brush.Style:=bsSolid;
      Brush.Color:=clHighlight;
      Font.Color:=clHighlightText;
      FillRect(rect);
      FInspector.FListCursorImages.DrawOverlay(Canvas,rc.Left,rc.Top,Index,1);
      Brush.Style:=bsClear;
      t:=(rc.Bottom-rc.Top)div 2 -(TextHeight(tmps) div 2);
      t:=rc.top+t;
      TextOut(rc.Right+1,t,tmps);
     end;
    end;
  end;
  
var
  PTI: PTypeInfo;
  tmpG:TtsvStringgrid;
  PSG: PStructGrid;
begin
  if FInspector.Page.ActivePage=FInspector.TSProp then tmpG:=FInspector.GridP
  else tmpG:=FInspector.GridE;
  PSG:=Pointer(tmpG.Objects[0,tmpG.Row]);
  PTI:=PSG.PTI;
  if PTI<>nil then begin
    if PTI=TypeInfo(TColor) then DRawListColor
    else if PTI=TypeInfo(TCursor) then DrawListCursor
    else DrawDefaultText;

  end;
end;

{TtsvCombo}

Constructor TtsvCombo.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  OnKeyDown:=ComboKeyDown;
  OnChange:=ComboClick;
  FStatus:=true;
end;

procedure TtsvCombo.SetInspector(Value: TtsvPnlInspector);
begin
   FInspector := Value;
end;

procedure TtsvCombo.ComboKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
 case Key of
  VK_RETURN: begin
    GoUpdate;
    FStatus:=true;
  end;
  VK_UP,VK_DOWN,VK_HOME,VK_END,VK_PRIOR, VK_NEXT:begin
    FStatus:=false;
  end;
 end;
end;

procedure TtsvCombo.ComboClick(Sender: TObject);
begin
    if not FStatus then exit;
    GoUpdate;
end;

procedure TtsvCombo.ComboMouseDown(Sender: TObject;
                Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if not DroppedDown then DroppedDown:=true
   else FStatus:=true;
end;

procedure TtsvCombo.GoUpdate;
var
   ct: TComponent;
begin
  if ItemIndex<>-1 then begin
    ct:=TComponent(Items.Objects[ItemIndex]);
    if (ct=nil)or(ItemIndex=-1) then exit;
    FInspector.ValueObj:=ct;
    FInspector.UpdateInspector(ct);
    if Finspector.Parent.Visible then
     if FInspector.Page.ActivePage=FInspector.FTSProp then begin
      FInspector.gridP.SetFocus;
     end else FInspector.gridE.SetFocus;
  end;   
end;

{TtsvPnlInspector}

constructor TtsvPnlInspector.Create(AOwner: TComponent);
var
   i,j,k,l:Integer;
   ct,ctM: TComponent;
   fmM: TForm;
   PPI:PpropInfo;
   PL:PPropList;
   PTD:PTypeData;
   PTM:TMethod;
   isCode:boolean;
begin
  Inherited Create(AOwner);
  ParentFont:=False;
  ParentColor:=False;
  Height:=360;
  Width:=250;
  Color:=clBtnFace;
//  ShowHint:=true;
  Parent:=AOwner as TWincontrol;
  FLanguage:=lgRussian;
  ListRus:=TStringList.Create;
  ListEng:=TStringList.Create;
  ListLang:=TStringList.Create;
  ListInfo:=TStringLIst.Create;
  SetTranslateForCreate;

  FTableMethod:=TStringList.Create;
  FTableMethodPPI:=TStringList.Create;

  FLabel:=Tlabel.Create(Self);
  FLabel.Parent:=Self;
  FLabel.Align:=alTop;
  FLabel.Alignment:=taCenter;
  FLabel.Font.Style:=[fsBold];
  FLabel.Width:=FLabel.Width+5;

  FCombo:=TtsvCombo.Create(Self);
  FCombo.Parent:=Self;
  FCombo.Align:=alTop;
  FCombo.Style:=csDropDownList;
  FCombo.Clear;

///////////////////
  for i:=0 to Application.ComponentCount-1 do begin
      if Application.Components[i].ClassType<>THintWindow then begin
       ctM:=Application.Components[i];
       FCombo.Items.AddObject(ctM.Name,ctM);
       PTD:=GetTypeData(ctM.ClassInfo);
       GetMem(PL,Sizeof(PPropInfo)*PTD.PropCount);
       GetPropInfos(ctM.ClassInfo,PL);
       for k:=0 to PTD.PropCount-1 do begin
           if PL[k]^.PropType^.Kind=tkMethod then begin
             PTM:=GetMethodProp(ctM,PL[k]);
             if (PTM.Code<>nil) and(ctM.MethodName(PTM.Code)<>'')then begin
                  isCode:=false;
                  for l:=0 to FTableMethod.Count-1 do begin
                    if PTM.Code=FTableMethod.Objects[l] then begin
                      isCode:=true;
                      Break;
                    end else isCode:=false;
                  end;
                  if not isCode then begin
                      FTableMethod.AddObject(ctM.Name+'.'+ctm.MethodName(PTM.Code),PTM.Code);
                      FTableMethodPPI.AddObject(ctM.Name+'.'+ctm.MethodName(PTM.Code),Pointer(PL[k]));
                  end;
             end;
           end;
       end;
       FreeMem(PL,Sizeof(PPropInfo)*PTD.PropCount);
       for j:=0 to ctM.ComponentCount-1 do begin
         ct:=ctM.Components[j];
         FCombo.Items.AddObject(ctM.Name+' - '+ct.Name,ct);
         PTD:=GetTypeData(ct.ClassInfo);
         GetMem(PL,Sizeof(PPropInfo)*PTD.PropCount);
         GetPropInfos(ct.ClassInfo,PL);
         for k:=0 to PTD.PropCount-1 do begin
             if PL[k]^.PropType^.Kind=tkMethod then begin
               PTM:=GetMethodProp(ct,PL[k]);
               if (PTM.Code<>nil) and(ctM.MethodName(PTM.Code)<>'')then begin
                  isCode:=false;
                  for l:=0 to FTableMethod.Count-1 do begin
                    if PTM.Code=FTableMethod.Objects[l] then begin
                      isCode:=true;
                      Break;
                    end else isCode:=false;
                  end;
                  if not isCode then begin
                     FTableMethod.AddObject(ctM.Name+'.'+ctM.MethodName(PTM.Code),PTM.Code);
                     FTableMethodPPI.AddObject(ctM.Name+'.'+ctM.MethodName(PTM.Code),Pointer(PL[k]));
                  end;     
               end;
             end;
         end;
         FreeMem(PL,Sizeof(PPropInfo)*PTD.PropCount);
       end;
      end;
  end;
  FCombo.SetInspector(Self);


  FPage:=TPageControl.Create(AOwner);
  FPage.Parent:=Self;
  FPage.Align:=alClient;

  FTSProp:=TTabSheet.Create(AOwner);
  FTSProp.Caption:='Свойства';
  FTSProp.PageControl:=FPage;
  FTSEven:=TTabSheet.Create(AOwner);
  FTSEven.Caption:='События';
  FTSEven.PageControl:=FPage;

  FGridP:=TtsvStringGrid.Create(Self);
  FGridP.parent:=FTSProp;
  FGridP.Align:=alClient;
  FGridP.ColWidths[0]:=Width div 3;
  FGridP.SetInspector(Self);
  FGridP.Button.OnClick:=ButtonDClick;
  FGridP.OnDblClick:=GridPDblClick;
  FGridP.OnSelectCell:=GridPOnSelectCell;

  FGridE:=TtsvStringGrid.Create(Self);
  FGridE.parent:=FTSEven;
  FGridE.Align:=alClient;
  FGridE.ColWidths[0]:=Width div 3;
  FGridE.SetInspector(Self);
  FGridE.Button.OnClick:=ButtonDClick;


  FfmList:=TForm.CreateNew(Self);
  FfmList.BorderStyle:=bsNone;
  FfmList.AutoScroll:=false;
  FfmList.FormStyle:=fsStayOnTop;
  FfmList.Height:=50;
  FfmList.Width:=50;
  FfmList.Visible:=false;

  FList:=TtsvList.Create(Self);
  FList.Parent:=FfmList;
  FList.Ctl3D:=false;
  FList.Align:=alClient;
  FList.Style:=lbOwnerDrawFixed;
  FList.SetInspector(Self);
  FList.OnMouseUp:=FList.ListMouseUp;
  FList.OnKeyDown:=FList.ListKeyDown;
  FList.OnDrawItem:=FList.ListDrawItem;
  FList.DefItemHeight:=FList.ItemHeight;

  FFilterItems:= TStringList.Create;
  FFilter:=true;
  SetFilterForCreate;

  FUncoveredList:=TStringList.Create;
  FillUncoveredProperty;

  FListCursorImages:=TImageList.Create(Self);
  FillListCursorImages;
end;

procedure TtsvPnlInspector.FillUncoveredProperty;
begin
  with FUncoveredList do begin
    Clear;
    Add('TDateTimeColors');
    Add('TFont');
    Add('TBrush');
    Add('TPen');
    Add('TControlScrollBar');
    Add('TTPDStateColors');
    Add('TCriticalValues');
    Add('TLabelState');
    Add('TSizeConstraints');
    Add('TMonthCalColors');
  end;
end;

destructor TtsvPnlInspector.Destroy;
begin
  ListRus.Free;
  ListEng.Free;
  ListLang.Free;
  ListInfo.Free;
  FFilterItems.Free;
  FList.Free;
  FfmList.Free;
  FCombo.Free;
  FGridP.Free;
  if FGridE<>nil then
   FGridE.Free;
  FTSProp.Free;
  if FTSEven<>nil then
    FTSEven.Free;
  FPage.Free;
  FTableMethod.Free;
  FTableMethodPPI.Free;
  FUncoveredList.free;
  FListCursorImages.Free;
  FFilterItems:=nil;
  FList:=nil;
  FfmList:=nil;
  FCombo:=nil;
  FGridP:=nil;
  FGridE:=nil;
  FTSProp:=nil;
  FTSEven:=nil;
  FPage:=nil;
  FTableMethod:=nil;
  FTableMethodPPI:=nil;
  inherited Destroy;
end;

procedure TtsvPnlInspector.ButtonDClick(Sender: TObject);
var
   PTI: PTypeInfo;
   tmpG:TtsvStringgrid;
   PSG: PStructGrid;
begin
  if FPage.ActivePage=FTSProp then tmpG:=FGridP
  else tmpG:=FGridE;
  PSG:=Pointer(tmpG.Objects[0,tmpG.Row]);
  PTI:=PSG.PTI;
  case tmpG.FEditType of
       edNormal:;
       edPointer: SetPropDialog(PTI);
       edList: SetListProp;
       edPointerChange: SetPropDialog(PTI);
  end;
end;

function TtsvPnlInspector.TextExtent(const Text: string): TSize;
begin
  Result.cX := 0;
  Result.cY := 0;
  GetTextExtentPoint(FList.Canvas.Handle, PChar(Text), Length(Text), Result);
end;

procedure TtsvPnlInspector.SetListProp;
var
   i,j,ScrX,strW:integer;
   str,str1,str2:string;
   pt:TPoint;
   Ls,Ls1,Ls2:integer;
   FGridtmp: TtsvStringGrid;
   incDW: Integer;
   PTI: PTypeInfo;
   PSG: PStructGrid;
begin
  FfmList.Hide;
  SetTypeProp;
  if Fpage.ActivePage=FTSProp then FGridtmp:=FGridP
   else FGridtmp:=FGridE;
  PSG:=Pointer(FGridtmp.Objects[0,FGridtmp.Row]);
  PTI:=PSG.PTI;
  if PTI<>nil then begin
    if PTI=TypeInfo(TCursor)then begin
     incDW:=40;
     FList.ItemHeight:=32;
    end else if PTI=TypeInfo(TColor)then begin
     incDW:=18;
     FList.ItemHeight:=FList.DefItemHeight;
    end else begin
     incDW:=0;
     FList.ItemHeight:=FList.DefItemHeight;
    end;
  end else begin
    incDW:=0;
  end;
  with FList do begin
     if Items.Count<>0 then
     str:=Items.Strings[0];
     for i:=0 to Items.Count-1 do begin
        str1:=Items.Strings[i];
        if i=Items.Count-1 then break;
        str2:=Items.Strings[i+1];
        Ls:=Length(str);
        Ls1:=Length(str1);
        Ls2:=Length(str2);
        if Ls<Ls1 then str:=str1;
        if (Ls1<Ls2) and(Ls<=Ls1) then str:=str2;
     end;
     FfmList.Height:=ItemHeight*Items.Count+2;
     ScrX:=10+incDW;
     if FfmList.Height>8*ItemHeight+2 then begin
        FfmList.Height:=ItemHeight*8+2;
        ScrX:=25+incDW;
     end;
   end;
   strW:=TextExtent(str).cx+ScrX;
   with FGridtmp do begin
    pt:=Point(InplaceEditor.left,InplaceEditor.top+InplaceEditor.Height);
    pt:=FGridtmp.clienttoscreen(pt);
    if strW<=InplaceEditor.Width+Button.Width then begin
       FfmList.Width:=InplaceEditor.Width+Button.Width;
       FfmList.Left:=pt.x;
    end else begin
       FfmList.Width:=strW;
       FfmList.Left:=pt.x+InplaceEditor.Width+Button.Width-strW;
    end;
   end;
   if (pt.y+FfmList.Height)<=Screen.Height then
     FfmList.top:=pt.y
   else FfmList.top:=pt.y-FGridtmp.InplaceEditor.Height-FfmList.Height;
   for j:=0 to FList.Items.Count-1 do begin
      if FList.Items.Strings[j]=FGridtmp.InplaceEditor.Text then begin
         sendMessage(FList.Handle,LB_SETCURSEL,j,0);
         break;
      end;
   end;
   if (FGridtmp.InplaceEditor.Text='')and(FList.Items.Count<>0)then
     sendMessage(FList.Handle,LB_SETCURSEL,0,0);
   if FList.Items.Count=0 then
     FmList.Height:=FList.ItemHeight;
   FfmList.show;
{   fm:=(Self.Parent as TForm);
   rt.Top:=fm.Top+2;
   rt.Bottom:=rt.Top+2+20;
   rt.Left:=fm.Left+2;
   rt.Right:=rt.Left+150;
   if DrawCaption(fm.Handle,fm.Canvas.Handle,rt,DC_SMALLCAP) then
     showmessage('Okey');
 }
end;

procedure TtsvPnlInspector.SetTypeProp;

 procedure AddListShortCut;
 var
   str:string;
   j:integer;
 begin
      str:='(None)';
      FList.Items.Add(str);
      for j:=$41 to $5A do begin
         str:='Ctrl+'+ShortCutToText(TShortCut(j));
         FList.Items.Add(str);
      end;
      for j:=$70 to $7B do begin
         str:=ShortCutToText(TShortCut(j));
         FList.Items.Add(str);
      end;
      for j:=$70 to $7B do begin
         str:='Ctrl+'+ShortCutToText(TShortCut(j));
         FList.Items.Add(str);
      end;
      for j:=$70 to $7B do begin
         str:='Shift+'+ShortCutToText(TShortCut(j));
         FList.Items.Add(str);
      end;
      for j:=$70 to $7B do begin
         str:='Shift+Ctrl+'+ShortCutToText(TShortCut(j));
         FList.Items.Add(str);
      end;
      for j:=$2D to $2E do begin
         str:=ShortCutToText(TShortCut(j));
         FList.Items.Add(str);
         str:='Shift+'+ShortCutToText(TShortCut(j));
         FList.Items.Add(str);
         str:='Ctrl+'+ShortCutToText(TShortCut(j));
         FList.Items.Add(str);
      end;
      str:='Alt+'+ShortCutToText(TShortCut($08));
      FList.Items.Add(str);
      str:='Shift+Alt+'+ShortCutToText(TShortCut($08));
      FList.Items.Add(str);
 end;

 procedure AddListFontCharset;
 var
    i:integer;
    str:string;
 begin
    for i:=0 to 17 do begin
       str:=FontCharsets[i].Name;
       FList.Items.Add(str);
    end;
 end;

var
   PPI:PPropInfo;
   PTI:PTypeInfo;
   mf: TForm;
   CTD: PTypeData;
   str: string;
   j:integer;
   FGridtmp:TtsvStringGrid;
   PSG: PStructGrid;
   isNotUse: Boolean;
   PropName: String;
begin
   FList.Clear;
   FList.Sorted:=false;
   if FPage.ActivePage=FTSProp then FGridtmp:=FGridP
     else FGridtmp:=FGridE;
   PSG:=Pointer(FGridtmp.Objects[0,FGridtmp.Row]);
   PTI:=PSG.PTI;
   PropName:=PSG.PropName;
   case PTI.Kind of
        tkClass:begin
           isNotUse:=false;
           CTD:=GetTypeData(PTI);
           if FValueObj is TPageControl then begin
             for j:=0 to TPageControl(FValueObj).PageCount-1 do begin
               FList.Items.AddObject(TPageControl(FValueObj).Pages[j].Name,
                                     TPageControl(FValueObj).Pages[j]);
             end;
             isNotUse:=true;
           end;
           if (FValueObj is TForm)and(PropName='ActiveControl') then begin
             for j:=0 to TForm(FValueObj).ComponentCount-1 do begin
              if (TForm(FValueObj).Components[j] is TControl)then begin
               FList.Items.AddObject(TForm(FValueObj).Components[j].Name,
                                     TForm(FValueObj).Components[j]);
              end;                       
             end;
             isNotUse:=true;
           end;
           if not isNotUse then begin
            mf:=Application.MainForm;
            for j:=0 to mf.ComponentCount-1 do begin
             if GetClassParent(mf.Components[j].ClassType,CTD.ClassType)then
                FList.Items.AddObject(mf.Components[j].Name,mf.Components[j]);
            end;
            FList.Sorted:=true;
           end; 
        end;
        tkEnumeration:begin
           CTD:=GetTypeData(PTI);
           for j:=CTD.MinValue to CTD.MaxValue do begin
               str:=GetEnumName(PTypeInfo(PTI),j);
               FList.Items.Add(str);
           end;
           FList.Sorted:=false;
        end;
        tkInteger:begin
           if PTI=TypeInfo(TColor)then begin
              FList.Sorted:=false;
              for j:=0 to 41 do begin
                str:=Colors[j].Name;
                FList.Items.Add(str);
              end;
           end;
           if PTI=TypeInfo(TCursor)then begin
              for j:=0 to 20 do begin
                str:=NameCursors[j].Name;
                FList.Items.Add(str);
              end;
              FList.Sorted:=true;
           end;
           if PTI=TypeInfo(TShortCut)then AddListShortCut;
           if PTI=TypeInfo(TFontCharset)then AddListFontCharset;
        end;
        tkString,tkLString,tkWString,tkChar:begin
           if PTI=TypeInfo(TFontName)then FList.items.Assign(Screen.Fonts);
           if PTI=TypeInfo(String)then begin
             if PSG.PropName='WordStyle' then  FList.items.Assign(ListDefaultStyles);
           end;
        end;   
        tkMethod:begin
           for j:=0 to FTableMethodPPI.Count-1 do begin
             PPI:=PPropInfo(FTableMethodPPI.Objects[j]);
             if PTI=PPI^.PropType^then
              FList.Items.Add(FTableMethodPPI.Strings[j]);
           end;
           FList.Sorted:=true;
        end;
   end;
   if FGridtmp.InplaceEditor.Text='' then exit;
   for j:=0 to FList.Items.Count-1 do begin
      if FList.Items.Strings[j]=FGridtmp.InplaceEditor.Text then begin
         sendMessage(FList.Handle,LB_SETCURSEL,j,0);
         break;
      end;
   end;
end;

procedure TtsvPnlInspector.UpdateTypeInfo;

  procedure SetOrdPropV(Obj: TObject; PPI: PPropInfo; PTI: PTypeInfo; Gridtmp:TtsvStringgrid);
  var
     tmps:String;
     chset: Longint;
  begin
     tmpS:=Gridtmp.InplaceEditor.Text;
     if PTI=TypeInfo(TColor)then
       SetOrdProp(Obj, PPI, integer(StringToColor(tmps)))
     else if PTI=TypeInfo(TCursor)then
       SetOrdProp(Obj, PPI, integer(StringToCursor(tmps)))
     else if PTI=TypeInfo(TShortCut)then begin
       if integer(TextToShortCut(tmps))=0 then begin
          if tmpS='(None)'then SetOrdProp(Obj, PPI, 0)
          else InvalidProperty;
       end else begin
          SetOrdProp(Obj, PPI, integer(TextToShortCut(tmps)))
       end;
     end else if PTI=TypeInfo(TFontCharset) then begin
          if IdentToCharset(tmps,chset) then
           SetOrdProp(Obj, PPI, integer(chset))
          else InvalidProperty; 
     end else SetOrdProp(Obj, PPI, strtoint(tmps));
  end;

  procedure SetAllObjects(tmpG:TtsvStringGrid);
  var
    i: Integer;
    PSG: PStructGrid;
    TmpObj: TObject;
    ParentObj: TObject;
    PPI:PPropInfo;
    PropName: String;
    isUpdate: Boolean;
  begin
    for i:=tmpG.row downto 0 do begin
       PSG:=Pointer(tmpG.Objects[0,i]);
       ParentObj:=PSG.Obj;
       if ParentObj=FValueObj then begin
        PropName:=PSG.PropName;
        break;
       end else begin
        //tmpObj:=ParentObj;
       end;
    end;
    PPI:=GetPropInfo(FValueObj.ClassInfo,PropName);
    if PPI<>nil then begin
     if PPI^.PropType^.Kind=tkClass then begin
      tmpObj:=TObject(GetOrdProp(FValueObj,PPI));
      isUpdate:=true;
      if (tmpObj is TStrings) then isUpdate:=false;
      if (PropName='ActiveControl') then isUpdate:=false;
      if isUpdate then
        SetOrdProp(FValueObj,PPI,Longint(tmpObj));
     end;
    end;
  end;

var
   PTI:PTypeInfo;
   CTD,PTD:PTypeData;
   PPI,PPIValue:PPropInfo;
   PropName: string;
   i,EnVal,j,Val:integer;
   isClass:Boolean;
   isExcept:Boolean;
   CurObj,Obj:TObject;
   tmps,Oldstr,ts:string;
   tmpG:TtsvStringGrid;
   PTM: TMethod;
   isMethod: boolean;
   PSG: PStructGrid;
begin
  if FPage.ActivePage=FTSProp then tmpG:=FGridP
  else tmpG:=FGridE;
   PSG:=Pointer(tmpG.Objects[0,tmpG.Row]);
   PTI:=PSG.PTI;
   CurObj:=PSG.Obj;
    PropName:=PSG.PropName;
//    CTD:=GetTypeData(CurObj.ClassInfo);
    PPIValue:=GetPropInfo(CurObj.ClassInfo,PropName);
    if PPIValue<>nil then begin
     try
       tmpS:=tmpG.InplaceEditor.Text;
       case PTI.Kind of
        tkInteger:SetOrdPropV(CurObj,PPIValue,PTI,tmpG);
        tkFloat: begin
          if PTI=TypeInfo(TDate)then
            SetFloatProp(CurObj,PPIValue, StrToDate(tmps))
          else if PTI=TypeInfo(TTime)then
            SetFloatProp(CurObj,PPIValue, StrToTime(tmps))
          else SetFloatProp(CurObj,PPIValue, strtofloat(tmps));
        end;
        tkString,tkLString,tkWString,tkChar:begin
           if PTI=TypeInfo(TFontName) then begin
             if Screen.Fonts.IndexOf(tmps)=-1 then InvalidProperty
             else SetStrProp(CurObj, PPIValue,tmps);
           end else SetStrProp(CurObj, PPIValue,tmps);
           if PropName='Name' then begin
             Newname:=tmps;
           end;
        end;
        tkEnumeration:begin
          EnVal:=GetEnumValue(PTI,tmps);
          if EnVal<>-1 then
//            SetEnumProp(CurObj,PropName,tmps)
            SetOrdProp(CurObj, PPIValue,EnVal)
          else  InvalidProperty;
        end;
        tkClass:begin
          isClass:=false;
          if FGridP.EditType=edList then begin
             PPI:=GetPropInfo(CurObj.ClassInfo,PropName);
             if tmps='' then begin
               SetOrdProp(CurObj,PPI,Longint(nil));
               isClass:=true;
             end else
              for j:=0 to FList.Items.Count-1 do begin
                 if FList.Items.Objects[j]=nil then break;
                 if LowerCase(FList.Items.Strings[j])=LowerCase(tmps) then begin
                    SetObjectProp(CurObj,PropName,FList.Items.Objects[FList.ItemIndex]);
//                    SetOrdProp(CurObj,PPI,Longint(FList.Items.Objects[FList.ItemIndex]));
                    isClass:=true;
                    break;
                 end  else isClass:=false;
              end;
             if not isClass then InvalidProperty;
          end;
          if FGridP.EditType=edPointer then begin
             PPI:=GetPropInfo(CurObj.ClassInfo,PropName);
             obj:=TObject(GetOrdProp(CurObj,PPI));
             if not (obj is TStrings) then
              SetOrdProp(CurObj,PPI,Longint(obj));
          end;
        end;
        tkMethod:begin
           isMethod:=false;
           for j:=0 to FTableMethod.Count-1 do begin
             if LowerCase(tmps)=LowerCase(FTableMethod.Strings[j]) then begin
               PTM.Code:=FTableMethod.Objects[j];
               isMethod:=true;
               break;
             end;
           end;
           if (isMethod=false) then begin
            if (tmps='') then begin
             PTM.Code:=nil;
             SetMethodProp(CurObj,PPIValue,PTM);
            end else InvalidProperty;
           end else SetMethodProp(CurObj,PPIValue,PTM);
        end;
       end;
      except InvalidProperty;
      end;//end of try
    end else begin
       for i:=tmpG.Row downto 0 do begin
          PSG:=Pointer(tmpG.Objects[0,i]);
          PTI:=PSG.PTI;
          tmps:=tmpG.InplaceEditor.Text;
          if PTI.Kind=tkSet then begin
            CTD:=GetTypeData(PTI);
            PropName:=PSG.PropName;
            PPI:=GetPropInfo(CurObj.ClassInfo,PropName);
            PTD:=GetTypeData(CTD^.CompType^);
            PSG:=Pointer(tmpG.Objects[0,tmpG.Row]);
            val:=0;
            for j:=PTD.MinValue to PTD.MaxValue do begin
              ts:=GetEnumName(PTypeInfo(CTD^.CompType^),j);
              if PSG.PropName=ts then begin
                val:=j;
                Break;
              end;
            end;
//            EnVal:=tmpG.Row-i-1+val;
            EnVal:=val;
            isExcept:=True;
            if (GetOrdProp(CurObj,PPI) and (1 shl EnVal)) >= 1 then
               Oldstr:='True' else  Oldstr:='False';
            if tmps<>Oldstr then begin
             if (tmps='True')or(tmps='False') then begin
                Val:=GetOrdProp(CurObj,PPI) XOR (1 shl EnVal);
                SetOrdProp(CurObj,PPI,Val);
                isExcept:=false;
             end;
             if isExcept then InvalidProperty;
            end;
            break;
          end;
        end;
     end;
   SetAllObjects(tmpg);
   tmpG.InplaceEditor.SelectAll;
   RefreshInspector;
   FLastProp:=PropName;
end;

procedure TtsvPnlInspector.ChangeSetText(Ob: TObject; PTD: PTypeData; PTI: PTypeInfo; PPI:PPropInfo; Index:integer);
var
   tmps,ts:string;
   j:integer;
   tmpG:TtsvStringGrid;
   PSG: PStructGrid;
begin
    tmps:='';
{    if FPage.ActivePage=FTSProp then tmpG:=FGridP
    else tmpG:=FGridE;}
    tmpG:=FGridP;
    PSG:=Pointer(tmpg.Objects[0,tmpg.Row]);
    for j:=PTD.MinValue to PTD.MaxValue do begin
      ts:=GetEnumName(PTypeInfo(PTI),j);
      if PSG.PropName=ts then begin
        break;
      end;
    end;
    for j:=PTD.MinValue to PTD.MaxValue do begin
      if (GetOrdProp(Ob,PPI) and (1 shl j)) >= 1 then
        if tmps='' then tmps:=GetEnumName(PTypeInfo(PTI),j)
        else tmps:=tmps+','+GetEnumName(PTypeInfo(PTI),j);
    end;
    tmpG.Cells[1,Index]:='['+tmps+']';
end;

procedure TtsvPnlInspector.InvalidProperty;
begin
  MessageBeep(0);
  MessageDlg('Неверное значение свойства.',mtError,[mbOk],-1);
//  MessageBox(Self.Handle,'Неверное значение свойства.','Ошибка',MB_ICONERROR+MB_OK);
//  MessageDlg('Неверное значение свойства ',mtError,[mbOK],0);
end;

procedure TtsvPnlInspector.UpdateInspector(Value: TComponent);

  function isPropAssign(PPI: PPropInfo): Boolean;
  var
    val: LongInt;
    tmps: string;
    obj: TObject;
    CTD: PTypeData;
  begin
    Result:=true;
    case PPI^.PropType^.Kind of
       tkInteger: begin
          val:=GetOrdProp(Value,PPI);
          SetOrdProp(value,PPI,Val);
       end;
       tkEnumeration: begin
          tmps:=GetEnumName(PTypeInfo(PPI^.PropType^),GetOrdProp(Value,PPI));
          val:=getEnumValue(PTypeInfo(PPI^.PropType^),tmps);
          SetOrdProp(Value,PPI,val);
       end;
       tkString,tkLString,tkWString: begin
         tmps:=GetStrProp(Value,PPI);
         SetStrProp(Value, PPI,tmps);
       end;
       tkFloat: begin
         SetFloatProp(Value,PPI,GetFloatProp(Value,PPI));
       end;
       tkClass: begin
         obj:=TObject(GetOrdProp(Value,PPI));
         CTD:=GetTypeData(PPI^.PropType^);
         if GetClassParent(CTD.ClassType,TComponent) then begin
           //
         end else begin
          if not Assigned(obj) then begin
           Result:=false;
         end; 
         end;
       end;
       tkSet: begin
       end;
    end;
  end;

var
  PropList,PLmf: PPropList;
  ClassTypeInfo: PTypeInfo;
  ClassTypeData,CTD,PTD: PTypeData;
  i,tmpI,tmpJ,j,k: integer;
  Obj:TObject;
  mf: TForm;
  PTM,PTMmf: TMethod;
  MTD,MTDmf,MTD1: PTypeData;
  PPImf,PPI: PPropInfo;
  tmps:string;
  val: Integer;
begin
//  FGridP.Visible:=false;
  FGridP.RowCount:=0;
  FGridP.Visible:=false;
  FGridP.OnSelectCell:=nil;
  if FgridE<>nil then begin
   FGridE.Visible:=false;
   FGridE.RowCount:=0;
  end;
  if Value=nil then exit;
  if not FCombo.Visible then
    FLabel.Caption:='Object - '+value.Name;
  ClassTypeInfo := Value.ClassInfo;
  ClassTypeData := GetTypeData(ClassTypeInfo);
  if ClassTypeData.PropCount = 0 then exit;
  GetMem(PropList, SizeOf(PPropInfo) * ClassTypeData.PropCount);
  GetPropInfos(Value.ClassInfo, PropList);
  tmpI:=0;
  tmpJ:=0;
  for i := 0 to ClassTypeData.PropCount - 1 do begin
      if not (PropList[i]^.PropType^.Kind = tkMethod) then begin
       try
        if isPropAssign(PropList[i]) then begin
           FGridP.RowCount:=tmpI+1;
           FGridP.Cells[0,tmpI]:='  '+PropList[i]^.Name;
 //        FGridP.Cells[0,tmpI]:='  '+ReadLangName(tmpI,FGridP);
           AddStructGrid(FGridP,tmpI,PropList[i]^.PropType^,PropList[i]^.Name,Value);
         case PropList[i]^.PropType^.Kind of
             tkInteger: begin
               FGridP.Cells[1,tmpI]:= inttostr(GetOrdProp(Value,PropList[i]));
               if PropList[i]^.PropType^=TypeInfo(TColor) then
               FGridP.Cells[1,tmpI]:=ColortoString(TColor(GetOrdProp(Value,PropList[i])))
               else if PropList[i]^.PropType^=TypeInfo(TCursor) then
               FGridP.Cells[1,tmpI]:=CursorToString(TCursor(GetOrdProp(Value,PropList[i])));
               if PropList[i]^.PropType^=TypeInfo(TShortCut) then begin
                 FGridP.Cells[1,tmpI]:=ShortCutToText(TShortCut(GetOrdProp(Value,PropList[i])));
                 if FGridP.Cells[1,tmpI]='' then FGridP.Cells[1,tmpI]:='(None)';
               end;
               if PropList[i]^.PropType^=TypeInfo(TFontCharset)then begin
                  CharsetToIdent(GetOrdProp(Value,PropList[i]),tmps);
                  FGridP.Cells[1,tmpI]:=tmps;
               end;
             end;
             tkEnumeration: begin
               FGridP.Cells[1,tmpI]:=GetEnumName(PTypeInfo(PropList[i]^.PropType^),
                                        GetOrdProp(Value,PropList[i]));
             end;
             tkString,tkLString,tkWString: begin
               FGridP.Cells[1,tmpI]:= GetStrProp(Value,PropList[i]);
               if PropList[i]^.PropType^.Name='TComponentName' then begin
                  OldName:=FGridP.Cells[1,tmpI];
                  Newname:=OldName;
               end;
             end;
             tkFloat: begin
               FGridP.Cells[1,tmpI]:= floattostr(GetFloatProp(Value,PropList[i]));
               if PropList[i]^.PropType^=TypeInfo(TDate)then
                 FGridP.Cells[1,tmpI]:= DateToStr(GetFloatProp(Value,PropList[i]));
               if PropList[i]^.PropType^=TypeInfo(TTime)then
                 FGridP.Cells[1,tmpI]:= TimeToStr(GetFloatProp(Value,PropList[i]));
             end;
             tkClass: begin
              obj:=TObject(GetOrdProp(Value,PropList[i]));
              CTD:=GetTypeData(PropList[i]^.PropType^);
                if (obj <> nil)and(Obj is TComponent) then begin
                FGridP.Cells[1,tmpI]:=TComponent(Obj).Name;
                if GetClassParent(CTD.ClassType,TMenuItem) or
                            GetClassParent(CTD.ClassType,TCollectionItem)then
                  FGridP.Cells[1,tmpI]:='('+CTD.ClassType.ClassName+')';
               end else FGridP.Cells[1,tmpI]:='('+CTD.ClassType.ClassName+')';
               val:=FUncoveredList.IndexOf(CTD.ClassType.ClassName);
               if val<>-1 then
                 FGridP.Cells[0,tmpI]:='+'+PropList[i]^.Name;
               if obj=nil then FGridP.Cells[1,tmpI]:='';
             end;
             tkSet: begin
                  FGridP.Cells[0,tmpI]:='+'+PropList[i]^.Name;
                  CTD:=GetTypeData(PropList[i]^.PropType^);
                  PTD:=GetTypeData(CTD^.CompType^);
                  ChangeSetText(Value,PTD,CTD^.CompType^,PropList[i],tmpI);
             end;
          end;
          inc(tmpI);
         end;
        except
          
        end;
      end else begin
      if FGridE<>nil then begin
        FGridE.RowCount:=tmpJ+1;
        AddStructGrid(FGridE,tmpJ,PropList[i]^.PropType^,PropList[i]^.Name,Value);
        FGridE.Cells[0,tmpJ]:='  '+PropList[i]^.Name;
        PTM:=GetMethodProp(Value,PropList[i]);
//        MTD:=GetTypeData(PropList[i]^.PropType^);
        if PTM.Code<>nil then
         for j:=0 to FTableMethod.Count-1 do begin
             if PTM.Code=FTableMethod.Objects[j] then begin
                FGridE.Cells[1,tmpJ]:=FTableMethod.Strings[j];
                break;
             end else begin
                FGridE.Cells[1,tmpJ]:='';
            end;
         end else FGridE.Cells[1,tmpJ]:='';
        inc(tmpJ);
       end;
      end;
  end;
{  FGridP.Sort;
  if FGridE<>nil then
   FGridE.Sort;}
  FreeMem(PropList, SizeOf(PPropInfo) * ClassTypeData.PropCount);
  FValueObj:=Value;
  RefreshLang(FLanguage);
  FGridP.Sort;
  if FGridE<>nil then
   FGridE.Sort;
  RefreshInspector;
  if FFilter then
    FilterForList;
  if FGridP.RowCount<>0 then
   FGridP.FocusCell(1,FIDName,true);
  LocateLastProp;
  FGridP.OnSelectCell:=GridPOnSelectCell;
  FGridP.Visible:=true;
  if FGridE<>nil then
   FGridE.Visible:=true;

end;

procedure TtsvPnlInspector.GridPDblClick(Sender: TObject);

 procedure InsertSet(PSG: PStructGrid; CTD: PTypedata; PTI: PTypeInfo;
  PropName: string; TabCount: integer;  Obj: TObject);
 var
   j,val:integer;
   ch:Char;
   CountProp:integer;
   PPI: PPropInfo;
   PTD: PTypeData;
   tmps:string;
   PSG1,PSG2: PStructGrid;
 begin
         PTD:=GetTypeData(CTD^.CompType^);
         ch:=propName[1];
         CountProp:=PTD.MaxValue-PTD.MinValue;
         if Ch='+' then begin
           PPI:=GetPropInfo(Obj.ClassInfo,PSG.PropName);
           tmps:='';
           for j:=0 to TabCount-1 do tmps:=tmps+' ';
           FGridP.Cells[0,FGridP.Row]:=tmps+'- '+ReadLangName(FGridP.Row,FGridP);
           InsertRow(FGridP.Row+1,CountProp+1);
           tmps:='';
           for j:=0 to 4+TabCount-1 do tmps:=tmps+' ';
           for j:=PTD.MinValue to PTD.MaxValue do begin
             AddStructGrid(FGridP,FGridP.Row+j+1,TypeInfo(Boolean),
                               GetEnumName(PTypeInfo(CTD^.CompType^),j),obj);
             FGridP.Cells[0,FGridP.Row+j+1]:=tmps+GetEnumName(PTypeInfo(CTD^.CompType^),j);
             if (GetOrdProp(Obj,PPI) and (1 shl j)) >= 1 then
                FGridP.Cells[1,FGridP.Row+j+1]:='True'
             else  FGridP.Cells[1,FGridP.Row+j+1]:='False';
           end;
         end else  begin
           tmps:='';
           for j:=0 to TabCount-2 do tmps:=tmps+' ';
           FGridP.Cells[0,FGridP.Row]:=tmps+'+'+ReadLangName(FGridP.Row,FGridP);
           PSG1:=Pointer(FGridP.Objects[0,FGridP.row+1]);
           val:=-1;
           for j:=FGridP.Row+1 to FGridP.Row+Countprop+1 do begin
              PSG2:=Pointer(FGridP.Objects[0,j]);
              if PSG1.Obj=PSG2.Obj then
                val:=val+1 else break;
           end;
           DelRow(FGridP.Row+1,val+1,FGridP);
         end;
 end;

 procedure InsertClass(PSG: PStructGrid; CTD: PTypedata; PTI: PTypeInfo;
                       PropName: string;TabCount: integer);
 var
   j:integer;
   ch:Char;
   CountProp,ValCount:integer;
   ValT:integer;
   PPI: PPropInfo;
   PL: PPropList;
   tmps:string;
   PrStr:string;
   obj,ob,Delobj:TObject;
   CTD1,PTD1: PTypeData;
   PSG1,PSG2: PstructGrid;
 begin
        ch:=propName[1];
        if (ch='+')or(ch='-')then begin
         CountProp:=CTD.PropCount-1;
         if Ch='+' then begin
           PPI:=GetPropInfo(FValueObj.ClassInfo,PSG.PropName);
           obj:=TObject(getOrdprop(FValueObj,PPI));
           tmps:='';
           for j:=0 to TabCount-1 do tmps:=tmps+' ';
           FGridP.Cells[0,FGridP.Row]:=tmps+'- '+ReadLangName(FGridP.Row,FGridP);
           InsertRow(FGridP.Row+1,CountProp+1);
           GetMem(PL, Sizeof(PPropInfo)*CTD.PropCount);
           GetPropInfos(PTI,PL);
           tmps:='';
           for j:=0 to 4+TabCount-1 do tmps:=tmps+' ';
           for j:=0 to CountProp do begin
              if PL[j]^.PropType^.Kind<>tkMethod then begin
                AddStructGrid(FGridP,FGridP.Row+j+1,PL[j]^.PropType^,PL[j]^.Name,obj);
                FGridP.Cells[0,FGridP.Row+j+1]:=tmps+PL[j]^.Name;
                case PL[j]^.PropType^.Kind of
                  tkInteger:begin
                    PrStr:=inttostr(GetOrdProp(obj,PL[j]));
                    if PL[j]^.PropType^=TypeInfo(TColor) then
                       PrStr:=ColortoString(TColor(GetOrdProp(Obj,PL[j])))
                    else if PL[j]^.PropType^=TypeInfo(TCursor) then
                       PrStr:=CursorToString(TCursor(GetOrdProp(obj,PL[j])));
                    if PL[j]^.PropType^=TypeInfo(TShortCut) then begin
                       PrStr:=ShortCutToText(TShortCut(GetOrdProp(obj,PL[j])));
                       if PrStr='' then PrStr:='(None)';
                    end;
                    if PL[j]^.PropType^=TypeInfo(TFontCharset)then
                       PrStr:=FontCharsets[GetOrdProp(obj,PL[j])].Name;
                    FGridP.Cells[1,FGridP.Row+j+1]:=PrStr;
                  end;
                  tkString,tkLString,tkWString: begin
                      PrStr:= GetStrProp(Obj,PL[j]);
                      FGridP.Cells[1,FGridP.Row+j+1]:=PrStr;
                  end;
                  tkFloat:begin
                      PrStr:= floattostr(GetFloatProp(Obj,PL[j]));
                      if PTI=TypeInfo(TDate)then
                      PrStr:= DateToStr(GetFloatProp(Obj,PL[j]));
                      if PTI=TypeInfo(TTime)then
                      PrStr:= TimeToStr(GetFloatProp(Obj,PL[j]));
                      FGridP.Cells[1,FGridP.Row+j+1]:=PrStr;
                  end;
                  tkEnumeration:begin
                       PrStr:=GetEnumName(PTypeInfo(PL[j]^.PropType^),
                                        GetOrdProp(Obj,PL[j]));
                       FGridP.Cells[1,FGridP.Row+j+1]:=PrStr;
                  end;
                  tkClass:begin
                       ob:=TObject(GetOrdProp(Obj,PL[j]));
                       CTD:=GetTypeData(PL[j]^.PropType^);
                       if (ob <> nil)and(Ob is TComponent) then begin
                       PrStr:=TComponent(Ob).Name;
                       if GetClassParent(CTD.ClassType,TMenuItem) or
                          GetClassParent(CTD.ClassType,TCollectionItem)then
                          PrStr:='('+CTD.ClassType.ClassName+')';
                       end else PrStr:='('+CTD.ClassType.ClassName+')';
                       if ob=nil then PrStr:='';
                       FGridP.Cells[1,FGridP.Row+j+1]:=PrStr;
                  end;
                  tkSet:begin
                       Delete(tmps,Length(tmps)-2,2);
                       FGridP.Cells[0,FGridP.Row+j+1]:=tmps+'+'+ReadLangName(FGridP.Row+j+1,FGridP);
                       CTD1:=GetTypeData(PL[j]^.PropType^);
                       PTD1:=GetTypeData(CTD1^.CompType^);
                       ChangeSetText(Obj,PTD1,CTD1^.CompType^,PL[j],FGridP.Row+j+1);
                  end;
                end;
              end;
           end;
           FreeMem(PL, Sizeof(PPropInfo)*CountProp);
//           FGridP.QuickSort(FGridP.Row+1,FGridP.Row+1+CountProp);
         end else begin
           PSG2:=Pointer(FGridP.Objects[0,FGridP.Row+1]);
           valCount:=-1;
           for j:=FGridP.Row+1 to FGridP.RowCount-1 do begin
              PSG1:=Pointer(FGridP.Objects[0,j]);
              if PSG1.Obj=PSG2.Obj then valCount:=valCount+1
               else break;   
              tmps:=delChars(FGridP.Cells[0,j],' ');
              ch:=tmps[1];
              if(ch='-')then begin
                Delete(tmps,1,1);
                PPI:=GetPropInfo(FValueObj.ClassInfo,PSG.PropName);
                obj:=TObject(getOrdprop(FValueObj,PPI));
                PPI:=GetPropInfo(Obj.ClassInfo,PSG1.PropName);
//                CTD1:=GetTypeData(PPI^.PropType^);
                case PPI^.PropType^.Kind of
                     tkSet:begin
           {             PTD1:=GetTypeData(CTD1^.CompType^);
                        DelRow(j,PTD1.MaxValue-PTD1.MinValue+1,FGridP);}
                     end;
                     tkClass:;
                end;
              end;
           end;
           tmps:='';
           for j:=0 to TabCount-1 do tmps:=tmps+' ';
           FGridP.Cells[0,FGridP.Row]:=tmps+'+'+ReadLangName(FGridP.Row,FGridP);
           DelRow(FGridP.Row+1,ValCount+1,FgridP);
         end;
      end;
 end;

var
   PTI: PTypeInfo;
   CTD: PTypeData;
   PropName,tmps:String;
   tmpG:TtsvStringGrid;
   obj:TObject;
   LenStr,TabC:integer;
   PSG: PStructGrid;
begin
   if FPage.ActivePage=FTSProp then tmpG:=FGridP
   else tmpG:=FGridE;
   PSG:=Pointer(tmpG.Objects[0,tmpG.Row]);
   PTI:=PSG.PTI;
   if PTI=nil then exit;
   tmps:=DelChars(tmpG.Cells[0,tmpG.Row],' ');
   LenStr:=Length(tmpG.Cells[0,tmpG.Row])-Length(tmps);
   PropName:=tmps;
   obj:=PSG.Obj;
   if obj=FValueObj then TabC:=0
   else TabC:=0+LenStr;
   CTD:=GetTypeData(PTI);
   case PTI.Kind of
      tkSet: InsertSet(PSG,CTD,PTI,PropName,TabC,obj);
      tkClass: InsertClass(PSG,CTD,PTI,PropName,TabC);
   end;
   RefreshLang(FLanguage);
   FilterForList;
end;

procedure TtsvPnlInspector.InsertRow(Index,CP: Integer);
var
   i:Integer;
   OldCount:integer;
begin
   OldCount:=FGridP.RowCount;
   FGridP.RowCount:=OldCount+CP;
   for i:=OldCount-1 downto Index do begin
      FGridP.Cells[0,i+CP]:=FGridP.Cells[0,i];
      FGridP.Cells[1,i+CP]:=FGridP.Cells[1,i];
      FGridP.Objects[0,i+CP]:=FGridP.Objects[0,i];

      FGridP.Cells[0,i]:='';
      FGridP.Cells[1,i]:='';
      FGridP.Objects[0,i]:=nil;
   end;
end;

procedure TtsvPnlInspector.DelRow(Index,CP: Integer; tmpG: TtsvStringGrid);
var
   i:Integer;
   Grd:TtsvStringGrid;
begin
   Grd:=tmpG;
   for i:=Index to Grd.RowCount-CP-1 do begin
      Grd.Cells[0,i]:=Grd.Cells[0,i+CP];
      Grd.Cells[1,i]:=Grd.Cells[1,i+CP];
      Grd.Objects[0,i]:=Grd.Objects[0,i+CP];
   end;
   Grd.RowCount:=Grd.RowCount-CP;
end;

procedure TtsvPnlInspector.SetPropDialog(PTInfo: PTypeInfo);
var
   PropName: String;
   PropValue: string;
   CD: TColorDialog;
   FD: TFontDialog;
   OD: TOpenDialog;
   SLE:TStrEditDlg;
   PE:TPictDialog;
   PTI:PTypeInfo;
   PPI:PPropInfo;
   obj:TObject;
   PSG:PStructGrid;
   tmps: string;
   fmme: TfmMask;
   fmLe: TfmLinksEdit;
   fmSbs: TfmSubs;
begin
   PSG:=Pointer(FGridP.Objects[0,FGridP.Row]);
   PropName:=PSG.PropName;
   PropValue:=FGridP.InplaceEditor.Text;
   if PTInfo=TypeInfo(TColor)then begin
     CD:=TColorDialog.Create(nil);
     CD.Color:=StringToColor(PropValue);
     if not CD.Execute then begin Cd.free; exit;end;
     FGridP.InplaceEditor.Text:=ColorToString(CD.Color);
     CD.Free;
   end;
   if PTInfo=TypeInfo(TFont)then begin
     FD:=TFontDialog.Create(nil);
     FD.Options:=[fdEffects,fdForceFontExist];
     PTI:=FValueObj.ClassInfo;
     PPI:=GetPropInfo(PTI,PropName);
     obj:=TObject(getOrdprop(FValueObj,PPI));
     if Obj is TFont then FD.Font.Assign(TFont(Obj));
     if not FD.Execute then begin FD.free;exit;end;
     TFont(Obj).Assign(FD.Font);
     FD.Free;
   end;
   if (PTInfo=TypeInfo(TFileName))and(PropName='Filename')then begin
     OD:=TOpenDialog.Create(nil);
     if FValueObj.ClassName='TMediaPlayer' then
        OD.Filter:='All files (*.*)|*.*|Wave files (*.wav)|*.wav|Midi files (*.mid)|*.mid|Video for Windows (*.avi)|*.avi'
     else OD.Filter:='All files (*.*)|*.*';
     OD.FileName:=PropValue;
     if not OD.Execute then begin OD.Free;exit;end;
     FGridP.InplaceEditor.Text:=OD.FileName;
     OD.free;
   end;
   if PTInfo=TypeInfo(TStrings)then begin
     SLE:=TStrEditDlg.Create(Owner);
     try
      PTI:=FValueObj.ClassInfo;
      PPI:=GetPropInfo(PTI,PropName);
      obj:=TObject(getOrdprop(FValueObj,PPI));
      if Obj is TStrings then
        SLE.Memo.Lines.Assign(TStrings(Obj));
      if SLE.ShowModal=mrOk then begin
        TStrings(Obj).Assign(SLE.Memo.Lines);
      end;
     finally
      SLE.Free;
     end;
   end;
   if PTInfo=TypeInfo(TBitmap)then begin
     PE:=TPictDialog.Create(Owner);
     try
      PTI:=FValueObj.ClassInfo;
      PPI:=GetPropInfo(PTI,PropName);
      obj:=TObject(getOrdprop(FValueObj,PPI));
      if Obj is TBitmap then PE.Image.Picture.Bitmap.Assign(TBitmap(Obj));
      if PE.Execute then begin
        TBitmap(obj).Assign(PE.Image.Picture.Bitmap);
      end;
     finally
      PE.Free;
     end;
   end;
   if PTInfo=TypeInfo(TPicture)then begin
     PE:=TPictDialog.Create(Owner);
     try
      PTI:=FValueObj.ClassInfo;
      PPI:=GetPropInfo(PTI,PropName);
      obj:=TObject(getOrdprop(FValueObj,PPI));
      if Obj is TPicture then begin
         PE.Image.Picture.Assign(TPicture(OBj));
      end;
      if PE.Execute then begin
        TPicture(obj).Assign(PE.Image.Picture);
      end;
     finally
      PE.Free;
     end;
   end;

   if (PTInfo=TypeInfo(String))and(PropName='Hint')then begin
     SLE:=TStrEditDlg.Create(Owner);
     tmps:=PropValue;
     SLE.Memo.Lines.SetText(Pchar(tmps));
     if SLE.ShowModal=mrOk then begin
        tmps:=SLE.Memo.Lines.Text;
        FGridP.InplaceEditor.Text:=tmps;
     end;
     SLE.Free;
   end;

   if (PropName='Caption')or(PropName='LabelCaption')then begin
     SLE:=TStrEditDlg.Create(Owner);
     tmps:=PropValue;
     SLE.Memo.Lines.SetText(Pchar(tmps));
     if SLE.ShowModal=mrOk then begin
        tmps:=SLE.Memo.Lines.Text;
        FGridP.InplaceEditor.Text:=tmps;
     end;
     SLE.Free;
   end;

   if (PTInfo=TypeInfo(String))and(PropName='FileName')then begin
     OD:=TOpenDialog.Create(Owner);
     try
      tmps:=PropValue;
      OD.Filter:='All files (*.*)|*.*';
      od.filename:=tmps;
      if od.Execute then begin
        FGridP.InplaceEditor.Text:=od.filename;
      end;
     finally
      OD.Free;
     end;
   end;

   if ((PTInfo=TypeInfo(String)) or (PTInfo=TypeInfo(TEditMask))) and (PropName='EditMask')then begin

     fmme:=TfmMask.Create(Owner);
     try
      fmme.BorderIcons:=fmme.BorderIcons-[biMinimize];
      fmme.bibOk.Visible:=true;
      fmme.bibOk.OnClick:=fmme.MR;
      fmme.Grid.OnDblClick:=fmme.MR;
      tmps:=PropValue;
      fmme.ActiveQuery;
      fmMe.Mainqr.Locate('mask',tmps,[loCaseInsensitive]);
      if fmme.ShowModal=mrOk then begin
        FGridP.InplaceEditor.Text:=fmMe.mskeTest.EditMask;
      end;
     finally
      fmme.Free;
     end; 
   end;

   if PTInfo=TypeInfo(TTypeLinks)then begin
     fmLe:=TfmLinksEdit.Create(Owner);
     try
      PTI:=FValueObj.ClassInfo;
      PPI:=GetPropInfo(PTI,PropName);
      obj:=TObject(getOrdprop(FValueObj,PPI));
      fmLe.FillListBoxs(getParentNew(TControl(FValueObj)),TTypeLinks(obj),TControl(FValueObj));
      if fmLe.ShowModal=mrOk then begin
      end;
     finally
      fmLe.Free;
     end;
   end;

   if (PTInfo=TypeInfo(String))and(PropName='Subs')then begin

     fmSbs:=TfmSubs.Create(Owner);
     try
      fmSbs.BorderIcons:=fmSbs.BorderIcons-[biMinimize];
      fmSbs.bibOk.Visible:=true;
      fmSbs.bibOk.OnClick:=fmSbs.MR;
      fmSbs.Grid.OnDblClick:=fmSbs.MR;
      tmps:=PropValue;
      fmSbs.ActiveQuery;
      fmSbs.Mainqr.Locate('name',tmps,[loCaseInsensitive]);
      if fmSbs.ShowModal=mrOk then begin
        if not fmSbs.Mainqr.Isempty then
         FGridP.InplaceEditor.Text:=fmSbs.Mainqr.FieldByName('name').AsString;
      end;
     finally
      fmSbs.Free;
     end;
   end;

   FGridP.InplaceEditor.SelectAll;
   UpdateTypeInfo;
end;

procedure TtsvPnlInspector.RefreshInspector;
var
   i,j,EnVal,k,val:integer;
   PTI:PTypeInfo;
   PPI:PpropInfo;
   PTM: Tmethod;
   PropName,PnStr,str,ts:String;
   obj,Objtmp:TObject;
   CTD,PTD:PTypeData;
   PSG: PStructGrid;
   Prn: TWinControl;
   NewIndex: Integer;
begin


   for i:=0 to FGridP.RowCount-1 do begin
     PSG:=Pointer(FGridP.Objects[0,i]);
     PTI:=PSG.PTI;
     Objtmp:=PSG.Obj;
     PropName:=PSG.PropName;
     PPI:=GetPropInfo(Objtmp.ClassInfo,PropName);
     if PPI<>nil then begin
       case PTI.Kind of
          tkInteger:begin
               PnStr:= inttostr(GetOrdProp(Objtmp,PPI));
               if PTI=TypeInfo(TColor) then
               PnStr:=ColortoString(TColor(GetOrdProp(Objtmp,PPI)))
               else if PTI=TypeInfo(TCursor) then
               PnStr:=CursorToString(TCursor(GetOrdProp(Objtmp,PPI)));
               if PTI=TypeInfo(TShortCut) then begin
                 PnStr:=ShortCutToText(TShortCut(GetOrdProp(Objtmp,PPI)));
                 if PnStr='' then FGridP.Cells[1,i]:='(None)';
               end;
               if PTI=TypeInfo(TFontCharset)then
                  CharsetToIdent(GetOrdProp(Objtmp,PPI),PnStr);
             FGridP.Cells[1,i]:=PnStr;
          end;
          tkEnumeration: begin
             NewIndex:=GetOrdProp(Objtmp,PPI);
             PnStr:=GetEnumName(PTypeInfo(PTI),NewIndex);
             FGridP.Cells[1,i]:=PnStr;
          end;
          tkString,tkLString,tkWString,tkChar: begin
             PnStr:= GetStrProp(Objtmp,PPI);
             if PTI=TypeInfo(TFontName)then
               Pnstr:=Screen.Fonts.Strings[Screen.Fonts.indexof(PnStr)];
             if PTI=TypeInfo(TComponentName)then FIDName:=i;
             FGridP.Cells[1,i]:=PnStr;
          end;
          tkFloat: begin
             PnStr:= floattostr(GetFloatProp(Objtmp,PPI));
             if PTI=TypeInfo(TDate)then
              PnStr:= DateToStr(GetFloatProp(Objtmp,PPI));
             if PTI=TypeInfo(TTime)then
               PnStr:= TimeToStr(GetFloatProp(Objtmp,PPI));
             FGridP.Cells[1,i]:=PnStr;
           end;
           tkClass: begin
             obj:=TObject(GetOrdProp(Objtmp,PPI));
             CTD:=GetTypeData(PTI);
             if (obj <> nil)and(Obj is TComponent) then begin
             PnStr:=TComponent(Obj).Name;
             if GetClassParent(CTD.ClassType,TMenuItem) or
                    GetClassParent(CTD.ClassType,TCollectionItem)then
                PnStr:='('+CTD.ClassType.ClassName+')';
             end else PnStr:='('+CTD.ClassType.ClassName+')';
             if obj=nil then PnStr:='';
//             FGridP.Cells[1,i]:=PnStr;
           end;
           tkSet: begin
                CTD:=GetTypeData(PTI);
                PTD:=GetTypeData(CTD^.CompType^);
                ChangeSetText(Objtmp,PTD,CTD^.CompType^,PPI,i);
           end;
       end;
     end else begin
       for j:=FgridP.Row downto 0 do begin
          PSG:=Pointer(FgridP.Objects[0,j]);
          PTI:=PSG.PTI;
          if PTI.Kind=tkSet then begin
            CTD:=GetTypeData(PTI);
            PropName:=PSG.PropName;
            PPI:=GetPropInfo(Objtmp.ClassInfo,PropName);
            PTD:=GetTypeData(CTD^.CompType^);
            PSG:=Pointer(FgridP.Objects[0,i]);
            val:=0;
            for k:=PTD.MinValue to PTD.MaxValue do begin
              ts:=GetEnumName(PTypeInfo(CTD^.CompType^),k);
              if PSG.PropName=ts then begin
                val:=k;
                Break;
              end;
            end;
            EnVal:=val;
            str:=GetEnumName(PTypeInfo(CTD^.CompType^),EnVal);
            ReplaceStructGrid(FGridP,i,TypeInfo(Boolean),
                        str,Objtmp);
            if (GetOrdProp(Objtmp,PPI) and (1 shl EnVal)) >= 1 then
                  FGridP.Cells[1,i]:='True'
            else  FGridP.Cells[1,i]:='False';
            Break;
          end;
        end;
     end;                   
   end;

  if FValueObj is TControl then begin
   Prn:=getParentNew(TControl(FValueObj));
   if Prn<>nil then begin
     sendMessage(Prn.Handle,WM_PropChange,0,0);
   end else begin
     if FValueObj is TWinControl then
      sendMessage(TWinControl(FValueObj).Handle,WM_PropChange,0,0);
   end;
  end;

  if FGridE<>nil then begin
   for i:=0 to FGridE.RowCount-1 do begin
     PSG:=Pointer(FGridE.Objects[0,i]);
     PTI:=PSG.PTI;
     PropName:=PSG.PropName;
//     ObjTmp:=PSG.Obj;
     PPI:=GetPropInfo(FValueObj.ClassInfo,PropName);
     PTM:=GetMethodProp(FValueObj,PPI);
     if PPI<>nil then begin
       case PTI.Kind of
            tkMethod: begin
              if PTM.Code<>nil then begin
                 for j:=0 to FTableMethod.Count-1 do begin
                   if PTM.Code=FTableMethod.Objects[j] then begin
                    FGridE.Cells[1,i]:=FTableMethod.Strings[j];
                    break;
                   end else
                     FGridE.Cells[1,i]:='';
                 end;
              end else FGridE.Cells[1,i]:='';
            end;
       end;
     end;
   end;
  end;
end;

function TtsvPnlInspector.ReadLangName(Index: integer; tmpG: TtsvStringGrid): String;
var
  PSG: PStructGrid;
  tmps:string;
begin
  PSG:=Pointer(tmpG.Objects[0,Index]);
  if PSG=nil then exit; 
  if (PSG.RusName<>'')or(PSG.EngName<>'')then begin
   case FLanguage of
     lgNone: tmps:=PSG.PropName;      
     lgEnglish: tmps:=PSG.EngName;
     lgRussian: tmps:=PSG.RusName;
   end;
  end else begin
    tmps:=PSG.PropName;
  end;
  Result:=tmps;
end;

procedure TtsvPnlInspector.UpdateLangLists(tmpG: TtsvStringGrid);
var
   i:integer;
   PSG:PStructGrid;
   val:integer;
begin
   if ListLang.Count=0 then exit;
   for i:=0 to tmpG.RowCount-1 do begin
      PSG:=Pointer(tmpG.Objects[0,i]);
      val:=ListLang.IndexOf(PSG.PropName);
      if Val<>-1 then begin
         if (ListRus.Count<>0)and(ListRus.Count=ListLang.Count) then
           PSG.RusName:=ListRus.Strings[val];
         if (ListEng.Count<>0)and(ListEng.Count=ListLang.Count) then
           PSG.EngName:=ListEng.Strings[val];
         if ((ListInfo.Count-1)>=Val) then
           PSG.Info:=ListInfo.Strings[val];
      end;
   end;
end;

procedure TtsvPnlInspector.Notification(AComponent: Tcomponent; Operation: TOperation);
begin
end;

procedure TtsvPnlInspector.SetFilter(Value: Boolean);
begin
  if Value<>FFilter then
    FFilter:=Value;
    UpdateInspector(TComponent(FValueObj));
end;

procedure TtsvPnlInspector.FilterForList;

  procedure FilterGrid(tmpg: TTsvStringGrid);
  var
   i,j:integer;
   PropName: string;
   tmps:String;
   PSG: PStructGrid;
  begin
   for i:=0 to FFilterItems.Count-1 do begin
     tmps:=FFilterItems.Strings[i];
      for j:=0 to tmpg.RowCount-1 do begin
       PSG:=Pointer(tmpg.Objects[0,j]);
       PropName:=PSG.PropName;
       if PropName='Name'then FIDName:=j;
       if Lowercase(tmps)=Lowercase(PropName) then begin
         if PropName='Name'then FIDName:=0;
         DelRow(j,1,tmpg);
         Break;
       end;
      end;
   end;
  end;

begin
   FilterGrid(FGridP);
   if FGridE<>nil then
    FilterGrid(FGridE);
end;

procedure TtsvPnlInspector.SetFilterItems(Value: TStringList);
begin
  FilterItems.Assign(Value);
end;

Procedure TtsvPnlInspector.AddStructGrid(TmpG: TTsvStringGrid; Index:Integer; PTI: PTypeInfo;
              PropName: String; Obj:Pointer);
begin
   New(tmpG.PStGd);
   tmpG.PstGd.PTI:=PTI;
   tmpG.PStGd.PropName:=PropName;
   tmpG.PstGd.Obj:=Obj;
   tmpG.Objects[0,Index]:=TObject(tmpG.PstGd);
end;

Procedure TtsvPnlInspector.ReplaceStructGrid(TmpG: TTsvStringGrid; Index:Integer; PTI: PTypeInfo;
              PropName: String; Obj:Pointer);
var
 PSG: PStructGrid;
begin
   PSG:=Pointer(tmpG.Objects[0,Index]);
   PSG.PTI:=PTI;
   PSG.PropName:=PropName;
   PSG.Obj:=Obj;
end;

procedure TtsvPnlInspector.SetLanguage(Value: TtsvLang);
begin
  if Value<>Flanguage then
    Flanguage:=Value;
end;

procedure TtsvPnlInspector.RefreshLang(Lang: TtsvLang);

    function ReadChar(ch: Char; var Value:Integer;
                     Index:Integer; tmpg: TtsvStringGrid): Boolean;
    var
      ch2:char;
      j:integer;
    begin
      Result:=false;
      for j:=0 to Length(tmpg.Cells[0,Index]) do begin
         ch2:=tmpg.Cells[0,Index][j];
         if ch2=ch then begin
           Value:=j;
           Result:=true;
           break;
         end;
      end;
    end;

   procedure ReadCellsName(tmpg: TtsvStringGrid);
   var
    i:integer;
    PSG:PStructGrid;
    tmps,s1:string;
    ch1:Char;
    val:integer;
   begin
    for i:=0 to tmpg.RowCount-1 do begin
    PSG:=Pointer(tmpg.Objects[0,i]);
    if (PSG.RusName<>'')or(PSG.EngName<>'') then begin
     case FLanguage of
      lgNone: s1:=PSG.PropName;
      lgRussian: s1:=PSG.RusName;
      lgEnglish: s1:=PSG.EngName;
     end;
   end else s1:=PSG.PropName;
    ch1:=s1[1];
    if not ReadChar(ch1,val,i,tmpg) then begin
      ch1:=PSG.PropName[1];
      ReadChar(ch1,val,i,tmpg);
    end;
    tmps:=tmpg.Cells[0,i];
    Delete(tmps,val,Length(tmps)-val+1);
    tmpg.Cells[0,i]:=tmps+ReadLangName(i,tmpg);
  end;
 end;

begin
  UpdateLangLists(FGridP);
  if FGridE<>nil then
   UpdateLangLists(FGridE);
  ReadCellsName(FGridP);
  if FGridE<>nil then
   ReadCellsName(FGridE);
end;

procedure TtsvPnlInspector.RefreshWithLanguageAndFilter(Lan: Boolean; Fil: Boolean);
begin
  if Lan then
   RefreshLang(FLanguage);
  FGridP.Sort;
  if FGridE<>nil then
   FGridE.Sort;
  RefreshInspector;
  if Fil then
    FilterForList;
  if FGridP.RowCount<>0 then
   FGridP.FocusCell(1,FIDName,true);
end;

procedure TtsvPnlInspector.WndProc(var Message: TMessage);
begin
  if Message.Msg=WM_BoundsChange then begin
   // RefreshInspector;
  end;
  inherited;
end;

procedure TtsvPnlInspector.SetFilterForCreate;
begin
  FFilterItems.Clear;
  // TForm
  FFilterItems.Add('Anchors');
  FFilterItems.Add('AlphaBlend');
  FFilterItems.Add('AlphaBlendValue');
  FFilterItems.Add('Action');
  FFilterItems.Add('ActiveControl');
  FFilterItems.Add('AutoScroll');
  FFilterItems.Add('BorderIcons');
  FFilterItems.Add('BiDiMode');
  FFilterItems.Add('DefaultMonitor');
  FFilterItems.Add('DockSite');
  FFilterItems.Add('DragKind');
  FFilterItems.Add('HelpContext');
  FFilterItems.Add('KeyPreview');
  FFilterItems.Add('Menu');
//  FFilterItems.Add('Name');
  FFilterItems.Add('ObjectMenuItem');
  FFilterItems.Add('OldCreateOrder');
  FFilterItems.Add('ParentBiDiMode');
  FFilterItems.Add('UseDockManager');
  FFilterItems.Add('Ctl3D');
  FFilterItems.Add('FormStyle');
  FFilterItems.Add('DragCursor');
  FFilterItems.Add('DragMode');
  FFilterItems.Add('HelpFile');
  FFilterItems.Add('Icon');
  FFilterItems.Add('ParentFont');
  FFilterItems.Add('PixelsPerInch');
  FFilterItems.Add('PopupMenu');
//  FFilterItems.Add('Position');
  FFilterItems.Add('PrintScale');
  FFilterItems.Add('Scaled');
  FFilterItems.Add('Tag');
  FFilterItems.Add('WindowMenu');
//  FFilterItems.Add('HorzScrollBar');
//  FFilterItems.Add('VertScrollBar');
  FFilterItems.Add('ClientHeight');
  FFilterItems.Add('ClientWidth');
  FFilterItems.Add('FocusControl');
  FFilterItems.Add('ShowAccelChar');
  FFilterItems.Add('ViewType');
  FFilterItems.Add('DocFile');
  FFilterItems.Add('ImeMode');
  FFilterItems.Add('ImeName');
  FFilterItems.Add('ParentCtl3D');
  FFilterItems.Add('HideSelection');
  FFilterItems.Add('OEMConvert');
  FFilterItems.Add('AllowGrayed');
  FFilterItems.Add('Columns');
  FFilterItems.Add('AllowAllUp');
  FFilterItems.Add('IncrementalDisplay');
  FFilterItems.Add('Images');
  FFilterItems.Add('MultiLine');
  FFilterItems.Add('OwnerDraw');
  FFilterItems.Add('RaggedRight');
  FFilterItems.Add('ScrollOpposite');
  FFilterItems.Add('ImageIndex');
  FFilterItems.Add('FormStyle');
  FFilterItems.Add('ScreenSnap');
  FFilterItems.Add('SnapBuffer');
  FFilterItems.Add('TransparentColor');
  FFilterItems.Add('TransparentColorValue');

  FFilterItems.Add('ButtonSize');
  FFilterItems.Add('Increment');
//  FFilterItems.Add('Range');
  FFilterItems.Add('Smooth');
  FFilterItems.Add('ThumbSize');
  FFilterItems.Add('Tracking');
  FFilterItems.Add('BlanksChar');
  FFilterItems.Add('YearDigits');
  FFilterItems.Add('DefaultToday');

  FFilterItems.Add('BevelEdges');
  FFilterItems.Add('BevelKind');
  FFilterItems.Add('HelpKeyword');
  FFilterItems.Add('HelpType');
  FFilterItems.Add('AutoCloseUp');
  FFilterItems.Add('AutoComplete');
  FFilterItems.Add('ScrollWidth');
  FFilterItems.Add('Format');
  FFilterItems.Add('ParentBackGround');
  FFilterItems.Add('ParentColor');
  FFilterItems.Add('ParentShowHint');
//  FFilterItems.Add('Transparent');
  FFilterItems.Add('ItemHeight');
  FFilterItems.Add('PasswordChar');
  FFilterItems.Add('WantReturns');
  FFilterItems.Add('WantTabs');
  FFilterItems.Add('State');
  FFilterItems.Add('ExtendedSelect');
  FFilterItems.Add('IntegralHeight');
  FFilterItems.Add('MultiSelect');
  FFilterItems.Add('TabWidth');
  FFilterItems.Add('FullRepaint');
  FFilterItems.Add('ThumbLength');
  FFilterItems.Add('TickMarks');
  FFilterItems.Add('TickStyle');
  FFilterItems.Add('CalAlignment');
  FFilterItems.Add('CalColors');
  FFilterItems.Add('BackColor');
  FFilterItems.Add('TextColor');
  FFilterItems.Add('TitleBackColor');
  FFilterItems.Add('TitleTextColor');
  FFilterItems.Add('MonthBackColor');
  FFilterItems.Add('TrailingTextColor');
  FFilterItems.Add('Highlighted');
  FFilterItems.Add('AutoDropDown');
  FFilterItems.Add('BeepOnError');
  FFilterItems.Add('ButtonHint');
  FFilterItems.Add('ButtonWidth');
  FFilterItems.Add('CheckOnExit');
  FFilterItems.Add('ClickKey');
  FFilterItems.Add('DecimalPlaces');
  FFilterItems.Add('DirectInput');
  FFilterItems.Add('DisplayFormat');
  FFilterItems.Add('FormatOnEditing');
  FFilterItems.Add('PopupAlign');
  FFilterItems.Add('ZeroEmpty');
  FFilterItems.Add('CalendarHints');
  FFilterItems.Add('CalendarStyle');
  FFilterItems.Add('DialogTitle');
  FFilterItems.Add('PopupColor');
  FFilterItems.Add('StartOfWeek');
  FFilterItems.Add('WeekendColor');
  FFilterItems.Add('Weekends');
  FFilterItems.Add('Sun');
  FFilterItems.Add('Mon');
  FFilterItems.Add('Tue');
  FFilterItems.Add('Wed');
  FFilterItems.Add('Thu');
  FFilterItems.Add('Fri');
  FFilterItems.Add('Sat');

  FFilterItems.Add('AlignWithMargins');
  FFilterItems.Add('Margins');
  FFilterItems.Add('Padding');
  FFilterItems.Add('PopupMode');
  FFilterItems.Add('PopupParent');

  FFilterItems.Add('EllipsisPosition');
  FFilterItems.Add('AutoCompleteDelay');
  FFilterItems.Add('DateAutoBetween');
  FFilterItems.Add('VerticalAlignment');
  FFilterItems.Add('Proportional');
  FFilterItems.Add('PositionTooltip');

  FFilterItems.Add('Down');
  FFilterItems.Add('Flat');
  FFilterItems.Add('GroupIndex');
  FFilterItems.Add('Spacing');
  FFilterItems.Add('ParseInput');
  FFilterItems.Add('HotTrack');
end;

procedure TtsvPnlInspector.SetTranslateForCreate;
begin
  ListLang.Clear;
  ListRus.Clear;
  ListInfo.Clear;
  with ListLang do begin

    Add('Name');
    ListRus.Add('Имя');
    ListInfo.Add('Это свойство содержит имя элемента');

    // TForm
    Add('Align');
    ListRus.Add('Привязка');
    ListInfo.Add('Это свойство позволяет привязывать элемент на элементе-родителе. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'alNone - без привязки, '+
                 #13#10+'alTop - сверху, '+
                 #13#10+'alBottom - снизу, '+
                 #13#10+'alLeft - слева, '+
                 #13#10+'alRight - справа, '+
                 #13#10+'alClient - границам, '+
                 #13#10+'alCustom - выборочно');
//    Add('Anchors');
//    ListRus.Add('Якори');
//    Add('akLeft');
//    ListRus.Add('левый');
//    Add('akTop');
//    ListRus.Add('верхний');
//    Add('akRight');
//    ListRus.Add('правый');
//    Add('akBottom');
//    ListRus.Add('нижний');
    Add('AutoSize');
    ListRus.Add('Авторазмер');
    ListInfo.Add('Это свойство позволяет подгонять размер элемента под размер, который он реально используется. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - включено, '+
                 #13#10+'False - выключено');
//    Add('BorderIcons');
//    ListRus.Add('Кнопки заголовка');
//    Add('biSystemMenu');
//    ListRus.Add('все кнопки');
//    Add('biMinimize');
//    ListRus.Add('кнопка свернуть');
//    Add('biMaximize');
//    ListRus.Add('кнопка развернуть');
//    Add('biHelp');
//    ListRus.Add('кнопка помощь');
    Add('BorderStyle');
    ListRus.Add('Стиль бордюра');
    ListInfo.Add('Это свойство устанавливает стиль краев элемента. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'bsNone - нет видимого бордюра, '+
                 #13#10+'bsSingle - бордюр очерчен одиночной линией');

    Add('BorderWidth');
    ListRus.Add('Ширина бордюра');
    ListInfo.Add('Это свойство устанавливает ширину бордюра в пикселях. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'0..65535 пикселей');

    Add('Caption');
    ListRus.Add('Заголовок');
    ListInfo.Add('Это свойство устанавливает значение заголовка элемента. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'Любые печатаемые символы');

    Add('Color');
    ListRus.Add('Цвет');
    ListInfo.Add('Это свойство устанавливает цвет');

    Add('Constraints');
    ListRus.Add('Ограничения');
    ListInfo.Add('Это свойство устанавливает ограничения максимальной - минимальной высоты и ширины');

    Add('MaxHeight');
    ListRus.Add('макс. высота');
    ListInfo.Add('Это свойство устанавливает максимальную высоту');

    Add('MaxWidth');
    ListRus.Add('макс. ширина');
    ListInfo.Add('Это свойство устанавливает максимальную ширину');

    Add('MinHeight');
    ListRus.Add('мин. высота');
    ListInfo.Add('Это свойство устанавливает минимальную высоту');

    Add('MinWidth');
    ListRus.Add('мин. ширина');
    ListInfo.Add('Это свойство устанавливает минимальную ширину');

    Add('Cursor');
    ListRus.Add('Курсор');
    ListInfo.Add('Это свойство устанавливает стиль курсора. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'Изображения курсоров представлены в выпадающем списке');

    Add('Enabled');
    ListRus.Add('Вкл/Выкл');
    ListInfo.Add('Это свойство сигнализирует о статусе элемента. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - включен, '+
                 #13#10+'False - выключен');

    Add('Font');
    ListRus.Add('Шрифт');
    ListInfo.Add('Это свойство устанавливает шрифт');

    Add('Charset');
    ListRus.Add('Кодировка');
    ListInfo.Add('Это свойство устанавливает кодировку шрифта');

    Add('Pitch');
    ListRus.Add('Точность');
    ListInfo.Add('Это свойство устанавливает точность шрифта');

    Add('Size');
    ListRus.Add('Размер');
    ListInfo.Add('Это свойство устанавливает размер шрифта');

    Add('Style');
    ListRus.Add('Стиль');
    ListInfo.Add('Это свойство устанавливает стиль шрифта');

    Add('fsBold');
    ListRus.Add('Жирный');
    ListInfo.Add('Это свойство устанавливает или убирает жирность шрифта. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - жирный, '+
                 #13#10+'False - обычный');

    Add('fsItalic');
    ListRus.Add('Наклонный');
    ListInfo.Add('Это свойство устанавливает или убирает наклонность шрифта. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - наклонный, '+
                 #13#10+'False - обычный');

    Add('fsUnderLine');
    ListRus.Add('Подчеркнутый');
    ListInfo.Add('Это свойство устанавливает или убирает подчеркнутость шрифта. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - подчеркнутый, '+
                 #13#10+'False - обычный');

    Add('fsStrikeOut');
    ListRus.Add('Перечеркнутый');
    ListInfo.Add('Это свойство устанавливает или убирает перечеркнутость шрифта. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - перечеркнутый, '+
                 #13#10+'False - обычный');

//    Add('FormStyle');
//    ListRus.Add('Стиль формы');

    Add('GridSize');
    ListRus.Add('Размер сетки');
    ListInfo.Add('Это свойство устанавливает размер сетки, которая используется для привязки элементов');

    Add('Height');
    ListRus.Add('Высота');
    ListInfo.Add('Это свойство устанавливает высоту элемента в пикселях');

    Add('Hint');
    ListRus.Add('Подсказка');
    ListInfo.Add('Это свойство устанавливает подсказку, которая отображается при наведении мышки на элемент');

    Add('Left');
    ListRus.Add('Слева');
    ListInfo.Add('Это свойство устанавливает позицию элемента слева (в пикселях)');

    Add('Position');
    ListRus.Add('Позиция');
    ListInfo.Add('');

    Add('ShowHint');
    ListRus.Add('Видимость подсказки');
    ListInfo.Add('Это свойство устанавливает или убирает видимость подсказки. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - видимая, '+
                 #13#10+'False - невидимая');


    Add('Top');
    ListRus.Add('Сверху');
    ListInfo.Add('Это свойство устанавливает позицию элемента сверху (в пикселях)');

    Add('Visible');
    ListRus.Add('Видимость');
    ListInfo.Add('Это свойство устанавливает или убирает видимость элемента. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - видимый, '+
                 #13#10+'False - невидимый');

    Add('Width');
    ListRus.Add('Ширина');
    ListInfo.Add('Это свойство устанавливает ширину элемента в пикселях');
    
    Add('WindowState');
    ListRus.Add('Состояние окна');
    ListInfo.Add('Это свойство устанавливает состояние окна');

    // TLabel
    Add('Alignment');
    ListRus.Add('Выравнивание по ширине');
    ListInfo.Add('Это свойство используется для выравнивания текста по ширине. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'taLeftJustify - слева, '+
                 #13#10+'taRightJustify - справа, '+
                 #13#10+'taCenter - по центру');


    Add('DocFieldName');
    ListRus.Add('Имя поля');
    ListInfo.Add('Это свойство используется для связывания элемента с полем текстового редактора. '+
                 'Если значение этого поля не совпадает с именем действительного поля, подстановка в последнее не будет осуществлена');

    Add('Layout');
    ListRus.Add('Выравнивание по высоте');
    ListInfo.Add('Это свойство используется для выравнивания текста по высоте. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'tlTop  - сверху, '+
                 #13#10+'tlCenter - по центру, '+
                 #13#10+'tlBottom - снизу');


//    Add('ParentColor');
//    ListRus.Add('Наследовать цвет от родителя');
//    Add('ParentShowHint');
//    ListRus.Add('Наследовать подсказку от родителя');
//    Add('Transparent');
//    ListRus.Add('Прозрачность');

    Add('WordWrap');
    ListRus.Add('Перенос слов');
    ListInfo.Add('Это свойство дает возможность автоматически переносить слова не следующую строку, если они не входят в текущую. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - переносить, '+
                 #13#10+'False - не переносить');

    // TComboBox
    Add('DropDownCount');
    ListRus.Add('Количество выпадающих строк');
    ListInfo.Add('Это свойство позволяет устанавливать количество строк при открытии выпадающего списка');

//    Add('ItemHeight');
//    ListRus.Add('Высота строки');

    Add('Items');
    ListRus.Add('Строки');
    ListInfo.Add('Это свойство позволяет редактировать строки используемые в элементе');

    Add('MaxLength');
    ListRus.Add('Макс. длина в символах');
    ListInfo.Add('Это свойство устанавливает максимально возможное количество символов, которые вводятся в элемент');

    Add('Sorted');
    ListRus.Add('Сортировка');
    ListInfo.Add('Это свойство дает возможность автоматически сортировать строки. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - сортировать, '+
                 #13#10+'False - не сортировать');

    Add('TabOrder');
    ListRus.Add('Номер порядка табуляции');
    ListInfo.Add('Это свойство устанавливает номер под которым будет находится элемент при обходе элементов, '+
                 'начиная с первого, с помощью клавиши TAB');

    Add('TabStop');
    ListRus.Add('Остановка по TAB');
    ListInfo.Add('Это свойство дает возможность включать и выключать остановку на элементе при обходе с помощью клавиши TAB. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - включить, '+
                 #13#10+'False - выключить');

    Add('Text');
    ListRus.Add('Текст');
    ListInfo.Add('Это свойство устанавливает текст элемента');

    // TEdit
    Add('AutoSelect');
    ListRus.Add('Автовыделение');
    ListInfo.Add('Это свойство позволяет включать и выключать автоматическое выделение текста элемента при попадении на него фокуса. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - включить, '+
                 #13#10+'False - выключить');

    Add('CharCase');
    ListRus.Add('Регистр букв');
    ListInfo.Add('Это свойство изменяет регистр букв элемента. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'ecNormal - нормальный, '+
                 #13#10+'ecUpperCase - верхний или большие, '+
                 #13#10+'ecLowerCase - нижний или маленькие');

//    Add('PasswordChar');
//    ListRus.Add('Буква пароля');

    Add('ReadOnly');
    ListRus.Add('Только для чтения');
    ListInfo.Add('Это свойство позволяет включать и выключать возможность редактирования текста элемента. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - нельзя редактировать, '+
                 #13#10+'False - можно редактировать');

    // TMemo
    Add('Lines');
    ListRus.Add('Строки');
    ListInfo.Add('Это свойство позволяет редактировать строки используемые в элементе');

    Add('ScrollBars');
    ListRus.Add('Движки');
    ListInfo.Add('Это свойство устанавливает тип движков. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'ssNone - нет движков, '+
                 #13#10+'ssHorizontal - горизонтальный, '+
                 #13#10+'ssVertical - вертикальный, '+
                 #13#10+'ssBoth - горизонтальный и вертикальный');

//    Add('WantReturns');
//    ListRus.Add('Возврат коретки');

//    Add('WantTabs');
//    ListRus.Add('Смещение по TAB');

    // TCheckBox
    Add('Checked');
    ListRus.Add('Выбрано');
    ListInfo.Add('Это свойство устанавливает один из двух вариантов: есть флажок или нет. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - есть флажок, '+
                 #13#10+'False - нет флажка');

//    Add('State');
//    ListRus.Add('Состояние');

    // TlistBox
//    Add('ExtendedSelect');
//    ListRus.Add('Расширенный выбор');
//    Add('IntegralHeight');
//    ListRus.Add('Интегральная высота');
//    Add('MultiSelect');
//    ListRus.Add('Мультивыбор');
//    Add('TabWidth');
//    ListRus.Add('Ширина отступа');

    // TRadioGroupBox
    Add('ItemIndex');
    ListRus.Add('Текущий индекс');
    ListInfo.Add('Это свойство устанавливает индекс строки по умолчанию. Отсчет идет с нуля');

    // TPanel
    Add('BevelInner');
    ListRus.Add('Внутреняя граница');
    ListInfo.Add('Это свойство устанавливает тип внутренней границы элемента. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'bvNone - без границ, '+
                 #13#10+'bvLowered - вдавленная, '+
                 #13#10+'bvRaised - выпуклая, '+
                 #13#10+'bvSpace - пустая');

    Add('BevelOuter');
    ListRus.Add('Внешняя граница');
    ListInfo.Add('Это свойство устанавливает тип внешней границы элемента. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'bvNone - без границ, '+
                 #13#10+'bvLowered - вдавленная, '+
                 #13#10+'bvRaised - выпуклая, '+
                 #13#10+'bvSpace - пустая');

    Add('BevelWidth');
    ListRus.Add('Ширина границы');
    ListInfo.Add('Это свойство устанавливает ширину границы');

//    Add('FullRepaint');
//    ListRus.Add('Полная перерисовка');
    Add('Locked');
    ListRus.Add('Блокировка');
    ListInfo.Add('Это свойство указывает заблокирован элемент или нет от применения правил при построении элементов. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - включена, '+
                 #13#10+'False - выключена');

    // TSpeedButton
{    Add('Down');
    ListRus.Add('Вниз');
    ListInfo.Add('Это свойство указывает кнопка нажата или нет. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - нажата, '+
                 #13#10+'False - нет');

    Add('Flat');
    ListRus.Add('Флат');
    ListInfo.Add('Это свойство указывает кнопка выпуклая или нет. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - выпуклая, '+
                 #13#10+'False - нет');}
    
    Add('Glyph');
    ListRus.Add('Картинка');
    ListInfo.Add('Это свойство позволяет выбирать изображение');

{    Add('GroupIndex');
    ListRus.Add('Индекс группы');
    ListInfo.Add('');}

    Add('Margin');
    ListRus.Add('Смещение');
    ListInfo.Add('');

    Add('NumGlyphs');
    ListRus.Add('Количество картинок');
    ListInfo.Add('');

{    Add('Spacing');
    ListRus.Add('Расстояние');
    ListInfo.Add('');}

    //TMaskEdit
    Add('EditMask');
    ListRus.Add('Поле маски');
    ListInfo.Add('Это свойство устанавливает формат маски');

    // TImage
    Add('Center');
    ListRus.Add('Центровка');
    ListInfo.Add('Это свойство устанавливает картинку по центру. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - включена, '+
                 #13#10+'False - выключена');

    Add('Picture');
    ListRus.Add('Изображение');
    ListInfo.Add('Это свойство позволяет выбирать изображение');

    Add('Stretch');
    ListRus.Add('Растяжение');
    ListInfo.Add('Это свойство растягивает картинку. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - включено, '+
                 #13#10+'False - выключено');

    // TShape
    Add('Brush');
    ListRus.Add('Кисть');
    ListInfo.Add('');

    Add('Pen');
    ListRus.Add('Карандаш');
    ListInfo.Add('');

    Add('Mode');
    ListRus.Add('Режим');
    ListInfo.Add('');

    Add('Shape');
    ListRus.Add('Фигура');
    ListInfo.Add('');

    // TSplitter
    Add('AutoSnap');
    ListRus.Add('Автошаг');
    ListInfo.Add('');

    Add('Beveled');
    ListRus.Add('Граница');
    ListInfo.Add('');

    Add('MinSize');
    ListRus.Add('Минимальный размер');
    ListInfo.Add('');

    Add('ResizeStyle');
    ListRus.Add('Стиль изменения размера');
    ListInfo.Add('');

    // TRichEdit
    Add('HideScrollBars');
    ListRus.Add('Скрыть движки');
    ListInfo.Add('');

    Add('PlainText');
    ListRus.Add('Ровный текст');
    ListInfo.Add('Это свойство преобразует текст из форматированного в обычный и наоборот. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - обычный, '+
                 #13#10+'False - форматированный');

    // TTrackBar
    Add('Frequency');
    ListRus.Add('Частота');
    ListInfo.Add('');

    Add('LineSize');
    ListRus.Add('Размер линии');
    ListInfo.Add('');

    Add('Max');
    ListRus.Add('Максимум');
    ListInfo.Add('');

    Add('Min');
    ListRus.Add('Минимум');
    ListInfo.Add('');

    Add('Orientation');
    ListRus.Add('Ориетация');
    ListInfo.Add('');

    Add('PageSize');
    ListRus.Add('Размер страницы');
    ListInfo.Add('');

    Add('SelEnd');
    ListRus.Add('Конец выделения');
    ListInfo.Add('');

    Add('SelStart');
    ListRus.Add('Начало выделения');
    ListInfo.Add('');

    Add('SliderVisible');
    ListRus.Add('Видимость движка');
    ListInfo.Add('');

//    Add('ThumbLength');
//    ListRus.Add('Длина пальца');
//    ListInfo.Add('');

//    Add('TickMarks');
//    ListRus.Add('Маркировка метки');
//    Add('TickStyle');
//    ListRus.Add('Стиль метки');

    // TAnimate
    Add('Active');
    ListRus.Add('Активно');
    ListInfo.Add('');

    Add('CommonAVI');
    ListRus.Add('Анимации');
    ListInfo.Add('');

    Add('FileName');
    ListRus.Add('Имя файла');
    ListInfo.Add('');

    Add('Repetitions');
    ListRus.Add('Повторения');
    ListInfo.Add('');

    Add('StartFrame');
    ListRus.Add('Кадр начала');
    ListInfo.Add('');

    Add('StopFrame');
    ListRus.Add('Кадр конца');
    ListInfo.Add('');

    Add('Timers');
    ListRus.Add('Таймеры');
    ListInfo.Add('');

    // TDateTimePicker
//    Add('CalAlignment');
//    ListRus.Add('Выравнивание дат');
//    Add('CalColors');
//    ListRus.Add('Цвета дат');
    Add('Date');
    ListRus.Add('Дата');
    ListInfo.Add('Свойство устанавливает дату по умолчанию');

    Add('DateFormat');
    ListRus.Add('Формат даты');
    ListInfo.Add('Это свойство устанавливает формат отображения даты. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'dfShort - сокращенный, '+
                 #13#10+'dfLong - полный');

    Add('DateMode');
    ListRus.Add('Режим даты');
    ListInfo.Add('Это свойство режим выбора даты. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'dmComboBox - выпадающий список, '+
                 #13#10+'dmUpDown - перечислимый');

    Add('Kind');
    ListRus.Add('Тип');
    ListInfo.Add('Это свойство устанавливает тип элемента. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'dtkDate - ввод даты, '+
                 #13#10+'dtkTime - ввод времени');

    Add('MaxDate');
    ListRus.Add('Максимальная дата');
    ListInfo.Add('Свойство устанавливает максимально возможную дату');

    Add('MinDate');
    ListRus.Add('Минимальная дата');
    ListInfo.Add('Свойство устанавливает минимально возможную дату');

{    Add('ParseInput');
    ListRus.Add('Разбирать ввод');
    ListInfo.Add('');}

    Add('ShowCheckBox');
    ListRus.Add('Показывать флаг выбора');
    ListInfo.Add('');

    Add('Time');
    ListRus.Add('Время');
    ListInfo.Add('Свойство устанавливает время по умолчанию');

//    Add('BackColor');
//    ListRus.Add('Задний цвет');
//    Add('TextColor');
//    ListRus.Add('Цвет текста');
//    Add('TitleBackColor');
//    ListRus.Add('Задний цвет заголовка');
//    Add('TitleTextColor');
//    ListRus.Add('Цвет текста заголовка');
//    Add('MonthBackColor');
//    ListRus.Add('Задний цвет месяца');
//    Add('TrailingTextColor');
//    ListRus.Add('Цвет прослеживания');

    Add('WordFormType');
    ListRus.Add('Тип поля');
    ListInfo.Add('Это свойство указывает на тип поля, который используется для подстановки. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'wtFieldQuote - тип поля Quote (это пока единственный поддерживаемый тип), '+
                 #13#10+'wtFieldNone - без типа');

//    Add('Highlighted');
//    ListRus.Add('Подсвечивать');
//    ListInfo.Add('Это свойство позволяет подсвечивать текст элемента при наведении мыши. '+
//                 #13#10+
//                 #13#10+'Возможные значения: '+
//                 #13#10+'True - подсвечивать, '+
//                 #13#10+'False - не подсвечивать');

    Add('TabVisible');
    ListRus.Add('Видимость закладки');
    ListInfo.Add('Это свойство позволяет скрывать закладку. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - не скрывать, '+
                 #13#10+'False - скрывать');

    Add('PageIndex');
    ListRus.Add('Индекс закладки');
    ListInfo.Add('Это свойство устанавливает порядок закладки начиная с нуля');

    Add('ActivePage');
    ListRus.Add('Активная закладка');
    ListInfo.Add('Это свойство устанавливает какая из закладок будет по умолчанию открыта. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'любая из созданных закладок');

{    Add('HotTrack');
    ListRus.Add('Подсветка закладок');
    ListInfo.Add('Это свойство позволяет подсвечивать текст при наведении мыши. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - подсвечивать, '+
                 #13#10+'False - не подсвечивать');}

    Add('TabHeight');
    ListRus.Add('Высота закладок');
    ListInfo.Add('Это свойство устанавливает высоту закладок в пикселях');

    Add('TabPosition');
    ListRus.Add('Позиция закладок');
    ListInfo.Add('Это свойство позволяет менять расположение закладок. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'tpTop - располагать сверху, '+
                 #13#10+'tpBottom - располагать снизу, '+
                 #13#10+'tpLeft - располагать слева, '+
                 #13#10+'tpRight - располагать справа');

    Add('WrittenOut');
    ListRus.Add('Тип прописи');
    ListInfo.Add('Это свойство позволяет изменять тип расписывания дат и чисел. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'woNormal - как и оригинал, '+
                 #13#10+'woLong - расписывать полностью, '+
                 #13#10+'woParentheses - расписывать с окончанием, '+
                 #13#10+'woLongRodit - расписывать полностью и в родительном падеже');

    { TRxCalcEdit }
//    Add('AutoDropDown');
//    ListRus.Add('Авто раскрывание');
//    Add('BeepOnError');
//    ListRus.Add('Звук в случае ошибки');
//    Add('ButtonHint');
//    ListRus.Add('Описание кнопки');
//    Add('ButtonWidth');
//    ListRus.Add('Ширина кнопки');
//    Add('CheckOnExit');
//    ListRus.Add('Проверка на выход');
//    Add('ClickKey');
//    ListRus.Add('Клавиши на раскрывание');
//    Add('DecimalPlaces');
//    ListRus.Add('Количество знаков после запятой');
//    Add('DirectInput');
//    ListRus.Add('Направление ввода');
//    Add('DisplayFormat');
//    ListRus.Add('Формат показа');
//    Add('FormatOnEditing');
//    ListRus.Add('Показывать формат при редактировании');
    Add('GlyphKind');
    ListRus.Add('Выбор картинки кнопки');
    ListInfo.Add('Это свойство позволяет выбирать картинку кнопки');

    Add('MaxValue');
    ListRus.Add('Максимальное значение');
    ListInfo.Add('Это свойство позволяет ограничивать максимальное значение');

    Add('MinValue');
    ListRus.Add('Минимальное значение');
    ListInfo.Add('Это свойство позволяет ограничивать минимальное значение');

//    Add('PopupAlign');
//    ListRus.Add('Выравнивание окна');

    Add('Value');
    ListRus.Add('Значение');
    ListInfo.Add('Это свойство устанавливает значение элемента');

//    Add('ZeroEmpty');
//    ListRus.Add('Обнулять если пусто');

    Add('TypeCase');
    ListRus.Add('Падеж');
    ListInfo.Add('Это свойство позволяет установить падеж элемента. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'tcNone - без падежа, '+
                 #13#10+'tcIminit - именительный, '+
                 #13#10+'tcRodit - родительный, '+
                 #13#10+'tcDatel - дательный, '+
                 #13#10+'tcTvorit - творительный, '+
                 #13#10+'tcVinit - винительный, '+
                 #13#10+'tcPredl - предложный');


    Add('TypeUpperLower');
    ListRus.Add('Преобразование значения');
    ListInfo.Add('Это свойство позволяет перед выводом текста его преобразовывать. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'tulNone - без преобразования, '+
                 #13#10+'tulFirstUpper - делать первую букву заглавной');

    Add('Signature');
    ListRus.Add('Подпись после');
    ListInfo.Add('Это свойство устанавливает текст после основного текста, т.е. дописывает в конец');

    Add('ToSign');
    ListRus.Add('Подпись до');
    ListInfo.Add('Это свойство устанавливает текст до основного текста, т.е. приписывает в начало');

    Add('Links');
    ListRus.Add('Связи');
    ListInfo.Add('Это свойство позволяет связывать различные элементы, после чего при наборе текста '+
                 'в одном элементе, этот текст выводится и в связанных элементах');
    
    Add('InsertedValues');
    ListRus.Add('Вставка дополнительных значений');
    ListInfo.Add('Это свойство добавляет или убирает приведенные под + (плюсом) функции');

    Add('tivFromDealNum');
    ListRus.Add('Номер из наследственных дел');
    ListInfo.Add('Это свойство включает или выключает передачу номера из наследственного дела (при выборе последнего) в элемент. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - передавать, '+
                 #13#10+'False - не передавать');

    Add('tivFromDealFIo');
    ListRus.Add('ФИО из наследственных дел');
    ListInfo.Add('Это свойство включает или выключает передачу ФИО из наследственного дела (при выборе последнего) в элемент. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - передавать, '+
                 #13#10+'False - не передавать');

    Add('tivFromDealDeathDate');
    ListRus.Add('Дата смерти из наследственных дел');
    ListInfo.Add('Это свойство включает или выключает передачу дату смерти из наследственного дела (при выборе последнего) в элемент. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - передавать, '+
                 #13#10+'False - не передавать');

    Add('tivFromHeaderFIO');
    ListRus.Add('ФИО из необходимых реквизитов');
    ListInfo.Add('Это свойство включает или выключает передачу ФИО из необходимых реквизитов в элемент. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - передавать, '+
                 #13#10+'False - не передавать');

    Add('tivFromConstTownDefault');
    ListRus.Add('Город по умолчанию из констант');
    ListInfo.Add('Это свойство включает или выключает передачу города по умолчанию из констант в элемент. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - передавать, '+
                 #13#10+'False - не передавать');

    Add('ActiveTimer');
    ListRus.Add('Активировать таймер');
    ListInfo.Add('Это свойство включает и выключает таймер. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - включить, '+
                 #13#10+'False - выключить');

    Add('Subs');
    ListRus.Add('Подстановка из');
    ListInfo.Add('Это свойство позволяет устанавливать справочник подстановок, который будет использоваться для выбора значения, при помощи клавиши F7');

    Add('WordStyle');
    ListRus.Add('Стиль в документе');
    ListInfo.Add('Это свойство устанавливат имя стиля в текстовом редакторе, который будет применяться при передачи значения из элемента в поле. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'любое имя стиля, которое существует в документе, привязанном к этой форме');

    Add('WordAutoFormat');
    ListRus.Add('Автоформат');
    ListInfo.Add('Это свойство включает и выключает функцию автоматического форматирования поля в текстовом редакторе. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - включить, '+
                 #13#10+'False - выключить');

   Add('HorzScrollBar');
   ListRus.Add('Горизонтальный движок');
   ListInfo.Add('');

   Add('VertScrollBar');
   ListRus.Add('Вертикальный движок');
    ListInfo.Add('');

   Add('Blocking');
   ListRus.Add('Блокировка');
    ListInfo.Add('Это свойство указывает заблокирован элемент или нет от применения правил при построении элементов. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - включена, '+
                 #13#10+'False - выключена');

//   Add('CalendarHints');
//   ListRus.Add('Подсказки календаря');
//   Add('CalendarStyle');
//   ListRus.Add('Стиль календаря');
//   Add('DialogTitle');
//   ListRus.Add('Заголовок диалога');
//   Add('PopupColor');
//   ListRus.Add('Цвет всплывающего окна');
//   Add('StartOfWeek');
//   ListRus.Add('Начало недели с');
//   Add('WeekendColor');
//   ListRus.Add('Цвет выходных');
//   Add('Weekends');
//   ListRus.Add('Выходные дни');
//   Add('Sun');
//   ListRus.Add('Воскресенье');
//   Add('Mon');
//   ListRus.Add('Понедельник');
//   Add('Tue');
//   ListRus.Add('Вторник');
//   Add('Wed');
//   ListRus.Add('Среда');
//   Add('Thu');
//   ListRus.Add('Четверг');
//   Add('Fri');
//   ListRus.Add('Пятница');
//   Add('Sat');
//   ListRus.Add('Суббота');
   Add('DefaultWorkDate');
   ListRus.Add('По умолчанию рабочая дата');
    ListInfo.Add('Это свойство включает или выключает функцию автоматической подстановки рабочей даты в элемент. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - включена, '+
                 #13#10+'False - выключена');

   
   Add('LabelPosition');
   ListRus.Add('Позиция метки');
    ListInfo.Add('Это свойство устанавливает позицию метки вокруг элемента. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'lpTopLeft - сверху слева, '+
                 #13#10+'lpTopCenter - сверху по центру, '+
                 #13#10+'lpTopRight - сверху справа, '+
                 #13#10+'lpBottomLeft - снизу слева, '+
                 #13#10+'lpBottomCenter - снизу по центру, '+
                 #13#10+'lpBottomRight - снизу справа, '+
                 #13#10+'lpLeftTop - слева сверху, '+
                 #13#10+'lpLeftCenter - слева по центру, '+
                 #13#10+'lpLeftBottom - слева снизу, '+
                 #13#10+'lpRightTop - справа сверху, '+
                 #13#10+'lpRightCenter - справа по центру, '+
                 #13#10+'lpRightBottom - справа снизу, '+
                 #13#10+'lpNoneVisible - не отображать');

   Add('LabelCaption');
   ListRus.Add('Текст метки');
   ListInfo.Add('Это свойство позволяет редактировать текст метки элемента');

   Add('AutoOpenSubs');
   ListRus.Add('Автооткрытие подстановок');
    ListInfo.Add('Это свойство включает или выключает функцию автоматического открытия справочника подстановок при попадении фокуса на элемент. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - включена, '+
                 #13#10+'False - выключена');


   Add('AutoFillSubs');
   ListRus.Add('Автозаполнение из подстановок');
    ListInfo.Add('Это свойство включает или выключает функцию автоматического заполнения списка строк из справочника подстановок при открытии формы. '+
                 #13#10+
                 #13#10+'Возможные значения: '+
                 #13#10+'True - включена, '+
                 #13#10+'False - выключена');

   // TNewForm
   Add('Script');
   ListRus.Add('Скрипт');
    ListInfo.Add('Содержит скрипт выполнения перед заполнением констант');

   //TPageControl
   Add('TabIndex');
   ListRus.Add('Индекс закладки');
    ListInfo.Add('Индекс закладки по умолчанию, начинается с нуля');

   //TLabel
   Add('Transparent');
   ListRus.Add('Прозрачность');
    ListInfo.Add('Это свойство включает или выключает прозрачность фона');

   //TControlBar
   Add('Range');
   ListRus.Add('Диапазон');
    ListInfo.Add('Это свойство устанавливает диапазон');

  end;

end;

procedure TtsvPnlInspector.FillListCursorImages;
var
  ix: Integer;
  ic: TIcon;
begin
  with FListCursorImages do begin
    FListCursorImages.BlendColor:=clBlack;
    FListCursorImages.BkColor:=clWhite;
    Width:=32;
    Height:=32;
    ic:=TIcon.Create;
    try
     for ix:=0 to CountCursors-1 do begin
      try
       ic.Handle:=Screen.Cursors[NameCursors[ix].Value];
       AddIcon(ic);
      except
      end;
     end;
    finally
      ic.Free;
    end;
  end;
end;

procedure TtsvPnlInspector.LocateLastProp;
var
  i: Integer;
  PSG: PStructGrid;
  PropName: string;
begin
  if Trim(FLastProp)='' then exit;
  for i:=0 to FGridP.RowCount-1 do begin
     PSG:=Pointer(FGridP.Objects[0,i]);
     PropName:=PSG.PropName;
     if PropName=FLastProp then begin
       FGridP.FocusCell(1,i,true);
       exit;
     end;
  end;
  
end;

procedure TtsvPnlInspector.GridPOnSelectCell(Sender: TObject; ACol, ARow: Longint;
                var CanSelect: Boolean);
var
  PSG: PStructGrid;
  PropName: string;
begin
  PSG:=Pointer(FGridP.Objects[0,ARow]);
  PropName:=PSG.PropName;
  FLastProp:=PropName;
  CanSelect:=true;
end;

initialization
  RegisterClass(TBevel);

end.


