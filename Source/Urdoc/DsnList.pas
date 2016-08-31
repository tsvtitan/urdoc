unit DsnList;

// Runtime Design System Version 2.x   June/08/1998
// Copyright(c) 1998 Kazuhiro Sasaki.

interface

uses
  Windows, Classes, Forms, Controls, Messages, Dialogs,
  Graphics;

type
  TReceiveTargets = class
  protected
    Notifies: TList;
    procedure ItemDeath(Index:Integer); virtual; abstract;
    procedure Add(Item:Pointer); virtual; abstract;
    procedure Clear; virtual; abstract;
    procedure Delete(Index:Integer); virtual; abstract;
    procedure SetPosition; virtual; abstract;
    procedure Notification(AComponent: TReceiveTargets); virtual;
  public
    destructor Destroy; override;
    procedure SelectNotification(AComponent: TReceiveTargets); virtual;
  end;

  TTargetList = class(TReceiveTargets)
  private
    FList: TList;
    FCount: Integer;
  protected
    function GetCount:Integer;
    function GetItems(Index:Integer):Pointer;
  public
    constructor Create;
    destructor Destroy; override;
    function IndexOf(Item:Pointer):Integer;
    procedure ItemDeath(Index:Integer); override;
    procedure Add(Item:Pointer); override;
    procedure Clear; override;
    procedure Delete(Index:Integer); override;
    procedure SetPosition; override;
    property Items[Index:Integer]: Pointer read GetItems; default;
    property List:TList read FList;
    property Count: Integer read GetCount;
  end;

implementation

destructor TReceiveTargets.Destroy;
var
  i:integer;
begin
  if Assigned(Notifies) then
    for i:= 0 to Notifies.Count -1 do
      TReceiveTargets(Notifies[i]).Notification(Self);
  inherited Destroy;
end;

procedure TReceiveTargets.SelectNotification(AComponent: TReceiveTargets);
begin
  if Assigned(AComponent) then
  begin
    if not Assigned(Notifies) then
      Notifies := TList.Create;
    if Notifies.IndexOf(AComponent) < 0 then
    begin
      Notifies.Add(AComponent);
      AComponent.SelectNotification(Self);
    end;
  end;
end;

procedure TReceiveTargets.Notification(AComponent: TReceiveTargets);
var
  n:integer;
begin
  if Assigned(AComponent)and Assigned(Notifies) then
  begin
    n:= Notifies.IndexOf(AComponent);
    Notifies.Delete(n);
  end;
end;

{TTargetList}
constructor TTargetList.Create;
begin
  FList:= TList.Create;
end;

destructor TTargetList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TTargetList.GetCount:Integer;
begin
  if Assigned(FList) then
    Result:= FList.Count
  else
    Result:= -1;
  FCount:= Result;
end;

function TTargetList.GetItems(Index:Integer):Pointer;
begin
  Result:= nil;

  if Assigned(FList) then
    if Index >= FList.Count then
      Result:= nil
    else
      Result:= FList[Index];
end;

function TTargetList.IndexOf(Item:Pointer):Integer;
begin
  if Assigned(FList) then
    Result:= FList.IndexOf(Item)
  else
    Result:= -1;
end;

procedure TTargetList.ItemDeath(Index:Integer);
var
  i:integer;
begin
  if Assigned(FList) then
    FList[Index]:= nil;
  if Assigned(Notifies) then
    for i:= 0 to Notifies.Count -1 do
      TReceiveTargets(Notifies[i]).ItemDeath(Index);
end;

procedure TTargetList.Add(Item:Pointer);
var
  i:integer;
begin
  if Assigned(FList) then
    FList.Add(Item);
  if Assigned(Notifies) then
    for i:= 0 to Notifies.Count -1 do
      TReceiveTargets(Notifies[i]).Add(Item);
end;

procedure TTargetList.Clear;
var
  i:integer;
begin
  if Assigned(FList) then
    FList.Clear;
  if Assigned(Notifies) then
    for i:= 0 to Notifies.Count -1 do
      TReceiveTargets(Notifies[i]).Clear;
end;

procedure TTargetList.Delete(Index:Integer);
var
  i:Integer;
begin
  if Assigned(FList) then
    FList.Delete(Index);
  if Assigned(Notifies) then
    for i:= 0 to Notifies.Count -1 do
      TReceiveTargets(Notifies[i]).Delete(Index); 
end;

procedure TTargetList.SetPosition;
var
  i:integer;
begin
  if Assigned(Notifies) then
    for i:= 0 to Notifies.Count -1 do
      TReceiveTargets(Notifies[i]).SetPosition;
end;


end.
