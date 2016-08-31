unit URBNotarius;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  UEditNotarius, UNewDbGrids, inifiles, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db,IBDatabase;

type
  TfmNotarius = class(TForm)
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
    FindFio,FindUradres,FindTown: string;
    isFindFio,isFindUradres,isFindTown: Boolean;
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
    function NotariusNameExists(strName: String; var ID: Integer): Boolean;
  public
    Grid: TNewdbGrid;
    procedure MR(Sender: TObject);
    procedure ActiveQuery;
    procedure LoadFilter;
  end;

var
  fmNotarius: TfmNotarius;
   
implementation

uses Udm, UMain;

{$R *.DFM}

procedure TfmNotarius.FormCreate(Sender: TObject);
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

procedure TfmNotarius.ActiveQuery;
var
 sqls: String;
 cl: TColumn;
begin
  ds.DataSet:=nil;
  Mainqr.Active:=false;
  Mainqr.sql.Clear;
  sqls:='Select * from '+TableNotarius+GetFilterString+' order by fio';
  Mainqr.sql.Add(sqls);
  Mainqr.Active:=true;
  ds.DataSet:=Mainqr;
  SetImageFilter;
  ViewCount;
  if Grid.Columns.Count<>2 then begin
   cl:=Grid.Columns.Add;
   cl.FieldName:='fio';
   cl.Title.Caption:='������� �.�.';
   cl.Width:=200;

   cl:=Grid.Columns.Add;
   cl.FieldName:='ishelperplus';
   cl.Title.Caption:='��� ��������';
   cl.Width:=80;
   
   cl:=Grid.Columns.Add;
   cl.FieldName:='uradres';
   cl.Title.Caption:='����������� �����';
   cl.Width:=250;


{   cl:=Grid.Columns.Add;
   cl.FieldName:='town';
   cl.Title.Caption:='�����';
   cl.Width:=150;}
  end;
end;

procedure TfmNotarius.bibAddClick(Sender: TObject);
var
  fm: TfmEditNotarius;
  qr: TIBQuery;
  RetVal: Boolean;
  valname: string;
  ID: Integer;
  sqls: string;
  tr: TIBTransaction;
