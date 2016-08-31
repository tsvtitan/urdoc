unit URBTypeReestr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  UEditTypeReestr, UNewDbGrids, inifiles, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db,IBDatabase, Variants;

type
  TfmTypeReestr = class(TForm)
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
    FindName: string;
    FindHint: string;
    FindFio: string;
    isFindName,isFindHint,isFindFio: Boolean;
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
    function TypeReestrNameExists(strName: String; NotId: Integer; var ID: Integer): Boolean;

  public
    Grid: TNewdbGrid;
    procedure MR(Sender: TObject);
    procedure ActiveQuery;
    procedure LoadFilter;
  end;

var
  fmTypeReestr: TfmTypeReestr;
   
implementation

uses Udm, UMain, URBUsers;

{$R *.DFM}

procedure TfmTypeReestr.FormCreate(Sender: TObject);
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

procedure TfmTypeReestr.ActiveQuery;
var
 sqls: String;
 cl: TColumn;
begin
  ds.DataSet:=nil;
  Mainqr.Active:=false;
  Mainqr.sql.Clear;
  sqls:='Select ttr.*,tn.fio as tnfio from '+TableTypeReestr+' ttr join '+
        TableNotarius+' tn on ttr.not_id=tn.not_id '+
        GetFilterString+' order by name';
  Mainqr.sql.Add(sqls);
  Mainqr.Active:=true;
  ds.DataSet:=Mainqr;
  SetImageFilter;
  ViewCount;
  if Grid.Columns.Count<>6 then begin
   cl:=Grid.Columns.Add;
   cl.FieldName:='Name';
   cl.Title.Caption:='������������';
   cl.Width:=150;

   cl:=Grid.Columns.Add;
   cl.FieldName:='tnfio';
   cl.Title.Caption:='��������';
   cl.Width:=220;

   cl:=Grid.Columns.Add;
   cl.FieldName:='Hint';
   cl.Title.Caption:='��������';
   cl.Width:=250;

   cl:=Grid.Columns.Add;
   cl.FieldName:='prefix';
   cl.Title.Caption:='�������';
   cl.Width:=50;

   cl:=Grid.Columns.Add;
   cl.FieldName:='sufix';
   cl.Title.Caption:='�������';
   cl.Width:=50;

   cl:=Grid.Columns.Add;
   cl.FieldName:='sortnum';
   cl.Title.Caption:='�������';
   cl.Width:=50;
  end;
end;

procedure TfmTypeReestr.bibAddClick(Sender: TObject);
var
  fm: TfmEditTypeReestr;
  qr: TIBQuery;
  RetVal: Boolean;
  valname: string;
  sqls: string;
  id: Integer;
  tr: TIBTransaction;
