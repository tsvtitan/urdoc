unit URenameTabSheet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, comctrls, typinfo, Variants;

type
  TfmRenameTabSheet = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    pnLeft: TPanel;
    pnRight: TPanel;
    grbTabSheet: TGroupBox;
    grbFields: TGroupBox;
    pnCmbTabSheet: TPanel;
    btDown: TBitBtn;
    btUp: TBitBtn;
    pnLBFields: TPanel;
    lbFields: TListBox;
    lbTabSheet: TListBox;
    edTabSheet: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure edTabSheetChange(Sender: TObject);
    procedure lbTabSheetClick(Sender: TObject);
    procedure edTabSheetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btUpClick(Sender: TObject);
    procedure btDownClick(Sender: TObject);
    procedure lbTabSheetDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lbTabSheetDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lbTabSheetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbFieldsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    PcLast: TPageControl;
    ptCur: TPoint;
    function GetSelectedIndex: Integer;
    procedure Select(Up: Boolean);
  public
    procedure FillFiedlsByTabSheet(ts: TTabSheet);
    procedure FillTabSheets(pc: TPageControl);
    procedure ApplyTabSheets;
  end;

var
  fmRenameTabSheet: TfmRenameTabSheet;

implementation

uses UCreateCtrl,UDM;

{$R *.DFM}

procedure TfmRenameTabSheet.FormCreate(Sender: TObject);
begin
  lbFields.ItemHeight:=fmCreateCtrl.IL.Height+2;
{  SendMessage(lbTabSheet.Handle, LB_SETHORIZONTALEXTENT, 1000, Longint(0));
  SendMessage(lbFields.Handle, LB_SETHORIZONTALEXTENT, 1000, Longint(0));}
  PcLast:=nil;
end;

procedure TfmRenameTabSheet.FillFiedlsByTabSheet(ts: TTabSheet);
var
  list: TList;
  i: Integer;
  ct: TControl;
  s: string;
  MaxS: Integer;
begin
  lbFields.Items.BeginUpdate;
  list:=TList.Create;
  MaxS:=0;
  try
   lbFields.Items.Clear;
   GetControlByPropValue(ts,ConstPropDocFieldName,Null,List,false);
   SortListByTabOrder(List);
   for i:=0 to List.Count-1 do begin
     ct:=List.Items[i];
     s:=GetStrProp(ct,ConstPropDocFieldName);
     if Trim(s)<>'' then
      lbFields.Items.AddObject(s,List.Items[i]);
     if MaxS<lbFields.Canvas.TextWidth(s) then MaxS:=lbFields.Canvas.TextWidth(s);
   end;
  finally
   SendMessage(lbFields.Handle, LB_SETHORIZONTALEXTENT, MaxS+fmCreateCtrl.IL.Width+4, 0);
   list.Free;
   lbFields.Items.EndUpdate;
  end;
end;

procedure TfmRenameTabSheet.FillTabSheets(pc: TPageControl);
var
  i: Integer;
  ts: TTabSheet;
  APos: Integer;
  MaxS: Integer;
  s: string;
begin
  if pc=nil then exit;
  PcLast:=pc;
  lbTabSheet.Items.BeginUpdate;
  MaxS:=0;
  try
   lbTabSheet.Items.Clear;
   for i:=0 to pc.PageCount-1 do begin
    ts:=pc.pages[i];
    APos:=AnsiPos(AnsiUpperCase(ConstTabSheetMain),AnsiUpperCase(ts.Caption));
    if Apos>0 then begin
      s:=ConstTabSheetCaption+' '+inttostr(i+1);
    end else begin
      s:=ts.Caption;
    end;
    lbTabSheet.Items.AddObject(s,ts);
    if MaxS<lbTabSheet.Canvas.TextWidth(s) then MaxS:=lbTabSheet.Canvas.TextWidth(s);
   end;
  finally
   SendMessage(lbTabSheet.Handle, LB_SETHORIZONTALEXTENT, MaxS, 0);
   lbTabSheet.Items.EndUpdate;
  end;
end;

procedure TfmRenameTabSheet.edTabSheetChange(Sender: TObject);
begin
  if lbTabSheet.ItemIndex<>-1 then begin
    lbTabSheet.Items.Strings[lbTabSheet.ItemIndex]:=edTabSheet.Text;
  end;
end;

procedure TfmRenameTabSheet.lbTabSheetClick(Sender: TObject);
begin
  if lbTabSheet.ItemIndex<>-1 then begin
    edTabSheet.OnChange:=nil;
    edTabSheet.Text:=lbTabSheet.Items.Strings[lbTabSheet.ItemIndex];
    FillFiedlsByTabSheet(TTabSheet(lbTabSheet.Items.Objects[lbTabSheet.ItemIndex]));
    edTabSheet.OnChange:=edTabSheetChange;
  end;
end;

procedure TfmRenameTabSheet.ApplyTabSheets;
var
  i: Integer;
  ts: TTabSheet;
begin
  if PcLast=nil then exit;
  for i:=0 to lbTabSheet.Items.Count-1 do begin
    ts:=TTabSheet(lbTabSheet.Items.Objects[i]);
    ts.PageIndex:=i;
    ts.Caption:=lbTabSheet.Items.Strings[i];
  end;
  if PcLast.PageCount>0 then
   PcLast.ActivePageIndex:=0;
