(*******************************************************************************
* Server of virtual timers:                                                    *
*     - Interval (msec) start/stop and autorestartable.                        *
*     - Periodic (seconds-months), synchronized with system time.              *
* Notification with Event object or messages.                                  *
*******************************************************************************)
unit tsvTimers;

interface

uses Windows,Classes,SysUtils;

const
  tmPeriod    = $00;    // Autorestart timer
  tmStartStop = $01;    // Start-Stop timer (disable after first tick)
  tmSureSync  = $02;    // Synchronized periodical timer
                            // with skip checking

  stEnable    = 0;
  stDisable   = 1;
  stMask      = $80;

  ttInterval  = 1;
  ttFixed     = 2;

  SleepTime   = 10;

const tnEvent       = 0;    // Use kernel object Event (SetEvent)
      tnThreadMsg   = 1;    // Use message to thread ID (PostThreadMessage)
      tnWinMsg      = 2;    // Use message to window HWND (PostMessage)
      tnCallBack    = 3;    // Asynchronous call user function TNotifierProc
      tnCallEvent   = 4;    // Asynchronous call object event handler TNotifierEvent

type TNotifierProc = procedure(Owner: THandle; Msg,UserParam : dword);
     TNotifierEvent = procedure(Sender : TObject; Msg, UserParam: dword) of object;

     
type
  TCronSet = set of 0..59;
  TCronGroups = (crSec, crMin, crHour, crDay, crMonth, crDoW);

  TCron = class
  private
    Groups : array[TCronGroups] of TCronSet;
  public
    procedure Init(CronMask : shortstring);
    function IsCron(const CheckTime: TSYSTEMTIME) : boolean;
    procedure GetLastCronTime(var Time : SYSTEMTIME);
  end;

  TNotify = class
  protected
    hNotify : THandle;
    hOwner : THandle;
    Message,
    UParam : dword;
  public
    constructor Create(hEventObj : THandle);
    procedure Execute; virtual;
    property Owner : THandle read hOwner write hOwner;
    property Param : dword read UParam write UParam;
  end;

  TThreadNotify = class(TNotify)
  protected
  public
    constructor Create(hEventObj,hSender : THandle;
                       MsgID,UserParam : dword);
    procedure Execute; override;
  end;

  TWinNotify = class(TThreadNotify)
  public
    procedure Execute; override;
  end;

  TCallBackNotify = class(TThreadNotify)
  public
    procedure Execute; override;
  end;

  TCallEventNotify = class(TThreadNotify)
  private
    fOnNotify : TNotifierEvent;
  public
    constructor Create(hEventObj : TNotifierEvent; hSender : THandle;
                       MsgID,UserParam : dword);
    property OnNotify : TNotifierEvent read fOnNotify write fOnNotify;
    procedure Execute; override;
  end;

  (* Base virtual timer *)
  TTimer = class
  private
    fNotifier : TNotify;
    function GetActive: boolean;
    procedure SetActive(Run : boolean);
  protected
    fMode,fStatus : byte;
    procedure Tick;
  public
    constructor Create(NotifyObj : TNotify; Mode : byte; Run : boolean);
    destructor Destroy; override;
    property Active : boolean read GetActive write SetActive;
    property Mode : byte read fMode write fMode;
    procedure Reset; virtual; abstract;
  end;

  (* Interval timer object *)
  TIntervalTimer = class(TTimer)
  private
    fInterval,
    fCurrent : dword;
  public
    constructor Create(NotifyObj : TNotify; Mode : byte; Run : boolean; Int : dword);
    property Interval : dword read fInterval write fInterval;
    procedure Update(Increment : dword);
    procedure Reset; override;
  end;

  (* Synchronized timer object *)
  TFixedTimer = class(TTimer)
  private
    fTimeMask : TCron;
    fLastTime : TSystemtime;
    procedure SetCron(const CronMask : shortstring);
  public
    constructor Create(NotifyObj : TNotify; Mode : byte; Run : boolean; const CronMask : shortstring);
    destructor Destroy; override;
    property TimeMask : shortstring write SetCron;
    property LastTime : TSYSTEMTIME read fLastTime write fLastTime;
    procedure Update(const CheckTime : TSystemTime);
    procedure Reset; override;
  end;

  (* Virtual timer manager object *)
  TTimerManager = class(TThread)
  private
    TimerList,
    AlarmList : TThreadList;
    LastTicks : dword;
    LastSecond : word;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddTimer(Item : TTimer);
    procedure DeleteTimer(Item : TTimer);
  end;

