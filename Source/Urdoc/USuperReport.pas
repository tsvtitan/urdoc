unit USuperReport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, db, inifiles, IBQuery, 
  ComObj,IBDatabase;

type
  TfmSuperReport = class(TForm)
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
    chbOnlyPriv: TCheckBox;
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
    isFindTypeReestr,isFindDocName,isFindOperName,
    isFindFio,isFindSumm,
    isFindDateFrom,isFindDateTo,
    isFindDateChangeFrom,isFindDateChangeTo,
    isFindOnlyPriv,
    isFindUserName: Boolean;
    FilterInside: Boolean;
    
    FindTypeReestr,FindDocName,FindOperName: String;
    FindFio,FindSumm: string;
    FindDateChangeFrom,FindDateChangeTo: TDate;
    FindDateFrom,FindDateTo: TDate;
    FindUserName: String;

    
    procedure DocTreeOkClick(Sender: TObject);
    function GetFilterString: string;
  public
    procedure LoadFilter;
    procedure ReportView;
    procedure SaveFilter;
  end;

var
  fmSuperReport: TfmSuperReport;

implementation

uses UMain, UDocTree, UDm, URBOperation, URBTypeReestr, URBUsers, UProgress,
  WordConst;

var
  NewFm: TfmDocTree;
{$R *.DFM}

procedure TfmSuperReport.FormCreate(Sender: TObject);
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

  LoadFilter;
end;

procedure TfmSuperReport.bibOkClick(Sender: TObject);
begin
  
  SaveFilter;
  ModalResult:=mrOk;
end;

procedure TfmSuperReport.bibDocNameClick(Sender: TObject);
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

procedure TfmSuperReport.DocTreeOkClick(Sender: TObject);
begin
  if NewFm=nil then exit;
  if NewFm.LV.SelCount=0 then begin
    ShowError(Application.Handle,DefSelectDocument+'.');
    exit;
  end;
  NewFm.modalResult:=mrOk;
end;

procedure TfmSuperReport.bibOperationClick(Sender: TObject);
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

procedure TfmSuperReport.edStringKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Char(Key) in ['0'..'9']))and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end;
end;

procedure TfmSuperReport.edSummKeyPress(Sender: TObject; var Key: Char);
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

procedure TfmSuperReport.edFioChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmSuperReport.edUserNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmSuperReport.bibTypeReestrClick(Sender: TObject);
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

procedure TfmSuperReport.bibUsernameClick(Sender: TObject);
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

procedure TfmSuperReport.LoadFilter;
var
  fi: TIniFile;
  oldVal: Boolean;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try

    edTypeReestr.text:=fi.ReadString('SuperReport','TypeReestr',edTypeReestr.text);
    edDocName.Text:=fi.ReadString('SuperReport','DocName',edDocName.Text);
    edOperName.text:=fi.ReadString('SuperReport','OperName',edOperName.text);
    edFio.text:=fi.ReadString('SuperReport','Fio',edFio.text);
    edSumm.text:=fi.ReadString('SuperReport','Summ',edSumm.text);

    oldVal:=fi.ReadBool('SuperReport','isDateFrom',dtpDateFrom.Checked);
    dtpDateFrom.date:=fi.ReadDate('SuperReport','DateFrom',dtpDateFrom.date);
    dtpDateFrom.Time:=Strtotime('0:00:00');
    dtpDateFrom.Checked:=oldVal;
    oldVal:=fi.ReadBool('SuperReport','isDateTo',dtpDateTo.Checked);
    dtpDateTo.Date:=fi.ReadDate('SuperReport','DateTo',dtpDateTo.Date);
    dtpDateTo.Time:=Strtotime('23:59:59');
    dtpDateTo.Checked:=oldVal;

    oldVal:=fi.ReadBool('SuperReport','isDateChangeFrom',dtpDateChangeFrom.Checked);
    dtpDateChangeFrom.date:=fi.ReadDate('SuperReport','DateChangeFrom',dtpDateChangeFrom.date);
    dtpDateChangeFrom.Time:=Strtotime('0:00:00');
    dtpDateChangeFrom.Checked:=oldVal;
    oldVal:=fi.ReadBool('SuperReport','isDateChangeTo',dtpDateChangeTo.Checked);
    dtpDateChangeTo.Date:=fi.ReadDate('SuperReport','DateChangeTo',dtpDateChangeTo.Date);
    dtpDateChangeTo.Time:=Strtotime('23:59:59');
    dtpDateChangeTo.Checked:=oldVal;

    edUserName.text:=fi.ReadString('SuperReport','UserName',edUserName.text);
    chbOnlyPriv.Checked:=fi.ReadBool('SuperReport','OnlyPriv',chbOnlyPriv.Checked);

    cbInString.Checked:=fi.ReadBool('SuperReport','Inside',cbInString.Checked);

  finally
   fi.Free;
  end;
