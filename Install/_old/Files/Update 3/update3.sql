
<sql>ALTER TRIGGER BI_SETRENOVATION_ID INACTIVE</sql> 

<sql>SET GENERATOR SETRENOVATION_ID TO 300</sql> 

<sql>insert into renovation (RENOVATION_ID,NAME,INDATE,TEXT) values (300,'Обновление №3','2004-12-09',
'    - Создана опись наследственных дел;
    - Внесена возможность очистки списка блокировки номеров по реестру;
    - Исправлен механизм внесения изменений в справочник посетителей;
    - Добавлена галочка, позволяющая не блокировать номер по реестру;
    - Решена проблема с подсчетом общей суммы в статистическом отчете;
    - Исправлена ошибка подстановки города по умолчанию;
')</sql>

<sql>ALTER TRIGGER BI_SETRENOVATION_ID ACTIVE</sql>

<sql>update doc set renovation_id=300</sql>

<sql>update const set renovation_id=300</sql>



