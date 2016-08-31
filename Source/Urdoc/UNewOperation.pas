unit UNewOperation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, UNewControls, IBQuery, IBTable,db,IBDatabase,
  ComCtrls, marquee, Variants;

type
  TfmNewOperation = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    bibOtlogen: TBitBtn;
    pnTop: TPanel;
    grbDoplnit: TGroupBox;
    lbOperation: TLabel;
    cbOperation: TComboBox;
    lbSumm: TLabel;
    lbSummPriv: TLabel;
    chbOnSogl: TCheckBox;
    lbCurReestr: TLabel;
    cbCurReestr: TComboBox;
    lbNumLic: TLabel;
    cbNumLic: TComboBox;
    lbMotion: TLabel;
    cmbMotion: TComboBox;
    chbNoYear: TCheckBox;
    lbFio: TLabel;
    cbFio: TComboBox;
    chbDefect: TCheckBox;
    lbCertificateDate: TLabel;
    dtpCertificateDate: TDateTimePicker;
    lbNumReestr: TLabel;
    edNumReestr: TEdit;
    btNextNumReestr: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure cbCurReestrChange(Sender: TObject);
    procedure cbOperationChange(Sender: TObject);
    procedure cbFioDropDown(Sender: TObject);
    procedure btNextNumReestrClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    pnMarquee: TPanel;
    pnReminder: TddgMarquee;
    Prefix,Sufix: string;
    isAreadyFillFio: Boolean;
    IsOtlogen: Boolean;
    function AppendToReestr: Boolean;
    procedure FillTypeReestrComboAndSetIndex(TypeReestrID: Integer);
    procedure FillFioCombo;
    procedure FillOpearionComboAndSetLast;
    function GetWhoCertificateId(var whocertificate: string): Integer;
  public
    SummEdit: TRxCalcEdit;
    SummEditPriv: TRxCalcEdit;
    DefLastTypeReestrID: Integer;
    LastTypeReestrID: Integer;
    LastOperID: Integer;
    isInsert: Boolean;
    LastReestrID: Integer;
    RenovationId: Integer;
    procedure FillAllNeedField;
    function IsReestrIDFound: Boolean;
    procedure FillAllNeedFieldForUpdate(NewNumReestr: Integer;
                newTypeReestrID: Integer; newFio: String;
                newSumm: Extended; newReestrID: Integer;
                newLicenseID: Integer);
    procedure edNumReestrKeyPress(Sender: TObject; var Key: Char);
    procedure edNumReestrChange(Sender: TObject);
    procedure bibCancelClickAppend(Sender: TObject);
    procedure bibOkClickAppend(Sender: TObject);
    procedure bibOtlogenClickAppend(Sender: TObject);
    procedure bibOkClickUpdate(Sender: TObject);
    procedure bibCancelClickUpdate(Sender: TObject);
    procedure bibOtlogenClickUpdate(Sender: TObject);
    function UpdateReestr: Boolean;
    function fUpdate(msOutForm: TMemoryStream; List: TList): Boolean;
    procedure InsertIntoOperations;
    procedure cmbMotionChange(Sender: TObject);
    procedure DestroyHeaderAndCreateNew;
    procedure cbNumLicChange(Sender: TObject);
    procedure cbFioKeyPress(Sender: TObject; var Key: Char);
    procedure FillNotarialActions(isUseForUpdate: Boolean);
    procedure FillNumLicenseCombo(LicenseID: Integer);
    procedure FillReminders;
    procedure SummEditChange(Sender: TObject);
  end;

var
  fmNewOperation: TfmNewOperation;

implementation

uses UDm, UDocReestr, UMain;

{$R *.DFM}

procedure TfmNewOperation.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfmNewOperation.FormCreate(Sender: TObject);
begin
   SummEdit:=TRxCalcEdit.Create(Self);
   SummEdit.Name:='SummEdit';
   SummEdit.Parent:=grbDoplnit;
   SummEdit.Top:=edNumReestr.Top;
   SummEdit.Left:=lbSumm.Left+lbSumm.Width+15;
   SummEdit.Width:=cbCurReestr.Left+cbCurReestr.Width-SummEdit.Left;

   SummEditPriv:=TRxCalcEdit.Create(Self);
   SummEditPriv.parent:=grbDoplnit;
   SummEditPriv.Name:='SummEditPriv';
   
   edNumReestr.TabOrder:=1;
   edNumReestr.OnKeyPress:=edNumReestrKeyPress;
   edNumReestr.OnChange:=edNumReestrChange;
   SummEdit.TabOrder:=2;
   cbCurReestr.TabOrder:=3;
   cbFio.TabOrder:=4;
   cbOperation.TabOrder:=5;
   RenovationId:=0;
end;

procedure TfmNewOperation.edNumReestrKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Char(Key) in ['0'..'9']))and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end;
end;

procedure TfmNewOperation.edNumReestrChange(Sender: TObject);
{var
  E: Integer;
  retval: Integer;}
begin
{  Val(edNumReestr.text, retval, E);
  if E <> 0 then begin
   edNumReestr.text:=inttostr(GetMaxNumReestr(LastTypeReestrID,UserID));
  end else edNumReestr.text:=inttostr(retval);}
end;

procedure TfmNewOperation.bibCancelClickAppend(Sender: TObject);
begin
  Close;
end;

procedure TfmNewOperation.bibOkClickAppend(Sender: TObject);
begin
  IsOtlogen:=false;
  if AppendToReestr then
   Close;
end;

procedure TfmNewOperation.bibOtlogenClickAppend(Sender: TObject);
begin
  IsOtlogen:=true;
  if AppendToReestr then
   Close;
end;

