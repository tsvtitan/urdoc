unit USearchNumInReestr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, IBQuery,IBDatabase, ComCtrls;

type
  TfmSearchNumInReestr = class(TForm)
    pnBottom: TPanel;
    bibClose: TBitBtn;
    pnTop: TPanel;
    lbTypeReestr: TLabel;
    cbTypeReestr: TComboBox;
    bibSearch: TBitBtn;
    pnMemo: TPanel;
    mmSearch: TMemo;
    lbCount: TLabel;
    lbDateAccept: TLabel;
    dtpDateFrom: TDateTimePicker;
    lbDateTo: TLabel;
    dtpDateTo: TDateTimePicker;
    bibPeriod: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bibCloseClick(Sender: TObject);
    procedure bibSearchClick(Sender: TObject);
    procedure cbTypeReestrChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibPeriodClick(Sender: TObject);
  private
    LastTypeReestrID: Integer;
    procedure FillTypeReestrComboAndSetIndex(Index: Integer);
  public
    procedure ActiveQuery;
  end;

var
  fmSearchNumInReestr: TfmSearchNumInReestr;

implementation

uses UDm, UDocReestr, DateUtils;

{$R *.DFM}

procedure TfmSearchNumInReestr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  fmSearchNumInReestr:=nil;
  Action:=caFree;
end;

procedure TfmSearchNumInReestr.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmSearchNumInReestr.FillTypeReestrComboAndSetIndex(Index: Integer);
var
  qr: TIBQuery;
  sqls: string;
  namestr: string;
  typeresstr_id: Integer;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  cbTypeReestr.Items.BeginUpdate;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select typereestr_id,name from '+TableTypeReestr+' order by name';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   cbTypeReestr.Clear;
   qr.First;
   while not qr.Eof do begin
     namestr:=Trim(qr.FieldByName('name').AsString);
     typeresstr_id:=qr.FieldByName('typereestr_id').AsInteger;
     cbTypeReestr.Items.AddObject(namestr,TObject(Pointer(typeresstr_id)));
     qr.Next;
   end;
  finally
   qr.Free;
   tr.Free;
   cbTypeReestr.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
  if cbTypeReestr.Items.Count>0 then begin
     cbTypeReestr.ItemIndex:=Index;
     LastTypeReestrID:=
       Integer(Pointer(TObject(cbTypeReestr.Items.Objects[cbTypeReestr.ItemIndex])));
  end;
end;

procedure TfmSearchNumInReestr.ActiveQuery;
begin
   FillTypeReestrComboAndSetIndex(0);
   if Assigned(fmDocReestr) then
     if cbTypeReestr.Items.Count>0 then begin
       cbTypeReestr.ItemIndex:=fmDocReestr.cbCurReestr.ItemIndex;
       cbTypeReestrChange(nil);
     end;
  // bibSearchClick(nil);
end;

procedure TfmSearchNumInReestr.bibSearchClick(Sender: TObject);
var
  qr: TIBQuery;
  sqls: string;
  val: Integer;
  valold: Integer;
  i: Integer;
  tr: TIBTransaction;
  incValue: Integer;
  addstr1, addstr2: string;
  and1, and2: string;
begin
  if cbTypeReestr.ItemIndex=-1 then exit;
  incValue:=0;
  Screen.Cursor:=crHourGlass;
  mmSearch.Lines.BeginUpdate;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;

   if dtpDateFrom.Checked then
     addstr1:=' CERTIFICATEDATE>='+QuotedStr(DateToStr(dtpDateFrom.Date))+' ';

   if dtpDateTo.Checked then
     addstr2:=' CERTIFICATEDATE<'+QuotedStr(DateToStr(IncDay(dtpDateTo.Date)))+' ';

   if (dtpDateFrom.Checked and dtpDateTo.Checked) then
     and2:=' and ';

   if (dtpDateFrom.Checked or dtpDateTo.Checked) then
     and1:=' and ';

   sqls:='Select numreestr from '+TableReestr+
         ' where typereestr_id='+inttostr(LastTypeReestrID)+
         ' and isdel is null'+and1+addstr1+and2+addstr2+
         ' order by numreestr';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   mmSearch.Clear;
   qr.First;
   ValOld:=Maxint;
   incValue:=0;
   while not qr.Eof do begin
     if incValue>2000 then break;
     val:=qr.FieldByName('numreestr').AsInteger;
     if Val-ValOld>1 then begin
       for i:=0 to Val-ValOld-2 do begin
         mmSearch.Lines.Add(inttostr(ValOld+i+1));
         inc(incValue);
       end;  
     end;
     valold:=val;
     qr.Next;
   end;
  finally
   qr.Free;
   tr.Free;
   mmSearch.Lines.EndUpdate;
   lbCount.Caption:=ViewCountTextSearch+inttostr(mmSearch.Lines.Count);
   Screen.Cursor:=crDefault;
   if incValue>2000 then
     ShowInfo('Слишком много пропущенных номером.');
  end;
end;

procedure TfmSearchNumInReestr.cbTypeReestrChange(Sender: TObject);
begin
  if cbTypeReestr.ItemIndex<>-1 then
   LastTypeReestrID:=Integer(Pointer(TObject(cbTypeReestr.Items.Objects[cbTypeReestr.ItemIndex])));
end;

procedure TfmSearchNumInReestr.FormCreate(Sender: TObject);
begin
  dtpDateFrom.Date:=StrToDate('01.01.'+IntTostr(YearOf(WorkDate)));
  dtpDateFrom.Checked:=true;
  dtpDateTo.Date:=StrToDate('31.12.'+IntTostr(YearOf(WorkDate)));
  dtpDateTo.Checked:=true;
end;

procedure TfmSearchNumInReestr.bibPeriodClick(Sender: TObject);
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

end.
