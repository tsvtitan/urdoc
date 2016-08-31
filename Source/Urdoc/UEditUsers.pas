unit UEditUsers;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmEditUsers = class(TForm)
    lbName: TLabel;
    edName: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    cbInString: TCheckBox;
    lbPass: TLabel;
    edPass: TEdit;
    chbHidePass: TCheckBox;
    chbAdmin: TCheckBox;
    bibClear: TBitBtn;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbHidePassClick(Sender: TObject);
    procedure chbAdminClick(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
    procedure bibClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    ChangeFlag: Boolean;
    procedure OkClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
  end;

var
  fmEditUsers: TfmEditUsers;

implementation

uses Udm, UMain;

{$R *.DFM}

procedure TfmEditUsers.OkClick(Sender: TObject);
begin
  if Trim(edname.Text)='' then begin
    ShowError(Handle,'Поле <'+lbName.Caption+'>'+#13+'не может быть пустым.');
    edname.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditUsers.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditUsers.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditUsers.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TfmEditUsers.chbHidePassClick(Sender: TObject);
begin
  if chbHidePass.Checked then begin
    edPass.PasswordChar:='*';
  end else begin
    edPass.PasswordChar:=#0;
  end;
end;

procedure TfmEditUsers.chbAdminClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditUsers.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditUsers.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

end.
