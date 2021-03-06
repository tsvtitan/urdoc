
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Device Detection Part                   }
{           version 5.6 for Delphi 3,4,5                }
{                                                       }
{       Copyright � 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Devices;

interface

uses
  SysUtils, Windows, Classes;

type
  TDeviceClass = (dcBattery, dcComputer, dcDiskDrive, dcDisplay, dcCDROM, dcfdc,
                  dcFloppyDisk, dcGPS, dcHIDClass, dchdc, dc1394, dcImage, dcInfrared,
                  dcKeyboard, dcMediumChanger, dcMTD, dcMouse, dcModem, dcMonitor,
                  dcMultiFunction, dcPortSerial, dcNet, dcLegacyDriver,
                  dcNtApm, dcUnknown, dcPCMCIA, dcPorts, dcPrinter, dcSCSIAdapter,
                  dcSmartCardReader, dcMEDIA, dcVolume, dcSystem, dcTapeDrive, dcUSB);

  PDevice = ^TDevice;

  TDevice = record
    ClassName,
    ClassDesc,
    ClassIcon,
    FriendlyName,
    Description,
    GUID,
    Manufacturer,
    Location,
    HardwareID,
    DriverDate,
    DriverVersion,
    DriverProvider,
    Service,
    ServiceName,
    ServiceGroup: string;
    ServiceType: integer;
    RegKey: string;
    DeviceClass :TDeviceClass;
  end;

  TDeviceList = TStringList;

  TDevices = class(TPersistent)
  private
    FCount: integer;
    FDeviceList: TDeviceList;
    function GetDevice(Index: integer): TDevice;
    function GetDeviceCount: integer;
    procedure ScanDevices(var ADeviceList: TDeviceList);
    function GetDeviceClass(AClassName: string): TDeviceClass;

    procedure ClearList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);
    procedure GetDevicesByClass(ADeviceClass: TDeviceClass; var ADevices: TStrings);
    property Devices[Index: integer]: TDevice read GetDevice;
  published
    property DeviceCount: integer read FCount write FCount;
  end;

implementation

uses Registry, MiTeC_Routines;

const
  DeviceClass :array[dcBattery..dcUSB] of string =
                 ('Battery', 'Computer', 'DiskDrive', 'Display', 'CDROM', 'fdc',
                  'FloppyDisk', 'GPS', 'HID', 'hdc', '1394', 'Image', 'Infrared',
                  'Keyboard', 'MediumChanger', 'MTD', 'Mouse', 'Modem', 'Monitor',
                  'MultiFunction', 'MultiPortSerial', 'Net', 'LegacyDriver',
                  'NtApm', 'Unknown', 'PCMCIA', 'Ports', 'Printer', 'SCSIAdapter',
                  'SmartCardReader', 'MEDIA', 'Volume', 'System', 'TapeDrive', 'USB');

{ TDevices }

constructor TDevices.Create;
begin
  FDeviceList:=TDeviceList.Create;
end;

destructor TDevices.Destroy;
begin
  ClearList;
  FDeviceList.Free;
  inherited;
end;

procedure TDevices.GetDevicesByClass;
var
  i,c: integer;
  s: string;
begin
  ADevices.Clear;
  c:=DeviceCount-1;
  for i:=0 to c do
    if Devices[i].DeviceClass=ADeviceClass then begin
      if Trim(Devices[i].FriendlyName)='' then
        s:=Devices[i].Description
      else
        s:=Devices[i].FriendlyName;
      ADevices.Add(s);
    end;
end;

function TDevices.GetDevice(Index: integer): TDevice;
begin
  try
    Result:=PDevice(FDeviceList.Objects[Index])^;
  except
  end;
end;

function TDevices.GetDeviceClass(AClassName: string): TDeviceClass;
var
  i: TDeviceClass;
begin
  Result:=dcUnknown;
  AClassName:=UpperCase(AClassName);
  for i:=dcBattery to dcUSB do
    if Pos(UpperCase(DeviceClass[i]),AClassName)=1 then begin
      Result:=i;
      Break;
    end;
end;

function TDevices.GetDeviceCount: integer;
begin
  Result:=FDeviceList.Count;
end;

procedure TDevices.GetInfo;
begin
  try
    ScanDevices(FDeviceList);
    FDeviceList.Sort;
    FCount:=GetDeviceCount;
  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TDevices.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TDevices.Report(var sl: TStringList);
var
  i,c: integer;
  s: string;
