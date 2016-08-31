unit DsnHandle;

// Runtime Design System Version 2.x   June/08/1998
// Copyright(c) 1998 Kazuhiro Sasaki.

interface

uses
  Windows, Classes, Forms, Controls, Messages, Dialogs, Graphics,
  StdCtrls, DsnShape, DsnList, DsnMes;


type

  THandlerRect = class;

  TMultiHandler = class(TReceiveTargets)
  protected
    FList: TList;
    function CreateHandlerRect(Control:TControl):THandlerRect;virtual;
  public
    Size: Integer;
    CutSizeX:Integer;
    CutSizeY:Integer;
    ColorSingle: TColor;
    ColorMulti: TColor;
    Color: TColor;
    PenWidth:Integer;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure ItemDeath(Index:Integer); override;
    procedure Add(Item:Pointer);override;
    procedure Clear; override;
    procedure Delete(Index:Integer); override;
    procedure SetPosition; override;
  end;

  THandlerRect = class
  private
    ChildDeth:Boolean;
  protected
    SmallRects: TList;
    SWidth: Integer;
    SHeight: Integer;
    SLeft: Integer;
    STop: Integer;
    procedure CreateSmallRect;virtual;
    procedure SetControl;virtual;
  public
    Control:TControl;
    Size: Integer;
    CutSizeX:Integer;
    CutSizeY:Integer;
    ColorSingle: TColor;
    ColorMulti: TColor;
    Color: TColor;
    PenWidth:Integer;
    constructor Create(AControl:TControl;ASize,ACutSizeX,ACutSizeY,APenWidth:Integer;clMulti,clSingle,ShapeColor:TColor);
    destructor Destroy; override;
    procedure ChangeColorMulti;
  end;

  TSmallRect = class(TCustomControl)
  private
    HandlerRect: THandlerRect;
  protected
    FShape: TMultiShape;
    FX: Integer;
    FY: Integer;
    procedure Cutting(var X, Y: Integer);
    function CreateRectShape:TMultiShape;virtual;
  public
    Control:TControl;
    Size: Integer;
    CutSizeX:Integer;
    CutSizeY:Integer;
    ColorSingle: TColor;
    ColorMulti: TColor;
    ShapeColor: TColor;
    PenWidth:Integer;
    constructor Create2(AControl:TControl;ASize,ACutSizeX,ACutSizeY:Integer;clMulti,clSingle:TColor);
    destructor  Destroy; override;
    procedure SetControl; virtual; abstract;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
                                          X, Y: Integer);override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
    procedure MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);override;
    procedure ChangeColorMulti;
  end;

  TMigiueRect = class(TSmallRect)
  public
    procedure SetControl;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
    procedure MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);override;
  end;

  TMigishitaRect = class(TSmallRect)
  public
    procedure SetControl;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
    procedure MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);override;
  end;

  THidariueRect = class(TSmallRect)
  public
    procedure SetControl;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
    procedure MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);override;
  end;

  THidarishitaRect = class(TSmallRect)
  public
    procedure SetControl;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
    procedure MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);override;
  end;

implementation


{TMultiHandler}
constructor TMultiHandler.Create;
begin
  Size:= SizeRectSelect;
  CutSizeX:= 6;
  CutSizeY:= 6;
  PenWidth:= 2;
  ColorSingle:= clBlack;
  ColorMulti:= clGray;
  Color:= clGray;
end;

destructor TMultiHandler.Destroy;
var
  i:integer;
begin
  if Assigned(FList) then
  begin
      for i:= 0 to FList.Count -1 do
        THandlerRect(FList[i]).Free;
    FList.Free;
  end;
  inherited Destroy;
end;

procedure TMultiHandler.ItemDeath(Index:Integer);
var
  i:integer;
begin
  if Assigned(FList) then
  begin
    THandlerRect(FList[Index]).Control:= nil;
    if Assigned(THandlerRect(FList[Index]).SmallRects) then
      for i:= 0 to THandlerRect(FList[Index]).SmallRects.Count -1 do
        TSmallRect(THandlerRect(FList[Index]).SmallRects[i]).Control:= nil;
  end;
end;

procedure TMultiHandler.Clear;
var
  i:integer;
begin
  if Assigned(FList) then
  begin
    for i:= 0 to FList.Count -1 do
      THandlerRect(FList[i]).Free;
    FList.Free;
    FList:= nil;
  end;
end;

procedure TMultiHandler.Delete(Index:Integer);
var
  H:Integer;
  P:Pointer;
