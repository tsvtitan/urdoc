unit UWorkYear;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TfmWorkYear = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    pnWoryear: TPanel;
    grbWorkYear: TGroupBox;
    lbworkYear: TLabel;
    edWorkDate: TEdit;
    udWorkYear: TUpDown;
    procedure bibOkClick(Sender: TObject);
    procedure bibCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmWorkYear: TfmWorkYear;

implementation

{$R *.DFM}

procedure TfmWorkYear.bibOkClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmWorkYear.bibCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
