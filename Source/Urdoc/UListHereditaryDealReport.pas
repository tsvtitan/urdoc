unit UListHereditaryDealReport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, db, inifiles, IBQuery, 
  ComObj,IBDatabase, Variants;

type
  TfmListHereditaryDeal = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    lbUserName: TLabel;
    edUserName: TEdit;
    lbTypeReestr: TLabel;
    edTypeReestr: TEdit;
    bibTypeReestr: TBitBtn;
    bibUsername: TBitBtn;
    bibClear: TBitBtn;
    lbFromNumber: TLabel;
    edFromNumber: TEdit;
    lbToNumber: TLabel;
    edToNumber: TEdit;
    grbCert: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    dtpCertFrom: TDateTimePicker;
    dtpCertTo: TDateTimePicker;
    bibCert: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure bibOkClick(Sender: TObject);
    procedure edStringKeyPress(Sender: TObject; var Key: Char);
    procedure edSummKeyPress(Sender: TObject; var Key: Char);
    procedure edFioChange(Sender: TObject);
    procedure edUserNameKeyPress(Sender: TObject; var Key: Char);
    procedure bibTypeReestrClick(Sender: TObject);
    procedure bibUsernameClick(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure edTypeReestrKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bibCertClick(Sender: TObject);
  private
    CurNotActId: String;
    isFindCurNotActId: Boolean;
    isFindCurNoYear: Boolean;
    isFindCurDefect: Boolean;
    isFindCountPriv: Boolean;
    isFindTypeReestr,
    isFindCertFrom,isFindCertTo,
    isFindFromNumber,isFindToNumber,
    
    FilterInside: Boolean;

    FindTypeReestr: string;
    FindCertFrom,FindCertTo: TDate;

    function GetFilterString(ForSumm: Boolean): string;
  public
    procedure LoadFilter;
    procedure ReportView;
    procedure SaveFilter;
  end;

var
  fmListHereditaryDeal: TfmListHereditaryDeal;

implementation

uses UMain, UDocTree, UDm, URBOperation, URBTypeReestr, URBUsers, UProgress,
  WordConst;

{var
  NewFm: TfmDocTree;}

{$R *.DFM}

procedure TfmListHereditaryDeal.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;

  dtpCertFrom.Date:=Workdate;
  dtpCertFrom.Time:=StrtoTime('0:00:00');
  dtpCertFrom.Checked:=false;
  dtpCertTo.Date:=Workdate;
  dtpCertTo.Time:=StrtoTime('23:59:59');
  dtpCertTo.Checked:=false;

  LoadFilter;
end;

procedure TfmListHereditaryDeal.bibOkClick(Sender: TObject);
begin
  if Trim(edFromNumber.text)<>'' then
    if not isInteger(Trim(edFromNumber.text)) then begin
      ShowError(Handle,'�������� ������ ���� ����� ������.');
      edFromNumber.SetFocus;
      exit;
    end;
  if Trim(edToNumber.text)<>'' then
    if not isInteger(Trim(edToNumber.text)) then begin
      ShowError(Handle,'�������� ������ ���� ����� ������.');
      edToNumber.SetFocus;
      exit;
    end;  

  if (Trim(edFromNumber.text)<>'')and
     (Trim(edToNumber.text)<>'') then begin
    if StrToInt(Trim(edFromNumber.text))>StrToInt(Trim(edToNumber.text)) then begin
      ShowError(Handle,'����� <� ��������> ������ ���� ������ ������ <��>.');
      edFromNumber.SetFocus;
      exit;
    end;
  end;

  ModalResult:=mrOk;
end;

procedure TfmListHereditaryDeal.edStringKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Char(Key) in ['0'..'9']))and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end;
end;

procedure TfmListHereditaryDeal.edSummKeyPress(Sender: TObject; var Key: Char);
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

procedure TfmListHereditaryDeal.edFioChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmListHereditaryDeal.edUserNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmListHereditaryDeal.bibTypeReestrClick(Sender: TObject);
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

procedure TfmListHereditaryDeal.bibUsernameClick(Sender: TObject);
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

