unit USearchReestr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, ImgList, Menus, dbtables,db, StdCtrls, Buttons,
  inifiles, DBCtrls, IBCustomDataSet, IBQuery, UNewDbGrids, DBGrids,
  IBTable,IBDatabase;

type

  TfmSearchReestr = class(TForm)
    pnLV: TPanel;
    pmLV: TPopupMenu;
    miAddDoc: TMenuItem;
    miLVDelete: TMenuItem;
    miLVChange: TMenuItem;
    pnGrid: TPanel;
    pnFind: TPanel;
    pnBottom: TPanel;
    lbCount: TLabel;
    DBNav: TDBNavigator;
    ds: TDataSource;
    Mainqr: TIBQuery;
    pncbReestr: TPanel;
    pnFindNew: TPanel;
    Label1: TLabel;
    edSearch: TEdit;
    miLVFilter: TMenuItem;
    bibSCondit: TBitBtn;
    bibClose: TBitBtn;
    bibView: TBitBtn;
    tran: TIBTransaction;
    bibGotoDoc: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MainqrAfterScroll(DataSet: TDataSet);
    procedure bibRefreshClick(Sender: TObject);
    procedure edSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bibCloseClick(Sender: TObject);
    procedure bibSConditClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure bibGotoDocClick(Sender: TObject);
  private
    RecordCount: Integer;
    isFindTypeReestr,isFindDocName,isFindOperName,
    isFindFio,isFindSumm,
    isFindDateFrom,isFindDateTo,
    isFindDateChangeFrom,isFindDateChangeTo,
    isFindUserName: Boolean;

    FindString,FindTypeReestr,FindDocName,FindOperName: String;
    FindFio,FindSumm: string;
    FindDateChangeFrom,FindDateChangeTo: TDate;
    FindDateFrom,FindDateTo: TDate;
    FindUserName: String;

    FilterInside: Boolean;

    CountSearch: Integer;
    procedure GridTitleClick(Column: TColumn);

    function GetFilterString: string;
    procedure SaveFilter;

    procedure GridDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure GridDragOver(Sender, Source: TObject; X, Y: Integer;
              State: TDragState; var Accept: Boolean);
    procedure SearchInReestr;
    procedure DeleteAllSearch;

    procedure ViewReestrFromDefault;
    procedure ViewReestrFromOperation;
    procedure ViewCopyReestr;
  public
    FlagActive: Boolean;
    LastIndex: Integer;
    LastTypeReestrID: Integer;
    LastOperID: Integer;
    Grid: TNewdbGrid;
    procedure LoadFilter;
    function ActiveQuery: Boolean;
    procedure ViewCount;
    procedure ActiveSearch;
  end;

var
  fmSearchReestr: TfmSearchReestr;

implementation

uses UMain, UDM, UHint, UDocTree, UNewForm, USearchReestrEdit, UCaseReestr,
  UProgress, UNewOperation, UEditOperation, UEditSumm, UDocReestr;

{$R *.DFM}

procedure TfmSearchReestr.FormCreate(Sender: TObject);
begin
  tran.AddDatabase(dm.IBDbase);
  dm.IBDbase.AddTransaction(tran);
  tran.Params.Text:=DefaultTransactionParamsTwo;
  Mainqr.Transaction:=tran;

  LastIndex:=0;
//  DeleteMenu(GetSystemMenu(Handle, FALSE), SC_CLOSE, MF_BYCOMMAND);
  Grid:=TNewdbGrid.Create(self);
  Grid.Parent:=pnGrid;
  Grid.Align:=alClient;
  Grid.DataSource:=ds;
   Grid.RowSelected.Visible:=true;
   Grid.RowSelected.Brush.Style:=bsSolid;
   Grid.RowSelected.Brush.Color:=GridRowColor;
   Grid.RowSelected.Font.Color:=clWhite;
   Grid.RowSelected.Pen.Style:=psClear;
   Grid.CellSelected.Visible:=true;
   Grid.CellSelected.Brush.Color:=clHighlight;
   Grid.CellSelected.Font.Color:=clHighlightText;
  Grid.Options:=Grid.Options-[dgEditing]-[dgTabs];
  Grid.ReadOnly:=true;
  Grid.OnTitleClick:=GridTitleClick;
