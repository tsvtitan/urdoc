unit UHint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmChangeHint = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    pnBack: TPanel;
    gbHint: TGroupBox;
    Panel1: TPanel;
    mmNint: TMemo;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmChangeHint: TfmChangeHint;

implementation

uses UMain;

{$R *.DFM}

procedure TfmChangeHint.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then
   Close;
  fmMain.OnKeyDown(Sender,Key,Shift);
end;

procedure TfmChangeHint.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  fmMain.OnKeyUp(Sender,Key,Shift);
end;

end.
