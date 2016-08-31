{$A+,B-,C+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y-,Z1}
{$D+}   { Make it D+ for debug information }
{modified 1998 june 17}
(************************************************************************
 * Compress.PAS V3.52a    -- Dual 16/32 bit version                     *
 *                                                                      *
 * Legal stuff:                                                         *
 *   Copyright (c) 1995-97, South Pacific Information Services Ltd      *
 *                                                                      *
 * This source code is provided for your inspection and adaptation.     *
 * While you are free to on-sell applications which make use            *
 * of the source or components based on it, you may NOT:                *
 * a) Use this source to make general data compression components       *
 *    (DCUs, DLLs, OBJs etc) for resale to other developers             *
 * b) On-sell this source code as part of any product                   *
 *                                                                      *
 * If you do not accept these restrictions, please contact              *
 * South Pacific Information Services Ltd for a full and immediate      *
 * refund.                                                              *
 *                                                                      *
 * Other than that -- have fun!                                         *
 ************************************************************************)
(*
   Oct 15 V3.52a -- Patch to GetAllFilesInDir
   Oct 15 V3.52 released
    -- accepts filepath/S in GetMatchingFiles/GetAllFilesInDir to recurse Subdirectories too
    -- handles FILE_ATTRIBUTE_NORMAL (NT) in GetAllFilesInDir
    -- makes ELZHBadDecodeTable and EUnableToCompress public

   July 12 v3.5 released
*)

 { Disable any of the defines below to make a somewhat smaller component (see Help)
   -- at the cost of losing the particular feature noted.
   Note that the LZH compression routines are twice as large as the expansion ones...
 }
{$DEFINE LZH1_EXPAND}   { support expansion of colzh compressed files }
{$DEFINE LZH1_COMPRESS} { support compression of files with colzh }


{$DEFINE LZH5_EXPAND}   { support expansion of colzh5 compressed files (better than LZH) }
{$DEFINE LZH5_COMPRESS} { support compression of files with colzh5 }

 { These RLE routines are very small -- hardly worth the effort of disabling... }
{$DEFINE RLE_EXPAND}   { support expansion of RLE compressed files }
{$DEFINE RLE_COMPRESS} { support compression of files with RLE }

{19990623 Correct Bug: In Method Compess inserted check of input size<=hdr+128, because
fail while size<130 }
unit Mcompres;

interface

{$IFDEF WIN32} { our benchmarks indicate little or NO gain from using ASM in D2.0 }
 {$DEFINE PASCALINSERT}
 {$DEFINE PASCALLINK}  {case in point: link got a fraction SLOWER when we hand-coded in ASM }
 {$DEFINE PASCALUPDATE}
 {$DEFINE PASCALDECODECHAR}
{$ENDIF}

uses
  SysUtils, Wintypes, WinProcs, Classes,graphics,Dialogs, Variants;

type
  ELZHBadDecodeTable = Class(Exception); { public V3.51 }
  EUnableToCompress = Class(Exception);  { public V3.51 }

  EInsufficientDiskSpace = Class(Exception);
  EUnrecognizedCompressionMethod = Class(Exception);
  EInvalidHeaderArchiveType = Class(Exception);
  EInvalidHeader = Class(Exception);
  EBadChecksum = Class(Exception);
  EInvalidKey = Class(Exception);

  TCompressArchiveType = (caSingle, caMulti);
  TCompressionMethod = ( coNone, coRLE, coLZH, coCustom, coLZH5 );
  TCProcessMode = ( cmCompress, cmExpand, cmDelete ); { for ProcessStreams/OnCheckFile }

{$IFDEF WIN32}
{$ALIGN OFF   to ensure storage compatibility with the 16-bit version }
{$ENDIF}
  TCompressHeader =
      Record
        ComId: array[0..4] of char; { Always SPIS + chr(26) }
        ComMethodId: array[0..2] of char; { RLE, LZH, LH5 etc. }
        Fullsize: Longint;    { uncompressed size, in bytes, excluding header }
        ArchiveType: TCompressArchiveType; { caSingle, caMulti }
        Checksum: Longint;    { CRC or checksum -- not used in multi-file archive }
        Locked: Longint;      { >0 means file was saved with a key V2.5 }
      end;

  TCompressedFileHeader =
      Record
        FileNameLength: Smallint;
        Datetime: Longint;
        Attributes: Smallint;
        Fullsize: Longint;
        CompressedSize: Longint;
        CompressedMode: TCompressionMethod;
        Checksum: Longint;   { CRC or checksum }
        Locked: Longint;     { 1 means file was Locked by TCompress 3.0 or earlier,
                               2 means file was encrypted by TCompress 3.5 or later }
      end;
{$IFDEF WIN32}
{$ALIGN ON}
{$ENDIF}
  TCompressedFileInfo = Class(TObject){ for a compressed file directory listing }
  public
        Datetime: Longint;
        Attributes: Smallint;
        Fullsize: Longint;
        CompressedSize: Longint;
        CompressedMode: TCompressionMethod;
        Checksum: Longint;
        Position: Longint; { offset of start of HEADER in the file }
        Locked: Boolean;   { was file saved with a key? }
  end;
  TFilenameCheckEvent = procedure (var filepath: String;
                                    mode: TCProcessMode) of Object;
  TCompressEvent = procedure(dest,source: Tstream;
                    var CompressID : string; var Outputsize: Longint;
                                          var checksum: Longint) of Object;
  TExpandEvent = procedure(dest,source: Tstream; Sourcesize, Destsize: longint;
                           CompressID: string; var checksum: Longint) of Object;
  TRecognizeEvent = procedure(CompressID: string;
                                 var recognized: Boolean) of Object;

  TShowProgressEvent = procedure(var PercentageDone: Longint) of Object;

  TMCompress = class(TComponent)
  private
     FRegName: String;
     FRegNumber: Longint;
     FCompressedToPercentage: Integer;
     FCompressionTime: Longint;
     FOnCompress: TCompressEvent;
     FOnExpand: TExpandEvent;
     FOnRecognize: TRecognizeEvent;
     FOnCheckFile: TFilenameCheckEvent;
     FOnShowProgress: TShowProgressEvent;

     FTargetPath: string;
     FMakeDirectories: Boolean;
     FKeyNum: Longint;
     FExceptionOnFileError: Boolean;
     FCheckSpaceBeforeExpand: Boolean; { V3.05 }

     FMustCompressByAtLeast: Longint; { V3.5 }

     function ProcessString(const str: string; compressionMethod: TCompressionMethod;
                             mode: TCProcessMode): string; { V3.5 }
     function CheckDiskSpace(filename: String): longint; { class member, V3.05 }
     procedure SetTargetPath(const path:string);
     function GetCompressedPercentage: Integer;
     function ProcessStreams(outstream, instream: TStream; Sourcesize, destSize: longint;
                             CompressionMethod: TCompressionMethod;var checksum: longint;
                             mode: TCProcessMode; Encrypted: Boolean): longint; { encrypted V3.5 }
  protected
     procedure AppendFilesExcept(const destfile,fromfile: String; notfiles: TStringlist);
     procedure SetHeader(var hdr: TCompressHeader; cID: string;
                           aType: TCompressArchiveType; size: Longint);
     function GetFileHeader(Stream: TStream;var Fhdr: TCompressedFileHeader; var Filename: String): Boolean;
     procedure PutFileHeader(Stream: TStream;var Fhdr: TCompressedFileHeader; const Filename: String);
     procedure CheckHeader(compressedFile: TStream;var hdr: TCompressHeader; var CID: string); { 3.0 }

  public
     function CompressString(const unCompressedString: string; compressionMethod: TCompressionMethod): string;
     function ExpandString(const CompressedString: string): string;

     function DoCompress(compressedStream, uncompressedStream: Tstream;
        compressionMethod: TCompressionMethod; var CompressID : string;
                                             var checksum: Longint): Longint;
     procedure DoExpand(expandedStream, unexpandedStream: Tstream;
                       compressedsize, fullsize, checksum: Longint;
                    compressionMethod: TCompressionMethod; const CompressID: string;
                              FLocked: Longint); { FLocked now Longint V3.5 }
     function Recognize(const cID: String) : TCompressionMethod;
     procedure Compress(compressedStream, uncompressedStream: Tstream;
                                          compressionMethod: TCompressionMethod);
     procedure Expand(expandedStream,unexpandedStream: Tstream);

     procedure CompressStreamToArchiveStream(compressedStream,uncompressedStream: TStream; { V3.0 }
          const Filename: string; FHdr: TCompressedFileHeader; var cID: string;
          CompressionMode: TCompressionMethod);

     procedure CompressStreamToArchive(arcFile: String; uncompressedStream: TStream;
              const fileName: string; CompressionMode: TCompressionMethod); { V3.0 }

     procedure ExpandStreamFromArchive(arcFile: String; uncompressedStream: TStream; fileName: string); { V3.0 }

     function CompressFilesToStream(dest: TStream; var whichfiles: TStringList;
                                  CompressionMode: TCompressionMethod): Longint;
     procedure CompressFiles(const arcFile: String; whichfiles: TStringList;
                                           CompressionMode: TCompressionMethod);
     procedure CompressFile(const arcfile:String; var fromFile: String; CompressionMode: TCompressionMethod);
     procedure DeleteFiles(const arcFile: String; whichfiles: TStringList);
     procedure ExpandFile(var toFile:String;const arcfile: String);
     procedure ExpandFiles(const arcfile:String;whichfiles: TStringList);
     procedure ExpandFilesFromStream(compressedstream:TStream;whichfiles: TStringList);
     procedure ScanCompressedStream(compressedstream: TStream; var Finfo: TStringList);
     procedure ScanCompressedFile(const arcfile: String; var Finfo: TStringList);
     property CompressedPercentage: Integer read GetCompressedPercentage;
     property CompressionTime: Longint read FCompressionTime;
     function LoadCompressedResource(ResourceName, DLLName: string): TStream;
     function LoadExpandedResource(ResourceName, DLLName: string): TStream;
     procedure FreeFileList(Finfo: TStringList);
     procedure GetAllFilesInDir(list: TStringList; dirname: string; const match: string; Anything: Boolean); { new in V3.0 }
     procedure GetMatchingFiles(list: TStringList; const matchname: string); { V3.0 }
     function ExpandBitmap(bm: TBitmap;FileName: string):longint; {0:no error; 1:error}
     function PackedStreamToBitmap(Stream:TStream;bm:TBitmap):longint;{0:no error; 1:error}
  published
     property RegName : string read FRegName write FRegName;
     property RegNumber : Longint read FRegNumber write FRegNumber;
     property OnCompress : TCompressEvent read FOnCompress write FOnCompress;
     property OnExpand : TExpandEvent read FOnExpand write FOnExpand;
     property OnCheckFile : TFilenameCheckEvent read FOnCheckFile write FOnCheckFile;
     property OnRecognize : TRecognizeEvent read FOnRecognize write FOnRecognize;
     property OnShowProgress : TShowProgressEvent read FOnShowProgress write FOnShowProgress;

     property TargetPath : String read FTargetPath write SetTargetPath;
     property MakeDirectories : Boolean read FMakeDirectories write FMakeDirectories;
     property ExceptionOnFileError: Boolean read FExceptionOnFileError write FExceptionOnFileError;
     property Key: Longint read FKeyNum write FKeyNum;
     property CheckSpaceBeforeExpand: Boolean read FCheckSpaceBeforeExpand
                             write FCheckSpaceBeforeExpand; { V3.05 }
  end;

procedure ForceDirectories(Dir: string);  
function PackFile(FileIn,FileOut:string;AKey:integer):integer;
function PackStreamToFile(SIn:TStream;Akey:integer;FileOut:string):integer;
function UnPackFile(FileIn,FileOut:string;AKey:integer):integer;
function UnPackFileToStream(FileIn:string;AKey:integer;SOut:TStream):integer;
function UnPackBitmap(FileName: string;const Key:longint;bm: TBitmap):integer;
function PackedStreamToBitmap(Stream:TStream;const Key:longint;bm: TBitmap):integer;
function CompressDir(const Dir,DestFile:String):string;
function ArchiveToDir(const Dir,ArcFile:String):string;
function PackStringsToFile(ss:TStrings;f:TFileName;Akey:integer):integer;


(*procedure Register;*)


implementation

var  GlobalOnShowProgress: TShowProgressEvent; { see GetChar and ProcessStreams }

const CompressNoMoreFlag='*';
      CompressSkipFlag='';

 const ChunkSize = 8192; { copy 8K chunks }
      CompressedFileHeaderID = 'FORM'+chr(26);
      CustomCompressionID='CUS';
      NoCompressionID='NON';
      RLECompressionID='RLE';
      LZHCompressionID='$8^';
      LZH5CompressionID = 'IDD';
      TempExtension='.$$$';
      LockedFlag = 1;  { V3.0 or earlier }
      EncryptFlag = 2; { V3.5 or later }

     CompressionCodes: array[TCompressionMethod] of string = (
           NoCompressionID,     { coNone }
           RLECompressionID,    { coRLE }
           LZHCompressionID,    { coLZH }
          CustomCompressionID, { coCustom }
          LZH5CompressionID);  { coLZH5 }

     RLEescapechar:char=#148; { thus 65 148 37 is 37 A's, and 148 00 is ONE 148 }

     TCOMPRESS_RESOURCE_TYPE = 'KRVC1';

{$IFDEF WINDOWS}  { V2.5 needed for D1 }
     FILE_ATTRIBUTE_NORMAL               = $00000080;
{$ENDIF}


function PackFile(FileIn,FileOut:string;AKey:integer):integer;
var
 sin,sout:TFileStream;
 Compressor:TmCompress;
begin
 Compressor:=TMCompress.Create(nil);
 Compressor.Key:=AKey;
 sin := TFileStream.create(FileIn,fmShareDenyNone);
 sout := TFileStream.create(FileOut,fmCreate);
 try
  Compressor.Compress(sout,sin, coLZH5);
  Result:=0;
 except
  Result:=1;
 end;
 sin.free;
 sout.free;
 Compressor.Free;
end;

function PackStreamToFile(SIn:TStream;Akey:integer;FileOut:string):integer;
var
 sout:TFileStream;
 Compressor:TmCompress;
begin
 Compressor:=TMCompress.Create(nil);
 Compressor.Key:=AKey;
 SIn.Position:=0;
 sout := TFileStream.create(FileOut,fmCreate);
 try
  Compressor.Compress(sout,SIn, coLZH5);
  Result:=0;
 except
  Result:=1;
 end;
 sout.free;
 Compressor.Free;
end;

function PackStringsToFile(ss:TStrings;f:TFileName;Akey:integer):integer;
var
 sin,sout:TStream;
 Compressor:TmCompress;
begin
 Compressor:=TMCompress.Create(nil);
 Compressor.Key:=AKey;
 sin := TMemoryStream.create;
 sout := TFileStream.create(F,fmCreate);
 ss.SaveToStream(sin);
 sin.Position:=0;
 try
  Compressor.Compress(sout,sin, coLZH5);
  Result:=0;
 except
  Result:=1;
 end;
 sin.free;
 sout.free;
 Compressor.Free;
end;

function UnpackFile(FileIn,FileOut:string;AKey:integer):integer;
var
 sin,sout:TFileStream;
 Compressor:TmCompress;
begin
 Compressor:=TMCompress.Create(nil);
 Compressor.Key:=AKey;
 sin := TFileStream.create(FileIn,fmShareDenyNone);
 sout := TFileStream.create(FileOut,fmCreate);
 try
  Compressor.Expand(sout,sin);
  Result:=0;
 except
  Result:=1;
 end;
 sin.free;
 sout.free;
 Compressor.Free;
end;

function UnPackFileToStream(FileIn:string;AKey:integer;SOut:TStream):integer;
var
 sin:TFileStream;
 Compressor:TmCompress;
begin
 Compressor:=TMCompress.Create(nil);
 Compressor.Key:=AKey;
 sin := TFileStream.create(FileIn,fmShareDenyNone+fmOpenRead);
 try
  Compressor.Expand(sout,sin);
  Result:=0;
 except
  Result:=1;
 end;
 sin.free;
 Compressor.Free;
 SOut.Position:=0;
end;

function UnPackBitmap(FileName: string;const Key:longint;bm: TBitmap):integer;
var
 Compressor:TMCompress;
begin
 Compressor:=TMCompress.Create(nil);
 Compressor.Key:=Key;
 Result:=Compressor.ExpandBitmap(bm,FileName);
 Compressor.Free;
end;

function PackedStreamToBitmap(Stream:TStream;const Key:longint;bm: TBitmap):integer;
var
 Compressor:TMCompress;
begin
 Compressor:=TMCompress.Create(nil);
 Compressor.Key:=Key;
 Result:=Compressor.PackedStreamToBitmap(Stream,bm);
 Compressor.Free;
end;

function CompressDir(const Dir,DestFile:String):string;
var
 Compressor:TMCompress;
 filesList:TStringList;
label l_end;
begin
 Result:='Ошибка записи';
 Compressor:=TMCompress.Create(nil);
 filesList:=TStringList.Create;
 SetCurrentDir(Dir);
 if UpperCase(Dir)<>UpperCase(GetCurrentDir) then goto l_end;
 if fileexists(DestFile)=true then deletefile(pchar(DestFile));
 if fileexists(destFile) then goto l_end;
 Compressor.GetAllFilesInDir(fileslist,'','*.*',true);
 Compressor.CompressFiles(DestFile,filesList,coLZH5);
 if fileexists(DestFile)=false then goto l_end;
 Result:='';
l_end:;
 filesList.Free;
 Compressor.Free;
end;

function ArchiveToDir(const Dir,ArcFile:String):string;
var
 Compressor:TMCompress;
label l_end;
begin
 Result:='Ошибка записи';
 Compressor:=TMCompress.Create(nil);
 forcedirectories(Dir);
 SetCurrentDir(Dir);
 if UpperCase(Dir)<>UpperCase(GetCurrentDir) then goto l_end;
 Compressor.ExpandFiles(arcFile,nil);
 Result:='';
l_end: 
 Compressor.Free;
end;

{TMCompress}

{$IFDEF WINDOWS}
procedure SetLength(var s: string; len: integer);
begin
     s[0] := Char(len);
end;
{$ENDIF}

function GetCryptValue(Key:longint):longint;{inserted by IVP }
{для измениния алгоритма шифровки}
var
 key1,key2,key3,key4:longint;
 keyLeft,KeyRight:longint;
begin
 key1:=Key shr 7;
 key2:=Key shl 7;
 key3:=Key shr 16;
 key4:=Key shl 1;
 KeyLeft:=(key3 shr 2) or (key4 shr 3);
 KeyRight:=(key1 shl 2) or (key2 shl 3);
 KeyLeft:=KeyLeft xor (key1 shl 3);
 KeyRight:=KeyLeft xor (KeyRight shr 1);
 Result:=(Key xor KeyLeft) xor KeyRight;
