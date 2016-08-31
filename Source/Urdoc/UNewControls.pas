unit UNewControls;

interface

uses Classes,stdctrls,Messages,UDM, Controls, Graphics,
     DsnUnit, DsnSelect, DsnProp, DsnSubDp, extctrls, 
     buttons,mask,forms,comctrls,Tabnotbk, CurrEdit, UUnited, Windows, sysutils,
     IBQuery, typInfo,IBDatabase, antAngleLabel, rxToolEdit, RxCalc, rxPickDate,
     BisHintEx, BisHint,
     marquee;

type

  IAutoFillSubs=interface
    procedure FillSubs;
  end;

  TTypeInsertedValue=(tivFromDealNum,tivFromDealFIO,tivFromDealDeathDate,tivFromHeaderFIO,
                      tivFromConstTownDefault);
  TSetTypeInsertedValue=Set of TTypeInsertedValue;

  TTypeLinks=class(TStringList)
  end;

  TNewLabel=class(TLabel)
   private
    FDocFile: String;
    FDocFieldName: String;
    FWordFormType: TWordFormType;
    FTypeCase: TTypeCase;
    FTypeUpperLower: TTypeUpperLower;
    FInsertedValues: TSetTypeInsertedValue;
    FSignature: string;
    FToSign: string;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    procedure SetTypeCase(Value: TTypeCase);
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
   public
    constructor Create(AOwner: TComponent);override;
    procedure WndProc(var Message: TMessage);override;
    procedure Paint; override;
   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;
    property TypeCase: TTypeCase read FTypeCase write SetTypeCase;
    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;
  end;

  { TBoundLabel }
  TLabelPosition = (lpTopLeft, lpTopCenter, lpTopRight, lpBottomLeft, lpBottomCenter, lpBottomRight,
                    lpLeftTop, lpLeftCenter, lpLeftBottom, lpRightTop, lpRightCenter, lpRightBottom, lpNoneVisible);

