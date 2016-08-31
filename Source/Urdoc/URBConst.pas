unit URBConst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
   UNewDbGrids, inifiles, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db,IBDatabase;

type
  TfmConst = class(TForm)
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
    FindValue,FindRenovation: string;
    isFindName,isFindHint,isFindValue,isFindRenovation: Boolean;
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
    function ConstNameExists(strName: String; var ID: Integer; RenovationID: Integer): Boolean;

  public
    Grid: TNewdbGrid;
    procedure MR(Sender: TObject);
    procedure ActiveQuery;
    procedure LoadFilter;
  end;

var
  fmConst: TfmConst;
   
implementation

uses Udm, UMain, URBUsers, UEditConst;

{$R *.DFM}

procedure TfmConst.FormCreate(Sender: TObject);
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

procedure TfmConst.ActiveQuery;
var
 sqls: String;
 cl: TColumn;
begin
  ds.DataSet:=nil;
  Mainqr.Active:=false;
  Mainqr.sql.Clear;
  sqls:='Select c.*, r.name as renovationname from '+TableConst+
        ' c left join '+TableRenovation+' r on c.renovation_id=r.renovation_id '+
        GetFilterString+' order by c.name';
  Mainqr.sql.Add(sqls);
  Mainqr.Active:=true;
  ds.DataSet:=Mainqr;
  SetImageFilter;
  ViewCount;
  if Grid.Columns.Count<>6 then begin

   cl:=Grid.Columns.Add;
   cl.FieldName:='Name';
   cl.Title.Caption:='Наименование';
   cl.Width:=150;

   cl:=Grid.Columns.Add;
   cl.FieldName:='renovationname';
   cl.Title.Caption:='Обновление';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='val';
   cl.Title.Caption:='Значение для нотариуса';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='valplus';
   cl.Title.Caption:='Значение для помощника нотариуса';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='Hint';
   cl.Title.Caption:='Описание';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='priority';
   cl.Title.Caption:='Приоритет';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='style';
   cl.Title.Caption:='Стиль';
   cl.Width:=150;

  end;
end;

procedure TfmConst.bibAddClick(Sender: TObject);
var
  fm: TfmEditConst;
  qr: TIBQuery;
  RetVal: Boolean;
  valname: string;
  sqls: string;
  id: Integer;
  tr: TIBTransaction;
