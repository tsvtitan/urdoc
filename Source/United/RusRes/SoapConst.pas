{*******************************************************}
{                                                       }
{ Borland Delphi Visual Component Library               }
{                SOAP Support                           }
{                                                       }
{ Copyright (c) 2001 Borland Software Corporation       }
{                                                       }
{  Русификация: 2001-02 Polaris Software                }
{               http://polesoft.da.ru                   }
{*******************************************************}

unit SOAPConst;

interface

uses TypInfo, XMLSchema;

const

{$IFNDEF VER140}
  SHTTPPrefix = 'http://';                                     { Do not localize }
  SContentId = 'Content-ID';                                   { Do not localize }
  SContentLocation = 'Content-Location';                       { Do not localize }
  SContentLength = 'Content-Length';                           { Do not localize }
  SContentType = 'Content-Type';                               { Do not localize }

  SWSDLMIMENamespace = 'http://schemas.xmlsoap.org/wsdl/mime/';{ Do not location }
  SBorlandMimeBoundary = 'MIME_boundaryB0R9532143182121';
  SSoapXMLHeader = '<?xml version="1.0" encoding=''UTF-8''?>'; { Do not localize }
  SUTF8 = 'UTF-8';                                             { Do not localize }
  ContentTypeTemplate = 'Content-Type: %s';                    { Do not localize }
  ContentTypeApplicationBinary = 'application/binary';         { Do not localize }
  SBinaryEncoding = 'binary';                                  { Do not localize }
  S8BitEncoding   = '8bit';                                    { Do not localize }
  ContentTypeTextPlain = 'text/plain';                         { Do not localize }
  SCharacterEncodingFormat = 'Content-transfer-encoding: %s';  { Do not localize }
  SCharacterEncoding = 'Content-transfer-encoding';            { Do not localize }
  SBoundary = 'boundary=';                                     { Do not localize }
  SMultiPartRelated = 'multipart/related';                     { Do not localize }
  SMultiPartRelatedNoSlash = 'multipartRelated';               { Do not localize }
  ContentHeaderMime = SMultiPartRelated + '; boundary=%s';     { Do not localize }
  SStart = '; start="<%s>"';                                   { Do not localize}
  SBorlandSoapStart = 'http://www.borland.com/rootpart.xml';   { Do not localize}
  SAttachmentIdPrefix = 'cid:';                                { Do not localize }

  MimeVersion = 'MIME-Version: 1.0';
{$ELSE}
  SSoapXMLHeader = '<?xml version="1.0" encoding=''UTF-8''?>'; { do not localize}
  SUTF8 = 'UTF-8';                                             { Do not localize}
  ContentHeaderUTF8 = 'Content-Type: text/xml; charset="utf-8"';        { Do not localize }
  ContentHeaderNoUTF8 = 'Content-Type: text/xml';                       { Do not localize }
{$ENDIF}
  sTextHtml = 'text/html';                                 { Do not localize }
  sTextXML  = 'text/xml';                                  { Do not localize }

  ContentTypeUTF8 = 'text/xml; charset="utf-8"';           { Do not localize }
  ContentTypeNoUTF8 = 'text/xml';                          { Do not localize }

  SSoapNameSpace = 'http://schemas.xmlsoap.org/soap/envelope/'; { do not localize}
  SXMLNS = 'xmlns';                                        { do not localize}
  SSoapEncodingAttr = 'encodingStyle';                     { do not localize}
  SSoap11EncodingS5 = 'http://schemas.xmlsoap.org/soap/encoding/';  { do not localize}

  SSoapEncodingArray = 'Array';                            { do not localize}
  SSoapEncodingArrayType = 'arrayType';                    { do not localize}

  SSoapHTTPTransport = 'http://schemas.xmlsoap.org/soap/http';   { do not localize}
  SSoapBodyUseEncoded = 'encoded';                         { do not localize}
  SSoapBodyUseLiteral = 'literal';                         { do not localize}

  SSoapEnvelope = 'Envelope';                              { do not localize}
  SSoapHeader = 'Header';                                  { do not localize}
  SSoapBody = 'Body';                                      { do not localize}
  SSoapResponseSuff = 'Response';                          { do not localize}

{$IFNDEF VER140}
  SRequired = 'required';                                  { do not localize }
{$ELSE}
  SSoapMustUnderstand = 'mustUnderstand';                  { do not localize}
{$ENDIF}
  SSoapActor = 'actor';                                    { do not localize}
{$IFNDEF VER140}
  STrue = 'true';                                          { do not localize}
{$ENDIF}

  SSoapServerFaultCode = 'Server';                         { do not localize}
  SSoapServerFaultString = 'Server Error';                 { do not localize}
  SSoapFault = 'Fault';                                    { do not localize}
  SSoapFaultCode = 'faultcode';                            { do not localize}
  SSoapFaultString = 'faultstring';                        { do not localize}
  SSoapFaultActor = 'faultactor';                          { do not localize}
  SSoapFaultDetails =  'detail';                           { do not localize}
{$IFNDEF VER140}
  SFaultCodeMustUnderstand = 'MustUnderstand';             { do not localize}
{$ENDIF}

  SHTTPSoapAction = 'SOAPAction';                          { do not localize}

{$IFNDEF VER140}
  SHeaderMustUnderstand = 'mustUnderstand';                { do not localize}
  SHeaderActor = 'actor';                                  { do not localize}
  SActorNext= 'http://schemas.xmlsoap.org/soap/actor/next';{ do not localize}
{$ENDIF}

  SSoapType = 'type';                                      { do not localize}
  SSoapResponse = 'Response';                              { do not localize}
  SDefaultReturnName = 'return';                           { do not localize}
  SDefaultResultName = 'result';                           { do not localize}

  sNewPage = 'WebServices';                                { do not localize}  // absolete D6 Update Pack 2

  SXMLID = 'id';                                           { do not localize}
  SXMLHREF = 'href';                                       { do not localize}

  SSoapNULL = 'NULL';                                      { do not localize}
{$IFNDEF VER140}
  SSoapNIL  = 'nil';                                       { do not localize}
{$ENDIF}

  SHREFPre = '#';                                          { do not localize}
  SArrayIDPre = 'Array-';                                  { do not localize}
  SDefVariantElemName = 'V';                               { do not localize}


{$IFNDEF VER140}
  SDefaultBaseURI = 'thismessage:/';                       { do not localize}
{$ENDIF}
  SDelphiTypeNamespace = 'http://www.borland.com/namespaces/Delphi/Types';    { do not localize}
  SBorlandTypeNamespace= 'http://www.borland.com/namespaces/Types';           { do not localize}

  SOperationNameSpecifier = '%operationName%';             { Do not localize }
  SDefaultReturnParamNames= 'Result;Return';               { Do not localize }
  sReturnParamDelimiters  = ';,/:';                        { Do not localize }


  KindNameArray:  array[tkUnknown..tkDynArray] of string =
    ('Unknown', 'Integer', 'Char', 'Enumeration', 'Float',                    { do not localize }
    'String', 'Set', 'Class', 'Method', 'WChar', 'LString', 'WString',        { do not localize }
    'Variant', 'Array', 'Record', 'Interface', 'Int64', 'DynArray');          { do not localize }

  SSoapNameSpacePre = 'SOAP-ENV';            { do not localize }
  SXMLSchemaNameSpacePre = 'xsd';            { do not localize}
  SXMLSchemaInstNameSpace99Pre = 'xsi';      { do not localize}
  SSoapEncodingPre = 'SOAP-ENC';             { do not localize}

{$IFNDEF VER140}
{$IFDEF D6_STYLE_COLORS}
  sDefaultColor = '#006699';
  sIntfColor    = '#006699';
  sTblHdrColor  = '#CCCC99';
  sTblColor1    = '#FFFFCC';
  sTblColor0    = '#CCCC99';
  sBkgndColor   = '#CCCC99';
  sTipColor     = '#666666';
  sWSDLColor    = '#666699';
  sOFFColor     = '#A0A0A0';
  sNavBarColor  = '#006699';
  sNavBkColor   = '#cccccc';
{$ELSE}
  sDefaultColor = '#333333';
  sIntfColor    = '#660000';
  sTblHdrColor  = '#CCCC99';
  sTblColor1    = '#f5f5dc';
  sTblColor0    = '#d9d4aa';
  sBkgndColor   = '#d9d4aa';
  sTipColor     = '#666666';
  sWSDLColor    = '#990000';
  sOFFColor     = '#A0A0A0';
  sNavBarColor  = '#660000';
  sNavBkColor   = '#f5f5dc';
{$ENDIF}
{$ENDIF}

  HTMLStylBeg = '<style type="text/css"><!--' + sLineBreak;
  HTMLStylEnd = '--></style>'                 + sLineBreak;
  BodyStyle1  = 'body       {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; }'                                                       + sLineBreak;
  BodyStyle2  = 'body       {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; margin-left: 0px; margin-top: 0px; margin-right: 0px; }' + sLineBreak;
{$IFNDEF VER140}
  OtherStyles = 'h1         {color: '+sDefaultColor+'; font-size: 18pt; font-style: normal; font-weight: bold; }'                                                   + sLineBreak +
                'h2         {color: '+sDefaultColor+'; font-size: 14pt; font-style: normal; font-weight: bold; }'                                                   + sLineBreak +
                'h3         {color: '+sDefaultColor+'; font-size: 12pt; font-style: normal; font-weight: bold; }'                                                   + sLineBreak +
                '.h1Style   {color: '+sDefaultColor+'; font-size: 18pt; font-style: normal; font-weight: bold; }'                                                   + sLineBreak +
                '.TblRow    {color: '+sDefaultColor+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: normal; }' + sLineBreak +
                '.TblRow1   {color: '+sDefaultColor+'; background-color: '+sTblColor1+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: normal; }' + sLineBreak +
                '.TblRow0   {color: '+sDefaultColor+'; background-color: '+sTblColor0+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: normal; }' + sLineBreak +
                '.TblHdr    {color: '+sTblHdrColor+ '; background-color: '+sDefaultColor+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: bold; text-align: center;}' + sLineBreak +
                '.IntfName  {color: '+sIntfColor  + '; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: bold; }'                             + sLineBreak +
                '.MethName  {color: '+sDefaultColor+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold; text-decoration: none; }'       + sLineBreak +
                '.ParmName  {color: '+sDefaultColor+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; text-decoration: none; }'                          + sLineBreak +
                '.Namespace {color: '+sDefaultColor+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-style: italic; }'                             + sLineBreak +
                '.WSDL      {color: '+sWSDLColor+   '; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold; }'                              + sLineBreak +
                '.MainBkgnd {background-color : '+sBkgndColor+'; }'                                                                                                          + sLineBreak +
                '.Info      {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12pt; font-weight: bold; }'                                             + sLineBreak +
                '.NavBar    {color: '+sNavBarColor+'; background-color: '+sNavBkColor+'; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold;text-decoration: none; }'+ sLineBreak +
                '.Off       {color: '+sOFFColor+'; }'                                                                                                                     + sLineBreak +
                '.Tip 	    {color: '+sTipColor+'; font-family : Verdana, Arial, Helvetica, sans-serif; font-weight : normal; font-size : 9pt; }'                         + sLineBreak;
{$ELSE}
  OtherStyles = 'h1         {color: #006699; font-size: 18pt; font-style: normal; font-weight: bold; }'                                                   + sLineBreak +
                'h2         {color: #006699; font-size: 14pt; font-style: normal; font-weight: bold; }'                                                   + sLineBreak +
                'h3         {color: #006699; font-size: 12pt; font-style: normal; font-weight: bold; }'                                                   + sLineBreak +
                '.h1Style   {color: #006699; font-size: 18pt; font-style: normal; font-weight: bold; }'                                                   + sLineBreak +
                '.TblRow    {color: #006699; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: normal; }' + sLineBreak +
                '.TblRow1   {color: #006699; background-color: #FFFFCC; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: normal; }' + sLineBreak +
                '.TblRow0   {color: #006699; background-color: #CCCC99; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: normal; }' + sLineBreak +
                '.TblHdr    {color: #CCCC99; background-color: #006699; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: bold; text-align: center;}' + sLineBreak +
                '.IntfName  {color: #006699; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: bold; }'                             + sLineBreak +
                '.MethName  {color: #006699; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold; text-decoration: none; }'       + sLineBreak +
                '.ParmName  {color: #006699; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; text-decoration: none; }'                          + sLineBreak +
                '.Namespace {color: #006699; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-style: italic; }'                             + sLineBreak +
                '.WSDL      {color: #666699; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold; }'                              + sLineBreak +
                '.MainBkgnd {background-color : #CCCC99; }'                                                                                                         + sLineBreak +
                '.Info      {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12pt; font-weight: bold; }'                                             + sLineBreak +
                '.NavBar    {color: #006699; background-color: #CCCCCC; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; font-weight: bold;text-decoration: none; }'+ sLineBreak +
                '.Off       {color: #A0A0A0; }'                                                                                                                     + sLineBreak +
                '.Tip 	    {color: #666666; font-family : Verdana, Arial, Helvetica, sans-serif; font-weight : normal; font-size : 9pt; }'                         + sLineBreak;
{$ENDIF}


  HTMLStyles  = HTMLStylBeg + BodyStyle1 + OtherStyles + HTMLStylEnd;
  HTMLNoMargin= HTMLStylBeg + BodyStyle2 + OtherStyles + HTMLStylEnd;

  TableStyle  = 'border=1 cellspacing=1 cellpadding=2 ';