//  TBoundLabel = class(TCustomStaticText)
  TBoundLabel = class(TCustomLabel)
  private
    FControl: TControl;
    function GetTop: Integer;
    function GetLeft: Integer;
    function GetWidth: Integer;
    function GetHeight: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  protected
    procedure AdjustSize; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetLabelPosition(const Value: TLabelPosition);
  published
    property Alignment;
    property AutoSize;
    property BiDiMode;
    property Caption;
    property Color;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Font;
    property Height: Integer read GetHeight write SetHeight;
    property Left: Integer read GetLeft;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowAccelChar;
    property ShowHint;
    property Top: Integer read GetTop;
    property Width: Integer read GetWidth write SetWidth;
    property WordWrap;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TNewEdit=class(TEdit)
   private
    FEditLabel: TBoundLabel;
    FLabelPosition: TLabelPosition;
    FAutoOpenSubs: Boolean;

    FNoNotify: Boolean;
    FLinks: TTypeLinks;
    FDocFile: String;
    FDocFieldName: String;
    FWordFormType: TWordFormType;
    FTypeCase: TTypeCase;
    FTypeUpperLower: TTypeUpperLower;
    FInsertedValues: TSetTypeInsertedValue;
    FSignature: string;
    FToSign: string;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    procedure SetTypeCase(Value: TTypeCase);
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
    procedure SetLinks(Value: TTypeLinks);
    procedure SetLabelPosition(const Value: TLabelPosition);
    function GetLabelCaption: String;
    procedure SetLabelCaption(Value: string);
   protected
    procedure CMEnabledchanged(var Message: TMessage);message CM_ENABLEDCHANGED;
    procedure CMVisiblechanged(var Message: TMessage);message CM_VISIBLECHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
   public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure Change; override;
    procedure SetupInternalLabel;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property EditLabel: TBoundLabel read FEditLabel;
   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;
    property TypeCase: TTypeCase read FTypeCase write SetTypeCase;
    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property Links: TTypeLinks read FLinks write SetLinks;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;

    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelCaption: String read GetLabelCaption write SetLabelCaption;
    property AutoOpenSubs: Boolean read FAutoOpenSubs write FAutoOpenSubs;
  end;

  TNewComboBoxStrings = class(TCustomComboBoxStrings)
  public
    function GetTextStr: string; override;
    function Add(const S: string): Integer; override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure Assign(Source: TPersistent); override;
    function Get(Index: Integer): string; override;
  end;

  TNewComboBox=class(TCombobox)
   private
    FAutoFillSubs: Boolean;
    FAutoOpenSubs: Boolean;
    FEditLabel: TBoundLabel;
    FLabelPosition: TLabelPosition;
    FNoNotify: Boolean;
    FLinks: TTypeLinks;
    FDocFile: String;
    FDocFieldName: String;
    FWordFormType: TWordFormType;
    FTypeCase: TTypeCase;
    FTypeUpperLower: TTypeUpperLower;
    FInsertedValues: TSetTypeInsertedValue;
    FSignature: string;
    FToSign: string;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    procedure SetTypeCase(Value: TTypeCase);
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
    procedure SetLinks(Value: TTypeLinks);
    procedure SetLabelPosition(const Value: TLabelPosition);
    function GetLabelCaption: String;
    procedure SetLabelCaption(Value: string);
   protected
    procedure CMEnabledchanged(var Message: TMessage);message CM_ENABLEDCHANGED;
    procedure CMVisiblechanged(var Message: TMessage);message CM_VISIBLECHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMEnter(var Message: TMessage); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    function GetItemsClass: TCustomComboBoxStringsClass; override;
   public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure Change; override;
    procedure SetupInternalLabel;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure FillSubs;

    property EditLabel: TBoundLabel read FEditLabel;

   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;
    property TypeCase: TTypeCase read FTypeCase write SetTypeCase;
    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property Links: TTypeLinks read FLinks write SetLinks;
    property ItemIndex;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelCaption: String read GetLabelCaption write SetLabelCaption;
    property AutoOpenSubs: Boolean read FAutoOpenSubs write FAutoOpenSubs stored true;
    property AutoFillSubs: Boolean read FAutoFillSubs write FAutoFillSubs stored true;
  end;

  TNewMemo=class(TMemo)
   private
    FAutoOpenSubs: Boolean;
    FEditLabel: TBoundLabel;
    FLabelPosition: TLabelPosition;
    FNoNotify: Boolean;
    FLinks: TTypeLinks;
    FDocFile: String;
    FDocFieldName: String;
    FTypeCase: TTypeCase;
    FWordFormType: TWordFormType;
    FTypeUpperLower: TTypeUpperLower;
    FInsertedValues: TSetTypeInsertedValue;
    FSignature: string;
    FToSign: string;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    procedure SetTypeCase(Value: TTypeCase);
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
    procedure SetLinks(Value: TTypeLinks);
    procedure SetLabelPosition(const Value: TLabelPosition);
    function GetLabelCaption: String;
    procedure SetLabelCaption(Value: string);
   protected
    procedure CMEnabledchanged(var Message: TMessage);message CM_ENABLEDCHANGED;
    procedure CMVisiblechanged(var Message: TMessage);message CM_VISIBLECHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
   public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure Change; override;
    procedure SetupInternalLabel;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property EditLabel: TBoundLabel read FEditLabel;
   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;
    property TypeCase: TTypeCase read FTypeCase write SetTypeCase;
    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property Links: TTypeLinks read FLinks write SetLinks;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelCaption: String read GetLabelCaption write SetLabelCaption;
    property AutoOpenSubs: Boolean read FAutoOpenSubs write FAutoOpenSubs;
  end;

  TNewCheckBox=class(TCheckBox)
   private
    FNoNotify: Boolean;
    FLinks: TTypeLinks;
    FDocFile: String;
    FDocFieldName: String;
    FTypeCase: TTypeCase;
    FWordFormType: TWordFormType;
    FTypeUpperLower: TTypeUpperLower;
    FInsertedValues: TSetTypeInsertedValue;
    FSignature: string;
    FToSign: string;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    FText: String;
    procedure SetTypeCase(Value: TTypeCase);
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
    procedure SetLinks(Value: TTypeLinks);
    function GetCaption: String;
    procedure SetCaption(const Value: String);
   protected
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
   public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure Click; override;
   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;
    property TypeCase: TTypeCase read FTypeCase write SetTypeCase;
    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property Links: TTypeLinks read FLinks write SetLinks;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;
    property Text: String read FText write FText;
    property Caption: String read GetCaption write SetCaption; 
  end;

  TNewRadioButton=class(TRadioButton)
   private
    FNoNotify: Boolean;
    FLinks: TTypeLinks;
    FDocFile: String;
    FDocFieldName: String;
    FTypeCase: TTypeCase;
    FWordFormType: TWordFormType;
    FTypeUpperLower: TTypeUpperLower;
    FInsertedValues: TSetTypeInsertedValue;
    FSignature: string;
    FToSign: string;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    FText: String;
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
    procedure SetTypeCase(Value: TTypeCase);
    procedure SetLinks(Value: TTypeLinks);
    function GetCaption: String;
    procedure SetCaption(const Value: String);
   protected
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
   public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure Click; override;
   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;
    property TypeCase: TTypeCase read FTypeCase write SetTypeCase;
    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property Links: TTypeLinks read FLinks write SetLinks;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;
    property Text: String read FText write FText;
    property Caption: String read GetCaption write SetCaption;
  end;

  TNewListBox=class(TListBox)
   private
    FAutoFillSubs: Boolean; 
    FEditLabel: TBoundLabel;
    FLabelPosition: TLabelPosition;
    FNoNotify: Boolean;
    FLinks: TTypeLinks;
    FDocFile: String;
    FDocFieldName: String;
    FTypeCase: TTypeCase;
    FWordFormType: TWordFormType;
    FTypeUpperLower: TTypeUpperLower;
    FInsertedValues: TSetTypeInsertedValue;
    FSignature: string;
    FToSign: string;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
    procedure SetTypeCase(Value: TTypeCase);
    procedure SetLinks(Value: TTypeLinks);
    procedure SetLabelPosition(const Value: TLabelPosition);
    function GetLabelCaption: String;
    procedure SetLabelCaption(Value: string);
   protected
    procedure CMEnabledchanged(var Message: TMessage);message CM_ENABLEDCHANGED;
    procedure CMVisiblechanged(var Message: TMessage);message CM_VISIBLECHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
   public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure Click; override;
    procedure SetupInternalLabel;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure FillSubs;
    property EditLabel: TBoundLabel read FEditLabel;
   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;
    property TypeCase: TTypeCase read FTypeCase write SetTypeCase;
    property ItemIndex;
    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property Links: TTypeLinks read FLinks write SetLinks;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelCaption: String read GetLabelCaption write SetLabelCaption;
    property AutoFillSubs: Boolean read FAutoFillSubs write FAutoFillSubs;
  end;

  TNewRadioGroup=class(TRadioGroup)
   private
    FAutoFillSubs: Boolean;
    FNoNotify: Boolean;
    FLinks: TTypeLinks;
    FDocFile: String;
    FDocFieldName: String;
    FTypeCase: TTypeCase;
    FWordFormType: TWordFormType;
    FTypeUpperLower: TTypeUpperLower;
    FInsertedValues: TSetTypeInsertedValue;
    FSignature: string;
    FToSign: string;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
    procedure SetTypeCase(Value: TTypeCase);
    procedure SetLinks(Value: TTypeLinks);
   protected
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
   public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure Click; override;
    procedure FillSubs;
   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;
    property TypeCase: TTypeCase read FTypeCase write SetTypeCase;
    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property Links: TTypeLinks read FLinks write SetLinks;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;
    property AutoFillSubs: Boolean read FAutoFillSubs write FAutoFillSubs;
  end;

  TNewMaskEdit=class(TMaskEdit)
   private
    FAutoOpenSubs: Boolean;
    FEditLabel: TBoundLabel;
    FLabelPosition: TLabelPosition;
    FNoNotify: Boolean;
    FLinks: TTypeLinks;
    FDocFile: String;
    FDocFieldName: String;
    FTypeCase: TTypeCase;
    FWordFormType: TWordFormType;
    FTypeUpperLower: TTypeUpperLower;
    FInsertedValues: TSetTypeInsertedValue;
    FSignature: string;
    FToSign: string;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
    procedure SetTypeCase(Value: TTypeCase);
    procedure SetLinks(Value: TTypeLinks);
    procedure SetLabelPosition(const Value: TLabelPosition);
    function GetLabelCaption: String;
    procedure SetLabelCaption(Value: string);
   protected
    procedure CMEnabledchanged(var Message: TMessage);message CM_ENABLEDCHANGED;
    procedure CMVisiblechanged(var Message: TMessage);message CM_VISIBLECHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
   public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure Change; override;
    procedure SetupInternalLabel;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property EditLabel: TBoundLabel read FEditLabel;
   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;
    property TypeCase: TTypeCase read FTypeCase write SetTypeCase;
    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property Links: TTypeLinks read FLinks write SetLinks;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelCaption: String read GetLabelCaption write SetLabelCaption;
    property AutoOpenSubs: Boolean read FAutoOpenSubs write FAutoOpenSubs;
  end;

  TNewRichEdit=class(TRichEdit)
   private
    FAutoOpenSubs: Boolean;
    FEditLabel: TBoundLabel;
    FLabelPosition: TLabelPosition;
    FNoNotify: Boolean;
    FLinks: TTypeLinks;
    FDocFile: String;
    FDocFieldName: String;
    FTypeCase: TTypeCase;
    FWordFormType: TWordFormType;
    FTypeUpperLower: TTypeUpperLower;
    FInsertedValues: TSetTypeInsertedValue;
    FSignature: string;
    FToSign: string;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
    procedure SetTypeCase(Value: TTypeCase);
    procedure SetLinks(Value: TTypeLinks);
    procedure SetLabelPosition(const Value: TLabelPosition);
    function GetLabelCaption: String;
    procedure SetLabelCaption(Value: string);
   protected
    procedure CMEnabledchanged(var Message: TMessage);message CM_ENABLEDCHANGED;
    procedure CMVisiblechanged(var Message: TMessage);message CM_VISIBLECHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
   public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure Change; override;
    procedure SetupInternalLabel;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property EditLabel: TBoundLabel read FEditLabel;
   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;
    property TypeCase: TTypeCase read FTypeCase write SetTypeCase;
    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property Links: TTypeLinks read FLinks write SetLinks;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelCaption: String read GetLabelCaption write SetLabelCaption;
    property AutoOpenSubs: Boolean read FAutoOpenSubs write FAutoOpenSubs;
  end;

  TWrittenOut=(woNormal,woLong,woParentheses,woLongRodit);

  TNewDateTimePicker=class(TDateTimePicker)
   private
    FAutoOpenSubs: Boolean;
    FEditLabel: TBoundLabel;
    FLabelPosition: TLabelPosition;
    FNoNotify: Boolean;
    FLinks: TTypeLinks;
    FDocFile: String;
    FDocFieldName: String;
    FWordFormType: TWordFormType;
    FWrittenOut: TWrittenOut;
    FTypeUpperLower: TTypeUpperLower;
    FInsertedValues: TSetTypeInsertedValue;
    FActiveTimer: Boolean;
    FSignature: string;
    FToSign: string;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
    procedure SetLinks(Value: TTypeLinks);
    procedure SetActiveTimer(Value: Boolean);
    procedure ChangeActiveTimer;
    procedure SetLabelPosition(const Value: TLabelPosition);
    function GetLabelCaption: String;
    procedure SetLabelCaption(Value: string);
   protected
    procedure CMEnabledchanged(var Message: TMessage);message CM_ENABLEDCHANGED;
    procedure CMVisiblechanged(var Message: TMessage);message CM_VISIBLECHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
   public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure Change; override;
    procedure SetupInternalLabel;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property EditLabel: TBoundLabel read FEditLabel;
   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;
    property WrittenOut: TWrittenOut read FWrittenOut write FWrittenOut;
    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property Links: TTypeLinks read FLinks write SetLinks;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property ActiveTimer: Boolean read FActiveTimer write SetActiveTimer;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelCaption: String read GetLabelCaption write SetLabelCaption;
    property AutoOpenSubs: Boolean read FAutoOpenSubs write FAutoOpenSubs;
  end;

  TRxCalcEdit=class(CurrEdit.TRxCalcEditEx)
  private
    FAutoDropDown: Boolean;
  published
    property AutoDropDown: Boolean read FAutoDropDown write FAutoDropDown;
    property Alignment;
    property AutoSelect;
    property AutoSize;
    property BeepOnError;
    property BorderStyle;
    property ButtonHint;
    property CheckOnExit;
    property ClickKey;
    property Color;
    property Ctl3D;
    property DecimalPlaces;
    property DirectInput;
    property DisplayFormat;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property FormatOnEditing;
    property GlyphKind;
    { Ensure GlyphKind is published before Glyph and ButtonWidth }
    property Glyph;
    property ButtonWidth;
    property HideSelection;
{$IFDEF RX_D4}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
{$ENDIF}
{$IFDEF WIN32}
  {$IFNDEF VER90}
    property ImeMode;
    property ImeName;
  {$ENDIF}
{$ENDIF}
    property MaxLength;
    property MaxValue;
    property MinValue;
    property NumGlyphs;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupAlign;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Value;
    property Visible;
    property ZeroEmpty;
    property OnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
{$IFDEF RX_D5}
    property OnContextPopup;
{$ENDIF}
{$IFDEF WIN32}
    property OnStartDrag;
{$ENDIF}
{$IFDEF RX_D4}
    property OnEndDock;
    property OnStartDock;
{$ENDIF}
  end;

  TNewRxCalcEdit=class(TRxCalcEdit)
   private
    FAutoOpenSubs: Boolean;
    FEditLabel: TBoundLabel;
    FLabelPosition: TLabelPosition;
    FNoNotify: Boolean;
    FLinks: TTypeLinks;
    FDocFile: String;
    FDocFieldName: String;
    FWordFormType: TWordFormType;
    FWrittenOut: TWrittenOut;
    FTypeUpperLower: TTypeUpperLower;
    FSignature: string;
    FToSign: string;
    FInsertedValues: TSetTypeInsertedValue;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
    procedure SetLinks(Value: TTypeLinks);
    procedure SetLabelPosition(const Value: TLabelPosition);
    function GetLabelCaption: String;
    procedure SetLabelCaption(Value: string);
   protected
    procedure CMEnabledchanged(var Message: TMessage);message CM_ENABLEDCHANGED;
    procedure CMVisiblechanged(var Message: TMessage);message CM_VISIBLECHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
   public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure Change; override;
    procedure SetupInternalLabel;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property EditLabel: TBoundLabel read FEditLabel;
   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;
    property WrittenOut: TWrittenOut read FWrittenOut write FWrittenOut;
    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Links: TTypeLinks read FLinks write SetLinks;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelCaption: String read GetLabelCaption write SetLabelCaption;
    property AutoOpenSubs: Boolean read FAutoOpenSubs write FAutoOpenSubs;
  end;


  TNewRxDateEdit=class(TDateEdit)
   private
    FAutoOpenSubs: Boolean;
    FEditLabel: TBoundLabel;
    FLabelPosition: TLabelPosition;
    FDefaultWorkDate: Boolean;
    FDateFormat: TDTDateFormat;
    FNoNotify: Boolean;
    FLinks: TTypeLinks;
    FDocFile: String;
    FDocFieldName: String;
    FWordFormType: TWordFormType;
    FWrittenOut: TWrittenOut;
    FTypeUpperLower: TTypeUpperLower;
    FSignature: string;
    FToSign: string;
    FInsertedValues: TSetTypeInsertedValue;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
    procedure SetLinks(Value: TTypeLinks);
    procedure SetLabelPosition(const Value: TLabelPosition);
    function GetLabelCaption: String;
    procedure SetLabelCaption(Value: string);
   protected
    procedure CMEnabledchanged(var Message: TMessage);message CM_ENABLEDCHANGED;
    procedure CMVisiblechanged(var Message: TMessage);message CM_VISIBLECHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
   public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure Change; override;
    procedure SetupInternalLabel;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property EditLabel: TBoundLabel read FEditLabel;
   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;
    property WrittenOut: TWrittenOut read FWrittenOut write FWrittenOut;
    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Links: TTypeLinks read FLinks write SetLinks;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;
    property DateFormat: TDTDateFormat read FDateFormat write FDateFormat;
    property DefaultWorkDate: Boolean read FDefaultWorkDate write FDefaultWorkDate;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelCaption: String read GetLabelCaption write SetLabelCaption;
    property AutoOpenSubs: Boolean read FAutoOpenSubs write FAutoOpenSubs;
  end;

  TNewComboBoxMarkCar=class(TCombobox)
   private
    FSaveItems: TStringList;
    FAutoOpenSubs: Boolean;
    FEditLabel: TBoundLabel;
    FLabelPosition: TLabelPosition;
    FNoNotify: Boolean;
    FLinks: TTypeLinks;
    FDocFile: String;
    FDocFieldName: String;
    FWordFormType: TWordFormType;
    FTypeUpperLower: TTypeUpperLower;
    FInsertedValues: TSetTypeInsertedValue;
    FSignature: string;
    FToSign: string;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
    procedure SelfOnKeyPress(Sender: TObject; var Key: Char);
    procedure SetLinks(Value: TTypeLinks);
    procedure SetLabelPosition(const Value: TLabelPosition);
    function GetLabelCaption: String;
    procedure SetLabelCaption(Value: string);
   protected
    procedure CMEnabledchanged(var Message: TMessage);message CM_ENABLEDCHANGED;
    procedure CMVisiblechanged(var Message: TMessage);message CM_VISIBLECHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    function GetItemsClass: TCustomComboBoxStringsClass; override;

   public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure DestroyWindowHandle; override;
    procedure Change; override;
    procedure FillMarkCar;
    procedure AddMarkCar;
    procedure SetupInternalLabel;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property EditLabel: TBoundLabel read FEditLabel;
   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;

    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property ItemIndex;
    property Links: TTypeLinks read FLinks write SetLinks;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelCaption: String read GetLabelCaption write SetLabelCaption;
    property AutoOpenSubs: Boolean read FAutoOpenSubs write FAutoOpenSubs;
  end;

  TNewComboBoxColor=class(TCombobox)
   private
    FAutoOpenSubs: Boolean;
    FEditLabel: TBoundLabel;
    FLabelPosition: TLabelPosition;
    FNoNotify: Boolean;
    FLinks: TTypeLinks;
    FDocFile: String;
    FDocFieldName: String;
    FWordFormType: TWordFormType;
    FTypeUpperLower: TTypeUpperLower;
    FInsertedValues: TSetTypeInsertedValue;
    FSignature: string;
    FToSign: string;
    FSubs: string;
    FWordStyle: string;
    FWordAutoFormat: Boolean;
    FBlocking: Boolean;
    procedure SetDocFile(Value: String);
    procedure SetDocFieldName(Value: String);
    procedure SelfOnKeyPress(Sender: TObject; var Key: Char);
    procedure SetLinks(Value: TTypeLinks);
    procedure SetLabelPosition(const Value: TLabelPosition);
    function GetLabelCaption: String;
    procedure SetLabelCaption(Value: string);
   protected
    procedure CMEnabledchanged(var Message: TMessage);message CM_ENABLEDCHANGED;
    procedure CMVisiblechanged(var Message: TMessage);message CM_VISIBLECHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    function GetItemsClass: TCustomComboBoxStringsClass; override;
   public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure WndProc(var Message: TMessage);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
    procedure Change; override;
    procedure FillColor;
    procedure AddColor;
    procedure SetupInternalLabel;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property EditLabel: TBoundLabel read FEditLabel;
   published
    property DocFile: string read FDocFile write SetDocFile;
    property WordFormType: TWordFormType read FWordFormType write FWordFormType;
    property DocFieldName: string read FDocFieldName write SetDocFieldName;

    property TypeUpperLower: TTypeUpperLower read FTypeUpperLower write FTypeUpperLower;
    property ItemIndex;
    property Links: TTypeLinks read FLinks write SetLinks;
    property InsertedValues: TSetTypeInsertedValue read FInsertedValues write FInsertedValues;
    property Signature: string read FSignature write FSignature;
    property ToSign: string read FToSign write FToSign;
    property Subs: string read FSubs write FSubs;
    property WordStyle: string read FWordStyle write FWordStyle;
    property WordAutoFormat: Boolean read FWordAutoFormat write FWordAutoFormat;
    property Blocking: Boolean read FBlocking write FBlocking;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelCaption: String read GetLabelCaption write SetLabelCaption;
    property AutoOpenSubs: Boolean read FAutoOpenSubs write FAutoOpenSubs;
  end;