end;

procedure TfmRenameTabSheet.edTabSheetKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_UP: begin
     Select(true);
     lbTabSheet.SetFocus;
    end;
    VK_DOWN: begin
     Select(false);
     lbTabSheet.SetFocus;
    end;
  end;
end;

procedure TfmRenameTabSheet.Select(Up: Boolean);
var
  Index: Integer;
begin
  Index:=GetSelectedIndex;
  if Up then begin
   if Index>0 then begin
    lbTabSheet.ItemIndex:=Index-1;
   end;
  end else begin
   if (Index<>-1)and(Index<>lbTabSheet.Items.Count-1) then begin
    lbTabSheet.ItemIndex:=Index+1;
   end;
  end;
  lbTabSheetClick(nil);
end;

procedure TfmRenameTabSheet.btUpClick(Sender: TObject);
var
  Index: Integer;
begin
  Index:=GetSelectedIndex;
  if Index>0 then begin
   lbTabSheet.Items.Move(Index,Index-1);
   lbTabSheet.ItemIndex:=Index-1;
  end;
end;

function TfmRenameTabSheet.GetSelectedIndex: Integer;
var
  I: Integer;
begin
 result:=-1;
  for i:=0 to lbTabSheet.Items.Count-1 do begin
    if lbTabSheet.Selected[i] then begin
      Result:=i;
      exit;
    end;
  end;
end;

procedure TfmRenameTabSheet.btDownClick(Sender: TObject);
var
  Index: Integer;
begin
  Index:=GetSelectedIndex;
  if (Index<>-1)and(Index<>lbTabSheet.Items.Count-1) then begin
   lbTabSheet.Items.Move(Index,Index+1);
   lbTabSheet.ItemIndex:=Index+1;
  end;
end;

procedure TfmRenameTabSheet.lbTabSheetDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  val: Integer;
begin
  val:=lbTabSheet.ItemAtPos(Point(X,Y),true);
  if val<>-1 then begin
    if val<>lbTabSheet.ItemIndex then begin
     if lbTabSheet.ItemIndex=-1 then exit;
     lbTabSheet.Items.Move(lbTabSheet.ItemIndex,val);
     lbTabSheet.ItemIndex:=val;
    end;
  end;
end;

procedure TfmRenameTabSheet.lbTabSheetDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  val: Integer;
begin
  Accept:=false;
  if Sender=Source then begin
    val:=lbTabSheet.ItemAtPos(Point(X,Y),true);
    if val<>-1 then begin
     if val<>lbTabSheet.ItemIndex then begin
       ptCur:=Point(X,Y);
       Accept:=true;
     end;
    end;
  end;
end;

procedure TfmRenameTabSheet.lbTabSheetKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_UP,VK_DOWN: begin
    end;
  end;
end;

procedure TfmRenameTabSheet.lbFieldsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);

  procedure DRawImages;
  var
    rc: TRect;
    t: Integer;
    newRect: TRect;
    ct: TControl;
    NewIndex: Integer;
    lb: TListBox;
    s: string;
  begin
    lb:=(Control as TListBox);
    ct:=TControl(lb.Items.Objects[Index]);
    s:=lb.Items.Strings[Index];
    NewIndex:=GetImageIndexFromClassesForWord(ct.ClassType);
    rc.TopLeft:=Rect.TopLeft;
    rc.BottomRight:=Rect.BottomRight;
    rc.Top:=rc.Top;
    rc.Bottom:=rc.Bottom;
    rc.Left:=rc.Left;
    rc.Right:=rc.Left+fmCreateCtrl.IL.Width+2;

    newRect.Left:=rc.Right;
    newRect.Top:=Rect.Top;
    newRect.Right:=Rect.Right;
    newRect.Bottom:=Rect.Bottom;

    with lb.Canvas do begin
     if State<>[odFocused,odSelected] then begin
      FillRect(newRect);
      Brush.Color:=clBtnFace;
      Brush.Style:=bsSolid;
      FillRect(rc);
      fmCreateCtrl.IL.Draw(lb.Canvas,rc.Left+1,rc.Top+1,NewIndex);
      fmCreateCtrl.ILWord.Draw(lb.Canvas,rc.Left+1,rc.Top+1,0);
     end else begin
      FillRect(newRect);
      Brush.Color:=clBtnFace;
      Brush.Style:=bsSolid;
      FillRect(rc);
      fmCreateCtrl.IL.Draw(lb.Canvas,rc.Left+1,rc.Top+1,NewIndex);
      fmCreateCtrl.ILWord.Draw(lb.Canvas,rc.Left+1,rc.Top+1,0);
     end;
     Brush.Style:=bsClear;
     Pen.Color:=clWindow;
     Rectangle(rc.left,rc.top,rc.Right,rc.Bottom);
     Pen.Color:=clBlack;
     Rectangle(rc.left+1,rc.top+1,rc.Right-1,rc.Bottom-1);
     t:=(rc.Bottom-rc.Top)div 2 -(TextHeight(s) div 2);
     t:=rc.top+t;
     TextOut(rc.Right+1,t,s);
    end;
    
  end;

begin
  DRawImages;
end;

end.
