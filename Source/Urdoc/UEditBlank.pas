unit UEditBlank;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TfmEditBlank = class(TForm)
    lbSeries: TLabel;
    lbNumFrom: TLabel;
    edSeries: TEdit;
    edNumFrom: TEdit;
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    cbInString: TCheckBox;
    bibClear: TBitBtn;
    lbNumTo: TLabel;
    edNumTo: TEdit;
    CheckBoxVisible: TCheckBox;
    procedure edSeriesKeyPress(Sender: TObject; var Key: Char);
    procedure edSeriesChange(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure edNumToKeyPress(Sender: TObject; var Key: Char);
    procedure CheckBoxVisibleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    ChangeFlag: Boolean;
    procedure OkClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
  end;

var
  fmEditBlank: TfmEditBlank;

implementation

uses UDm;

{$R *.DFM}

procedure TfmEditBlank.OkClick(Sender: TObject);
const
  NotEmpty='�� ����� ���� ������.';
begin
  if Trim(edSeries.Text)='' then begin
    ShowError(Handle,'���� <'+lbSeries.Caption+'>'+#13+NotEmpty);
    edSeries.SetFocus;
    exit;
  end;
  ModalResult:=mrOk;
end;

procedure TfmEditBlank.edSeriesKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditBlank.edNumToKeyPress(Sender: TObject; var Key: Char);
var
  S: String;
  Val: Integer;
begin
  if Integer(Key)<>VK_BACK then begin
    S:=TEdit(Sender).Text+Key;
    if not TryStrToInt(S,Val) then
      Key:=#0;
  end;
end;

procedure TfmEditBlank.edSeriesChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditBlank.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditBlank.FormCreate(Sender: TObject);
begin
  edNumFrom.MaxLength:=MaxBlankNumLength;
  edNumTo.MaxLength:=MaxBlankNumLength;
end;

procedure TfmEditBlank.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmEditBlank.CheckBoxVisibleClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.                      
