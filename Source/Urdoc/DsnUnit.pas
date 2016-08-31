unit DsnUnit;

// Runtime Design System Version 2.x   June/08/1998
// Copyright(c) 1998 Kazuhiro Sasaki.

interface

uses
  Windows, Messages, SysUtils, {COMMCTRL,}Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TypInfo, ExtCtrls, Buttons, Grids,
  Clipbrd, Menus, COMCTRLS, DsnShape, DsnHandle, DsnList, DsnProp,
  DsnPanel, DsnMes, DsnLgMes, DsnAgent, DsnFunc, Udm;


type

  TDsnMenuItem = class(TMenuItem)
  private
    PropName:String;
    Value:String;
  end;


  TResizeMessage = record
    Msg: Cardinal;
    SLeft:Smallint;
    STop:Smallint;
    SWidth:Smallint;
    SHeight:Smallint;
    Result: Longint;
  end;

  TDsnStage = class;
  TDsnCtrl = class;
  TDsnRegister = class;

  TDsnList = class(TList)
  end;

  TDsnPartner = class(TComponent)
  private
    FDsnRegister: TDsnRegister;
  protected
    FDesigning: Boolean;
    procedure SetDsnRegister(Value:TDsnRegister);
    procedure SetDesigning(Value:Boolean);virtual;
    procedure CreateTargetList;
    procedure CreateMoveShape;
    function CheckCanSelect(Control: TControl): Boolean;
    function GetDsnList:TDsnList;
    function GetTargetList:TTargetList;
  public
    constructor Create(AOwner: TComponent); override;
    property DsnRegister: TDsnRegister read FDsnRegister write SetDsnRegister;
  end;

  TDsnRegister = class(TComponent)
  private
    FDesigning:Boolean;
    FDsnPanel:TCustomCmpPlt;
    FDsnStage:TDsnStage;
    FDsnInspector:TCustomInspector;
    FArrowButton:TArrowButton;
    FProps: TMultiProps;
    FControlMenu: TPopupMenu;
    FFormMenu: TPopupMenu;
    procedure SetFormMenu(Value: TPopupMenu);
    procedure SetControlMenu(Value: TPopupMenu);
  protected
    FDsnCtrlList: TDsnList;
    DsnNotifies: TList;
    DsnPartners: TList;
//    FLastTarget: TComponent;
    FTargetList: TTargetList;
    FParentCtrl: TWinControl;
    FX, FY: Integer;
    CutSizeX:Integer;
    CutSizeY:Integer;
    Color:TColor;
    PenWidth:Integer;
    FDsnControl:TComponent;
    FHandler: TMultiHandler;
    FShape: TMultiShape;
    procedure CreateSubClass;
    procedure DestroySubClass;
    procedure SetDsnStage(Value:TDsnStage);
    procedure SetDsnPanel(Value:TCustomCmpPlt);
    procedure SetDsnInspector(Value:TCustomInspector);
    procedure SetArrowButton(Value:TArrowButton);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure AlertClientDeath;virtual;
    procedure AlertTargetDeath;virtual;
    procedure SetDesigning(Value:Boolean);virtual;
    procedure CreateHandler;virtual;
    procedure CreateCopyShape;virtual;
    procedure CreateMoveShape;virtual;
    function CreateSubCtrl(AParent:TWinControl):TDsnCtrl;virtual;
    function CreateList:TTargetList;virtual;
    function CreateDsnList:TDsnList;virtual;
    function CreateProps:TMultiProps;
    procedure Cutting(var X, Y: Integer);
    procedure MouseDown(Client:TWinControl; Target:TComponent; MousePoint:TPoint; Shift: TShiftState);virtual;
    procedure MoseMove(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);virtual;
    procedure MoseUp(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);virtual;
    procedure MouseDownCreate(Client:TWinControl; Target:TComponent; MousePoint:TPoint; Shift: TShiftState);virtual;
    procedure MouseMoveCreate(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);virtual;
    procedure MouseUpCreate(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);virtual;
    procedure MouseDownMove(Client:TWinControl; Target:TComponent; MousePoint:TPoint; Shift: TShiftState);virtual;
    procedure MouseMoveMove(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);virtual;
    procedure MouseUpMove(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);virtual;
    procedure DbClick(Target:TControl; var Message: TWMMouse);virtual;
    procedure CallPopupMenu(Client:TWinControl; Target:TControl; XPos,YPos: Integer);virtual;
    procedure RButtonDown(Client:TWinControl; Target:TControl; XPos,YPos: Integer);virtual;
    function CanCopy:Boolean;virtual;
    function CanPaste:Boolean;virtual;
    function PasteZero:TWinControl;virtual;
    procedure Cut;virtual;
    procedure Copy;virtual;
    procedure Paste;virtual;
    procedure Delete;virtual;
    procedure ComponentsProcClipbrd(Component:TComponent);
    procedure CopyPaste(Ctrl:TControl;aParent:TWinControl);
    procedure ComponentsProc(Component:TComponent);virtual;
    procedure GiveName(Component: TComponent);virtual;
    procedure Resized(Control:TControl;var Message: TResizeMessage);virtual;
    procedure Moved(DeltaX,DeltaY: Integer);virtual;
    procedure Selected(Control:TControl;var Message: TMessage);virtual;
    procedure SelectByInspect(Control:TControl);
    procedure SetSubClass(AParent: TWinControl);
    procedure CreateContextMenu;virtual;
    procedure MenuMethod(Sender:TObject);virtual;
    procedure SortForDelete(List: TList);
    //procedure AddReceiveTargets(List: TReceiveTargets); virtual;
    function CheckCanSelect(Control: TControl): Boolean;
  public
    MainInsertPoint: TPoint;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Designing:Boolean read FDesigning write SetDesigning;
    function SameParent:Boolean;
    procedure ClearSelect;
    procedure AddPartners(Partner: TDsnPartner); virtual;
    procedure RemovePartners(Partner: TDsnPartner); virtual;
    procedure AddNotifies(List: TReceiveTargets); virtual;
    procedure CheckName(Reader:TReader; Component:TComponent; var Name:String);
  published
    property DsnStage:TDsnStage read FDsnStage write SetDsnStage;
    property DsnPanel:TCustomCmpPlt read FDsnPanel write SetDsnPanel;
    property DsnInspector: TCustomInspector read FDsnInspector write SetDsnInspector;
    property ControlMenu: TPopupMenu read FControlMenu write SetControlMenu;
    property FormMenu: TPopupMenu read FFormMenu write SetFormMenu;
    //Someday, DsnInspector property will be abolished  when TCustomInspector become a subclass of TDsnPartner.
    property ArrowButton: TArrowButton read FArrowButton write SetArrowButton;
    //Someday, ArrowButton property will be abolished when DsnInspector property is abolished.
  end;

  TRubberband = class(TPersistent)
  private
    FColor:TColor;
    FPenWidth:Integer;
    FMoveWidth:Integer;
    FMoveHeight:Integer;
  published
    property Color:TColor read FColor write FColor;
    property PenWidth:Integer read FPenWidth write FPenWidth;
    property MoveWidth:Integer read FMoveWidth write FMoveWidth;
    property MoveHeight:Integer read FMoveHeight write FMoveHeight;
  end;

  TSelectAccept = set of (saCreate, saMove);
  TSelectQuery = procedure
                    (Sender:TObject;Component:TComponent;
                           var CanSelect:TSelectAccept) of Object;
  TMoveQuery = procedure
                    (Sender:TObject;Component:TComponent;
                           var CanMove:Boolean) of Object;
  TCoverAccept = (caAllAccept, caNoAccept, caChildrenAccept);
  TCoverQuery = procedure
                    (Sender:TObject;Component:TComponent;
                           var CanCover:TCoverAccept) of Object;
  TControlCreate = procedure
                    (Sender:TObject;Component:TComponent)
                                                      of Object;
  TCallCompoEditor = procedure
                    (Sender:TObject;Component:TComponent)
                                                      of Object;
  TDsnStage = class(TPanel)
  private
    FDsnRegister: TDsnRegister;
    FSelfProps:TStrings;
    FOutProps:TStrings;
    FOnDeleteQuery:TDeleteQuery;
    FOnCoverQuery:TCoverQuery;
    FOnSelectQuery:TSelectQuery;
    FOnMoveQuery:TMoveQuery;
    FOnControlCreate:TControlCreate;
    FOnControlLoaded:TControlCreate;
    FOnControlLoading:TControlCreate;
    FOnCoverDblClick:TCallCompoEditor;
    FOnMenuClick:TCallPropEditor;
    FOnPopup:TNotifyEvent;
    FRubberband:TRubberband;
    FCoverMenu:TPopupMenu;
    FFixPosition:Boolean;
    FFixSize:Boolean;
    FDesigning:Boolean;
