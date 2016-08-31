unit UEditHereditaryDocum;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TfmEditHereditaryDocum = class(TForm)
    lbName: TLabel;
    lbNum: TLabel;
    edName: TEdit;
    edNum: TEdit;
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    lbPlace: TLabel;
    edPlace: TEdit;
    lbDateDoc: TLabel;
    dtpDateDoc: TDateTimePicker;
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
    procedure edNameChange(Sender: TObject);
    procedure dtpDateDocChange(Sender: TObject);
  private
    { Private declarations }
  public
    ChangeFlag: Boolean;
    procedure OkClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
    procedure DisableControl(wt: TWinControl);
  end;

var
  fmEditHereditaryDocum: TfmEditHereditaryDocum;

implementation

uses UDm;

{$R *.DFM}

procedure TfmEditHereditaryDocum.OkClick(Sender: TObject);
const
  NotEmpty='не может быть пустым.';
begin
  if Trim(edName.Text)='' then begin
    ShowError(Handle,'Поле <'+lbName.Caption+'>'+#13+NotEmpty);
    edName.SetFocus;
    exit;
  end;
  ModalResult:=mrOk;
end;

procedure TfmEditHereditaryDocum.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditHereditaryDocum.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditHereditaryDocum.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditHereditaryDocum.DisableControl(wt: TWinControl);
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
  end;
end;

procedure TfmEditHereditaryDocum.dtpDateDocChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
