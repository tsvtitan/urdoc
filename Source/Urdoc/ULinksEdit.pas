unit ULinksEdit;

interface

uses {$IFDEF WIN32} Windows, {$ELSE} WinTypes, WinProcs, {$ENDIF} Classes,
  Graphics, Forms, Controls, Buttons, Dialogs, StdCtrls, ExtCtrls, messages,
  UCreateCtrl, UNewControls, inifiles, typinfo;

type
  TfmLinksEdit = class(TForm)
    pnBottom: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    pnLeft: TPanel;
    pnRigth: TPanel;
    grbExists: TGroupBox;
    grbLinks: TGroupBox;
    bibAdd: TBitBtn;
    pnExists: TPanel;
    pnLinks: TPanel;
    lbExists: TListBox;
    lbLinks: TListBox;
    bibAddAll: TBitBtn;
    bibDel: TBitBtn;
    bibDelAll: TBitBtn;
    pnCenter: TPanel;
    procedure bibOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbExistsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure bibAddClick(Sender: TObject);
    procedure bibAddAllClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibDelAllClick(Sender: TObject);
    procedure lbExistsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lbLinksDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lbLinksEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure lbExistsEndDrag(Sender, Target: TObject; X, Y: Integer);
  private
    fm: TfmCreateCtrl;
    CurControl: TControl;
    CurTTL: TTypeLinks;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure ClearListBoxs;
    function isNameAlreadyExists(lb: TListBox; Value: String): Boolean;
    procedure ViewCount(grb: TGroupBox);
    procedure RemoveControlFromListBox(lb: TListBox; ControlName: String);
    procedure SetFromListBox;
    procedure LoadFromIni;
    procedure SaveToIni;
  public
    procedure FillListBoxs(wt: TWinControl; ttl: TTypeLinks; MainControl: TControl);

  end;

implementation

{$R *.DFM}

uses SysUtils, UDm;

{ TfmLinksEdit }

type
  PInfoLink=^TInfoLink;
  TInfoLink=packed record
    DrawName: string;
    RealName: string;
    ImageIndex: Integer;
  end;
  
const
  WCenter=100;

procedure TfmLinksEdit.bibOkClick(Sender: TObject);
begin
  SetFromListBox;
  ModalResult:=mrOk;
end;

procedure TfmLinksEdit.FormCreate(Sender: TObject);
begin
  Left:=Screen.width div 2-Width div 2;
  Top:=Screen.Height div 2-Height div 2;

  fm:=TfmCreateCtrl.Create(nil);
  pnLeft.Align:=alNone;
  pnLeft.Width:=ClientWidth div 2 - WCenter div 2;
  pnLeft.Align:=alLeft;
  pnRigth.Align:=alNone;
  pnRigth.Width:=pnLeft.Width;
  pnRigth.Align:=alRight;
  pnCenter.Width:=WCenter;

  lbExists.ItemHeight:=fm.IL.Height+2;
  lbLinks.ItemHeight:=lbExists.ItemHeight;
  LoadFromIni;
end;

procedure TfmLinksEdit.WMSize(var Message: TWMSize);
begin
  pnLeft.Align:=alNone;
  pnLeft.Width:=ClientWidth div 2 - WCenter div 2;
  pnLeft.Align:=alLeft;
  pnRigth.Align:=alNone;
  pnRigth.Width:=pnLeft.Width;
  pnRigth.Align:=alRight;
  pnCenter.Width:=WCenter;
end;

procedure TfmLinksEdit.FormDestroy(Sender: TObject);
begin
  ClearListBoxs;
  fm.Free;
  SaveToIni;
end;

procedure TfmLinksEdit.ClearListBoxs;

  procedure ClearCurrent(lb: TListBox);
  var
    i: Integer;
    PNew: PInfoLink;
  begin
   lb.Items.BeginUpdate;
   try
    for i:=0 to lb.Items.Count-1 do begin
      PNew:=PInfoLink(lb.Items.Objects[i]);
      dispose(PNew);
    end;
    lb.Items.Clear;
   finally
    lb.Items.EndUpdate;
   end; 
  end;
  
begin
  ClearCurrent(lbExists);
  ClearCurrent(lbLinks);
end;