//    FViewType: TViewType;

  protected
    procedure SetSelfProps(Value: TStrings);
    procedure SetOutProps(Value: TStrings);
    procedure ComponentsProc(Component:TComponent);
    procedure CheckName(Reader:TReader; Component:TComponent; var Name:String); virtual;
    procedure WriteComponents(Stream:TStream;Control:TControl); virtual;
    procedure ReadComponents(Stream:TStream); virtual;
    procedure ReadError(Reader: TReader; const Message: string; var Handled: Boolean); virtual;
    procedure FindMethod(Reader: TReader; const MethodName: string;
               var Address: Pointer; var Error: Boolean); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure WMKeyUp(var Message: TWmKeyUp); message WM_KEYUP;
//    procedure WMPaint(var Message: TWMPaint); message WM_Paint;

    procedure ClientDeth(var Message:TMessage); message AG_DESTROY;
    procedure PropertyChanged(var Message:TMessage); message CI_SETPROPERTY;
    procedure ControlCreated(var Message:TMessage); message DR_CREATED;
    procedure ControlLoaded(var Message: TMessage); message DS_LOADED;
    function GetControls(Index:Integer):TControl;
    function GetCanCopy:Boolean;
    function GetCanPaste:Boolean;
    procedure KeyPress(var Key: Char); override;
    procedure SetDesignig(Value:Boolean); virtual;
  public
    MenuReg: TPopupMenu;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Paint;override;
    procedure SaveToFile(FileName:String);
    procedure SaveToStream(Stream:TStream);
    procedure LoadFromFile(FileName:String);
    procedure LoadFromStream(Stream:TStream);
    procedure Cut;
    procedure Copy;
    procedure Paste;
    procedure UpdateControl;
    function TargetsCount:Integer;
    procedure Delete;
    property Targets[Index:Integer]:TControl read GetControls;
    property CanCopy: Boolean read GetCanCopy;
    property CanPaste: Boolean read GetCanPaste;
    property Designing: Boolean read FDesigning;

  published
    property SelfProps:TStrings read FSelfProps write SetSelfProps;
    property OutProps:TStrings read FOutProps write SetOutProps;
    property Rubberband:TRubberband read FRubberband write FRubberband;
    property CoverMenu:TPopupMenu read FCoverMenu write FCoverMenu;
    property FixPosition:Boolean read FFixPosition write FFixPosition;
    property FixSize:Boolean read FFixSize write FFixSize;
    property OnDeleteQuery:TDeleteQuery read FOnDeleteQuery write FOnDeleteQuery;
    property OnCoverQuery:TCoverQuery read FOnCoverQuery write FOnCoverQuery;
    property OnSelectQuery:TSelectQuery read FOnSelectQuery write FOnSelectQuery;
    property OnMoveQuery:TMoveQuery read FOnMoveQuery write FOnMoveQuery;
    property OnControlCreate:TControlCreate read FOnControlCreate write FOnControlCreate;
    property OnControlLoading:TControlCreate read FOnControlLoading write FOnControlLoading;
    property OnControlLoaded:TControlCreate read FOnControlLoaded write FOnControlLoaded;
    property OnCoverDblClick:TCallCompoEditor read FOnCoverDblClick write FOnCoverDblClick;
    property OnMenuClick:TCallPropEditor read FOnMenuClick write FOnMenuClick;
    property OnPopup:TNotifyEvent read FOnPopup write FOnPopup;
  end;

  TDsnSwitch = class(TSpeedButton)
  private
    FDsnRegister:TDsnRegister;
    FDsnMessageFlg:Boolean;
    FDsnMessage:String;
  protected
    procedure SetDsnRegister(Value:TDsnRegister);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
    procedure Click; override;
    procedure DesignOn;
    procedure DesignOff;
  published
    property DsnRegister:TDsnRegister read FDsnRegister write SetDsnRegister;
    property DsnMessageFlg:Boolean read FDsnMessageFlg write FDsnMessageFlg;
    property DsnMessage:String read FDsnMessage write FDsnMessage;
  end;

  TDsnCtrl = class(TClientAgent)
  private
    FDsnRegister: TDsnRegister;
    ClientDeath: Boolean;
  protected
    FMousePoint: TPoint;
    procedure TakeInstance;override;
    procedure ReleaseInstance;override;
    procedure ClientWndProc(var Message: TMessage);override;
    procedure ClientMouseDown(var Message: TWMMouse);virtual;
    procedure ClientMouseMove(var Message: TWMMouse);virtual;
    procedure ClientMouseUp(var Message: TWMMouse);virtual;
    procedure ClientPaint(var Message: TWMPaint);virtual;
    procedure ClientCaptureChanged(var Message: TMessage);override;
    procedure ClientPreResize(var Message: TMessage);virtual;
    procedure ClientResize(var Message: TResizeMessage);virtual;
    procedure ClientSelect(var Message: TMessage);virtual;
    procedure ClientSelectByInspect(var Message: TMessage);virtual;
    procedure ClientSetFocus(var Message: TMessage);virtual;
    procedure ClientDbClick(var Message: TWMMouse);virtual;
    procedure ClientContextMenu(var Message: TWMMouse);virtual;
    procedure ClientHandleChange(var Message: TMessage);virtual;
  public
    constructor CreateInstance(AClient: TWinControl); override;
    property DsnRegister: TDsnRegister read FDsnRegister;
  end;

  TDsnSwich = class(TDsnSwitch)
  end;
  
  procedure Register;
  function CompareParent(Item1, Item2: Pointer): Integer;


implementation

uses {for Register Method}
  DsnSpctr, DsnSubDp, DsnSubRS, DsnSubCl, DsnSelect;

const
  DsnSwc_GrpIdx = 2302;

var
  UDsnStage: TDsnStage;

{ TDsnRegister }
constructor TDsnRegister.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDesigning:= False;
end;

destructor TDsnRegister.Destroy;
var
  i: integer;
begin
  if Assigned(FHandler) then
  begin
    FHandler.Free;
    FHandler:= nil;
  end;

  if Assigned(FDsnCtrlList) then
  begin
    for i:= 0 to FDsnCtrlList.Count -1 do
    begin
      TDsnCtrl(FDsnCtrlList[i]).ClientDeath:= True;
      TDsnCtrl(FDsnCtrlList[i]).Free;
    end;
    FDsnCtrlList.Free;
  end;

  if Assigned(FTargetList) then
  begin
    FTargetList.Clear;
    FTargetList.Free;
  end;

  if DsnNotifies <> nil then
    DsnNotifies.Free;

  if DsnPartners <> nil then
    DsnPartners.Free; 

  inherited;
end;

procedure TDsnRegister.Notification(AComponent: TComponent; Operation: TOperation);
var
  i,n:integer;
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FDsnStage then
    begin
      FDsnStage := nil;
    end;

    if AComponent = FDsnInspector then FDsnInspector := nil;
    if AComponent = FDsnPanel then FDsnPanel := nil;
    if AComponent = FArrowButton then FArrowButton := nil;

    if Assigned(FDsnCtrlList) then
      for i:= FDsnCtrlList.Count -1 downto 0 do
        if AComponent = TDsnCtrl(FDsnCtrlList[i]).Client then
        begin
          AlertClientDeath;
          TDsnCtrl(FDsnCtrlList[i]).ClientDeath:= True;
          // Free DsnCtrl in TDsnStage.ClientDeth
          FDsnCtrlList.Delete(i);
        end;

    if Assigned(FTargetList) then
    begin
      n:= FTargetList.IndexOf(AComponent);
      if n > -1 then
      begin
        FTargetList.ItemDeath(n);
        AlertTargetDeath;
        FTargetList.Delete(n);
        if not SameParent then
          FTargetList.Clear;
        FTargetList.SetPosition;
      end;
    end;
  end;
end;

procedure TDsnRegister.AlertClientDeath;
begin
end;

procedure TDsnRegister.AlertTargetDeath;
begin
end;

procedure TDsnRegister.SetDsnStage(Value:TDsnStage);
begin
  if Assigned(Value) then
  begin
    FDsnStage:=Value;
    FDsnStage.FreeNotification(Self);
    CutSizeX:= FDsnStage.FRubberband.MoveWidth;
    CutSizeY:= FDsnStage.FRubberband.MoveHeight;
    Color:= FDsnStage.FRubberband.Color;
    PenWidth:= FDsnStage.FRubberband.PenWidth;
    FDsnStage.FDsnRegister:= Self;
  end
  else
    FDsnStage:=nil;
end;

