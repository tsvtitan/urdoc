{*******************************************************}
{                                                       }
{       Borland Delphi Test Server                      }
{                                                       }
{  Copyright (c) 2001 Borland Software Corporation      }
{                                                       }
{  Русификация: 2001 Polaris Software                   }
{               http://polesoft.da.ru                   }
{*******************************************************}

unit SvrConst;

interface

resourcestring
  sWebAppDebugger = 'Отладчик Web-приложений';
  sStopServer = 'Стоп';
  sStartServer = 'Старт';
  sCouldNotOpenRegKey = 'Не могу открыть ключ реестра: %s';
  sUnauthorizedString = '<HTML><HEAD><TITLE>Несанкционировано</TITLE></HEAD>' +
    '<BODY><H1>Несанкционировано</H1>' +
    'Правильная авторизация требуется для этой области. ' +
    'Либо Ваш браузер не поддерживает авторизацию, ' +
    'либо Ваша авторизация - неверная.' +
    '</BODY></HTML>'#13#10;
  sForbiddenString = '<HTML><TITLE>Требуемый URL запрещен</TITLE>' + '<BODY>' + '<H1>Требуемый URL запрещен</H1>' + '<P>Код статуса HTTP: 403' + '</BODY></HTML>'#13#10;
  sNoDirBrowseString = '<HTML><TITLE>Просмотр каталогов запрещен</TITLE>' + '<BODY>' + '<H1>Требуемый URL запрещен</H1>' + '<P>Код статуса HTTP: 403' + '</BODY></HTML>'#13#10;
  sBadRequest = '<HTML><TITLE>Неверный HTTP запрос: Метод не допускается для HTTP/1.0</TITLE>' + '<BODY>' + '<H1>Неверный HTTP запрос: Метод не допускается для HTTP/1.0</H1>' + '<P>Код статуса HTTP: 400' + '</BODY></HTML>'#13#10;
  sNotFound =
    '<TITLE>Требуемый URL не найден</TITLE>' +
    '<BODY>' +
    '<H1>Требуемый URL не найден</H1>' +
    '<P>Код статуса HTTP: 404' +
    '</BODY>';
  sInternalServerError =
    '<TITLE>Внутренняя ошибка сервера</TITLE>' +
    '<BODY>' +
    '<H1>Внутренняя ошибка сервера</H1>' +
    '<P>Код статуса HTTP: 500' +
    '<P>Сообщение об ошибке HTTP: %s' +
    '</BODY>';

  SInvalidActionRegistration = 'Неверная регистрация действия (action)';
  sErrorEvent = 'ERROR';
  sResponseEvent = 'RESPONSE';
  sEvent = 'Event';
  sTime = 'Time';
  sDate = 'Date';
  sElapsed = 'Elapsed';
  sPath = 'Path';
  sCode = 'Code';
  sContentLength = 'Content Length';
  sContentType = 'Content Type';
  sThread = 'Thread';

  sNoDefaultURL = '(нет)';
  sLogTab = 'Log(%d)';

  sSend = 'Send';
  sReceive = 'Receive';
  sLogStrTemplate = '%s %s Ошибка: (%d)%s';

  UnauthorizedString = '<HTML><HEAD><TITLE>Несанкционировано</TITLE></HEAD>' +
    '<BODY><H1>Несанкционировано</H1>' +
    'Правильная авторизация требуется для этой области. ' +
    'Либо Ваш браузер не поддерживает авторизацию, ' +
    'либо Ваша авторизация - неверная.' +
    '</BODY></HTML>'#13#10;
  ForbiddenString = '<HTML><TITLE>Требуемый URL запрещен</TITLE>' + '<BODY>' + '<H1>Требуемый URL запрещен</H1>' + '<P>Код статуса HTTP: 403' + '</BODY></HTML>'#13#10;
  NoDirBrowseString = '<HTML><TITLE>Просмотр каталогов запрещен</TITLE>' + '<BODY>' + '<H1>Требуемый URL запрещен</H1>' + '<P>Код статуса HTTP: 403' + '</BODY></HTML>'#13#10;
  BadRequest = '<HTML><TITLE>Неверный HTTP запрос: Метод не допускается для HTTP/1.0</TITLE>' + '<BODY>' + '<H1>Неверный HTTP запрос: Метод не допускается для HTTP/1.0</H1>' + '<P>Код статуса HTTP: 400' + '</BODY></HTML>'#13#10;
  NotFound =
    '<TITLE>Требуемый URL не найден</TITLE>' +
    '<BODY>' +
    '<H1>Требуемый URL не найден</H1>' +
    '<P>Код статуса HTTP: 404' +
    '</BODY>';
  DateFormat = 'ddd, dd mmm yyyy hh:mm:ss';
  sBuild = 'Build';
  sDirHeader = '<HTML><HEAD><TITLE>Каталог %s</TITLE></HEAD>' +
    '<BODY><H1>Каталог %0:s</H1>'#13#10;
  sDirParent = 'Up to <A HREF="%s">%0:s</A>'#13#10'<UL>';
  sDirRoot = 'Вверх в <A HREF="%s">корневой каталог</A>'#13#10'<UL>';
  sDirEntry = '<LI>[ <A HREF="%s">%s</A> ]'#13#10;
  sFileEntry = '<LI><A HREF="%s">%s</A> (%d байт)'#13#10;
  sListStart = '<UL>'#13#10;
  sDirFooter = '</UL></BODY></HTML>'#13#10;


implementation

end.