begin
 fm:=TfmEditNotarius.Create(nil);
 try
  fm.Caption:=captionAdd;
  fm.bibOk.OnClick:=fm.OkClick;
  if fm.ShowModal=mrOk then begin

    valname:=Trim(fm.edFio.Text);
    retval:=NotariusNameExists(valname,ID);
    if retVal then begin
      ShowError(Application.handle,'�������� <'+valname+'> '+#13+
               '� ���� <'+fm.lbFio.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('not_id',id,[loCaseInsensitive]);
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
     sqls:='Insert into '+TableNotarius+' (fio,uradres,townfullnormal,townfullwhere,'+
           'townfullwhat,townsmallnormal,townsmallwhere,townsmallwhat,nametownnormal,'+
           'nametownwhere,nametownwhat,inn,ishelper,phone) '+
           ' values ('''+valname+
           ''','''+Trim(fm.edUrAdres.text)+
           ''','''+Trim(fm.edTownFullNormal.text)+
           ''','''+Trim(fm.edTownFullWhere.text)+
           ''','''+Trim(fm.edTownFullWhat.text)+
           ''','''+Trim(fm.edTownSmallNormal.text)+
           ''','''+Trim(fm.edTownSmallWhere.text)+
           ''','''+Trim(fm.edTownSmallWhat.text)+
           ''','''+Trim(fm.edNameTownNormal.text)+
           ''','''+Trim(fm.edNameTownWhere.text)+
           ''','''+Trim(fm.edNameTownWhat.text)+
           ''','''+Trim(fm.edInn.text)+
           ''','+inttostr(Integer(fm.chbIsHelper.checked))+
           ','''+Trim(fm.EditPhone.text)+
           ''')';
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('fio',valname,[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmNotarius.bibChangeClick(Sender: TObject);
var
  fm: TfmEditNotarius;
  RetVal: Boolean;
  valname: string;
  Id: Integer;
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
 if MainQr.RecordCount=0 then exit;
 fm:=TfmEditNotarius.Create(nil);
 try
  fm.Caption:=captionChange;
  fm.edFio.text:=Trim(MainQr.FieldByName('fio').AsString);
  fm.edUrAdres.text:=Trim(MainQr.FieldByName('uradres').AsString);
  fm.edTownFullNormal.text:=Trim(MainQr.FieldByName('townfullnormal').AsString);
  fm.edTownFullWhere.text:=Trim(MainQr.FieldByName('townfullwhere').AsString);
  fm.edTownFullWhat.text:=Trim(MainQr.FieldByName('townfullwhat').AsString);
  fm.edTownSmallNormal.text:=Trim(MainQr.FieldByName('townsmallnormal').AsString);
  fm.edTownSmallWhere.text:=Trim(MainQr.FieldByName('townsmallwhere').AsString);
  fm.edTownSmallWhat.text:=Trim(MainQr.FieldByName('townsmallwhat').AsString);
  fm.edNameTownNormal.text:=Trim(MainQr.FieldByName('nametownnormal').AsString);
  fm.edNameTownWhere.text:=Trim(MainQr.FieldByName('nametownwhere').AsString);
  fm.edNameTownWhat.text:=Trim(MainQr.FieldByName('nametownwhat').AsString);
  fm.edInn.text:=Trim(MainQr.FieldByName('inn').AsString);
  fm.EditPhone.Text:=Trim(MainQr.FieldByName('phone').AsString);
  fm.chbIsHelper.checked:=Boolean(MainQr.FieldByName('ishelper').AsInteger);

  fm.bibOk.OnClick:=fm.OkClick;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    if not fm.ChangeFlag then exit;
    valname:=Trim(fm.edFio.Text);
    retval:=NotariusNameExists(valname,Id);
    if (retVal)and(MainQr.FieldByName('not_id').AsInteger<>id) then begin
      ShowError(Application.handle,'�������� <'+valname+'> '+#13+
               '� ���� <'+fm.lbFio.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('not_id',id,[loCaseInsensitive]);
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
     sqls:='Update '+TableNotarius+
           ' set fio='''+valname+
           ''',uradres='''+Trim(fm.edUrAdres.text)+
           ''',townfullnormal='''+Trim(fm.edTownFullNormal.text)+
           ''',townfullwhere='''+Trim(fm.edTownFullWhere.text)+
           ''',townfullwhat='''+Trim(fm.edTownFullWhat.text)+
           ''',townsmallnormal='''+Trim(fm.edTownSmallNormal.text)+
           ''',townsmallwhere='''+Trim(fm.edTownSmallWhere.text)+
           ''',townsmallwhat='''+Trim(fm.edTownSmallWhat.text)+
           ''',nametownnormal='''+Trim(fm.edNameTownNormal.text)+
           ''',nametownwhere='''+Trim(fm.edNameTownWhere.text)+
           ''',nametownwhat='''+Trim(fm.edNameTownWhat.text)+
           ''',inn='''+Trim(fm.edInn.text)+
           ''',phone='''+Trim(fm.EditPhone.Text)+
           ''',ishelper='+inttostr(Integer(fm.chbIsHelper.checked))+
           ' where not_id='+MainQr.FieldByName('not_id').AsString;

     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('fio',valname,[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmNotarius.bibDelClick(Sender: TObject);

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
     sqls:='Delete from '+TableNotarius+' where not_id='+
          Mainqr.FieldByName('not_id').asString;
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
  mr:=MessageDlg('������� ?',mtConfirmation,[mbYes,mbNo],-1);

//  but:=MessageBox(Handle,Pchar('������� ?'),'��������������',MB_YESNO+MB_ICONWARNING);
  if mr=mrYes then begin
    if not deleteRecord then begin
      ShowError(Application.Handle,'�������� <'+Mainqr.FieldByName('fio').AsString+'> ������������.');
    end;
  end;
end;

procedure TfmNotarius.bibFilterClick(Sender: TObject);
var
  fm: TfmEditNotarius;
  filstr: string;
begin
 fm:=TfmEditNotarius.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.pc.Enabled:=false;
  fm.DisableControl(fm.pc);
  fm.edINN.Enabled:=false;
  fm.lbINN.Enabled:=false;
  fm.EditPhone.Enabled:=false;
  fm.LabelPhone.Enabled:=false;
  fm.chbIsHelper.Enabled:=false;
  fm.bibOk.OnClick:=fm.filterClick;

  if Trim(FindFio)<>'' then fm.edFio.Text:=FindFio;
  if Trim(FindUradres)<>'' then fm.edUrAdres.Text:=FindUradres;

  fm.cbInString.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindFio:=Trim(fm.edFio.Text);
    isFindFio:=Trim(FindFio)<>'';
    FindUradres:=Trim(fm.edUrAdres.Text);
    isFindUradres:=Trim(FindUradres)<>'';
    isFindTown:=Trim(FindTown)<>'';

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

procedure TfmNotarius.bibPrintClick(Sender: TObject);
begin
  CreateWordTableByGrid(Grid,Caption);
end;

procedure TfmNotarius.MR(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmNotarius.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 tmps: string;
begin
  if not isValidKey(Char(Key)) then exit;
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  tmps:=grid.SelectedField.FullName;
  if AnsiUpperCase(tmps)=AnsiUpperCase('ISHELPERPLUS') then
    tmps:='ishelper';
  MainQr.Locate(tmps,Trim(edSearch.Text),
                [loPartialKey,loCaseInsensitive]);
end;

procedure TfmNotarius.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfmNotarius.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNotarius.GridTitleClick(Column: TColumn);
var
  fn: string;
  id: integer;
begin
  if not MainQr.Active then exit;
  if MainQr.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   if AnsiUpperCase(fn)=AnsiUpperCase('ISHELPERPLUS') then fn:='ishelper';
   id:=MainQr.fieldByName('not_id').asInteger;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   MainQr.SQL.Add('Select * from '+TableNotarius+GetFilterString+' Order by '+fn);
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('not_id',id,[loCaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmNotarius.FormDestroy(Sender: TObject);
begin
  Grid.Free;
  if fsCreatedMDIChild in FormState then
   fmNotarius:=nil;
end;

procedure TfmNotarius.SetImageFilter;
begin
  bibFilter.Glyph.Assign(nil);
  bibFilter.Glyph.Width:=dm.IlMain.Width;
  bibFilter.Glyph.Height:=dm.IlMain.Height;
  if isFindFio or isFindUradres or isFindTown then begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,0,true);
  end else begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,1,true);
  end;
end;

procedure TfmNotarius.LoadFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    FindFio:=fi.ReadString('RBNotarius','FIO',FindFio);
    FindUradres:=fi.ReadString('RBNotarius','Uradres',FindUradres);
    FindTown:=fi.ReadString('RBNotarius','Town',FindTown);

    FilterInside:=fi.ReadBool('RBNotarius','Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

procedure TfmNotarius.SaveFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteString('RBNotarius','FIO',FindFio);
    fi.WriteString('RBNotarius','Uradres',FindUradres);
    fi.WriteString('RBNotarius','Town',FindTown);

    fi.WriteBool('RBNotarius','Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

function TfmNotarius.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3: string;
  and1,and2: string;
begin
    Result:='';

    isFindFio:=Trim(FindFio)<>'';
    isFindUradres:=Trim(FindUradres)<>'';
    isFindTown:=Trim(FindTown)<>'';

    if isFindFio or isFindUradres or isFindTown then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if (isFindFio)then begin
        addstr1:=' Upper(fio) like '+AnsiUpperCase(QuotedStr(FilInSide+FindFio+'%'))+' ';
     end;

     if (isFindUradres)then begin
        addstr2:=' Upper(uradres) like '+AnsiUpperCase(QuotedStr(FilInSide+FindUradres+'%'))+' ';
     end;

     if (isFindTown)then begin
        addstr3:=' Upper(town) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTown+'%'))+' ';
     end;


     if (isFindFio and isFindUradres)or
        (isFindFio and isFindTown)then begin
        and1:=' and ';
     end;

     if (isFindUradres and isFindTown)then begin
        and2:=' and ';
     end;

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3;

end;

procedure TfmNotarius.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmNotarius.MainqrAfterOpen(DataSet: TDataSet);
begin
  ViewCount;
end;

procedure TfmNotarius.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
  
  procedure DrawPlus;
  var
    chk: Boolean;
    x: Integer;
  begin
    chk:=Mainqr.FieldByName('ishelper').AsString='1';
    x:=rect.Left+(rect.Right-rect.Left) div 2;
    if not chk then Begin
     il.Draw(grid.Canvas,x-il.Width div 2,rect.Top,0,true);
    end else begin
     il.Draw(grid.Canvas,x-il.Width div 2,rect.Top,1,true);
    end;
  end;

begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if column.Title.Caption='��� ��������' then begin
    DrawPlus;
  end;
end;

procedure TfmNotarius.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  bibChangeClick(nil);
end;

function TfmNotarius.NotariusNameExists(strName: String; var ID: Integer): Boolean;
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
   sqls:='Select * from '+TableNotarius+' where fio='''+Trim(strName)+'''';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.recordCount=1 then begin
     ID:=qr.FieldByName('not_id').ASInteger;
     Result:=true;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=CrDefault;
  end;
end;

procedure TfmNotarius.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfmNotarius.FormResize(Sender: TObject);
begin
  edSearch.Width:=Self.Width-edSearch.Left-pnBut.Width-8;
end;

end.
