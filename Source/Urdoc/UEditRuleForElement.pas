unit UEditRuleForElement;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, db, tsvGrids, ImgList, ComCtrls;

type
  TfmEditRuleForElement = class(TForm)
    lbName: TLabel;
    edName: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TBitBtn;
    btCancel: TBitBtn;
    cbInString: TCheckBox;
    bibClear: TBitBtn;
    pnObjInsp: TPanel;
    grbTest: TGroupBox;
    cbObj: TComboBox;
    pnTest: TPanel;
    sbTest: TScrollBox;
    rbNear: TRadioButton;
    rbNotNear: TRadioButton;
    lbPriority: TLabel;
    edPriority: TEdit;
    udPriority: TUpDown;
    btLoad: TButton;
    btSave: TButton;
    PanelInfo: TPanel;
    MemoInfo: TMemo;
    Splitter: TSplitter;
    LabelElementType: TLabel;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbAdminClick(Sender: TObject);
    procedure meHintChange(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
    procedure edNotChange(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure chbUseNoYearClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbObjDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbObjChange(Sender: TObject);
    procedure rbNearClick(Sender: TObject);
    procedure udPriorityChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure btLoadClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
  private
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);
  public
    DefaultControl: TControl;
    ObjInsp: TtsvPnlInspector;
    NotID: Integer;
    ChangeFlag: Boolean;
    procedure OkClick(Sender: TObject);
    procedure FilterClick(Sender: TObject);
    procedure FillCbObjForWord;
    procedure CreateDefaultControl;
  end;

var
  fmEditRuleForElement: TfmEditRuleForElement;

  function GetTypeElementByIndex(Index: Integer): String;

implementation

uses Udm, UMain, URBRuleForElement, DsnFunc, UCreateCtrl;

{$R *.DFM}

function GetTypeElementByIndex(Index: Integer): String;
begin
  Result:='';
  if (Index>=0)or(Index<=ListClassesForWord.Count-1) then
    Result:=PInfoClass(ListClassesForWord.Items[Index]).Caption;
end;

procedure TfmEditRuleForElement.OkClick(Sender: TObject);
begin
  if Trim(edname.Text)='' then begin
    ShowError(Handle,'Поле <'+lbName.Caption+'>'+#13+'не может быть пустым.');
    edname.SetFocus;
    exit;
  end;
  ModalResult:=mrOk;
end;

procedure TfmEditRuleForElement.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRuleForElement.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditRuleForElement.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;


  ObjInsp:=TtsvPnlInspector.Create(Self);
  ObjInsp.Combo.Clear;
  ObjInsp.Combo.Visible:=false;
  ObjInsp.Align:=alClient;
  ObjInsp.cmLabel.Visible:=false;
  ObjInsp.Combo.Visible:=false;
  ObjInsp.TSEven.TabVisible:=false;
  ObjInsp.Filter:=true;
  ObjInsp.GridP.ColWidths[0]:=140;
  ObjInsp.FilterItems.Add('Left');
  ObjInsp.FilterItems.Add('Top');
  ObjInsp.FilterItems.Add('Links');
  ObjInsp.FilterItems.Add('WordFormType');
  ObjInsp.FilterItems.Add('Name');
  ObjInsp.FilterItems.Add('DocFieldName');
//  ObjInsp.FilterItems.Add('TypeCase');
  ObjInsp.MemoInfo:=MemoInfo;

  ObjInsp.Parent:=pnObjInsp;

  FillCbObjForWord;

  CreateDefaultControl;

end;

procedure TfmEditRuleForElement.CreateDefaultControl;
var
  P: PInfoClass;
  ct: TComponent;
begin
  if DefaultControl<>nil then FreeAndNil(DefaultControl);
  if cbObj.Items.Count=0 then exit;
  if cbObj.ItemIndex=-1 then exit;
  P:=PInfoClass(cbObj.Items.Objects[cbObj.ItemIndex]);
  ct:=TComponentClass(P.TypeClass).Create(Self);
  DefaultControl:=TControl(ct);
  DefaultControl.Parent:=sbTest;
  DefaultControl.Left:=3;
  DefaultControl.Visible:=true;
  DefaultControl.Name:=DsnCheckNameNew(Self,DefaultControl,GetNewName(DefaultControl));
  ObjInsp.UpdateInspector(DefaultControl);
end;

procedure TfmEditRuleForElement.chbAdminClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRuleForElement.meHintChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRuleForElement.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmEditRuleForElement.edNotChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRuleForElement.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
  if cbObj.ItemIndex<>-1 then
   if cbObj.Items.Count>0 then begin
    cbObj.ItemIndex:=0;
    CreateDefaultControl;
   end;  
end;

procedure TfmEditRuleForElement.chbUseNoYearClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRuleForElement.FormDestroy(Sender: TObject);
begin
  ObjInsp.Free;
  DefaultControl.Free;
end;

procedure TfmEditRuleForElement.FillCbObjForWord;
var
  i: Integer;
  P: PInfoClass;
begin
  cbObj.Items.BeginUpdate;
  try
   cbObj.Clear;
   for i:=0 to ListClassesForWord.Count-1 do begin
    P:=ListClassesForWord.Items[i];
    cbObj.Items.AddObject(P.Caption,TObject(P));
   end;
  finally
    cbObj.Items.EndUpdate;
  end;
  if cbObj.Items.Count<>0 then
   cbObj.ItemIndex:=0;
end;


procedure TfmEditRuleForElement.cbObjDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
  procedure DRawImages;
  var
    tmps: string;
    rc: TRect;
    t: Integer;
    newRect: TRect;
    P: PInfoClass;
    NewIndex: Integer;
  begin
    tmps:=cbObj.Items.Strings[Index];
    P:=PInfoClass(cbObj.Items.Objects[Index]);
    if P.ImageIndex<>-1 then
     NewIndex:=P.ImageIndex
    else NewIndex:=Index;
    rc.TopLeft:=Rect.TopLeft;
    rc.BottomRight:=Rect.BottomRight;
    rc.Top:=rc.Top;
    rc.Bottom:=rc.Bottom;
    rc.Left:=rc.Left;
    rc.Right:=rc.Left+fmCreateCtrl.IL.Width+2;

    newRect.Left:=rc.Right;
    newRect.Top:=Rect.Top;
    newRect.Right:=Rect.Right;
    newRect.Bottom:=Rect.Bottom;

    with cbObj.Canvas do begin
     if State<>[odFocused,odSelected] then begin
      FillRect(newRect);
      Brush.Color:=clBtnFace;
      Brush.Style:=bsSolid;
      FillRect(rc);
      fmCreateCtrl.IL.Draw(cbObj.Canvas,rc.Left+1,rc.Top+1,NewIndex);
      fmCreateCtrl.ILWord.Draw(cbObj.Canvas,rc.Left+1,rc.Top+1,0);
     end else begin
      FillRect(newRect);
      Brush.Color:=clBtnFace;
      Brush.Style:=bsSolid;
      FillRect(rc);
      fmCreateCtrl.IL.Draw(cbObj.Canvas,rc.Left+1,rc.Top+1,NewIndex);
      fmCreateCtrl.ILWord.Draw(cbObj.Canvas,rc.Left+1,rc.Top+1,0);
     end;
     Brush.Style:=bsClear;
     Pen.Color:=clWindow;
     Rectangle(rc.left,rc.top,rc.Right,rc.Bottom);
     Pen.Color:=clBlack;
     Rectangle(rc.left+1,rc.top+1,rc.Right-1,rc.Bottom-1);
     t:=(rc.Bottom-rc.Top)div 2 -(TextHeight(tmps) div 2);
     t:=rc.top+t;
     TextOut(rc.Right+1,t,tmps);
    end;

  end;

begin
  DRawImages;
end;

procedure TfmEditRuleForElement.cbObjChange(Sender: TObject);
begin
  CreateDefaultControl;
end;

procedure TfmEditRuleForElement.rbNearClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRuleForElement.udPriorityChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRuleForElement.btLoadClick(Sender: TObject);
var
  od: TOpenDialog;
begin
  od:=TOpenDialog.Create(nil);
  try
    od.Filter:='Файлы правил (*.rul)|*.rul|Все файлы (*.*)|*.*';
    if od.Execute then begin
      LoadFromFile(od.FileName);
    end;
  finally
    od.Free;
  end;
end;

procedure TfmEditRuleForElement.btSaveClick(Sender: TObject);
var
  sd: TSaveDialog;
begin
  sd:=TSaveDialog.Create(nil);
  try
    sd.Filter:='Файлы правил (*.rul)|*.rul|Все файлы (*.*)|*.*';
    sd.DefaultExt:='.rul';
    sd.FileName:=RemoveNotFileNameChar(Trim(edName.Text));
    if sd.Execute then begin
      SaveToFile(sd.FileName);
    end;
  finally
    sd.Free;
  end;
end;

procedure TfmEditRuleForElement.LoadFromFile(const FileName: string);
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
          rbNear.Checked:=rd.ReadBoolean;
          rbNotNear.Checked:=not rbNear.Checked;
          udPriority.Position:=rd.ReadInteger;
          cbObj.ItemIndex:=rd.ReadInteger;
          cbObjChange(nil);
          DefaultControl.Name:='';
          rd.ReadRootComponent(DefaultControl);
          DefaultControl.Left:=0;
          DefaultControl.Top:=0;
          ObjInsp.UpdateInspector(DefaultControl);
        end;
      end;
    finally
      rd.Free;
    end;
  finally
    fs.Free;
  end;
end;

procedure TfmEditRuleForElement.SaveToFile(const FileName: string);
var
  fs: TFileStream;
  wr: TWriter;
begin
  fs:=TFileStream.Create(FileName,fmCreate);
  try
    wr:=TWriter.Create(fs,4096);
    try
      wr.WriteInteger(NRuleVersion);
      wr.WriteString(edName.Text);
      wr.WriteBoolean(rbNear.Checked);
      wr.WriteInteger(udPriority.Position);
      wr.WriteInteger(cbObj.ItemIndex);
      DefaultControl.Name:='';
      wr.IgnoreChildren:=true;
      wr.WriteRootComponent(DefaultControl);
    finally
      wr.Free;
    end;
  finally
    fs.Free;
  end;
end;

end.
