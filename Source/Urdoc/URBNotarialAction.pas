unit URBNotarialAction;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
   UNewDbGrids, inifiles, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db,IBDatabase;

type
  TfmRBNotarialAction = class(TForm)
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
    il: TImageList;
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
    isFindName,isFindHint: Boolean;
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
    function NotarialActionNameExists(strName: String; var ID: Integer): Boolean;

  public
    Grid: TNewdbGrid;
    procedure MR(Sender: TObject);
    procedure ActiveQuery;
    procedure LoadFilter;
  end;

var
  fmRBNotarialAction: TfmRBNotarialAction;
   
implementation

uses Udm, UMain, UEditNotarialAction;

{$R *.DFM}

procedure TfmRBNotarialAction.FormCreate(Sender: TObject);
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

procedure TfmRBNotarialAction.ActiveQuery;
var
 sqls: String;
 cl: TColumn;
begin
  ds.DataSet:=nil;
  Mainqr.Active:=false;
  Mainqr.sql.Clear;
  sqls:='Select * from '+TableNotarialAction+GetFilterString+' order by fieldsort';
  Mainqr.sql.Add(sqls);
  Mainqr.Active:=true;
  ds.DataSet:=Mainqr;
  SetImageFilter;
  ViewCount;
  if Grid.Columns.Count<>6 then begin
   cl:=Grid.Columns.Add;
   cl.FieldName:='Name';
   cl.Title.Caption:='Наименование';
   cl.Width:=280;

   cl:=Grid.Columns.Add;
   cl.FieldName:='Hint';
   cl.Title.Caption:='Описание';
   cl.Width:=350;

   cl:=Grid.Columns.Add;
   cl.FieldName:='usenoyearplus';
   cl.Title.Caption:='Использовать с н/летними';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='usedefectplus';
   cl.Title.Caption:='Использовать с физ.недостатками';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='viewhereditaryplus';
   cl.Title.Caption:='Использовать с наследством';
   cl.Width:=100;
   
   cl:=Grid.Columns.Add;
   cl.FieldName:='percent';
   cl.Title.Caption:='Процент от суммы норма';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='fieldsort';
   cl.Title.Caption:='Порядок сортировки в форме';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='viewinformplus';
   cl.Title.Caption:='Показывать в форме';
   cl.Width:=100;


  end;
end;

procedure TfmRBNotarialAction.bibAddClick(Sender: TObject);
var
  fm: TfmEditNotarialAction;
  qr: TIBQuery;
  RetVal: Boolean;
  valname: string;
  sqls: string;
  id: Integer;
  tr: TIBTransaction;
begin
 fm:=TfmEditNotarialAction.Create(nil);
 try
  fm.Caption:=captionAdd;
  fm.btOk.OnClick:=fm.OkClick;
  if fm.ShowModal=mrOk then begin

    valname:=Trim(fm.edName.Text);
    retval:=NotarialActionNameExists(valname,id);
    if retVal then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbname.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('notarialaction_id',id,[loCaseInsensitive]);         
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
     sqls:='Insert into '+TableNotarialAction+
           ' (name,hint,usenoyear,usedefect,percent,fieldsort,viewinform,viewhereditary) '+
           ' values ('+
           QuotedStr(Trim(valname))+','+
           QuotedStr(Trim(fm.meHint.Lines.Text))+','+
           GetStrFromCondition(fm.chbUseNoYear.Checked,'1','0')+','+
           GetStrFromCondition(fm.chbUseDefect.Checked,'1','0')+','+
           GetStrFromCondition(Trim(fm.edPercent.Text)<>'',ChangeChar(fm.edPercent.Text,',','.'),'null')+','+
           QuotedStr(Trim(fm.edFieldSort.Text))+','+
           GetStrFromCondition(fm.chbViewInForm.Checked,'1','0')+','+
           GetStrFromCondition(fm.chbViewHereditary.Checked,'1','0')+
           ')';
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

procedure TfmRBNotarialAction.bibChangeClick(Sender: TObject);
var
  fm: TfmEditNotarialAction;
  qr: TIBQuery;
  RetVal: Boolean;
  valname: string;
  id: Integer;
  sqls: string;
  tr: TIBTransaction;
