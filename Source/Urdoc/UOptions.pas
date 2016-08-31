unit UOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, FileCtrl, ComCtrls, IBServices, db, CheckLst,
  IniFiles;

type
  TDatabaseInfo=class(TObject)
  public
    var Name: String;
    var FileName: String;
  end;

  TfmOptions = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    TV: TTreeView;
    pnMain: TPanel;
    ntb: TNotebook;
    grbBaseDir: TGroupBox;
    pnTopStatus: TPanel;
    lbTopStatus: TLabel;
    chbFirstArch: TCheckBox;
    chbLastArch: TCheckBox;
    chbTimeArch: TCheckBox;
    edTimeArch: TEdit;
    udTimeArch: TUpDown;
    Label1: TLabel;
    lbFreezeArch: TLabel;
    edFreezeArch: TEdit;
    udFreezeArch: TUpDown;
    Label2: TLabel;
    chbDelTempFile: TCheckBox;
    grbFileHelp: TGroupBox;
    edFileHelp: TEdit;
    bibFileHelp: TBitBtn;
    od: TOpenDialog;
    lbRestoreSleep: TLabel;
    edRestoreSleep: TEdit;
    udRestoreSleep: TUpDown;
    lbRestoreSleepSec: TLabel;
    chbTextPClose: TCheckBox;
    lbTranslateToUpperCase: TLabel;
    hkTranslateToUpperCase: THotKey;
    lbTranslateToLowerCase: TLabel;
    hkTranslateToLowerCase: THotKey;
    lbTranslateToRussian: TLabel;
    hkTranslateToRussian: THotKey;
    lbTranslateToEnglish: TLabel;
    hkTranslateToEnglish: THotKey;
    lbDefaultDir: TLabel;
    edDefaultDir: TEdit;
    chbViewDateInListView: TCheckBox;
    chbViewPath: TCheckBox;
    chbRefreshForm: TCheckBox;
    chbChangeDocument: TCheckBox;
    chbDeleteQuiteInReestr: TCheckBox;
    chbViewDeleteQuiteInReestr: TCheckBox;
    lbDayDoverOffset: TLabel;
    edDayDoverOffset: TEdit;
    udDayDoverOffset: TUpDown;
    chbDisableDefaultOnForm: TCheckBox;
    grbUpdateInfo: TGroupBox;
    edUpdateInfoFile: TEdit;
    bibUpdateInfo: TBitBtn;
    chbViewUpdateInfo: TCheckBox;
    chbViewHintOnFocus: TCheckBox;
    chbViewReminder: TCheckBox;
    chbAutoUpdateWords: TCheckBox;
    chbViewWhoCert: TCheckBox;
    chbDocumentLock: TCheckBox;
    chbNotViewHereditaryDeal: TCheckBox;
    chbExpandConst: TCheckBox;
    chbCheckEmptySumm: TCheckBox;
    ButtonDatabaseAdd: TButton;
    ButtonDatabaseChange: TButton;
    ButtonDatabaseDelete: TButton;
    CheckListBoxDatabases: TCheckListBox;
    BitBtnSelectBackupDir: TBitBtn;
    chbSelectDatabase: TCheckBox;
    chbQuestionBackup: TCheckBox;
    procedure bibOkClick(Sender: TObject);
    procedure edBaseDirChange(Sender: TObject);
    procedure chbTimeArchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbDelTempFileClick(Sender: TObject);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure bibFileHelpClick(Sender: TObject);
    procedure chbViewDeleteQuiteInReestrClick(Sender: TObject);
    procedure bibUpdateInfoClick(Sender: TObject);
    procedure chbChangeDocumentClick(Sender: TObject);
    procedure chbExpandConstClick(Sender: TObject);
    procedure CheckListBoxDatabasesClickCheck(Sender: TObject);
    procedure ButtonDatabaseDeleteClick(Sender: TObject);
    procedure ButtonDatabaseAddClick(Sender: TObject);
    procedure ButtonDatabaseChangeClick(Sender: TObject);
    procedure CheckListBoxDatabasesDblClick(Sender: TObject);
    procedure BitBtnSelectBackupDirClick(Sender: TObject);
  private
    FLicenseID: Integer;
    procedure SetLicenseID(Value: Integer);
    procedure SelectPage(Index: Integer);
    procedure UnCheckAllDatabases(OnlyIndex: Integer); 
  public
    isSetAll: Boolean;
    ChangeFlag: Boolean;

    destructor Destroy; override;
    procedure LoadDatabases;
    procedure SaveDatabases;

    property LicenseID: Integer read FLicenseID write SetLicenseID;
  end;

var
  fmOptions: TfmOptions;

implementation

uses UDm, UUtils, UMain, DatabaseEditFm, URBLicense, tsvGradientLabel;

