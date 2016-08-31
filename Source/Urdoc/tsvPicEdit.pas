unit tsvPicEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FileCtrl,ShellApi, ExtDlgs, clipbrd, Buttons;

type
  TPictEditor = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Load: TButton;
    Save: TButton;
    Copy: TButton;
    Paste: TButton;
    Clear: TButton;
    Panel4: TPanel;
    ScrollBox1: TScrollBox;
    Image: TImage;
    bibCancel: TBitBtn;
    bibOk: TBitBtn;
    OD: TOpenPictureDialog;
    SD: TSavePictureDialog;
    procedure btEditClick(Sender: TObject);
    procedure LoadClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure PasteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TPictDialog=class(TComponent)
    private
      FPictEdit: TPictEditor;
      FImage: TImage;
    public
      constructor Create(AOwner: TComponent);override;
      destructor Destroy;override;
      function Execute: Boolean;
      property Image: TImage read FImage;
  end;


implementation

//uses Jpeg;

const
     PictureFilter='Bitmap (*.bmp)|*.bmp|Icon (*.ico)|*.ico'+
                   '|Wmf (*.wmf)|*.wmf|Jpeg (*.jpg)|*.jpg';
var
  AData: THandle;
  APalette: HPALETTE;

{$R *.DFM}

{ TPictDialog }

constructor TPictDialog.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 FPictEdit:=TPictEditor.Create(Self);
 FImage:=FPictEdit.Image;
end;

destructor TPictDialog.Destroy;
begin
 FPictEdit.Free;
 inherited;
end;

function TPictDialog.Execute: Boolean;
begin
  result:=false;
  if Image.Picture.SupportsClipboardFormat(CF_PICTURE) then begin
    FPictEdit.Paste.Enabled:=true;
  end;
  if FPictEdit.ShowModal=mrOk then begin
   Result:=true;
  end;
end;

procedure TPictEditor.btEditClick(Sender: TObject);
var
  AppDir: String;
  tmpDir:string;
  filen: string;
  WinDir: string;
  PBrushFile: string;
  buf: array[0..259] of char;
begin
  GetWindowsDirectory(buf,259);
  WinDir:=StrPas(buf);
  PBrushFile:=WinDir+'\Pbrush.exe';
  AppDir:=ExtractFileDir(Application.Exename);
  tmpDir:=AppDir+'\Temp';
  filen:=tmpdir+'\temp.bmp';
  if not DirectoryExists(tmpDir) then begin
     if CreateDir(tmpDir) then begin
       Image.Picture.Bitmap.SaveToFile(filen);
       if FileExists(filen) then
       ShellExecute(Application.MainForm.Handle,nil,PChar(PBrushFile),
         PChar('temp.bmp'),PChar(tmpDir),SW_SHOWMAXIMIZED);
     end;
  end else begin
       Image.Picture.Bitmap.SaveToFile(filen);
       if FileExists(filen) then
       ShellExecute(Application.MainForm.Handle,nil,PChar(PBrushFile),
         PChar('temp.bmp'),PChar(tmpDir),SW_SHOWMAXIMIZED);
  end;
end;

procedure TPictEditor.LoadClick(Sender: TObject);
begin
 // od.Filter:=PictureFilter;
  if not Od.Execute then exit;
  Image.Picture.LoadFromFile(od.FileName);
end;

procedure TPictEditor.SaveClick(Sender: TObject);
begin
 // sd.Filter:=PictureFilter;
  if not Sd.Execute then exit;
  Image.Picture.SaveToFile(sd.FileName);
end;

procedure TPictEditor.ClearClick(Sender: TObject);
begin
  Image.Picture.Bitmap.Assign(nil);
  Clear.Enabled:=false;
  Copy.Enabled:=false;
end;

procedure TPictEditor.FormActivate(Sender: TObject);
begin
  if Image.Picture.SupportsClipboardFormat(CF_PICTURE) then begin
    Paste.Enabled:=true;
  end else begin
    Paste.Enabled:=false;
  end;
end;

procedure TPictEditor.CopyClick(Sender: TObject);
begin
  Image.Picture.SaveToClipboardFormat(CF_PICTURE,AData,APalette);
  Paste.Enabled:=true;
  Clear.Enabled:=true;
end;

procedure TPictEditor.PasteClick(Sender: TObject);
begin
  Image.Picture.LoadFromClipBoardFormat(CF_PICTURE,AData,0);
  Copy.Enabled:=true;
  Clear.Enabled:=true;
end;

procedure TPictEditor.FormShow(Sender: TObject);
begin
  if Image.Picture.SupportsClipboardFormat(CF_PICTURE) then begin
    Paste.Enabled:=true;
  end else begin
    Paste.Enabled:=false;
  end;
end;

end.