begin
  if Assigned(FList) then
  begin
    THandlerRect(FList[Index]).Free;
    FList.Delete(Index);
    if FList.Count = 1 then
    begin
      H:= 0;
      try
        if THandlerRect(FList[0]).Control is TWinControl then
          H:= TWinControl(THandlerRect(FList[0]).Control).Handle
        else
          H:= THandlerRect(FList[0]).Control.Parent.Handle;
      except
      end;
      if H > 0 then
      begin
        P:= THandlerRect(FList[0]).Control;
        THandlerRect(FList[0]).Free;
        FList.Free;
        FList:= nil;
        Add(TControl(P));
      end;
    end;
  end;
end;

function TMultiHandler.CreateHandlerRect(Control:TControl):THandlerRect;
begin
  Result:= THandlerRect.Create(Control,Size,CutSizeX,CutSizeY,PenWidth,ColorMulti,ColorSingle,Color);
end;

procedure TMultiHandler.Add(Item:Pointer);
var
  HandlerRect: THandlerRect;
  i:integer;
  Control:TControl;
begin
  Control:= TControl(Item);
  if (Control = nil) or (Control is TSmallRect) then
    Exit;
  if FList = nil then
    FList:= TList.Create;
  for i:= 0 to FList.Count -1 do
    if THandlerRect(FList[i]).Control = Control then
      Exit;
      
  HandlerRect:= CreateHandlerRect(Control);
  FList.Add(HandlerRect);
  if FList.Count = 2 then
    THandlerRect(FList[0]).ChangeColorMulti;
  if FList.Count > 1 then
    HandlerRect.ChangeColorMulti;

  if Control is TWinControl then
    SendMessage(TWinControl(Control).Handle,MH_SELECT,MakeLong(HandlerRect.SLeft,HandlerRect.STop),MakeLong(HandlerRect.SWidth,HandlerRect.SHeight))
  else
    SendMessage(Control.Parent.Handle,MH_SELECT,MakeLong(HandlerRect.SLeft,HandlerRect.STop),MakeLong(HandlerRect.SWidth,HandlerRect.SHeight));

end;

procedure TMultiHandler.SetPosition;
var
  i:integer;
begin
  if Assigned(FList) then
    for i:= 0 to FList.Count -1 do
      THandlerRect(FList[i]).SetControl;
end;

{THandlerRect}
constructor THandlerRect.Create(AControl:TControl;ASize,ACutSizeX,ACutSizeY,APenWidth:Integer;clMulti,clSingle,ShapeColor:TColor);
var
  i:integer;
begin
  Size:= ASize;
  Control:= AControl;
  ColorMulti:= clMulti;
  ColorSingle:= clSingle;
  CutSizeX:= ACutSizeX;
  CutSizeY:= ACutSizeY;
  Color:= ShapeColor;
  PenWidth:= APenWidth;
  ChildDeth:= False;
  SmallRects:= TList.Create;
  CreateSmallRect;
  for i:= 0 to SmallRects.Count -1 do
  begin
    TSmallRect(SmallRects[i]).Parent:= AControl.Parent;
    TSmallRect(SmallRects[i]).HandlerRect:= Self;
    TSmallRect(SmallRects[i]).ShapeColor:= ShapeColor;
    TSmallRect(SmallRects[i]).PenWidth:= PenWidth;
  end;
end;

procedure THandlerRect.CreateSmallRect;
var
  SmallRect:TSmallRect;
begin
  if Assigned(SmallRects) then
  begin
    SmallRect:= TMigishitaRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
    SmallRect:= TMigiueRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
    SmallRect:= THidariueRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
    SmallRect:= THidarishitaRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRects.Add(SmallRect);
  end;
end;

destructor THandlerRect.Destroy;
var
  i:integer;
begin
  if Assigned(SmallRects) then
  begin
    if not ChildDeth then
      for i:= 0 to SmallRects.Count -1 do
        TSmallRect(SmallRects[i]).Free;
    SmallRects.Free;
  end;
  inherited Destroy;
end;

procedure THandlerRect.SetControl;
var
  i:integer;
begin
  for i:= 0 to SmallRects.Count -1 do
    if not ChildDeth then
      TSmallRect(SmallRects[i]).SetControl;
end;

procedure THandlerRect.ChangeColorMulti;
var
  i:integer;
begin
  for i:= 0 to SmallRects.Count -1 do
    TSmallRect(SmallRects[i]).ChangeColorMulti;
end;

{TSmallRect}
constructor TSmallRect.Create2(AControl:TControl;ASize,ACutSizeX,ACutSizeY:Integer;clMulti,clSingle:TColor);
begin
  inherited Create(nil);
  Control:= AControl;
  Size:= ASize;
  CutSizeX:= ACutSizeX;
  CutSizeY:= ACutSizeY;
  ColorMulti:= clMulti;
  ColorSingle:= clSingle;
  Color:=ColorSingle;
end;

destructor  TSmallRect.Destroy;
begin
  HandlerRect.ChildDeth:= True;
  inherited Destroy;
end;

