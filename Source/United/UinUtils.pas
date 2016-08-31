unit UinUtils;

interface

uses Windows, Classes, Variants;

//type


function iff(Condition: Boolean; ValueTrue, ValueFalse: Variant): Variant; overload;
function iff(Condition: Boolean; ValueTrue, ValueFalse: TObject): TObject; overload;
function isValidKey(const Key: AnsiChar): Boolean;
function isValidIntegerKey(const Key: AnsiChar): Boolean;

function GetChangedText(const Text: string; SelStart, SelLength: integer; Key: char): string;

function  PosChar(const F: AnsiChar; const S: AnsiString;
          const Index: Integer = 1): Integer;

function  CopyRange(const S: AnsiString;
          const StartIndex, StopIndex: Integer): AnsiString;


function StrIPos(const SubStr, S: AnsiString): Integer;
function StrLeft(const S: AnsiString; Count: Integer): AnsiString;
function StrStripNonNumberChars(const S: AnsiString): AnsiString;
function StrDelete(const psSub, psMain: string): string;
function  StrBetweenChar(const S: AnsiString;
          const FirstDelim, SecondDelim: AnsiChar;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False): AnsiString;
          
function StrToHexStr(S:String):String;
function HexStrToStr(S:String):String;
function ChangeChar(Value: string; chOld, chNew: char): string;

function CharIsNumber(const C: AnsiChar): Boolean;
function CharIsDigit(const C: AnsiChar): Boolean;

function CreateUniqueId: String; 
function TempPath: string;
function TempFileName: string;
function GetAssociatedIcon(const Filename: string; SmallIcon: boolean): HICON;

implementation

uses SysUtils, ActiveX, ShellApi;

var
  AnsiCharTypes: array [AnsiChar] of Word;
const
  AnsiSigns          = ['-', '+'];

const
  // CharType return values
  C1_UPPER  = $0001; // Uppercase
  C1_LOWER  = $0002; // Lowercase
  C1_DIGIT  = $0004; // Decimal digits
  C1_SPACE  = $0008; // Space characters
  C1_PUNCT  = $0010; // Punctuation
  C1_CNTRL  = $0020; // Control characters
  C1_BLANK  = $0040; // Blank characters
  C1_XDIGIT = $0080; // Hexadecimal digits
  C1_ALPHA  = $0100; // Any linguistic character: alphabetic, syllabary, or ideographic

function iff(Condition: Boolean; ValueTrue, ValueFalse: Variant): Variant;
begin
  if Condition then
    Result:=ValueTrue
  else Result:=ValueFalse;
end;

function iff(Condition: Boolean; ValueTrue, ValueFalse: TObject): TObject;
begin
  if Condition then
    Result:=ValueTrue
  else Result:=ValueFalse;
end;

function isValidKey(const Key: AnsiChar): Boolean;
begin
{  Result:=(Byte(Key) in [byte('A')..byte('z')]) or
          (Byte(Key) in [byte('À')..byte('ÿ')])or
          isValidIntegerKey(Key);}
  Result:=((AnsiCharTypes[Key] and C1_ALPHA) <> 0) or
          isValidIntegerKey(Key);
end;

function isValidIntegerKey(const Key: AnsiChar): Boolean;
begin
  Result := (AnsiCharTypes[Key] and C1_DIGIT) <> 0;
end;

{function PackedNames(Source: TStringList): OleVariant;
var
  I, Idx, Count: Integer;
begin
  Result := NULL;
  Count := 0;
  for I := 0 to Source.Count - 1 do
    if Trim(Source[I])<>'' then Inc(Count);
  if Count > 0 then
  begin
    Idx := 0;
    Result := VarArrayCreate([0, Count - 1], varVariant);
    for I := 0 to Source.Count - 1 do begin
      Result[Idx] := Source[I];
      Inc(Idx);
    end;
  end;
end;

procedure UnPackNames(const Source: OleVariant; Dest: TStringList);
var
  TempStrings: TStringList;
  i: Integer;
begin
  if not VarIsNull(Source) and VarIsArray(Source) then
  begin
    TempStrings := TStringList.Create;
    try
      for i := 0 to VarArrayHighBound(Source, 1) do
      begin
        TempStrings.Add(Source[i]);
      end;
      Dest.Assign(TempStrings);
    finally
      TempStrings.Free;
    end;
  end;
end;}

function GetChangedText(const Text: string; SelStart, SelLength: integer; Key: char): string;
begin
  Result := Text;
  if SelLength > 0 then
    Delete(Result, SelStart + 1, SelLength);
  if Key <> #0 then
    Insert(Key, Result, SelStart + 1);
end;

function PosChar(const F: AnsiChar; const S: AnsiString;
    const Index: Integer): Integer;
var P    : PAnsiChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1 else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  While I <= L do
    if P^ = F then
      begin
        Result := I;
        exit;
      end else
      begin
        Inc(P);
        Inc(I);
      end;
  Result := 0;
end;

function CopyRange(const S: AnsiString; const StartIndex, StopIndex: Integer): AnsiString;
var L, I : Integer;
begin
  L := Length(S);
  if (StartIndex > StopIndex) or (StopIndex < 1) or (StartIndex > L) or (L = 0) then
    Result := '' else
    begin
      if StartIndex <= 1 then
        if StopIndex >= L then
          begin
            Result := S;
            exit;
          end else
          I := 1
      else
        I := StartIndex;
      Result := Copy(S, I, StopIndex - I + 1);
    end;
end;

