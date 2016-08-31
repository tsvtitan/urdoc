unit tsvDbGrid;

interface

uses Windows, SysUtils, Messages, Classes, Controls, Forms, StdCtrls,
  Graphics, Grids, DBCtrls,DbGrids, Db, Menus, ImgList;

type

  TtsvDbGrid=class;
  TRowSelected=class(TPersistent)
    private
      FFont: TFont;
      FBrush: TBrush;
      FPen: TPen;
      FGrid: TtsvDbGrid;
      FVisible: Boolean;
      FUnSelectedBrushColor: TColor;
      FUnSelectedFontColor: TColor;
      procedure SetFont(Value: TFont);
      procedure SetBrush(Value: TBrush);
      procedure SetPen(Value: TPen);
      procedure SetVisible(Value: Boolean);
    public
      constructor Create(AOwner: TtsvDbGrid);
      destructor Destroy;override;
    published
      property Font: TFont read FFont write SetFont;
      property Brush: TBrush read FBrush write SetBrush;
      property Pen: Tpen read Fpen write SetPen;
      property Visible: Boolean read FVisible write SetVisible;
      property UnSelectedBrushColor: TColor read FUnSelectedBrushColor write FUnSelectedBrushColor;
      property UnSelectedFontColor: TColor read FUnSelectedFontColor write FUnSelectedFontColor; 
  end;


  TSelectedCell=class(TCollectionItem)
   private
    FFont: TFont;
    FBrush: TBrush;
    FPen: TPen;
    FFieldValues: TStringList;
    FFieldNames:TStringList;
    FVisible: Boolean;
    procedure SetFont(Value: TFont);
    procedure SetBrush(Value: TBrush);
    procedure SetPen(Value: TPen);
    procedure SetFieldValues(Value: TStringList);
    procedure SetFieldNames(Value: TStringList);
    procedure SetVisible(Value: Boolean);
   public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
   published
    property Font: TFont read FFont write SetFont;
    property Brush: TBrush read FBrush write SetBrush;
    property Pen: Tpen read FPen write SetPen;
    property FieldValues: TStringList read FFieldValues write SetFieldValues;
    property FieldNames: TStringList read FFieldNames write SetFieldNames;
    property Visible: Boolean read FVisible write SetVisible;
  end;

  TSelCellClass=class of TSelectedCell;

  TSelectedCells=class(TCollection)
  private
    FGrid: TtsvDbGrid;
    function GetSelCell(Index: Integer): TSelectedCell;
    procedure SetSelCell(Index: Integer; Value: TSelectedCell);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(Grid: TtsvDbGrid; SelCellClass: TSelCellClass);
    function  Add: TSelectedCell;
    property Grid: TtsvDbGrid read FGrid;
    property Items[Index: Integer]: TSelectedCell read GetSelCell write SetSelCell; default;
  end;
  
  TNewGridDataLink = class(TGridDataLink)
  end;


  TTypeColumnSort=(tcsNone,tcsAsc,tcsDesc);
  TOnTitleClickWithSort=procedure(Column: TColumn; TypeSort: TTypeColumnSort)of object;


  TtsvDbGrid=class(TCustomDBGrid)
  private
    FColumnSortEnabled: Boolean;
    NotSetLocalWidth: Boolean;
    FMultiSelect: Boolean;
    FOldGridState: TGridState;
    OldCell: TGridCoord;
    FTitleX,FTitleY: Integer;
    FTitleMouseDown: Boolean;
    FRowSelected: TRowSelected;
    FTitleCellMouseDown: TRowSelected;
    FCellSelected: TRowSelected;
    FSelectedCells: TSelectedCells;
    FRowSizing: Boolean;
    FRowHeight: Integer;
    FColumnSort: TColumn;
    FListColumnSort: TList;
    FOnTitleClickWithSort: TOnTitleClickWithSort;
    FImageList: TImageList;
    FTitleClickInUse: Boolean;
    FVisibleRowNumber: Boolean;
    FNewDefaultRowHeight : Integer;
    FColumnSortColor: TColor;
    FOldColumnSortColor: TColor;
//    FRealTopRow: Integer;
    procedure ClearListColumnSort;
    procedure SetColumnSort(Column: TColumn);
    procedure SetRowSelected(Value: TRowSelected);
    procedure SetCellSelected(Value: TRowSelected);
    procedure SetSelectedCells(Value: TSelectedCells);
    procedure SetTitleCellMouseDown(Value: TRowSelected);
    procedure SetRowSizing(Value: Boolean);
    procedure SetRowHeight(Value: Integer);
    procedure SetMultiSelect(Value: Boolean);
    procedure SetColumnSortEnabled(Value: Boolean);
    procedure SetVisibleRowNumber(Value: Boolean);
    procedure SetWidthRowNumber(NewRow: Integer);
    function GetRealTopRow(NewRow: Integer): Integer;
    procedure SetDefaultRowHeight(Value: Integer);
    function GetMinRowHeight: Integer;
    function GetDefaultRowHeight: Integer;

