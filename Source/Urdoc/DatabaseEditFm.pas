unit DatabaseEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TDatabaseEditForm = class(TForm)
    edBaseDir: TEdit;
    bibBaseDir: TBitBtn;
    LabelDatabase: TLabel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    LabelName: TLabel;
    EditName: TEdit;
    procedure bibOkClick(Sender: TObject);
    procedure bibCancelClick(Sender: TObject);
    procedure bibBaseDirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DatabaseEditForm: TDatabaseEditForm;

implementation

uses UDm, UServerConnect, IBServices;

{$R *.dfm}

procedure TDatabaseEditForm.bibBaseDirClick(Sender: TObject);
var
  fm: TfmServerConnect;
  Prot: TProtocol;
  SrvName: string;
begin
  fm:=TfmServerConnect.Create(nil);
  try
   GetProtocolAndServerName(edBaseDir.Text,Prot,SrvName);
   fm.SetParams(edBaseDir.Text,Prot,SrvName);
   if fm.ShowModal=mrOk then begin
    if ConnectServer(fm.ConnectString) then
     edBaseDir.Text:=fm.ConnectString;
     ChangeFlag:=true;
   end;  
  finally
   fm.Free;
  end;
end;

procedure TDatabaseEditForm.bibCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TDatabaseEditForm.bibOkClick(Sender: TObject);
begin
  if Trim(EditName.Text)='' then begin
    ShowError(Handle,'������� ������������.');
    EditName.SetFocus;
    exit;
  end;
  if Trim(edBaseDir.Text)='' then begin
    ShowError(Handle,'�������� ���� ������.');
    bibBaseDir.SetFocus;
    exit;
  end;
  if not ConnectServer(Trim(edBaseDir.Text)) then begin
    ShowError(Handle,'���� ������ �� �������.');
    bibBaseDir.SetFocus;
    exit;
  end;
  ModalResult:=mrOK;
end;

end.