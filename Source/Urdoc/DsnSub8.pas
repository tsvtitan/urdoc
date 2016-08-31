unit DsnSub8;

interface

uses
  Windows, Classes, Forms, Controls, Messages, Dialogs, Graphics,
  DsnShape, DsnUnit, DsnHandle, DsnSubMl;

type
  TDsn8Register = class(TDsnMlRegister)
  protected
    procedure CreateHandler;override;
  end;

  TMulti8Handler = class(TMultiHandler)
  protected
    function CreateHandlerRect(Control:TControl):THandlerRect;override;
  end;

  THandler8Rect = class(THandlerRect)
  protected
    procedure CreateSmallRect;override;
  end;

  TNakaueRect = class(TSmallRect)
    procedure SetControl;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
    procedure MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);override;
  end;

  TNakashitaRect = class(TSmallRect)
    procedure SetControl;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
    procedure MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);override;
  end;

  TNakamigiRect = class(TSmallRect)
    procedure SetControl;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
    procedure MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);override;
  end;

  TNakahidariRect = class(TSmallRect)
    procedure SetControl;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
    procedure MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);override;
  end;
  

  procedure Register;

implementation

procedure TDsn8Register.CreateHandler;
begin
  FHandler:= TMulti8Handler.Create;
end;

function TMulti8Handler.CreateHandlerRect(Control:TControl):THandlerRect;
begin
  Result:= THandler8Rect.Create(Control,Size,CutSizeX,CutSizeY,PenWidth,ColorMulti,ColorSingle,Color);
end;

procedure THandler8Rect.CreateSmallRect;
var
  SmallRect:TSmallRect;
begin
  inherited;
  if Assigned(SmallRects) then
  begin
    SmallRect:= TNakaueRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
    SmallRect:= TNakashitaRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
    SmallRect:= TNakamigiRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
    SmallRect:= TNakahidariRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
  end;
end;

{/MouseMove/}
procedure TNakaueRect.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Point:TPoint;
begin
  if Color = ColorSingle then
    Cursor := crSizeNS;

  if Assigned(FShape) then
  begin
    Cutting(X, Y);
    Point.x:= Left;
    Point.y:= Top + Y;
    Point:= Parent.ClientToScreen(Point);
    FShape.SetHeight(Control.Height - Y);
    FShape.Drow(Point);
  end;
end;

procedure TNakashitaRect.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Point:TPoint;
begin
  if Color = ColorSingle then
    Cursor := crSizeNS;

  if Assigned(FShape) then
  begin
    Cutting(X, Y);
    Point.x:= Left;
    Point.y:= Top;
    Point:= Parent.ClientToScreen(Point);
    FShape.SetHeight(Control.Height - (FY-Y));
    FShape.Drow(Point);
  end;
end;

procedure TNakamigiRect.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Point:TPoint;
begin
  if Color = ColorSingle then
    Cursor := crSizeWE;

  if Assigned(FShape) then
  begin
    Cutting(X, Y);
    Point.x:= Left;
    Point.y:= Top;
    Point:= Parent.ClientToScreen(Point);
    FShape.SetWidth(Control.Width - (FX-X));
    FShape.Drow(Point);
  end;
end;

procedure TNakahidariRect.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Point:TPoint;
begin
  if Color = ColorSingle then
    Cursor := crSizeWE;

  if Assigned(FShape) then
  begin
    Cutting(X, Y);
    Point.x:= Left + X;
    Point.y:= Top;
    Point:= Parent.ClientToScreen(Point);
    FShape.SetWidth(Control.Width - X);
    FShape.Drow(Point);
  end;
end;

{/MouseUp/}
procedure TNakaueRect.MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);
var
  NewLeft, NewTop, NewWidth, NewHeight: Integer;
begin
  Cutting(X, Y);
  NewLeft:= Control.Left;
  NewWidth:= Control.Width;
  NewTop:= Control.Top + (Y - FY);
  NewHeight:= Control.Height - (Y - FY);
  if NewHeight >=0 then
    Control.SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
  if NewHeight <0 then
    Control.SetBounds(NewLeft, Control.Top + Control.Height, NewWidth, -NewHeight);
  inherited;
end;

procedure TNakashitaRect.MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);
var
  NewLeft, NewTop, NewWidth, NewHeight: Integer;
begin
  Cutting(X, Y);
  NewLeft:= Control.Left;
  NewWidth:= Control.Width;
  NewTop:= Control.Top;
  NewHeight:= Control.Height + (Y - FY);
  if NewHeight >=0 then
    Control.SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
  if NewHeight <0 then
    Control.SetBounds(NewLeft, Control.Top + NewHeight, NewWidth, -NewHeight);
  inherited;
end;

procedure TNakamigiRect.MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);
var
  NewLeft, NewTop, NewWidth, NewHeight: Integer;
begin
  Cutting(X, Y);
  NewLeft:= Control.Left;
  NewWidth:= Control.Width - (FX - X);
  NewTop:= Control.Top;
  NewHeight:= Control.Height;
  if NewWidth >=0 then
    Control.SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
  if NewWidth <0 then
    Control.SetBounds(Control.Left + NewWidth, NewTop, -NewWidth, NewHeight);
  inherited;
end;

procedure TNakahidariRect.MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);
var
  NewLeft, NewTop, NewWidth, NewHeight: Integer;
begin
  Cutting(X, Y);
  NewLeft:= Control.Left + (X - FX);
  NewWidth:= Control.Width - (X - FX);
  NewTop:= Control.Top;
  NewHeight:= Control.Height;
  if NewWidth >=0 then
    Control.SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
  if NewWidth <0 then
    Control.SetBounds(Control.Left + Control.Width, NewTop, -NewWidth, NewHeight);
  inherited;
end;



{/SetControl/}
procedure TNakaueRect.SetControl;
var
  NewLeft, NewTop: Integer;
begin
  NewLeft:= Control.Left + (Control.Width div 2) - (Size div 2);
  NewTop:= Control.Top -2;
  SetBounds(NewLeft,NewTop,Size,Size);
end;

procedure TNakashitaRect.SetControl;
var
  NewLeft, NewTop: Integer;
begin
  NewLeft:= Control.Left + (Control.Width div 2) - (Size div 2);
  NewTop:= Control.Top + Control.Height - Size +2;
  SetBounds(NewLeft,NewTop,Size,Size);
end;

procedure TNakamigiRect.SetControl;
var
  NewLeft, NewTop: Integer;
begin
  NewLeft:= Control.Left  +Control.Width - Size +2;
  NewTop:= Control.Top + (Control.Height div 2) - (Size div 2);
  SetBounds(NewLeft,NewTop,Size,Size);
end;

procedure TNakahidariRect.SetControl;
var
  NewLeft, NewTop: Integer;
begin
  NewLeft:= Control.Left -2;
  NewTop:= Control.Top + (Control.Height div 2) - (Size div 2);
  SetBounds(NewLeft,NewTop,Size,Size);
end;

procedure Register;
begin
  RegisterComponents('DsnSys', [TDsn8Register]);
end;

end.
