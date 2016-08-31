unit UEditMarkCarEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmEditMaskEdit = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    lbName: TLabel;
    edName: TEdit;
    lbmask: TLabel;
    edMask: TEdit;
    lbtest: TLabel;
    edTest: TEdit;
    cbInString: TCheckBox;
    procedure edNameChange(Sender: TObject);
    procedure edMaskChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edTestChange(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    ChangeFlag: Boolean;
    procedure AddAndChangeOkClick(Sender: TObject);
    procedure FilterOk(Sender: TObject);
  end;

var
  fmEditMaskEdit: TfmEditMaskEdit;

implementation

uses UDm, UMain;

{$R *.DFM}

procedure TfmEditMaskEdit.AddAndChangeOkClick(Sender: TObject);
begin
  if Trim(edName.text)='' then begin
    ShowError(Application.Handle,'Поле <'+lbName.Caption+'> не заполнено.');
    edName.SetFocus;
    exit;
  end;
  if Trim(edMask.text)='' then begin
    ShowError(Application.Handle,'Поле <'+lbMask.Caption+'> не заполнено.');
    edMask.SetFocus;
    exit;
  end;
  if Trim(edtest.text)='' then begin
    ShowError(Application.Handle,'Поле <'+lbtest.Caption+'> не заполнено.');
    edtest.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditMaskEdit.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditMaskEdit.edMaskChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditMaskEdit.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TfmEditMaskEdit.edTestChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditMaskEdit.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditMaskEdit.FilterOk(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

end.