begin
 if MainQr.RecordCount=0 then exit;
 fm:=TfmEditNotarialAction.Create(nil);
 try
  fm.Caption:=captionChange;
  fm.edName.text:=Trim(MainQr.FieldByName('name').AsString);
  fm.meHint.Lines.Text:=Trim(MainQr.FieldByName('hint').AsString);
  fm.chbUseNoYear.Checked:=Boolean(MainQr.FieldByName('usenoyear').AsInteger);
  fm.chbUsedefect.Checked:=Boolean(MainQr.FieldByName('usedefect').AsInteger);
  fm.edPercent.Text:=MainQr.FieldByName('percent').AsString;
  fm.edFieldSort.Text:=MainQr.FieldByName('fieldsort').AsString;
  fm.chbViewInForm.Checked:=Boolean(MainQr.FieldByName('viewinform').AsInteger);
  fm.chbViewHereditary.Checked:=Boolean(MainQr.FieldByName('viewhereditary').AsInteger);

  fm.btOk.OnClick:=fm.OkClick;
  fm.ChangeFlag:=false;
  
  if fm.ShowModal=mrOk then begin

    if not fm.ChangeFlag then exit;
    valname:=Trim(fm.edName.Text);
    retval:=NotarialActionNameExists(valname,Id);
    if (retVal)and(MainQr.FieldByName('notarialaction_id').AsInteger<>id) then begin
      ShowError(Application.handle,'Значение <'+valname+'> '+#13+
               'в поле <'+fm.lbname.Caption+'>'+#13+
               valuePresent);
      MainQr.Locate('notarialaction_id',id,[loCaseInsensitive]);
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
     sqls:='Update '+TableNotarialAction+
           ' set name='+QuotedStr(Trim(valname))+
           ', hint='+QuotedStr(Trim(fm.meHint.Lines.Text))+
           ', usenoyear='+GetStrFromCondition(fm.chbUseNoYear.Checked,'1','0')+
           ', usedefect='+GetStrFromCondition(fm.chbUseDefect.Checked,'1','0')+
           ', fieldsort='+QuotedStr(Trim(fm.edFieldSort.Text))+
           ', percent='+GetStrFromCondition(Trim(fm.edPercent.Text)<>'',ChangeChar(fm.edPercent.Text,',','.'),'null')+
           ', viewinform='+GetStrFromCondition(fm.chbViewInForm.Checked,'1','0')+
           ', viewhereditary='+GetStrFromCondition(fm.chbViewHereditary.Checked,'1','0')+
           ' where notarialaction_id='+inttostr(MainQr.FieldByName('notarialaction_id').AsInteger);

     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
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

procedure TfmRBNotarialAction.bibDelClick(Sender: TObject);

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
     sqls:='Delete from '+TableNotarialAction+' where notarialaction_id='+
          Mainqr.FieldByName('notarialaction_id').asString;
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
      ShowError(Application.Handle,'Нотариальное действие <'+Mainqr.FieldByName('name').AsString+'> используется.');
    end;
  end;
end;

procedure TfmRBNotarialAction.bibFilterClick(Sender: TObject);
var
  fm: TfmEditNotarialAction;
  filstr: string;
begin
 fm:=TfmEditNotarialAction.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.chbUseNoYear.Enabled:=false;
  fm.chbUsedefect.Enabled:=false;
  fm.lbPercent.Enabled:=false;
  fm.edPercent.Enabled:=false;
  fm.edPercent.Color:=clBtnFace;
  fm.lbFieldSort.Enabled:=false;
  fm.edFieldSort.Enabled:=false;
  fm.edFieldSort.Color:=clBtnFace;
  fm.chbViewInForm.Enabled:=false;
  fm.chbViewHereditary.Enabled:=false;
  fm.btOk.OnClick:=fm.filterClick;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindHint)<>'' then fm.meHint.Lines.Text:=FindHint;

  fm.cbInString.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindName:=Trim(fm.edName.Text);
    isFindName:=Trim(FindName)<>'';
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

procedure TfmRBNotarialAction.MR(Sender: TObject);
begin
  if MainQr.RecordCount=0 then exit;
  ModalResult:=mrOk;
end;

procedure TfmRBNotarialAction.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  fn: string;
begin
  if not isValidKey(Char(Key)) then exit;
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  fn:=grid.SelectedField.FullName;
  if AnsiUpperCase(fn)=AnsiUpperCase('usenoyearplus') then fn:='usenoyear';
  if AnsiUpperCase(fn)=AnsiUpperCase('usedefectplus') then fn:='usedefect';
  if AnsiUpperCase(fn)=AnsiUpperCase('viewinformplus') then fn:='viewinform';
  if AnsiUpperCase(fn)=AnsiUpperCase('viewhereditaryplus') then fn:='viewhereditary';
  MainQr.Locate(fn,Trim(edSearch.Text),
                [loPartialKey,loCaseInsensitive]);
end;

procedure TfmRBNotarialAction.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfmRBNotarialAction.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmRBNotarialAction.GridTitleClick(Column: TColumn);
var
  fn: string;
  id: integer;
