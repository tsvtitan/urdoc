{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{   Copyright (c) 2001 Borland Software Corporation     }
{                                                       }
{  Русификация: 2001-02 Polaris Software                }
{               http://polesoft.da.ru                   }
{*******************************************************}

unit SiteConst;

interface

resourcestring

  // Adapter errors
  sFieldRequiresAValue = 'Поле %s требует значение';
  sFieldDoesNotAllowMultipleValues = '%s не допускает множественные значения';
  sFieldDoesNotAllowMultipleFiles = '%s не допускает множественные файлы';
  sFieldRequiresAFile = '%s требует файл';
  sFieldModificationNotPermitted = 'Изменение %s не допустимо';
  sActionExecutionNotPermitted = 'Выполнение действия %s не допустимо';
  sFieldViewNotPermitted = 'Просмотр поля не допустим';
  sAdapterModificationNotPermitted = 'Изменение данных не допустимо';
  sFileUploadNotSupported = '%s не поддерживает закачку файлов';
  sNoLoginPage = 'Страница входа не определена';
  sPageNotFound = 'Web-страница не найдена: %s';
  sPageContentNotProvided = 'Web-страница не предоставляло содержимого';
  sImageNotProvided = 'Поле %s не предоставляло изображения';

  // DataSetAdapter errors
  sUnknownAdapterMode = 'Неизвестный режим адаптера: %s';
  sNilAdapterDataSet = 'DataSet равен nil';
  sAdapterRowNotFound = 'Строка не найдена в %s';
  sFieldChangedByAnotherUser = 'Поле %s изменено другим пользователем';
  sAdapterFieldNotFound = 'Поле не найдено: %s';
  sDataSetPropertyIsNil = '%s: свойство DataSet равно nil';
  sDataSetUnknownKeyFields = '%0:s: Dataset %1:s неизв. ключевые поля';
  sDataSetNotActive = '%0:s: Dataset %1:s не активен';
  sValueFieldIsBlank = '%0:s: значение свойства ValueField - пустое';

  // XSLPageProducer errors
  SNoXMLData = 'Отсутствует компонент данных XML';
  SNoXMLDocument = 'Не могу создать XMLDocument';

  // Add Adapter Fields Editor
  sAddAdapterData = 'Добавить поля...';
  sAddAllAdapterData = 'Добавить все поля';
  sAddAdapterDataDlgCaption = 'Добавление полей';
  sAddAdapterActions = 'Добавить действия...';
  sAddAllAdapterActions = 'Добавить все действия';
  sAddAdapterActionsDlgCaption = 'Добавление действий';
  sAdapterActionsPrefix = 'Action'; // Do not location
  sAddCommands = 'Добавить команды...';
  sAddAllCommands = 'Добавить все команды';
  sAddCommandsDlgCaption = 'Добавление команд';
  sAddColumns = 'Добавить колонки...';
  sAddAllColumns = 'Добавить все колонки';
  sAddColumnsDlgCaption = 'Добавление колонок';
  sAddFieldItems = 'Добавить поля...';
  sAddAllFieldItems = 'Добавить все поля';
  sAddFieldItemsDlgCaption = 'Добавление полей';


  // SitePageProducer errors
  sAdapterPropertyIsNil =  '%s: свойство Adapter равно nil';
  sAdapterFieldNameIsBlank = '%s: пустое имя поля';
  sCantFindAdapterField = '%0:s: поле %1:s не найдено в связанном Adapter';    // 0 - Component name, 1 - Adapter Field name
  sAdapterActionNameIsBlank = '%s: пустое имя действия';
  sCantFindAdapterAction = '%0:s: действие %1:s не найдено в связанном Adapter';   // 0 - Component name, 1 - Adapter Action name
  sDisplayComponentPropertyIsNil = '%s: свойство DisplayComponent равно nil';


  sNoHandler = 'Нет обработчиков запросов обрабатывающих этот запрос. ' +
    'Свойства WebAppComponents PageDispatcher, AdapterDispatcher или DispatchActions должны быть установлены.';


  // LoginAdapter validation
  sBlankPassword = 'Пароль не должен быть пустым';
  sBlankUserName = 'Имя пользователя не должно быть пустым';

  // Dispatcher errors
  sAdapterRequestNotHandled = 'Запрос адаптера не управляем: %0:s, %1:s';    // 0 - Request identifier, 1 - object identifier
  sDispatchBlankPageName = 'Dispatching blank page name';
  sPageAccessDenied = 'Доступ к странице закрыт';
  sPageDoesNotSupportRedirect = 'Web-страница не поддерживает перенаправление';

  // Include errors
  sCantFindIncludePage = 'Не могу найти включенную страницу: %s';
  sInclusionNotSupported = 'Страница %s не поддерживает вложение';
  sRecursiveIncludeFile = 'Включенный файл %s содержит сам себя';

  // DB Image errors
{$IFNDEF VER140}
  sIncorrectImageFormat = 'Неправильный формат изображения (%0:s) для поля %1:s';
{$ELSE}
  sIncorrectImageFormat = 'Неправильный формат изображения (%s) для поля %s';
{$ENDIF}
  sFileExpected = 'Закаченный файл ожидается для поля %s';

  // WebUserList names - must be valid identifiers
  sWebUserName = 'UserName';
  sWebUserPassword = 'Password';
  sWebUserAccessRights = 'AccessRights';

  // WebUserList errors
  sUserIDNotFound = 'UserID не найден';
  sInvalidPassword = 'Неверный пароль';
  sMissingPassword = 'Отсутствует пароль';
  sUnknownUserName = 'Неизвестное имя пользователя';
  sMissingUserName = 'Отсутствует имя пользователя';


  // Script errors
  sCannotCreateScriptEngine = 'Не могу создать script engine: %s.  Ошибка: %x'; 
  sCannotInitializeScriptEngine = 'Не могу инициализировать script engine';
  sScriptEngineNotFound = 'Script engine не найден: %s.';
  sObjectParameterExpected = 'Script Object ожидается';
  sIntegerParameterExpected = 'Целочисленный параметр ожидается';
  sUnexpectedParameterType = 'Неожиданный тип параметра';
  sUnexpectedResultType = 'Неожиданный возвращаемый тип';
  sDuplicatePrototypeName = 'Неуникальное имя прототипа';
  sBooleanParameterExpected = 'Параметр логического типа ожидается';
  sDoubleParameterExpected = 'Параметр типа Double ожидается';
  sUnexpectedScriptError = 'Неожиданная ошибка скрипта';


  // 0 - Error index number
  // 1 - Error description
  // 2 - Line number
  // 3 - character position number
  // 4 - source line text
  sScriptErrorTemplate =
{$IFNDEF VER140}
      '<table width="95%%" border="1" cellspacing="0" bordercolor="#C0C0C0">' + SLineBreak +
        '<tr>' + SLineBreak +
          '<td colspan=2>' + SLineBreak +
            '<font color="#727272"><b>Ошибка[' +  '%0:d' + ']:</b> ' + SLineBreak +
            '%1:s' + SLineBreak +
            '</font>' + SLineBreak +
          '</td>' + SLineBreak +
        '</tr>' + SLineBreak +
        '<tr>' + SLineBreak +
          '<td>' + SLineBreak +
            '<font color="#727272"><b>Строка:</b> ' + SLineBreak +
            '%2:d' + SLineBreak +
            '</font>' + SLineBreak +
          '</td>' + SLineBreak +
          '<td>' + SLineBreak +
            '<font color="#727272"><b>Позиция:</b> ' + SLineBreak +
            '%3:d' + SLineBreak +
            '</font>' + SLineBreak +
          '</td>' + SLineBreak +
        '</tr>' + SLineBreak +
        (* Don't display source text 
        '<tr>' + SLineBreak +
          '<td colspan=2>' + SLineBreak +
            '<font color="#727272"><b>Source Text:</b> ' + SLineBreak +
        '%4:s' + SLineBreak +
            '</font>' + SLineBreak +
          '</td>' + SLineBreak +
        '</tr>' + SLineBreak +
        *)
        '</table>' + SLineBreak;
{$ELSE}
      '<table width="95%%" border="1" cellspacing="0" bordercolor="#C0C0C0">'#13#10 +
        '<tr>'#13#10 +
          '<td colspan=2>'#13#10 +
            '<font color="#727272"><b>Ошибка[' +  '%0:d' + ']:</b> '#13#10 +
            '%1:s'#13#10 +
            '</font>'#13#10 +
          '</td>'#13#10 +
        '</tr>'#13#10 +
        '<tr>'#13#10 +
          '<td>'#13#10 +
            '<font color="#727272"><b>Строка:</b> '#13#10 +
            '%2:d'#13#10 +
            '</font>'#13#10 +
          '</td>'#13#10 +
          '<td>'#13#10 +
            '<font color="#727272"><b>Позиция:</b> '#13#10 +
            '%3:d'#13#10 +
            '</font>'#13#10 +
          '</td>'#13#10 +
        '</tr>'#13#10 +
        (* Don't display source text 
        '<tr>'#13#10 +
          '<td colspan=2>'#13#10 +
            '<font color="#727272"><b>Source Text:</b> '#13#10 +
        '%4:s'#13#10 +
            '</font>'#13#10 +
          '</td>'#13#10 +
        '</tr>'#13#10 +
        *)
        '</table>'#13#10;
{$ENDIF}

  sMaximumSessionsExceeded = 'Превышено максимальное количество сессий';
  sVariableNotFound = 'Переменная не найдена: %s';
  sComponentDoesNotSupportScripting = 'Компонент не поддерживает scripting. Класс: %0:s, Имя: %1:s';
  sClassDoesNotSupportScripting = 'Объект не поддерживает scripting. Класс: %0:s';
  sParameterExpected = 'Параметр ожидается';
  sStringParameterExpected = 'Строковый параметр ожидается';
  sInvalidImageSize = 'Неверное изображение (размер меньше 4 байт).';


  // File include errors 
  sIncDblQuoteError = 'Ошибка включения файла (include) в строке %d: ожидается "';
  sIncEqualsError = 'Ошибка включения файла (include) в строке %d: ожидается =';
  sIncTypeError = 'Ошибка включения файла (include) в строке %d: ожидается virtual, файл, или страница, но найдено %s.';

{$IFNDEF VER140}
  sUnknownImageType = 'неизвестный';

  // WebSnapObjs.pas scripting errors
  sComponentNotFound = 'Компонент %s не найден';
  sCountFromComponentsNotSupported = 'Вызов Count у объекта TComponentsEnumerator не поддерживается';
  sInterfaceCompRefExpected = 'Компонент ожидается для реализации IInterfaceComponentReference для поддержки ValuesList';
  sErrorsObjectNeedsIntf = 'Объект ошибок должен поддерживать интерфейс IIterateIntfSupport';
{$ENDIF}

implementation

end.
