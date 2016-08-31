unit UEditPeople;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Mask;

type
  TfmEditPeople = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    lbNomin: TLabel;
    edNomin: TEdit;
    cbInString: TCheckBox;
    lbGenit: TLabel;
    edGenit: TEdit;
    lbDativ: TLabel;
    edDativ: TEdit;
    lbCreat: TLabel;
    edCreat: TEdit;
    lbVinit: TLabel;
    edVinit: TEdit;
    lbPredl: TLabel;
    edPredl: TEdit;
    bibClear: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edCity: TEdit;
    edStreet: TEdit;
    edHouse: TEdit;
    edFlat: TEdit;
    edBirthPlace: TEdit;
    edCityzen: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edSex: TEdit;
    edDocumentUDL: TEdit;
    edSeriasDUDL: TEdit;
    edNumberDUDL: TEdit;
    edCODDUDL: TEdit;
    edWhoDealDUDL: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    edDocumentUFD: TEdit;
    edWhoDealDUFD: TEdit;
    edSeriasDUFD: TEdit;
    edNumberDUFD: TEdit;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    edBirthday: TMaskEdit;
    edDateDUDL: TMaskEdit;
    edRegistartionFrom: TMaskEdit;
    edDateDeath: TMaskEdit;
    edDateDUFD: TMaskEdit;
    procedure edNominChange(Sender: TObject);
    procedure edMaskChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edTestChange(Sender: TObject);
    procedure edNominKeyPress(Sender: TObject; var Key: Char);
    procedure bibClearClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure edNominExit(Sender: TObject);
  private
    { Private declarations }
  public
    isFilter: Boolean;
    ChangeFlag: Boolean;
    procedure AddAndChangeOkClick(Sender: TObject);
    procedure AddCaseOkClick(Sender: TObject);
    procedure FilterOk(Sender: TObject);
  end;

var
  fmEditPeople: TfmEditPeople;

implementation

uses UDm, UMain, URBPeople, UUnited;

{$R *.DFM}

procedure TfmEditPeople.AddAndChangeOkClick(Sender: TObject);
begin
  if Trim(edNomin.text)='' then begin
    ShowError(Handle,'Поле <'+lbNomin.Caption+'> не заполнено.');
    edNomin.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditPeople.AddCaseOkClick(Sender: TObject);
begin

  ModalResult:=mrOk;
end;

procedure TfmEditPeople.edNominChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditPeople.edMaskChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditPeople.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TfmEditPeople.edTestChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditPeople.edNominKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditPeople.FilterOk(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

procedure TfmEditPeople.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmEditPeople.Button1Click(Sender: TObject);
begin
 //fmRBPeople.UpFill(fmEditPeople);
end;

procedure TfmEditPeople.edNominExit(Sender: TObject);
begin
  if not isFilter then begin
    if Trim(edGenit.Text)='' then
       edGenit.Text:=GetPadegStr(Trim(edNomin.Text),tcRodit);
    if Trim(edDativ.Text)='' then
       edDativ.Text:=GetPadegStr(Trim(edNomin.Text),tcDatel);
    if Trim(edCreat.Text)='' then
       edCreat.Text:=GetPadegStr(Trim(edNomin.Text),tcTvorit);
    if Trim(edVinit.Text)='' then
       edVinit.Text:=GetPadegStr(Trim(edNomin.Text),tcVinit);
    if Trim(edPredl.Text)='' then
       edPredl.Text:=GetPadegStr(Trim(edNomin.Text),tcPredl);
  end;     
end;

end.
