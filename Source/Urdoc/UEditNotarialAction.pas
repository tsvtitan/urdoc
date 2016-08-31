unit UEditNotarialAction;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, db;

type
  TfmEditNotarialAction = class(TForm)
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
    chbUseNoYear: TCheckBox;
    chbUsedefect: TCheckBox;
    lbPercent: TLabel;
    edPercent: TEdit;
    lbFieldSort: TLabel;
    edFieldSort: TEdit;
    chbViewInForm: TCheckBox;
    chbViewHereditary: TCheckBox;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbAdminClick(Sender: TObject);
    procedure meHintChange(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
    procedure edNotChange(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure chbUseNoYearClick(Sender: TObject);
  private
    { Private declarations }
  public
    NotID: Integer;
    ChangeFlag: Boolean;
    procedure OkClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
  end;

var
  fmEditNotarialAction: TfmEditNotarialAction;

implementation

uses Udm, UMain, URBNotarialAction;

{$R *.DFM}

procedure TfmEditNotarialAction.OkClick(Sender: TObject);
begin
  if Trim(edname.Text)='' then begin
    ShowError(Handle,'Поле <'+lbName.Caption+'>'+#13+'не может быть пустым.');
    edname.SetFocus;
    exit;
  end;
  if Trim(meHint.Lines.Text)='' then begin
    ShowError(Handle,'Поле <'+lbHint.Caption+'>'+#13+'не может быть пустым.');
    meHint.SetFocus;
    exit;
  end;
  if Trim(edPercent.Text)<>'' then begin
    if not isFloat(edPercent.Text) then begin
      ShowError(Handle,DefNoncorrectValue);
      edPercent.SetFocus;
      exit;
    end;
  end;
  if Trim(edFieldSort.Text)<>'' then begin
    if not isInteger(edFieldSort.Text) then begin
      ShowError(Handle,DefNoncorrectValue);
      edFieldSort.SetFocus;
      exit;
    end;
  end else begin
   ShowError(Handle,'Поле <'+lbFieldSort.Caption+'>'+#13+'не может быть пустым.');
   edFieldSort.SetFocus;
   exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditNotarialAction.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditNotarialAction.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditNotarialAction.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TfmEditNotarialAction.chbAdminClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditNotarialAction.meHintChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditNotarialAction.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditNotarialAction.edNotChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditNotarialAction.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmEditNotarialAction.chbUseNoYearClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
