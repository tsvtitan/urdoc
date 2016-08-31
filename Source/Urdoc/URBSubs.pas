unit URBSubs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  UEditSubs, UNewDbGrids, inifiles, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db, Mask,IBDatabase;

type
  TfmSubs = class(TForm)
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
    procedure edSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibPrintClick(Sender: TObject);
  private
    FindName: string;
    isFindName: Boolean;
    FilterInSide: Boolean;
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
                                 DataCol: Integer; Column: TColumn;
                                 State: TGridDrawState);
    procedure GridTitleClick(Column: TColumn);
    procedure GridDblClick(Sender: TObject);
    procedure SetImageFilter;
    procedure SaveFilter;
    procedure ViewCount;
    function GetFilterString: string;
    function SubsNameExists(strName: String; var ID: Integer): Boolean;
    procedure GridKeyPress(Sender: TObject; var Key: Char);
  public
    Grid: TNewdbGrid;
    procedure MR(Sender: TObject);
    procedure ActiveQuery;
    procedure LoadFilter;
  end;

var
  fmSubs: TfmSubs;

implementation

uses Udm, UMain;

{$R *.DFM}


procedure TfmSubs.FormCreate(Sender: TObject);
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
  Grid.OnDrawColumnCell:=GridDrawColumnCell;
  Grid.OnDblClick:=GridDblClick;
  Grid.OnKeyDown:=FormKeyDown;
  Grid.OnKeyPress:=GridKeyPress;

  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
  Mainqr.Database:=dm.IBDbase;
end;

procedure TfmSubs.ActiveQuery;
var
 sqls: String;
 cl: TColumn;
begin
  ds.DataSet:=nil;
  Mainqr.Active:=false;
  Mainqr.sql.Clear;
  sqls:='Select * from '+TableSubs+GetFilterString+' order by priority, name';
  Mainqr.sql.Add(sqls);
  Mainqr.Active:=true;
  ds.DataSet:=Mainqr;
  SetImageFilter;
  ViewCount;
  if Grid.Columns.Count<>2 then begin
   cl:=Grid.Columns.Add;
   cl.FieldName:='Name';
   cl.Title.Caption:='Наименование';
   cl.Width:=300;

   cl:=Grid.Columns.Add;
   cl.FieldName:='priority';
   cl.Title.Caption:='Порядок';
   cl.Width:=50;
  end;
end;

procedure TfmSubs.bibAddClick(Sender: TObject);
var
  fm: TfmEditSubs;
  qr: TIBQuery;
  RetVal: Boolean;
  valname: string;
  sqls: string;
  id: Integer;
  tr: TIBTransaction;
