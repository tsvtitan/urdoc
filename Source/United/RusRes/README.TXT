HHHH       H            H        HHHH       H  H
H   H  HH  H  HHH  H HH    HHH  H     HH   H  HHH H   H  HHH  H HH  HH
H   H H  H H H  H  HH   H H     HH   H  H HHH  H  H H H H  H  HH   H  H
HHHH  H  H H H  H  H    H  HH     HH H  H  H   H   HHH  H  H  H    HHH   
H      HH  H  HHHH H    H    H     H  HH   H    H  H H   HHHH H    H   
H                         HHH  HHHH       H                         HHH

В этом архиве предлагается Вашему вниманию набор русифицированных ресурсов
для Delphi 3, 4, 5, 6, 7. (только для RUNTIME при откл. Build with runtime packages)
Переведены строковые ресурсы, находящиеся в представленных PAS-файлах.

  ====================
--==   Версия 2.5   ==--
  ====================

СОСТАВ
------
..... Delphi 3 и выше
bdeconst.pas
comstrs.pas
consts.pas
dbconsts.pas
ibconst.pas
mxconsts.pas
oleconst.pas
sysutils.inc (include-файл для sysutils.pas) (только для Delphi3!!!)
webconst.pas

..... Delphi 4 и выше
comconst.pas
corbcnst.pas
midconst.pas
scktcnst.pas
sysconst.pas

..... Delphi 5 и выше
adoconst.pas
brkrconst.pas
ibxconst.pas
mxdconst.pas
qr3const.pas
wbmconst.pas

..... Delphi 6 и выше
CtlConsts.pas
DesignConst.pas
IBDCLConst.pas
IdResourceStrings.pas
InvConst.pas
QConsts.pas
QDBConsts.pas
RTLConsts.pas
SiteConst.pas
SoapConst.pas
SqlConst.pas
SvrConst.pas
SvrInfoConst.pas
VDBConsts.pas

..... Delphi 7 и выше
IBVisualConst.pas
WbmDCnst.pas
XMLConst.pas
ZLibConst.pas

Замечания:
- qr3const.pas - для Quick Report 3.0.5 Pro. Включен в данный набор как демо.
  Полная русификация QR 3 Pro включена в проект BFQR http://bfqr.nm.ru.
- файл IdResourceStrings.pas можно использовать и с версиями Indy 8 и 9,
  не входящими в комплект Delphi 5,6,7. Если у Вас возникают ошибки при
  компиляции, скачайте последнюю версию Indy (http://www.nevrona.com/indy).


УСТАНОВКА
---------
В соответствии с рекомендациями Borland Corp. необходимо записать файлы в папку,
доступную для Ваших русских проектов (либо туда, где сам проект, либо вписать 
в search path в опциях каждого проекта).


ИСТОРИЯ
-------
Версия 2.5
1. Внесены изменения для совместимости с Delphi 7 и IBX x.05.
2. DFM-файлы вынесены в отдельный архив.
3. Несколько благоустроен данный файл.

Версия 2.4.5
1. Внесены изменения для совместимости с Delphi 6 Update Pack 2 и IBX x.03.

Версия 2.4.4
1. Исправлен IBXConst.pas для совместимости с IBX x.02.

Версия 2.4.3
1. Внесены изменения для совместимости с Delphi 6 Update Pack 1.

Версия 2.4.2
1. Исправлен IBXConst.pas для совместимости с IBX 4.63.

Версия 2.4.1
1. Исправлен DBConsts.pas для Delphi 6.

Версия 2.4
1. Добавлена поддержка Delphi 6.

Версия 2.3
1. Изменения в ibxconst.pas для совместимости с IBX 4.51.

Версия 2.2
1. Добавлена русификация DFM-файлов для Delphi 4.
2. Файл ib.pas заменен на ibxconst.pas для совместимости с IBX 4.4.

Версия 2.1
Исправлены ошибки в consts.pas, ib.pas, wbmconst.pas.

Версия 2.0
1. Добавлена поддержка Delphi 5.
2. Изменения для Quick Report 3.0.5.

Версия 1.8
Исправлены ошибки почти во всех файлах благодаря активному содействию
хороших людей. Всем ОГРОМНОЕ СПАСИБО.

Версия 1.7
Исправлены ошибки в dbconsts.pas, bdeconst.pas.

Версии 1.5-1.6
Добавлена основная часть файлов.

Версии 0.0-1.4
Первые потуги.


БЛАГОДАРНОСТИ
-------------
Александр Ильин   alexil@aha.ru   http://www.aha.ru/~alexil
За кропотливый труд по выискиванию глюков в нашей писанине.


Ждем Ваших предложений и пожеланий.

18.12.02
С уважением,
Polaris Software
Россия, Краснодар
http://polesoft.da.ru
Email: polesoft@mail.ru