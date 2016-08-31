unit DsnSubRS;

// Runtime Design System Version 2.x   1998/06/08-
// Copyright Kazuhiro Sasaki 1997-1998.

interface

uses
  Windows, Classes, Forms, Controls, Messages, Dialogs, Graphics,
  DsnHandle, DsnShape, DsnUnit, DsnSub8, DsnSubMl;

type
  TDsnRSRegister = class(TDsnMlRegister)
  protected
    procedure CreateHandler;override;
    procedure Resized(Control:TControl;var Message: TResizeMessage);override;
  end;

  TMultiRSHandler = class(TMultiHandler)
  protected
    function CreateHandlerRect(Control:TControl):THandlerRect;override;
  end;

  THandlerRSRect = class(THandlerRect)
  protected
    procedure CreateSmallRect;override;
  end;


  //procedure Register;


implementation

procedure TDsnRSRegister.CreateHandler;
begin
  FHandler:= TMultiRSHandler.Create;
end;

procedure TDsnRSRegister.Resized(Control:TControl;var Message: TResizeMessage);
var
  SW,SH:Single;
  i:integer;
  NewLeft, NewTop, NewWidth, NewHeight: Integer;
  Ctrl: TControl;
begin
  SW:= Control.Width/Message.SWidth;
  SH:= Control.Height/Message.SHeight;
  if Control.Left <> Message.SLeft then
    SW:= -SW;
  if Control.Top <> Message.STop then
    SH:= -SH;
  if Assigned(FTargetList) then
    for i:= 0 to FTargetList.Count -1 do
      if TControl(FTargetList[i]) <> Control then
      begin
        Ctrl:= TControl(FTargetList[i]);
        //ShowMessage(Ctrl.Name);
        NewWidth:= Abs(Round(SW * Ctrl.Width));
        NewHeight:= Abs(Round(SH * Ctrl.Height));
        NewLeft:= Ctrl.Left;
        if (SW > 0) then
          NewLeft:= Ctrl.Left;
        if (SW < 0)  then
        begin
          NewLeft:= Ctrl.Left - (NewWidth - Ctrl.Width);
          if Control.Left = (Message.SLeft + Message.SWidth) then
            NewLeft:= Ctrl.Left + Ctrl.Width;
          if (Control.Left + Control.Width) = Message.SLeft then
            NewLeft:= Ctrl.Left - NewWidth;
        end;
        NewTop:= Ctrl.Top;
        if (SH > 0) then
          NewTop:= Ctrl.Top;
        if (SH < 0)  then
        begin
          NewTop:= Ctrl.Top - (NewHeight - Ctrl.Height);
          if Control.Top = (Message.STop + Message.SHeight) then
            NewTop:= Ctrl.Top + Ctrl.Height;
          if (Control.Top + Control.Height) = Message.STop then
            NewTop:= Ctrl.Top - NewHeight;
        end;
        Cutting(NewWidth, NewHeight);
        Cutting(NewLeft, NewTop);
        Ctrl.SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
      end;

  if Assigned(FHandler) then
    FHandler.SetPosition;
end;

function TMultiRSHandler.CreateHandlerRect(Control:TControl):THandlerRect;
begin
  Result:= THandlerRSRect.Create(Control,Size,CutSizeX,CutSizeY,PenWidth,ColorMulti,ColorSingle,Color);
end;

procedure THandlerRSRect.CreateSmallRect;
var
  SmallRect:TSmallRect;
begin
  if Assigned(SmallRects) then
  begin
    SmallRect:= TMigishitaRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRect.ColorMulti:= SmallRect.ColorSingle;
    SmallRects.Add(SmallRect);
    {SmallRect:= TMigiueRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRect.ColorMulti:= SmallRect.ColorSingle;
    SmallRects.Add(SmallRect);
    SmallRect:= THidariueRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRect.ColorMulti:= SmallRect.ColorSingle;
    SmallRects.Add(SmallRect);
    SmallRect:= THidarishitaRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRect.ColorMulti:= SmallRect.ColorSingle;
    SmallRects.Add(SmallRect);
    SmallRect:= TNakaueRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRect.ColorMulti:= SmallRect.ColorSingle;
    SmallRects.Add(SmallRect);
    SmallRect:= TNakashitaRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRect.ColorMulti:= SmallRect.ColorSingle;
    SmallRects.Add(SmallRect);
    SmallRect:= TNakamigiRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRect.ColorMulti:= SmallRect.ColorSingle;
    SmallRects.Add(SmallRect);
    SmallRect:= TNakahidariRect.Create2(Control,Size,CutSizeX,CutSizeY,ColorMulti,ColorSingle);
    SmallRect.ColorMulti:= SmallRect.ColorSingle;
    SmallRects.Add(SmallRect); }
  end;
end;
{
procedure Register;
begin
  RegisterComponents('DsnSys', [TDsnRSRegister]);
end;
}
end.