begin
 fm:=TfmEditConst.Create(nil);
 try
  fm.Caption:=captionAdd;
  fm.btOk.OnClick:=fm.OkClick;
  if fm.ShowModal=mrOk then begin

    valname:=Trim(fm.edName.Text);
    retval:=ConstNameExists(valname,id,fm.edRenovation.Tag);
    if retVal then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbname.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('const_id',id,[loCaseInsensitive]);         
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
     sqls:='Insert into '+TableConst+' (name,val,valplus,priority,hint,autoformat,style,renovation_id) '+
           ' values ('''+valname+
           ''','+QuotedStr(fm.mevalue.Lines.Text)+
           ','+QuotedStr(fm.mevalplus.Lines.Text)+
           ','+inttostr(fm.udPriority.Position)+
           ','''+Trim(fm.meHint.Lines.Text)+
           ''','+IntToStr(Integer(fm.chbAutoFormat.Checked))+
           ','+QuotedStr(fm.cmbStyle.Text)+
           ','+iff(Trim(fm.edRenovation.Text)<>'',inttostr(fm.edRenovation.Tag),'null')+')';
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

procedure TfmConst.bibChangeClick(Sender: TObject);
var
  fm: TfmEditConst;
  qr: TIBQuery;
  RetVal: Boolean;
  valname: string;
  id: Integer;
  sqls: string;
  tr: TIBTransaction;
begin
 if MainQr.RecordCount=0 then exit;
 fm:=TfmEditConst.Create(nil);
 try
  fm.Caption:=captionChange;
  fm.edName.text:=Trim(MainQr.FieldByName('name').AsString);
  fm.mevalue.Lines.Text:=MainQr.FieldByName('val').AsString;
  fm.mevalplus.Lines.Text:=MainQr.FieldByName('valplus').AsString;
  fm.meHint.Lines.Text:=Trim(MainQr.FieldByName('hint').AsString);
  fm.udPriority.Position:=MainQr.FieldByName('priority').AsInteger;
  fm.chbAutoFormat.Checked:=Boolean(MainQr.FieldByName('autoformat').AsInteger);
  fm.cmbStyle.Text:=MainQr.FieldByName('style').AsString;
  fm.edRenovation.Text:=MainQr.FieldByName('renovationname').AsString;
  fm.edRenovation.Tag:=MainQr.FieldByName('renovation_id').AsInteger;
  fm.btOk.OnClick:=fm.OkClick;
  fm.ChangeFlag:=false;
  
  if fm.ShowModal=mrOk then begin

    if not fm.ChangeFlag then exit;
    valname:=Trim(fm.edName.Text);
    retval:=ConstNameExists(valname,Id,fm.edRenovation.Tag);
    if (retVal)and(MainQr.FieldByName('const_id').AsInteger<>id) then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbname.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('const_id',id,[loCaseInsensitive]);         
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
      sqls:='Update '+TableConst+
           ' set name='''+valname+
           ''', val='+QuotedStr(fm.mevalue.Lines.Text)+
           ', valplus='+QuotedStr(fm.mevalplus.Lines.Text)+
           ', hint='''+Trim(fm.meHint.Lines.Text)+
           ''', priority='+inttostr(fm.udPriority.Position)+
           ', autoformat='+IntToStr(Integer(fm.chbAutoFormat.Checked))+
           ', style='+QuotedStr(fm.cmbStyle.Text)+
           ', renovation_id='+iff(Trim(fm.edRenovation.Text)<>'',inttostr(fm.edRenovation.Tag),'null')+
           ' where const_id='+inttostr(MainQr.FieldByName('const_id').AsInteger);
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

procedure TfmConst.bibDelClick(Sender: TObject);

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    sqls: string;
    tr: TIBTransaction;
  begin
   result:=false;
   Screen.Cursor:=crHourGlass;
   tr:=TIBTransaction.Create(nil);
   qr:=TIBQuery.Create(nil);
   try
    try

     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+TableConst+' where const_id='+
          Mainqr.FieldByName('const_id').asString;
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
      ShowError(Application.Handle,'Константа <'+Mainqr.FieldByName('name').AsString+'> используется.');
    end;
  end;
end;

procedure TfmConst.bibFilterClick(Sender: TObject);
var
  fm: TfmEditConst;
  filstr: string;
begin
 fm:=TfmEditConst.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.meValPlus.Enabled:=false;
  fm.meValPlus.Color:=clBtnFace;
  fm.lbValPlus.Enabled:=false;
  fm.edPriority.Enabled:=false;
  fm.edPriority.Color:=clBtnFace;
  fm.udPriority.Enabled:=false;
  fm.chbAutoFormat.Enabled:=false;
  fm.lbStyle.Enabled:=false;
  fm.cmbStyle.Enabled:=false;
  fm.cmbStyle.Color:=clBtnFace;
  fm.edRenovation.ReadOnly:=false;
  fm.edRenovation.Color:=clWindow;
  
  fm.btOk.OnClick:=fm.filterClick;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindValue)<>'' then fm.meValue.Lines.Text:=FindValue;
  if Trim(FindHint)<>'' then fm.meHint.Lines.Text:=FindHint;
  if Trim(FindRenovation)<>'' then fm.edRenovation.Text:=FindRenovation;

  fm.cbInString.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindName:=Trim(fm.edName.Text);
    isFindName:=Trim(FindName)<>'';
    FindHint:=Trim(fm.meHint.Lines.Text);
    isFindHint:=Trim(FindHint)<>'';
    FindValue:=Trim(fm.meValue.Lines.Text);
    isFindValue:=Trim(FindValue)<>'';
    FindRenovation:=Trim(fm.edRenovation.Text);
    isFindRenovation:=Trim(FindRenovation)<>'';

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

procedure TfmConst.MR(Sender: TObject);
begin
  if MainQr.RecordCount=0 then exit;
  ModalResult:=mrOk;
end;

procedure TfmConst.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not isValidKey(Char(Key)) then exit;
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  MainQr.Locate(grid.SelectedField.FullName,Trim(edSearch.Text),
                [loPartialKey,loCaseInsensitive]);
end;

procedure TfmConst.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfmConst.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmConst.GridTitleClick(Column: TColumn);
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
   if AnsiUpperCase(fn)=AnsiUpperCase('val') then exit;
   if AnsiUpperCase(fn)=AnsiUpperCase('valplus') then exit;
   if AnsiUpperCase(fn)=AnsiUpperCase('name') then fn:='c.name';
   if AnsiUpperCase(fn)=AnsiUpperCase('renovationname') then fn:='r.name';
   id:=MainQr.fieldByName('const_id').asInteger;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   sqls:='Select c.*, r.name as renovationname from '+TableConst+
        ' c left join '+TableRenovation+' r on c.renovation_id=r.renovation_id '+
        GetFilterString+' order by '+fn;
   MainQr.SQL.Add(sqls);
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('const_id',id,[loCaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmConst.FormDestroy(Sender: TObject);
begin
  Grid.Free;
  if fsCreatedMDIChild in FormState then
   fmConst:=nil;
end;

procedure TfmConst.SetImageFilter;
begin
  bibFilter.Glyph.Assign(nil);
  bibFilter.Glyph.Width:=dm.IlMain.Width;
  bibFilter.Glyph.Height:=dm.IlMain.Height;
  if isFindName or isFindHint or isFindValue or isFindRenovation then begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,0,true);
  end else begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,1,true);
  end;
end;

procedure TfmConst.LoadFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    FindName:=fi.ReadString(ClassName,'Name',FindName);
    FindValue:=fi.ReadString(ClassName,'Value',FindValue);
    FindHint:=fi.ReadString(ClassName,'Hint',FindHint);
    FindRenovation:=fi.ReadString(ClassName,'Renovation',FindRenovation);
    FilterInside:=fi.ReadBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

procedure TfmConst.SaveFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteString(ClassName,'Name',FindName);
    fi.WriteString(ClassName,'Value',FindValue);
    fi.WriteString(ClassName,'Hint',FindHint);
    fi.WriteString(ClassName,'Renovation',FindRenovation);
    fi.WriteBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

function TfmConst.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4: string;
  and1,and2,and3: string;
begin
    Result:='';

    isFindName:=Trim(FindName)<>'';
    isFindValue:=Trim(FindValue)<>'';
    isFindHint:=Trim(FindHint)<>'';
    isFindRenovation:=Trim(FindRenovation)<>'';

    if isFindName or isFindHint or isFindValue or isFindRenovation then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(c.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindValue then begin
        addstr2:=' Upper(val) like '+AnsiUpperCase(QuotedStr(FilInSide+FindValue+'%'))+' ';
     end;

     if isFindHint then begin
        addstr3:=' Upper(hint) like '+AnsiUpperCase(QuotedStr(FilInSide+FindHint+'%'))+' ';
     end;

     if isFindRenovation then begin
        addstr4:=' Upper(r.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindRenovation+'%'))+' ';
     end;

     if (isFindName and isFindHint)or
        (isFindName and  isFindValue)or
        (isFindName and isFindRenovation) then
      and1:=' and ';

     if (isFindHint and  isFindValue)or
        (isFindHint and isFindRenovation) then
      and2:=' and ';

     if (isFindValue and isFindRenovation) then
      and3:=' and ';

     Result:=wherestr+addstr1+and1+addstr2+and2+addstr3+and3+addstr4;

end;

procedure TfmConst.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmConst.MainqrAfterOpen(DataSet: TDataSet);
begin
  ViewCount;
end;

procedure TfmConst.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
end;

procedure TfmConst.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  bibChangeClick(nil);
end;

function TfmConst.ConstNameExists(strName: String; var ID: Integer; RenovationID: Integer): Boolean;
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
   sqls:='Select * from '+TableConst+' where name='+QuotedStr(Trim(strName))+
         iff(RenovationID<>0,' and renovation_id='+inttostr(RenovationID),'');
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.recordCount=1 then begin
     ID:=qr.FieldByName('const_id').ASInteger;
     Result:=true;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=CrDefault;
  end;
end;

procedure TfmConst.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfmConst.FormResize(Sender: TObject);
begin
  edSearch.Width:=Self.Width-edSearch.Left-pnBut.Width-8;
end;

procedure TfmConst.bibPrintClick(Sender: TObject);
begin
  CreateWordTableByGrid(Grid,Caption);
end;

end.
