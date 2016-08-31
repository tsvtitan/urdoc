unit USearchReestrEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, db;

type
  TfmSearchReestrEdit = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    lbDocName: TLabel;
    edDocName: TEdit;
    bibDocName: TBitBtn;
    lbOperation: TLabel;
    edOperName: TEdit;
    bibOperation: TBitBtn;
    grbDate: TGroupBox;
    cbInString: TCheckBox;
    lbDateFrom: TLabel;
    dtpDateFrom: TDateTimePicker;
    lbDateTo: TLabel;
    dtpDateTo: TDateTimePicker;
    lbUserName: TLabel;
    edUserName: TEdit;
    lbString: TLabel;
    edString: TEdit;
    lbFio: TLabel;
    edFio: TEdit;
    lbSumm: TLabel;
    edSumm: TEdit;
    lbTypeReestr: TLabel;
    edTypeReestr: TEdit;
    bibTypeReestr: TBitBtn;
    bibUsername: TBitBtn;
    bibClear: TBitBtn;
    bibDateIn: TBitBtn;
    grbDateChange: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dtpDateChangeFrom: TDateTimePicker;
    dtpDateChangeTo: TDateTimePicker;
    bibDateChange: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure bibOkClick(Sender: TObject);
    procedure bibDocNameClick(Sender: TObject);
    procedure bibOperationClick(Sender: TObject);
    procedure edStringKeyPress(Sender: TObject; var Key: Char);
    procedure edSummKeyPress(Sender: TObject; var Key: Char);
    procedure edFioChange(Sender: TObject);
    procedure edUserNameKeyPress(Sender: TObject; var Key: Char);
    procedure bibTypeReestrClick(Sender: TObject);
    procedure bibUsernameClick(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure bibDateInClick(Sender: TObject);
    procedure bibDateChangeClick(Sender: TObject);
  private
    procedure DocTreeOkClick(Sender: TObject);
  public

  end;

var
  fmSearchReestrEdit: TfmSearchReestrEdit;

implementation

uses UMain, UDocTree, UDm, URBOperation, URBTypeReestr, URBUsers;

var
  NewFm: TfmDocTree;
{$R *.DFM}

procedure TfmSearchReestrEdit.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;

  dtpDateFrom.Date:=Workdate;
  dtpDateFrom.Time:=StrtoTime('0:00:00');
  dtpDateFrom.Checked:=false;
  dtpDateTo.Date:=Workdate;
  dtpDateTo.Time:=StrtoTime('23:59:59');
  dtpDateTo.Checked:=false;

  dtpDateChangeFrom.Date:=Workdate;
  dtpDateChangeFrom.Time:=StrtoTime('0:00:00');
  dtpDateChangeFrom.Checked:=false;
  dtpDateChangeTo.Date:=Workdate;
  dtpDateChangeTo.Time:=StrtoTime('23:59:59');
  dtpDateChangeTo.Checked:=false;

end;

procedure TfmSearchReestrEdit.bibOkClick(Sender: TObject);
begin
  if dtpDateFrom.Checked then begin
  end;

  if dtpDateTo.Checked then begin
  end;

  ModalResult:=mrOk;
end;

procedure TfmSearchReestrEdit.bibDocNameClick(Sender: TObject);
var
  fm: TfmDocTree;
  Index: Integer;
begin
  fm:=TfmDocTree.Create(nil);
  try
   NewFm:=fm;
   fm.Caption:=DefSelectDocument;
   fm.pnBottom.Visible:=true;
   fm.Hide;
   fm.Position:=poScreenCenter;
   fm.BorderIcons:=[biSystemMenu, biMaximize];
   fm.ViewType:=vtEdit;
   fm.ViewType:=vtView;
   fm.ActiveQuery;
   Index:=-1;
   if fmDocTree<>nil then
    if fmDocTree.TV.Selected<>nil then
     Index:=fmDocTree.TV.Selected.AbsoluteIndex;
   if Index<>-1 then begin
    fm.tv.Items.Item[Index].MakeVisible;
    fm.tv.Items.Item[Index].Selected:=true;
    fm.ViewNodeNew(fm.tv.Items.Item[Index],true);
   end; 

   fm.bibOk.OnClick:=DocTreeOkClick;
   fm.LV.OnDblClick:=DocTreeOkClick;

   if fm.ShowModal=mrOk then begin
     if fm.LV.Selected<>nil then
      edDocName.Text:=fm.LV.Selected.Caption;
   end;
  finally
   fm.Free;
  end;
end;

procedure TfmSearchReestrEdit.DocTreeOkClick(Sender: TObject);
begin
  if NewFm=nil then exit;
  if NewFm.LV.SelCount=0 then begin
    ShowError(Application.Handle,DefSelectDocument+'.');
    exit;
  end;
  NewFm.modalResult:=mrOk;
end;

procedure TfmSearchReestrEdit.bibOperationClick(Sender: TObject);
var
  fm: TfmOperation;
begin
  fm:=TfmOperation.Create(nil);
  try
   fm.BorderIcons:=[biSystemMenu, biMaximize]; 
   fm.bibOk.Visible:=true;
   fm.bibOk.OnClick:=fm.MR;
   fm.pnSQL.Visible:=false;
   fm.Grid.OnDblClick:=fm.MR;
   fm.LoadFilter;
   fm.ActiveQuery;
   if trim(edOperName.Text)<>'' then
    fm.Mainqr.locate('name',trim(edOperName.Text),[loCaseInsensitive]);
   if fm.ShowModal=mrOk then begin
     edOperName.Text:=Trim(fm.Mainqr.fieldByName('name').AsString);
   end;
  finally
   fm.Free;
  end;
end;

{procedure TfmSearchReestrEdit.DocTreeNodeOkClick(Sender: TObject);
begin
  if NewFm=nil then exit;
  if NewFm.TV.Selected=nil then begin
    ShowError(Application.Handle,DefSelectNode+'.');
    exit;
  end;
  NewFm.modalResult:=mrOk;
end;}

procedure TfmSearchReestrEdit.edStringKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Char(Key) in ['0'..'9']))and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end;
end;

