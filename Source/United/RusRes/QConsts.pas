{ *************************************************************************** }
{                                                                             }
{ Delphi and Kylix Cross-Platform Visual Component Library                    }
{                                                                             }
{ Copyright (c) 2000-2002 Borland Software Corporation                        }
{                                                                             }
{ This file may be distributed and/or modified under the terms of the GNU     }
{ General Public License (GPL) version 2 as published by the Free Software    }
{ Foundation and appearing at http://www.borland.com/kylix/gpl.html.          }
{                                                                             }
{ Licensees holding a valid Borland No-Nonsense License for this Software may }
{ use this file in accordance with such license, which appears in the file    }
{ license.txt that came with this Software.                                   }
{                                                                             }
{  Русификация: 2001-02 Polaris Software                                      }
{               http://polesoft.da.ru                                         }
{ *************************************************************************** }

unit QConsts;

interface

const
  // Delphi mime types
  SDelphiBitmap = 'image/delphi.bitmap';
  SDelphiComponent = 'application/delphi.component';
  SDelphiPicture = 'image/delphi.picture';
  SDelphiDrawing = 'image/delphi.drawing';
{$IFNDEF VER140}
  SBitmapExt = 'BMP';
{$ENDIF}

resourcestring
  SInvalidCreateWidget = 'Класс %s не может создать QT widget';
  STooManyMessageBoxButtons = 'Определено слишком много кнопок для окна сообщения';

  SmkcBkSp = 'Backspace';
  SmkcTab = 'Tab';
  SmkcBackTab = 'BackTab';
  SmkcEsc = 'Esc';
  SmkcReturn = 'Return';
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

  SOpenFileTitle = 'Открыть';
{$IFDEF VER140}
  SAssignError = 'Не могу значение %s присвоить %s';
  SFCreateError = 'Не могу создать файл %s';
  SFOpenError = 'Не могу открыть файл %s';
  SReadError = 'Ошибка чтения потока';
  SWriteError = 'Ошибка записи потока';
  SMemoryStreamError = 'Не хватает памяти при расширении memory stream';
  SCantWriteResourceStreamError = 'Не могу записывать в поток ресурсов "только для чтения"';
{$ENDIF}
  SDuplicateReference = 'WriteObject вызван дважды для одного и того же экземпляра';
{$IFDEF VER140}
  SClassNotFound = 'Класс %s не найден';
  SInvalidImage = 'Неверный формат потока';
  SResNotFound = 'Ресурс %s не найден';
{$ENDIF}
  SClassMismatch = 'Неверный класс ресурса %s';
{$IFDEF VER140}
  SListIndexError = 'Индекс списка вышел за границы (%d)';
  SListCapacityError = 'Размер списка вышел за границы (%d)';
  SListCountError = 'Счетчик списка вышел за границы (%d)';
  SSortedListError = 'Операция недопустима для отсортированного списка строк';
  SDuplicateString = 'Список строк не допускает дубликатов';
{$ENDIF}
  SInvalidTabIndex = 'Tab индекс вышел за границы';
  SInvalidTabPosition = 'Позиция tab несовместима с текущим стилем tab';
  SInvalidTabStyle = 'Cтиль tab несовместим с текущей позицией tab';
{$IFDEF VER140}
  SDuplicateName = 'Компонент с именем %s уже существует';
  SInvalidName = '''''%s'''' недопустимо в качестве имени компонента';
  SDuplicateClass = 'Класс с именем %s уже существует';
  SNoComSupport = '%s не зарегистрирован как COM класс';
  SInvalidInteger = '''''%s'''' - неверное целое число';
  SLineTooLong = 'Строка слишком длинная';
  SInvalidPropertyValue = 'Неверное значение свойства';
  SInvalidPropertyPath = 'Неверный путь к свойству';
  SInvalidPropertyType = 'Неверный тип свойства: %s';
  SInvalidPropertyElement = 'Неверный элемент свойства: %s';
  SUnknownProperty = 'Свойство не существует';
  SReadOnlyProperty = 'Свойство только для чтения';
  SPropertyException = 'Ошибка чтения %s%s%s: %s';
  SAncestorNotFound = 'Предок для ''%s'' не найден';
{$ENDIF}
  SInvalidBitmap = 'Изображение Bitmap имеет неверный формат';
  SInvalidIcon = 'Иконка (Icon) имеет неверный формат';
  SInvalidPixelFormat = 'Неверный точечный (pixel) формат';
  SBitmapEmpty = 'Изображение Bitmap пустое';
  SScanLine = 'Scan line индекс вышел за границы';
  SChangeIconSize = 'Не могу изменить размер иконки';
  SUnknownExtension = 'Неизвестное расширение файла изображения (.%s)';
  SUnknownClipboardFormat = 'Неподдерживаемый формат буфера обмена';
  SOutOfResources = 'Не хватает системных ресурсов';
  SNoCanvasHandle = 'Canvas не позволяет рисовать';
  SInvalidCanvasState = 'Неверный запрос состояния canvas';
  SInvalidImageSize = 'Неверный размер изображения';
  SInvalidWidgetHandle = 'Неверный дескриптор widget';
  SInvalidColorDepth = 'Глубина цвета должна быть 1, 8 или 32 bpp';
{$IFNDEF VER140}
  SInvalidXImage = 'Неверный XImage';
{$ENDIF}
  STooManyImages = 'Слишком много изображений';
  SWidgetCreate = 'Ошибка создания widget';
  SCannotFocus = 'Не могу передать фокус ввода отключенному или невидимому окну (%s)';
  SParentRequired = 'Элемент управления ''%s'' не имеет родительского widget';
  SParentGivenNotAParent = 'Данный родитель не является родителем ''%s''';
  SVisibleChanged = 'Не могу изменить Visible в OnShow или OnHide';
  SCannotShowModal = 'Не могу сделать видимым модальное окно';
  SScrollBarRange = 'Свойство Scrollbar вышло за границы';
  SPropertyOutOfRange = 'Свойство %s вышло за границы';
  SMenuIndexError = 'Индекс меню вышел за границы';
  SMenuReinserted = 'Меню вставлено дважды';
  SNoMenuRecursion = 'Рекурсия при вставке меню не поддерживается';
  SMenuNotFound = 'Подменю - не в меню';
  SMenuSetFormError = 'TMenu.SetForm: аргумент должен быть TCustomForm';
  SNoTimers = 'Нет доступных таймеров';
{$IFDEF VER140}
  SNotPrinting = 'Принтер не находится сейчас в состоянии печати';
  SPrinting = 'Идет печать...';
{$ENDIF}
  SNoAdapter = 'Нет доступного адаптера принтера для печати';
  SPrinterIndexError = 'Индекс принтера вышел за границы';
  SInvalidPrinter = 'Выбран неверный принтер';
  SDeviceOnPort = '%s on %s';
  SGroupIndexTooLow = 'GroupIndex не может быть меньше, чем GroupIndex предыдущего пункта меню';
  SNoMDIForm = 'Не могу создать форму. Нет активных MDI форм';
  SNotAnMDIForm = 'Неверный MDIParent для класса %s';
  SMDIChildNotVisible = 'Не могу скрыть дочернюю MDI форму';
{$IFDEF VER140}
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

  SFB = 'FB';
  SFG = 'FG';
  SBG = 'BG';
  SVIcons = 'Иконки';
  SVBitmaps = 'Bitmaps';
  SVPixmaps = 'Pixmaps';
  SVPNGs = 'PNGs';
  SDrawings = 'Рисунки';
{$IFNDEF VER140}
  SVJpegs = 'Jpegs';
{$ENDIF}
{$IFDEF VER140}
  SGridTooLarge = 'Таблица (Grid) слишком большая для работы';
  STooManyDeleted = 'Удаляется слишком много строк или столбцов';
  SIndexOutOfRange = 'Индекс Grid вышел за границы';
  SFixedColTooBig = 'Число фиксированных столбцов должно быть меньше общего числа столбцов';
  SFixedRowTooBig = 'Число фиксированных строк должно быть меньше общего числа строк';
  SInvalidStringGridOp = 'Не могу вставить или удалить строки из таблицы (grid)';
  SParseError = '%s в строке %d';
  SIdentifierExpected = 'Ожидается идентификатор';
  SStringExpected = 'Ожидается строка';
  SNumberExpected = 'Ожидается число';
  SCharExpected = 'Ожидается ''''%s''''';
  SSymbolExpected = 'Ожидается %s';
{$ENDIF}
  SInvalidNumber = 'Неверное числовое значение';
{$IFDEF VER140}
  SInvalidString = 'Неверная строковая константа';
  SInvalidProperty = 'Неверное значение свойства';
  SInvalidBinary = 'Неверное двоичное значение';
{$ENDIF}
  SInvalidCurrentItem = 'Неверное значение для текущего элемента';
{$IFDEF VER140}
  SMaskErr = 'Введено неверное значение';
  SMaskEditErr = 'Введено неверное значение.  Нажмите Esc для отмены изменений';
{$ENDIF}

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

  srUnknown = '(Неизвестно)';
  srNone = '(Нет)';
  SOutOfRange = 'Значение должно быть между %d и %d';
  SCannotCreateName = 'Не могу создать имя метода по умолчанию для компонента без имени';
  SUnnamed = 'Безымянный';

{$IFDEF VER140}
  SDateEncodeError = 'Неверный аргумент для формирования даты';
  STimeEncodeError = 'Неверный аргумент для формирования времени';
  SInvalidDate = '''''%s'''' - неверная дата';
  SInvalidTime = '''''%s'''' - неверное время';
  SInvalidDateTime = '''''%s'''' - неверные дата и время';
  SInvalidFileName = 'Неверное имя файла - %s';
  SDefaultFilter = 'Все файлы (*.*)|*.*';
{$ENDIF}
  SInsertLineError = 'Невозможно вставить строку';

  SConfirmCreateDir = 'Указанная папка не существует. Создать ее?';
  SSelectDirCap = 'Выбор папки';
{$IFNDEF VER140}
  SCannotCreateDirName = 'Не могу создать папку "%s".';
  SAccessDeniedTo = 'Доступ к "%s" запрещен';
  SCannotReadDirectory = 'Не могу прочитать папку:' + sLineBreak + '"%s"';
  SDirectoryNotEmpty = 'Папка "%s" - не пустая.';
  SNotASubDir = '"%s" - не подкаталог "%s"';
{$ENDIF}
{$IFDEF VER140}
  SCannotCreateDir = 'Не могу создать папку';
{$ENDIF}
  SDirNameCap = '&Имя папки:';
  SDrivesCap = '&Устройства:';
  SDirsCap = '&Папки:';
  SFilesCap = '&Файлы: (*.*)';
  SNetworkCap = '&Сеть...';
{$IFNDEF VER140}
  SInvalidDirectory = 'Не могу прочитать папку "%s".';
  SNewFolder = 'Новая папка';
  SFileNameNotFound = '"%s"'#10'Файл не найден.';
  SAlreadyExists = 'Файл с таким именем уже существует. Пожалуйста, укажите '+
    'другое имя файла.';
  SConfirmDeleteTitle = 'Подтвеждение удаления файла';
  SConfirmDeleteMany = 'Вы уверены, что хотите удалить эти %d пункта(ов)?';
  SConfirmDeleteOne = 'Вы уверены, что хотите удалить "%s"?';
  SContinueDelete = 'Продолжить операцию удаления?';
  SAdditional = 'Дополнительно';
  SName = 'Имя';
  SSize = 'Размер';
  SType = 'Тип';
  SDate = 'Дата изменения';
  SAttributes = 'Атрибуты';
 {$IFDEF LINUX}
  SOwner = 'Хозяин';
  SGroup = 'Группа';
  SDefaultFilter = 'Все файлы (*)|*|';
 {$ENDIF}
 {$IFDEF MSWINDOWS}
  SPermissions = 'Атрибуты';
  SDefaultFilter = 'Все файлы (*.*)|*.*|';
  SVolume = 'Том';
  SFreeSpace = 'Свободно';
  SAnyKnownDrive = ' неизвестный диск';
  SMegs = '%d МБ';
 {$ENDIF}

  SDirectory = 'Папка';
  SFile = 'Файл';
  SLinkTo = 'Ссылка на ';
{$ENDIF}

  SInvalidClipFmt = 'Неверный формат буфера обмена';
  SIconToClipboard = 'Буфер обмена не поддерживает иконки';
  SCannotOpenClipboard = 'Не могу открыть буфер обмена';

{$IFDEF VER140}
  SInvalidActionRegistration = 'Неверная регистрация действия (action)';
  SInvalidActionUnregistration = 'Неверная отмена регистрации действия (action)';
  SInvalidActionEnumeration = 'Неверный перечень действий (action)';
  SInvalidActionCreation = 'Неверное создание действия (action)';
{$ENDIF}

  SDefault = 'Default';

  SInvalidMemoSize = 'Текст превысил емкость memo';
  SCustomColors = 'Custom Colors';
  SInvalidPrinterOp = 'Операция не поддерживается на выбранном принтере';
  SNoDefaultPrinter = 'Нет выбранного по умолчанию принтера';

{$IFDEF VER140}
  SIniFileWriteError = 'Не могу записать в %s';

  SBitsIndexError = 'Индекс Bits вышел за границы';
{$ENDIF}

  SUntitled = '(Без имени)';

  SDuplicateMenus = 'Меню ''%s'' уже используется другой формой';

  SPictureLabel = 'Картинка:';
  SPictureDesc = ' (%dx%d)';
  SPreviewLabel = 'Просмотр';
{$IFNDEF VER140}
  SNoPreview = 'Нет доступного Просмотра';
{$ENDIF}

  SBoldItalicFont = 'Bold Italic';
  SBoldFont = 'Bold';
  SItalicFont = 'Italic';
  SRegularFont = 'Regular';

  SPropertiesVerb = 'Свойства';

{$IFDEF VER140}
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

  SAllCommands = 'All Commands';

{$IFDEF VER140}
  SDuplicateItem = 'Список не допускает дубликатов ($0%x)';
{$ENDIF}

  SDuplicatePropertyCategory = 'Категория свойства, названная %s, уже создана';
  SUnknownPropertyCategory = 'Категория свойства не создана (%s)';

{$IFDEF VER140}
  SInvalidMask = '''%s'' - неверная маска в позиции %d';
{$ENDIF}
  SInvalidFilter = 'Фильтром свойств может быть только имя, класс или тип по базе (%d:%d)';
  SInvalidCategory = 'Категории должны определять свои имя и описание';

  sOperationNotAllowed = 'Операция не допустима во время отправки событий приложения';
  STextNotFound = 'Текст не найден: "%s"';

  SImageIndexError = 'Неверный индекс ImageList';
  SReplaceImage = 'Невозможно заменить изображение';
  SInvalidImageType = 'Неверный тип изображения';
  SInvalidImageDimensions = 'Ширина и высота изображения должны совпадать';
  SInvalidImageDimension = 'Неверное измерение изображения';
  SErrorResizingImageList = 'Ошибка изменения размеров ImageList';

  SInvalidRangeError = 'Диапазон от %d до %d - неверный';
  SInvalidMimeSourceStream = 'Формат MimeSource должен иметь связанный с данными поток (stream)';
  SMimeNotSupportedForIcon = 'Формат Mime не поддерживается для TIcon';

  SOpen = 'Открыть';
{$IFDEF VER140}
  SSave = 'Сохранить как';
{$ELSE}
  SSave = 'Сохранить';
  SSaveAs = 'Сохранить как';
{$ENDIF}
  SFindWhat = '&Найти:';
  SWholeWord = '&Только целые слова';
  SMatchCase = 'С у&четом регистра';
  SFindNext = 'Найти &далее';
  SCancel = 'Отмена';
  SHelp = 'Справка';
  SFindTitle = 'Поиск';
  SDirection = 'Направление';
  SUp = '&Вверх';
  SDown = 'Вн&из';
  SReplaceWith = 'За&менить на:';
  SReplace = '&Заменить';
  SReplaceTitle = 'Замена';
  SReplaceAll = 'Заменить в&се';
  SOverwriteCaption = 'Сохранить %s как';
{$IFDEF VER140}
  SOverwriteText = '%s уже создан.'#13'Хотите заменить его?';
  SFileMustExist = '%s'#13'Файл не найден.'#13'Пожалуйста, проверьте правильность '+
    'данного имени файла.';
  SPathMustExist = '%s'#13'Путь не найден.'#13'Пожалуйста, проверьте правильность '+
    'данного пути.';
{$ELSE}
  SOverwriteText = '"%s" уже создан.' + sLineBreak + 'Хотите заменить его?';
  SFileMustExist = '"%s"' + sLineBreak + 'Файл не найден.' + sLineBreak + 'Пожалуйста, проверьте правильность '+
    'данного имени файла.';
  SPathMustExist = '"%s"' + sLineBreak + 'Путь не найден.' + sLineBreak + 'Пожалуйста, проверьте правильность '+
    'данного пути.';
  SDriveNotFound = 'Диск %s не существует.' + sLineBreak + 'Пожалуйста, проверьте правильность '+
    'данного диска.';
{$ENDIF}

  SUnknownImageFormat = 'Формат изображения не распознан';
  SInvalidHandle = 'Неверное значение дескриптора (handle) для %s';
  SUnableToWrite = 'Не могу записать bitmap';
  sAllFilter = 'Все';

  sInvalidSetClipped = 'Не могу установить свойство Clipped во время рисования';

  sInvalidLCDValue = 'Неверное значение LCDNumber';

  sTabFailDelete = 'Не удалось удалить страницу (tab) с индексом %d';
  sPageIndexError = 'Неверное значение PageIndex (%d).  PageIndex должен быть ' +
    'между 0 и %d';
  sInvalidLevel = 'Присваивание неверного уровня элемента';
  sInvalidLevelEx = 'Неверный уровень (%d) для элемента "%s"';
  sTabMustBeMultiLine = 'MultiLine должно быть True, когда TabPosition равно tpLeft или tpRight';
  sStatusBarContainsControl = '%s уже в StatusBar';
  sListRadioItemBadParent = 'Пункты Radio должны иметь Controller как родителя';
  sOwnerNotCustomHeaderSections = 'Владелец - не TCustomHeaderSection';
  sHeaderSectionOwnerNotHeaderControl = 'Владелец Header Section должен быть TCustomHeaderControl';

  SUndo = 'Отменить';
  SRedo = 'Повторить';
  SLine = '-';
  SCut = 'Вырезать';
  SCopy = 'Копировать';
  SPaste = 'Вставить';
  SClear = 'Очистить';
  SSelectAll = 'Выбрать все';

{$IFNDEF VER140}
  SBadMovieFormat = 'Неизвестный видеоформат';
  SMovieEmpty = 'Видео не загружено';
  SLoadingEllipsis = 'Загрузка...';

  SNoAppInLib = 'Фатальная ошибка: Не могу создать объект приложения в разделенном (shared) объекте или библиотеке.';
  SDuplicateApp = 'Фатальная ошибка: Не могу создать более одного экземпляра TApplication';
{$ENDIF}
implementation

end.
