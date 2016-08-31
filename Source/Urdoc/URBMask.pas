unit URBMask;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  UEditMaskEdit, UNewDbGrids, inifiles, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db, Mask,IBDatabase;

type
  TfmMask = class(TForm)
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
    gbTest: TGroupBox;
    mskeTest: TMaskEdit;
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
    procedure MainqrAfterScroll(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure bibPrintClick(Sender: TObject);
  private
    FindName: string;
    FindMask: string;
    FindTest: string;
    isFindName,isFindMask,isFindTest: Boolean;
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
    function MaskNameExists(strName: String; var ID: Integer): Boolean;
    procedure ViewTest;

  public
    Grid: TNewdbGrid;
    procedure MR(Sender: TObject);
    procedure ActiveQuery;
    procedure LoadFilter;
  end;

var
  fmMask: TfmMask;

implementation

uses Udm, UMain, URBUsers, URBOperation;

{$R *.DFM}


procedure TfmMask.FormCreate(Sender: TObject);
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

  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
  Mainqr.Database:=dm.IBDbase;
end;

procedure TfmMask.ActiveQuery;
var
 sqls: String;
 cl: TColumn;
begin
  ds.DataSet:=nil;
  Mainqr.Active:=false;
  Mainqr.sql.Clear;
  sqls:='Select * from '+TableMask+GetFilterString+' order by name';
  Mainqr.sql.Add(sqls);
  Mainqr.Active:=true;
  ds.DataSet:=Mainqr;
  SetImageFilter;
  ViewCount;
  if Grid.Columns.Count<>3 then begin
   cl:=Grid.Columns.Add;
   cl.FieldName:='Name';
   cl.Title.Caption:='Наименование';
   cl.Width:=150;

   cl:=Grid.Columns.Add;
   cl.FieldName:='Mask';
   cl.Title.Caption:='Маска';
   cl.Width:=85;

   cl:=Grid.Columns.Add;
   cl.FieldName:='Test';
   cl.Title.Caption:='Тест';
   cl.Width:=85;
   
  end;
end;

procedure TfmMask.bibAddClick(Sender: TObject);
var
  fm: TfmEditMaskEdit;
  qr: TIBQuery;
  RetVal: Boolean;
  valname: string;
  sqls: string;
  id: Integer;
  tr: TIBTransaction;
begin
 fm:=TfmEditMaskEdit.Create(nil);
 try
  fm.Caption:=captionAdd;
  fm.bibOk.OnClick:=fm.AddAndChangeOkClick;
  if fm.ShowModal=mrOk then begin

    valname:=Trim(fm.edName.Text);
    retval:=MaskNameExists(valname,id);
    if retVal then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbname.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('mask_id',id,[loCaseInsensitive]);         
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
     sqls:='Insert into '+TableMask+' (name,mask,test) '+
           ' values ('''+valname+
           ''','''+Trim(fm.edMask.Text)+
           ''','''+Trim(fm.edTest.Text)+''')';
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

procedure TfmMask.bibChangeClick(Sender: TObject);
var
  fm: TfmEditMaskEdit;
  qr: TIBQuery;
  RetVal: Boolean;
  valname: string;
  id: Integer;
  sqls: string;
  tr: TIBTransaction;
begin
 if MainQr.RecordCount=0 then exit;
 fm:=TfmEditMaskEdit.Create(nil);
 try
  fm.Caption:=captionChange;
  fm.edName.text:=Trim(MainQr.FieldByName('name').AsString);
  fm.edMask.Text:=Trim(MainQr.FieldByName('mask').AsString);
  fm.edTest.Text:=Trim(MainQr.FieldByName('test').AsString);

  fm.bibOk.OnClick:=fm.AddAndChangeOkClick;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    if not fm.ChangeFlag then exit;
    valname:=Trim(fm.edName.Text);
    retval:=MaskNameExists(valname,Id);
    if (retVal)and(MainQr.FieldByName('mask_id').AsInteger<>id) then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbname.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('mask_id',id,[loCaseInsensitive]);         
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
     sqls:='Update '+TableMask+
           ' set name='''+valname+''', mask='''+Trim(fm.edMask.Text)+
           ''', test='''+Trim(fm.edTest.Text)+
           ''' where mask_id='+inttostr(MainQr.FieldByName('mask_id').AsInteger);
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

procedure TfmMask.bibDelClick(Sender: TObject);

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
     sqls:='Delete from '+TableMask+' where mask_id='+
           Mainqr.FieldByName('mask_id').asString;
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

//  but:=MessageBox(Handle,Pchar('Удалить ?'),'Предупреждение',MB_YESNO+MB_ICONWARNING);
  if mr=mrYes then begin
    if not deleteRecord then begin
      ShowError(Application.Handle,'Маска <'+Mainqr.FieldByName('name').AsString+'> используется.');
    end;
  end;
end;

procedure TfmMask.bibFilterClick(Sender: TObject);
var
  fm: TfmEditMaskEdit;
  filstr: string;
begin
 fm:=TfmEditMaskEdit.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOk.OnClick:=fm.FilterOk;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindMask)<>'' then fm.edMask.Text:=FindMask;
  if Trim(FindTest)<>'' then fm.edTest.Text:=FindTest;

  fm.cbInString.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindName:=Trim(fm.edName.Text);
    isFindName:=Trim(FindName)<>'';
    FindMask:=Trim(fm.edMask.Text);
    isFindMask:=Trim(FindMask)<>'';
    FindTest:=Trim(fm.edTest.Text);
    isFindTest:=Trim(FindTest)<>'';

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

procedure TfmMask.bibPrintClick(Sender: TObject);
begin
  CreateWordTableByGrid(Grid,Caption);
end;

procedure TfmMask.MR(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmMask.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not isValidKey(Char(Key)) then exit;
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  MainQr.Locate(grid.SelectedField.FullName,Trim(edSearch.Text),
                [loPartialKey,loCaseInsensitive]);
end;

procedure TfmMask.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfmMask.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMask.GridTitleClick(Column: TColumn);
var
  fn: string;
  id: integer;
begin
  if not MainQr.Active then exit;
  if MainQr.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('mask_id').asInteger;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   MainQr.SQL.Add('Select * from '+TableMask+GetFilterString+' Order by '+fn);
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('mask_id',id,[loCaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmMask.FormDestroy(Sender: TObject);
begin
  Grid.Free;
  if fsCreatedMDIChild in FormState then
   fmMask:=nil;
end;

procedure TfmMask.SetImageFilter;
begin
  bibFilter.Glyph.Assign(nil);
  bibFilter.Glyph.Width:=dm.IlMain.Width;
  bibFilter.Glyph.Height:=dm.IlMain.Height;
  if isFindName or isFindMask or isFindTest then begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,0,true);
  end else begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,1,true);
  end;
end;

procedure TfmMask.LoadFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    FindName:=fi.ReadString('RBMask','Name',FindName);
    FindMask:=fi.ReadString('RBMask','Mask',FindMask);
    FindTest:=fi.ReadString('RBMask','Test',FindTest);
    FilterInside:=fi.ReadBool('RBMask','Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

procedure TfmMask.SaveFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteString('RBMask','Name',FindName);
    fi.WriteString('RBMask','Mask',FindMask);
    fi.WriteString('RBMask','Test',FindTest);
    fi.WriteBool('RBMask','Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

function TfmMask.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3: string;
  and1,and2: string;
begin
    Result:='';

    isFindName:=Trim(FindName)<>'';
    isFindMask:=Trim(FindMask)<>'';
    isFindTest:=Trim(FindTest)<>'';

    if isFindName or isFindMask or isFindTest then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindMask then begin
        addstr2:=' Upper(mask) like '+AnsiUpperCase(QuotedStr(FilInSide+FindMask+'%'))+' ';
     end;

     if isFindTest then begin
        addstr3:=' Upper(test) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTest+'%'))+' ';
     end;

     if (isFindName and isFindMask)or
        (isFindName and isFindTest)   then
      and1:=' and ';

     if (isFindMask and isFindTest)   then
      and2:=' and ';

     Result:=wherestr+addstr1+and1+addstr2+and2+addstr3;

end;

procedure TfmMask.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmMask.MainqrAfterOpen(DataSet: TDataSet);
begin
  ViewCount;
  ViewTest;
end;

procedure TfmMask.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
end;

procedure TfmMask.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  bibChangeClick(nil);
end;

function TfmMask.MaskNameExists(strName: String; var ID: Integer): Boolean;
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
   sqls:='Select * from '+TableMask+' where name='''+Trim(strName)+'''';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.recordCount=1 then begin
     ID:=qr.FieldByName('mask_id').ASInteger;
     Result:=true;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=CrDefault;
  end;
end;

procedure TfmMask.ViewTest;
begin
 if MainQr.Active then
  if MainQr.RecordCount<>0 then
   mskeTest.EditMask:=Mainqr.FieldByName('mask').AsString;
end;

procedure TfmMask.MainqrAfterScroll(DataSet: TDataSet);
begin
  ViewTest;
end;

procedure TfmMask.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfmMask.FormResize(Sender: TObject);
begin
  edSearch.Width:=Self.Width-edSearch.Left-pnBut.Width-8;
end;

end.
