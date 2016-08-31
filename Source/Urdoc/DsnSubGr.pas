unit DsnSubGr;

// Runtime Design System Version 2.x   1998/06/08-
// Copyright Kazuhiro Sasaki 1997-1998.

interface

uses
  Windows, Classes, Forms, Controls, Messages, Dialogs, Graphics,
  DsnHandle, DsnUnit, DsnSubMl, DsnMes;

type
  TDsnGrRegister = class(TDsnMlRegister)
  private
  protected
    OnPaint:TNotifyEvent;
    procedure SetDesigning(Value:Boolean);override;
    procedure CreateHandler;override;
    procedure Selected(Control:TControl;var Message: TMessage);override;
    procedure PaintCanvas(Sender:TObject);
    function CreateSubCtrl(AParent:TWinControl):TDsnCtrl;override;
  public
    constructor Create(AOwner: TComponent);override;
  end;

  TMultiGrHandler = class(TMultiHandler)
  protected
    function CreateHandlerGrRect(Control:TControl):THandlerRect;
  public
    procedure Add(Item:Pointer);override;
  end;

  THandlerGrRect = class(THandlerRect)
  public
    constructor Create(AControl:TControl;ASize,ACutSizeX,ACutSizeY,APenWidth:Integer;clMulti,clSingle,ShapeColor:TColor);
    destructor Destroy; override;
    procedure SetControl;override;
  end;

  TDsnGrCtrl = class(TDsnCtrl)
  protected
    procedure ClientPaint(var Message: TWMPaint);override;
  end;

  procedure Register;

implementation

uses UNewControls;

constructor TDsnGrRegister.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OnPaint:= nil;
end;

procedure TDsnGrRegister.SetDesigning(Value:Boolean);
begin
  OnPaint:= nil;
  inherited;
end;

procedure TDsnGrRegister.CreateHandler;
begin
  FHandler:= TMultiGrHandler.Create;
end;

procedure TDsnGrRegister.PaintCanvas(Sender:TObject);
var
  Left,Top,Width,Height,i,h:Integer;
  ACanvas:TCanvas;
begin
  if Sender is TWinControl then
    for i:= 0 to TWinControl(Sender).ControlCount -1 do
      if FTargetList.IndexOf(TWinControl(Sender).Controls[i]) > -1 then
        if TWinControl(Sender).Controls[i] is TGraphicControl then
          PaintCanvas(TWinControl(Sender).Controls[i]);

  if FTargetList.IndexOf(Sender) > -1 then
  begin
    ACanvas:=TCanvas.Create;
    if (Sender is TWinControl) then
      if TWinControl(Sender).HandleAllocated then
        try
          h:= GetDC(TWinControl(Sender).Handle)
        except
          h:= 0;
        end
      else
        h:= 0
    else
      if TControl(Sender).Parent.HandleAllocated then
        try
          h:= GetDC(TControl(Sender).Parent.Handle) ;
        except
          h:= 0;
        end
      else
        h:= 0;
    if not (Sender is TWinControl) then
    begin
      Left:= TControl(Sender).Left;
      Top:= TControl(Sender).Top;
    end
    else
    begin
      Left:= 0;
      Top:= 0;
    end;

    Width:= TControl(Sender).ClientWidth;
    Height:= TControl(Sender).ClientHeight;

    if h <> 0 then
    begin
      ACanvas.Handle:= h;
      ACanvas.Brush.Color:= clGray;
      ACanvas.Pen.Color:= clGray;
      ACanvas.Rectangle(Left,Top,Left+SizeRectMultiSelect,Top+SizeRectMultiSelect);
      ACanvas.Rectangle(Left+Width-SizeRectMultiSelect,Top,Left+Width,Top+SizeRectMultiSelect);
      ACanvas.Rectangle(Left,Top+Height-SizeRectMultiSelect,Left+SizeRectMultiSelect,Top+Height);
      ACanvas.Rectangle(Left+Width-SizeRectMultiSelect,Top+Height-SizeRectMultiSelect,Left+Width,Top+Height);
      ReleaseDC(h,ACanvas.Handle);
    end;
    ACanvas.Free;
  end;
end;

procedure TDsnGrRegister.Selected(Control:TControl;var Message: TMessage);
begin
  if FTargetList.Count > 1 then
    OnPaint:= PaintCanvas
  else
    OnPaint:= nil;
end;

function TDsnGrRegister.CreateSubCtrl(AParent:TWinControl):TDsnCtrl;
begin
  Result:= TDsnGrCtrl.CreateInstance(AParent);
end;

function TMultiGrHandler.CreateHandlerGrRect(Control:TControl):THandlerRect;
begin
  Result:= THandlerGrRect.Create(Control,Size,CutSizeX,CutSizeY,PenWidth,ColorMulti,ColorSingle,Color);
end;

procedure TMultiGrHandler.Add(Item:Pointer);
var
  HandlerRect: THandlerRect;
  i:integer;
  Control:TControl;
begin
  Control:= TControl(Item);
  if (Control = nil) or (Control is TSmallRect) then
    Exit;

//  if (Control is TBoundLabel) then
//    exit;

  if FList = nil then
    FList:= TList.Create;
  for i:= 0 to FList.Count -1 do
    if THandlerRect(FList[i]).Control = Control then
      Exit;

  if FList.Count > 1 then
  begin
    HandlerRect:= CreateHandlerGrRect(Control);
    FList.Add(HandlerRect);
  end;

  if FList.Count = 1 then
  begin
    HandlerRect:= CreateHandlerGrRect(THandlerRect(FList[0]).Control);
    THandlerRect(FList[0]).Free;
    FList.Delete(0);
    FList.Add(HandlerRect);
    HandlerRect:= CreateHandlerGrRect(Control);
    FList.Add(HandlerRect);
  end;

  if FList.Count = 0 then
  begin
    HandlerRect:= CreateHandlerRect(Control);
    FList.Add(HandlerRect);
  end;

  if Control is TWinControl then
    SendMessage(TWinControl(Control).Handle,MH_SELECT,0,0)
  else
    SendMessage(Control.Parent.Handle,MH_SELECT,0,0);

end;

constructor THandlerGrRect.Create(AControl:TControl;ASize,ACutSizeX,ACutSizeY,APenWidth:Integer;clMulti,clSingle,ShapeColor:TColor);
begin
  Control:= AControl;
end;

destructor THandlerGrRect.Destroy;
begin
  if Assigned(Control) then
    Control.Invalidate;
  inherited;
end;

procedure THandlerGrRect.SetControl;
begin
  if Control is TWinControl then
    Control.Repaint
  else
    Control.Parent.Repaint;
end;

procedure TDsnGrCtrl.ClientPaint(var Message: TWMPaint);
begin
  inherited;
  if Assigned(DsnRegister) then
    if Assigned(TDsnGrRegister(DsnRegister).OnPaint) then
      if Assigned(Client) then
        TDsnGrRegister(DsnRegister).OnPaint(Client);
end;

procedure Register;
begin
  RegisterComponents('DsnSys', [TDsnGrRegister]);
end;

end.