//    procedure MouseToCell(X,Y:Integer; var ACol,ARow:Integer);

    function GetTypeColumnSortEx: TTypeColumnSort;
    procedure SetTypeColumnSortEx(Value: TTypeColumnSort);

  public
    DrawRow,CurrentRow: Integer;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure DrawDataCell(const Rect: TRect; Field: TField;
      State: TGridDrawState); override;
    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    property Canvas;
    property SelectedRows;
    procedure WMMouseWheel(var Message: TWMMouseWheel);message WM_MOUSEWHEEL;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    function GetShortString(w: integer; str,text: string): string;
    procedure WriteTextEx(ARow,ACol: Integer; rt: Trect; Alignment: TAlignment; Text: String ; DX,DY: Integer;
                          var TextW: Integer; TextWidthMinus: Integer=0);
    procedure TitleClick(Column: TColumn); override;
    procedure DblClick;override;
    procedure CalcSizingState(X, Y: Integer;
                              var State: TGridState; var Index, SizingPos, SizingOfs: Integer;
                               var FixedInfo: TGridDrawInfo);override;
    function GetTypeColumnSort(Column: TColumn): TTypeColumnSort;
    procedure SetTypeColumnSort(Column: TColumn; TypeSort: TTypeColumnSort);
    procedure DrawSort(Canvas: TCanvas; ARect: TRect; TypeSort: TTypeColumnSort);
    procedure ClearColumnSort;
    procedure SetColumnAttributes; override;
    procedure Scroll(Distance: Integer); override;
    procedure TopLeftChanged; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure SetEditText(ACol, ARow: Longint; const Value: string);override;
    function GetEditText(ACol, ARow: Longint): string;override;
    function SelectCell(ACol, ARow: Longint): Boolean;override;
    procedure TimedScroll(Direction: TGridScrollDirection);override;
    procedure RowHeightsChanged; override;
    procedure LayoutChanged; override;
    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
    procedure DefaultDrawRowCellSelected(const Rect: TRect; DataCol: Integer;
                                               Column: TColumn; State: TGridDrawState);
    procedure UpdateRowNumber;
    procedure DoTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); virtual;

    property ColumnSort: TColumn read FColumnSort write SetColumnSort;
    property ColumnSortEnabled: Boolean read FColumnSortEnabled write SetColumnSortEnabled;
    property ColumnSortType: TTypeColumnSort read GetTypeColumnSortEx write SetTypeColumnSortEx;
    property ColumnSortColor: TColor read FColumnSortColor write FColumnSortColor;

  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Columns stored False; //StoreColumns;
    property Constraints;
    property Ctl3D;
    property DataSource;
    property DefaultDrawing;
    property DefaultRowHeight: Integer read GetDefaultRowHeight write SetDefaultRowHeight;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FixedColor;
    property FixedCols;
    property Font;
    property ImeMode;
    property ImeName;
    property Options;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RowSelected: TRowSelected read FRowSelected write SetRowSelected;
    property CellSelected: TRowSelected read FCellSelected write SetCellSelected;
    property TitleCellMouseDown: TRowSelected read FTitleCellMouseDown write SetTitleCellMouseDown;
    property TitleMouseDown: Boolean read FTitleMouseDown;
    property RowSizing: Boolean read FRowSizing write SetRowSizing;
    property RowHeight: Integer read FRowHeight write SetRowHeight;
    property ShowHint;
    property SelectedCells: TSelectedCells read FSelectedCells write SetSelectedCells;
    property TabOrder;
    property TabStop;
    property TitleFont;
    property Visible;
    property VisibleRowNumber: Boolean read FVisibleRowNumber write SetVisibleRowNumber;
    property OnCellClick;
    property OnColEnter;
    property OnColExit;
    property OnColumnMoved;
    property OnDrawDataCell;  { obsolete }
    property OnDrawColumnCell;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditButtonClick;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnTitleClick;
    property OnTitleClickWithSort: TOnTitleClickWithSort read FOnTitleClickWithSort write FOnTitleClickWithSort;
  end;

{$R TSVDBGrid.res}

implementation

const
   DefaultVisibleRowNumber=60;
   DefaultVisibleRowNumberCaption='¹';

type
  TTempGrid=class(TCustomGrid)
    public
      property Options;
  end;



  PInfoColumnSort=^TInfoColumnSort;
  TInfoColumnSort=packed record
    Column: TColumn;
    TypeColumnSort: TTypeColumnSort; 
  end;

{ TRowSelected }

constructor TRowSelected.Create(AOwner: TtsvDbGrid);
begin
  FGrid:=AOwner;
  FFont:=TFont.Create;
  FBrush:=TBrush.Create;
  FPen:=Tpen.Create;
  FVisible:=false;
end;

destructor TRowSelected.Destroy;
begin
  FFont.Free;
  FBrush.Free;
  FPen.Free;
end;

procedure TRowSelected.SetFont(Value: TFont);
begin
  if Value<>FFont then begin
    FFont.Assign(Value);
    FGrid.DefaultDrawing:=true;
    FGrid.InvalidateRow(FGrid.row);
  end;
end;

procedure TRowSelected.SetBrush(Value: TBrush);
begin
  if Value<>FBrush then begin
    FBrush.Assign(Value);
    FGrid.DefaultDrawing:=true;
    FGrid.InvalidateRow(FGrid.row);
  end;
end;

procedure TRowSelected.SetPen(Value: TPen);
begin
  if Value<>Fpen then begin
    FPen.Assign(Value);
    FGrid.DefaultDrawing:=true;
    FGrid.InvalidateRow(FGrid.row);
  end;
end;

procedure TRowSelected.SetVisible(Value: Boolean);
begin
  if Value<>FVisible then begin
    FVisible:=Value;
    FGrid.DefaultDrawing:=true;
    FGrid.InvalidateRow(FGrid.row);
  end;
end;

{ TSelectedCell }


constructor TSelectedCell.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFont := TFont.Create;
  FBrush:= TBrush.Create;
  Fpen:=TPen.Create;
  FFieldValues:=TStringList.Create;
  FFieldNames:=TStringList.Create;
  FVisible:=true;
end;

destructor TSelectedCell.Destroy;
begin
  FFont.Free;
  FBrush.Free;
  FPen.Free;
  FFieldValues.Free;
  FFieldNames.Free;
  inherited Destroy;
end;

procedure TSelectedCell.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TSelectedCell.SetPen(Value: TPen);
begin
  Fpen.Assign(value);
end;

procedure TSelectedCell.SetFont(Value: TFont);
begin
  if Value<>FFont then
   FFont.Assign(Value);
end;

procedure TSelectedCell.SetFieldValues(Value: TStringList);
begin
   FFieldValues.Assign(Value);
end;

procedure TSelectedCell.SetFieldNames(Value: TStringList);
begin
   FFieldNames.Assign(Value);
end;

procedure TSelectedCell.SetVisible(Value: Boolean);
begin
  if Value<>FVisible then
   FVisible:=Value;
end;


{ TSelectedCells }

constructor TSelectedCells.Create(Grid: TtsvDbGrid; SelCellClass: TSelCellClass);
begin
  inherited Create(SelCellClass);
  FGrid := Grid;
end;

function TSelectedCells.GetSelCell(Index: Integer): TSelectedCell;
begin
  Result := TSelectedCell(inherited Items[Index]);
end;

procedure TSelectedCells.SetSelCell(Index: Integer; Value: TSelectedCell);
begin
  Items[Index].Assign(Value);
end;

