﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы "Заполнение по документу основанию"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

// Обработчик события возникающего на сервере при создании формы.
//
// Параметры:
//  Отказ                - Булево - Признак отказа от создания формы.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СценарийПланирования             = ПолучитьЗначениеПараметраСтруктуры(Параметры, "СценарийПланирования",             Неопределено);
	ДокументОснование                = ПолучитьЗначениеПараметраСтруктуры(Параметры, "ДокументОснование",                Неопределено);
	ТипЦен                           = ПолучитьЗначениеПараметраСтруктуры(Параметры, "ТипЦен",                           Неопределено);
	КурсДокумента                    = ПолучитьЗначениеПараметраСтруктуры(Параметры, "КурсДокумента",                    0);
	Дата                             = ПолучитьЗначениеПараметраСтруктуры(Параметры, "Дата",                             Неопределено);
	ПодразделениеКомпании            = ПолучитьЗначениеПараметраСтруктуры(Параметры, "ПодразделениеКомпании",            Неопределено);
	ДатаПланирования                 = ПолучитьЗначениеПараметраСтруктуры(Параметры, "ДатаПланирования",                 Неопределено);
	Владелец                         = ПолучитьЗначениеПараметраСтруктуры(Параметры, "Владелец",                         Неопределено);
	
	Если НЕ ЗначениеЗаполнено(СценарийПланирования) ИЛИ НЕ ЗначениеЗаполнено(СценарийПланирования.Периодичность) Тогда
		ОбщегоНазначения.СообщитьПользователю(Нстр("ru = 'Не выбран сценарий планирования, либо у выбранного сценария не указана периодичность.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// видимость колонок в ТЧ Автоработы
	Элементы.АвтоработыСуммаВсегоУпр.Видимость = Ложь;
	
	// Заполним табличное поле
	ЗаполнитьТабличноеПоле();
	
	// Заполним надпись с типом цены
	ПараметрыНадписи = Новый Структура;
	ПараметрыНадписи.Вставить("ТипЦен",                    ТипЦен);
	ПараметрыНадписи.Вставить("КурсДокумента",             КурсДокумента);
	ПараметрыНадписи.Вставить("НадписьИнформацияОТипеЦен", Элементы.НадписьИнформацияОТипеЦен);
	ПланированиеСервер.СформироватьНадписьТипаЦены(ПараметрыНадписи);
	
	НастроитьПараметрыВыбораДокументаОснование();
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Обработчик события возникающего при изменении данных реквизита "ДокументОснование" в контексте сервера.
//
&НаСервере
Процедура ДокументОснованиеПриИзмененииНаСервере()
	
	ЗаполнитьТабличноеПоле();
	
КонецПроцедуры // ДокументОснованиеПриИзмененииНаСервере()

// Обработчик события возникающего на клиенте при изменении данных реквизита "ДокументОснование".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	ДокументОснованиеПриИзмененииНаСервере();
	
КонецПроцедуры // ДокументОснованиеПриИзменении()

// Обработчик события возникающего на клиенте перед началом выбора данных реквизита "ДокументОснование".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура ДокументОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ОтборДатаКонца", ПараметрыПериода.ДатаКонца);
	ПараметрыФормы.Вставить("Отбор", Новый Структура("ПодразделениеКомпании", ПодразделениеКомпании));
	
	Если ЗначениеЗаполнено(Владелец) Тогда
		ПараметрыФормы.Вставить("ОтборДокументИсключение", Владелец);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ОтборПоСценариюПланирования", СписокСценарияПланирования);
	
	ОткрытьФорму("Документ.БюджетОказанияУслугПоАвтоработам.ФормаСписка", ПараметрыФормы, Элемент);
	
КонецПроцедуры // ДокументОснованиеНачалоВыбора()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик события нажатия кнопки "ОК" на клиенте
//
&НаКлиенте
Процедура ОК(Команда)
	
	Если НЕ ЗначениеЗаполнено(ДокументОснование) Тогда
		
		ОбработкаОповещения = Новый ОписаниеОповещения("СформироватьИтогововуюТаблицу", ЭтотОбъект, "ЗакрытьОкно");
		ПоказатьВопрос(ОбработкаОповещения, Нстр("ru = 'Не выбран документ-основание! Закрыть форму без сохранения?'"), РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	СформироватьИтогововуюТаблицуАвторабот();
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("ДокументОснование", ДокументОснование);
	
	ТаблицаРезультата = Новый Массив;
	Для Каждого ТекСтрока Из Результат Цикл
		
		НоваяСтрока = Новый Структура("Авторабота, Количество, Цена, СуммаВсегоУпр, СуммаНДС, СтавкаНДС", 
		                              ТекСтрока.Авторабота, ТекСтрока.Количество, ТекСтрока.Цена, ТекСтрока.СуммаВсегоУпр, ТекСтрока.СуммаНДС, ТекСтрока.Ставка);
		ТаблицаРезультата.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	РезультатВыбора.Вставить("ТаблицаАвторабот", ТаблицаРезультата);
	РезультатВыбора.Вставить("СпособПоследнегоЗаполнения", 2);
	
	Закрыть(РезультатВыбора);
	
КонецПроцедуры // ОК()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет таблицу по табличной части документа основания
//
&НаСервере
Процедура ЗаполнитьТабличноеПоле()
	
	Если НЕ ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	Автоработы.ПолучитьЭлементы().Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	ТаблицаДанных.Авторабота.Наименование КАК Представление,
				   |	ТаблицаДанных.Авторабота КАК Авторабота,
				   |	ТаблицаДанных.Цена,
				   |	ТаблицаДанных.Количество,
				   |	0 КАК СуммаВсегоУпр,
				   |	ТаблицаДанных.СуммаВсегоУпр КАК СуммаВсегоУпрНеРаспред,
				   |	ТаблицаДанных.СуммаНДС
				   |ИЗ
				   |	Документ.БюджетОказанияУслугПоАвтоработам.Автоработы КАК ТаблицаДанных
				   |ГДЕ
				   |	ТаблицаДанных.Ссылка = &Ссылка
				   |УПОРЯДОЧИТЬ ПО Представление";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	Выборка = Запрос.Выполнить().Выбрать();
	Сч = 1;
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Автоработы.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.Ставка = НоваяСтрока.Авторабота.Номенклатура.СтавкаНДС.Ставка;
		НоваяСтрока.СтавкаНДС = Строка(НоваяСтрока.Ставка) + "%";
		Сч = Сч + 1;
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьТабличноеПоле()

// Формирвание параметров выбора документа основания
//
&НаСервере
Процедура НастроитьПараметрыВыбораДокументаОснование()
	
	ПараметрыПериода = Новый Структура;
	ПараметрыПериода.Вставить("ДатаИзПериода", ДатаПланирования);
	ПараметрыПериода.Вставить("Периодичность", СценарийПланирования.Периодичность);
	ПараметрыПериода.Вставить("Действие", 0);
	ПланированиеСервер.ПолучитьДатыПланируемогоПериода(ПараметрыПериода);
	
	// Отбор по периодичности
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СценарииПланирования.Ссылка
	|ИЗ
	|	Справочник.СценарииПланирования КАК СценарииПланирования
	|ГДЕ
	|	СценарииПланирования.ЭтоГруппа = ЛОЖЬ
	|	И СценарииПланирования.Периодичность = &Периодичность";
	Запрос.УстановитьПараметр("Периодичность", СценарийПланирования.Периодичность);
	СписокСценарияПланирования.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

//  Обработчик формирования результирующей таблицы
//
&НаСервере
Процедура СформироватьИтогововуюТаблицуАвторабот()
	
	ПараметрыДанных = Новый Структура;
	ПараметрыДанных.Вставить("ТабличнаяЧасть", Результат);
	ПараметрыДанных.Вставить("ДеревоЗначений", РеквизитФормыВЗначение("Автоработы"));
	ПараметрыДанных.Вставить("ДвухУровневоеДерево", Ложь);
	ПараметрыДанных.Вставить("ИмяПоляПриемника", "Авторабота");
	ПараметрыДанных.Вставить("ИмяПоляИсточника", "Авторабота");
	
	ПланированиеСервер.ЗаполнитьТабличнуюЧастьПоДеревуЗначений(ПараметрыДанных);
	
КонецПроцедуры // СформироватьИтогововуюТаблицуАвтомобилей()

// Обработчик для загрузки результата 
//
&НаКлиенте
Процедура СформироватьИтогововуюТаблицу(Результат, ДопонительныеПраметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры // СформироватьИтогововуюТаблицу()

#КонецОбласти