procedure TDsnRegister.SetDsnPanel(Value:TCustomCmpPlt);
begin
  if Assigned(Value) then
  begin
    FDsnPanel:=Value;
    FDsnPanel.FreeNotification(Self);
  end
  else
    FDsnPanel:=nil;
end;

procedure TDsnRegister.SetArrowButton(Value:TArrowButton);
begin
  if Assigned(Value) then
  begin
    FArrowButton:=Value;
    FArrowButton.FreeNotification(Self);
  end
  else
    FArrowButton:=nil;
end;

procedure TDsnRegister.SetDsnInspector(Value:TCustomInspector);
begin
  if Assigned(Value) then
  begin
    FDsnInspector:=Value;
    FDsnInspector.FreeNotification(Self);
  end
  else
    FDsnInspector:=nil;
end;

procedure TDsnRegister.SetDesigning(Value:Boolean);
var
 i:integer;
begin
  if Value = FDesigning then
    Exit;     

  FDesigning:= Value;

  if Assigned(DsnPartners) then
    for i := 0 to DsnPartners.Count -1 do
      TDsnPartner(DsnPartners[i]).SetDesigning(FDesigning);

  if FDesigning then
  begin
    if Assigned(FDsnStage) then
    begin
      FDsnStage.FDsnRegister:= Self;
      CreateSubClass;
      CreateContextMenu;
//      FDsnStage.SetFocus;
      FDsnStage.FDesigning:= True;
      FDsnStage.SetDesigning(FDesigning);
    end;

    if Assigned(FDsnPanel) then
    begin
      if Assigned(FArrowButton) then
      begin
        FDsnPanel.SetArrowButton(FArrowButton);
        FArrowButton.SetDsnPanel(FDsnPanel);
      end;
      FDsnPanel.Designing:= True;
    end;
    if Assigned(FDsnInspector) then
    begin
      FDsnInspector.Designing:= True;
      if Assigned(FDsnStage) then
        FDsnInspector.StageHandle:= FDsnStage.Handle;
    end;
  end
  else
  begin
    if Assigned(FDsnStage) then
    begin
      DestroySubClass;
      FDsnStage.FDesigning:= False;
      FDsnStage.SetDesignig(FDesigning);
    end;
    if Assigned(FDsnPanel) then
    begin
      FDsnPanel.Designing:= False;
      FDsnPanel.SetTemplate(nil);
    end;
    if Assigned(FDsnInspector) then
      FDsnInspector.Designing:= False;
    if Assigned(FProps) then
    begin
      FProps.Free;
      FProps:= nil;
    end;
    if Assigned(FHandler) then
    begin
      FHandler.Free;
      FHandler:= nil;
    end;
    if Assigned(FTargetList) then
    begin
      FTargetList.Free;
      FTargetList:= nil;
    end;
  end;
end;

procedure TDsnRegister.SetSubClass(AParent: TWinControl);
var
  DsnCtrl: TDsnCtrl;
  procedure ProcA(AAParent:TWinControl);
  var
    List:TChildList;
    i:integer;
    CanCover: TCoverAccept;
    procedure ProcB(AHandle:Integer;Agent:TDsnCtrl);
    var
      BList:TChildList;
      j:integer;
    begin
      if Agent.AgentList = nil then
        Agent.AgentList:= TAgentList.Create;
      Agent.AgentList.Add(AHandle);
      BList:= TChildList.Create(nil,AHandle);
      for j:= 0 to BList.Count -1 do
        ProcB(BList[j].Handle, Agent);
      BList.Free;
    end;
  begin
    CanCover:= caAllAccept;
    if Assigned(FDsnStage.OnCoverQuery) then
      FDsnStage.OnCoverQuery(FDsnStage, AAParent, CanCover);

    if CanCover = caAllAccept then
    begin
      DsnCtrl:= CreateSubCtrl(AAParent);
      FDsnCtrlList.Add(DsnCtrl);
      DsnCtrl.FDsnRegister:= Self;
    end;

    if not (CanCover = caNoAccept) then
    begin
      List:= TChildList.Create(AAParent,AAParent.Handle);
      for i:= 0 to List.Count -1 do
      begin
        if List[i].Instance <> nil then
          if List[i].Instance.Owner <> FDsnStage.Owner then
            ProcB(List[i].Handle,DsnCtrl) // For Like Spinedit
          else
            ProcA(List[i].Instance);
        if List[i].Instance = nil then
          ProcB(List[i].Handle,DsnCtrl)  // For Like Combobox
      end;
      List.Free;
    end
  end;
begin
  ProcA(AParent);
end;

procedure TDsnRegister.CreateSubClass;
begin
  if FDsnCtrlList = nil then
    FDsnCtrlList:= CreateDsnList;

  SetSubClass(FDsnStage);
end;

procedure TDsnRegister.CreateContextMenu;
var
  i:integer;
  CoverMenu:TPopupMenu;
  Item:TMenuItem;
begin
  if not Assigned(FDsnStage) then
    Exit;

  if (not Assigned(FDsnStage.CoverMenu)) and (FDsnStage.SelfProps.Count = 0) then
    Exit;


  // Copy from CoverMenu
  if Assigned(FDsnStage.CoverMenu) then
    if Assigned(FDsnStage.CoverMenu) then
    begin
      CoverMenu:= FDsnStage.CoverMenu;
      for i:= CoverMenu.Items.Count -1 downto 0 do
      begin
        {Item:= TMenuItem.Create(Owner);
        Item.Caption:= CoverMenu.Items[i].Caption;
        Item.OnClick:= CoverMenu.Items[i].OnClick;}
        Item:= CoverMenu.Items[i];
        CoverMenu.Items.Remove(Item);
      end;
    end;

  //Input Fixed Items Count on Tag
end;

procedure TDsnRegister.MenuMethod(Sender:TObject);
var
  Item:TDsnMenuItem;
  Targets:TSelectedComponents;
begin
  Item:= TDsnMenuItem(Sender);
  if Assigned(FDsnStage) then
    if Assigned(FDsnStage.OnMenuClick) then
    begin
      Targets:=TSelectedComponents.Create;
      Targets.AssignList(FTargetList.List);
      FDsnStage.OnMenuClick(FDsnStage,Targets,
                            Item.PropName,Item.Value);
      SetProp(FTargetList.List,Item.PropName,Item.Value);
      FTargetList.SetPosition;
      Targets.Free;
    end;
end;

function TDsnRegister.CreateSubCtrl(AParent:TWinControl):TDsnCtrl;
begin
  Result:= TDsnCtrl.CreateInstance(AParent);
end;

procedure TDsnRegister.DestroySubClass;
var
  i: integer;
begin
  if Assigned(FDsnCtrlList) then
    for i:= 0 to FDsnCtrlList.Count -1 do
      TDsnCtrl(FDsnCtrlList[i]).Free;

  FDsnCtrlList.Clear;
end;

procedure TDsnRegister.SelectByInspect(Control:TControl);
begin
  if not Assigned(FTargetList) then
    FTargetList:= CreateList;
  FTargetList.Clear;
  FTargetList.Add(Control);
  FTargetList.SetPosition;
end;

procedure TDsnRegister.MouseDown(Client:TWinControl; Target:TComponent; MousePoint:TPoint; Shift: TShiftState);
var
  Template:TControl;
begin
  Template:= nil;
  if Assigned(FDsnPanel) then
    Template:=  TControl(FDsnPanel.GetTemplate);

  if Assigned(Template) then
    MouseDownCreate(Client,Target,MousePoint,Shift)
  else
    MouseDownMove(Client,Target,MousePoint,Shift);
end;

procedure TDsnRegister.MouseDownMove(Client:TWinControl; Target:TComponent; MousePoint:TPoint; Shift: TShiftState);
var
  n,i: integer;
  CanSelect: TSelectAccept;
begin
  CanSelect:= [saCreate, saMove];

  if Assigned(FDsnStage) then
    if Assigned(FDsnStage.OnSelectQuery) then
      FDsnStage.OnSelectQuery(FDsnStage, Target, CanSelect);

  if saMove in CanSelect then
  begin
    if Client = Target then
      FParentCtrl:= Client.Parent
    else
      FParentCtrl:= Client;

    if FTargetList = nil then
      FTargetList:= CreateList;

    n:= FTargetList.Count;
    if n > 0 then
    begin
      n:= FTargetList.IndexOf(Target);
      if (n = -1) or not SameParent then
      begin
        FTargetList.Clear;
        FTargetList.Add(Target);
      end;
    end
    else
    begin
      FTargetList.Add(Target);
    end;

    if Assigned(Target) then
    begin
      if SameParent then
      begin
        //Application.ProcessMessages;
        CreateMoveShape;
        FShape.Color:= Color;
        FShape.PenWidth:= PenWidth;
        Cutting(MousePoint.x,MousePoint.y);
        FX:= MousePoint.x;
        FY:= MousePoint.y;
        MousePoint:= FParentCtrl.ClientToScreen(MousePoint);
        FShape.Point:= MousePoint;
        for i:= 0 to FTargetList.Count -1 do
          FShape.Add(FTargetList[i]);
        FShape.DrowOn(FParentCtrl);
      end;

    end;
  end;
