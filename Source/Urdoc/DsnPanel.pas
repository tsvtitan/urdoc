unit DsnPanel;

// Runtime Design System Version 2.x   June/08/1998
// Copyright(c) 1998 Kazuhiro Sasaki.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TypInfo, ExtCtrls, Buttons, Grids,
  Clipbrd, Menus, DsnLgMes, DsnMes;

type
  TArrowButton = class;

  TCustomCmpPlt = class(TPanel)
  private
    FDesigning:Boolean;
  protected
    procedure SetDesigning(Value: Boolean); virtual; abstract;
  public
    function GetTemplate:TComponent; virtual; abstract;
//    function GetTemplate:TControl; virtual; abstract;
    procedure SetTemplate(Template:TComponent); virtual; abstract;
//    procedure SetTemplate(Template:TControl); virtual; abstract;
    procedure SetArrowButton(Value:TArrowButton); virtual; abstract;
    procedure EndCreating; virtual; abstract;
    property Designing:Boolean read FDesigning write SetDesigning;
  end;

  TDsnPanel = class(TCustomCmpPlt)
  private
    FFlgA:Boolean;
    //FDesigning:Boolean;
    hStd:THandle;
    hDB:THandle;
    FArrowButton:TArrowButton;
    FTemplate:TControl;
    FDsnButtons:TList;
    FBtnWidth:Integer;
    FBtnHeight:Integer;
    FBtnCaption:Boolean;
  protected
    procedure CMControlChange(var Message:TCMControlChange);
                            message CM_CONTROLCHANGE;
    procedure MyControlList(var Message:TMessage);message MY_CONTROLLIST;
    procedure SetDesigning(Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure SetArrowButton(Value:TArrowButton); override;
    function GetTemplate:TComponent; override;
//    function GetTemplate:TComponent; override;
    procedure SetTemplate(Template:TComponent); override;
//    procedure SetTemplate(Template:TControl); override;
    procedure EndCreating; override;
    //property Designing:Boolean read FDesigning write SetDesigning;
  published
    property BtnWidth:Integer read FBtnWidth write FBtnWidth;
    property BtnHeight:Integer read FBtnHeight write FBtnHeight;
    property BtnCaption:Boolean read FBtnCaption write FBtnCaption;
  end;

  TDsnButton = class(TSpeedButton)
  private
    FDpstControl:TControl;
    FDsnPanel:TDsnPanel;
    GeneName:ShortString;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadName(Reader:TReader);
    procedure WriteName(Writer:TWriter);
    procedure Loaded; override;
  public
    procedure Click; override;
  end;

  TArrowButton = class(TSpeedButton)
  private
    FDsnPanel:TCustomCmpPlt;
  protected
    procedure Loaded; override;
  public
    procedure SetDsnPanel(Value:TCustomCmpPlt);
    procedure Click; override;
  end;

implementation

const
  ArwBtn_GrpIdx = 2301;
  DsnBtn_GrpIdx = 2301;

{TDsnPanel}
constructor TDsnPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FFlgA := True;
  FBtnWidth:=90;
  FBtnHeight:=50;
  FBtnCaption:=True;

{$IFDEF VER100} // Delphi 3
  if csDesigning in ComponentState then
  begin
    hStd:=LoadLibrary(PChar(ExtractFilePath(Application.ExeName)
                                            + 'Dclstd30.dpl'));
    hDB:=LoadLibrary(PChar(ExtractFilePath(Application.ExeName)
                                            + 'Dcldb30.dpl'));
  end;
{$ENDIF}
{$IFDEF VER120} // Delphi 4
  if csDesigning in ComponentState then
  begin
    hStd:=LoadLibrary(PChar(ExtractFilePath(Application.ExeName)
                                            + 'dclstd40.bpl'));
    hDB:=LoadLibrary(PChar(ExtractFilePath(Application.ExeName)
                                            + 'dcldb40.dpl'));
  end;
{$ENDIF}

end;

destructor TDsnPanel.Destroy;
begin
  if FDsnButtons <> nil then
    FDsnButtons.Free;

  if csDesigning in ComponentState then
  begin
    FreeLibrary(hStd);
    FreeLibrary(hDB);
  end;

  inherited;
end;

procedure TDsnPanel.SetDesigning(Value: Boolean);
var
  i:integer;
  DpstControl:TComponent;
begin
  FDesigning:=Value;
  if FDesigning then
  begin
    if FArrowButton <> nil then
    begin
      FArrowButton.Down:=True;
      FArrowButton.Enabled:=True;
    end;
    if FDsnButtons <> nil then
      for i:= 0 to FDsnButtons.Count-1 do
      begin
        DpstControl:=Owner.FindComponent(TDsnButton(FDsnButtons[i]).GeneName);
        TDsnButton(FDsnButtons[i]).FDpstControl:=TControl(DpstControl);
        TDsnButton(FDsnButtons[i]).Enabled:=True;
      end;
  end
  else
  begin
    if FArrowButton <> nil then
      FArrowButton.Enabled:=False;
    if FDsnButtons <> nil then
      for i:= 0 to FDsnButtons.Count-1 do
        TDsnButton(FDsnButtons[i]).Enabled:=False;
  end;   
end;

procedure TDsnPanel.CMControlChange(var Message:TCMControlChange);
begin
  inherited;
  if not ((Message.Control is TDsnButton) or
         (Message.Control is TArrowButton)) then
    PostMessage(Handle, MY_CONTROLLIST,Integer(Message.Control),0);

  if csDesigning in ComponentState then
    if not Message.Inserting then
      if Message.Control is TDsnButton then
        if Owner.FindComponent(TDsnButton(Message.Control).GeneName) <> nil then
          Owner.FindComponent(TDsnButton(Message.Control).GeneName).Free;
end;

procedure TDsnPanel.SetArrowButton(Value:TArrowButton);
begin
  if Assigned(Value) then
    FArrowButton:= Value;
end;

procedure TDsnPanel.SetTemplate(Template:TComponent);
begin
  if (Template = FArrowButton) or (Template = nil) then
    FTemplate:= nil
  else
    if Assigned(Template) then
      FTemplate:= TControl(Template);
end;

function TDsnPanel.GetTemplate:TComponent;
begin
  Result:= FTemplate;
end;

procedure TDsnPanel.EndCreating;
begin
  if Assigned(FArrowButton) then
    FArrowButton.Down:= True;
end;

procedure TDsnPanel.MyControlList(var Message:TMessage);
var
  DpstPanel:TPanel;
  Button:TDsnButton;
  ArrowButton:TArrowButton;
  i,n,m,l:integer;
  S:String;
  h:Thandle;
  P:Pointer;
  DpstControl:TControl;
  Flag:Boolean;

  procedure Proc(var a,b:integer);
  begin
    if a>m then
    begin
      a:=a-m;
      Inc(b);
      if a>m then
        Proc(a,b);
    end;
  end;

begin
  if FFlgA then
  begin
    FFlgA := False;

    if csDesigning in ComponentState then
    begin

      P:= Pointer(Owner.FindComponent('DsnDpstPanel'));
      if P = nil then
      begin
        DpstPanel:=TPanel.Create(Owner);
        DpstPanel.Parent:=Self.Parent;
        DpstPanel.Name:= 'DsnDpstPanel';
        DpstPanel.SetBounds(-100,-100,50,50);
      end else
        DpstPanel:=TPanel(P);

      Flag:=True;
      for i:=0 to ControlCount-1 do
        if Controls[i] is TArrowButton then
        begin
          Flag:=False;
          Break;
        end;

      if Flag then
      begin
        ArrowButton:=TArrowButton.Create(Owner);
        ArrowButton.Parent:=Self;

        m:=1;
        while Owner.FindComponent('ArrowButton' + IntToStr(m)) <> nil do
           Inc(m);

        ArrowButton.Name:= 'ArrowButton' + IntToStr(m);
        FArrowButton:=ArrowButton;
        ArrowButton.SetBounds(8,8,FBtnWidth,FBtnHeight);
        h:= LoadBitmap(hInstance,'ARROWBUTTON');
        ArrowButton.Glyph.Handle:=h;
        ArrowButton.GroupIndex:= ArwBtn_GrpIdx;
      end;
      TControl(Message.WParam).Parent:=DpstPanel;
      DpstControl:= TControl(Message.WParam);

      S:= 'Dpst_' + TControl(Message.WParam).ClassName;
      while Owner.FindComponent(S) <> nil do
         S:=S + 'X';
      TControl(Message.WParam).Name:= S;
      TControl(Message.WParam).SetBounds(0,0,50,50);

      Button:=TDsnButton.Create(Owner);
      Button.Parent:=Self;
      Button.FDsnPanel:= Self;
      Button.FDpstControl:=DpstControl;
      Button.GeneName:= S;

      n:=0;

      for i:=0 to ControlCount-1 do
        if ((Controls[i] is TDsnButton) or
           (Controls[i] is TArrowButton)) then
           Inc(n);

      m:=1;
      while Owner.FindComponent('DsnButton' + IntToStr(m)) <> nil do
         Inc(m);

      Button.Name:='DsnButton' + IntToStr(m);

      S:= TControl(Message.WParam).ClassName;

      S:= AnsiUpperCase(S);

      if csDesigning in ComponentState then
      begin
        h:= LoadBitmap(hInstance,PChar(S));
        if h=0 then
          h:= LoadBitmap(hStd,PChar(S));
        if h=0 then
          h:= LoadBitmap(hDB,PChar(S));
        if h=0 then
          h:= LoadBitmap(hInstance,'TCOMPONENT');

        Button.Glyph.Handle:= h;

      end;

      Delete(S,1,1);
      if FBtnCaption then
        Button.Caption:= S;
      Button.Layout:= blGlyphTop;

      if Self.Width<FBtnWidth then Self.Width:=FBtnWidth+24;
      m:= Self.Width div FBtnWidth;
      l:=0;
      Proc(n,l);

      Button.SetBounds(FBtnWidth*n-FBtnWidth+8, 8+FBtnHeight*l, FBtnWidth, FBtnHeight);
      Button.GroupIndex:= DsnBtn_GrpIdx;

    end;

  end else
    FFlgA := True;
end;

{TDsnButton}
procedure TDsnButton.Click;
begin
  inherited;
  if Down then
    if Assigned(FDpstControl) then
      FDsnPanel.SetTemplate(FDpstControl)
    else
      if Assigned(FDsnPanel.FArrowButton) then
        FDsnPanel.FArrowButton.Down:= True;
end;

procedure TDsnButton.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('GeneName',ReadName,WriteName,True);
end;

procedure TDsnButton.ReadName(Reader:TReader);
begin
  GeneName:=Reader.ReadString;
end;

procedure TDsnButton.WriteName(Writer:TWriter);
begin
  Writer.WriteString(GeneName);
end;

procedure TDsnButton.Loaded;
begin
  inherited;
  Enabled:= False;
  FDsnPanel:= TDsnPanel(Parent);
  if FDsnPanel.FDsnButtons = nil then
    FDsnPanel.FDsnButtons:=TList.Create;

  FDsnPanel.FDsnButtons.Add(Self);
end;


{TArrowButton}
procedure TArrowButton.Loaded;
begin
  inherited;
  AllowAllUp:=False;
  Enabled:=False;
end;

procedure TArrowButton.Click;
begin
  inherited;
  if Down then
    FDsnPanel.SetTemplate(Self);
end;

procedure TArrowButton.SetDsnPanel(Value:TCustomCmpPlt);
begin
  if Assigned(Value) then
    FDsnPanel:= Value;
end;


end.
