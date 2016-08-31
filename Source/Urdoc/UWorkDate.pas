unit UWorkDate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TfmWorkDate = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    pnWoryear: TPanel;
    grbWorkYear: TGroupBox;
    lbworkYear: TLabel;
    dtpWorkdate: TDateTimePicker;
    procedure bibOkClick(Sender: TObject);
    procedure bibCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmWorkDate: TfmWorkDate;

implementation

{$R *.DFM}

procedure TfmWorkDate.bibOkClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmWorkDate.bibCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