begin
  if not MainQr.Active then exit;
  if MainQr.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
  if AnsiUpperCase(fn)=AnsiUpperCase('usenoyearplus') then fn:='usenoyear';
  if AnsiUpperCase(fn)=AnsiUpperCase('usedefectplus') then fn:='usedefect';
  if AnsiUpperCase(fn)=AnsiUpperCase('viewinformplus') then fn:='viewinform';
  if AnsiUpperCase(fn)=AnsiUpperCase('viewhereditaryplus') then fn:='viewhereditary';

   id:=MainQr.fieldByName('notarialaction_id').asInteger;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   MainQr.SQL.Add('Select * from '+TableNotarialAction+GetFilterString+' Order by '+fn);
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('notarialaction_id',id,[loCaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmRBNotarialAction.FormDestroy(Sender: TObject);
begin
  Grid.Free;
  if fsCreatedMDIChild in FormState then
   fmRBNotarialAction:=nil;
end;

procedure TfmRBNotarialAction.SetImageFilter;
begin
  bibFilter.Glyph.Assign(nil);
  bibFilter.Glyph.Width:=dm.IlMain.Width;
  bibFilter.Glyph.Height:=dm.IlMain.Height;
  if isFindName or isFindHint then begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,0,true);
  end else begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,1,true);
  end;
end;

procedure TfmRBNotarialAction.LoadFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    FindName:=fi.ReadString(ClassName,'Name',FindName);
    FindHint:=fi.ReadString(ClassName,'Hint',FindHint);
    FilterInside:=fi.ReadBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

procedure TfmRBNotarialAction.SaveFilter;
var
  fi: TIniFile;
begin
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteString(ClassName,'Name',FindName);
    fi.WriteString(ClassName,'Hint',FindHint);
    fi.WriteBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
end;

function TfmRBNotarialAction.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:='';

    isFindName:=Trim(FindName)<>'';
    isFindHint:=Trim(FindHint)<>'';

    if isFindName or isFindHint then begin
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

     if (isFindName and isFindHint) then
      and1:=' and ';

     Result:=wherestr+addstr1+and1+addstr2;

end;

procedure TfmRBNotarialAction.ViewCount;
begin
 if MainQr.Active then
  lbCount.Caption:=ViewCountText+inttostr(GetRecordCount(Mainqr));
end;

procedure TfmRBNotarialAction.MainqrAfterOpen(DataSet: TDataSet);
begin
  ViewCount;
end;

procedure TfmRBNotarialAction.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);

  procedure DrawPlusOne;
  var
    chk: Boolean;
    x: Integer;
  begin
    chk:=Mainqr.FieldByName('usenoyear').AsString='1';
    x:=rect.Left+(rect.Right-rect.Left) div 2;
    if not chk then Begin
     il.Draw(grid.Canvas,x-il.Width div 2,rect.Top,0,true);
    end else begin
     il.Draw(grid.Canvas,x-il.Width div 2,rect.Top,1,true);
    end;
  end;

  procedure DrawPlusTwo;
  var
    chk: Boolean;
    x: Integer;
  begin
    chk:=Mainqr.FieldByName('usedefect').AsString='1';
    x:=rect.Left+(rect.Right-rect.Left) div 2;
    if not chk then Begin
     il.Draw(grid.Canvas,x-il.Width div 2,rect.Top,0,true);
    end else begin
     il.Draw(grid.Canvas,x-il.Width div 2,rect.Top,1,true);
    end;
  end;

  procedure DrawPlusTwoEx;
  var
    chk: Boolean;
    x: Integer;
  begin
    chk:=Mainqr.FieldByName('viewhereditary').AsString='1';
    x:=rect.Left+(rect.Right-rect.Left) div 2;
    if not chk then Begin
     il.Draw(grid.Canvas,x-il.Width div 2,rect.Top,0,true);
    end else begin
     il.Draw(grid.Canvas,x-il.Width div 2,rect.Top,1,true);
    end;
  end;

  procedure DrawPlusThree;
  var
    chk: Boolean;
    x: Integer;
  begin
    chk:=Mainqr.FieldByName('viewinform').AsString='1';
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
  if column.Title.Caption='Использовать с н/летними' then begin
    DrawPlusOne;
  end;
  if column.Title.Caption='Использовать с физ.недостатками' then begin
    DrawPlusTwo;
  end;
  if column.Title.Caption='Использовать с наследством' then begin
    DrawPlusTwoEx;
  end;
  if column.Title.Caption='Показывать в форме' then begin
    DrawPlusThree;
  end;
end;

procedure TfmRBNotarialAction.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  bibChangeClick(nil);
end;

function TfmRBNotarialAction.NotarialActionNameExists(strName: String; var ID: Integer): Boolean;
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
   sqls:='Select * from '+TableNotarialAction+' where name='''+Trim(strName)+'''';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.recordCount=1 then begin
     ID:=qr.FieldByName('notarialaction_id').ASInteger;
     Result:=true;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=CrDefault;
  end;
end;

procedure TfmRBNotarialAction.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfmRBNotarialAction.FormResize(Sender: TObject);
begin
  edSearch.Width:=Self.Width-edSearch.Left-pnBut.Width-8;
end;

procedure TfmRBNotarialAction.bibPrintClick(Sender: TObject);
begin
  CreateWordTableByGrid(Grid,Caption);
end;

end.