//  Grid.OnDblClick:=GridDblClick;
  Grid.OnKeyDown:=FormKeyDown;
  Grid.OnDragDrop:=GridDragDrop;
  Grid.OnDragOver:=GridDragOver;
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;

  Mainqr.Database:=dm.IBDbase;


  LoadFromIniReestrParams;
end;

procedure TfmSearchReestr.FormDestroy(Sender: TObject);
begin
  Grid.Free;
  fmSearchReestr:=nil;
end;



procedure TfmSearchReestr.GridDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
end;

procedure TfmSearchReestr.GridDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
end;


procedure TfmSearchReestr.SaveFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try

    fi.WriteString('SearchReestr','String',FindString);
    fi.WriteString('SearchReestr','TypeReestr',FindTypeReestr);

    fi.WriteString('SearchReestr','DocName',FindDocName);
    fi.WriteString('SearchReestr','OperName',FindOperName);
    fi.WriteString('SearchReestr','Fio',FindFio);
    fi.WriteString('SearchReestr','Summ',FindSumm);

    fi.WriteBool('SearchReestr','isDateFrom',isFindDateFrom);
    fi.WriteDate('SearchReestr','DateFrom',FindDateFrom);
    fi.WriteBool('SearchReestr','isDateTo',isFindDateTo);
    fi.WriteDate('SearchReestr','DateTo',FindDateTo);

    fi.WriteBool('SearchReestr','isDateChangeFrom',isFindDateChangeFrom);
    fi.WriteDate('SearchReestr','DateChangeFrom',FindDateChangeFrom);
    fi.WriteBool('SearchReestr','isDateChangeTo',isFindDateChangeTo);
    fi.WriteDate('SearchReestr','DateChangeTo',FindDateChangeTo);

    fi.WriteString('SearchReestr','UserName',FindUserName);
    fi.WriteBool('SearchReestr','Inside',FilterInside);


  finally
   fi.Free;
  end;
end;

procedure TfmSearchReestr.LoadFilter;
var
  fi: TIniFile;

begin
  fi:=TIniFile.Create(GetIniFileName);
  try

    FindString:=fi.ReadString('SearchReestr','String',FindString);
    FindTypeReestr:=fi.ReadString('SearchReestr','TypeReestr',FindTypeReestr);
    FindDocName:=fi.ReadString('SearchReestr','DocName',FindDocName);
    FindOperName:=fi.ReadString('SearchReestr','OperName',FindOperName);
    FindFio:=fi.ReadString('SearchReestr','Fio',FindFio);
    FindSumm:=fi.ReadString('SearchReestr','Summ',FindSumm);

    isFindDateFrom:=fi.ReadBool('SearchReestr','isDateFrom',isFindDateFrom);
    FindDateFrom:=fi.ReadDate('SearchReestr','DateFrom',FindDateFrom);
    isFindDateTo:=fi.ReadBool('SearchReestr','isDateTo',isFindDateTo);
    FindDateTo:=fi.ReadDate('SearchReestr','DateTo',FindDateTo);

    isFindDateChangeFrom:=fi.ReadBool('SearchReestr','isDateChangeFrom',isFindDateChangeFrom);
    FindDateChangeFrom:=fi.ReadDate('SearchReestr','DateChangeFrom',FindDateChangeFrom);
    isFindDateChangeTo:=fi.ReadBool('SearchReestr','isDateChangeTo',isFindDateChangeTo);
    FindDateChangeTo:=fi.ReadDate('SearchReestr','DateChangeTo',FindDateChangeTo);

    FindUserName:=fi.ReadString('SearchReestr','UserName',FindUserName);
    FilterInside:=fi.ReadBool('SearchReestr','Inside',FilterInside);

  finally
   fi.Free;
  end;
end;

procedure TfmSearchReestr.GridTitleClick(Column: TColumn);
var
  fn: string;
  id: integer;
  sqls: string;
