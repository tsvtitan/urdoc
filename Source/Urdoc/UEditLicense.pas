unit UEditLicense;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, db;

type
  TfmEditLicense = class(TForm)
    lbNum: TLabel;
    edNum: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    cbInString: TCheckBox;
    lbKem: TLabel;
    edKem: TEdit;
    lbdateLic: TLabel;
    dtpDateLic: TDateTimePicker;
    lbNot: TLabel;
    edNot: TEdit;
    bibNot: TBitBtn;
    bibClear: TBitBtn;
    procedure edNumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbAdminClick(Sender: TObject);
    procedure edNumKeyPress(Sender: TObject; var Key: Char);
    procedure bibNotClick(Sender: TObject);
    procedure dtpDateLicChange(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    NotID: Integer;
    ChangeFlag: Boolean;
    procedure OkClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
  end;

var
  fmEditLicense: TfmEditLicense;

implementation

uses Udm, UMain, URBNotarius;

{$R *.DFM}

procedure TfmEditLicense.OkClick(Sender: TObject);
begin
  if Trim(edNot.Text)='' then begin
    ShowError(Handle,'Поле <'+lbNot.Caption+'>'+#13+'не может быть пустым.');
    bibNot.SetFocus;
    exit;
  end;
  if Trim(edNum.Text)='' then begin
    ShowError(Handle,'Поле <'+lbNum.Caption+'>'+#13+'не может быть пустым.');
    edNum.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditLicense.edNumChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditLicense.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditLicense.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
  dtpDateLic.date:=Workdate;
  dtpDateLic.Time:=StrtoTime('0:00:00');
end;

procedure TfmEditLicense.chbAdminClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditLicense.edNumKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditLicense.bibNotClick(Sender: TObject);
var
  fm: TfmNotarius;
begin
  fm:=TfmNotarius.Create(nil);
  try
   fm.BorderIcons:=[biSystemMenu, biMaximize];
   fm.bibOk.Visible:=true;
   fm.bibOk.OnClick:=fm.MR;
   fm.pnSQL.Visible:=false;
   fm.Grid.OnDblClick:=fm.MR;
   fm.LoadFilter;
   fm.ActiveQuery;
   if trim(edNot.Text)<>'' then
    fm.Mainqr.locate('fio',trim(edNot.Text),[loPartialKey,loCaseInsensitive]);
   if fm.ShowModal=mrOk then begin
     ChangeFlag:=true;
     edNot.Text:=Trim(fm.Mainqr.fieldByName('fio').AsString);
     Self.NotID:=fm.Mainqr.fieldByName('not_id').AsInteger;
   end;
  finally
   fm.Free;
  end;
end;

procedure TfmEditLicense.dtpDateLicChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditLicense.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

end.
