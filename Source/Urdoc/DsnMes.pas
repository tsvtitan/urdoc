unit DsnMes;

interface

uses
  Messages;

const
  DsnSysConst = 570;
  MY_CONTROLLIST  =   WM_USER + DsnSysConst;
  MY_DELCOMPONENT =   WM_USER + DsnSysConst + 1;
  MY_RECTFOCUS =      WM_USER + DsnSysConst + 2;
  RM_START =          WM_USER + DsnSysConst + 3;
  RM_FINISH =         WM_USER + DsnSysConst + 4;
  MH_SELECT =         WM_USER + DsnSysConst + 5;
  AG_DESTROY =        WM_USER + DsnSysConst + 6;
  CI_SELECT =         WM_USER + DsnSysConst + 7;
  CI_SETPROPERTY =    WM_USER + DsnSysConst + 8;
  FA_KILLCOMPONENT =  WM_USER + DsnSysConst + 9;
  DR_CREATED =        WM_USER + DsnSysConst +10;
  DS_LOADED =        WM_USER + DsnSysConst +11;
  Mini_Rubberband = 8;
  Dsn_ClipboardFormat = 'Dsn_ClipboardFormat';
const
  SizeRectMultiSelect=5;
  SizeRectSelect=5;  

implementation

end.