function TSelectedCells.GetOwner: TPersistent;
begin
  Result := FGrid;
end;

procedure TSelectedCells.Update(Item: TCollectionItem);
begin
  if (FGrid = nil) or (csLoading in FGrid.ComponentState) then Exit;
end;

function TSelectedCells.Add: TSelectedCell;
begin
  Result := TSelectedCell(inherited Add);
end;

{ TtsvDbGrid }
constructor TtsvDbGrid.Create(AOwner: TComponent);
var
  bmp,AndMask: TBitmap;
begin
  FColumnSortEnabled:=true;

  FRowSelected:=TRowSelected.Create(Self);
  FCellSelected:=TRowSelected.Create(Self);
  FSelectedCells:=TSelectedCells.Create(self,TSelectedCell);
  FTitleCellMouseDown:=TRowSelected.Create(Self);


  FTitleCellMouseDown.Visible:=true;
  FTitleCellMouseDown.Brush.Color:=clBtnface;
  FRowSelected.Visible:=true;
  FRowSelected.Brush.Style:=bsSolid;
  FRowSelected.Brush.Color:=clBlack;
  FRowSelected.Font.Color:=clWindow;
  FRowSelected.Pen.Style:=psClear;
  FRowSelected.UnSelectedBrushColor:=clBlack;
  FRowSelected.UnSelectedFontColor:=clWindow;
  FCellSelected.Visible:=true;
  FCellSelected.Brush.Color:=clHighlight;
  FCellSelected.Font.Color:=clHighlightText;
  FCellSelected.Pen.Style:=psClear;
  FCellSelected.UnSelectedBrushColor:=clBtnShadow;
  FCellSelected.UnSelectedFontColor:=clHighlightText;


  FColumnSort:=nil;
  FListColumnSort:=TList.Create;
  FImageList:=TImageList.Create(nil);

  bmp:=TBitmap.Create;
  AndMask:=TBitmap.Create;
  try
    bmp.LoadFromResourceName(HINSTANCE,'SORTDESC');
    AndMask.Assign(bmp);
    AndMask.Mask(clTeal);
    FImageList.Width:=bmp.Width;
    FImageList.Height:=bmp.Height;
    FImageList.Add(bmp,AndMask);
    bmp.LoadFromResourceName(HINSTANCE,'SORTASC');
    AndMask.Assign(bmp);
    AndMask.Mask(clTeal);
    FImageList.Add(bmp,AndMask);
  finally
    AndMask.Free;
    bmp.free;
  end;


  Options:=Options-[dgEditing]-[dgTabs];
  ReadOnly:=true;

  inherited Create(AOwner);

  colwidths[0]:=IndicatorWidth;

  FRowSelected.Visible:=true;
  FVisibleRowNumber:=false;
  FRowSelected.Font.Assign(Font);
  FRowSelected.Brush.Style:=bsClear;
  FRowSelected.Brush.Color:=clBlack;
  FRowSelected.Font.Color:=clWhite;
  FRowSelected.Pen.Style:=psClear;
  FCellSelected.Font.Assign(Font);
  FCellSelected.Visible:=true;
  FCellSelected.Brush.Color:=clHighlight;
  FCellSelected.Font.Color:=clWhite;
  FTitleCellMouseDown.Font.Assign(Font);
  FColumnSortColor:=clInfoBk;
  RowSizing:=true;
  ReadOnly:=true;

end;

destructor TtsvDbGrid.Destroy;
begin
  ClearListColumnSort;
  FreeAndNil(FListColumnSort);
  FreeAndNil(FImageList);
  FreeAndNil(FSelectedCells);
  FreeAndNil(FCellSelected);
  FreeAndNil(FRowSelected);
  FreeAndNil(FTitleCellMouseDown);
  inherited;
end;

procedure TtsvDbGrid.SetRowSelected(Value: TRowSelected);
begin
  FRowSelected.Assign(Value);
end;

procedure TtsvDbGrid.SetCellSelected(Value: TRowSelected);
begin
  FCellSelected.Assign(Value);
end;

procedure TtsvDbGrid.SetSelectedCells(Value: TSelectedCells);
begin
  FSelectedCells.Assign(Value);
end;

procedure TtsvDbGrid.SetTitleCellMouseDown(Value: TRowSelected);
begin
  FTitleCellMouseDown.Assign(Value);
end;

function TtsvDbGrid.GetShortString(w: integer; str,text: string): string;
   var
     i: Integer;
     tmps: string;
     neww: Integer;
   begin
    result:=text;
    for i:=1 to Length(text) do begin
      tmps:=tmps+text[i];
      neww:=Canvas.TextWidth(tmps+str);
      if neww>=(w-Canvas.TextWidth(str)) then begin
       result:=tmps+str;
       exit;
      end;
    end;
end;

procedure TtsvDbGrid.WriteTextEx(ARow,ACol: Integer; rt: Trect; Alignment: TAlignment; Text: String ; DX,DY: Integer;
                                 var TextW: Integer; TextWidthMinus: Integer=0);
var
     Left_: INteger;
     newstr: string;
     strx: integer;
   begin
     with Canvas do begin
        Brush.Style:=bsClear;
        case Alignment of
          taLeftJustify:
            Left_ := rt.Left + DX;
           taRightJustify:
            Left_ := rt.Right - TextWidth(Text) -3;
           else
            Left_ := rt.Left + (rt.Right - rt.Left) shr 1 - (TextWidth(Text) shr 1);
         end;
         newstr:=Text;
         if ARow<>Row then begin
          strx:=TextWidth(text);
          if strx>=ColWidths[ACol]-TextWidthMinus-1 then begin
            newstr:=GetShortString(ColWidths[ACol]-TextWidthMinus,'...',text);
          end;
         end;

         TextRect(rt, Left_, rt.Top + DY, newstr);
         TextW:=TextWidth(newstr);
     end;
end;

procedure TtsvDbGrid.DrawSort(Canvas: TCanvas; ARect: TRect; TypeSort: TTypeColumnSort);
var
//  w,h: Integer;
  x,y: Integer;