end;

procedure TDsnRegister.MouseDownCreate(Client:TWinControl; Target:TComponent; MousePoint:TPoint; Shift: TShiftState);
var
  CanSelect: TSelectAccept;
begin
  CanSelect:= [saCreate, saMove];
  if Assigned(FDsnStage) then
    if Assigned(FDsnStage.OnSelectQuery) then
      FDsnStage.OnSelectQuery(FDsnStage, Target, CanSelect);

  if saCreate in CanSelect then
  begin
    if csAcceptsControls in Client.ControlStyle then
      FParentCtrl:= Client
    else
    begin
      FParentCtrl:= Client.Parent;
      Inc(MousePoint.x, Client.Left);
      Inc(MousePoint.y, Client.Top);
    end;

    CreateCopyShape;
    FShape.Color:= Color;
    FShape.PenWidth:= PenWidth;
    Cutting(MousePoint.x,MousePoint.y);
    FX:= MousePoint.x;
    FY:= MousePoint.y;
    FShape.Point:= MousePoint;
    FShape.AddNew;
    FShape.DrowOn(FParentCtrl);
  end;
end;

procedure TDsnRegister.MoseMove(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);
var
  Template:TControl;
begin
  Template:= nil;
  if Assigned(FDsnPanel) then
    Template:=  TControl(FDsnPanel.GetTemplate);

  if Assigned(Template) then
    MouseMoveCreate(Client,MousePoint,Shift)
  else if ssLeft in Shift then
    MouseMoveMove(Client,MousePoint,Shift)
  else
  begin
    if Assigned(FShape) then
    begin
      FShape.DrowUp;
      FShape.Free;
      FShape:= nil;
    end;
  end;
end;

procedure TDsnRegister.MouseMoveMove(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);
begin
  if Assigned(FShape) then
  begin
    Cutting(MousePoint.x,MousePoint.y);
    if SameParent then
    begin
      MousePoint:= FParentCtrl.ClientToScreen(MousePoint);
      FShape.Drow(MousePoint);
    end;
  end;
end;

procedure TDsnRegister.MouseMoveCreate(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);
begin
  if Assigned(FShape) then
  begin
    Cutting(MousePoint.x,MousePoint.y);
    if not (csAcceptsControls in Client.ControlStyle) then
    begin
      Inc(MousePoint.x,Client.Left);
      Inc(MousePoint.y,Client.Top);
    end;
    FShape.SetWidth(MousePoint.x - FX);
    FShape.SetHeight(MousePoint.y - FY);
    MousePoint.x:= FX;
    MousePoint.y:= FY;
    MousePoint:= FParentCtrl.ClientToScreen(MousePoint);
    FShape.Drow(MousePoint);
  end;
end;

procedure TDsnRegister.MoseUp(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);
var
  Template:TControl;
begin
  Template:= nil;
  if Assigned(FDsnPanel) then
    Template:=  TControl(FDsnPanel.GetTemplate);

  if Assigned(Template) then
      MouseUpCreate(Client,MousePoint,Shift)
  else
    MouseUpMove(Client,MousePoint,Shift);
end;

procedure TDsnRegister.MouseUpMove(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);
var
  i,DX,DY:integer;
  CanMove: Boolean;
begin
  Cutting(MousePoint.x,MousePoint.y);
  if SameParent then
    if Assigned(FShape) then
    begin
      FShape.DrowUp;
      FShape.Free;
      FShape:= nil;
      if Assigned(FTargetList) then
        for i:= 0 to FTargetList.Count -1 do
        begin
          CanMove:= True;
          if Assigned(FDsnStage.OnMoveQuery) then
            FDsnStage.OnMoveQuery(FDsnStage,FTargetList[i],CanMove);
          if CanMove then
          begin
            TControl(FTargetList[i]).Left:= TControl(FTargetList[i]).Left + (MousePoint.x - FX);
            TControl(FTargetList[i]).Top:= TControl(FTargetList[i]).Top + (MousePoint.y - FY);
          end;
        end;
    end;

  DX:= FX- MousePoint.x;
  DY:= FY- MousePoint.y;
  if (DX <> 0) or (DY <> 0) then
    Moved(DX,DY);

  if Assigned(FTargetList) then
    FTargetList.SetPosition;
end;

procedure TDsnRegister.MouseUpCreate(Client:TWinControl; MousePoint:TPoint; Shift: TShiftState);
var
  NewWidth, NewHeight: Integer;
begin
  Cutting(MousePoint.x, MousePoint.y);
  if Assigned(FShape) then
  begin
    if not (csAcceptsControls in Client.ControlStyle) then
    begin
      Inc(MousePoint.x, Client.Left);
      Inc(MousePoint.y, Client.Top);
    end;
    FShape.DrowUp;
    FShape.Free;
    FShape:= nil;
    NewWidth:= MousePoint.x - FX;
    NewHeight:= MousePoint.y - FY;
    try
      CopyPaste(TControl(FDsnPanel.GetTemplate),FParentCtrl);
    except
    end;
    if Assigned(FDsnControl) then
    begin
      GiveName(FDsnControl);
      if (NewWidth >=0) and (NewHeight >=0) then
        TControl(FDsnControl).SetBounds(FX, FY, NewWidth, NewHeight);
      if (NewWidth <0) and (NewHeight >=0) then
        TControl(FDsnControl).SetBounds(FX + NewWidth, FY, -NewWidth, NewHeight);
      if (NewWidth >=0) and (NewHeight <0) then
        TControl(FDsnControl).SetBounds(FX, FY + NewHeight, NewWidth, -NewHeight);
      if (NewWidth <0) and (NewHeight <0) then
        TControl(FDsnControl).SetBounds(FX + NewWidth, FY + NewHeight, -NewWidth, -NewHeight);

      if FTargetList = nil then
        FTargetList:= CreateList;

      if FDsnControl is TWinControl then
        SetSubClass(TWinControl(FDsnControl));

      FTargetList.Clear;
      FTargetList.Add(FDsnControl);
//      FLastTarget:= TControl(FDsnControl);
      FTargetList.SetPosition;

      {if Assigned(FDsnStage) then
        if Assigned(FDsnStage.OnControlCreate) then
          FDsnStage.OnControlCreate(FDsnStage, FDsnControl);}
    end;
  end;
  if Assigned(FDsnPanel) then
    FDsnPanel.EndCreating;
  FDsnPanel.SetTemplate(nil);
  FDsnControl:= nil;
end;

procedure TDsnRegister.Resized(Control:TControl;var Message: TResizeMessage);
begin
  if Assigned(FProps) then
  begin
    FProps.GetValues;
    FProps.SetPosition;
  end;
end;

procedure TDsnRegister.Moved(DeltaX,DeltaY: Integer);
begin
  if Assigned(FProps) then
    FProps.GetValues;
end;

procedure TDsnRegister.Selected(Control:TControl;var Message: TMessage);
begin
end;

procedure TDsnRegister.ClearSelect;
begin
  if Assigned(FTargetList) then
    FTargetList.Clear;
end;

procedure TDsnRegister.DbClick(Target:TControl; var Message: TWMMouse);
begin
  //ShowMessage(Target.Owner.Name);
  if Assigned(FDsnStage) then
    if Assigned(FDsnStage.OnCoverDblClick) then
      FDsnStage.OnCoverDblClick(FDsnStage, Target);
end;

procedure TDsnRegister.RButtonDown(Client:TWinControl; Target:TControl; XPos,YPos: Integer);
var
  n:integer;
  CanSelect: TSelectAccept;
begin
  CanSelect:= [saCreate, saMove];

  if Assigned(FDsnStage) then
    if Assigned(FDsnStage.OnSelectQuery) then
      FDsnStage.OnSelectQuery(FDsnStage, Target, CanSelect);

  if saMove in CanSelect then
  begin
    if Client = Target then
      FParentCtrl:= Client.Parent
    else
      FParentCtrl:= Client;

    if FTargetList = nil then
      FTargetList:= CreateList;

    n:= FTargetList.Count;
    if n > 0 then
    begin
      n:= FTargetList.IndexOf(Target);
      if (n = -1) or not SameParent then
      begin
        FTargetList.Clear;
        FTargetList.Add(Target);
      end;
    end
    else
    begin
      FTargetList.Add(Target);
    end;
    FTargetList.SetPosition;
  end;
