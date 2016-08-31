{This very small pack was developed for application building, having form, buttons and labels styles like Norton CrashGuard 3 (NU3).

Thanks to RXLib developers, you are very cool programmers.
I use some code from RXLib and Bi-Library( Bjoern, http://www.b-ischo.horizont.is.net)

_NOTE_:
 IT IS FREWARE. YOU MAY USE AND CHANGE
 SOURCE CODE AS YOU WANT. 
 IF USE THIS PACK IN COMMERCIAL APPLICATIONS
 YOU MUST INCLUDE INFORMATION ABOUT YUPACK AUTHOR


Mail to yusoft@i-connect.ru
        yusoft@chat.ru
http://www.chat.ru/~yusoft

  Roman Yugov, freelance client-server database programmer

  
                 *history*
 June 25, 1998 v1.0 - First public release
 June 26, 1998 v1.1 - TYusoftLabel paint bag was removed
 June 29, 1998 v1.2 - Final release :-)
 September 26, 1998 v2.0  - Full rewritten, added new components
 October 3, 1998 v2.1 - Credits to Bjoern was added
                        TYusoftLabel paint method was improved 
 January 15, 1999 v2.99 - Full rewritten again
                          All extended properties names was ripped, sorry
 January 16, 1999 v2.99+ - Some stupid bugs was removed
 }
unit yupack;

{$I yu.INC}
interface

uses Windows, Messages, Classes, Controls, Forms, Graphics,
  ExtCtrls, buttons, stdctrls, menus;

const
  YTM_FIRST = WM_USER + 110;
  YTM_ENABLEDCHANGENOTIFY = YTM_FIRST + 1;
  YTM_MOUSEENTERNOTIFY    = YTM_FIRST + 2;
  YTM_MOUSELEAVENOTIFY    = YTM_FIRST + 3;
  YTM_LBUTTONDOWNNOTIFY   = YTM_FIRST + 4;
  YTM_LBUTTONUPNOTIFY     = YTM_FIRST + 5;
type
    myrgb=record
       r:byte;
       g:byte;
       b:byte;
    end;

    TTextStyle=(tsNone, tsRaised1, tsRaised2, tsRecessed1, tsRecessed2, taShadow);
    TYusoftButtonState=(ysUp, ysDown, ysMouseOver);

    TLabelState=class(TPersistent)
    private
      FActive      : Boolean;
      FBorderColor : TColor;
      FBorderWidth : Byte;
      FTextStyle   : TTextStyle;
      FShadowColor : TColor;
      FShadowWidth : Byte;
      FOnChange    : TNotifyEvent;
      procedure SetActive(Value:Boolean);
      procedure SetBorderColor(Value:TColor);
      procedure SetShadowColor(Value:TColor);
      procedure SetBorderWidth(Value:Byte);
      procedure SetShadowWidth(Value:Byte);
      procedure SetTextStyle(Value:TTextStyle);
      procedure Changed;
    public
      constructor Create(aOnChange: TNotifyEvent);
      procedure Assign(Source:TPersistent);override;
      property OnChange: TNotifyEvent read FOnChange write FOnChange;
    published
      property Active:Boolean read FActive write SetActive;
      property BorderColor : TColor read FBorderColor write SetBorderColor;
      property BorderWidth : Byte read FBorderWidth write SetBorderWidth;
      property TextStyle   : TTextStyle read FTextStyle write SetTextStyle;
      property ShadowColor : TColor read FShadowColor write SetShadowColor;
      property ShadowWidth : Byte read FShadowWidth write SetShadowWidth;
    end;

    TYuSoftButton=class;

    TYuSoftLabel = class(TCustomLabel)
    private
        FCanReceive       : Boolean;
        FMouse           : Boolean;
        FClick           : Boolean;
        FOnMouseBehavior : TLabelState;
        FOnClickBehavior : TLabelState;
        FOnNormalBehavior: TLabelState;
        FOnMouseEnter    : TNotifyEvent;
        FOnMouseLeave    : TNotifyEvent;
        FTransparent     : Boolean;
        FYusoftButton    : TYusoftButton;
        procedure LabelStateChanged(Sender: Tobject);
        procedure SetOnMouseBehavior(Value:TLabelState);
        procedure SetOnClickBehavior(Value:TLabelState);
        procedure SetOnNormalBehavior(Value:TLabelState);
        procedure SetTransparent(Value: Boolean);
        procedure SetYusoftButton(Value:TYusoftButton);
    protected
        procedure Paint; override;
        procedure DoDrawMyText(const aCanvas:TCanvas;var Rect: TRect; Flags: Longint);
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
        procedure CMLButtonDown(var Message: TMessage); message WM_LBUTTONDOWN;
        procedure CMLButtonUp(var Message: TMessage); message WM_LBUTTONUP;
        procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
        procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
        procedure YTMEnabledChangeNotify(var Message: TMessage); message YTM_ENABLEDCHANGENOTIFY;
        procedure YTMMouseEnterNotify(var Message: TMessage); message YTM_MOUSEENTERNOTIFY;
        procedure YTMMouseLeaveNotify(var Message: TMessage); message YTM_MOUSELEAVENOTIFY;
        procedure YTMLButtonDownNotify(var Message: TMessage); message YTM_LBUTTONDOWNNOTIFY;
        procedure YTMLButtonUpNotify(var Message: TMessage); message YTM_LBUTTONUPNOTIFY;
    public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
    published
        property Align;
        property Alignment;
        property AutoSize;
        property Color;
        Property Caption;
        property Enabled;
        property DragCursor;
        property DragMode;
        Property Font;
        property FocusControl;
        property Layout;
        property ParentColor;
        property ParentFont;
        property ParentShowHint;
        property PopupMenu;
        property ShowAccelChar;
        property ShowHint;
        property Visible;
        property WordWrap;
        property OnClick;
        property OnDblClick;
        property OnDragDrop;
        property OnDragOver;
        property OnMouseDown;
        property OnMouseMove;
        property OnMouseUp;
        property OnStartDrag;
        {$IFDEF VER120}
        property Anchors;
        property BiDiMode;
        property Constraints;
        property DragKind;
        property ParentBiDiMode;
        property OnEndDock;
        property OnEndDrag;
        property OnStartDock;
        {$ENDIF VER120}

        property OnMouseEnterState:TLabelState read FOnMouseBehavior write SetOnMouseBehavior;
        property OnClickState:TLabelState read FOnClickBehavior write SetOnClickBehavior;
        property OnExtendedState:TLabelState read FOnNormalBehavior write SetOnNormalBehavior;
        property Transparent:Boolean read FTransparent write SetTransparent;
        property YusoftButton:TYusoftButton read FYusoftButton write SetYusoftButton;
  end;

    TYuSoftButton=class(TGraphicControl)
    private
      FClick          : Boolean;
      FMouse          : Boolean;
      FUpImage        : TBitmap;
      FDownImage      : TBitmap;
      FMouseOverImage : TBitmap;
      FDisabledImage  : TBitmap;
      FStretch        : Boolean;
      FTransparent    : Boolean;
      FTransColor     : TColor;
      FOnMouseEnter   : TNotifyEvent;
      FOnMouseLeave   : TNotifyEvent;
      FState          : TYusoftButtonState;
      procedure SetState(Value:TYusoftButtonState);
      procedure SetUpImage(Value: TBitmap);
      procedure SetDownImage(Value: TBitmap);
      procedure SetMouseOverImage(Value: TBitmap);
      procedure SetDisabledImage(Value: TBitmap);
      procedure SetStretch(Value: Boolean);
      procedure SetTransparent(Value: Boolean);
      procedure SetTransColor(Value: TColor);
      procedure CMLButtonDown(var Message: TMessage); message WM_LBUTTONDOWN;
      procedure CMLButtonUp(var Message: TMessage); message WM_LBUTTONUP;
      procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
      procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
      procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      property State:TYusoftButtonState read FState write SetState;
    protected
      procedure Paint;override;
      procedure Check;
    published
       property Stretch:Boolean read FStretch write SetStretch;
       property UpImage:TBitmap read FUpImage write SetUpImage;
       property DownImage:TBitmap read FDownImage write SetDownImage;
       property MouseOverImage:TBitmap read FMouseOverImage write SetMouseOverImage;
       property DisabledImage:TBitmap read FDisabledImage write SetDisabledImage;
       property TransparentColor:TColor read FTransColor write SetTransColor;
       property Transparent:boolean read FTransparent write SetTransparent;
       property OnMouseEnter:TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
       property OnMouseLeave:TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
       property Align;
       property Visible;
       property ShowHint;
       property Enabled;
       property OnClick;
       property OnDblClick;
       property OnMouseMove;
       property OnStartDrag;
       property	OnDragDrop;
       property	OnDragOver;
       property OnEndDrag;
       property	OnMouseDown;
       property	OnMouseUp;

       {$IFDEF VER120}
       property Anchors;
       property BiDiMode;
       property Constraints;
       property DragKind;
       property ParentBiDiMode;
       property OnEndDock;
       property OnStartDock;
       {$ENDIF VER120}
    end;



  TYusoftWallpaper=class(TGraphicControl)
  protected
    FImage           : TBitmap;
    procedure Paint; override;
    procedure SetImage(Value: TBitMap);
{$W -}
//    procedure loaded;override;
{$W +}
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    property Bitmap:TBitmap read FImage write SetImage;
    property Height default 100;
    property Width  default 100;
    property Visible;
    property Align default alClient;
    property Enabled;
    property ParentShowHint;
    property ShowHint;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    {$IFDEF VER120}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
    {$ENDIF VER120}

  end;


  TYusoftGradientButton = class(tgraphiccontrol)
  private
    FVertical            : Boolean;
    FSColor              : TColor;
    FEColor              : TColor;
    FBevel               : Integer;
    FFlat                : Boolean;
    FSpacing             : Integer;
    Transclr             : TColor;
    Gwidth               : Integer;
    Drawframe            : Boolean;
    FGlyph               : TBitmap;
    FGray                : Boolean;
    FPopupmark           : Boolean;
    FDown                : Boolean;
    FGroupindex          : Integer;
    FAllup               : Boolean;
    FPopupmenu           : TPopupMenu;
    FLayout              : TButtonLayout;
    FMouseEnter          : TNotifyEvent;
    FMouseLeave          : TNotifyEvent;
    FWindowCaption       : Boolean;
    procedure SetSColor(Value: TColor); virtual;
    procedure SetEColor(Value: TColor); virtual;
    procedure Setbevel(Value: Integer);
    procedure SetSpacing(Value: Integer);
    procedure SetFlat(Value: Boolean);
    procedure SetGray(Value: Boolean);
    procedure SetMark(Value: Boolean);
    procedure SetLayout(Value: TButtonlayout);
    procedure SetGlyph(Value: TBitmap);
    procedure SetPopup(Value: TPopupMenu);
    procedure SetDown(Value: Boolean);
    procedure SetGroupIndex(Value:Integer);