begin
  if not MainQr.Active then exit;
  if MainQr.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('tdname') then fn:='td.name';
   if UpperCase(fn)=UpperCase('ttoname') then fn:='tto.name';
   if UpperCase(fn)=UpperCase('tuname') then fn:='tu.name';
   if UpperCase(fn)=UpperCase('tu1name') then fn:='tu1.name';
   if UpperCase(fn)=UpperCase('ttrname') then fn:='ttr.name';
   if UpperCase(fn)=UpperCase('numreestr') then fn:='tb.numreestr';
   
   id:=MainQr.fieldByName('search_id').asInteger;
   MainQr.Active:=false;
   sqls:='Select tsr.search_id, tb.reestr_id, ttr.prefix||tb.numreestr||ttr.sufix as numreestr, td.name as tdname, '+
        ' tto.name as ttoname, tb.fio, tb.summ, tb.datein, tu.name as tuname, '+
        ' tb.doc_id, tb.oper_id, tb.typereestr_id, tb.whoin, tb.sogl,'+
        ' tb.license_id, tb.tmpname, tb.parent_id, tb.keepdoc, '+
        ' tb.whochange, tb.datechange, tu1.name as tu1name, tb.summpriv, '+
        ' ttr.name as ttrname from '+
        TableSearchInReestr+' tsr join '+
        TableReestr+' tb on tsr.reestr_id=tb.reestr_id left join '+
        TableDoc+' td on tb.doc_id=td.doc_id left join '+
        TableTypeReestr+' ttr on tb.typereestr_id=ttr.typereestr_id left join '+
        TableOperation+' tto on tb.oper_id=tto.oper_id left join '+
        TableUsers+' tu on tb.whoin=tu.user_id join '+
        TableUsers+' tu1 on tb.whochange=tu1.user_id '+
        ' where suser_id='+inttostr(UserId)+
        ' order by '+fn;
   MainQr.SQL.Clear;
   MainQr.SQL.Add(sqls);
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('search_id',id,[loCaseInsensitive]);
   ViewCount;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

{procedure TfmSearchReestr.GridDblClick(Sender: TObject);
begin
  bibView.Click;
end;}

procedure TfmSearchReestr.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountTextSearch+inttostr(CountSearch);
end;


procedure TfmSearchReestr.MainqrAfterScroll(DataSet: TDataSet);
begin
 // ViewCount;
end;

procedure TfmSearchReestr.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery;
end;

procedure TfmSearchReestr.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not isValidKey(Char(Key)) then exit;
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  MainQr.Locate(grid.SelectedField.FullName,Trim(edSearch.Text),
                [loPartialKey,loCaseInsensitive]);
end;

procedure TfmSearchReestr.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (not (ssAlt in Shift))and(not(ssCtrl in Shift)) then begin
  case Key of
//    VK_F2: bibAdd.Click;
    VK_F3: bibView.Click;
{    VK_F4: bibDel.Click;
    VK_F5: bibRefresh.Click;
    VK_F6: bibFilter.Click;}
  end;
 end;
 fmMain.FormKeyDown(Sender,Key,Shift);
end;

procedure TfmSearchReestr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DeleteAllSearch;
  Action:=caFree;
end;

procedure TfmSearchReestr.bibCloseClick(Sender: TObject);
begin
  Close;
end;

function TfmSearchReestr.ActiveQuery: Boolean;
var
 fm: TfmSearchReestrEdit;