function GetBoundLabel(ct: TControl): TBoundLabel;
function ViewHintExByControl(ct: TControl): Boolean;
procedure CancelHintEx;
procedure StartHintTimer;

const
   ConstLabelSpacing=5;
var
  HintEx: TBisHintWindowEx;

implementation

uses UNewForm, dialogs, RTLConsts, Consts;




const
   CasePropError='������ � ����� <%s> �� ������ ����� ����������, � ������� ���������, �������� �������� <�����> �� ����� �������-��������';
   CasePropErrorLabel='������ � ������� <%s> �� ������ ����� ����������, � ������� ���������, �������� �������� <�����> �� ����� �������-��������';
   ConstLabelMaxWidth=100;

type
  TNewTimer=class(TTimer)
  private
    ListControls: TList;
    procedure OnTimerNew(Sender: TObject);
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    procedure AddControl(Control: TControl);
    procedure RemoveControl(Control: TControl);
  end;

var
  GlobalTimer: TNewTimer;
  FTimerHandle: THandle;


{ TNewTimer }

constructor TNewTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ListControls:=TList.Create;
  OnTimer:=OnTimerNew;
  Interval:=999;
  Enabled:=false;
end;

destructor TNewTimer.Destroy;
begin
  ListControls.Free;
  Inherited;
end;

procedure TNewTimer.OnTimerNew(Sender: TObject);
var
  ct: TControl;
  i: Integer;
  Hour,Min,Sec,MSec: Word;
begin
  Enabled:=false;
  for i:=0 to ListControls.Count-1 do begin
    ct:=TControl(ListControls.Items[i]);
    if ct is TNewDateTimePicker then begin
      if TNewDateTimePicker(ct).Kind=dtkTime then begin
         DecodeTime(TNewDateTimePicker(ct).Time,Hour,Min,Sec,MSec);
         if Sec+1>59 then begin
          Sec:=0;
          if Min+1>59 then begin
           Min:=0;
           if Hour+1>23 then Hour:=0
           else Hour:=Hour+1;
          end else begin
           Min:=Min+1;
          end;
         end else begin
          Sec:=Sec+1;
         end; 
         TNewDateTimePicker(ct).Time:=EncodeTime(Hour,Min,Sec,MSec);
      end; 
    end;
  end;
  Enabled:=ListControls.Count>0;
end;

procedure TNewTimer.AddControl(Control: TControl);
begin
  if ListControls.IndexOf(Control)=-1 then
    ListControls.Add(Control);
  Enabled:=ListControls.Count>0;
end;

procedure TNewTimer.RemoveControl(Control: TControl);
begin
  ListControls.Remove(Control);
  Enabled:=ListControls.Count>0;
end;


function GetParentNew(ct: TControl):TWinControl;
var
  Prn: TWinControl;
begin
  Prn:=ct.Parent;
  result:=Prn;
  if Prn<>nil then begin
   while Prn.Parent<>nil do begin
     Prn:=Prn.Parent;
     Result:=Prn;
     if Prn.Parent=nil then exit;
   end;
  end;
end;

procedure RemoveFromLinks(AComp: TComponent);

  procedure RemoveLinks(wt: TWinControl);
  var
    i: Integer;
    ct: TControl;
    ttl: TTypeLinks;
    val: Integer;
    PI: PPropInfo;
  begin
    for i:=0 to  wt.ControlCount-1 do begin
      ct:=wt.Controls[i];
      if isNewControl(ct) then begin
        PI:=GetPropInfo(ct.ClassInfo,'Links');
        if PI<>nil then begin
         ttl:=TTypeLinks(TObject(GetOrdprop(ct,PI)));
         if ttl<>nil then begin
           val:=ttl.IndexOf(AComp.Name);
           if val<>-1 then
              ttl.Delete(val);
         end;
        end; 
      end;
      if ct is TWinControl then
        RemoveLinks(TWinControl(ct));
    end;
  end;
  
var
  wt: TWinControl;
begin
  if AComp.Owner=nil then exit;
  if not (AComp.Owner is TWinControl) then exit;
  wt:=TWinControl(AComp.Owner);
  if wt=nil then exit;
  RemoveLinks(wt);
end;

procedure ChangeToOther(cmpParent:TComponent; TTL: TTypeLinks);

  procedure SetForNewLabel(lb: TNewLabel);
  begin
    lb.Caption:=GetTextFromControl(TControl(cmpParent));
  end;

  procedure SetForNewEdit(ed: TNewEdit);
  begin
    ed.Text:=GetTextFromControl(TControl(cmpParent));
  end;

  procedure SetForNewComboBox(cb: TNewComboBox);
  var
    val: Integer;
    s: string;
  begin
    if cmpParent is TNewComboBox then begin
      s:=GetTextFromControl(TControl(cmpParent));
      val:=TNewComboBox(cmpParent).Items.IndexOf(s);
      if val<>-1 then begin
        cb.ItemIndex:=TNewComboBox(cmpParent).ITemIndex;
        cb.Change;
      end else begin
        cb.Text:=s;
      end;
    end else
     cb.Text:=GetTextFromControl(TControl(cmpParent));
  end;

  procedure SetForNewMemo(me: TNewMemo);
  begin
    me.Lines.Text:=GetTextFromControl(TControl(cmpParent));
  end;

  procedure SetForNewCheckBox(cb: TNewCheckBox);
  begin
    if cmpParent is TNewCheckBox then begin
     cb.Checked:=TNewCheckBox(cmpParent).Checked;
     cb.Click;
    end else
     cb.Caption:=GetTextFromControl(TControl(cmpParent));
  end;

  procedure SetForNewRadioButton(rb: TNewRadioButton);
  begin
    if cmpParent is TNewRadioButton then
//     rb.Checked:=TNewRadioButton(cmpParent).Checked
    else
     rb.Caption:=GetTextFromControl(TControl(cmpParent));
  end;

  procedure SetForNewListBox(lb: TNewListBox);
  begin
   if cmpParent is TNewListBox then begin
    lb.itemindex:=TNewListBox(cmpParent).ItemIndex;
    lb.Click;
   end else begin
    if (lb.Items.Count>0) and (lb.ItemIndex<>-1) then
      lb.Items.Strings[lb.itemindex]:=GetTextFromControl(TControl(cmpParent));
   end;   
  end;

  procedure SetForNewRadioGroup(rg: TNewRadioGroup);
  begin
   if cmpParent is TNewRadioGroup then begin
    rg.itemindex:=TNewRadioGroup(cmpParent).ItemIndex;
    rg.Click;
   end else begin
    if (rg.Items.Count>0) and (rg.ItemIndex<>-1) then
      rg.Items.Strings[rg.itemindex]:=GetTextFromControl(TControl(cmpParent));
   end;   
  end;

  procedure SetForNewMaskEdit(me: TNewMaskEdit);
  begin
    me.Text:=GetTextFromControl(TControl(cmpParent));
  end;

  procedure SetForNewRichEdit(re: TNewRichEdit);
  begin
    re.Lines.Text:=GetTextFromControl(TControl(cmpParent));
  end;

  procedure SetForNewDateTimePicker(dtp: TNewDateTimePicker);
  var
    tmps: string;
  begin
    if cmpParent is TDateTimePicker then
     dtp.DateTime:=TDateTimePicker(cmpParent).DateTime
    else begin
      tmps:=GetTextFromControl(TControl(cmpParent));
      case dtp.Kind of
        dtkDate: begin
          if isDate(tmps) then
           dtp.date:=StrToDate(tmps);
        end;
        dtkTime: begin
          if isTime(tmps) then
           dtp.time:=StrToTime(tmps);
        end;
      end;
    end;
  end;

  procedure SetForNewRxCalcEdit(rce: TNewRxCalcEdit);
  var
    tmps: string;
  begin
    tmps:=GetTextFromControl(TControl(cmpParent));
    if isFloat(tmps) then
     rce.Value:=StrToFloat(tmps);
  end;

  procedure SetForNewRxDateEDit(de: TNewRxDateEdit);
  var
    tmps: string;
  begin
    if cmpParent is TNewRxDateEdit then
     de.Date:=TNewRxDateEdit(cmpParent).Date
    else begin
      tmps:=GetTextFromControl(TControl(cmpParent));
      if isDate(tmps) then
         de.date:=StrToDate(tmps);
    end;
  end;
  
  procedure SetForNewComboBoxMarkCar(cb: TNewComboBoxMarkCar);
  begin
    if cmpParent is TNewComboBoxMarkCar then begin
     cb.ItemIndex:=TNewComboBoxMarkCar(cmpParent).ItemIndex;
     cb.Change;
    end else
     cb.Text:=GetTextFromControl(TControl(cmpParent));
  end;

  procedure SetForNewComboBoxColor(cb: TNewComboBoxColor);
  begin
    if cmpParent is TNewComboBoxColor then begin
     cb.ItemIndex:=TNewComboBoxColor(cmpParent).ItemIndex;
     cb.Change;
    end else
     cb.Text:=GetTextFromControl(TControl(cmpParent));
  end;

var
  i: Integer;
  ct: TControl;
  cpt: TComponent;
  wt: TWinControl;
begin
  if TTL=nil then exit;
  if cmpParent.Owner=nil then exit;
  if not (cmpParent.Owner is TWinControl) then exit;
  wt:=TWinControl(cmpParent.Owner);
  if wt=nil then exit;
  for i:=0 to TTL.Count-1 do begin
    cpt:=wt.FindComponent(TTL.Strings[i]);
    ct:=nil;
    if cpt is TControl then
     ct:=TControl(cpt);
    if ct<>nil then
     if isNewControl(ct) then begin
       if ct is TNewLabel then SetForNewLabel(TNewLabel(ct));
       if ct is TNewEdit then SetForNewEdit(TNewEdit(ct));
       if ct is TNewComboBox then SetForNewComboBox(TNewComboBox(ct));
       if ct is TNewMemo then SetForNewMemo(TNewMemo(ct));
       if ct is TNewCheckBox then SetForNewCheckBox(TNewCheckBox(ct));
       if ct is TNewRadioButton then SetForNewRadioButton(TNewRadioButton(ct));
       if ct is TNewListBox then SetForNewListBox(TNewListBox(ct));
       if ct is TNewRadioGroup then SetForNewRadioGroup(TNewRadioGroup(ct));
       if ct is TNewMaskEdit then SetForNewMaskEdit(TNewMaskEdit(ct));
       if ct is TNewRichEdit then SetForNewRichEdit(TNewRichEdit(ct));
       if ct is TNewDateTimePicker then SetForNewDateTimePicker(TNewDateTimePicker(ct));
       if ct is TNewRxCalcEdit then SetForNewRxCalcEdit(TNewRxCalcEdit(ct));
       if ct is TNewRxDateEdit then SetForNewRxDateEdit(TNewRxDateEdit(ct));
       if ct is TNewComboBoxMarkCar then SetForNewComboBoxMarkCar(TNewComboBoxMarkCar(ct));
       if ct is TNewComboBoxColor then SetForNewComboBoxColor(TNewComboBoxColor(ct));
     end;
  end;