begin
 fm:=TfmEditSubs.Create(nil);
 try
  fm.Caption:=captionAdd;
  fm.bibOk.OnClick:=fm.AddAndChangeOkClick;
  if fm.ShowModal=mrOk then begin

    valname:=Trim(fm.edName.Text);
    retval:=SubsNameExists(valname,id);
    if retVal then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbname.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('subs_id',id,[loCaseInsensitive]);         
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
     sqls:='Insert into '+TableSubs+' (name,priority) '+
           ' values ('+QuotedStr(valname)+','+inttostr(fm.udPriority.Position)+')';
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('name',valname,[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmSubs.bibChangeClick(Sender: TObject);
var
  fm: TfmEditSubs;
  qr: TIBQuery;
  RetVal: Boolean;
  valname: string;
  id: Integer;
  sqls: string;
  tr: TIBTransaction;
begin
 if MainQr.RecordCount=0 then exit;
 fm:=TfmEditSubs.Create(nil);
 try
  fm.Caption:=captionChange;
  fm.edName.text:=Trim(MainQr.FieldByName('name').AsString);
  fm.udPriority.Position:=MainQr.FieldByName('priority').AsInteger;
  id:=MainQr.FieldByName('subs_id').AsInteger;

  fm.bibOk.OnClick:=fm.AddAndChangeOkClick;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    if not fm.ChangeFlag then exit;
    valname:=Trim(fm.edName.Text);
    retval:=SubsNameExists(valname,Id);
    if (retVal)and(MainQr.FieldByName('subs_id').AsInteger<>id) then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbname.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('subs_id',id,[loCaseInsensitive]);         
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
     sqls:='Update '+TableSubs+
           ' set name='+QuotedStr(valname)+
           ',priority='+inttostr(fm.udPriority.Position)+
           ' where subs_id='+inttostr(MainQr.FieldByName('subs_id').AsInteger);
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('name',valname,[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmSubs.bibDelClick(Sender: TObject);

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
     sqls:='Delete from '+TableSubs+' where subs_id='+
           Mainqr.FieldByName('subs_id').asString;
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
      ShowError(Application.Handle,'Подстановка <'+Mainqr.FieldByName('name').AsString+'> используется.');
    end;
  end;
end;

procedure TfmSubs.bibFilterClick(Sender: TObject);
var
  fm: TfmEditSubs;
  filstr: string;
begin
 fm:=TfmEditSubs.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.lbPriority.Enabled:=false;
  fm.edPriority.Enabled:=false;
  fm.edPriority.Color:=clBtnFace;
  fm.udPriority.Enabled:=false;
  
  fm.bibOk.OnClick:=fm.FilterOk;

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

procedure TfmSubs.MR(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmSubs.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not isValidKey(Char(Key)) then exit;
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  MainQr.Locate(grid.SelectedField.FullName,Trim(edSearch.Text),
                [loPartialKey,loCaseInsensitive]);
end;

procedure TfmSubs.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfmSubs.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmSubs.GridTitleClick(Column: TColumn);
var
  fn: string;
  id: integer;
begin
  if not MainQr.Active then exit;
  if MainQr.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('subs_id').asInteger;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   MainQr.SQL.Add('Select * from '+TableSubs+GetFilterString+' Order by '+fn);
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('subs_id',id,[loCaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmSubs.FormDestroy(Sender: TObject);
begin
  Grid.Free;
  if fsCreatedMDIChild in FormState then
   fmSubs:=nil;
end;

procedure TfmSubs.SetImageFilter;
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

procedure TfmSubs.LoadFilter;
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

procedure TfmSubs.SaveFilter;
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

function TfmSubs.GetFilterString: string;
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

procedure TfmSubs.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmSubs.MainqrAfterOpen(DataSet: TDataSet);
begin
  ViewCount;
end;

procedure TfmSubs.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
end;

procedure TfmSubs.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  bibChangeClick(nil);
end;

function TfmSubs.SubsNameExists(strName: String; var ID: Integer): Boolean;
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
   sqls:='Select * from '+TableSubs+' where name='''+Trim(strName)+'''';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.recordCount=1 then begin
     ID:=qr.FieldByName('subs_id').ASInteger;
     Result:=true;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=CrDefault;
  end;
end;

procedure TfmSubs.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfmSubs.FormResize(Sender: TObject);
begin
  edSearch.Width:=Self.Width-edSearch.Left-pnBut.Width-8;
end;

procedure TfmSubs.GridKeyPress(Sender: TObject; var Key: Char);
begin
  if isValidKey(Key) then begin
   edSearch.SetFocus;
   edSearch.Text:=Key;
   edSearch.SelStart:=Length(edSearch.Text);
   if Assigned(edSearch.OnKeyPress) then
    edSearch.OnKeyPress(Sender,Key);
  end;
end;

procedure TfmSubs.edSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP,VK_DOWN: Grid.SetFocus;
  end;
  FormKeyDown(Sender,Key,Shift);
end;

procedure TfmSubs.bibPrintClick(Sender: TObject);
begin
  CreateWordTableByGrid(Grid,Caption);
end;

end.
