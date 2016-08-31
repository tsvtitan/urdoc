unit UEditCase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmEditCase = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    lbNomin: TLabel;
    edNomin: TEdit;
    cbInString: TCheckBox;
    lbGenit: TLabel;
    edGenit: TEdit;
    lbDativ: TLabel;
    edDativ: TEdit;
    lbCreat: TLabel;
    edCreat: TEdit;
    lbVinit: TLabel;
    edVinit: TEdit;
    lbPredl: TLabel;
    edPredl: TEdit;
    bibClear: TBitBtn;
    procedure edNominChange(Sender: TObject);
    procedure edMaskChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edTestChange(Sender: TObject);
    procedure edNominKeyPress(Sender: TObject; var Key: Char);
    procedure bibClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    ChangeFlag: Boolean;
    procedure AddAndChangeOkClick(Sender: TObject);
    procedure AddCaseOkClick(Sender: TObject);
    procedure FilterOk(Sender: TObject);
  end;

var
  fmEditCase: TfmEditCase;

implementation

uses UDm, UMain;

{$R *.DFM}

procedure TfmEditCase.AddAndChangeOkClick(Sender: TObject);
begin
  if Trim(edNomin.text)='' then begin
    ShowError(Handle,'Поле <'+lbNomin.Caption+'> не заполнено.');
    edNomin.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditCase.AddCaseOkClick(Sender: TObject);
begin
  if (Trim(edNomin.text)='')and(not edNomin.ReadOnly) then begin
    ShowError(Handle,'Поле <'+lbNomin.Caption+'> не заполнено.');
    edNomin.SetFocus;
    exit;
  end;
  if (Trim(edGenit.text)='') and(not edGenit.ReadOnly) then begin
    ShowError(Handle,'Поле <'+lbGenit.Caption+'> не заполнено.');
    edGenit.SetFocus;
    exit;
  end;
  if (Trim(edDativ.text)='') and(not edDativ.ReadOnly) then begin
    ShowError(Handle,'Поле <'+lbDativ.Caption+'> не заполнено.');
    edDativ.SetFocus;
    exit;
  end;
  if (Trim(edCreat.text)='') and(not edCreat.ReadOnly) then begin
    ShowError(Handle,'Поле <'+lbCreat.Caption+'> не заполнено.');
    edCreat.SetFocus;
    exit;
  end;
  if (Trim(edVinit.text)='') and(not edVinit.ReadOnly) then begin
    ShowError(Handle,'Поле <'+lbVinit.Caption+'> не заполнено.');
    edVinit.SetFocus;
    exit;
  end;
  if (Trim(edPredl.text)='') and(not edPredl.ReadOnly) then begin
    ShowError(Handle,'Поле <'+lbPredl.Caption+'> не заполнено.');
    edPredl.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditCase.edNominChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditCase.edMaskChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditCase.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TfmEditCase.edTestChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditCase.edNominKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditCase.FilterOk(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

procedure TfmEditCase.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

end.