{$IFNDEF VER140}
resourcestring
  HTMLContentLanguage   = ''; // '<meta http-equiv="Content-Language" content="ja"><meta http-equiv="Content-Type" content="text/html; charset=shift_jis">';

const
  HTMLHead    = '<html><head>';
  HTMLServiceInspection = '<META name="serviceInspection" content="inspection.wsil">';

{resourcestring - these are getting truncated as resources currently resulting in bad HTML pages!!} 
  HTMLTopPlain              = HTMLHead + '</head><body>';
  HTMLTop                   = HTMLHead + '</head>'+HTMLStyles+'<body>';
  HTMLTopNoMargin           = HTMLHead + '</head>'+HTMLNoMargin+'<body>';
  HTMLTopTitleNoMargin      = HTMLHead + '<title>%s</title></head>'+HTMLNoMargin+'<body>';
  HTMLTopNoStyles           = HTMLHead + '</head><body>';
  HTMLTopTitle              = HTMLHead + '<title>%s</title></head>'+HTMLStyles+'<body>';
  HTMLTopTitleNoMarginWSIL  = HTMLHead + HTMLServiceInspection + '<title>%s</title></head>'+HTMLNoMargin+'<body>';

const
{$ELSE}
  HTMLTopPlain= '<html><head></head><body>';
  HTMLTop     = '<html><head></head>'+HTMLStyles+'<body>';
  HTMLTopNoM  = '<html><head></head>'+HTMLNoMargin+'<body>';
  HTMLTopTNoM = '<html><head><title>%s</title></head>'+HTMLNoMargin+'<body>';
  HTMLTopNS   = '<html><head></head><body>';
  HTMLTopTitle= '<html><head><title>%s</title></head>'+HTMLStyles+'<body>';
{$ENDIF}
  HTMLEnd     = '</body></html>';
  InfoTitle1  = '<table class="MainBkgnd" border=0 cellpadding=0 cellspacing=0 width="100%">' +
                '<tr><td>&nbsp;</td></tr>';
  InfoTitle2  = '<tr><td class="h1Style" align="center">%s - %s</td></tr>' +
                '</table>';
  TblCls: array[Boolean] of string = ('TblRow0', 'TblRow1');
  sTblRow     = 'TblRow';
  sTblHdrCls  = 'TblHdr';

  sQueryStringIntf = 'intf';                                    { Do not localize }
  sQueryStringTypes= 'types';                                   { Do not localize }
  sNBSP = '&nbsp;';                                             { Do not localize }

