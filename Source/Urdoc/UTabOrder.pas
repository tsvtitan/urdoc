unit UTabOrder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, CheckLst, DsnHandle, DsnUnit, UNewForm;

type
  TfmTabOrder = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    pnTabOrder: TPanel;
    gbTabOrder: TGroupBox;
    pnList: TPanel;
    pnListR: TPanel;
    btUp: TBitBtn;
    btDown: TBitBtn;
    Panel1: TPanel;
    clbList: TCheckListBox;
    Panel4: TPanel;
    chbViewInspector: TCheckBox;
    procedure btUpClick(Sender: TObject);
    procedure btDownClick(Sender: TObject);
    procedure clbListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure clbListClick(Sender: TObject);
    procedure clbListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure clbListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure clbListEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure clbListDragDrop(Sender, Source: TObject; X, Y: Integer);
  private
    fmNew: TfmNewForm;
    ptCur: TPoint;
    function GetSelectedIndex: Integer;
  public
    procedure InitTabOrder(wt: TWinControl; fm: TForm);
    procedure BackUpTabOrder;
  end;

var
  fmTabOrder: TfmTabOrder;

implementation

uses UDm, UMain;

{$R *.DFM}

procedure TfmTabOrder.InitTabOrder(wt: TWinControl; fm: TForm);
var
  List: TList;
  i: Integer;
  ct: TControl;
  str: string;
  newi: Integer;
  tmps: string;
begin
  fmNew:=nil;
  if fm<>nil then  fmNew:=TfmNewForm(fm);
  List:=TList.Create;
  try
    wt.GetTabOrderList(List);
    clbList.Items.Clear;
    newi:=0;
    for i:=0 to List.Count-1 do begin
     ct:=List.Items[i];
     if not (ct is TSmallRect) then begin
      if Trim(ct.Name)<>'' then begin
       tmps:=' ('+GetTextFromControl(ct)+')';
       str:=ct.Name+': '+ct.Classname+tmps;
       clbList.Items.AddObject(str,ct);
       if ct is TWinControl then begin
        clbList.Checked[newi]:=TWinControl(ct).TabStop;
       end;
       inc(newi);
      end; 
     end; 
    end;
    if clbList.Items.Count<>0 then
     clbList.ItemIndex:=0; 
  finally
   List.Free;
  end;
end;

function TfmTabOrder.GetSelectedIndex: Integer;
var
  I: Integer;
begin
 result:=-1;
  for i:=0 to clbList.Items.Count-1 do begin
    if clbList.Selected[i] then begin
      Result:=i;
      exit;
    end;
  end;
end;

procedure TfmTabOrder.btUpClick(Sender: TObject);
var
  Index: Integer;
begin
  Index:=GetSelectedIndex;
  if Index>0 then begin
   clbList.Items.Move(Index,Index-1);
   clbList.ItemIndex:=Index-1;
  end;
  clbList.SetFocus;
end;

procedure TfmTabOrder.btDownClick(Sender: TObject);
var
  Index: Integer;
begin
  Index:=GetSelectedIndex;
  if (Index<>-1)and(Index<>clbList.Items.Count-1) then begin
   clbList.Items.Move(Index,Index+1);
   clbList.ItemIndex:=Index+1;
  end;
  clbList.SetFocus;
end;

procedure TfmTabOrder.BackUpTabOrder;
var
  i: Integer;
  ct: TControl;
begin
    for i:=0 to clbList.Items.Count-1 do begin
     ct:=TControl(clbList.Items.Objects[i]);
     if ct is TWinControl then begin
       TWinControl(ct).TabOrder:=i;
       TWinControl(ct).TabStop:=clbList.Checked[i];
     end;
    end;
end;

procedure TfmTabOrder.clbListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  tmps: string;
  x,y: Integer;
begin
  with clbList.Canvas do begin
    Brush.Style:=bsSolid;
    Brush.Color:=clWindow;
    Pen.Style:=psClear;
    FillRect(rect);
    tmps:=clbList.Items.Strings[Index];
    if State=[odSelected,odFocused] then begin
      Brush.Style:=bsSolid;
      Brush.Color:=clHighlight;
      Font.Color:=clHighlightText;
  //    FillRect(rect);
      Brush.Style:=bsClear;
      x:=rect.Left+2;
      y:=rect.Top;
      TextOut(x,y,tmps);
    end else begin
      Brush.Style:=bsSolid;
      Brush.Color:=clWindow;
      Font.Color:=clWindowText;
//      FillRect(rect);
      if PtInRect(rect,ptCur) then begin
       DrawFocusRect(rect);
      end;
      Brush.Style:=bsClear;
      x:=rect.Left+2;
      y:=rect.Top;
      TextOut(x,y,tmps);
    end;
  end;
end;

procedure TfmTabOrder.clbListClick(Sender: TObject);
var
  ct: TControl;
begin
  if clbList.Items.Count>0 then begin
    if clbList.ItemIndex<>-1 then begin
      ct:=TControl(clbList.Items.Objects[clbList.ItemIndex]);
      if fmNew<>nil then begin
        fmNew.sel.Select(ct);
        if chbViewInspector.Checked then begin
         fmNew.miPropCtrlClick(nil);
         Self.SetFocus;
        end;

      end;
    end;
  end;
end;

procedure TfmTabOrder.clbListMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  val: Integer;
begin
   if (Shift=[ssLeft]) then begin
    val:=clbList.ItemAtPos(Point(X,Y),true);
    if val<>-1 then begin
     if val=clbList.ItemIndex then begin
       clbList.BeginDrag(true);
     end;
    end;
   end;
end;

procedure TfmTabOrder.clbListDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  val: Integer;
begin
  Accept:=false;
  if Sender=Source then begin
    val:=clbList.ItemAtPos(Point(X,Y),true);
    if val<>-1 then begin
     if val<>clbList.ItemIndex then begin
       ptCur:=Point(X,Y);
       Accept:=true;
     end;
    end;
  end;
end;

procedure TfmTabOrder.clbListEndDrag(Sender, Target: TObject; X,
  Y: Integer);
var
 val: Integer;
begin
  exit;
  val:=clbList.ItemAtPos(Point(X,Y),true);
  if val<>-1 then begin
    clbList.Items.Move(clbList.ItemIndex,val);
    clbList.ItemIndex:=val;
    //clbList.Style:=lbStandard;
  end;
end;

procedure TfmTabOrder.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TfmTabOrder.clbListDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
 val: Integer;
begin

  val:=clbList.ItemAtPos(Point(X,Y),true);
  if val<>-1 then begin
    if val<>clbList.ItemIndex then begin
     if clbList.ItemIndex=-1 then exit;
     clbList.Items.Move(clbList.ItemIndex,val);
     clbList.ItemIndex:=val;
    end;
//    clbList.Style:=lbStandard;
  end;
end;

end.
