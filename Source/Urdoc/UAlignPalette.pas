unit UAlignPalette;

interface

uses
  Windows, Messages, SysUtils, Classes, Buttons, Menus, Controls, ExtCtrls,
  Forms;

type

  TAlignPalette = class(TForm)
    bnLeft: TSpeedButton;
    bnHCenter: TSpeedButton;
    bnHWinCenter: TSpeedButton;
    bnHSpace: TSpeedButton;
    bnRight: TSpeedButton;
    bnBottom: TSpeedButton;
    bnVSpace: TSpeedButton;
    bnVWinCenter: TSpeedButton;
    bnVCenter: TSpeedButton;
    bnTop: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure bnLeftClick(Sender: TObject);
    procedure bnRightClick(Sender: TObject);
    procedure bnTopClick(Sender: TObject);
    procedure bnBottomClick(Sender: TObject);
    procedure bnHCenterClick(Sender: TObject);
    procedure bnVCenterClick(Sender: TObject);
    procedure bnHWinCenterClick(Sender: TObject);
    procedure bnVWinCenterClick(Sender: TObject);
    procedure bnHSpaceClick(Sender: TObject);
    procedure bnVSpaceClick(Sender: TObject);
  private
  public
  end;

var
  AlignPalette: TAlignPalette;

implementation

uses UDm, UMain, UNewForm;



{$R *.DFM}

procedure TAlignPalette.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TAlignPalette.bnLeftClick(Sender: TObject);
begin
  if Assigned(LastActive) then
    TfmNewForm(LastActive).AlignLeft;
end;

procedure TAlignPalette.bnRightClick(Sender: TObject);
begin
  if Assigned(LastActive) then
    TfmNewForm(LastActive).AlignRight;
end;

procedure TAlignPalette.bnTopClick(Sender: TObject);
begin
  if Assigned(LastActive) then
    TfmNewForm(LastActive).AlignTop;
end;

procedure TAlignPalette.bnBottomClick(Sender: TObject);
begin
  if Assigned(LastActive) then
    TfmNewForm(LastActive).AlignBottom;
end;

procedure TAlignPalette.bnHCenterClick(Sender: TObject);
begin
  if Assigned(LastActive) then
    TfmNewForm(LastActive).AlignHCenter;
end;

procedure TAlignPalette.bnVCenterClick(Sender: TObject);
begin
  if Assigned(LastActive) then
    TfmNewForm(LastActive).AlignVCenter;
end;

procedure TAlignPalette.bnHWinCenterClick(Sender: TObject);
begin
  if Assigned(LastActive) then
    TfmNewForm(LastActive).AlignWinHCenter;
end;

procedure TAlignPalette.bnVWinCenterClick(Sender: TObject);
begin
  if Assigned(LastActive) then
    TfmNewForm(LastActive).AlignWinVCenter;
end;

procedure TAlignPalette.bnHSpaceClick(Sender: TObject);
begin
  if Assigned(LastActive) then
    TfmNewForm(LastActive).AlignHSpace;
end;

procedure TAlignPalette.bnVSpaceClick(Sender: TObject);
begin
  if Assigned(LastActive) then
    TfmNewForm(LastActive).AlignVSpace;
end;

end.