procedure TfmLinksEdit.FillListBoxs(wt: TWinControl; ttl: TTypeLinks; MainControl: TControl);

  procedure FillExists(WinCont: TWinControl);
  var
    i: Integer;
    P: PInfoLink;
    ct: TControl;
  begin
   lbExists.Items.BeginUpdate;
   try
    for i:=0 to WinCont.ControlCount-1 do begin
      ct:=WinCont.Controls[i];
      if isNewControl(ct) then begin
       new(P);
       if ct is TNewLabel then
         P.DrawName:=ct.Name+' - '+GetTextFromControl(ct)
       else P.DrawName:=ct.Name+' - '+GetStrProp(ct,ConstPropDocFieldName);
       P.RealName:=ct.Name;
       P.ImageIndex:=GetImageIndexFromClassesForWord(ct.ClassType);
       lbExists.Items.AddObject(P.DrawName,TObject(P));
      end;
      if ct is TWinControl then begin
        FillExists(TWinControl(ct));
      end;
    end;
   finally
    lbExists.Items.EndUpdate;
   end;
  end;

  procedure FillLinks;
  var
    i: Integer;
    P: PInfoLink;
    ct: TControl;
    cpt: TComponent;
    tmps: string;
  begin
   lbLinks.Items.BeginUpdate;
   try
    lbLinks.Clear;
    for i:=0 to ttl.Count-1 do begin
     tmps:=ttl.Strings[i];
     ct:=nil;
     cpt:=wt.FindComponent(tmps);
     if cpt is TControl then
      ct:=TControl(cpt);
     if ct<>nil then begin
      if isNewControl(ct) then begin
       new(P);
       if ct is TNewLabel then
         P.DrawName:=ct.Name+' - '+GetTextFromControl(ct)
       else P.DrawName:=ct.Name+' - '+GetStrProp(ct,ConstPropDocFieldName);
       P.RealName:=ct.Name;
       P.ImageIndex:=GetImageIndexFromClassesForWord(ct.ClassType);
       lbLinks.Items.AddObject(P.DrawName,TObject(P));
      end;
     end;
    end;
   finally
    lbLinks.Items.EndUpdate;
   end;
  end;

  procedure RemoveExist;
  var
    i: Integer;
  begin
    for i:=0 to ttl.Count-1 do begin
      RemoveControlFromListBox(lbExists,ttl.Strings[i]);
    end;
  end;

begin
  if wt=nil then exit;
  if ttl=nil then exit;
  if MainControl=nil then exit;
  CurControl:=MainControl;
  CurTTL:=ttl;
  lbExists.Clear;
  FillExists(wt);
  lbLinks.Clear;
  FillLinks;
  RemoveControlFromListBox(lbExists,CurControl.Name);
  RemoveControlFromListBox(lbLinks,CurControl.Name);
  RemoveExist;
  ViewCount(grbExists);
  ViewCount(grbLinks);

end;

procedure TfmLinksEdit.RemoveControlFromListBox(lb: TListBox; ControlName: String);
var
  i: Integer;
  P: PInfoLink;
begin
 lb.Items.BeginUpdate;
 try
  for i:=lb.Items.Count-1 downto 0 do begin
   P:=PInfoLink(lb.Items.Objects[i]);
   if P.RealName=ControlName then begin
     lb.Items.Delete(i);
     dispose(P);
   end;
  end;
 finally
   lb.Items.EndUpdate; 
 end;
end;

procedure TfmLinksEdit.lbExistsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);

  procedure DRawImages;
  var
    rc: TRect;
    t: Integer;
    newRect: TRect;
    P: PInfoLink;
    NewIndex: Integer;
    lb: TListBox;
  begin
    lb:=(Control as TListBox);
    P:=PInfoLink(lb.Items.Objects[Index]);
    NewIndex:=P.ImageIndex;
    rc.TopLeft:=Rect.TopLeft;
    rc.BottomRight:=Rect.BottomRight;
    rc.Top:=rc.Top;
    rc.Bottom:=rc.Bottom;
    rc.Left:=rc.Left;
    rc.Right:=rc.Left+fm.IL.Width+2;

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
      fm.IL.Draw(lb.Canvas,rc.Left+1,rc.Top+1,NewIndex);
      fm.ILWord.Draw(lb.Canvas,rc.Left+1,rc.Top+1,0);
     end else begin
      FillRect(newRect);
      Brush.Color:=clBtnFace;
      Brush.Style:=bsSolid;
      FillRect(rc);
      fm.IL.Draw(lb.Canvas,rc.Left+1,rc.Top+1,NewIndex);
      fm.ILWord.Draw(lb.Canvas,rc.Left+1,rc.Top+1,0);
     end;
     Brush.Style:=bsClear;
     Pen.Color:=clWindow;
     Rectangle(rc.left,rc.top,rc.Right,rc.Bottom);
     Pen.Color:=clBlack;
     Rectangle(rc.left+1,rc.top+1,rc.Right-1,rc.Bottom-1);
     t:=(rc.Bottom-rc.Top)div 2 -(TextHeight(P.DrawName) div 2);
     t:=rc.top+t;
     TextOut(rc.Right+1,t,P.DrawName);
    end;
    
  end;

begin
  DRawImages;
end;

procedure TfmLinksEdit.bibAddClick(Sender: TObject);
var
  i: Integer;
  PFrom,PTo: PInfoLink;
