unit UEditRenovation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, db;

type
  TfmEditRenovation = class(TForm)
    lbName: TLabel;
    edName: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    cbInString: TCheckBox;
    lbIndate: TLabel;
    dtpInDate: TDateTimePicker;
    bibClear: TBitBtn;
    lbText: TLabel;
    meText: TMemo;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbAdminClick(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
    procedure dtpInDateChange(Sender: TObject);
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
  fmEditRenovation: TfmEditRenovation;

implementation

uses Udm, UMain, URBNotarius;

{$R *.DFM}

procedure TfmEditRenovation.OkClick(Sender: TObject);
begin
  if Trim(edName.Text)='' then begin
    ShowError(Handle,'Поле <'+lbName.Caption+'>'+#13+'не может быть пустым.');
    edName.SetFocus;
    exit;
  end;
  if Trim(meText.Lines.Text)='' then begin
    ShowError(Handle,'Поле <'+lbText.Caption+'>'+#13+'не может быть пустым.');
    meText.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditRenovation.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRenovation.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditRenovation.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
  dtpInDate.date:=Workdate;
  dtpInDate.Time:=StrtoTime('0:00:00');
end;

procedure TfmEditRenovation.chbAdminClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRenovation.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditRenovation.dtpInDateChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRenovation.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

end.