end;

procedure TfmSuperReport.SaveFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try

    fi.WriteString('SuperReport','TypeReestr',edTypeReestr.text);

    fi.WriteString('SuperReport','DocName',edDocName.Text);
    fi.WriteString('SuperReport','OperName',edOperName.text);
    fi.WriteString('SuperReport','Fio',edFio.text);
    fi.WriteString('SuperReport','Summ',edSumm.text);

    fi.WriteBool('SuperReport','isDateFrom',dtpDateFrom.Checked);
    fi.WriteDate('SuperReport','DateFrom',dtpDateFrom.date);
    fi.WriteBool('SuperReport','isDateTo',dtpDateTo.Checked);
    fi.WriteDate('SuperReport','DateTo',dtpDateTo.Date);

    fi.WriteBool('SuperReport','isDateChangeFrom',dtpDateChangeFrom.Checked);
    fi.WriteDate('SuperReport','DateChangeFrom',dtpDateChangeFrom.date);
    fi.WriteBool('SuperReport','isDateChangeTo',dtpDateChangeTo.Checked);
    fi.WriteDate('SuperReport','DateChangeTo',dtpDateChangeTo.Date);

    fi.WriteString('SuperReport','UserName',edUserName.text);
    fi.WriteBool('SuperReport','OnlyPriv',chbOnlyPriv.Checked);
    fi.WriteBool('SuperReport','Inside',cbInString.Checked);


  finally
   fi.Free;
  end;
end;

function TfmSuperReport.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,
  addstr6,addstr7,addstr8,addstr9,addstr10,addstr11: string;
  and1,and2,and3,and4,and5,and6,and7,and8,and9,and10: string;
  plusstr: string;
