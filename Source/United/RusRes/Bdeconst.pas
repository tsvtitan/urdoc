{********************************************************}
{                                                        }
{       Borland Delphi Visual Component Library          }
{                                                        }
{       Copyright (c) 1995,99 Inprise Corporation        }
{                                                        }
{  Русификация: 1998-2002 Polaris Software               }
{               http://polesoft.da.ru                    }
{********************************************************}

unit BdeConst;

interface

{$IFDEF VER130}
  {$DEFINE D5_}
{$ENDIF}
{$IFDEF VER140}
  {$DEFINE D5_}
{$ENDIF}
{$IFDEF VER150}
  {$DEFINE D5_}
{$ENDIF}

resourcestring
{$IFNDEF VER100}
  SAutoSessionExclusive = 'Не могу включить свойство AutoSessionName при более чем одной сессии в форме или модуле данных';
  SAutoSessionExists = 'Не могу добавить сессию в форму или модуль данных, когда для сессии ''%s'' включено AutoSessionName';
  SAutoSessionActive = 'Не могу изменить SessionName, пока AutoSessionName включено';
{$ENDIF}
  SDuplicateDatabaseName = 'Дубликат имени базы данных ''%s''';
  SDuplicateSessionName = 'Дубликат имени сессии ''%s''';
  SInvalidSessionName = 'Неверное имя сессии %s';
  SDatabaseNameMissing = 'Отсутствует имя базы данных';
  SSessionNameMissing = 'Отсутствует имя сессии';
  SDatabaseOpen = 'Не могу выполнить эту операцию для открытой базы данных';
  SDatabaseClosed = 'Не могу выполнить эту операцию для закрытой базы данных';
  SDatabaseHandleSet = 'Дескриптором базы данных владеет другая сессия';
  SSessionActive = 'Не могу выполнить эту операцию для активной сессии';
  SHandleError = 'Ошибка создания курсора';
  SInvalidFloatField = 'Не могу преобразовать поле ''%s'' в дробное значение';
  SInvalidIntegerField = 'Не могу преобразовать поле ''%s'' в целое значение';
  STableMismatch = 'Таблицы-источник и приемник несовместимы';
  SFieldAssignError = 'Поля ''%s'' и ''%s'' не совместимы для присваивания';
  SNoReferenceTableName = 'ReferenceTableName не определено для ''%s''';
{$IFDEF VER100}
  SFieldUndefinedType = 'Тип поля ''%s'' неизвестен';
  SFieldUnsupportedType = 'Тип поля ''%s'' не поддерживается';
{$ENDIF}
  SCompositeIndexError = 'Не могу использовать массив значений полей с индексами-выражениями';
  SInvalidBatchMove = 'Неверные параметры пакетного перемещения (batch move)';
  SEmptySQLStatement = 'Нет доступных SQL команд';
  SNoParameterValue = 'Нет значения параметра ''%s''';
  SNoParameterType = 'Не задан тип параметра ''%s''';
{$IFDEF VER100}
  SParameterNotFound = 'Параметр ''%s'' не найден';
  SParamTooBig = 'Параметр ''%s'', не могу сохранить данные более чем %d байт';
{$ENDIF}
  SLoginError = 'Не могу подключиться к базе данных ''%s''';
  SInitError = 'Ошибка инициализации Borland Database Engine (ошибка $%.4x)';
{$IFNDEF D5_}
  SDatasetDesigner = '&Редактор полей...';
  SFKInternalCalc = '&InternalCalc';
{$ENDIF}
{$IFDEF VER120}
  SFKAggregate = '&Aggregate';
{$ENDIF}
  SDatabaseEditor = 'Редактор &БД...';
  SExplore = 'E&xplore';
{$IFNDEF D5_}
  SLinkDesigner = 'Поле ''%s'' из списка Detail Fields должно быть связано';
{$ENDIF}
  SLinkDetail = 'Таблица ''%s'' не может быть открыта';
  SLinkMasterSource = 'Свойство MasterSource ''%s'' должно быть связано с DataSource';
  SLinkMaster = 'Невозможно открыть таблицу из MasterSource';
{$IFDEF VER100}
  SSQLDatasetDesigner = 'Редактор &полей...';
  SQBEVerb = 'Построитель &запросов...';
{$ELSE}
  SGQEVerb = 'Построитель &запросов...';
{$ENDIF}
  SBindVerb = '&Определить параметры...';
  SIDAPILangID = '0019';
  SDisconnectDatabase = 'База данных сейчас подсоединена. Отсоединиться и продолжить?';
  SBDEError = 'Ошибка BDE $%.4x';
  SLookupSourceError = 'Невозможно использовать дублированные DataSource и LookupSource';
  SLookupTableError = 'LookupSource должен соединяться с компонентом TTable';
  SLookupIndexError = '%s должно быть lookup table''s активным индексом';
  SParameterTypes = ';Input;Output;Input/Output;Result';
  SInvalidParamFieldType = 'Необходимо выбрать правильный тип поля';
  STruncationError = 'Параметр ''%s'' усечен при выводе';
{$IFDEF VER100}
  SInvalidVersion = 'Невозможно загрузить параметры привязки';
{$ENDIF}
  SDataTypes = ';String;SmallInt;Integer;Word;Boolean;Float;Currency;BCD;Date;Time;DateTime;;;;Blob;Memo;Graphic;;;;;Cursor;';
  SResultName = 'Result';
  SDBCaption = '%s%s%s База данных';
  SParamEditor = '%s%s%s Параметры';
{$IFNDEF D5_}
  SDatasetEditor = '%s%s%s';
{$ENDIF}
  SIndexFilesEditor = '%s%s%s Индексные файлы';
  SNoIndexFiles = '(Нет)';
  SIndexDoesNotExist = 'Индекс не существует. Индекс: %s';
  SNoTableName = 'Отсутствует свойство TableName';
{$IFNDEF VER100}
  SNoDataSetField = 'Отсутствует свойство DataSetField';
{$ENDIF}
  SBatchExecute = 'В&ыполнить';
  SNoCachedUpdates = 'Не в режиме cached update';
  SInvalidAliasName = 'Неверное имя псевдонима (alias) %s';
{$IFNDEF D5_}
  SDBGridColEditor = '&Редактор столбцов...';
{$ENDIF}
  SNoFieldAccess = 'Не могу получить доступ к полю ''%s'' в фильтре';
  SUpdateSQLEditor = '&Редактор UpdateSQL...';
{$IFNDEF VER100}
  SNoDataSet = 'Нет ассоциации с набором данных (dataset)';
{$ENDIF}
  SUntitled = 'Программа без заголовка';
  SUpdateWrongDB = 'Не могу изменить, %s не имеет владельца %s';
  SUpdateFailed = 'Изменение (update) не выполнено';
  SSQLGenSelect = 'Нужно выбрать хотя бы одно ключевое поле и одно изменяемое поле';
  SSQLNotGenerated = 'Команда Update SQL не сгенерирована, выйти?';
  SSQLDataSetOpen = 'Невозможно определить имена полей для %s';
  SLocalTransDirty = 'Уровень изоляции транзакции должен быть dirty read для локальных БД';
{$IFNDEF D5_}
  SPrimary = 'Primary';
{$ENDIF}
  SMissingDataSet = 'Отсутствует свойство DataSet';
  SNoProvider = 'Нет доступных провайдеров';
{$IFNDEF VER100}
  SNotAQuery = 'Набор данных (Dataset) не является запросом';
{$ENDIF}

implementation

end.
