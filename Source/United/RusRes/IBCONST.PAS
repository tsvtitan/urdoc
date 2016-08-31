{  Русификация: 1998-2001 Polaris Software              }
{               http://polesoft.da.ru                   }

unit IBConst;

interface

resourcestring
  srSamples = 'Samples';
  SNoEventsRegistered  = 'Вы должны зарегистрировать события перед их запросом';
  SInvalidDBConnection = 'Компонент не подключен к открытой Database';
  SInvalidDatabase     = '''''%s'''' не подключен к базе данных InterBase';
  SInvalidCancellation = 'Нельзя вызвать CancelEvents внутри OnEventAlert';
  SInvalidEvent        = 'Неверное пустое событие добавлено в список событий EventAlerter';
  SInvalidQueueing     = 'Нельзя вызвать QueueEvents внутри OnEventAlert';
  SInvalidRegistration = 'Нельзя вызвать Register или Unregister для событий внутри OnEventAlert';  
{$IFNDEF VER100}
  SMaximumEvents       = 'Можно зарегистрировать только 15 событий в EventAlerter';
{$ENDIF}

implementation

end.
  
