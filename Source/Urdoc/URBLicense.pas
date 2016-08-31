unit URBLicense;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  UEditLicense, UNewDbGrids, inifiles, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db,IBDatabase, Variants;

type
  TfmLicense = class(TForm)
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
    isFindNotName,isFindNum,isFindDatelic,isFindKem: Boolean;
    FindNotName,FindNum,FindKem: String;
    FindDateLic: TDateTime;
    FilterInSide: Boolean;
    procedure GridTitleClick(Column: TColumn);
    procedure GridDblClick(Sender: TObject);
    procedure SetImageFilter;
    procedure SaveFilter;
    procedure ViewCount;
    function GetFilterString: string;
    function NumExists(strName: String; tmpNotID: Integer; var ID: Integer): Boolean;
  public
    Grid: TNewdbGrid;
    procedure MR(Sender: TObject);
    procedure ActiveQuery;
    procedure LoadFilter;
  end;

var
  fmLicense: TfmLicense;
   
implementation

uses Udm, UMain;

{$R *.DFM}

procedure TfmLicense.FormCreate(Sender: TObject);
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
  FindDateLic:=Workdate;
end;

procedure TfmLicense.ActiveQuery;
var
 sqls: String;
 cl: TColumn;
begin
  ds.DataSet:=nil;
  Mainqr.Active:=false;
  Mainqr.sql.Clear;
  sqls:='Select tl.*, tn.fio as tnfio from '+TableLicense+
        ' tl join '+TableNotarius+' tn on tl.not_id=tn.not_id '+
        GetFilterString+' order by tn.fio';
  Mainqr.sql.Add(sqls);
  Mainqr.Active:=true;
  ds.DataSet:=Mainqr;
  SetImageFilter;
  ViewCount;
   if Grid.Columns.Count<>3 then begin
    cl:=Grid.Columns.Add;
    cl.FieldName:='num';
    cl.Title.Caption:='Номер лицензии';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='datelic';
    cl.Title.Caption:='Дата выдачи';
    cl.Width:=90;

    cl:=Grid.Columns.Add;
    cl.FieldName:='tnfio';
    cl.Title.Caption:='Нотариус';
    cl.Width:=220;

  end;
end;

procedure TfmLicense.bibAddClick(Sender: TObject);
var
  fm: TfmEditLicense;
  RetVal: Boolean;
  valname: string;
  ID: Integer;
  qr: TIbQuery;
  sqls: string;
  tr: TIBTransaction;