//    procedure SetAllUp(Value:Boolean);
    procedure InternalPaint(var Buffer:TBitmap);
    procedure Setvertical(Value: Boolean);
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    FState: TButtonState;
    procedure Loaded;override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override ;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property LightColor:tcolor read fscolor write setscolor;
    property ShadowColor:tcolor read fecolor write setecolor;
    property Glyph:tbitmap read fglyph write setglyph;
    property DropDownMenu:tpopupmenu read fpopupmenu write setpopup;
    property GrayedInactive:boolean read fgray write setgray;
    property Caption;
    property Layout:tbuttonlayout read flayout write setlayout;
    property BevelWidth:integer read fbevel write setbevel default 1;
    property Font;
    property Down:boolean read fdown write setdown;
    property GroupIndex:integer read fgroupindex write setgroupindex;
    property AllowAllUp:boolean read fallup write fallup;
    property Flat:boolean read fflat write setflat default false;
    property MarkDropDown:boolean read fpopupmark write setmark;
    property Spacing:Integer read fspacing write setspacing default 1;
    property Vertical:boolean read fvertical write setvertical;
    property WindowCaption:Boolean read FWindowCaption write FWindowCaption;
    property OnMouseEnter:TNotifyEvent read FMouseEnter write FMouseEnter;
    property OnMouseLeave:TNotifyEvent read FMouseLeave write FMouseLeave;
    property Enabled;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property ShowHint;
    property ParentFont;
    property ParentShowHint;

    {$IFDEF VER120}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnEndDrag;
    property OnStartDock;
    {$ENDIF VER120}
  end;



const PaletteMask = $02000000;
procedure DrawBitmapTransparent(Dest: TCanvas; DstX, DstY: Integer;
  Bitmap: TBitmap; TransparentColor: TColor);
procedure DrawBitmapRectTransparent(Dest: TCanvas; DstX, DstY: Integer;
  SrcRect: TRect; Bitmap: TBitmap; TransparentColor: TColor);
procedure StretchBitmapRectTransparent(Dest: TCanvas; DstX, DstY, DstW,
  DstH: Integer; SrcRect: TRect; Bitmap: TBitmap; TransparentColor: TColor);
procedure mygrayedbmp(var bmp1:tbitmap;const c1,c2:tcolor);
procedure myDrawButtonFace(Canvas: TCanvas; const Client: TRect;
  BevelWidth: Integer; IsDown:boolean;c1,c2:tcolor);
procedure Register;

implementation

procedure Register;
begin
   RegisterComponents('YuPack', [TYuSoftButton]);
   RegisterComponents('YuPack', [TYuSoftLabel]);
   RegisterComponents('YuPack', [TYuSoftWallpaper]);
   RegisterComponents('YuPack', [TYuSoftGradientButton]);
end;

procedure Notify(Ctrl: TControl; Msg: Integer; lParam: Integer);
var
   Message: TMessage;
begin
   Message.Msg := Msg;
   Message.WParam := LongInt(Ctrl);
   Message.LParam := lParam;
   Message.Result := 0;
   Ctrl.Parent.Broadcast(Message);
end;

{***************************************************
*              TLabelState Class                   *
****************************************************}

constructor TLabelState.Create( aOnChange: TNotifyEvent);
begin
  FActive:=True;
  FShadowColor:=clBtnShadow;
  FBorderColor:=clBtnHighlight;
  FOnChange := aOnChange;
end;

procedure TLabelState.Assign(Source:TPersistent);
begin
  with Source as TLabelState do
  begin
    Self.FBorderColor:=BorderColor;
    Self.FBorderWidth:=BorderWidth;
    Self.FTextStyle:=TextStyle;
    Self.FShadowColor:=ShadowColor;
    Self.FShadowWidth:=ShadowWidth;
  end;
  //Changed;
end;

