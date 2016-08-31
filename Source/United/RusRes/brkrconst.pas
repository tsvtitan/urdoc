{ *************************************************************************** }
{                                                                             }
{ Delphi and Kylix Cross-Platform Visual Component Library                    }
{ Internet Application Runtime                                                }
{                                                                             }
{ Copyright (C) 1995, 2001 Borland Software Corporation                       }
{                                                                             }
{ Licensees holding a valid Borland No-Nonsense License for this Software may }
{ use this file in accordance with such license, which appears in the file    }
{ license.txt that came with this Software.                                   }
{                                                                             }
{  Русификация: 1999-2002 Polaris Software                                    }
{               http://polesoft.da.ru                                         }
{ *************************************************************************** }

unit BrkrConst;

interface

resourcestring
  sOnlyOneDataModuleAllowed = 'Допустим только один модуль данных на приложение';
  sNoDataModulesRegistered = 'Не зарегистрировано ни одного модуля данных';
  sNoDispatcherComponent = 'Не найдено ни одного компонента-диспетчера в модуле данных';
{$IFNDEF VER130}
  sNoWebModulesActivated = 'Нет автоматически активированных модулей данных';
{$ENDIF}
  sTooManyActiveConnections = 'Достигнут максимум конкурирующих соединений.  ' +
    'Повторите попытку позже';
  sInternalServerError = '<html><title>Внутренняя Ошибка Сервера 500</title>'#13#10 +
    '<h1>Внутренняя Ошибка Сервера 500</h1><hr>'#13#10 +
    'Исключительная ситуация: %s<br>'#13#10 +
    'Сообщение: %s<br></html>'#13#10;
  sDocumentMoved = '<html><title>Документ перемещен 302</title>'#13#10 +
    '<body><h1>Объект перемещен</h1><hr>'#13#10 +
    'Этот объект может быть найден <a HREF="%s">здесь.</a><br>'#13#10 +
    '<br></body></html>'#13#10;


implementation

end.