var Server : TTimerManager;

function MakeNotifier(hEventObj,hSender : THandle;
                      EventType : byte; MsgID,UserParam : dword) : TNotify;
function IsEqualTime(const T1,T2 : TSYSTEMTIME) : boolean;

                      

implementation


(*** Creating interval timer with object event handler ***)
function tmCreateIntervalTimer(
        hEventProc: TNotifierEvent;  // Client event handler
        Interval  : dword;    // Time interval, msec
        Mode      : byte;     // Timer mode
        Run       : boolean;  // Start timer immediately
        Msg,                  // Message code (2nd handler parameter)
        UserParam : dword     // User parameter (3rd handler parameter)
        ) : THandle;
  var T : TIntervalTimer;
  begin
    T := TIntervalTimer.Create(
        TCallEventNotify.Create(hEventProc, 0, Msg, UserParam),
        Mode, Run, Interval);
    Server.AddTimer(T);
    result := THANDLE(T);
  end;

(*** Creating interval timer ***)
function tmCreateIntervalTimerEx(
        hEventObj : THandle;  // Notify object handle
        Interval  : dword;    // Time interval, msec
        Mode      : byte;     // Timer mode
        Run       : boolean;  // Start timer immediately
        EventType : byte;     // Notify object type
        Msg,                  // Message code
        UserParam : dword     // User parameter for message
        ) : THandle;
  var N : TNotify; T : TIntervalTimer;
  begin
    N := MakeNotifier(hEventObj, 0, EventType, Msg, UserParam);
    if N = nil then Result := INVALID_HANDLE_VALUE
    else
      begin
        T := TIntervalTimer.Create(N, Mode, Run, Interval);
        Server.AddTimer(T);
        result := THANDLE(T);
      end;
  end;

(*** Closing timer ***)
procedure tmCloseTimer(hTimer : THandle);
  begin
    Server.DeleteTimer(TTimer(hTimer));
  end;

(*** Starting timer (enable work) ***)
procedure tmStartTimer(hTimer : THandle);
  begin
    TTimer(hTimer).Active := true;
  end;

(*** Stopping timer (disable work) ***)
procedure tmStopTimer(hTimer : THandle);
  begin
    TTimer(hTimer).Active := false;
  end;

(*** Resetting timer ***)
procedure tmResetTimer(hTimer : THandle);
  begin
    TTimer(hTimer).Reset;
  end;

(*** Set timer mode ***)
procedure tmSetTimerMode(hTimer : THandle; Mode : byte);
  begin
    TTimer(hTimer).Mode := Mode;
  end;

(*** Modify timer interval ***)
procedure tmSetTimerInterval(hTimer : THandle; Interval : dword);
  begin
    TIntervalTimer(hTimer).Interval := Interval;
  end;

(*** Creating synchronized period timer with object event handler ***)
function tmCreateFixedTimer(
        hEventProc: TNotifierEvent;  // Client event handler
        TimeMask  : ShortString;// Time period in CRON format
        Mode      : Byte;       // Timer mode
        Run       : Boolean;    // Start timer immediately
        Msg,                    // Message code
        UserParam : dword       // User parameter for message
        ) : THandle;
  var T : TFixedTimer;
  begin
    T := TFixedTimer.Create(
        TCallEventNotify.Create(hEventProc, 0, Msg, UserParam),
        Mode, Run, TimeMask);
    Server.AddTimer(T);
    result := THANDLE(T);
  end;

(*** Creating synchronized period timer ***)
function tmCreateFixedTimerEx(
        hEventObj : THandle;    // Notify object handle
        TimeMask  : ShortString;// Time period in CRON format
        Mode      : Byte;       // Timer mode
        Run       : Boolean;    // Start timer immediately
        EventType : Byte;       // Notify object type
        Msg,                    // Message code
        UserParam : dword       // User parameter for message
        ) : THandle;
  var N : TNotify; T : TFixedTimer;
  begin
    N := MakeNotifier(hEventObj, 0, EventType, Msg, UserParam);
    if (N = nil) then Result := INVALID_HANDLE_VALUE
    else
      begin
        T := TFixedTimer.Create(N, Mode, Run, TimeMask);
        Server.AddTimer(T);
        result := THANDLE(T);
      end;
  end;