end;

procedure TDsnRegister.CallPopupMenu(Client:TWinControl; Target:TControl; XPos,YPos: Integer);
var
  Point:TPoint;
begin
  RButtonDown(Client, Target, XPos,YPos);

  if not Assigned(FDsnStage) then
    Exit;

  if not Assigned(FControlMenu) then
    Exit;

  FDsnStage.MenuReg:=FControlMenu;

  if FDsnStage=Target then
    ClearSelect;

  Point.x:= Client.Left;
  Point.y:= Client.Top;
  Point:= Client.Parent.ClientToScreen(Point);

  if not FDsnStage.Designing then exit;
  if (Target<>Client) then begin
   FControlMenu.PopUp(XPos+Point.x,YPos+Point.y);
  end else begin
   if (Client.ControlCount=0)and(Client.ClassType<>TDsnStage) then begin
    FControlMenu.PopUp(XPos+Point.x,YPos+Point.y);
   end else begin
    if Assigned(FFormMenu) then
     FFormMenu.PopUp(XPos+Point.x,YPos+Point.y);
   end;
  end;
end;

procedure TDsnRegister.SetControlMenu(Value: TPopupMenu);
begin
  if Value<>FControlMenu then
   FControlMenu:=Value;
end;

procedure TDsnRegister.SetFormMenu(Value: TPopupMenu);
begin
  if Value<>FFormMenu then
   FFormMenu:=Value;
end;

procedure TDsnRegister.GiveName(Component: TComponent);
var
  S1,S2: String;
  n:integer;
begin
  S1:= Component.ClassName;
  System.Delete(S1,1,1);
  n:=1;
  S2:=S1 + '1';
  while Owner.FindComponent(S2) <> nil do
  begin
    Inc(n);
    S2:=S1 + IntToStr(n);
  end;
  Component.Name:=S2;
end;

procedure TDsnRegister.CreateHandler;
begin
  FHandler:= TMultiHandler.Create;
end;

function TDsnRegister.CreateProps:TMultiProps;
begin
  Result:= TMultiProps.Create;
end;

procedure TDsnRegister.CreateCopyShape;
begin
  FShape:= TMultiShape.Create;
end;

procedure TDsnRegister.CreateMoveShape;
begin
  if Assigned(FShape) then
  begin
    FShape.DrowUp;
    FShape.Free;
  end;
  FShape:= TMultiShape.Create;
end;

function TDsnRegister.CreateDsnList:TDsnList;
begin
  Result:= TDsnList.Create;
end;

function TDsnRegister.CreateList:TTargetList;
var
  InspectList:TStringList;
  CaptionList:TStringList;
  i: integer;
begin
  Result:= TTargetList.Create;

  if Assigned(FHandler) then
    FHandler.Free;
  if Assigned(FProps) then
    FProps.Free;

  if Assigned(FDsnStage) then
  begin
    CreateHandler;
    FHandler.Color:= Color;
    FHandler.PenWidth:= PenWidth;
    FHandler.CutSizeX:= CutSizeX;
    FHandler.CutSizeY:= CutSizeY;
    Result.SelectNotification(FHandler);
  end;

  if Assigned(FDsnInspector) then
  begin
    FProps:= CreateProps;
    Result.SelectNotification(FProps);
    FProps.SetInspector(FDsnInspector);
    InspectList:= TStringList.Create;
    CaptionList:= TStringList.Create;
    FDsnInspector.GetPropLists(InspectList,CaptionList);
    FProps.SetInspectList(InspectList);
    FProps.SetCaptionList(CaptionList);
    FProps.SetOutList(FDsnInspector.GetOutProps);
    InspectList.Free;
    CaptionList.Free;
  end;

  if DsnNotifies <> nil then
  begin
    for i := 0 to DsnNotifies.Count -1 do
    begin
      Result.SelectNotification(TReceiveTargets(DsnNotifies[i]));
    end;
  end;
end;

procedure TDsnRegister.ComponentsProc(Component:TComponent);
begin
  FDsnControl:=Component;
end;

procedure TDsnRegister.CopyPaste(Ctrl:TControl;aParent:TWinControl);
var
  MemoryStream:TMemoryStream;
  Writer:TWriter;
  Reader:TReader;
  S:String;
begin
  S:= Ctrl.Name;
  Ctrl.Name:='';
  //Copy
  MemoryStream:=TMemoryStream.Create;
  try
    Writer:=TWriter.Create(MemoryStream,4096);
    try
      Writer.RootAncestor := nil;
      Writer.Ancestor := nil;
      Writer.Root := Ctrl.Owner;
      Writer.WriteSignature;
      Writer.WriteComponent(Ctrl);
      Writer.WriteListEnd;
    finally
      Writer.Free;
    end;
  //Paste
    MemoryStream.Position:=0;
    Reader:=TReader.Create(MemoryStream,4096);
    try
      Reader.OnSetName:=CheckName;
      Reader.ReadComponents(aParent.Owner,aParent,ComponentsProc);
    finally
      Reader.Free;
    end;
  finally
    MemoryStream.Free;
    Ctrl.Name:=S;
  end;
end;

procedure TDsnRegister.CheckName(Reader:TReader; Component:TComponent; var Name:String);
begin
  DsnCheckName(Owner,Reader,Component,Name);

  PostMessage(FDsnStage.Handle, DR_CREATED, Integer(Component),0)

end;

procedure TDsnRegister.Cut;
begin
  if not Assigned(FTargetList) then
    Exit;
  if FTargetList.Count = 0 then
    Exit;
  if not SameParent then
    Exit;

  Copy;
  Delete;
end;

function TDsnRegister.CanCopy:Boolean;
begin
  Result:= False;
  if not Assigned(FTargetList) then
    Exit;
  if FTargetList.Count = 0 then
    Exit;
  if not SameParent then
    Exit;
  if TObject(FTargetList.Items[0]) is TTabSheet then exit;
  Result:= True;
end;

procedure TDsnRegister.Copy;
var
  CF_SPECIAL:Cardinal;
  MS: TMemoryStream;
  WR:TWriter;
  HMem: THandle;
  PMem: Pointer;
  PL: PLongInt;
  i:integer;
begin
  if not CanCopy then
    Exit;


  MS := TMemoryStream.Create;

  WR:=TWriter.Create(MS,4096);
  try
    WR.RootAncestor := nil;
    WR.Ancestor := nil;
    WR.Root := Owner;
    for i:= 0 to FTargetList.Count -1 do
    begin
      WR.WriteSignature;
      WR.WriteComponent(TComponent(FTargetList[i]));
    end;
    WR.WriteListEnd;
  finally
    WR.Free;
  end;
  HMem := GlobalAlloc(GHND, MS.Size + SizeOf (LongInt));
  PMem := GlobalLock(HMem);

  PL := PLongInt(PMem);
  PL^ := MS.Size;
  Inc(PL);
  PMem := Pointer(PL);

  MS.Seek(0,0);
  MS.ReadBuffer(PMem^, MS.Size);

  CF_SPECIAL := RegisterClipboardFormat (Dsn_ClipboardFormat);

  GlobalUnlock(HMem);
  Clipboard.Open;
  Clipboard.SetAsHandle(CF_SPECIAL, HMem);

  Clipboard.Close;

  MS.Free;
end;

function TDsnRegister.CanPaste:Boolean;
var
  Control:TWinControl;
  CF_SPECIAL:Cardinal;
begin
  Result:= False;
  if not Assigned(FTargetList) then
    Exit;
  if FTargetList.Count > 1 then
    Exit;
  if FTargetList.Count = 1 then
  begin
    Control:= TWinControl(FTargetList[0]);
    if not (csAcceptsControls in Control.ControlStyle) then
      Exit;
  end;
  CF_SPECIAL := RegisterClipboardFormat(Dsn_ClipboardFormat);
  if not Clipboard.HasFormat(CF_SPECIAL) then
    Exit; 
  Result:= True;
end;

function TDsnRegister.PasteZero:TWinControl;
begin
  Result:= FDsnStage;
end;

procedure TDsnRegister.Paste;
var
  MS: TMemoryStream;
  HMem: THandle;
  PMem: Pointer;
  Size: LongInt;
  RD:TReader;
  Control:TWinControl;
  CF_SPECIAL:Cardinal;
