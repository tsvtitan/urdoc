unit DsnSubMl;

// Runtime Design System Version 2.x   June/08/1998
// Copyright(c) 1998 Kazuhiro Sasaki.

interface

uses
  Windows, Classes, Forms, Controls, Messages, Dialogs, Graphics,
  DsnHandle, DsnShape, DsnUnit;

const
//  DS_PENCOLOR = clRed;
//  DS_PENCOLOR = clGreen;
//  DS_PENCOLOR = clAqua;
//  DS_PENCOLOR = clFuchsia;
//  DS_PENCOLOR = clLime;
//  DS_PENCOLOR = clSilver;
//  DS_PENCOLOR = clTeal;
//  DS_PENCOLOR = clPurple;
//  DS_PENCOLOR = clNavy;
//  DS_PENCOLOR = clOlive;
//  DS_PENCOLOR = clMaroon;
    DS_PENCOLOR = clGray;

type
  TDsnMlRegister = class(TDsnRegister)
  protected
    FDotShape: TMultiShape;
    procedure MouseDown(Client:TWinControl; Target:TComponent; MousePoint:TPoint; Shift: TShiftState);override;
    procedure MoseMove(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);override;
    procedure MoseUp(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);override;
    procedure MouseDownMove(Client:TWinControl; Target:TComponent; MousePoint:TPoint; Shift: TShiftState);override;
    procedure MouseMoveMove(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);override;
    procedure MouseUpMove(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);override;
    procedure RButtonDown(Client:TWinControl; Target:TControl; XPos,YPos: Integer);override;
    procedure MouseDownCtrlKey(Client:TWinControl; Target:TComponent; MousePoint:TPoint; Shift: TShiftState);virtual;
    procedure MouseMoveCtrlKey(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);virtual;
    procedure MouseUpCtrlKey(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);virtual;
    procedure CreateDotShape;virtual;
  end;

  procedure Register;

implementation

procedure TDsnMlRegister.MouseDown(Client:TWinControl; Target:TComponent; MousePoint:TPoint; Shift: TShiftState);
var
  Template:TControl;
begin
  Template:= nil;
  if Assigned(DsnPanel) then
    Template:= TControl(DsnPanel.GetTemplate);

  if Assigned(Template) then
    MouseDownCreate(Client,Target,MousePoint,Shift)
  else
  if ssCtrl in Shift then
    MouseDownCtrlKey(Client,Target,MousePoint,Shift)
  else
  if Target is TDsnStage then
    MouseDownCtrlKey(Client,Target,MousePoint,Shift)
  else
    MouseDownMove(Client,Target,MousePoint,Shift);
end;

procedure TDsnMlRegister.MoseMove(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);
var
  Template:TControl;
begin
  Template:= nil;
  if Assigned(DsnPanel) then
    Template:=  TControl(DsnPanel.GetTemplate);

  if Assigned(Template) then
    MouseMoveCreate(Client,MousePoint,Shift)
  else
  if Assigned(FDotShape) then
    MouseMoveCtrlKey(Client,MousePoint,Shift)
  else if ssLeft in Shift then
    MouseMoveMove(Client,MousePoint,Shift)
  else
  begin
    if Assigned(FShape) then
    begin
      FShape.DrowUp;
      FShape.Free;
      FShape:= nil;
    end;
  end;
end;

procedure TDsnMlRegister.MoseUp(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);
var
  Template:TControl;
begin
  Template:= nil;
  if Assigned(DsnPanel) then
    Template:=  TControl(DsnPanel.GetTemplate);

  if Assigned(Template) then
      MouseUpCreate(Client,MousePoint,Shift)
  else
  if Assigned(FDotShape) then
    MouseUpCtrlKey(Client,MousePoint,Shift)
  else
    MouseUpMove(Client,MousePoint,Shift);
end;

procedure TDsnMlRegister.MouseDownMove(Client:TWinControl; Target:TComponent; MousePoint:TPoint; Shift: TShiftState);
var
  n,i: integer;
  CanSelect: TSelectAccept;