begin
 lbLinks.Items.BeginUpdate;
 lbExists.Items.BeginUpdate;
 try
  for i:=lbExists.Items.Count-1 downto 0 do begin
    if lbExists.Selected[i] then begin
     PFrom:=PInfoLink(lbExists.Items.Objects[i]);
     if not isNameAlreadyExists(lbLinks,PFrom.RealName) then begin
      new(PTo);
      PTo.DrawName:=PFrom.DrawName;
      PTo.RealName:=PFrom.RealName;
      PTo.ImageIndex:=PFrom.ImageIndex;
      lbLinks.Items.AddObject(PTo.DrawName,TObject(PTo));
     end;
     lbExists.Items.Delete(i);
     dispose(PFrom);
    end;
  end;
 finally
  lbLinks.Items.EndUpdate;
  lbExists.Items.EndUpdate;
  ViewCount(grbExists);
  ViewCount(grbLinks);
 end; 
end;

function TfmLinksEdit.isNameAlreadyExists(lb: TListBox; Value: String): Boolean;
var
  i: Integer;
  P: PInfoLink;
begin
  Result:=false;
  for i:=0 to lb.Items.Count-1 do begin
    P:=PInfoLink(lb.Items.Objects[i]);
    if P.RealName=Value then begin
      Result:=True;
      exit;
    end;
  end;
end;

procedure TfmLinksEdit.bibAddAllClick(Sender: TObject);
var
  i: Integer;
begin
 lbExists.Items.BeginUpdate;
 try
  for i:=0 to lbExists.Items.Count-1 do
   lbExists.Selected[i]:=true;
  bibAdd.Click;
  for i:=0 to lbExists.Items.Count-1 do
   lbExists.Selected[i]:=false;
 finally

  lbExists.Items.EndUpdate;
 end; 
end;

procedure TfmLinksEdit.ViewCount(grb: TGroupBox);
begin
  if grb=grbExists then begin
   grbExists.Caption:='Существующие - '+inttostr(lbExists.Items.count)+' ';
  end;
  if grb=grbLinks then begin
   grbLinks.Caption:='Связанные - '+inttostr(lbLinks.Items.count)+' ';
  end;
end;

procedure TfmLinksEdit.bibDelClick(Sender: TObject);
var
  i: Integer;
  PFrom,PTo: PInfoLink;
begin
 lbLinks.Items.BeginUpdate;
 lbExists.Items.BeginUpdate;
 try
  for i:=lbLinks.Items.Count-1 downto 0 do begin
    if lbLinks.Selected[i] then begin
     PFrom:=PInfoLink(lbLinks.Items.Objects[i]);
     if not isNameAlreadyExists(lbExists,PFrom.RealName) then begin
      new(PTo);
      PTo.DrawName:=PFrom.DrawName;
      PTo.RealName:=PFrom.RealName;
      PTo.ImageIndex:=PFrom.ImageIndex;
      lbExists.Items.AddObject(PTo.DrawName,TObject(PTo));
     end;
     lbLinks.Items.Delete(i);
     dispose(PFrom);
    end;
  end;
 finally
  lbLinks.Items.EndUpdate;
  lbExists.Items.EndUpdate;
  ViewCount(grbExists);
  ViewCount(grbLinks);
 end; 
end;

procedure TfmLinksEdit.bibDelAllClick(Sender: TObject);
var
  i: Integer;
begin
 lbLinks.Items.BeginUpdate;
 try
  for i:=0 to lbLinks.Items.Count-1 do
   lbLinks.Selected[i]:=true;
  bibdel.Click;
  for i:=0 to lbLinks.Items.Count-1 do
   lbLinks.Selected[i]:=false;
 finally
  lbLinks.Items.EndUpdate;
 end; 
end;

procedure TfmLinksEdit.SetFromListBox;
var
  i: Integer;
  P: PInfoLink;
begin
 CurTTL.BeginUpdate;
 try
  CurTTL.Clear;
  for i:=0 to lbLinks.items.Count-1 do begin
    P:=PInfoLink(lbLinks.items.Objects[i]);
    CurTTL.Add(P.RealName);
  end;
 finally
  CurTTL.EndUpdate;
 end;
end;

procedure TfmLinksEdit.lbExistsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:=false;
  if Sender=lbExists then begin
    Accept:=false;
  end;
  if Source=lbLinks then begin
    Accept:=true;
  end;
end;

procedure TfmLinksEdit.lbLinksDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:=false;
  if Sender=lbLinks then begin
    Accept:=false;
  end;
  if Source=lbExists then begin
    Accept:=true;
  end;
end;

procedure TfmLinksEdit.lbLinksEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  if Target=lbExists then begin
   bibDel.Click;
  end;
end;

procedure TfmLinksEdit.lbExistsEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  if Target=lbLinks then begin
   bibAdd.Click;
  end;
end;

procedure TfmLinksEdit.LoadFromIni;
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
 end;
end;

procedure TfmLinksEdit.SaveToIni;
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
 end;
end;

end.