begin
 Result:=false;
 FlagActive:=false;
 fmDocReestr.bibrefresh.Click;
 fm:=TfmSearchReestrEdit.Create(nil);
 try
  fm.Caption:='������� ������ �� �������';
  if Trim(FindString)<>'' then fm.edString.Text:=FindString;
  if Trim(FindTypeReestr)<>'' then fm.edTypeReestr.Text:=FindTypeReestr;
  if Trim(FindDocName)<>'' then fm.edDocName.Text:=FindDocName;
  if Trim(FindOperName)<>'' then fm.edOperName.Text:=FindOperName;
  if Trim(FindFio)<>'' then fm.edFio.Text:=FindFio;
  if Trim(FindSumm)<>'' then fm.edSumm.Text:=FindSumm;

  if isFindDateFrom then begin
   fm.dtpDateFrom.Date:=FindDateFrom;
   fm.dtpDateFrom.Time:=StrToTime('0:00:00');
  end;
  fm.dtpDateFrom.Checked:=isFindDateFrom;
  if isFindDateTo then begin
   fm.dtpDateTo.Date:=FindDateTo;
   fm.dtpDateTo.Time:=StrToTime('23:59:59');
  end;
  fm.dtpDateTo.Checked:=isFindDateTo;

  if isFindDateChangeFrom then begin
   fm.dtpDateChangeFrom.Date:=FindDateChangeFrom;
   fm.dtpDateChangeFrom.Time:=StrToTime('0:00:00');
  end;
  fm.dtpDateChangeFrom.Checked:=isFindDateChangeFrom;
  if isFindDateChangeTo then begin
   fm.dtpDateChangeTo.Date:=FindDateChangeTo;
   fm.dtpDateChangeTo.Time:=StrToTime('23:59:59');
  end;
  fm.dtpDateChangeTo.Checked:=isFindDateChangeTo;

  if FindUserName<>'' then fm.edUserName.Text:=FindUserName;

  fm.cbInString.Checked:=FilterInside;
  
  if fm.ShowModal=mrOk then begin
    Result:=true;
    FlagActive:=true;

    FindString:=Trim(fm.edString.Text);
    FindTypeReestr:=Trim(fm.edTypeReestr.Text);
    FindDocName:=Trim(fm.edDocName.Text);
    FindOperName:=Trim(fm.edOperName.Text);
    FindFio:=Trim(fm.edFio.Text);
    FindSumm:=Trim(fm.edSumm.Text);
    if fm.dtpDateFrom.Checked then begin
     FindDateFrom:=fm.dtpDateFrom.DateTime;
    end;
    isFindDateFrom:=fm.dtpDateFrom.Checked;
    if fm.dtpDateTo.Checked then begin
     FindDateTo:=fm.dtpDateTo.DateTime;
    end;
    isFindDateTo:=fm.dtpDateTo.Checked;

    if fm.dtpDateChangeFrom.Checked then begin
     FindDateChangeFrom:=fm.dtpDateChangeFrom.DateTime;
    end;
    isFindDateChangeFrom:=fm.dtpDateChangeFrom.Checked;
    if fm.dtpDateChangeTo.Checked then begin
     FindDateChangeTo:=fm.dtpDateChangeTo.DateTime;
    end;
    isFindDateChangeTo:=fm.dtpDateChangeTo.Checked;

    FindUserName:=Trim(fm.edUserName.Text);

    FilterInside:=fm.cbInString.Checked;

    SaveFilter;
    DeleteAllSearch;
    SearchInReestr;
    ActiveSearch;
  end;

 finally
  fm.Free;
 end;

end;

procedure TfmSearchReestr.SearchInReestr;

   procedure InsertIntoSearchTable(Reestr_id: Integer);
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
      sqls:='Insert into '+TableSearchInReestr+' (reestr_id,suser_id) '+
            ' values ('+inttostr(Reestr_id)+','+inttostr(UserID)+')';
      qr.SQL.Add(sqls);
      qr.ExecSQL;
      qr.Transaction.CommitRetaining;
     finally
      qr.Free;
      tr.Free;
      Screen.Cursor:=crDefault;
     end;
   end;

var
  qr: TIBQuery;
  sqls: String;
  i,j: Integer;
  tr: TIBTransaction;
  FindWords: TStringList;
  Words: string;
  msWords: TMemoryStream;
  IsFind: Boolean;
