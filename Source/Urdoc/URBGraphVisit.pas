unit URBGraphVisit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  UEditGraphVisit, UNewDbGrids, inifiles, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db,IBDatabase, Variants;

type
  TfmGraphVisit = class(TForm)
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
    pnModal: TPanel;
    bibOk: TBitBtn;
    bibClose: TBitBtn;
    bibFilter: TBitBtn;
    pnSQL: TPanel;
    bibAdd: TBitBtn;
    bibChange: TBitBtn;
    bibDel: TBitBtn;
    tran: TIBTransaction;
    bibPrint: TBitBtn;
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
    procedure bibPrintClick(Sender: TObject);
  private
    isFindWho,isFindHint,isFindDateAccept,isFindDateTo: Boolean;
    FindWho,FindHint: String;
    FindDateAccept,FindDateTo: TDateTime;
    FilterInSide: Boolean;
    procedure GridTitleClick(Column: TColumn);
    procedure GridDblClick(Sender: TObject);
    procedure SetImageFilter;
    procedure SaveFilter;
    procedure ViewCount;
    function GetFilterString: string;
  public
    Grid: TNewdbGrid;
    procedure MR(Sender: TObject);
    procedure ActiveQuery;
    procedure LoadFilter;
  end;

var
  fmGraphVisit: TfmGraphVisit;

implementation

uses Udm, UMain, DateUtils;

{$R *.DFM}

procedure TfmGraphVisit.FormCreate(Sender: TObject);
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
  Grid.OnTitleClick:=GridTitleClick;
//  Grid.OnDrawColumnCell:=GridDrawColumnCell;
  Grid.OnDblClick:=GridDblClick;
  Grid.OnKeyDown:=FormKeyDown;

  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
  Mainqr.Database:=dm.IBDbase;

  FindDateAccept:=DateOf(WorkDate);
  FindDateTo:=DateOf(WorkDate);
  isFindDateAccept:=true;
  isFindDateTo:=true;
end;

procedure TfmGraphVisit.ActiveQuery;
var
 sqls: String;
 cl: TColumn;
begin
  ds.DataSet:=nil;
  Mainqr.Active:=false;
  Mainqr.sql.Clear;
  sqls:='Select * from '+TableGraphVisit+' '+
        GetFilterString+' order by dateaccept';
  Mainqr.sql.Add(sqls);
  Mainqr.Active:=true;
  ds.DataSet:=Mainqr;
  SetImageFilter;
  ViewCount;
   if Grid.Columns.Count<>4 then begin
    cl:=Grid.Columns.Add;
    cl.FieldName:='dateaccept';
    cl.Title.Caption:='Дата и время принятия';
    cl.Width:=105;

    cl:=Grid.Columns.Add;
    cl.FieldName:='who';
    cl.Title.Caption:='Клиент';
    cl.Width:=150;

    cl:=Grid.Columns.Add;
    cl.FieldName:='hint';
    cl.Title.Caption:='Описание';
    cl.Width:=170;

    cl:=Grid.Columns.Add;
    cl.FieldName:='dateservice';
    cl.Title.Caption:='Дата и время обслуживания';
    cl.Width:=60;

  end;
end;

procedure TfmGraphVisit.bibAddClick(Sender: TObject);
var
  fm: TfmEditGraphVisit;
  qr: TIbQuery;
  sqls: string;
  tr: TIBTransaction;
  DateAccept: TDateTime;
  id: string;
