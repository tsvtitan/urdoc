unit UEditMarkCar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmEditMarkCar = class(TForm)
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
  fmEditMarkCar: TfmEditMarkCar;

implementation

uses UDm, UMain;

{$R *.DFM}

procedure TfmEditMarkCar.AddAndChangeOkClick(Sender: TObject);
begin
  if Trim(edName.text)='' then begin
    ShowError(Handle,'Поле <'+lbName.Caption+'> не заполнено.');
    edName.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditMarkCar.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditMarkCar.edMaskChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditMarkCar.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TfmEditMarkCar.edTestChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditMarkCar.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditMarkCar.FilterOk(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

procedure TfmEditMarkCar.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

end.
