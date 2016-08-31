unit DsnAgent;

// Runtime Design System Version 2.x   June/08/1998
// Copyright(c) 1998 Kazuhiro Sasaki.

interface

uses
  Windows, Messages, SysUtils,Classes, Forms, Controls,
  Dialogs, DsnMes, DsnLgMes;

type

  TDeleteQuery = procedure
                    (Sender:TObject;Component:TComponent;
                               var CanDelete:Boolean) of object;

  TAgent = class
  private
    FClientHandle: THandle;
    FDefClientProc: TFarProc;
    FClientInstance: TFarProc;
    FOnFreeInstance: TThreadMethod;
  protected
    FTarget:TControl;
    FSubClassing: Boolean;
    procedure ClientCaptureChanged(var Message: TMessage);virtual;
    procedure ClientWndProc(var Message: TMessage);virtual;abstract;
    procedure EndSubClassing;virtual;
  public
    constructor Create(Handle: THandle);virtual;
    destructor Destroy; override;
    procedure ChangeHandele(Handle: THandle);virtual;
    property DefClientProc: TFarProc read FDefClientProc;
    property OnFreeInstance: TThreadMethod read FOnFreeInstance write FOnFreeInstance;
    property ClientHandle: THandle read FClientHandle write FClientHandle;
  end;

  TAgentList = class;

  TClientAgent = class(TAgent)
  private
    FClient: TWinControl;
    FAgentList:TAgentList;
  protected
    procedure TakeInstance;virtual;abstract;
    procedure ReleaseInstance;virtual;abstract;
  public
    constructor CreateInstance(AClient: TWinControl);virtual;
    destructor Destroy; override;
    procedure ChangeHandele(Handle: THandle);override;
    property Client: TWinControl read FClient;
    property AgentList: TAgentList read FAgentList write  FAgentList;
  end;

  TAgentList = class
  private
    FList: TList;
    procedure Clear;
    procedure ReScanChild(Instance: TWinControl; Handle: THandle);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Handle: THandle);
  end;

  TChildHandle = record
    Instance:TWinControl;
    Handle: THandle;
  end;

  TChildList = class
  private
    FHandleList: TList;
    FControlList: TList;
    FHandle: THandle;
    FParent: TWinControl;
    function GetItems(Index:Integer):TChildHandle;
    procedure MakeList;
  public
    constructor Create(Instance: TWinControl; Handle: THandle);
    destructor Destroy; override;
    function Count:Integer;
    property Items[Index:Integer]: TChildHandle read GetItems; default;
  end;

  TFormAgent = class(TClientAgent)
  protected
    procedure ClientWndProc(var Message: TMessage); override;
    procedure KillComponent(Component: TComponent);
    procedure TakeInstance; override;
    procedure ReleaseInstance; override;
  end;

implementation

type

  TChildAgent = class(TAgent)
  protected
    procedure ClientWndProc(var Message: TMessage);override;
  end;

constructor TAgent.Create(Handle: THandle);
begin
  FClientHandle := Handle;
  FOnFreeInstance:= nil;
  if Handle <> 0 then
  begin
    FClientInstance := MakeObjectInstance(ClientWndProc);
    FDefClientProc := Pointer(GetWindowLong(FClientHandle,
                              GWL_WNDPROC));
    if SetWindowLong(FClientHandle, GWL_WNDPROC,
                       Longint(FClientInstance)) = 0 then
    begin
      raise Exception.Create(AGT_ECREAT);
    end;
  end;
  FSubClassing:= True;
end;

destructor TAgent.Destroy;
begin
  {SetWindowLong(FClientHandle, GWL_WNDPROC,
                            Longint(FDefClientProc));
  FreeObjectInstance(FClientInstance); }
  if FSubClassing then
    EndSubClassing;
  if Assigned(FOnFreeInstance) then
    FOnFreeInstance;

  inherited Destroy;
end;

procedure TAgent.EndSubClassing;
begin
  SetWindowLong(FClientHandle, GWL_WNDPROC,
                            Longint(FDefClientProc));
  FreeObjectInstance(FClientInstance);

  FSubClassing:= False;

  {if Assigned(FOnFreeInstance) then
    FOnFreeInstance;}
end;

procedure TAgent.ClientCaptureChanged(var Message: TMessage);
begin
  FTarget := nil;
end;

procedure TAgent.ChangeHandele(Handle: THandle);
begin
  FClientHandle:= Handle;
  if Handle <> 0 then
  begin
    FClientInstance := MakeObjectInstance(ClientWndProc);
    FDefClientProc := Pointer(GetWindowLong(FClientHandle,
                              GWL_WNDPROC));
    if SetWindowLong(FClientHandle, GWL_WNDPROC,
                       Longint(FClientInstance)) = 0 then
    begin
      raise Exception.Create(AGT_ECREAT);
    end;
  end;
  FSubClassing:= True;