begin
 fm:=TfmEditTypeReestr.Create(nil);
 try
  fm.Caption:=captionAdd;
  fm.BibOk.OnClick:=fm.OkClick;
  if fm.ShowModal=mrOk then begin

    valname:=Trim(fm.edName.Text);
    retval:=TypeReestrNameExists(valname,fm.NotID,id);
    if retVal then begin
      ShowError(Application.handle,'�������� <'+valname+'> '+#13+
               '� ���� <'+fm.lbname.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('typereestr_id',id,[loCaseInsensitive]);         
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
     sqls:='Insert into '+TableTypeReestr+' (name,hint,not_id,prefix,sufix,sortnum) '+
           ' values ('''+valname+
           ''','''+Trim(fm.meHint.Lines.Text)+
           ''','+inttostr(fm.NotID)+
           ','''+Trim(fm.edPrefix.Text)+
           ''','''+Trim(fm.edSufix.Text)+
           ''','+iff(Trim(fm.edSortNum.Text)<>'',Trim(fm.edSortNum.Text),'null')+
           ')';
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('name;not_id',VarArrayOf([valname,fm.NotID]),[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmTypeReestr.bibChangeClick(Sender: TObject);
var
  fm: TfmEditTypeReestr;
  qr: TIBQuery;
  RetVal: Boolean;
  valname: string;
  id: Integer;
  sqls: string;
  tr: TIBTransaction;
begin
 if MainQr.RecordCount=0 then exit;
 fm:=TfmEditTypeReestr.Create(nil);
 try
  fm.Caption:=captionChange;
  fm.NotID:=MainQr.FieldByName('not_id').AsInteger;
  fm.edNot.Text:=Trim(MainQr.FieldByName('tnfio').AsString);
  fm.edName.text:=Trim(MainQr.FieldByName('name').AsString);
  fm.meHint.Lines.Text:=Trim(MainQr.FieldByName('hint').AsString);
  fm.edPrefix.Text:=Trim(MainQr.FieldByName('prefix').AsString);
  fm.edSufix.Text:=Trim(MainQr.FieldByName('sufix').AsString);
  fm.edSortNum.Text:=Trim(MainQr.FieldByName('sortnum').AsString);
  fm.bibOk.OnClick:=fm.OkClick;
  fm.ChangeFlag:=false;
  
  if fm.ShowModal=mrOk then begin

    if not fm.ChangeFlag then exit;
    valname:=Trim(fm.edName.Text);
    retval:=TypeReestrNameExists(valname,fm.NotId,Id);
    if (retVal)and(MainQr.FieldByName('typereestr_id').AsInteger<>id) then begin
      ShowError(Application.handle,'�������� <'+valname+'> '+#13+
               '� ���� <'+fm.lbname.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('typereestr_id',id,[loCaseInsensitive]);         
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
     sqls:='Update '+TableTypeReestr+
           ' set name='''+valname+''', hint='''+Trim(fm.meHint.Lines.Text)+
           ''', not_id='+inttostr(fm.NotID)+
           ', prefix='+QuotedStr(Trim(fm.edPrefix.Text))+
           ', sufix='+QuotedStr(Trim(fm.edSufix.Text))+
           ', sortnum='+iff(Trim(fm.edSortNum.Text)<>'',Trim(fm.edSortNum.Text),'null')+
           ' where typereestr_id='+inttostr(MainQr.FieldByName('typereestr_id').AsInteger);
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
    finally
     qr.Free;
     tr.Free;
     Mainqr.Active:=false;
     Mainqr.Active:=true;
     Mainqr.Locate('name;not_id',VarArrayOf([valname,fm.NotID]),[loCaseInsensitive]);
     ViewCount;
     Screen.Cursor:=crDefault;
    end;
  end;
 finally
  fm.Free;
 end;             
end;

procedure TfmTypeReestr.bibDelClick(Sender: TObject);

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
     sqls:='Delete from '+TableTypeReestr+' where typereestr_id='+
          Mainqr.FieldByName('typereestr_id').asString;
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
  mr:=MessageDlg('������� ?',mtConfirmation,[mbYes,mbNo],-1);

//  but:=MessageBox(Handle,Pchar('������� ?'),'��������������',MB_YESNO+MB_ICONWARNING);
  if mr=mrYes then begin
    if not deleteRecord then begin
      ShowError(Application.Handle,'������ <'+Mainqr.FieldByName('name').AsString+'> ������������.');
    end;
  end;
end;

procedure TfmTypeReestr.bibFilterClick(Sender: TObject);
var
  fm: TfmEditTypeReestr;
  filstr: string;
begin
 fm:=TfmEditTypeReestr.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.edNot.Color:=clWindow;
  fm.edNot.ReadOnly:=false;
  fm.bibNot.Enabled:=true;
  fm.edPrefix.Enabled:=false;
  fm.lbPrefix.Enabled:=false;
  fm.edSufix.Enabled:=false;
  fm.lbSufix.Enabled:=false;
  fm.lbSortNum.Enabled:=false;
  fm.edSortNum.Enabled:=false;
  fm.edSortNum.Color:=clBtnFace;
  fm.bibOk.OnClick:=fm.filterClick;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindHint)<>'' then fm.meHint.Lines.Text:=FindHint;
  if Trim(FindFio)<>'' then fm.edNot.Text:=FindFio;

  fm.cbInString.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindName:=Trim(fm.edName.Text);
    isFindName:=Trim(FindName)<>'';
    FindHint:=Trim(fm.meHint.Lines.Text);
    isFindHint:=Trim(FindHint)<>'';
    FindFio:=Trim(fm.edNot.Text);
    isFindFio:=Trim(FindFio)<>'';

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

procedure TfmTypeReestr.bibPrintClick(Sender: TObject);
begin
  CreateWordTableByGrid(Grid,Caption);
end;

procedure TfmTypeReestr.MR(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmTypeReestr.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not isValidKey(Char(Key)) then exit;
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  MainQr.Locate(grid.SelectedField.FullName,Trim(edSearch.Text),
                [loPartialKey,loCaseInsensitive]);
end;

procedure TfmTypeReestr.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfmTypeReestr.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmTypeReestr.GridTitleClick(Column: TColumn);
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
   id:=MainQr.fieldByName('typereestr_id').asInteger;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   sqls:='Select ttr.*,tn.fio as tnfio from '+TableTypeReestr+' ttr join '+
        TableNotarius+' tn on ttr.not_id=tn.not_id '+
        GetFilterString+' order by '+fn;
   Mainqr.sql.Add(sqls);
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('typereestr_id',id,[loCaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmTypeReestr.FormDestroy(Sender: TObject);
begin
  Grid.Free;
  if fsCreatedMDIChild in FormState then
   fmTypeReestr:=nil;
end;

procedure TfmTypeReestr.SetImageFilter;
begin
  bibFilter.Glyph.Assign(nil);
  bibFilter.Glyph.Width:=dm.IlMain.Width;
  bibFilter.Glyph.Height:=dm.IlMain.Height;
  if isFindName or isFindHint or isFindFio then begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,0,true);
  end else begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,1,true);
  end;
end;

procedure TfmTypeReestr.LoadFilter;
var
  fi: TIniFile;
begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  try
    FindName:=fi.ReadString('RBTypeReestr','Name',FindName);
    FindHint:=fi.ReadString('RBTypeReestr','Hint',FindHint);
    FindFIO:=fi.ReadString('RBTypeReestr','FIO',FindFIO);
    FilterInside:=fi.ReadBool('RBTypeReestr','Inside',FilterInside);
  finally
   fi.Free;
  end;
 except
 end; 
end;

procedure TfmTypeReestr.SaveFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteString('RBTypeReestr','Name',FindName);
    fi.WriteString('RBTypeReestr','Hint',FindHint);
    fi.WriteString('RBTypeReestr','FIO',FindFIO);
    fi.WriteBool('RBTypeReestr','Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

function TfmTypeReestr.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3: string;
  and1,and2: string;
begin
    Result:='';

    isFindName:=Trim(FindName)<>'';
    isFindHint:=Trim(FindHint)<>'';
    isFindFio:=Trim(FindFio)<>'';

    if isFindName or isFindHint or isFindFio then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindHint then begin
        addstr2:=' Upper(hint) like '+AnsiUpperCase(QuotedStr(FilInSide+FindHint+'%'))+' ';
     end;

     if isFindFio then begin
        addstr3:=' Upper(tn.fio) like '+AnsiUpperCase(QuotedStr(FilInSide+FindFio+'%'))+' ';
     end;


     if (isFindName and isFindHint) or
        (isFindName and isFindFio)
        then
      and1:=' and ';

     if (isFindHint and isFindFio)
        then
      and2:=' and ';


     Result:=wherestr+addstr1+and1+addstr2+and2+addstr3;

end;

procedure TfmTypeReestr.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmTypeReestr.MainqrAfterOpen(DataSet: TDataSet);
begin
  ViewCount;
end;

procedure TfmTypeReestr.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
end;

procedure TfmTypeReestr.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  bibChangeClick(nil);
end;

function TfmTypeReestr.TypeReestrNameExists(strName: String; NotId: Integer; var ID: Integer): Boolean;
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
   sqls:='Select * from '+TableTypeReestr+' where name='''+Trim(strName)+''''+
         ' and not_id='+inttostr(NotId);
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.recordCount=1 then begin
     ID:=qr.FieldByName('typereestr_id').ASInteger;
     Result:=true;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=CrDefault;
  end;
end;

procedure TfmTypeReestr.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfmTypeReestr.FormResize(Sender: TObject);
begin
  edSearch.Width:=Self.Width-edSearch.Left-pnBut.Width-8;
end;

end.