begin
  with Canvas do begin
{    w:=(Arect.Right-Arect.Left) div 2;
    h:=(Arect.Bottom-Arect.Top) div 3;}
    x:=Arect.Left;
    y:=Arect.Top;
    Brush.Style:=bsSolid;
    Pen.Style:=psSolid;
    Pen.Color:=clBlack;
    case TypeSort of
      tcsNone:;
      tcsAsc: begin
{        MoveTo(x+w div 2,y+h);
        LineTo(x+w+w div 2,y+h);
        LineTo(x+w,y+2*h);
        LineTo(x+w div 2,y+h);}
        FImageList.Draw(Canvas,x,y,0);
      end;
      tcsDesc: begin
{        MoveTo(x+w,y+h);
        LineTo(x+w+w div 2,y+2*h);
        LineTo(x+w div 2,y+2*h);
        LineTo(x+w,y+h);}
        FImageList.Draw(Canvas,x,y,1);
      end;
    end;
  end;
end;

procedure TtsvDbGrid.DefaultDrawRowCellSelected(const Rect: TRect; DataCol: Integer;
                                               Column: TColumn; State: TGridDrawState);
{var
  Rect: TRect;}


   procedure DrawRowCellSelected;
   var
    OldBrush: TBrush;
    OldFont: TFont;
    OldPen: Tpen;
