unit DsnSubCl;

// Runtime Design System Version 2.x   1998/06/08-
// Copyright Kazuhiro Sasaki 1997-1998.

interface

uses
  Windows, Classes, Forms, Controls, Messages, Dialogs, Graphics,
  DsnHandle, DsnShape, DsnUnit, DsnSub8, ExtCtrls;

type
  TDsnClRegister = class(TDsnRegister)
  protected
    procedure CreateHandler;override;
    procedure CreateCopyShape;override;
    procedure CreateMoveShape;override;
  end;

  TMultiClShape = class(TMultiShape)
  private
  protected
    function CreateAddShape:TFundamentalShape;override;
    function CreateAddNewShape:TFundamentalShape;override;
  end;

  TClShape = class(TFundamentalShape)
  private
    FTimer: TTimer;
  protected
    OldColor:TColor;
    OldLeft:Integer;
    OldTop:Integer;
    Cnt: Integer;
    procedure ChangeColorOnTimer(Sender: TObject);virtual;
  public
    destructor  Destroy; override;
    procedure SetBounds(aLeft,aTop:Integer);override;
  end;

  TMultiClHandler = class(TMultiHandler)
  protected
    function CreateHandlerRect(Control:TControl):THandlerRect;override;
  end;

  THandlerClRect = class(THandlerRect)
  protected
    procedure CreateSmallRect;override;
  end;

  TClMigiueRect = class(TMigiueRect)
  public
    function CreateRectShape:TMultiShape;override;
  end;

  TClMigishitaRect = class(TMigishitaRect)
  public
    function CreateRectShape:TMultiShape;override;
  end;

  TClHidariueRect = class(THidariueRect)
  public
    function CreateRectShape:TMultiShape;override;
  end;

  TClHidarishitaRect = class(THidarishitaRect)
  public
    function CreateRectShape:TMultiShape;override;
  end;

  TClNakaueRect = class(TNakaueRect)
  public
    function CreateRectShape:TMultiShape;override;
  end;

  TClNakashitaRect = class(TNakashitaRect)
    function CreateRectShape:TMultiShape;override;
  end;

  TClNakamigiRect = class(TNakamigiRect)
    function CreateRectShape:TMultiShape;override;
  end;

  TClNakahidariRect = class(TNakahidariRect)
    function CreateRectShape:TMultiShape;override;
  end;
  
  //procedure Register;


implementation

procedure TDsnClRegister.CreateCopyShape;
begin
  FShape:= TMultiClShape.Create;
end;

procedure TDsnClRegister.CreateMoveShape;
begin
  FShape:= TMultiClShape.Create;
end;

procedure TDsnClRegister.CreateHandler;
begin
  FHandler:= TMultiClHandler.Create;
end;

function TMultiClShape.CreateAddShape:TFundamentalShape;
begin
  Result:= TClShape.Create(CV);
end;

function TMultiClShape.CreateAddNewShape:TFundamentalShape;
begin
  Result:= TClShape.Create(CV);
end;

destructor TClShape.Destroy;
begin
  if FTimer <> nil then
    FTimer.Free;
  inherited Destroy;
end;

procedure TClShape.SetBounds(aLeft,aTop:Integer);
begin
  if FTimer = nil then
  begin
    Cnt:=0;
    FTimer:= TTimer.Create(nil);
    FTimer.Interval:= 50;
    FTimer.OnTimer:= ChangeColorOnTimer;
    OldColor:= Color;
  end;
  OldLeft:= aLeft;OldTop:= aTop;
  CV.Pen.Color:= OldColor;

  inherited;

  OldColor:= Color;

end;

procedure TClShape.ChangeColorOnTimer(Sender: TObject);
begin
  case Cnt of
    0:begin
        Color:=ClRed;
        Inc(Cnt);
      end;
    1:begin
        Color:=ClGray;
        Inc(Cnt);
      end;
    2:begin
        Color:=ClYellow;
        Inc(Cnt);
      end;
    3:begin
        Color:=ClBlue;
        Inc(Cnt);
      end;
    4:begin
        Color:=ClAqua;
        Cnt:=0;
      end;
   end;
   SetBounds(OldLeft,OldTop);
end;

function TMultiClHandler.CreateHandlerRect(Control:TControl):THandlerRect;
begin
  Result:= THandlerClRect.Create(Control,Size,CutSizeX,CutSizeY,PenWidth,ColorMulti,ColorSingle,Color);
end;

procedure THandlerClRect.CreateSmallRect;
var
  SmallRect:TSmallRect;
begin
  if Assigned(SmallRects) then
  begin
    SmallRect:= TClMigishitaRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
    SmallRect:= TClMigiueRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
    SmallRect:= TClHidariueRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
    SmallRect:= TClHidarishitaRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
    SmallRect:= TClNakaueRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
    SmallRect:= TClNakashitaRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
    SmallRect:= TClNakamigiRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
    SmallRect:= TClNakahidariRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
  end;
end;

function TClMigishitaRect.CreateRectShape:TMultiShape;
begin
  Result:= TMultiClShape.Create;
end;

function TClMigiueRect.CreateRectShape:TMultiShape;
begin
  Result:= TMultiClShape.Create;
end;

function TClHidariueRect.CreateRectShape:TMultiShape;
begin
  Result:= TMultiClShape.Create;
end;

function TClHidarishitaRect.CreateRectShape:TMultiShape;
begin
  Result:= TMultiClShape.Create;
end;

function TClNakaueRect.CreateRectShape:TMultiShape;
begin
  Result:= TMultiClShape.Create;
end;

function TClNakashitaRect.CreateRectShape:TMultiShape;
begin
  Result:= TMultiClShape.Create;
end;

function TClNakamigiRect.CreateRectShape:TMultiShape;
begin
  Result:= TMultiClShape.Create;
end;

function TClNakahidariRect.CreateRectShape:TMultiShape;
begin
  Result:= TMultiClShape.Create;
end;

{
procedure Register;
begin
  RegisterComponents('DsnSys', [TDsnClRegister]);
end;
}

end.