procedure TfmNewOperation.FillTypeReestrComboAndSetIndex(TypeReestrID: Integer);
var
  qr: TIBQuery;
  sqls: string;
  namestr: string;
  typeresstr_id: Integer;
  Index: Integer;
  newInc: Integer;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  cbCurReestr.Items.BeginUpdate;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select typereestr_id,name,prefix,sufix from '+TableTypeReestr+' order by sortnum';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   cbCurReestr.Clear;
   newInc:=0;
   Index:=0;
   qr.First;
   while not qr.Eof do begin
     namestr:=Trim(qr.FieldByName('name').AsString);
     typeresstr_id:=qr.FieldByName('typereestr_id').AsInteger;
     if typeresstr_id=TypeReestrID then begin
       Prefix:=qr.FieldByName('prefix').AsString;
       Sufix:=qr.FieldByName('sufix').AsString;
       Index:=newInc;
     end;  

     cbCurReestr.Items.AddObject(namestr,TObject(Pointer(typeresstr_id)));
     inc(newInc);
     qr.Next;
   end;
  finally
   qr.Free;
   tr.Free;
   cbCurReestr.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
  if cbCurReestr.Items.Count>0 then begin
    cbCurReestr.ItemIndex:=Index;
  end;
end;

procedure TfmNewOperation.FillFioCombo;
var
  qr: TIBQuery;
  sqls: string;
  namestr: string;
  tr: TIBTransaction;
  s: string;
begin
  if isAreadyFillFio then exit;
  Screen.Cursor:=crHourGlass;
  cbFio.Items.BeginUpdate;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   s:=cbFio.Text;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select Distinct(fio) as fio from '+TableReestr+
         ' where typereestr_id='+inttostr(LastTypeReestrID)+
         ' and isdel is null '+
         ' order by fio';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   cbFio.Clear;
   qr.First;
   while not qr.Eof do begin
     namestr:=Trim(qr.FieldByName('fio').AsString);
     cbFio.Items.Add(namestr);
     qr.Next;
   end;
  finally
   isAreadyFillFio:=true;
   cbFio.Text:=s;
   qr.Free;
   tr.Free;
   cbFio.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
end;

procedure TfmNewOperation.cbCurReestrChange(Sender: TObject);
begin
 if cbCurReestr.ItemIndex<>-1 then begin
  LastTypeReestrID:=Integer(Pointer(TObject(cbCurReestr.Items.Objects[cbCurReestr.ItemIndex])));
  FillAllNeedField;
 end;
end;

procedure TfmNewOperation.FillAllNeedField;
begin
//  edNumReestr.Text:=inttostr(GetMaxNumReestr(LastTypeReestrID,UserID));
  edNumReestr.Text:='';
  FillTypeReestrComboAndSetIndex(LastTypeReestrID);
  FillNotarialActions(false);
  isAreadyFillFio:=false;
//  FillFioCombo;
  FillOpearionComboAndSetLast;
  if cbCurReestr.ItemIndex<>-1 then begin
   LastTypeReestrID:=Integer(Pointer(TObject(cbCurReestr.Items.Objects[cbCurReestr.ItemIndex])));
   FillNumLicenseCombo(0);
  end;
  
end;

procedure TfmNewOperation.FillOpearionComboAndSetLast;
var
  qr: TIBQuery;
  sqls: string;
  namestr: string;
  oper_id: Integer;
  Index: Integer;
  newInc: Integer;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  cbOperation.Items.BeginUpdate;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select oper_id,name from '+TableOperation+' order by name';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   cbOperation.Clear;
   newInc:=0;
   Index:=0;
   qr.First;
   while not qr.Eof do begin
     namestr:=Trim(qr.FieldByName('name').AsString);
     oper_id:=qr.FieldByName('oper_id').AsInteger;
     if LastOperID<>0 then begin
      if oper_id=LastOperID then
       Index:=newInc;
     end;

     cbOperation.Items.AddObject(namestr,TObject(Pointer(oper_id)));
     inc(newInc);
     qr.Next;
   end;
  finally
   qr.Free;
   tr.Free;
   cbOperation.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
  if cbOperation.Items.Count>0 then begin
    cbOperation.ItemIndex:=Index;
    LastOperID:=Integer(Pointer(TObject(cbOperation.Items.Objects[cbOperation.ItemIndex])));
  end;
end;


procedure TfmNewOperation.cbOperationChange(Sender: TObject);
begin
 if cbOperation.ItemIndex<>-1 then begin
  LastOperID:=Integer(Pointer(TObject(cbOperation.Items.Objects[cbOperation.ItemIndex])));
 end;
end;

function TfmNewOperation.GetWhoCertificateId(var whocertificate: string): Integer;
var
  PInNot: PInfoNotarius;
  PHelper: PInfoNotarius;
  TypeReestr_id: Integer;
  IHI: TInfoHelperItem;
begin

  New(PInNot);
  New(PHelper);
  try
   Result:=0;
   IHI:=TInfoHelperItem(fmMain.cmbHelper.Items.Objects[fmMain.cmbHelper.ItemIndex]);
   if not Assigned(IHI) then begin
     FillChar(PInNot^,SizeOf(PInNot),0);
     TypeReestr_id:=Integer(Pointer(TObject(cbCurReestr.Items.Objects[cbCurReestr.ItemIndex])));
     GetInfoNotarius(TypeReestr_id,PInNot,RenovationId);
     whocertificate:=PInNot.FIO;
     Result:=PInNot.not_id;
   end else begin
     FillChar(PHelper^,SizeOf(PHelper),0);
     GetInfoNotariusEx(IHI.NotId,PHelper,RenovationId,true,false,false);
     whocertificate:=PHelper.FIO;
     Result:=PHelper.not_id;
   end;
 finally
   Dispose(PHelper);
   Dispose(PInNot);
 end;
end;

function TfmNewOperation.AppendToReestr: Boolean;
var
  tb: TIBTable;
  tr: TIBTransaction;
  reestr_id: Integer;
  tmpName: string;
  whocertificate_id: Integer;
  whocertificate: string;