begin
 fm:=TfmEditLicense.Create(nil);
 try
  fm.Caption:=captionAdd;
  fm.dtpDateLic.ShowCheckbox:=false;
  fm.btOk.OnClick:=fm.OkClick;
  if fm.ShowModal=mrOk then begin

    valname:=Trim(fm.edNum.Text);
    retval:=NumExists(valname,fm.NotID,ID);
    if retVal then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbNum.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('license_id',id,[loCaseInsensitive]);
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
     sqls:='Insert into '+TableLicense+' (not_id,num,datelic,kem) '+
           ' values ('+inttostr(fm.NotID)+','''+trim(fm.edNum.Text)+
           ''','''+DateToStr(fm.dtpDateLic.Date)+
           ''','''+trim(fm.edkem.Text)+''')';
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('num;not_id',VarArrayOf([valname,fm.NotID]),[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmLicense.bibChangeClick(Sender: TObject);
var
  fm: TfmEditLicense;
  RetVal: Boolean;
  valname: string;
  Id: Integer;
  qr: TIbQuery;
  sqls: string;
  tr: TIBTransaction;
begin
 if MainQr.RecordCount=0 then exit;
 fm:=TfmEditLicense.Create(nil);
 try
  fm.Caption:=captionChange;
  fm.dtpDateLic.ShowCheckbox:=false;
  fm.edNot.text:=Trim(MainQr.FieldByName('tnfio').AsString);
  fm.NotID:=MainQr.FieldByName('not_id').AsInteger;

  fm.edNum.Text:=trim(MainQr.FieldByName('num').AsString);
  fm.dtpDateLic.date:=MainQr.FieldByName('datelic').AsDateTime;
  fm.edKem.text:=Trim(MainQr.FieldByName('kem').AsString);

  fm.btOk.OnClick:=fm.OkClick;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    if not fm.ChangeFlag then exit;
    valname:=Trim(fm.edNum.Text);
    retval:=NumExists(valname,fm.NotId,Id);
    if (retVal)and(MainQr.FieldByName('license_id').AsInteger<>id) then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbNum.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('license_id',id,[loCaseInsensitive]);
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
     sqls:='Update '+TableLicense+' set '+
           ' not_id='+inttostr(fm.NotId)+
           ',num='''+trim(fm.edNum.Text)+
           ''',datelic='''+DateToStr(fm.dtpDateLic.Date)+
           ''',kem='''+trim(fm.edkem.Text)+
           ''' where license_id='+Mainqr.FieldByName('license_id').AsString;
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('num;not_id',VarArrayOf([valname,fm.NotID]),[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmLicense.bibDelClick(Sender: TObject);

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
     sqls:='Delete from '+TableLicense+' where license_id='+
          Mainqr.FieldByName('license_id').asString;
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
      ShowError(Application.Handle,'Лицензия <'+Mainqr.FieldByName('num').AsString+'> используется.');
    end;
  end;
end;

procedure TfmLicense.bibFilterClick(Sender: TObject);
var
  fm: TfmEditLicense;
  filstr: string;
begin
 fm:=TfmEditLicense.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.edNot.Color:=clWindow;
  fm.edNot.ReadOnly:=false;
  fm.bibNot.Enabled:=true;
  fm.dtpDateLic.ShowCheckbox:=true;
  fm.btOk.OnClick:=fm.filterClick;

  if Trim(FindNotName)<>'' then fm.edNot.Text:=FindNotName;
  if Trim(FindNum)<>'' then fm.edNum.Text:=FindNum;

  fm.dtpDateLic.DateTime:=FindDateLic;
  fm.dtpDateLic.Checked:=isFindDatelic;
  if Trim(FindKem)<>'' then fm.edKem.text:=FindKem;

  fm.cbInString.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindNotName:=Trim(fm.edNot.Text);
    isFindNotName:=Trim(FindNotName)<>'';
    FindNum:=Trim(fm.edNum.Text);
    isFindNum:=Trim(FindNum)<>'';

    FindDateLic:=fm.dtpDateLic.date;
    isFindDatelic:=fm.dtpDateLic.Checked;

    Findkem:=Trim(fm.edkem.Text);
    isFindKem:=Trim(Findkem)<>'';

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

procedure TfmLicense.bibPrintClick(Sender: TObject);
begin
  CreateWordTableByGrid(Grid,Caption);
end;

procedure TfmLicense.MR(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmLicense.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not isValidKey(Char(Key)) then exit;
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  MainQr.Locate(grid.SelectedField.FullName,Trim(edSearch.Text),
                [loPartialKey,loCaseInsensitive]);
end;

procedure TfmLicense.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfmLicense.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmLicense.GridTitleClick(Column: TColumn);
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
   if AnsiUpperCase(fn)='TNFIO' then fn:='tn.fio';
   id:=MainQr.fieldByName('license_id').asInteger;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   sqls:='Select tl.*, tn.fio as tnfio from '+TableLicense+
        ' tl join '+TableNotarius+' tn on tl.not_id=tn.not_id '+
         GetFilterString+' order by '+fn;
   MainQr.SQL.Add(sqls);      
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('license_id',id,[loCaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmLicense.FormDestroy(Sender: TObject);
begin
  Grid.Free;
  if fsCreatedMDIChild in FormState then
   fmLicense:=nil;
end;

procedure TfmLicense.SetImageFilter;
begin
  bibFilter.Glyph.Assign(nil);
  bibFilter.Glyph.Width:=dm.IlMain.Width;
  bibFilter.Glyph.Height:=dm.IlMain.Height;
  if isFindNotName or isFindNum or isFindDatelic or isFindKem then begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,0,true);
  end else begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,1,true);
  end;
end;

procedure TfmLicense.LoadFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    FindNotName:=fi.ReadString('RBLicense','NotName',FindNotName);
    FindNum:=fi.ReadString('RBLicense','Num',FindNum);
    FindKem:=fi.ReadString('RBLicense','Kem',FindKem);
    FindDateLic:=fi.ReadDate('RBLicense','DateLic',FindDateLic);
    isFindDatelic:=fi.ReadBool('RBLicense','isDateLic',isFindDateLic);
    FilterInside:=fi.ReadBool('RBLicense','Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

procedure TfmLicense.SaveFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteString('RBLicense','NotName',FindNotName);
    fi.WriteString('RBLicense','Num',FindNum);
    fi.WriteString('RBLicense','Kem',FindKem);
    fi.WriteDate('RBLicense','DateLic',FindDateLic);
    fi.WriteBool('RBLicense','isDateLic',isFindDateLic);
    fi.WriteBool('RBLicense','Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

procedure TfmLicense.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmLicense.MainqrAfterOpen(DataSet: TDataSet);
begin
  ViewCount;
end;

procedure TfmLicense.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  bibChangeClick(nil);
end;

function TfmLicense.NumExists(strName: String; tmpNotID: Integer; var ID: Integer): Boolean;
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
   sqls:='Select * from '+TableLicense+' where num='''+Trim(strName)+
         ''' and not_id='+inttostr(tmpNotID);
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.recordCount=1 then begin
     ID:=qr.FieldByName('license_id').ASInteger;
     Result:=true;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=CrDefault;
  end;
end;

procedure TfmLicense.FormKeyDown(Sender: TObject; var Key: Word;
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

function TfmLicense.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4: string;
  and1,and2,and3: string;
begin
    Result:='';

    isFindNotName:=Trim(FindNotName)<>'';
    isFindNum:=Trim(FindNum)<>'';
    isFindDatelic:=isFindDatelic;
    isFindKem:=Trim(FindKem)<>'';


    if isFindNotName or isFindNum or isFindDatelic or isFindKem then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindNotName then begin
        addstr1:=' Upper(tn.fio) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNotName+'%'))+' ';
     end;

     if isFindNum then begin
        addstr2:=' Upper(num) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNum+'%'))+' ';
     end;

     if isFindDatelic then begin
        addstr3:=' datelic='''+dateTostr(FindDateLic)+''' ';
     end;

     if isFindKem then begin
        addstr4:=' Upper(kem) like '+AnsiUpperCase(QuotedStr(FilInSide+FindKem+'%'))+' ';
     end;

     if (isFindNotName and isFindNum)or
        (isFindNotName and isFindDatelic)or
        (isFindNotName and isFindKem) then
      and1:=' and ';

     if (isFindNum and isFindDatelic)or
        (isFindNum and isFindKem) then
      and2:=' and ';

     if (isFindDatelic and isFindKem) then
      and3:=' and ';

      Result:=wherestr+addstr1+and1+
                       addstr2+and2+
                       addstr3+and3+
                       addstr4;

end;

procedure TfmLicense.FormResize(Sender: TObject);
begin
  edSearch.Width:=Self.Width-edSearch.Left-pnBut.Width-8;
end;

end.
