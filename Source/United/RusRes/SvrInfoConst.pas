{***************************************************************}
{                                                               }
{   Borland Delphi Visual Component Library                     }
{                                                               }
{   Copyright (c) 2000-2001 Borland Software Corporation        }
{                                                               }
{  Русификация: 2001-02 Polaris Software                        }
{               http://polesoft.da.ru                           }
{***************************************************************}
unit SvrInfoConst;

interface

resourcestring
  sFileStatus = 'Статус файл:';
  sFound = 'Найден';
  sNotFound = 'Не найден';
{$IFNDEF VER140}
  sMissingProgID = 'Отсутствует ProgID';
{$ELSE}
  sMissingClsID = 'Отсутствует ClassID';
{$ENDIF}
  sGo = 'Пуск';

implementation

end.