begin
  c:=DeviceCount;
  with sl do begin
    Add('[Devices]');
    Add(Format('Count=%d',[c]));
    for i:=0 to c-1 do begin
      if Trim(Devices[i].FriendlyName)='' then
        s:=Devices[i].Description
      else
        s:=Devices[i].FriendlyName;
      Add(Format('[%s]',[s]));
      Add(Format('Class Name=%s',[Devices[i].ClassDesc]));
      Add(Format('Class GUID=%s',[Devices[i].GUID]));
      Add(Format('Manufacturer=%s',[Devices[i].Manufacturer]));
      Add(Format('Location=%s',[Devices[i].Location]));
      Add(Format('Hardware ID=%s',[Devices[i].HardwareID]));
      Add(Format('Driver Date=%s',[Devices[i].DriverDate]));
      Add(Format('Driver Version=%s',[Devices[i].DriverVersion]));
      Add(Format('Driver Provider=%s',[Devices[i].DriverProvider]));
      Add(Format('Service Name=%s',[Devices[i].ServiceName]));
      Add(Format('Service Group=%s',[Devices[i].ServiceGroup]));
    end;
  end;
end;

procedure TDevices.ScanDevices(var ADeviceList: TDeviceList);

procedure GetDeviceClass(AGUID :string; var AClassName, AClassDesc, AClassIcon: string);
var
  i :integer;
  sl :TStringList;
  rkClass, vLink: string;
const
  rvClass = 'Class';
  rvIcon = 'Icon';
  rvLink = 'Link';

  rkClassNT = {HKEY_LOCAL_MACHINE\}'SYSTEM\CurrentControlSet\Control\Class';
  rkClass9x = {HKEY_LOCAL_MACHINE\}'SYSTEM\CurrentControlSet\Services\Class';