end;

function CalcPercentage(numerator, denominator: Longint): Integer; { new 3.01 to avoid o'flo probs }
begin
  if denominator > 100000 then { we can stand dividing it some! }
    result := Integer(numerator div (denominator div 100))
  else
    result := Integer(100*numerator div denominator); { conservative, but overflows if numerator > 20MB }
end;


{ Below are three new routines (two public) introduced in V3.5 }
function TMCompress.ProcessString(const str: string; compressionMethod: TCompressionMethod;
          mode: TCProcessMode): string;
var outMS, inMS: TMemoryStream;
begin
   outMS := TMemoryStream.create;
   inMS := TMemoryStream.create;
   try
     inMS.write(str[1],Length(str));
     inMS.seek(0,soFromBeginning);
     if mode = cmCompress then
       Compress(outMS,inMS,compressionMethod)
     else
       Expand(outMS,inMS);

     with outMS do
     begin
       setLength(result,outMS.size);
       seek(0,soFromBeginning);
       read(result[1],outMS.size);
     end;
   finally
     outMS.free;
     inMS.free;
   end;
end;

function TMCompress.CompressString(const unCompressedString: string;
             compressionMethod: TCompressionMethod): string;
begin
   result := ProcessString(unCompressedString,compressionMethod,cmCompress);
end;

function TMCompress.ExpandString(const CompressedString: string): string;
begin
   result := ProcessString(CompressedString,coNone,cmExpand);
end;

function TMCompress.ExpandBitmap(bm: TBitmap;FileName: string):longint;
var
 ResourceStream: TStream;
 FStream:TFileStream;
begin
 Result:=1;
 FStream:=TFileStream.Create(FileName, fmShareDenyNone);
 ResourceStream:=TMemoryStream.Create;
 Expand(ResourceStream,FStream);
 ResourceStream.Position:=0;
 FStream.Free;
 try
  bm.LoadFromStream(ResourceStream);
  Result:=0;
 except
 end;
 ResourceStream.free;  { MUST make sure it gets freed }
end;

function TMCompress.PackedStreamToBitmap(Stream:TStream;bm:TBitmap):longint;
var
 ResourceStream: TStream;
begin
 Result:=1;
 Stream.Position:=0;
 ResourceStream:=TMemoryStream.Create;
 Expand(ResourceStream,Stream);
 ResourceStream.Position:=0;
 try
  bm.LoadFromStream(ResourceStream);
  Result:=0;
 except
 end;
 ResourceStream.free;  { MUST make sure it gets freed }
end;

{ These two functions added v3.52 to support /S processing }

{ NB: WildMatch is based on the "MatchString" routine from Michael
  Ax's TPack component set. Adapted with kind permission: ax@href.com }
function WildMatch(Const Source, Match: string): Boolean;
{matches 'Hellothere' to 'He???th*' -- Matches even if Source longer than match!}
var
  i,n:integer;
  hasStar: Boolean;
begin
  Result:= (Match='*') or ((Match='') and (Source=''));
  n:=length(Match);          {min match length}
  i:=pred(pos('*',Match));   {use '*' as cutoff}
  hasStar := i > 0;

  if hasStar and (i<n) then      {did we get one}
    n:=i;                      {assign the earlier}
  if length(source)<n then     {is the input long enough}
    exit;                      {nope. exit with result set}
  for i:= 1 to n do            {loop through match-string}
    if Result then
      exit
    else
      if (Match[i]<>'?') and (Match[i]<>Source[i]) then
        break
      else
        Result:= (i=n) and
         (hasStar or (i=Length(Source))); { NO implicit * at end of match this way... }
{        Result:=i=n; {done?}
  {returns true if the source matches the pattern. trailing '*' implied in pattern!!}
end;

function MatchFileName(const Filename, FilenameMask: string): Boolean;
var ppos: Integer;
    lpf,rpf,lpm,rpm: string;
begin
  ppos := pos('.',FilenameMask);
  if ppos >0 then
  begin
    lpm := AnsiLowerCase(copy(FileNameMask,1, pred(ppos))); { left of . }
    rpm := AnsiLowerCase(copy(FileNameMask,ppos+1, 999)); { right of . }
  end else
  begin
    lpm := AnsiLowerCase(FileNameMask); { left of... }
    rpm :='*'; { if they have no '.', we'll accept ANY extension }
  end;

  ppos := pos('.',Filename);
  if ppos >0 then
  begin
    lpf := AnsiLowerCase(copy(FileName,1, pred(ppos))); { left of . }
    rpf := AnsiLowerCase(copy(FileName,ppos+1, 999)); { right of . }
  end else
  begin
    lpf := AnsiLowerCase(FileName); { left of... }
    rpf :=''; { no extension }
  end;
  result := WildMatch(lpf,lpm) and WildMatch(rpf,rpm);
end;


{ Below are two new routines introduced in V3.0 (/S supported added V3.52) }

procedure TMCompress.GetAllFilesInDir(list: TStringList; dirname: string; const match: string; Anything: Boolean);
var Searchrec: TSearchRec; { used for FindFirst/FindNext }
    FoundOne : Integer;
    Searchfor: string;
    recurselist: TStringlist;
    recurse: Boolean;
begin
     if list=nil then exit;
     list.clear;
     if Length(dirname) > 0 then { not "current" }
        if dirname[Length(dirname)]<>'\' then
            dirname:=dirname+'\';  { need \ for legal paths }

     if (Length(Match) > 2) and (CompareText(copy(Match,Length(Match)-1,2),'/S')=0) then
     begin { V3.52 }
        SearchFor :=copy(Match,1,Length(Match)-2); { back to normal case }
        recurse := True;            { but...}
     end else
     begin
        recurse := False;
        SearchFor := match; { v2.5a -- was dirname+match }
     end;
{$R-} { RangeChecks off, in case on at this point...}
     FoundOne := FindFirst(dirname+'*.*',faAnyFile,SearchRec);
     while FoundOne=0 do
     begin
       with SearchRec do
       if (Copy(Name,1,1)<>'.') then { not a . or .. reference }
       begin
        if recurse and ((Attr and faDirectory)<>0) then { recursing? v3.52 }
        begin { get all files from lower level(s) }
           recurseList := TStringList.create;
           try
              GetAllFilesInDir(recurselist,dirname+name,match,anything);
              list.addstrings(recurseList);
           finally
             recurseList.free;
           end;
        end;

        if (anything or (Attr=FILE_ATTRIBUTE_NORMAL) or { test added V3.52 }
           (not ((Attr > 0) and (Attr<> faArchive)))) and
   {        ((Attr and faDirectory)<>faDirectory) and}{ skip Dir, Hidden, Volume, Read-only or System }
           MatchFileName(Name,SearchFor) then
         list.add(dirname+Name);
       end; { with }
       FoundOne := FindNext(SearchRec); { awkward, but that's how First/Next work... }
     end;
     SysUtils.FindClose(SearchRec);
end;

{ Gets a list of all regular files (excludes System, Hidden, Directory AND ReadOnly)
  which MATCH the name specified (can be wild, can't be just a dirname)
  -- returns in LOWER case, full path as per matchname passed in
}
procedure TMCompress.GetMatchingFiles(list: TStringList; const matchname: string);
var dirpath: string;
begin
     if Length(matchname)=0 then exit;
     dirPath := ExtractFilePath(matchname);
     GetAllFilesInDir(list,dirPath,ExtractFileName(matchname),False); { regular files only }
end;


procedure TMCompress.SetTargetPath(const path:string);
begin
  FTargetpath := path;
  if path<>'' then
     if Copy(path,Length(path),1)<>'\' then
        FTargetpath := path+'\';
end;

{ Call this function to empty the list populated by a
  call to ScanCompressedFile or ScanCompressedStream
  Clears the stringlist as well as the freeing the objects in it.
}
procedure TMCompress.FreeFileList(Finfo: TStringList);
var count: Integer;
begin
  if Finfo<> nil then
  begin
    for count:= 0 to pred(Finfo.count) do
     Finfo.objects[count].free; { get rid of these (if any)... }
    Finfo.clear; { changed in V3.0 -- in v2.5 this was a FREE! }
  end; { begin/end added v3.05 }
end;

{ This function can be called to load a resource from either the current EXE or,
  if DLLName is not empty, from a named DLL. Returns a pointer to either a
  TMemoryStream (Delphi 1) or a TResourceStream (Delphi 2) containing the
  resource required.  Resources are assumed to be of the type 'TCOMPRESS'.
}
{$IFDEF WIN32}
function TMCompress.LoadCompressedResource(ResourceName, DLLName: string): TStream;
var  hFileInstance :  THandle;
begin
  if DLLName<>'' then
  begin
    hFileInstance := LoadLibrary(PChar(DLLName));   { Load DLL }
    if hFileInstance=NULL then { oops }
       raise(Exception.create('Could not load '+DLLName+' DLL'));
  end else
    hFileInstance := HInstance; { the handle to the current EXE }
  try
    result := TResourceStream.Create(hFileInstance,ResourceName,PChar(TCOMPRESS_RESOURCE_TYPE));
  finally
    if DLLName<>'' then { must free Library }
       FreeLibrary(hFileInstance );     { Always Unload DLL }
  end;
end;
{$ENDIF}

{$IFDEF WINDOWS}
function TMCompress.LoadCompressedResource(ResourceName, DLLName: string): TStream;
var  hFileInstance :  THandle;
    ResHandle, MemHandle: THandle;
    ResourceBuffer: Pointer;
    TypeBuff, Namebuff: Array[0..255] of char;
begin
  result := nil;

  if DLLName<>'' then
  begin
    DLLName := DLLName+#0;
    hFileInstance := LoadLibrary(@DLLName[1] );   { Load DLL }
    if hFileInstance=0 then { oops }
       raise(Exception.create('Could not load '+DLLName+' DLL'));
  end else
    hFileInstance := HInstance; { the handle to the current EXE }

  try
    MemHandle := 0;
    ResourceName := ResourceName+#0;
    ResHandle := FindResource(HFileInstance,@ResourceName[1],
                               strPCopy(TypeBuff,TCOMPRESS_RESOURCE_TYPE));
    try
      if ResHandle > 0 then
         MemHandle := LoadResource(hFileInstance,ResHandle);
      if (ResHandle=0) or (MemHandle = 0) then
        raise(EResNotFound.Create('Could not find '+ResourceName+' resource!'));

      ResourceBuffer := LockResource(MemHandle);
      result := TMemoryStream.Create;
      result.Write(ResourceBuffer^,SizeofResource(hFileInstance, ResHandle));
      result.seek(0,soFromBeginning);
    finally
      UnLockResource(MemHandle);
      FreeResource(ResHandle);
    end;
  finally
    if DLLName<>'' then { must free Library }
       FreeLibrary(hFileInstance );     { Always Unload DLL }
  end;
end;
{$ENDIF}

{ Tries to load AND expand compressed resource of the given name from the given DLL/EXE
 (or the current app if DLLName is blank). Raises exception if not found. }
function TMCompress.LoadExpandedResource(ResourceName, DLLName: string): TStream;
var CompressedStream: TStream;
begin
     result := TMemoryStream.Create;
     CompressedStream :=LoadCompressedResource(ResourceName,DLLName);
     try
        if (CompressedStream=nil) or (CompressedStream.size=0) then
           raise(EResNotFound.Create('Could not load resource: '+ResourceName));
        Expand(result,CompressedStream); { got it }
        result.seek(0,soFromBeginning); { rewind! }
     finally
       CompressedStream.free;
     end;
end;

{ New in V2.5 -- ex FileCtrl, so as to avoid needing to Use it...  }
{$IFDEF WIN32}
function DirectoryExists(const Name: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;
{$ENDIF}

{$IFDEF WINDOWS}
function DirectoryExists(Name: string): Boolean;
var
  SR: TSearchRec;
begin
  if Name[Length(Name)] = '\' then Dec(Name[0]);
  if (Length(Name) = 2) and (Name[2] = ':') then
    Name := Name + '\*.*';
  Result := FindFirst(Name, faDirectory, SR) = 0;
  Result := Result and (SR.Attr and faDirectory <> 0);
end;
{$ENDIF}

procedure ForceDirectories(Dir: string);
begin
  if Dir='' then exit;  { note: this test not in VCL code }
  if Dir[Length(Dir)] = '\' then
    SetLength(Dir, Length(Dir)-1);
  if (Length(Dir) < 3) or DirectoryExists(Dir) then Exit;
  ForceDirectories(ExtractFilePath(Dir));
  MkDir(Dir);
end;

{ Below is original V2.0 routines (with some 2.5 amendments flagged }
procedure TMCompress.CompressFile(const arcFile:String; var fromFile: String;
              CompressionMode: TCompressionMethod);
var s: TStringlist;
begin
  s:=TstringList.create;
  try
     s.add(fromfile);
     CompressFiles(arcFile,s,compressionMode);
     if s.count > 0 then
       fromfile:=s[0] { in case it changed }
     else
       fromFile :='';
  finally
     s.free;
  end;
end;

procedure TMCompress.ExpandFile(var toFile: String;const arcfile: String);
var s: TStringlist;
begin
  s:=TstringList.create;
  try
     s.add(tofile);
     ExpandFiles(arcfile,s);
     if s.count > 0 then
       tofile:=s[0] { in case it changed }
     else
       toFile :='';
  finally
     s.free;
  end;
end;

function TMCompress.DoCompress(compressedStream, uncompressedStream: Tstream;
        compressionMethod: TCompressionMethod; var CompressID : string;
                                             var checksum: Longint): Longint;
begin
  FCompressionTime := GetTickCount;
  checksum := 0; { for coNone, possibly coCustom }
  Result := 0; { Will only be in catastrophic failures? }
  case compressionMethod of
     coNone: Result := compressedStream.CopyFrom(uncompressedStream,
                                                  uncompressedStream.size);
     coLZH, coLZH5, coRLE:
        begin
           result := ProcessStreams(compressedStream,uncompressedStream,
                uncompressedStream.size,0,compressionMethod,checksum,cmCompress, False);
        end;
     coCustom: if assigned(FOnCompress) then FOnCompress(compressedStream,
                          unCompressedStream, CompressID ,Result, checksum);
  end;
  Checksum := CheckSum+Key;  { Add key in V2.5 }
  FCompressionTime:=LongInt(GetTickCount) - FCompressionTime;
end;

procedure TMCompress.SetHeader(var hdr: TCompressHeader; cID: string;
                           aType: TCompressArchiveType; size: Longint);
begin
  with hdr do
  begin
    strPLCopy(ComID,CompressedFileHeaderID,sizeof(ComID)); { terminator goes in too, but is safe here }
    Move(cID[1],ComMethodID,sizeof(ComMethodID));          { avoid terminator }
    Fullsize:=size; { uncompressed size, in bytes }
    ArchiveType := aType;
    Checksum := 0;
    Locked:=0;
    if Key>0 then
      Locked := EncryptFlag; { V3.5 }
  end;
end;

{ unlike compressFILE ops, this can leave the result in the destination
  UNCOMPRESSED, WITHOUT A HEADER if that is the optimal result
}
procedure TMCompress.Compress(compressedStream, uncompressedStream: Tstream;
                               compressionMethod: TCompressionMethod);
var hdr: TCompressHeader;
    cID : String;
    checksum: Longint;
    CompressedSize: Longint;
    CompressedStartPosition, Endposition: Longint;
begin
  FCompressedToPercentage := 100; { e.g. for copy }

  if (compressionMethod = coCustom) and not assigned(FOnCompress) then
    compressionMethod := coNone; { just for safety }

  CompressedStartPosition := CompressedStream.Position;

  if uncompressedStream.size < sizeof(hdr)+128 then { forget it! }
     CompressionMethod := coNone;

  if compressionMethod <> coNone then
  begin
    cID :=CompressionCodes[CompressionMethod];
    SetHeader(hdr, cID,caSingle, uncompressedStream.size);
    CompressedStream.writebuffer(hdr,sizeof(hdr));
    FMustCompressByAtLeast := sizeof(hdr); { always reset to zero after DoCompress! }
  end;

  try
    try
      CompressedSize := DoCompress(compressedStream, uncompressedStream,
                                      compressionMethod, cID, checksum);
    except on EUnableToCompress do { stopped when reached original size, so save
                                     with no compression and NO header }
      begin
        CompressionMethod := coNone; { ok? }
        unCompressedStream.seek(0,soFromBeginning);
        compressedStream.Seek(CompressedStartPosition,soFromBeginning);
        CompressedSize := compressedStream.Copyfrom(uncompressedStream,
                                      uncompressedstream.size); { and again... }
      end;
    end; { except }
  finally
    FMustCompressByAtLeast := 0;
  end;
  if CompressionMethod = coNone then exit; { our duty is done, sticks at 100 }

  Inc(CompressedSize,Sizeof(hdr));

  if hdr.FullSize>0 then
    FCompressedToPercentage := CalcPercentage(CompressedSize,hdr.FullSize);

  if CompressionMethod<> coNone then { update header -- custom ID, checksum }
  begin
    EndPosition := CompressedStream.Position;
    compressedStream.Seek(CompressedStartPosition,soFromBeginning);
    Move(cID[1],hdr.ComMethodID,sizeof(hdr.ComMethodID));
    hdr.checksum := checksum;
    CompressedStream.writebuffer(hdr,sizeof(hdr));
    compressedStream.Seek(EndPosition,soFromBeginning);
  end;

end;

function TMCompress.Recognize(const cID: String) : TCompressionMethod;
var recognized: Boolean;
begin
   for result := low(TCompressionMethod) to high(TCompressionMethod) do
       if cID = CompressionCodes[result] then exit; { incl. custom }

   if assigned(FOnRecognize) then { special case }
   begin
        recognized := False;
        FOnRecognize(cID, recognized);
        if recognized then
        begin
         Result := coCustom;
         exit;
        end;
   end;

   raise EUnrecognizedCompressionMethod.Create('Unrecognized compression method: "'+cID+'" in header');

end;

procedure TMCompress.DoExpand(expandedStream, unexpandedStream: Tstream;
                           compressedsize, fullsize, checksum: longint;
                    compressionMethod: TCompressionMethod;const CompressID: string;
                     FLocked: Longint); { FLocked now Longint V3.5 }
var expandchecksum: Longint;
begin
  if (compressionMethod<>coNone) and (FLocked >0) and (Key=0) then
      raise EInvalidKey.Create('File locked -- valid key required');
  expandchecksum := 0;
  FCompressionTime := GetTickCount;
  case compressionMethod of
     coNone: if compressedsize > 0
               then expandedStream.copyFrom(unExpandedStream,compressedsize);
     coRLE, coLZH, coLZH5:
            try
              ProcessStreams(expandedStream, unexpandedStream,compressedsize,fullsize,
                    compressionMethod, expandchecksum, cmExpand, FLocked=EncryptFlag);
            except on ELZHBadDecodeTable do { V3.5 }
                 if FLocked >0 then
                    raise EInvalidKey.Create('File locked -- valid key required')
                 else
                    raise; { stick with it... }
            end;
     coCustom:   if assigned(FOnExpand) then FOnExpand(expandedStream,
                 unExpandedStream, compressedsize, fullsize, CompressID, expandchecksum);
                  { CompressID in case has internal coding, e.g ver }
  end;
  FCompressionTime:=LongInt(GetTickCount) - FCompressionTime;
  if (compressionMethod<>coNone) and (expandchecksum <> checksum) then
    if Flocked >0 then { TCompress V3.0 or earlier lock check applies if checksum fails }
    begin
      if (expandchecksum+Key) <> checksum then
        raise EInvalidKey.Create('File locked -- valid key required')
    end else { genuine checksum error }
       raise EBadChecksum.Create('Bad checksum during expansion -- data may be invalid');
end;

procedure TMCompress.Expand(expandedStream, unExpandedStream: Tstream);
var  hdr: TCompressHeader;
     checksum: Longint;
     compressionMethod: TCompressionMethod;
     StartPosition, csize: Longint;
     cID: String;
begin
  compressionMethod:=coNone;
  checksum := 0;
  StartPosition :=unExpandedStream.Position;
  csize := unExpandedStream.size-StartPosition;
  if csize>sizeof(hdr) then { might have a header }
  begin
     unexPandedStream.Read(hdr,sizeof(hdr)); { have a peek }
     if hdr.ComID=CompressedFileHeaderID then { yup! }
     begin
        if hdr.ArchiveType<>caSingle then { this mode can't handle caMulti! }
           raise EInvalidHeaderArchiveType.Create('Expand can''t handle caMulti archive type in compressed header');
        SetLength(cID,sizeof(hdr.ComMethodID));
        Move(hdr.ComMethodID,cID[1],sizeof(hdr.ComMethodID));
        CompressionMethod := Recognize(cID); { raises exception if can't recognize }
        checksum := hdr.checksum;
        Dec(csize,sizeof(hdr));
        if expandedStream is TMemoryStream then { get the size in one go }
           TMemoryStream(expandedStream).setSize(hdr.FullSize); {expanded size, see? }
     end else { nope -- not compressed, no header, copy the LOT}
        unexpandedStream.Seek(StartPosition,soFromBeginning); { rewind for full copy }
  end;
  { note: hdr.Fullsize undefined if coNone }
  DoExpand(expandedStream, unexpandedStream,
           csize,hdr.Fullsize,checksum,compressionMethod, cID, hdr.Locked);
end;

function TMCompress.GetFileHeader(Stream: TStream;var Fhdr: TCompressedFileHeader; var Filename: String): Boolean;
begin
    result := False;
    if stream.read(Fhdr,sizeof(Fhdr))=sizeof(Fhdr) then { got one }
    begin
     SetLength(Filename,Fhdr.FilenameLength);
     if stream.read(Filename[1],Fhdr.FilenameLength)=Fhdr.FileNameLength then
        Result := True;
    end;
end;

procedure TMCompress.PutFileHeader(Stream: TStream;var Fhdr: TCompressedFileHeader; const Filename: String);
begin
    Fhdr.FilenameLength :=Length(Filename);
    stream.writebuffer(Fhdr,sizeof(Fhdr));
    stream.writebuffer(Filename[1],Length(Filename));
end;

procedure TMCompress.ScanCompressedStream(compressedstream: TStream;
                                                   var Finfo: TStringList);
var hdr: TCompressHeader;
    Fhdr: TCompressedFileHeader;
    Filename: String;
    cfileinfo : TCompressedFileInfo;
    CID: string;
begin
  if (compressedStream.size-compressedStream.position) >= sizeof(hdr)+sizeof(Fhdr) then { got something in it }
  begin
    checkHeader(compressedStream,hdr,cID);

    while GetFileHeader(compressedStream,Fhdr,Filename) do { got one }
    begin
     cfileinfo:= TCompressedFileInfo.Create;
     cfileinfo.Datetime:=Fhdr.Datetime;
     cfileInfo.Attributes:= FHdr.Attributes;
     cfileinfo.Fullsize := Fhdr.Fullsize;
     cfileinfo.Compressedsize := Fhdr.CompressedSize;
     cfileinfo.Position := compressedStream.position-sizeof(Fhdr)-Fhdr.FilenameLength;
     cfileinfo.CompressedMode:=Fhdr.CompressedMode;
     cfileinfo.Checksum:=Fhdr.Checksum;
     cfileInfo.Locked := FHdr.Locked>0; 
     FInfo.addobject(filename,cfileinfo);
     compressedStream.seek(Fhdr.Compressedsize,soFromCurrent); { move on... }
    end;
  end;
end;

procedure TMCompress.ScanCompressedFile(const arcfile: String; var Finfo: TStringList);
var cfile: TFilestream;
begin
   cfile:=TFilestream.create(arcfile,fmOpenRead or fmShareExclusive);
   try
     ScanCompressedStream(cfile,Finfo);
   finally
     cfile.free;
   end;
end;

{ Assumes both exist on same path. Renames new to old AND deletes old... }
procedure replaceFile(oldfile, newfile: String);
begin
  SysUtils.DeleteFile(oldfile);
  renameFile(newfile,oldfile);
end;

function FixStoredFilename(s: String): String;
begin
  if (Length(s) > 2) and (s[2]=':') then { has a drive specifier -- get rid of it }
       s := Copy(s,3,Length(s));
  result := s; {AnsiLowerCase(s); No longer changing case, V3.0 }
end;


{ added V3.0 to avoid changing filename case }
function FileInList(whichFiles: TStringList;filename: string): Boolean;
var count: Integer;
begin
  result := True;
  for count := 0 to pred(whichFiles.count) do
    if CompareText(Filename,whichFiles[count])=0 then
      exit;
  result := False; { not there }
end;

{ The cute thing about this is that it does NOT insist on
  destfile pre-existing, so can implement a DELETE with it too! }
procedure TMCompress.AppendFilesExcept(const destfile,fromfile: String;
                                                      notfiles: TStringlist);
var dest, source: TFileStream;
  dhdr, shdr: TCompressHeader;
  FHdr: TCompressedFileHeader;
  Filename: String;
begin
  source:=TFilestream.create(fromfile,fmOpenRead or fmShareExclusive);

  if FileExists(destfile) then
    dest:=TFilestream.create(destfile,fmOpenReadWrite or fmShareExclusive)
  else  { create from scratch -- e.g. in delete case }
    dest:=TFilestream.create(destfile,fmCreate);

  try
    if source.size>sizeof(shdr)+sizeof(Fhdr) then { ok to proceed }
    begin
        source.read(shdr,sizeof(shdr));
        if dest.size >sizeof(dhdr) then
        begin
          dest.read(dhdr,sizeof(dhdr));
          dest.seek(0,soFromEnd); { end of file }
        end else { no header -- make one like source }
        begin
          dhdr := shdr;
          dhdr.Fullsize:= 0; { for now... }
          dest.writebuffer(dhdr,sizeof(dhdr));
        end;

        while GetFileHeader(source,Fhdr,Filename) do { got one }
        begin
           if not FileInList(notfiles,Filename) then { 3.02 keep? ok, copy to dest }
           begin
             PutFileHeader(dest,Fhdr,Filename);
             if fhdr.CompressedSize> 0 then dest.Copyfrom(source,fhdr.CompressedSize);
             Inc(dhdr.Fullsize,fhdr.FullSize);
           end else
             source.seek(Fhdr.Compressedsize,soFromCurrent);
        end;
        dest.seek(0,soFromBeginning);
        dest.writebuffer(dhdr,sizeof(dhdr)); { update... }
    end;
  finally
   dest.free;
   source.free;
  end;
end;


procedure TMCompress.DeleteFiles(const arcFile: String; whichfiles: TStringList);
var newfilename, storedwhichfile, whichfile: String;
     count,here: Integer;
begin
  count := 0;
  while count < whichfiles.count do
  begin
     whichfile := whichfiles[count];
     storedwhichfile := whichfile;
     if assigned(FOnCheckFile) then
     begin
        FOnCheckFile(storedwhichfile,cmDelete); { changes as required... }
        if (storedwhichFile=CompressSkipFlag) or (storedwhichfile=CompressNoMoreFlag) then
        begin
          whichfiles.delete(count); { modify the list for reference by caller... }
          if (storedwhichfile=CompressNoMoreFlag) then
          begin
             here := count;
             for count:=whichfiles.count-1 downto here+1 do { any more? }
              whichfiles.delete(count);
             break; { we've emptied the remainder of the list... }
          end;
          continue;                { skip increment }
        end;
     end;
     inc(count);
  end; { for }
  { We've now verified which ones to delete... go ahead and do it... }
  if whichfiles.count > 0 then
  begin
    newfilename := ChangeFileExt(arcfile,TempExtension); { too bad if it exists... }
    AppendFilesExcept(newfilename,arcfile,whichfiles); { see? }
    ReplaceFile(arcfile,newfilename); { just like that ! }
  end;
end;

procedure TMCompress.CompressFiles(const arcFile: String; whichfiles: TStringList;
                                            CompressionMode: TCompressionMethod);
var dest: TFileStream;
     update: Boolean;
     newfilename: String;
begin
  update:=False;
  newfilename := arcfile;
  if FileExists(arcfile) then { we are updating an existing archive... I assume }
  begin
    update:=True;
    newfilename := ChangeFileExt(arcfile,TempExtension); { overwritten if it exists... }
  end;
 { special check for what should be obvious reasons (and fmShareExclusive seems not to lock OURSELVES out!) }
  if FileInList(whichfiles,newfilename) then { V3.02 FileInList}
     whichfiles.delete(whichfiles.indexof(ansilowercase(newfilename))); { of course, they could CHEAT
                                                             & force it in FonCheck file but... }
  dest:=TFilestream.create(newfilename,fmCreate or fmShareExclusive);
  try
    CompressFilesToStream(dest,whichfiles,CompressionMode);
  except on EWriteError do  { ran out of disk space? or protected? }
    begin
      dest.free;
      SysUtils.DeleteFile(newfilename);
      raise EInsufficientDiskSpace.Create('Ошибка записи: Disk protected or full during compression');
    end;
  end;

  dest.free;
  if update then begin { lots to do here... }
     try
       AppendFilesExcept(newfilename,arcfile,whichfiles);
     except on EWriteError do  { ran out of disk space? }
         raise EInsufficientDiskSpace.Create('Disk full or write error during compression');
     end;
     ReplaceFile(arcfile,newfilename);
  end;
end;

{ Note: This function DOES NOT update/append to an existing stream --
  that would have to be managed by the calling procedure (see CompressFiles) }
function TMCompress.CompressFilesToStream(dest: TStream; var whichfiles: TStringList;
                                      CompressionMode: TCompressionMethod): longint;
var hdr: TCompressHeader;
     fromfile, storedfromfile: String;
     cID: string;
     count : Integer;
     source: TFileStream;
     Fhdr: TCompressedFileHeader;
     Filename: String;
begin
  source := nil; { V3.0 to silence warning }
  cID := CompressionCodes[CompressionMode];
  Result := 0; { non-zero means dest is a FILE requiring truncation after dest is closed... }
  SetHeader(hdr, cID, caMulti, Longint(0));
  dest.writebuffer(hdr,sizeof(hdr));
  count := 0;
  while count < whichFiles.count do
  begin
     fromfile := whichfiles[count];
     storedfromfile := fromfile;
     if TargetPath<>'' then { trim off target path if set?  V2.5 }
       if CompareText(Copy(storedFromFile,1,Length(targetPath)),targetPath)=0 then { cut it }
             storedFromFile :=Copy(storedFromFile,Length(targetPath)+1,9999);
     if assigned(FOnCheckFile) then
     begin
        FOnCheckFile(storedFromFile,cmCompress); { changes as required... }
        if (storedFromFile=CompressSkipFlag) or (storedFromfile=CompressNoMoreFlag) then
        begin
          whichfiles.delete(count); { modify the list for reference by caller... }
          if (storedFromfile=CompressNoMoreFlag) then
             break; { note that earlier files ARE processed }
          continue;                { skip it }
        end;
     end;
     storedfromFile := FixStoredFilename(storedfromFile); { no drive, all lower }
     try
       source:=TFilestream.create(fromfile,fmOpenRead or fmShareDenyNone); {V3.0 (was fmShareExclusive) }
     except on EFOpenError do
      begin
        if ExceptionOnFileError then
           raise;
        whichfiles.delete(count); { modify the list for reference by caller... }
        continue;                { skip it }
      end;
     end;
     whichfiles[count] := storedfromfile; { save amendments for reference by caller }
     Filename := storedfromfile;

     with FHdr do
     begin
       DateTime := FileGetDate(source.Handle);
       Attributes := fileGetattr(fromfile);
     end;

     try { V3.0 rewrite to use new routine... }
       inc(hdr.Fullsize,source.size);
       CompressStreamToArchiveStream(dest,source,
            Filename,FHdr,CID,CompressionMode);
     finally
       source.free;
     end;

     inc(Count);
  end; { for }

  Move(cID[1],hdr.ComMethodID,sizeof(hdr.ComMethodID));  { in case CUSTOM changed it... }
  dest.seek(0,soFromBeginning);
  dest.writebuffer(hdr,sizeof(hdr)); { updates Fullsize as well }
end;

{ New in V3.0 --
 Called to write an arbitrary stream to the current archive position.
 Assumes:
a) FHdr.DateTime, FHdr.attributes and Filename are all valid
b) both source and dest are at the correct starting place
c) CID is at least 3 bytes long, potentially holding a custom compression method ID
   -- *should* be written to archive header's ComMethodID field when all done
e) Archive header's Fullsize value will be incremented with the source.size-source.position value
NB: will save WITHOUT compression if saving WITH makes it larger

SETS following Fhdr fields:
 CompressedMode, CompressedSize, FullSize, FileNameLength, Locked
}

procedure TMCompress.CompressStreamToArchiveStream(compressedStream, unCompressedStream: TStream;
            const Filename: string; FHdr: TCompressedFileHeader;
            var cID: string; CompressionMode: TCompressionMethod);
var  fhdrpos, savepos, thisfilein, thisfileout :Longint;
begin
     savepos := uncompressedStream.position;
     thisfilein := uncompressedStream.size-savepos;
     fhdrpos := compressedStream.position;
     PutFileHeader(compressedStream,Fhdr,Filename);

     try
       thisfileout := DoCompress(compressedStream,uncompressedStream,compressionMode, cID,fhdr.checksum);
     except on EUnableToCompress do { stopped when reached original size, so save
                                      with no compression and NO header }
       begin
         CompressionMode := coNone; { flag }
         compressedStream.Seek(fhdrpos+sizeof(Fhdr)+Fhdr.FilenameLength,soFromBeginning); { rewrite from compressed area }
         uncompressedStream.seek(savepos,soFromBeginning); { rewind! }
         thisfileout := thisfilein;
         if thisfilein > 0 then compressedStream.Copyfrom(uncompressedStream,thisfilein);
         fhdr.checksum := 0; { by default }
       end;
     end; { except }

     savepos := compressedStream.position;
     with FHdr do
     begin
       Fhdr.CompressedSize := thisfileout;
       Fhdr.Fullsize := thisfilein;
       CompressedMode := CompressionMode; { the default for this Cfile }
       Locked := 0;
       if Key>0 then
        Locked := EncryptFlag; { V3.5 }
     end;

     compressedStream.seek(fhdrpos,soFromBeginning);
     compressedStream.writebuffer(fhdr,sizeof(fhdr)); { not updating filename here, so ok }
     compressedStream.seek(savepos,soFromBeginning);
     if thisfilein > 0 then
       FCompressedToPercentage := CalcPercentage(thisfileout,thisfilein)
     else
      FCompressedToPercentage := 100;
end;


{ Compresses the remaining contents of uncompressedStream using dummy name
  in Filename onto the end of the current archive (creates if necessary).
  Does NOT check if Filename is already in the archive.
}
procedure TMCompress.CompressStreamToArchive(arcFile: String; uncompressedStream: TStream; const fileName: string;
                           CompressionMode: TCompressionMethod); { V3.0 }
var dest: TFileStream;
    CID: string;
    hdr: TCompressHeader;
    fHdr: TCompressedFileHeader;
begin
  cID := CompressionCodes[CompressionMode];
  if FileExists(arcFile) then
  begin
    dest:=TFilestream.create(arcFile,fmOpenReadWrite or fmShareExclusive);
    try
      checkHeader(dest,hdr,cID);
      dest.seek(0,soFromEnd); { always appends, no checks on pre-existence }
    except on Exception do begin dest.free; raise end
    end;
  end else { new archive }
  begin
    dest:=TFilestream.create(arcFile,fmCreate or fmShareExclusive);
    SetHeader(hdr, cID, caMulti, Longint(0));
    dest.writebuffer(hdr,sizeof(hdr)); { ensure we have the correct header in the archive }
  end;

  try
    try
      fHdr.Datetime := 0;
      fHdr.attributes :=0; { all else is set & written in the next call... }
      inc(hdr.Fullsize,uncompressedStream.size-uncompressedStream.position);
      CompressStreamToArchiveStream(dest,uncompressedStream,fileName,fHdr,
                                    CID,CompressionMode);
      Move(cID[1],hdr.ComMethodID,sizeof(hdr.ComMethodID));  { in case CUSTOM changed it... }
      dest.seek(0,soFromBeginning);
      dest.writebuffer(hdr,sizeof(hdr)); { updates Fullsize as well }
    except on EWriteError do  { ran out of disk space? or protected? }
      raise EInsufficientDiskSpace.Create('Disk protected or full during compression');
    end; { except }
  finally
    dest.free;
  end;
end;

{ Finds FIRST occurrence of Filename in the archive and expand into uncompressedStream. }
procedure TMCompress.ExpandStreamFromArchive(arcFile: String; uncompressedStream: TStream; fileName: string); { V3.0 }
var from: TFileStream;
    thisfile,CID: string;
    hdr: TCompressHeader;
    fHdr: TCompressedFileHeader;
    ExpandedSize: Longint; { just in case stream continues past archive end }
begin
  from:=TFilestream.create(arcfile,fmOpenRead or fmShareExclusive);
  try
    checkHeader(from,hdr,cID);
    ExpandedSize :=0;
    while (GetFileHeader(from,Fhdr,thisfile))
      and (ExpandedSize < hdr.FullSize) do
    begin
     if CompareText(thisfile,Filename)=0  then { V3.03 -- not case sensitive, stop when found }
     begin
       DoExpand(unCompressedStream,from,fhdr.CompressedSize,fhdr.Fullsize,fhdr.checksum,
                                fhdr.CompressedMode,cID, Fhdr.Locked)
     end else
        from.seek(Fhdr.Compressedsize,soFromCurrent); { move on... }
     Inc(ExpandedSize,fhdr.Fullsize);
    end; { while }
  finally
    from.free;
  end;
end;


procedure TMCompress.ExpandFiles(const arcfile:String;whichfiles: TStringList);
var from: TFilestream;
begin
  from:=TFilestream.create(arcfile,fmOpenRead or fmShareExclusive);
  try
     ExpandFilesFromStream(from,whichfiles);
  finally
     from.free;
  end;
end;

function TMCompress.CheckDiskSpace(filename: String): longint;
var f : file of Byte;
     diskid: Integer;
     freespace: Longint;
begin
  result := MaxLongInt; { automatic pass }
  if not CheckSpaceBeforeExpand then { 3.05 }
     exit;
  diskid:=0;
  filename:=uppercase(filename);
  if (length(filename)>1) and (filename[2]=':') then { has drive }
     diskid:=ord(filename[1])-ord('@'); { 1 for A, 2 for B etc. }
  freespace := diskfree(diskid); { so far so good }
  if freespace >= 0 then
    result := freespace; { otherwise stays at MaxLongint 3.02 }

  if (result < MaxLongInt) and FileExists(filename) then { add 2 billion check v3.01 }
  begin
   Assignfile(f,filename); { open it }
   Filemode := 0; { 3.02 }
   Reset(f);
   result := result+Filesize(f);
   Closefile(f); { and that's it... }
  end;
end;

{ Validates that stream (forced to the start) is:
a) Big enough to hold a TCompress header (else no action -- leaves at start and
   initializes hdr to caMulti/current CID)
b) Contains valid CompressedFileHeaderID
c) Is of type caMulti
d) has a recognisable ComMethodID, e.g. 'LZH'
   -- raises exceptions if not. If ok, hdr and CID are set and the stream
   position is at the end of the header
}
procedure TMCompress.CheckHeader(compressedFile: TStream;var hdr: TCompressHeader; var CID: string);
begin
   SetLength(cID,sizeof(hdr.ComMethodID));
{   compressedFile.seek(0,sofromBeginning);  disabled v3.5 }
   if (compressedFile.size-compressedFile.position) >= sizeof(hdr) then
   begin
     compressedFile.read(hdr,sizeof(hdr));
     if hdr.ComID<>CompressedFileHeaderID then { oops }
       raise EInvalidHeader.Create('Can''t recognize compressed file header');
     if hdr.ArchiveType<>caMulti then { wrong mode! }
       raise EInvalidHeaderArchiveType.Create('Archive type must be caMulti');
    Move(hdr.ComMethodID,cID[1],sizeof(hdr.ComMethodID));
    Recognize(cID); { raises exception if can't recognize }
   end else
     SetHeader(hdr, cID, caMulti, Longint(0)); { CID *may* be garbage if not initialised before call }
end;

procedure TMCompress.ExpandFilesFromStream(compressedstream:TStream;whichfiles: TStringList);
var hdr: TCompressHeader;
    FHdr: TCompressedFileHeader;
    Filename: String;
    dest: TFilestream;
    whichfile: String;
    ExpandedList: TStringlist;
    expandedSize: Longint; { V2.5 so we can stop even if resource size > actual archive size }
    cID: String;
    fndir,scurpath:string;{v IVP***}
begin
  dest := nil; { V3.0 to silence warning }
  ExpandedList:=TStringlist.Create;
  try
    checkHeader(compressedStream,hdr,cID);

    ExpandedSize :=0;
    while (GetFileHeader(compressedStream,Fhdr,Filename))
      and (ExpandedSize < hdr.FullSize) do { V2.5 added ExpandedSize test }
    begin
     if (whichfiles<>nil) and (not FileInList(whichFiles,filename)) then  { FileInList V3.0 }
        compressedStream.seek(Fhdr.Compressedsize,soFromCurrent) { move on... }
     else
     begin
        whichfile := Filename;
        if Copy(whichfile,1,1)<>'\' then { not an absolute path?  V2.5 }
           whichfile:=TargetPath+whichfile;  { TargetPath prepend V2.5 }
        if assigned(FonCheckFile) then
        begin
          FOnCheckFile(whichfile,cmExpand); { changes as required... }
          if (whichFile=CompressSkipFlag) then
          begin
            compressedStream.seek(Fhdr.Compressedsize,soFromCurrent); { move on... }
            continue
          end;
          if whichfile=CompressNoMoreFlag then
              break;
        end;
        { check we have space available -- roughly }

        if CheckDiskSpace(whichfile) < FHdr.fullsize then
           raise EInsufficientDiskSpace.Create('Not enough disk space to expand '+whichfile);

        if MakeDirectories then begin      {modified *** IVP 98.10.21}
         fnDir:=ExtractFilePath(Whichfile);
         if fnDir<>'' then begin {modified *** IVP 98.11.14}
          sCurPath:=GetCurrentDir;
          if sCurpath[length(sCurpath)]<>'\' then SCurpath:=sCurpath+'\';
          if fnDir[2]<>':' then fnDir:=sCurPath+fnDir;
          ForceDirectories(fnDir);
         end;
        end;

        { here we get to create the file and expand into it... }
        try
          dest:=TFileStream.Create(whichfile,fmCreate or fmShareExclusive)
        except on EFOpenError do
           begin
              if ExceptionOnFileError then
                 raise;
              compressedStream.seek(Fhdr.Compressedsize,soFromCurrent); { move on... }
              continue
           end;
        end;
        { Note that we SUPPORT varying modes here, i.e. we use each file's mode,
          BUT the cID could conceivably overrule it if inspected in OnExpand... (we don't) }
        try
          try  { EInvalidKey handling V2.5 }
            DoExpand(dest,compressedStream,
                     fhdr.CompressedSize,fhdr.Fullsize,fhdr.checksum,
                                                  fhdr.CompressedMode,cID, Fhdr.Locked);
          except on EInvalidKey do
            begin
              dest.free; { close }
              dest := nil;
              SysUtils.DeleteFile(whichfile);
              raise; { raise again so the world knows... }
            end;
          end;
          FileSetDate(dest.handle,Fhdr.DateTime);
          ExpandedList.add(whichfile);
        finally
           if dest<>nil then { V2.5 -- add test as possible EInvalidKey }
           begin
            dest.free;
            FileSetAttr(whichfile,FHdr.Attributes);
           end;
        end;
     end; { if }
     Inc(ExpandedSize,fhdr.Fullsize); { moved from above FilesetDate V3.0 }
    end; { while }
    if whichFiles<>nil then  { nil test added V2.5 }
    begin
      whichfiles.clear;
      whichfiles.assign(ExpandedList);
    end;
 finally
  ExpandedList.free;
 end;
end;


function TMCompress.GetCompressedPercentage: Integer;
begin
   Result := 100-FCompressedToPercentage; { display per PKZIP's approach, i.e. 99% is LOTS }
end;


{ Variables for ProcessStreams, LZH/RLE routines }
var AtStart, InputEOF, inRepeat: Boolean;
    inBuffer, outBuffer: PChar;
    inBmax, inBptr, outBmax, outBptr: Pchar;
    source, dest: TStream;
    lastch: Char;
    DupCount : Integer;
    InChecksum, Outchecksum, Readsize, lChunk, BytesIn, BytesOut: Longint;
    EncryptingIn, EncryptingOut: Boolean; { V3.5 }
    EncryptCodes: Array[0..3] of Byte;
    EncryptCounter: Smallint;
    MaxNumberOfBytesToWrite: Longint;

function Encrypt(ch: char): char; { V3.5 }
begin
  result := char(ord(ch) xor EncryptCodes[EncryptCounter]);
  inc(EncryptCounter); {***modified by IVP 1998, June 22}
  EncryptCounter := EncryptCounter mod 4;
end;

function GetChar: Char;
var BytesRead: LongInt;
    Progress: Longint;
begin
  if inBptr = inBMax then { done buffer }
  begin
     Result := #0;
     InputEOF := True; { precautionary }
     if readsize=0 then
        exit; { no more boss }
     if lChunk > readsize then
        lChunk := readsize;
     BytesRead := source.Read(inBuffer^, lChunk); { read chunk }
     readsize:=readsize-BytesRead;
     if BytesRead = 0 then { EOF }
        exit;
     inBmax := inBuffer+BytesRead;
     inBptr := inBuffer;
     if assigned(GlobalOnShowProgress) then
     begin
       BytesIn := BytesIn + BytesRead; { read so far -- readsize is "yet to read" }
       Progress := CalcPercentage(BytesIn,BytesIn+Readsize); { V3.01 }
       GlobalOnShowProgress(Progress);
       if Progress = -1 then { user cancel }  { V3.01 -- test for -1 explicitly -- was < 0 }
         exit; { InputEOF is still true at present, so we fake an early EOF, is all }
     end;
{$IFDEF WIN32}
     Sleep(0);  { V2.5 replaces Application.ProcessMessages so Compress can be
                  used without Forms dependency }
{$ENDIF}
     InputEOF := False; { keep on in there... }
  end;
  Result := inBptr^;
  InCheckSum:= InChecksum+Ord(Result);
  if EncryptingIn then
    Result := Encrypt(result);
  Inc(inBptr);
end;

procedure PutChar(ch: Char);
begin
  if MaxNumberOfBytesToWrite <= 0 then { V3.5 } begin
   // showmessage(ch);
   // raise EUnableToCompress.Create('Could not compress data');
  end;
//  if MaxNumberOfBytesToWrite <= 0 then exit;

  Dec(MaxNumberOfBytesToWrite);

  if outBptr = outBmax then { filled buffer }
  begin
{$IFDEF WIN32}
    Sleep(0);  { V2.5 replaces Application.ProcessMessages so Compress can be
                  used without Forms dependency }
{$ENDIF}
    dest.writebuffer(OutBuffer^,ChunkSize);
    outBptr := outBuffer;
  end;
  if EncryptingOut then
    ch := Encrypt(ch); { really a decrypt }
  outBptr^ := ch;
  OutCheckSum:= OutChecksum+Ord(ch);
  Inc(outBptr);
  Inc(BytesOut);
end;

{$IFDEF RLE_COMPRESS}
procedure emit(count: Integer; ch: char);
begin
  if (count > 2) or (count=0) then {only emit if worth it }
  begin
    putChar(RLEescapechar);
    putChar(chr(count));
  end else
  begin
     Dec(count);
     while count > 0 do begin putChar(ch); Dec(count) end;
  end;
end;

procedure CompressRLE;
var ch: Char;
begin
 while True do
 begin
   ch:= GetChar;
   if InputEOF then
   begin
     if inRepeat then
        emit(Dupcount,lastch); { flag the repeat }
     break;
   end;
   if inRepeat then
   begin
      if (lastch = ch) and (DupCount<255) then
        Inc(DupCount) { and stay in inRepeat }
      else
      begin
        emit(DupCount,lastch); { however many }
        lastch := ch;
        if ch=RLEescapechar then
        begin
           emit(0,RLEEscapechar); { flag it }
        end else
           Putchar(ch);
        inRepeat := False;
      end;
   end else
   begin
     if (ch=RLEescapechar) then
        emit(0,ch)
     else if (ch=lastch) and not AtStart then
     begin
        DupCount := 2;
        inRepeat := True;
     end else Putchar(ch);
     lastch := ch;
   end;
   AtStart := False;
 end; { While not InputEOF }
end;
{$ENDIF} {RLE_COMPRESS}

{$IFDEF RLE_EXPAND}
procedure ExpandRLE;
var ch: Char;
begin
 while True do
 begin
   ch:= GetChar;
   if InputEOF then
     break; { done, at last... }
   if ch<> RLEescapechar then
     Putchar(ch)
   else { ok, get a count... MUST be there, really! }
   begin
     DupCount := Ord(GetChar); { 0 if EOF, but not legal, however... }
     if DupCount=0 then Putchar(RLEEscapechar) { special flag }
     else
     begin
        Dec(DupCount);  { because one was already IN the bytestream }
        while Dupcount>0 do begin Putchar(lastch); Dec(DupCount) end;
     end;
   end;
   lastch := ch;
 end; { while }
end;
{$ENDIF} { RLE_EXPAND }

{    Compress/ExpandLZH
     Derived from the Unix C code of the LHarc Encoding/Decoding module
  	LZSS Algorithm			Haruhiko.Okumura
  	Adaptic Huffman Encoding	1989.05.27  Haruyasu.Yoshizaki
     See copyright/distribution permissions at end of the LZH section
     (from the Unix 'man' document accompanying the original file)
}

{$IFDEF LZH1_EXPAND}  { we want expand enabled }
  {$DEFINE LZH1_COMMON}  { then we need common data/routines }
{$ENDIF}
{$IFDEF LZH1_COMPRESS}  { we want compress enabled }
  {$DEFINE LZH1_COMMON}
{$ENDIF}


{$IFDEF LZH1_COMMON} { stuff common to both compress and expand }

{
  LZSS encoding
}
const N  = 4096; { Buffer }
      TNIL = 4096; { nil in tree terms }
      F = 60;   { lookahead buffer }
      THRESHOLD = 2;

      N_CHAR = (256 - THRESHOLD + F); { 256-THRESHOLD+F, code : 0 .. N_CHAR-1 }
      T = N_CHAR * 2 - 1;      { size of table }
      R = T - 1;                { root position }
      MAX_FREQ = $8000;	     { tree update timing from frequency }


type textbuffer =Array [0..N + F-1] of char;
     textbufptr = ^textbuffer;
     lsons = Array[0..N] of Smallint;
     lsonptr = ^lsons;
     rsons = Array[0..N + 1 + N] of Smallint;
     rsonptr = ^rsons;
     dads =  Array[0..N + 1] of Smallint;
     dadptr = ^dads;
     samebuf = Array[0..N + 1] of char;
     samebufptr = ^samebuf;

var  text_buf: textbufptr;
     lson: lsonptr;
     rson: rsonptr;
     dad:  dadptr;
     same: samebufptr;

{	HUFFMAN ENCODING }

{ Encode/Decode table for upper 6 bits position information }

{ for encode }
const p_len: Array [0..63] of Char =
(	#03, #04, #04, #04, #05, #05, #05, #05,
	#05, #05, #05, #05, #06, #06, #06, #06,
	#06, #06, #06, #06, #06, #06, #06, #06,
	#07, #07, #07, #07, #07, #07, #07, #07,
	#07, #07, #07, #07, #07, #07, #07, #07,
	#07, #07, #07, #07, #07, #07, #07, #07,
	#08, #08, #08, #08, #08, #08, #08, #08,
	#08, #08, #08, #08, #08, #08, #08, #08
);

p_code: Array [0..63] of Char =
(	Char($00), char($20), char($30), char($40), char($50), char($58), char($60), char($68),
	char($70), char($78), char($80), char($88), char($90), char($94), char($98), char($9C),
	char($A0), char($A4), char($A8), char($AC), char($B0), char($B4), char($B8), char($BC),
	char($C0), char($C2), char($C4), char($C6), char($C8), char($CA), char($CC), char($CE),
	char($D0), char($D2), char($D4), char($D6), char($D8), char($DA), char($DC), char($DE),
	char($E0), char($E2), char($E4), char($E6), char($E8), char($EA), char($EC), char($EE),
	char($F0), char($F1), char($F2), char($F3), char($F4), char($F5), char($F6), char($F7),
	char($F8), char($F9), char($FA), char($FB), char($FC), char($FD), char($FE), char($FF)
);

{ for decode }
d_code: Array [0..255] of Char =
(	#00, #00, #00, #00, #00, #00, #00, #00,
	#00, #00, #00, #00, #00, #00, #00, #00,
	#00, #00, #00, #00, #00, #00, #00, #00,
	#00, #00, #00, #00, #00, #00, #00, #00,
	#01, #01, #01, #01, #01, #01, #01, #01,
	#01, #01, #01, #01, #01, #01, #01, #01,
	#02, #02, #02, #02, #02, #02, #02, #02,
	#02, #02, #02, #02, #02, #02, #02, #02,
	#03, #03, #03, #03, #03, #03, #03, #03,
	#03, #03, #03, #03, #03, #03, #03, #03,
	#04, #04, #04, #04, #04, #04, #04, #04,
	#05, #05, #05, #05, #05, #05, #05, #05,
	#06, #06, #06, #06, #06, #06, #06, #06,
	#07, #07, #07, #07, #07, #07, #07, #07,
	#08, #08, #08, #08, #08, #08, #08, #08,
	#09, #09, #09, #09, #09, #09, #09, #09,
	Char($0A), Char($0A), Char($0A), Char($0A), Char($0A), Char($0A), Char($0A), Char($0A),
	Char($0B), char($0B), char($0B), char($0B), char($0B), char($0B), char($0B), char($0B),
	char($0C), char($0C), char($0C), char($0C), char($0D), char($0D), char($0D), char($0D),
	char($0E), char($0E), char($0E), char($0E), char($0F), char($0F), char($0F), char($0F),
	char($10), char($10), char($10), char($10), char($11), char($11), char($11), char($11),
	char($12), char($12), char($12), char($12), char($13), char($13), char($13), char($13),
	char($14), char($14), char($14), char($14), char($15), char($15), char($15), char($15),
	char($16), char($16), char($16), char($16), char($17), char($17), char($17), char($17),
	char($18), char($18), char($19), char($19), char($1A), char($1A), char($1B), char($1B),
	char($1C), char($1C), char($1D), char($1D), char($1E), char($1E), char($1F), char($1F),
	char($20), char($20), char($21), char($21), char($22), char($22), char($23), char($23),
	char($24), char($24), char($25), char($25), char($26), char($26), char($27), char($27),
	char($28), char($28), char($29), char($29), char($2A), char($2A), char($2B), char($2B),
	char($2C), char($2C), char($2D), char($2D), char($2E), char($2E), char($2F), char($2F),
	char($30), char($31), char($32), char($33), char($34), char($35), char($36), char($37),
	char($38), char($39), char($3A), char($3B), char($3C), char($3D), char($3E), char($3F)
);

d_len: Array [0..255] of Char =
(	#03, #03, #03, #03, #03, #03, #03, #03,
	#03, #03, #03, #03, #03, #03, #03, #03,
	#03, #03, #03, #03, #03, #03, #03, #03,
	#03, #03, #03, #03, #03, #03, #03, #03,
	#04, #04, #04, #04, #04, #04, #04, #04,
	#04, #04, #04, #04, #04, #04, #04, #04,
	#04, #04, #04, #04, #04, #04, #04, #04,
	#04, #04, #04, #04, #04, #04, #04, #04,
	#04, #04, #04, #04, #04, #04, #04, #04,
	#04, #04, #04, #04, #04, #04, #04, #04,
	#05, #05, #05, #05, #05, #05, #05, #05,
	#05, #05, #05, #05, #05, #05, #05, #05,
	#05, #05, #05, #05, #05, #05, #05, #05,
	#05, #05, #05, #05, #05, #05, #05, #05,
	#05, #05, #05, #05, #05, #05, #05, #05,
	#05, #05, #05, #05, #05, #05, #05, #05,
	#05, #05, #05, #05, #05, #05, #05, #05,
	#05, #05, #05, #05, #05, #05, #05, #05,
	#06, #06, #06, #06, #06, #06, #06, #06,
	#06, #06, #06, #06, #06, #06, #06, #06,
	#06, #06, #06, #06, #06, #06, #06, #06,
	#06, #06, #06, #06, #06, #06, #06, #06,
	#06, #06, #06, #06, #06, #06, #06, #06,
	#06, #06, #06, #06, #06, #06, #06, #06,
	#07, #07, #07, #07, #07, #07, #07, #07,
	#07, #07, #07, #07, #07, #07, #07, #07,
	#07, #07, #07, #07, #07, #07, #07, #07,
	#07, #07, #07, #07, #07, #07, #07, #07,
	#07, #07, #07, #07, #07, #07, #07, #07,
	#07, #07, #07, #07, #07, #07, #07, #07,
	#08, #08, #08, #08, #08, #08, #08, #08,
	#08, #08, #08, #08, #08, #08, #08, #08
);


type freqs =Array [0..T] of word;
     freqptr = ^freqs;
     prnts =Array [0..T+N_CHAR] of smallint;
     prntptr = ^prnts;
     sons =Array [0..T] of smallint;
     sonptr = ^sons;

var  freq: freqptr; 	{ frequency table }
     prnt: prntptr;    { parent nodes }
     son: sonptr;      { points to son nodes (son^[i],son^[i+1]) }
{ notes : prnt^[T .. T + N_CHAR - 1] used by
     indicates leaf position that corresponds to code }

var putbuf: Word;
    putlen: Char;
    getbuf: Word;
    getlen: char;


{ Initialize tree }

procedure StartHuff;
var i,j: Smallint;
begin

  for i := 0 to N_CHAR-1 do
  begin
    freq^[i] := 1;
    son^[i] := i + T;
    prnt^[i + T] := i;
  end;
  i := 0; j := N_CHAR;
  while (j <= R) do
  begin
    freq^[j] := freq^[i]+freq^[i + 1];
    son^[j] := i;
    prnt^[i] := j;
    prnt^[i + 1] := j;
    Inc(i,2); Inc(j);
  end;
  freq^[T] := $ffff;
  prnt^[R] := 0;
  putlen := #0;
  getlen := #0; { good to see... }
  putbuf := 0;
  getbuf := 0;
end;

procedure EndHuff;
begin
  if rson<>nil then freeMem(rson,sizeof(rson^)); rson := nil;
  if lson<>nil then freeMem(lson,sizeof(lson^)); lson := nil;
  if dad<>nil then freeMem(dad,sizeof(dad^)); dad := nil;
  if same<>nil then freeMem(same,sizeof(same^)); same := nil;
  if text_buf<>nil then freeMem(text_buf,sizeof(text_buf^)); text_buf := nil;
  if son<>nil then freeMem(son,sizeof(son^)); son := nil;
  if prnt<>nil then freeMem(prnt,sizeof(prnt^)); prnt := nil;
  if freq<>nil then freeMem(freq,sizeof(freq^)); freq := nil;
end;


{ reconstruct tree }
procedure reconst;
var i,j,k: Smallint;
    f: Word;
    p,e: ^word;
    pi, ei: ^Smallint;
begin

	{ correct leaf node into of first half,
	   and set these freqency to (freq+1)/2  }
  j := 0;
  for i := 0 to T-1 do
  begin
    if (son^[i] >= T) then
    begin
      freq^[j] := (freq^[i] + 1) div 2;
      son^[j] := son^[i];
      Inc(j);
    end;
  end;
	{ build tree.  Link sons first }

  i:=0;
  for J := N_CHAR to T-1 do
  begin
    k := i + 1;
    f :=freq^[i] + freq^[k];
    freq^[j] := f;
    k:=j - 1;
    while f < freq^[k] do
      Dec(k);
    inc(k);
    p:= @freq^[j];
    e:= @freq^[k];
    while longint(p) > longint(e) do
    begin
      p^ := Word(Pointer(LongInt(p) - sizeof(Word))^); { C is *p := p[-1] }
      Dec(p);
    end;
    freq^[k] := f;
    pi:= @son^[j];
    ei:= @son^[k];
    while longint(pi) > longint(ei) do
    begin
      pi^ := Smallint(Pointer(LongInt(pi) - sizeof(Smallint))^); { C is *pi := pi[-1] }
      Dec(pi);
    end;
    son^[k] := i;
    Inc(i,2);
  end;
	{ link parents }
  for i:= 0 to T-1 do
  begin
    k:= son^[i];
    if (k >= T) then
      prnt^[k] := i
    else
    begin
      prnt^[k] := i;
      prnt^[k + 1] := i;
    end;
  end;
end;

{$IFDEF PASCALUPDATE}
{ update given code's frequency, and update tree }

procedure update (c: Word);
var i,j,l: Smallint;
    k: Word; { was Smallint, caused overflow }
begin
  if (freq^[R] = MAX_FREQ) then
    reconst;
  c := prnt^[c + T];

  while true do
  begin
     Inc(freq^[c]);
     k := freq^[c];

	{ swap nodes when the frequency order is no longer correct }
     l:=c+1;
     if (k > freq^[l]) then
     begin
      Inc(l);
      while k > freq^[l] do
        Inc(l);
      dec(l);
      freq^[c]:=freq^[l];
      freq^[l]:=k;
      i := son^[c];
      prnt^[i] := l;
      if (i < T) then
        prnt^[Succ(i)] := l;

      j := son^[l];
      son^[l] := i;

      prnt^[j] := c;
      if (j < T) then
        prnt^[Succ(j)] := c;
      son^[c] := j;

      c := l;
    end;
    c:= prnt^[c];
    if c=0 then
      break; { all done  -- at root }
  end;
end;

{$ENDIF} { PASCALINSERT }

{$IFNDEF PASCALUPDATE}
{ Register usage:
  ES:DI is freq^, CX is DI backup
  DS:SI is prnt^
  ES:DI is son^ in that section, CX is backup
  AX is C (code)
  BX is K (frequency)
  DX is work
}
{$IFDEF WINDOWS}
procedure update (c: Word);
var index, i,j,l: Smallint;
    k: Word; { was Smallint, caused overflow }
    var localson: sonptr;
begin
  if (freq^[R] = MAX_FREQ) then
    reconst;
  c := prnt^[c + T];

localson:=son;
asm
  push  ds          { we use it }
  les   di,[freq]   { start of freq table }
  mov   cx,di       { and backup }
  lds   si,[prnt]   { and prnt table }
  mov   ax,c        { get current code }

@Loop:
  mov   di,cx       { restore  to start of freq }
  mov   bx,ax       { save code...   Inc(freq^[c]); k := freq^[c] }
  shl   ax,1        { offset into freq }
  add   di,ax       { and here we are... }
  mov   ax,bx       { restore code }
  mov   dx,di       { save freq^[c] position }
  mov   bx,es:[di]  { get frequency }
  inc   bx
  mov   es:[di],bx  { update it }
  cmp   bx,es:[di+2]{ is K > freq[L (=c+1)]? }
  jbe   @FrequencyOk{ jbe not jle as this is an unsigned (word) comparison }
  { lots of adjusting to do here... }

@FindPos:
  inc   di          { next please... }
  inc   di
  cmp   bx,es:[di]  { while K > freq[L] }
  jg    @FindPos
  dec   di
  dec   di          { di now points to the last node whose freq < K }

  push  cx          { preserve freq start position }
  mov   cx,es:[di]  { L's freq }
  mov   es:[di],bx  { save K in its place }
  mov   bx,di       { phew! a spare work register! }
  shr   bx,1        { yes shr -- becomes the L offset }
  push  bx          { Save it for C (AX) later }
  mov   di,dx       { original freq^[c] position }
  mov   es:[di],cx  { this frequency goes here... }

  push  es          { save freq -- we have a use for es now.. }
  les   di,[localson]    { as our son pointer... }
  mov   cx,di       { for computation backup }
  mov   dx,ax
  shl   dx,1        { offset into son }
  add   di,dx
  mov   dx,es:[di]  { i=son^[c] }
  push  si          { save prnt^ start }
  push  dx          { and our i offset }
  shl   dx,1        { offset into prnt }
  add   si,dx
  mov   ds:[si],bx  { prnt^[i] := L }
  pop   dx
  cmp   dx,T        { i < T? }
  jge   @NotNext
  inc   si
  inc   si
  mov   ds:[si],bx  { prnt^[Succ(i)] := L too}

@NotNext:
  pop   si          { back to start of prnt }

  mov   di,cx       { get back saved son start }
  shl   bx,1        { offset into son }
  add   di,bx
  mov   bx,es:[di]  { j=son^[L] }
  mov   es:[di],dx  { son^[L] := I }
  mov   di,cx       { restore start of son }

  push  si          { save prnt^ start }
  push  bx          { and our J offset }
  shl   bx,1        { offset into prnt }
  add   si,bx
  mov   ds:[si],ax  { prnt^[J] := C }
  pop   bx
  cmp   bx,T        { J < T? }
  jge   @NotNext1
  inc   si
  inc   si
  mov   ds:[si],ax  { prnt^[Succ(J)] := C too}

@NotNext1:
  pop   si          { hang on to that start of prnt }
  mov   cx,ax       { c }
  shl   cx,1
  add   di,cx       { son^[c] := J }
  mov   es:[di],bx

  pop   es          { freq again }
  pop   ax          { and C=L }
  pop   cx          { our freq start preserver }

@FrequencyOk:

{  DS:SI is prnt^, CX is also SI backup -- is SI valid right here? }

  shl   ax,1           { get offset into prnt^ }
  mov   dx,si          {save si }
  add   si,ax          {SISISISISI!}
  mov   ax,ds:[si]     { and next parent }
  mov   si,dx          { restore si }
  or    ax,ax          { zero yet? }
  jnz   @Loop

  pop   ds          { clean up }
end;
end;
{$ENDIF}  { WINDOWS }
{$ENDIF}  { IFNDEF PASCALUPDATE }

{$ENDIF} {LZH1_COMMON}

{ Compression-only routines }

{$IFDEF LZH1_COMPRESS}

var match_position, match_length: Word;

procedure InitTree;
var i:Smallint;
begin
  for i:=N+1 to N+N do rson^[i]:=TNIL;
  for i:=0 to N-1 do dad^[i]:=TNIL;
end;

{ Insert to node }
procedure InsertNode(r: Smallint);
{$IFNDEF PASCALINSERT }
var  c,j: Word;
     p: Smallint;
     key : Pchar;
     MP,ML:Word;
label Alldone;  { for quick assembler exit }
begin
  rson^[r] := TNIL;
  lson^[r] := TNIL;
  key := @text_buf^[r];
  MP:=Match_position; { needed? maybe... }

  { Register usage:
     AX: cmp
     BX: P  (restored on exit to P proper )
     CX: I
     DX: Work
     ES:DI rson, lson, dad, same, key
     DS:SI (temp): text_buf
   }

asm
  { Calculate P }
  les   di,[key]
  inc   di          { key[1] }
  mov   al,es:[di]
  inc   di          { key [2] }
  mov   ah,es:[di]
  xor   al,ah       { Smallint(key[1]) xor Smallint(key[2]); }
  mov   bl,al
  shr   al,4
  xor   bl,al       { i xor (i shr 4) }
  and   bx,$0f      {(i and $0f) shl 8}
  shl   bx,8        { top bits irrelevant! }
  sub   di,2        { back to key^ }
  mov   al,es:[di]
  xor   ah,ah
  add   bx,ax
  add   bx,(N+1)     { P:= N + 1 + Smallint(key^) + i above }

  { Main initialisation and loop... }
  xor   ax,ax
  mov   ML,ax
  inc   ax
  mov   J,ax
  mov   cx,ax

 { Main Loop: }

@Loop:
  or    ax,ax          { cmp <zero? }
  jl    @Left
  les   di,[rson]      { yes, we're working with lson }
  jmp   @DoCompare
@Left:
  les   di,[lson]      { we're working with rson }

@DoCompare:
  mov   dx,bx          { save P for possible exit }
  shl   bx,1
  add   di,bx          { xson^[p] }
  mov   bx,es:[di]
  cmp   bx,TNIL        { =TNIL? }
  jnz   @MoveOn
  mov   ax,R
  mov   es:[di],ax     { xson^[p] := r }
  les   di,[same]
  add   di,ax
  mov   es:[di],cl      { same^[r] := char(i) }
  les   di,[dad]
  shl   ax,1           { offset into dad }
  add   di,ax
  mov   es:[di],dx     { dad^[r] := p }
  jmp   Alldone

@MoveOn:               { P := xson^[P]  already...}
  les   di,[same]
  add   di,bx          { get P offset into same^ }
  mov   dl,es:[di]     { and assign as CHAR to }
  xor   dh,dh
  mov   J,dx           { j }

  { end of first block... }

  cmp   cx,dx          { i>j? (unsigned) }
  jb @TryThreshold     { no, j > i, skip it }
  jz @SameJI
  mov   cx,dx          { i:=j }
  les   di,[key]       { Key [i] }
  add   di,cx
  mov   al,es:[di]    { al = key[i] }
  les   di,[text_buf]
  add   di,dx         { +i }
  add   di,bx         { +p }
  sub   al,es:[di]    { cmp = al - text_buf^[i+p] }
  rcr   ax,1          { Carry bit makes ax either negative (key<textbuf), or >=0 }
  jmp   @TryThreshold

@SameJI:
  push  ds             { gonna use it }
  les   di,[text_buf]
  add   di,bx          { start at text_buf^[p+i] }
  add   di,cx          { the +i }
  lds   si,[key]       { Key[i] }
  add   si,cx          { [i] }

@SmallLoop:
  cmp   cx,F
  jae   @ExitSmallLoop{ above or equal (unsgnd): if we take THIS exit, ax irrelevant }
  cmpsb               { ds:si=key - es:di=textbuf }
  jnz   @ExitAndSetCmp
  inc   cx            { di, si already incremented }
  jmp   @SmallLoop

@ExitAndSetCmp:       { last compare was >0 or <0 }
  rcr   ax,1          { Carry bit makes ax either negative (key<textbuf), or >=0 }

@ExitSmallLoop:
  pop   ds             { all else (cx=i, ax=cmp, bx=P) are just fine }


{ end of block 2 }

@TryThreshold:

  cmp   cx,THRESHOLD
  jbe   @Loop

  cmp   cx,ML
  jb    @Loop
  jz    @EQMatchLength

  mov   dx,R
  sub   dx,bx    { r-p }
  and   dx,(N-1)
  dec   dx       { (r-p) and (N-1)  - 1 }
  mov   MP,dx
  mov   ML,cx    { match_length := i }


  cmp   cx,F
  jae   @ExitLoop      { i >= F? }
  jmp   @Loop

@EQMatchLength:
  mov   dx,R
  sub   dx,bx    { r-p }
  and   dx,(N-1)
  dec   dx       { (r-p) and (N-1)  - 1 }
  mov   C,dx     { C: = the above }
  cmp   dx,MP

  jae   @Loop
  mov   MP,dx    { if c<match_position then match_position := c }
  jmp   @Loop

@ExitLoop:
  mov   P,bx  { and nothing else matters as R stays in variable... }
end;

  same^[r] := same^[p];
  j:=dad^[p];
  dad^[r] := j;
  lson^[r] := lson^[p];
  rson^[r] := rson^[p];
  dad^[lson^[p]] := r;
  dad^[rson^[p]] := r;
  if (rson^[j] = p) then
  	rson^[j] := r
  else
  	lson^[j] := r;
  dad^[p]:= TNIL;  { remove p }

Alldone:  { for quick assembler exit }
  Match_position:=MP;
  Match_Length := ML;
{$ENDIF }

{$IFDEF PASCALINSERT }
var cmp, p: Smallint;
     c,i,j: Word;
     key : Pchar;
begin
  rson^[r] := TNIL;
  lson^[r] := TNIL;
  key := @text_buf^[r];
  i := Smallint(key[1]) xor Smallint(key[2]);
  i := i xor (i shr 4);
  p := N + 1 + Smallint(key^) + ((i and $0f) shl 8);
  cmp := 1;
  i := 1; j := 1;
  match_length := 0;


  while True do
  begin
    if (cmp >= 0) then
    begin
    	if (rson^[p] <> TNIL) then
        begin
          p := rson^[p];
	  j := Ord(same^[p]);
	end else begin
	  rson^[p] := r;
	  dad^[r] := p;
	  same^[r] := Char(i);
	  exit;
        end;
    end else begin
    	if (lson^[p] <> TNIL) then
        begin
	  p := lson^[p];
	  j := Ord(same^[p]);
	end else begin
	  lson^[p] := r;
	  dad^[r] := p;
	  same^[r] := Char(i);
	  exit;
        end;
     end;

     if (i > j) then
     begin
       i := j;
       cmp := Ord(key[i]) - Ord(text_buf^[p + i]);
     end else
       if (i = j) then
       begin
         while i < F do
         begin
     	   cmp := Ord(key[i]) - Ord(text_buf^[p + i]);
  	   if (cmp <> 0) then
              break;
           Inc(i);
         end; { while }
       end;

       if (i > THRESHOLD) then
       begin
       	 if (i > match_length) then
         begin
	    match_position := ((r - p) and (N - 1)) - 1;
            match_length := i;
	    if (match_length  >= F) then
               break
	 end else if (i = match_length) then
         begin
            c:= ((r - p) and (N - 1)) - 1;
  	    if (c < match_position) then
  	    	match_position := c;
  	 end
      end { if i > THRESHOLD }
  end; { while true }

  same^[r] := same^[p];
  j:=dad^[p];
  dad^[r] := j;
  lson^[r] := lson^[p];
  rson^[r] := rson^[p];
  dad^[lson^[p]] := r;
  dad^[rson^[p]] := r;
  if (rson^[j] = p) then
    rson^[j] := r
  else
    lson^[j] := r;
  dad^[p]:= TNIL;
{$ENDIF}
end;

{$IFNDEF PASCALLINK}
{$IFDEF WINDOWS}
procedure link (n, p, q: Smallint);
begin
  if (p >= TNIL) then begin
    same^[q] := #1;
    exit;
  end;

{ Registers: CX = counter, DS:SI=text_buf+P+N, ES:DI=text_buf+Q+N
  BX = F, AX=Q }
asm
  push  ds                { will be required... }
  mov   cx,F
  mov   bx,cx             { default same^[Q] value, or used to calc it }
  mov   ax,N              { used twice... }
  sub   cx,ax             { now have counter for WHILE loop }
  or    cx,cx             { counter zero? }
  jz    @EndLoop
  les   di,[text_buf]     { start of the chars }
  add   di,ax             { standard N offset }
  mov   si,di             { will become the P offset }
  mov   ax,Q              { will be using Q later... }
  add   di,ax
  add   si,P
  push  es
  pop   ds                { all pointing at right places... }

@Loop:
  cmpsb             { ds:si - es:di }
  jnz   @EndLoop    { exit with cx non-zero to give right offset }
  loop  @Loop

@EndLoop:           { one way or other, cx gives us F-0 or F-cx }
  sub   bx,cx       { this gives us the offset in text_buf to use... }
  pop   ds          { so we can set same^[] }
  les   di,[same]
  add   di,ax       { Q }
  mov   es:[di],bl  { V2.0 possible undetected bug -- fixed -- was BX into a char!! }
 end;
end;
{$ENDIF} {WINDOWS}
{$IFDEF WIN32}
  { Note: benchmarks show that this 32-bit assembler routine is
    not faster (and is probably slower) than the Pascal code
    produced by Delphi 2.0. Hence we are sticking with Pascal
    for the 2.0 implementation of LZH. This routine is the
    only exception, and it is NOT being used in TCompress 2.0.
  }
procedure link (n, p, q: Smallint); assembler
begin
 { ESI = textbuf+P+N, EDI= text_buf+Q+N, DX=F, AX=Q, CX=counter }
asm
  push  ESI            { our pointers -- must be preserved (EBX too if used) }
  push  EDI
  xor   EAX,EAX        { XOR early for possible add in @Exit }
  mov   CX,P           { can use CX here as XORed below }
  cmp   CX,TNIL
  jl    @Under
  mov   AX,Q
  mov   DL,1           { same^[Q] = #1 }
  jmp   @Exit

@Under:
  xor   ECX,ECX
  mov   CX,F
  mov   DX,CX        { default same^[Q] value, or used to calc correct one }
  mov   AX,N
  sub   CX,AX        { counter for while loop }
  or    CX,CX
  jz    @EndLoop
  mov   EDI,[text_buf]
  add   EDI,EAX
  mov   ESI,EDI
  mov   AX,P
  add   ESI,EAX
  mov   AX,Q           { use just below, but also later... }
  add   EDI,EAX
  repe  cmpsb          { compare bytes until end or not equal }

{ at this point, either CX is zero (no match or no loop), or non-zero at right place }

@EndLoop:           { one way or other, cx gives us F-0 or F-cx }
  sub   DX,CX     { this gives us the offset in text_buf to use... }

@Exit:
  mov   EDI,[same]
  add   EDI,EAX     { Q}
  mov   EDI.Byte,DL     { save^[Q] = DL }
  pop   EDI
  pop   ESI
 end;
end;
{$ENDIF} {WIN32}
{$ELSE}
procedure link (n, p, q: Smallint);
var s1,s2,s3: Pchar;
begin
  if (p >= TNIL) then begin
    same^[q] := #1;
    exit;
  end;

  s1 := text_buf^ + p + n;
  s2 := text_buf^ + q + n;
  s3 := text_buf^ + p + F;
  while (s1 < s3) do
  begin
     if s1^<>s2^ then
     begin
        same^[q] := Char(s1-text_buf^-p);
        exit;
     end;
     inc(s1);
     inc(s2);
  end;
  same^[q] := char(F);
end;
{$ENDIF} { IFNDEF PASCALLINK}

procedure linknode (p, q, r: smallint);
var cmp: Smallint;
begin
  cmp :=Ord(same^[q]) - Ord(same^[r]);
  if (cmp = 0) then
    link(Ord(same^[q]), p, r)
  else if (cmp < 0) then
    same^[r] := same^[q];
end;

procedure DeleteNode(p: Smallint);
var q: Smallint;
begin
  if (dad^[p] = TNIL) then
    exit;{ nothing linked }

  if (rson^[p] = TNIL) then
  begin
     q:=lson^[p];
     if (q <> TNIL) then
  	linknode(dad^[p], p, q);
  end else if (lson^[p] = TNIL) then
  begin
     q := rson^[p];
     linknode(dad^[p], p, q);
  end else
  begin
     q := lson^[p];
     if (rson^[q] <> TNIL) then
     begin
        q:=rson^[q];
        while rson^[q]<>TNIL do
      	  q := rson^[q];
  	if (lson^[q] <> TNIL) then
  	   linknode(dad^[q], q, lson^[q]);
	link(1, q, lson^[p]);
	rson^[dad^[q]] := lson^[q];
	dad^[lson^[q]] := dad^[q];
	lson^[q] := lson^[p];
  	dad^[lson^[p]] := q;
     end;
     link(1, dad^[p], q);
     link(1, q, rson^[p]);
     rson^[q] := rson^[p];
     dad^[rson^[p]] := q;
   end;
   dad^[q] := dad^[p];
   if (rson^[dad^[p]] = p) then
     rson^[dad^[p]] := q
   else
     lson^[dad^[p]] := q;
   dad^[p] := TNIL;
end;

{ output C bits }
procedure Putcode (L: Smallint; c: Word);
var len: smallint;
    b: Word;
begin

  len := Ord(putlen);
  b := putbuf;
  b := b or (c shr len);
  Inc(len,L);
  if (len>= 8) then
  begin
    putchar(char(b shr 8));
    Dec(len,8);
    if (len >= 8) then
    begin
      putchar(char(b));
      Dec(len,8);
{$R-}  { Always }
      b := c shl (L-len);
{$R-}  { R+ if doing range check during debug }
    end else
      b:= b shl 8;
  end;
  putbuf := b;
  putlen := Char(len);
end;

procedure EncodeChar (c:word);
var	i: Longint;  { careful -- should be UNSIGNED long! }
  	k,j : Smallint;
begin
  i := 0;
  j := 0;
  k := prnt^[c+T];

	{ trace links from leaf node to root }
  while true do
  begin
    i := i shr 1;
	{ if node index is odd, trace larger of sons }
    if (k and 1) >0 then
        Inc(i,$80000000);
    Inc(j);
    k:=prnt^[k];
    if k=R then break;
  end;

  if (j > 16) then
  begin
    Putcode(16, Word(i shr 16));
    Putcode(j - 16, word(i));
  end else
    Putcode(j, Word(i shr 16));

  update(c);
end;

procedure EncodePosition(c:Word);
var i: Word;
begin
  { output upper 6 bits from table }
   i := c shr 6;
   Putcode(Smallint(p_len[i]), Word(p_code[i]) shl 8);
  { output lower 6 bits }
   Putcode(6, Word(c and $3f) shl 10);
end;

procedure EncodeEnd;
begin
  if (putlen>#0) then
     putchar(Char(putbuf shr 8));
end;
procedure CompressLZH;
var i, len, r, s, last_match_length: smallint;
    c: char;
begin
 rson:=nil; lson:=nil; dad:=nil;
 same:=nil; text_buf:=nil;
 son:=nil; freq:=nil; prnt :=nil;

 try
  getMem(rson,sizeof(rson^));
  getMem(lson,sizeof(lson^));
  getMem(dad,sizeof(dad^));
  getMem(same,sizeof(same^));
  getMem(text_buf,sizeof(text_buf^));
  getMem(son,sizeof(son^));
  getMem(prnt,sizeof(prnt^));
  getMem(freq,sizeof(freq^));

  StartHuff;
  InitTree;
  s := 0;
  r := N - F;

  for i:= s to r-1 do text_buf^[i] := ' ';

  for len:=0 to F-1 do
  begin
     c:=getchar;
     if InputEOF then break;
  	text_buf^[r + len] := c;
  end;
  if len=0 then exit; { added PJH }
  if not InputEOF then len:=F; { so we have correct value for finishing up... }

  for i := 1 to F do InsertNode(r - i);
     InsertNode(r);

  while true do
  begin
     if (SmallInt(match_length) > len) then
	match_length := len;
     if (match_length <= THRESHOLD) then
     begin
     	match_length := 1;
     	EncodeChar(Word(text_buf^[r]));
     end else
     begin
	EncodeChar(255 - THRESHOLD + match_length);
	EncodePosition(match_position);
     end;
     last_match_length := match_length;
     i:=0;
     while i < last_match_length do
     begin
        c:= getChar;
        if InputEof then
            break;
	DeleteNode(s);
	text_buf^[s] := c;
	if (s < F - 1) then
  	   text_buf^[s + N] := c;
	s := (s + 1) and (N - 1);
	r := (r + 1) and (N - 1);
	InsertNode(r);
        Inc(i);
    end;

    while i < last_match_length do
    begin
       Inc(i);
    	DeleteNode(s);
	s := (s + 1) and (N - 1);
	r := (r + 1) and (N - 1);
        Dec(len);
	if len > 0 then
        begin
           InsertNode(r);
        end;
     end; { don't need the extra Inc(i) as not used }
     if len=0 then break;
  end;
  EncodeEnd;
 finally
  EndHuff;
 end;
end;
{$ENDIF} { LZH1_COMPRESS }


{ Routines used only for LZH1 expansion }

{$IFDEF LZH1_EXPAND}
{ get one bit
 returning in Bit 0 }
function GetBit: Smallint;
var dx, c: Word;
begin
{$R-} { Rangechecks off in case on...}
  dx := getbuf;

  if (getlen <= #8) then
  begin
    c := Word(getchar);
    if InputEOF then c := 0;
    dx := dx or (c shl (8-Ord(getlen)));
    Inc(getlen,8);
  end;
  getbuf := dx shl 1;
  Dec(getlen);
  if (dx and $8000) <>0 then
     result:=1
  else
     result := 0;
end;

{get one byte
 returning in Bits 7..0 }
function GetByte: Word;
var dx, c: Word;
begin
  dx := getbuf;

  if (getlen <= #8) then
  begin
    c := Word(getchar);
    if InputEOF then c := 0;
    dx := dx or (c shl (8-Ord(getlen)));
    Inc(getlen,8);
  end;
  getbuf := dx shl 8;
  Dec(getlen,8);
  result := (dx shr 8) and $ff;
end;


{ get N bits
{ returning in Bit(n-1)...Bit 0 }
const mask: Array[0..16] of Word =
   ( $0000,
     $0001, $0003, $0007, $000f,
     $001f, $003f, $007f, $00ff,
     $01ff, $03ff, $07ff, $0fff,
     $1fff, $3fff, $0fff, $ffff );

     shift: Array[0..16] of Smallint =
     	( 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 );

function GetNBits(n: Word): Smallint;
var dx, c: Word;
begin
  dx := getbuf;
  if (getlen <= #8) then
  begin
    c := Word(getchar);
    if InputEOF then c := 0;
    dx := dx or (c shl (8-Ord(getlen)));
    Inc(getlen,8);
  end;
  getbuf := dx shl n;
  Dec(getlen,n);
  result := (dx shr shift[n]) and mask[n];
end;

function DecodeChar: Smallint;
begin
{$IFDEF PASCALDECODECHAR}
  result := son^[R];
 { trace from root to leaf
   got bit is 0 to small(son[]), 1 to large (son[]+1) son node }
  while (result < T) do
  begin
    if Getbit >0 then Inc(result);
    result := son^[result];
    end;
    Dec(result,T);
    update(result);
{$ENDIF}

{$IFNDEF PASCALDECODECHAR}
{ Register Usage:
  AX: holds result
  DL: Getlen holder
  BX: getBuf holder
  CX: Preserves DI
  ES:DI -- pointer to start of son^[] array
}
asm
  les      di,[son]    { start of son^[] array }
  mov      cx,di       { save for within loop }
  mov      bx, getbuf  { preserved word from last call }
  mov      dl,getlen   { bits available in that word }
  mov      ax,R        { root position }
  shl      ax,1        { x 2 to get correct offset }
  add      di,ax       { here we go... }
  mov      ax,es:[di]  { ax is now son^[R], I hope... }

@Loop:
  cmp      ax,T        { over the limit? }
  jge      @DoneLoop   { yep }

  cmp      dl,8        { how many bits left? }
  jg      @Nextbit     { Still more than 8 }
  push     ax
  push     cx
  push     bx
  push     dx
  push     es
  call     Getchar     { new char in ax -- will be 0 if InputEOF }
  pop      es
  pop      dx
  pop      bx
  mov      cl,8
  sub      cl,dl       { 8-getlen }
  xor      ah,ah
  shl      ax,cl       { shift ax left }
  or       bx,ax       { update bx (getbuf) }
  add      dl,8        { and our bit count }
  pop      cx
  pop      ax

@Nextbit:
  dec      dl          { keep counter accurate }
  test     bx,$8000    { Top bit on? }
  jz       @LeftSon    { nope...}
  inc      ax          { was on -- move to right hand son }
@LeftSon:
  shl      bx,1        { move bits along then }
  mov      di,cx       { saved start position }
  shl      ax,1        { x 2 to get correct offset }
  add      di,ax       { here we go... }
  mov      ax,es:[di]  { ax is now son^[ax] }
  jmp      @Loop

@DoneLoop:
  sub      ax,T        { yep.... deduct to get the actual char }
  mov      getbuf,bx   { save for next time... }
  mov      getlen,dl
  mov      Result,ax   { and for return }
  push     ax          { update the huff table }
  call     update
end;
{$ENDIF}
end;

function DecodePosition: Smallint;
var i,j,c: Word;
begin
  { decode upper 6 bits from table }
  i := GetByte;
  c := Word(d_code[i]) shl 6;
  j := Word(d_len[i]);

  { get lower 6 bits }
  Dec(j,2);
  result := c or  ((( i shl j) or GetNBits(j)) and $3f);
end;

procedure ExpandLZH(textsize: Longint);
var	i, j, k, r, c: Smallint;
	count: longint;
begin
 if (textsize = 0) then exit;

 rson:=nil; lson:=nil; dad:=nil;
 same:=nil; text_buf:=nil;
 son:=nil; freq:=nil; prnt :=nil;

 try
  getMem(rson,sizeof(rson^));
  getMem(lson,sizeof(lson^));
  getMem(dad,sizeof(dad^));
  getMem(same,sizeof(same^));
  getMem(text_buf,sizeof(text_buf^));
  getMem(son,sizeof(son^));
  getMem(prnt,sizeof(prnt^));
  getMem(freq,sizeof(freq^));

  StartHuff;
  r := N - F;
  for i:= 0 to r-1 do
    text_buf^[i] := ' ';
  count:=0;
  while count < textsize do
  begin
     c := DecodeChar;
     if (c < 256) then
     begin
	Putchar(Char(c));
	text_buf^[r] := Char(c);
        Inc(r);
	r := r and (N - 1);
	Inc(count);
     end else
     begin
	i := (r - DecodePosition - 1) and (N - 1);
	j := c - 255 + THRESHOLD;
	for k := 0 to j-1 do
        begin
	   c := Ord(text_buf^[(i + k) and (N - 1)]);
 	   Putchar(Char(c));
	   text_buf^[r] := Char(c);
           inc(r);
           r := r and (N - 1);
           Inc(count);
        end; {for }
      end;   {else }
    end;      {while }
 finally
   EndHuff;
 end;
end;
{$ENDIF} { LZH1_EXPAND }

{
October 6, 1990   INTEGRATED SOLUTIONS 4.3 BSD                  4

LHARC(L)            UNIX Programmer's Manual             LHARC(L)

DISTRIBUTION
     This software is Copyrighted 09/19/1989 by Yooichi Tagawa,
     Tokyo, Japan.  The author allows free distribution under the
     following conditions:

     1.      This copyright notice is maintained.

     2.      As for contents of distribution,

             a.      All files in the standard distribution (e.g.
                     source code, documents, guide to program-
                     mers) must exist in any re-distribution.  If
                     they were modified, modifications must be
                     clearly indicated.

             b.      If any kind of valuable capabilities, pro-
                     grams, or information were added within a
                     re-distribution, the distributor doing the
                     modifications must make every effort to
                     include them in the next distribution.  In
                     such case, decent documents describing the
                     new programs or additional capabilities must
                     be prepared.

             c.      Do not distribute LHarc in binary only.
                     (This also pertains to added programs or
                     information).

     3.      You must make an effort to distribute the newest
             version (but it's not your mandatory duty).

     4.      This program comes with no warranty, expressed or
             implied.  Use of this program is at the entire risk
             of the user.

     5.      The current author has no duty to correct mistakes,
             if any, in this program.

     6.      Parts of this program, or the whole program may be
             freely incorporated into other programs.  In such
             case, the resulting program is not allowed to be
             called LHarc.

     7.      For use of this program for commercial purposes, in
             addition to the above conditions, the following con-
             ditions also apply.

             a.      Commercial use which consists solely or
                     principally of this program as a product for
                     sale, is prohibited.

             b.      If the purchaser or licensee of a commercial
                     product including LHarc in its distribution
                     is judged likely to make improper use of
                     this program, or refuses to comply with
                     these restrictions, distribution of LHarc
                     with the commercial product to that user is
                     forbidden.

             c.      If LHarc is used as a means of installing
                     commercial software, the vendor of the com-
                     mercial software is not allowed to require
                     the user to do that installation.  In this
                     case, the commercial vendor must do the
                     installation.  All damages caused by use of
                     LHarc in such an installation are the
                     responsibility of the commercial vendor.

             d.      If LHarc is included as part of a commercial
                     product, the vendor of that product must
                     support this program.

ACKNOWLEDGEMENTS
     Thanks to Haruhiko Okumura for his development of the LZARI
     method, on which LZHUF was based.  Thanks to Haruhiko Miki
     for LArc, and thanks to Yasuaki Yoshizaki for his derivative
     work from LArc, thus making up the LZHUF method and MS-DOS
     LHarc. Thanks to the many people who assisted the develop-
     ment of LHarc, Kazuaki Ishibashi for forwarding mail
     (between commercial BBS's), all beta testers who reported
     various results, and the person who forwarded this informa-
     tion, Koichiro Mori.

     This manual was translated by Youki Kadobayashi
     <youki@mercury.ics.osaka-u.ac.jp>.  Although I made every
     possible effort I could, there may be mistakes or queer
     expressions.  Feel free to correct my mistakes, I will
     appreciate your feedback.
}

const CHAR_BIT = 8; { special for LZH5 in TCompress }

{ Now for the LZH5 handling routines V3.5 }

{$IFDEF LZH5_EXPAND}  { we want expand enabled }
  {$DEFINE LZH5_COMMON}  { then we need common data/routines }
{$ENDIF}
{$IFDEF LZH5_COMPRESS}  { we want compress enabled }
  {$DEFINE LZH5_COMMON}
{$ENDIF}

{ the two debugging defines below should be left disabled. }
{--$DEFINE COMPARE_ON_EXPAND}
{--$DEFINE COMPARE_ON_COMPRESS}

{$IFDEF LZH5_COMMON}

const MaxMatch = 256;
      DictionaryBits = 13;
      DictionarySize = 1 shl DictionaryBits;
      Hash1 = DictionaryBits - 9;
      Hash2 = DictionarySize * 2;
      CharMax = 255; { (1<<sizeof(char))*8 -1 }
      WordMax = 65535;
      WordBits = 16;
      SmallintMax = 32767;
      SmallintMin = SmallintMax - WordMax; { i.e. -32768 }
      max_hash_val = 3*DictionarySize + (DictionarySize div 512 + 1)*CharMax;
      BufferSize = 16*1024; { used encode only }
      Threshold5 = 3;
      NC = CharMax + MaxMatch + 2 - Threshold5;
      CBIT = 9;
      PBIT = 4; { smallest int s.t. (1<<PBIT) > NP }
      TBIT = 5; { as above but > NT }
      NP =  13+1; { Max_DictionaryBits + 1 }
      NT = 16+3; { sizeof(Smallint)*8 + 3 }
      NPT = $80;
      NIL5 = 0;

type textbuffer5  = Array[0..(DictionarySize*2+MaxMatch)] of char;
     levelbuffer = Array[0..(DictionarySize+CharMax+1)] of char;
     childcountbuffer = Array[0..(DictionarySize+CharMax+1)] of char;
     node = Smallint;
     positionbuffer = Array[0..(DictionarySize+CharMax+1)] of node;
     positionptr = ^positionbuffer;
     parentbuffer = Array[0..(DictionarySize*2)] of node;
     prevbuffer = Array[0..(DictionarySize*2)] of node;
     nextbuffer = Array[0..(max_hash_val + 1)] of node;
     buffer = Array[0..BufferSize] of char; { used for encode only }
     bufferptr = ^buffer;
     childBuffer = Array[0..2*NC-1] of Word;
     chartablebuffer = Array[0..4096] of Word;
     charcodebuffer = Array[0..NC] of Word;
     positiontablebuffer = Array[0..256] of Word;
     charlenbuffer = Array[0..NC] of char;
     positioncodebuffer =Array[0..NPT] of Word;

var text : ^textbuffer5;
    level : ^levelbuffer;
    childcount : ^childcountbuffer;
    position: ^positionbuffer;
    parent : ^parentbuffer;
    prev: ^prevbuffer;
    buf: ^buffer; { encode only? }
    subBitbuf, Bitcount : char; { mini ints really... }
    Blocksize,bitbuf: Word;
    left : ^childbuffer; { all these arrays oversize by 1 }
    right: ^childbuffer;
    charLen: ^charlenbuffer;
    position_len: Array[0..NPT] of Char;
    char_freq: ^childbuffer;
    char_table: ^chartablebuffer;
    char_code: ^charcodebuffer;
    position_freq: Array[0..2*NP-1] of Word;
    position_table: ^positiontablebuffer;
    position_code: ^positioncodebuffer;
    t_freq: Array[0..2*NT-1] of Word;
    pos, MatchPosition, avail: node;

const next : ^nextbuffer = nil;

{$IFDEF COMPARE_ON_EXPAND}
  {$DEFINE COMPARE_BYTES}
{$ENDIF}
{$IFDEF COMPARE_ON_COMPRESS} { crude 'or' }
  {$DEFINE COMPARE_BYTES}
{$ENDIF}

{$IFDEF COMPARE_BYTES}
const compareFile: TFilestream = nil;
procedure chkchar(c: smallint);
var inch: char;
begin
  if compareFile.read(inch,1)<>1 then
   raise Exception.Create('EOF on compare file!');
  if inch<> char(c) then
   raise Exception.Create('bad compare byte: '+InttoHex(ord(inch),2)+' vs. '+InttoHex(c,2)+' at '+IntToStr(BytesOut));
end;
{$ENDIF}


procedure StartHuff5(Compress: Boolean); { init bit get/put vars }
begin { also allocate and init internal structures }
  getMem(text,sizeof(text^)); { larger than needed for decode, but consistent }

  getMem(left,sizeof(left^));
  getMem(right,sizeof(right^));
  getMem(position_table,sizeof(position_table^));
  getMem(charlen,sizeof(charlen^));

  if Compress then
  begin
    getMem(level,sizeof(level^));
    getMem(childcount,sizeof(childcount^));
    getMem(position,sizeof(position^));
    getMem(parent,sizeof(parent^));
    getMem(prev,sizeof(prev^));
    getMem(next,sizeof(next^));
    getMem(buf,sizeof(buf^));
    getMem(char_freq,sizeof(char_freq^));
    getMem(char_code,sizeof(char_code^));
    getMem(position_code,sizeof(position_code^));
    Bitcount := Char(Char_Bit);
  end else
  begin
    getMem(char_table,sizeof(char_table^));
    Bitcount := #0;
  end;

  subBitbuf := #0;
  bitbuf := 0;
  blocksize := 0;
end;

procedure EndHuff5;
begin
  if text<>nil then freeMem(text,sizeof(text^)); text := nil;
  if level<>nil then freeMem(level,sizeof(level^)); level := nil;
  if childcount<>nil then freeMem(childcount,sizeof(childcount^)); childcount := nil;
  if position<>nil then freeMem(position,sizeof(position^)); position := nil;
  if parent<>nil then freeMem(parent,sizeof(parent^)); parent := nil;
  if prev<>nil then freeMem(prev,sizeof(prev^)); prev := nil;
  if next<>nil then freeMem(next,sizeof(next^)); next := nil;
  if buf<>nil then freeMem(buf,sizeof(buf^)); buf := nil;

  if char_table<>nil then freeMem(char_table,sizeof(char_table^)); char_table := nil;
  if char_code<>nil then freeMem(char_code,sizeof(char_code^)); char_code := nil;
  if char_freq<>nil then freeMem(char_freq,sizeof(char_freq^)); char_freq := nil;
  if left<>nil then freeMem(left,sizeof(left^)); left := nil;
  if right<>nil then freeMem(right,sizeof(right^)); right := nil;
  if position_table<>nil then freeMem(position_table,sizeof(position_table^)); position_table := nil;
  if position_code<>nil then freeMem(position_code,sizeof(position_code^)); position_code := nil;
  if charlen<>nil then freeMem(charlen,sizeof(charlen^)); charlen := nil;

end;

{$ENDIF} { LZH5_COMMON}

{$IFDEF LZH5_EXPAND}
procedure buildtable(nchar: Smallint; bitlen: Array of char;
                            tablebits: Smallint; var table: Array of Word);
var count: array[0..16] of Word; { rightsized }
    weight: array[0..16] of Word;  { 0 unused... }
    start: array[0..16] of Word;
    total, i: Word;
    j,k,l,m,n,avail: Longint;
    p : ^Word;
begin
   { initialise }
   avail := nchar;
   for i := 1 to 16 do
   begin
     count[i] := 0;
     weight[i] := 1 shl (16-i);
   end;

   for i := 0 to pred(nchar) do
      inc(count[ord(bitlen[i])]); { count[bitlen[i]] := couint[bitlen[i]]+1; }

   total := 0;
   for i := 1 to 16 do
   begin
     start[i] := total;
     inc(total,weight[i]*count[i]);
   end;
   if (total and $ffff) <> 0 then
     raise ELZHBadDecodeTable.Create('Bad decode table in archive!');

   m := 16 - tablebits;
   for i := 1 to tablebits do
   begin
     start[i] := start[i] shr m;
     weight[i] := weight[i] shr m;
   end;

   j := start[tablebits+1] shr m;
   k := 1 shl tablebits;
   if j <>0 then
     for i := j to pred(k) do
       table[i] := 0;

  for j := 0 to pred(nchar) do
  begin
     k := Longint(bitlen[j]);
     if k=0 then continue;
     l := start[k] + weight[k];

     if k <= tablebits then
     begin
       for i := start[k] to pred(l) do
         table[i] := j;
     end else begin
       i := start[k];
       p := @table[i shr m];
       i := i shl tablebits;
        for n := 0 to pred(k - tablebits) do
        begin
         if p^ = 0 then
         begin
           right^[avail] := 0;
           left^[avail] :=0;
           p^ := avail;
           inc(avail);
         end; { if }
         if (i and $8000) > 0 then
            p := @right^[p^]
         else
            p := @left^[p^];
         i := i shl 1;
       end; { while }
       p^ := j;
     end; { else }
     start[k] := l;
  end; { for }
end;

procedure fillbuf(n: char);
begin
  while (n > bitcount) do
  begin
    Dec(n,ord(bitcount));
    bitbuf := (bitbuf shl ord(bitcount)) + (ord(subbitbuf) shr (Char_Bit - ord(bitcount)));
    if InputEOF then
       subBitBuf := #0
    else
       subBitBuf := GetChar;
    bitcount := Char(Char_bit);
  end;
  Dec(bitcount,ord(n));
  bitbuf := (bitbuf shl ord(n)) +(ord(subBitBuf) shr (Char_bit - ord(n)));
  subbitbuf :=   Char(ord(subbitbuf) shl ord(n));
end;

function getbits(n: char): Word;
begin
   result := bitbuf shr (2*Char_Bit - ord(n));
   fillbuf(n)
end;

procedure read_position_len(nn, nbit, i_special: Smallint);
var i,c,n: Smallint;
    mask: Word;
begin
   n := getbits(char(nbit));
   if n=0 then
   begin
     c := getbits(char(nbit));
     for i := 0 to pred(nn) do
      position_len[i] := #0;
     for i := 0 to pred(256) do
      position_table^[i] := c;
   end else
   begin
     i := 0;
     while i < n do
     begin
       c := bitbuf shr (16-3);
       if c=7 then
       begin
         mask := 1 shl (16-4);
         while (mask and bitbuf) > 0 do
         begin
           mask := mask shr 1;
           inc(c);
         end;
       end; {if }
       if c < 7 then
         fillbuf(#3)
       else
         fillbuf(char(c-3));
       position_len[i] := char(c); inc(i);
       if i = i_special then
       begin
         for c := pred(getbits(#2)) downto 0 do
         begin
           position_len[i] := #0; inc(i);
         end;

       end; { if }
     end; { while }
     while (i < nn) do
     begin
       position_len[i] := #0; inc(i);
     end;
     buildtable(nn,position_len,8,position_table^);
   end; { else }
end;

procedure read_charLen;
var i,c,n: Smallint;
    mask: Word;
begin
   n := getbits(char(CBIT));
   if n=0  then
   begin
     c := getbits(char(CBIT));
     for i:= 0 to pred(NC) do
       charLen^[i] :=#0;
     for i := 0 to pred(4096) do
       char_table^[i] := c;
   end else begin
     i := 0;
     while i < n do
     begin
       c := position_table^[bitbuf shr (16-8)];
       if c >= NT then
       begin
          mask := 1 shl (16-9);
          repeat
            if (bitbuf and mask) > 0 then
               c := right^[c]
            else
               c := left^[c];
            mask := mask shr 1;
          until c < NT;
       end;
       fillbuf(position_len[c]);
       if c <= 2 then
       begin
         if c=0 then
            c := 1
         else if c = 1 then
            c := getbits(#4)+3
         else
            c := getbits(char(CBIT))+20;
         for c := 0 to pred(c) do
         begin
            charLen^[i] :=#0; inc(i);
         end;
       end else
       begin
          charLen^[i] := Char(c-2); inc(i);
       end; { else }
     end; { while }

     while (i < NC) do
     begin
       charLen^[i] := #0; inc(i);
     end;
     buildtable(NC,charLen^,12,char_table^);
   end; { else }
end;


function DecodeChar5: Word;
var mask: Word;
begin
   if blocksize =0 then
   begin
     blocksize := getbits(#16);
     read_position_len(NT,TBIT,3);
     read_charLen;
     read_position_len(NP,PBIT,-1);
   end;
   dec(blocksize);
   result := char_table^[bitbuf shr 4];
   if result < NC then
      fillbuf(charLen^[result])
   else begin
      fillbuf(#12);
      mask := 1 shl (16-1);
      repeat
        if (bitbuf and mask) > 0 then
           result := right^[result]
        else
           result := left^[result];
        mask := mask shr 1;
      until result < NC;
      fillbuf(Char(ord(charLen^[result]) - 12));
   end; { else }
end;

function DecodePosition5: Word;
var mask: Word;
begin
  result := position_table^[bitbuf shr (16-8)];
  if result < NP then
    fillbuf(position_len[result])
  else begin
    fillbuf(#8);
    mask := 1 shl (16-1);
    repeat
      if (bitbuf and mask) > 0 then
        result := right^[result]
      else
        result := left^[result];
      mask := mask shr 1;
    until result < NP;
    fillbuf(char(ord(position_len[result])-8));
  end; { else }
  if result <> 0 then
    result := (1 shl pred(result)) + getbits(char(pred(result)));
end;

procedure ExpandLZH5(destsize: longint);
var i, j, k, c, offset: Smallint;
    count: Longint;
    loc: Word;
begin
if destsize=0 then exit; { quietly ignore }

try
{$IFDEF COMPARE_ON_EXPAND}
     CompareFile := TFileStream.create('c:\wg2ntr.exe',fmOpenRead);
{$ENDIF}


 StartHuff5(False); { initialise important things }
 fillbuf(Char(2*CHAR_BIT)); { prime input buffer }

 for i:= 0 to pred(DictionarySize) do
  text^[i] := ' ';

 offset := 256-3;
 count := 0;
 loc := 0;
 while count < DestSize do
 begin
   if count=850000 then { 880047 }
     count := 850000;
   c := DecodeChar5;
   if (c <= CharMax) then
   begin
     text^[loc] := Char(c); inc(loc);
     PutChar(Char(c));
{$IFDEF COMPARE_ON_EXPAND}
     chkchar(c);
{$ENDIF}
     if (loc=DictionarySize) then
       loc := 0;
     inc(count);
   end else
   begin
      j := c - offset;
      i := (loc - DecodePosition5 -1 ) and pred(DictionarySize);
      inc(count,j);
      for k:=0 to pred(j) do
      begin
        text^[loc] := text^[(i+k) and pred(DictionarySize)];
        PutChar(text^[loc]);
{$IFDEF COMPARE_ON_EXPAND}
     chkchar(text^[loc]);
{$ENDIF}
        inc(loc);

        if (loc=DictionarySize) then
          loc := 0;
      end { for }
   end; { else }
 end;

finally
{$IFDEF COMPARE_ON_EXPAND}
  CompareFile.free;
{$ENDIF}

  EndHuff5; { free up stuff }
end; { try }
end; { expandLZH5 }

{$ENDIF} { LZH5_EXPAND}



{ Compress routines follow }
{$IFDEF LZH5_COMPRESS}

function buildtree(nparm: Smallint; var freqparm: Array of Word; var lenparm: Array of char;
     var codeparm: Array of Word): Smallint;
var n, heapsize: smallint;
    heap:Array[0..NC] of Smallint;
    sort: ^Word;
    len_cnt: Array[0..16] of Smallint;

    i,j,avail: Smallint; { only used within make-tree }

  procedure buildcode(n: Smallint; len: Array of Char; var code: Array of Word);
  var weight: Array[0..16] of Word;
      start: Array[0..16] of Word;
      i, j, k: Word;
  begin
     j:=0;
     k:= 1 shl (16-1);
     for i:= 1 to 16 do
     begin
          start[i] := j;
          weight[i] := k;
          inc(j,k* len_cnt[i]);
          k := k shr 1;
     end;
     for i := 0 to pred(n) do
     begin
          j := ord(len[i]);
          code[i] := start[j];
          inc(start[j],weight[j]);
     end;
  end; { buildcode }

  const depth : char = #0; { persists... }

  procedure count_len(i: Smallint); { i being the root }
  begin
    if i < n then
    begin
       if depth < #16 then
          inc(len_cnt[ord(depth)])
       else
          inc(len_cnt[16]);
    end else
    begin
       inc(depth);
       count_len(left^[i]);
       count_len(right^[i]);
       dec(depth);
    end;
  end; { count_len }

  procedure buildlen(root: Smallint);
  var i, k: Smallint;
      cum: Word;
  begin

    for i:=0 to 16 do
      len_cnt[i] := 0;
    count_len(root);
    cum :=0;
    for i:=0 to 16 do
      inc(cum,len_cnt[i] shl (16-i));

    if cum > 0 then { adjust so WILL be zero... }
    begin
      Dec(len_cnt[16],cum);
      repeat
        for i := 15 downto 1 do
          if len_cnt[i] > 0 then
          begin
            dec(len_cnt[i]);
            inc(len_cnt[succ(i)],2);
            break;
          end;
        dec(cum);
      until cum = 0;
    end;

    for i := 16 downto 1 do
    begin
      for k := len_cnt[i] downto 1 do
      begin
        lenparm[sort^] := char(i);
        inc(sort);
      end;
    end;

  end; { buildlen }

  procedure downheap(i: Smallint);
  var J,k: Smallint;
  begin
    k := heap[i];
    while True do
    begin
      j := 2*i;
      if j > heapsize then
         break;
      if (j < heapsize) and (freqparm[heap[j]] > freqparm[heap[succ(j)]]) then
         inc(j);
      if freqparm[k] <= freqparm[heap[j]] then
         break;
      heap[i] := heap[j];
      i := j;
    end;
    heap[i] := k;
  end; { downheap }

begin { buildtree }
  n := nparm;
  avail := n;
  heapsize := 0;
  heap[1] := 0;
  for i := 0 to pred(n) do
  begin
    lenparm[i] := #0;
    if freqparm[i] <> 0 then
    begin
      inc(heapsize);
      heap[heapsize] := i;
    end;
  end;

  if heapsize < 2 then
  begin
    codeparm[heap[1]] := 0;
    result := heap[1];
    exit;
  end;

  for i := heapsize div 2 downto 1 do
      downheap(i);

  sort := @codeparm;
  repeat
    i := heap[1];
    if i < n then
    begin
      sort^ := i;
      inc(sort);
    end;
    heap[1] := heap[heapsize]; dec(heapsize);
    downheap(1);
    j := heap[1];
    if j < n then
    begin
      sort^ := j;
      inc(sort);
    end;
    result := avail; inc(avail);
    freqparm[result] := freqparm[i]+ freqparm[j];
    heap[1] := result;
    downheap(1);
    left^[result] := i;
    right^[result] := j;
  until heapsize = 1;
  sort := @codeparm;
  buildlen(result);
  buildcode(nparm,lenparm,codeparm);

end; { buildtree }

procedure count_t_freq;
var i, k, n, count: Smallint;
begin
  for i := 0 to pred(NT) do
      t_freq[i] :=0;
  n := NC;
  while (n > 0) and (charLen^[pred(n)] = #0) do
     dec(n);
  i := 0;
  while i < n do
  begin
    k := Ord(charLen^[i]); inc(i);
    if k = 0 then
    begin
      count := 1;
      while (i < n) and (charLen^[i] = #0) do
      begin
        inc(i);
        inc(count);
      end;
      if count <=2 then
         inc(t_freq[0],count)
      else if count <= 18 then
         inc(t_freq[1])
      else if count = 19 then
      begin
         inc(t_freq[0]);
         inc(t_freq[1]);
      end else
         inc(t_freq[2]);
    end else { k<>0 }
      inc(t_freq[k+2]);
  end;
end; { count_t_freq }

{$R-} { ensure no spurious errors for next two routines... }
procedure putcode5(n: Char; x: Word);
begin
  while n >= bitcount do
  begin
    dec(n,ord(bitcount));
    inc(subbitbuf, x shr (WordBits - ord(bitcount)));
    x := x shl ord(bitcount);
    { skip unpackable test }
    PutChar(subbitbuf);
{$IFDEF COMPARE_ON_COMPRESS}
    chkchar(ord(subbitbuf));
{$ENDIF}
    subbitbuf := #0;
    bitcount := Char(CHAR_BIT);
  end;
  inc(subbitbuf, x shr (WordBits - ord(bitcount)));
  dec(bitcount,ord(n));
end; { putcode }

procedure putbits(n: char;x: Word);
begin
  x := x shl (WordBits-ord(n));
  putcode5(n,x);
end;


procedure write_position_len(n, nbit, i_special: Smallint);
var i,k: Smallint;
begin
  while (n > 0) and (position_len[pred(n)]=#0) do
    dec(n);
  putbits(Char(nbit),n);
  i := 0;
  while (i<n) do
  begin
    k := ord(position_len[i]); inc(i);
    if k <=6 then
       putbits(#3,k)
    else
       putbits(Char(k-3),Word(Longint(WordMax) shl 1));

    if i = i_special then
    begin
      while (i < 6) and (position_len[i] = #0) do
        inc(i);
      putbits(#2,i-3);
    end;
  end; { while }
end; { write_position_len }

procedure write_charLen;
var i, k, n, count: Smallint;
begin
  n := NC;
  while (n > 0) and (charLen^[pred(n)] = #0) do
    dec(n);
  putbits(Char(CBIT),n);
  i := 0;
  while i < n do
  begin
    k := ord(charLen^[i]); inc(i);
    if k = 0 then
    begin
      count := 1;
      while (i < n) and (charLen^[i] = #0) do
      begin
        inc(i);
        inc(count);
      end;
      if count <= 2 then
      begin
        for k := 0 to pred(count) do
          putcode5(position_len[0],position_code^[0]);
      end else if count <= 18 then
      begin
        putcode5(position_len[1],position_code^[1]);
        putbits(#4,count-3);
      end else if count = 19 then
      begin
        putcode5(position_len[0],position_code^[0]);
        putcode5(position_len[1],position_code^[1]);
        putbits(#4,15);
      end else
      begin
        putcode5(position_len[2],position_code^[2]);
        putbits(Char(CBIT),count-20);
      end;
    end else { k <> 0 }
      putcode5(position_len[k+2],position_code^[k+2]);
  end; { while i < n}
end; { write_charLen }

procedure encode_char(c: Smallint);
begin
  putcode5(charLen^[c],char_code^[c]);
end;

procedure encode_position(p: Word);
var c,q: Word;
begin
  c := 0;
  q := p;
  while q > 0 do
  begin
    q := q shr 1;
    inc(c);
  end;
  putcode5(position_len[c], position_code^[c]);
  if c > 1 then
    putbits(Char(c-1),p);
end; { encode_p }

procedure send_block;
var flags: char;
    i, k, root, pos, size: Word;
begin
  root := buildtree(NC, char_freq^,charLen^,char_code^);
  size := char_freq^[root];
  putbits(#16,size);
  if root >= NC then
  begin
    count_t_freq;
    root := buildtree(NT,t_freq,position_len,position_code^);
    if root >= NT then
       write_position_len(NT,TBIT,3)
    else begin
       putbits(Char(TBIT),0);
       putbits(Char(TBIT),root);
    end;
    write_charLen;
  end else { root < NC }
  begin
    putbits(Char(TBIT),0);
    putbits(Char(TBIT),0);
    putbits(Char(CBIT),0);
    putbits(Char(CBIT),root);
  end; { if }

  root := buildtree(NP,position_freq,position_len,position_code^);
  if root >= NP then
    write_position_len(NP,PBIT,-1)
  else
  begin
    putbits(Char(PBIT),0);
    putbits(Char(PBIT),root);
  end;

  pos := 0; flags := #0;
  for i := 0 to pred(size) do
  begin
    if (i mod CHAR_BIT)= 0 then
    begin
      flags := buf^[pos]; inc(pos);
    end else
      flags := Char(ord(flags) shl 1);

    if (ord(flags) and (1 shl pred(CHAR_BIT))) <> 0 then
    begin
      encode_char(Ord(buf^[pos]) + (1 shl CHAR_BIT));
      inc(pos);
      k := ord(buf^[pos]) shl CHAR_BIT; inc(pos);
      inc(k,ord(buf^[pos])); inc(pos);
      encode_position(k);
    end else
    begin
      encode_char(ord(buf^[pos])); inc(pos);
    end;
{ if unpackable then return }
  end; { for }

  for i := 0 to pred(NC) do char_freq^[i] := 0;
  for i := 0 to pred(NP) do position_freq[i] := 0;
end; { send_block }

var output_pos, output_mask, cpos: Word;

procedure OutputCodes(c, p: Word);
begin
  output_mask := output_mask shr 1;
  if output_mask = 0 then
  begin
    output_mask :=  1 shl pred(CHAR_BIT);
    if output_pos >= (BufferSize-3*CHAR_BIT) then
    begin
      send_block;
      output_pos := 0;
    end;
    cpos := output_pos;  inc(output_pos);
    buf^[cpos] := #0;
  end;

  buf^[output_pos] := Char(c); inc(output_pos);
  inc(char_freq^[c]);

  if c >= (1 shl CHAR_BIT) then
  begin
    buf^[cpos] := Char(ord(buf^[cpos]) or output_mask);
    buf^[output_pos] := Char(p shr CHAR_BIT); inc(output_pos);
    buf^[output_pos] := Char(p); inc(output_pos);
    c := 0;
    while (p > 0) do
    begin
      p := p shr 1;
      inc(c);
    end;
    inc(position_freq[c]);
  end;
end;

var remainder, MatchLength: Smallint;
    count: Longint; { ideally, unsigned, but Cardinal won't do it, so 2GB limit stands }

procedure initSlide;
var i: node;
begin
  for i := DictionarySize to DictionarySize + CharMax do
  begin
    level^[i] := #1;
    position^[i] := NIL5;
  end;
  for i := DictionarySize to pred(DictionarySize * 2) do
     parent^[i] := NIL5;
  avail := 1;
  for i := 1 to pred(DictionarySize-1) do
    next^[i] := i+1;
  next^[DictionarySize-1] := NIL5;
  for i := DictionarySize*2 to max_hash_val do
    next^[i] := NIL5;
end;

function child(q: node; c: char): node;
begin
  result := next^[q + (ord(c) shl hash1) + hash2];
  parent^[NIL5] := q;
  while parent^[result] <> q do
    result := next^[result];
end;

procedure makechild(q: node; c: char; r: node);
var h,t: node;
begin
   h := q + (ord(c) shl hash1) + hash2;
   t := next^[h];
   next^[h] := r;
   next^[r] := t;
   prev^[t] := r;
   prev^[r] := h;
   parent^[r] := q;
   inc(childcount^[q]);
end; { makechild }

procedure split(old: node);
var new, t: node;
begin
  new := avail;
  avail := next^[new];
  childcount^[new] := #0;

  t := prev^[old];
  prev^[new] := t;
  next^[t] := new;

  t := next^[old];
  next^[new] := t;
  prev^[t] := new;

  parent^[new] := parent^[old];
  level^[new] := char(MatchLength);
  position^[new] := pos;

  makechild(new,text^[MatchPosition+MatchLength],old);
  makechild(new,text^[pos+MatchLength],pos);
end;

procedure insert_node;
var q,r,j,t: node;
    c: char;
    ta,tb: Smallint;
begin
  q := 0; { silence compiler warning }
  if MatchLength >= 4 then
  begin
    dec(MatchLength);
    r := succ(MatchPosition) or DictionarySize;
    while True do
    begin
      q := parent^[r];
      if q<>NIL5 then break;
      r := next^[r];
    end;
    while ord(level^[q]) >= MatchLength do
    begin
      r := q;
      q := parent^[q];
    end;
    t := q;
    while position^[t] < 0 do
    begin
      position^[t] := pos;
      t := parent^[t];
    end;
    if t < DictionarySize then
       position^[t] := pos or SmallintMin;
  end else { MatchLength <= 4}
  begin
    q := ord(text^[pos])+DictionarySize;
    c := text^[pos+1];
    r := child(q,c);
    if r=NIL5 then
    begin
      makechild(q,c,pos);
      MatchLength := 1;
      exit;
    end;
    MatchLength := 2;
  end; { else }

  while True do
  begin
    if r >= DictionarySize then
    begin
      j := maxmatch;
      MatchPosition := r;
    end else
    begin
      j := ord(level^[r]);
      MatchPosition := position^[r] and SmallintMax;
    end;
    if MatchPosition >=pos then
       dec(MatchPosition,DictionarySize);
    ta := pos+MatchLength;
    tb := MatchPosition+MatchLength;
    while MatchLength < j do
    begin
      if text^[ta]<>text^[tb] then
      begin
        split(r);
        exit;
      end;
      inc(MatchLength);
      inc(ta);
      inc(tb);
    end; { while }
    if MatchLength=maxmatch then
      break;
    position^[r] := pos;
    q := r;
    r := child(q,text^[ta]);
    if r=NIL5 then
    begin
      makechild(q,text^[ta],pos);
      exit;
    end;
    inc(MatchLength);
  end; { while true }

  prev^[pos] := prev^[r];
  next^[prev^[r]] := pos;

  next^[pos] := next^[r];
  prev^[next^[r]] := pos;

  parent^[pos] := q;
  parent^[r] := NIL5;
  next^[r] := pos;
end; { insert_node}

procedure delete_node;
var q,r,s,t,u: node;
begin
  u := 0; { silence compiler warning }
  if parent^[pos] = NIL5 then
     exit;

  next^[prev^[pos]] := next^[pos];
  prev^[next^[pos]] := prev^[pos];

  r := parent^[pos];
  parent^[pos] := NIL5;
  dec(childcount^[r]);
  if (r >= DictionarySize) or (childcount^[r] > #1) then
     exit;
  t := position^[r] and SmallintMax;
  if t >= pos then
    dec(t,DictionarySize);

  s := t;
  q := parent^[r];
  while True do
  begin
    u := position^[q];
    if u >=0 then break;
    u := u and SmallintMax;
    if u >= pos then
       dec(u,DictionarySize);
    if u > s then
      s := u;
    position^[q] := s or DictionarySize;
    q := parent^[q];
  end; { while }

  if q < DictionarySize then
  begin
    if u >= pos then
      dec(u,DictionarySize);
    if u > s then
      s := u;
    position^[q] := (s or DictionarySize) or SmallintMin;
  end;

  s := child(r,text^[t+ord(level^[r])]);
  t := prev^[s];
  u := next^[s];

  next^[t] := u;
  prev^[u] := t;

  t := prev^[r];
  next^[t] := s;
  prev^[s] := t;

  t := next^[r];
  prev^[t] := s;
  next^[s] := t;

  parent^[s] := parent^[r];
  parent^[r] := NIL5;
  next^[r] := avail;
  avail := r;
end; { delete_node }

procedure get_next_match;
var i: Smallint;
begin
  dec(remainder);
  inc(pos);
  if pos = DictionarySize*2 then
  begin
    move(text^[DictionarySize],text^[0],DictionarySize+MaxMatch);
    for i:= DictionarySize+maxmatch to pred(DictionarySize*2+maxmatch) do
    begin     { fill buffer with incoming data }
      text^[i] := GetChar;
      if InputEOF then
         break;
    end;
    if inputEOF then
       inc(remainder,i-(DictionarySize+maxmatch)) { just what we got }
    else
       inc(remainder,DictionarySize);
    pos := DictionarySize;
  end;
  delete_node;
  insert_node;
end;

procedure CompressLZH5;
var  lastMatchLength : Smallint;
     lastMatchPosition: node;
     c: char;
     i: node;
begin
{$IFDEF COMPARE_ON_COMPRESS}
     CompareFile := TFileStream.create('c:\tst.lzh',fmOpenRead);
     CompareFile.seek(32,soFromBeginning);
{$ENDIF}

 try
  StartHuff5(True); { this is Compress so LOTS more buffers required... }
  count := 0;
  initSlide;

  for i := 0 to pred(NC) do
    char_freq^[i] := 0;
  for i := 0 to pred(NP) do
    position_freq[i] := 0;
  buf^[0] := #0;
  output_pos :=0;
  output_mask := 0;
  cpos := 0;

  pos := DictionarySize + maxmatch;
  remainder := 0;
  for i:= pos to pos+pred(DictionarySize) do { fill buffer with incoming data OR spaces... }
  begin
    c := GetChar;
    if InputEOF then
       text^[i] := ' '
    else
    begin
       text^[i] := c;
       inc(remainder);
    end;
  end;
  if remainder=0 then exit; { nothing to compress... }
  MatchPosition := 0;
  MatchLength := 0;
  insert_node;
  while remainder > 0 do { and (not unpackable) }
  begin
    lastMatchLength := MatchLength;
    lastMatchPosition := MatchPosition;

    get_next_match;
    if MatchLength > remainder then
      MatchLength := remainder;
    if (MatchLength > lastMatchLength) or (lastMatchLength < Threshold5) then
    begin
      OutputCodes(Word(text^[pos-1]),0);
      inc(count);
    end else
    begin
      OutputCodes(lastMatchLength+CharMax + 1 - Threshold5,
                                  (pos - lastMatchPosition - 2) and pred(DictionarySize));
      for lastMatchLength := 1 to pred(lastMatchLength) do
      begin
         get_next_match;
         inc(count);
      end;
      if MatchLength > remainder then
         MatchLength := remainder;
    end;     { else }
  end; { while }

{ if not unpackable then }
  send_block;
  putbits(Char(CHAR_BIT -1),0);
 finally
  EndHuff5; { free up stuff }
{$IFDEF COMPARE_ON_COMPRESS}
     CompareFile.free;
{$ENDIF}

 end;
end;

{$ENDIF} { LZH5_COMPRESS}

function TMCompress.ProcessStreams(outstream, instream: TStream; sourcesize,destsize: longint;
         CompressionMethod: TCompressionMethod; var checksum: Longint; mode: TCProcessMode;
         encrypted: Boolean): longint; { Encryption added V3.5 }
var Keyval: Longint;
begin
  GlobalOnShowProgress := FOnShowProgress;  { save in global so Getchar can see }
  source := inStream;
  dest := outStream;
  GetMem(inBuffer, ChunkSize); { allocate the buffers }
  inBMax := inBuffer; { initially, until first read... }
  inBptr := inBuffer;
  GetMem(outBuffer, ChunkSize);
  outBMax := outBuffer+ChunkSize;
  outBptr := outBuffer; { not same as inBptr! }
  InputEOF := False;
  AtStart := True;
  lastch := #0;
  inRepeat := False;
  dupCount := 0;
  ReadSize := Sourcesize;
  lChunk := Chunksize;
  inChecksum:= 0;
  outChecksum := 0;
  BytesIn := 0; { for ShowProgress event }

  if mode=cmExpand then    { V3.5 }
     MaxNumberOfBytesToWrite := MaxLongint { permit any size expand! }
  else   { on Compression, never write more than Sourcesize-overhead bytes }
     MaxNumberOfBytesToWrite := SourceSize-FMustCompressByAtLeast;

  EncryptingOut := (mode = cmCompress) and (Key<>0); { V3.5 }
  EncryptingIn := (mode = cmExpand) and (Key<>0) and
                    Encrypted;  { ignore Key unless flag is ALSO set in archive }
  KeyVal:=Key;
  Keyval := GetCryptValue(Key);{modified by IVP}
  Move(Keyval,EncryptCodes,sizeof(Encryptcodes));
{  EncryptCounter :=0;}
  EncryptCounter :=3; {*** modified by ivp }

  try
   if mode = cmCompress then
   begin
    BytesOut:=0;
    case CompressionMethod of
       coRLE:
{$IFDEF RLE_COMPRESS}
        CompressRLE;
{$ELSE}
        raise EUnrecognizedCompressionMethod.Create(
                    'RLE compression disabled in this build');
{$ENDIF}

       coLZH:
{$IFDEF LZH1_COMPRESS}
        CompressLZH;
{$ELSE}
        raise EUnrecognizedCompressionMethod.Create(
                    'LZH1 compression disabled in this build');
{$ENDIF}

      coLZH5:
{$IFDEF LZH5_COMPRESS}
        CompressLZH5;
{$ELSE}
        raise EUnrecognizedCompressionMethod.Create(
                    'LZH5 compression disabled in this build');
{$ENDIF}

    end;
    checksum := InChecksum;
   end else { expand }
   begin
    BytesOut:=1;
    case CompressionMethod of
       coRLE:
{$IFDEF RLE_EXPAND}
           ExpandRLE;
{$ELSE}
               raise EUnrecognizedCompressionMethod.Create(
                     'RLE expansion disabled in this build');
{$ENDIF}
       coLZH:
{$IFDEF LZH1_EXPAND}
           ExpandLZH(destsize);
{$ELSE}
               raise EUnrecognizedCompressionMethod.Create(
                     'LZH1 expansion disabled in this build');
{$ENDIF}

       coLZH5:
{$IFDEF LZH5_EXPAND}
           ExpandLZH5(destsize);
{$ELSE}
               raise EUnrecognizedCompressionMethod.Create(
                     'LZH5 expansion disabled in this build');
{$ENDIF}

    end;
    checksum := OutChecksum;
   end;
   if outBptr<>OutBuffer then { must flush }
     dest.writebuffer(OutBuffer^,outBptr-OutBuffer);
  finally
   FreeMem(inBuffer, ChunkSize); { free the buffer }
   FreeMem(outBuffer, ChunkSize);
  end;
  Result := BytesOut;
end;


(*procedure Register;
begin
  RegisterComponents('Compress', [TMCompress]);
end;*)

end.