procedure TLabelState.Changed;
begin
   if Assigned(FOnChange) then  FOnChange(self);
end;

procedure TLabelState.SetActive(Value: Boolean);
begin
  if FActive<>Value then
  begin
    FActive:=Value;
    Changed;
  end;
end;

procedure TLabelState.SetShadowWidth(Value: Byte);
begin
  if (Value in [0..9]) then
  begin
    if FShadowWidth<>Value then
    begin
      FShadowWidth := Value;
      Changed;
    end;
  end;
end;

procedure TLabelState.SetBorderWidth(Value: Byte);
begin
  if (Value in [0..9]) then
  begin
    if FBorderWidth<>Value then
    begin
      FBorderWidth := Value;
      Changed;
    end;
  end;
end;

procedure TLabelState.SetBorderColor(Value:TColor);
begin
  if FBorderColor<>Value then
  begin
    FBorderColor:= Value;
    Changed;
  end;
end;

procedure TLabelState.SetShadowColor(Value:TColor);
begin
  if FShadowColor<>Value then
  begin
    FShadowColor:= Value;
    Changed;
  end;
end;

procedure TLabelState.SetTextStyle(Value:TTextStyle);
begin
  if FTextStyle<>Value then
  begin
    FTextStyle:=Value;
    Changed;
  end;
end;


{***************************************************
*                TYusoftLabel                      *
****************************************************}

constructor TYuSoftLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  FCanReceive:=True;
  FMouse:=False;
  FClick:=False;
  FOnMouseBehavior:=TLabelState.Create(LabelStateChanged);
  FOnClickBehavior:=TLabelState.Create(LabelStateChanged);
  FOnClickBehavior.Active:=False;
  FOnMouseBehavior.BorderWidth:=1;
  FOnNormalBehavior:=TLabelState.Create(LabelStateChanged);
end;

destructor TYuSoftLabel.Destroy;
begin
  FOnMouseBehavior.Free;
  FOnClickBehavior.Free;
  FOnNormalBehavior.Free;
  inherited Destroy;
end;


procedure TYusoftLabel.LabelStateChanged(Sender: Tobject);
begin
  Invalidate;
end;

procedure TYusoftLabel.SetTransparent(Value: Boolean);
begin
  if FTransparent <> Value then
  begin
    FTransparent:=Value;
    if Value then ControlStyle := ControlStyle - [csOpaque]
      else  ControlStyle := ControlStyle + [csOpaque];
      Invalidate;
   end;
end;

procedure TYusoftLabel.SetYusoftButton(Value:TYusoftButton);
begin
  if FYusoftButton<> Value then  FYusoftButton:=Value;
  if Value<>nil then Enabled:=FYusoftButton.Enabled;
end;

procedure TYuSoftLabel.SetOnMouseBehavior(Value:TLabelState);
begin
  if FOnMouseBehavior<>Value then  FOnMouseBehavior.Assign(Value);
end;

procedure TYuSoftLabel.SetOnClickBehavior(Value:TLabelState);
begin
  if FOnClickBehavior<>Value then FOnClickBehavior.Assign(Value);
end;

procedure TYuSoftLabel.SetOnNormalBehavior(Value:TLabelState);
begin
  if FOnNormalBehavior<>Value then   FOnNormalBehavior.Assign(Value);
end;

