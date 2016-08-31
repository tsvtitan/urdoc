unit UEditSumm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, UNewControls, ComCtrls;

type
  TfmEditSumm = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    Panel1: TPanel;
    grbSumm: TGroupBox;
    lbSumm: TLabel;
    btMore: TButton;
    grbCount: TGroupBox;
    rbCountOne: TRadioButton;
    rbCountIntervalNumReestr: TRadioButton;
    lbIntervalNumReestrFrom: TLabel;
    edIntervalNumReestrFrom: TEdit;
    lbIntervalNumReestrTo: TLabel;
    edIntervalNumReestrTo: TEdit;
    rbCountInterval: TRadioButton;
    edIntervalFrom: TEdit;
    lbIntervalFrom: TLabel;
    lbIntervalTo: TLabel;
    edIntervalTo: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bibOkClick(Sender: TObject);
    procedure btMoreClick(Sender: TObject);
    procedure rbCountOneClick(Sender: TObject);
    procedure edIntervalNumReestrFromKeyPress(Sender: TObject;
      var Key: Char);
  private
    { Private declarations }
  public
    SummEdit: TRxCalcEdit;
  end;

var
  fmEditSumm: TfmEditSumm;

implementation

uses UDm;

const
  HNormal=155;
  HMore=300;


{$R *.DFM}

procedure TfmEditSumm.FormCreate(Sender: TObject);
begin
  SummEdit:=TRxCalcEdit.Create(nil);
  SummEdit.Parent:=grbSumm;
  SummEdit.Top:=lbSumm.Top+lbSumm.Height div 2 - SummEdit.Height div 2;
  SummEdit.Left:=lbSumm.Left+lbSumm.Width+10;
  SummEdit.Width:=150;

  btMore.Left:=SummEdit.Left+SummEdit.Width-btMore.Width;
  btMore.Top:=SummEdit.Top+SummEdit.Height+5;

  Height:=HNormal;

  SummEdit.TabOrder:=1;
  btMore.TabOrder:=2;
  grbCount.TabOrder:=3; 
end;

procedure TfmEditSumm.FormDestroy(Sender: TObject);
begin
  SummEdit.Free;
end;

procedure TfmEditSumm.bibOkClick(Sender: TObject);
begin

  if rbCountIntervalNumReestr.Checked then begin
    if not isInteger(edIntervalNumReestrFrom.Text) then begin
      ShowError(Handle,DefNoncorrectValue);
      edIntervalNumReestrFrom.SetFocus;
      exit;
    end;
    if not isInteger(edIntervalNumReestrTo.Text) then begin
      ShowError(Handle,DefNoncorrectValue);
      edIntervalNumReestrTo.SetFocus;
      exit;
    end;
    if StrToInt(edIntervalNumReestrFrom.Text)>StrToInt(edIntervalNumReestrTo.Text) then begin
      ShowError(Handle,'Значение <с номера:> должно быть меньше либо равно значению <по:>');
      edIntervalNumReestrFrom.SetFocus;
      exit;
    end;
  end;

  if rbCountInterval.Checked then begin
    if not isInteger(edIntervalFrom.Text) then begin
      ShowError(Handle,DefNoncorrectValue);
      edIntervalFrom.SetFocus;
      exit;
    end;
    if not isInteger(edIntervalTo.Text) then begin
      ShowError(Handle,DefNoncorrectValue);
      edIntervalTo.SetFocus;
      exit;
    end;
    if StrToInt(edIntervalTo.Text)<=0 then begin
      ShowError(Handle,DefNoncorrectValue);
      edIntervalTo.SetFocus;
      exit;
    end;

  end;

  ModalResult:=mrOk;
end;

procedure TfmEditSumm.btMoreClick(Sender: TObject);
begin
  if btMore.Caption='Больше' then begin
    Height:=HMore;
    btMore.Caption:='Меньше';
    grbCount.Visible:=true;
  end else begin
    Height:=HNormal;
    btMore.Caption:='Больше';
    grbCount.Visible:=false;
  end;
end;

procedure TfmEditSumm.rbCountOneClick(Sender: TObject);
begin
  lbIntervalNumReestrFrom.Enabled:=false;
  edIntervalNumReestrFrom.Enabled:=false;
  edIntervalNumReestrFrom.Color:=clBtnFace;
  lbIntervalNumReestrTo.Enabled:=false;
  edIntervalNumReestrTo.Enabled:=false;
  edIntervalNumReestrTo.Color:=clBtnFace;

  lbIntervalFrom.Enabled:=false;
  edIntervalFrom.Enabled:=false;
  edIntervalFrom.Color:=clBtnFace;
  lbIntervalTo.Enabled:=false;
  edIntervalTo.Enabled:=false;
  edIntervalTo.Color:=clBtnFace;

  if rbCountOne.Checked then begin
  end;

  if rbCountIntervalNumReestr.Checked then begin
   lbIntervalNumReestrFrom.Enabled:=true;
   edIntervalNumReestrFrom.Enabled:=true;
   edIntervalNumReestrFrom.Color:=clWindow;
   lbIntervalNumReestrTo.Enabled:=true;
   edIntervalNumReestrTo.Enabled:=true;
   edIntervalNumReestrTo.Color:=clWindow;
  end;

  if rbCountInterval.Checked then begin
   lbIntervalFrom.Enabled:=true;
   edIntervalFrom.Enabled:=true;
   edIntervalFrom.Color:=clWindow;
   lbIntervalTo.Enabled:=true;
   edIntervalTo.Enabled:=true;
   edIntervalTo.Color:=clWindow;
  end;

end;

procedure TfmEditSumm.edIntervalNumReestrFromKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not ((Word(Key) in [byte('0')..byte('9')])or
          (Word(Key)=VK_BACK)) then begin
   Key:=#0;
   exit;
  end; 
end;

end.