begin
  CanSelect:= [saCreate, saMove];

  if Assigned(DsnStage) then
    if Assigned(DsnStage.OnSelectQuery) then
      DsnStage.OnSelectQuery(DsnStage, Target, CanSelect);

  if saMove in CanSelect then
  begin
    if Client = Target then
      FParentCtrl:= Client.Parent
    else
      FParentCtrl:= Client;

    if FTargetList = nil then
      FTargetList:= CreateList;

    if ssShift in Shift then
    begin
      n:= FTargetList.IndexOf(Target);
      if n > -1 then
        FTargetList.Delete(n)
      else
        FTargetList.Add(Target);
    end
    else
    begin
      n:= FTargetList.Count;
      if n > 0 then
      begin
        n:= FTargetList.IndexOf(Target);
        if (n = -1) or not SameParent then
        begin
          FTargetList.Clear;
          FTargetList.Add(Target);
        end;
      end
      else
      begin
        FTargetList.Add(Target);
      end;
    end;

    if Assigned(Target) then
    begin
      if SameParent and not (ssShift in Shift)  then
      begin
        //Application.ProcessMessages;
        CreateMoveShape;
        FShape.Color:= Color;
        FShape.PenWidth:= PenWidth;
        Cutting(MousePoint.x,MousePoint.y);
        FX:= MousePoint.x;
        FY:= MousePoint.y;
        MousePoint:= FParentCtrl.ClientToScreen(MousePoint);
        FShape.Point:= MousePoint;
        for i:= 0 to FTargetList.Count -1 do
          FShape.Add(FTargetList[i]);
        FShape.DrowOn(FParentCtrl);
      end;

    end;
  end;
end;

procedure TDsnMlRegister.MouseMoveMove(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);
begin
  if Assigned(FShape) then
  begin
    Cutting(MousePoint.x,MousePoint.y);
    if SameParent and not (ssShift in Shift) then
    begin
      MousePoint:= FParentCtrl.ClientToScreen(MousePoint);
      FShape.Drow(MousePoint);
    end;
  end;
end;

procedure TDsnMlRegister.MouseUpMove(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);
var
  i,DX,DY:integer;
  CanMove: Boolean;
begin
  Cutting(MousePoint.x,MousePoint.y);
  if SameParent then
    if Assigned(FShape) and not (ssShift in Shift) then
    begin
      FShape.DrowUp;
      FShape.Free;
      FShape:= nil;
      if Assigned(FTargetList) then
        for i:= 0 to FTargetList.Count -1 do
        begin
          CanMove:= True;
          if Assigned(DsnStage.OnMoveQuery) then
            DsnStage.OnMoveQuery(DsnStage,FTargetList[i],CanMove);
          if CanMove then
          begin
            TControl(FTargetList[i]).Left:= TControl(FTargetList[i]).Left + (MousePoint.x - FX);
            TControl(FTargetList[i]).Top:= TControl(FTargetList[i]).Top + (MousePoint.y - FY);
          end;
        end;
    end;

  DX:= FX- MousePoint.x;
  DY:= FY- MousePoint.y;
  if (DX <> 0) or (DY <> 0) then
    Moved(DX,DY);

  if Assigned(FTargetList) then
    FTargetList.SetPosition;
end;

procedure TDsnMlRegister.RButtonDown(Client:TWinControl; Target:TControl; XPos,YPos: Integer);
var
  n: integer;
  CanSelect: TSelectAccept;
begin
  CanSelect:= [saCreate, saMove];

  if Assigned(DsnStage) then
    if Assigned(DsnStage.OnSelectQuery) then
      DsnStage.OnSelectQuery(DsnStage, Target, CanSelect);

  if Target is TDsnStage then
    CanSelect:= [saCreate];

  if saMove in CanSelect then
  begin
    if Client = Target then
      FParentCtrl:= Client.Parent
    else
      FParentCtrl:= Client;

    if FTargetList = nil then
      FTargetList:= CreateList;

    n:= FTargetList.Count;
    if n > 0 then
    begin
      n:= FTargetList.IndexOf(Target);
      if (n = -1) or not SameParent then
      begin
        FTargetList.Clear;
        FTargetList.Add(Target);
      end;
    end
    else
    begin
      FTargetList.Add(Target);
    end;

    FTargetList.SetPosition;
  end;