begin
  Screen.Cursor:=crHourGlass;
  BreakAnyProgress:=false;
  fmProgress.Caption:='�������: 0';
  fmProgress.lbProgress.Caption:='����������:';
  fmProgress.gag.Position:=0;
  fmProgress.Visible:=true;
  fmProgress.bibBreak.Visible:=true;
  fmProgress.Update;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  FindWords:=TStringList.Create;
  msWords:=TMemoryStream.Create;
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select tb.reestr_id, ttr.name as ttrname,'+
        ' tb.tmpname as tbtmpname, tb.doc_id as tbdoc_id, tb.words from '+
        TableReestr+' tb left join '+
        TableDoc+' td on tb.doc_id=td.doc_id left join '+
        TableTypeReestr+' ttr on tb.typereestr_id=ttr.typereestr_id left join '+
        TableOperation+' tto on tb.oper_id=tto.oper_id left join '+
        TableUsers+' tu on tb.whoin=tu.user_id '+
        GetFilterString;
   qr.SQL.Add(sqls);
   qr.Active:=true;

   fmProgress.gag.Max:=GetRecordCount(qr);
   fmProgress.gag.Position:=0;

   i:=0;
   CountSearch:=0;
   IsFind:=false;
   qr.First;
   FindString:=AnsiUpperCase(TrimCharForOne(' ',Trim(FindString)));
   GetStringsByString(FindString,' ',FindWords);
   while not qr.Eof do begin
     application.ProcessMessages;
     if BreakAnyProgress then exit;
     inc(i);
     SetPositonAndText(i+1,qr.FieldByname('tbtmpname').AsString,
                           qr.FieldByname('ttrname').AsString+': ',nil,fmProgress.gag.Max);

     msWords.Clear;                           
     TBlobField(qr.FieldByName('words')).SaveToStream(msWords);
     msWords.Position:=0;
     ExtractObjectFromStream(msWords);
     msWords.Position:=0;
     SetLength(Words,msWords.Size);
     msWords.Read(Pointer(Words)^,msWords.Size);
     Words:=AnsiUpperCase(Words);

     if FindWords.Count>0 then begin
       for j:=0 to FindWords.Count-1 do begin
         if AnsiPos(FindWords.Strings[j],Words)>0 then begin
           isFind:=true;
         end else begin
           isFind:=false;
           break;
         end;
       end;
     end else
       IsFind:=true;

     if IsFind then begin
       InsertIntoSearchTable(qr.FieldByname('reestr_id').AsInteger);
       inc(CountSearch);
     end;

     fmProgress.Caption:='�������: '+inttostr(CountSearch);

     qr.Next;
   end;
  finally
   msWords.Free;
   FindWords.Free;
   qr.Free;
   tr.Free;
   fmProgress.Visible:=false;
   Screen.Cursor:=crDefault;
  end;
end;

procedure TfmSearchReestr.bibSConditClick(Sender: TObject);
begin
  fmSearchReestr.LoadFilter;
  fmSearchReestr.ActiveQuery;
end;

procedure TfmSearchReestr.ActiveSearch;
var
  sqls: string;
  cl: TColumn;
begin
  Screen.Cursor:=crHourGlass;
  try
   ds.DataSet:=nil;
   Mainqr.Active:=false;
   sqls:='Select tsr.search_id, tb.reestr_id, ttr.prefix||tb.numreestr||ttr.sufix as numreestr, td.name as tdname, '+
        ' tto.name as ttoname, tb.fio, tb.summ, tb.datein, tu.name as tuname, '+
        ' tb.doc_id, tb.oper_id, tb.typereestr_id, tb.whoin, tb.sogl,'+
        ' tb.license_id, tb.tmpname, tb.parent_id, tb.keepdoc, '+
        ' tb.whochange, tb.datechange, tu1.name as tu1name, tb.summpriv, '+
        ' ttr.name as ttrname  from '+
        TableSearchInReestr+' tsr join '+
        TableReestr+' tb on tsr.reestr_id=tb.reestr_id left join '+
        TableDoc+' td on tb.doc_id=td.doc_id left join '+
        TableTypeReestr+' ttr on tb.typereestr_id=ttr.typereestr_id left join '+
        TableOperation+' tto on tb.oper_id=tto.oper_id left join '+
        TableUsers+' tu on tb.whoin=tu.user_id join '+
        TableUsers+' tu1 on tb.whochange=tu1.user_id '+
        ' where suser_id='+inttostr(UserId)+
        ' order by tb.numreestr';
   Mainqr.Sql.Clear;
   Mainqr.Sql.Add(sqls);
   Mainqr.Active:=true;
   RecordCount:=GetRecordCount(Mainqr);
   ds.DataSet:=Mainqr;
   ViewCount;
   if Grid.Columns.Count<>10 then begin

    cl:=Grid.Columns.Add;
    cl.FieldName:='ttrname';
    cl.Title.Caption:='������';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='numreestr';
    cl.Title.Caption:='����� �';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='tmpname';
    cl.Title.Caption:='��������';
    cl.Width:=300;

 {   cl:=Grid.Columns.Add;
    cl.FieldName:='ttoname';
    cl.Title.Caption:='��������';
    cl.Width:=100;}

    cl:=Grid.Columns.Add;
    cl.FieldName:='fio';
    cl.Title.Caption:='������� �.�.';
    cl.Width:=230;

    cl:=Grid.Columns.Add;
    cl.FieldName:='summ';
    cl.Title.Caption:='�/�����';
    cl.Width:=80;

    cl:=Grid.Columns.Add;
    cl.FieldName:='summpriv';
    cl.Title.Caption:='�/����';
    cl.Width:=80;
    
    cl:=Grid.Columns.Add;
    cl.FieldName:='datein';
    cl.Title.Caption:='���� �����';
    cl.Width:=110;

    cl:=Grid.Columns.Add;
    cl.FieldName:='datechange';
    cl.Title.Caption:='���� ���������';
    cl.Width:=110;

    cl:=Grid.Columns.Add;
    cl.FieldName:='tuname';
    cl.Title.Caption:='��� ����';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='tu1name';
    cl.Title.Caption:='��� �������';
    cl.Width:=100;

   end;
  finally
   Screen.Cursor:=crDefault;
  end;
