{  Русификация: 2001-02 Polaris Software                                      }
{               http://polesoft.da.ru                                         }

unit IdResourceStrings;

interface

resourcestring
  // General
  RSAlreadyConnected = 'Уже соединено.';
  RSByteIndexOutOfBounds = 'Индекс Byte вышел за границы.';
  RSCannotAllocateSocket = 'Не могу зарезервировать socket.';
  RSConnectionClosedGracefully = 'Соединение элегантно закрыто.';
  RSCouldNotBindSocket = 'Не могу привязать socket. Адрес и порт уже используются.';
  RSFailedTimeZoneInfo = 'Ошибка при попытке получить информацию о часовом поясе.';
  RSNoBindingsSpecified = 'Привязки не определены.';
  RSOnExecuteNotAssigned = 'OnExecute не определен.';
  RSNotAllBytesSent = 'Посланы не все байты.';
  RSNotEnoughDataInBuffer = 'Нет данных в буфере.';
  RSPackageSizeTooBig = 'Размер пакета слишком большой.';
  RSRawReceiveError0 = 'Ошибка приема Raw = 0.';
  RSICMPReceiveError0 = 'Ошибка приема ICMP = 0.';
  RSWinsockInitializationError = 'Ошибка инициализации Winsock.';
  RSCouldNotLoad = '%s не может быть загружен.';
  RSSetSizeExceeded = 'Установленный размер превышен.';
  RSThreadClassNotSpecified = 'Не определен класс потока (thread).';
  RSFileNotFound = 'Файл "%s" не найден';
  RSCannotChangeDebugTargetAtWhileActive = 'Не могу изменить приемник, когда он активен.';
  RSOnlyOneAntiFreeze = 'Может быть создан только один TIdAntiFreeze в приложении.';
  RSInterceptCircularLink = '%d: циклические ссылки не допустимы';
  RSInterceptPropIsNil = 'InterceptEnabled не может быть установлен в true когда Intercept равен nil.';
  RSIOHandlerPropInvalid = 'Значение IOHandler - неверное';
  RSNotConnected         = 'Не соединено';
  RSInterceptPropInvalid = 'Значение Intercept - неверное' {$IFDEF VER150}deprecated{$ENDIF}; 
  RSObjectTypeNotSupported = 'Тип объекта не поддерживается.';
  RSAcceptWaitCannotBeModifiedWhileServerIsActive
    = 'Свойство AcceptWait не может быть изменено, когда сервер активен.';
  RSTerminateThreadTimeout = 'Завершить тайм-аут потока';
  RSNoExecuteSpecified = 'Не найдено execute обработчиков.';
  RSIdNoDataToRead = 'Нет данных для чтения.';
  RSCanNotBindRange = 'Не могу связать в диапазоне портов (%d - %d)';
  RSInvalidPortRange = 'Неверный диапазон портов (%d - %d)';
  RSReadTimeout = 'Тайм-аут чтения';
  RSReadLnMaxLineLengthExceeded = 'Превышена макс. длина строки.';
  RSUDPReceiveError0 = 'Ошибка приема UDP = 0.';
  RSNoCommandHandlerFound = 'Дескрипторов команды не найдено.';
  RSCannotPerformTaskWhileServerIsActive = 'Не могу выполнить задачу, пока сервер активен.';
  //  TIdEMailAddress 
  RSEMailSymbolOutsideAddress = '@ внешний адрес';
  //ZLIB Intercept
  RSZLCompressorInitializeFailure = 'Не могу инициализировать компрессор';
  RSZLDecompressorInitializeFailure = 'Не могу инициализировать декомпрессор';
  RSZLCompressionError = 'Ошибка сжатия';
  RSZLDecompressionError = 'Ошибка распаковки';
  //Winsock 2 Stub
  RSWS2CallError = 'Ошибка вызова фнкции %s библиотеки Winsock2';
  RSWS2LoadError = 'Ошибка загрузки библиотеки Winsock2 (%s)';
  //MIME Types
  RSMIMEExtensionEmpty = 'Расширение - пустое';
  RSMIMEMIMETypeEmpty = 'Mimetype - пустое';
  RSMIMEMIMEExtAlreadyExists = 'Расширение уже существует';
  // IdRegister
  RSRegIndyClients = 'Indy Clients';
  RSRegIndyServers = 'Indy Servers';
  RSRegIndyIntercepts = 'Indy Intercepts';
  RSRegIndyIOHandlers = 'Indy I/O Handlers';
  RSRegIndyMisc = 'Indy Misc';
  // Status Strings
  RSStatusResolving = 'Поиск хоста %s.';
  RSStatusConnecting = 'Подключение к %s.';
  RSStatusConnected = 'Соединено.';
  RSStatusDisconnecting = 'Отсоединение от %s.';
  RSStatusDisconnected = 'Отсоединено.';
  RSStatusText = '%s';
  // TIdTCPClient
  RSConnectTimeout = 'Превышено время ожидания соединения.';
  //IdCoder3To4
  RSCoderNoTableEntryNotFound = 'Элемент таблицы кодировки не найден.' {$IFDEF VER150}deprecated{$ENDIF};
  // MessageClient Strings
  RSMsgClientEncodingText = 'Кодирование текста';
  RSMsgClientEncodingAttachment = 'Кодирование вложения';
  RSMsgClientUnkownMessagePartType = 'Неизвестный Message Part Type.';
  RSMsgClientInvalidEncoding = 'Неверное кодирование. UU позволено только с телом и вложениями';
  // NNTP Exceptions
  RSNNTPConnectionRefused = 'В соединении явно отказано NNTP сервером.';
  RSNNTPStringListNotInitialized = 'Stringlist не проинициализирован!';
  RSNNTPNoOnNewsgroupList = 'Не определено событие OnNewsgroupList.';
  RSNNTPNoOnNewGroupsList = 'Не определено событие OnNewGroupsList.';
  RSNNTPNoOnNewNewsList = 'Не определено событие OnNewNewsList.';
  // Log strings
  RSLogConnected = 'Соединено.';
  RSLogDisconnected = 'Отсоединено.';
  RSLogEOL = '<EOL>'; //End of Line
  RSLogCR  = '<CR>'; //Carriage Return
  RSLogLF  = '<LF>'; //Line feed
  RSLogRecv = 'Recv '; //Receive
  RSLogSent = 'Sent '; //Send
  RSLogStat = 'Stat '; //Status
  // HTTP Status
  RSHTTPChunkStarted = 'Кусок стартовал';
  RSHTTPContinue = 'Продолжение';
  RSHTTPSwitchingProtocols = 'Переключение протоколов';
  RSHTTPOK = 'OK';
  RSHTTPCreated = 'Создан';
  RSHTTPAccepted = 'Принят';
  RSHTTPNonAuthoritativeInformation = 'Ненадежная информация';
  RSHTTPNoContent = 'Нет содержимого';
  RSHTTPResetContent = 'Сброс содержимого';
  RSHTTPPartialContent = 'Частичное содержимое';
  RSHTTPMovedPermanently = 'Перемещен постоянно';
  RSHTTPMovedTemporarily = 'Перемещен временно';
  RSHTTPSeeOther = 'Смотри другое';
  RSHTTPNotModified = 'Не изменен';
  RSHTTPUseProxy = 'Исп. прокси';
  RSHTTPBadRequest = 'Неверный запрос';
  RSHTTPUnauthorized = 'Не авторизовано';
  RSHTTPForbidden = 'Запрещено';
  RSHTTPNotFound = 'Не найдено';
  RSHTTPMethodeNotallowed = 'Метод не допустим';
  RSHTTPNotAcceptable = 'Недопустимый';
  RSHTTPProxyAuthenticationRequired = 'Авторизация на прокси требуется';
  RSHTTPRequestTimeout = 'Request Timeout';
  RSHTTPConflict = 'Конфликт';
  RSHTTPGone = 'Готово';
  RSHTTPLengthRequired = 'Length требуется';
  RSHTTPPreconditionFailed = 'Ошибка Precondition';
  RSHTTPRequestEntityToLong = 'Request Entity To Long';
  RSHTTPRequestURITooLong = 'Request-URI слишком длинный. Максимум 256 символов';
  RSHTTPUnsupportedMediaType = 'Неподдерживаемый тип мультимедиа';
  RSHTTPInternalServerError = 'Внутренняя ошибка сервера';
  RSHTTPNotImplemented = 'Невыполненный';
  RSHTTPBadGateway = 'Неверный шлюз';
  RSHTTPServiceUnavailable = 'Сервис (служба) не доступен';
  RSHTTPGatewayTimeout = 'Таймаут шлюза';
  RSHTTPHTTPVersionNotSupported = 'Версия HTTP не поддерживается';
  RSHTTPUnknownResponseCode = 'Неизвестный код ответа';
  // HTTP Other
  RSHTTPHeaderAlreadyWritten = 'Заголовок уже написан.';
  RSHTTPErrorParsingCommand = 'Ошибка при разборе команды.';
  RSHTTPUnsupportedAuthorisationScheme = 'Неподдерживаемая схема авторизации.';
  RSHTTPCannotSwitchSessionStateWhenActive = 'Не могу изменить состояние сессии, когда сервер активен.';
  //HTTP Authentication
  RSHTTPAuthAlreadyRegistered = 'Этот метод авторизации уже зарегистрирован с классом %s.';
  //HTTP Authentication Digeest
  RSHTTPAuthInvalidHash = 'Неподдерживаемый hash алгоритм. Эта реализация поддерживает только кодирование MD5.';
  //SSPI Authentication
  {
  Note: CompleteToken is an API function Name:
  }
  RSHTTPSSPISuccess = 'Успешный вызов API';
  RSHTTPSSPINotEnoughMem = 'Нет свободной памяти для завершения этого запроса';
  RSHTTPSSPIInvalidHandle = 'Указанный дескриптор - неверный';
  RSHTTPSSPIFuncNotSupported = 'Требуемая функция не поддерживается';
  RSHTTPSSPIUnknownTarget = 'Указанный приемник (target) неизвестен или недостижим';
  RSHTTPSSPIInternalError = 'The Local Security Authority cannot be contacted';
  RSHTTPSSPISecPackageNotFound = 'Требуемый пакет защиты не существует';
  RSHTTPSSPINotOwner = 'The caller is not the owner of the desired credentials';
  RSHTTPSSPIPackageCannotBeInstalled = 'Пакет защиты вызвал сбой при инициализации, и не может быть установлен';
  RSHTTPSSPIInvalidToken = 'The token supplied to the function is invalid';
  RSHTTPSSPICannotPack = 'Пакет защиты не способен разместить буффер входа, таким образом, попытка входа была неудачной';
  RSHTTPSSPIQOPNotSupported = 'The per-message Quality of Protection не поддерживается пакетом защиты';
  RSHTTPSSPINoImpersonation = 'The security context does not allow impersonation of the client';
  RSHTTPSSPILoginDenied = 'Неудачная попытка входа';
  RSHTTPSSPIUnknownCredentials = 'Полномочия, данные пакету, не опознаны';
  RSHTTPSSPINoCredentials = 'No credentials are available in the security package';
  RSHTTPSSPIMessageAltered = 'The message or signature supplied for verification has been altered';
  RSHTTPSSPIOutOfSequence = 'The message supplied for verification is out of sequence';
  RSHTTPSSPINoAuthAuthority = 'No authority could be contacted for authentication.';
  RSHTTPSSPIContinueNeeded = 'Функция завершилась успешно, но должна быть вызвана снова для завершения контекста';
  RSHTTPSSPICompleteNeeded = 'Функция завершилась успешно, но должен быть вызван CompleteToken';
  RSHTTPSSPICompleteContinueNeeded =  'Функция завершилась успешно, но CompleteToken и эта функция должны быть вызваны для завершения контекста';
  RSHTTPSSPILocalLogin = 'Вход завершен, но нет доступных сетевых полномочий. Вход был сделан с использованием локально известной информации';
  RSHTTPSSPIBadPackageID = 'Требуемый пакет защиты не существует';
  RSHTTPSSPIContextExpired = 'Контекст потерял силу и не может далее использоваться.';
  RSHTTPSSPIIncompleteMessage = 'Данное сообщение - незавершенное.  Сигнатура не была проверена.';
  RSHTTPSSPIIncompleteCredentialNotInit =  'Данные полномочия - неполные, и не были проверены. Контекст не был инициализирован.';
  RSHTTPSSPIBufferTooSmall = 'Буффера, предоставленные функции, были слишком малы.';
  RSHTTPSSPIIncompleteCredentialsInit = 'Данные полномочия - неполные, и не были проверены. Дополнительная информация может быть получена из контекста.';
  RSHTTPSSPIRengotiate = 'The context data must be renegotiated with the peer.';
  RSHTTPSSPIWrongPrincipal = 'The target principal name is incorrect.';
  RSHTTPSSPINoLSACode = 'There is no LSA mode context associated with this context.';
  RSHTTPSSPITimeScew = 'Время на часах клиентской и серверной машин отличается.';
  RSHTTPSSPIUntrustedRoot = 'The certificate chain was issued by an untrusted authority.';
  RSHTTPSSPIIllegalMessage = 'Полученное сообщение было неожиданным или неверно отформатированным.';
  RSHTTPSSPICertUnknown = 'Неизвестная ошибка возникла во время обработки сертификата.';
  RSHTTPSSPICertExpired = 'Полученный сертификат потерял силу.';
  RSHTTPSSPIEncryptionFailure = 'Указанные данные не должны быть зашифрованы.';
  RSHTTPSSPIDecryptionFailure = 'Указанные данные не должны быть расшифрованы.';
  RSHTTPSSPIAlgorithmMismatch = 'Клиент и сервер не могут общаться, потому что они не обладают общим алгоритмом.';
  RSHTTPSSPISecurityQOSFailure = 'Контекст защиты не может быть созданe из-за сбоя в требуемом свойстве сервиса (например, взаимное опознавание или делегирование).';
  RSHTTPSSPIUnknwonError = 'Неизвестная ошибка';
  {
  Note to translators - the parameters for the next message are below:

  Failed Function Name
  Error Number
  Error Number
  Error Message by Number
  }

  RSHTTPSSPIErrorMsg = 'SSPI %s вернула ошибку #%d(0x%x): %s';

  RSHTTPSSPIInterfaceInitFailed = 'Интерфейс SSPI не смог инициализироваться правильно';
  RSHTTPSSPINoPkgInfoSpecified = 'PSecPkgInfo не указан';
  RSHTTPSSPINoCredentialHandle = 'No credential handle acquired';
  RSHTTPSSPICanNotChangeCredentials = 'Не могу изменить полномочия после handle aquired. Используйте сначала Release';
  RSHTTPSSPIUnknwonCredentialUse = 'Unknown credentials use';
  RSHTTPSSPIDoAuquireCredentialHandle = 'Сделайте сначала AcquireCredentialsHandle';
  RSHTTPSSPICompleteTokenNotSupported = 'CompleteAuthToken не поддерживается';

  //Block Cipher Intercept
  RSBlockIncorrectLength = 'Неправильный размер в принятом блоке';

  // FTP
  RSFTPUnknownHost = 'Неизвестен';
  RSInvalidFTPListingFormat = 'Неизвестный формат листинга FTP';
  RSFTPStatusReady = 'Соединение установлено';
  RSFTPStatusStartTransfer = 'Начало передачи по FTP';
  RSFTPStatusDoneTransfer  = 'Передача закончена';
  RSFTPStatusAbortTransfer = 'Передача прервана';

  // Property editor exceptions
  RSCorruptServicesFile = '%s поврежден.';
  RSInvalidServiceName = '%s - неверная служба.';
  // Stack Error Messages
  RSStackError = 'Ошибка socket # %d' + #13#10 + '%s';
  RSStackEINTR = 'Прерванный системный вызов.';
  RSStackEBADF = 'Неверный номер файла.';
  RSStackEACCES = 'В доступе отказано.';
  RSStackEFAULT = 'Неверный адрес.';
  RSStackEINVAL = 'Неверный аргумент.';
  RSStackEMFILE = 'Слишком много открытых файлов.';
  RSStackEWOULDBLOCK = 'Operation would block. ';
  RSStackEINPROGRESS = 'Операция сейчас выполняется.';
  RSStackEALREADY = 'Операция уже выполняется.';
  RSStackENOTSOCK = 'Socket операция на non-socket.';
  RSStackEDESTADDRREQ = 'Требуется адрес приемника.';
  RSStackEMSGSIZE = 'Сообщение слишком длинное.';
  RSStackEPROTOTYPE = 'Неверный тип протокола для socket.';
  RSStackENOPROTOOPT = 'Неверная опция протокола.';
  RSStackEPROTONOSUPPORT = 'Протокол не поддерживается.';
  RSStackESOCKTNOSUPPORT = 'Тип socket''а не поддерживается.';
  RSStackEOPNOTSUPP = 'Операция не поддерживается на socket.';
  RSStackEPFNOSUPPORT = 'Семейство протоколов не поддерживается.';
  RSStackEAFNOSUPPORT = 'Семейство адресов не поддерживается семейством протоколов.';
  RSStackEADDRINUSE = 'Адрес уже используется.';
  RSStackEADDRNOTAVAIL = 'Не могу присвоить требуемый адрес.';
  RSStackENETDOWN = 'Сеть не работает.';
  RSStackENETUNREACH = 'Сеть недоступна.';
  RSStackENETRESET = 'Сеть сбросила соединение.';
  RSStackECONNABORTED = 'Программное обеспечение вызвало аварийное прекращение работы соединения.';
  RSStackECONNRESET = 'Сброс соединения by peer.';
  RSStackENOBUFS = 'Нет доступного места для буфера.';
  RSStackEISCONN = 'Socket уже соединен.';
  RSStackENOTCONN = 'Socket не соединен.';
  RSStackESHUTDOWN = 'Не могу посылать и принимать после закрытия socket.';
  RSStackETOOMANYREFS = 'Слишком много отношений, не могу соединить.';
  RSStackETIMEDOUT = 'Соединение превысило время.';
  RSStackECONNREFUSED = 'Соединение прервано.';
  RSStackELOOP = 'Слишком много уровней символических ссылок.';
  RSStackENAMETOOLONG = 'Имя файла слишком длинное.';
  RSStackEHOSTDOWN = 'Хост не работает.';
  RSStackEHOSTUNREACH = 'Нет маршрута к хосту.';
  RSStackENOTEMPTY = 'Каталог не пуст';
  RSStackEPROCLIM = 'Слишком много процессов.';
  RSStackEUSERS = 'Слишком много пользователей.';
  RSStackEDQUOT = 'Превышен лимит места на диске.';
  RSStackESTALE = 'Устаревший дескриптор (handle) NFS файла.';
  RSStackEREMOTE = 'Слишком много уровней удаленных (remote) в пути.';
  RSStackSYSNOTREADY = 'Сетевая подсистема недоступна.';
  RSStackVERNOTSUPPORTED = 'Версия WINSOCK DLL вышла за границы.';
  RSStackNOTINITIALISED = 'Winsock еще не загружен.';
  RSStackHOST_NOT_FOUND = 'Хост не найден.';
  RSStackTRY_AGAIN = 'Ненадежный ответ (попытайтесь снова или проверьте настройки DNS).';
  RSStackNO_RECOVERY = 'Неисправляемые ошибки: FORMERR, REFUSED, NOTIMP.';
  RSStackNO_DATA = 'Верное имя, нет записи данных (проверьте настройки DNS).';

  RSCMDNotRecognized = 'команда не распознана';

  RSGopherNotGopherPlus = '%s - не сервер Gopher+';

  RSCodeNoError     = 'RCode НЕТ ошибки';
  RSCodeQueryFormat = 'DNS Server Reports Query Format Error';
  RSCodeQueryServer = 'DNS Server Reports Query Server Error';
  RSCodeQueryName   = 'DNS Server Reports Query Name Error';
  RSCodeQueryNotImplemented = 'DNS Server Reports Query Not Implemented Error';
  RSCodeQueryQueryRefused = 'DNS Server Reports Query Refused Error';
  RSCodeQueryUnknownError = 'Сервер возвратил неизвестную ошибку';

  RSDNSTimeout = 'TimedOut';
  RSDNSMFIsObsolete = 'MF - устаревшая команда. Используйте MX.';
  RSDNSMDISObsolete = 'MD - устаревшая команда. Используйте MX.';
  RSDNSMailAObsolete = 'MailA - устаревшая команда. Используйте MX.';
  RSDNSMailBNotImplemented = '-Err 501 MailB не выполнена';

  RSQueryInvalidQueryCount = 'Неверное число запросов %d';
  RSQueryInvalidPacketSize = 'Неверный размер пакета %d';
  RSQueryLessThanFour = 'Принятый пакет слишком мал. Менее 4 байт %d';
  RSQueryInvalidHeaderID = 'Неверный Id заголовка %d';
  RSQueryLessThanTwelve = 'Принятый пакет слишком мал. Менее 12 байт %d';
  RSQueryPackReceivedTooSmall = 'Принятый пакет слишком мал. %d';

  { LPD Client Logging event strings }
  RSLPDDataFileSaved = 'Файл данных сохранен в %s';
  RSLPDControlFileSaved = 'Контрольный файл сохранен в %s';
  RSLPDDirectoryDoesNotExist = 'Каталог %s не создан';
  RSLPDServerStartTitle = 'Winshoes LPD Server %s ';
  RSLPDServerActive = 'Сервер статус: активен';
  RSLPDQueueStatus = 'Статус очереди %s: %s';
  RSLPDClosingConnection = 'закрытие соединения';
  RSLPDUnknownQueue = 'Неизвестная очередь %s';
  RSLPDConnectTo = 'соединен с %s';
  RSLPDAbortJob = 'сброс работы';
  RSLPDReceiveControlFile = 'Прием контрольного файла';
  RSLPDReceiveDataFile = 'Прием файла данных';

  { LPD Exception Messages }
  RSLPDNoQueuesDefined = 'Ошибка: очереди не определены';

  { Trivial FTP Exception Messages }
  RSTimeOut = 'Таймаут';
  RSTFTPUnexpectedOp = 'Неожиданная операция из %s:%d';
  RSTFTPUnsupportedTrxMode = 'Неподдерживаемый режим передачи: "%s"';
  RSTFTPDiskFull = 'Не могу завершить запись запроса, процесс прерван на %d байтах';
  RSTFTPFileNotFound = 'Не могу открыть %s';
  RSTFTPAccessDenied = 'Доступ к %s запрещен';

  { MESSAGE Exception messages }
  RSTIdTextInvalidCount = 'Неверное количество Text. TIdText должен быть больше 1';
  RSTIdMessagePartCreate = 'TIdMessagePart не может быть создан.  Используйте классы-потомки. ';
  RSTIdMessageErrorSavingAttachment = 'Ошибка сохранения вложения.';

  { POP Exception Messages }
  RSPOP3FieldNotSpecified = ' не определен';
  RSPOP3UnrecognizedPOP3ResponseHeader = 'Unrecognized POP3 Response Header:'#10'"%s"'; //APR: user will see Server response    {Do not Localize}
  RSPOP3ServerDoNotSupportAPOP = 'Server do not support APOP (no timestamp)';//APR    {Do not Localize}

  { IdIMAP4 Exception Messages }
  RSIMAP4ConnectionStateError = 'Не могу выполнить команду, неверное состояние соединения;' +
                                 'Текущее состояние соединения: %s.';
  RSUnrecognizedIMAP4ResponseHeader = 'Неопознанный заголовок ответа IMAP4.';

  { IdIMAP4 Connection State strings }
  RSIMAP4ConnectionStateAny = 'Любой';
  RSIMAP4ConnectionStateNonAuthenticated = 'Неопознанный';
  RSIMAP4ConnectionStateAuthenticated = 'Опознанный';
  RSIMAP4ConnectionStateSelected = 'Выбранный';

  { Telnet Server }
  RSTELNETSRVUsernamePrompt = 'Имя: ';
  RSTELNETSRVPasswordPrompt = 'Пароль: ';
  RSTELNETSRVInvalidLogin = 'Неверный вход в систему.';
  RSTELNETSRVMaxloginAttempt = 'Превышено число разрешенных попыток входа, до свидания.';
  RSTELNETSRVNoAuthHandler = 'Не определен обработчик идентификации.';
  RSTELNETSRVWelcomeString = 'Indy Telnet Server';
  RSTELNETSRVOnDataAvailableIsNil = 'Событие OnDataAvailable равно nil.';

  { Telnet Client }
  RSTELNETCLIConnectError = 'сервер не отвечает';
  RSTELNETCLIReadError = 'Сервер не ответил.';

  { Network Calculator }
  RSNETCALInvalidIPString     = 'Строка %s не переводится в правильный IP.';
  RSNETCALCInvalidNetworkMask = 'Неверная маска сети.';
  RSNETCALCInvalidValueLength = 'Неверная длина значения: Должно быть 32.';
  RSNETCALConfirmLongIPList = 'Слишком много IP адресов в указанном диапазоне (%d) отобразится в design time.';
  { IdentClient}
  RSIdentReplyTimeout = 'Истекло время ожидания ответа:  Сервер не возвратил ответ и запрос был отвергнут';
  RSIdentInvalidPort = 'Неверный порт:  Внешний или локальный порт неправильно определен или неверный';
  RSIdentNoUser = 'Нет пользователя:  Пара портов не используется или не используется опознанным пользователем';
  RSIdentHiddenUser = 'Невидимый пользователь:  Информация не была возвращена по запросу пользователя';
  RSIdentUnknownError = 'Неизвестная или другая ошибка: Не могу определить владельца, либо ошибка, или необнаруженная ошибка.';
  { About Box stuff }
  RSAAboutFormCaption = 'О Indy';
  RSAAboutBoxCompName = 'Internet Direct (Indy)';
  RSAAboutMenuItemName = 'О Internet &Direct (Indy) %s...';
  RSAAboutBoxVersion = 'Версия %s';
  RSAAboutBoxCopyright = 'Copyright (c) 1993 - 2002'#13#10
   + 'Kudzu (Chad Z. Hower)'#13#10
   + 'и'#13#10
   + 'Indy Pit Crew';
  RSAAboutBoxPleaseVisit = 'Для получения обновлений и информации посетите, пожалуйста:';
  RSAAboutBoxIndyWebsite = 'http://www.nevrona.com/indy/';    {Do not Localize}
  RSAAboutCreditsCoordinator = 'Координатор проекта';
  RSAAboutCreditsCoCordinator = 'СоКоординатор проекта';
  RSAAboutCreditsDocumentation = 'Координатор документации';
  RSAAboutCreditsDemos = 'Координатор демо';
  RSAAboutCreditsDistribution = 'Координатор дистрибуции';
  RSAAboutCreditsRetiredPast = 'Ушедшие/Прошлые помощники';
  RSAAboutOk = 'OK';
  {Binding Editor stuff}
  {
  Note to translators - Please Read!!!

  For all the constants except RSBindingFormCaption, there may be an
  & symbol before a letter or number.  This is rendered as that chractor being
  underlined.  In addition, the charactor after the & symbol along with the ALT
  key enables a user to move to that control.  Since these are on one form, be
  careful to ensure that the same letter or number does not have a & before it
  in more than one string, otherwise an ALT key sequence will be broken.

  }
  RSBindingFormCaption = 'Редактор связей';
  RSBindingAddCaption = '&Добавить';
  RSBindingRemoveCaption = '&Удалить';
  RSBindingLabelBindings = '&Связи';
  RSBindingHostnameLabel = '&IP адрес';
  RSBindingPortLabel = '&Порт';
  RSBindingOkButton = 'OK';
  RSBindingCancel   = 'Отмена';
  {}
  RSBindingAll = 'Все'; //all IP addresses
  RSBindingAny = 'Любой'; //any port
 { Tunnel messages }
  RSTunnelGetByteRange = 'Вызов к %s.GetByte [property байт] с индексом <> [0..%d]';
  RSTunnelTransformErrorBS = 'Ошибка в преобразовании перед посылкой';
  RSTunnelTransformError = 'Ошибка преобразования';
  RSTunnelCRCFailed = 'Ошибка CRC';
  RSTunnelConnectMsg = 'Подключение';
  RSTunnelDisconnectMsg = 'Отключение';
  RSTunnelConnectToMasterFailed = 'Не могу подключиться к Master серверу';
  RSTunnelDontAllowConnections = 'Сейчас не разрешены соединения';
  RSTunnelMessageTypeError = 'Ошибка распознания типа сообщения';
  RSTunnelMessageHandlingError = 'Ошибка обработки сообщения';
  RSTunnelMessageInterpretError = 'Ошибка интерпретации сообщения';
  RSTunnelMessageCustomInterpretError = 'Ошибка интерпретации произвольного сообщения';

  { Socks messages }
  RSSocksRequestFailed = 'Запрос отвергнут или не выполнен.';
  RSSocksRequestServerFailed =
    'Запрос отвергнут, потому что SOCKS сервер не может соединиться.';
  RSSocksRequestIdentFailed =
    'Запрос отвергнут, потому что программа-клиент и identd report different user-ids.';
  RSSocksUnknownError = 'Неизвестная ошибка socks.';
  RSSocksServerRespondError = 'Socks сервер не отвечает.';
  RSSocksAuthMethodError = 'Неверный метод socks аутентификации.';
  RSSocksAuthError = 'Ошибка аутентификации на socks сервере.';
  RSSocksServerGeneralError = 'Общая ошибка SOCKS сервера.';
  RSSocksServerPermissionError = 'Соединение не разрешено набором правил (ruleset).';
  RSSocksServerNetUnreachableError = 'Сеть недоступна.';
  RSSocksServerHostUnreachableError = 'Хост недоступен.';
  RSSocksServerConnectionRefusedError = 'Соединение прервано.';
  RSSocksServerTTLExpiredError = 'TTL истекло.';
  RSSocksServerCommandError = 'Команда не поддерживается.';
  RSSocksServerAddressError = 'Тип адреса не поддерживается.';

  { FTP }
  RSDestinationFileAlreadyExists = 'Файл-приемник уже создан.';

  { SSL messages }
  RSSSLAcceptError = 'Ошибка допуска соединения с SSL.';
  RSSSLConnectError = 'Ошибка соединения с SSL.';
  RSSSLSettingCipherError = 'Ошибка SetCipher.';
  RSSSLSettingChiperError = 'Ошибка SetCipher.' {$IFDEF VER150}deprecated{$ENDIF};
  RSSSLCreatingContextError = 'Ошибка создания SSL контекста.';
  RSSSLLoadingRootCertError = 'Не могу загрузить root сертификат.';
  RSSSLLoadingCertError = 'Не могу загрузить сертификат.';
  RSSSLLoadingKeyError = 'Не могу загрузить ключ, проверьте пароль.';
  RSSSLGetMethodError = 'Ошибка получения SSL метода.';
  RSSSLDataBindingError = 'Ошибка привязки данных к SSL socket.';
  {IdMessage Component Editor}
  RSMsgCmpEdtrNew = '&New Message Part...';
  RSMsgCmpEdtrExtraHead = 'Extra Headers Text Editor';
  RSMsgCmpEdtrBodyText = 'Body Text Editor';
  {IdICMPClient}
  RSICMPNotEnoughtBytes = 'Получены не все байты';
  RSICMPNonEchoResponse = 'Non-echo type response received';
  RSICMPWrongDestination = 'Received someone else''s packet';
  {IdNNTPServer}
  RSNNTPServerNotRecognized = 'Команда не распознана';
  RSNNTPServerGoodBye = 'До свидания';
  {IdGopherServer}
  RSGopherServerNoProgramCode = 'Ошибка: Нет кода программы, чтобы возвратить запрос!';

  {IdSyslog}
  RSInvalidSyslogPRI = 'Неверное сообщение syslog: неверная секция PRI';
  RSInvalidSyslogPRINumber = 'Неверное сообщение syslog: неверный номер PRI "%s"';
  RSInvalidSyslogTimeStamp = 'Неверное сообщение syslog: неверный timestamp "%s"';
  RSInvalidSyslogPacketSize = 'Неверное сообщение syslog: пакет слишком большой (%d байта(ов))';
  RSInvalidHostName = 'Неверное имя хоста. Имя хоста SYSLOG не может содержать пробелов ("%s")+';

  {IdOpenSSL}
  RSOSSLModeNotSet = 'Режим не установлен.';
  RSOSSLCouldNotLoadSSLLibrary = 'Не могу загрузить библиотеку SSL.';
  RSOSSLStatusString = 'Статус SSL: "%s"';
  RSOSSLConnectionDropped = 'SSL соединение прервано.';
  RSOSSLCertificateLookup = 'Ошибка запроса сертификата SSL.';
  RSOSSLInternal = 'Внутренняя ошибка библиотеки SSL.';

  {IdWinsockStack}
  RSWSockStack = 'Winsock stack';
  {IdSMTPServer}
  RSSMTPSvrCmdNotRecognized = 'Команда не распознана';
  RSSMTPSvrQuit = 'Выход';
  RSSMTPSvrOk   = 'OK';
  RSSMTPSvrStartData = 'Начало ввода письма; конец с <CRLF>.<CRLF>';
  RSSMTPSvrAddressOk = '%s адрес OK';
  RSSMTPSvrAddressError = '%s ошибка адреса';
  RSSMTPSvrAddressWillForward = 'Пользователь не локальный, будет передано далее';
  RSSMTPSvrWelcome = 'Добро пожаловать в INDY SMTP Сервер';
  RSSMTPSvrHello = 'Здравствуйте, %s';
  RSSMTPSvrNoHello = 'Вежливые люди говорят HELO';
  RSSMTPSvrCmdGeneralError = 'Синтаксическая ошибка - Команда не понята: %s';
  RSSMTPSvrXServer = 'Indy SMTP Сервер';
  RSSMTPSvrReceivedHeader = 'by DNSName [127.0.0.1] running Indy SMTP';
  RSSMTPSvrAuthFailed = 'В авторизации отказано';
  {IdPOP3Server}
  RSPOP3SvrNotHandled = 'Команда не обработана: %s';
  // TIdCoder3to4
  RSUnevenSizeInDecodeStream = 'Нечетный размер в DecodeToStream.';
  RSUnevenSizeInEncodeStream = 'Нечетный размер в Encode.';
  // TIdMessageCoder
  RSMessageDecoderNotFound = 'Декодер сообщения не найден';
  RSMessageEncoderNotFound = 'Кодировщик сообщения не найден';
  // TIdMessageCoderMIME
  RSMessageCoderMIMEUnrecognizedContentTrasnferEncoding = 'Неопознанное кодирование содержание передачи.';
  // TIdMessageCoderUUE
  RSUnrecognizedUUEEncodingScheme = 'Неопознанное схема UUE кодирования.';
  // TIdICMPCast
  RSIPMCastInvalidMulticastAddress = 'Данный IP адрес - неверный групповой адрес [224.0.0.0 - 239.255.255.255].';
  RSIPMCastNotSupportedOnWin32 = 'Эта функция не поддерживается на Win32.';
  { IdFTPServer }
  RSFTPDefaultGreeting = 'Indy FTP Сервер готов.';
  RSFTPOpenDataConn = 'Соединение для данных уже открыто; передача начинается.';
  RSFTPDataConnToOpen = 'Статус файла OK; about to open data connection.';
  RSFTPCmdSuccessful = '%s Команда успешно выполнена.';
  RSFTPServiceOpen = 'Сервис готов для пового пользователя.';
  RSFTPServerClosed = 'Сервис закрывает управляющее соединение.';
  RSFTPDataConn = 'Открыто соединение для данных; нет передачи.';
  RSFTPDataConnClosed = 'Закрытие соединения для данных.';
  RSFTPDataConnClosedAbnormally = 'Соединение для данных закрыто аварийно.';
  RSFTPPassiveMode = 'Вход в пассивный режим (%s).';
  RSFTPUserLogged = 'Пользователь вошел, продолжаем.';
  RSFTPAnonymousUserLogged = 'Анонимный пользователь вошел, продолжаем.';
  RSFTPFileActionCompleted = 'Требуемое действие с файлом OK, завершено.';
  RSFTPDirFileCreated = '"%s" создан.';
  RSFTPUserOkay = 'Имя пользователя OK, требуется пароль.';
  RSFTPAnonymousUserOkay = 'Анонимный вход OK, посылается e-mail как пароль.';
  RSFTPNeedLoginWithUser = 'Войдите с USER сначала.';
  RSFTPNeedAccountForLogin = 'Требуется учетная запись для входа.';
  RSFTPFileActionPending = 'Требуемое действие с файлом в ожидании дополнительной информации.';
  RSFTPServiceNotAvailable = 'Сервис не доступен, закрытие управляющего соединения.';
  RSFTPCantOpenDataConn = 'Не могу открыть соединение для данных.';
  RSFTPFileActionNotTaken = 'Требуемое действие с файлом не taken.';
  RSFTPFileActionAborted = 'Требуемое действие прервано: локальная ошибка в процессе.';
  RSFTPRequestedActionNotTaken = 'Требуемое действие не taken.';
  RSFTPCmdSyntaxError = 'Синтаксическая ошибка, команда не распознана.';
  RSFTPCmdNotImplemented = '"%s" Команда не реализована.';
  RSFTPUserNotLoggedIn = 'Не вошел.';
  RSFTPNeedAccForFiles = 'Требуется учетная запись для сохранения файлов.';
  RSFTPActionNotTaken = 'Требуемое действие не taken.';
  RSFTPActionAborted = 'Требуемое действие прервано: тип страницы неизвестен.';
  RSFTPRequestedFileActionAborted = 'Требуемое действие с файлом прервано.';
  RSFTPRequestedFileActionNotTaken = 'Требуемое действие не taken.';
  RSFTPMaxConnections = 'Превышен лимит количества соединений. Попробуйте снова позже.';
  //Note to translators, it may be best to leave the stuff in quotes as the very first
  //part of any phrase otherwise, a FTP client might get confused.
  RSFTPCurrentDirectoryIs = '"%s" -  - рабочая папка.';
  RSFTPTYPEChanged = 'Тип установлен в %s.';
  RSFTPMODEChanged = 'Режим установлен в %s.';
  RSFTPSTRUChanged = 'Structure set to %s.';
  RSFTPSITECmdsSupported = 'Следующие SITE команды не поддерживаются:' +
                            #13 + ' HELP  DIRSTYLE';
  RSFTPDirectorySTRU = '%s структура каталогов.';
  RSFTPCmdEndOfStat = 'Конец статуса';
  RSFTPCmdExtsSupported = 'Поддерживаются расширения:'#13#10'SIZE'#13#10'PASV'#13#10'REST'#13#10'Конец расширений.';

  RSFTPNoOnDirEvent = 'Не найдено события OnListDirectory!';

  {SYSLog Message}
  // facility
  STR_SYSLOG_FACILITY_KERNEL     = 'сообщения ядра';
  STR_SYSLOG_FACILITY_USER       = 'сообщения уровня пользователя';
  STR_SYSLOG_FACILITY_MAIL       = 'почтовая система';
  STR_SYSLOG_FACILITY_SYS_DAEMON = 'системные демоны';
  STR_SYSLOG_FACILITY_SECURITY1  = 'сообщения защиты/авторизации (1)';
  STR_SYSLOG_FACILITY_INTERNAL   = 'сообщения, созданные внутри syslogd';
  STR_SYSLOG_FACILITY_LPR        = 'подсистема строкового принтера';
  STR_SYSLOG_FACILITY_NNTP       = 'подсистема сетевых новостей';
  STR_SYSLOG_FACILITY_UUCP       = 'подсистема UUCP';
  STR_SYSLOG_FACILITY_CLOCK1     = 'демон часов (1)';
  STR_SYSLOG_FACILITY_SECURITY2  = 'сообщения защиты/авторизации (2)';
  STR_SYSLOG_FACILITY_FTP        = 'демон FTP';
  STR_SYSLOG_FACILITY_NTP        = 'подсистема NTP';
  STR_SYSLOG_FACILITY_AUDIT      = 'лог аудит';
  STR_SYSLOG_FACILITY_ALERT      = 'log alert';
  STR_SYSLOG_FACILITY_CLOCK2     = 'демон часов (2)';
  STR_SYSLOG_FACILITY_LOCAL0     = 'local use 0  (local0)';
  STR_SYSLOG_FACILITY_LOCAL1     = 'local use 1  (local1)';
  STR_SYSLOG_FACILITY_LOCAL2     = 'local use 2  (local2)';
  STR_SYSLOG_FACILITY_LOCAL3     = 'local use 3  (local3)';
  STR_SYSLOG_FACILITY_LOCAL4     = 'local use 4  (local4)';
  STR_SYSLOG_FACILITY_LOCAL5     = 'local use 5  (local5)';
  STR_SYSLOG_FACILITY_LOCAL6     = 'local use 6  (local6)';
  STR_SYSLOG_FACILITY_LOCAL7     = 'local use 7  (local7)';
  STR_SYSLOG_FACILITY_UNKNOWN    = 'Неизвестный или недопустимый код устройства';

  // Severity
  STR_SYSLOG_SEVERITY_EMERGENCY     = 'Авария: система непригодна для использования';
  STR_SYSLOG_SEVERITY_ALERT         = 'Тревога: действие должно быть taken немедленно';
  STR_SYSLOG_SEVERITY_CRITICAL      = 'Опасность: состояние опасности';
  STR_SYSLOG_SEVERITY_ERROR         = 'Ошибка: состояние ошибки';
  STR_SYSLOG_SEVERITY_WARNING       = 'Предупреждение: состояние предупреждения';
  STR_SYSLOG_SEVERITY_NOTICE        = 'Замечание: нормальное, но важное состояние';
  STR_SYSLOG_SEVERITY_INFORMATIONAL = 'Информационно: информационные сообщения';
  STR_SYSLOG_SEVERITY_DEBUG         = 'Отладка: сообщения уровня отладки';
  STR_SYSLOG_SEVERITY_UNKNOWN       = 'Неизвестный или недопустимый код защиты';

  {LPR Messages}
  RSLPRError = 'Ответить %s на Job ID %s';
  RSLPRUnknown = 'Неизвестен';

  {IRC Messages}
  RSIRCCanNotConnect = 'Соединение к IRC не установлено';
  RSIRCNotConnected = 'Не подключено к серверу.';
  RSIRCClientVersion =  'TIdIRC 1.061 by Steve Williams';
  RSIRCClientInfo = '%s Не визульный компонент для 32-бит Delphi.';
  RSIRCNick = 'Nick';
  RSIRCAltNick = 'OtherNick';
  RSIRCUserName = 'username';
  RSIRCRealName = 'Реальное имя';
  RSIRCTimeIsNow = 'Локальное время - %s';

  {HL7 Lower Layer Protocol Messages}
  RSHL7StatusStopped           = 'Остановлен';
  RSHL7StatusNotConnected      = 'Не соединен';
  RSHL7StatusFailedToStart     = 'Ошибка старта: %s';
  RSHL7StatusFailedToStop      = 'Ошибка остановки: %s';
  RSHL7StatusConnected         = 'Соединен';
  RSHL7StatusConnecting        = 'Соединение';
  RSHL7StatusReConnect         = 'Reconnect at %s: %s';
  RSHL7NotWhileWorking         = 'Вы не можете установить %s, пока компонент HL7 работает';
  RSHL7NotWorking              = 'Попытка %s, пока компонент HL7 работает';
  RSHL7NotFailedToStop         = 'Интерфейс неиспользуемый из-за ошибки при остановке';
  RSHL7AlreadyStarted          = 'Интерфейс уже запущен';
  RSHL7AlreadyStopped          = 'Интерфейс уже остановлен';
  RSHL7ModeNotSet              = 'Режим не инициализирован';
  RSHL7NoAsynEvent             = 'Компонент в асинхронном режиме, но OnMessageArrive не привязан';
  RSHL7NoSynEvent              = 'Компонент в синхронном режиме, но OnMessageReceive не привязан';
  RSHL7InvalidPort             = 'Определенный значение Port %d - неверное';
  RSHL7ImpossibleMessage       = 'Сообщение было принято, но режим передачи неизвестен';
  RSHL7UnexpectedMessage       = 'Неожиданное сообщение прибыло на интерфейс, который не опрашивается';
  RSHL7UnknownMode             = 'Неизвестный режим';
  RSHL7ClientThreadNotStopped  = 'Не могу остановить клиентский поток';
  RSHL7SendMessage             = 'Отправить сообщение';
  RSHL7NoConnectionFound       = 'Server Connection not locatable, когда отправляется сообщение';
  RSHL7WaitForAnswer           = 'Вы не можете отправить сообщение, когда Вы ожидаете ответ';

  { MultipartFormData }
  RSMFDIvalidObjectType        = 'Неподдерживаемый тип объекта. Вы можете определить только один из следующих типов или их потомков: TStrings, TStream.';
  { TIdURI exceptions }
  RSURINoProto                 = 'Поле Protocol - пустое';
  RSURINoHost                  = 'Поле Host - пустое';
  { TIdIOHandlerThrottle}
  RSIHTChainedNotAssigned      = 'Вы должны связать этот компонент с другим I/O Handler перед его использованием';
  { TIdSNPP}
  RSSNPPNoMultiLine            = 'TIdSNPP Mess команда поддерживает только однострочные сообщения.';
  {TIdThread}
  RSThreadTerminateAndWaitFor  = 'Не могу вызвать TerminateAndWaitFor на FreeAndTerminate потоках';
  {IdLogBase}
  //RSLogRecV = 'Полч: ' {$IFDEF VER150}deprecated{$ENDIF};
  //RSLogSent = 'Посл: ' {$IFDEF VER150}deprecated{$ENDIF};
 // RSLogEOL  = '<EOL>'  {$IFDEF VER150}deprecated{$ENDIF};

implementation

end.