{$R *.DFM}

procedure TfmOptions.bibOkClick(Sender: TObject);
begin
  if Trim(edFileHelp.Text)<>'' then
   if not FileExists(edFileHelp.Text) then begin
    ShowError(Handle,'���� ������ �� ������.');
    SelectPage(3);
    edFileHelp.SetFocus;
    exit;
   end;

  modalResult:=mrOk;
end;

procedure TfmOptions.edBaseDirChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmOptions.chbTimeArchClick(Sender: TObject);
begin
  if chbTimeArch.Checked then begin
    edTimeArch.Enabled:=true;
    edTimeArch.Color:=clWindow;
    udTimeArch.Enabled:=true;
  end else begin
    edTimeArch.Enabled:=false;
    edTimeArch.Color:=clBtnFace;
    udTimeArch.Enabled:=false;
  end;
end;

procedure TfmOptions.FormCreate(Sender: TObject);
var
  lb: TtsvGradientLabel;
begin
  isSetAll:=false;
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
  ntb.PageIndex:=0;
  lb:=TtsvGradientLabel.Create(Self);
  lb.Parent:=lbTopStatus.Parent;
  lb.Align:=lbTopStatus.Align;
  lb.Font.Assign(lbTopStatus.Font);
  lb.FromColor:=clBtnShadow;
  lb.ToColor:=clBtnFace;
  lb.ColorCount:=ColorCount;
  lbTopStatus.Free;
  lb.Name:='lbTopStatus';
  lbTopStatus:=TLabel(lb);
end;

procedure TfmOptions.chbDelTempFileClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmOptions.TVChange(Sender: TObject; Node: TTreeNode);
var
  nd: TTreeNode;
begin
  nd:=Tv.Selected;
  if nd=nil then exit;
  lbTopStatus.Caption:=nd.Text;
  ntb.PageIndex:=nd.AbsoluteIndex;
end;

procedure TfmOptions.UnCheckAllDatabases(OnlyIndex: Integer);
var
  i: Integer;
begin
  for i:=0 to CheckListBoxDatabases.Items.Count-1 do begin
    if OnlyIndex<>i then
      CheckListBoxDatabases.Checked[i]:=false;    
  end;
end;

procedure TfmOptions.bibFileHelpClick(Sender: TObject);
begin
  od.FileName:=edFileHelp.Text;
  od.Filter:=FilterAll;
  if not od.Execute then exit;
  edFileHelp.Text:=od.FileName;
end;

procedure TfmOptions.SetLicenseID(Value: Integer);
begin
end;

procedure TfmOptions.SelectPage(Index: Integer);
var
  nd: TTreeNode;
begin
  ntb.PageIndex:=Index;
  nd:=TV.Items.Item[Index];
  nd.Selected:=true;
  lbTopStatus.Caption:=nd.Text;
end;

procedure TfmOptions.chbViewDeleteQuiteInReestrClick(Sender: TObject);
begin
  if isSetAll then begin
    ChangeFlag:=true;
    if chbViewDeleteQuiteInReestr.Checked then begin
      chbDeleteQuiteInReestr.Checked:=true;
    end else begin
      chbDeleteQuiteInReestr.Checked:=false;
    end;
  end;
end;

procedure TfmOptions.CheckListBoxDatabasesClickCheck(Sender: TObject);
begin
  UnCheckAllDatabases(CheckListBoxDatabases.ItemIndex);
  ChangeFlag:=true;
end;

procedure TfmOptions.CheckListBoxDatabasesDblClick(Sender: TObject);
begin
  ButtonDatabaseChangeClick(nil);
end;

destructor TfmOptions.Destroy;
begin
  ClearStrings(CheckListBoxDatabases.Items);
  inherited Destroy;
end;

procedure TfmOptions.bibUpdateInfoClick(Sender: TObject);
begin
  od.FileName:=edUpdateInfoFile.Text;
  od.Filter:=FilterAll;
  if not od.Execute then exit;
  edUpdateInfoFile.Text:=od.FileName;
end;

procedure TfmOptions.ButtonDatabaseDeleteClick(Sender: TObject);
var
  Obj: TDatabaseInfo;
begin
  if CheckListBoxDatabases.ItemIndex<>-1 then begin
    if not CheckListBoxDatabases.Checked[CheckListBoxDatabases.ItemIndex]  then begin
      Obj:=TDatabaseInfo(CheckListBoxDatabases.Items.Objects[CheckListBoxDatabases.ItemIndex]);
      Obj.Free;
      CheckListBoxDatabases.DeleteSelected;
      ChangeFlag:=true;
    end else
      ShowError(Handle,'������ ������� ������� ���� ������ �� ������.');
  end else
    ShowError(Handle,'�������� ���� ������.');
