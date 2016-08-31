unit UDocReestrEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, db;

type
  TfmDocReestrEdit = class(TForm)
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
    grbDateIn: TGroupBox;
    cbInString: TCheckBox;
    lbDateFrom: TLabel;
    dtpDateFrom: TDateTimePicker;
    lbDateTo: TLabel;
    dtpDateTo: TDateTimePicker;
    lbUserName: TLabel;
    edUserName: TEdit;
    lbNumReestr: TLabel;
    edNumReestr: TEdit;
    lbFio: TLabel;
    edFio: TEdit;
    lbSumm: TLabel;
    edSumm: TEdit;
    bibClear: TBitBtn;
    bibDateIn: TBitBtn;
    grbDateChange: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dtpDateChangeFrom: TDateTimePicker;
    dtpDateChangeTo: TDateTimePicker;
    bibDateChange: TBitBtn;
    lbCancelAction: TLabel;
    cmbCancelAction: TComboBox;
    lbHereditaryDeal: TLabel;
    edHereditaryDeal: TEdit;
    bibHereditaryDeal: TBitBtn;
    Label3: TLabel;
    edNumReestrTo: TEdit;
    grbCert: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    dtpCertFrom: TDateTimePicker;
    dtpCertTo: TDateTimePicker;
    bibCert: TBitBtn;
    lbNotarialAction: TLabel;
    edNotarialAction: TEdit;
    bibNotarialAction: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure bibOkClick(Sender: TObject);
    procedure bibDocNameClick(Sender: TObject);
    procedure bibOperationClick(Sender: TObject);
    procedure edNumReestrKeyPress(Sender: TObject; var Key: Char);
    procedure edSummKeyPress(Sender: TObject; var Key: Char);
    procedure bibClearClick(Sender: TObject);
    procedure bibDateInClick(Sender: TObject);
    procedure bibDateChangeClick(Sender: TObject);
    procedure bibHereditaryDealClick(Sender: TObject);
    procedure bibCertClick(Sender: TObject);
    procedure bibNotarialActionClick(Sender: TObject);
  private
    procedure DocTreeOkClick(Sender: TObject);
//    procedure DocTreeNodeOkClick(Sender: TObject);
  public

  end;

var
  fmDocReestrEdit: TfmDocReestrEdit;

implementation

uses UMain, UDocTree, UDm, URBOperation, URBHereditaryDeal,
  URBNotarialAction;

var
  NewFm: TfmDocTree;
{$R *.DFM}

procedure TfmDocReestrEdit.FormCreate(Sender: TObject);
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

  dtpCertFrom.Date:=Workdate;
  dtpCertFrom.Time:=StrtoTime('0:00:00');
  dtpCertFrom.Checked:=false;
  dtpCertTo.Date:=Workdate;
  dtpCertTo.Time:=StrtoTime('23:59:59');
  dtpCertTo.Checked:=false;

  cmbCancelAction.ItemIndex:=0;
end;

procedure TfmDocReestrEdit.bibOkClick(Sender: TObject);
begin
  if Trim(edNumReestr.text)<>'' then
    if not isInteger(Trim(edNumReestr.text)) then begin
      ShowError(Handle,'«начение должно быть целым числом.');
      edNumReestr.SetFocus;
      exit;
    end;
  if Trim(edNumReestrTo.text)<>'' then
    if not isInteger(Trim(edNumReestrTo.text)) then begin
      ShowError(Handle,'«начение должно быть целым числом.');
      edNumReestrTo.SetFocus;
      exit;
    end;  

  if (Trim(edNumReestr.text)<>'')and
     (Trim(edNumReestrTo.text)<>'') then begin
    if StrToInt(Trim(edNumReestr.text))>StrToInt(Trim(edNumReestrTo.text)) then begin
      ShowError(Handle,'Ќомер <с которого> должен быть меньше номера <по>.');
      edNumReestr.SetFocus;
      exit;
    end;
  end;

  if dtpDateFrom.Checked then begin
  end;

  if dtpDateTo.Checked then begin
  end;

  ModalResult:=mrOk;
end;