begin
    Result:='';
    Plusstr:='tb.numreestr is not null and isdel is null';

    FindTypeReestr:=trim(edTypeReestr.Text);
    FindDocName:=trim(edDocName.Text);
    FindOperName:=trim(edOperName.Text);
    FindFio:=trim(edFio.Text);
    FindSumm:=trim(edSumm.Text);
    FindUserName:=trim(edUserName.Text);
    FindDateFrom:=dtpDateFrom.DateTime;
    FindDateTo:=dtpDateTo.DateTime;
    FindDateChangeFrom:=dtpDateChangeFrom.DateTime;
    FindDateChangeTo:=dtpDateChangeTo.DateTime;

    isFindTypeReestr:=trim(FindTypeReestr)<>'';
    isFindDocName:=trim(FindDocName)<>'';
    isFindOperName:=trim(FindOperName)<>'';
    isFindFio:=trim(FindFio)<>'';
    isFindSumm:=trim(FindSumm)<>'';
    isFindUserName:=trim(FindUserName)<>'';
    isFindDateFrom:=dtpDateFrom.Checked;
    isFindDateTo:=dtpDateTo.Checked;
    isFindDateChangeFrom:=dtpDateChangeFrom.Checked;
    isFindDateChangeTo:=dtpDateChangeTo.Checked;
    isFindOnlyPriv:=chbOnlyPriv.Checked;

    if isFindTypeReestr or isFindDocName or isFindOperName or isFindFio or isFindUserName or
      isFindSumm or
      isFindDateChangeFrom or isFindDateChangeTo or
      isFindDateFrom or isFindDateTo or isFindUserName or isFindOnlyPriv or 
      (Trim(PlusStr)<>'') then begin
       wherestr:=' where ';
    end;

    if FilterInside then FilInSide:='%';


      if isFindTypeReestr then begin
        addstr1:=' Upper(ttr.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTypeReestr+'%'))+' ';
      end;
      if isFindDocName then begin
        addstr2:=' Upper(td.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindDocName+'%'))+' ';
      end;
      if isFindOperName then begin
        addstr3:=' Upper(tto.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindOperName+'%'))+' ';
      end;
      if isFindFio then begin
        addstr4:=' Upper(fio) like '+AnsiUpperCase(QuotedStr(FilInSide+FindFio+'%'))+' ';
      end;
      if isFindSumm then begin
         addstr5:=' summ ='+FindSumm+' ';
      end;
      if isFindDateFrom then begin
         addstr6:=' tb.datein >='''+formatdatetime(fmtDateTime,FindDateFrom)+''' ';
      end;

      if isFindDateTo then begin
         addstr7:=' tb.datein <='''+formatdatetime(fmtDateTime,FindDateTo)+''' ';
      end;

      if isFindDateChangeFrom then begin
         addstr8:=' tb.datechange >='''+formatdatetime(fmtDateTime,FindDateChangeFrom)+''' ';
      end;

      if isFindDateChangeTo then begin
         addstr9:=' tb.datechange <='''+formatdatetime(fmtDateTime,FindDateChangeTo)+''' ';
      end;
      
      if isFindUserName then begin
        addstr10:=' Upper(tu.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindUserName+'%'))+' ';
      end;

      if isFindOnlyPriv then begin
        addstr11:=' tb.summpriv<tb.summ  ';
      end;


      if (isFindTypeReestr and isFindDocName)or
         (isFindTypeReestr and isFindOperName)or
         (isFindTypeReestr and isFindFio)or
         (isFindTypeReestr and isFindSumm)or
         (isFindTypeReestr and isFindDateFrom)or
         (isFindTypeReestr and isFindDateTo)or
         (isFindTypeReestr and isFindDateChangeFrom)or
         (isFindTypeReestr and isFindDateChangeTo)or
         (isFindTypeReestr and isFindUserName)or
         (isFindTypeReestr and isFindOnlyPriv)then
       and1:=' and ';

      if (isFindDocName and isFindOperName)or
         (isFindDocName and isFindFio)or
         (isFindDocName and isFindSumm)or
         (isFindDocName and isFindDateFrom)or
         (isFindDocName and isFindDateTo)or
         (isFindDocName and isFindDateChangeFrom)or
         (isFindDocName and isFindDateChangeTo)or
         (isFindDocName and isFindUserName)or
         (isFindDocName and isFindOnlyPriv)then
      and2:=' and ';

      if (isFindOperName and isFindFio)or
         (isFindOperName and isFindSumm)or
         (isFindOperName and isFindDateFrom)or
         (isFindOperName and isFindDateTo)or
         (isFindOperName and isFindDateChangeFrom)or
         (isFindOperName and isFindDateChangeTo)or
         (isFindOperName and isFindUserName)or
         (isFindOperName and isFindOnlyPriv)then
      and3:=' and ';

      if (isFindFio and isFindSumm)or
         (isFindFio and isFindDateFrom)or
         (isFindFio and isFindDateTo)or
         (isFindFio and isFindDateChangeFrom)or
         (isFindFio and isFindDateChangeTo)or
         (isFindFio and isFindUserName)or
         (isFindFio and isFindOnlyPriv)then
      and4:=' and ';

      if (isFindSumm and isFindDateFrom)or
         (isFindSumm and isFindDateTo)or
         (isFindSumm and isFindDateChangeFrom)or
         (isFindSumm and isFindDateChangeTo)or
         (isFindSumm and isFindUserName)or
         (isFindSumm and isFindOnlyPriv)
      then and5:=' and ';

      if (isFindDateFrom and isFindDateTo)or
         (isFindDateFrom and isFindDateChangeFrom)or
         (isFindDateFrom and isFindDateChangeTo)or
         (isFindDateFrom and isFindUserName)or
         (isFindDateFrom and isFindOnlyPriv)
      then and6:=' and ';

      if (isFindDateTo and isFindDateChangeFrom)or
         (isFindDateTo and isFindDateChangeTo)or
         (isFindDateTo and isFindUserName)or
         (isFindDateTo and isFindOnlyPriv)
      then and7:=' and ';

      if (isFindDateChangeFrom and isFindDateChangeTo)or
         (isFindDateChangeFrom and isFindUserName)or
         (isFindDateChangeFrom and isFindOnlyPriv)
      then and8:=' and ';

      if (isFindDateChangeTo and isFindUserName)or
         (isFindDateChangeTo and isFindOnlyPriv)
      then and9:=' and ';

      if (isFindUserName and isFindOnlyPriv)
      then and10:=' and ';

      Result:=wherestr+addstr1+and1+
                       addstr2+and2+
                       addstr3+and3+
                       addstr4+and4+
                       addstr5+and5+
                       addstr6+and6+
                       addstr7+and7+
                       addstr8+and8+
                       addstr9+and9+
                       addstr10+and10+
                       addstr11;
      if Result=wherestr then
       Result:=Result+PlusStr
      else
       Result:=Result+' and '+Plusstr;

end;

procedure TfmSuperReport.ReportView;
var
  W: Variant;

  procedure SetParam(D: Variant; Min,Max: Integer);
  var
    tb: Variant;
    incr: Extended;
    last: Integer;
    sqls: String;
//    isCheckedData: Boolean;
//    periodStr: string;
//    MaxDataZak,MinDataZak: TDateTime;
    i: Integer;
    RecCount: Integer;
    MainQr: TIBQuery;
    newValue: Extended;
    SummAll: String;
    SummAllPriv: string;
    tr: TIBTransaction;
 begin

  tr:=TIBTransaction.Create(nil);
  MainQr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    MainQr.Database:=dm.IBDbase;
    MainQr.Transaction:=tr;
    MainQr.Transaction.Active:=true;

    MainQr.Active:=false;
    MainQr.SQL.Clear;
    sqls:='Select Sum(tb.summ) as tbsumm, Sum(tb.summpriv) as tbsummpriv from '+
          TableReestr+' tb left join '+
          TableDoc+' td on tb.doc_id=td.doc_id left join '+
          TableTypeReestr+' ttr on tb.typereestr_id=ttr.typereestr_id left join '+
          TableOperation+' tto on tb.oper_id=tto.oper_id left join '+
          TableUsers+' tu on tb.whoin=tu.user_id '+
          GetFilterString;

    MainQr.SQL.Add(sqls);
    MainQr.Active:=true;
    SummAll:='0';
    SummAllPriv:='0';
    if MainQr.RecordCount>0 then begin
     SummAll:=MainQr.FieldByName('tbsumm').AsString;
     SummAllPriv:=MainQr.FieldByName('tbsummpriv').AsString;
    end;

    MainQr.Active:=false;
    MainQr.SQL.Clear;
    sqls:='Select Max(datein)as maxdatein, Min(datein) as mindatein from '+TableReestr+
          ' where isdel is null ';
    MainQr.SQL.Add(sqls);
    MainQr.Active:=true;
{    MaxDataZak:=MainQr.FieldByName('maxdatein').AsDateTime;
    MinDataZak:=MainQr.FieldByName('mindatein').AsDateTime;}

    MainQr.Active:=false;
    MainQr.SQL.Clear;
    sqls:='Select tb.dataform, tb.reestr_id, ttr.name as ttrname,'+
          ' tb.tmpname as tbtmpname, tb.doc_id as tbdoc_id, '+
          ' ttr.prefix||tb.numreestr||ttr.sufix  as tbnumreestr, tb.fio as tbfio, '+
          ' tb.summ as tbsumm, tb.summpriv as tbsummpriv, tb.datein as tbdatein from '+
          TableReestr+' tb left join '+
          TableDoc+' td on tb.doc_id=td.doc_id left join '+
          TableTypeReestr+' ttr on tb.typereestr_id=ttr.typereestr_id left join '+
          TableOperation+' tto on tb.oper_id=tto.oper_id left join '+
          TableUsers+' tu on tb.whoin=tu.user_id '+
          GetFilterString+
          ' order by ttr.name, tb.numreestr';

    MainQr.SQL.Add(sqls);
    MainQr.Active:=true;
    RecCount:=GetRecordCount(MainQr);
    fmProgress.gag.Max:=Max;
    newValue:=Min;
    incr:=Max/(RecCount+7);

    tb:=D.Paragraphs.Item(1).Range.Tables.Add(D.Paragraphs.Item(1).Range,1,1);
    tb.Rows.Borders.InsideLineStyle:= wdLineStyleNone;
    tb.Rows.Borders.OutsideLineStyle:= wdLineStyleNone;
    tb.Cell(1,1).Range.Font.Bold:=true;
    tb.Cell(1,1).Range.Font.Size:=16;
    tb.Cell(1,1).Range.Paragraphs.Alignment:=wdAlignParagraphCenter;
    tb.Cell(1,1).Range.InsertBefore('Универсальный отчет');
    Application.ProcessMessages;
    if BreakAnyProgress then exit;
    newValue:=newValue+incr;
    SetPositonAndText(Round(newValue),'','Создание заголовка',nil,fmProgress.gag.Max);

//    isCheckedData:=dtpDateFrom.Checked or dtpDateTo.Checked;
{    if isCheckedData then begin
     if dtpDateFrom.Checked and (not dtpDateTo.Checked)then begin
      periodStr:='с: '+formatDateTime(fmtReportPlus,dtpDateFrom.Datetime)+
                 ' по: '+formatDateTime(fmtReportPlus,MaxDataZak);
     end;
     if (not dtpDateFrom.Checked) and (dtpDateTo.Checked)then begin
      periodStr:='с: '+formatDateTime(fmtReportPlus,MinDataZak)+
                 ' по: '+formatDateTime(fmtReportPlus,dtpDateTo.Datetime);
     end;
     if dtpDateFrom.Checked and dtpDateTo.Checked then begin
      periodStr:='с: '+formatDateTime(fmtReportPlus,dtpDateFrom.Datetime)+
                ' по: '+formatDateTime(fmtReportPlus,dtpDateTo.Datetime);
     end;
    end else begin
      periodStr:='с: '+formatDateTime(fmtReportPlus,MinDataZak)+
                 ' по: '+formatDateTime(fmtReportPlus,MaxDataZak);
    end;}


    tb.Rows.Add;
    tb.Cell(2,1).Range.Font.Bold:=false;
    tb.Cell(2,1).Range.Font.Size:=12;
//    tb.Cell(2,1).Range.InsertBefore('за период '+periodStr);
    Application.ProcessMessages;
    if BreakAnyProgress then exit;
    newValue:=newValue+incr;
    SetPositonAndText(Round(newValue),'','Создание заголовка',nil,fmProgress.gag.Max);


    tb.Rows.Add;
    Application.ProcessMessages;
    if BreakAnyProgress then exit;
    newValue:=newValue+incr;
    SetPositonAndText(Round(newValue),'','Создание заголовка',nil,fmProgress.gag.Max);

    Last:=3;
    Last:=Last+1;
    tb.Rows.Add;
    tb.Cell(last,1).Borders.OutsideLineStyle:= wdLineStyleSingle;
    tb.Cell(last,1).Borders.OutsideLineWidth:= wdLineWidth025pt;
    tb.Cell(last,1).Range.Font.Bold:=true;
    tb.Cell(last,1).Range.Font.Size:=12;

    tb.Cell(last,1).Split(1,7);
    tb.Cell(last,1).Range.Paragraphs.Alignment:=wdAlignParagraphCenter;
    tb.Cell(last,1).SetWidth(150,wdAdjustProportional);
    tb.Cell(last,1).Range.InsertBefore('Реестр');
    tb.Cell(last,2).Range.Paragraphs.Alignment:=wdAlignParagraphCenter;
    tb.Cell(last,2).SetWidth(80,wdAdjustProportional);
    tb.Cell(last,2).Range.InsertBefore('Номер по реестру');
    tb.Cell(last,3).Range.Paragraphs.Alignment:=wdAlignParagraphCenter;
    tb.Cell(last,3).SetWidth(150,wdAdjustProportional);
    tb.Cell(last,3).Range.InsertBefore('Документ');
    tb.Cell(last,4).Range.Paragraphs.Alignment:=wdAlignParagraphCenter;
    tb.Cell(last,4).SetWidth(150,wdAdjustProportional);
    tb.Cell(last,4).Range.InsertBefore('Фамилия И.О.');
    tb.Cell(last,5).Range.Paragraphs.Alignment:=wdAlignParagraphCenter;
    tb.Cell(last,5).SetWidth(60,wdAdjustProportional);
    tb.Cell(last,5).Range.InsertBefore('С/норма');
    tb.Cell(last,6).Range.Paragraphs.Alignment:=wdAlignParagraphCenter;
    tb.Cell(last,6).SetWidth(60,wdAdjustProportional);
    tb.Cell(last,6).Range.InsertBefore('С/факт');
    tb.Cell(last,7).Range.Paragraphs.Alignment:=wdAlignParagraphCenter;
    tb.Cell(last,7).SetWidth(85,wdAdjustProportional);
    tb.Cell(last,7).Range.InsertBefore('Дата ввода');

    Application.ProcessMessages;
    if BreakAnyProgress then exit;
    newValue:=newValue+incr;
    SetPositonAndText(Round(newValue),'','Создание заголовка',nil,fmProgress.gag.Max);

    Last:=Last+1;
    tb.Rows.Add;
    tb.Cell(last,1).Range.Font.Bold:=false;
    tb.Cell(last,1).Range.Paragraphs.Alignment:=wdAlignParagraphLeft;
    tb.Cell(last,2).Range.Font.Bold:=false;
    tb.Cell(last,2).Range.Paragraphs.Alignment:=wdAlignParagraphRight;
    tb.Cell(last,3).Range.Font.Bold:=false;
    tb.Cell(last,3).Range.Paragraphs.Alignment:=wdAlignParagraphLeft;
    tb.Cell(last,4).Range.Font.Bold:=false;
    tb.Cell(last,4).Range.Paragraphs.Alignment:=wdAlignParagraphLeft;
    tb.Cell(last,5).Range.Font.Bold:=false;
    tb.Cell(last,5).Range.Paragraphs.Alignment:=wdAlignParagraphRight;
    tb.Cell(last,6).Range.Font.Bold:=false;
    tb.Cell(last,6).Range.Paragraphs.Alignment:=wdAlignParagraphRight;
    tb.Cell(last,7).Range.Font.Bold:=false;
    tb.Cell(last,7).Range.Paragraphs.Alignment:=wdAlignParagraphRight;

    Application.ProcessMessages;
    if BreakAnyProgress then exit;
    newValue:=newValue+incr;
    SetPositonAndText(Round(newValue),'','Создание заголовка',nil,fmProgress.gag.Max);


    Last:=Last+1;
    Mainqr.First;
    i:=0;
    while not Mainqr.Eof do begin
     if i<>0 then
      tb.Rows.Add;

     tb.Cell(Last+i,1).Range.InsertBefore(Trim(Mainqr.FieldByName('ttrname').AsString));
     tb.Cell(Last+i,2).Range.InsertBefore(Mainqr.FieldByName('tbnumreestr').AsString);
     tb.Cell(Last+i,3).Range.InsertBefore(trim(Mainqr.FieldByName('tbtmpname').AsString));
     tb.Cell(Last+i,4).Range.InsertBefore(Trim(Mainqr.FieldByName('tbfio').AsString));
     tb.Cell(Last+i,5).Range.InsertBefore(Mainqr.FieldByName('tbsumm').AsString);
     tb.Cell(Last+i,6).Range.InsertBefore(Mainqr.FieldByName('tbsummpriv').AsString);
     tb.Cell(Last+i,7).Range.InsertBefore(
                     formatDateTime(fmtReport,Mainqr.FieldByName('tbdatein').AsDateTime));
     Application.ProcessMessages;
     if BreakAnyProgress then exit;
     newValue:=newValue+incr;
     SetPositonAndText(Round(newValue),Mainqr.FieldByName('tbnumreestr').AsString,
                                Mainqr.FieldByName('ttrname').AsString+': ',nil,fmProgress.gag.Max);

     Mainqr.Next;
     inc(i);
    end;

    Application.ProcessMessages;
    if BreakAnyProgress then exit;
    newValue:=newValue+incr;
    SetPositonAndText(Round(newValue),'','Подсчет суммы',nil,fmProgress.gag.Max);

    Last:=Last+i+1;
    tb.Rows.Add;
    tb.Cell(last,1).Range.Font.Bold:=true;
    tb.Cell(Last,1).Range.InsertBefore('Всего:');
    tb.Cell(last,5).Range.Font.Bold:=true;
    tb.Cell(Last,5).Range.InsertBefore(SummAll);
    tb.Cell(last,6).Range.Font.Bold:=true;
    tb.Cell(Last,6).Range.InsertBefore(SummAllPriv);


  finally
    MainQr.Free;
  end;
 end;


  function ViewReport: Boolean;
  var
    D: Variant;
  begin
      BreakAnyProgress:=false;
      SetPositonAndText(2,'','Подготовка',nil,fmProgress.gag.Max);
//      W.Visible:=false;
      D:=W.Documents.Add;
      SetPositonAndText(5,'','Подготовка',nil,fmProgress.gag.Max);
      D.ActiveWindow.View.Zoom.Percentage:=60;
      D.PageSetup.Orientation:=wdOrientLandscape;
      SetParam(D,10,100);
      W.Visible:=true;
      SetPositonAndText(100,'','Все готово',nil,fmProgress.gag.Max);
      W.Activate;
      W.WindowState:=wdWindowStateMaximize;
      Result:=true;
  end;

  function CreateAndPrepairReport: Boolean;
  begin
   result:=false;
   Screen.Cursor:=crHourGlass;
   try
    try
     VarClear(W);
     W:=CreateOleObject(WordOle);
     result:=ViewReport;
    except
     on E: Exception do begin
       Application.ShowException(E);
     end;
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
  end;

  function PrepairReport: Boolean;
  begin
   fmProgress.Caption:=CaptionCreateReport;
   fmProgress.lbProgress.Caption:='Подготовка';
   fmProgress.gag.Position:=0;
   fmProgress.Visible:=true;
   fmProgress.Update;
   Screen.Cursor:=crHourGlass;
   try
    try
     W:=GetActiveOleObject(WordOle);
     result:=ViewReport;
    except
     on E: Exception do begin
       if E.Message=MesOperationInaccessible then
        result:=CreateAndPrepairReport
       else if E.Message=MesCallingWasDeclined then
        result:=CreateAndPrepairReport
       else begin
         W.Quit;
         Result:=False;
         Application.ShowException(E);
       end;
     end;
    end;
   finally
    fmProgress.Visible:=false;
    Screen.Cursor:=crDefault;
   end;
  end;

begin
   if not Assigned(fmProgress) then exit;
   PrepairReport;
end;


procedure TfmSuperReport.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmSuperReport.bibDateInClick(Sender: TObject);
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

procedure TfmSuperReport.bibDateChangeClick(Sender: TObject);
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