end;

procedure TfmSearchReestr.DeleteAllSearch;
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
    sqls:='Delete from '+TableSearchInReestr+
          ' where suser_id='+inttostr(UserId);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.CommitRetaining;
  finally
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmSearchReestr.ViewReestrFromDefault;
var
  msOutForm: TMemoryStream;
  fmNew: TfmNewForm;
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
  Error: Boolean;
begin
     fmNew:=TfmNewForm.Create(nil);
     tr:=TIBTransaction.Create(nil);
     msOutForm:=TMemoryStream.Create;
     qr:=TIBQuery.Create(nil);
     try
      Screen.Cursor:=crHourGlass;
      try
       tr.AddDatabase(dm.IBDbase);
       dm.IBDbase.AddTransaction(tr);
       tr.Params.Text:=DefaultTransactionParamsTwo;
       qr.Database:=dm.IBDbase;
       qr.Transaction:=tr;
       qr.Transaction.Active:=true;
       sqls:='Select * from '+TableReestr+' where reestr_id='+Mainqr.FieldByname('reestr_id').AsString;
       qr.SQL.Add(sqls);
       qr.Active:=true;
       TBlobField(qr.fieldByName('dataform')).SaveToStream(msOutForm);
       msOutForm.Position:=0;
       ExtractObjectFromStream(msOutForm);
       msOutForm.Position:=0;
       FreeAllComponents(fmNew);
       Error:=false;
       LoadControlFromStream(fmNew,msOutForm,Error);
       if not Error then begin

         fmNew.OnKeyDown:=fmMain.OnKeyDown;
         fmNew.OnKeyPress:=fmMain.OnKeyPress;
         fmNew.OnKeyUp:=fmMain.OnKeyUp;
         fmNew.ViewType:=vtEdit;
         fmNew.ViewType:=vtView;
         fmNew.Caption:=CaptionView+' �������� <'+
                        Trim(Mainqr.FieldByname('tdname').AsString)+'>';
         fmNew.bibOk.OnClick:=fmNew.bibOkClickUpdate;
         fmNew.bibCancel.OnClick:=fmNew.bibCancelClickUpdate;
         fmNew.bibOtlogen.OnClick:=fmNew.bibOtlogenClickUpdate;
         fmNew.bibOtlogen.Enabled:=true;
         fmNew.isCreateReestr:=true;
         fmNew.LastTypeReestrID:=fmDocReestr.LastTypeReestrID;
         fmNew.LastDocId:=Mainqr.FieldByname('doc_id').AsInteger;
         fmNew.isInsert:=Trim(Mainqr.FieldByname('numreestr').AsString)='';
         fmNew.chbOnSogl.Checked:=Mainqr.FieldByname('sogl').AsInteger<>0;
         fmNew.isKeepDoc:=Mainqr.FieldByname('keepdoc').AsInteger<>0;
         fmNew.FillAllNeedFieldForUpdate(Mainqr.FieldByname('numreestr').AsInteger,
                                         Mainqr.FieldByname('typereestr_id').AsInteger,
                                         Mainqr.FieldByname('fio').AsString,
                                         Mainqr.FieldByname('summ').AsFloat,
                                         Mainqr.FieldByname('reestr_id').AsInteger,
                                         Mainqr.FieldByname('license_id').AsInteger,
                                         Mainqr.FieldByname('blank_id').Value,
                                         Mainqr.FieldByname('blank_num').DisplayText);
         fmNew.FillReminders;
         fmNew.bibOk.Enabled:=false;
         fmNew.bibOtlogen.Enabled:=false;
         fmNew.FormStyle:=fsMDIChild;
       end;
      finally
       Screen.Cursor:=crDefault;
      end;
    finally
     msOutForm.Free;
     qr.Free;
     tr.Free;
    end;
