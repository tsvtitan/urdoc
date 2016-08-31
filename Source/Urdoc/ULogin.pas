unit ULogin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, dbtables,db, IBQuery,IBDatabase;

type
  TfmLogin = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    pn: TPanel;
    GroupBox1: TGroupBox;
    Panel2: TPanel;
    lbUser: TLabel;
    lbPass: TLabel;
    im: TImage;
    edPass: TEdit;
    cbUsers: TComboBox;
    procedure bibOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    IncConnect: Integer;
  public
    isFocusPass: Boolean;
    UserId: Integer;
    UserName: String;
    procedure ActiveQuery;
    function Connect: Boolean;
  end;

var
  fmLogin: TfmLogin;

implementation

uses UDm;

{$R *.DFM}

procedure TfmLogin.ActiveQuery;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
 Screen.Cursor:=crHourGlass;
 tr:=TIBTransaction.Create(nil);
 qr:=TIBQuery.Create(nil);
 try
   cbUsers.Clear;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select * from '+TableUsers+' order by name';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   qr.First;
   while not qr.Eof do begin
     cbUsers.Items.Add(Trim(qr.FieldByName('name').AsString));
     qr.Next;
   end;
 finally
  qr.Free;
  tr.Free;
  Screen.Cursor:=crDefault;
 end;
end;

procedure TfmLogin.bibOkClick(Sender: TObject);
begin
  inc(IncConnect);
  if (IncConnect>4) then begin
    ModalResult:=mrCancel;
    exit;
  end;

  if (not Connect)then begin
    ShowError(Application.Handle,'Неверный пользователь или пароль.');
    exit;
  end; 
  ModalResult:=mrOk;
end;

procedure TfmLogin.FormCreate(Sender: TObject);
begin
  IncConnect:=1;
  isFocusPass:=false;
end;

function TfmLogin.Connect: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  ms: TmemoryStream;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  ms:=TmemoryStream.Create;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   Result:=false;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select * from '+TableUsers+' where name='''+Trim(cbUsers.text)+'''';
   qr.Sql.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount>0 then begin
    Self.UserId:=qr.FieldByName('user_id').AsInteger;
    Self.UserName:=qr.FieldByName('name').AsString;
    UserIsAdmin:=qr.FieldByName('flagadmin').AsString='1';
//    isEdit:=qr.FieldByName('progadmin').AsString='1';
    isEdit:=UserIsAdmin;
    TBlobField(qr.FieldByName('userpass')).SaveToStream(ms);
    ms.Position:=0;
    Result:=CheckStream(ms,edPass.Text);
   end;
  finally
   qr.Free;
   tr.Free;
   ms.Free;
   Screen.Cursor:=crDefault;
  end;

end;


procedure TfmLogin.FormActivate(Sender: TObject);
begin
  if isFocusPass then
    edPass.SetFocus;
end;

procedure TfmLogin.FormShow(Sender: TObject);
begin
   SetForegroundWindow(Self.Handle);
end;

end.
