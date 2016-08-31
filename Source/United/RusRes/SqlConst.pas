{ *************************************************************************** }
{                                                                             }
{ Kylix and Delphi Cross-Platform Visual Component Library                    }
{                                                                             }
{ Copyright (c) 1997, 2001 Borland Software Corporation                       }
{                                                                             }
{  Русификация: 2001-02 Polaris Software                                      }
{               http://polesoft.da.ru                                         }
{ *************************************************************************** }


unit SqlConst;

interface

const
  DRIVERS_KEY = 'Installed Drivers';            { Do not localize }
  CONNECTIONS_KEY = 'Installed Connections';    { Do not localize }
  DRIVERNAME_KEY = 'DriverName';                { Do not localize }
  HOSTNAME_KEY = 'HostName';                    { Do not localize }
  ROLENAME_KEY = 'RoleName';                    { Do not localize }
  DATABASENAME_KEY = 'Database';                { Do not localize }
  MAXBLOBSIZE_KEY = 'BlobSize';                 { Do not localize }          
  VENDORLIB_KEY = 'VendorLib';                  { Do not localize }
  DLLLIB_KEY = 'LibraryName';                   { Do not localize }
  GETDRIVERFUNC_KEY = 'GetDriverFunc';          { Do not localize }
  AUTOCOMMIT_KEY = 'AutoCommit';                { Do not localize }
  BLOCKINGMODE_KEY = 'BlockingMode';            { Do not localize }
  WAITONLOCKS_KEY= 'WaitOnLocks';               { Do not localize }
  COMMITRETAIN_KEY = 'CommitRetain';            { Do not localize }
  TRANSISOLATION_KEY = '%s TransIsolation';     { Do not localize }
  SQLDIALECT_KEY = 'SqlDialect';                { Do not localize }
  SQLLOCALE_CODE_KEY = 'LocaleCode';            { Do not localize }
  ERROR_RESOURCE_KEY = 'ErrorResourceFile';     { Do not localize }
  SQLSERVER_CHARSET_KEY = 'ServerCharSet';      { Do not localize }
  SREADCOMMITTED = 'readcommited';              { Do not localize }
  SREPEATREAD = 'repeatableread';               { Do not localize }
  SDIRTYREAD = 'dirtyread';                     { Do not localize }
  SDRIVERREG_SETTING = 'Driver Registry File';           { Do not localize }
  SCONNECTIONREG_SETTING = 'Connection Registry File';   { Do not localize }
  szUSERNAME         = 'USER_NAME';             { Do not localize }
  szPASSWORD         = 'PASSWORD';              { Do not localize }
  SLocaleCode        = 'LCID';                  { Do not localize }
  ROWSETSIZE_KEY     = 'RowsetSize';            { Do not localize }
{$IFNDEF VER140}
  OSAUTHENTICATION   = 'OS Authentication';     { Do not localize }
  SERVERPORT         = 'Server Port';           { Do not localize }
  MULTITRANSENABLED  = 'Multiple Transaction';  { Do not localize }
  TRIMCHAR           = 'Trim Char';             { Do not localize }
  CUSTOM_INFO        = 'Custom String';         { Do not localize }
  CONN_TIMEOUT       = 'Connection Timeout';    { Do not localize }
{$ELSE}
  OSAUTHENTICATION   = 'Os Authentication';     { Do not localize }
{$ENDIF}
{$IFDEF MSWINDOWS}
  SDriverConfigFile = 'dbxdrivers.ini';            { Do not localize }
  SConnectionConfigFile = 'dbxconnections.ini';    { Do not localize }
  SDBEXPRESSREG_SETTING = '\Software\Borland\DBExpress'; { Do not localize }
{$ENDIF}
{$IFDEF LINUX}
  SDBEXPRESSREG_USERPATH = '/.borland/';          { Do not localize }
  SDBEXPRESSREG_GLOBALPATH = '/usr/local/etc/';   { Do not localize }
  SDriverConfigFile = 'dbxdrivers';                  { Do not localize }
  SConnectionConfigFile = 'dbxconnections';          { Do not localize }
  SConfExtension = '.conf';                       { Do not localize }
{$ENDIF}

resourcestring
  SLoginError = 'Не могу присоединиться к базе данных ''%s''';
  SMonitorActive = 'Не могу изменить соединение в Active Monitor';
  SMissingConnection = 'Отсутствует свойство SQLConnection';
  SDatabaseOpen = 'Не могу выполнить эту операцию при открытом соединении';
  SDatabaseClosed = 'Не могу выполнить эту операцию при закрытом соединении';
  SMissingSQLConnection = 'Свойство SQLConnection требуется для этой операции';
  SConnectionNameMissing = 'Отсутствует имя соединения';
  SEmptySQLStatement = 'Нет доступных SQL команд';
  SNoParameterValue = 'Нет значения для параметра ''%s''';
  SNoParameterType = 'Нет типа для параметра ''%s''';
  SParameterTypes = ';Input;Output;Input/Output;Result';
  SDataTypes = ';String;SmallInt;Integer;Word;Boolean;Float;Currency;BCD;Date;Time;DateTime;;;;Blob;Memo;Graphic;;;;;Cursor;';
  SResultName = 'Result';
  SNoTableName = 'Отсутствует свойство TableName';
  SNoSqlStatement = 'Отсутствует запрос, имя таблицы или имя процедуры';
  SNoDataSetField = 'Отсутствует свойство DataSetField';
  SNoCachedUpdates = 'Не в режиме cached update';
  SMissingDataBaseName = 'Отсутствует свойство Database';
  SMissingDataSet = 'Отсутствует свойство DataSet';
  SMissingDriverName = 'Отсутствует свойство DriverName';
  SPrepareError = 'Не могу выполнить Запрос';
  SObjectNameError = 'Таблица/процедура не найдена';
  SSQLDataSetOpen = 'Не могу определить имена полей для %s';
  SNoActiveTrans = 'Нет активной транзакции';
  SActiveTrans = 'Транзакция уже активна';
  SDllLoadError = 'Не могу загрузить %s';
  SDllProcLoadError = 'Не могу найти процедуру %s';
  SConnectionEditor = '&Изменить свойства соединения';
  SCommandTextEditor = '&Изменить CommandText';
  SMissingDLLName = 'Имя DLL/Shared Library не установлено';
  SMissingDriverRegFile = 'Файл регитсрации драйвера/соединения ''%s'' не найден';
  STableNameNotFound = 'Не могу найти TableName в CommandText';
  SNoCursor = 'Курсор не возвращен из Запроса';
  SMetaDataOpenError = 'Не могу открыть Metadata';
  SErrorMappingError = 'Ошибка SQL: Error mapping failed';
  SStoredProcsNotSupported = 'Хранимые процедуры не поддерживаются ''%s'' Server';
  SPackagesNotSupported = 'Пакеты не поддерживаются ''%s'' сервером';
  SDBXUNKNOWNERROR = 'Ошибка DBX: No Mapping for Error Code Found';
  SDBXNOCONNECTION = 'Ошибка DBX: Соединение не найдено, сообщение об ошибке не может быть получено';
  SDBXNOMETAOBJECT = 'Ошибка DBX: MetadataObject не найден, сообщение об ошибке не может быть получено';
  SDBXNOCOMMAND = 'Ошибка DBX: Соединение не найдено, сообщение об ошибке не может быть получено';
  SDBXNOCURSOR = 'Ошибка DBX: Соединение не найдено, сообщение об ошибке не может быть получено';
{$IFNDEF VER140}
  SNOMEMORY = 'Ошибка dbExpress: Не хватает памяти для операции';
  SINVALIDFLDTYPE = 'Ошибка dbExpress: Неверное тип поля';
  SINVALIDHNDL = 'Ошибка dbExpress: Неверный дескриптор';
  SINVALIDTIME = 'Ошибка dbExpress: Неверное время';
  SNOTSUPPORTED = 'Ошибка dbExpress: Операция не поддерживается';
  SINVALIDXLATION = 'Ошибка dbExpress: Неверное преобразование данных';
  SINVALIDPARAM = 'Ошибка dbExpress: Неверный параметр';
  SOUTOFRANGE = 'Ошибка dbExpress: Параметр/колонка вышла за границы';
  SSQLPARAMNOTSET = 'Ошибка dbExpress: Параметр не установлен';
  SEOF = 'Ошибка dbExpress: Результат находится в EOF';
  SINVALIDUSRPASS = 'Ошибка dbExpress: Неверное имя/пароль';
  SINVALIDPRECISION = 'Ошибка dbExpress: Неверная точность';
  SINVALIDLEN = 'Ошибка dbExpress Error: Неверная длина';
  SINVALIDXISOLEVEL = 'Ошибка dbExpress: Неверный Уровень Изоляции Транзакций';
  SINVALIDTXNID = 'Ошибка dbExpress: Неверный ID транзакции';
  SDUPLICATETXNID = 'Ошибка dbExpress: Дубликат ID транзакции';
  SDRIVERRESTRICTED = 'Ошибка dbExpress: Приложение не лицензировано для использование этой возможности';
  SLOCALTRANSACTIVE = 'Ошибка dbExpress: Локальная транзакция уже активна';
  SMULTIPLETRANSNOTENABLED = 'Ошибка dbExpress: Несколько транзакций не доступно';
{$ELSE}
  SNOMEMORY = 'Ошибка DBX: Не хватает памяти для операции';
  SINVALIDFLDTYPE = 'Ошибка DBX: Неверное тип поля';
  SINVALIDHNDL = 'Ошибка DBX: Неверный дескриптор';
  SINVALIDTIME = 'Ошибка DBX: Неверное время';
  SNOTSUPPORTED = 'Ошибка DBX: Операция не поддерживается';
  SINVALIDXLATION = 'Ошибка DBX: Неверное преобразование';
  SINVALIDPARAM = 'Ошибка DBX: Неверный параметр';
  SOUTOFRANGE = 'Ошибка DBX: Аргумент вышел за границы';
  SSQLPARAMNOTSET = 'Ошибка DBX: Параметр не установлен';
  SEOF = 'Ошибка DBX: Результат находится в EOF';
  SINVALIDUSRPASS = 'Ошибка DBX: Неверное имя/пароль';
  SINVALIDPRECISION = 'Ошибка DBX: Неверная точность';
  SINVALIDLEN = 'Ошибка DBX: Неверная длина';
  SINVALIDXISOLEVEL = 'Ошибка DBX: Неверный Уровень Изоляции Транзакций';
  SINVALIDTXNID = 'Ошибка DBX: Неверный ID транзакции';
  SDUPLICATETXNID = 'Ошибка DBX: Дубликат ID транзакции';
  SDRIVERRESTRICTED = 'dbExpress: Приложение не лицензировано для использование этой возможности';
  SLOCALTRANSACTIVE = 'Ошибка DBX: Локальная транзакция уже активна';
{$ENDIF}
  SMultiConnNotSupported = 'Многочисленные соединения не поддерживаются драйвером %s';
  SConfFileMoveError = 'Не могу переместить %s в %s';
  SMissingConfFile = 'Файл конфигурации %s не найден';
  SObjectViewNotTrue = 'ObjectView должен быть True для таблиц с Object полями';
  SDriverNotInConfigFile = 'Драйвер (%s) не найден в конфиг. файле (%s)';
  SObjectTypenameRequired = 'Имя типа Object требуется как значение параметра';
  SCannotCreateFile = 'Не могу создать файл %s';
// used in SqlReg.pas
{$IFNDEF VER140}
  SDlgOpenCaption = 'Открыть файл протокола трассировки';
{$ENDIF}
  SDlgFilterTxt = 'Текстовые файлы (*.txt)|*.txt|Все файлы (*.*)|*.*';
  SLogFileFilter = 'Файлы протокола (*.log)';
{$IFNDEF VER140}
  SCircularProvider = 'Циклические ссылки провайдеров не допускаются.';
{$ENDIF}

const

{$IFNDEF VER140}
  DbxError : array[0..19] of String = ( '', SNOMEMORY, SINVALIDFLDTYPE,
{$ELSE}
  DbxError : array[0..18] of String = ( '', SNOMEMORY, SINVALIDFLDTYPE,
{$ENDIF}
                SINVALIDHNDL, SINVALIDTIME,
                SNOTSUPPORTED, SINVALIDXLATION, SINVALIDPARAM, SOUTOFRANGE,
                SSQLPARAMNOTSET, SEOF, SINVALIDUSRPASS, SINVALIDPRECISION,
                SINVALIDLEN, SINVALIDXISOLEVEL, SINVALIDTXNID, SDUPLICATETXNID,
{$IFNDEF VER140}
                SDRIVERRESTRICTED, SLOCALTRANSACTIVE, SMULTIPLETRANSNOTENABLED );
{$ELSE}
                SDRIVERRESTRICTED, SLOCALTRANSACTIVE );
{$ENDIF}

implementation

end.
