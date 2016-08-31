unit UCheckSum;

interface

uses Classes;

function  Crc32Initialization: Pointer;

const     Crc32Init = $FFFFFFFF;
function  Crc32Next   (Crc32Current: LongWord; const Data; Count: LongWord): LongWord; register;
function  Crc32Done   (Crc32: LongWord): LongWord; register;
function  Crc32Stream (Source: TStream; Count: Longint): LongWord;
function  Crc32Pointer(P: Pointer; Count: Longint): LongWord;
function CalculateCheckSum(P: Pointer; Size: Longword): LongWord;

implementation


{
Учебник Темникова Ф.Е. "Теоретические основы информационно-измерительной техники" - М.: "Энергия", 1979.

  1. CRC32Init - инициализирует  CRC-32 значением $FFFFFFFF.
  2. Затем надо помещать порции заданной  последовательности в буфер и для каждой
     порции вызывать CRC32Next.
  3. В конце CRC32Done инвертирует все биты результата.

  CRC-32 инициализируется значением $FFFFFFFF. Потом для каждого байта
B входной последовательности CRC-32 сдвигается вправо  на 1 байт.
Если байты CRC-32 были [C1,C2,C3,C4] (C1 - старший, C4 - младший),
сдвиг дает [0,C1,C2,C3]. Младший байт C4 побитно складывается с B
по модулю 2 (C4 xor B). Новым значением CRC-32 будет его сдвинутое
значение, сложенное побитно по модулю  2 (xor) с4-байтовой величиной
из "магической" таблицы с использованием [B xor C4] в качестве индекса.

     Было:
       CRC-32 = [C1,C2,C3,C4] и получили очередной байт B.
     Стало:
       CRC-32 = [0,C1,C2,C3] xor Magic[B xor C4].
Delphi:
     CRC := (CRC shr 8) xor Magic[B xor byte(CRC and $FF)];
     (здесь CRC - longint, Magic - array[byte] of longint).

Последний этап вычисления CRC-32 - инвертировать все биты: CRC:= NOT CRC;
===
Например :                                                     
 var                                                           
  Buffer : array[1..8192] of Char;
  CRC    : Cardinal;                                           
  Count  : Cardinal;                                           
 .......
  CRC := CRC32INIT;
  repeat
   BlockRead(F, Buffer, SizeOf( Buffer ), Count);
   CRC := CalculateBufferCRC32( CRC, Buffer, Count );
  until Eof(F);
  CRC := CRC xor CRC32INIT;
 .......
===

  Generate a table for a byte-wise 32-bit CRC calculation on the polynomial:
  x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x+1.

  Polynomials over GF(2) are represented in binary, one bit per coefficient,
  with the lowest powers in the most significant bit.  Then adding polynomials
  is just exclusive-or, and multiplying a polynomial by x is a right shift by
  one.  If we call the above polynomial p, and represent a byte as the
  polynomial q, also with the lowest power in the most significant bit (so the
  byte 0xb1 is the polynomial x^7+x^3+x+1), then the CRC is (q*x^32) mod p,
  where a mod b means the remainder after dividing a by b.

  This calculation is done using the shift-register method of multiplying and
  taking the remainder.  The register is initialized to zero, and for each
  incoming bit, x^32 is added mod p to the register if the bit is a one (where
  x^32 mod p is p+x^32 = x^26+...+1), and the register is multiplied mod p by
  x (which is shifting right by one and adding x^32 mod p if the bit shifted
  out is a one).  We start with the highest power (least significant bit) of
  q and repeat for all eight bits of q.

  The table is simply the CRC of all possible eight bit values.  This is all
  the information needed to generate CRC's on data a byte at a time for all
  combinations of CRC register values and incoming bytes.

procedure make_crc_table;
var
 c    : uLong;
 n,k  : int;
 poly : uLong; // polynomial exclusive-or pattern
const
 // terms of polynomial defining this crc (except x^32):
 p: array [0..13] of Byte = (0,1,2,4,5,7,8,10,11,12,16,22,23,26);
Begin
  // make exclusive-or pattern from polynomial ($EDB88320)
  poly := 0;
  for n := 0 to (sizeof(p) div sizeof(Byte))-1 do
    poly := poly or (Long(1) shl (31 - p[n]));

  for n := 0 to 255 do begin
    c := uLong(n);
    for k := 0 to 7 do begin
      if (c and 1) <> 0 then
        c := poly xor (c shr 1)
      else
        c := (c shr 1);
    end;
    crc_table[n] := c;
  end;
  crc_table_empty := FALSE;
end;
}
{ CRC32Table: array[Byte] of Cardinal = (
 $00000000, $77073096, $EE0E612C, $990951BA, $076DC419, $706AF48F, $E963A535,
 $9E6495A3, $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988, $09B64C2B, $7EB17CBD,
 $E7B82D07, $90BF1D91, $1DB71064, $6AB020F2, $F3B97148, $84BE41DE, $1ADAD47D,
 $6DDDE4EB, $F4D4B551, $83D385C7, $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC,
 $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5, $3B6E20C8, $4C69105E, $D56041E4,
 $A2677172, $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B, $35B5A8FA, $42B2986C,
 $DBBBC9D6, $ACBCF940, $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59, $26D930AC,
 $51DE003A, $C8D75180, $BFD06116, $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
 $2802B89E, $5F058808, $C60CD9B2, $B10BE924, $2F6F7C87, $58684C11, $C1611DAB,
 $B6662D3D, $76DC4190, $01DB7106, $98D220BC, $EFD5102A, $71B18589, $06B6B51F,
 $9FBFE4A5, $E8B8D433, $7807C9A2, $0F00F934, $9609A88E, $E10E9818, $7F6A0DBB,
 $086D3D2D, $91646C97, $E6635C01, $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
 $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457, $65B0D9C6, $12B7E950, $8BBEB8EA,
 $FCB9887C, $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65, $4DB26158, $3AB551CE,
 $A3BC0074, $D4BB30E2, $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB, $4369E96A,
 $346ED9FC, $AD678846, $DA60B8D0, $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
 $5005713C, $270241AA, $BE0B1010, $C90C2086, $5768B525, $206F85B3, $B966D409,
 $CE61E49F, $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4, $59B33D17, $2EB40D81,
 $B7BD5C3B, $C0BA6CAD, $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A, $EAD54739,
 $9DD277AF, $04DB2615, $73DC1683, $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8,
 $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1, $F00F9344, $8708A3D2, $1E01F268,
 $6906C2FE, $F762575D, $806567CB, $196C3671, $6E6B06E7, $FED41B76, $89D32BE0,
 $10DA7A5A, $67DD4ACC, $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5, $D6D6A3E8,
 $A1D1937E, $38D8C2C4, $4FDFF252, $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
 $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60, $DF60EFC3, $A867DF55, $316E8EEF,
 $4669BE79, $CB61B38C, $BC66831A, $256FD2A0, $5268E236, $CC0C7795, $BB0B4703,
 $220216B9, $5505262F, $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04, $C2D7FFA7,
 $B5D0CF31, $2CD99E8B, $5BDEAE1D, $9B64C2B0, $EC63F226, $756AA39C, $026D930A,
 $9C0906A9, $EB0E363F, $72076785, $05005713, $95BF4A82, $E2B87A14, $7BB12BAE,
 $0CB61B38, $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21, $86D3D2D4, $F1D4E242,
 $68DDB3F8, $1FDA836E, $81BE16CD, $F6B9265B, $6FB077E1, $18B74777, $88085AE6,
 $FF0F6A70, $66063BCA, $11010B5C, $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
 $A00AE278, $D70DD2EE, $4E048354, $3903B3C2, $A7672661, $D06016F7, $4969474D,
 $3E6E77DB, $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0, $A9BCAE53, $DEBB9EC5,
 $47B2CF7F, $30B5FFE9, $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6, $BAD03605,
 $CDD70693, $54DE5729, $23D967BF, $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
 $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D ); }

