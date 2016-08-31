unit UAdjust;

interface
//{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, CheckLst, dbgrids, comctrls, inifiles;

type
  TfmAdjust = class(TForm)
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
    bibCheckAll: TBitBtn;
    bibUnCheckAll: TBitBtn;
    procedure btUpClick(Sender: TObject);
    procedure btDownClick(Sender: TObject);
    procedure clbListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure clbListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure clbListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure clbListClickCheck(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure clbListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure bibCheckAllClick(Sender: TObject);
    procedure bibUnCheckAllClick(Sender: TObject);
  private
    ptCur: TPoint;
    function GetSelectedIndex: Integer;
    procedure LoadFromIni;
    procedure SaveToIni;
  public
    procedure InitTabOrder(wt: TWinControl; fm: TForm);
    procedure BackUpTabOrder;
  end;

function SetAdjustColumns(Columns: TDBGridColumns): Boolean;
function SetAdjustTabs(Page: TPageControl): Boolean;

implementation

uses UDm;

// Import                         
const
  CaptionAdjustColumns='Настройка колонок';
  CaptionAdjustTabs='Настройка закладок';

{$R *.DFM}

function SetAdjustColumns(Columns: TDBGridColumns): Boolean;
var
  fm: TfmAdjust;

  procedure FillColumns;
  var
    i: Integer;
    cl: TColumn;
    val: Integer;
  begin
    fm.clbList.Clear;
    for i:=0 to Columns.Count-1 do begin
      cl:=Columns[i];
      val:=fm.clbList.Items.AddObject(cl.Title.Caption,cl);
      fm.clbList.Checked[val]:=cl.Visible;
    end;
  end;

  procedure SetColumns;
  var
    i: Integer;
    cl: TColumn;
  begin
    for i:=0 to fm.clbList.Items.Count-1 do begin
      cl:=TColumn(fm.clbList.Items.Objects[i]);
      cl.Index:=i;
      cl.Visible:=fm.clbList.Checked[i];
    end;
  end;

begin
 result:=false;
 try
  if Columns=nil then exit;
  fm:=TfmAdjust.Create(nil);
  try
   fm.LoadFromIni;
   fm.Caption:=CaptionAdjustColumns;
   fm.gbTabOrder.Caption:=CaptionAdjustColumns;
   FillColumns;
   if fm.ShowModal=mrOk then begin
    SetColumns;
    result:=true;
   end;
   fm.SaveToIni;
  finally
   fm.Free;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function SetAdjustTabs(Page: TPageControl): Boolean;
var
  fm: TfmAdjust;

  procedure FillTabs;
  var
    i: Integer;
    tbs: TTabSheet;
    val: Integer;
  begin
    fm.clbList.Clear;
    for i:=0 to Page.PageCount-1 do begin
      tbs:=Page.Pages[i];
      val:=fm.clbList.Items.AddObject(tbs.Caption,tbs);
      fm.clbList.Checked[val]:=tbs.TabVisible;
    end;
  end;

  procedure SetTabs;
  var
    i: Integer;
    tbs: TTabSheet;
  begin
    for i:=0 to fm.clbList.Items.Count-1 do begin
      tbs:=TTabSheet(fm.clbList.Items.Objects[i]);
      tbs.PageIndex:=i;
      tbs.TabVisible:=fm.clbList.Checked[i];
    end;
  end;

begin
 result:=false;
 try
  if Page=nil then exit;
  fm:=TfmAdjust.Create(nil);
  try
   fm.LoadFromIni;
   fm.Caption:=CaptionAdjustTabs;
   fm.gbTabOrder.Caption:=CaptionAdjustTabs;
   FillTabs;
   if fm.ShowModal=mrOk then begin
    SetTabs;
    result:=true;
   end;
   fm.SaveToIni;
  finally
   fm.Free;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmAdjust.InitTabOrder(wt: TWinControl; fm: TForm);
{var
  List: TList;
  i: Integer;
  ct: TControl;
  str: string;
  newi: Integer;
  tmps: string;}
begin
{  fmNew:=nil;
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
  end;}
end;

function TfmAdjust.GetSelectedIndex: Integer;
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

procedure TfmAdjust.btUpClick(Sender: TObject);
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

procedure TfmAdjust.btDownClick(Sender: TObject);
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

procedure TfmAdjust.BackUpTabOrder;
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

procedure TfmAdjust.clbListDrawItem(Control: TWinControl; Index: Integer;
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

procedure TfmAdjust.clbListMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  val: Integer;
begin
   if (Shift=[ssLeft]) then begin
    val:=clbList.ItemAtPos(Point(X,Y),true);
    if val<>-1 then begin
     if val=clbList.ItemIndex then begin
       clbList.BeginDrag(true);
//       clbList.Style:=lbOwnerDrawFixed;
     end;
    end;
   end;
end;

procedure TfmAdjust.clbListDragOver(Sender, Source: TObject; X,
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

procedure TfmAdjust.clbListClickCheck(Sender: TObject);
var
  i: Integer;
  CheckCount: Integer;
begin
  CheckCount:=0;
  for i:=0 to clbList.Items.Count-1 do begin
    if clbList.Checked[i] then
     inc(CheckCount);
  end;
  if CheckCount=0 then begin
//    ShowWarning(Handle,Const);
    if clbList.Items.Count<>0 then clbList.Checked[clbList.ItemIndex]:=true;
    exit;
  end;
end;

procedure TfmAdjust.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Hint:='';
end;

procedure TfmAdjust.clbListDragDrop(Sender, Source: TObject; X,
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

procedure TfmAdjust.LoadFromIni;
var
  fi: TIniFile;
begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  try
    Left:=fi.ReadInteger(ClassName,'Left',Left);
    Top:=fi.ReadInteger(ClassName,'Top',Top);
    Height:=fi.ReadInteger(ClassName,'Height',Height);
    Width:=fi.ReadInteger(ClassName,'Width',Width);
  finally
   fi.Free;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmAdjust.SaveToIni;
var
  fi: TIniFile;
begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteInteger(ClassName,'Left',Left);
    fi.WriteInteger(ClassName,'Top',Top);
    fi.WriteInteger(ClassName,'Height',Height);
    fi.WriteInteger(ClassName,'Width',Width);
  finally
   fi.Free;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmAdjust.FormCreate(Sender: TObject);
begin
  Left:=Screen.width div 2-Width div 2;
  Top:=Screen.Height div 2-Height div 2;
end;

procedure TfmAdjust.bibCheckAllClick(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to clbList.Items.Count-1 do
    clbList.Checked[i]:=true;
end;

procedure TfmAdjust.bibUnCheckAllClick(Sender: TObject);
var
  i: Integer;
  onecheck: boolean;
begin
  onecheck:=false;
  for i:=0 to clbList.Items.Count-1 do begin
   if clbList.Checked[i] then begin
     if onecheck then 
      clbList.Checked[i]:=false
     else
      onecheck:=true;  
   end;
  end;    
end;

end.