end;

procedure TfmOptions.chbChangeDocumentClick(Sender: TObject);
begin
  chbExpandConst.Checked:=not chbChangeDocument.Checked;
end;

procedure TfmOptions.chbExpandConstClick(Sender: TObject);
begin
  chbChangeDocument.Checked:=not chbExpandConst.Checked;
end;

procedure TfmOptions.LoadDatabases;
var
  fi: TIniFile;
  Str: TStringList;
  Index: Integer;
  i: Integer;
  Info: TDatabaseInfo;
begin
  fi:=TIniFile.Create(GetIniFileName);
  CheckListBoxDatabases.Items.BeginUpdate;
  Str:=TStringList.Create;
  try
    ClearStrings(CheckListBoxDatabases.Items);

    fi.ReadSectionValues('Databases',Str);
    Index:=-1;
    for i:=0 to Str.Count-1 do begin
      Info:=TDatabaseInfo.Create;
      Info.Name:=Str.Names[i];
      Info.FileName:=Str.ValueFromIndex[i];
      CheckListBoxDatabases.Items.AddObject(Info.Name,Info);
      if (Index=-1) and AnsiSameText(DataBaseName,Info.FileName) then begin
        CheckListBoxDatabases.Checked[i]:=true;
        CheckListBoxDatabases.ItemIndex:=i;
        Index:=i;
      end;
    end;

  finally
    Str.Free;
    CheckListBoxDatabases.Items.EndUpdate;
    fi.Free;
  end;
end;

procedure TfmOptions.SaveDatabases;
var
  fi: TIniFile;
  Str: TStringList;
  i: Integer;
  Info: TDatabaseInfo;
begin
  fi:=TIniFile.Create(GetIniFileName);
  CheckListBoxDatabases.Items.BeginUpdate;
  Str:=TStringList.Create;
  try
    fi.EraseSection('Databases');
    for i:=0 to CheckListBoxDatabases.Items.Count-1 do begin
      Info:=TDatabaseInfo(CheckListBoxDatabases.Items.Objects[i]);
      fi.WriteString('Databases',Info.Name,Info.FileName);
      if CheckListBoxDatabases.Checked[i] then
        DataBaseName:=Info.FileName;
    end;
  finally
    Str.Free;
    CheckListBoxDatabases.Items.EndUpdate;
    fi.Free;
  end;
end;

procedure TfmOptions.BitBtnSelectBackupDirClick(Sender: TObject);
var
  Last: String;
  S: String;
begin
  S:=DefaultBackUpDir;
  if Trim(edDefaultDir.Text)<>'' then
    S:=Trim(edDefaultDir.Text);
  Last:=GetDir(Application.Handle,S);
  if DirectoryExists(Last) then begin
    edDefaultDir.Text:=Last;
  end;
end;

procedure TfmOptions.ButtonDatabaseAddClick(Sender: TObject);
var
  Form: TDatabaseEditForm;
  Info: TDatabaseInfo;
  Index: Integer;
begin
  Form:=TDatabaseEditForm.Create(nil);
  try
    Form.Caption:='�������� ���� ������';
    if Form.ShowModal=mrOk then begin
      UnCheckAllDatabases(-1);
      Info:=TDatabaseInfo.Create;
      Info.Name:=Form.EditName.Text;
      Info.FileName:=Form.edBaseDir.Text;
      Index:=CheckListBoxDatabases.Items.AddObject(Info.Name,Info);
      CheckListBoxDatabases.Checked[Index]:=true;
      CheckListBoxDatabases.ItemIndex:=Index;
      ChangeFlag:=true;
    end;
  finally
    Form.Free;
  end;
end;

procedure TfmOptions.ButtonDatabaseChangeClick(Sender: TObject);
var
  Form: TDatabaseEditForm;
  Info: TDatabaseInfo;
begin
  if CheckListBoxDatabases.ItemIndex<>-1 then begin
    Info:=TDatabaseInfo(CheckListBoxDatabases.Items.Objects[CheckListBoxDatabases.ItemIndex]);
    Form:=TDatabaseEditForm.Create(nil);
    try
      Form.Caption:='�������� ���� ������';
      Form.EditName.Text:=Info.Name;
      Form.edBaseDir.Text:=Info.FileName;
      if Form.ShowModal=mrOk then begin
        Info.Name:=Form.EditName.Text;
        Info.FileName:=Form.edBaseDir.Text;
        CheckListBoxDatabases.Items.Strings[CheckListBoxDatabases.ItemIndex]:=Info.Name;
        ChangeFlag:=true;
      end;
    finally
      Form.Free;
    end;
  end else begin
    ShowError(Handle,'�������� ���� ������.');
  end;
end;

end.
