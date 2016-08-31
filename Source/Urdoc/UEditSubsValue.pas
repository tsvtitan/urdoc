unit UEditSubsValue;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, db;

type
  TfmEditSubsValue = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    cbInString: TCheckBox;
    lbSubs: TLabel;
    edSubs: TEdit;
    bibSubs: TBitBtn;
    bibClear: TBitBtn;
    lbText: TLabel;
    meText: TMemo;
    lbPriority: TLabel;
    edPriority: TEdit;
    udPriority: TUpDown;
    procedure edNumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbAdminClick(Sender: TObject);
    procedure edNumKeyPress(Sender: TObject; var Key: Char);
    procedure bibSubsClick(Sender: TObject);
    procedure dtpDateLicChange(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure meTextChange(Sender: TObject);
    procedure meTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    SubsID: Integer;
    ChangeFlag: Boolean;
    procedure OkClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
  end;

var
  fmEditSubsValue: TfmEditSubsValue;

implementation

uses Udm, UMain, URBSubs;

{$R *.DFM}

procedure TfmEditSubsValue.OkClick(Sender: TObject);
begin
  if Trim(edSubs.Text)='' then begin
    ShowError(Handle,'Поле <'+lbSubs.Caption+'>'+#13+'не может быть пустым.');
    bibSubs.SetFocus;
    exit;
  end;
  if Trim(meText.Lines.Text)='' then begin
    ShowError(Handle,'Поле <'+lbText.Caption+'>'+#13+'не может быть пустым.');
    meText.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditSubsValue.edNumChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditSubsValue.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditSubsValue.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TfmEditSubsValue.chbAdminClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditSubsValue.edNumKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditSubsValue.bibSubsClick(Sender: TObject);
var
  fm: TfmSubs;
begin
  fm:=TfmSubs.Create(nil);
  try
   fm.BorderIcons:=[biSystemMenu, biMaximize];
   fm.bibOk.Visible:=true;
   fm.bibOk.OnClick:=fm.MR;
   fm.pnSQL.Visible:=false;
   fm.Grid.OnDblClick:=fm.MR;
   fm.LoadFilter;
   fm.ActiveQuery;
   if trim(edSubs.Text)<>'' then
    fm.Mainqr.locate('name',trim(edSubs.Text),[loPartialKey,loCaseInsensitive]);
   if fm.ShowModal=mrOk then begin
     ChangeFlag:=true;
     edSubs.Text:=Trim(fm.Mainqr.fieldByName('name').AsString);
     Self.SubsID:=fm.Mainqr.fieldByName('subs_id').AsInteger;
   end;
  finally
   fm.Free;
  end;
end;

procedure TfmEditSubsValue.dtpDateLicChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditSubsValue.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmEditSubsValue.meTextChange(Sender: TObject);
begin
  CHangeFlag:=true;
end;

procedure TfmEditSubsValue.meTextKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then Close;
end;

end.