(*** Modify fixed timer CRON mask ***)
procedure tmSetTimerMask(hTimer : THandle; TimeMask : shortstring);
  begin
    TFixedTimer(hTimer).TimeMask := TimeMask;
  end;

(*** Load fixed timer LastTime ***)
procedure tmSetLastTime(hTimer : THandle; var LastTime : TSystemTime);
  begin
    TFixedTimer(hTimer).LastTime := LastTime;
  end;

(*** Save fixed timer LastTime ***)
procedure tmGetLastTime(hTimer : THandle; var LastTime : TSystemTime);
  begin
    LastTime := TFixedTimer(hTimer).LastTime;
  end;

// Check equivalence of time T1 and T2 (seconds-months)
function IsEqualTime(const T1,T2 : TSYSTEMTIME) : boolean;
  begin
    result := (T1.wMonth  = T2.wMonth)  and
              (T1.wDay    = T2.wDay)    and
              (T1.wHour   = T2.wHour)   and
              (T1.wMinute = T2.wMinute) and
              (T1.wSecond = T2.wSecond);
  end;

// Get first word from Src to delimiter, put into result,
// return remainder im Src
function GetWord(var Src : shortstring; Delim : char) : shortstring;
  var p : integer;
  begin
    p := pos(Delim, Src);
    if p <> 0 then
      begin
        result := copy(Src, 1, p-1);
        delete(Src, 1, p);
      end
    else
      begin
        result := Src;
        Src := '';
      end;
  end;

// Convert number string (non blank) to set,
// return true when end of line,
// remainder in Src
function ParseGroup(var Group : TCronSet; var Src : shortstring) : boolean;
  var GSrc,VSrc,NSrc : string[63];
      Step,Last,Item,e : integer;
  begin
    result := true; if Src = '' then exit;
    gsrc := GetWord(Src, ' ');
    if pos('*', gsrc) = 0 then
      begin
        Group := [];
        while gsrc <> '' do
          begin
            vsrc := GetWord(gsrc, ',');
            nsrc := GetWord(vsrc, '+');
            val(vsrc, step, e);
            vsrc := GetWord(nsrc, '-');
            val(nsrc, last, e);
            if (e <> 0) and (Step <> 0) then Last := 59;
            val(vsrc, item, e);
            if Step = 0 then Step := 1;
            repeat
              if item > 59 then break;
              include(Group, Item);
              inc(Item, Step);
            until Item > Last;
          end;
      end;
    result := Src = '';
  end;


(*** TCron object ***)

procedure TCron.Init(CronMask : shortstring);
  var i : TCronGroups;
  begin
    fillchar(Groups, sizeof(Groups), $FF);
    for i := crSec to crDoW do
      if ParseGroup(Groups[i], CronMask) then break;
  end;

type TTimeArray = array[0..7] of word;
const TimeNdx : array[TCronGroups] of byte = (6,5,4,3,1,2);

function TCron.IsCron(const CheckTime: SYSTEMTIME) : boolean;
  begin
    result := (CheckTime.wSecond in Groups[crSec]) and
              (CheckTime.wMinute in Groups[crMin]) and
              (CheckTime.wHour in Groups[crHour]) and
              (CheckTime.wDay in Groups[crDay]) and
              (CheckTime.wMonth in Groups[crMonth]) and
              (CheckTime.wDayOfWeek in Groups[crDoW]);
  end;