function StrIPos(const SubStr, S: AnsiString): integer;
begin
  Result := Pos(AnsiUpperCase(SubStr), AnsiUpperCase(S));
end;

function StrLeft(const S: AnsiString; Count: Integer): AnsiString;
begin
  Result := Copy(S, 1, Count);
end;

function StrStripNonNumberChars(const S: AnsiString): AnsiString;
var
  I: Integer;
  C: AnsiChar;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    C := S[I];
    if CharIsNumber(C) then
      Result := Result + C;
  end;
end;

function StrRestOf(const ps: AnsiString; const n: integer): AnsiString;
begin
  Result := Copy(ps, n, (Length(ps) - n + 1));
end;

function StrDeleteChars(const ps: string; const piPos: integer; const piCount: integer): string;
begin
  Result := StrLeft(ps, piPos - 1) + StrRestOf(ps, piPos + piCount);
end;

function StrDelete(const psSub, psMain: string): string;
var
  liPos: integer;
begin
  Result := psMain;
  if psSub = '' then
    exit;

  liPos := StrIPos(psSub, psMain);

  while liPos > 0 do
    begin
      Result := StrDeleteChars(Result, liPos, Length(psSub));
      liPos := StrIPos(psSub, Result);
    end;
end;

function StrBetweenChar(const S: AnsiString;
    const FirstDelim, SecondDelim: AnsiChar;
    const FirstOptional: Boolean; const SecondOptional: Boolean): AnsiString;
var I, J: Integer;
begin
  Result := '';
  I := PosChar(FirstDelim, S);
  if (I = 0) and not FirstOptional then
    exit;
  J := PosChar(SecondDelim, S, I + 1);
  if J = 0 then
    if not SecondOptional then
      exit else
      J := Length(S) + 1;
  Result := CopyRange(S, I + 1, J - 1);
end;


function StrToHexStr(S:String):String;
var
  i: Integer;
  l: Integer;
begin
  l:=Length(S);
  Result:='';
  for i:=1 to l do
   Result:=Result+IntToHex(Word(S[i]),2);
end;

function HexStrToStr(S:String):String;
var
  l: Integer;
  APos: Integer;
  tmps: string;
begin
  l:=Length(S);
  APos:=1;
  Result:='';
  while APos<(l+1) do begin
    tmps:=Copy(S,APos,2);
    Result:=Result+Char(StrToIntDef('$'+tmps,0));
    inc(APos,2);
  end;
end;

function ChangeChar(Value: string; chOld, chNew: char): string;
var
  i: Integer;
  tmps: string;
begin
  for i:=1 to Length(Value) do begin
    if Value[i]=chOld then
     Value[i]:=chNew;
    tmps:=tmps+Value[i];
  end;
  Result:=tmps;
end;

function CharIsNumber(const C: AnsiChar): Boolean;
begin
  Result := ((AnsiCharTypes[C] and C1_DIGIT) <> 0) or
     (C in AnsiSigns) or (C = DecimalSeparator);
end;

function CharIsDigit(const C: AnsiChar): Boolean;
begin
  Result := (AnsiCharTypes[C] and C1_DIGIT) <> 0;
end;

procedure LoadCharTypes;
var
  CurrChar: AnsiChar;
  CurrType: Word;
begin
  {$IFDEF MSWINDOWS}
  for CurrChar := Low(AnsiChar) to High(AnsiChar) do
  begin
    GetStringTypeExA(LOCALE_USER_DEFAULT, CT_CTYPE1, @CurrChar, SizeOf(AnsiChar), CurrType);
    AnsiCharTypes[CurrChar] := CurrType;
  end;
  {$ENDIF}
end;


function CreateClassID: string;
var
  ClassID: TCLSID;
  P: PWideChar;
begin
  CoCreateGuid(ClassID);
  StringFromCLSID(ClassID, P);
  Result := P;
  CoTaskMemFree(P);
end;

function CreateUniqueId: String;
var
  s: string;
begin
  s:=Copy(CreateClassID, 2, 36);
  Result:=Copy(s, 25, 12)+Copy(s, 20, 4)+Copy(s, 15, 4)+Copy(s, 10, 4)+Copy(s, 1, 8);
  Result:=Copy(Result,1,32);          
end;

function TempPath: string;
var
	i: integer;
begin
  SetLength(Result, MAX_PATH);
	i := GetTempPath(Length(Result), PChar(Result));
	SetLength(Result, i);
end;

function TempFileName: string;
begin
  Result:=TempPath+CreateUniqueId+'.tmp';
end;

function GetAssociatedIcon(const Filename: string; SmallIcon: boolean): HICON;
const
  cSmall: array[boolean] of Cardinal = (SHGFI_LARGEICON, SHGFI_SMALLICON);
var pfsi: TShFileInfo; hLarge: HICON; w: word;
begin
  FillChar(pfsi, sizeof(pfsi), 0);
  ShGetFileInfo(PChar(Filename), 0, pfsi, sizeof(pfsi),
    SHGFI_ICONLOCATION or SHGFI_ATTRIBUTES or SHGFI_ICON or cSmall[SmallIcon] or SHGFI_USEFILEATTRIBUTES);
  Result := pfsi.hIcon;
  if Result = 0 then
    ExtractIconEx(pfsi.szDisplayName, pfsi.iIcon, hLarge, Result, 1);
  if not SmallIcon then
    Result := hLarge;
  if Result = 0 then
    ExtractAssociatedIcon(GetFocus, PChar(Filename), w);
end;



initialization

  LoadCharTypes;


end.