procedure TfmDocReestrEdit.bibDocNameClick(Sender: TObject);
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

procedure TfmDocReestrEdit.DocTreeOkClick(Sender: TObject);
begin
  if NewFm=nil then exit;
  if NewFm.LV.SelCount=0 then begin
    ShowError(Application.Handle,DefSelectDocument+'.');
    exit;
  end;
  NewFm.modalResult:=mrOk;
end;

procedure TfmDocReestrEdit.bibOperationClick(Sender: TObject);
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
    fm.Mainqr.locate('name',trim(edOperName.Text),[loPartialKey,loCaseInsensitive]);
   if fm.ShowModal=mrOk then begin
     edOperName.Text:=Trim(fm.Mainqr.fieldByName('name').AsString);
   end;
  finally
   fm.Free;
  end;
end;

{procedure TfmDocReestrEdit.DocTreeNodeOkClick(Sender: TObject);
begin
  if NewFm=nil then exit;
  if NewFm.TV.Selected=nil then begin
    ShowError(Application.Handle,DefSelectNode+'.');
    exit;
  end;
  NewFm.modalResult:=mrOk;
end;}

procedure TfmDocReestrEdit.edNumReestrKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Char(Key) in ['0'..'9']))and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end;
end;

procedure TfmDocReestrEdit.edSummKeyPress(Sender: TObject; var Key: Char);
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

procedure TfmDocReestrEdit.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmDocReestrEdit.bibDateInClick(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=tepDay;
   P.LoadAndSave:=false;
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

procedure TfmDocReestrEdit.bibDateChangeClick(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=tepDay;
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

procedure TfmDocReestrEdit.bibHereditaryDealClick(Sender: TObject);
var
  fm: TfmHereditaryDeal;
begin
  fm:=TfmHereditaryDeal.Create(nil);
  try
   fm.BorderIcons:=[biSystemMenu, biMaximize]; 
   fm.bibOk.Visible:=true;
   fm.bibOk.OnClick:=fm.MR;
   fm.pnSQL.Visible:=false;
   fm.Grid.OnDblClick:=fm.MR;
   fm.LoadFilter;
   fm.ActiveQuery;
   if trim(edHereditaryDeal.Text)<>'' then
    fm.Mainqr.locate('numdeal',trim(edHereditaryDeal.Text),[loPartialKey,loCaseInsensitive]);
   if fm.ShowModal=mrOk then begin
     edHereditaryDeal.Text:=Trim(fm.Mainqr.fieldByName('numdeal').AsString);
   end;
  finally
   fm.Free;
  end;
end;

procedure TfmDocReestrEdit.bibCertClick(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=tepDay;
   P.LoadAndSave:=false;
   P.DateBegin:=dtpCertFrom.DateTime;
   P.DateEnd:=dtpCertTo.DateTime;
   if ViewEnterPeriod(P) then begin
     dtpCertFrom.DateTime:=P.DateBegin;
     dtpCertFrom.Checked:=true;
     dtpCertTo.DateTime:=P.DateEnd;
     dtpCertTo.Checked:=true;
   end;
  finally
    FreeMem(P,sizeof(TInfoEnterPeriod));
  end;
end;

procedure TfmDocReestrEdit.bibNotarialActionClick(Sender: TObject);
var
  fm: TfmRBNotarialAction;
begin
  fm:=TfmRBNotarialAction.Create(nil);
  try
   fm.BorderIcons:=[biSystemMenu, biMaximize]; 
   fm.bibOk.Visible:=true;
   fm.bibOk.OnClick:=fm.MR;
   fm.pnSQL.Visible:=false;
   fm.Grid.OnDblClick:=fm.MR;
   fm.LoadFilter;
   fm.ActiveQuery;
   if trim(edNotarialAction.Text)<>'' then
    fm.Mainqr.locate('name',trim(edNotarialAction.Text),[loPartialKey,loCaseInsensitive]);
   if fm.ShowModal=mrOk then begin
     edNotarialAction.Text:=Trim(fm.Mainqr.fieldByName('name').AsString);
   end;
  finally
   fm.Free;
  end;
end;

end.