end;

constructor TClientAgent.CreateInstance(AClient: TWinControl);
begin
  FClient := AClient;
  FAgentList:= TAgentList.Create;
  TakeInstance;
  if Assigned(FClient) then
  begin
    inherited Create(FClient.Handle);
  end;
end;

destructor TClientAgent.Destroy;
begin
  if Assigned(FAgentList) then
    FAgentList.Free;
  OnFreeInstance:= ReleaseInstance;
  inherited Destroy;
end;

procedure TClientAgent.ChangeHandele(Handle: THandle);
begin
  inherited;
  if Assigned(FAgentList) then
  begin
    FAgentList.Clear;
    FAgentList.ReScanChild(Client,Handle);
  end;
end;

procedure TChildAgent.ClientWndProc(var Message: TMessage);
begin
  case(Message.Msg)of
    WM_NCHITTEST:Message.Result:= HTTRANSPARENT;
    else
      with Message do
        Result := CallWindowProc(FDefClientProc, FClientHandle,
                                 Msg, WParam, LParam);
  end;
end;

constructor TAgentList.Create;
begin
  FList:= TList.Create
end;

destructor TAgentList.Destroy;
var
  i:integer;
begin
  for i:= 0 to FList.Count -1 do
    TChildAgent(FList[i]).Free;
  FList.Free;
  inherited Destroy;
end;

procedure TAgentList.Add(Handle: THandle);
var
  Child:TChildAgent;
begin
  Child:= TChildAgent.Create(Handle);
  FList.Add(Child);
end;

procedure TAgentList.Clear;
var
  i:integer;
begin
  for i:= 0 to FList.Count -1 do
    TChildAgent(FList[i]).Free;
  FList.Clear;
end;

procedure TAgentList.ReScanChild(Instance: TWinControl; Handle: THandle);
var
  List:TChildList;
  i:integer;
  procedure Proc(AHandle: THandle);
  var
    AList:TChildList;
    j:integer;
  begin
    Add(AHandle);
    AList:= TChildList.Create(nil,AHandle);
    for j:= 0 to AList.Count -1 do
      Proc(AList[j].Handle);
    AList.Free;
  end;
begin
  List:= TChildList.Create(Instance,Handle);
  for i:= 0 to List.Count -1 do
  begin
    if List[i].Instance <> nil then
      if List[i].Instance.Owner <> Instance.Owner then
        Proc(List[i].Handle);
    if List[i].Instance = nil then
      Proc(List[i].Handle);
  end;
  List.Free;
end;

constructor TChildList.Create(Instance: TWinControl; Handle: THandle);
begin
  FHandleList:= TList.Create;
  FControlList:= TList.Create;
  FHandle:= Handle;
  FParent:= Instance;
  MakeList;
end;

destructor TChildList.Destroy;
begin
  FHandleList.Free;
  FControlList.Free;
  inherited Destroy;
end;

procedure TChildList.MakeList;
var
  i,h,n:integer;
  HList,IList:TList;
begin
  HList:= TList.Create;
  IList:= TList.Create;
  if Assigned(FParent) then
    for i:= 0 to FParent.ControlCount -1 do
      if FParent.Controls[i] is TWinControl then
      begin
        HList.Add(Pointer((FParent.Controls[i] as TWinControl).Handle));
        IList.Add(FParent.Controls[i]);
      end;
  h:= GetWindow(FHandle, GW_CHILD);
  while h <> 0 do
  begin
    FHandleList.Add(Pointer(h));
    h:= GetWindow(h, GW_HWNDNEXT);
  end;
  for i:= 0 to FHandleList.Count -1 do
  begin
    n:= HList.IndexOf(FHandleList[i]);
    if n >= 0 then
      FControlList.Add(IList[n])
    else
      FControlList.Add(nil);
  end;
  HList.Free;
  IList.Free;
end;

function TChildList.GetItems(Index:Integer):TChildHandle;
begin
  Result.Handle:= Integer(FHandleList[Index]);
  Result.Instance:= FControlList[Index];
end;

function TChildList.Count:Integer;
begin
  Result:= FControlList.Count;
end;

//***TFormAgent***//
procedure TFormAgent.ClientWndProc(var Message: TMessage);
begin
  case(Message.Msg)of
    FA_KILLCOMPONENT:KillComponent(TComponent(Message.wParam));
    else
      with Message do
        Result := CallWindowProc(DefClientProc, Client.Handle,
                                 Msg, WParam, LParam);
  end;
end;

// Suicide Aid
procedure TFormAgent.KillComponent(Component: TComponent);
begin
  Component.Free;
end;

procedure TFormAgent.TakeInstance;
begin
end;

procedure TFormAgent.ReleaseInstance;
begin
end;

end.
