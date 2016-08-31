{ ********************************************************************** }
{                                                                        }
{ Delphi Open-Tools API                                                  }
{                                                                        }
{ Copyright (C) 2000, 2001 Borland Software Corporation                  }
{                                                                        }
{  Русификация: 2001-02 Polaris Software                                 }
{               http://polesoft.da.ru                                    }
{ ********************************************************************** }
unit DesignConst;

interface

resourcestring
  srNone = '(нет)';
  srLine = 'строка';
  srLines = 'строк';

  SInvalidFormat = 'Неверный графический формат';
  
  SUnableToFindComponent = 'Не могу найти форму/компонент, ''%s''';
  SCantFindProperty = 'Не могу найти свойство ''%s'' у компонента ''%s''';
  SStringsPropertyInvalid = 'Свойство ''%s'' не проинициализировано у компонента ''%s''';

  SLoadPictureTitle = 'Загрузить картинку';
  SSavePictureTitle = 'Сохранить картинку как';
  
  SAboutVerb = 'О...';
  SNoPropertyPageAvailable = 'Нет доступных страниц свойств для этого элемента управления';
  SNoAboutBoxAvailable = 'About Box не доступен для этого элемента управления';
  SNull = '(Null)';
  SUnassigned = '(Unassigned)';
  SUnknown = '(Неизвестен)';
  SString = 'String';

  SUnknownType = 'Неизвестный тип';

  SCannotCreateName = 'Не могу создать метод для безымянного компонента';

  SColEditCaption = 'Изменение %s%s%s';

  SCantDeleteAncestor = 'Выбор содержит компонент, который применяется в форме-предке, которая не удалена';
  SCantAddToFrame = 'Новые компоненты не могут добавляться в образцы фреймов.';

{$IFDEF LINUX}
  SAllFiles = 'Все файлы (*)';
{$ENDIF}
{$IFDEF MSWINDOWS}
  SAllFiles = 'Все файлы (*.*)';
{$ENDIF}

const
  SIniEditorsName = 'Property Editors';

implementation

end.
