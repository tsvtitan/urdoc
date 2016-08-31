unit URBRenovation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  UEditRenovation, UNewDbGrids, inifiles, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db,IBDatabase, Variants;

type
  TfmRenovation = class(TForm)
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
    isFindName: Boolean;
    FindName: String;
    FilterInSide: Boolean;
    procedure GridTitleClick(Column: TColumn);
    procedure GridDblClick(Sender: TObject);
    procedure SetImageFilter;
    procedure SaveFilter;
    procedure ViewCount;
    function GetFilterString: string;
    function NameExists(strName: String; var ID: Integer): Boolean;
  public
    Grid: TNewdbGrid;
    procedure MR(Sender: TObject);
    procedure ActiveQuery;
    procedure LoadFilter;
  end;

var
  fmRenovation: TfmRenovation;
   
implementation

uses Udm, UMain;

{$R *.DFM}

procedure TfmRenovation.FormCreate(Sender: TObject);
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
end;

procedure TfmRenovation.ActiveQuery;
var
 sqls: String;
 cl: TColumn;
begin
  ds.DataSet:=nil;
  Mainqr.Active:=false;
  Mainqr.sql.Clear;
  sqls:='Select * from '+TableRenovation+' '+
        GetFilterString+' order by name';
  Mainqr.sql.Add(sqls);
  Mainqr.Active:=true;
  ds.DataSet:=Mainqr;
  SetImageFilter;
  ViewCount;
   if Grid.Columns.Count<>3 then begin
    cl:=Grid.Columns.Add;
    cl.FieldName:='name';
    cl.Title.Caption:='Наименование';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='indate';
    cl.Title.Caption:='Дата';
    cl.Width:=90;

    cl:=Grid.Columns.Add;
    cl.FieldName:='text';
    cl.Title.Caption:='Текст';
    cl.Width:=220;

  end;
end;

procedure TfmRenovation.bibAddClick(Sender: TObject);
var
  fm: TfmEditRenovation;
  RetVal: Boolean;
  valname: string;
  ID: Integer;
  qr: TIbQuery;
  sqls: string;
  tr: TIBTransaction;