end;

procedure TfmSearchReestr.ViewReestrFromOperation;
var
  fm: TfmNewOperation;
begin
  fm:=TfmNewOperation.Create(Application);
  fm.LastTypeReestrID:=LastTypeReestrID;
  fm.LastOperID:=LastOperID;
  fm.Caption:=CaptionView+' �������� <'+
                      Trim(Mainqr.FieldByname('ttoname').AsString)+'>';
  fm.bibOk.OnClick:=fm.bibOkClickUpdate;
  fm.bibCancel.OnClick:=fm.bibCancelClickUpdate;
  fm.bibOtlogen.OnClick:=fm.bibOtlogenClickUpdate;
  fm.bibOtlogen.Enabled:=false;

  fm.isInsert:=Trim(Mainqr.FieldByname('numreestr').AsString)='';
  fm.LastOperID:=Mainqr.FieldByname('oper_id').AsInteger;
  fm.FillAllNeedFieldForUpdate(Mainqr.FieldByname('numreestr').AsInteger,
                               Mainqr.FieldByname('typereestr_id').AsInteger,
                               Mainqr.FieldByname('fio').AsString,
                               Mainqr.FieldByname('summ').AsFloat,
                               Mainqr.FieldByname('reestr_id').AsInteger,
                               Mainqr.FieldByname('license_id').AsInteger);
  fm.FillReminders;                               
  fm.bibOk.Enabled:=false;
  fm.FormStyle:=fsMDIChild;

end;

procedure TfmSearchReestr.bibViewClick(Sender: TObject);
var
  CaseDoc: Boolean;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then begin
    ShowError(Application.Handle,'�������� ������ �������.');
    exit;
  end;
  if Trim(Mainqr.FieldByName('parent_id').AsString)='' then begin
   CaseDoc:=Trim(Mainqr.FieldByName('doc_id').AsString)<>'';
   if CaseDoc then begin
    ViewReestrFromDefault;
   end else begin
    ViewReestrFromOperation;
   end;
  end else begin
    ViewCopyReestr;
  end;
end;

procedure TfmSearchReestr.ViewCopyReestr;
var
 fm: TfmEditSumm;
// lastReestrId: Integer;
// sqls: string;
begin
 fm:=TfmEditSumm.Create(nil);
 try
  fm.Caption:=CaptionView+' �����';
  fm.SummEdit.Value:=MainQr.fieldByName('summ').AsFloat;
  fm.bibOk.Enabled:=false;

  if fm.ShowModal=mrOk then begin