procedure TfmListHereditaryDeal.LoadFilter;
var
  fi: TIniFile;
  oldVal: Boolean;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try

    edTypeReestr.text:=fi.ReadString(ClassName,'TypeReestr',edTypeReestr.text);

    oldVal:=fi.ReadBool(ClassName,'isCertFrom',dtpCertFrom.Checked);
    dtpCertFrom.date:=fi.ReadDate(ClassName,'CertFrom',dtpCertFrom.date);
    dtpCertFrom.Time:=Strtotime('0:00:00');
    dtpCertFrom.Checked:=oldVal;
    oldVal:=fi.ReadBool(ClassName,'isCertTo',dtpCertTo.Checked);
    dtpCertTo.Date:=fi.ReadDate(ClassName,'CertTo',dtpCertTo.Date);
    dtpCertTo.Time:=Strtotime('23:59:59');
    dtpCertTo.Checked:=oldVal;

    edFromNumber.Text:=fi.ReadString(ClassName,'FromNumber',edFromNumber.Text);
    edToNumber.Text:=fi.ReadString(ClassName,'ToNumber',edToNumber.Text);

  finally
   fi.Free;
  end;
end;

procedure TfmListHereditaryDeal.SaveFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try

    fi.WriteString(ClassName,'TypeReestr',edTypeReestr.text);

    fi.WriteBool(ClassName,'isCertFrom',dtpCertFrom.Checked);
    fi.WriteDate(ClassName,'CertFrom',dtpCertFrom.date);
    fi.WriteBool(ClassName,'isCertTo',dtpCertTo.Checked);
    fi.WriteDate(ClassName,'CertTo',dtpCertTo.Date);

    fi.WriteString(ClassName,'FromNumber',edFromNumber.Text);
    fi.WriteString(ClassName,'ToNumber',edToNumber.Text);

  finally
   fi.Free;
  end;
end;

{$WARNINGS OFF}
function TfmListHereditaryDeal.GetFilterString(ForSumm: Boolean): string;
var
  FilInSide: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,
  addstr6,addstr7,addstr8,addstr9,addstr10,addstr11,addstr12,addstr13,addstr14,addstr15,addstr16: string;
  and1,and2,and3,and4,and5,and6,and7,and8,and9,and10,and11,and12,and13,and14,and15: string;
  s: string;
