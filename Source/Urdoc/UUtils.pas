unit UUtils;

interface

uses ActiveX, ShlObj, ComCtrls, Windows, Classes, SysUtils, FileCtrl, Forms;

function GetDir(HW: Hwnd; InDir: string): string;
function GetProgramFilesDir: string;

implementation

var
  Malloc: IMalloc;
  Desktop: IShellFolder;  pidlMyComputer: PItemIDList;  pidlResult: PItemIDList;
  pidlInitialFolder: PItemIDList;
  bi: TBrowseInfo;  DisplayName: string;
  ProgramFilesDir: WideString;
  CharsDone: ULONG;  dwAttributes: DWORD;  Temp: string;

  
function BrowseCallbackProc( hWnd: HWND; uMsg: UINT; lParam: LPARAM;
  lpData: LPARAM ): Integer; stdcall; // обратите внимание на соглашение о вызовах -
                                      // stdcallbegin  Result := 0;
begin
  Result:=0;
  case uMsg of    BFFM_INITIALIZED:    begin
      PostMessage( hWnd, BFFM_SETSELECTION, 0, Integer(pidlInitialFolder) );
      PostMessage( hWnd, BFFM_SETSTATUSTEXT, 0,
        Integer(PChar('')) );
  end;
 end;
end;

function GetProgramFilesDirByKeyStr(KeyStr: string): string;
var
  dwKeySize: DWORD;
  Key: HKEY;
  dwType: DWORD;
begin
 if
    RegOpenKeyEx( HKEY_LOCAL_MACHINE, PChar(KeyStr), 0, KEY_READ, Key ) = ERROR_SUCCESS
  then  try
    RegQueryValueEx( Key, 'ProgramFilesDir', nil, @dwType, nil, @dwKeySize );
    if (dwType in [REG_SZ, REG_EXPAND_SZ]) and (dwKeySize > 0) then    begin
      SetLength( Result, dwKeySize );
      RegQueryValueEx( Key, 'ProgramFilesDir', nil, @dwType, PByte(PChar(Result)),
        @dwKeySize );    end    else    begin
      RegQueryValueEx( Key, 'ProgramFilesPath', nil, @dwType, nil, @dwKeySize );
      if (dwType in [REG_SZ, REG_EXPAND_SZ]) and (dwKeySize > 0) then      begin
        SetLength( Result, dwKeySize );
        RegQueryValueEx( Key, 'ProgramFilesPath', nil, @dwType, PByte(PChar(Result)),
          @dwKeySize );
      end;
  end;
  finally
    RegCloseKey( Key );
  end;
end;

function GetProgramFilesDir: string;

const
  DefaultProgramFilesDir = '%SystemDrive%\Program Files';

var
  FolderName: string;
  dwStrSize: DWORD;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then  begin    FolderName :=
      GetProgramFilesDirByKeyStr('Software\Microsoft\Windows NT\CurrentVersion');
  end;
  if Length(FolderName) = 0 then  begin    FolderName :=
      GetProgramFilesDirByKeyStr('Software\Microsoft\Windows\CurrentVersion');
  end;
  if Length(FolderName) = 0 then FolderName := DefaultProgramFilesDir;
  dwStrSize := ExpandEnvironmentStrings( PChar(FolderName), nil, 0 );
  SetLength( Result, dwStrSize );
  ExpandEnvironmentStrings( PChar(FolderName), PChar(Result), dwStrSize );
end;

function GetDir(HW: Hwnd; InDir: string): string;
begin
  if DirectoryExists(InDir) then begin
   ProgramFilesDir := InDir;//GetProgramFilesDir;  // acquire shell's allocator
  end else
//   ProgramFilesDir := GetProgramFilesDir;  // acquire shell's allocator
   ProgramFilesDir := 'c:\';  // acquire shell's allocator
  if SUCCEEDED( SHGetMalloc( Malloc ) ) then
  try
    // acquire shell namespace root folder
    if SUCCEEDED( SHGetDesktopFolder( Desktop ) ) then
    try
      // acquire folder that will be serve as root in dialog
      if SUCCEEDED( SHGetSpecialFolderLocation( 0, CSIDL_DRIVES, pidlMyComputer ) ) then
      try        // acquire PIDL for folder that will be selected by default
        if          SUCCEEDED(
            Desktop.ParseDisplayName( 0, nil, PWideChar(ProgramFilesDir), CharsDone,
            pidlInitialFolder, dwAttributes )          )        then
         try
          SetLength( DisplayName, MAX_PATH );
          FillChar( bi, sizeof(bi), 0 );
          bi.hwndOwner:=HW;
          bi.pidlRoot := pidlMyComputer; // roots from 'My Computer'
          bi.pszDisplayName := PChar( DisplayName );
          bi.lpszTitle := PChar('Выберите папку');
          bi.ulFlags := BIF_STATUSTEXT+BIF_RETURNONLYFSDIRS;
          bi.lpfn := BrowseCallbackProc;
          pidlResult := SHBrowseForFolder( bi );
          if Assigned(pidlResult) then begin
           try
            SetLength( Temp, MAX_PATH );
            if SHGetPathFromIDList( pidlResult, PChar(Temp) ) then begin
              DisplayName := Temp;
            end;
            DisplayName := Trim(DisplayName);
            Result:=StrPas(Pchar(DisplayName));
{            getMem(P,sizeof(DisplayName));
            try
             Result:=
            finally
              FreeMem(P,sizeof(DisplayName));
            end;
            StrCopy(Pchar(Result),Pchar(DisplayName));}
           finally
             Malloc.Free( pidlResult ); // release returned value

           end;
          end else Result:=InDir; 
         finally
          Malloc.Free( pidlInitialFolder ); // release PIDL for folder that
         end;
      finally
         Malloc.Free( pidlMyComputer ); // release folder that was served as root in dialog
      end;
    finally
      Desktop := nil; // release shell namespace root folder
    end;
  finally
    Malloc := nil; // release shell's allocator  end;
  end;
end;

end.