begin
 fm:=TfmEditRenovation.Create(nil);
 try
  fm.Caption:=captionAdd;
  fm.dtpINDate.ShowCheckbox:=false;
  fm.btOk.OnClick:=fm.OkClick;
  if fm.ShowModal=mrOk then begin

    valname:=Trim(fm.edName.Text);
    retval:=NameExists(valname,ID);
    if retVal then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbName.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('renovation_id',id,[loCaseInsensitive]);
      exit;
    end;
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
     sqls:='Insert into '+TableRenovation+' (name,indate,text) '+
           ' values ('+QuotedStr(trim(fm.edName.Text))+
           ','''+DateToStr(fm.dtpInDate.Date)+
           ''','+QuotedStr(fm.meText.Lines.Text)+')';
     qr.SQL.Add(sqls);
     qr.ExecSQL;


     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('name;indate',VarArrayOf([valname,fm.dtpInDate.Date]),[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmRenovation.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRenovation;
  RetVal: Boolean;
  valname: string;
  Id: Integer;
  qr: TIbQuery;
  sqls: string;
  tr: TIBTransaction;
begin
 if MainQr.RecordCount=0 then exit;
 fm:=TfmEditRenovation.Create(nil);
 try
  fm.Caption:=captionChange;
  fm.dtpinDate.ShowCheckbox:=false;
  fm.edName.text:=Trim(MainQr.FieldByName('name').AsString);
  fm.dtpInDate.date:=MainQr.FieldByName('indate').AsDateTime;
  fm.meText.Lines.text:=MainQr.FieldByName('text').AsString;

  fm.btOk.OnClick:=fm.OkClick;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    if not fm.ChangeFlag then exit;
    valname:=Trim(fm.edName.Text);
    retval:=NameExists(valname,Id);
    if (retVal)and(MainQr.FieldByName('renovation_id').AsInteger<>id) then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbName.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('renovation_id',id,[loCaseInsensitive]);
      exit;
    end;
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
     sqls:='Update '+TableRenovation+' set '+
           'name='+QuotedStr(trim(fm.edName.Text))+
           ',indate='''+DateToStr(fm.dtpInDate.Date)+
           ''',text='+QuotedStr(fm.meText.Lines.Text)+
           ' where renovation_id='+Mainqr.FieldByName('renovation_id').AsString;
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('name;indate',VarArrayOf([valname,fm.dtpInDate.Date]),[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmRenovation.bibDelClick(Sender: TObject);

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
     sqls:='Delete from '+TableRenovation+' where renovation_id='+
          Mainqr.FieldByName('renovation_id').asString;
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
  mr:=MessageDlg('Удалить ?',mtConfirmation,[mbYes,mbNo],-1);
  if mr=mrYes then begin
    if not deleteRecord then begin
      ShowError(Application.Handle,'Обновление <'+Mainqr.FieldByName('name').AsString+'> используется.');
    end;
  end;
end;

procedure TfmRenovation.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRenovation;
  filstr: string;
begin
 fm:=TfmEditRenovation.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.dtpInDate.Enabled:=false;
  fm.lbInDate.Enabled:=false;
  fm.meText.Enabled:=false;
  fm.meText.Color:=clBtnFace;
  fm.lbText.Enabled:=false;
  fm.btOk.OnClick:=fm.filterClick;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;

  fm.cbInString.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindName:=Trim(fm.edName.Text);
    isFindName:=Trim(FindName)<>'';

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

procedure TfmRenovation.bibPrintClick(Sender: TObject);
begin
  CreateWordTableByGrid(Grid,Caption);
end;

procedure TfmRenovation.MR(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmRenovation.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not isValidKey(Char(Key)) then exit;
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  MainQr.Locate(grid.SelectedField.FullName,Trim(edSearch.Text),
                [loPartialKey,loCaseInsensitive]);
end;

procedure TfmRenovation.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfmRenovation.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmRenovation.GridTitleClick(Column: TColumn);
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
   id:=MainQr.fieldByName('renovation_id').asInteger;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   sqls:='Select * from '+TableRenovation+
        ' '+GetFilterString+' order by '+fn;
   MainQr.SQL.Add(sqls);
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('renovation_id',id,[loCaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmRenovation.FormDestroy(Sender: TObject);
begin
  Grid.Free;
  if fsCreatedMDIChild in FormState then
   fmRenovation:=nil;
end;

procedure TfmRenovation.SetImageFilter;
begin
  bibFilter.Glyph.Assign(nil);
  bibFilter.Glyph.Width:=dm.IlMain.Width;
  bibFilter.Glyph.Height:=dm.IlMain.Height;
  if isFindName then begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,0,true);
  end else begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,1,true);
  end;
end;

procedure TfmRenovation.LoadFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    FindName:=fi.ReadString(ClassName,'Name',FindName);
    FilterInside:=fi.ReadBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

procedure TfmRenovation.SaveFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteString(ClassName,'Name',FindName);
    fi.WriteBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

procedure TfmRenovation.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmRenovation.MainqrAfterOpen(DataSet: TDataSet);
begin
  ViewCount;
end;

procedure TfmRenovation.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  bibChangeClick(nil);
end;

function TfmRenovation.NameExists(strName: String; var ID: Integer): Boolean;
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
   sqls:='Select * from '+TableRenovation+' where name='+QuotedStr(Trim(strName));
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.recordCount=1 then begin
     ID:=qr.FieldByName('renovation_id').ASInteger;
     Result:=true;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=CrDefault;
  end;
end;

procedure TfmRenovation.FormKeyDown(Sender: TObject; var Key: Word;
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

function TfmRenovation.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1: string;
begin
    Result:='';

    isFindName:=Trim(FindName)<>'';

    if isFindName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

    if isFindName then begin
      addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
    end;

    Result:=wherestr+addstr1;

end;

procedure TfmRenovation.FormResize(Sender: TObject);
begin
  edSearch.Width:=Self.Width-edSearch.Left-pnBut.Width-8;
end;

end.