begin
    Result:='';

    FindTypeReestr:=trim(edTypeReestr.Text);
    FindCertFrom:=dtpCertFrom.DateTime;
    FindCertTo:=dtpCertTo.DateTime;

    isFindCurNotActId:=Trim(CurNotActId)<>'';
    isFindTypeReestr:=trim(FindTypeReestr)<>'';
    isFindCertFrom:=dtpCertFrom.Checked;
    isFindCertTo:=dtpCertTo.Checked;
    isFindFromNumber:=(Trim(edFromNumber.text)<>'') and isInteger(Trim(edFromNumber.text));
    isFindToNumber:=(Trim(edToNumber.text)<>'') and isInteger(Trim(edToNumber.text));


    if FilterInside then FilInSide:='%';


      if isFindTypeReestr then begin
        addstr1:=' Upper(tr.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTypeReestr+'%'))+' ';
      end;

      if isFindCurNoYear then begin
         addstr6:=' noyear=1 ';
      end;

      if isFindCurdefect then begin
         addstr7:=' defect=1 ';
      end;

      if isFindCurNotActId then begin
         addstr10:=' r.notarialaction_id='+CurNotActId+' ';
      end;

      if isFindCountPriv then begin
         addstr11:=' r.summpriv<r.summ ';
      end;

      if isFindFromNumber then begin
         addstr13:=' r.numreestr>='+Trim(edFromNumber.text)+' ';
      end;

      if isFindToNumber then begin
         addstr14:=' r.numreestr<='+Trim(edToNumber.text)+' ';
      end;

      if isFindCertFrom then begin
         addstr15:=' r.certificatedate >='''+formatdatetime(fmtDateTime,FindCertFrom)+''' ';
      end;

      if isFindCertTo then begin
         addstr16:=' r.certificatedate <='''+formatdatetime(fmtDateTime,FindCertTo)+''' ';
      end;


      if (isFindTypeReestr and isFindCurNoYear)or
         (isFindTypeReestr and isFindCurdefect)or
         (isFindTypeReestr and isFindCurNotActId)or
         (isFindTypeReestr and isFindCountPriv)or
         (isFindTypeReestr and isFindFromNumber)or
         (isFindTypeReestr and isFindToNumber)or
         (isFindTypeReestr and isFindCertFrom)or
         (isFindTypeReestr and isFindCertTo)
         then
       and1:=' and ';


      if (isFindCurNoYear and isFindCurdefect)or
         (isFindCurNoYear and isFindCurNotActId)or
         (isFindCurNoYear and isFindCountPriv)or
         (isFindCurNoYear and isFindFromNumber)or
         (isFindCurNoYear and isFindToNumber)or
         (isFindCurNoYear and isFindCertFrom)or
         (isFindCurNoYear and isFindCertTo)
         then
       and6:=' and ';

      if (isFindCurdefect and isFindCurNotActId)or
         (isFindCurdefect and isFindCountPriv)or
         (isFindCurdefect and isFindFromNumber)or
         (isFindCurdefect and isFindToNumber)or
         (isFindCurdefect and isFindCertFrom)or
         (isFindCurdefect and isFindCertTo)
         then
       and7:=' and ';

      if (isFindCurNotActId and isFindCountPriv)or
         (isFindCurNotActId and isFindFromNumber)or
         (isFindCurNotActId and isFindToNumber)or
         (isFindCurNotActId and isFindCertFrom)or
         (isFindCurNotActId and isFindCertTo)
         then
       and10:=' and ';

      if (isFindCountPriv and isFindFromNumber)or
         (isFindCountPriv and isFindToNumber)or
         (isFindCountPriv and isFindCertFrom)or
         (isFindCountPriv and isFindCertTo)
         then
       and11:=' and ';

      if (isFindFromNumber and isFindToNumber)or
         (isFindFromNumber and isFindCertFrom)or
         (isFindFromNumber and isFindCertTo)
         then
       and13:=' and ';

      if (isFindToNumber and isFindCertFrom)or
         (isFindToNumber and isFindCertTo)
         then
       and14:=' and ';

      if (isFindCertFrom and isFindCertTo)
         then
       and15:=' and ';

                    s:=addstr1+and1+
                       addstr2+and2+
                       addstr3+and3+
                       addstr4+and4+
                       addstr5+and5+
                       addstr6+and6+
                       addstr7+and7+
                       addstr8+and8+
                       addstr9+and9+
                       addstr10+and10+
                       addstr11+and11+
                       addstr12+and12+
                       addstr13+and13+
                       addstr14+and14+
                       addstr15+and15+
                       addstr16;

      if Trim(s)='' then begin
        s:=' r.numreestr is not null and isdel is null and rtrim(ltrim(Substr(HD.NUMDEAL,1,Strlen(HD.NUMDEAL)-5)))<>'''' ';
      end else begin
        s:=s+' and r.numreestr is not null and isdel is null and rtrim(ltrim(Substr(HD.NUMDEAL,1,Strlen(HD.NUMDEAL)-5)))<>'''' ';
      end;
      if trim(s)<>'' then
        Result:=' where '+s

end;
{$WARNINGS ON}

procedure TfmListHereditaryDeal.ReportView;
var
  W: OleVariant;
  D: OleVariant;

  procedure ViewReport;
  var
    i: Integer;
    List: TList;
    tb,R: OleVariant;
    last: Integer;
    TableW: Integer;
    Counter: Integer;
    NewValue: OleVariant;
    qr: TIbQuery;
    tr: TIbTransaction;
    sqls,filter: string;
    Field: TField;
  begin
    BreakAnyProgress:=false;
    qr:=TIbQuery.Create(nil);
    tr:=TIbTransaction.Create(nil);
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    filter:=GetFilterString(false);
    sqls:='SELECT HD.NUMDEAL||'' ''||HD.FIO, R.CERTIFICATEDATE, R.TMPNAME, HD.NOTE '+
       //   'cast(Substr(HD.NUMDEAL,1,Strlen(HD.NUMDEAL)-5) as integer) '+
          'FROM HEREDITARYDEAL HD '+
          'JOIN REESTR R ON R.HEREDITARYDEAL_ID=HD.HEREDITARYDEAL_ID '+
          'JOIN TYPEREESTR TR ON TR.TYPEREESTR_ID=R.TYPEREESTR_ID '+filter+
          'ORDER BY 2';
    qr.SQL.Add(sqls);
    qr.Open;
    qr.FetchAll;
    fmProgress.gag.Max:=qr.RecordCount;
    SetPositonAndText(0,'','����������',nil,fmProgress.gag.Max);
    D:=W.Documents.Add;
    D.ActiveWindow.View.Zoom.PageFit:=wdPageFitFullPage;
    D.PageSetup.Orientation:=wdOrientLandscape;

    List:=TList.Create;
    try

      for i:=0 to qr.Fields.Count-1 do begin
        if qr.Fields[i].Visible then begin
           List.Add(qr.Fields[i]);
           if i=0 then begin
             qr.Fields[i].DisplayLabel:='�������� ��������������� ����';
             qr.Fields[i].DisplayWidth:=280;
           end;  
           if i=1 then begin
             qr.Fields[i].DisplayLabel:='����';
             qr.Fields[i].DisplayWidth:=70;
           end;
           if i=2 then begin
             qr.Fields[i].DisplayLabel:='��������';
             qr.Fields[i].DisplayWidth:=240;
           end;
           if i=3 then begin
             qr.Fields[i].DisplayLabel:='����������';
             qr.Fields[i].DisplayWidth:=120;
           end;
        end;
      end;  

      last:=1;
      tb:=D.Paragraphs.Item(1).Range.Tables.Add(D.Paragraphs.Item(1).Range,1,1);
      tb.Rows.Borders.InsideLineStyle:= wdLineStyleNone;
      tb.Rows.Borders.OutsideLineStyle:= wdLineStyleNone;

      tb.Cell(last,1).Range.Font.Bold:=true;
      tb.Cell(last,1).Range.Font.Size:=16;
      tb.Cell(last,1).Range.Paragraphs.Alignment:=wdAlignParagraphCenter;
      tb.Cell(last,1).Range.InsertBefore(Self.Caption);

      inc(last);
      tb.Rows.Add;
      tb.Cell(last,1).Borders.OutsideLineStyle:= wdLineStyleSingle;
      tb.Cell(last,1).Borders.OutsideLineWidth:= wdLineWidth025pt;
      tb.Cell(last,1).Range.Font.Bold:=true;
      tb.Cell(last,1).Range.Font.Size:=12;
      tb.Cell(last,1).Range.Paragraphs.Alignment:=wdAlignParagraphCenter;
      tb.Cell(last,1).Split(1,List.Count+1);
      TableW:=0;
      for i:=1 to List.Count do begin
        TableW:=TableW+tb.Cell(last,i).Width;
      end;

      for i:=-1 to List.Count-1 do begin
        if (i=-1) then begin
          tb.Cell(last,i+2).Width:=30;
          tb.Cell(last,i+2).Range.InsertBefore('�');
        end else begin
          Field:=TField(List.Items[i]);
          tb.Cell(last,i+2).Width:=Field.DisplayWidth;
          tb.Cell(last,i+2).Range.InsertBefore(Field.DisplayLabel);
        end;  
      end;

      Counter:=1;
      qr.First;
      while not qr.Eof do begin
        Application.ProcessMessages;
        if BreakAnyProgress then exit;
        inc(last);
        tb.Rows.Add;
        for i:=-1 to List.Count-1 do begin
          if i=-1 then begin
            NewValue:=Counter;
          end else begin
            if i=1 then
              NewValue:=FormatDateTime('dd.mm.yyyy',TField(List.Items[i]).AsDateTime)
            else
              NewValue:=TField(List.Items[i]).Value;
            if i=0 then
              SetPositonAndText(Round(Counter),VarToStrDef(NewValue,''),'�������� �/�: ',
                                nil,fmProgress.gag.Max);
          end;                      
          R:=tb.Cell(last,i+2).Range;
          R.Font.Bold:=false;
          R.Paragraphs.Alignment:=wdAlignParagraphLeft;
          R.InsertBefore(VarToStrDef(NewValue,''));
        end;
        Inc(Counter);
        qr.Next;
      end;

    finally
      tr.Free;
      qr.Free;
      List.Free;
      W.Visible:=true;
      SetPositonAndText(fmProgress.gag.Max,'','��� ������',nil,fmProgress.gag.Max);
      W.Activate;
      W.WindowState:=wdWindowStateMaximize;
    end;  
  end;

  function CreateAndPrepairReport: Boolean;
  begin
   result:=false;
   Screen.Cursor:=crHourGlass;
   try
    try
     VarClear(W);
     W:=CreateOleObject(WordOle);
     ViewReport;
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
   fmProgress.lbProgress.Caption:='����������';
   fmProgress.gag.Position:=0;
   fmProgress.Visible:=true;
   fmProgress.Update;
   Screen.Cursor:=crHourGlass;
   try
    Result:=false;
    try
     W:=GetActiveOleObject(WordOle);
     ViewReport;
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


procedure TfmListHereditaryDeal.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmListHereditaryDeal.edTypeReestrKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edTypeReestr.Text:='';
  end;
end;

procedure TfmListHereditaryDeal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFilter;
end;

procedure TfmListHereditaryDeal.bibCertClick(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=tepYear;
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

end.
