{********************************************************}
{                                                        }
{       Borland Delphi Visual Component Library          }
{                                                        }
{  Copyright (c) 1995-2001 Borland Software Corporation  }
{                                                        }
{  Русификация: 1998-2002 Polaris Software               }
{               http://polesoft.da.ru                    }
{********************************************************}

unit Consts;

interface

{$IFDEF VER140}
  {$DEFINE D6_}
{$ENDIF}
{$IFDEF VER150}
  {$DEFINE D6_}
{$ENDIF}

resourcestring
{$IFNDEF VER100}
  SOpenFileTitle = 'Открыть';
{$ENDIF}
{$IFNDEF D6_}
  SAssignError = 'Не могу значение %s присвоить %s';
  SFCreateError = 'Не могу создать файл %s';
  SFOpenError = 'Не могу открыть файл %s';
  SReadError = 'Ошибка чтения потока';
  SWriteError = 'Ошибка записи потока';
  SMemoryStreamError = 'Не хватает памяти при расширении memory stream';
{$ENDIF}
  SCantWriteResourceStreamError = 'Не могу записывать в поток ресурсов "только для чтения"';
  SDuplicateReference = 'WriteObject вызван дважды для одного и того же экземпляра';
{$IFNDEF D6_}
  SClassNotFound = 'Класс %s не найден';
  SInvalidImage = 'Неверный формат потока';
  SResNotFound = 'Ресурс %s не найден';
{$ENDIF}
  SClassMismatch = 'Неверный класс ресурса %s';
{$IFNDEF D6_}
  SListIndexError = 'Индекс списка вышел за границы (%d)';
  SListCapacityError = 'Размер списка вышел за границы (%d)';
  SListCountError = 'Счетчик списка вышел за границы (%d)';
  SSortedListError = 'Операция недопустима для отсортированного списка строк';
  SDuplicateString = 'Список строк не допускает дубликатов';
{$ENDIF}
  SInvalidTabIndex = 'Tab индекс вышел за границы';
{$IFNDEF VER100}
  SInvalidTabPosition = 'Позиция tab несовместима с текущим стилем tab';
  SInvalidTabStyle = 'Cтиль tab несовместим с текущей позицией tab';
{$ENDIF}
{$IFNDEF D6_}
  SDuplicateName = 'Компонент с именем %s уже существует';
  SInvalidName = '''''%s'''' недопустимо в качестве имени компонента';
  SDuplicateClass = 'Класс с именем %s уже существует';
  SNoComSupport = '%s не зарегистрирован как COM класс';
  SInvalidInteger = '''''%s'''' - неверное целое число';
  SLineTooLong = 'Строка слишком длинная';
  SInvalidPropertyValue = 'Неверное значение свойства';
  SInvalidPropertyPath = 'Неверный путь к свойству';
 {$IFDEF VER130}
  SInvalidPropertyType = 'Неверный тип свойства: %s';
  SInvalidPropertyElement = 'Неверный элемент свойства: %s';
 {$ENDIF}
  SUnknownProperty = 'Свойство не существует';
  SReadOnlyProperty = 'Свойство только для чтения';
 {$IFDEF VER100}
  SPropertyException = 'Ошибка чтения %s.%s: %s';
 {$ELSE}
  SPropertyException = 'Ошибка чтения %s%s%s: %s';
 {$ENDIF}
  SAncestorNotFound = 'Предок для ''%s'' не найден';
{$ENDIF}
  SInvalidBitmap = 'Изображение Bitmap имеет неверный формат';
  SInvalidIcon = 'Иконка (Icon) имеет неверный формат';
  SInvalidMetafile = 'Метафайл имеет неверный формат';
  SInvalidPixelFormat = 'Неверный точечный (pixel) формат';
{$IFDEF D6_}
  SInvalidImage = 'Неверное изображение';
{$ENDIF}
  SBitmapEmpty = 'Изображение Bitmap пустое';
  SScanLine = 'Scan line индекс вышел за границы';
  SChangeIconSize = 'Не могу изменить размер иконки';
  SOleGraphic = 'Неверная операция с TOleGraphic';
  SUnknownExtension = 'Неизвестное расширение файла изображения (.%s)';
  SUnknownClipboardFormat = 'Неподдерживаемый формат буфера обмена';
  SOutOfResources = 'Не хватает системных ресурсов';
  SNoCanvasHandle = 'Canvas не позволяет рисовать';
  SInvalidImageSize = 'Неверный размер изображения';
  STooManyImages = 'Слишком много изображений';
  SDimsDoNotMatch = 'Размеры изображения не совпадают с размерами в image list';
  SInvalidImageList = 'Неверный ImageList';
  SReplaceImage = 'Невозможно заменить изображение';
  SImageIndexError = 'Неверный индекс ImageList';
  SImageReadFail = 'Ошибка чтения данных ImageList из потока';
  SImageWriteFail = 'Ошибка записи данных ImageList в поток';
  SWindowDCError = 'Ошибка создания контекста окна (window device context)';
  SClientNotSet = 'Клиент TDrag не инициализирован';
  SWindowClass = 'Ошибка создания оконного класса';
  SWindowCreate = 'Ошибка создания окна';
  SCannotFocus = 'Не могу передать фокус ввода отключенному или невидимому окну';
  SParentRequired = 'Элемент управления ''%s'' не имеет родительского окна';
{$IFDEF D6_}
  SParentGivenNotAParent = 'Данный родитель не является родителем ''%s''';
{$ENDIF}
  SMDIChildNotVisible = 'Не могу скрыть дочернюю форму MDI';
  SVisibleChanged = 'Не могу изменить Visible в OnShow или OnHide';
  SCannotShowModal = 'Не могу сделать видимым модальное окно';
  SScrollBarRange = 'Свойство Scrollbar вышло за границы';
  SPropertyOutOfRange = 'Свойство %s вышло за границы';
  SMenuIndexError = 'Индекс меню вышел за границы';
  SMenuReinserted = 'Меню вставлено дважды';
  SMenuNotFound = 'Подменю - не в меню';
  SNoTimers = 'Нет доступных таймеров';
  SNotPrinting = 'Принтер не находится сейчас в состоянии печати';
  SPrinting = 'Идет печать...';
  SPrinterIndexError = 'Индекс принтера вышел за границы';
  SInvalidPrinter = 'Выбран неверный принтер';
  SDeviceOnPort = '%s on %s';
  SGroupIndexTooLow = 'GroupIndex не может быть меньше, чем GroupIndex предыдущего пункта меню';
  STwoMDIForms = 'Нельзя иметь более одной основной MDI формы в программе';
  SNoMDIForm = 'Не могу создать форму. Нет активных MDI форм';
{$IFNDEF D6_}
  SRegisterError = 'Неверная регистрация компонента';
{$ENDIF}
  SImageCanvasNeedsBitmap = 'Можно редактировать только изображения, которые содержат bitmap';
  SControlParentSetToSelf = 'Элемент управления не может быть родителем самого себя';
  SOKButton = 'OK';
  SCancelButton = 'Отмена';
  SYesButton = '&Да';
  SNoButton = '&Нет';
  SHelpButton = '&Справка';
  SCloseButton = '&Закрыть';
  SIgnoreButton = 'Про&должить';
  SRetryButton = '&Повторить';
  SAbortButton = 'Прервать';
  SAllButton = '&Все';

  SCannotDragForm = 'Не могу перемещать форму';
  SPutObjectError = 'PutObject для неопределенного типа';
  SCardDLLNotLoaded = 'Не могу загрузить CARDS.DLL';
  SDuplicateCardId = 'Найден дубликат CardId';

  SDdeErr = 'Возвращена ошибка DDE  ($0%x)';
  SDdeConvErr = 'Ошибка DDE - диалог не установлен ($0%x)';
  SDdeMemErr = 'Ошибка - не хватает памяти для DDE ($0%x)';
  SDdeNoConnect = 'Не могу присоединить DDE диалог (conversation)';

  SFB = 'FB';
  SFG = 'FG';
  SBG = 'BG';
  SOldTShape = 'Не могу загрузить старую версию TShape';
  SVMetafiles = 'Метафайлы';
  SVEnhMetafiles = 'Расширенные метафайлы';
  SVIcons = 'Иконки';
  SVBitmaps = 'Картинки';
  SGridTooLarge = 'Таблица (Grid) слишком большая для работы';
  STooManyDeleted = 'Удаляется слишком много строк или столбцов';
  SIndexOutOfRange = 'Индекс Grid вышел за границы';
  SFixedColTooBig = 'Число фиксированных столбцов должно быть меньше общего числа столбцов';
  SFixedRowTooBig = 'Число фиксированных строк должно быть меньше общего числа строк';
  SInvalidStringGridOp = 'Не могу вставить или удалить строки из таблицы (grid)';
{$IFNDEF D6_}
  SParseError = '%s в строке %d';
  SIdentifierExpected = 'Ожидается идентификатор';
  SStringExpected = 'Ожидается строка';
  SNumberExpected = 'Ожидается число';
  SCharExpected = 'Ожидается ''''%s''''';
  SSymbolExpected = 'Ожидается %s';
{$ELSE}
  SInvalidEnumValue = 'Неверное Enum значение';
{$ENDIF}
  SInvalidNumber = 'Неверное числовое значение';
{$IFNDEF D6_}
  SInvalidString = 'Неверная строковая константа';
  SInvalidProperty = 'Неверное значение свойства';
  SInvalidBinary = 'Неверное двоичное значение';
{$ENDIF}
  SOutlineIndexError = 'Индекс Outline не найден';
  SOutlineExpandError = 'Родительский узел должен быть раскрыт';
  SInvalidCurrentItem = 'Неверное значение для текущего элемента';
  SMaskErr = 'Введено неверное значение';
  SMaskEditErr = 'Введено неверное значение.  Нажмите Esc для отмены изменений';
  SOutlineError = 'Неверный индекс outline';
  SOutlineBadLevel = 'Неверное определение уровня';
  SOutlineSelection = 'Неверный выбор';
  SOutlineFileLoad = 'Ошибка загрузки файла';
  SOutlineLongLine = 'Строка слишком длинная';
  SOutlineMaxLevels = 'Достигнута максимальная глубина outline';

  SMsgDlgWarning = 'Предупреждение';
  SMsgDlgError = 'Ошибка';
  SMsgDlgInformation = 'Информация';
  SMsgDlgConfirm = 'Подтверждение';
  SMsgDlgYes = '&Да';
  SMsgDlgNo = '&Нет';
  SMsgDlgOK = 'OK';
  SMsgDlgCancel = 'Отмена';
  SMsgDlgHelp = '&Справка';
  SMsgDlgHelpNone = 'Справка недоступна';
  SMsgDlgHelpHelp = 'Справка';
  SMsgDlgAbort = 'П&рервать';
  SMsgDlgRetry = '&Повторить';
  SMsgDlgIgnore = 'Про&должить';
  SMsgDlgAll = '&Все';
  SMsgDlgNoToAll = 'Н&ет для всех';
  SMsgDlgYesToAll = 'Д&а для всех';

  SmkcBkSp = 'BkSp';
  SmkcTab = 'Tab';
  SmkcEsc = 'Esc';
  SmkcEnter = 'Enter';
  SmkcSpace = 'Space';
  SmkcPgUp = 'PgUp';
  SmkcPgDn = 'PgDn';
  SmkcEnd = 'End';
  SmkcHome = 'Home';
  SmkcLeft = 'Left';
  SmkcUp = 'Up';
  SmkcRight = 'Right';
  SmkcDown = 'Down';
  SmkcIns = 'Ins';
  SmkcDel = 'Del';
  SmkcShift = 'Shift+';
  SmkcCtrl = 'Ctrl+';
  SmkcAlt = 'Alt+';

  srUnknown = '(Неизвестно)';
  srNone = '(Нет)';
  SOutOfRange = 'Значение должно быть между %d и %d';
{$IFNDEF D6_}
  SCannotCreateName = 'Не могу создать имя метода по умолчанию для безымянного компонента';
{$ENDIF}

  SDateEncodeError = 'Неверный аргумент для формирования даты';
{$IFNDEF D6_}
  STimeEncodeError = 'Неверный аргумент для формирования времени';
  SInvalidDate = '''''%s'''' - неверная дата';
  SInvalidTime = '''''%s'''' - неверное время';
  SInvalidDateTime = '''''%s'''' - неверные дата и время';
  SInvalidFileName = 'Неверное имя файла - %s';
{$ENDIF}
  SDefaultFilter = 'Все файлы (*.*)|*.*';
  sAllFilter = 'Все';
  SNoVolumeLabel = ': [ - нет метки тома - ]';
  SInsertLineError = 'Невозможно вставить строку';

  SConfirmCreateDir = 'Указанная папка не существует. Создать ее?';
  SSelectDirCap = 'Выбор папки';
{$IFNDEF D6_}
  SCannotCreateDir = 'Не могу создать папку';
{$ENDIF}
  SDirNameCap = '&Имя папки:';
  SDrivesCap = '&Устройства:';
  SDirsCap = '&Папки:';
  SFilesCap = '&Файлы: (*.*)';
  SNetworkCap = '&Сеть...';

  SColorPrefix = 'Color';
  SColorTags = 'ABCDEFGHIJKLMNOP';

  SInvalidClipFmt = 'Неверный формат буфера обмена';
  SIconToClipboard = 'Буфер обмена не поддерживает иконки';
{$IFNDEF VER100}
  SCannotOpenClipboard = 'Не могу открыть буфер обмена';
{$ENDIF}

  SDefault = 'Default';

  SInvalidMemoSize = 'Текст превысил емкость memo';
  SCustomColors = 'Custom Colors';
  SInvalidPrinterOp = 'Операция не поддерживается на выбранном принтере';
  SNoDefaultPrinter = 'Нет выбранного по умолчанию принтера';

  SIniFileWriteError = 'Не могу записать в %s';

  SBitsIndexError = 'Индекс Bits вышел за границы';

  SUntitled = '(Без имени)';

  SInvalidRegType = 'Неверный тип данных для ''%s''';
{$IFNDEF D6_}
  SRegCreateFailed = 'Ошибка создания ключа %s';
  SRegSetDataFailed = 'Ошибка записи значения для ''%s''';
  SRegGetDataFailed = 'Ошибка чтения значения для ''%s''';
{$ENDIF}

  SUnknownConversion = 'Неизвестное расширение файла для конвертирования RichEdit (.%s)';
  SDuplicateMenus = 'Меню ''%s'' уже используется другой формой';

  SPictureLabel = 'Картинка:';
  SPictureDesc = ' (%dx%d)';
  SPreviewLabel = 'Просмотр';

  SCannotOpenAVI = 'Не могу открыть AVI';

  SNotOpenErr = 'Нет открытых устройств MCI';
  SMPOpenFilter = 'Все файлы (*.*)|*.*|Аудио файлы (*.wav)|*.wav|Midi файлы (*.mid)|*.mid|Видео для Windows (*.avi)|*.avi';
  SMCINil = '';
  SMCIAVIVideo = 'AVIVideo';
  SMCICDAudio = 'CDAudio';
  SMCIDAT = 'DAT';
  SMCIDigitalVideo = 'DigitalVideo';
  SMCIMMMovie = 'MMMovie';
  SMCIOther = 'Other';
  SMCIOverlay = 'Overlay';
  SMCIScanner = 'Scanner';
  SMCISequencer = 'Sequencer';
  SMCIVCR = 'VCR';
  SMCIVideodisc = 'Videodisc';
  SMCIWaveAudio = 'WaveAudio';
  SMCIUnknownError = 'Неизвестный код ошибки';

  SBoldItalicFont = 'Bold Italic';
  SBoldFont = 'Bold';
  SItalicFont = 'Italic';
  SRegularFont = 'Regular';

  SPropertiesVerb = 'Свойства';

{$IFNDEF VER100}
 {$IFNDEF D6_}
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
 {$ENDIF}

  SServiceFailed = 'Сбой службы на %s: %s';
  SExecute = 'execute';
  SStart = 'start';
  SStop = 'stop';
  SPause = 'pause';
  SContinue = 'continue';
  SInterrogate = 'interrogate';
  SShutdown = 'shutdown';
  SCustomError = 'Сбой службы в custom message(%d): %s';
  SServiceInstallOK = 'Служба установлена успешно';
  SServiceInstallFailed = 'Сбой при установке службы "%s", ошибка: "%s"';
  SServiceUninstallOK = 'Служба снята успешно';
  SServiceUninstallFailed = 'Сбой при снятии службы "%s", ошибка: "%s"';

  SInvalidActionRegistration = 'Неверная регистрация действия (action)';
  SInvalidActionUnregistration = 'Неверная отмена регистрации действия (action)';
  SInvalidActionEnumeration = 'Неверный перечень действий (action)';
  SInvalidActionCreation = 'Неверное создание действия (action)';

  SDockedCtlNeedsName = 'Докированный элемент должен иметь имя';
  SDockTreeRemoveError = 'Ошибка удаления элемента из dock tree';
  SDockZoneNotFound = ' - область докирования не найдена';
  SDockZoneHasNoCtl = ' - область докирования не имеет элементов управления';

  SAllCommands = 'All Commands';

 {$IFNDEF VER110} // Delphi 5 and later
 {$IFNDEF VER120}
 {$IFNDEF VER125}
  SDuplicateItem = 'Список не допускает дубликатов ($0%x)';

  {$IFNDEF D6_}
  SDuplicatePropertyCategory = 'Категория свойства, названная %s, уже создана';
  SUnknownPropertyCategory = 'Категория свойства не создана (%s)';

  SActionCategoryName = 'Action';
  SActionCategoryDesc = 'Свойства и/или события действия (action)';
  SDataCategoryName = 'Data';
  SDataCategoryDesc = 'Свойства и/или события категории Data';
  SDatabaseCategoryName = 'Database';
  SDatabaseCategoryDesc = 'Свойства и/или события категории Database';
  SDragNDropCategoryName = 'Drag, Drop and Docking';
  SDragNDropCategoryDesc = 'Свойства и/или события категории Drag, Drop and Docking';
  SHelpCategoryName = 'Help and Hints';
  SHelpCategoryDesc = 'Свойства и/или события категории Help and Hint';
  SLayoutCategoryName = 'Layout';
  SLayoutCategoryDesc = 'Свойства и/или события категории Layout';
  SLegacyCategoryName = 'Legacy';
  SLegacyCategoryDesc = 'Свойства и/или события категории Legacy';
  SLinkageCategoryName = 'Linkage';
  SLinkageCategoryDesc = 'Свойства и/или события категории Linkage';
  SLocaleCategoryName = 'Locale';
  SLocaleCategoryDesc = 'Свойства и/или события категории Locale';
  SLocalizableCategoryName = 'Localizable';
  SLocalizableCategoryDesc = 'Свойства и/или события категории Localizable';
  SMiscellaneousCategoryName = 'Miscellaneous';
  SMiscellaneousCategoryDesc = 'Свойства и/или события категории Miscellaneous';
  SVisualCategoryName = 'Visual';
  SVisualCategoryDesc = 'Свойства и/или события категории Visual';
  SInputCategoryName = 'Input';
  SInputCategoryDesc = 'Свойства и/или события категории Input';

  SInvalidMask = '''%s'' - неверная маска в позиции %d';
  SInvalidFilter = 'Фильтром свойств может быть только имя, класс или тип по базе (%d:%d)';
  SInvalidCategory = 'Категории должны определять свои имя и описание';

  sOperationNotAllowed = 'Операция не допустима во время отправки событий приложения';
  {$ENDIF}
 {$ENDIF}
 {$ENDIF}
 {$ENDIF}
{$ENDIF}  // IFNDEF VER100

{$IFDEF D6_}
  STextNotFound = 'Текст не найден: "%s"';
  SBrowserExecError = 'Не определен браузер по умолчанию';

  SColorBoxCustomCaption = 'Выбрать...';

  SMultiSelectRequired = 'Режим множественного выбора должен быть включен для этой возможности';

  SKeyCaption = 'Параметр';
  SValueCaption = 'Значение';
  SKeyConflict = 'Параметр с именем "%s" уже создан';
  SKeyNotFound = 'Параметр "%s" не найден';
  SNoColumnMoving = 'goColMoving - неподдерживаемая опция';
  SNoEqualsInKey = 'Параметр не может содержать знак "равно" ("=")';

  SSendError = 'Ошибка отправки почты';
  SAssignSubItemError = 'Не могу присвоить подпункт к actionbar когда один из его предков уже присвоен actionbar';
  SDeleteItemWithSubItems = 'Пункт %s имеет подпункты, все равно удалить?';
  {$IFNDEF VER140}
  SDeleteNotAllowed = 'Вам не разрешено удалять этот пункт';
  SMoveNotAllowed = 'Пункт %s нельзя перемещать';
  {$ENDIF}
  SMoreButtons = 'Больше кнопок';
  SErrorDownloadingURL = 'Ошибка загрузки URL: %s';
  SUrlMonDllMissing = 'Не могу загрузить %s';
  SAllActions = '(Все действия)';
  SNoCategory = '(Нет категории)';
  SExpand = 'Expand';
  SErrorSettingPath = 'Ошибка установки пути: "%s"';
  SLBPutError = 'Попытка поместить пункты в виртуальный listbox';
  SErrorLoadingFile = 'Ошибка загрузки ранее сохраненного файла настроек: %s'#13'Вы хотите удалить его?';
  SResetUsageData = 'Reset все используемые данные?';
  SFileRunDialogTitle = 'Выполнить';
  SNoName = '(Нет имени)';      
  SErrorActionManagerNotAssigned = 'ActionManager должен быть присвоен первым';
  SAddRemoveButtons = '&Добавить или удалить кнопки';
  SResetActionToolBar = 'Reset Toolbar';
  SCustomize = '&Настроить';
  SSeparator = 'Разделитель';
  SCirularReferencesNotAllowed = 'Циклические ссылки не поддерживаются';
  SCannotHideActionBand = '%s не позволяет скрыть (hiding)';
  SErrorSettingCount = 'Ошибка установки %s.Count';
  SListBoxMustBeVirtual = 'Listbox (%s) Style должен быть Virtual для установки такого Count';
  SUnableToSaveSettings = 'Не могу сохранить установки';  
  SRestoreDefaultSchedule = 'Вы хотите восстановить Priority Schedule по умолчанию?';
  {$IFNDEF VER140}
  SNoGetItemEventHandler = 'Не определен обработчик события OnGetItem';
  SInvalidColorMap = 'Неверный Colormap этот ActionBand требует ColorMaps типа TCustomActionBarColorMapEx';
  SDuplicateActionBarStyleName = 'Стиль с именем %s уже зарегистрирован';
  SStandardStyleActionBars = 'Стандартный стиль';
  SXPStyleActionBars = 'Стиль XP';
  SActionBarStyleMissing = 'Нет модуля со стилем ActionBand в предложении uses.'#13 +
    'Ваше приложение должно включать либо XPStyleActnCtrls, StdStyleActnCtrls, или ' +
    'модуль со стилем ActionBand третьей фирмы в своем предложении uses.';
  {$ENDIF}
{$ENDIF}

implementation

end.
