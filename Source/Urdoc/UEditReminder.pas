unit UEditReminder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, db;

type
  TfmEditReminder = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    cbInString: TCheckBox;
    bibClear: TBitBtn;
    lbText: TLabel;
    meText: TMemo;
    lbPriority: TLabel;
    edPriority: TEdit;
    udPriority: TUpDown;
    procedure edNumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbAdminClick(Sender: TObject);
    procedure edNumKeyPress(Sender: TObject; var Key: Char);
    procedure dtpDateLicChange(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure meTextChange(Sender: TObject);
    procedure meTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    ReminderID: Integer;
    ChangeFlag: Boolean;
    procedure OkClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
  end;

var
  fmEditReminder: TfmEditReminder;

implementation

uses Udm, UMain, URBSubs;

{$R *.DFM}

procedure TfmEditReminder.OkClick(Sender: TObject);
begin
  if Trim(meText.Lines.Text)='' then begin
    ShowError(Handle,'Поле <'+lbText.Caption+'>'+#13+'не может быть пустым.');
    meText.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditReminder.edNumChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditReminder.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditReminder.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TfmEditReminder.chbAdminClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditReminder.edNumKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditReminder.dtpDateLicChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditReminder.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmEditReminder.meTextChange(Sender: TObject);
begin
  CHangeFlag:=true;
end;

procedure TfmEditReminder.meTextKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then Close;
end;

end.
