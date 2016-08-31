
{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{       XML RTL Constants                               }
{                                                       }
{ Copyright (c) 2002 Borland Software Corporation       }
{                                                       }
{  Русификация: 2002 Polaris Software                   }
{               http://polesoft.da.ru                   }
{*******************************************************}

unit XMLConst;

interface

resourcestring
  { xmldom.pas }
  SDuplicateRegistration = '"%s" DOMImplementation уже зарегистрирован';
  SNoMatchingDOMVendor = 'Нет подходящего DOM Vendor: "%s"';
  SNoDOMNodeEx = 'Выбранный DOM Vendor не поддерживает это свойство или метод';
  SDOMNotSupported = 'Свойство или метод "%s" не поддерживается DOM Vendor "%s"';

  { msxmldom.pas }
  SNodeExpected = 'Узел не может быть пустым (null)';
  SMSDOMNotInstalled = 'Microsoft MSXML не установлен';

  { oxmldom.pas }
  {$IFDEF MSWINDOWS}
  SErrorDownloadingURL = 'Ошибка загрузки URL: %s';
  SUrlMonDllMissing = 'Не могу загрузить %s';
  {$ENDIF}
  SNotImplemented = 'Это свойство или метод не реализован в Open XML Parser';

  { xercesxmldom.pas }
  SINDEX_SIZE_ERR = 'Неверное смещение в строке';
  SDOMSTRING_SIZE_ERR = 'Неверный размер DOMString';
  SHIERARCHY_REQUEST_ERR = 'Не могу вставить дочерний узел';
  SWRONG_DOCUMENT_ERR = 'Узлом владеет другой документ';
  SINVALID_CHARACTER_ERR = 'Неверный символ в имени';
  SNO_DATA_ALLOWED_ERR = 'No data allowed'; // not used
  SNO_MODIFICATION_ALLOWED_ERR = 'Изменения не допустимы (данные только для чтения)';
  SNOT_FOUND_ERR = 'Узел не найден';
  SNOT_SUPPORTED_ERR = 'Не поддерживается';
  SINUSE_ATTRIBUTE_ERR = 'Атрибут уже связан с другим элементом';
  SINVALID_STATE_ERR = 'Неверное состояние';
  SSYNTAX_ERR = 'Неверный синтаксис';
  SINVALID_MODIFICATION_ERR = 'Invalid modification';  // not used
  SNAMESPACE_ERR = 'Неверный запрос namespace';
  SINVALID_ACCESS_ERR = 'Invalid access'; // not used

  SBadTransformArgs = 'TransformNode должен быть вызван, используя узел документа (не элемент документа) для источника и stylesheet.';
  SErrorWritingFile = 'Ошибка создания файла "%s"';
  SUnhandledXercesErr = 'Unhandled Xerces DOM ошибка (сообщение не доступно): %d';
  SDOMError = 'Ошибка DOM: ';
  {$IFDEF LINUX}
  SErrorLoadingLib = 'Ошибка загрузки библиотеки "%s": "%s"';
  {$ENDIF}

  { XMLDoc.pas }
  SNotActive = 'Нет активного документа';
  SNodeNotFound = 'Узел "%s" не найден';
  SMissingNode = 'IDOMNode требуется';
  SNoAttributes = 'Атрибуты не поддерживаются на этом типе узла';
  SInvalidNodeType = 'Неверный тип узла';
  SMismatchedRegItems = 'Несовпадающие параметры к RegisterChildNodes';
  SNotSingleTextNode = 'Элемент не содержит единственный текстовый узел';
  SNoDOMParseOptions = 'Реализация DOM не поддерживает IDOMParseOptions';
  SNotOnHostedNode = 'Неверная операция на hosted узле';
  SMissingItemTag = 'Свойство ItemTag не инициализировано';
  SNodeReadOnly = 'Узел только для чтения';
  SUnsupportedEncoding = 'Кодирование неподдерживаемого символа "%s", повторите с использованием LoadFromFile';
  SNoRefresh = 'Refresh поддерживается только, если установлены свойства FileName или XML';
  SMissingFileName = 'FileName не может быть пустым';
  SLine = 'Line';
  SUnknown = 'Неизвестно';

  { XMLSchema.pas }
  SInvalidSchema = 'Неверный или неподдерживаемый документ XML Schema';
  SNoLocalTypeName = 'Объявления локального типа не могут иметь имя.  Элемент: %s';
  SUnknownDataType = 'Неизвестный тип данных "%s"';
  SInvalidValue = 'Неверное %s значение: "%s"';
  SInvalidGroupDecl = 'Неверное group объявление в "%s"';
  SMissingName = 'Потеряно имя типа';
  SInvalidDerivation = 'Неверное решение комплексного типа: %s';
  SNoNameOnRef = 'Имя не допускается на ref item';
  SNoGlobalRef = 'Пункты глобальной схемы не могут содержать ref';
  SNoRefPropSet = '%s не может быть установлено на ref item';
  SSetGroupRefProp = 'Установить свойство GroupRef для cmGroupRef content model';
  SNoContentModel = 'ContentModel не установлена';
  SNoFacetsAllowed = 'Facets и Enumeration не допустимы на этом типе данных "%s"';
  SNotBuiltInType = 'Неверное имя встроенного типа "%s"';
  SBuiltInType = 'Встроенный тип';

  { XMLDataToSchema.pas }
  SXMLDataTransDesc = 'Транслятор XMLData в XML Schema (.xml -> .xsd)';

  { XMLSchema99.pas }
  S99TransDesc = 'Транслятор 1999 XML Schema (.xsd <-> .xsd)';

  { DTDSchema.pas }
  SDTDTransDesc = 'Транслятор DTD в XML Schema (.dtd <-> .xsd)';

  { XDRSchema.pas }
  SXDRTransDesc = 'Транслятор XDR в XML Schema (.xdr <-> .xsd)';

  
implementation

end.
