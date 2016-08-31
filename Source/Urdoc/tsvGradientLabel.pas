unit tsvGradientLabel;

interface

uses  Windows, Graphics, stdctrls;

type

   TFillDirection=(fdLR,fdRL,fdTB,fdBT);

   TtsvGradientLabel=class(TCustomLabel)
   private
     FFromColor: TColor;
     FToColor: TColor;
     FColorCount: Integer;
     procedure FillGradientRect(canvas: tcanvas; Recty: trect;
                                fbcolor, fecolor: tcolor; fcolors:
                                Integer; fdirect: TFillDirection);
   public
     procedure Paint; override;
     property FromColor: TColor read FFromColor write FFromColor;
     property ToColor: TColor read FToColor write FToColor;
     property ColorCount: Integer read FColorCount write FColorCount;
     property Font;
     property Caption;
   end;



implementation

{ TtsvGradientLabel }

procedure TtsvGradientLabel.FillGradientRect(canvas: tcanvas; Recty: trect;
                                          fbcolor, fecolor: tcolor; fcolors: Integer; fdirect: TFillDirection);
var
  i, j, h, w: Integer;
  R, G, B: Longword;
  beginRGBvalue, RGBdifference: array[0..2] of Longword;
begin
  beginRGBvalue[0] := GetRvalue(colortoRGB(FBcolor));
  beginRGBvalue[1] := GetGvalue(colortoRGB(FBcolor));
  beginRGBvalue[2] := GetBvalue(colortoRGB(FBcolor));

  RGBdifference[0] := GetRvalue(colortoRGB(FEcolor)) - beginRGBvalue[0];
  RGBdifference[1] := GetGvalue(colortoRGB(FEcolor)) - beginRGBvalue[1];
  RGBdifference[2] := GetBvalue(colortoRGB(FEcolor)) - beginRGBvalue[2];

  canvas.pen.style := pssolid;
  canvas.pen.mode := pmcopy;

  j := 0;
  h := recty.bottom - recty.top;
  w := recty.right - recty.left;
  R:=0;
  G:=0;
  B:=0;

  case fdirect of
    fdRL: begin

     for i := fcolors downto 0 do begin
      recty.left  := muldiv(i - 1, w, fcolors);
      recty.right := muldiv(i, w, fcolors);
      if fcolors>1 then begin
        R := beginRGBvalue[0] + LongWord(muldiv(j, RGBDifference[0], fcolors));
        G := beginRGBvalue[1] + LongWord(muldiv(j, RGBDifference[1], fcolors));
        B := beginRGBvalue[2] + LongWord(muldiv(j, RGBDifference[2], fcolors));
      end;
      canvas.brush.color := RGB(R, G, B);
      patBlt(canvas.handle, recty.left, recty.top, Recty.right - recty.left, h, patcopy);
      inc(j);
     end;
    end;
    fdLR: begin

     for i :=0 to fcolors do begin
      recty.left  := muldiv(i-1 , w, fcolors);
      recty.right := muldiv(i , w, fcolors);
      if fcolors>1 then begin
        R := beginRGBvalue[0] + LongWord(muldiv(j, RGBDifference[0], fcolors));
        G := beginRGBvalue[1] + LongWord(muldiv(j, RGBDifference[1], fcolors));
        B := beginRGBvalue[2] + LongWord(muldiv(j, RGBDifference[2], fcolors));
      end;
      canvas.brush.color := RGB(R, G, B);
      patBlt(canvas.handle, recty.left, recty.top, Recty.right - recty.left, h, patcopy);
      inc(j);
     end;
    end;
    fdTB: begin

     for i :=0 to fcolors do begin
      recty.Top  := muldiv(i-1 , h, fcolors);
      recty.Bottom := muldiv(i , h, fcolors);
      if fcolors>1 then begin
        R := beginRGBvalue[0] + LongWord(muldiv(j, RGBDifference[0], fcolors));
        G := beginRGBvalue[1] + LongWord(muldiv(j, RGBDifference[1], fcolors));
        B := beginRGBvalue[2] + LongWord(muldiv(j, RGBDifference[2], fcolors));
      end;
      canvas.brush.color := RGB(R, G, B);
      patBlt(canvas.handle, recty.left, recty.top, w,Recty.Bottom - recty.top, patcopy);
      inc(j);
     end;

    end;
    fdBT: begin

     for i :=fcolors downto 0 do begin
      recty.Top  := muldiv(i-1 , h, fcolors);
      recty.Bottom := muldiv(i , h, fcolors);
      if fcolors>1 then begin
        R := beginRGBvalue[0] + LongWord(muldiv(j, RGBDifference[0], fcolors));
        G := beginRGBvalue[1] + LongWord(muldiv(j, RGBDifference[1], fcolors));
        B := beginRGBvalue[2] + LongWord(muldiv(j, RGBDifference[2], fcolors));
      end;
      canvas.brush.color := RGB(R, G, B);
      patBlt(canvas.handle, recty.left, recty.top, w,Recty.Bottom - recty.top, patcopy);
      inc(j);
     end;

    end;
  end;
end;

procedure TtsvGradientLabel.Paint;
var
  Rect: TRect;
  Flags: Longint;
begin
  FillGradientRect(Canvas,GetClientRect,FFromColor, FToColor ,FColorCount,fdTB);
  with Canvas do begin
    Canvas.Font := Self.Font;
    Brush.Style := bsClear;
    Rect := ClientRect;
    Flags:=DT_SINGLELINE or DT_VCENTER;
    Rect.Left:=Rect.Left+3;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end;
end;

end.
