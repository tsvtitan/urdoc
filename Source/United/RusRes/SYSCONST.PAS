{ *********************************************************************** }
{                                                                         }
{ Delphi / Kylix Cross-Platform Runtime Library                           }
{                                                                         }
{ Copyright (c) 1995, 2001 Borland Software Corporation                   }
{                                                                         }
{  Русификация: 1999-2002 Polaris Software                                }
{               http://polesoft.da.ru                                     }
{ *********************************************************************** }

unit SysConst;

interface

{$IFDEF VER140}
  {$DEFINE D6_}
{$ENDIF}
{$IFDEF VER150}
  {$DEFINE D6_}
{$ENDIF}

resourcestring
{$IFNDEF VER120}
{$IFNDEF VER125}
  SUnknown = '<неизвестен>';
{$ENDIF}
{$ENDIF}
  SInvalidInteger = '''%s'' - неверное целое значение';
  SInvalidFloat = '''%s'' - неверное дробное значение';
{$IFDEF D6_}
  SInvalidCurrency = '''%s'' - неверное денежное значение';
{$ENDIF}
  SInvalidDate = '''%s'' - неверная дата';
  SInvalidTime = '''%s'' - неверное время';
  SInvalidDateTime = '''%s'' - неверная дата и время';
{$IFDEF D6_}
  SInvalidDateTimeFloat = '''%g'' - неверная дата и время';
  SInvalidTimeStamp = '''%d.%d'' - неверная дата и время (timestamp)';
  SInvalidGUID = '''%s'' - неверное значение GUID';
  SInvalidBoolean = '''%s'' - неверное логическое значение';
{$ENDIF}
  STimeEncodeError = 'Неверный аргумент для формирования времени';
  SDateEncodeError = 'Неверный аргумент для формирования даты';
  SOutOfMemory = 'Не хватает памяти';
  SInOutError = 'Ошибка ввода/вывода %d';
  SFileNotFound = 'Файл не найден';
  SInvalidFilename = 'Неверное имя файла';
  STooManyOpenFiles = 'Слишком много открытых файлов';
  SAccessDenied = 'В доступе к файлу отказано';
  SEndOfFile = 'Чтение за окончанием файла';
  SDiskFull = 'Диск полон';
  SInvalidInput = 'Неверный ввод числа';
  SDivByZero = 'Деление на ноль';
  SRangeError = 'Ошибка выхода за границы (Range check)';
  SIntOverflow = 'Переполнение целого';
  SInvalidOp = 'Неверная операция с дробными числами';
  SZeroDivide = 'Нецелочисленное деление на ноль';
  SOverflow = 'Нецелочисленное переполнение';
  SUnderflow = 'Нецелочисленная потеря (underflow)';
  SInvalidPointer = 'Неверная операция с указателем';
  SInvalidCast = 'Неверное приведение класса';
{$IFDEF D6_}
 {$IFDEF MSWINDOWS}
  {$IFDEF VER140}
  SAccessViolation = 'Нарушение доступа по адресу %p. %s по адресу %p';
  {$ELSE}
  SAccessViolationArg3 = 'Нарушение доступа по адресу %p. %s по адресу %p';
  {$ENDIF}
 {$ENDIF}
 {$IFDEF LINUX}
  {$IFDEF VER140}
  SAccessViolation = 'Нарушение доступа по адресу %p, обращение к адресу %p';
  {$ELSE}
  SAccessViolationArg2 = 'Нарушение доступа по адресу %p, обращение к адресу %p';
  {$ENDIF}
 {$ENDIF}
  {$IFNDEF VER140}
  SAccessViolationNoArg = 'Нарушение доступа';
  {$ENDIF}
{$ELSE}
  SAccessViolation = 'Нарушение доступа по адресу %p. %s по адресу %p';
{$ENDIF}
  SStackOverflow = 'Переполнение стека';
  SControlC = 'Нажатие Control-C';
{$IFDEF D6_}
  SQuit = 'Нажатие кнопки Выход';
{$ENDIF}
  SPrivilege = 'Привилегированная инструкция';
  SOperationAborted = 'Операция прервана';
{$IFDEF D6_}
  SException = 'Исключительная ситуация %s в модуле %s по адресу %p.' + sLineBreak + '%s%s' + sLineBreak;
{$ELSE}
  SException = 'Исключительная ситуация %s в модуле %s по адресу %p.'#$0A'%s%s';
{$ENDIF}
  SExceptTitle = 'Ошибка приложения';
{$IFDEF LINUX}
  SSigactionFailed = 'sigaction call failed';
{$ENDIF}
  SInvalidFormat = 'Формат ''%s'' неверен или несовместим с аргументом';
  SArgumentMissing = 'Нет аргумента для формата ''%s''';
  SInvalidVarCast = 'Неверное преобразование вариантного типа';
  SInvalidVarOp = 'Неверная операция с вариантом';
  SDispatchError = 'Вызовы вариантных методов не поддерживаются';
  SReadAccess = 'Чтение';
  SWriteAccess = 'Запись';
  SResultTooLong = 'Результат форматирования длиннее, чем 4096 символов';
  SFormatTooLong = 'Строка формата слишком длинная';

{$IFDEF VER150}
  SVarArrayCreate = 'Ошибка создания вариантного или safe массива';
{$ELSE}
  SVarArrayCreate = 'Ошибка создания вариантного массива';
{$ENDIF}
{$IFNDEF D6_}
  SVarNotArray = 'Вариант не является массивом';
{$ENDIF}
{$IFDEF VER150}
  SVarArrayBounds = 'Индекс вариантного или safe массива вышел за границы';
{$ELSE}
  SVarArrayBounds = 'Индекс вариантного массива вышел за границы';
{$ENDIF}
{$IFDEF D6_}
  {$IFDEF VER150}
  SVarArrayLocked = 'Вариантный или safe массив заблокирован';
  SVarArrayWithHResult = 'Неожиданная ошибка вариантного или safe массива: %s%.8x';
  {$ELSE}
  SVarArrayLocked = 'Вариантный массив заблокирован';
  {$ENDIF}
  SInvalidVarOpWithHResult = 'Неверная операция с вариантом ($%.8x)' {$IFDEF VER150}deprecated{$ENDIF};

  // the following are not used anymore
  SVarNotArray = 'Вариант не является массивом' deprecated; // not used, use SVarInvalid
  {$IFDEF VER140}
  SVarTypeUnknown = 'Неизвестный произвольный вариантный тип (%.4x)' deprecated; // not used anymore

  SVarTypeOutOfRange = 'Произвольный вариантный тип (%.4x) вышел за границы';
  SVarTypeAlreadyUsed = 'Произвольный вариантный тип (%.4x) уже используется %s';
  SVarTypeNotUsable = 'Произвольный вариантный тип (%.4x) является непригодным';
  {$ELSE}
  SVarTypeUnknown = 'Неизвестный произвольный вариантный тип ($%.4x)' deprecated; // not used anymore
  SVarTypeOutOfRange = 'Произвольный вариантный тип ($%.4x) вышел за границы' deprecated;
  SVarTypeAlreadyUsed = 'Произвольный вариантный тип ($%.4x) уже используется %s' deprecated;
  SVarTypeNotUsable = 'Произвольный вариантный тип ($%.4x) является непригодным' deprecated;

  SInvalidVarNullOp = 'Неверная операция с NULL';
  SInvalidVarOpWithHResultWithPrefix = 'Неверная операция с вариантом (%s%.8x)'#10'%s';
  SVarTypeRangeCheck1 = 'Ошибка выхода за границы (range check) для варианта типа (%s)';
  SVarTypeRangeCheck2 = 'Ошибка выхода за границы (range check) при конвертировании варианта типа (%s) в тип (%s)';
  SVarTypeOutOfRangeWithPrefix = 'Произвольный вариантный тип (%s%.4x) вышел за границы';
  SVarTypeAlreadyUsedWithPrefix = 'Произвольный вариантный тип (%s%.4x) уже используется %s';
  SVarTypeNotUsableWithPrefix = 'Произвольный вариантный тип (%s%.4x) является непригодным';
  {$ENDIF}
  SVarTypeTooManyCustom = 'Зарегистрировано cлишком много произвольных вариантных типов';

  SVarTypeCouldNotConvert = 'Не могу преобразовать вариант типа (%s) в тип (%s)';
  SVarTypeConvertOverflow = 'Переполнение при преобразовании варианта типа (%s) в тип (%s)';
  SVarOverflow = 'Переполнение варианта';
  SVarInvalid = 'Неверный аргумент';
  SVarBadType = 'Неверный тип варианта';
  SVarNotImplemented = 'Операция не поддерживается';
  SVarOutOfMemory = 'Операции с вариантом не хватило памяти';
  SVarUnexpected = 'Неожиданная ошибка варианта';

  SVarDataClearRecursing = 'Рекурсия во время выполнения VarDataClear';
  SVarDataCopyRecursing = 'Рекурсия во время выполнения VarDataCopy';
  SVarDataCopyNoIndRecursing = 'Рекурсия во время выполнения VarDataCopyNoInd';
  SVarDataInitRecursing = 'Рекурсия во время выполнения VarDataInit';
  SVarDataCastToRecursing = 'Рекурсия во время выполнения VarDataCastTo';
  SVarIsEmpty = 'Вариант - пустой';
  sUnknownFromType = 'Не могу преобразовать из указанного типа';
  sUnknownToType = 'Не могу преобразовать в указанный тип';
{$ENDIF}
  SExternalException = 'Внешняя исключительная ситуация %x';
  SAssertionFailed = 'Assertion failed';
  SIntfCastError = 'Интерфейс не поддерживается';
{$IFNDEF VER120}
{$IFNDEF VER125}
  SSafecallException = 'Исключительная ситуация в safecall методе';
{$ENDIF}
{$ENDIF}
  SAssertError = '%s (%s, строка %d)';
  SAbstractError = 'Абстрактная ошибка';
  SModuleAccessViolation = 'Нарушение доступа по адресу %p в модуле ''%s''. %s по адресу %p';
  SCannotReadPackageInfo = 'Не могу получить информацию пакета для пакета ''%s''';
  sErrorLoadingPackage = 'Не могу загрузить пакет %s.'#13#10'%s';
  SInvalidPackageFile = 'Неверный файл пакета ''%s''';
  SInvalidPackageHandle = 'Неверный дескриптор пакета';
  SDuplicatePackageUnit = 'Не могу загрузить пакет ''%s''.  Он включает модуль ''%s''' +
    ', который также содержится в пакете ''%s''';
{$IFDEF D6_}
  SOSError = 'Системная ошибка.  Код: %d.'+sLineBreak+'%s';
  SUnkOSError = 'Ошибка при вызове функции ОС';
 {$IFDEF MSWINDOWS}
  SWin32Error = 'Ошибка Win32.  Код: %d.'#10'%s' deprecated; // use SOSError
  SUnkWin32Error = 'Ошибка функции Win32 API' deprecated; // use SUnkOSError
 {$ENDIF}
{$ELSE}
  SWin32Error = 'Ошибка Win32.  Код: %d.'#10'%s';
  SUnkWin32Error = 'Ошибка функции Win32 API';
{$ENDIF}
  SNL = 'Приложение не имеет лицензии на использование этой возможности';

{$IFDEF VER140}
  SConvIncompatibleTypes2 = 'Несовместимые типы преобразования [%s, %s]';
  SConvIncompatibleTypes3 = 'Несовместимые типы преобразования [%s, %s, %s]';
  SConvIncompatibleTypes4 = 'Несовместимые типы преобразования [%s - %s, %s - %s]';
  SConvUnknownType = 'Неизвестный тип преобразования %s';
  SConvDuplicateType = 'Тип преобразования (%s) уже зарегистрирован';
  SConvUnknownFamily = 'Неизвестное семейство преобразования %s';
  SConvDuplicateFamily = 'Семейство преобразования (%s) уже зарегистрировано';
  SConvUnknownDescription = '[%.8x]';
  SConvIllegalType = 'Недопустимый тип';
  SConvIllegalFamily = 'Недопустимое семейство';
  SConvFactorZero = '%s имеет нулевой множитель';
{$ENDIF}

  SShortMonthNameJan = 'Янв';
  SShortMonthNameFeb = 'Фев';
  SShortMonthNameMar = 'Мар';
  SShortMonthNameApr = 'Апр';
  SShortMonthNameMay = 'Май';
  SShortMonthNameJun = 'Июн';
  SShortMonthNameJul = 'Июл';
  SShortMonthNameAug = 'Авг';
  SShortMonthNameSep = 'Сен';
  SShortMonthNameOct = 'Окт';
  SShortMonthNameNov = 'Ноя';
  SShortMonthNameDec = 'Дек';

  SLongMonthNameJan = 'Январь';
  SLongMonthNameFeb = 'Февраль';
  SLongMonthNameMar = 'Март';
  SLongMonthNameApr = 'Апрель';
  SLongMonthNameMay = 'Май';
  SLongMonthNameJun = 'Июнь';
  SLongMonthNameJul = 'Июль';
  SLongMonthNameAug = 'Август';
  SLongMonthNameSep = 'Сентябрь';
  SLongMonthNameOct = 'Октябрь';
  SLongMonthNameNov = 'Ноябрь';
  SLongMonthNameDec = 'Декабрь';

  SShortDayNameSun = 'Вск';
  SShortDayNameMon = 'Пон';
  SShortDayNameTue = 'Втр';
  SShortDayNameWed = 'Срд';
  SShortDayNameThu = 'Чет';
  SShortDayNameFri = 'Пят';
  SShortDayNameSat = 'Суб';

  SLongDayNameSun = 'Воскресенье';
  SLongDayNameMon = 'Понедельник';
  SLongDayNameTue = 'Вторник';
  SLongDayNameWed = 'Среда';
  SLongDayNameThu = 'Четверг';
  SLongDayNameFri = 'Пятница';
  SLongDayNameSat = 'Суббота';

{$IFDEF D6_}
 {$IFDEF LINUX}
  SEraEntries = '';
 {$ENDIF}

  SCannotCreateDir = 'Невозможно создать каталог';
  {$IFDEF VER150}
  SCodesetConversionError = 'Ошибка преобразования codeset';
  {$ENDIF}
{$ENDIF}

implementation

end.