end;

{ TNewLabel }

constructor TNewLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBlocking:=false;
  ShowHint:=true;
end;

procedure TNewLabel.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewLabel.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewLabel.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewLabel.SetTypeCase(Value: TTypeCase);
begin
  if Value<>FTypeCase then begin
   if Value<>tcNone then begin
    if isOtherControlConsistProp(Parent,Value) then begin
     if (not (csLoading in ComponentState))or (not (csReading in ComponentState)) then
       ShowError(Application.Handle,Format(CasePropErrorLabel,[Caption]));
//     MessageBox(Application.Handle,Pchar(Format(CasePropError,[Self.Name])),'������',MB_ICONERROR);
    end else
     FTypeCase:=Value;
   end else FTypeCase:=Value;
  end;
end;

procedure TNewLabel.Paint;
begin
  if Visible then inherited Paint
  else begin

  end;
end;

{ TBoundLabel }

constructor TBoundLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Name := '';  
  Caption:='';
  AutoSize:=true;
  Transparent:=true;
  if Owner<>nil then
   if Owner is TControl then
     FControl:=TControl(Owner);
end;

procedure TBoundLabel.AdjustSize;
begin
  inherited AdjustSize;
end;

procedure TBoundLabel.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

function TBoundLabel.GetHeight: Integer;
begin
  Result := inherited Height;
end;

function TBoundLabel.GetLeft: Integer;
begin
  Result := inherited Left;
end;

function TBoundLabel.GetTop: Integer;
begin
  Result := inherited Top;
end;

function TBoundLabel.GetWidth: Integer;
begin
  Result := inherited Width;
end;

procedure TBoundLabel.SetHeight(const Value: Integer);
begin
  SetBounds(Left, Top, Width, Value);
end;

procedure TBoundLabel.SetWidth(const Value: Integer);
begin
  SetBounds(Left, Top, Value, Height);
end;
// taLeftJustify, taRightJustify, taCenter
//tlTop, tlCenter, tlBottom
procedure TBoundLabel.SetLabelPosition(const Value: TLabelPosition);
begin
  if FControl=nil then exit;
  Visible:=true;
  case Value of
    lpTopLeft: begin
      SetBounds(FControl.Left, FControl.Top-Height-ConstLabelSpacing, Width, Height);
      Alignment:=taLeftJustify;
      Layout:=tlBottom;
    end;
    lpTopCenter: begin
      SetBounds(FControl.Left+(FControl.Width div 2-Width div 2), FControl.Top-Height-ConstLabelSpacing, Width, Height);
      Alignment:=taCenter;
      Layout:=tlBottom;
    end;
    lpTopRight: begin
      SetBounds(FControl.Left+FControl.Width-Width, FControl.Top-Height-ConstLabelSpacing, Width, Height);
      Alignment:=taRightJustify;
      Layout:=tlBottom;
    end;
    lpBottomLeft: begin
      SetBounds(FControl.Left, FControl.Top+FControl.Height+ConstLabelSpacing, Width, Height);
      Alignment:=taLeftJustify;
      Layout:=tlTop;
    end;
    lpBottomCenter: begin
      SetBounds(FControl.Left+(FControl.Width div 2-Width div 2), FControl.Top+FControl.Height+ConstLabelSpacing, Width, Height);
      Alignment:=taCenter;
      Layout:=tlTop;
    end;
    lpBottomRight: begin
      SetBounds(FControl.Left+FControl.Width-Width, FControl.Top+FControl.Height+ConstLabelSpacing, Width, Height);
      Alignment:=taRightJustify;
      Layout:=tlTop;
    end;
    lpLeftTop: begin
      SetBounds(FControl.Left-Width-ConstLabelSpacing, FControl.Top, Width, Height);
      Alignment:=taRightJustify;
      Layout:=tlTop;
    end;
    lpLeftCenter: begin
      SetBounds(FControl.Left-Width-ConstLabelSpacing, FControl.Top+(FControl.Height div 2-Height div 2), Width, Height);
      Alignment:=taRightJustify;
      Layout:=tlCenter;
    end;
    lpLeftBottom: begin
      SetBounds(FControl.Left-Width-ConstLabelSpacing, FControl.Top+FControl.Height-Height, Width, Height);
      Alignment:=taRightJustify;
      Layout:=tlBottom;
    end;
    lpRightTop: begin
      SetBounds(FControl.Left + FControl.Width + ConstLabelSpacing, FControl.Top, Width, Height);
      Alignment:=taLeftJustify;
      Layout:=tlTop;
    end;
    lpRightCenter: begin
      SetBounds(FControl.Left + FControl.Width + ConstLabelSpacing, FControl.Top+(FControl.Height div 2-Height div 2), Width, Height);
      Alignment:=taLeftJustify;
      Layout:=tlCenter;
    end;
    lpRightBottom: begin
      SetBounds(FControl.Left + FControl.Width + ConstLabelSpacing, FControl.Top+FControl.Height-Height, Width, Height);
      Alignment:=taLeftJustify;
      Layout:=tlBottom;
    end;
    lpNoneVisible: begin
      Visible:=false;
    end;
  end;
end;

{ TNewEdit }

constructor TNewEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinks:=TTypeLinks.Create;
  FNoNotify:=true;
  FBlocking:=false;
  FLabelPosition := lpLeftCenter;
  SetupInternalLabel;
  ShowHint:=true;
end;

destructor TNewEdit.Destroy;
begin
  FEditLabel.Free;
  FNoNotify:=false;
  FLinks.Free;
  inherited Destroy;
end;

procedure TNewEdit.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewEdit.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewEdit.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewEdit.SetTypeCase(Value: TTypeCase);
begin
  if Value<>FTypeCase then begin
   if Value<>tcNone then begin
    if isOtherControlConsistProp(Parent,Value) then begin
     if (not (csLoading in ComponentState))or (not (csReading in ComponentState)) then
       ShowError(Application.Handle,Format(CasePropError,[DocFieldName]));
    end else
     FTypeCase:=Value;
   end else FTypeCase:=Value;
  end;
end;

procedure TNewEdit.SetLinks(Value: TTypeLinks);
begin
  FLinks.Assign(Value);
end;

procedure TNewEdit.Change;
begin
  if not ((csDesigning in ComponentState)or
          (csLoading in ComponentState)or
          (csReading in ComponentState)) then
   ChangeToOther(Self,FLinks);
  inherited;
end;

procedure TNewEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
  if FNoNotify then
   if (Operation=opRemove) and (AComponent=Self) then begin
    RemoveFromLinks(Self);
   end;
end;

procedure TNewEdit.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.BiDiMode := BiDiMode;
end;

procedure TNewEdit.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Enabled := Enabled;
end;

procedure TNewEdit.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Visible := Visible;
end;

procedure TNewEdit.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if FAutoOpenSubs then
    if Trim(FSubs)<>'' then
      if Trim(Text)='' then
        OpenSubs(Self,true,FSubs,Text,true);
  if isViewHintOnFocus then ViewHintExByControl(Self);
end;

procedure TNewEdit.CMExit(var Message: TCMExit);
begin
  CancelHintEx;
  inherited;
end;

procedure TNewEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetLabelPosition(FLabelPosition);
end;

procedure TNewEdit.SetLabelPosition(const Value: TLabelPosition);
begin
  if FEditLabel = nil then exit;
  FEditLabel.SetLabelPosition(Value);
  FEditLabel.Visible:=Visible;
  FLabelPosition := Value;
end;

procedure TNewEdit.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FEditLabel = nil then exit;
  FEditLabel.Parent := AParent;
end;

function TNewEdit.GetLabelCaption: String;
begin
  Result:='';
  if FEditLabel = nil then exit;
  Result:=FEditLabel.Caption;
end;

procedure TNewEdit.SetLabelCaption(Value: string);
begin
  if FEditLabel = nil then exit;
  if Value<>FEditLabel.Caption then begin
    FEditLabel.Caption:=Value;
    SetLabelPosition(FLabelPosition);
  end;
end;

procedure TNewEdit.SetupInternalLabel;
begin
  if Assigned(FEditLabel) then exit;
  FEditLabel := TBoundLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;
  FEditLabel.SetDesigning(false,false);
end;


{ TNewComboBox }

constructor TNewComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinks:=TTypeLinks.Create;
  FNoNotify:=true;
  FBlocking:=false;
  FLabelPosition := lpLeftCenter;
  SetupInternalLabel;
  ShowHint:=true;
end;

destructor TNewComboBox.Destroy;
begin
  FEditLabel.Free;
  FNoNotify:=false;
  FLinks.Free;
  inherited Destroy;
end;

procedure TNewComboBox.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewComboBox.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewComboBox.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewComboBox.SetTypeCase(Value: TTypeCase);
begin
  if Value<>FTypeCase then begin
   if Value<>tcNone then begin
    if isOtherControlConsistProp(Parent,Value) then begin
     if (not (csLoading in ComponentState))or (not (csReading in ComponentState)) then
      ShowError(Application.Handle,Format(CasePropError,[DocFieldName]));
//     MessageBox(Application.Handle,Pchar(Format(CasePropError,[Self.Name])),'������',MB_ICONERROR);
    end else
     FTypeCase:=Value;
   end else FTypeCase:=Value;
  end; 
end;

procedure TNewComboBox.SetLinks(Value: TTypeLinks);
begin
  FLinks.Assign(Value);
end;

procedure TNewComboBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
  if FNoNotify then
   if (Operation=opRemove) and (AComponent=Self) then begin
    RemoveFromLinks(Self);
   end;
end;

procedure TNewComboBox.Change;
begin
  if not ((csDesigning in ComponentState)or
          (csLoading in ComponentState)or
          (csReading in ComponentState)) then
   ChangeToOther(Self,FLinks);
  inherited;
end;

procedure TNewComboBox.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.BiDiMode := BiDiMode;
end;

procedure TNewComboBox.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Enabled := Enabled;
end;

procedure TNewComboBox.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Visible := Visible;
end;

procedure TNewComboBox.CMEnter(var Message: TMessage);
begin
  inherited;
  if FAutoOpenSubs then
    if Trim(FSubs)<>'' then
      if Trim(Text)='' then
        OpenSubs(Self,true,FSubs,Text,true);
  if isViewHintOnFocus then ViewHintExByControl(Self);
end;

procedure TNewComboBox.CMExit(var Message: TCMExit);
begin
  CancelHintEx;
  inherited;
end;

procedure TNewComboBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetLabelPosition(FLabelPosition);
end;

procedure TNewComboBox.SetLabelPosition(const Value: TLabelPosition);
begin
  if FEditLabel = nil then exit;
  FEditLabel.SetLabelPosition(Value);
  FEditLabel.Visible:=Visible;
  FLabelPosition := Value;
end;

procedure TNewComboBox.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FEditLabel = nil then exit;
  FEditLabel.Parent := AParent;
end;

function TNewComboBox.GetLabelCaption: String;
begin
  Result:='';
  if FEditLabel = nil then exit;
  Result:=FEditLabel.Caption;
