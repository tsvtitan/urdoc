unit URBNotary;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  UEditNotary, UNewDbGrids, inifiles, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db,IBDatabase, Variants;

type
  TfmNotary = class(TForm)
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
    FindFio,FindChamber,FindAddress,FindPhone,FindEmail,FindCounty,FindLetter: string;
    isFindFio,isFindChamber,isFindAddress,isFindPhone,isFindEmail,isFindCounty,isFindLetter: Boolean;
    FilterInSide: Boolean;
    procedure GridTitleClick(Column: TColumn);
    procedure GridDblClick(Sender: TObject);
    procedure SetImageFilter;
    procedure SaveFilter;
    procedure ViewCount;
    function GetFilterString: string;
    function NotaryNameExists(strName: String; var ID: Integer): Boolean;

  public
    Grid: TNewdbGrid;
    procedure MR(Sender: TObject);
    procedure ActiveQuery;
    procedure LoadFilter;
  end;

var
  fmNotary: TfmNotary;
   
implementation

uses Udm, UMain, URBUsers;

{$R *.DFM}

procedure TfmNotary.FormCreate(Sender: TObject);
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
  Grid.OnDblClick:=GridDblClick;
  Grid.OnKeyDown:=FormKeyDown;

  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
  Mainqr.Database:=dm.IBDbase;
end;

procedure TfmNotary.ActiveQuery;
var
 sqls: String;
 cl: TColumn;
begin
  ds.DataSet:=nil;
  Mainqr.Active:=false;
  Mainqr.sql.Clear;
  sqls:='Select tn.*,tc.name as chamber_name from '+TableNotary+' tn join '+
        TableChamber+' tc on tn.chamber_id=tc.chamber_id '+
        GetFilterString+' order by fio';
  Mainqr.sql.Add(sqls);
  Mainqr.Active:=true;
  ds.DataSet:=Mainqr;
  SetImageFilter;
  ViewCount;
  if Grid.Columns.Count<>4 then begin
   cl:=Grid.Columns.Add;
   cl.FieldName:='fio';
   cl.Title.Caption:='Нотариус';
   cl.Width:=200;

   cl:=Grid.Columns.Add;
   cl.FieldName:='phone';
   cl.Title.Caption:='Телефон';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='address';
   cl.Title.Caption:='Адрес';
   cl.Width:=250;

   cl:=Grid.Columns.Add;
   cl.FieldName:='letter';
   cl.Title.Caption:='Буквы';
   cl.Width:=100;

  end;
end;

procedure TfmNotary.bibAddClick(Sender: TObject);
var
  fm: TfmEditNotary;
  qr: TIBQuery;
  RetVal: Boolean;
  valname: string;
  sqls: string;
  id: Integer;
  tr: TIBTransaction;