procedure TCron.GetLastCronTime(var Time : SYSTEMTIME);
  var ICnt,MCnt : integer; Borrow : Boolean;
  procedure DecItem(var Group : TCronSet; var Item : word;
                    Min,Max : integer);
    var i : integer;
    begin
      inc(ICnt); i := Item;
      if (i in Group) and not Borrow then exit;
      repeat
        Borrow := i <= Min; if Borrow then break;
        dec(i);
      until i in Group;
      if i <> Item then MCnt := ICnt-1;
      if Borrow then MCnt := ICnt
      else Item := i;
    end;
  function ToMaxItem(var Group : TCronSet; var Item : word;
                      Min,Max : integer) : boolean;
    var i : integer;
    begin
      i := Max;
      repeat
        if i in Group then break;
        dec(i);
      until i <= Min;
      Item := i; dec(MCnt);
      result := MCnt = 0;
    end;
  const GLim : array[TCronGroups] of record Lo,Hi : byte end =
    ( (Lo:0; Hi:59), (Lo:0; Hi:59), (Lo:0; Hi:23),
      (Lo:1; Hi:31), (Lo:1; Hi:12), (Lo:0; Hi:6) );
  var i : TCronGroups;
      Times : TTimeArray absolute Time;
  begin
    ICnt := 0; MCnt := 0; Borrow := false;
    for i := crSec to crMonth do
      DecItem(Groups[i], Times[TimeNdx[i]], GLim[i].Lo, GLim[i].Hi);
    if Borrow or (MCnt <> 0) then
      for i := crMonth downto crSec do
        if ToMaxItem(Groups[i], Times[TimeNdx[i]], GLim[i].Lo, GLim[i].Hi) then
          break;
  end;

function MakeNotifier(hEventObj,hSender : THandle;
                      EventType : byte; MsgID,UserParam : dword) : TNotify;
  begin
    case EventType of
      tnEvent     : result := TNotify.Create(hEventObj);
      tnThreadMsg :
        result := TThreadNotify.Create(hEventObj, hSender, MsgID, UserParam);
      tnWinMsg    :
        result := TWinNotify.Create(hEventObj, hSender, MsgID, UserParam);
      tnCallBack  :
        result := TCallBackNotify.Create(hEventObj, hSender, MsgID, UserParam);
      //tnCallEvent :
      //  result := TCallEventNotify.Create(hEventObj, hSender, MsgID, UserParam);
    else result := nil;
    end;
  end;


(*** TNotify ***)

constructor TNotify.Create(hEventObj : THandle);
  begin
    hNotify := hEventObj;
  end;

procedure TNotify.Execute;
  begin
    SetEvent(hNotify);
  end;


(*** TThreadNotify ***)

constructor TThreadNotify.Create(hEventObj,hSender : THandle;
                                 MsgID,UserParam : dword);
  begin
    inherited Create(hEventObj);
    Owner := hSender;
    Message := MsgID;
    UParam := UserParam;
  end;

procedure TThreadNotify.Execute;
  begin
    PostThreadMessage(hNotify, Message, UParam, hOwner);
  end;

(*** TWinNotify ***)

procedure TWinNotify.Execute;
  begin
    PostMessage(hNotify, Message, UParam, hOwner);
  end;

(*** TCallbackNotify ***)

procedure TCallbackNotify.Execute;
  begin
    TNotifierProc(hNotify)(hOwner, Message, UParam);
  end;

(*** TCalleventNotify ***)

constructor TCalleventNotify.Create(hEventObj : TNotifierEvent; hSender : THandle;
                    MsgID,UserParam : dword);
  begin
    OnNotify := hEventObj;
    Owner := hSender;
    Message := MsgID;
    UParam := UserParam;
  end;

procedure TCalleventNotify.Execute;
  begin
    if assigned(OnNotify) then OnNotify(TObject(Owner), Message, UParam);
  end;


(*** TTimer ***)

constructor TTimer.Create(NotifyObj : TNotify; Mode : byte; Run : boolean);
  begin
    fNotifier := NotifyObj;
    fNotifier.Owner := THandle(Self);
    Active := Run;
    Self.Mode := Mode;
  end;

destructor TTimer.Destroy;
  begin
    fNotifier.Free;
    inherited;
  end;

function TTimer.GetActive: boolean;
  begin
    result := fStatus and stDisable = 0;
  end;

procedure TTimer.SetActive(Run : boolean);
  begin
    if Run then fStatus := fStatus and not stDisable
    else fStatus := fStatus or stDisable;
  end;

procedure TTimer.Tick;
  begin
    if Mode and tmStartStop <> 0 then Active := false;
    fNotifier.Execute;
  end;

(*** TTimerManager ***)

constructor TTimerManager.Create;
  begin
    inherited Create(true);
    Priority := tpTimeCritical;
    TimerList := TThreadList.Create;
    AlarmList := TThreadList.Create;
    Resume;
  end;