end;

procedure TNewComboBox.SetLabelCaption(Value: string);
begin
  if FEditLabel = nil then exit;
  if Value<>FEditLabel.Caption then begin
    FEditLabel.Caption:=Value;
    SetLabelPosition(FLabelPosition);
  end;
end;

procedure TNewComboBox.SetupInternalLabel;
begin
  if Assigned(FEditLabel) then exit;
  FEditLabel := TBoundLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;
  FEditLabel.SetDesigning(false,false);
end;

procedure TNewComboBox.FillSubs;
var
  ii: Integer;
begin
  if FAutoFillSubs then
    if Trim(FSubs)<>'' then begin
      ii:=ItemIndex;
      FillSubsToStrings(FSubs,Items);
      ItemIndex:=ii;
    end;  
end;

function TNewComboBox.GetItemsClass: TCustomComboBoxStringsClass;
begin
  Result:=TNewComboBoxStrings;
end;

{ TNEwComboBoxStrings }

function TNEwComboBoxStrings.Add(const S: string): Integer;
begin
  Result := SendMessage(ComboBox.Handle, CB_ADDSTRING, 0, Longint(PChar(S)));
  if Result < 0 then
    raise EOutOfResources.Create(SInsertLineError);
end;

procedure TNEwComboBoxStrings.Insert(Index: Integer; const S: string);
begin
  if SendMessage(ComboBox.Handle, CB_INSERTSTRING, Index,
    Longint(PChar(S))) < 0 then
    raise EOutOfResources.Create(SInsertLineError);
end;

function TNEwComboBoxStrings.GetTextStr: string;
begin
  Result:=inherited GetTextStr;
end;

function TNEwComboBoxStrings.Get(Index: Integer): string; 
var
  Text: array[0..4095] of Char;
  Len: Integer;
begin
  Len := SendMessage(ComboBox.Handle, CB_GETLBTEXT, Index, Longint(@Text));
  if Len = CB_ERR then Len := 0;
  SetString(Result, Text, Len);

{  Len := SendMessage(ComboBox.Handle, CB_GETLBTEXTLEN, Index, 0);
  if Len <> CB_ERR then
  begin
    SetLength(Result, Len);
    SendMessage(ComboBox.Handle, CB_GETLBTEXT, Index, Longint(PChar(Result)));
  end
  else
    SetLength(Result, 0);}
end;

procedure TNEwComboBoxStrings.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
end;


{ TNewMemo }

constructor TNewMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinks:=TTypeLinks.Create;
  FNoNotify:=true;
  FBlocking:=false;
  FLabelPosition := lpLeftTop;
  SetupInternalLabel;
  ShowHint:=true;
end;

destructor TNewMemo.Destroy;
begin
  FEditLabel.Free;
  FNoNotify:=false;
  FLinks.Free;
  inherited Destroy;
end;

procedure TNewMemo.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewMemo.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewMemo.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewMemo.SetTypeCase(Value: TTypeCase);
begin
  if Value<>FTypeCase then begin
   if Value<>tcNone then begin
    if isOtherControlConsistProp(Parent,Value) then begin
     if (not (csLoading in ComponentState))or (not (csReading in ComponentState)) then
      ShowError(Application.Handle,Format(CasePropError,[DocFieldName]));
//     MessageBox(Application.Handle,Pchar(Format(CasePropError,[Self.Name])),'������',MB_ICONERROR);
    end else
     FTypeCase:=Value;
   end else FTypeCase:=Value;
  end; 
end;

procedure TNewMemo.SetLinks(Value: TTypeLinks);
begin
  FLinks.Assign(Value);
end;

procedure TNewMemo.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
  if FNoNotify then
   if (Operation=opRemove) and (AComponent=Self) then begin
    RemoveFromLinks(Self);
   end;
end;

procedure TNewMemo.Change;
begin
  if not ((csDesigning in ComponentState)or
          (csLoading in ComponentState)or
          (csReading in ComponentState)) then
   ChangeToOther(Self,FLinks);
  inherited;
end;

procedure TNewMemo.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.BiDiMode := BiDiMode;
end;

procedure TNewMemo.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Enabled := Enabled;
end;

procedure TNewMemo.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Visible := Visible;
end;

procedure TNewMemo.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if FAutoOpenSubs then
    if Trim(FSubs)<>'' then
      if Trim(Text)='' then
        OpenSubs(Self,true,FSubs,Text,true);
  if isViewHintOnFocus then ViewHintExByControl(Self);
end;

procedure TNewMemo.CMExit(var Message: TCMExit);
begin
  CancelHintEx;
  inherited;
end;

procedure TNewMemo.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetLabelPosition(FLabelPosition);
end;

procedure TNewMemo.SetLabelPosition(const Value: TLabelPosition);
begin
  if FEditLabel = nil then exit;
  FEditLabel.SetLabelPosition(Value);
  FEditLabel.Visible:=Visible;
  FLabelPosition := Value;
end;

procedure TNewMemo.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FEditLabel = nil then exit;
  FEditLabel.Parent := AParent;
end;

function TNewMemo.GetLabelCaption: String;
begin
  Result:='';
  if FEditLabel = nil then exit;
  Result:=FEditLabel.Caption;
end;

procedure TNewMemo.SetLabelCaption(Value: string);
begin
  if FEditLabel = nil then exit;
  if Value<>FEditLabel.Caption then begin
    FEditLabel.Caption:=Value;
    SetLabelPosition(FLabelPosition);
  end;
end;

procedure TNewMemo.SetupInternalLabel;
begin
  if Assigned(FEditLabel) then exit;
  FEditLabel := TBoundLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;
  FEditLabel.SetDesigning(false,false);
end;


{ TNewCheckBox }

constructor TNewCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNoNotify:=true;
  FLinks:=TTypeLinks.Create;
  FNoNotify:=true;
  FBlocking:=false;
  ShowHint:=true;
end;

destructor TNewCheckBox.Destroy;
begin
  FNoNotify:=false;
  FLinks.Free;
  inherited Destroy;
end;

procedure TNewCheckBox.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewCheckBox.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewCheckBox.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewCheckBox.SetTypeCase(Value: TTypeCase);
begin
  if Value<>FTypeCase then begin
   if Value<>tcNone then begin
    if isOtherControlConsistProp(Parent,Value) then begin
     if (not (csLoading in ComponentState))or (not (csReading in ComponentState)) then
      ShowError(Application.Handle,Format(CasePropError,[DocFieldName]));
//     MessageBox(Application.Handle,Pchar(Format(CasePropError,[Self.Name])),'������',MB_ICONERROR);
    end else
     FTypeCase:=Value;
   end else FTypeCase:=Value;
  end;
end;

procedure TNewCheckBox.SetLinks(Value: TTypeLinks);
begin
  FLinks.Assign(Value);
end;

procedure TNewCheckBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if FNoNotify then
   if (Operation=opRemove) and (AComponent=Self) then begin
    RemoveFromLinks(Self);
   end;
end;

procedure TNewCheckBox.Click;
begin
  if not ((csDesigning in ComponentState)or
          (csLoading in ComponentState)or
          (csReading in ComponentState)) then
   ChangeToOther(Self,FLinks);
  inherited;
end;

procedure TNewCheckBox.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if isViewHintOnFocus then ViewHintExByControl(Self);
end;

procedure TNewCheckBox.CMExit(var Message: TCMExit);
begin
  CancelHintEx;
  inherited;
end;

function TNewCheckBox.GetCaption: String;
begin
  Result:=inherited Caption;
end;

procedure TNewCheckBox.SetCaption(const Value: String);
begin
  inherited Caption:=Value;
  if Trim(FText)='' then
    FText:=Value;
end;

{ TNewRadioButton }

constructor TNewRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinks:=TTypeLinks.Create;
  FNoNotify:=true;
  FBlocking:=false;
  ShowHint:=true;
end;

destructor TNewRadioButton.Destroy;
begin
  FNoNotify:=false;
  FLinks.Free;
  inherited Destroy;
end;

procedure TNewRadioButton.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewRadioButton.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewRadioButton.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewRadioButton.SetTypeCase(Value: TTypeCase);
begin
  if Value<>FTypeCase then begin
   if Value<>tcNone then begin
    if isOtherControlConsistProp(Parent,Value) then begin
     if (not (csLoading in ComponentState))or (not (csReading in ComponentState)) then
      ShowError(Application.Handle,Format(CasePropError,[DocFieldName]));
//     MessageBox(Application.Handle,Pchar(Format(CasePropError,[Self.Name])),'������',MB_ICONERROR);
    end else
     FTypeCase:=Value;
   end else FTypeCase:=Value;
  end;
end;

procedure TNewRadioButton.SetLinks(Value: TTypeLinks);
begin
  FLinks.Assign(Value);
end;

procedure TNewRadioButton.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if FNoNotify then
   if (Operation=opRemove) and (AComponent=Self) then begin
    RemoveFromLinks(Self);
   end;
end;

procedure TNewRadioButton.Click;
begin
  if not ((csDesigning in ComponentState)or
          (csLoading in ComponentState)or
          (csReading in ComponentState)) then
   ChangeToOther(Self,FLinks);
  inherited;
end;

procedure TNewRadioButton.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if isViewHintOnFocus then ViewHintExByControl(Self);
end;

procedure TNewRadioButton.CMExit(var Message: TCMExit);
begin
  CancelHintEx;
  inherited;
end;

function TNewRadioButton.GetCaption: String;
begin
  Result:=inherited Caption;
end;

procedure TNewRadioButton.SetCaption(const Value: String);
begin
  inherited Caption:=Value;
  if Trim(FText)='' then
    FText:=Value;
end;

{ TNewListBox }

constructor TNewListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinks:=TTypeLinks.Create;
  FNoNotify:=true;
  FBlocking:=false;
  FLabelPosition := lpLeftTop;
  SetupInternalLabel;
  ShowHint:=true;
end;

destructor TNewListBox.Destroy;
begin
  FEditLabel.Free;
  FNoNotify:=false;
  FLinks.Free;
  inherited Destroy;
end;

procedure TNewListBox.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewListBox.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewListBox.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewListBox.SetTypeCase(Value: TTypeCase);
begin
  if Value<>FTypeCase then begin
   if Value<>tcNone then begin
    if isOtherControlConsistProp(Parent,Value) then begin
     if (not (csLoading in ComponentState))or (not (csReading in ComponentState)) then
      ShowError(Application.Handle,Format(CasePropError,[DocFieldName]));
//     MessageBox(Application.Handle,Pchar(Format(CasePropError,[Self.Name])),'������',MB_ICONERROR);
    end else
     FTypeCase:=Value;
   end else FTypeCase:=Value;
  end;
end;

procedure TNewListBox.SetLinks(Value: TTypeLinks);
begin
  FLinks.Assign(Value);
end;

procedure TNewListBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
  if FNoNotify then
   if (Operation=opRemove) and (AComponent=Self) then begin
    RemoveFromLinks(Self);
   end;
end;

procedure TNewListBox.Click;
begin
  if not ((csDesigning in ComponentState)or
          (csLoading in ComponentState)or
          (csReading in ComponentState)) then
   ChangeToOther(Self,FLinks);
  inherited;
end;

procedure TNewListBox.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.BiDiMode := BiDiMode;
end;

procedure TNewListBox.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Enabled := Enabled;
end;

procedure TNewListBox.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Visible := Visible;
end;

procedure TNewListBox.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if isViewHintOnFocus then ViewHintExByControl(Self);
end;

procedure TNewListBox.CMExit(var Message: TCMExit);
begin
  CancelHintEx;
  inherited;
end;

procedure TNewListBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetLabelPosition(FLabelPosition);
end;

