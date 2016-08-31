{ *************************************************************************** }
{                                                                             }
{ Kylix and Delphi Cross-Platform Visual Component Library                    }
{                                                                             }
{ Copyright (c) 1997, 2001 Borland Software Corporation                       }
{                                                                             }
{  Русификация: 1998-2002 Polaris Software                                    }
{               http://polesoft.da.ru                                         }
{ *************************************************************************** }

unit MidConst;

interface

{$IFNDEF VER120} // Delphi 5 и выше
{$IFNDEF VER125}
  {$DEFINE D5_}
{$ENDIF}
{$ENDIF}

{$IFDEF VER140}
  {$DEFINE D6_}
{$ENDIF}
{$IFDEF VER150}
  {$DEFINE D6_}
{$ENDIF}

{$IFDEF D5_}
const
{ Do not localize }
  MIDAS_CatDesc = 'Borland MIDAS Application Servers';
  CATID_MIDASAppServer: TGUID = '{13E85B3C-9508-11D2-AB63-00C04FA35CFA}';
  {$IFDEF D6_}
  MIDASInterceptor_CatDesc = 'Borland DataSnap Application Servers';
  CATID_MIDASInterceptor: TGUID = '{6BFD12F2-7004-11D4-BE3C-0001023E6E0F}';
  {$ENDIF}
  SCatImplBaseKey = 'CLSID\%s\Implemented Categories';
  SCatImplKey = SCatImplBaseKey + '\%s';
  MIDAS_DLL = 'MIDAS.DLL';
  SClsid = 'CLSID\';
  SPooled = 'Pooled';
  SMaxObjects = 'MaxObjects';
  STimeout = 'Timeout';
  SSingleton = 'Singleton';
  SSockets = 'Sockets';
  SWeb = 'Web';
  SFlagOn = '1';
  SFlagOff = '0';
 {$IFDEF D6_}
  MINDATAPACKETSIZE = 8;
  {$IFNDEF VER140}
{$IFDEF LINUX}
  SMidasLib = 'libmidas.so.1';
{$ENDIF}
{$IFDEF MSWINDOWS}
  SMidasLib = 'midas.dll';
{$ENDIF}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

resourcestring
  { App Server }
{$IFDEF D5_}
  SProviderNotExported = 'Провайдер не экспортирован: %s';
{$ENDIF}

  { DBClient }
  SNoDataProvider = 'Потерян провайдер данных или пакет данных';
  SInvalidDataPacket = 'Неверный пакет данных';
  SRefreshError = 'Необходимо применить изменения перед обновлением данных';
  SProviderInvalid = 'Неверный провайдер. Провайдер был освобожден сервером приложений';
  SServerNameBlank = 'Не могу соединиться, %s должен содержать правильное ServerName или ServerGUID';
  SRepositoryIdBlank = 'Не могу соединиться, %s должен содержать правильное repository id';
  SAggsGroupingLevel = 'Уровень группировки превысил текущее количество полей индекса';
  SAggsNoSuchLevel = 'Уровень группировки не определен';
  SNoCircularReference = 'Циклические ссылки провайдеров не разрешаются';
{$IFDEF D5_}
  SErrorLoadingMidas = 'Ошибка загрузки MIDAS.DLL';
  SCannotCreateDataSet = 'Поля не определены.  Не могу создать набор данных (dataset)';
 {$IFDEF VER140}
  SFieldNameTooLarge = 'Fieldname %s превысило %d символов';
 {$ENDIF}
 {$IFDEF D6_}
  SInvalidClone = 'Неверное CloneConnection: различные потомки ClientDataSet';
 {$ENDIF}
 {$IFNDEF VER140}
  SCDSDlgOpenCaption = 'Открыть таблицу MyBase';
  SNoConnectToBroker = 'Соединение с TConnectionBroker не допустимо';
 {$ENDIF}
{$ENDIF}

  { MConnect }
  SSocketReadError = 'Ошибка чтения из socket';
  SInvalidProviderName = 'Имя провайдера "%s" не распознано сервером';
  SBadVariantType = 'Неподдерживаемый вариантный тип: %s';
  SInvalidAction = 'Запрошено неверное действие (action): %d';
{$IFDEF D6_}
  SNoParentConnection = 'ParentConnection не присвоено';
  SBlankChildName = 'ChildName не может быть пустым';
{$ENDIF}

  { Resolver }
  SInvalidResponse = 'Неверный ответ';
{$IFNDEF D5_}
  SRecordChanged = 'Запись изменена другим пользователем';
{$ENDIF}
  SRecordNotFound = 'Запись не найдена';
  STooManyRecordsModified = 'Изменение (Update) затрагивает более 1 записи.';

  { Provider }
  SInvalidOptParamType = 'Значение не может быть сохранено в необязательный параметр';
  SMissingDataSet = 'Потеряно свойство DataSet';
  SConstraintFailed = 'Условие на запись или поле (constraint) не выполнилось.';
  SField = 'Field';
  SReadOnlyProvider = 'Не могу применить изменения для ReadOnly провайдера';
  SNoKeySpecified = 'Не могу найти запись.  Не определен ключ';
  SFieldNameTooLong = 'Имя поля не может быть длиннее чем %d символов.  Попытайтесь ' +
                      'установить ObjectView в True в dataset';
  SNoDataSets = 'Не могу определить набор данных, когда используются вложенные наборы данных или ссылки';
  SRecConstFail = 'Подготовка record constraint не выполнилась с ошибкой "%s"';
  SFieldConstFail = 'Подготовка field constraint не выполнилась с ошибкой "%s"';
  SDefExprFail = 'Подготовка default expression не выполнилась с ошибкой "%s"';
  SArrayElementError = 'Массив элементов типа %s не поддерживается'; 
  SNoTableName = 'Не могу определить записи.  Имя таблицы не найдено.';
{$IFDEF D5_}
  SNoEditsAllowed = 'Изменения не допустимы';
  SNoDeletesAllowed = 'Удаления не допустимы';
  SNoInsertsAllowed = 'Добавления (inserts) не допустимы';
  SCannotChangeCommandText = 'Изменения CommandText не допустимы';
 {$IFDEF D6_}
  SAggregatesActive = 'Операция не допустима с активными aggregates';
 {$ENDIF}
{$ENDIF}

  { ObjectBroker }
  SNoServers = 'Нет доступного сервера';

{$IFDEF D6_}
  { ConnectionBroker }

  SConnectionMissing = 'Требуется Connection перед открытием';
  SNoCircularConnection = 'Циклические ссылки на Connection не допустимы';
{$ENDIF}

  { Socket Connection }
  SReturnError = 'Ожидаемое возвращаемое значение не получено';
  SNoWinSock2 = 'Должен быть установлен WinSock 2 для использования socket соединения';

{$IFDEF D5_}
  { Web Connection }
  SURLRequired = 'Требуется URL';
  SDefaultURL = 'http://server.company.com/scripts/httpsrvr.dll';
  SInvalidURL = 'URL должен быть в форме "http://server.company.com/scripts/httpsrvr.dll"';
  SServerIsBusy = 'Сервер занят';

  SObjectNotAvailable = 'Объект не доступен: %s';
 {$IFDEF D6_}

  { SuperComponents }
  SMasterNotOpen = 'Не могу открыть detail таблицу, если master закрыта';
 {$ENDIF}
{$ENDIF}

implementation

end.