destructor TTimerManager.Destroy;
  var i : integer;
  begin
    Terminate;
    with TimerList.LockList do try
      for i := 0 to Count-1 do TTimer(Items[i]).Free;
    finally
      TimerList.UnlockList;
    end;
    TimerList.Free;
    with AlarmList.LockList do try
      for i := 0 to Count-1 do TTimer(Items[i]).Free;
    finally
      AlarmList.UnlockList;
    end;
    AlarmList.Free;
  end;

procedure TTimerManager.AddTimer(Item : TTimer);
  begin
    if Item is TIntervalTimer then
      begin
        with TimerList.LockList do Add(Item);
        TimerList.UnlockList;
      end
    else
      begin
        with AlarmList.LockList do Add(Item);
        AlarmList.UnlockList;
      end
  end;

procedure TTimerManager.DeleteTimer(Item : TTimer);
  begin
    if Item is TIntervalTimer then
      begin
        with TimerList.LockList do Remove(Item);
        TimerList.UnlockList;
      end
    else
      begin
        with AlarmList.LockList do Remove(Item);
        AlarmList.UnlockList;
      end;
    Item.Free;
  end;

procedure TTimerManager.Execute;
  var Ticks,Diff : dword;
      i : integer; Time : TSYSTEMTIME;
  begin
    LastTicks := GetTickCount;
    while not Terminated do
      begin
        Sleep( SLEEPTIME - (GetTickCount mod SLEEPTIME) );
        Ticks := GetTickCount;
        Diff := Ticks-LastTicks;
        LastTicks := Ticks;

        with TimerList.LockList do try
          for i := 0 to Count-1 do
            begin
              if Terminated then exit;
              TIntervalTimer(Items[i]).Update(Diff);
            end;
        finally
          TimerList.UnlockList;
        end;

        GetLocalTime(Time);
        if Time.wSecond = LastSecond then continue;
        LastSecond := Time.wSecond;

        with AlarmList.LockList do try
          for i := 0 to Count-1 do
            begin
              if Terminated then exit;
              TFixedTimer(Items[i]).Update(Time);
            end;
        finally
          AlarmList.UnlockList;
        end;
      end;
  end;


(*** TIntervalTimer ***)

constructor TIntervalTimer.Create(NotifyObj: TNotify; Mode: byte;
  Run: boolean; Int: dword);
  begin
    inherited Create(NotifyObj, Mode, Run);
  end;

procedure TIntervalTimer.Reset;
  begin
    fCurrent := 0;
  end;

procedure TIntervalTimer.Update(Increment : dword);
  begin
    if not Active then exit;
    inc(fCurrent, Increment);
    if fCurrent < Interval then exit;
    fCurrent := fCurrent mod Interval;
    if Mode and tmStartStop <> 0 then fCurrent := 0;
    Tick;
  end;


(*** TFixedTimer ***)

constructor TFixedTimer.Create(NotifyObj: TNotify; Mode: byte;
  Run: boolean; const CronMask: shortstring);
  begin
    inherited Create(NotifyObj, Mode, Run);
    fTimeMask := TCron.Create;
    TimeMask := CronMask;
  end;

destructor TFixedTimer.Destroy;
  begin
    fTimemask.Free;
    inherited;
  end;

procedure TFixedTimer.Reset;
  begin
    fStatus := fStatus or stMask;
  end;

procedure TFixedTimer.SetCron(const CronMask: shortstring);
  begin
    fTimeMask.Init(CronMask);
    Reset;
  end;

procedure TFixedTimer.Update(const CheckTime : TSystemTime);
  var T : TSystemTime;
  begin
    if not Active then exit;
    if fTimeMask.IsCron(CheckTime) then  // Normal match
      begin
        Tick; LastTime := CheckTime;
      end
    else if Mode = tmSureSync then      // Check last unhandled moment
      begin
        T := CheckTime;
        fTimeMask.GetLastCronTime(T);
        if fStatus and stMask <> 0 then // First checking for LastTime was masked
          begin
            LastTime := T;
            fStatus  := fStatus and not stMask;
          end
        else if not IsEqualTime(T, LastTime) then // Match last unhandled moment
          begin
            Tick; LastTime := T;
          end;
      end;
  end;

initialization
  Server := TTimerManager.Create;
finalization
  Server.Free;

end.
