unit UEditConst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, db, ComCtrls;

type
  TfmEditConst = class(TForm)
    lbName: TLabel;
    edName: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    lbHint: TLabel;
    meHint: TMemo;
    lbValue: TLabel;
    mevalue: TMemo;
    bibClear: TBitBtn;
    lbValPlus: TLabel;
    meValPlus: TMemo;
    lbPriority: TLabel;
    edPriority: TEdit;
    udPriority: TUpDown;
    chbAutoFormat: TCheckBox;
    lbStyle: TLabel;
    cmbStyle: TComboBox;
    lbRenovation: TLabel;
    edRenovation: TEdit;
    bibRenovation: TBitBtn;
    bibEditNotary: TBitBtn;
    btUp: TBitBtn;
    btDown: TBitBtn;
    bibEditHelper: TBitBtn;
    cbInString: TCheckBox;
    btLoad: TButton;
    btSave: TButton;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbAdminClick(Sender: TObject);
    procedure meHintChange(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
    procedure edNotChange(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure edPriorityChange(Sender: TObject);
    procedure udPriorityChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure chbAutoFormatClick(Sender: TObject);
    procedure bibRenovationClick(Sender: TObject);
    procedure edRenovationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btDownClick(Sender: TObject);
    procedure btUpClick(Sender: TObject);
    procedure bibEditNotaryClick(Sender: TObject);
    procedure bibEditHelperClick(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
  private
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);
  public
    NotID: Integer;
    ChangeFlag: Boolean;
    procedure OkClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
  end;

var
  fmEditConst: TfmEditConst;

implementation

uses Udm, UMain, URBNotarius, URBRenovation, UEditText;

{$R *.DFM}

procedure TfmEditConst.OkClick(Sender: TObject);
begin
  if Trim(edname.Text)='' then begin
    ShowError(Handle,'Поле <'+lbName.Caption+'>'+#13+'не может быть пустым.');
    edname.SetFocus;
    exit;
  end;
  if Trim(meValue.Lines.Text)='' then begin
    ShowError(Handle,'Поле <'+lbValue.Caption+'>'+#13+'не может быть пустым.');
    meValue.SetFocus;
    exit;
  end;
  if Trim(meValPlus.Lines.Text)='' then begin
    ShowError(Handle,'Поле <'+lbValPlus.Caption+'>'+#13+'не может быть пустым.');
    meValPlus.SetFocus;
    exit;
  end;

  ModalResult:=mrOk;
end;

procedure TfmEditConst.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditConst.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditConst.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;

  cmbStyle.Items.AddStrings(ListDefaultStyles);
  edRenovation.Tag:=0;
end;

procedure TfmEditConst.chbAdminClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditConst.meHintChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditConst.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditConst.edNotChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditConst.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmEditConst.edPriorityChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditConst.udPriorityChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

procedure TfmEditConst.chbAutoFormatClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditConst.bibRenovationClick(Sender: TObject);
var
  fm: TfmRenovation;
begin
  fm:=TfmRenovation.Create(nil);
  try
   fm.BorderIcons:=[biSystemMenu, biMaximize];
   fm.bibOk.Visible:=true;
   fm.bibOk.OnClick:=fm.MR;
   fm.Grid.OnDblClick:=fm.MR;
   fm.LoadFilter;
   fm.ActiveQuery;
   if trim(edRenovation.Text)<>'' then
    fm.Mainqr.locate('name',trim(edRenovation.Text),[loPartialKey,loCaseInsensitive]);
   if fm.ShowModal=mrOk then begin
     ChangeFlag:=true;
     edRenovation.Text:=Trim(fm.Mainqr.fieldByName('name').AsString);
     edRenovation.Tag:=fm.Mainqr.fieldByName('renovation_id').AsInteger;
   end;
  finally
   fm.Free;
  end;
end;

procedure TfmEditConst.edRenovationKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE) or (Key=VK_BACK) then begin
     edRenovation.Text:='';
     edRenovation.Tag:=0;
     ChangeFlag:=true;
  end;
end;

procedure TfmEditConst.btDownClick(Sender: TObject);
begin
  meValPlus.Lines.Text:=mevalue.Lines.Text;
end;

procedure TfmEditConst.btUpClick(Sender: TObject);
begin
  mevalue.Lines.Text:=meValPlus.Lines.Text;
end;

procedure TfmEditConst.bibEditNotaryClick(Sender: TObject);
var
  fm: TfmEditText;
begin
  fm:=TfmEditText.Create(nil);
  try
    fm.Caption:='Редактирование константы';
    fm.Memo1.Lines.Text:=mevalue.Lines.Text;
    if fm.ShowModal=mrOk then begin
      mevalue.Lines.Text:=fm.Memo1.Lines.Text;
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmEditConst.bibEditHelperClick(Sender: TObject);
var
  fm: TfmEditText;
begin
  fm:=TfmEditText.Create(nil);
  try
    fm.Caption:='Редактирование константы';
    fm.Memo1.Lines.Text:=meValPlus.Lines.Text;
    if fm.ShowModal=mrOk then begin
      meValPlus.Lines.Text:=fm.Memo1.Lines.Text;
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmEditConst.btLoadClick(Sender: TObject);
var
  od: TOpenDialog;
begin
  od:=TOpenDialog.Create(nil);
  try
    od.Filter:='Файлы констант (*.con)|*.con|Все файлы (*.*)|*.*';
    if od.Execute then begin
      LoadFromFile(od.FileName);
    end;
  finally
    od.Free;
  end;
end;

procedure TfmEditConst.btSaveClick(Sender: TObject);
var
  sd: TSaveDialog;
begin
  sd:=TSaveDialog.Create(nil);
  try
    sd.Filter:='Файлы констант (*.con)|*.con|Все файлы (*.*)|*.*';
    sd.DefaultExt:='.con';
    sd.FileName:=RemoveNotFileNameChar(Trim(edName.Text));
    if sd.Execute then begin
      SaveToFile(sd.FileName);
    end;
  finally
    sd.Free;
  end;
end;

procedure TfmEditConst.LoadFromFile(const FileName: string);
var
  fs: TFileStream;
  rd: TReader;
  Ver: Integer;
begin
  fs:=TFileStream.Create(FileName,fmOpenRead);
  try
    rd:=TReader.Create(fs,4096);
    try
      Ver:=rd.ReadInteger;
      case Ver of
        1: begin
          edName.Text:=rd.ReadString;
          mevalue.Text:=rd.ReadString;
          meValPlus.Text:=rd.ReadString;
          meHint.Text:=rd.ReadString;
          udPriority.Position:=rd.ReadInteger;
          chbAutoFormat.Checked:=rd.ReadBoolean;
          cmbStyle.Text:=rd.ReadString;
        end;
      end;
    finally
      rd.Free;
    end;
  finally
    fs.Free;
  end;  
end;

procedure TfmEditConst.SaveToFile(const FileName: string);
var
  fs: TFileStream;
  wr: TWriter;
begin
  fs:=TFileStream.Create(FileName,fmCreate);
  try
    wr:=TWriter.Create(fs,4096);
    try
      wr.WriteInteger(NConstVersion);
      wr.WriteString(edName.Text);
      wr.WriteString(mevalue.Text);
      wr.WriteString(meValPlus.Text);
      wr.WriteString(meHint.Text);
      wr.WriteInteger(udPriority.Position);
      wr.WriteBoolean(chbAutoFormat.Checked);
      wr.WriteString(cmbStyle.Text);
    finally
      wr.Free;
    end;
  finally
    fs.Free;
  end;  
end;


end.
