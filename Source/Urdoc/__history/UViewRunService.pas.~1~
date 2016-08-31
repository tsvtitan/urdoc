unit UViewRunService;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IBServices, ExtCtrls, ImgList, StdCtrls;

type
  TfmViewRunService = class(TForm)
    tm: TTimer;
    im: TImage;
    Il: TImageList;
    lb: TLabel;
    procedure tmTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FService: TIBBackupRestoreService;
    FCurrentIndex: Integer;
    procedure SetService(Value: TIBBackupRestoreService);
  public
    property Service: TIBBackupRestoreService read FService write SetService;
  end;

var
  fmViewRunService: TfmViewRunService;

implementation

uses UDm;

{$R *.DFM}

procedure TfmViewRunService.SetService(Value: TIBBackupRestoreService);
begin
  FService:=Value;
end;

procedure TfmViewRunService.tmTimer(Sender: TObject);
begin
  if FCurrentIndex>Il.Count-1 then FCurrentIndex:=0;
  il.GetBitmap(FCurrentIndex,im.Picture.Bitmap);
  im.Invalidate;
  inc(FCurrentIndex);
  if FService<>nil then
   try
    if FService.Handle<>nil then begin
     if not FService.IsServiceRunning then begin
      tm.Enabled:=false;
      ModalResult:=mrOk;
     end;
    end else begin
      tm.Enabled:=false;
      ModalResult:=mrOk;
    end;
   except
     on E: Exception do begin
       ShowError(Handle,E.Message);
     end;
   end;  
end;

procedure TfmViewRunService.FormCreate(Sender: TObject);
begin
  FCurrentIndex:=0;
  il.GetBitmap(FCurrentIndex,im.Picture.Bitmap);
  im.Invalidate;
end;

end.