procedure TSmallRect.Paint;
begin
  Canvas.Brush.Style:=bsSolid;
  Canvas.Brush.Color:=Color;
  Canvas.Rectangle(0,0,Width,Height);
end;

procedure TSmallRect.ChangeColorMulti;
begin
  Color:= ColorMulti;
  Cursor := 0;
  Repaint;
end;

function TSmallRect.CreateRectShape:TMultiShape;
begin
  Result:= TMultiShape.Create;
end;

procedure TSmallRect.MouseDown(Button: TMouseButton; Shift: TShiftState;
                                      X, Y: Integer);
var
  Point:TPoint;
begin
  if Color = ColorSingle then
  begin
    HandlerRect.SWidth:= Control.Width;
    HandlerRect.SHeight:= Control.Height;
    HandlerRect.SLeft:= Control.Left;
    HandlerRect.STop:= Control.Top;
    FX:= X;
    FY:= Y;
    Cutting(FX,FY);
    
    FShape:= CreateRectShape;
    FShape.Color:= ShapeColor;
    FShape.PenWidth:= PenWidth;
    Point.x:= Left;
    Point.y:= Top;
    Point:= Parent.ClientToScreen(Point);
    FShape.Point:= Point;
    FShape.Add(Control);
    FShape.DrowOn(Control.Parent);
    if Control is TWinControl then
      SendMessage(TWinControl(Control).Handle,RM_START,Integer(Control),0)
    else
      SendMessage(Control.Parent.Handle,RM_START,Integer(Control),0);
  end;
end;

procedure TSmallRect.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TSmallRect.MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FShape) then
  begin
    FShape.DrowUp;
    FShape.Free;
    FShape:= nil;
    if Control is TWinControl then
      SendMessage(TWinControl(Control).Handle,RM_FINISH,MakeLong(HandlerRect.SLeft,HandlerRect.STop),MakeLong(HandlerRect.SWidth,HandlerRect.SHeight))
    else
      SendMessage(Control.Parent.Handle,RM_FINISH,MakeLong(HandlerRect.SLeft,HandlerRect.STop),MakeLong(HandlerRect.SWidth,HandlerRect.SHeight));
    HandlerRect.SetControl;
    HandlerRect.SWidth:= Control.Width;
    HandlerRect.SHeight:= Control.Height;
    HandlerRect.SLeft:= Control.Left;
    HandlerRect.STop:= Control.Top;
  end;
end;

procedure TSmallRect.Cutting(var X, Y: Integer);
begin
  X:= (X div CutSizeX) * CutSizeX;
  Y:= (Y div CutSizeY) * CutSizeY;
end;

{/MouseMove/}
procedure TMigiueRect.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Point:TPoint;
begin
  if Color = ColorSingle then
    Cursor := crSizeNESW;

  if Assigned(FShape) then
  begin
    Cutting(X, Y);
    Point.x:= Left;
    Point.y:= Top + Y;
    Point:= Parent.ClientToScreen(Point);
    FShape.SetWidth(Control.Width - (FX-X));
    FShape.SetHeight(Control.Height - Y);
    FShape.Drow(Point);
  end;
end;

procedure TMigishitaRect.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Point:TPoint;
begin
  if Color = ColorSingle then
    Cursor := crSizeNWSE;

  if Assigned(FShape) then
  begin
    Cutting(X, Y);
    Point.x:= Left;
    Point.y:= Top;
    Point:= Parent.ClientToScreen(Point);
    FShape.SetWidth(Control.Width - (FX-X));
    FShape.SetHeight(Control.Height - (FY-Y));
    FShape.Drow(Point);
  end;
end;

procedure THidariueRect.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Point:TPoint;
begin
  if Color = ColorSingle then
    Cursor := crSizeNWSE;

  if Assigned(FShape) then
  begin
    Cutting(X, Y);
    Point.x:= Left + X;
    Point.y:= Top + Y;
    Point:= Parent.ClientToScreen(Point);
    FShape.SetWidth(Control.Width - X);
    FShape.SetHeight(Control.Height - Y);
    FShape.Drow(Point);
  end;
end;

procedure THidarishitaRect.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Point:TPoint;
begin
  if Color = ColorSingle then
    Cursor := crSizeNESW;

  if Assigned(FShape) then
  begin
    Cutting(X, Y);
    Point.x:= Left + X;
    Point.y:= Top;
    Point:= Parent.ClientToScreen(Point);
    FShape.SetWidth(Control.Width - X);
    FShape.SetHeight(Control.Height - (FY-Y));
    FShape.Drow(Point);
  end;
end;

{/MouseUp/}
procedure TMigiueRect.MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);
var
  NewLeft, NewTop, NewWidth, NewHeight: Integer;
