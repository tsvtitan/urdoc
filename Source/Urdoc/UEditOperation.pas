unit UEditOperation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, db;

type
  TfmEditOperation = class(TForm)
    lbName: TLabel;
    edName: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    cbInString: TCheckBox;
    lbHint: TLabel;
    meHint: TMemo;
    bibClear: TBitBtn;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbAdminClick(Sender: TObject);
    procedure meHintChange(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
    procedure edNotChange(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    NotID: Integer;
    ChangeFlag: Boolean;
    procedure OkClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
  end;

var
  fmEditOperation: TfmEditOperation;

implementation

uses Udm, UMain, URBNotarius;

{$R *.DFM}

procedure TfmEditOperation.OkClick(Sender: TObject);
begin
  if Trim(edname.Text)='' then begin
    ShowError(Handle,'Поле <'+lbName.Caption+'>'+#13+'не может быть пустым.');
    edname.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditOperation.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditOperation.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditOperation.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TfmEditOperation.chbAdminClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditOperation.meHintChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditOperation.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditOperation.edNotChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditOperation.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

end.