var

  XMLSchemaNameSpace: string = SXMLSchemaURI_2001;    { Default namespace we publish under }
  XMLSchemaInstNameSpace: string =  SXMLSchemaInstURI;

resourcestring

  SUnsupportedEncodingSyle = 'Неподдерживаемый SOAP encodingStyle %s';
  SInvalidSoapRequest = 'Неверный SOAP запрос';
{$IFNDEF VER140}
  SInvalidSoapResponse = 'Неверный SOAP ответ';
{$ENDIF}
  SMultiBodyNotSupported = 'Не поддерживаются многочисленные элементы тела';
  SUnsupportedCC = 'Неподдерживаемое соглашение о вызовах: %s';
  SUnsupportedCCIntfMeth = 'Удаленный вызов метода: неподдерживаемое соглашение о вызовах %s для метода %s через интерфейс %s';
  SInvClassNotRegistered  = 'Нет зарегистрированного вызываемого класса для обеспечения интерфейса %s (soap action/path) %s';
  SInvInterfaceNotReg = 'Нет зарегистрированного интерфейса для soap action ''%s''';
  SInvInterfaceNotRegURL = 'Нет зарегистрированного интерфейса для URL ''%s''';
  SRemTypeNotRegistered  = 'Remotable Type %s не зарегистрирован';
  STypeMismatchInParam = 'Несовпадение типов в параметре %s';
  SNoSuchMethod = 'Нет метода c именем ''%s'', поддерживаемого интерфейсом ''%s''';
  SInterfaceNotReg = 'Интерфейс не зарегистрирован, UUID = %s';
  SInterfaceNoRTTI = 'Интерфейс не имеет RTTI, UUID = %s';
  SNoWSDL = 'Нет WSDL документа, связанного с WSDLView';
  SWSDLError = 'Неверный WSDL документ ''%s'' - Пожалуйста, проверьте размещение и содержание!'#13#10'Ошибка: %s';
  SEmptyWSDL = 'Пустой документ';
  sNoWSDLURL = 'Не установлены свойства WSDL или URL в компоненте THTTPRIO. Вы должны установить свойство WSDL или URL перед вызовом Web Service';
  sCantGetURL= 'Не могу возвратить URL endpoint для Service/Port ''%s''/''%s'' из WSDL ''%s''';
  SDataTypeNotSupported = 'Тип данных TypeKind: %s не поддерживается как аргумент для удаленного вызова';
{$IFDEF LINUX}
  SNoMatchingDelphiType = 'Cоответствующий Kylix тип не найден для типа: URI = %s, Name = %s on Node %s';
{$ENDIF}
  SUnknownSOAPAction = 'Неизвестное SOAPAction %s';
{$IFNDEF VER140}
  SScalarFromTRemotableS = 'Классы, которые представляют скалярные типы, должны порождаться из TRemotableXS, а %s - нет';
  SNoSerializeGraphs = 'Must enable multiref output for objects when serializing a graph of objects - (%s)';
  SUnsuportedClassType = 'Преобразование из класса %s в SOAP не поддерживается - классы SOAP должны порождаться из TRemotable';
{$ELSE}
  SScalarFromTRemotableS = 'Классы, которые представляют скалярные типы, должны порождаться из TRemotable, а %s - нет';
  SNoSerializeGraphs = 'Must allow multiref output for objects when serializing a graph of objects';
  SUnsuportedClassType = 'Преобразование из класса %s в SOAP не поддерживается';
{$ENDIF}
  SUnexpectedDataType = 'Внутренняя ошибка: тип данных вида %s не ожидается в этом контексте';
{$IFNDEF VER140}
  SInvalidContentType = 'Получено неверное значение настройки Content-Type: %s - SOAP ожидает "text/xml"';
{$ENDIF}

  SArrayTooManyElem = 'Узел массива: %s имеет слишком много элементов';
  SWrongDocElem = 'DocumentElement %s:%s ожидается, %s:%s найден';
  STooManyParameters = 'Слишком много параметров в методе %s';
  SArrayExpected = 'Тип Массив ожидается. Узел %s';
{$IFDEF VER140}
  SNoMultiDimVar = 'Многоразмерные вариантные массивы не поддерживаются в данной версии';
  SNoURL = 'Нет установленных URL';
{$ENDIF}

  SNoInterfaceGUID = 'Класс %s не обеспечивает интерфейс GUID %s';
  SNoArrayElemRTTI = 'Элемент массива типа %s не имеет RTTI';
  SInvalidResponse = 'Неверный ответ SOAP';
  SInvalidArraySpec = 'Неверный спецификация массива SOAP';
  SCannotFindNodeID = 'Не могу найти узел по ссылке ID %s';
  SNoNativeNULL = 'Опция не установлена для разрешения типу Native быть установленным в NULL';
  SFaultCodeOnlyAllowed = 'Допускается только один элемент FaultCode';
  SFaultStringOnlyAllowed = 'Допускается только один элемент FaultString';
  SMissingFaultValue = 'Отсутствует элемент FaultString или FaultCode';
  SNoInterfacesInClass = 'Invokable класс %s не обеспечивает интерфейсов';

  SVariantCastNotSupported = 'Тип не может быть приведен как Variant';
  SVarDateNotSupported = 'Тип varDate не поддерживается';
  SVarDispatchNotSupported = 'Тип varDispatch не поддерживается';
  SVarErrorNotSupported = 'Тип varError не поддерживается';
  SVarVariantNotSupported = 'Тип varVariant не поддерживается';
{$IFNDEF VER140}
  SHeaderError = 'Ошибка выполнения заголовка (%s)%s';
{$ELSE}
  SHeaderError = 'Ошибка выполнения заголовка %s';
{$ENDIF}
  SMissingSoapReturn = 'Ответный пакет SOAP: ожидается результирующий элемент, получено "%s"';
  SInvalidPointer = 'Неверный указатель';
  SNoMessageConverter = 'Не установлен конвертер из Native в Message';
  SNoMsgProcessingNode = 'Не установлен Message processing node';
  SHeaderAttributeError = 'Заголовок Soap %s с атрибутом ''mustUnderstand'' set to true was not handled';

  {IntfInfo}
  SNoRTTI = 'Интерфейс %s не имеет RTTI';
  SNoRTTIParam = 'Параметр %s метода %s интерфейса %s не имеет RTTI';

  {XSBuiltIns}
  SInvalidDateString        = 'Неверная строка даты: %s';
  SInvalidTimeString        = 'Неверная строка времени: %s';
  SInvalidHour              = 'Неверный час: %d';
  SInvalidMinute            = 'Неверная минута: %d';
  SInvalidSecond            = 'Неверная секунда: %d';
  SInvalidFractionSecond    = 'Неверная секунда: %f';
  SInvalidMillisecond       = 'Неверная миллисекунда: %d';
  SInvalidFractionalSecond  = 'Неверная дробная секунда: %f';
  SInvalidHourOffset        = 'Неверный сдвиг часа: %d';
  SInvalidDay               = 'Неверный день: %d';
  SInvalidMonth             = 'Неверный месяц: %d';
  SInvalidDuration          = 'Неверная строка длительности: %s';
  SMilSecRangeViolation     = 'Значения миллисекунд должны быть между 000 - 999';
  SInvalidYearConversion    = 'Год даты слишком большой для преобразования';
  SInvalidTimeOffset        = 'Сдвиг часа времени - неверный';
  SInvalidDecimalString     = 'Неверная decimal строка: ''''%s''''';
  SEmptyDecimalString       = 'Не могу преобразовать пустую строку в TBcd значение';
  SNoSciNotation            = 'Не могу преобразовать научную запись числа  в TBcd значение';
  SNoNAN                    = 'Не могу преобразовать NAN в TBcd значение';
  SInvalidBcd               = 'Неверная Bcd точность (%d) или Scale (%d)';
  SBcdStringTooBig          = 'Не могу преобразовать в TBcd: строка имеет больше чем 64 цифр: %s';
  SInvalidHexValue          = '%s - неверная шестнадцатиричная строка';
{$IFNDEF VER140}
  SInvalidHTTPRequest       = 'Неверный HTTP запрос: длина равна 0';
  SInvalidHTTPResponse      = 'Неверный HTTP ответ: длина равна 0';
{$ENDIF}

  {WebServExp}
  SInvalidBooleanParameter  = 'ByteBool, WordBool и LongBool не могут быть exposed by WebServices. Пожалуйста, используйте ''Boolean''';

  {WSDLIntf}
  SWideStringOutOfBounds = 'Индекс WideString вышел за границы';

  {WSDLPub}
  IWSDLPublishDoc = 'Lists all the PortTypes published by this Service';

  SNoServiceForURL = 'Нет доступного сервиса для URL %s';
  SNoInterfaceForURL = 'Нет зарегистрированного интерфейса для управления URL %s';
  SNoClassRegisteredForURL = 'Нет зарегистрированного класса для обеспечения интерфейса %s';
  SEmptyURL = 'Нет URL, определенного для ''GET''';
  SInvalidURL = 'Неверный url ''%s'' - поддерживает только ''http'' и ''https'' схемы';
  SNoClassRegistered = 'Нет зарегистрированного класса для вызываемого интерфейса %s';
  SNoDispatcher = 'Нет установленного диспетчера';
  SMethNoRTTI = 'Метод не имеет RTTI';
{$IFNDEF VER140}
  SUnsupportedVariant = 'Неподдерживаемый вариантный тип %d';
{$ELSE}
  SUnsupportedVariant = 'Неподдерживаемый вариантный тип';
{$ENDIF}
  SNoVarDispatch = 'Тип varDispatch не поддерживается';
  SNoErrorDispatch = 'Тип varError не поддерживается';
  SUnknownInterface = '(Unknown)';

  SInvalidTimeZone = 'Неверный или неизвестный часовой пояс';
  SLocationFilter = 'WSDL файлы (*.wsdl)|*.wsdl|XML файлы (*.xml)|*.xml';

  sUnknownError = 'Неизвестная ошибка';
  sErrorColon   = 'Ошибка: ';
{$IFNDEF VER140}
  sServiceInfo  = '%s - PortTypes:';
  sInterfaceInfo= '<a href="%s">%s</a>&nbsp;&gt;&nbsp;<span class="Off">%s</span>';
  sWSILInfo     = 'WSIL:';
  sWSILLink     = '&nbsp;&nbsp;<span class="Tip">Ссылка на WS-Inspection документ of Services <a href="%s">here</a></span>';
{$ELSE}
  sServiceInfo  = '%s exposes следующие интерфейсы:';
  sInterfaceInfo= '<a class="NavBar" href="%s">%s</a>&nbsp;&gt;&nbsp;<span class="Off">%s</span>';
{$ENDIF}
  sRegTypes     = 'Зарегистрированные типы';

  sWebServiceListing      = 'WebService Listing';
  sWebServiceListingAdmin = 'WebService Listing Administrator';
  sPortType               = 'Тип порта';
  sNameSpaceURI           = 'Namespace URI';
  sDocumentation          = 'Документация';
  sWSDL                   = 'WSDL';
  sPortName               = 'PortName';
{$IFNDEF VER140}
  sInterfaceNotFound      = HTMLHead + '</head><body>' + '<h1>Обнаружена ошибка</h1><P>Интерфейс %s не найден</P>' +HTMLEnd;
  sForbiddenAccess        = HTMLHead + '</head><body>' + '<h1>Запрещено (403)</h1><P>Доступ запрещен</P>' +HTMLEnd;
{$ELSE}
  sInterfaceNotFound      = HTMLTopPlain + '<h1>Обнаружена ошибка</h1><P>Интерфейс %s не найден</P>' +HTMLEnd;
  sForbiddenAccess        = HTMLTopNS + '<h1>Запрещено (403)</h1><P>Доступ запрещен</P>' +HTMLEnd;
{$ENDIF}
  sWSDLPortsforPortType   = 'WSDL порты для PortType';
  sWSDLFor                = '';
  sServiceInfoPage        = 'Service Info Page';

