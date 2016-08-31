unit UEditNotarius;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TfmEditNotarius = class(TForm)
    lbFio: TLabel;
    lbUrAdres: TLabel;
    edFio: TEdit;
    edUrAdres: TEdit;
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    pc: TPageControl;
    cbInString: TCheckBox;
    tsTownFull: TTabSheet;
    tsTownSmall: TTabSheet;
    tsNameTown: TTabSheet;
    lbTownFullNormal: TLabel;
    lbTownFullWhere: TLabel;
    lbTownFullWhat: TLabel;
    edTownFullNormal: TEdit;
    edTownFullWhere: TEdit;
    edTownFullWhat: TEdit;
    lbTownSmallNormal: TLabel;
    edTownSmallNormal: TEdit;
    edTownSmallWhere: TEdit;
    lbTownSmallWhere: TLabel;
    edTownSmallWhat: TEdit;
    lbTownSmallWhat: TLabel;
    lbNameTownNormal: TLabel;
    edNameTownNormal: TEdit;
    edNameTownWhere: TEdit;
    lbNameTownWhere: TLabel;
    edNameTownWhat: TEdit;
    lbNameTownWhat: TLabel;
    bibClear: TBitBtn;
    chbIsHelper: TCheckBox;
    lbINN: TLabel;
    edINN: TEdit;
    LabelPhone: TLabel;
    EditPhone: TEdit;
    procedure edFioKeyPress(Sender: TObject; var Key: Char);
    procedure edFioChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  fmEditNotarius: TfmEditNotarius;

implementation

uses UDm;

{$R *.DFM}

procedure TfmEditNotarius.OkClick(Sender: TObject);
const
  NotEmpty='не может быть пустым.';
begin
  if Trim(edFio.Text)='' then begin
    ShowError(Handle,'Поле <'+lbFio.Caption+'>'+#13+NotEmpty);
    edFio.SetFocus;
    exit;
  end;
  if Trim(edUrAdres.Text)='' then begin
    ShowError(Handle,'Поле <'+lbUrAdres.Caption+'>'+#13+NotEmpty);
    edUrAdres.SetFocus;
    exit;
  end;
  if Trim(edInn.Text)='' then begin
    ShowError(Handle,'Поле <'+lbInn.Caption+'>'+#13+NotEmpty);
    edInn.SetFocus;
    exit;
  end;
  if Trim(edTownFullNormal.Text)='' then begin
    ShowError(Handle,'Поле <'+lbTownFullNormal.Caption+'>'+#13+NotEmpty);
    pc.ActivePageIndex:=0;
    edTownFullNormal.SetFocus;
    exit;
  end;
  if Trim(edTownFullWhere.Text)='' then begin
    ShowError(Handle,'Поле <'+lbTownFullWhere.Caption+'>'+#13+NotEmpty);
    pc.ActivePageIndex:=0;
    edTownFullWhere.SetFocus;
    exit;
  end;
  if Trim(edTownFullWhat.Text)='' then begin
    ShowError(Handle,'Поле <'+lbTownFullWhat.Caption+'>'+#13+NotEmpty);
    pc.ActivePageIndex:=0;
    edTownFullWhat.SetFocus;
    exit;
  end;
  if Trim(edTownSmallNormal.Text)='' then begin
    ShowError(Handle,'Поле <'+lbTownSmallNormal.Caption+'>'+#13+NotEmpty);
    pc.ActivePageIndex:=1;
    edTownSmallNormal.SetFocus;
    exit;
  end;
  if Trim(edTownSmallWhere.Text)='' then begin
    ShowError(Handle,'Поле <'+lbTownSmallWhere.Caption+'>'+#13+NotEmpty);
    pc.ActivePageIndex:=1;
    edTownSmallWhere.SetFocus;
    exit;
  end;
  if Trim(edTownSmallWhat.Text)='' then begin
    ShowError(Handle,'Поле <'+lbTownSmallWhat.Caption+'>'+#13+NotEmpty);
    pc.ActivePageIndex:=1;
    edTownSmallWhat.SetFocus;
    exit;
  end;
  if Trim(edNameTownNormal.Text)='' then begin
    ShowError(Handle,'Поле <'+lbNameTownNormal.Caption+'>'+#13+NotEmpty);
    pc.ActivePageIndex:=2;
    edNameTownNormal.SetFocus;
    exit;
  end;
  if Trim(edNameTownWhere.Text)='' then begin
    ShowError(Handle,'Поле <'+lbNameTownWhere.Caption+'>'+#13+NotEmpty);
    pc.ActivePageIndex:=2;
    edNameTownWhere.SetFocus;
    exit;
  end;
  if Trim(edNameTownWhat.Text)='' then begin
    ShowError(Handle,'Поле <'+lbNameTownWhat.Caption+'>'+#13+NotEmpty);
    pc.ActivePageIndex:=2;
    edNameTownWhat.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditNotarius.edFioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditNotarius.edFioChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditNotarius.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditNotarius.FormCreate(Sender: TObject);
begin
  pc.ActivePageIndex:=0;
end;

procedure TfmEditNotarius.DisableControl(wt: TWinControl);
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

procedure TfmEditNotarius.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmEditNotarius.chbIsHelperClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
