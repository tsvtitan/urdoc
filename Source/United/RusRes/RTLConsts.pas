{ *************************************************************************** }
{                                                                             }
{ Delphi and Kylix Cross-Platform Visual Component Library                    }
{                                                                             }
{ Copyright (c) 1995, 2001 Borland Software Corporation                       }
{                                                                             }
{  Русификация: 2001-02 Polaris Software                                      }
{               http://polesoft.da.ru                                         }
{ *************************************************************************** }

unit RTLConsts;

interface

resourcestring
  SAncestorNotFound = 'Предок для ''%s'' не найден';
  SAssignError = 'Не могу значение %s присвоить %s';
  SBitsIndexError = 'Индекс Bits вышел за границы';
  SBucketListLocked = 'Список заблокирован при активном ForEach';
  SCantWriteResourceStreamError = 'Не могу записывать в поток ресурсов "только для чтения"';
  SCharExpected = 'Ожидается ''''%s''''';
  SCheckSynchronizeError = 'CheckSynchronize вызван из потока (thread) $%x, который НЕ является основным потоком';
  SClassNotFound = 'Класс %s не найден';
  SDelimiterQuoteCharError = 'Свойства Delimiter и QuoteChar не могут иметь одно и то же значение';
  SDuplicateClass = 'Класс с именем %s уже существует';
  SDuplicateItem = 'Список не допускает дубликатов ($0%x)';
  SDuplicateName = 'Компонент с именем %s уже существует';
  SDuplicateString = 'Список строк не допускает дубликатов';
  SFCreateError = 'Не могу создать файл %s';
{$IFNDEF VER140}
  SFCreateErrorEx = 'Не могу создать файл "%s". %s';
{$ENDIF}
  SFixedColTooBig = 'Число фиксированных столбцов должно быть меньше общего числа столбцов';
  SFixedRowTooBig = 'Число фиксированных строк должно быть меньше общего числа строк';
  SFOpenError = 'Не могу открыть файл %s';
{$IFNDEF VER140}
  SFOpenErrorEx = 'Не могу открыть файл "%s". %s';
{$ENDIF}
  SGridTooLarge = 'Таблица (Grid) слишком большая для работы';
  SIdentifierExpected = 'Ожидается идентификатор';
  SIndexOutOfRange = 'Индекс Grid вышел за границы';
  SIniFileWriteError = 'Не могу записать в %s';
  SInvalidActionCreation = 'Неверное создание действия (action)';
  SInvalidActionEnumeration = 'Неверный перечень действий (action)';
  SInvalidActionRegistration = 'Неверная регистрация действия (action)';
  SInvalidActionUnregistration = 'Неверная отмена регистрации действия (action)';
  SInvalidBinary = 'Неверное двоичное значение';
  SInvalidDate = '''''%s'''' - неверная дата' {$IFNDEF VER140}deprecated{$ENDIF};
  SInvalidDateTime = '''''%s'''' - неверные дата и время' {$IFNDEF VER140}deprecated{$ENDIF};
  SInvalidFileName = 'Неверное имя файла - %s';
  SInvalidImage = 'Неверный формат потока';
  SInvalidInteger = '''''%s'''' - неверное целое число' {$IFNDEF VER140}deprecated{$ENDIF};
  SInvalidMask = '''%s'' - неверная маска в позиции %d';
  SInvalidName = '''''%s'''' недопустимо в качестве имени компонента';
  SInvalidProperty = 'Неверное значение свойства';
  SInvalidPropertyElement = 'Неверный элемент свойства: %s';
  SInvalidPropertyPath = 'Неверный путь к свойству';
  SInvalidPropertyType = 'Неверный тип свойства: %s';
  SInvalidPropertyValue = 'Неверное значение свойства';
  SInvalidRegType = 'Неверный тип данных для ''%s''';
  SInvalidString = 'Неверная строковая константа';
  SInvalidStringGridOp = 'Не могу вставить или удалить строки из таблицы (grid)';
  SInvalidTime = '''''%s'''' - неверное время' {$IFNDEF VER140}deprecated{$ENDIF};
  SItemNotFound = 'Пункт не найден ($0%x)';
  SLineTooLong = 'Строка слишком длинная';
  SListCapacityError = 'Размер списка вышел за границы (%d)';
  SListCountError = 'Счетчик списка вышел за границы (%d)';
  SListIndexError = 'Индекс списка вышел за границы (%d)';
  SMaskErr = 'Введено неверное значение';
  SMaskEditErr = 'Введено неверное значение.  Нажмите Esc для отмены изменений';
  SMemoryStreamError = 'Не хватает памяти при расширении memory stream';
  SNoComSupport = '%s не зарегистрирован как COM класс';
  SNotPrinting = 'Принтер не находится сейчас в состоянии печати';
  SNumberExpected = 'Ожидается число';
  SParseError = '%s в строке %d';
  SComponentNameTooLong = 'Имя компонента ''%s'' превысило предел в 64 символов';
  SPropertyException = 'Ошибка чтения %s%s%s: %s';
  SPrinting = 'Идет печать...';
  SReadError = 'Ошибка чтения потока';
  SReadOnlyProperty = 'Свойство только для чтения';
  SRegCreateFailed = 'Ошибка создания ключа %s';
  SRegGetDataFailed = 'Ошибка чтения значения для ''%s''';
  SRegisterError = 'Неверная регистрация компонента';
  SRegSetDataFailed = 'Ошибка записи значения для ''%s''';
  SResNotFound = 'Ресурс %s не найден';
  SSeekNotImplemented = '%s.Seek не выполнено';
  SSortedListError = 'Операция недопустима для отсортированного списка строк';
  SStringExpected = 'Ожидается строка';
  SSymbolExpected = 'Ожидается %s';
  STimeEncodeError = 'Неверный аргумент для формирования времени' {$IFNDEF VER140}deprecated{$ENDIF};
  STooManyDeleted = 'Удаляется слишком много строк или столбцов';
  SUnknownGroup = '%s нет в группе регистрации класса';
  SUnknownProperty = 'Свойство %s не существует';
  SWriteError = 'Ошибка записи потока';
  SStreamSetSize = 'Ошибка установки размера потока (stream size)';
  SThreadCreateError = 'Ошибка создания потока (thread): %s';
  SThreadError = 'Ошибка потока (thread): %s (%d)';

  SInvalidDateDay = '(%d, %d) - неверная пара DateDay';
  SInvalidDateWeek = '(%d, %d, %d) - неверное сочетание DateWeek';
  SInvalidDateMonthWeek = '(%d, %d, %d, %d) - неверное сочетание DateMonthWeek';
  SInvalidDayOfWeekInMonth = '(%d, %d, %d, %d) - неверное сочетание DayOfWeekInMonth';
  SInvalidJulianDate = '%f Julian не может быть представлена как DateTime';
  SMissingDateTimeField = '?';

  SConvIncompatibleTypes2 = 'Несовместимые типы преобразования [%s, %s]';
  SConvIncompatibleTypes3 = 'Несовместимые типы преобразования [%s, %s, %s]';
  SConvIncompatibleTypes4 = 'Несовместимые типы преобразования [%s - %s, %s - %s]';
  SConvUnknownType = 'Неизвестный тип преобразования %s';
  SConvDuplicateType = 'Тип преобразования (%s) уже зарегистрирован в %s';
  SConvUnknownFamily = 'Неизвестное семейство преобразования %s';
  SConvDuplicateFamily = 'Семейство преобразования (%s) уже зарегистрировано';
{$IFNDEF VER140}
  SConvUnknownDescription = '[$%.8x]' deprecated; // no longer used
  SConvUnknownDescriptionWithPrefix = '[%s%.8x]';
{$ELSE}
  SConvUnknownDescription = '[%.8x]';
{$ENDIF}
  SConvIllegalType = 'Недопустимый тип';
  SConvIllegalFamily = 'Недопустимое семейство';
  SConvFactorZero = '%s имеет нулевой множитель';
  SConvStrParseError = 'Не могу разобрать %s';
  SFailedToCallConstructor = 'Потомок TStrings %s вызвал ошибку при вызове inherited constructor';

  sWindowsSocketError = 'Ошибка Windows socket: %s (%d), при вызове ''%s''';
  sAsyncSocketError = 'Ошибка asynchronous socket %d';
  sNoAddress = 'Не определен адрес';
  sCannotListenOnOpen = 'Не могу прослушивать открытый socket';
  sCannotCreateSocket = 'Не могу создать новый socket';
  sSocketAlreadyOpen = 'Socket уже открыт';
  sCantChangeWhileActive = 'Не могу изменить значение пока socket активен';
  sSocketMustBeBlocking = 'Socket должен быть в режиме блокировки';
  sSocketIOError = '%s ошибка %d, %s';
  sSocketRead = 'Read';
  sSocketWrite = 'Write';

{$IFNDEF VER140}
  SCmplxCouldNotParseImaginary = 'Не могу распознать мнимую часть';
  SCmplxCouldNotParseSymbol = 'Не могу распознать требуемый ''%s'' символ';
  SCmplxCouldNotParsePlus = 'Не могу распознать требуемый ''+'' (или ''-'') символ';
  SCmplxCouldNotParseReal = 'Не могу распознать действительную часть';
  SCmplxUnexpectedEOS = 'Неожиданный конец строки [%s]';
  SCmplxUnexpectedChars = 'Неожиданные символы';
  SCmplxErrorSuffix = '%s [%s<?>%s]';

  hNoSystem = 'Менеджер Справки не установлен.';
  hNoTopics = 'Справка на основе тем (topic) не установлена.';
  hNoContext = 'Контекстно-зависимая Справка не установлена.';
  hNothingFound = 'Не найдено справки для "%s"';
  hNoTableOfContents = 'Содержание не найдено.';

  { ************************************************************************* }
  { Distance's family type }
  SDistanceDescription = 'Расстояние';

  { Distance's various conversion types }
  SMicromicronsDescription = 'Микромикроны';
  SAngstromsDescription = 'Ангстремы';
  SMillimicronsDescription = 'Миллимикроны';
  SMicronsDescription = 'Микроны';
  SMillimetersDescription = 'Миллиметры';
  SCentimetersDescription = 'Сантиметры';
  SDecimetersDescription = 'Дециметры';
  SMetersDescription = 'Метры';
  SDecametersDescription = 'Декаметры';
  SHectometersDescription = 'Гектометры';
  SKilometersDescription = 'Километры';
  SMegametersDescription = 'Мегаметры';
  SGigametersDescription = 'Гигаметры';
  SInchesDescription = 'Дюймы';
  SFeetDescription = 'Футы';
  SYardsDescription = 'Ярды';
  SMilesDescription = 'Мили';
  SNauticalMilesDescription = 'Морские мили';
  SAstronomicalUnitsDescription = 'Астрономические единицы';
  SLightYearsDescription = 'Световые годы';
  SParsecsDescription = 'Парсеки';
  SCubitsDescription = 'Локти';
  SFathomsDescription = 'Морские сажени';
  SFurlongsDescription = '1/8 мили';
  SHandsDescription = 'Руки';
  SPacesDescription = 'Шаги';
  SRodsDescription = 'Пруты (rods)';
  SChainsDescription = 'Мерные цепи';
  SLinksDescription = 'Звенья землемерной цепи';
  SPicasDescription = 'Пики (picas)';
  SPointsDescription = 'Точки';

  { ************************************************************************* }
  { Area's family type }
  SAreaDescription = 'Площадь';

  { Area's various conversion types }
  SSquareMillimetersDescription = 'Кв. миллиметры';
  SSquareCentimetersDescription = 'Кв. сантиметры';
  SSquareDecimetersDescription = 'Кв. дециметры';
  SSquareMetersDescription = 'Кв. метры';
  SSquareDecametersDescription = 'Кв. декаметры';
  SSquareHectometersDescription = 'Кв. гектометры';
  SSquareKilometersDescription = 'Кв. километры';
  SSquareInchesDescription = 'Кв. дюймы';
  SSquareFeetDescription = 'Кв. футы';
  SSquareYardsDescription = 'Кв. ярды';
  SSquareMilesDescription = 'Кв. мили';
  SAcresDescription = 'Акры';
  SCentaresDescription = 'Сантиары';
  SAresDescription = 'Ары';
  SHectaresDescription = 'Гектары';
  SSquareRodsDescription = 'Кв. пруты (rods)';

  { ************************************************************************* }
  { Volume's family type }
  SVolumeDescription = 'Объем';

  { Volume's various conversion types }
  SCubicMillimetersDescription = 'Куб. миллиметры';
  SCubicCentimetersDescription = 'Куб. сантиметры';
  SCubicDecimetersDescription = 'Куб. дециметры';
  SCubicMetersDescription = 'Куб. метры';
  SCubicDecametersDescription = 'Куб. декаметры';
  SCubicHectometersDescription = 'Куб. гектометры';
  SCubicKilometersDescription = 'Куб. километры';
  SCubicInchesDescription = 'Куб. дюймы';
  SCubicFeetDescription = 'Куб. футы';
  SCubicYardsDescription = 'Куб. ярды';
  SCubicMilesDescription = 'Куб. мили';
  SMilliLitersDescription = 'Миллилитры';
  SCentiLitersDescription = 'Сантилитры';
  SDeciLitersDescription = 'Децилитры';
  SLitersDescription = 'Литры';
  SDecaLitersDescription = 'Декалитры';
  SHectoLitersDescription = 'Гектолитры';
  SKiloLitersDescription = 'Килолитры';
  SAcreFeetDescription = 'Акрофуты';
  SAcreInchesDescription = 'Акродюймы';
  SCordsDescription = 'Корды';
  SCordFeetDescription = 'Кордфуты';
  SDecisteresDescription = 'Decisteres';
  SSteresDescription = 'Steres';
  SDecasteresDescription = 'Decasteres';

  { American Fluid Units }
  SFluidGallonsDescription = 'Галлоны жидкие';
  SFluidQuartsDescription = 'Кварты жидкие';
  SFluidPintsDescription = 'Пинты жидкие';
  SFluidCupsDescription = 'Кубки жидкие';
  SFluidGillsDescription = '1/4 пинты жидкие';
  SFluidOuncesDescription = 'Унции жидкие';
  SFluidTablespoonsDescription = 'Столовые ложки';
  SFluidTeaspoonsDescription = 'Чайные ложки';

  { American Dry Units }
  SDryGallonsDescription = 'Галлоны сыпучие';
  SDryQuartsDescription = 'Кварты сыпучие';
  SDryPintsDescription = 'Пинты сыпучие';
  SDryPecksDescription = 'DryPecks';
  SDryBucketsDescription = 'Ведра';
  SDryBushelsDescription = 'Бушели';

  { English Imperial Fluid/Dry Units }
  SUKGallonsDescription = 'Англ. галлоны';
  SUKPottlesDescription = 'UKPottle';
  SUKQuartsDescription = 'Англ. кварты';
  SUKPintsDescription = 'Англ. пинты';
  SUKGillsDescription = 'Англ. 1/4 пинты';
  SUKOuncesDescription = 'Англ. унции';
  SUKPecksDescription = 'UKPecks';
  SUKBucketsDescription = 'Англ. ведра';
  SUKBushelsDescription = 'Англ. бушели';

  { ************************************************************************* }
  { Mass's family type }
  SMassDescription = 'Масса';

  { Mass's various conversion types }
  SNanogramsDescription = 'Нанограммы';
  SMicrogramsDescription = 'Микрограммы';
  SMilligramsDescription = 'Миллиграммы';
  SCentigramsDescription = 'Сантиграммы';
  SDecigramsDescription = 'Дециграммы';
  SGramsDescription = 'Граммы';
  SDecagramsDescription = 'Декаграммы';
  SHectogramsDescription = 'Гектограммы';
  SKilogramsDescription = 'Килограммы';
  SMetricTonsDescription = 'Метр. тонны';
  SDramsDescription = 'Драхмы';
  SGrainsDescription = 'Граны';
  STonsDescription = 'Тонны';
  SLongTonsDescription = 'Длинные тонны';
  SOuncesDescription = 'Унции';
  SPoundsDescription = 'Фунты';
  SStonesDescription = 'Стоуны';

  { ************************************************************************* }
  { Temperature's family type }
  STemperatureDescription = 'Температура';

  { Temperature's various conversion types }
  SCelsiusDescription = 'Цельсий';
  SKelvinDescription = 'Кельвин';
  SFahrenheitDescription = 'Фаренгейт';
  SRankineDescription = 'Rankine';
  SReaumurDescription = 'Реомюр';

  { ************************************************************************* }
  { Time's family type }
  STimeDescription = 'Время';

  { Time's various conversion types }
  SMilliSecondsDescription = 'Миллисекунды';
  SSecondsDescription = 'Секунды';
  SMinutesDescription = 'Минуты';
  SHoursDescription = 'Часы';
  SDaysDescription = 'Дни';
  SWeeksDescription = 'Недели';
  SFortnightsDescription = 'Две недели';
  SMonthsDescription = 'Месяца';
  SYearsDescription = 'Годы';
  SDecadesDescription = 'Декады';
  SCenturiesDescription = 'Века';
  SMillenniaDescription = 'Тысячелетия';
  SDateTimeDescription = 'ДатаВремя';
  SJulianDateDescription = 'Юлианская дата';
  SModifiedJulianDateDescription = 'Измененая Юлианская дата';
{$ENDIF}

implementation

end.
