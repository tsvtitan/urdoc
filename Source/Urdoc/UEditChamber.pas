unit UEditChamber;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TfmEditChamber = class(TForm)
    lbName: TLabel;
    lbAddress: TLabel;
    edName: TEdit;
    edAddress: TEdit;
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    cbInString: TCheckBox;
    bibClear: TBitBtn;
    lbPresident: TLabel;
    edPresident: TEdit;
    lbPhone: TLabel;
    edPhone: TEdit;
    lbEmail: TLabel;
    edEmail: TEdit;
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
    procedure edNameChange(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure chbIsHelperClick(Sender: TObject);
  private
    { Private declarations }
  public
    ChangeFlag: Boolean;
    procedure OkClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
    procedure DisableControl(wt: TWinControl);
  end;

var
  fmEditChamber: TfmEditChamber;

implementation

uses UDm;

{$R *.DFM}

procedure TfmEditChamber.OkClick(Sender: TObject);
const
  NotEmpty='не может быть пустым.';
begin
  if Trim(edName.Text)='' then begin
    ShowError(Handle,'Поле <'+lbName.Caption+'>'+#13+NotEmpty);
    edName.SetFocus;
    exit;
  end;
  if Trim(edAddress.Text)='' then begin
    ShowError(Handle,'Поле <'+lbAddress.Caption+'>'+#13+NotEmpty);
    edAddress.SetFocus;
    exit;
  end;
  if Trim(edPresident.Text)='' then begin
    ShowError(Handle,'Поле <'+lbPresident.Caption+'>'+#13+NotEmpty);
    edPresident.SetFocus;
    exit;
  end;
  ModalResult:=mrOk;
end;

procedure TfmEditChamber.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditChamber.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditChamber.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditChamber.DisableControl(wt: TWinControl);
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

procedure TfmEditChamber.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmEditChamber.chbIsHelperClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
