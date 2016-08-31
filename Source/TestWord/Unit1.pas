unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ActiveX, ComObj;

type
  TfmMain = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

procedure TfmMain.Button1Click(Sender: TObject);
var
  V: Variant;
begin
  V:=CreateOleObject(Edit1.Text);
  V.Visible:=true;
  V.WindowState:=1;
end;

end.