procedure TYuSoftLabel.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FMouse:=True;
  FCanReceive:=False;
  if (Enabled and FOnMouseBehavior.Active and (not FClick)) then Refresh;
  if FYusoftButton<>nil then FYusoftButton.Perform(CM_MOUSEENTER,0,0);
  if Assigned (FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TYuSoftLabel.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FMouse:=False;
  if (Enabled and FOnMouseBehavior.Active and (not FClick)) then Refresh;
  if (FYusoftButton<>nil) and (not FClick) then FYusoftButton.Perform(CM_MOUSELEAVE,0,0);
  FCanReceive:=True;
  if Assigned (FOnMouseLeave) then FOnMouseLeave(Self);
end;

procedure TYuSoftLabel.CMLButtonDown(var Message: TMessage);
begin
  inherited;
  FClick:=True;
  FCanReceive:=False;
  if FYusoftButton<>nil then FYusoftButton.State:=ysDown;
  if (Enabled and FOnClickBehavior.Active) then Refresh;
end;

procedure TYuSoftLabel.CMLButtonUP(var Message: TMessage);
begin
  inherited;
  FClick:=False;
  if (Enabled and FOnClickBehavior.Active) then Refresh;
  if FYusoftButton<>nil then
  begin
    if FMouse then  FYusoftButton.State:=ysMouseOver
      else  FYusoftButton.State:=ysUp;
  end;
  FCanReceive:=True;
end;

procedure TYusoftLabel.Notification(AComponent: TComponent; Operation: TOperation);
begin
   inherited Notification(AComponent, Operation);
   if (Operation = opRemove) and (AComponent = FYusoftButton) then
      FYusoftButton := nil;
end;

procedure TYusoftLabel.YTMEnabledChangeNotify(var Message: TMessage);
begin
  if (FYusoftButton<> nil) and (Message.Result = 0) and (Message.WParam = LongInt(FYusoftButton)) then
  begin
    Enabled := Boolean(Message.LParam);
    Message.Result := 1;
  end;
end;

procedure TYusoftLabel.YTMMouseEnterNotify(var Message: TMessage);
begin
  if FCanReceive and (FYusoftButton<> nil) and (Message.Result = 0) and (Message.WParam = LongInt(FYusoftButton)) then
  begin
    Message.Result := 1;
    FMouse:=True;
    if (Enabled and FOnMouseBehavior.Active and (not FClick)) then Refresh;
  end;
end;

procedure TYusoftLabel.YTMMouseLeaveNotify(var Message: TMessage);
begin
  if FCanReceive and (FYusoftButton <> nil) and (Message.Result = 0) and (Message.WParam = LongInt(FYusoftButton)) then
  begin

    FMouse:=False;
    if (Enabled and FOnMouseBehavior.Active and (not FClick)) then Refresh;
  end;
end;

procedure TYusoftLabel.YTMLButtonDownNotify(var Message: TMessage);
begin
  if FCanReceive and (FYusoftButton <> nil) and (Message.Result = 0) and (Message.WParam = LongInt(FYusoftButton)) then
  begin
    Message.Result := 1;
    FClick:=True;
    if (Enabled and FOnClickBehavior.Active) then Invalidate;
  end;
end;

procedure TYusoftLabel.YTMLButtonUpNotify(var Message: TMessage);
begin
  if FCanReceive and (FYusoftButton <> nil) and (Message.Result = 0) and (Message.WParam = LongInt(FYusoftButton)) then
  begin
    Message.Result := 1;
    FClick:=False;
    if (Enabled and FOnClickBehavior.Active) then Invalidate;
  end;
end;

procedure TYuSoftLabel.Paint;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  ULColor, LRColor:TColor;
  TempRect, Rect, CalcRect:TRect;
  DrawStyle:Longint;
  Bmp:TBitmap;
  TempVarX, TempVarY:Byte;
  CurrentLabelState:TLabelState;
begin
  Bmp:=TBitmap.Create;
  try
    Bmp.Width:=Width;
    Bmp.Height:=Height;
    with Bmp.Canvas do
    begin
      Brush.Color:=Self.Color;
      Brush.Style:=bsSolid;
      FillRect(ClientRect);
      FillRect(Rect);
      Brush.Style:=bsClear;
      Rect:=ClientRect;
      DrawStyle:= DT_EXPANDTABS or WordWraps[WordWrap] or Alignments[Alignment];
      if Layout <> tlTop then
      begin
        CalcRect := Rect;
        DoDrawMyText(Bmp.Canvas, CalcRect, DrawStyle or DT_CALCRECT);
        if Layout = tlBottom then OffsetRect(Rect, 0, Height - CalcRect.Bottom)
          else OffsetRect(Rect, 0, (Height - CalcRect.Bottom) div 2);
      end;

      Font:=Self.Font;

      if FClick then CurrentLabelState:=FOnClickBehavior
        else if FMouse then   CurrentLabelState:=FOnMouseBehavior
          else  CurrentLabelState:=FOnNormalBehavior;

      if Enabled then
      begin
        UlColor:=clBtnHighLight;
        LrColor:=clBtnShadow;
        if CurrentLabelState.TextStyle in [tsRecessed1, tsRaised1, tsRecessed2, tsRaised2] then
        begin
          case CurrentLabelState.TextStyle of
            tsRaised1, tsRaised2:
            begin
              UlColor:=clBtnHighLight;
              LrColor:=clBtnShadow;
            end;
            tsRecessed1, tsRecessed2:
            begin
              LrColor:=clBtnHighLight;
              UlColor:=clBtnShadow;
            end;
          end;

          case  CurrentLabelState.TextStyle of
            tsRaised1, tsRecessed1:
            begin
              TempRect:=Rect;
              OffsetRect(TempRect,1,1);
              Font.Color:=LRColor;
              DoDrawMyText(Bmp.Canvas,TempRect,DrawStyle);

              TempRect:=Rect;
              OffsetRect(TempRect,-1,-1);
              Font.Color:=ULColor;
              DoDrawMyText(Bmp.Canvas,TempRect,DrawStyle);
            end;
            tsRaised2, tsRecessed2:
            begin
              TempRect:=Rect;
              OffsetRect(TempRect,-1,1);
              Font.Color:=LRColor;
              DoDrawMyText(BMP.Canvas,TempRect,DrawStyle);

              TempRect:=Rect;
              OffsetRect(TempRect,1,-1);
              Font.Color:=ULColor;
              DoDrawMyText(Bmp.Canvas,TempRect,DrawStyle);
            end;
          end;
        end
        else
        begin
          if CurrentLabelState.TextStyle=taShadow then
          begin
            TempRect:=Rect;
            Font.Color:=CurrentLabelState.ShadowColor;
            OffsetRect(TempRect,CurrentLabelState.ShadowWidth, CurrentLabelState.ShadowWidth);
            DoDrawMyText(Bmp.Canvas,TempRect,DrawStyle);
          end;
        end;
      end;

      Brush.Style := bsClear;

      if (CurrentLabelState.BorderWidth>0) and (Enabled) then
      begin
        Font.Color := CurrentLabelState.BorderColor;

        for TempVarX:=1 to CurrentLabelState.BorderWidth do
        begin
          for TempVarY:=1 to  CurrentLabelState.BorderWidth do
          begin
            TempRect:=Rect;
            OffsetRect(TempRect,TempVarX,TempVarY);
            DoDrawMyText(Bmp.Canvas,TempRect,DrawStyle);
            TempRect:=Rect;
            OffsetRect(TempRect,TempVarX,-TempVarY);
            DoDrawMyText(Bmp.Canvas,TempRect,DrawStyle);
            TempRect:=Rect;
            OffsetRect(TempRect,-TempVarX,TempVarY);
            DoDrawMyText(Bmp.Canvas,TempRect,DrawStyle);
            TempRect:=Rect;
            OffsetRect(TempRect,-TempVarX,-TempVarY);
            DoDrawMyText(Bmp.Canvas,TempRect,DrawStyle);
          end;
        end;
      end;

      Font.Color:=Self.Font.Color;
      DoDrawMyText(Bmp.Canvas,Rect,DrawStyle);
    end;

    if FTransparent then  DrawBitmapTransparent(Canvas, 0, 0, Bmp, Self.Color)
      else BitBlt(Canvas.Handle,0,0,Width,Height,Bmp.Canvas.Handle,0,0,SRCCOPY);
  finally
    Bmp.Free;
  end;
end;

procedure TYuSoftLabel.DoDrawMyText(const aCanvas:TCanvas;var Rect: TRect; Flags: Longint);
var
  Text: string;
begin
  Text := GetLabelText;
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and
    (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
  if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;

  {$IFDEF VER120}
  Flags := DrawTextBiDiModeFlags(Flags);
  {$ENDIF VER120}

  if not Enabled then
  begin
    OffsetRect(Rect, 1, 1);
    aCanvas.Font.Color := clBtnHighlight;
    DrawText(aCanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
    OffsetRect(Rect, -1, -1);
    aCanvas.Font.Color := clBtnShadow;
    DrawText(aCanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end
  else
    DrawText(aCanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
end;


{***************************************************
*                TYusoftButton                     *
****************************************************}

constructor TYuSoftbutton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle+[csOpaque];
  Width:=50;
  Height:=50;
  FUpImage:=TBitmap.Create;
  FDownImage:=TBitmap.Create;
  FMouseOverImage:=TBitmap.Create;
  FDisabledImage:=TBitmap.Create;
  FStretch:=False;
  FTransColor:=clWhite;
  FTransparent:=False;
end;

destructor TYuSoftbutton.destroy;
begin
  FUpimage.Free;
  FDownImage.Free;
  FMouseOverImage.Free;
  FDisabledImage.Free;
  inherited destroy;
end;

procedure TYuSoftbutton.SetState(Value: TYusoftButtonState);
begin
  if Value<>FState then
   begin
     FState:=Value;
     Paint;
   end;
end;

procedure TYuSoftbutton.SetStretch(Value: Boolean);
begin
  if Value<>FStretch then
   begin
     FStretch:=Value;
     Paint;
   end;
end;

procedure TYuSoftbutton.SetTransColor(Value:TColor);
begin
  if Value<>FTransColor then
  begin
    FTransColor:=Value;
    Paint;
  end;
end;

procedure TYuSoftbutton.SetTransparent(Value: Boolean);
begin
  if Value<>FTransparent then
  begin
    FTransparent:=Value;
    if FTransparent then ControlStyle:=ControlStyle - [csOpaque]
      else  ControlStyle:=ControlStyle +[csOpaque];
    Paint;
   end;
end;

procedure TYuSoftbutton.Check;
begin
  if FUpImage.Width>0 then
  begin
    if FDownImage.Width<1 then FDownImage.Assign(FUpImage);
    if FMouseOverImage.Width<1 then FMouseOverImage.Assign(FUpImage);
    if FDisabledImage.Width<1 then FDisabledImage.Assign(FUpImage);
  end;
end;

procedure TYuSoftbutton.SetupImage(Value: TBitmap);
begin
  FUpImage.Assign(Value);
  Check;
  Paint;
end;

procedure TYuSoftbutton.SetDownImage(Value: TBitmap);
begin
  FDownimage.Assign(Value);
  Paint;
end;

procedure TYuSoftbutton.SetMouseOverImage(value: tbitmap);
begin
  FMouseOverImage.Assign(Value);
  Paint;
end;

procedure TYuSoftbutton.SetDisabledImage(Value: TBitmap);
begin
  FDisabledImage.Assign(Value);
  Paint;
end;

procedure TYuSoftbutton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Notify(Self, YTM_ENABLEDCHANGENOTIFY, Ord(ENABLED));
end;

procedure TYuSoftbutton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FMouse:=True;
  if FClick then  State:=ysDown else State:=ysMouseOver;
  Notify(Self, YTM_MOUSEENTERNOTIFY, 0);
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TYuSoftbutton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FMouse:=False;
  if FClick then  State:=ysDown else State:=ysUp;
  Notify(Self, YTM_MOUSELEAVENOTIFY, 0);
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

procedure TYuSoftbutton.CMLButtonDown(var Message: TMessage);
begin
  inherited;
  if Enabled then
  begin
    FClick:=True;
    State := ysDown;
    Notify(Self, YTM_LBUTTONDOWNNOTIFY, 0);
  end;
end;

procedure TYuSoftbutton.CMLButtonUp(var Message: TMessage);
begin
  inherited;
  if Enabled then
  begin
    FClick:=False;
    if FMouse then State:= ysMouseOver else State:=ysUp;
    Notify(Self, YTM_LBUTTONUPNOTIFY, 0);
  end;
end;

procedure  TYuSoftbutton.Paint;
var
  Buffer:TBitmap;
  Rect:TRect;
begin
   if (DownImage.Width<1) or (MouseOverImage.Width<1) then Check;

   Buffer:=TBitmap.Create;
   try
     Buffer.Width:=Width;
     Buffer.Height:=Height;
     Rect:=Self.ClientRect;

     with Buffer.Canvas do
     begin
       if not FTransparent then  Brush.Color:=(Parent as TWincontrol).Brush.Color
         else  brush.color:=FTransColor;
       FillRect(Rect);

       if not FTransparent then
       begin
         if not Enabled then
         begin
           if not  FStretch then BitBlt(Handle,0,0,Width,Height,FDisabledImage.Canvas.Handle,0,0,SRCCOPY)
             else StretchDraw(Rect,FDisabledImage);
         end
         else
         begin
           case FState of
             ysUp:
             begin
               if not FStretch then BitBlt(Handle,0,0,Width,Height,FUpImage.Canvas.Handle,0,0,SRCCOPY)
                 else StretchDraw(Rect,FUpImage);
             end;
             ysDown:
             begin
               if not FStretch then BitBlt(Handle,0,0,Width,Height,FDownImage.Canvas.Handle,0,0,SRCCOPY)
                 else StretchDraw(Rect,FDownImage);
             end;
             ysMouseOver:
             begin
               if not FStretch then BitBlt(Handle,0,0,Width,Height,FMouseOverImage.Canvas.Handle,0,0,SRCCOPY)
                 else StretchDraw(Rect,FMouseOverImage);
             end;
           end;
         end
       end
       else
       begin
         if not Enabled then
         begin
           Rect.BottomRight.X:=FDisabledImage.Width;
           Rect.BottomRight.Y:=FDisabledImage.Height;
           if not FStretch then DrawBitmapTransparent(Buffer.Canvas, 0, 0, FDisabledImage, FTransColor)
             else StretchBitmapRectTransparent(Buffer.Canvas,0,0,Width,Height, Rect, FDisabledImage,FTransColor);
         end
         else
         begin
           case FState of
             ysUp:
             begin
               Rect.BottomRight.X:=UpImage.Width;
               Rect.BottomRight.Y:=UpImage.Height;
               if not FStretch then DrawBitmapTransparent(Buffer.Canvas, 0, 0, UpImage, FTransColor )
                 else StretchBitmapRectTransparent(Buffer.Canvas,0,0,Width,Height, Rect,UpImage,FTransColor);
             end;
             ysDown:
             begin
               Rect.BottomRight.X:=DownImage.Width;
               Rect.BottomRight.Y:=DownImage.Height;
               if not FStretch then DrawBitmapTransparent(Buffer.Canvas, 0, 0, DownImage, FTransColor )
                 else StretchBitmapRectTransparent(Buffer.Canvas,0,0,Width,Height, Rect,DownImage,FTransColor);
             end;
             ysMouseOver:
             begin
               Rect.BottomRight.X:=MouseOverImage.Width;
               Rect.BottomRight.Y:=MouseOverImage.Height;
               if not FStretch then DrawBitmapTransparent(Buffer.Canvas, 0, 0, MouseOverImage, FTransColor )
                 else StretchBitmapRectTransparent(Buffer.Canvas,0,0,Width,Height, Rect,MouseOverImage,FTransColor);
             end;
           end;
         end;
      end;

     if FTransparent then   DrawBitmapTransparent(canvas,0,0, Buffer, FTransColor)
         else  BitBlt(Canvas.Handle,0,0,Width,Height,Buffer.Canvas.Handle,0,0,SRCCOPY);
    end;
  finally
    Buffer.Free;
  end;
end;


{***************************************************
*               TYusoftWallpaper                   *
****************************************************}

constructor TYusoftWallpaper.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle +[csOpaque];
  FImage:=TBitMap.Create;
  Align:=alClient;
end;

destructor TYusoftWallpaper.Destroy;
begin
  FImage.Free;
  inherited Destroy;
end;


procedure TYusoftWallpaper.SetImage(Value: tbitmap);
begin
  if Assigned(Value) then  FImage.Assign(Value)
    else
    begin
      FImage.Height := 0;
      FImage.Width  := 0;
    end;
  Invalidate;
end;



{procedure TYusoftWallpaper.loaded;
begin
 inherited loaded;
 invalidate;
end;}

procedure TYusoftWallpaper.paint;
var
Buffer:TBitmap;
x,y:Integer;
begin
  Buffer:=TBitmap.Create;
  try
    Buffer.Width:=Width;
    Buffer.Height:=Height;
    if FImage.Width>0 then
    begin
      y:=0;
      while y<Height do
      begin
        x:=0;
        while x<Width do
        begin
          BitBlt(Buffer.Canvas.Handle,x,y,FImage.Width,FImage.Height,FImage.Canvas.Handle,0,0,SRCCOPY);
          inc(x,FImage.Width);
        end;
        inc(y,FImage.Height);
      end;
      BitBlt(Canvas.Handle,0,0,Width,Height,Buffer.Canvas.Handle,0,0,SRCCOPY);
    end;
  finally
    Buffer.free;
  end;
end;


{***************************************************
*           TYusoftGradientButton                  *
****************************************************}

constructor TYusoftGradientButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csClickEvents, csCaptureMouse, csOpaque, csDoubleClicks];
  FPopupmenu:=nil;
  Width:=25;
  Height:=25;
  FGroupIndex:=0;
  FSColor:=clBtnHighlight;
  FEColor:=clBtnShadow;
  FBevel:=1;
  FSpacing:=1;
  FLayout:=blGlyphTop;
  FGray:=True;
  Drawframe:=True;
  FGlyph:=TBitmap.Create;
end;

destructor TYusoftGradientButton.Destroy;
begin
  FGlyph.Free;
  inherited destroy;
end;

procedure TYusoftGradientButton.Loaded;
begin
  inherited loaded;
  SetGlyph(FGlyph);
end;

procedure TYusoftGradientButton.SetLayout(Value: TButtonLayout);
begin
  if Value<>FLayout then
  begin
    FLayout:=Value;
    Invalidate;
  end;
end;

procedure TYusoftGradientButton.SetPopup(value: TPopupMenu);
begin
  FPopupmenu := Value;
  if FPopupmark then Invalidate;
end;

procedure TYusoftGradientButton.SetSColor(value: TColor);
begin
  if Value<>FSColor then
  begin
    FSColor:=Value;
    Invalidate;
  end;
end;


procedure TYusoftGradientButton.SetGray(Value: Boolean);
begin
  if Value<>FGray then
  begin
    FGray:=Value;
    Invalidate;
  end;
end;

procedure TYusoftGradientButton.SetDown(Value: Boolean);
var
 i: Integer;
 otherbutton: TYusoftGradientButton;
begin
  if FDown = Value then Exit;
  if FGroupIndex <> 0 then
  begin
    FDown := Value;
    Invalidate;
    if FDown = True then
    begin
      for i := 0 to Parent.ControlCount - 1 do
      begin
        if Parent.Controls[i] is TYusoftGradientButton then
        begin
          otherbutton := (Parent.Controls[i] as TYusoftGradientButton);
          if (otherbutton <> Self) and (otherbutton.GroupIndex = GroupIndex) and (otherbutton.FDown = True) then
          begin
            otherbutton.FDown := False;
            otherbutton.Invalidate;
          end
        end
      end
    end
  end
end;

{procedure TYusoftGradientButton.SetAllUp(Value:Boolean);
var
  i: Integer;
  otherbutton: TYusoftGradientButton;
begin
  FAllUp := value;
  if FGroupIndex <> 0 then
  begin
    for i := 0 to Parent.ControlCount - 1 do
    begin
      if Parent.Controls[i] is TYusoftGradientButton then
      begin
        otherbutton := (Parent.Controls[i] as TYusoftGradientButton);
        if (otherbutton <> Self) and (otherbutton.GroupIndex = GroupIndex) then otherbutton.FAllUp := Value;
      end
    end
  end
end;}

procedure TYusoftGradientButton.SetGroupIndex(Value:Integer);
begin
  if FGroupIndex = value then Exit;
  FGroupIndex := Value;
  if (FGroupIndex = 0) and FDown then
  begin
    FDown := False;
    Invalidate;
  end;
end;


procedure TYusoftGradientButton.SetFlat(Value: Boolean);
begin
  FFlat:=Value;
  if Value=False then DrawFrame:=True else DrawFrame:=False;
  Invalidate;
end;

procedure TYusoftGradientButton.SetMark(Value: Boolean);
begin
  if Value<>FPopupmark then
  begin
    FPopupmark:=Value;
    Invalidate;
  end;
end;

procedure TYusoftGradientButton.SetGlyph(value: tbitmap);
begin
  if (Value<>nil) and (Value.Height<>0) then
  begin
    FGlyph.Assign(Value);
    Transclr:=Value.transparentcolor;
  end
  else gwidth:=0;
  Invalidate;
end;


procedure TYusoftGradientButton.Notification(AComponent: TComponent; Operation:
TOperation);
begin
  if (operation = opRemove) and (AComponent = fpopupmenu) then FPopupmenu := nil;
end;

procedure TYusoftGradientButton.CMDialogChar(var Message: TCMDialogChar);
var
  pos:tpoint;
begin
  with Message do
  begin
    if IsAccel(CharCode, Caption)and Enabled and Visible then
    begin
      GetCursorPos(pos);
      pos:=ScreenToClient(pos);
      Application.ProcessMessages;
      MouseDown(mbleft,[ssleft],pos.x,pos.y);
      Application.ProcessMessages;
      MouseUp(mbleft,[ssleft],pos.x,pos.y);
      Application.ProcessMessages;
      Click;
      Result := 1;
    end;
  end;
end;

procedure TYusoftGradientButton.CMMouseEnter(var Message: TMessage);
begin
  DrawFrame:=true;
  if ((FFlat) and (Enabled)) then Repaint;
  if Assigned(FMouseEnter) then FMouseEnter(Self);
end;

procedure TYusoftGradientButton.CMMouseLeave(var Message: TMessage);
begin
  if FFlat then DrawFrame:=False else DrawFrame:=True;
  if ((FFlat) and (Enabled)) then Repaint;
  if Assigned(FMouseLeave) then FMouseLeave(Self);
end;

procedure TYusoftGradientButton.CMFontChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TYusoftGradientButton.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TYusoftGradientButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var pos:tpoint;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if ((Button = mbLeft) and (Enabled) and (not FWindowCaption)) then
  begin
    FState := bsDown;
    Repaint;
    if Fpopupmenu<>nil then
    begin
      Application.ProcessMessages;
      if FFlat then DrawFrame:=False else DrawFrame:=True;
      FState := bsUp;
      Repaint;
      pos:=ClientToScreen(Point(0, Height));
      FPopupmenu.Popup(pos.x,pos.y);
    end;
  end;
end;

procedure TYusoftGradientButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if ((Button = mbLeft) and (Enabled) and (not FWindowCaption)) then
  begin
    FState:= bsUp;
    Repaint;
  end;
end;

procedure TYusoftGradientButton.SetSpacing(Value: Integer);
begin
  FSpacing:=Value;
  Invalidate;
end;

procedure TYusoftGradientButton.SetBevel(Value: Integer);
begin
  if FBevel<>Value then
  begin
    FBevel:=value;
    Invalidate;
  end;
end;

procedure TYusoftGradientButton.SetEColor(Value: TColor);
begin
  FEColor:=Value;
  Invalidate;
end;

procedure TYusoftGradientButton.internalpaint(var buffer:tbitmap);
var
  _rect  :TRect;
  gleft,gtop,tleft,ttop,totalh,adjust2:integer;
begin
  tleft:=0;
  ttop:=0;
  gleft:=0;
  gtop:=0;

  buffer.canvas.font:=self.font;
  if FPopupmark AND (FPopupmenu<>nil) then
    adjust2:=4 else adjust2:=0;

  totalh:=FGlyph.height+buffer.canvas.textheight(caption)+2+spacing;

  case layout of
     blglyphtop:   begin
                     tleft:=width div 2 - buffer.canvas.textwidth(caption) div 2-adjust2;
                     ttop:=height div 2 - totalh div 2+fglyph.height+spacing;
                     gleft:=width div 2 - gwidth div 2;
                     gtop:=ttop - fglyph.height -spacing;
                     //mleft:=tleft+buffer.canvas.textwidth(caption)+2+adjust2 div 2;
                   end;
     blglyphbottom:begin
                     ttop:=height div 2 - totalh div 2;
                     tleft:=width div 2 - buffer.canvas.textwidth(caption) div 2-adjust2;
                     gleft:=width div 2 - gwidth div 2;
                     gtop:=ttop + fglyph.height + spacing;
                     //mleft:=tleft+buffer.canvas.textwidth(caption)+2+adjust2 div 2;
                   end;
     blglyphleft:  begin
                     if FGlyph.Width>0 then  tleft:=width div 2-buffer.canvas.textwidth(caption) div 2+gwidth div 2+spacing
                       else tleft:=width-buffer.canvas.textwidth(caption)-spacing ;
                     ttop:=height div 2 - buffer.canvas.textheight(caption) div 2;
                     gleft:=tleft-spacing-gwidth;
                     gtop:=height div 2 - fglyph.height div 2;
                     //mleft:=tleft+buffer.canvas.textwidth(caption)+2;
                   end;
     blglyphright: begin
                     if FGlyph.Width>0 then  tleft:=width div 2-buffer.canvas.textwidth(caption) div 2-spacing-gwidth div 2
                       else tleft:=spacing;
                     ttop:=height div 2 - buffer.canvas.textheight(caption) div 2;
                     gleft:=width div 2+buffer.canvas.textwidth(caption) div 2+spacing-gwidth div 2;
                     gtop:=height div 2 - fglyph.height div 2;
                     //mleft:=tleft-4;
                   end;
     end;

  //drawtext
  with buffer.canvas do
  begin
    _rect:=rect(tleft,ttop,width-bevelwidth-1-adjust2,height);
    brush.style:=bsclear;
    DrawText(Handle, PChar(caption), Length(caption), _Rect, dt_left or dt_noclip) ;
   end;

  if (FGlyph<>nil) and (FGlyph.height<>0) then
     DrawBitmapTransparent(buffer.Canvas,  gleft, gtop, fglyph, transclr );


  _rect:=clientrect;
  if DrawFrame AND Flat then
  begin
     if not((FState=bsDown) OR FDown) then
      Frame3D(buffer.Canvas, _rect, lightcolor, shadowcolor, bevelwidth)
  end
  else Frame3D(buffer.Canvas, _rect, shadowcolor, lightcolor, bevelwidth);

  if (not Flat) and (BevelWidth>0) then
                  myDrawButtonFace(buffer.canvas,clientrect,bevelwidth,
                  fdown or (fstate=bsdown) ,shadowcolor, lightcolor);
end;



procedure TYusoftgradientbutton.SetVertical(value: boolean);
begin
  FVertical:=value;
  Repaint;
end;


procedure TYusoftgradientbutton.Paint;
var
    x:integer;
    _a,_b,_c:myrgb;
    buffer:tbitmap;
begin

  buffer:=tbitmap.create;
  buffer.width:=width;
  buffer.height:=height;

  _a.r:=getrvalue(colortorgb(fscolor));
  _a.g:=getgvalue(colortorgb(fscolor));
  _a.b:=getbvalue(colortorgb(fscolor));


  _b.r:=getrvalue(colortorgb(fecolor));
  _b.g:=getgvalue(colortorgb(fecolor));
  _b.b:=getbvalue(colortorgb(fecolor));


  buffer.canvas.pen.style:=pssolid;
  buffer.canvas.pen.width:=1;

  if not fvertical then
    for x:=0 to width do
      with buffer.canvas do
        begin
          if _a.r<_b.r then  _c.r:=_a.r+round(((_b.r-_a.r) / width)*x)
            else _c.r:=_a.r-round(((_a.r-_b.r) / width)*x);
          if _a.g<_b.g then   _c.g:=_a.g+round(((_b.g-_a.g) / width)*x)
            else _c.g:=_a.g-round(((_a.g-_b.g) / width)*x);
          if _a.b<_b.b then   _c.b:=_a.b+round(((_b.b-_a.b) / width)*x)
            else _c.b:=_a.b-round(((_a.b-_b.b) / width)*x);
          pen.color:=rgb(_c.r,_c.g,_c.b);
          moveto(x,0);
          lineto(x,height);
       end
      else
       for x:=0 to height do
         with buffer.canvas do
           begin
             if _a.r<_b.r then  _c.r:=_a.r+round(((_b.r-_a.r) / height)*x)
               else _c.r:=_a.r-round(((_a.r-_b.r) / height)*x);
             if _a.g<_b.g then   _c.g:=_a.g+round(((_b.g-_a.g) / height)*x)
               else _c.g:=_a.g-round(((_a.g-_b.g) / height)*x);
             if _a.b<_b.b then   _c.b:=_a.b+round(((_b.b-_a.b) / height)*x)
               else _c.b:=_a.b-round(((_a.b-_b.b) / height)*x);
             pen.color:=rgb(_c.r,_c.g,_c.b);
             moveto(0,x);
             lineto(width,x);
          end;

  internalpaint(buffer);
  bitblt(canvas.handle,0,0,width,height,buffer.canvas.handle,0,0,srccopy);
  buffer.free;
end;


{***************************************************
*             RXLIB VCLUtils Code                  *
****************************************************}

function PaletteColor(Color: TColor): Longint;
begin
  Result := ColorToRGB(Color) or PaletteMask;
end;

procedure StretchBltTransparent(DstDC: HDC; DstX, DstY, DstW, DstH: Integer;
  SrcDC: HDC; SrcX, SrcY, SrcW, SrcH: Integer; Palette: HPalette;
  TransparentColor: TColorRef);
var
  Color: TColorRef;
  bmAndBack, bmAndObject, bmAndMem, bmSave: HBitmap;
  bmBackOld, bmObjectOld, bmMemOld, bmSaveOld: HBitmap;
  MemDC, BackDC, ObjectDC, SaveDC: HDC;
  palDst, palMem, palSave, palObj: HPalette;
begin
  { Create some DCs to hold temporary data }
  BackDC := CreateCompatibleDC(DstDC);
  ObjectDC := CreateCompatibleDC(DstDC);
  MemDC := CreateCompatibleDC(DstDC);
  SaveDC := CreateCompatibleDC(DstDC);
  { Create a bitmap for each DC }
  bmAndObject := CreateBitmap(SrcW, SrcH, 1, 1, nil);
  bmAndBack := CreateBitmap(SrcW, SrcH, 1, 1, nil);
  bmAndMem := CreateCompatibleBitmap(DstDC, DstW, DstH);
  bmSave := CreateCompatibleBitmap(DstDC, SrcW, SrcH);
  { Each DC must select a bitmap object to store pixel data }
  bmBackOld := SelectObject(BackDC, bmAndBack);
  bmObjectOld := SelectObject(ObjectDC, bmAndObject);
  bmMemOld := SelectObject(MemDC, bmAndMem);
  bmSaveOld := SelectObject(SaveDC, bmSave);
  { Select palette }
  palDst := 0; palMem := 0; palSave := 0; palObj := 0;
  if Palette <> 0 then begin
    palDst := SelectPalette(DstDC, Palette, True);
    RealizePalette(DstDC);
    palSave := SelectPalette(SaveDC, Palette, False);
    RealizePalette(SaveDC);
    palObj := SelectPalette(ObjectDC, Palette, False);
    RealizePalette(ObjectDC);
    palMem := SelectPalette(MemDC, Palette, True);
    RealizePalette(MemDC);
  end;
  { Set proper mapping mode }
  SetMapMode(SrcDC, GetMapMode(DstDC));
  SetMapMode(SaveDC, GetMapMode(DstDC));
  { Save the bitmap sent here }
  BitBlt(SaveDC, 0, 0, SrcW, SrcH, SrcDC, SrcX, SrcY, SRCCOPY);
  { Set the background color of the source DC to the color,         }
  { contained in the parts of the bitmap that should be transparent }
  Color := SetBkColor(SaveDC, PaletteColor(TransparentColor));
  { Create the object mask for the bitmap by performing a BitBlt()  }
  { from the source bitmap to a monochrome bitmap                   }
  BitBlt(ObjectDC, 0, 0, SrcW, SrcH, SaveDC, 0, 0, SRCCOPY);
  { Set the background color of the source DC back to the original  }
  SetBkColor(SaveDC, Color);
  { Create the inverse of the object mask }
  BitBlt(BackDC, 0, 0, SrcW, SrcH, ObjectDC, 0, 0, NOTSRCCOPY);
  { Copy the background of the main DC to the destination }
  BitBlt(MemDC, 0, 0, DstW, DstH, DstDC, DstX, DstY, SRCCOPY);
  { Mask out the places where the bitmap will be placed }
  StretchBlt(MemDC, 0, 0, DstW, DstH, ObjectDC, 0, 0, SrcW, SrcH, SRCAND);
  { Mask out the transparent colored pixels on the bitmap }
  BitBlt(SaveDC, 0, 0, SrcW, SrcH, BackDC, 0, 0, SRCAND);
  { XOR the bitmap with the background on the destination DC }
  StretchBlt(MemDC, 0, 0, DstW, DstH, SaveDC, 0, 0, SrcW, SrcH, SRCPAINT);
  { Copy the destination to the screen }
  BitBlt(DstDC, DstX, DstY, DstW, DstH, MemDC, 0, 0,
    SRCCOPY);
  { Restore palette }
  if Palette <> 0 then begin
    SelectPalette(MemDC, palMem, False);
    SelectPalette(ObjectDC, palObj, False);
    SelectPalette(SaveDC, palSave, False);
    SelectPalette(DstDC, palDst, True);
  end;
  { Delete the memory bitmaps }
  DeleteObject(SelectObject(BackDC, bmBackOld));
  DeleteObject(SelectObject(ObjectDC, bmObjectOld));
  DeleteObject(SelectObject(MemDC, bmMemOld));
  DeleteObject(SelectObject(SaveDC, bmSaveOld));
  { Delete the memory DCs }
  DeleteDC(MemDC);
  DeleteDC(BackDC);
  DeleteDC(ObjectDC);
  DeleteDC(SaveDC);
end;

procedure StretchBitmapTransparent(Dest: TCanvas; Bitmap: TBitmap;
  TransparentColor: TColor; DstX, DstY, DstW, DstH, SrcX, SrcY,
  SrcW, SrcH: Integer);
var
  CanvasChanging: TNotifyEvent;
  Temp: TBitmap;
begin
  if DstW <= 0 then DstW := Bitmap.Width;
  if DstH <= 0 then DstH := Bitmap.Height;
  if (SrcW <= 0) or (SrcH <= 0) then begin
    SrcX := 0; SrcY := 0;
    SrcW := Bitmap.Width;
    SrcH := Bitmap.Height;
  end;
  if not Bitmap.Monochrome then
    SetStretchBltMode(Dest.Handle, STRETCH_DELETESCANS);
  CanvasChanging := Bitmap.Canvas.OnChanging;
  try
    Bitmap.Canvas.OnChanging := nil;
{$IFDEF yu_D3}
    {if Bitmap.HandleType = bmDIB then begin
      Temp := TBitmap.Create;
      Temp.Assign(Bitmap);
      Temp.HandleType := bmDDB;
    end
    else} Temp := Bitmap;
{$ELSE}
    Temp := Bitmap;
{$ENDIF}
    try
      if TransparentColor = clNone then begin
        StretchBlt(Dest.Handle, DstX, DstY, DstW, DstH, Temp.Canvas.Handle,
          SrcX, SrcY, SrcW, SrcH, Dest.CopyMode);
      end
      else begin
{$IFDEF yu_D3}
        if TransparentColor = clDefault then
          TransparentColor := Temp.Canvas.Pixels[0, Temp.Height - 1];
{$ENDIF}
        if Temp.Monochrome then TransparentColor := clWhite
        else TransparentColor := ColorToRGB(TransparentColor);
        StretchBltTransparent(Dest.Handle, DstX, DstY, DstW, DstH,
          Temp.Canvas.Handle, SrcX, SrcY, SrcW, SrcH, Temp.Palette,
          TransparentColor);
      end;
    finally
{$IFDEF yu_D3}
      {if Bitmap.HandleType = bmDIB then Temp.Free;}
{$ENDIF}
    end;
  finally
    Bitmap.Canvas.OnChanging := CanvasChanging;
  end;
end;

procedure StretchBitmapRectTransparent(Dest: TCanvas; DstX, DstY,
  DstW, DstH: Integer; SrcRect: TRect; Bitmap: TBitmap;
  TransparentColor: TColor);
begin
  with SrcRect do
    StretchBitmapTransparent(Dest, Bitmap, TransparentColor,
    DstX, DstY, DstW, DstH, Left, Top, Right - Left, Bottom - Top);
end;

procedure DrawBitmapRectTransparent(Dest: TCanvas; DstX, DstY: Integer;
  SrcRect: TRect; Bitmap: TBitmap; TransparentColor: TColor);
begin
  with SrcRect do
    StretchBitmapTransparent(Dest, Bitmap, TransparentColor,
    DstX, DstY, Right - Left, Bottom - Top, Left, Top, Right - Left,
    Bottom - Top);
end;

procedure DrawBitmapTransparent(Dest: TCanvas; DstX, DstY: Integer;
  Bitmap: TBitmap; TransparentColor: TColor);
begin
  StretchBitmapTransparent(Dest, Bitmap, TransparentColor, DstX, DstY,
    Bitmap.Width, Bitmap.Height, 0, 0, Bitmap.Width, Bitmap.Height);
end;

procedure mygrayedbmp(var bmp1:tbitmap;const c1,c2:tcolor);
var x,y,tmp:integer;
    _c:integer;
    __c:tcolor;
begin
if bmp1.width*bmp1.height>10000 then exit;

for x:=0 to bmp1.width do
    for y:=0 to bmp1.height do
        begin
            __c:=bmp1.canvas.pixels[x,y];
            if __c<>bmp1.canvas.pixels[0,0] then
               begin
               _c:=colortorgb(__c);
               tmp:= (_c shr 16)+
                     ((_c shr 8) and $00FF)+
                     (_c and $0000FF);
               if tmp>550 then bmp1.canvas.pixels[x,y]:=clwhite
               else
               if tmp>250 then bmp1.canvas.pixels[x,y]:=c1
               else
               if tmp>60 then bmp1.canvas.pixels[x,y]:=c2
               else bmp1.canvas.pixels[x,y]:=clblack;
               end;
        end;
end;

procedure myDrawButtonFace(Canvas: TCanvas; const Client: TRect;
  BevelWidth: Integer; IsDown:boolean;c1,c2:tcolor);
var
  R: TRect;
  DC: THandle;
begin
  R := Client;
  with Canvas do
  begin
      Brush.Style := bsclear;
      DC := Canvas.Handle;
      if IsDown then
      begin    { DrawEdge is faster than Polyline }
        DrawEdge(DC, R, BDR_SUNKENINNER, BF_TOPLEFT);              { black     }
        DrawEdge(DC, R, BDR_SUNKENOUTER, BF_BOTTOMRIGHT);          { btnhilite }
        Dec(R.Bottom);
        Dec(R.Right);
        Inc(R.Top);
        Inc(R.Left);
        DrawEdge(DC, R, BDR_SUNKENOUTER, BF_TOPLEFT); { btnshadow }
      end
      else
      begin
        DrawEdge(DC, R, BDR_RAISEDOUTER, BF_BOTTOMRIGHT);          { black }
        Dec(R.Bottom);
        Dec(R.Right);
        DrawEdge(DC, R, BDR_RAISEDINNER, BF_TOPLEFT);              { btnhilite }
        Inc(R.Top);
        Inc(R.Left);
        DrawEdge(DC, R, BDR_RAISEDINNER, BF_BOTTOMRIGHT); { btnshadow }
      end;
    end
end;
end.
