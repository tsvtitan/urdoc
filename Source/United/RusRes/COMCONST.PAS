{ *********************************************************************** }
{                                                                         }
{ Delphi Runtime Library                                                  }
{                                                                         }
{ Copyright (c) 1999-2001 Borland Software Corporation                    }
{                                                                         }
{  Русификация: 1998-2002 Polaris Software                                }
{               http://polesoft.da.ru                                     }
{ *********************************************************************** }

unit ComConst;

interface

resourcestring
  SCreateRegKeyError = 'Ошибка создания ключа (entry) системного реестра';
  SOleError = 'Ошибка OLE %.8x';
  SObjectFactoryMissing = 'Object factory для класса %s потеряна';
  STypeInfoMissing = 'Информация о типе потеряна для класса %s';
  SBadTypeInfo = 'Неверная информация о типе для класса %s';
  SDispIntfMissing = 'Dispatch interface потерян для класса %s';
  SNoMethod = 'Метод ''%s'' не поддерживается automation объектом';
  SVarNotObject = 'Вариант не ссылается automation объектом';
{$IFNDEF VER120}
{$IFNDEF VER125}
{$IFNDEF VER130}
  STooManyParams = 'Dispatch методы не поддерживают более 64 параметров';
{$ENDIF}
{$ENDIF}
{$ENDIF}
  SDCOMNotInstalled = 'DCOM не установлен';
  SDAXError = 'Ошибка DAX';

  SAutomationWarning = 'Предупреждение COM Сервера';
  SNoCloseActiveServer1 = 'В приложении имеются активные COM объекты. ' +
    'Один или более клиентов могут ссылаться на эти объекты, ' +
    'таким образом, закрытие ';
  SNoCloseActiveServer2 = 'приложения может вызвать сбой клиентских ' +
    'приложений.'#13#10#13#10'Вы уверены, что хотите закрыть это ' +
    'приложение?';

implementation

end.
