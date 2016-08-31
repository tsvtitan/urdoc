unit DsnSubDp;

// Runtime Design System Version 2.x   1998/06/08-
// Copyright Kazuhiro Sasaki 1997-1998.

interface

uses
  Windows, Classes, Forms, Controls, Messages, Dialogs, Graphics,
  DsnHandle, DsnSub8, DsnSubGr;

type
  TPaintCanvas = procedure(Sender:TObject; Canvas:TCanvas) of object;

  TDsnDpRegister = class(TDsnGrRegister)
  protected
    procedure CreateHandler;override;
  end;

  TMultiDpHandler = class(TMultiGrHandler)
  protected
    function CreateHandlerRect(Control:TControl):THandlerRect;override;
  end;

implementation

procedure TDsnDpRegister.CreateHandler;
begin
  FHandler:= TMultiDpHandler.Create;
end;

function TMultiDpHandler.CreateHandlerRect(Control:TControl):THandlerRect;
begin
  Result:= THandler8Rect.Create(Control,Size,CutSizeX,CutSizeY,PenWidth,ColorMulti,ColorSingle,Color);
end;

end.