//    cl: TColumn;
//    fl: TField;
    i: Integer;
    ACol: Integer;
    Rect1: TRect;
   begin
     OldBrush:=TBrush.Create;
     OldFont:=TFont.Create;
     OldPen:=Tpen.Create;
     try
      OldBrush.Assign(Canvas.Brush);
      OldFont.Assign(Canvas.Font);
      OldPen.Assign(Canvas.Pen);
       with Canvas do begin
        if FRowSelected.Visible then begin
          Font.Assign(FRowSelected.Font);
          Brush.Assign(FRowSelected.Brush);
          Pen.Assign(FRowSelected.Pen);
          for i:=IndicatorOffset to ColCount-1 do begin
            ACol:=i;
            Rect1:=CellRect(ACol,Row);
            Brush.Color:=clBlack;
            Fillrect(Rect1);
{            if (Columns.Count>=ACol)and(ACol>=IndicatorOffset) then begin
            cl:=Columns.Items[ACol-IndicatorOffset];
             if cl<>nil then begin
              Font.Name:=cl.Font.Name;
              fl:=cl.Field;
              if fl<>nil then
                WriteTextEx(Row,ACol,Rect1,cl.Alignment,fl.DisplayText,2,2);
             end;
            end;}
          end;
{          Pen.Assign(FRowSelected.Pen);
          Rectangle(rect);
          DefaultDrawing:=False;}
        end; // end of FRowSelected.Visible
{        if FCellSelected.Visible then begin
         for i:=0 to ColCount-1 do begin
           ACol:=i;
           if ACol=Col then begin
            Font.Assign(FCellSelected.Font);
            Brush.Assign(FCellSelected.Brush);
            Pen.Assign(FCellSelected.Pen);
            Fillrect(Rect);
            if (Columns.Count>=Col)and(Col>=IndicatorOffset) then begin
             cl:=Columns.Items[Col-IndicatorOffset];
             if cl<>nil then begin
              Font.Name:=cl.Font.Name;
              fl:=cl.Field;
              if fl<>nil then
               WriteTextEx(Row,Col,Rect,cl.Alignment,fl.DisplayText,2,2);
             end;
            end;
            Pen.Assign(FCellSelected.Pen);
            Rectangle(rect);
            if Focused then  Windows.DrawFocusRect(Handle, Rect);
            DefaultDrawing:=False;
            exit;
           end;
         end;
        end;// end of FCellSelected.Visible}
       end; // end of with canvas
      finally
       Canvas.Brush.Assign(OldBrush);
       OldBrush.Free;
       Canvas.Font.Assign(OldFont);
       OldFont.Free;
       Canvas.Pen.Assign(OldPen);
       OldPen.Free;
      end;
   end;

begin
//  Rect:=BoxRect(IndicatorOffset,Row,ColCount,Row);
 // DrawRowCellSelected;
end;

procedure TtsvDbGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);

   procedure DrawRowCellSelected;
   var
    OldBrush: TBrush;
    OldFont: TFont;
    OldPen: Tpen;
    cl: TColumn;
    fl: TField;
    TextW: Integer;
   begin
     OldBrush:=TBrush.Create;
     OldFont:=TFont.Create;
     OldPen:=Tpen.Create;
     try
      OldBrush.Assign(Canvas.Brush);
      OldFont.Assign(Canvas.Font);
      OldPen.Assign(Canvas.Pen);
      if (Arow=Row) then begin
       with Canvas do begin
        if FRowSelected.Visible then begin
         Font.Assign(FRowSelected.Font);
         Brush.Assign(FRowSelected.Brush);
         Pen.Assign(FRowSelected.Pen);
         if not Focused then begin
           Brush.Color:=FRowSelected.UnSelectedBrushColor;
           Font.Color:=FRowSelected.UnSelectedFontColor;
         end;
         Fillrect(ARect);
         if (Columns.Count>=ACol)and(ACol>=IndicatorOffset) then begin
          cl:=Columns.Items[ACol-IndicatorOffset];
          if cl<>nil then begin
           Font.Name:=cl.Font.Name;
           Font.Style:=cl.Font.Style;
           fl:=cl.Field;
           if fl<>nil then
            WriteTextEx(ARow,ACol,ARect,cl.Alignment,fl.DisplayText,2,2,TextW);
          end;
         end;
         Pen.Assign(FRowSelected.Pen);
         Rectangle(Arect);
         DefaultDrawing:=False;
        end; // end of FRowSelected.Visible
        if FCellSelected.Visible then begin
         if ACol=Col then begin
          Font.Assign(FCellSelected.Font);
          Brush.Assign(FCellSelected.Brush);
          Pen.Assign(FCellSelected.Pen);
          if not Focused then begin
            Brush.Color:=FCellSelected.UnSelectedBrushColor;
            Font.Color:=FCellSelected.UnSelectedFontColor;
          end;  
          Fillrect(ARect);
          if (Columns.Count>=ACol)and(ACol>=IndicatorOffset) then begin
           cl:=Columns.Items[ACol-IndicatorOffset];
           if cl<>nil then begin
            Font.Name:=cl.Font.Name;
            Font.Style:=cl.Font.Style;
            fl:=cl.Field;
            if fl<>nil then
             WriteTextEx(ARow,ACol,ARect,cl.Alignment,fl.DisplayText,2,2,TextW);
           end;
          end;
          Pen.Assign(FCellSelected.Pen);
          Rectangle(Arect);
          if Focused then begin
            Windows.DrawFocusRect(Handle, ARect);
          end;


          DefaultDrawing:=False;
          exit;
         end;
        end;// end of FCellSelected.Visible
       end; // end of with canvas
      end else begin
{       if (Columns.Count>=ACol)and(Acol>0) then begin
        cl:=Columns.Items[ACol-1];
        if cl<>nil then begin
         fl:=cl.Field;
         Canvas.Fillrect(ARect);
         if fl<>nil then begin
           WriteTextEx(ARow,ACol,ARect,cl.Alignment,fl.AsString,2,2);
         end;
        end;
       end;}
       DefaultDrawing:=true;
      end;
      finally
       Canvas.Brush.Assign(OldBrush);
       OldBrush.Free;
       Canvas.Font.Assign(OldFont);
       OldFont.Free;
       Canvas.Pen.Assign(OldPen);
       OldPen.Free;
      end;
   end;

   procedure DrawRowCellSelectedNoRecord;
   var
    OldBrush: TBrush;
    OldFont: TFont;
    OldPen: Tpen;
   begin
     OldBrush:=TBrush.Create;
     OldFont:=TFont.Create;
     OldPen:=Tpen.Create;
     try
      OldBrush.Assign(Canvas.Brush);
      OldFont.Assign(Canvas.Font);
      OldPen.Assign(Canvas.Pen);
      if (Arow=Row) then begin
       with Canvas do begin
        if FRowSelected.Visible then begin
{         Font.Assign(FRowSelected.Font);
         Brush.Assign(FRowSelected.Brush);
         Pen.Assign(FRowSelected.Pen);}
         Fillrect(ARect);
{         Pen.Assign(FRowSelected.Pen);
         Rectangle(Arect);}
         DefaultDrawing:=False;
        end; // end of FRowSelected.Visible}
        if FCellSelected.Visible then begin
         if ACol=Col then begin
          Font.Assign(FCellSelected.Font);
          Brush.Assign(FCellSelected.Brush);
          Pen.Assign(FCellSelected.Pen);
          if not Focused then begin
            Brush.Color:=FCellSelected.UnSelectedBrushColor;
            Font.Color:=FCellSelected.UnSelectedFontColor;
          end;  
          Fillrect(ARect);
          Pen.Assign(FCellSelected.Pen);
          Rectangle(Arect);
          if Focused then  Windows.DrawFocusRect(Handle, ARect);
          DefaultDrawing:=False;
          exit;
         end;
        end;// end of FCellSelected.Visible
       end; // end of with canvas
      end else begin
       DefaultDrawing:=true;
      end;
      finally
       Canvas.Brush.Assign(OldBrush);
       OldBrush.Free;
       Canvas.Font.Assign(OldFont);
       OldFont.Free;
       Canvas.Pen.Assign(OldPen);
       OldPen.Free;
      end;
   end;

   procedure DrawMouseDown;
   var
     TitleRect: TRect;
     OldBrush: TBrush;
     OldFont: TFont;
     OldPen: Tpen;
     TextW: Integer;
     cl: TColumn;
     rt: Trect;
     dx: Integer;
     x,y: Integer;
     TCS: TTypeColumnSort;
   begin
    if FTitleCellMouseDown.Visible then begin
     OldBrush:=TBrush.Create;
     OldFont:=TFont.Create;
     OldPen:=Tpen.Create;
     try
      if FTitleMouseDown then begin
       OldBrush.Assign(Canvas.Brush);
       OldFont.Assign(Canvas.Font);
       OldPen.Assign(Canvas.Pen);
       if (ACol>=IndicatorOffset) and(ARow<1) then begin
        with Canvas do begin
         Font.Assign(FTitleCellMouseDown.Font);
         Brush.Assign(FTitleCellMouseDown.Brush);
         Pen.Assign(FTitleCellMouseDown.Pen);
         FillRect(ARect);
         cl:=Columns.Items[ACol-IndicatorOffset];
         if cl<>nil then begin
           CopyMemory(@rt,@ARect,Sizeof(TRect));
           dx:=0;
           rt.Left:=rt.Left+1;
           rt.Top:=rt.Top+1;
           TCS:=GetTypeColumnSort(cl);
           if TCS<>tcsNone then
             dx:=FImageList.Width+2;
           WriteTextEx(ARow,ACol,rt,cl.Title.Alignment,cl.Title.Caption,2,2,TextW,dx);
           x:=rt.Left+TextW+6;
           y:=rt.Top+(rt.Bottom-rt.Top)div 2-FImageList.Height div 2 +1;
           case TCS of
             tcsAsc: FImageList.draw(Canvas,x,y,0);
             tcsDesc: FImageList.draw(Canvas,x,y,1);
           end;
         
         end;
         DrawEdge(Canvas.Handle,TitleRect,BDR_SUNKENOUTER,BF_TOPLEFT);
         DrawEdge(Canvas.Handle,TitleRect,BDR_RAISEDINNER,BF_BOTTOMRIGHT);
         Pen.Assign(FTitleCellMouseDown.Pen);
         Rectangle(TitleRect);
        end;
        DefaultDrawing:=false;
       end;
      end;
     finally
       Canvas.Brush.Assign(OldBrush);
       OldBrush.Free;
       Canvas.Font.Assign(OldFont);
       OldFont.Free;
       Canvas.Pen.Assign(OldPen);
       OldPen.Free;
     end;
    end;
   end;

   procedure DrawColumns;
   var
     OldBrush: TBrush;
     OldFont: TFont;
     OldPen: Tpen;
     cl: TColumn;
     rt: Trect;
     dx: Integer;
     dy: Integer;
     x,y: Integer;
     TextW: Integer;
     Curr: Integer;
     TCS: TTypeColumnSort;
   begin
     OldBrush:=TBrush.Create;
     OldFont:=TFont.Create;
     OldPen:=Tpen.Create;
     try
      if not FTitleMouseDown then begin
       OldBrush.Assign(Canvas.Brush);
       OldFont.Assign(Canvas.Font);
       OldPen.Assign(Canvas.Pen);
       Canvas.Font.Assign(Font);
       TextW:=0;
       if (ACol>=IndicatorOffset)and (Arow=0)then begin
        with Canvas do begin
         brush.Color:=FixedColor;
         Pen.Style:=psClear;
         FillRect(ARect);
         cl:=Columns.Items[ACol-IndicatorOffset];
         if cl<>nil then begin
           CopyMemory(@rt,@ARect,Sizeof(TRect));
           dx:=0;
           rt.Left:=rt.Left+1;
           rt.Top:=rt.Top+1;
           TCS:=GetTypeColumnSort(cl);
           if TCS<>tcsNone then
             dx:=FImageList.Width+2;
           WriteTextEx(ARow,ACol,rt,cl.Title.Alignment,cl.Title.Caption,1,1,TextW,dx);
           x:=rt.Left+TextW+5;
           y:=rt.Top+(rt.Bottom-rt.Top)div 2-FImageList.Height div 2;
           case TCS of
             tcsAsc: FImageList.draw(Canvas,x,y,0);
             tcsDesc: FImageList.draw(Canvas,x,y,1);
           end;
         end;
         DrawEdge(Canvas.Handle,ARect,BDR_RAISEDINNER, BF_BOTTOMRIGHT);
         DrawEdge(Canvas.Handle,ARect,BDR_RAISEDINNER, BF_TOPLEFT);
        end;
        DefaultDrawing:=false;
       end;
       if FVisibleRowNumber then begin
        if (ACol<IndicatorOffset)then begin
         Canvas.Brush.Color:=FixedColor;
         Canvas.Pen.Style:=psClear;
         dx:=0;
         CopyMemory(@rt,@ARect,Sizeof(TRect));
         rt.Left:=rt.Left+1+dx;
         rt.Top:=rt.Top+1;
         if (Arow=0) then begin

          WriteTextEx(ARow,ACol,rt,taLeftJustify,DefaultVisibleRowNumberCaption,1,1,TextW,dx);
         end else begin
          Curr:=0;
          dy:=rt.Bottom-rt.Top-2;
          dy:=dy div 2 - Canvas.TextHeight('W') div 2;
          if (DataLink.DataSet<>nil) then
           if (DataLink.DataSet.active)and(DataLink.DataSet.RecordCount>0) then
            Curr:=GetRealTopRow(Row)+ARow
           else Curr:=0;
          if Curr<>0 then
           WriteTextEx(ARow,ACol,rt,taLeftJustify,inttostr(Curr),1,dy,dx,TextW);
         end;
         DefaultDrawing:=false;
        end;
       end;

      end;
     finally
       Canvas.Brush.Assign(OldBrush);
       OldBrush.Free;
       Canvas.Font.Assign(OldFont);
       OldFont.Free;
       Canvas.Pen.Assign(OldPen);
       OldPen.Free;
     end;
   end;