begin
  Result:=false;
  if cbCurReestr.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ������.');
   cbCurReestr.SetFocus;
   exit;
  end;
  if cbNumLic.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ��������.');
   cbNumLic.SetFocus;
   exit;
  end;
  if cmbMotion.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ������������ ��������.');
   cmbMotion.SetFocus;
   exit;
  end;
  if Trim(cbFio.Text)='' then begin
   ShowError(Application.Handle,'�������� ��� ������� ������� �.�.');
   cbFio.SetFocus;
   exit;
  end;
  if Trim(cbOperation.Text)='' then begin
   ShowError(Application.Handle,'�������� ��� ������� ��������.');
   cbOperation.SetFocus;
   exit;
  end else begin
   InsertIntoOperations;
  end;

  if isCheckEmptySumm then
    if (Trim(edNumReestr.Text)<>'') and (SummEdit.Value=0.0) then begin
     ShowError(Application.Handle,'����� ��� �������� �� ����� ���� ����� 0.');
     SummEdit.SetFocus;
     exit;
    end;


  if Trim(edNumReestr.Text)<>'' then begin
    if isNumReestrAlready(Strtoint(edNumReestr.Text),LastTypeReestrID) then begin
      ShowError(Application.Handle,'����� � ������� <'+edNumReestr.Text+'> ��� ����������.');
      edNumReestr.Text:=inttostr(GetMaxNumReestr(LastTypeReestrID,UserID));
      edNumReestr.SetFocus;
      exit;
    end;
    DocumentLock(Strtoint(edNumReestr.Text),LastTypeReestrID);
  end;

  try
        IsOtlogen:=Trim(edNumReestr.Text)='';

        Screen.Cursor:=crHourGlass;
        tr:=TIBTransaction.Create(nil);
        tb:=TIBTable.Create(nil);
        try
         reestr_id:=fmDocReestr.GetMaxReestrID;

         tr.AddDatabase(dm.IBDbase);
         dm.IBDbase.AddTransaction(tr);
         tr.Params.Text:=DefaultTransactionParamsTwo;
         tb.Database:=dm.IBDbase;
         tb.Transaction:=tr;
         tb.Transaction.Active:=true;
         tb.TableName:=TableReestr;
         tb.Filter:=' reestr_id='+Inttostr(reestr_id )+' ';
         tb.Filtered:=true;
         tb.Active:=true;
         tb.Append;

         tb.FieldByName('reestr_id').AsInteger:=reestr_id;

         tb.FieldByName('certificatedate').AsDateTime:=StrToDate(DateToStr(dtpCertificateDate.Date))+Time;
         whocertificate_id:=GetWhoCertificateId(whocertificate);
         tb.FieldByName('whocertificate_id').AsInteger:=whocertificate_id;

         tb.FieldByName('oper_id').AsInteger:=LastOperID;
         tb.FieldByName('datein').AsDateTime:=StrToDate(DateToStr(WorkDate))+Time;
         tb.FieldByName('whoin').AsInteger:=UserId;
         tb.FieldByName('datechange').AsDateTime:=StrToDate(DateToStr(WorkDate))+Time;
         tb.FieldByName('whochange').AsInteger:=UserId;
         tb.FieldByName('keepdoc').AsInteger:=0;
         tb.FieldByName('yearwork').AsInteger:=WorkYear;

         tb.FieldByName('typereestr_id').AsInteger:=LastTypeReestrID;
         tb.FieldByName('notarialaction_id').AsInteger:=LastNotarialActionId;
         tb.FieldByName('noyear').AsInteger:=Integer(chbNoYear.Enabled and chbNoYear.Checked);
         tb.FieldByName('defect').AsInteger:=Integer(chbDefect.Enabled and chbDefect.Checked);
         tb.FieldByName('summpriv').AsFloat:=SummEditPriv.Value;


         if not IsOtlogen then
          tb.FieldByName('numreestr').AsInteger:=Strtoint(edNumReestr.Text);
         tb.FieldByName('fio').AsString:=Trim(cbFio.text);
         tb.FieldByName('summ').AsFloat:=SummEdit.Value;
         tmpName:=GetOperName(LastOperID);
         tb.FieldByName('tmpname').AsString:=tmpName;

         tb.FieldByName('countuse').AsInteger:=1;

         tb.Post;
         tb.Transaction.CommitRetaining;

          fmDocReestr.NeedCacheUpdate(true,
                                      reestr_id,true,
                                      Iff(not IsOtlogen,iff(Trim(edNumReestr.Text)='',Null,Prefix+Trim(edNumReestr.Text)+Sufix),Null),true,
                                      Iff(not IsOtlogen,iff(Trim(edNumReestr.Text)='',Null,Trim(edNumReestr.Text)),Null),true,
                                      Null,true,
                                      Trim(cbOperation.Text),true,
                                      Trim(cbFio.text),true,
                                      SummEdit.Value,true,
                                      StrToDate(DateToStr(WorkDate))+Time,true,
                                      UserName,true,
                                      Null,true,
                                      LastOperID,true,
                                      LastTypeReestrID,true,
                                      UserId,true,
                                      Null,true,
                                      Null,true,
                                      tmpName,true,
                                      Null,true,
                                      True,true,
                                      UserId,true,
                                      StrToDate(DateToStr(WorkDate))+Time,true,
                                      UserName,true,
                                      Integer(chbNoYear.Enabled and chbNoYear.Checked),true,
                                      Integer(chbDefect.Enabled and chbDefect.Checked),true,
                                      SummEditPriv.Value,true,
                                      LastNotarialActionId,true,
                                      Trim(cmbMotion.Text),true,
                                      Null,true,
                                      Null,true,
                                      Null,true,
                                      Null,true,
                                      Null,true,
                                      Null,true,
                                      StrToDate(DateToStr(dtpCertificateDate.Date))+Time,true,
                                      whocertificate,true,
                                      whocertificate_id,true,
                                      null,null,null);

         Result:=true;
         fmDocReestr.LastOperID:=LastOperID;
        finally
         tb.Free;
         tr.Free;
{         fmDocReestr.Mainqr.Active:=false;
         fmDocReestr.Mainqr.Active:=true;
         fmDocReestr.Mainqr.locate('reestr_id',fmDocReestr.GetMaxReestrID-1,[loCaseInsensitive]);}

         Screen.Cursor:=crDefault;
        end;
  finally
    if Trim(edNumReestr.Text)<>'' then
      DocumentUnLock(Strtoint(edNumReestr.Text),LastTypeReestrID);
  end;      