procedure TNewListBox.SetLabelPosition(const Value: TLabelPosition);
begin
  if FEditLabel = nil then exit;
  FEditLabel.SetLabelPosition(Value);
  FEditLabel.Visible:=Visible;
  FLabelPosition := Value;
end;

procedure TNewListBox.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FEditLabel = nil then exit;
  FEditLabel.Parent := AParent;
end;

function TNewListBox.GetLabelCaption: String;
begin
  Result:='';
  if FEditLabel = nil then exit;
  Result:=FEditLabel.Caption;
end;

procedure TNewListBox.SetLabelCaption(Value: string);
begin
  if FEditLabel = nil then exit;
  if Value<>FEditLabel.Caption then begin
    FEditLabel.Caption:=Value;
    SetLabelPosition(FLabelPosition);
  end;
end;

procedure TNewListBox.SetupInternalLabel;
begin
  if Assigned(FEditLabel) then exit;
  FEditLabel := TBoundLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;
  FEditLabel.SetDesigning(false,false);
end;

procedure TNewListBox.FillSubs;
var
  ii: Integer;
begin
  if FAutoFillSubs then
    if Trim(FSubs)<>'' then begin
      ii:=ItemIndex;
      FillSubsToStrings(FSubs,Items);
      ItemIndex:=ii;
    end;  
end;


{ TNewRadioGroup }

constructor TNewRadioGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinks:=TTypeLinks.Create;
  FNoNotify:=true;
  FBlocking:=false;
  ShowHint:=true;
end;

destructor TNewRadioGroup.Destroy;
begin
  FNoNotify:=false;
  FLinks.Free;
  inherited Destroy;
end;

procedure TNewRadioGroup.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewRadioGroup.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewRadioGroup.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewRadioGroup.SetTypeCase(Value: TTypeCase);
begin
  if Value<>FTypeCase then begin
   if Value<>tcNone then begin
    if isOtherControlConsistProp(Parent,Value) then begin
     if (not (csLoading in ComponentState))or (not (csReading in ComponentState)) then
      ShowError(Application.Handle,Format(CasePropError,[DocFieldName]));
//     MessageBox(Application.Handle,Pchar(Format(CasePropError,[Self.Name])),'������',MB_ICONERROR);
    end else
     FTypeCase:=Value;
   end else FTypeCase:=Value;
  end; 
end;

procedure TNewRadioGroup.SetLinks(Value: TTypeLinks);
begin
  FLinks.Assign(Value);
end;

procedure TNewRadioGroup.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if FNoNotify then
   if (Operation=opRemove) and (AComponent=Self) then begin
    RemoveFromLinks(Self);
   end;
end;

procedure TNewRadioGroup.Click;
begin
  if not ((csDesigning in ComponentState)or
          (csLoading in ComponentState)or
          (csReading in ComponentState)) then
   ChangeToOther(Self,FLinks);
  inherited;
end;

procedure TNewRadioGroup.FillSubs;
var
  ii: Integer;
begin
  if FAutoFillSubs then
    if Trim(FSubs)<>'' then begin
      ii:=ItemIndex;
      FillSubsToStrings(FSubs,Items);
      ItemIndex:=ii;
    end;  
end;

procedure TNewRadioGroup.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if isViewHintOnFocus then ViewHintExByControl(Self);
end;

procedure TNewRadioGroup.CMExit(var Message: TCMExit);
begin
  CancelHintEx;
  inherited;
end;

{ TNewMaskEdit }

constructor TNewMaskEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinks:=TTypeLinks.Create;
  FNoNotify:=true;
  FBlocking:=false;
  FLabelPosition := lpLeftCenter;
  SetupInternalLabel;
  ShowHint:=true;
end;

destructor TNewMaskEdit.Destroy;
begin
  FEditLabel.Free;
  FNoNotify:=false;
  FLinks.Free;
  inherited Destroy;
end;

procedure TNewMaskEdit.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewMaskEdit.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewMaskEdit.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewMaskEdit.SetTypeCase(Value: TTypeCase);
begin
  if Value<>FTypeCase then begin
   if Value<>tcNone then begin
    if isOtherControlConsistProp(Parent,Value) then begin
     if (not (csLoading in ComponentState))or (not (csReading in ComponentState)) then
      ShowError(Application.Handle,Format(CasePropError,[DocFieldName]));
//     MessageBox(Application.Handle,Pchar(Format(CasePropError,[Self.Name])),'������',MB_ICONERROR);
    end else
     FTypeCase:=Value;
   end else FTypeCase:=Value;
  end;
end;

procedure TNewMaskEdit.SetLinks(Value: TTypeLinks);
begin
  FLinks.Assign(Value);
end;

procedure TNewMaskEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
  if FNoNotify then
   if (Operation=opRemove) and (AComponent=Self) then begin
    RemoveFromLinks(Self);
   end;
end;

procedure TNewMaskEdit.Change;
begin
  if not ((csDesigning in ComponentState)or
          (csLoading in ComponentState)or
          (csReading in ComponentState)) then
   ChangeToOther(Self,FLinks);
  inherited;
end;

procedure TNewMaskEdit.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.BiDiMode := BiDiMode;
end;

procedure TNewMaskEdit.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Enabled := Enabled;
end;

procedure TNewMaskEdit.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Visible := Visible;
end;

procedure TNewMaskEdit.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if FAutoOpenSubs then
    if Trim(FSubs)<>'' then
      if Trim(Text)='' then
        OpenSubs(Self,true,FSubs,Text,true);
  if isViewHintOnFocus then ViewHintExByControl(Self);
end;

procedure TNewMaskEdit.CMExit(var Message: TCMExit);
begin
  CancelHintEx;
  inherited;
end;

procedure TNewMaskEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetLabelPosition(FLabelPosition);
end;

procedure TNewMaskEdit.SetLabelPosition(const Value: TLabelPosition);
begin
  if FEditLabel = nil then exit;
  FEditLabel.SetLabelPosition(Value);
  FEditLabel.Visible:=Visible;
  FLabelPosition := Value;
end;

procedure TNewMaskEdit.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FEditLabel = nil then exit;
  FEditLabel.Parent := AParent;
end;

function TNewMaskEdit.GetLabelCaption: String;
begin
  Result:='';
  if FEditLabel = nil then exit;
  Result:=FEditLabel.Caption;
end;

procedure TNewMaskEdit.SetLabelCaption(Value: string);
begin
  if FEditLabel = nil then exit;
  if Value<>FEditLabel.Caption then begin
    FEditLabel.Caption:=Value;
    SetLabelPosition(FLabelPosition);
  end;
end;

procedure TNewMaskEdit.SetupInternalLabel;
begin
  if Assigned(FEditLabel) then exit;
  FEditLabel := TBoundLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;
  FEditLabel.SetDesigning(false,false);
end;


{ TNewRichEdit }

constructor TNewRichEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinks:=TTypeLinks.Create;
  FNoNotify:=true;
  FBlocking:=false;
  FLabelPosition := lpLeftTop;
  SetupInternalLabel;
  ShowHint:=true;
end;

destructor TNewRichEdit.Destroy;
begin
  FEditLabel.Free;
  FNoNotify:=false;
  FLinks.Free;
  inherited Destroy;
end;

procedure TNewRichEdit.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewRichEdit.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewRichEdit.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewRichEdit.SetTypeCase(Value: TTypeCase);
begin
  if Value<>FTypeCase then begin
   if Value<>tcNone then begin
    if isOtherControlConsistProp(Parent,Value) then begin
     if (not (csLoading in ComponentState))or (not (csReading in ComponentState)) then
      ShowError(Application.Handle,Format(CasePropError,[DocFieldName]));
//     MessageBox(Application.Handle,Pchar(Format(CasePropError,[Self.Name])),'������',MB_ICONERROR);
    end else
     FTypeCase:=Value;
   end else FTypeCase:=Value;
  end;
end;

procedure TNewRichEdit.SetLinks(Value: TTypeLinks);
begin
  FLinks.Assign(Value);
end;

procedure TNewRichEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
  if FNoNotify then
   if (Operation=opRemove) and (AComponent=Self) then begin
    RemoveFromLinks(Self);
   end;
end;

procedure TNewRichEdit.Change;
begin
  if not ((csDesigning in ComponentState)or
          (csLoading in ComponentState)or
          (csReading in ComponentState)) then
   ChangeToOther(Self,FLinks);
  inherited;
end;

procedure TNewRichEdit.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.BiDiMode := BiDiMode;
end;

procedure TNewRichEdit.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Enabled := Enabled;
end;

procedure TNewRichEdit.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Visible := Visible;
end;

procedure TNewRichEdit.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if FAutoOpenSubs then
    if Trim(FSubs)<>'' then
      if Trim(Text)='' then
        OpenSubs(Self,true,FSubs,Text,true);
  if isViewHintOnFocus then ViewHintExByControl(Self);
end;

procedure TNewRichEdit.CMExit(var Message: TCMExit);
begin
  CancelHintEx;
  inherited;
end;

procedure TNewRichEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetLabelPosition(FLabelPosition);
end;

procedure TNewRichEdit.SetLabelPosition(const Value: TLabelPosition);
begin
  if FEditLabel = nil then exit;
  FEditLabel.SetLabelPosition(Value);
  FEditLabel.Visible:=Visible;
  FLabelPosition := Value;
end;

procedure TNewRichEdit.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FEditLabel = nil then exit;
  FEditLabel.Parent := AParent;
end;

function TNewRichEdit.GetLabelCaption: String;
begin
  Result:='';
  if FEditLabel = nil then exit;
  Result:=FEditLabel.Caption;
end;

procedure TNewRichEdit.SetLabelCaption(Value: string);
begin
  if FEditLabel = nil then exit;
  if Value<>FEditLabel.Caption then begin
    FEditLabel.Caption:=Value;
    SetLabelPosition(FLabelPosition);
  end;
end;

procedure TNewRichEdit.SetupInternalLabel;
begin
  if Assigned(FEditLabel) then exit;
  FEditLabel := TBoundLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;
  FEditLabel.SetDesigning(false,false);
end;


{ TNewDateTimePicker }

constructor TNewDateTimePicker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinks:=TTypeLinks.Create;
  FNoNotify:=true;
  FBlocking:=false;
  FLabelPosition := lpLeftCenter;
  SetupInternalLabel;
  ShowHint:=true;
end;

destructor TNewDateTimePicker.Destroy;
begin
  GlobalTimer.RemoveControl(Self);
  FEditLabel.Free;
  FNoNotify:=false;
  FLinks.Free;
  inherited Destroy;
end;

procedure TNewDateTimePicker.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewDateTimePicker.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewDateTimePicker.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewDateTimePicker.SetLinks(Value: TTypeLinks);
begin
  FLinks.Assign(Value);
end;

procedure TNewDateTimePicker.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
  if FNoNotify then
   if (Operation=opRemove) and (AComponent=Self) then begin
    RemoveFromLinks(Self);
   end;
end;

procedure TNewDateTimePicker.Change;
begin
  if not ((csDesigning in ComponentState)or
          (csLoading in ComponentState)or
          (csReading in ComponentState)) then
   ChangeToOther(Self,FLinks);
  inherited;
end;

procedure TNewDateTimePicker.SetActiveTimer(Value: Boolean);
begin
  FActiveTimer:=Value;
  ChangeActiveTimer;
end;

procedure TNewDateTimePicker.ChangeActiveTimer;
begin
  if FActiveTimer then begin
    GlobalTimer.AddControl(Self)
  end else GlobalTimer.RemoveControl(Self);
end;

procedure TNewDateTimePicker.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.BiDiMode := BiDiMode;
end;

procedure TNewDateTimePicker.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Enabled := Enabled;
end;

