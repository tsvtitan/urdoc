
<sql>ALTER TABLE REESTR ADD ISDEL SMALLINT</sql>

<sql>ALTER TABLE SUBSVALUE DROP CONSTRAINT R_5_SUBSVALUE</sql>

<sql>DROP INDEX XIF31SUBSVALUE</sql>

<sql>ALTER TABLE CONST ADD RENOVATION_ID INTEGER</sql>

<sql>ALTER TABLE DOC ADD RENOVATION_ID INTEGER</sql>

<sql>ALTER TABLE NOTARIALACTION ADD VIEWHEREDITARY SMALLINT</sql>

<sql>CREATE TABLE REMINDER(REMINDER_ID INTEGER NOT NULL,
TEXT VARCHAR(1000) CHARACTER SET WIN1251 NOT NULL COLLATE PXW_CYRL,
PRIORITY INTEGER NOT NULL)</sql>

<sql>ALTER TABLE REMINDER ADD CONSTRAINT XPKREMINDER PRIMARY KEY (REMINDER_ID)</sql>

<sql>grant select, delete, insert, update on reminder to user_urdoc</sql>

<sql>CREATE GENERATOR SETREMINDER_ID</sql>

<sql>CREATE TRIGGER BI_SETREMINDER_ID FOR REMINDER
ACTIVE BEFORE INSERT POSITION 0 
AS
BEGIN
    new.reminder_id = gen_id(setreminder_id, 1);
END</sql>

<sql>ALTER TRIGGER BI_SETREMINDER_ID INACTIVE</sql> 

<sql>SET GENERATOR SETREMINDER_ID TO 103</sql> 

<sql>INSERT INTO REMINDER (REMINDER_ID,TEXT,PRIORITY) VALUES (100,'Фирма CINTEx расположена по адресу: проспект Красноярский рабочий, дом 91, вход со двора',1)</sql>
<sql>INSERT INTO REMINDER (REMINDER_ID,TEXT,PRIORITY) VALUES (101,'А вы знаете что, если нажать кнопку F1, то откроется документ содержащий полную информация о программе',2)</sql>
<sql>INSERT INTO REMINDER (REMINDER_ID,TEXT,PRIORITY) VALUES (102,'Горячие телефоны нашей фирмы: 34-09-27, 60-39-50 код города (3912)',2)</sql>
<sql>INSERT INTO REMINDER (REMINDER_ID,TEXT,PRIORITY) VALUES (103,'Наша фирма работает без выходных дней',2)</sql>

<sql>ALTER TRIGGER BI_SETREMINDER_ID ACTIVE</sql>

<sql>CREATE TABLE RENOVATION(RENOVATION_ID INTEGER NOT NULL,
NAME VARCHAR(150) CHARACTER SET WIN1251 NOT NULL COLLATE PXW_CYRL,
INDATE DATE NOT NULL,
TEXT BLOB NOT NULL)</sql>

<sql>ALTER TABLE RENOVATION ADD CONSTRAINT XPKRENOVATION PRIMARY KEY (RENOVATION_ID)</sql>

<sql>grant select, delete, insert, update on renovation to user_urdoc</sql>

<sql>CREATE GENERATOR SETRENOVATION_ID</sql>

<sql>CREATE TRIGGER BI_SETRENOVATION_ID FOR RENOVATION
ACTIVE BEFORE INSERT POSITION 0 
AS
BEGIN
    new.renovation_id = gen_id(setrenovation_id, 1);
END
</sql>

<sql>ALTER TRIGGER BI_SETRENOVATION_ID INACTIVE</sql> 

<sql>SET GENERATOR SETRENOVATION_ID TO 100</sql> 

<sql>insert into renovation (RENOVATION_ID,NAME,INDATE,TEXT) values (100,'Обновление №1','2003-07-18',
'	- Создано информационное окно о текущих обновления программы;
	- Добавлен параметр регулирующий дату окончания срока доверенности (сегодняшняя дата + три года +/- параметр настройки в днях);
	- Произведена глобализация списков подстановок для всех элементов ввода форм;
	- Для повышения скорости заполнения форм добавлена функция автоматического открытия значений подстановок;
	- Введен интуитивный механизм присвоения номера по реестру;
	- Поле ввода номера перенесено вниз формы;
	- Добавлена кнопка запроса следующего номера по реестру
	- При не заполнении номера документ автоматически попадает в отложенные документы;
	- Перефразирован вопрос при отмене редактирования формы документа
	- Выбор наследственного дела при подготовке документов, стал возможен только для документов связанных с таковыми;
	- Изменен общий вид дерева документов
	- Появилась возможность выстроить по желанию записи в справочниках подстановок и их значений (часто используемые – на первое место)
	- Внедрен механизм защиты от случайных удалений документов из реестра;
	- Добавлен новый элемент «Дата» позволяющий быстрее вводить информацию, или не вводить её совсем;
	- Кардинально изменен и упрощен механизм автоматического создания элементов формы при изменении или создании нового шаблона документа;
	- Для элементов не имеющих заголовка, он добавлен
	- Введены подсказки ввода для каждого элемента с их автоматическим отображением
	- Добавлена информационная панель с справочником напоминаний
')</sql>

<sql>ALTER TRIGGER BI_SETRENOVATION_ID ACTIVE</sql>

<sql>alter table subs add priority smallint</sql>

<sql>alter table subsvalue add priority smallint</sql>

<sql>update subs set priority=1</sql>

<sql>update subsvalue set priority=1</sql>

<sql>ALTER TABLE CONST ADD CONSTRAINT CONST_R1 FOREIGN KEY (RENOVATION_ID) REFERENCES RENOVATION(RENOVATION_ID)</sql>

<sql>ALTER TABLE DOC ADD CONSTRAINT DOC_R1 FOREIGN KEY (RENOVATION_ID) REFERENCES RENOVATION(RENOVATION_ID)</sql>

<sql>ALTER TABLE SUBSVALUE ADD CONSTRAINT R_5_SUBSVALUE FOREIGN KEY (SUBS_ID) REFERENCES SUBS(SUBS_ID) ON UPDATE CASCADE</sql>

<sql>update doc set renovation_id=100</sql>

<sql>update const set renovation_id=100</sql>

<sql>SET STATISTICS INDEX XPKSUBS</sql>

<sql>SET STATISTICS INDEX XPKSUBSVALUE</sql>