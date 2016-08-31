{*************************************************************}
{                                                             }
{       Borland Delphi Visual Component Library               }
{       InterBase Express core components                     }
{                                                             }
{       Copyright (c) 1998-2002 Borland Software Corporation  }
{                                                             }
{    InterBase Express is based in part on the product        }
{    Free IB Components, written by Gregory H. Deatz for      }
{    Hoagland, Longo, Moran, Dunst & Doukas Company.          }
{    Free IB Components is used under license.                }
{                                                             }
{    Additional code created by Jeff Overcash and used        }
{    with permission.                                         }
{                                                             }
{  Русификация: 1999-2002 Polaris Software                    }
{               http://polesoft.da.ru                         }
{*************************************************************}

unit IBXConst;

interface

uses IBUtils;

const
{$IFDEF VER150}
  IBX_Version = 7.05;
{$ELSE}
  {$IFDEF VER140}
  IBX_Version = 6.05;
  {$ELSE}
  IBX_Version = 5.05;
  {$ENDIF}
{$ENDIF}

resourcestring
{ generic strings used in code }
  SIBDatabaseEditor = 'Редактор &БД...';
  SIBTransactionEditor = 'Редактор &транзакций...';
  SDatabaseFilter = 'Файлы БД (*.gdb)|*.gdb|Все файлы (*.*)|*.*';
  SDisconnectDatabase = 'Есть активное соединение с базой данных. Прервать соединение и продолжить?';
  SCommitTransaction = 'Транзакция активна. Откатить ее и продолжить?';
  SExecute = '&Выполнить';
  SNoDataSet = 'Нет ссылки на набор данных (dataset)';
  SSQLGenSelect = 'Необходимо выбрать хотя бы одно ключевое и одно изменяемое поле';
  SSQLNotGenerated = 'Команды Update SQL не сгенерированы, выйти?';
  SIBUpdateSQLEditor = 'Редактор &UpdateSQL...';
  SIBDataSetEditor = '&Редактор набора данных...';
  SSQLDataSetOpen = 'Не могу определить имена полей для %s';
  SDefaultTransaction = '%s, По умолчанию';

{ strings used in error messages}
  SUnknownError = 'Неизвестная ошибка';
{$IFNDEF VER130}
 {$IFDEF MSWINDOWS}
  SInterBaseMissing = 'Библиотека InterBase gds32.dll не найдена. Пожалуйста, установите InterBase для использования этой возможности';
 {$ENDIF}
 {$IFDEF LINUX}
  SInterBaseMissing = 'Библиотека InterBase gds.so.0 не найдена. Пожалуйста, установите InterBase для использования этой возможности';
 {$ENDIF}
{$ELSE}
  SInterBaseMissing = 'Библиотека InterBase gds32.dll не найдена. Пожалуйста, установите InterBase для использования этой возможности';
{$ENDIF}
  SInterBaseInstallMissing = 'Библиотека установки InterBase ibinstall.dll не найдена. Пожалуйста, установите InterBase 6 для использования этой возможности';
  SIB60feature = '%s - это функция InterBase6. Пожалуйста, обновите до InterBase6 для использования этой возможности';
  SNotSupported = 'Неподдерживаемая возможность';
  SNotPermitted = 'Не допустимо';
  SFileAccessError = 'Ошибка доступа к временному файлу';
  SConnectionTimeout = 'Истекло время соединения к базе данных';
  SCannotSetDatabase = 'Не могу установить базу данных';
  SCannotSetTransaction = 'Не могу стартовать транзакцию';
  SOperationCancelled = 'Операция прервана по запросу пользователя';
  SDPBConstantNotSupported = 'DPB константа (isc_dpb_%s) не поддерживается';
  SDPBConstantUnknown = 'DPB константа (%d) неизвестна';
  STPBConstantNotSupported = 'TPB константа (isc_tpb_%s) не поддерживается';
  STPBConstantUnknown = 'TPB константа (%d) неизвестна';
  SDatabaseClosed = 'Не могу выполнить операцию -- БД не открыта';
  SDatabaseOpen = 'Не могу выполнить операцию -- БД открыта';
  SDatabaseNameMissing = 'Не указано имя базы данных';
  SNotInTransaction = 'Транзакция не активна';
  SInTransaction = 'Транзакция активна';
  STimeoutNegative = 'Значения задержек не могут быть отрицательными';
  SNoDatabasesInTransaction = 'Нет баз данных в списке transaction компонента';
  SUpdateWrongDB = 'Изменение неверной базы данных';
  SUpdateWrongTR = 'Изменение неверной транзакции. В наборе ожидается уникальная транзакция';
  SDatabaseNotAssigned = 'База данных не определена';
  STransactionNotAssigned = 'Транзакция не определена';
  SXSQLDAIndexOutOfRange = 'Индекс XSQLDA вышел за границы';
  SXSQLDANameDoesNotExist = 'Имя XSQLDA не найдено (%s)';
  SEOF = 'Конец файла';
  SBOF = 'Начало файла';
  SInvalidStatementHandle = 'Неверный дескриптор команды';
  SSQLOpen = 'IBSQL открыт';
  SSQLClosed = 'IBSQL закрыт';
  SDatasetOpen = 'Набор данных (Dataset) открыт';
  SDatasetClosed = 'Набор данных (Dataset) закрыт';
  SUnknownSQLDataType = 'Неверный тип данных SQL (%d)';
  SInvalidColumnIndex = 'Неверный индекс колонки (индекс превысил разрешенный диапазон)';
  SInvalidParamColumnIndex = 'Неверный индекс параметра (индекс превысил разрешенный диапазон)';
  SInvalidDataConversion = 'Неверное преобразование данных';
  SColumnIsNotNullable = 'Колонка не может быть установлена в NULL (%s)';
  SBlobCannotBeRead = 'Не могу прочитать из Blob stream';
  SBlobCannotBeWritten = 'Не могу записать в Blob stream';
  SEmptyQuery = 'Пустой запрос';
  SCannotOpenNonSQLSelect = 'Не могу выполнить Open для не SELECT команды. Используйте ExecQuery';
  SNoFieldAccess = 'Нет доступа к полю "%s"';
  SFieldReadOnly = 'Поле "%s" только для чтения';
  SFieldNotFound = 'Поле "%s" не найдено';
  SNotEditing = 'Не редактирование';
  SCannotInsert = 'Не могу добавить запись в набор данных (dataset). (Нет insert запроса)';
  SCannotPost = 'Не могу сохранить (post). (Нет update/insert запроса)';
  SCannotUpdate = 'Не могу изменить (update). (Нет update запроса)';
  SCannotDelete = 'Не могу удалить из набора данных (dataset). (Нет delete запроса)';
  SCannotRefresh = 'Не могу обновить запись. (Нет refresh запроса)';
  SBufferNotSet = 'Буфер не установлен';
  SCircularReference = 'Циклические ссылки не разрешены';
  SSQLParseError = 'Ошибка синтаксического разбора SQL:' + CRLF + CRLF + '%s';
  SUserAbort = 'Прервано пользователем';
  SDataSetUniDirectional = 'Однонаправленный набор данных (Data set)';
  SCannotCreateSharedResource = 'Не могу создать разделенный ресурс. (Ошибка Windows %d)';
  SWindowsAPIError = 'Ошибка Windows API. (Ошибка Windows %d [$%.8x])';
  SColumnListsDontMatch = 'Списки колонок не совпадают';
  SColumnTypesDontMatch = 'Типы колонок не совпадают. (С индекса %d до %d)';
  SCantEndSharedTransaction = 'Не могу завершить общую (shared) транзакцию кроме случаев, когда она принудительно завершена and equal ' +
                             'TimeoutAction транзакции';
  SFieldUnsupportedType = 'Неподдерживаемый тип поля';
  SCircularDataLink = 'Циклическая DataLink ссылка';
  SEmptySQLStatement = 'Пустая SQL команда';
  SIsASelectStatement = 'используйте Open для Select команды';
  SRequiredParamNotSet = 'Требуемое значение Param не установлено';
  SNoStoredProcName = 'Не определено имя хранимой процедуры';
  SIsAExecuteProcedure = 'используйте ExecProc для процедур; используйте TQuery для Select процедур';
  SUpdateFailed = 'Ошибка при изменении (Update)';
  SNotCachedUpdates = 'CachedUpdates не разрешены';
  SNotLiveRequest = 'Запрос открыт не для изменений (not live) - не могу изменять';
  SNoProvider = 'Нет провайдера';
  SNoRecordsAffected = 'Ни одной записи не обработано';
  SNoTableName = 'Не определено имя таблицы';
  SCannotCreatePrimaryIndex = 'Не могу создать Primary индекс; создан автоматически';
  SCannotDropSystemIndex = 'Не могу удалить System индекс';
  STableNameMismatch = 'Не совпадает имя таблицы';
  SIndexFieldMissing = 'Не указано индексное поле';
  SInvalidCancellation = 'Не могу отменить события во время обработки';
  SInvalidEvent = 'Неверное событие';
  SMaximumEvents = 'Достигнут максимальный предел для событий';
  SNoEventsRegistered = 'Нет зарегистрированных событий';
  SInvalidQueueing = 'Неверная организация очередей';
  SInvalidRegistration = 'Неверная регистрация';
  SInvalidBatchMove = 'Неверное пакетное перемещение (batch move)';
  SSQLDialectInvalid = 'Неверный диалект SQL';
  SSPBConstantNotSupported = 'SPB константа не поддерживается';
  SSPBConstantUnknown = 'SPB константа неизвестна';
  SServiceActive = 'Не могу выполнить операцию -- служба не подключена';
  SServiceInActive = 'Не могу выполнить операцию -- служба подключена';
  SServerNameMissing = 'Имя сервера не указано';
  SQueryParamsError = 'Параметры запроса не указаны или неверные';
  SStartParamsError = 'Start параметры не указаны или неверные';
  SOutputParsingError = 'Неожидаемые значения буфера вывода';
  SUseSpecificProcedures = 'Generic ServiceStart не применим: используйте Specific Procedures для установки параметров конфигурации';
  SSQLMonitorAlreadyPresent = 'SQL Monitor уже запущен';
  SCantPrintValue = 'Не могу напечатать значение';
  SEOFReached = 'SEOFReached';
  SEOFInComment = 'Обнаружен EOF в комментарии';
  SEOFInString = 'Обнаружен EOF в строке';
  SParamNameExpected = 'Имя параметра ожидается';
  SSuccess = 'Успешное выполнение';
  SDelphiException = 'DelphiException %s';
  SNoOptionsSet = 'Не выбраны Install Options';
  SNoDestinationDirectory = 'DestinationDirectory не установлена';
  SNosourceDirectory = 'SourceDirectory не установлена';
  SNoUninstallFile = 'Uninstall File Name не установлено';
  SOptionNeedsClient = 'Компоненту %s требуется Клиент для правильной работы';
  SOptionNeedsServer = 'Компоненту %s требуется Сервер для правильной работы';
  SInvalidOption = 'Определена неверная опция';
  SInvalidOnErrorResult = 'onError возвратил неожиданное значение';
  SInvalidOnStatusResult = 'onStatus возвратил неожиданное значение';

  SInterbaseExpressVersion = 'InterbaseExpress 4.3';
  SEditSQL = 'Изменить SQL';
  SDPBConstantUnknownEx = 'DPB константа (%s) не известна';
  STPBConstantUnknownEx = 'TPB константа (%s) не известна';
  SInterbaseExpressVersionEx = 'InterbaseExpress %g';
  SUnknownPlan = 'Неизвестная ошибка - Не могу получить план';
  SFieldSizeMismatch = 'Несовпадение размера - длина поля %s слишком мала для данных';
  SEventAlreadyRegistered   = 'События уже зарегистрированы';
  SStringTooLarge = 'Попытка сохранить строку длиной %d в поле, которое может содержать только %d';
  SIBServiceEditor = '&Редактор сервиса ...';
  SIBSuccessConnect = 'Успешное соединение';
  SNoTimers = 'Нет доступных таймеров';
  SIB65feature = '%s - функция InterBase 6.5. Пожалуйста, обновите InterBase до версии 6.5 для использования этой возможности';
  SLoginPromptFailure = 'Не могу найти диалог ввода имени и пароля по умолчанию.  Пожалуйста, добавьте DBLogDlg в секцию uses Вашего основного файла.';
  SIBMemoryError = 'Недостаточно памяти';
  SIBInvalidStatement = 'Неверная команда';
  SIBInvalidComment = 'Неверный комментарий';
  SIBBrokerOpen = '  Открытие соединения ';
  SIBBrokerVersion = 'Запуск IBConnectionBroker Версия 1.0.1:';
  SIBBrokerDatabase = 'Имя базы данных = ';
  SIBBrokerUser = 'Имя пользователя = ';
  SIBBrokerMinConnections = 'Min соединений = ';
  SIBBrokerMaxConnections = 'Max соединений = ';
  SIBBrokerIdleTimer = 'IdleTimer = ';
  SIBBrokerGiveOut = 'gave out connection ';
  SIBBrokerUnavailable = 'Не могу создать новое соединение: ';
  SIBBrokerExhausted = '-----> Соединения исчерпаны!  Будут выполнены в цикле ожидание и повтор ';
  SIBBrokerNilError = 'Попытка освобождения пустой (nil) базы данных';
  SIBBrokerRelease = 'Закрытие соединения ';
  SIBDatabaseINISection = 'Настройки базы данных';
  SIBDatabaseINISectionEmpty = 'Имя секции не может быть пустым';
  SIB70feature = '%s - это функция InterBase 7.0. Пожалуйста, обновите до InterBase 7.0 для использования этой возможности';

implementation

end.
 