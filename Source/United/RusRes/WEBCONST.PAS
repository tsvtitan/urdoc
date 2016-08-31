{ *************************************************************************** }
{                                                                             }
{ Kylix and Delphi Cross-Platform Visual Component Library                    }
{ Internet Application Runtime                                                }
{                                                                             }
{ Copyright (C) 1997, 2001 Borland Software Corporation                       }
{                                                                             }
{ Licensees holding a valid Borland No-Nonsense License for this Software may }
{ use this file in accordance with such license, which appears in the file    }
{ license.txt that came with this Software.                                   }
{                                                                             }
{  Русификация: 1999-2002 Polaris Software                                    }
{               http://polesoft.da.ru                                         }
{ *************************************************************************** }

unit WebConst;

interface

{$IFDEF VER130}
  {$DEFINE D5_}
{$ENDIF}
{$IFDEF VER140}
  {$DEFINE D5_}
  {$DEFINE D6_}
{$ENDIF}
{$IFDEF VER150}
  {$DEFINE D5_}
  {$DEFINE D6_}
{$ENDIF}

resourcestring
{$IFDEF D6_}
  {$IFNDEF VER140}
  sErrorDecodingURLText = 'Ошибка расшифровки стиля URL (%%XX), закодированного строкой, в позиции %d';
  {$ELSE}
  sErrorDecodingURLText = 'Ошибка расшифровки стиля URL (%XX), закодированного строкой, в позиции %d';
  {$ENDIF}
  sInvalidURLEncodedChar = 'Неверный закодированный символ URL (%s) в позиции %d';
  sInvalidHTMLEncodedChar = 'Неверный закодированный символ HTML (%s) в позиции %d';
{$ENDIF}
  sInvalidActionRegistration = 'Неверная регистрация Action';
{$IFNDEF D5_}
  sOnlyOneDataModuleAllowed = 'Допустим только один модуль данных на приложение';
  sNoDataModulesRegistered = 'Не зарегистрировано ни одного модуля данных';
  sNoDispatcherComponent = 'Не найдено ни одного компонента-диспетчера в модуле данных';
  sOnlyOneDispatcher = 'Только один WebDispatcher на формы/модуля данных';
{$ENDIF}
  sDuplicateActionName = 'Дубликат имени action';
{$IFDEF D6_}
  sFactoryAlreadyRegistered = 'Web Module Factory уже зарегистрирована';
  sAppFactoryAlreadyRegistered = 'Web App Module Factory уже зарегистрирована.';
{$ENDIF}
{$IFDEF D5_}
  sOnlyOneDispatcher = 'Только один WebDispatcher на формы/модуля данных';
{$ELSE}
  sTooManyActiveConnections = 'Достигнут максимум конкурирующих соединений.  ' +
    'Повторите попытку позже';
{$ENDIF}
  sHTTPItemName = 'Name';
  sHTTPItemURI = 'PathInfo';
  sHTTPItemEnabled = 'Enabled';
  sHTTPItemDefault = 'Default';
{$IFDEF D5_}
  sHTTPItemProducer = 'Producer';
{$ENDIF}

{$IFNDEF D5_}
  sInternalServerError = '<html><title>Внутренняя Ошибка Сервера 500</title>'#13#10 +
    '<h1>Внутренняя Ошибка Сервера 500</h1><hr>'#13#10 +
    'Исключительная ситуация: %s<br>'#13#10 +
    'Сообщение: %s<br></html>'#13#10;
{$ENDIF}
{$IFDEF VER120}
  sDocumentMoved = '<html><title>Документ перемещен 302</title>'#13#10 +
    '<body><h1>Объект перемещен</h1><hr>'#13#10 +
    'Этот объект может быть найден <a HREF="%s">здесь.</a><br>'#13#10 +
    '<br></body></html>'#13#10;
{$ENDIF}
{$IFDEF VER100}
  sWindowsSocketError = 'Ошибка Windows socket: %s (%d), в API ''%s''';
  sNoAddress = 'Не указан адрес';
  sCannotCreateSocket = 'Не могу создать новый socket';
  sCannotListenOnOpen = 'Не могу слушать открытый socket';
  sSocketAlreadyOpen = 'Socket уже открыт';
  sCantChangeWhileActive = 'Не могу изменить значение, пока socket активный';
  sMustCreateThread = 'Поток должен создаваться в режиме Thread blocking';
  sSocketMustBeBlocking = 'Socket должен быть в blocking mode';
  sSocketIOError = '%s ошибка %d, %s';
  sSocketRead = 'Чтения';
  sSocketWrite = 'Записи';
  sAsyncSocketError = 'Ошибка асинхронного socket %d';
{$ENDIF}

  sResNotFound = 'Ресурс %s не найден';

  sTooManyColumns = 'Слишком много столбцов в таблице';
  sFieldNameColumn = 'Field Name';
  sFieldTypeColumn = 'Field Type';

{$IFNDEF D5_}
  sInvalidMask = '''%s'' - неверная маска (%d)';
{$ENDIF}

{$IFDEF D6_}
  sInvalidWebComponentsRegistration =  'Неверная регистрация Web компонента';
  sInvalidWebComponentsEnumeration =  'Неверная нумерация Web компонента';
  sInvalidWebParent = 'Операция не поддерживается.  Компонент %s не поддерживает IGetWebComponentList'; 
                                                      
  sVariableIsNotAContainer = 'Переменная %s - не контейнер';
  {$IFNDEF VER140}
  sInternalApplicationError = '<html><body><h1>Внутренняя ошибка приложения</h1>' + sLineBreak +
                              '<p>%0:s' + sLineBreak +
                              '<p><hr width="100%%"><i>%1:s</i></body></html>';
  {$ELSE}
  sInternalApplicationError = '<h1>Внутренняя ошибка приложения</h1>'#13#10 +
                              '<p>%0:s'#13#10 +
                              '<p><hr width="100%%"><i>%1:s</i>';
  {$ENDIF}
  sInvalidParent = 'Неверный родитель';

  sActionDoesNotProvideResponse = 'Action не обеспечивает ответ';
  sActionCantRespondToUnkownHTTPMethod = 'Action не может ответить неизвестному HTTP методу';
  sActionCantRedirectToBlankURL = 'Action не может нереадресовать на пустой URL';
{$ENDIF}

implementation

end.