procedure TNewDateTimePicker.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Visible := Visible;
end;

procedure TNewDateTimePicker.CMEnter(var Message: TCMEnter);
var
  s: string;
begin
  inherited;
  if FAutoOpenSubs then
    if Trim(FSubs)<>'' then begin
      case Kind of
        dtkDate: s:=DateToStr(DateTime);
        dtkTime: s:=TimeToStr(DateTime);
      end;
      if Trim(s)='' then begin
        OpenSubs(Self,true,FSubs,s,true);
      end;
    end;
  if isViewHintOnFocus then ViewHintExByControl(Self);
end;

procedure TNewDateTimePicker.CMExit(var Message: TCMExit);
begin
  CancelHintEx;
  inherited;
end;

procedure TNewDateTimePicker.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetLabelPosition(FLabelPosition);
end;

procedure TNewDateTimePicker.SetLabelPosition(const Value: TLabelPosition);
begin
  if FEditLabel = nil then exit;
  FEditLabel.SetLabelPosition(Value);
  FEditLabel.Visible:=Visible;
  FLabelPosition := Value;
end;

procedure TNewDateTimePicker.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FEditLabel = nil then exit;
  FEditLabel.Parent := AParent;
end;

function TNewDateTimePicker.GetLabelCaption: String;
begin
  Result:='';
  if FEditLabel = nil then exit;
  Result:=FEditLabel.Caption;
end;

procedure TNewDateTimePicker.SetLabelCaption(Value: string);
begin
  if FEditLabel = nil then exit;
  if Value<>FEditLabel.Caption then begin
    FEditLabel.Caption:=Value;
    SetLabelPosition(FLabelPosition);
  end;
end;

procedure TNewDateTimePicker.SetupInternalLabel;
begin
  if Assigned(FEditLabel) then exit;
  FEditLabel := TBoundLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;
  FEditLabel.SetDesigning(false,false);
end;

{ TNewRxCalcEdit }

constructor TNewRxCalcEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinks:=TTypeLinks.Create;
  FNoNotify:=true;
  FBlocking:=false;
  FLabelPosition := lpLeftCenter;
  SetupInternalLabel;
  ShowHint:=true;
end;

destructor TNewRxCalcEdit.Destroy;
begin
  FEditLabel.Free;
  FNoNotify:=false;
  FLinks.Free;
  inherited Destroy;
end;

procedure TNewRxCalcEdit.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewRxCalcEdit.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewRxCalcEdit.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewRxCalcEdit.SetLinks(Value: TTypeLinks);
begin
  FLinks.Assign(Value);
end;

procedure TNewRxCalcEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
  if FNoNotify then
   if (Operation=opRemove) and (AComponent=Self) then begin
    RemoveFromLinks(Self);
   end;
end;

procedure TNewRxCalcEdit.Change;
begin
  if not ((csDesigning in ComponentState)or
          (csLoading in ComponentState)or
          (csReading in ComponentState)) then
   ChangeToOther(Self,FLinks);
  inherited;
end;

procedure TNewRxCalcEdit.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.BiDiMode := BiDiMode;
end;

procedure TNewRxCalcEdit.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Enabled := Enabled;
end;

procedure TNewRxCalcEdit.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Visible := Visible;
end;

procedure TNewRxCalcEdit.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if FAutoOpenSubs then
    if Trim(FSubs)<>'' then
      if Trim(Text)='' then
        OpenSubs(Self,true,FSubs,Text,true);
  if isViewHintOnFocus then ViewHintExByControl(Self);
end;

procedure TNewRxCalcEdit.CMExit(var Message: TCMExit);
begin
  CancelHintEx;
  inherited;
end;

procedure TNewRxCalcEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetLabelPosition(FLabelPosition);
end;

procedure TNewRxCalcEdit.SetLabelPosition(const Value: TLabelPosition);
begin
  if FEditLabel = nil then exit;
  FEditLabel.SetLabelPosition(Value);
  FEditLabel.Visible:=Visible;
  FLabelPosition := Value;
end;

procedure TNewRxCalcEdit.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FEditLabel = nil then exit;
  FEditLabel.Parent := AParent;
end;

function TNewRxCalcEdit.GetLabelCaption: String;
begin
  Result:='';
  if FEditLabel = nil then exit;
  Result:=FEditLabel.Caption;
end;

procedure TNewRxCalcEdit.SetLabelCaption(Value: string);
begin
  if FEditLabel = nil then exit;
  if Value<>FEditLabel.Caption then begin
    FEditLabel.Caption:=Value;
    SetLabelPosition(FLabelPosition);
  end;
end;

procedure TNewRxCalcEdit.SetupInternalLabel;
begin
  if Assigned(FEditLabel) then exit;
  FEditLabel := TBoundLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;
  FEditLabel.SetDesigning(false,false);
end;

{ TNewRxDateEdit }

constructor TNewRxDateEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinks:=TTypeLinks.Create;
  FNoNotify:=true;
  CheckOnExit:=true;
  FBlocking:=false;
  FDefaultWorkDate:=false;
  FLabelPosition := lpLeftCenter;
  SetupInternalLabel;
  ShowHint:=true;
end;

destructor TNewRxDateEdit.Destroy;
begin
  FEditLabel.Free;
  FNoNotify:=false;
  FLinks.Free;
  inherited Destroy;
end;

procedure TNewRxDateEdit.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewRxDateEdit.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewRxDateEdit.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewRxDateEdit.SetLinks(Value: TTypeLinks);
begin
  FLinks.Assign(Value);
end;

procedure TNewRxDateEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
  if FNoNotify then
   if (Operation=opRemove) and (AComponent=Self) then begin
    RemoveFromLinks(Self);
   end;
end;

procedure TNewRxDateEdit.Change;
begin
  if not ((csDesigning in ComponentState)or
          (csLoading in ComponentState)or
          (csReading in ComponentState)) then
   ChangeToOther(Self,FLinks);
  inherited;
end;

procedure TNewRxDateEdit.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.BiDiMode := BiDiMode;
end;

procedure TNewRxDateEdit.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Enabled := Enabled;
end;

procedure TNewRxDateEdit.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Visible := Visible;
end;

procedure TNewRxDateEdit.CMEnter(var Message: TCMEnter);
var
  s: string;
begin
  inherited;
  if FAutoOpenSubs then
    if Trim(FSubs)<>'' then begin
      s:=iff(Date>0,DateToStr(Date),'');
      if Trim(s)='' then
        OpenSubs(Self,true,FSubs,s,true);
    end;
  if isViewHintOnFocus then ViewHintExByControl(Self);
end;

procedure TNewRxDateEdit.CMExit(var Message: TCMExit);
begin
  CancelHintEx;
  inherited;
end;

procedure TNewRxDateEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetLabelPosition(FLabelPosition);
end;

procedure TNewRxDateEdit.SetLabelPosition(const Value: TLabelPosition);
begin
  if FEditLabel = nil then exit;
  FEditLabel.SetLabelPosition(Value);
  FEditLabel.Visible:=Visible;
  FLabelPosition := Value;
end;

procedure TNewRxDateEdit.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FEditLabel = nil then exit;
  FEditLabel.Parent := AParent;
end;

function TNewRxDateEdit.GetLabelCaption: String;
begin
  Result:='';
  if FEditLabel = nil then exit;
  Result:=FEditLabel.Caption;
end;

procedure TNewRxDateEdit.SetLabelCaption(Value: string);
begin
  if FEditLabel = nil then exit;
  if Value<>FEditLabel.Caption then begin
    FEditLabel.Caption:=Value;
    SetLabelPosition(FLabelPosition);
  end;
end;

procedure TNewRxDateEdit.SetupInternalLabel;
begin
  if Assigned(FEditLabel) then exit;
  FEditLabel := TBoundLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;
  FEditLabel.SetDesigning(false,false);
end;

{ TNewComboBoxMarkCar }

constructor TNewComboBoxMarkCar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OnKeyPress:=SelfOnKeyPress;
  FLinks:=TTypeLinks.Create;
  FNoNotify:=true;
  FBlocking:=false;
  FLabelPosition := lpLeftCenter;
  SetupInternalLabel;
  ShowHint:=true;
end;

destructor TNewComboBoxMarkCar.Destroy;
begin
  FEditLabel.Free;
  FNoNotify:=false;
  FLinks.Free;
  inherited Destroy;
end;

procedure TNewComboBoxMarkCar.CreateWnd;
begin
  inherited CreateWnd;
  if FSaveItems <> nil then
  begin
    Items.Assign(FSaveItems);
    FSaveItems.Free;
    FSaveItems := nil;
    if FSaveIndex <> -1 then
    begin
      if Items.Count < FSaveIndex then FSaveIndex := Items.Count;
      SendMessage(Handle, CB_SETCURSEL, FSaveIndex, 0);
    end;
  end;
end;

procedure TNewComboBoxMarkCar.DestroyWnd;
begin
  if Items.Count > 0 then
  begin
    FSaveIndex := ItemIndex;
    FSaveItems := TStringList.Create;
    try
      FSaveItems.Assign(Items);
      Items.Clear;
    except

    end;  
  end;
  inherited DestroyWnd;
end;

procedure TNewComboBoxMarkCar.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited CreateWindowHandle(Params);
end;

procedure TNewComboBoxMarkCar.DestroyWindowHandle;
begin
  inherited DestroyWindowHandle;
end;