{   lastReestrId:=MainQr.fieldByName('reestr_id').AsInteger;
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   try
    qr.Database:=dm.IBDbase;
    qr.Transaction.Active:=true;
    sqls:='Update '+TableReestr+
          ' set summ='+ChangeDecimalSeparator(fm.SummEdit.text,'.')+
          ' where reestr_id='+inttostr(LastReestrID);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.CommitRetaining;
    ActiveQuery;
    Mainqr.Locate('reestr_id',lastReestrId,[loCaseInsensitive]);
   finally
    qr.Free;
    Screen.Cursor:=crDefault;
   end;
{
    Mainqr.Locate('numreestr;user_id',
                  VarArrayOf([lastnumreestr,lastuserid]),[loCaseInsensitive]);}
  end;
 finally
  fm.Free;
 end;

end;

procedure TfmSearchReestr.FormResize(Sender: TObject);
begin
  edSearch.Width:=Self.Width-edSearch.Left-pncbReestr.Width-10;
end;

function TfmSearchReestr.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,
  addstr6,addstr7,addstr8,addstr9,addstr10: string;
  and1,and2,and3,and4,and5,and6,and7,and8,and9: string;
  Plusstr: string;
begin
    Result:='';
    Plusstr:='tb.isdel is null';

    isFindTypeReestr:=trim(FindTypeReestr)<>'';
    isFindDocName:=trim(FindDocName)<>'';
    isFindOperName:=trim(FindOperName)<>'';
    isFindFio:=trim(FindFio)<>'';
    isFindSumm:=trim(FindSumm)<>'';
    isFindUserName:=trim(FindUserName)<>'';


    if isFindTypeReestr or isFindDocName or isFindOperName or isFindFio or isFindUserName or
      isFindSumm or
      isFindDateChangeFrom or isFindDateChangeTo or
      isFindDateFrom or isFindDateTo or isFindUserName or 
      (Trim(PlusStr)<>'')then begin
       wherestr:=' where ';
    end;

    if FilterInside then FilInSide:='%';

      if isFindTypeReestr then begin
        addstr1:=' Upper(ttr.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTypeReestr+'%'))+' ';
      end;
      if isFindDocName then begin
        addstr2:=' Upper(tb.tmpname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindDocName+'%'))+' ';
      end;
      if isFindOperName then begin
        addstr3:=' Upper(tb.tmpname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindOperName+'%'))+' ';
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


      if (isFindTypeReestr and isFindDocName)or
         (isFindTypeReestr and isFindOperName)or
         (isFindTypeReestr and isFindFio)or
         (isFindTypeReestr and isFindSumm)or
         (isFindTypeReestr and isFindDateFrom)or
         (isFindTypeReestr and isFindDateTo)or
         (isFindTypeReestr and isFindDateChangeFrom)or
         (isFindTypeReestr and isFindDateChangeTo)or
         (isFindTypeReestr and isFindUserName)then
       and1:=' and ';

      if (isFindDocName and isFindOperName)or
         (isFindDocName and isFindFio)or
         (isFindDocName and isFindSumm)or
         (isFindDocName and isFindDateFrom)or
         (isFindDocName and isFindDateTo)or
         (isFindDocName and isFindDateChangeFrom)or
         (isFindDocName and isFindDateChangeTo)or
         (isFindDocName and isFindUserName)then
      and2:=' and ';

      if (isFindOperName and isFindFio)or
         (isFindOperName and isFindSumm)or
         (isFindOperName and isFindDateFrom)or
         (isFindOperName and isFindDateTo)or
         (isFindOperName and isFindDateChangeFrom)or
         (isFindOperName and isFindDateChangeTo)or
         (isFindOperName and isFindUserName)then
      and3:=' and ';

      if (isFindFio and isFindSumm)or
         (isFindFio and isFindDateFrom)or
         (isFindFio and isFindDateTo)or
         (isFindFio and isFindDateChangeFrom)or
         (isFindFio and isFindDateChangeTo)or
         (isFindFio and isFindUserName)then
      and4:=' and ';

      if (isFindSumm and isFindDateFrom)or
         (isFindSumm and isFindDateTo)or
         (isFindSumm and isFindDateChangeFrom)or
         (isFindSumm and isFindDateChangeTo)or
         (isFindSumm and isFindUserName)
      then and5:=' and ';

      if (isFindDateFrom and isFindDateTo)or
         (isFindDateFrom and isFindDateChangeFrom)or
         (isFindDateFrom and isFindDateChangeTo)or
         (isFindDateFrom and isFindUserName)
      then and6:=' and ';

      if (isFindDateTo and isFindDateChangeFrom)or
         (isFindDateTo and isFindDateChangeTo)or
         (isFindDateTo and isFindUserName)
      then and7:=' and ';

      if (isFindDateChangeFrom and isFindDateChangeTo)or
         (isFindDateChangeFrom and isFindUserName)
      then and8:=' and ';

      if (isFindDateChangeTo and isFindUserName)
      then and9:=' and ';

      Result:=wherestr+addstr1+and1+
                       addstr2+and2+
                       addstr3+and3+
                       addstr4+and4+
                       addstr5+and5+
                       addstr6+and6+
                       addstr7+and7+
                       addstr8+and8+
                       addstr9+and9+
                       addstr10;

      if Result=wherestr then
       Result:=Result+PlusStr
      else
       Result:=Result+' and '+Plusstr;
end;


procedure TfmSearchReestr.bibGotoDocClick(Sender: TObject);
begin
  if not Mainqr.Active and
     Mainqr.IsEmpty then begin
    ShowError(Handle,DefSearchReestr);
    exit; 
  end;
  if fmDocReestr<>nil then begin
    fmDocReestr.SetCondition(Mainqr);
  end;
end;

end.