begin
  DrawRow:=ARow;
  CurrentRow:=Row;

  if not Assigned(FRowSelected) or
     not Assigned(FTitleCellMouseDown) or
     not Assigned(FCellSelected) then exit;

  if Assigned(DataLink) and DataLink.Active  then begin
     if DataLink.RecordCount>0 then
       DrawRowCellSelected
     else DrawRowCellSelectedNoRecord;
  end else DrawRowCellSelectedNoRecord;

  inherited;

  DrawColumns;

  DrawMouseDown;


end;


procedure TtsvDbGrid.DrawDataCell(const Rect: TRect; Field: TField; State: TGridDrawState);
begin
  inherited;
end;

procedure TtsvDbGrid.DrawColumnCell(const Rect: TRect; DataCol: Integer;
                        Column: TColumn; State: TGridDrawState);
begin
  inherited;
end;

procedure TtsvDbGrid.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
end;

procedure TtsvDbGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
var
  Cell: TGridCoord;
  fm: TCustomForm;
begin
  if not (csDesigning in ComponentState) and CanFocus then begin
    fm:=Screen.ActiveCustomForm;
    if fm<>nil then
      Windows.SetFocus(fm.Handle);
  end;     
  inherited MouseDown(Button,Shift,X,Y);

  if (FOldGridState<>gsColSizing) then
    NotSetLocalWidth:=true;

  FOldGridState:=FGridState;
  Cell := MouseCoord(X, Y);
  OldCell:=MouseCoord(X, Y);
  if (FGridState<>gsNormal)and
     (FGridState<>gsColSizing)and
     (Cell.X >= IndicatorOffset) and
     (Cell.Y < 1) then
  begin
   FTitleClickInUse:=true;
   if (Button=mbLeft)then begin
    FTitleMouseDown:=true;
    FTitleX:=Cell.X;
    FTitleY:=Cell.Y;
    InvalidateCell(Cell.X,Cell.Y);
   end;
  end else begin
   FTitleClickInUse:=false;
   FTitleMouseDown:=false;
   InvalidateCell(Cell.X,Cell.Y);
  end;
end;

procedure TtsvDbGrid.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
var
  Cell: TGridCoord;
  Column: TColumn;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FTitleMouseDown then begin
    if FGridState<>gsColMoving then begin
      Cell := MouseCoord(X,Y);
      Column:=Columns[RawToDataColumn(Cell.X)];
      if FColumnSortEnabled then begin
        SetColumnSort(Column);
      end;
      DoTitleClickWithSort(Column,GetTypeColumnSort(Column));
    end;
  end;
  FTitleMouseDown:=false;
  InvalidateCell(FTitleX,FTitleY);
end;

{procedure TtsvDbGrid.MouseToCell(X,Y:Integer; var ACol,ARow:Integer);
var
  Coord:TGridCoord;
begin
  Coord:=MouseCoord(X, Y);
  ACol:=Coord.X;
  ARow:=Coord.Y;
end;}

procedure TtsvDbGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
end;

procedure TtsvDbGrid.WMMouseWheel(var Message: TWMMouseWheel);
const
  CountWheel=1;
begin
  FTitleMouseDown:=false;
  if Assigned(DataLink) and DataLink.Active  then begin
   if DataLink.DataSet=nil then exit;
   if Datalink.Active then
    with Message, DataLink.DataSet do begin
       if WheelDelta<0 then
         DataLink.DataSet.MoveBy(CountWheel)
       else DataLink.DataSet.MoveBy(-CountWheel);
       Result:=1;
    end;
  end;