end;

procedure TfmNewOperation.bibOkClickUpdate(Sender: TObject);
begin
  if cbCurReestr.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ������.');
   cbCurReestr.SetFocus;
   exit;
  end;
  if cbNumLic.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ��������.');
   cbNumLic.SetFocus;
   exit;
  end;
  if cmbMotion.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ������������ ��������.');
   cmbMotion.SetFocus;
   exit;
  end;
  if Trim(cbFio.Text)='' then begin
   ShowError(Application.Handle,'�������� ��� ������� ������� �.�.');
   cbFio.SetFocus;
   exit;
  end;
  if Trim(cbOperation.Text)='' then begin
   ShowError(Application.Handle,'�������� ��� ������� ��������.');
   cbOperation.SetFocus;
   exit;
  end else begin
   InsertIntoOperations;
  end;

  if isCheckEmptySumm then
    if (Trim(edNumReestr.Text)<>'') and (SummEdit.Value=0.0) then begin
     ShowError(Application.Handle,'����� ��� �������� �� ����� ���� ����� 0.');
     SummEdit.SetFocus;
     exit;
    end;

  IsOtlogen:=false;
  if UpdateReestr then
   Close;
end;

procedure TfmNewOperation.bibCancelClickUpdate(Sender: TObject);
begin
  Close;
end;

procedure TfmNewOperation.bibOtlogenClickUpdate(Sender: TObject);
begin

  IsOtlogen:=true;
  if UpdateReestr then
   Close;
end;

function TfmNewOperation.UpdateReestr: Boolean;
var
  List: TList;
  msOutForm: TMemoryStream;
begin
  Result:=false;
  if Not isInsert then
   if not IsReestrIDFound then begin
    ShowError(Application.Handle,'��� ������ � ������� ���� �������, �������� ������.');
    close;
    exit;
   end;
  if IsInsert then begin
{   if isNumReestrAlready(Strtoint(edNumReestr.Text),LastTypeReestrID) then begin
    ShowError(Application.Handle,'����� � ������� <'+edNumReestr.Text+'> �� ����������.');
    edNumReestr.Text:=inttostr(GetMaxNumReestr(LastTypeReestrID,UserID));
    edNumReestr.SetFocus;
    exit;
   end;}
  end;

   msOutForm:=TMemoryStream.Create;
   List:=TList.Create;
   try
      if not IsOtlogen then begin
         Result:=fUpdate(msOutForm,list);
      end else begin
         Result:=true;
      end;
   finally
    ClearWordObjectList(List);
    List.Free;
    msOutForm.Free;
   end;
end;

procedure TfmNewOperation.FillAllNeedFieldForUpdate(NewNumReestr: Integer;
   newTypeReestrID: Integer; newFio: String; newSumm: Extended; newReestrID: Integer;
   newLicenseID: Integer);
begin
{  if not isInsert then
   edNumReestr.Text:=inttostr(NewNumReestr)
  else edNumReestr.Text:=inttostr(GetMaxNumReestr(LastTypeReestrID,UserID));}
  if not isInsert then
   edNumReestr.Text:=inttostr(NewNumReestr)
  else edNumReestr.Text:='';
  FillTypeReestrComboAndSetIndex(newTypeReestrID);
  FillNotarialActions(true);
  isAreadyFillFio:=false;
//  FillFioCombo;
  FillNumLicenseCombo(newLicenseID);
  cbFio.Text:=Trim(newFio);
  SummEdit.Value:=newSumm;
  FillOpearionComboAndSetLast;

  LastReestrID:=newReestrID;
end;

function TfmNewOperation.IsReestrIDFound: Boolean;
var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   Result:=false;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select reestr_id from '+TableReestr+
         ' where reestr_id='+inttostr(LastReestrID);
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount>0 then
    Result:=true;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

function TfmNewOperation.fUpdate(msOutForm: TMemoryStream; List: TList): Boolean;
  var
    tb: TIBTable;
    plusstr: string;
    tr: TIBTransaction;
    tmpName: string;
    whocertificate_id: Integer;
    whocertificate: string;