const
  Crc32Polynomial = $EDB88320;
var
  CRC32Table: array [Byte] of Cardinal;

const
  IcsPlusIoPageSize = 8192*2;
  IcsPlusLineEnd: String = #10;
  IcsPlusLineEndLength: LongInt = 1;

function  Crc32Next (CRC32Current: LongWord; const Data; Count: LongWord): LongWord;
Asm //EAX - CRC32Current; EDX - Data; ECX - Count
  test  ecx, ecx
  jz    @@EXIT
  PUSH  ESI
  MOV   ESI, EDX  //Data
@@Loop:
    MOV EDX, EAX                       // copy CRC into EDX
    LODSB                              // load next byte into AL
    XOR EDX, EAX                       // put array index into DL
    SHR EAX, 8                         // shift CRC one byte right
    SHL EDX, 2                         // correct EDX (*4 - index in array)
    XOR EAX, DWORD PTR CRC32Table[EDX] // calculate next CRC value
  dec   ECX
  JNZ   @@Loop                         // LOOP @@Loop
  POP   ESI
@@EXIT:
End;//Crc32Next

//Result:=NOT Crc32;
function  Crc32Done (Crc32: LongWord): LongWord;
Asm
  NOT   EAX
End;//Crc32Done

function  Crc32Initialization: Pointer;
Asm
  push    EDI
  STD
  mov     edi, OFFSET CRC32Table+ ($400-4)  // Last DWORD of the array
  mov     edx, $FF  // array size

@im0:
  mov     eax, edx  // array index
  mov     ecx, 8
@im1:
  shr     eax, 1
  jnc     @Bit0
  xor     eax, Crc32Polynomial
@Bit0:
  dec     ECX
  jnz     @im1

  stosd
  dec     edx
  jns     @im0

  CLD
  pop     EDI
  mov     eax, OFFSET CRC32Table
End;//Crc32Initialization

function  Crc32Stream (Source: TStream; Count: Longint): LongWord;
var
  BufSize, N: Integer;
  Buffer: PChar;
Begin
  Result:=Crc32Init;
  if Count = 0 then begin
    Source.Position:= 0;
    Count:= Source.Size;
  end;
  if Count > IcsPlusIoPageSize then BufSize:= IcsPlusIoPageSize else BufSize:= Count;
  GetMem(Buffer, BufSize);
  try
    while Count <> 0 do begin
      if Count > BufSize then N := BufSize else N := Count;
      Source.ReadBuffer(Buffer^, N);
      Result:=Crc32Next(Result,Buffer^,N);
      Dec(Count, N);
    end;
  finally
    Result:=Crc32Done(Result);
    FreeMem(Buffer);
  end;
End;//Crc32Stream

function  Crc32Pointer(P: Pointer; Count: Longint): LongWord;
var
  BufSize, N: Integer;
Begin
  Result:=Crc32Init;
  if Count > IcsPlusIoPageSize then BufSize:= IcsPlusIoPageSize else BufSize:= Count;
  while Count <> 0 do begin
    if Count > BufSize then N := BufSize else N := Count;
    Result:=Crc32Next(Result,P^,N);
    Dec(Count, N);
  end;
  Result:=Crc32Done(Result);
End;//Crc32Stream

function CalculateCheckSum(P: Pointer; Size: Longword): LongWord;
begin
  Crc32Initialization;
  Result:=Crc32Pointer(P,Size);
end;

end.

