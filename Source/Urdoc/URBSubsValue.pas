unit URBSubsValue;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  UEditSubsValue, UNewDbGrids, inifiles, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db,IBDatabase, Variants;

type
  TfmSubsValue = class(TForm)
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
    EditValueSubsName: string;
    EditValueSubsId: integer;
    isEditValue: Boolean;
    isFindSubsName,isFindText: Boolean;
    FindSubsName,FindText: String;
    FilterInSide: Boolean;
{    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
                                 DataCol: Integer; Column: TColumn;
                                 State: TGridDrawState);}
    procedure GridTitleClick(Column: TColumn);
    procedure GridDblClick(Sender: TObject);
    procedure SetImageFilter;
    procedure SaveFilter;
    procedure ViewCount;
    function GetFilterString: string;
    function TextExists(strText: String; tmpSubsID: Integer; var ID: Integer): Boolean;
    procedure GridKeyPress(Sender: TObject; var Key: Char);
  public
    Grid: TNewdbGrid;
    procedure MR(Sender: TObject);
    procedure ActiveQuery;
    procedure LoadFilter;
    procedure SetFilter(const SubsName,Text: string);
    procedure SetEditValue(const SubsName: string; const SubsID: integer);
  end;

var
  fmSubsValue: TfmSubsValue;
   
implementation

uses Udm, UMain;

{$R *.DFM}

procedure TfmSubsValue.FormCreate(Sender: TObject);
begin
  isEditValue:=false;
  
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
  Grid.OnDblClick:=GridDblClick;
  Grid.OnKeyDown:=FormKeyDown;
  Grid.OnKeyPress:=GridKeyPress;

  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
  Mainqr.Database:=dm.IBDbase;
end;

procedure TfmSubsValue.ActiveQuery;
var
 sqls: String;
 cl: TColumn;
begin
  ds.DataSet:=nil;
  Mainqr.Active:=false;
  Mainqr.sql.Clear;
  sqls:='Select tsv.*, ts.name as tsname from '+TableSubsValue+
        ' tsv join '+TableSubs+' ts on tsv.subs_id=ts.subs_id '+
        GetFilterString+' order by tsv.priority,tsv.text,ts.name';
  Mainqr.sql.Add(sqls);
  Mainqr.Active:=true;
  ds.DataSet:=Mainqr;
  SetImageFilter;
  ViewCount;
   if Grid.Columns.Count<>3 then begin

    cl:=Grid.Columns.Add;
    cl.FieldName:='text';
    cl.Title.Caption:='Значение';
    cl.Width:=300;

    cl:=Grid.Columns.Add;
    cl.FieldName:='tsname';
    cl.Title.Caption:='Подстановка';
    cl.Width:=150;

    cl:=Grid.Columns.Add;
    cl.FieldName:='priority';
    cl.Title.Caption:='Порядок';
    cl.Width:=50;
    
  end;
end;

procedure TfmSubsValue.bibAddClick(Sender: TObject);
var
  fm: TfmEditSubsValue;
  RetVal: Boolean;
  valname: string;
  ID: Integer;
  qr: TIbQuery;
  sqls: string;
  tr: TIBTransaction;
