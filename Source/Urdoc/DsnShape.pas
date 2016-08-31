unit DsnShape;

// Runtime Design System Version 2.x   1998/06/08-
// Copyright Kazuhiro Sasaki 1997-1998.

interface

uses
  Windows, Classes, Forms, Controls, Messages, Dialogs, Graphics;

type

  TFundamentalShape = class;

  TMultiShape = class
  private
  protected
    FList: TList;
    FRect: TRect;
    FDC:HDC;
    CV: TCanvas;
    function CreateAddShape:TFundamentalShape; virtual;
    function CreateAddNewShape:TFundamentalShape; virtual;
  public
    Point: TPoint;
    Color:TColor;
    PenWidth:Integer;
    PenStyle:TPenStyle;
    procedure Add(Control:TControl);
    procedure AddNew;
    procedure DrowOn(Parent:TWinControl); virtual;
    procedure Drow(NewPoint:TPoint); virtual;
    procedure DrowUp; virtual;
    procedure SetWidth(Value:integer);
    procedure SetHeight(Value:integer);
    constructor Create;
    destructor  Destroy; override;
  end;

  TFundamentalShape = class
  private
  protected
    aWidth:integer;
    aHeight:integer;
    FOldRect:TRect;
    CV: TCanvas;
    SPoint:TPoint;
  public
    PenWidth:Integer;
    PenStyle:TPenStyle;
    Color:TColor;
    FShaping:Integer;
    procedure SetBounds(aLeft,aTop:Integer);virtual;
    constructor Create(aCV:TCanvas);
  end;


implementation

{TMultiShape}
constructor TMultiShape.Create;
begin
  Color:= clGray;
  PenWidth:=2;
  PenStyle:= psSolid;
  FDC:=GetDC(0);
  CV:= TCanvas.Create;
  CV.Handle:= FDC;
end;

procedure TMultiShape.Drow(NewPoint:TPoint);
var
  i:integer;
begin
  for i:= 0 to FList.Count -1 do
    TFundamentalShape(FList[i]).SetBounds(NewPoint.x, NewPoint.y)
end;

procedure TMultiShape.DrowOn(Parent:TWinControl);
var
  PT:TPoint;
begin
  PT.x:= 0;
  PT.y:= 0;
  PT:= Parent.ClientToScreen(PT);
  FRect.Left:=PT.x;
  FRect.Top:=PT.y;
  FRect.Right:=PT.x + Parent.Width;
  FRect.Bottom:=PT.y + Parent.Height;
  ClipCursor(@FRect);
end;

procedure TMultiShape.DrowUp;
var
  i:integer;
begin
  ClipCursor(nil);
  for i:= 0 to FList.Count -1 do
  begin
    TFundamentalShape(FList[i]).FShaping:= 2;
    TFundamentalShape(FList[i]).SetBounds(0,0);
  end;
end;

function TMultiShape.CreateAddShape:TFundamentalShape;
begin
  Result:= TFundamentalShape.Create(CV);
end;

function TMultiShape.CreateAddNewShape:TFundamentalShape;
begin
  Result:= TFundamentalShape.Create(CV);
end;

procedure TMultiShape.Add(Control:TControl);
var
  Shape: TFundamentalShape;
begin
  if Control = nil then
    Exit;
  if FList = nil then
    FList:= TList.Create;
  Shape:= CreateAddShape;//TFundamentalShape.Create(CV);
  FList.Add(Shape);
  Shape.Color:= Color;
  Shape.PenWidth:= PenWidth;
  Shape.PenStyle:= PenStyle;
  Shape.aWidth:= Control.Width;
  Shape.aHeight:= Control.Height;
  Shape.SPoint.x:= Control.Left;
  Shape.SPoint.y:= Control.Top;
  Shape.SPoint:= Control.Parent.ClientToScreen(Shape.SPoint);
  Shape.SPoint.x:= Shape.SPoint.x - Point.x;
  Shape.SPoint.y:= Shape.SPoint.y - Point.y;
end;

procedure TMultiShape.AddNew;
var
  Shape: TFundamentalShape;
  i:integer;
begin
  if Assigned(FList) then
  begin
    for i:= 0 to FList.Count -1 do
      TFundamentalShape(FList[i]).Free;
    FList.Free;
  end;
  FList:= TList.Create;
  Shape:= CreateAddNewShape;//TFundamentalShape.Create(CV);
  FList.Add(Shape);
  Shape.Color:= Color;
  Shape.PenWidth:= PenWidth;
  Shape.PenStyle:= PenStyle;
  Shape.aWidth:= 0;
  Shape.aHeight:= 0;
  Shape.SPoint.x:= 0;
  Shape.SPoint.x:= 0;
end;

destructor TMultiShape.Destroy;
var
  i:integer;
begin
  if Assigned(FList) then
  begin
    for i:= 0 to FList.Count -1 do
      TFundamentalShape(FList[i]).Free;
    FList.Free;
  end;
  ReleaseDC(0, FDC);
  CV.Free;
  inherited Destroy;
end;

procedure TMultiShape.SetWidth(Value:integer);
begin
  TFundamentalShape(FList[0]).aWidth:= Value;
end;

procedure TMultiShape.SetHeight(Value:integer);
begin
  TFundamentalShape(FList[0]).aHeight:= Value;
end;

{TFundamentalShape}
constructor TFundamentalShape.Create(aCV:TCanvas);
begin
  FShaping:=0;
  Color:=clGray;
  PenWidth:=20;
  PenStyle:=psSolid;
  CV:= aCV;
end;

procedure TFundamentalShape.SetBounds(aLeft,aTop:Integer);
var
  W:Integer;
begin
  CV.Pen.Mode:=pmXor;
  W:=PenWidth;
  CV.Pen.Width:=W;
  CV.Pen.Style:=PenStyle;
  aLeft:= aLeft + SPoint.x;
  aTop:= aTop + SPoint.y;

  W:= 0;
  if FShaping > 0 then
  begin
    CV.MoveTo(FOldRect.Left,FOldRect.Top);
    CV.LineTo(FOldRect.Right,FOldRect.Top);
    CV.MoveTo(FOldRect.Right,FOldRect.Top+W);
    CV.LineTo(FOldRect.Right,FOldRect.Bottom-W);

    CV.MoveTo(FOldRect.Right,FOldRect.Bottom);
    CV.LineTo(FOldRect.Left,FOldRect.Bottom);
    CV.MoveTo(FOldRect.Left,FOldRect.Bottom-W);
    CV.LineTo(FOldRect.Left,FOldRect.Top+W);
  end;
  if FShaping < 2 then
  begin
    CV.Pen.Color:= Color;
    FOldRect.Left:=aLeft; FOldRect.Right:=aLeft+aWidth;
    FOldRect.Top:=aTop; FOldRect.Bottom:=aTop+aHeight;
    CV.MoveTo(FOldRect.Left,FOldRect.Top);
    CV.LineTo(FOldRect.Right,FOldRect.Top);
    CV.MoveTo(FOldRect.Right,FOldRect.Top+W);
    CV.LineTo(FOldRect.Right,FOldRect.Bottom-W);
    CV.MoveTo(FOldRect.Right,FOldRect.Bottom);
    CV.LineTo(FOldRect.Left,FOldRect.Bottom);
    CV.MoveTo(FOldRect.Left,FOldRect.Bottom-W);
    CV.LineTo(FOldRect.Left,FOldRect.Top+W);
    FShaping:=1;
  end;


end;


end.
