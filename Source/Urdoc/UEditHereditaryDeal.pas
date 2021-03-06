unit UEditHereditaryDeal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, RxMemDS, UNewDbGrids, Db, dBGrids, IBQuery,
  IBDataBase, IBCustomDataSet, Variants;

type
  TfmEditHereditaryDeal = class(TForm)
    lbFio: TLabel;
    edFio: TEdit;
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    pc: TPageControl;
    cbInString: TCheckBox;
    tsDocum: TTabSheet;
    tsReestr: TTabSheet;
    bibClear: TBitBtn;
    lbNumDeal: TLabel;
    edNumDeal: TEdit;
    lbDateDeal: TLabel;
    dtpDateDeal: TDateTimePicker;
    lbDeathDate: TLabel;
    dtpDeathDate: TDateTimePicker;
    meNote: TMemo;
    lbNote: TLabel;
    pnDocumLeft: TPanel;
    btDocumAdd: TButton;
    btDocumChange: TButton;
    btDocumDel: TButton;
    pnGridDocum: TPanel;
    dsDocum: TDataSource;
    pnGridReestr: TPanel;
    dsReestr: TDataSource;
    tran: TIBTransaction;
    qrReestr: TIBQuery;
    procedure edFioKeyPress(Sender: TObject; var Key: Char);
    procedure edFioChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure chbIsHelperClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dtpDateDealChange(Sender: TObject);
    procedure btDocumAddClick(Sender: TObject);
    procedure btDocumChangeClick(Sender: TObject);
    procedure btDocumDelClick(Sender: TObject);
  private
    procedure GridDocumDblClick(Sender: TObject);
  public
    GridDocum: TNewdbGrid;
    GridReestr: TNewdbGrid;
    MemTable: TRxMemoryData;
    ChangeFlag: Boolean;
    procedure OkClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
    procedure DisableControl(wt: TWinControl);
    procedure FillDocums(hereditarydeal_id: Integer);
    procedure AddFromMemTable(hereditarydeal_id: Integer);
    procedure ActiveReestr(hereditarydeal_id: Integer);
  end;

var
  fmEditHereditaryDeal: TfmEditHereditaryDeal;

implementation

uses UDm, UEditHereditaryDocum;

{$R *.DFM}

procedure TfmEditHereditaryDeal.OkClick(Sender: TObject);
const
  NotEmpty='�� ����� ���� ������.';