begin
  if IsNT then
    rkClass:=rkClassNT
  else
    rkClass:=rkClass9x;
  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    {$IFDEF D4PLUS}
    if OpenKeyReadOnly(rkClass) then begin
    {$ELSE}
    if OpenKey(rkClass,False) then begin
    {$ENDIF}
      sl:=TStringList.Create;
      GetKeyNames(sl);
      CloseKey;
      i:=sl.IndexOf(AGUID);
      if i>-1 then
        {$IFDEF D4PLUS}
        if OpenKeyReadOnly(rkClass+'\'+sl[i]) then begin
        {$ELSE}
        if OpenKey(rkClass+'\'+sl[i],False) then begin
        {$ENDIF}
          AClassName:=ReadString(rvClass);
          if not IsNT then begin
            vLink:=ReadString(rvLink);
            CloseKey;
            {$IFDEF D4PLUS}
            if not OpenKeyReadOnly(rkClass+'\'+vLink) then
            {$ELSE}
            if not OpenKey(rkClass+'\'+vLink,False) then
            {$ENDIF}
              Exit;
          end;
          AClassIcon:=ReadString(rvIcon);
          AClassDesc:=ReadString('');
          CloseKey;
        end;
      sl.Free;
    end;
    free;
  end;
end;

procedure GetDeviceDriver(AGUID :string; var ADate, AVersion, AProvider: string);
var
  rkClass: string;
const
  rvDate = 'DriverDate';
  rvVersion = 'DriverVersion';
  rvProvider = 'ProviderName';

  rkClassNT = {HKEY_LOCAL_MACHINE\}'SYSTEM\CurrentControlSet\Control\Class';
  rkClass9x = {HKEY_LOCAL_MACHINE\}'SYSTEM\CurrentControlSet\Services\Class';
begin
  if IsNT then
    rkClass:=rkClassNT
  else
    rkClass:=rkClass9x;
  AGUID:=ReplaceStr(AGUID,'\\','\');  
  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    {$IFDEF D4PLUS}
    if OpenKeyReadOnly(rkClass+'\'+AGUID) then begin
    {$ELSE}
    if OpenKey(rkClass+'\'+AGUID,False) then begin
    {$ENDIF}
      ADate:=ReadString(rvDate);
      AVersion:=ReadString(rvVersion);
      AProvider:=ReadString(rvProvider);
      CloseKey;
    end;
    free;
  end;
end;

procedure GetDeviceService(AGUID :string; var AName, AGroup: string; var AType: integer);
const
  rvName = 'DisplayName';
  rvGroup = 'Group';
  rvType = 'Type';

  rkClass = {HKEY_LOCAL_MACHINE\}'SYSTEM\CurrentControlSet\Services';
begin
  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    {$IFDEF D4PLUS}
    if OpenKeyReadOnly(rkClass+'\'+AGUID) then begin
    {$ELSE}
    if OpenKey(rkClass+'\'+AGUID,False) then begin
    {$ENDIF}
      AGroup:=ReadString(rvGroup);
      try
        AName:=ReadString(rvName);
        AGroup:=ReadString(rvGroup);
        AType:=ReadInteger(rvType);
      except
        AName:='';
      end;
      CloseKey;
    end;
    free;
  end;
end;

var
  i,j,k :integer;
  sl1,sl2,sl3 :TStringList;
  dr: PDevice;
  rkEnum: string;
  Data: PChar;
const
  rvClass = 'Class';
  rvGUID = 'ClassGUID';
  rvDesc = 'DeviceDesc';
  rvFriend = 'FriendlyName';
  rvMfg = 'Mfg';
  rvService = 'Service';
  rvLoc = 'LocationInformation';
  rvDriver = 'Driver';
  rvHID = 'HardwareID';

  rkEnumNT = {HKEY_LOCAL_MACHINE\}'SYSTEM\CurrentControlSet\Enum';
  rkEnum9x = {HKEY_LOCAL_MACHINE\}'Enum';

  rkControl = 'Control';

begin
  ClearList;
  if IsNT then
    rkEnum:=rkEnumNT
  else
    rkEnum:=rkEnum9x;
  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    {$IFDEF D4PLUS}
    if OpenKeyReadOnly(rkEnum) then begin
    {$ELSE}
    if OpenKey(rkEnum,False) then begin
    {$ENDIF}
      sl1:=TStringList.Create;
      sl2:=TStringList.Create;
      sl3:=TStringList.Create;
      Data:=StrAlloc(255);
      GetKeyNames(sl1);
      CloseKey;
      for i:=0 to sl1.Count-1 do
        if (IsNT or (not IsNT and (sl1[i]<>'Network'))) and
          {$IFDEF D4PLUS}
          OpenKeyReadOnly(rkEnum+'\'+sl1[i]) then begin
          {$ELSE}
          OpenKey(rkEnum+'\'+sl1[i],False) then begin
          {$ENDIF}
          GetKeyNames(sl2);
          CloseKey;
          for j:=0 to sl2.count-1 do
            {$IFDEF D4PLUS}
            if OpenKeyReadOnly(rkEnum+'\'+sl1[i]+'\'+sl2[j]) then begin
            {$ELSE}
            if OpenKey(rkEnum+'\'+sl1[i]+'\'+sl2[j],False) then begin
            {$ENDIF}
              GetKeyNames(sl3);
              CloseKey;
              for k:=0 to sl3.count-1 do
                {$IFDEF D4PLUS}
                if OpenKeyReadOnly(rkEnum+'\'+sl1[i]+'\'+sl2[j]+'\'+sl3[k]) then begin
                {$ELSE}
                if OpenKey(rkEnum+'\'+sl1[i]+'\'+sl2[j]+'\'+sl3[k],False) then begin
                {$ENDIF}
                  if not IsNT or (IsNT and KeyExists(rkControl)) then begin
                    new(dr);
                    with dr^ do begin
                      GUID:=UpperCase(ReadString(rvGUID));
                      FriendlyName:=ReadString(rvFriend);
                      Description:=ReadString(rvDesc);
                      Manufacturer:=ReadString(rvMfg);
                      Service:=ReadString(rvService);
                      Location:=ReadString(rvLoc);
                      if Location='' then
                        GetDeviceService(sl1[i],Location,ServiceGroup,ServiceType);
                      GetDeviceClass(GUID,Classname,ClassDesc,ClassIcon);
                      if ClassName='' then
                        ClassName:=ReadString(rvClass);
                      GetDeviceDriver(ReadString(rvDriver),DriverDate,DriverVersion,DriverProvider);
                      GetDeviceService(Service,ServiceName,ServiceGroup,ServiceType);
                      RegKey:=rkEnum+'\'+sl1[i]+'\'+sl2[j]+'\'+sl3[k];
                      try
                        if ValueExists(rvHID) then begin
                          ReadBinaryData(rvHID,Data^,255);
                          HardWareID:=GetStrFromBuf(Data);
                        end else
                          HardwareID:='';
                      except
                        try
                          HardwareID:=ReadString(rvHID);
                        except
                        end;
                      end;
                    end;
                    if Trim(dr.ClassName)<>'' then begin
                      dr.DeviceClass:=Self.GetDeviceClass(dr.ClassName);
                      ADeviceList.AddObject(dr.Classname,TObject(dr));
                    end else
                      Dispose(dr);
                  end;
                  CloseKey;
                end;
            end;
        end;
      sl1.free;
      sl2.Free;
      sl3.Free;
      StrDispose(Data);
    end;
    free;
  end;
end;

procedure TDevices.ClearList;
var
  dr: PDevice;
begin
  while FDeviceList.count>0 do begin
   dr:=PDevice(FDeviceList.Objects[FDeviceList.count-1]);
   Dispose(dr);
   FDeviceList.Delete(FDeviceList.count-1);
  end;
end;


end.
