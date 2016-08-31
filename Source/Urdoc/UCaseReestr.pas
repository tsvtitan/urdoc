unit UCaseReestr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmCaseReestr = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    Panel1: TPanel;
    rgbTypeRecord: TRadioGroup;
    chbKeepDoc: TCheckBox;
    procedure bibOkClick(Sender: TObject);
    procedure rgbTypeRecordClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmCaseReestr: TfmCaseReestr;

implementation

{$R *.DFM}

procedure TfmCaseReestr.bibOkClick(Sender: TObject);
begin
  ModalResult:=mrok;
end;

procedure TfmCaseReestr.rgbTypeRecordClick(Sender: TObject);
begin
  case rgbTypeRecord.ItemIndex of
    0: begin
      chbKeepDoc.Enabled:=true;
    end;
    1: begin
      chbKeepDoc.Enabled:=false;
    end;
  end;
end;

end.