begin

        IsOtlogen:=Trim(edNumReestr.Text)='';

        Screen.Cursor:=crHourGlass;
        tr:=TIBTransaction.Create(nil);
        tb:=TIBTable.Create(nil);
        try
         Result:=false;
         tr.AddDatabase(dm.IBDbase);
         dm.IBDbase.AddTransaction(tr);
         tr.Params.Text:=DefaultTransactionParamsTwo;
         tb.Database:=dm.IBDbase;
         tb.Transaction:=tr;
         tb.Transaction.Active:=true;

         tb.TableName:=TableReestr;
         tb.Filter:=' reestr_id='+inttostr(LastReestrID);
         tb.Filtered:=true;

         tb.Active:=true;

         if tb.IsEmpty then exit;

         tb.edit;
         tb.FieldByName('reestr_id').Asinteger:=LastReestrID;

         tb.FieldByName('certificatedate').AsDateTime:=StrToDate(DateToStr(dtpCertificateDate.Date))+Time;
         whocertificate_id:=GetWhoCertificateId(whocertificate);
         tb.FieldByName('whocertificate_id').AsInteger:=whocertificate_id;
         
         tb.FieldByName('oper_id').AsInteger:=LastOperID;
         tb.FieldByName('datein').AsDateTime:=tb.FieldByName('datein').AsDateTime;
         tb.FieldByName('whoin').AsInteger:=tb.FieldByName('whoin').AsInteger;
         tb.FieldByName('datechange').AsDateTime:=StrToDate(DateToStr(WorkDate))+Time;
         tb.FieldByName('whochange').AsInteger:=UserId;
         tb.FieldByName('keepdoc').AsInteger:=0;
         tb.FieldByName('yearwork').AsInteger:=WorkYear;
         tb.FieldByName('typereestr_id').AsInteger:=LastTypeReestrID;

         tb.FieldByName('notarialaction_id').AsInteger:=LastNotarialActionId;
         tb.FieldByName('noyear').AsInteger:=Integer(chbNoYear.Enabled and chbNoYear.Checked);
         tb.FieldByName('defect').AsInteger:=Integer(chbDefect.Enabled and chbDefect.Checked);
         tb.FieldByName('summpriv').AsFloat:=SummEditPriv.Value;

         plusstr:='';
         if not IsOtlogen then begin
          tb.FieldByName('numreestr').AsInteger:=Strtoint(edNumReestr.Text);
          plusstr:=' �� ������� � '+edNumReestr.Text;
         end else begin
          tb.FieldByName('numreestr').Value:=null;
         end;

         tb.FieldByName('fio').AsString:=Trim(cbFio.text);
         tb.FieldByName('summ').AsFloat:=SummEdit.Value;
         if Trim(tb.FieldByName('parent_id').AsString)='' then
          tmpName:=GetOperName(LastOperID)
         else begin
          tmpName:='����� ('+GetOperName(tb.FieldByName('oper_id').AsInteger)+')'+plusstr;
         end;
         tb.FieldByName('tmpname').AsString:=tmpName;
         tb.FieldByName('countuse').AsInteger:=tb.FieldByName('countuse').AsInteger+1;

         tb.Post;
         tb.Transaction.CommitRetaining;

          fmDocReestr.NeedCacheUpdate(false,
                                      LastReestrID,true,
                                      Iff(not IsOtlogen,iff(Trim(edNumReestr.Text)='',Null,Prefix+Trim(edNumReestr.Text)+Sufix),Null),true,
                                      Iff(not IsOtlogen,iff(Trim(edNumReestr.Text)='',Null,Trim(edNumReestr.Text)),Null),true,
                                      Null,true,
                                      Trim(cbOperation.Text),true,
                                      Trim(cbFio.text),true,
                                      SummEdit.Value,true,
                                      Null,false,
                                      Null,false,
                                      Null,true,
                                      LastOperID,true,
                                      LastTypeReestrID,true,
                                      Null,false,
                                      Null,true,
                                      Null,true,
                                      tmpName,true,
                                      Null,true,
                                      True,true,
                                      UserId,true,
                                      StrToDate(DateToStr(WorkDate))+Time,true,
                                      UserName,true,
                                      Integer(chbNoYear.Enabled and chbNoYear.Checked),true,
                                      Integer(chbDefect.Enabled and chbDefect.Checked),true,
                                      SummEditPriv.Value,true,
                                      LastNotarialActionId,true,
                                      Trim(cmbMotion.Text),true,
                                      Null,false,
                                      Null,false,
                                      Null,false,
                                      Null,false,
                                      Null,false,
                                      Null,false,
                                      StrToDate(DateToStr(dtpCertificateDate.Date))+Time,true,
                                      whocertificate,true,
                                      whocertificate_id,true,
                                      null,null,null);


         Result:=true;
        finally
         tb.Free;
         tr.Free;
{         fmDocReestr.Mainqr.Active:=false;
         fmDocReestr.Mainqr.Active:=true;
         fmDocReestr.Mainqr.locate('reestr_id',LastReestrID,[loCaseInsensitive]);
         fmDocReestr.ViewCount;}
         Screen.Cursor:=crDefault;
        end;
end;

procedure TfmNewOperation.InsertIntoOperations;

  function ExistsInComboOperations: Boolean;
  var
    val: Integer;
  begin
    Result:=false;
    val:=cbOperation.Items.IndexOf(cbOperation.Text);
    if Val<>-1 then begin
      Result:=true;
    end;
  end;