begin
 fm:=TfmEditSubsValue.Create(nil);
 try
  if isEditValue then begin
   fm.edSubs.text:=EditValueSubsName;
   fm.SubsID:=EditValueSubsId;
   fm.ActiveControl:=fm.meText;
  end;
  fm.Caption:=captionAdd;
  fm.btOk.OnClick:=fm.OkClick;
  if fm.ShowModal=mrOk then begin

    valname:=Trim(fm.meText.LInes.Text);
    retval:=TextExists(valname,fm.SubsID,ID);
    if retVal then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbText.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('subsvalue_id',id,[loCaseInsensitive]);
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
     sqls:='Insert into '+TableSubsValue+' (subs_id,text,priority) '+
           ' values ('+inttostr(fm.SubsID)+','+
           QuotedStr(trim(fm.meText.Lines.Text))+','+
           inttostr(fm.udPriority.Position)+
           ')';
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('text;subs_id',VarArrayOf([valname,fm.SubsID]),[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmSubsValue.bibChangeClick(Sender: TObject);
var
  fm: TfmEditSubsValue;
  RetVal: Boolean;
  valname: string;
  Id: Integer;
  qr: TIbQuery;
  sqls: string;
  tr: TIBTransaction;
  oldid: string;
begin
 if MainQr.RecordCount=0 then exit;
 fm:=TfmEditSubsValue.Create(nil);
 try
  fm.Caption:=captionChange;
  fm.edSubs.text:=Trim(MainQr.FieldByName('tsname').AsString);
  fm.SubsID:=MainQr.FieldByName('subs_id').AsInteger;
  id:=MainQr.FieldByName('subsvalue_id').AsInteger;
  fm.meText.Lines.Text:=trim(MainQr.FieldByName('text').AsString);
  fm.udPriority.Position:=MainQr.FieldByName('priority').AsInteger;

  fm.btOk.OnClick:=fm.OkClick;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    if not fm.ChangeFlag then exit;
    valname:=Trim(fm.meText.Lines.Text);
    retval:=TextExists(valname,fm.SubsId,Id);
    oldid:=MainQr.FieldByName('subsvalue_id').AsString;
    if (retVal)and(MainQr.FieldByName('subsvalue_id').AsInteger<>id) then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbtext.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('subsvalue_id',id,[loCaseInsensitive]);
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
     sqls:='Update '+TableSubsValue+' set '+
           ' subs_id='+inttostr(fm.SubsId)+
           ',text='+QuotedStr(trim(fm.meText.Lines.Text))+
           ',priority='+inttostr(fm.udPriority.Position)+
           ' where subsvalue_id='+oldid;
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('subsvalue_id',oldid,[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmSubsValue.bibDelClick(Sender: TObject);

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
     sqls:='Delete from '+TableSubsValue+' where subsvalue_id='+
          Mainqr.FieldByName('subsvalue_id').asString;
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
      ShowError(Application.Handle,'Значение подстановки <'+Mainqr.FieldByName('text').AsString+'> используется.');
    end;
  end;
end;

procedure TfmSubsValue.bibFilterClick(Sender: TObject);
var
  fm: TfmEditSubsValue;
  filstr: string;
begin
 fm:=TfmEditSubsValue.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.edSubs.Color:=clWindow;
  fm.edSubs.ReadOnly:=false;
  fm.lbPriority.Enabled:=false;
  fm.edPriority.Enabled:=false;
  fm.edPriority.Color:=clBtnFace;
  fm.udPriority.Enabled:=false;
  fm.btOk.OnClick:=fm.filterClick;

  if Trim(FindSubsName)<>'' then fm.edSubs.Text:=FindSubsName;
  if Trim(FindText)<>'' then fm.meText.Lines.Text:=FindText;

  fm.cbInString.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindSubsName:=Trim(fm.edSubs.Text);
    isFindSubsName:=Trim(FindSubsName)<>'';
    FindText:=Trim(fm.meText.Lines.Text);
    isFindText:=Trim(FindText)<>'';

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

procedure TfmSubsValue.MR(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmSubsValue.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not isValidKey(Char(Key)) then exit;
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  MainQr.Locate(grid.SelectedField.FullName,Trim(edSearch.Text),
                [loPartialKey,loCaseInsensitive]);
end;

procedure TfmSubsValue.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfmSubsValue.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmSubsValue.GridTitleClick(Column: TColumn);
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
   if AnsiUpperCase(fn)='TSNAME' then fn:='ts.name';
   if AnsiUpperCase(fn)='PRIORITY' then fn:='tsv.priority';
   id:=MainQr.fieldByName('subsvalue_id').asInteger;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   sqls:='Select tsv.*, ts.name as tsname from '+TableSubsValue+
        ' tsv join '+TableSubs+' ts on tsv.subs_id=ts.subs_id '+
         GetFilterString+' order by '+fn;
   MainQr.SQL.Add(sqls);
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('subsvalue_id',id,[loCaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmSubsValue.FormDestroy(Sender: TObject);
begin
  Grid.Free;
  if fsCreatedMDIChild in FormState then
   fmSubsValue:=nil;
end;

procedure TfmSubsValue.SetImageFilter;
begin
  bibFilter.Glyph.Assign(nil);
  bibFilter.Glyph.Width:=dm.IlMain.Width;
  bibFilter.Glyph.Height:=dm.IlMain.Height;
  if isFindSubsName or isFindText then begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,0,true);
  end else begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,1,true);
  end;
end;

procedure TfmSubsValue.LoadFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    FindSubsName:=fi.ReadString(ClassName,'SubsName',FindSubsName);
    FindText:=fi.ReadString(ClassName,'Text',FindText);
    FilterInside:=fi.ReadBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

procedure TfmSubsValue.SaveFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteString(ClassName,'SubsName',FindSubsName);
    fi.WriteString(ClassName,'Text',FindText);
    fi.WriteBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

procedure TfmSubsValue.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmSubsValue.MainqrAfterOpen(DataSet: TDataSet);
begin
  ViewCount;
end;

{procedure TfmSubsValue.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);

begin

end;}

procedure TfmSubsValue.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  bibChangeClick(nil);
end;

function TfmSubsValue.TextExists(strText: String; tmpSubsID: Integer; var ID: Integer): Boolean;
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
   sqls:='Select * from '+TableSubsValue+' where text='+QuotedStr(Trim(strText))+
         ' and subs_id='+inttostr(tmpSubsID);
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.recordCount=1 then begin
     ID:=qr.FieldByName('subsvalue_id').ASInteger;
     Result:=true;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=CrDefault;
  end;
end;

procedure TfmSubsValue.FormKeyDown(Sender: TObject; var Key: Word;
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

function TfmSubsValue.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:='';

    isFindSubsName:=Trim(FindSubsName)<>'';
    isFindText:=Trim(FindText)<>'';


    if isFindSubsName or isFindText then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindSubsName then begin
        addstr1:=' Upper(ts.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSubsName+'%'))+' ';
     end;

     if isFindText then begin
        addstr2:=' Upper(text) like '+AnsiUpperCase(QuotedStr(FilInSide+FindText+'%'))+' ';
     end;

     if (isFindSubsName and isFindText) then
      and1:=' and ';

      Result:=wherestr+addstr1+and1+
                       addstr2;

end;

procedure TfmSubsValue.FormResize(Sender: TObject);
begin
  edSearch.Width:=Self.Width-edSearch.Left-pnBut.Width-8;
end;

procedure TfmSubsValue.SetFilter(const SubsName,Text: string);
begin
  FindSubsName:=SubsName;
  FindText:=Text;
end;

procedure TfmSubsValue.edSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP,VK_DOWN: Grid.SetFocus;
  end;
  FormKeyDown(Sender,Key,Shift);
end;

procedure TfmSubsValue.GridKeyPress(Sender: TObject; var Key: Char);
begin
  if isValidKey(Key) then begin
   edSearch.SetFocus;
   edSearch.Text:=Key;
   edSearch.SelStart:=Length(edSearch.Text);
   if Assigned(edSearch.OnKeyPress) then
    edSearch.OnKeyPress(Sender,Key);
  end;
end;

procedure TfmSubsValue.SetEditValue(const SubsName: string; const SubsID: integer);
begin
  EditValueSubsName:=SubsName;
  EditValueSubsId:=SubsID;
  isEditValue:=true;
end;


procedure TfmSubsValue.bibPrintClick(Sender: TObject);
begin
  CreateWordTableByGrid(Grid,Caption);
end;

end.