end;

procedure TtsvDbGrid.SetRowSizing(Value: Boolean);
begin
  if FRowSizing<>Value then begin
    FRowSizing:=Value;
    if FRowSizing then begin
     TTempGrid(self).Options:=TTempGrid(self).Options+[goRowSizing];
    end else begin
     TTempGrid(self).Options:=TTempGrid(self).Options-[goRowSizing];
    end;
  end;
end;

procedure TtsvDbGrid.CalcSizingState(X, Y: Integer;
  var State: TGridState; var Index, SizingPos, SizingOfs: Integer;
  var FixedInfo: TGridDrawInfo);
begin
  inherited CalcSizingState(X, Y, State, Index, SizingPos, SizingOfs, FixedInfo);
end;

procedure TtsvDbGrid.SetRowHeight(Value: Integer);
var
  i: Integer;
begin
  if FRowHeight<>Value then begin
    FRowHeight:=Value;
    for i:=0 to TTempGrid(self).RowCount-1 do
     TTempGrid(self).RowHeights[i]:=FRowHeight;
  end;
end;

procedure TtsvDbGrid.TitleClick(Column: TColumn);
begin
  inherited;
  if (FOldGridState<>gsColSizing)and(NotSetLocalWidth)then begin
    inherited;
  end;
end;

procedure TtsvDbGrid.DblClick;

  procedure SetLocalWidth;
  var
    w: Integer;
    cl: TColumn;
    i: Integer;
    l: Integer;
    fl: TField;
    bm: TBookmark;
    tmpcol: Integer;
    OldAfterScroll: TDataSetNotifyEvent;
    tmps: string;
  begin
   if DataSource=nil then exit;
   if DataSource.DataSet=nil then exit;
   if not DataSource.DataSet.active then exit;
   try
    DataSource.DataSet.DisableControls;
    OldAfterScroll:=DataSource.DataSet.AfterScroll;
    DataSource.DataSet.AfterScroll:=nil;
    bm:=DataSource.DataSet.GetBookmark;
    try
     tmpcol:=RawToDataColumn(OldCell.X);
     if ((tmpcol)<0)or
        ((tmpcol)>(Columns.Count-1)) then exit;
     cl:=Columns[tmpcol];
     if cl=nil then exit;
     w:=cl.Width;
     DataSource.DataSet.First;
     fl:=cl.Field;
     if fl=nil then exit;
     for i:=0 to DataSource.DataSet.RecordCount-1 do begin
       tmps:='';
       try
        tmps:=fl.DisplayText;
       except
       end;
        
       case fl.DataType of
        ftSmallint,ftInteger,ftWord,ftBytes,ftLargeint: begin
          tmps:=inttostr(fl.AsInteger);
        end;
        ftString,ftWideString,ftFixedChar: begin
          tmps:=fl.DisplayText;
        end;
       end;
       l:=Canvas.TextWidth(tmps)+Canvas.TextWidth('W');
       if l>w then w:=l;
       DataSource.DataSet.Next;
     end;
     cl.Width:=w;

    finally
     DataSource.DataSet.GotoBookmark(bm);
     DataSource.DataSet.AfterScroll:=OldAfterScroll;
     DataSource.DataSet.EnableControls;
    end;
   except
   end;
  end;


begin
  if (FOldGridState=gsColSizing)then begin
    NotSetLocalWidth:=false;
    SetLocalWidth;
  end else begin
   if not FTitleClickInUse then
    inherited;
   NotSetLocalWidth:=true;
  end;
end;

procedure TtsvDbGrid.SetMultiSelect(Value: Boolean);
begin
  if Value<>FMultiSelect then begin
    if Value then Options:=Options+[dgMultiSelect]
    else Options:=Options-[dgMultiSelect];
    FMultiSelect:=Value;
  end;
end;


procedure TtsvDbGrid.ClearListColumnSort;
var
  P: PInfoColumnSort;
  i: Integer;
begin
  for i:=0 to FListColumnSort.Count-1 do begin
    P:=FListColumnSort.Items[i];
    Dispose(P);
  end;
  FListColumnSort.Clear;
end;

function TtsvDbGrid.GetTypeColumnSort(Column: TColumn): TTypeColumnSort;
var
  i: Integer;
  P: PInfoColumnSort;
begin
  Result:=tcsNone;
  for i:=0 to FListColumnSort.Count-1 do begin
    P:=FListColumnSort.Items[i];
    if P.Column=Column then begin
      Result:=P.TypeColumnSort;
      exit;
    end;
  end;
end;

procedure TtsvDbGrid.SetColumnSort(Column: TColumn);
var
  i: Integer;
  P: PInfoColumnSort;
  cur,next: TTypeColumnSort;
begin
  for i:=FListColumnSort.Count-1 downto 0 do begin
    P:=FListColumnSort.Items[i];
    if P.Column=Column then begin
      FColumnSort:=Column;
      cur:=P.TypeColumnSort;
      next:=cur;
      case cur of
        tcsNone: next:=tcsAsc;
        tcsAsc: next:=tcsDesc;
        tcsDesc: next:=tcsNone;
      end;
      if next<>tcsNone then begin
        FColumnSort.Color:=FColumnSortColor;
      end else
        FColumnSort.Color:=FOldColumnSortColor;
      P.TypeColumnSort:=next;
      exit;
    end else begin
      P.Column.Color:=FOldColumnSortColor;
      FListColumnSort.Remove(P);
      Dispose(P);
    end;
  end;
  New(P);
  P.Column:=Column;
  FColumnSort:=Column;
  P.TypeColumnSort:=tcsAsc;
  FOldColumnSortColor:=FColumnSort.Color;
  FColumnSort.Color:=FColumnSortColor;
  FListColumnSort.Add(P);
  InvalidateTitles;
end;

procedure TtsvDbGrid.SetTypeColumnSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  i: Integer;
  P: PInfoColumnSort;
begin
  for i:=0 to FListColumnSort.Count-1 do begin
    P:=FListColumnSort.Items[i];
    if P.Column=Column then begin
      P.TypeColumnSort:=TypeSort;
      exit;
    end;
  end;
