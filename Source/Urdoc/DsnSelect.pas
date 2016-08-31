unit DsnSelect;

// Runtime Design System Version 2.x   June/08/1998
// Copyright(c) 1998 Kazuhiro Sasaki.

// DsnSelect.pas May/22/1999

interface

uses
  Windows, Messages, SysUtils, Classes, Controls,
  DsnList, DsnUnit, DsnLgMes, DsnMes, DsnProp;

type
  TDsnSelect = class;
  TSelectionManager = class(TReceiveTargets)
  private
    FList: TList;
    FDsnSelect: TDsnSelect;
  protected
    procedure ItemDeath(Index:Integer); override;
    procedure Add(Item:Pointer); override;
    procedure Clear; override;
    procedure Delete(Index:Integer); override;
    procedure SetPosition; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TSelectOperation = (opAdd, opClear, opDelete, opItemDeath);
  TChangeSelected = procedure
                    (Sender: TObject; Targets: TSelectedComponents;
                    Operation: TSelectOperation) of Object;

  TDsnSelect = class(TDsnPartner)
  private
    FSelectionManager: TSelectionManager;
    FChangeSelected: TChangeSelected;
  protected
    procedure SetDesigning(Value:Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Select(Control: TControl); virtual;
    procedure MultipleSelect(List: TList); virtual;
  published
    property DsnRegister;
    property OnChangeSelected: TChangeSelected read FChangeSelected write FChangeSelected;
  end;


implementation

{ TSelectionManager }

procedure TSelectionManager.Add(Item: Pointer);
var
  Targets: TSelectedComponents;
begin
  FList.Add(Item);
  if Assigned(FDsnSelect.FChangeSelected) then
  begin
    Targets:= TSelectedComponents.Create;
    Targets.AssignList(FList);
    FDsnSelect.FChangeSelected(FDsnSelect,Targets,opAdd);
  end;
end;

procedure TSelectionManager.Clear;
var
  Targets: TSelectedComponents;
begin
  FList.Clear;
  if Assigned(FDsnSelect.FChangeSelected) then
  begin
    Targets:= TSelectedComponents.Create;
    Targets.AssignList(FList);
    FDsnSelect.FChangeSelected(FDsnSelect,Targets,opClear);
  end;
end;

constructor TSelectionManager.Create;
begin
  FList:= TList.Create;
end;

procedure TSelectionManager.Delete(Index: Integer);
var
  Targets: TSelectedComponents;
begin
  FList.Delete(Index);
  if Assigned(FDsnSelect.FChangeSelected) then
  begin
    Targets:= TSelectedComponents.Create;
    Targets.AssignList(FList);
    FDsnSelect.FChangeSelected(FDsnSelect,Targets,opDelete);
  end;
end;

destructor TSelectionManager.Destroy;
begin
  if FList <> nil then
    FList.Free;
  inherited;
end;

procedure TSelectionManager.ItemDeath(Index: Integer);
var
  Targets: TSelectedComponents;
begin
  FList[Index]:= nil;
  if Assigned(FDsnSelect.FChangeSelected) then
  begin
    Targets:= TSelectedComponents.Create;
    Targets.AssignList(FList);
    FDsnSelect.FChangeSelected(FDsnSelect,Targets,opItemDeath);
  end;
end;

procedure TSelectionManager.SetPosition;
begin

end;

{ TDsnSelect }

constructor TDsnSelect.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TDsnSelect.Destroy;
begin
  if FSelectionManager <> nil then
    FSelectionManager.Free;
  inherited;
end;

procedure TDsnSelect.MultipleSelect(List: TList);
var
  TargetList: TTargetList;
  i: integer;
  Flag: Boolean;
  Control: TControl;
begin
  if not FDesigning then
    Exit;
  Flag:= False;
  for i:= 0 to List.Count -1 do
  begin
    Control:= TControl(List[i]);
    Flag:= CheckCanSelect(Control);
    if Flag then
      Break;
  end;
  if Flag then
  begin
    TargetList:= GetTargetList;
    if TargetList = nil then
    begin
      CreateTargetList;
      TargetList:= GetTargetList;
    end;
    TargetList.Clear;
    for i:= 0 to List.Count -1 do
    begin
      Control:= TControl(List[i]);
      TargetList.Add(Control);
    end;
    TargetList.SetPosition;
  end;
end;

procedure TDsnSelect.Select(Control: TControl);
var
  TargetList: TTargetList;
begin
  if not FDesigning then
    Exit;
  if CheckCanSelect(Control) then
  begin
    TargetList:= GetTargetList;
    if TargetList = nil then
    begin
      CreateTargetList;
      TargetList:= GetTargetList;
    end;
    TargetList.Clear;
    TargetList.Add(Control);
    TargetList.SetPosition;
  end;
end;

procedure TDsnSelect.SetDesigning(Value: Boolean);
begin
  inherited;
  if Value and (DsnRegister <> nil) then
    if FSelectionManager = nil then
    begin
      FSelectionManager:= TSelectionManager.Create;
      FSelectionManager.FDsnSelect:= Self;
      DsnRegister.AddNotifies(FSelectionManager);
    end;
end;

end.
