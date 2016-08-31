unit USplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, {jpeg,} StdCtrls, jpeg;

type

  TfmSplash = class(TForm)
    im: TImage;
    ImLabel: TImage;
    lbVersion: TLabel;
    Shape1: TShape;
    lbMainPlus: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    procedure SetCenter;
  public
  end;

var
  fmSplash: TfmSplash;

implementation

uses UDm, SeoDbConsts, SeoPicture;

{$R *.DFM}

procedure TfmSplash.FormCreate(Sender: TObject);
var
  dwHandle: THandle;
  dwLen: DWord;
  lpData: Pointer;
  v1,v2,v3,v4: Word;
  tmps: string;
  VerValue: PVSFixedFileInfo;
  Buffer: String;
  ms: TMemoryStream;
begin
  Im.Picture.Assign(nil);
  im.Picture:=TSeoPicture.Create;

  dwLen:=GetFileVersionInfoSize(Pchar(Application.ExeName),dwHandle);
  if dwlen<>0 then begin
   GetMem(lpData, dwLen);
   try
    if GetFileVersionInfo(Pchar(Application.ExeName),dwHandle,dwLen,lpData) then begin
      VerQueryValue(lpData, '\', Pointer(VerValue), dwLen);
      V1 := VerValue.dwFileVersionMS shr 16;
      V2 := VerValue.dwFileVersionMS and $FFFF;
      V3 := VerValue.dwFileVersionLS shr 16;
      V4 := VerValue.dwFileVersionLS and $FFFF;
      tmps:=inttostr(V1)+'.'+inttostr(V2)+'.'+inttostr(V3)+'.'+inttostr(V4);
      lbVersion.Caption:=Format(fmtAboutVer,[tmps]);
    end;
   finally
     FreeMem(lpData, dwLen);
   end;
   end;

  ms:=TMemoryStream.Create;
  try
    if LocalDb.ReadParam(SDb_ParamSplash,Buffer) then begin
      ms.Write(Pointer(Buffer)^,Length(Buffer));
      ms.Position:=0;
      TSeoPicture(im.Picture).LoadFromStream(ms);
      ClientWidth:=TSeoPicture(im.Picture).Width;
      ClientHeight:=TSeoPicture(im.Picture).Height;
      SetCenter;
    end;  
  finally
    ms.Free;
  end;

   Buffer:='';
   if LocalDb.ReadParam(SDb_ParamCompany,Buffer) then
     lbMainPlus.Caption:=Format(SCompany,[Buffer]);
end;

procedure TfmSplash.SetCenter;
begin
  Left:=Screen.Width div 2 - Width div 2;
  Top:=Screen.Height div 2 - Height div 2;
end;

end.