begin
  Cutting(X, Y);
  NewLeft:= Control.Left;
  NewWidth:= Control.Width + (X - FX);
  NewTop:= Control.Top + (Y - FY);
  NewHeight:= Control.Height - (Y - FY);
  if (NewWidth >=0) and (NewHeight >=0) then
    Control.SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
  if (NewWidth <0) and (NewHeight >=0) then
    Control.SetBounds(Control.Left + NewWidth, NewTop, -NewWidth, NewHeight);
  if (NewWidth >=0) and (NewHeight <0) then
    Control.SetBounds(NewLeft, Control.Top + Control.Height, NewWidth, -NewHeight);
  if (NewWidth <0) and (NewHeight <0) then
    Control.SetBounds(Control.Left + NewWidth, Control.Top + Control.Height, -NewWidth, -NewHeight);
  inherited;
end;

procedure TMigishitaRect.MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);
var
  NewLeft, NewTop, NewWidth, NewHeight: Integer;
begin
  Cutting(X, Y);
  NewLeft:= Control.Left;
  NewWidth:= Control.Width + (X - FX);
  NewTop:= Control.Top;
  NewHeight:= Control.Height + (Y - FY);
  if (NewWidth >=0) and (NewHeight >=0) then
    Control.SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
  if (NewWidth <0) and (NewHeight >=0) then
    Control.SetBounds(Control.Left + NewWidth, NewTop, -NewWidth, NewHeight);
  if (NewWidth >=0) and (NewHeight <0) then
    Control.SetBounds(NewLeft, Control.Top + NewHeight, NewWidth, -NewHeight);
  if (NewWidth <0) and (NewHeight <0) then
    Control.SetBounds(Control.Left + NewWidth, Control.Top + NewHeight, -NewWidth, -NewHeight);
  inherited;
end;

procedure THidariueRect.MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);
var
  NewLeft, NewTop, NewWidth, NewHeight: Integer;
begin
  Cutting(X, Y);
  NewLeft:= Control.Left + (X - FX);
  NewWidth:= Control.Width - (X - FX);
  NewTop:= Control.Top + (Y - FY);
  NewHeight:= Control.Height - (Y - FY);
  if (NewWidth >=0) and (NewHeight >=0) then
    Control.SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
  if (NewWidth <0) and (NewHeight >=0) then
    Control.SetBounds(Control.Left + Control.Width, NewTop, -NewWidth, NewHeight);
  if (NewWidth >=0) and (NewHeight <0) then
    Control.SetBounds(NewLeft, Control.Top + Control.Height, NewWidth, -NewHeight);
  if (NewWidth <0) and (NewHeight <0) then
    Control.SetBounds(Control.Left + Control.Width, Control.Top + Control.Height, -NewWidth, -NewHeight);
  inherited;
end;

procedure THidarishitaRect.MouseUp(Button: TMouseButton;
                      Shift: TShiftState; X, Y: Integer);
var
  NewLeft, NewTop, NewWidth, NewHeight: Integer;
begin
  Cutting(X, Y);
  NewLeft:= Control.Left + (X - FX);
  NewWidth:= Control.Width - (X - FX);
  NewTop:= Control.Top;
  NewHeight:= Control.Height + (Y - FY);
  if (NewWidth >=0) and (NewHeight >=0) then
    Control.SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
  if (NewWidth <0) and (NewHeight >=0) then
    Control.SetBounds(Control.Left + Control.Width, NewTop, -NewWidth, NewHeight);
  if (NewWidth >=0) and (NewHeight <0) then
    Control.SetBounds(NewLeft, Control.Top + NewHeight, NewWidth, -NewHeight);
  if (NewWidth <0) and (NewHeight <0) then
    Control.SetBounds(Control.Left + Control.Width, Control.Top + NewHeight, -NewWidth, -NewHeight);
  inherited;
end;



{/SetControl/}
procedure TMigiueRect.SetControl;
var
  NewLeft, NewTop: Integer;
begin
  NewLeft:= Control.Left + Control.Width - Size +2;
  NewTop:= Control.Top -2;
  SetBounds(NewLeft,NewTop,Size,Size);
end;

procedure TMigiShitaRect.SetControl;
var
  NewLeft, NewTop: Integer;
begin
  NewLeft:= Control.Left + Control.Width - Size +2;
  NewTop:= Control.Top + Control.Height - Size +2;
  SetBounds(NewLeft,NewTop,Size,Size);
end;

procedure THidariueRect.SetControl;
var
  NewLeft, NewTop: Integer;
begin
  NewLeft:= Control.Left -2;
  NewTop:= Control.Top -2;
  SetBounds(NewLeft,NewTop,Size,Size);
end;

procedure THidarishitaRect.SetControl;
var
  NewLeft, NewTop: Integer;
begin
  NewLeft:= Control.Left -2;
  NewTop:= Control.Top + Control.Height - Size +2;
  SetBounds(NewLeft,NewTop,Size,Size);
end;

end.