begin
  if not CanPaste then
    Exit;
  Control:= nil;
  if FTargetList.Count = 1 then
    Control:= TWinControl(FTargetList[0]);
  if FTargetList.Count = 0 then
    Control:= PasteZero;
  if Control = nil then
    Exit;

  FTargetList.Clear;
  CF_SPECIAL := RegisterClipboardFormat(Dsn_ClipboardFormat);


  MS := TMemoryStream.Create;

  try
    Clipboard.Open;
    try
      HMem := GetClipboardData(CF_SPECIAL);
      if HMem = 0 then
      begin
        Clipboard.Close;
        MS.Free;
        Exit;
      end;
      PMem := GlobalLock(HMem);
      Size := PLongInt(PMem)^;
      PMem := Pointer(LongInt(PMem)+SizeOf(LongInt));
      try
        MS.WriteBuffer(PMem^, Size);
      finally
        GlobalUnlock(HMem);
      end;
    finally
      Clipboard.Close;
    end;

    MS.Seek(0,0);

    RD:=TReader.Create(MS,4096);
    try
      RD.OnSetName:=CheckName;
      //RD.OnError:=ReadError;
      //RD.OnFindMethod:=FindMethod;
      RD.Position:=0;
      RD.ReadComponents(Owner,Control,ComponentsProcClipbrd);
    finally
      RD.Free;
    end;
  finally
    MS.Free;
  end;
  FTargetList.SetPosition;
end;

procedure TDsnRegister.ComponentsProcClipbrd(Component:TComponent);
var
  Control: TControl;
begin
  if Component is TWinControl then
    SetSubClass(TWinControl(Component));

  if Component is TControl then
  begin
    Control:= TControl(Component);
    if Control.Left > Control.Parent.Width then
      Control.Left:= Control.Parent.Width - Control.Width;
    if Control.Left < 0 then
      Control.Left:= 0;
    if Control.Top > Control.Parent.Height then
      Control.Top:= Control.Parent.Height - Control.Height;
    if Control.Top < 0 then
      Control.Top:= 0;
  end;
  FTargetList.Add(Component);
end;

procedure TDsnRegister.Cutting(var X, Y: Integer);
begin
  if CutSizeX > 0 then
    X:= (X div CutSizeX) * CutSizeX;
  if CutSizeY > 0 then
    Y:= (Y div CutSizeY) * CutSizeY; 
end;

function TDsnRegister.SameParent:Boolean;
var
  i:integer;
  AParent:TWinControl;
begin
  result:= True;
  if Assigned(FTargetList) then
  begin
    if FTargetList.Count > 0 then
    begin
      AParent:= TControl(FTargetList[0]).Parent;
      for i:= 1 to FTargetList.Count -1 do
        if TControl(FTargetList[i]).Parent <> AParent then
        begin
          result:= False;
          Break;
        end;
    end;
  end;
end;

function CompareParent(Item1, Item2: Pointer): Integer;
var
  AParent: TWinControl;
begin
  Result:= 0;
  if UDsnStage = nil then Exit;
  AParent:= TControl(Item1).Parent;
  while AParent <> UDsnStage do
  begin
    AParent:= AParent.Parent;
    Inc(Result);
  end;
  AParent:= TControl(Item2).Parent;
  while AParent <> UDsnStage do
  begin
    AParent:= AParent.Parent;
    Dec(Result);
  end;
end;

procedure TDsnRegister.SortForDelete(List: TList);
begin
  UDsnStage:= FDsnStage;
  List.Sort(CompareParent);
  UDsnStage:= nil;
end;

procedure TDsnRegister.Delete;
var
  i:integer;
  LList:TList;
  CanDelete: Boolean;
begin
  if Assigned(FTargetList) then
  begin
    LList:= TList.Create;
    for i:= 0 to FTargetList.Count -1 do
      LList.Add(FTargetList[i]);
    FTargetList.Clear;
    //Dlete Query
    if FDsnStage <> nil then
      if Assigned(FDsnStage.OnDeleteQuery) then
        for i:= LList.Count -1 downto 0 do
        begin
          CanDelete:= True;
          FDsnStage.OnDeleteQuery(FDsnStage,TComponent(LList[i]),CanDelete);
          if not CanDelete then
            LList.Delete(i);
        end;
    //Sort from Grandchild to DsnStage
    SortForDelete(LList);
    //Delete
    for i:= LList.Count -1 downto 0 do
      TControl(LList[i]).Free;
    LList.Free;
    FTargetList.SetPosition;
  end;
end;

procedure TDsnRegister.AddNotifies(List: TReceiveTargets);
begin
  if DsnNotifies = nil then
    DsnNotifies:= TList.Create;
  DsnNotifies.Add(List);
end;

{procedure TDsnRegister.AddReceiveTargets(List: TReceiveTargets);
begin
  FTargetList.SelectNotification(List);
end;}

procedure TDsnRegister.AddPartners(Partner: TDsnPartner);
begin
  if DsnPartners = nil then
    DsnPartners:= TList.Create;
  DsnPartners.Add(Partner);
end;

procedure TDsnRegister.RemovePartners(Partner: TDsnPartner);
var
  n: integer;
begin
  if DsnPartners <> nil then
  begin
    n:= DsnPartners.IndexOf(Partner);
    if n > -1 then
      DsnPartners.Delete(n);
  end;
end;

function TDsnRegister.CheckCanSelect(Control: TControl): Boolean;
var
  Flag: Boolean;
  Parent: TWinControl;
  CanCover: TCoverAccept;
  CanSelect: TSelectAccept;
begin
  Result:= False;
  if FDsnStage = nil then
    Exit;
  Parent:= Control.Parent;
  Flag:= False;
  while not (Parent is TForm) do
  begin
    if Parent = FDsnStage then
    begin
      Flag:= True;
      Break;
    end;
    Parent:= Parent.Parent;
    if Parent = nil then
      Break;
  end;
  if Flag then
  begin
    CanCover:= caAllAccept;
    if Control is TWinControl then
    begin
      if Assigned(FDsnStage.OnCoverQuery) then
      begin
        FDsnStage.OnCoverQuery(Self,Control,CanCover);
      end;
    end
    else
    begin
      Parent:= Control.Parent;
      if Assigned(FDsnStage.OnCoverQuery) then
      begin
        FDsnStage.OnCoverQuery(Self,Parent,CanCover);
      end;
    end;
    if CanCover = caAllAccept then
      Result:= True;
    if Result then
    begin
      CanSelect:= [saCreate, saMove];

      if Assigned(FDsnStage.OnSelectQuery) then
        FDsnStage.OnSelectQuery(Self, Control, CanSelect);

      if not (saMove in CanSelect) then
        Result:= False;
    end;
  end;
end;

{ TDsnStage }
constructor TDsnStage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRubberband:=TRubberband.Create;
  FRubberband.Color:=clGray;
  FRubberband.PenWidth:=2;
  FRubberband.MoveWidth:=8;
  FRubberband.MoveHeight:=8;
  FSelfProps:=TStringList.Create;
  FOutProps:=TStringList.Create;
  FDesigning:= False;
end;

destructor TDsnStage.Destroy;
begin
  FRubberband.Free;
  FSelfProps.Free;
  FOutProps.Free;
  inherited;
end;


procedure TDsnStage.Paint;

   procedure DrawGrid;
   var
     I,J: Integer;
   begin
    if (Rubberband.FMoveWidth<2)or(Rubberband.FMoveHeight<2) then
     exit;
    with self.Canvas do begin
     Brush.Style:=bsSolid;
     Brush.Color:=Color;
     FillRect(GetClientRect);
     for i:=1 to Width do begin
      for j:=1 to Height do begin
       if ((i mod Rubberband.FMoveWidth)=0) and
          ((j mod Rubberband.FMoveHeight)=0) then begin
        Pixels[i,j]:=clBlack;
       end;
      end;
     end;
    end;
   end;

begin
//  inherited Paint;
{  if Designing then
   DrawGrid;}
end;

procedure TDsnStage.SetDesignig(Value:Boolean);
begin
end;