begin
  if Trim(edNumDeal.Text)='' then begin
    ShowError(Handle,'���� <'+lbNumDeal.Caption+'>'+#13+NotEmpty);
    edNumDeal.SetFocus;
    exit;
  end;
  if Trim(edFio.Text)='' then begin
    ShowError(Handle,'���� <'+lbFio.Caption+'>'+#13+NotEmpty);
    edFio.SetFocus;
    exit;
  end;
  ModalResult:=mrOk;
end;

procedure TfmEditHereditaryDeal.edFioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditHereditaryDeal.edFioChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditHereditaryDeal.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditHereditaryDeal.FormCreate(Sender: TObject);
var
  fd: TFieldDef;
  cl: TColumn;
begin
  MemTable:=TRxMemoryData.Create(nil);

  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='hereditarydocum_id';
  fd.DataType:=ftInteger;
  fd.CreateField(MemTable);

  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='name';
  fd.DataType:=ftString;
  fd.Size:=150;
  fd.CreateField(MemTable);

  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='num';
  fd.DataType:=ftString;
  fd.Size:=20;
  fd.CreateField(MemTable);

  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='datedoc';
  fd.DataType:=ftDate;
  fd.CreateField(MemTable);

  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='place';
  fd.DataType:=ftString;
  fd.Size:=255;
  fd.CreateField(MemTable);

  MemTable.Active:=true;

  dsDocum.DataSet:=MemTable;

  pc.ActivePageIndex:=0;

  dtpDateDeal.Date:=GetDateTimeFromServer;
  dtpDeathDate.Date:=dtpDateDeal.Date;

  GridDocum:=TNewdbGrid.Create(self);
  GridDocum.Parent:=pnGridDocum;
  GridDocum.Align:=alClient;
  GridDocum.DataSource:=dsDocum;
  GridDocum.RowSelected.Visible:=true;
  GridDocum.RowSelected.Brush.Style:=bsSolid;
  GridDocum.RowSelected.Brush.Color:=GridRowColor;
  GridDocum.RowSelected.Font.Color:=clWhite;
  GridDocum.RowSelected.Pen.Style:=psClear;
  GridDocum.CellSelected.Visible:=true;
  GridDocum.CellSelected.Brush.Color:=clHighlight;
  GridDocum.CellSelected.Font.Color:=clHighlightText;
  GridDocum.Options:=GridDocum.Options-[dgEditing]-[dgTabs];
  GridDocum.OnDblClick:=GridDocumDblClick;
  GridDocum.ReadOnly:=true;

  
    cl:=GridDocum.Columns.Add;
    cl.FieldName:='name';
    cl.Title.Caption:='������������';
    cl.Width:=60;

    cl:=GridDocum.Columns.Add;
    cl.FieldName:='num';
    cl.Title.Caption:='�����';
    cl.Width:=60;

    cl:=GridDocum.Columns.Add;
    cl.FieldName:='datedoc';
    cl.Title.Caption:='����';
    cl.Width:=80;

    cl:=GridDocum.Columns.Add;
    cl.FieldName:='place';
    cl.Title.Caption:='�����������';
    cl.Width:=150;

  tran.AddDatabase(dm.IBDbase);
  dm.IBDbase.AddTransaction(tran);
  qrReestr.DataBase:=dm.IBDbase;


  GridReestr:=TNewdbGrid.Create(self);
  GridReestr.Parent:=pnGridReestr;
  GridReestr.Align:=alClient;
  GridReestr.DataSource:=dsReestr;
  GridReestr.RowSelected.Visible:=true;
  GridReestr.RowSelected.Brush.Style:=bsSolid;
  GridReestr.RowSelected.Brush.Color:=GridRowColor;
  GridReestr.RowSelected.Font.Color:=clWhite;
  GridReestr.RowSelected.Pen.Style:=psClear;
  GridReestr.CellSelected.Visible:=true;
  GridReestr.CellSelected.Brush.Color:=clHighlight;
  GridReestr.CellSelected.Font.Color:=clHighlightText;
  GridReestr.Options:=GridReestr.Options-[dgEditing]-[dgTabs];
  GridReestr.ReadOnly:=true;

end;

procedure TfmEditHereditaryDeal.DisableControl(wt: TWinControl);
var
  i: Integer;
  ct: TControl;
begin
  for i:=0 to wt.ControlCount-1 do begin
    ct:=wt.Controls[i];
    if ct is TWInControl then begin
      DisableControl(TwinCOntrol(ct));
    end;
    if ct is TEdit then begin
      TEdit(ct).Color:=clBtnFace;
      TEdit(ct).Enabled:=false;
    end;
    if ct is TLabel then begin
      TLabel(ct).Color:=clBtnFace;
      TLabel(ct).Enabled:=false;
    end;
    if ct is TButton then begin
      TButton(ct).Enabled:=false;
    end;
    if ct is TCustomDbGrid then begin
      TNewDbGrid(ct).Enabled:=false;
      TNewDbGrid(ct).Color:=clBtnFace;
    end;
  end;
end;

procedure TfmEditHereditaryDeal.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmEditHereditaryDeal.chbIsHelperClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditHereditaryDeal.FormDestroy(Sender: TObject);
begin
  GridDocum.Free;
  MemTable.Free;
  GridReestr.Free;
end;

procedure TfmEditHereditaryDeal.dtpDateDealChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditHereditaryDeal.ActiveReestr(hereditarydeal_id: Integer);
var
  sqls: string;
  cl: TColumn;
begin
  Screen.Cursor:=crHourGlass;
  try
   qrReestr.Active:=false;

    GridReestr.Columns.Clear;

    cl:=GridReestr.Columns.Add;
    cl.FieldName:='ttrname';
    cl.Title.Caption:='������';
    cl.Width:=60;

    cl:=GridReestr.Columns.Add;
    cl.FieldName:='numreestr';
    cl.Title.Caption:='����� �';
    cl.Width:=60;

    cl:=GridReestr.Columns.Add;
    cl.FieldName:='tmpname';
    cl.Title.Caption:='��������';
    cl.Width:=150;

    cl:=GridReestr.Columns.Add;
    cl.FieldName:='fio';
    cl.Title.Caption:='������� �.�.';
    cl.Width:=150;

   qrReestr.SQL.Clear;
   sqls:='Select tb.reestr_id, ttr.prefix||tb.numreestr||ttr.sufix as numreestr, td.name as tdname, '+
        ' tto.name as ttoname, tb.fio, '+
        ' tb.doc_id, tb.oper_id, tb.typereestr_id, tb.whoin, tb.sogl,'+
        ' tb.license_id, tb.tmpname, tb.parent_id, '+
        ' tb.whochange, tb.datechange, '+
        ' ttr.name as ttrname from '+
        TableReestr+' tb join '+
        TableDoc+' td on tb.doc_id=td.doc_id left join '+
        TableTypeReestr+' ttr on tb.typereestr_id=ttr.typereestr_id left join '+
        TableOperation+' tto on tb.oper_id=tto.oper_id '+
        ' where tb.hereditarydeal_id='+inttostr(hereditarydeal_id)+
        ' order by ttr.name,tb.numreestr';
   qrReestr.SQL.Add(sqls);
   tran.Active:=true;
   qrReestr.Active:=true;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmEditHereditaryDeal.btDocumAddClick(Sender: TObject);
var
  fm: TfmEditHereditaryDocum;
begin
 fm:=TfmEditHereditaryDocum.Create(nil);
 try
  fm.Caption:=captionAdd;
  fm.bibOk.OnClick:=fm.OkClick;
  if fm.ShowModal=mrOk then begin
    ChangeFlag:=true;
    MemTable.Append;
//    MemTable.FieldByName('hereditarydocum_id').AsInteger:=;
    MemTable.FieldByName('name').AsString:=Trim(fm.edName.Text);
    MemTable.FieldByName('num').AsString:=Trim(fm.edNum.Text);
    if fm.dtpDateDoc.Checked then
     MemTable.FieldByName('datedoc').AsDateTime:=fm.dtpDateDoc.Date;
    MemTable.FieldByName('place').AsString:=Trim(fm.edPlace.Text);
    MemTable.Post;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmEditHereditaryDeal.btDocumChangeClick(Sender: TObject);
var
  fm: TfmEditHereditaryDocum;
begin
 if MemTable.IsEmpty then exit;
 fm:=TfmEditHereditaryDocum.Create(nil);
 try
  fm.Caption:=captionChange;
  fm.bibOk.OnClick:=fm.OkClick;
  fm.edName.Text:=MemTable.FieldByName('name').AsString;
  fm.edNum.Text:=MemTable.FieldByName('num').AsString;
  if MemTable.FieldByName('datedoc').AsString<>'' then
   fm.dtpDateDoc.Date:=MemTable.FieldByName('datedoc').AsDateTime;
  fm.edPlace.Text:=MemTable.FieldByName('place').AsString; 

  fm.ChangeFlag:=false;
  if fm.ShowModal=mrOk then begin
    if not fm.ChangeFlag then exit;
    ChangeFlag:=true;
    MemTable.Edit;
//    MemTable.FieldByName('hereditarydocum_id').AsInteger:=;
    MemTable.FieldByName('name').AsString:=Trim(fm.edName.Text);
    MemTable.FieldByName('num').AsString:=Trim(fm.edNum.Text);
    if fm.dtpDateDoc.Checked then
     MemTable.FieldByName('datedoc').AsDateTime:=fm.dtpDateDoc.Date
    else MemTable.FieldByName('datedoc').Value:=NULL;
    MemTable.FieldByName('place').AsString:=Trim(fm.edPlace.Text);
    MemTable.Post;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmEditHereditaryDeal.GridDocumDblClick(Sender: TObject);
begin
  btDocumChangeClick(nil);
end;

procedure TfmEditHereditaryDeal.btDocumDelClick(Sender: TObject);
var
  mr: TModalResult;
begin
 if MemTable.IsEmpty then exit;
  mr:=MessageDlg('������� ?',mtConfirmation,[mbYes,mbNo],-1);
//  but:=MessageBox(Handle,Pchar('������� ?'),'��������������',MB_YESNO+MB_ICONWARNING);
  if mr=mrYes then begin
    ChangeFlag:=true;
    MemTable.Delete;
  end;
end;

procedure TfmEditHereditaryDeal.FillDocums(hereditarydeal_id: Integer);
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  MemTable.EmptyTable;
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
   sqls:='Select * from '+TableHereditaryDocum+' where hereditarydeal_id='+inttostr(hereditarydeal_id);
   qr.SQL.Add(sqls);
   qr.Active:=true;
   qr.First;
   while not qr.Eof do begin
    MemTable.Append;
//    MemTable.FieldByName('hereditarydocum_id').AsInteger:=;
    MemTable.FieldByName('name').AsString:=qr.FieldByName('name').AsString;
    MemTable.FieldByName('num').AsString:=qr.FieldByName('num').AsString;
    MemTable.FieldByName('datedoc').AsDateTime:=qr.FieldByName('datedoc').AsDateTime;
    MemTable.FieldByName('place').AsString:=qr.FieldByName('place').AsString;
    MemTable.Post;
    qr.Next;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=CrDefault;
  end;
end;

procedure TfmEditHereditaryDeal.AddFromMemTable(hereditarydeal_id: Integer);
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
  tmps: string;
begin
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
   sqls:='Delete from '+TableHereditaryDocum+' where hereditarydeal_id='+inttostr(hereditarydeal_id);
   qr.SQL.Add(sqls);
   qr.ExecSQL;
   MemTable.DisableControls;
   try
    MemTable.First;
    while not MemTable.Eof do begin
     try
      if MemTable.FieldByName('datedoc').AsString='' then tmps:='null'
      else tmps:=QuotedStr(MemTable.FieldByName('datedoc').AsString);
      sqls:='Insert into '+TableHereditaryDocum+' (hereditarydeal_id,name,num,datedoc,place) values ('+
            inttostr(hereditarydeal_id)+
            ','+QuotedStr(MemTable.FieldByName('name').AsString)+
            ','+QuotedStr(MemTable.FieldByName('num').AsString)+
            ','+tmps+
            ','+QuotedStr(MemTable.FieldByName('place').AsString)+')';
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.ExecSQL;
      MemTable.Next;
     except
     end; 
    end;
   finally
     MemTable.EnableControls;
   end; 
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=CrDefault;
  end;   
end;

end.
