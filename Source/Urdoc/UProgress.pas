unit UProgress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Gauges, StdCtrls, ExtCtrls, Buttons, filectrl, ComCtrls;

type
  TfmProgress = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    bibBreak: TBitBtn;
    lbProgress: TLabel;
    gag: TProgressBar;
    procedure bibBreakClick(Sender: TObject);
  private
  public
  end;

var
  fmProgress: TfmProgress;

implementation

uses UMain, UDm;

{$R *.DFM}

procedure TfmProgress.bibBreakClick(Sender: TObject);
begin
  BreakAnyProgress:=true;
end;


end.