{procedure TDsnStage.WMPaint(var Message: TWMPaint);

   procedure DrawGrid;
   var
     I,J: Integer;
   begin
    with self.Canvas do begin
     Brush.Style:=bsSolid;
     Brush.Color:=Color;
     FillRect(GetClientRect);
     for i:=1 to Width do begin
      for j:=1 to Height do begin
       if ((i mod 5)=0) and ((j mod 5)=0) then begin
        Pixels[i,j]:=clBlack;
       end;
      end;
     end;
    end;
   end;

var
  HDCSelf: THandle;
begin
  inherited;
//  DrawGrid;
{  Brush.Style:=bsDiagCross;
  HDCSelf:=GetDC(Handle);
  try
   FillRect(HDCSelf,GetClientRect,Brush.Handle);
  finally
   ReleaseDc(Handle,HDCSelf);
  end;}
//end;

procedure TDsnStage.ClientDeth(var Message:TMessage);
var
  DsnCtrl:TDsnCtrl;
begin
  DsnCtrl:= TDsnCtrl(Message.WParam);
  if DsnCtrl.ClientDeath then
    DsnCtrl.Free
  else
    DsnCtrl.ChangeHandele(DsnCtrl.Client.Handle);
end;

procedure TDsnStage.PropertyChanged(var Message:TMessage);
begin
  UpdateControl;
end;

function TDsnStage.GetControls(Index:Integer):TControl;
begin
  Result:= FDsnRegister.FTargetList[Index];
end;

function TDsnStage.TargetsCount:Integer;
begin
  Result:= 0;
  if Assigned(FDsnRegister) then
    if Assigned(FDsnRegister.FTargetList) then
      Result:= FDsnRegister.FTargetList.Count;
end;

procedure TDsnStage.UpdateControl;
begin
 try
  if IsBadHugeReadPtr(FDsnRegister,Sizeof(FDsnRegister)) then exit;

  if Assigned(FDsnRegister) then begin
    if IsBadCodePtr(FDsnRegister.FTargetList) then exit;
    if Assigned(FDsnRegister.FTargetList) then begin
      FDsnRegister.FTargetList.SetPosition;
    end;
  end;
 except
 end; 
end;

procedure TDsnStage.SetSelfProps(Value: TStrings);
begin
  FSelfProps.Assign(Value);
end;

procedure TDsnStage.SetOutProps(Value: TStrings);
begin
  FOutProps.Assign(Value);
end;

procedure TDsnStage.WMKeyUp(var Message: TWmKeyUp);
begin
  if (Message.CharCode in [VK_DELETE]) then
  begin
    Delete;
    Message.Result:=1;
  end;

  inherited;
end;

procedure TDsnStage.KeyPress;
begin
  if Key in [^C] then
  begin
    Key := #0;
    Copy;
  end;

  if Key in [^X] then
  begin
    Key := #0;
    Cut;
  end;

  if Key in [^V] then
  begin
    Key := #0;
    Paste;
  end;

  inherited ;

end;

function TDsnStage.GetCanCopy:Boolean;
begin
  Result:= False;
  if Assigned(FDsnRegister) then
    Result:= FDsnRegister.CanCopy;
end;

function TDsnStage.GetCanPaste:Boolean;
begin
  Result:= False;
  if Assigned(FDsnRegister) then
    Result:= FDsnRegister.CanPaste;
end;

procedure TDsnStage.Delete;
begin
  if Assigned(FDsnRegister) then
    FDsnRegister.Delete;
end;

procedure TDsnStage.Cut;
begin
  if Assigned(FDsnRegister) then
    FDsnRegister.Cut;
end;

procedure TDsnStage.Copy;
begin
  if Assigned(FDsnRegister) then
    FDsnRegister.Copy;
end;

procedure TDsnStage.Paste;
begin
  if Assigned(FDsnRegister) then
    FDsnRegister.Paste;
end;

procedure TDsnStage.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
    if AComponent = FCoverMenu then
      FCoverMenu := nil;
end;

procedure TDsnStage.SaveToFile(FileName:String);
var
  FS:TStream;
  WR:TWriter;
  i:integer;
begin
  if Assigned(FDsnRegister) then
    FDsnRegister.ClearSelect;

  FS:=TFileStream.Create(FileName, fmCreate);
  try
    WR:=TWriter.Create(FS,4096);
    try
      for i:=0 to ControlCount-1 do
      begin
        WriteComponents(FS,Controls[i]);
        WR.WriteListEnd;
      end;
    finally
      WR.Free;
    end;
  finally
    FS.Free;
  end;
end;

procedure TDsnStage.SaveToStream(Stream:TStream);
var
  WR:TWriter;
  i:integer;
begin
  if Assigned(FDsnRegister) then
    FDsnRegister.ClearSelect;

  WR:=TWriter.Create(Stream,4096);
  try
    for i:=0 to ControlCount-1 do
      WriteComponents(Stream,Controls[i]);

    WR.WriteListEnd;

  finally
    WR.Free;
  end;
end;

procedure TDsnStage.LoadFromFile(FileName:String);
var
  FS:TStream;
  Flag: Boolean;
begin
  {if Designing then
    Raise Exception.Create(STG_ERRORREAD); }

  Flag:= False;
  if Assigned(FDsnRegister) then
  begin
    if FDsnRegister.Designing then
      Flag:= True;
    FDsnRegister.SetDesigning(False);
  end;

  try
    FS:=TFileStream.Create(FileName, fmOpenRead);
    try
      ReadComponents(FS);
    finally
      FS.Free;
    end;
  except
    Raise Exception.Create(FileName+ STG_ERRORREADFILE);
  end;

  if Flag then
    FDsnRegister.SetDesigning(True);
end;

procedure TDsnStage.LoadFromStream(Stream:TStream);
var
  Flag: Boolean;
begin
 { if Designing then
    Raise Exception.Create(STG_ERRORREAD);}

  Flag:= False;
  if Assigned(FDsnRegister) then
  begin
    if FDsnRegister.Designing then
      Flag:= True;
    FDsnRegister.SetDesigning(False);
  end;

  ReadComponents(Stream);

  if Flag then
    FDsnRegister.SetDesigning(True);
end;

procedure TDsnStage.ComponentsProc(Component:TComponent);
begin
end;

procedure TDsnStage.WriteComponents(Stream:TStream;Control:TControl);
var
  WR:TWriter;
begin
  WR:=TWriter.Create(Stream,4096);
  try
    WR.RootAncestor := nil;
    WR.Ancestor := nil;
    WR.Root := Owner;
    WR.WriteSignature;
    WR.WriteComponent(Control);
  finally
    WR.Free;
  end;
end;

procedure TDsnStage.ReadComponents(Stream:TStream);
var
  RD:TReader;
  i:integer;
begin
  for i:=ControlCount-1 downto 0 do begin
    Controls[i].Free;
  end;
  RD:=TReader.Create(Stream,4096);
  try
    RD.OnError:=ReadError;
    RD.OnFindMethod:=FindMethod;
    RD.OnSetName:=CheckName;
    RD.Position:=0;
    RD.ReadComponents(Owner,Self,ComponentsProc);
  finally
    RD.Free;
  end;
end;

procedure TDsnStage.CheckName(Reader:TReader; Component:TComponent; var Name:String);
begin
  DsnCheckName(Owner,Reader,Component,Name);
  if Assigned(FOnControlLoading) then
    FOnControlLoading(Self, Component);
  PostMessage(Handle, DS_LOADED, Integer(Component),0)
end;

procedure TDsnStage.ReadError(Reader: TReader; const Message: string; var Handled: Boolean);
begin
  Handled:=True;
end;

procedure TDsnStage.FindMethod(Reader: TReader; const MethodName: string;
               var Address: Pointer; var Error: Boolean);
begin
  if Error then
  begin
    Address:=nil;
    Error:=False;
  end;   
end;

procedure TDsnStage.ControlCreated(var Message: TMessage);
var
  Component:TComponent;
begin
  Component:= TComponent(Message.WParam);
  if Assigned(OnControlCreate) then
    OnControlCreate(Self, Component);
end;

procedure TDsnStage.ControlLoaded(var Message: TMessage);
var
  Component:TComponent;
begin
  Component:= TComponent(Message.WParam);
  if Assigned(OnControlLoaded) then
    OnControlLoaded(Self, Component);
end;

{TDsnCtrl}
constructor TDsnCtrl.CreateInstance(AClient: TWinControl);
begin
  inherited CreateInstance(AClient);
  ClientDeath:= False;
end;

procedure TDsnCtrl.TakeInstance;
begin
  if Assigned(Client) then
  begin
    Client.Cursor:= crArrow;
    Client.Invalidate;
  end;
end;

procedure TDsnCtrl.ReleaseInstance;
begin
  if (Assigned(Client)) and (not ClientDeath) then
  begin
    Client.Cursor:= crDefault;
    Client.Invalidate;
  end;
end;

procedure TDsnCtrl.ClientMouseDown(var Message: TWMMouse);
var
  Shift: TShiftState;
begin
  FMousePoint := Point(Message.XPos, Message.YPos);
  FTarget := nil;
  FTarget := Client.ControlAtPos(FMousePoint, TRUE);
  if FTarget = nil then
    FTarget := Client;

  if FTarget.Owner <> Client.Owner then
    FTarget := Client;  // For Like DBNavigator

  Shift:= KeysToShiftState(Message.Keys);

  SetCapture(Client.Handle);
  FDsnRegister.MouseDown(Client, FTarget, FMousePoint, Shift);
  FDsnRegister.FDsnStage.SetFocus;
end;

procedure TDsnCtrl.ClientMouseMove(var Message: TWMMouse);
var
  Shift: TShiftState;
begin
  FMousePoint := Point(Message.XPos, Message.YPos);
  Shift:= KeysToShiftState(Message.Keys);

  if Assigned(FTarget)then
    FDsnRegister.MoseMove(Client, FMousePoint, Shift);
end;

procedure TDsnCtrl.ClientMouseUp(var Message: TWMMouse);
var
  Shift: TShiftState;
begin
  FMousePoint := Point(Message.XPos, Message.YPos);
  Shift:= KeysToShiftState(Message.Keys);

  if Assigned(FTarget)then
    FDsnRegister.MoseUp(Client, FMousePoint, Shift);
  ReleaseCapture;
end;

procedure TDsnCtrl.ClientCaptureChanged(var Message: TMessage);
begin
  //FTarget := nil;
end;

procedure TDsnCtrl.ClientPaint(var Message: TWMPaint);
begin
  with TMessage(Message) do Client.Perform(Msg, wParam, lParam);
end;

procedure TDsnCtrl.ClientWndProc(var Message: TMessage);
var
  r:integer;
begin
  case(Message.Msg)of
    WM_LBUTTONDOWN: 
    begin 
     r:= SendMessage(Client.Handle,CM_DESIGNHITTEST,
              TMessage(Message).WParam,TMessage(Message).LParam);
     if r = 1 then
        with Message do  // for PageControl's Tab
          Result := CallWindowProc(DefClientProc, Client.Handle,
                                 Msg, WParam, LParam)
     else;
       ClientMouseDown(TWMMouse(Message));
    end;
    WM_LBUTTONUP: ClientMouseUp(TWMMouse(Message));
    WM_MOUSEMOVE: ClientMouseMove(TWMMouse(Message));
    WM_RBUTTONDOWN: ClientContextMenu(TWMMouse(Message));
    WM_CAPTURECHANGED: ClientCaptureChanged(Message);
    WM_PAINT: ClientPaint(TWMPaint(Message));
    RM_START: ClientPreResize(TMessage(Message));
    RM_FINISH: ClientResize(TResizeMessage(Message));
    MH_SELECT: ClientSelect(TMessage(Message));
    CI_SELECT: ClientSelectByInspect(TMessage(Message));
    WM_SETFOCUS:ClientSetFocus(TMessage(Message));
    WM_DESTROY:ClientHandleChange(TMessage(Message));
    WM_LBUTTONDBLCLK:ClientDbClick(TWMMouse(Message));
    WM_NCHITTEST:Message.Result:= HTCLIENT;
    else

      with Message do
        Result := CallWindowProc(DefClientProc, Client.Handle,
                                 Msg, WParam, LParam); 
  end;
end;

procedure TDsnCtrl.ClientDbClick(var Message: TWMMouse);
begin
  FDsnRegister.DbClick(FTarget,TWMMouse(Message));
end;

procedure TDsnCtrl.ClientContextMenu(var Message: TWMMouse);
begin
  TMessage(Message).WParam:= 0;
  FMousePoint := Point(Message.XPos, Message.YPos);
  FDsnRegister.MainInsertPoint:=FMousePoint;
  FTarget := nil;
  FTarget := Client.ControlAtPos(FMousePoint, TRUE,true);
  if FTarget = nil then
    FTarget := Client;

  if FTarget.Owner <> Client.Owner then
    FTarget := Client;  // For Like DBNavigator

  SetCapture(Client.Handle);
  FDsnRegister.CallPopupMenu(Client, FTarget, Message.XPos, Message.YPos);
  FDsnRegister.FDsnStage.SetFocus;
end;

procedure TDsnCtrl.ClientHandleChange(var Message: TMessage);
begin
  EndSubClassing;

  with Message do
    Result := CallWindowProc(DefClientProc, Client.Handle,
                           Msg, WParam, LParam);
  PostMessage(FDsnRegister.FDsnStage.Handle, AG_DESTROY, Integer(Self),0);
end;

procedure TDsnCtrl.ClientPreResize(var Message: TMessage);
begin
  FTarget:= TControl(Message.WParam);
end;

procedure TDsnCtrl.ClientResize(var Message: TResizeMessage);
begin
  FDsnRegister.Resized(FTarget,Message);
end;

procedure TDsnCtrl.ClientSelect(var Message: TMessage);
begin
  FDsnRegister.Selected(FTarget,Message);
end;

procedure TDsnCtrl.ClientSelectByInspect(var Message: TMessage);
begin
  FDsnRegister.SelectByInspect(TControl(Message.WParam));
end;

procedure TDsnCtrl.ClientSetFocus(var Message: TMessage);
begin
  if not (Client is TDsnStage) then
    FDsnRegister.FDsnStage.SetFocus
  else
    with Message do
      Result := CallWindowProc(DefClientProc, Client.Handle,
                                 Msg, WParam, LParam);
end;

{TDsnSwitch}
procedure TDsnSwitch.SetDsnRegister(Value:TDsnRegister);
begin
  if Assigned(Value) then
    FDsnRegister:= Value
  else
    FDsnRegister:= nil;
end;

procedure TDsnSwitch.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
    if AComponent = FDsnRegister then FDsnRegister := nil;
end;

constructor TDsnSwitch.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DsnMessageFlg:=False;
  DsnMessage:= DSNMES_START;
end;

procedure TDsnSwitch.Loaded;
begin
  inherited;
  GroupIndex:=DsnSwc_GrpIdx;
  AllowAllUp:=True;
end;

procedure TDsnSwitch.Click;
begin
  if Down and DsnMessageFlg then
    ShowMessage(DsnMessage);

  if FDsnRegister <> nil then
    FDsnRegister.SetDesigning(Down);

  inherited;
end;

procedure TDsnSwitch.DesignOn;
begin
  if not Down then
  begin
    Down:= True;
    Click;
  end;

end;

procedure TDsnSwitch.DesignOff;
begin
  if Down then
  begin
    Down:= False;
    Click;
  end;

end;


{ TDsnPartner }

function TDsnPartner.CheckCanSelect(Control: TControl): Boolean;
begin
  if FDsnRegister <> nil then
    Result:= FDsnRegister.CheckCanSelect(Control)
  else
    Result:= False;
end;

constructor TDsnPartner.Create(AOwner: TComponent);
begin
  inherited;
  FDesigning:= False;
end;

procedure TDsnPartner.CreateMoveShape;
var
  i: integer;
begin
  if FDsnRegister <> nil then
  begin
    FDsnRegister.CreateMoveShape;
    FDsnRegister.FShape.Color:= FDsnRegister.Color;
    FDsnRegister.FShape.PenWidth:= FDsnRegister.PenWidth;
    for i:= 0 to FDsnRegister.FTargetList.Count -1 do
      FDsnRegister.FShape.Add(FDsnRegister.FTargetList[i]);
  end;
end;

procedure TDsnPartner.CreateTargetList;
begin
  if FDsnRegister <> nil then
    FDsnRegister.FTargetList:= FDsnRegister.CreateList;
end;

function TDsnPartner.GetDsnList: TDsnList;
begin
  if FDsnRegister <> nil then
    Result:= FDsnRegister.FDsnCtrlList
  else
    Result:= nil;
end;

function TDsnPartner.GetTargetList: TTargetList;
begin
  if FDsnRegister <> nil then
    Result:= FDsnRegister.FTargetList
  else
    Result:= nil;
end;

procedure TDsnPartner.SetDesigning(Value: Boolean);
begin
  if Value <> FDesigning then
    FDesigning:= Value;
end;

procedure TDsnPartner.SetDsnRegister(Value: TDsnRegister);
begin
  if Assigned(Value) then
  begin
    FDsnRegister:=Value;
    FDsnRegister.FreeNotification(Self);
    FDsnRegister.AddPartners(Self);
  end
  else
    FDsnRegister:=nil;
end;



procedure Register;
begin
  RegisterComponents('DsnSys', [TDsnSwitch]);
  RegisterComponents('DsnSys', [TDsnStage]);
  RegisterComponents('DsnSys', [TDsnPanel]);
  RegisterComponents('DsnSys', [TDsnInspector]);
  RegisterComponents('DsnSys', [TDsnRegister]);
  RegisterComponents('DsnSys', [TDsnDpRegister]);
  RegisterComponents('DsnSys', [TDsnRSRegister]);
  RegisterComponents('DsnSys', [TDsnClRegister]);
  RegisterComponents('DsnSys', [TDsnSelect]);
end;
initialization
  RegisterClass(TDsnButton);
  RegisterClass(TArrowButton);
 
end.