begin
 fm:=TfmEditNotary.Create(nil);
 try
  fm.Caption:=captionAdd;
  fm.btOk.OnClick:=fm.OkClick;
  if fm.ShowModal=mrOk then begin

    valname:=Trim(fm.edFio.Text);
    retval:=NotaryNameExists(valname,id);
    if retVal then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbFio.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('notary_id',id,[loCaseInsensitive]);         
      exit;
    end;
    ID:=GetGenId(TableNotary,1);
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
     sqls:='Insert into '+TableNotary+' (notary_id,fio,chamber_id,address,phone,email,county,letter,work_graph,is_helper) '+
           ' values ('+IntToStr(id)+
           ','+QuotedStr(Trim(fm.edFio.Text))+
           ','+IntToStr(fm.ChamberId)+
           ','+QuotedStr(Trim(fm.edAddress.Text))+
           ','+iff(Trim(fm.edPhone.Text)<>'',QuotedStr(Trim(fm.edPhone.Text)),'null')+
           ','+iff(Trim(fm.edEmail.Text)<>'',QuotedStr(Trim(fm.edEmail.Text)),'null')+
           ','+iff(Trim(fm.edCounty.Text)<>'',QuotedStr(Trim(fm.edCounty.Text)),'null')+
           ','+iff(Trim(fm.edLetter.Text)<>'',QuotedStr(Trim(fm.edLetter.Text)),'null')+
           ','+iff(Trim(fm.meWorkGraph.Lines.Text)<>'',QuotedStr(Trim(fm.meWorkGraph.Lines.Text)),'null')+
           ','+iff(fm.chbIsHelper.Checked,'1','0')+
           ')';
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('fio',VarArrayOf([valname]),[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmNotary.bibChangeClick(Sender: TObject);
var
  fm: TfmEditNotary;
  qr: TIBQuery;
  RetVal: Boolean;
  valname: string;
  id: Integer;
  sqls: string;
  tr: TIBTransaction;
begin
 if MainQr.RecordCount=0 then exit;
 fm:=TfmEditNotary.Create(nil);
 try
  fm.Caption:=captionChange;
  fm.edFio.Text:=Trim(MainQr.FieldByName('fio').AsString);
  fm.ChamberId:=MainQr.FieldByName('chamber_id').AsInteger;
  fm.edChamber.Text:=Trim(MainQr.FieldByName('chamber_name').AsString);
  fm.edAddress.Text:=Trim(MainQr.FieldByName('address').AsString);
  fm.edPhone.Text:=Trim(MainQr.FieldByName('phone').AsString);
  fm.edEmail.Text:=Trim(MainQr.FieldByName('email').AsString);
  fm.edCounty.Text:=Trim(MainQr.FieldByName('county').AsString);
  fm.edLetter.Text:=Trim(MainQr.FieldByName('letter').AsString);
  fm.meWorkGraph.Lines.Text:=Trim(MainQr.FieldByName('work_graph').AsString);
  fm.chbIsHelper.Checked:=MainQr.FieldByName('is_helper').AsInteger>0;

  fm.btOk.OnClick:=fm.OkClick;
  fm.ChangeFlag:=false;
  
  if fm.ShowModal=mrOk then begin

    if not fm.ChangeFlag then exit;
    valname:=Trim(fm.edFio.Text);
    retval:=NotaryNameExists(valname,Id);
    if (retVal)and(MainQr.FieldByName('notary_id').AsInteger<>id) then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbFio.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('notary_id',id,[loCaseInsensitive]);         
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
     sqls:='Update '+TableNotary+
           ' set fio='+QuotedStr(valname)+
           ', chamber_id='+inttostr(fm.ChamberId)+
           ', address='+QuotedStr(fm.edAddress.Text)+
           ', phone='+iff(Trim(fm.edPhone.Text)<>'',QuotedStr(Trim(fm.edPhone.Text)),'null')+
           ', email='+iff(Trim(fm.edEmail.Text)<>'',QuotedStr(Trim(fm.edEmail.Text)),'null')+
           ', county='+iff(Trim(fm.edCounty.Text)<>'',QuotedStr(Trim(fm.edCounty.Text)),'null')+
           ', letter='+iff(Trim(fm.edLetter.Text)<>'',QuotedStr(Trim(fm.edLetter.Text)),'null')+
           ', work_graph='+iff(Trim(fm.meWorkGraph.Lines.Text)<>'',QuotedStr(Trim(fm.meWorkGraph.Lines.Text)),'null')+
           ', is_helper='+iff(fm.chbIsHelper.Checked,'1','0')+
           ' where notary_id='+inttostr(MainQr.FieldByName('notary_id').AsInteger);
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('fio',VarArrayOf([valname]),[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;             
end;

procedure TfmNotary.bibDelClick(Sender: TObject);

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
    Result:=false;
    try

     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+TableNotary+' where notary_id='+
            Mainqr.FieldByName('notary_id').asString;
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
      ShowError(Application.Handle,'Нотариус <'+Mainqr.FieldByName('fio').AsString+'> используется.');
    end;
  end;
end;

procedure TfmNotary.bibFilterClick(Sender: TObject);
var
  fm: TfmEditNotary;
  filstr: string;
begin
 fm:=TfmEditNotary.Create(nil);
 try
  fm.Caption:=CaptionFilter;

  fm.edChamber.Color:=clWindow;
  fm.edChamber.ReadOnly:=false;

  fm.meWorkGraph.Enabled:=false;
  fm.meWorkGraph.Color:=clBtnFace;
  fm.lbWorkGraph.Enabled:=false;

  fm.chbIsHelper.Enabled:=false;

  fm.btOk.OnClick:=fm.filterClick;

  if Trim(FindFio)<>'' then fm.edFio.Text:=FindFio;
  if Trim(FindChamber)<>'' then fm.edChamber.Text:=FindChamber;
  if Trim(FindAddress)<>'' then fm.edAddress.Text:=FindAddress;
  if Trim(FindPhone)<>'' then fm.edPhone.Text:=FindPhone;
  if Trim(FindEmail)<>'' then fm.edEmail.Text:=FindEmail;
  if Trim(FindCounty)<>'' then fm.edCounty.Text:=FindCounty;
  if Trim(FindLetter)<>'' then fm.edLetter.Text:=FindLetter;

  fm.cbInString.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindFio:=fm.edFio.Text;
    isFindFio:=Trim(FindFio)<>'';
    
    FindChamber:=fm.edChamber.Text;
    isFindChamber:=Trim(FindChamber)<>'';

    FindAddress:=fm.edAddress.Text;
    isFindAddress:=Trim(FindAddress)<>'';

    FindPhone:=fm.edPhone.Text;
    isFindPhone:=Trim(FindPhone)<>'';

    FindEmail:=fm.edEmail.Text;
    isFindEmail:=Trim(FindEmail)<>'';

    FindCounty:=fm.edCounty.Text;
    isFindCounty:=Trim(FindCounty)<>'';

    FindLetter:=fm.edLetter.Text;
    isFindLetter:=Trim(FindLetter)<>'';

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

procedure TfmNotary.MR(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmNotary.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not isValidKey(Char(Key)) then exit;
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  MainQr.Locate(grid.SelectedField.FullName,Trim(edSearch.Text),
                [loPartialKey,loCaseInsensitive]);
end;

procedure TfmNotary.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfmNotary.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNotary.GridTitleClick(Column: TColumn);
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
   if fn='ADDRESS' then fn:='tn.address';
   if fn='PHONE' then fn:='tn.phone';
   id:=MainQr.fieldByName('notary_id').asInteger;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   sqls:='Select tn.*,tc.name as chamber_name from '+TableNotary+' tn join '+
         TableChamber+' tc on tn.chamber_id=tc.chamber_id '+
         GetFilterString+' order by '+fn;
   Mainqr.sql.Add(sqls);
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('notary_id',id,[loCaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmNotary.FormDestroy(Sender: TObject);
begin
  Grid.Free;
  if fsCreatedMDIChild in FormState then
   fmNotary:=nil;
end;

procedure TfmNotary.SetImageFilter;
begin
  bibFilter.Glyph.Assign(nil);
  bibFilter.Glyph.Width:=dm.IlMain.Width;
  bibFilter.Glyph.Height:=dm.IlMain.Height;
  if isFindFio or isFindChamber or isFindAddress or isFindPhone or isFindEmail or isFindCounty or isFindLetter then begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,0,true);
  end else begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,1,true);
  end;
end;

procedure TfmNotary.LoadFilter;
var
  fi: TIniFile;
begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  try
    FindFio:=fi.ReadString('RBNotary','Fio',FindFio);
    FindChamber:=fi.ReadString('RBNotary','Chamber',FindChamber);
    FindAddress:=fi.ReadString('RBNotary','Address',FindAddress);
    FindPhone:=fi.ReadString('RBNotary','Phone',FindPhone);
    FindEmail:=fi.ReadString('RBNotary','Email',FindEmail);
    FindCounty:=fi.ReadString('RBNotary','County',FindCounty);
    FindLetter:=fi.ReadString('RBNotary','Letter',FindLetter);
    FilterInside:=fi.ReadBool('RBNotary','Inside',FilterInside);
  finally
   fi.Free;
  end;
 except
 end;
end;

procedure TfmNotary.SaveFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteString('RBNotary','Fio',FindFio);
    fi.WriteString('RBNotary','Chamber',FindChamber);
    fi.WriteString('RBNotary','Address',FindAddress);
    fi.WriteString('RBNotary','Phone',FindPhone);
    fi.WriteString('RBNotary','Email',FindEmail);
    fi.WriteString('RBNotary','County',FindCounty);
    fi.WriteString('RBNotary','Letter',FindLetter);
    fi.WriteBool('RBNotary','Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

function TfmNotary.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,addstr6,addstr7: string;
  and1,and2,and3,and4,and5,and6: string;
begin
    Result:='';

    isFindFio:=Trim(FindFio)<>'';
    isFindChamber:=Trim(FindChamber)<>'';
    isFindAddress:=Trim(FindAddress)<>'';
    isFindPhone:=Trim(FindPhone)<>'';
    isFindEmail:=Trim(FindEmail)<>'';
    isFindCounty:=Trim(FindCounty)<>'';
    isFindLetter:=Trim(FindLetter)<>'';

    if isFindFio or isFindChamber or isFindAddress or isFindPhone or isFindEmail or isFindCounty or isFindLetter then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindFio then begin
        addstr1:=' Upper(fio) like '+AnsiUpperCase(QuotedStr(FilInSide+FindFio+'%'))+' ';
     end;

     if isFindChamber then begin
        addstr2:=' Upper(tc.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindChamber+'%'))+' ';
     end;

     if isFindAddress then begin
        addstr3:=' Upper(tn.address) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAddress+'%'))+' ';
     end;

     if isFindPhone then begin
        addstr4:=' Upper(tn.phone) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPhone+'%'))+' ';
     end;

     if isFindEmail then begin
        addstr5:=' Upper(tn.email) like '+AnsiUpperCase(QuotedStr(FilInSide+FindEmail+'%'))+' ';
     end;

     if isFindCounty then begin
        addstr6:=' Upper(county) like '+AnsiUpperCase(QuotedStr(FilInSide+FindCounty+'%'))+' ';
     end;

     if isFindLetter then begin
        addstr7:=' Upper(letter) like '+AnsiUpperCase(QuotedStr(FilInSide+FindLetter+'%'))+' ';
     end;

     if (isFindFio and isFindChamber) or
        (isFindFio and isFindAddress) or
        (isFindFio and isFindPhone) or
        (isFindFio and isFindEmail) or
        (isFindFio and isFindCounty) or
        (isFindFio and isFindLetter)
        then
      and1:=' and ';

     if (isFindChamber and isFindAddress) or
        (isFindChamber and isFindPhone) or
        (isFindChamber and isFindEmail) or
        (isFindChamber and isFindCounty) or
        (isFindChamber and isFindLetter)
        then
      and2:=' and ';

     if (isFindAddress and isFindPhone) or
        (isFindAddress and isFindEmail) or
        (isFindAddress and isFindCounty) or
        (isFindAddress and isFindLetter)
        then
      and3:=' and ';

     if (isFindPhone and isFindEmail) or
        (isFindPhone and isFindCounty) or
        (isFindPhone and isFindLetter)
        then
      and4:=' and ';

     if (isFindEmail and isFindCounty) or
        (isFindEmail and isFindLetter)
        then
      and5:=' and ';

     if (isFindCounty and isFindLetter)
        then
      and6:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4+and4+
                      addstr5+and5+
                      addstr6+and6+
                      addstr7;

end;

procedure TfmNotary.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmNotary.MainqrAfterOpen(DataSet: TDataSet);
begin
  ViewCount;
end;

procedure TfmNotary.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  bibChangeClick(nil);
end;

function TfmNotary.NotaryNameExists(strName: String; var ID: Integer): Boolean;
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
   sqls:='Select * from '+TableNotary+' where fio='+QuotedStr(Trim(strName))+
         ' and notary_id='+inttostr(Id);
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.recordCount=1 then begin
     ID:=qr.FieldByName('notary_id').ASInteger;
     Result:=true;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=CrDefault;
  end;
end;

procedure TfmNotary.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfmNotary.FormResize(Sender: TObject);
begin
  edSearch.Width:=Self.Width-edSearch.Left-pnBut.Width-8;
end;

procedure TfmNotary.bibPrintClick(Sender: TObject);
begin
  CreateWordTableByGrid(Grid,Caption);
end;

end.