{$IFNDEF VER140}
{SOAPAttach}
  SEmptyStream = 'Ошибка TAggregateStream: нет внутренних потоков';
  SMethodNotSupported = 'метод не поддерживается';
  SInvalidMethod = 'Метод неразрешен в TSoapDataList';
  SNoContentLength = 'Заголовок Content-Length не найден';
  SInvalidContentLength = 'Неполные данные для Content-Length';
  SMimeReadError = 'Ошибка чтения из Mime Request Stream';
 {$IFDEF MSWINDOWS}
  STempFileAccessError = 'Нет доступа к временному файлу';
 {$ENDIF}
 {$IFDEF LINUX}
  STempFileAccessError = 'Нет доступа к временному файлу: проверьте настройку TMPDIR';
 {$ENDIF}

{SoapConn}
  SSOAPServerIIDFmt = '%s - %s';
  SNoURL = 'Не установлено свойство URL - пожалуйста, укажите URL Сервиса, к которому Вы хотите подключиться';
  SSOAPInterfaceNotRegistered = 'Интерфейс (%s) не зарегестрирован - пожалуйста, включите в Ваш проект модуль, который регистрирует этот интерфейс';
  SSOAPInterfaceNotRemotable  = 'Интерфейс (%s) не может быть удаленным - пожалуйста, проверьте объявление интерфейса - особенно соглашение о вызовах методов!';

  SCantLoadLocation = 'Не могу загрузить WSDL Файл/Размещение: %s.  Ошибка [%s]';
{$ENDIF}
implementation

end.
