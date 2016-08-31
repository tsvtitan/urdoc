unit UCreateCtrl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ImgList;

type
  TfmCreateCtrl = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Panel2: TPanel;
    cbObj: TComboBox;
    IL: TImageList;
    rbStandart: TRadioButton;
    rbForWord: TRadioButton;
    ILWord: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure cbObjDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure rbStandartClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    procedure FillCbObj;
    procedure FillCbObjForWord;
  end;

var
  fmCreateCtrl: TfmCreateCtrl;

implementation

uses UDm, UMain;

{$R *.DFM}

procedure TfmCreateCtrl.FormCreate(Sender: TObject);
begin
  TControl(cbObj).Align:=alClient;
  FillCbObj;
end;

procedure TfmCreateCtrl.FillCbObj;
var
  i: Integer;
  P: PInfoClass;
begin
  cbObj.Items.BeginUpdate;
  try
   cbObj.Clear;
   for i:=0 to ListClasses.Count-1 do begin
    P:=ListClasses.Items[i];
    cbObj.Items.AddObject(P.Caption,TObject(P));
   end;
  finally
    cbObj.Items.EndUpdate;
  end;
  if cbObj.Items.Count<>0 then
   cbObj.ItemIndex:=0;
end;

procedure TfmCreateCtrl.cbObjDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);

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
    rc.Right:=rc.Left+IL.Width+2;

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
      IL.Draw(cbObj.Canvas,rc.Left+1,rc.Top+1,NewIndex);
      if rbForWord.Checked then begin
       ILWord.Draw(cbObj.Canvas,rc.Left+1,rc.Top+1,0);
      end;
     end else begin
      FillRect(newRect);
      Brush.Color:=clBtnFace;
      Brush.Style:=bsSolid;
      FillRect(rc);
      IL.Draw(cbObj.Canvas,rc.Left+1,rc.Top+1,NewIndex);
      if rbForWord.Checked then begin
        ILWord.Draw(cbObj.Canvas,rc.Left+1,rc.Top+1,0);
      end;
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

procedure TfmCreateCtrl.rbStandartClick(Sender: TObject);
begin
   if Sender=rbStandart then begin
     FillCbObj;
     exit;
   end;
   if Sender=rbForWord then begin
     FillCbObjForWord;
     exit;
   end;
end;

procedure TfmCreateCtrl.FillCbObjForWord;
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

procedure TfmCreateCtrl.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  fmMain.OnKeyDown(Sender,Key,Shift);
end;

procedure TfmCreateCtrl.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  fmMain.OnKeyUp(Sender,Key,Shift);
end;

end.