begin
 fm:=TfmEditGraphVisit.Create(nil);
 try
  fm.Caption:=captionAdd;
  fm.btOk.OnClick:=fm.OkClick;
  if fm.ShowModal=mrOk then begin

    Screen.Cursor:=crHourGlass;
    tr:=TIBTransaction.Create(nil);
    qr:=TIbQuery.Create(nil);
    try
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;

     DateAccept:=fm.dtpDateAccept.Date;
     ReplaceTime(DateAccept,fm.dtpTimeAccept.Time);
     id:=IntToStr(GetGenId(TableGraphVisit,1));

     sqls:='Insert into '+TableGraphVisit+' (graphvisit_id,dateaccept,who,hint,dateservice) '+
           ' values ('+Id+','+QuotedStr(DateTimeToStr(DateAccept))+
           ','+QuotedStr(fm.edWho.Text)+','+QuotedStr(fm.meHint.Lines.Text)+
           ','+iff(fm.chbService.Checked,QuotedStr(DateTimeToStr(Now)),'null')+')';
     qr.SQL.Add(sqls);
     qr.ExecSQL;

     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('graphvisit_id',VarArrayOf([Id]),[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmGraphVisit.bibChangeClick(Sender: TObject);
var
  fm: TfmEditGraphVisit;
  Id: string;
  qr: TIbQuery;
  sqls: string;
  tr: TIBTransaction;
  DateAccept: TDateTime;
begin
 if MainQr.RecordCount=0 then exit;
 fm:=TfmEditGraphVisit.Create(nil);
 try
  fm.Caption:=captionChange;
  id:=MainQr.FieldByName('graphvisit_id').AsString;
  DateAccept:=MainQr.FieldByName('dateaccept').AsDateTime;
  fm.dtpDateAccept.Date:=DateOf(DateAccept);
  fm.dtpTimeAccept.Time:=TimeOf(DateAccept);
  fm.edWho.text:=Trim(MainQr.FieldByName('who').AsString);
  fm.meHint.Lines.Text:=Trim(MainQr.FieldByName('hint').AsString);
  if not VarIsNull(MainQr.FieldByName('dateservice').Value) then begin
    fm.DateService:=MainQr.FieldByName('dateservice').AsDateTime;
    fm.chbService.Checked:=true;
  end else fm.DateService:=Now;

  fm.btOk.OnClick:=fm.OkClick;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    DateAccept:=DateOf(fm.dtpDateAccept.Date)+TimeOf(fm.dtpTimeAccept.Time);

    Screen.Cursor:=crHourGlass;
    tr:=TIBTransaction.Create(nil);
    qr:=TIbQuery.Create(nil);
    try
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Update '+TableGraphVisit+' set '+
           ' dateaccept='+QuotedStr(DateTimeToStr(DateAccept))+
           ',who='+QuotedStr(fm.edWho.Text)+
           ',hint='+QuotedStr(fm.meHint.Lines.Text)+
           ',dateservice='+iff(fm.chbService.Checked,QuotedStr(DateTimeToStr(fm.DateService)),'null')+
           ' where graphvisit_id='+id;
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('graphvisit_id',VarArrayOf([Id]),[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmGraphVisit.bibDelClick(Sender: TObject);

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
     sqls:='Delete from '+TableGraphVisit+' where graphvisit_id='+
          Mainqr.FieldByName('graphvisit_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
     Result:=true;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Last;
     ViewCount;
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
  mr:=MessageDlg('Удалить текущую запись?',mtConfirmation,[mbYes,mbNo],-1);
  if mr=mrYes then begin
    if not deleteRecord then begin
//      ShowError(Application.Handle,'График посещений <'+Mainqr.FieldByName('name').AsString+'> используется.');
    end;
  end;
end;

procedure TfmGraphVisit.bibFilterClick(Sender: TObject);
var
  fm: TfmEditGraphVisit;
  filstr: string;
begin
 fm:=TfmEditGraphVisit.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.dtpDateAccept.ShowCheckbox:=true;
  fm.lbDateAccept.Caption:='Дата с:';
  fm.dtpDateTo.ShowCheckbox:=true;
  fm.bibPeriod.Visible:=true;

  fm.lbTime.Visible:=false;
  fm.dtpTimeAccept.Visible:=false;

  fm.chbService.Enabled:=false;
  fm.btOk.OnClick:=fm.filterClick;

  fm.lbDateTo.Visible:=true;
  fm.dtpDateTo.Visible:=true;

  if isFindDateAccept then
    fm.dtpDateAccept.Date:=FindDateAccept
  else begin
    fm.dtpDateAccept.Date:=DateOf(WorkDate);
    fm.dtpDateAccept.Checked:=false;
  end;

  if isFindDateTo then
    fm.dtpDateTo.Date:=FindDateTo
  else begin
    fm.dtpDateTo.Date:=DateOf(WorkDate);
    fm.dtpDateTo.Checked:=false;
  end;

  if Trim(FindWho)<>'' then fm.edWho.Text:=FindWho;
  if Trim(FindHint)<>'' then fm.meHint.Lines.Text:=FindHint;

  fm.cbInString.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindDateAccept:=fm.dtpDateAccept.Date;
    isFindDateAccept:=fm.dtpDateAccept.Checked;

    FindDateTo:=fm.dtpDateTo.Date;
    isFindDateTo:=fm.dtpDateTo.Checked;

    FindWho:=Trim(fm.edWho.Text);
    isFindWho:=Trim(FindWho)<>'';

    FindHint:=Trim(fm.meHint.Lines.Text);
    isFindHint:=Trim(FindHint)<>'';

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

procedure TfmGraphVisit.MR(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmGraphVisit.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not isValidKey(Char(Key)) then exit;
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  MainQr.Locate(grid.SelectedField.FullName,Trim(edSearch.Text),
                [loPartialKey,loCaseInsensitive]);
end;

procedure TfmGraphVisit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfmGraphVisit.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmGraphVisit.GridTitleClick(Column: TColumn);
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
   id:=MainQr.fieldByName('graphvisit_id').asInteger;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   sqls:='Select * from '+TableGraphVisit+' '+
         GetFilterString+' order by '+fn;
   MainQr.SQL.Add(sqls);
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('graphvisit_id',id,[loCaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmGraphVisit.FormDestroy(Sender: TObject);
begin
  Grid.Free;
  if fsCreatedMDIChild in FormState then
   fmGraphVisit:=nil;
end;

procedure TfmGraphVisit.SetImageFilter;
begin
  bibFilter.Glyph.Assign(nil);
  bibFilter.Glyph.Width:=dm.IlMain.Width;
  bibFilter.Glyph.Height:=dm.IlMain.Height;
  if isFindWho or isFindHint or isFindDateAccept or isFindDateTo then begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,0,true);
  end else begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,1,true);
  end;
end;

procedure TfmGraphVisit.LoadFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    FindWho:=fi.ReadString(ClassName,'Who',FindWho);
    FindHint:=fi.ReadString(ClassName,'Hint',FindHint);
//    FindDateAccept:=fi.ReadDate(ClassName,'DateAccept',FindDateAccept);
//    isFindDateAccept:=fi.ReadBool(ClassName,'isDateAccept',isFindDateAccept);
    FilterInside:=fi.ReadBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

procedure TfmGraphVisit.SaveFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteString(ClassName,'Who',FindWho);
    fi.WriteString(ClassName,'Hint',FindHint);
//    fi.WriteDate(ClassName,'DateAccept',FindDateAccept);
//    fi.WriteBool(ClassName,'isDateAccept',isFindDateAccept);
    fi.WriteBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

procedure TfmGraphVisit.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmGraphVisit.MainqrAfterOpen(DataSet: TDataSet);
begin
  ViewCount;
end;

procedure TfmGraphVisit.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  bibChangeClick(nil);
end;

procedure TfmGraphVisit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F2: if pnSQL.Visible then bibAdd.Click;
    VK_F3: if pnSQL.Visible then bibChange.Click;
    VK_F4: if pnSQL.Visible then bibDel.Click;
//    VK_F5: bibRefresh.Click;
    VK_F6: bibFilter.Click;
  end;
  fmMain.FormKeyDown(Sender,Key,Shift);
end;

function TfmGraphVisit.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4: string;
  and1,and2,and3: string;
begin
    Result:='';

    isFindWho:=Trim(FindWho)<>'';
    isFindHint:=Trim(FindHint)<>'';
    isFindDateAccept:=isFindDateAccept;
    isFindDateTo:=isFindDateTo;

    if isFindWho or isFindHint or isFindDateAccept or isFindDateTo then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindWho then begin
        addstr1:=' Upper(who) like '+AnsiUpperCase(QuotedStr(FilInSide+FindWho+'%'))+' ';
     end;

     if isFindHint then begin
        addstr2:=' Upper(hint) like '+AnsiUpperCase(QuotedStr(FilInSide+FindHint+'%'))+' ';
     end;

     if isFindDateAccept then begin
        addstr3:=' dateaccept>='+QuotedStr(DateToStr(FindDateAccept))+' ';
     end;

     if isFindDateTo then begin
        addstr4:=' dateaccept<'+QuotedStr(DateToStr(IncDay(FindDateTo)))+' ';
     end;

     if (isFindWho and isFindHint)or
        (isFindWho and isFindDateAccept)or
        (isFindWho and isFindDateTo) then
      and1:=' and ';

     if (isFindHint and isFindDateAccept) or
        (isFindHint and isFindDateTo)then
      and2:=' and ';

     if (isFindDateAccept and isFindDateTo) then
      and3:=' and ';

      Result:=wherestr+addstr1+and1+
                       addstr2+and2+
                       addstr3+and3+
                       addstr4;

end;

procedure TfmGraphVisit.FormResize(Sender: TObject);
begin
  edSearch.Width:=Self.Width-edSearch.Left-pnBut.Width-8;
end;

procedure TfmGraphVisit.bibPrintClick(Sender: TObject);
begin
  CreateWordTableByGrid(Grid,Caption);
end;

end.
