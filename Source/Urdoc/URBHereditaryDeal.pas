unit URBHereditaryDeal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  UNewDbGrids, inifiles, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db,IBDatabase, UEditHereditaryDeal, UAdjust, ComObj, ActiveX, 
  FileCtrl, Variants;

type
  TfmHereditaryDeal = class(TForm)
    pnBut: TPanel;
    pnGrid: TPanel;
    ds: TDataSource;
    pnFind: TPanel;
    Label1: TLabel;
    edSearch: TEdit;
    pnBottom: TPanel;
    DBNav: TDBNavigator;
    lbCount: TLabel;
    Mainqr: TIBQuery;
    il: TImageList;
    pnModal: TPanel;
    bibOk: TBitBtn;
    bibClose: TBitBtn;
    bibFilter: TBitBtn;
    pnSQL: TPanel;
    bibAdd: TBitBtn;
    bibChange: TBitBtn;
    bibDel: TBitBtn;
    tran: TIBTransaction;
    bibAdjust: TBitBtn;
    bibBlank: TBitBtn;
    bibExport: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure edSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bibCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MainqrAfterOpen(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure bibAdjustClick(Sender: TObject);
    procedure bibBlankClick(Sender: TObject);
    procedure bibExportClick(Sender: TObject);
  private
    FindFio,FindNumDeal: string;
    isFindFio,isFindNumDeal: Boolean;
    FilterInSide: Boolean;
//    procedure GridTitleClick(Column: TColumn);
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
    procedure GridDblClick(Sender: TObject);
    procedure SetImageFilter;
    procedure SaveFilter;
    procedure ViewCount;
    function GetFilterString: string;
    function HereditaryNameExists(strName: String; date: TDate; var ID: Integer): Boolean;
    procedure GridKeyDown(Sender: TObject; var Key: Word;
                          Shift: TShiftState);
    procedure LoadGridParams;
    procedure SaveGridParams;
    procedure CreateHereditaryDealBlank;
  public
    Grid: TNewdbGrid;
    procedure MR(Sender: TObject);
    procedure ActiveQuery;
    procedure LoadFilter;
  end;

var
  fmHereditaryDeal: TfmHereditaryDeal;
   
implementation

uses Udm, UMain, UUnited, USelectNotarius;

{$R *.DFM}

procedure TfmHereditaryDeal.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
  tran.AddDatabase(dm.IBDbase);
  dm.IBDbase.AddTransaction(tran);
  tran.Params.Text:=DefaultTransactionParamsTwo;
  Mainqr.Transaction:=tran;

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
  Grid.OnTitleClickWithSort:=GridTitleClickWithSort;
//  Grid.OnTitleClick:=GridTitleClick;
  Grid.OnDblClick:=GridDblClick;
  Grid.OnKeyDown:=GridKeyDown;
  Grid.ColumnSortEnabled:=true;

  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
  Mainqr.Database:=dm.IBDbase;

   cl:=Grid.Columns.Add;
   cl.FieldName:='numdeal';
   cl.Title.Caption:='Номер дела';
   cl.Width:=80;

   cl:=Grid.Columns.Add;
   cl.FieldName:='datedeal';
   cl.Title.Caption:='Дата дела';
   cl.Width:=80;

   cl:=Grid.Columns.Add;
   cl.FieldName:='fio';
   cl.Title.Caption:='Фамилия И.О.';
   cl.Width:=200;

   cl:=Grid.Columns.Add;
   cl.FieldName:='deathdate';
   cl.Title.Caption:='Дата смерти';
   cl.Width:=80;

   cl:=Grid.Columns.Add;
   cl.FieldName:='note';
   cl.Title.Caption:='Примечания';
   cl.Width:=150;

  
  LoadGridParams;
end;

procedure TfmHereditaryDeal.ActiveQuery;
var
 sqls: String;
begin
  ds.DataSet:=nil;
  Mainqr.Active:=false;
  Mainqr.sql.Clear;
  sqls:='Select * from '+TableHereditaryDeal+GetFilterString+' order by fio';
  Mainqr.sql.Add(sqls);
  Mainqr.Active:=true;
  ds.DataSet:=Mainqr;
  SetImageFilter;
  ViewCount;
end;

procedure TfmHereditaryDeal.bibAddClick(Sender: TObject);
var
  fm: TfmEditHereditaryDeal;
  qr: TIBQuery;
  RetVal: Boolean;
  valname: string;
  ID: Integer;
  sqls: string;
  tr: TIBTransaction;
  datename: TDateTime;
begin
 fm:=TfmEditHereditaryDeal.Create(nil);
 try
  fm.Caption:=captionAdd;
  fm.bibOk.OnClick:=fm.OkClick;
  if fm.ShowModal=mrOk then begin

    valname:=Trim(fm.edFio.Text);
    datename:=fm.dtpDeathDate.Date;
    retval:=HereditaryNameExists(valname,datename,ID);
    if retVal then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbFio.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('hereditarydeal_id',id,[loCaseInsensitive]);
      exit;
    end;
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
     sqls:='Insert into '+TableHereditaryDeal+' (numdeal,datedeal,fio,deathdate,note) '+
           ' values ('''+Trim(fm.edNumDeal.Text)+
           ''','''+DateToStr(fm.dtpDateDeal.Date)+
           ''','''+valname+
           ''','''+DateToStr(fm.dtpDeathDate.Date)+
           ''','''+Trim(fm.meNote.Lines.text)+
           ''')';
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     if Mainqr.Locate('fio;deathdate',VarArrayOf([valname,StrTodate(DateToStr(datename))]),[loCaseInsensitive]) then begin
       fm.AddFromMemTable(Mainqr.FieldByName('hereditarydeal_id').AsInteger);
     end;
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmHereditaryDeal.bibChangeClick(Sender: TObject);
var
  fm: TfmEditHereditaryDeal;
  RetVal: Boolean;
  valname: string;
  Id: Integer;
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
  datename: TDateTime;
  oldid: string;
begin
 if MainQr.RecordCount=0 then exit;
 fm:=TfmEditHereditaryDeal.Create(nil);
 try
  fm.Caption:=captionChange;
  fm.tsReestr.TabVisible:=true;
  fm.edNumDeal.Text:=Trim(MainQr.FieldByName('numdeal').AsString);
  fm.dtpDateDeal.Date:=MainQr.FieldByName('datedeal').AsDateTime;
  fm.edFio.text:=Trim(MainQr.FieldByName('fio').AsString);
  fm.dtpDeathDate.Date:=MainQr.FieldByName('deathdate').AsDateTime;
  fm.meNote.Lines.Text:=Trim(MainQr.FieldByName('note').AsString);
  fm.ActiveReestr(MainQr.FieldByName('hereditarydeal_id').AsInteger);
  fm.FillDocums(MainQr.FieldByName('hereditarydeal_id').AsInteger);
  fm.bibOk.OnClick:=fm.OkClick;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    if not fm.ChangeFlag then exit;
    valname:=Trim(fm.edFio.Text);
    datename:=fm.dtpDeathDate.Date;
    retval:=HereditaryNameExists(valname,datename,ID);
    oldid:=MainQr.FieldByName('hereditarydeal_id').AsString;
    if (retVal)and(MainQr.FieldByName('hereditarydeal_id').AsInteger<>id) then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbFio.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('hereditarydeal_id',id,[loCaseInsensitive]);
      exit;
    end;
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
     sqls:='Update '+TableHereditaryDeal+
           ' set fio='''+valname+
           ''',datedeal='''+DateToStr(fm.dtpDateDeal.Date)+
           ''',numdeal='''+Trim(fm.edNumDeal.text)+
           ''',deathdate='''+DateToStr(datename)+
           ''',note='''+Trim(fm.meNote.LInes.text)+
           ''' where hereditarydeal_id='+MainQr.FieldByName('hereditarydeal_id').AsString;

     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     if Mainqr.Locate('hereditarydeal_id',oldid,[loCaseInsensitive]) then begin
       fm.AddFromMemTable(Mainqr.FieldByName('hereditarydeal_id').AsInteger);
     end;
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmHereditaryDeal.bibDelClick(Sender: TObject);

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    sqls: string;
    tr: TIBTransaction;
  begin
   Screen.Cursor:=crHourGlass;
   tr:=TIBTransaction.Create(nil);
   qr:=TIBQuery.Create(nil);
   try
    result:=false;
    try

     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+TableHereditaryDeal+' where hereditarydeal_id='+
          Mainqr.FieldByName('hereditarydeal_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Last;
     ViewCount;
     Result:=true;
    except
    end;
   finally
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

var
  mr: TModalResult;  
begin
  if Mainqr.RecordCount=0 then exit;
  mr:=MessageDlg('Удалить ?',mtConfirmation,[mbYes,mbNo],-1);

//  but:=MessageBox(Handle,Pchar('Удалить ?'),'Предупреждение',MB_YESNO+MB_ICONWARNING);
  if mr=mrYes then begin
    if not deleteRecord then begin
      ShowError(Application.Handle,'Дело <'+Mainqr.FieldByName('numdeal').AsString+'> используется.');
    end;
  end;
end;

procedure TfmHereditaryDeal.bibFilterClick(Sender: TObject);
var
  fm: TfmEditHereditaryDeal;
  filstr: string;
begin
 fm:=TfmEditHereditaryDeal.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.dtpDateDeal.Enabled:=false;
  fm.dtpDateDeal.Color:=clBtnFace;
  fm.dtpDeathDate.Enabled:=false;
  fm.dtpDeathDate.Color:=clBtnFace;
  fm.pc.Enabled:=false;
  fm.DisableControl(fm.pc);
  fm.bibOk.OnClick:=fm.filterClick;

  if Trim(FindFio)<>'' then fm.edFio.Text:=FindFio;
  if Trim(FindNumDeal)<>'' then fm.edNumDeal.Text:=FindNumDeal;

  fm.cbInString.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindFio:=Trim(fm.edFio.Text);
    isFindFio:=Trim(FindFio)<>'';
    FindNumDeal:=Trim(fm.edNumDeal.Text);
    isFindNumDeal:=Trim(FindNumDeal)<>'';

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    SaveFilter;
    ActiveQuery;
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmHereditaryDeal.MR(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmHereditaryDeal.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 tmps: string;
begin
  if not isValidKey(Char(Key)) then exit;
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  tmps:=grid.SelectedField.FullName;
  MainQr.Locate(tmps,Trim(edSearch.Text),
                [loPartialKey,loCaseInsensitive]);
end;

procedure TfmHereditaryDeal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfmHereditaryDeal.bibCloseClick(Sender: TObject);
begin
  Close;
end;

{procedure TfmHereditaryDeal.GridTitleClick(Column: TColumn);
var
  fn: string;
  id: integer;
begin
  if not MainQr.Active then exit;
  if MainQr.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('hereditarydeal_id').asInteger;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   MainQr.SQL.Add('Select * from '+TableHereditaryDeal+GetFilterString+' Order by '+fn);
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('hereditarydeal_id',id,[loCaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
end;                        }

procedure TfmHereditaryDeal.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: integer;
  sqls: string;
  OrderStr: string;
begin
  if not MainQr.Active then exit;
  if MainQr.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('hereditarydeal_id').asInteger;
   MainQr.Active:=false;
   sqls:='Select * from '+TableHereditaryDeal+GetFilterString;
   MainQr.SQL.Clear;
   case TypeSort of
     tcsNone: OrderStr:='';
     tcsAsc: OrderStr:=' asc ';
     tcsDesc: OrderStr:=' desc ';
   end;
   MainQr.SQL.Add(sqls+' Order by '+fn+' '+OrderStr);
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('hereditarydeal_id',id,[loCaseInsensitive]);
   ViewCount;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmHereditaryDeal.FormDestroy(Sender: TObject);
begin
  SaveGridParams;
  Grid.Free;
  if fsCreatedMDIChild in FormState then
   fmHereditaryDeal:=nil;
end;

procedure TfmHereditaryDeal.SetImageFilter;
begin
  bibFilter.Glyph.Assign(nil);
  bibFilter.Glyph.Width:=dm.IlMain.Width;
  bibFilter.Glyph.Height:=dm.IlMain.Height;
  if isFindFio or isFindNumDeal then begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,0,true);
  end else begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,1,true);
  end;
end;

procedure TfmHereditaryDeal.LoadFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    FindFio:=fi.ReadString(ClassName,'FIO',FindFio);
    FindNumDeal:=fi.ReadString(ClassName,'NumDeal',FindNumDeal);

    FilterInside:=fi.ReadBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

procedure TfmHereditaryDeal.SaveFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteString(ClassName,'FIO',FindFio);
    fi.WriteString(ClassName,'NumDeal',FindNumDeal);

    fi.WriteBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

function TfmHereditaryDeal.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:='';

    isFindFio:=Trim(FindFio)<>'';
    isFindNumDeal:=Trim(FindNumDeal)<>'';

    if isFindFio or isFindNumDeal then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if (isFindFio)then begin
        addstr1:=' Upper(fio) like '+AnsiUpperCase(QuotedStr(FilInSide+FindFio+'%'))+' ';
     end;

     if (isFindNumDeal)then begin
        addstr2:=' Upper(numdeal) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNumDeal+'%'))+' ';
     end;

     if (isFindFio and isFindNumDeal)then begin
        and1:=' and ';
     end;

     Result:=wherestr+addstr1+and1+
                      addstr2;
end;

procedure TfmHereditaryDeal.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmHereditaryDeal.MainqrAfterOpen(DataSet: TDataSet);
begin
  ViewCount;
end;

procedure TfmHereditaryDeal.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  bibChangeClick(nil);
end;

function TfmHereditaryDeal.HereditaryNameExists(strName: String; date: TDate; var ID: Integer): Boolean;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Result:=false;
  Screen.Cursor:=CrHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select * from '+TableHereditaryDeal+' where fio='''+Trim(strName)+''' and '+
         'deathdate='''+DateToStr(date)+'''';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.recordCount=1 then begin
     ID:=qr.FieldByName('hereditarydeal_id').ASInteger;
     Result:=true;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=CrDefault;
  end;
end;

procedure TfmHereditaryDeal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F2: if pnSQL.Visible then bibAdd.Click;
    VK_F3: if pnSQL.Visible then bibChange.Click;
    VK_F4: if pnSQL.Visible then bibDel.Click;
//    VK_F5: bibRefresh.Click;
    VK_F6: bibFilter.Click;
    VK_UP,VK_DOWN: Grid.SetFocus;
  end;
  fmMain.FormKeyDown(Sender,Key,Shift);
end;

procedure TfmHereditaryDeal.FormResize(Sender: TObject);
begin
  edSearch.Width:=Self.Width-edSearch.Left-pnBut.Width-8;
end;

procedure TfmHereditaryDeal.GridKeyDown(Sender: TObject; var Key: Word;
                                        Shift: TShiftState);
begin
  if not ((Key in [byte('A')..byte('z')])or
     (Key in [byte('А')..byte('я')])or
     (Key in [byte('0')..byte('9')])) then exit;
  edSearch.Text:=String(Char(Key));
  edSearch.SetFocus;
  edSearch.SelStart:=Length(edSearch.Text);
  fmMain.FormKeyDown(Sender,Key,Shift);
end;

procedure TfmHereditaryDeal.LoadGridParams;
var
  fi: TIniFile;
begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  try

    LoadGridProp(ClassName,fi,TDbGrid(grid));

  finally
   fi.Free;
  end;
 except
 end;
end;

procedure TfmHereditaryDeal.SaveGridParams;
var
  fi: TIniFile;
begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  try

    SaveGridProp(ClassName,fi,TDbGrid(grid));

  finally
   fi.Free;
  end;
 except
 end;
end;

procedure TfmHereditaryDeal.bibAdjustClick(Sender: TObject);
begin
  SetAdjustColumns(Grid.Columns);
end;

procedure TfmHereditaryDeal.bibBlankClick(Sender: TObject);
begin
  if MainQr.RecordCount=0 then exit;
  CreateHereditaryDealBlank;
end;

procedure TfmHereditaryDeal.CreateHereditaryDealBlank;
var
  notarius: string;

  procedure ExtractBlank;
  var
    rs: TResourceStream;
    datestr,timestr: string;
    tmps: string;
  begin
    rs:=TResourceStream.Create(HINSTANCE,'BLANK1','REPORT');
    try
      if not DirectoryExists(TempDocFilePath) then
        CreateDir(TempDocFilePath);
      timestr:=FormatDateTime(fmtFileTime,WorkDate);
      datestr:=FormatDateTimeTSV(fmtDateLong,WorkDate);
      tmps:='Бланк наследственного дела'+' ('+timestr+', ' +datestr+').doc';
      lastFileDoc:=GetUniqueFileName(TempDocFilePath+'\'+tmps,0);
      rs.SaveToFile(lastFileDoc);
    finally
      rs.Free;
    end;
  end;

  procedure AddWordField(List: TList;Result,FieldName: string);
  var
    P: PFieldQuote;
  begin
    New(P);
    FillChar(P^,SizeOf(P^),0);
    P.Code:='';
    P.Result:=Result;
    P.FieldName:=FieldName;
    AddToWordObjectList(List,P,wtFieldQuote,'');
  end;

  procedure GetParamsList(List: TList);
  begin
    AddWordField(List,notarius,'ФИО нотариуса');
    AddWordField(List,'г.Красноярск','Город');
    AddWordField(List,Mainqr.FieldByName('numdeal').AsString,'Номер дела');
    AddWordField(List,Mainqr.FieldByName('fio').AsString,'ФИО наследодателя');
    AddWordField(List,AnsiLowerCase(FormatDateTimeTSV(fmtDateLong,Mainqr.FieldByName('deathdate').AsDateTime)),'Дата смерти');
    AddWordField(List,AnsiLowerCase(FormatDateTimeTSV(fmtReportPlus,Mainqr.FieldByName('datedeal').AsDateTime)),'Дата начала');
  end;

var
  List: TList;
  fm: TfmSelectNoarius;
begin
  fm:=TfmSelectNoarius.Create(nil);
  List:=TList.Create;
  try
    fm.FillNotarius(false);
    fm.meInfo.Lines.Text:='Выберите нотариуса для автоматической подписи на бланке наследственного дела';
    if fm.ShowModal=mrOk then begin
      notarius:=fm.GetNotariusName;
      ExtractBlank;
      GetParamsList(List);
      try
       if SetFieldsToWord(List,true,false) then begin

       end;
      finally
        ClearWordObjectList(List);
      end;
    end;
  finally
    List.Free;
    fm.Free;
  end;
end;

procedure TfmHereditaryDeal.bibExportClick(Sender: TObject);
begin
  CreateWordTableByGrid(Grid,Caption);
end;

end.
