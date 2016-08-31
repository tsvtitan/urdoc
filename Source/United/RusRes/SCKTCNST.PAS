{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{       Copyright (c) 1997,99 Inprise Corporation       }
{                                                       }
{  Русификация: 1999-2001 Polaris Software              }
{               http://polesoft.da.ru                   }
{*******************************************************}

unit ScktCnst;

interface

const
  //Do not localize
  KEY_SOCKETSERVER  = '\SOFTWARE\Borland\Socket Server';
{$IFNDEF VER120}
{$IFNDEF VER125}
  KEY_IE            = 'SOFTWARE\Microsoft\Internet Explorer';
{$ENDIF}
{$ENDIF}
  csSettings        = 'Settings';
  ckPort            = 'Port';
  ckThreadCacheSize = 'ThreadCacheSize';
  ckInterceptGUID   = 'InterceptGUID';
  ckShowHost        = 'ShowHost';
  ckTimeout         = 'Timeout';
{$IFNDEF VER120}
{$IFNDEF VER125}
  ckRegistered      = 'RegisteredOnly';
  SServiceName      = 'SocketServer';
  SApplicationName  = 'Borland Socket Server';
{$ENDIF}
{$ENDIF}

resourcestring
  SServiceOnly = 'Socket Server может работать только как служба на NT 3.51 или ранее';
  SErrClose = 'Не могу выйти, когда есть активные соединения. Прервать соединения?';
  SErrChangeSettings = 'Не могу изменить установки, когда есть активные соединения. Прервать соединения?';
  SQueryDisconnect = 'Отсоединение клиентов может вызвать ошибки приложений. Продолжить?';
  SOpenError = 'Ошибка открытия порта %d с ошибкой: %s';
  SHostUnknown = '(Неизвестен)';
{$IFNDEF VER120}
{$IFNDEF VER125}
  SNotShown = '(Невидим)';
{$ENDIF}
{$ENDIF}
  SNoWinSock2 = 'Должен быть установлен WinSock 2 для использования socket соединения';
{$IFNDEF VER120}
{$IFNDEF VER125}
  SStatusline = '%d текущих соединений';
  SAlreadyRunning = 'Socket Server уже работает';
  SNotUntilRestart = 'Это изменение не вступит в силу пока Socket Server не будет перезагружен';
{$ENDIF}
{$ENDIF}

implementation

end.
 