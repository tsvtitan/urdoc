{
  $Project$
  $Workfile$
  $Revision$
  $DateUTC$
  $Id$

  This file is part of the Indy (Internet Direct) project, and is offered
  under the dual-licensing agreement described on the Indy website.
  (http://www.indyproject.org/)

  Copyright:
   (c) 1993-2005, Chad Z. Hower and the Indy Pit Crew. All rights reserved.
}
{
  $Log$
}
{
{   Rev 1.1    2003-10-16 11:22:42  HHellstr�m
{ Fixed for dotNET
}
{
{   Rev 1.0    11/13/2002 07:53:32 AM  JPMugaas
}
unit IdHashElf;

interface

uses
  IdObjs,
  IdHash;

type
  TIdHashElf = class( TIdHash32 )
  public
    function HashValue( AStream: TIdStream ) : LongWord; override;
    procedure HashStart(var VRunningHash : LongWord); override;
    procedure HashByte(var VRunningHash : LongWord; const AByte : Byte); override;

  end;

implementation

{ TIdHashElf }

procedure TIdHashElf.HashByte(var VRunningHash: LongWord; const AByte: Byte);
var
  LTemp: LongWord;
begin
  VRunningHash := ( VRunningHash shl 4 ) + AByte;
  LTemp := VRunningHash and $F0000000;
  if LTemp <> 0 then begin
    VRunningHash := VRunningHash xor ( LTemp shr 24 ) ;
  end;
  VRunningHash := VRunningHash and not LTemp;

end;

procedure TIdHashElf.HashStart(var VRunningHash: LongWord);
begin
  VRunningHash := 0;
end;

function TIdHashElf.HashValue( AStream: TIdStream ) : LongWord;
const
  BufSize = 1024; // Keep it small for dotNET
var
  i: Integer;
  LTemp: LongWord;
  LBuffer: array[0..BufSize - 1] of Byte;
  LSize: integer;
begin
  Result := 0;
  LSize := AStream.Read( LBuffer, BufSize ) ;
  while LSize > 0 do begin
    for i := 0 to LSize - 1 do begin
      Result := ( Result shl 4 ) + LBuffer[i];
      LTemp := Result and $F0000000;
      if LTemp <> 0 then begin
        Result := Result xor ( LTemp shr 24 ) ;
      end;
      Result := Result and not LTemp;
      LSize := AStream.Read( LBuffer, BufSize ) ;
    end;
  end;
end;

end.