var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   if not ExistsInComboOperations then begin
    sqls:='Insert into '+TableOperation+
         ' (name) '+
         ' values ('''+Trim(cbOperation.Text)+''')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.CommitRetaining;
   end;
   qr.SQL.Clear;
   sqls:='Select * from '+TableOperation+
         ' where name='''+Trim(cbOperation.Text)+'''';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount=1 then begin
     LastOperID:=qr.FieldByname('oper_id').AsInteger;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure TfmNewOperation.DestroyHeaderAndCreateNew;

   procedure DestroyHeader;
   var
     i: Integer;
     ct: TControl;
   begin
     if FindComponent('SummEdit')<>nil then begin
       ct:=TControl(FindComponent('SummEdit'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free; 
     end;
     if FindComponent('SummEditPriv')<>nil then begin
       ct:=TControl(FindComponent('SummEditPriv'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('lbNumReestr')<>nil then begin
       ct:=TControl(FindComponent('lbNumReestr'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('edNumReestr')<>nil then begin
       ct:=TControl(FindComponent('edNumReestr'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;
     
     if FindComponent('btNextNumReestr')<>nil then begin
       ct:=TControl(FindComponent('btNextNumReestr'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('pnReminder')<>nil then begin
       ct:=TControl(FindComponent('pnReminder'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('pnMarquee')<>nil then begin
       ct:=TControl(FindComponent('pnMarquee'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;
     
     for i:=grbDoplnit.ControlCount-1 downto 0 do begin
       ct:=grbDoplnit.Controls[i];
       grbDoplnit.RemoveControl(ct);
       ct.Free;
     end;
   end;


   procedure CreateHeader;
   var
     lb: TLabel;
     ed: TEdit;
     se: TRxCalcEdit;
     ch: TCheckBox;
     cb: TComboBox;
     dtp: TDateTimePicker;
     bt: TButton;
     pn: TPanel;
     pnM: TddgMarquee;
   begin
     lb:=TLabel.Create(Self);
     lb.Parent:=pnBottom;
     lb.Anchors:=[akRight, akBottom];
     lb.Name:='lbNumReestr';
     lb.Alignment:=taRightJustify;
     lb.Left:=Panel3.Left-130;
     lb.Width:=46;
     lb.Top:=14;
     lb.Height:=13;
     lb.Caption:='����� � �������:';
     lb.Font.Style:=[fsBold];
     lbNumReestr:=lb;

     ed:=TEdit.Create(Self);
     ed.parent:=pnBottom;
     ed.Anchors:=[akRight, akBottom];
     ed.Name:='edNumReestr';
     ed.ShowHint:=true;
     ed.Hint:='����� � �������';
     ed.MaxLength:=9;
     ed.Left:=lbNumReestr.Left+lbNumReestr.Width+6;
     ed.Width:=62;
     ed.Top:=11;
     ed.Height:=21;
     ed.Text:='';
     ed.TabOrder:=1;
     edNumReestr:=ed;
     edNumReestr.OnKeyPress:=edNumReestrKeyPress;
     edNumReestr.OnChange:=edNumReestrChange;

     bt:=TButton.Create(Self);
     bt.parent:=pnBottom;
     bt.Anchors:=[akRight, akBottom];
     bt.Name:='btNextNumReestr';
     bt.ShowHint:=true;
     bt.Caption:='<-';
     bt.Hint:='��������� ����� � �������';
     bt.Width:=21;
     bt.Left:=edNumReestr.Left+edNumReestr.Width+3;
     bt.Top:=11;
     bt.Height:=21;
     bt.TabOrder:=2;
     btNextNumReestr:=bt;
     btNextNumReestr.OnClick:=btNextNumReestrClick;

     lb:=TLabel.Create(Self);
     lb.Parent:=grbDoplnit;
     lb.Name:='lbSumm';
     lb.Left:=38;
     lb.Width:=47;
     lb.Top:=24;
     lb.Height:=13;
     lb.Caption:='�/�����:';
     lb.Alignment:=taRightJustify;
     lbSumm:=lb;

     se:=TRxCalcEdit.Create(Self);
     se.Parent:=grbDoplnit;
     se.Name:='SummEdit';
     se.Top:=21;
     se.Left:=91;
     se.Width:=77;
     se.ShowHint:=true;
     se.Hint:='����� �����';
     se.TabOrder:=2;
     SummEdit:=se;
     SummEdit.OnChange:=SummEditChange;

     lb:=TLabel.Create(Self);
     lb.Parent:=grbDoplnit;
     lb.Name:='lbSummPriv';
     lb.Left:=177;
     lb.Width:=40;
     lb.Top:=24;
     lb.Height:=13;
     lb.Caption:='�/����:';
     lb.Alignment:=taRightJustify;
     lbSummPriv:=lb;

     se:=TRxCalcEdit.Create(Self);
     se.Parent:=grbDoplnit;
     se.Name:='SummEditPriv';
     se.Top:=21;
     se.Left:=lbSummPriv.Left+lbSummPriv.Width+6;
     se.Width:=77;
     se.ShowHint:=true;
     se.Hint:='����� ����';
     se.TabOrder:=3;
     SummEditPriv:=se;

     ch:=TCheckBox.Create(Self);
     ch.Parent:=grbDoplnit;
     ch.Name:='chbOnSogl';
     ch.Left:=411;
     ch.Width:=65;
     ch.Top:=23;
     ch.Height:=17;
     ch.Caption:='�� ����.';
     ch.ShowHint:=true;
     ch.Hint:='�� ����������';
     ch.TabOrder:=4;
     ch.Visible:=false;
     chbOnSogl:=ch;

     lb:=TLabel.Create(Self);
     lb.Parent:=grbDoplnit;
     lb.Name:='lbCurReestr';
     lb.Left:=44;
     lb.Width:=39;
     lb.Top:=48;
     lb.Height:=13;
     lb.Caption:='������:';
     lbCurReestr:=lb;

     cb:=TComboBox.Create(Self);
     cb.Parent:=grbDoplnit;
     cb.Name:='cbCurReestr';
     cb.ShowHint:=true;
     cb.Hint:='� ����� ������';
     cb.Left:=91;
     cb.Width:=265;
     cb.Top:=45;
     cb.Height:=21;
     cb.Text:='';
     cb.Style:=csDropDownList;
     cb.TabOrder:=5;
     cbCurReestr:=cb;
     cbCurReestr.OnChange:=cbCurReestrChange;

     lb:=TLabel.Create(Self);
     lb.Parent:=grbDoplnit;
     lb.Name:='lbNumLic';
     lb.Left:=363;
     lb.Width:=53;
     lb.Top:=48;
     lb.Height:=13;
     lb.Caption:='��������:';
     lb.Visible:=false;
     lbNumLic:=lb;

     cb:=TComboBox.Create(Self);
     cb.Parent:=grbDoplnit;
     cb.Name:='cbNumLic';
     cb.ShowHint:=true;
     cb.Hint:='����� ��������';
     cb.Left:=lbNumLic.Left+lbNumLic.Width+6;
     cb.Width:=265;
     cb.Top:=45;
     cb.Height:=21;
     cb.Text:='';
     cb.Style:=csDropDownList;
     cb.TabOrder:=6;
     cb.Visible:=false;
     cbNumLic:=cb;
     cbNumLic.OnChange:=cbNumLicChange;

     lb:=TLabel.Create(Self);
     lb.Parent:=grbDoplnit;
     lb.Name:='lbMotion';
     lb.WordWrap:=true;
     lb.Alignment:=taRightJustify;
     lb.Left:=7;
     lb.Width:=76;
     lb.Top:=66;
     lb.Height:=26;
     lb.Caption:='������������ ��������:';
     lbMotion:=lb;

     cb:=TComboBox.Create(Self);
     cb.Parent:=grbDoplnit;
     cb.Name:='cmbMotion';
     cb.Left:=91;
     cb.Width:=265;
     cb.Top:=69;
     cb.Height:=21;
     cb.Text:='';
     cb.Style:=csDropDownList;
     cb.ShowHint:=true;
     cb.DropDownCount:=20;
     cb.TabOrder:=7;
     cmbMotion:=cb;
     cmbMotion.OnChange:=cmbMotionChange;

     ch:=TCheckBox.Create(Self);
     ch.Parent:=grbDoplnit;
     ch.Name:='chbNoYear';
     ch.Left:=363;
     ch.Width:=113;
     ch.Top:=70;
     ch.Height:=17;
     ch.Caption:='�/������';
     ch.ShowHint:=true;
     ch.Hint:=' �������� � ������� �������� ���'+#13+
              '����������������� ��������'+#13+
              '������������������';
     ch.TabOrder:=8;
     chbNoYear:=ch;

     lb:=TLabel.Create(Self);
     lb.Parent:=grbDoplnit;
     lb.Name:='lbFio';
     lb.Left:=7;
     lb.Width:=77;
     lb.Top:=96;
     lb.Height:=13;
     lb.Caption:='������� �.�.:';
     lbFio:=lb;

     cb:=TComboBox.Create(Self);
     cb.Parent:=grbDoplnit;
     cb.ShowHint:=true;
     cb.Hint:='������� ��� ��������';
     cb.Name:='cbFio';
     cb.Left:=91;
     cb.Width:=265;
     cb.Top:=93;
     cb.Height:=21;
     cb.Style:=csDropDown;
     cb.Text:='';
     cb.TabOrder:=9;
     cbFio:=cb;
     cbFio.OnKeyPress:=cbFioKeyPress;
     cbFio.OnDropDown:=cbFioDropDown;

     ch:=TCheckBox.Create(Self);
     ch.Parent:=grbDoplnit;
     ch.Name:='chbDefect';
     ch.Left:=363;
     ch.Width:=113;
     ch.Top:=94;
     ch.Height:=17;
     ch.Caption:='���.����������';
     ch.ShowHint:=true;
     ch.Hint:='  �������� �� �������������� �������'+#13+
              '���������� ��-�� ������� ���������� ����������';
     ch.TabOrder:=10;
     chbDefect:=ch;

     lb:=TLabel.Create(Self);
     lb.Parent:=grbDoplnit;
     lb.Name:='lbOperation';
     lb.Left:=30;
     lb.Width:=53;
     lb.Top:=119;
     lb.Height:=13;
     lb.Caption:='��������:';
     lbOperation:=lb;

     cb:=TComboBox.Create(Self);
     cb.Parent:=grbDoplnit;
     cb.ShowHint:=true;
     cb.Hint:='������� ��������';
     cb.Name:='cbOperation';
     cb.Left:=91;
     cb.Width:=265;
     cb.Top:=116;
     cb.Height:=21;
     cb.Style:=csDropDown;
     cb.Text:='';
     cb.TabOrder:=11;
     cbOperation:=cb;
     cbOperation.OnChange:=cbOperationChange;

     lb:=TLabel.Create(Self);
     lb.Parent:=grbDoplnit;
     lb.Name:='lbCertificateDate';
     lb.WordWrap:=true;
     lb.Alignment:=taRightJustify;
     lb.Left:=363;
     lb.Width:=108;
     lb.Top:=119;
     lb.Height:=13;
     lb.Caption:='���� �������������:';
     lbCertificateDate:=lb;

     dtp:=TDateTimePicker.Create(Self);
     dtp.Parent:=grbDoplnit;
     dtp.Name:='dtpCertificateDate';
     dtp.Left:=485;
     dtp.Width:=94;
     dtp.Top:=115;
     dtp.Height:=21;
     dtp.TabOrder:=14;
     dtp.Hint:='���� ������������� ���������';
     dtp.ShowHint:=true;
     dtpCertificateDate:=dtp;

     pn:=TPanel.Create(Self);
     pn.Parent:=pnBottom;
     pn.Align:=alLeft;
     pn.Width:=Width-400;
     pn.Name:='pnMarquee';
     pn.BevelOuter:=bvNone;
     pn.BorderWidth:=6;
     pn.Caption:='';
     pnMarquee:=pn;

     pnM:=TddgMarquee.Create(Self);
     pnM.Parent:=pnMarquee;
     pnM.Align:=alClient;
     pnM.Justify:=tjLeft;
     pnM.Circle:=true;
     pnM.StopOnLine:=true;
     pnM.TimerInterval:=100;
     pnM.ParentColor:=true;
     pnM.ParentFont:=true;
     pnM.Font.Style:=[fsBold];
     pnM.Font.Color:=clBtnShadow;
     pnM.Name:='pnReminder';
     pnM.Caption:='';
     pnM.Items.Clear;
     pnM.BevelOuter:=bvNone;
     pnM.hint:='������ �����������';
     pnM.Active:=isViewReminder;
     pnReminder:=pnM;

     Constraints.MinHeight:=230;
     Constraints.MinWidth:=640;

   end;

begin
  DestroyHeader;
  CreateHeader;
end;

procedure TfmNewOperation.cmbMotionChange(Sender: TObject);
var
  id: Integer;
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  if cmbMotion.ItemIndex<>-1 then begin
   id:=Integer(Pointer(cmbMotion.Items.Objects[cmbMotion.ItemIndex]));
   LastNotarialActionId:=id;
   Screen.Cursor:=crHourGlass;
   tr:=TIBTransaction.Create(nil);
   qr:=TIBQuery.Create(nil);
   try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select * from '+TableNotarialAction+
         ' where notarialaction_id='+inttostr(id);
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if not qr.isEmpty then begin
     chbNoYear.Enabled:=Boolean(qr.FieldByname('usenoyear').AsInteger);
     chbDefect.Enabled:=Boolean(qr.FieldByname('usedefect').AsInteger);
     cmbMotion.Hint:=qr.FieldByname('hint').AsString;
     if qr.FieldByname('percent').AsString<>'' then
      SummEditPriv.Value:=SummEdit.Value*qr.FieldByname('percent').AsFloat/100;
    end;
   finally
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
   end;
  end;
end;

procedure TfmNewOperation.cbNumLicChange(Sender: TObject);
begin

end;

procedure TfmNewOperation.cbFioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmNewOperation.FillNotarialActions(isUseForUpdate: Boolean);
var
  qr: TIBQuery;
  sqls: string;
  ind: Integer;
  tmpind: Integer;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  cmbMotion.Items.BeginUpdate;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select * from '+TableNotarialAction+' where viewinform=1 order by fieldsort';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   cmbMotion.Clear;
   ind:=0;
   tmpind:=0;
   while not qr.Eof do begin
     if qr.FieldByname('notarialaction_id').AsInteger=LastNotarialActionID then begin
       tmpind:=Ind;
     end;
     inc(ind);
     cmbMotion.Items.AddObject(qr.FieldByname('name').AsString,
                              TObject(Pointer(qr.FieldByname('notarialaction_id').AsInteger)));
     qr.Next;
   end;
  finally
   qr.Free;
   tr.Free;
   cmbMotion.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
  if cmbMotion.Items.Count>0 then begin
    cmbMotion.ItemIndex:=tmpind;
    cmbMotion.OnChange(nil);
  end;
end;

procedure TfmNewOperation.FillNumLicenseCombo(LicenseID: Integer);
var
  qr: TIBQuery;
  sqls: string;
  ind: Integer;
  tmpind: Integer;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  cbNumLic.Items.BeginUpdate;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try

   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select tl.num, tl.license_id from '+TableTypeReestr+' ttr join '+
         TableLicense+' tl on ttr.not_id=tl.not_id '+
         ' where ttr.typereestr_id='+inttostr(LastTypeReestrID);
   qr.SQL.Add(sqls);
   qr.Active:=true;
   cbNumLic.Clear;
   ind:=0;
   tmpind:=0;
   while not qr.Eof do begin
     if qr.FieldByname('license_id').AsInteger=LicenseID then begin
       tmpind:=Ind;
     end;
     inc(ind);
     cbNumLic.Items.AddObject(qr.FieldByname('num').AsString,
                              TObject(Pointer(qr.FieldByname('license_id').AsInteger)));
     qr.Next;
   end;
  finally
   qr.Free;
   tr.Free;
   cbNumLic.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
  if cbNumLic.Items.Count>0 then begin
    cbNumLic.ItemIndex:=tmpind;
  end;
end;

procedure TfmNewOperation.SummEditChange(Sender: TObject);
begin
  SummEditPriv.Value:=SummEdit.Value;
end;

procedure TfmNewOperation.cbFioDropDown(Sender: TObject);
begin
  FillFioCombo;
end;

procedure TfmNewOperation.btNextNumReestrClick(Sender: TObject);
begin
  edNumReestr.Text:=inttostr(GetMaxNumReestr(LastTypeReestrID,UserID));
end;

procedure TfmNewOperation.FillReminders;

   procedure CopyRandom(str1,str2: TStringList);
   var
     list: TList;
     v,val: Integer;
   begin
     list:=TList.Create;
     try
       while str1.Count<>list.Count do begin
         v:=Random(str1.Count);
         val:=List.IndexOf(Pointer(v));
         if val=-1 then begin
           if str2.Count>0 then
             str2.Add('');
           str2.Add(str1.Strings[v]);
           list.Add(Pointer(v));
         end;
       end;
     finally
       list.Free;
     end;
   end;

var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
  CurrPriority: Integer;
  str: TStringList;
begin
   pnReminder.Active:=false;
   Screen.Cursor:=crHourGlass;
   tr:=TIBTransaction.Create(nil);
   qr:=TIBQuery.Create(nil);
   str:=TStringList.Create;
   try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select * from '+TableReminder+' order by priority';
    qr.SQL.Add(sqls);
    qr.Active:=true;
    qr.First;
    CurrPriority:=0;
    while not qr.EOF do begin
      if qr.FieldByname('priority').AsInteger<>CurrPriority then begin
        CopyRandom(str,pnReminder.Items);
        str.Clear;
        str.Add(qr.FieldByname('text').AsString);
      end else begin
        str.Add(qr.FieldByname('text').AsString);
      end;
      CurrPriority:=qr.FieldByname('priority').AsInteger;
      qr.Next;
    end;
    CopyRandom(str,pnReminder.Items);
   finally
    str.Free;
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
    pnReminder.Active:=(Trim(pnReminder.Items.Text)<>'') and isViewReminder;
   end;
end;


procedure TfmNewOperation.FormResize(Sender: TObject);
begin
  pnMarquee.Width:=Width-400;
end;

end.
