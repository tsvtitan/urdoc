unit UEditGraphVisit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, db;

type
  TfmEditGraphVisit = class(TForm)
    lbWho: TLabel;
    edWho: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    cbInString: TCheckBox;
    lbDateAccept: TLabel;
    dtpDateAccept: TDateTimePicker;
    bibClear: TBitBtn;
    dtpTimeAccept: TDateTimePicker;
    chbService: TCheckBox;
    meHint: TMemo;
    lbHint: TLabel;
    bibWho: TBitBtn;
    lbTime: TLabel;
    lbDateTo: TLabel;
    dtpDateTo: TDateTimePicker;
    bibPeriod: TBitBtn;
    procedure edWhoChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbAdminClick(Sender: TObject);
    procedure edWhoKeyPress(Sender: TObject; var Key: Char);
    procedure dtpDateAcceptChange(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure bibWhoClick(Sender: TObject);
    procedure bibPeriodClick(Sender: TObject);
  private
    { Private declarations }
  public
    ChangeFlag: Boolean;
    DateService: TDateTime;
    procedure OkClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
  end;

var
  fmEditGraphVisit: TfmEditGraphVisit;

implementation

uses Udm, UMain, DateUtils, URBPeople;

{$R *.DFM}

procedure TfmEditGraphVisit.OkClick(Sender: TObject);
begin
  if Trim(edWho.Text)='' then begin
    ShowError(Handle,'Поле <'+lbWho.Caption+'>'+#13+'не может быть пустым.');
    edWho.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditGraphVisit.edWhoChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditGraphVisit.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditGraphVisit.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
  dtpDateAccept.date:=Workdate;
  dtpDateAccept.date:=IncDay(dtpDateAccept.date);
  dtpTimeAccept.Time:=TimeOf(Now);
  dtpTimeAccept.Time:=EncodeTime(HourOf(dtpTimeAccept.Time),MinuteOf(dtpTimeAccept.Time),0,0);
end;

procedure TfmEditGraphVisit.chbAdminClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditGraphVisit.edWhoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditGraphVisit.dtpDateAcceptChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditGraphVisit.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmEditGraphVisit.bibWhoClick(Sender: TObject);
var
  fm: TfmRBPeople;
begin
  fm:=TfmRBPeople.Create(nil);
  try
   fm.BorderIcons:=[biSystemMenu, biMaximize];
   fm.bibOk.Visible:=true;
   fm.bibOk.OnClick:=fm.MR;
   fm.Grid.OnDblClick:=fm.MR;
   fm.LoadFilter;
   fm.ActiveQuery;
   if trim(edWho.Text)<>'' then
      fm.Mainqr.locate('nomin',trim(edWho.Text),[loPartialKey,loCaseInsensitive]);
   if fm.ShowModal=mrOk then begin
     ChangeFlag:=true;
     edWho.Text:=Trim(fm.Mainqr.fieldByName('nomin').AsString);
   end;
  finally
   fm.Free;
  end;
end;

procedure TfmEditGraphVisit.bibPeriodClick(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=tepDay;
   P.LoadAndSave:=false;
   P.DateBegin:=dtpDateAccept.DateTime;
   P.DateEnd:=dtpDateTo.DateTime;
   if ViewEnterPeriod(P) then begin
     dtpDateAccept.DateTime:=P.DateBegin;
     dtpDateAccept.Checked:=true;
     dtpDateTo.DateTime:=P.DateEnd;
     dtpDateTo.Checked:=true;
   end;
  finally
    FreeMem(P,sizeof(TInfoEnterPeriod));
  end;
end;

end.