procedure TNewComboBoxMarkCar.FillMarkCar;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourglass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  Items.BeginUpdate;
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select name from '+TableMarkCar+' order by name';
    qr.SQL.Add(sqls);
    qr.Active:=true;
    qr.First;
    Items.Clear;
    while not qr.Eof do begin
      Items.Add(qr.fieldbyname('name').AsString);
      qr.Next;
    end;
  finally
    Items.EndUpdate;
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TNewComboBoxMarkCar.AddMarkCar;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourglass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  Items.BeginUpdate;
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select name from '+TableMarkCar+' where Upper(name)='+QuotedStr(AnsiUpperCase(Trim(Text)));
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if qr.RecordCount<>0 then exit;
    qr.Active:=false;
    qr.SQL.Clear;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+TableMarkCar+' (name) values ('''+Trim(Text)+''')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.CommitRetaining;

  finally
    Items.EndUpdate;
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TNewComboBoxMarkCar.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewComboBoxMarkCar.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewComboBoxMarkCar.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewComboBoxMarkCar.SelfOnKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TNewComboBoxMarkCar.SetLinks(Value: TTypeLinks);
begin
  FLinks.Assign(Value);
end;

procedure TNewComboBoxMarkCar.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
  if FNoNotify then
   if (Operation=opRemove) and (AComponent=Self) then begin
    RemoveFromLinks(Self);
   end;
end;

procedure TNewComboBoxMarkCar.Change;
begin
  if not ((csDesigning in ComponentState)or
          (csLoading in ComponentState)or
          (csReading in ComponentState)) then
   ChangeToOther(Self,FLinks);
  inherited;
end;

procedure TNewComboBoxMarkCar.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.BiDiMode := BiDiMode;
end;

procedure TNewComboBoxMarkCar.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Enabled := Enabled;
end;

procedure TNewComboBoxMarkCar.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Visible := Visible;
end;

procedure TNewComboBoxMarkCar.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if FAutoOpenSubs then
    if Trim(FSubs)<>'' then
      if Trim(Text)='' then
        OpenSubs(Self,true,FSubs,Text,true);
  if isViewHintOnFocus then ViewHintExByControl(Self);
end;

procedure TNewComboBoxMarkCar.CMExit(var Message: TCMExit);
begin
  CancelHintEx;
  inherited;
end;

procedure TNewComboBoxMarkCar.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetLabelPosition(FLabelPosition);
end;

procedure TNewComboBoxMarkCar.SetLabelPosition(const Value: TLabelPosition);
begin
  if FEditLabel = nil then exit;
  FEditLabel.SetLabelPosition(Value);
  FEditLabel.Visible:=Visible;
  FLabelPosition := Value;
end;

procedure TNewComboBoxMarkCar.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FEditLabel = nil then exit;
  FEditLabel.Parent := AParent;
end;

function TNewComboBoxMarkCar.GetLabelCaption: String;
begin
  Result:='';
  if FEditLabel = nil then exit;
  Result:=FEditLabel.Caption;
end;

procedure TNewComboBoxMarkCar.SetLabelCaption(Value: string);
begin
  if FEditLabel = nil then exit;
  if Value<>FEditLabel.Caption then begin
    FEditLabel.Caption:=Value;
    SetLabelPosition(FLabelPosition);
  end;
end;

procedure TNewComboBoxMarkCar.SetupInternalLabel;
begin
  if Assigned(FEditLabel) then exit;
  FEditLabel := TBoundLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;
  FEditLabel.SetDesigning(false,false);
end;

function TNewComboBoxMarkCar.GetItemsClass: TCustomComboBoxStringsClass;
begin
  Result:=TNewComboBoxStrings;
end;

{ TNewComboBoxColor }

constructor TNewComboBoxColor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OnKeyPress:=SelfOnKeyPress;
  FLinks:=TTypeLinks.Create;
  FNoNotify:=true;
  FBlocking:=false;
  FLabelPosition := lpLeftCenter;
  SetupInternalLabel;
  ShowHint:=true;
end;

destructor TNewComboBoxColor.Destroy;
begin
  FEditLabel.Free;
  FNoNotify:=false;
  FLinks.Free;
  inherited Destroy;
end;

procedure TNewComboBoxColor.FillColor;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourglass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  Items.BeginUpdate;
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select name from '+TableColor+' order by name';
    qr.SQL.Add(sqls);
    qr.Active:=true;
    qr.First;
    Items.Clear;
    while not qr.Eof do begin
      Items.Add(qr.fieldbyname('name').AsString);
      qr.Next;
    end;
  finally
    Items.EndUpdate;
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TNewComboBoxColor.AddColor;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourglass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  Items.BeginUpdate;
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select name from '+TableColor+' where Upper(name)='+QuotedStr(AnsiUpperCase(Trim(Text)));
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if qr.RecordCount<>0 then exit;
    qr.Active:=false;
    qr.SQL.Clear;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+TableColor+' (name) values ('''+Trim(Text)+''')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.CommitRetaining;

  finally
    Items.EndUpdate;
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TNewComboBoxColor.SetDocFile(Value: String);
begin
  if Value<>FDocFile then
   FDocFile:=Value;
end;

procedure TNewComboBoxColor.SetDocFieldName(Value: String);
begin
  if Value<>FDocFieldName then
   FDocFieldName:=Value;
end;

procedure TNewComboBoxColor.WndProc(var Message: TMessage);
begin
  inherited;
end;

procedure TNewComboBoxColor.SelfOnKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TNewComboBoxColor.SetLinks(Value: TTypeLinks);
begin
  FLinks.Assign(Value);
end;

procedure TNewComboBoxColor.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
  if FNoNotify then
   if (Operation=opRemove) and (AComponent=Self) then begin
    RemoveFromLinks(Self);
   end;
end;

procedure TNewComboBoxColor.Change;
begin
  if not ((csDesigning in ComponentState)or
          (csLoading in ComponentState)or
          (csReading in ComponentState)) then
   ChangeToOther(Self,FLinks);
  inherited;
end;

procedure TNewComboBoxColor.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.BiDiMode := BiDiMode;
end;

procedure TNewComboBoxColor.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Enabled := Enabled;
end;

procedure TNewComboBoxColor.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  FEditLabel.Visible := Visible;
end;

procedure TNewComboBoxColor.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if FAutoOpenSubs then
    if Trim(FSubs)<>'' then
      if Trim(Text)='' then
        OpenSubs(Self,true,FSubs,Text,true);
  if isViewHintOnFocus then ViewHintExByControl(Self);
end;

procedure TNewComboBoxColor.CMExit(var Message: TCMExit);
begin
  CancelHintEx;
  inherited;
end;

procedure TNewComboBoxColor.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetLabelPosition(FLabelPosition);
end;

procedure TNewComboBoxColor.SetLabelPosition(const Value: TLabelPosition);
begin
  if FEditLabel = nil then exit;
  FEditLabel.SetLabelPosition(Value);
  FEditLabel.Visible:=Visible;
  FLabelPosition := Value;
end;

procedure TNewComboBoxColor.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FEditLabel = nil then exit;
  FEditLabel.Parent := AParent;
end;

function TNewComboBoxColor.GetLabelCaption: String;
begin
  Result:='';
  if FEditLabel = nil then exit;
  Result:=FEditLabel.Caption;
end;

procedure TNewComboBoxColor.SetLabelCaption(Value: string);
begin
  if FEditLabel = nil then exit;
  if Value<>FEditLabel.Caption then begin
    FEditLabel.Caption:=Value;
    SetLabelPosition(FLabelPosition);
  end;
end;

procedure TNewComboBoxColor.SetupInternalLabel;
begin
  if Assigned(FEditLabel) then exit;
  FEditLabel := TBoundLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;
  FEditLabel.SetDesigning(false,false);
end;

function TNewComboBoxColor.GetItemsClass: TCustomComboBoxStringsClass;
begin
  Result:=TNewComboBoxStrings;
end;


////////////////////

function GetBoundLabel(ct: TControl): TBoundLabel;
begin
  Result:=nil;
  if ct is TNewLabel then result:=nil;
  if ct is TNewEdit then  result:=TNewEdit(ct).EditLabel;
  if ct is TNewComboBox then result:=TNewComboBox(ct).EditLabel;
  if ct is TNewMemo then  result:=TNewMemo(ct).EditLabel;
  if ct is TNewListBox then Result:=TNewListBox(ct).EditLabel;
  if ct is TNewMaskEdit then Result:=TNewMaskEdit(ct).EditLabel;
  if ct is TNewRichEdit then Result:=TNewRichEdit(ct).EditLabel;
  if ct is TNewDateTimePicker then result:=TNewDateTimePicker(ct).EditLabel;
  if ct is TNewRXCalcEdit then result:=TNewRXCalcEdit(ct).EditLabel;
  if ct is TNewRXDateEdit then result:=TNewRXDateEdit(ct).EditLabel;
  if ct is TNewComboBoxMarkCar then result:=TNewComboBoxMarkCar(ct).EditLabel;
  if ct is TNewComboBoxColor then result:=TNewComboBoxColor(ct).EditLabel;
end;

function ViewHintExByControl(ct: TControl): Boolean;
var
  pt: TPoint;
  HintWinRect: TRect;
  Parent: TWinControl;
begin
  Result:=false;
  if ct=nil then exit;
  Parent:=ct.Parent;
  if Parent=nil then exit;
  if ct.ShowHint then begin
    if Trim(ct.Hint)<>'' then begin
      if Parent is TScrollBox then
        TScrollBox(Parent).ScrollInView(ct);
      pt:=Point(ct.Left+4,ct.Top+ct.Height+4);
      pt:=Parent.ClientToScreen(pt);
      if HintEx=nil then begin
        HintEx:=TBisHintWindowEx.Create(nil);
        HintEx.Color:=clInfoBk;
        if Assigned(HintEx.HintComponent) then begin

          HintEx.HintComponent.Control:=ct;
          ct.ShowHint:=false;
          HintEx.HintComponent.Caption.Text:=ct.Hint;

          HintEx.HintComponent.Font.Assign(Screen.HintFont);
          HintEx.HintComponent.Pen.Color:=clBlack;
          HintWinRect:=HintEx.CalcHintRect(Screen.Width,ct.Hint,HintEx.HintComponent);
          OffsetRect(HintWinRect, pt.x, pt.y);
          HintEx.ActivateHintData(HintWinRect,ct.Hint,HintEx.HintComponent);
          StartHintTimer;
          Result:=true;
        end;
      end;
    end else CancelHintEx;
  end else CancelHintEx;
end;

procedure CancelHintEx;
begin
  if HintEx<>nil then begin
    if Assigned(HintEx.HintComponent) then begin
      if Assigned(HintEx.HintComponent.Control) then
        HintEx.HintComponent.Control.ShowHint:=true;
    end;
    HintEx.Free;
    HintEx:=nil;
  end;
end;

procedure StopHintTimer;
begin
  if FTimerHandle <> 0 then
  begin
    KillTimer(0, FTimerHandle);
    FTimerHandle := 0;
  end;
end;

procedure HintTimerProc(Wnd: HWnd; Msg, TimerID, SysTime: Longint); stdcall;
begin
  StopHintTimer;
  CancelHintEx;
end;

procedure StartHintTimer;
var
  Value: Integer;
begin
  StopHintTimer;
  Value:=5000;
  FTimerHandle := SetTimer(0, 0, Value, @HintTimerProc);
  if FTimerHandle = 0 then CancelHintEx;
end;



initialization

  Classes.RegisterClass(TNewLabel);
  Classes.RegisterClass(TBoundLabel);
  Classes.RegisterClass(TNewEdit);
  Classes.RegisterClass(TNewComboBox);
  Classes.RegisterClass(TNewMemo);
  Classes.RegisterClass(TNewCheckBox);
  Classes.RegisterClass(TNewRadioButton);
  Classes.RegisterClass(TNewListBox);
  Classes.RegisterClass(TNewRadioGroup);
  Classes.RegisterClass(TNewMaskEdit);
  Classes.RegisterClass(TNewRichEdit);
  Classes.RegisterClass(TNewDateTimePicker);
  Classes.RegisterClass(TNewRxCalcEdit);
  Classes.RegisterClass(TNewRxDateEdit);
  Classes.RegisterClass(TNewComboBoxMarkCar);
  Classes.RegisterClass(TNewComboBoxColor);


  ////////////////////
  Classes.RegisterClass(TLabel);
  Classes.RegisterClass(TEdit);
  Classes.RegisterClass(TComboBox);
  Classes.RegisterClass(TMemo);
  Classes.RegisterClass(TCheckBox);
  Classes.RegisterClass(TRadioButton);
  Classes.RegisterClass(TListBox);
  Classes.RegisterClass(TGroupBox);
  Classes.RegisterClass(TRadioGroup);
  Classes.RegisterClass(TPanel);
  Classes.RegisterClass(TSpeedButton);
  Classes.RegisterClass(TMaskEdit);
  Classes.RegisterClass(TImage);
  Classes.RegisterClass(TShape);
  Classes.RegisterClass(TBevel);
  Classes.RegisterClass(TScrollBox);
  Classes.RegisterClass(TSplitter);
  Classes.RegisterClass(TRichEdit);
  Classes.RegisterClass(TTrackBar);
  Classes.RegisterClass(TAnimate);
  Classes.RegisterClass(TDateTimePicker);
  Classes.RegisterClass(TPageControl);
  Classes.RegisterClass(TTabSheet);
  Classes.RegisterClass(TEditButton);
  
  Classes.RegisterClass(TRxCalcEdit);
  Classes.RegisterClass(TantAngleLabel);
  Classes.RegisterClass(TddgMarquee);

  Classes.RegisterClass(TDsnStage);
  Classes.RegisterClass(TDsnDPRegister);
  Classes.RegisterClass(TDsnMenuItem);
  Classes.RegisterClass(TDsnSelect);

  Classes.RegisterClass(TfmNewForm);

  GlobalTimer:=TNewTimer.Create(nil);

finalization
  CancelHintEx;
  GlobalTimer.Free;



end.
