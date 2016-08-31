unit UInputNumReestr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmInputNumber = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    Label1: TLabel;
    edNumber: TEdit;
    procedure edNumberKeyPress(Sender: TObject; var Key: Char);
    procedure bibOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    TypeReestrId: Integer;
  end;

var
  fmInputNumber: TfmInputNumber;

implementation

uses UDm;

{$R *.DFM}

procedure TfmInputNumber.edNumberKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Char(Key) in ['0'..'9']))and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end;
end;

procedure TfmInputNumber.bibOkClick(Sender: TObject);
begin
  if isNumReestrAlready(Strtoint(edNumber.Text),TypeReestrId) then begin
    ShowError(Application.Handle,'Номер в реестре <'+edNumber.Text+'> не существует.');
    edNumber.Text:=inttostr(GetMaxNumReestr(TypeReestrId,UserID));
    edNumber.SetFocus;
    edNumber.SelectAll;
    exit;
  end;
  ModalResult:=mrOk;
end;

end.
