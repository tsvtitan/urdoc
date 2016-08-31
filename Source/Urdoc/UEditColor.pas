unit UEditColor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmEditColor = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    lbName: TLabel;
    edName: TEdit;
    cbInString: TCheckBox;
    bibClear: TBitBtn;
    procedure edNameChange(Sender: TObject);
    procedure edMaskChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edTestChange(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
    procedure bibClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    ChangeFlag: Boolean;
    procedure AddAndChangeOkClick(Sender: TObject);
    procedure FilterOk(Sender: TObject);
  end;

var
  fmEditColor: TfmEditColor;

implementation

uses UDm, UMain;

{$R *.DFM}

procedure TfmEditColor.AddAndChangeOkClick(Sender: TObject);
begin
  if Trim(edName.text)='' then begin
    ShowError(Handle,'Поле <'+lbName.Caption+'> не заполнено.');
    edName.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditColor.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditColor.edMaskChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditColor.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TfmEditColor.edTestChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditColor.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditColor.FilterOk(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

procedure TfmEditColor.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

end.
