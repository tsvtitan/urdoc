unit UUpdateInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls;

type
  TfmUpdateInfo = class(TForm)
    pnBottom: TPanel;
    bibClose: TBitBtn;
    chbNotViewOnLoad: TCheckBox;
    pnTop: TPanel;
    reInfo: TRichEdit;
    procedure bibCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    procedure CreateHeader;
    procedure CreateBody;
    procedure CReateFooter;
  public
    procedure FillInfo;
  end;

var
  fmUpdateInfo: TfmUpdateInfo;

implementation

uses UDm, IBQuery, IBDatabase, SeoDbConsts;

{$R *.DFM}

procedure TfmUpdateInfo.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmUpdateInfo.FormResize(Sender: TObject);
begin
  reInfo.Repaint;
end;

procedure TfmUpdateInfo.FillInfo;
begin
  reInfo.Lines.Clear;
  CreateHeader;
  CreateBody;
  CReateFooter;
  reInfo.SelStart:=0;
end;

procedure TfmUpdateInfo.CreateHeader;
var
  Buffer: string;
begin
  reInfo.SelAttributes.Style:=[fsBold];
  reInfo.SelAttributes.Height:=18;
  reInfo.SelAttributes.Name:=ConstFontNameUpdateInfo;
  reInfo.Paragraph.Alignment:=taCenter;
  Buffer:='';
  Buffer:='';
  if LocalDb.ReadParam(SDb_ParamProgramm,Buffer) then
    reInfo.Lines.Add(Format(SMainCaption,[Buffer]));
end;

procedure TfmUpdateInfo.CreateBody;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select * from '+TableRenovation+
          ' order by indate desc';
    qr.SQL.Add(sqls);
    qr.Active:=true;
    qr.First;
    reInfo.Paragraph.Alignment:=taLeftJustify;
    while not qr.Eof do begin
      reInfo.Lines.Add('');
      reInfo.SelAttributes.Style:=[fsBold];
      reInfo.SelAttributes.Name:=ConstFontNameUpdateInfo;
      reInfo.SelAttributes.Height:=ConstFontHeightUpdateInfo+1;
      reInfo.Lines.Add(Format(fmtUpdateInfo,[qr.FieldByName('name').AsString,qr.FieldByName('indate').AsString]));
      reInfo.Lines.Add('');
      reInfo.SelAttributes.Style:=[];
      reInfo.SelAttributes.Name:=ConstFontNameUpdateInfo;
      reInfo.SelAttributes.Height:=ConstFontHeightUpdateInfo;
      reInfo.Lines.Add(qr.FieldByname('text').AsString);
      qr.Next;
    end;
  finally
    qr.Free;
    tr.Free;
  end;
end;

procedure TfmUpdateInfo.CReateFooter;
var
  Buffer: string;
begin
  reInfo.Lines.Add('');
  reInfo.SelAttributes.Style:=[fsBold];
  reInfo.SelAttributes.Name:=ConstFontNameUpdateInfo;
  reInfo.SelAttributes.Height:=ConstFontHeightUpdateInfo;
  reInfo.Paragraph.Alignment:=taRightJustify;
  Buffer:='';
  if LocalDb.ReadParam(SDb_ParamCompany,Buffer) then
    reInfo.Lines.Add(Format(SConstFooterUpdateInfo1,[Format(SCompanyName,[Buffer])]));
end;

end.