end;

procedure TtsvDbGrid.ClearColumnSort;
begin
  ClearListColumnSort;
end;

procedure TtsvDbGrid.SetColumnSortEnabled(Value: Boolean);
begin
 if Value<>FColumnSortEnabled then begin
   FColumnSortEnabled:=Value;
   if not FColumnSortEnabled then
     ClearColumnSort;
 end;
end;

procedure TtsvDbGrid.SetVisibleRowNumber(Value: Boolean);
begin
  if Value<>FVisibleRowNumber then begin
    FVisibleRowNumber:=Value;
    SetWidthRowNumber(Row);
  end;
end;

function ReadOnlyField(Field: TField): Boolean;
var
  MasterField: TField;
begin
  Result := Field.ReadOnly;
  if not Result and (Field.FieldKind = fkLookup) then
  begin
    Result := True;
    if Field.DataSet = nil then Exit;
    MasterField := Field.Dataset.FindField(Field.KeyFields);
    if MasterField = nil then Exit;
    Result := MasterField.ReadOnly;
  end;
end;

procedure TtsvDbGrid.SetColumnAttributes;
var
  I: Integer;
begin
  for I := 0 to Columns.Count-1 do
  with Columns[I] do
  begin
    TabStops[I + IndicatorOffset] := Showing and not ReadOnly and DataLink.Active and
      Assigned(Field) and not (Field.FieldKind = fkCalculated) and not ReadOnlyField(Field);
    ColWidths[I + IndicatorOffset] := Width;
  end;
  SetWidthRowNumber(Row);
end;

procedure TtsvDbGrid.Scroll(Distance: Integer);
begin
  inherited Scroll(Distance);
  SetWidthRowNumber(Row);
end;

procedure TtsvDbGrid.TopLeftChanged;
begin
  inherited TopLeftChanged;
end;

procedure TtsvDbGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  SetWidthRowNumber(Row);
end;

procedure TtsvDbGrid.SetWidthRowNumber(NewRow: Integer);
var
  ARow: Integer;
  w,wmin: Integer;
  Plus: Integer;
begin
  if FVisibleRowNumber then begin
   if DataLink.DataSet<>nil then begin
    ARow:=GetRealTopRow(NewRow)+NewRow;
    Plus:=0;
    if dgIndicator in Options then Plus:=IndicatorWidth;
    wmin:=Canvas.TextWidth(inttostr(9))+3+Plus;
    w:=Canvas.TextWidth(inttostr(ARow))+3+Plus;
    if w<wmin then w:=wmin;
    colwidths[0]:=w;
   end else colwidths[0]:=IndicatorWidth;
  end else begin
    colwidths[0]:=IndicatorWidth;
  end;
end;

procedure TtsvDbGrid.SetEditText(ACol, ARow: Longint; const Value: string);
begin
  inherited;
end;

function TtsvDbGrid.GetEditText(ACol, ARow: Longint): string;
begin
  Result:=inherited GetEditText(ACol, ARow);
end;

function TtsvDbGrid.SelectCell(ACol, ARow: Longint): Boolean;
begin
  SetWidthRowNumber(ARow);
  Result:=inherited SelectCell(ACol,ARow);
end;

procedure TtsvDbGrid.TimedScroll(Direction: TGridScrollDirection);
begin
  inherited TimedScroll(Direction);
  SetWidthRowNumber(Row);
end;

function TtsvDbGrid.GetRealTopRow(NewRow: Integer): Integer;
begin
  Result:=0;
  if DataLink.DataSet<>nil then begin
    if not DataLink.DataSet.IsEmpty then
      if DataLink.DataSet.Active then
        Result:=DataLink.DataSet.RecNo-NewRow;
  end;
end;

procedure TtsvDbGrid.LayoutChanged;
begin
  Inherited;
  SetDefaultRowHeight(FNewDefaultRowHeight);
end;

procedure TtsvDbGrid.RowHeightsChanged;
var
  i,ThisHasChanged,Def : Integer;
begin
  ThisHasChanged:=-1;
  Def:=DefaultRowHeight;
  For i:=Ord(dgTitles In Options) to RowCount Do begin
    If RowHeights[i]<>Def Then Begin
      ThisHasChanged:=i;
      Break;
    End;
  End;
  If ThisHasChanged<>-1 Then Begin
    SetDefaultRowHeight(RowHeights[ThisHasChanged]);
    RecreateWnd;
  End;
  inherited;
end;

procedure TtsvDbGrid.SetDefaultRowHeight(Value: Integer);
begin
  if Assigned(Parent) then begin
    if Value<=GetMinRowHeight then begin
      Value:=GetMinRowHeight;
    end;
    inherited DefaultRowHeight:=Value;
    FNewDefaultRowHeight:=Value;
    if dgTitles in Options then begin
      Canvas.Font:=TitleFont;
      RowHeights[0]:=GetMinRowHeight;
    end;
  end;  
end;

function TtsvDbGrid.GetDefaultRowHeight: Integer;
begin
  Result:=inherited DefaultRowHeight;
end;

function TtsvDbGrid.GetMinRowHeight: Integer;
begin
  Result:=Canvas.TextHeight('W')+4;
end;

procedure TtsvDbGrid.WMVScroll(var Message: TWMVScroll);
begin
  inherited;
  SetWidthRowNumber(Row);
end;

procedure TtsvDbGrid.UpdateRowNumber;
begin
  SetWidthRowNumber(Row);
end;

procedure TtsvDbGrid.DoTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); 
begin
  if Assigned(FOnTitleClickWithSort) then
    FOnTitleClickWithSort(Column,TypeSort);
  InvalidateTitles;  
end;

function TtsvDbGrid.GetTypeColumnSortEx: TTypeColumnSort;
begin
  Result:=tcsNone;
  if Assigned(FColumnSort) then
    Result:=GetTypeColumnSort(FColumnSort);
end;

procedure TtsvDbGrid.SetTypeColumnSortEx(Value: TTypeColumnSort);
begin
  if Assigned(FColumnSort) then
    SetTypeColumnSort(FColumnSort,Value);
end;

procedure TtsvDbGrid.ColumnMoved(FromIndex, ToIndex: Longint);
begin
  inherited;
  FTitleMouseDown:=false;
end;

end.
