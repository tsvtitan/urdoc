unit USearchDocEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, db;

type
  TfmSearchDocEdit = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    lbPathName: TLabel;
    edPathName: TEdit;
    bibPathName: TBitBtn;
    cbInString: TCheckBox;
    lbUserName: TLabel;
    edUserName: TEdit;
    lbString: TLabel;
    edString: TEdit;
    bibUsername: TBitBtn;
    bibClear: TBitBtn;
    lbHint: TLabel;
    edHint: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure bibOkClick(Sender: TObject);
    procedure bibPathNameClick(Sender: TObject);
    procedure edStringKeyPress(Sender: TObject; var Key: Char);
    procedure edSummKeyPress(Sender: TObject; var Key: Char);
    procedure edFioChange(Sender: TObject);
    procedure edUserNameKeyPress(Sender: TObject; var Key: Char);
    procedure bibUsernameClick(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
  private
    procedure DocTreeNodeOkClick(Sender: TObject);
  public

  end;

var
  fmSearchDocEdit: TfmSearchDocEdit;

implementation

uses UMain, UDocTree, UDm, URBOperation, URBTypeReestr, URBUsers;

var
  NewFm: TfmDocTree;
{$R *.DFM}

procedure TfmSearchDocEdit.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TfmSearchDocEdit.bibOkClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmSearchDocEdit.bibPathNameClick(Sender: TObject);
var
  fm: TfmDocTree;
  Index: Integer;
begin
  fm:=TfmDocTree.Create(nil);
  try
   NewFm:=fm;
   fm.Caption:=DefSelectNode;
   fm.pnBottom.Visible:=true;
   fm.Hide;
   fm.Width:=400;
   fm.Height:=400;
   fm.pnLV.Visible:=false;
   fm.splLeft.Visible:=false;
   fm.pnTV.Align:=alClient;
   fm.pnTVBottom.Height:=30;

   fm.Position:=poScreenCenter;
   fm.BorderIcons:=[biSystemMenu, biMaximize];
   fm.ViewType:=vtEdit;
   fm.ViewType:=vtView;
   fm.ActiveQuery;
   Index:=-1;
   if fmDocTree<>nil then
    if fmDocTree.TV.Selected<>nil then
     Index:=fmDocTree.TV.Selected.AbsoluteIndex;
   if Index<>-1 then begin
    fm.tv.Items.Item[Index].MakeVisible;
    fm.tv.Items.Item[Index].Selected:=true;
   end;

   fm.bibOk.OnClick:=DocTreeNodeOkClick;
   fm.TV.OnDblClick:=DocTreeNodeOkClick;

   if fm.ShowModal=mrOk then begin
     if fm.TV.Selected<>nil then
      edPathName.Text:=fm.TV.Selected.Text;
   end;
  finally
   fm.Free;
  end;
end;

procedure TfmSearchDocEdit.DocTreeNodeOkClick(Sender: TObject);
begin
  if NewFm=nil then exit;
  if NewFm.TV.Selected=nil then begin
    ShowError(Application.Handle,DefSelectNode+'.');
    exit;
  end;
  NewFm.modalResult:=mrOk;
end;

procedure TfmSearchDocEdit.edStringKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Char(Key) in ['0'..'9']))and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end;
end;

procedure TfmSearchDocEdit.edSummKeyPress(Sender: TObject; var Key: Char);
var
  APos: Integer;
begin
  if (not (Key in ['0'..'9']))and (Key<>DecimalSeparator)and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end else begin
   if Key=DecimalSeparator then begin
    Apos:=Pos(String(DecimalSeparator),TEdit(Sender).Text);
    if Apos<>0 then Key:=char(nil);
   end;
  end;
end;

procedure TfmSearchDocEdit.edFioChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmSearchDocEdit.edUserNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmSearchDocEdit.bibUsernameClick(Sender: TObject);
var
  fm: TfmUsers;
begin
  fm:=TfmUsers.Create(nil);
  try
   fm.BorderIcons:=[biSystemMenu, biMaximize];
   fm.bibOk.Visible:=true;
   fm.bibOk.OnClick:=fm.MR;
   fm.pnSQL.Visible:=false;
   fm.Grid.OnDblClick:=fm.MR;
   fm.LoadFilter;
   fm.ActiveQuery;
   if trim(edUserName.Text)<>'' then
    fm.Mainqr.locate('name',trim(edUserName.Text),[loCaseInsensitive]);
   if fm.ShowModal=mrOk then begin
     edUserName.Text:=Trim(fm.Mainqr.fieldByName('name').AsString);
   end;
  finally
   fm.Free;
  end;
end;

procedure TfmSearchDocEdit.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

end.
