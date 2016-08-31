unit UEditNotary;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, db;

type
  TfmEditNotary = class(TForm)
    lbFio: TLabel;
    edFio: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    cbInString: TCheckBox;
    lbChamber: TLabel;
    edChamber: TEdit;
    bibChamber: TBitBtn;
    lbAddress: TLabel;
    edAddress: TEdit;
    lbPhone: TLabel;
    edPhone: TEdit;
    lbEmail: TLabel;
    edEmail: TEdit;
    lbCounty: TLabel;
    edCounty: TEdit;
    lbLetter: TLabel;
    edLetter: TEdit;
    chbIsHelper: TCheckBox;
    meWorkGraph: TMemo;
    lbWorkGraph: TLabel;
    bibClear: TBitBtn;
    procedure edFioChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbAdminClick(Sender: TObject);
    procedure meHintChange(Sender: TObject);
    procedure edFioKeyPress(Sender: TObject; var Key: Char);
    procedure bibChamberClick(Sender: TObject);
    procedure edChamberChange(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    ChamberId: Integer;
    ChangeFlag: Boolean;
    procedure OkClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
  end;

var
  fmEditNotary: TfmEditNotary;

implementation

uses Udm, UMain, URBChamber;

{$R *.DFM}

procedure TfmEditNotary.OkClick(Sender: TObject);
begin
  if Trim(edFio.Text)='' then begin
    ShowError(Handle,'Поле <'+lbFio.Caption+'>'+#13+'не может быть пустым.');
    edFio.SetFocus;
    exit;
  end;
  if Trim(edChamber.Text)='' then begin
    ShowError(Handle,'Поле <'+lbChamber.Caption+'>'+#13+'не может быть пустым.');
    bibChamber.SetFocus;
    exit;
  end;
  if Trim(edAddress.Text)='' then begin
    ShowError(Handle,'Поле <'+lbAddress.Caption+'>'+#13+'не может быть пустым.');
    edAddress.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditNotary.edFioChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditNotary.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditNotary.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TfmEditNotary.chbAdminClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditNotary.meHintChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditNotary.edFioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditNotary.bibChamberClick(Sender: TObject);
var
  fm: TfmChamber;
begin
  fm:=TfmChamber.Create(nil);
  try
   fm.BorderIcons:=[biSystemMenu, biMaximize];
   fm.bibOk.Visible:=true;
   fm.bibOk.OnClick:=fm.MR;
   fm.pnSQL.Visible:=false;
   fm.Grid.OnDblClick:=fm.MR;
   fm.LoadFilter;
   fm.ActiveQuery;
   if trim(edChamber.Text)<>'' then
     fm.Mainqr.locate('name',trim(edChamber.Text),[loPartialKey,loCaseInsensitive]);
   if fm.ShowModal=mrOk then begin
     ChangeFlag:=true;
     edChamber.Text:=Trim(fm.Mainqr.fieldByName('name').AsString);
     Self.ChamberId:=fm.Mainqr.fieldByName('chamber_id').AsInteger;
   end;
  finally
   fm.Free;
  end;
end;

procedure TfmEditNotary.edChamberChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditNotary.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

end.