end;

procedure TDsnMlRegister.MouseDownCtrlKey(Client:TWinControl; Target:TComponent; MousePoint:TPoint; Shift: TShiftState);
begin
  if csAcceptsControls in Client.ControlStyle then
    FParentCtrl:= Client
  else
  begin
    FParentCtrl:= Client.Parent;
    Inc(MousePoint.x, Client.Left);
    Inc(MousePoint.y, Client.Top);
  end;

  CreateDotShape;
//  FDotShape.Color:= DS_PENCOLOR;
  FDotShape.Color:= clBlack;

  FDotShape.PenWidth:= 1;
  FDotShape.PenStyle:= psDot;
  Cutting(MousePoint.x,MousePoint.y);
  FX:= MousePoint.x;
  FY:= MousePoint.y;
  FDotShape.Point:= MousePoint;
  FDotShape.AddNew;
  FDotShape.DrowOn(FParentCtrl);
end;

procedure TDsnMlRegister.MouseMoveCtrlKey(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);
begin
  Cutting(MousePoint.x,MousePoint.y);
  if not (csAcceptsControls in Client.ControlStyle) then
  begin
    Inc(MousePoint.x,Client.Left);
    Inc(MousePoint.y,Client.Top);
  end;
  FDotShape.SetWidth(MousePoint.x - FX);
  FDotShape.SetHeight(MousePoint.y - FY);
  MousePoint.x:= FX;
  MousePoint.y:= FY;
  MousePoint:= FParentCtrl.ClientToScreen(MousePoint);
  FDotShape.Drow(MousePoint);
end;

procedure TDsnMlRegister.MouseUpCtrlKey(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);
var
  PenRect, CtrlRect, Dummy: TRect;
  Ctrl: TControl;
  i: integer;
  NewWidth, NewHeight: Integer;
  CanSelect: TSelectAccept;
begin
  if not (csAcceptsControls in Client.ControlStyle) then
  begin
    Inc(MousePoint.x,Client.Left);
    Inc(MousePoint.y,Client.Top);
  end;
  FDotShape.DrowUp;
  FDotShape.Free;
  FDotShape:= nil;

  if FTargetList = nil then
    FTargetList:= CreateList;

  FTargetList.Clear;

  NewWidth:= MousePoint.x - FX;
  NewHeight:= MousePoint.y - FY;

  if (NewWidth >=0) and (NewHeight >=0) then
    SetRect(PenRect, FX, FY, FX+NewWidth, FY+NewHeight);
  if (NewWidth <0) and (NewHeight >=0) then
    SetRect(PenRect, FX + NewWidth, FY, FX, FY+NewHeight);
  if (NewWidth >=0) and (NewHeight <0) then
    SetRect(PenRect, FX, FY + NewHeight, FX+NewWidth, FY);
  if (NewWidth <0) and (NewHeight <0) then
    SetRect(PenRect, FX + NewWidth, FY + NewHeight, FX, FY);

  for i:= 0 to FParentCtrl.ControlCount -1 do
  begin
    Ctrl:= FParentCtrl.Controls[i];
    CanSelect:= [saCreate, saMove];
    if Assigned(DsnStage.OnSelectQuery) then
      DsnStage.OnSelectQuery(DsnStage, Ctrl, CanSelect);
    SetRect(CtrlRect, Ctrl.Left, Ctrl.Top, Ctrl.Left+Ctrl.Width, Ctrl.Top+Ctrl.Height);
    if ((saMove in CanSelect) and
           IntersectRect(Dummy, PenRect, CtrlRect)) then
        FTargetList.Add(Ctrl);
  end;
  FTargetList.SetPosition;
end;

procedure TDsnMlRegister.CreateDotShape;
begin
  FDotShape:= TMultiShape.Create;
end;

procedure Register;
begin
  RegisterComponents('DsnSys', [TDsnMlRegister]);
end;

end.