procedure TfmSearchReestrEdit.edSummKeyPress(Sender: TObject; var Key: Char);
var
  APos: Integer;
begin
  if (not (Key in ['0'..'9']))and (Key<>DecimalSeparator)and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end else begin
   if Key=DecimalSeparator then begin
    Apos:=Pos(String(DecimalSeparator),TEdit(Sender).Text);
    if Apos<>0 then Key:=char(nil);
   end;
  end;
end;

procedure TfmSearchReestrEdit.edFioChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmSearchReestrEdit.edUserNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmSearchReestrEdit.bibTypeReestrClick(Sender: TObject);
var
  fm: TfmTypeReestr;
begin
  fm:=TfmTypeReestr.Create(nil);
  try
   fm.BorderIcons:=[biSystemMenu, biMaximize];
   fm.bibOk.Visible:=true;
   fm.bibOk.OnClick:=fm.MR;
   fm.pnSQL.Visible:=false;
   fm.Grid.OnDblClick:=fm.MR;
   fm.LoadFilter;
   fm.ActiveQuery;
   if trim(edTypeReestr.Text)<>'' then
    fm.Mainqr.locate('name',trim(edTypeReestr.Text),[loCaseInsensitive]);
   if fm.ShowModal=mrOk then begin
     edTypeReestr.Text:=Trim(fm.Mainqr.fieldByName('name').AsString);
   end;
  finally
   fm.Free;
  end;
end;

procedure TfmSearchReestrEdit.bibUsernameClick(Sender: TObject);
var
  fm: TfmUsers;
begin
  fm:=TfmUsers.Create(nil);
  try
   fm.BorderIcons:=[biSystemMenu, biMaximize];
   fm.bibOk.Visible:=true;
   fm.bibOk.OnClick:=fm.MR;
   fm.pnSQL.Visible:=false;
   fm.Grid.OnDblClick:=fm.MR;
   fm.LoadFilter;
   fm.ActiveQuery;
   if trim(edUserName.Text)<>'' then
    fm.Mainqr.locate('name',trim(edUserName.Text),[loCaseInsensitive]);
   if fm.ShowModal=mrOk then begin
     edUserName.Text:=Trim(fm.Mainqr.fieldByName('name').AsString);
   end;
  finally
   fm.Free;
  end;
end;

procedure TfmSearchReestrEdit.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmSearchReestrEdit.bibDateInClick(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=tepInterval;
   P.LoadAndSave:=true;
   P.DateBegin:=dtpDateFrom.DateTime;
   P.DateEnd:=dtpDateTo.DateTime;
   if ViewEnterPeriod(P) then begin
     dtpDateFrom.DateTime:=P.DateBegin;
     dtpDateFrom.Checked:=true;
     dtpDateTo.DateTime:=P.DateEnd;
     dtpDateTo.Checked:=true;
   end;
  finally
    FreeMem(P,sizeof(TInfoEnterPeriod));
  end;
end;

procedure TfmSearchReestrEdit.bibDateChangeClick(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=tepYear;
   P.LoadAndSave:=false;
   P.DateBegin:=dtpDateChangeFrom.DateTime;
   P.DateEnd:=dtpDateChangeTo.DateTime;
   if ViewEnterPeriod(P) then begin
     dtpDateChangeFrom.DateTime:=P.DateBegin;
     dtpDateChangeFrom.Checked:=true;
     dtpDateChangeTo.DateTime:=P.DateEnd;
     dtpDateChangeTo.Checked:=true;
   end;
  finally
    FreeMem(P,sizeof(TInfoEnterPeriod));
  end;
end;

end.
