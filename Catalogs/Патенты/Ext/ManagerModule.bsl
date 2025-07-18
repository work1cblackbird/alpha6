﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список патентов, полученных данной организацией.
//
// Параметры:
//  Организация    - СправочникСсылка.Организации - Организация, патенты которой требуется получить.
//  ПериодДействия - Дата, Неопределено - если указан, будут отобраны только действующие в указанную дату патенты.
//
// Возвращаемое значение:
//   Массив   - список патентов организации.
//
Функция ДоступныеПатенты(Владелец = Неопределено, ПериодДействия = Неопределено) Экспорт
	
	Патенты = Новый Массив;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Патенты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Патенты КАК Патенты
	|ГДЕ
	|	НЕ Патенты.ПометкаУдаления
	|	И &УсловиеВладелец
	|	И &УсловиеПериодДействия
	|
	|УПОРЯДОЧИТЬ ПО
	|	Патенты.Наименование";
	
	Если ЗначениеЗаполнено(Владелец) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеВладелец", "Патенты.Владелец = &Владелец");
		Запрос.УстановитьПараметр("Владелец", Владелец);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеВладелец", "ИСТИНА");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПериодДействия) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПериодДействия",
			"(Патенты.ДатаНачала <= &ДатаНачала
			|	ИЛИ Патенты.ДатаНачала = &ПустаяДата)
			|И (Патенты.ДатаОкончания >= &ДатаОкончания
			|	ИЛИ Патенты.ДатаОкончания = &ПустаяДата)");
		Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(ПериодДействия));
		Запрос.УстановитьПараметр("ДатаОкончания", НачалоДня(ПериодДействия));
		Запрос.УстановитьПараметр("ПустаяДата", Дата(1, 1, 1));
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПериодДействия", "ИСТИНА");
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Патенты = Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	
	Возврат Патенты;
	
КонецФункции

// Возвращает сведения о патентах организации, действовавших в указанный период.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - организация, по которой запрашиваются сведения.
//  ДатаНачала - Дата - начало периода, за который требуются сведения о патентах.
//  ДатаОкончания - Дата - конец периода, за который требуются сведения о патентах.
//
// Возвращаемое значение:
//   ТаблицаЗначений  - сведения о действующих в указанный период патентах. Колонки:
//    * Ссылка - СправочникСсылка.Патенты - ссылка на патент
//    * Наименование - Строка - наименование патента в программе
//    * ДатаНачала - Дата - день начала срока действия патента
//    * ДатаОкончания - Дата - день окончания срока действия патента
//    * ДатаВыдачи - Дата - дата выдачи патента
//
Функция ПатентыОрганизацииЗаПериод(Организация, ДатаНачала, ДатаОкончания) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",   Организация);
	Запрос.УстановитьПараметр("ДатаНачала",    НачалоДня(ДатаНачала));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ДатаОкончания));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Патенты.Ссылка КАК Ссылка,
	|	Патенты.Наименование КАК Наименование,
	|	Патенты.ДатаНачала КАК ДатаНачала,
	|	Патенты.ДатаОкончания КАК ДатаОкончания,
	|	Патенты.ДатаВыдачи КАК ДатаВыдачи
	|ИЗ
	|	Справочник.Патенты КАК Патенты
	|ГДЕ
	|	Патенты.Владелец = &Организация
	|	И (Патенты.ДатаОкончания МЕЖДУ &ДатаНачала И &ДатаОкончания
	|			ИЛИ Патенты.ДатаНачала МЕЖДУ &ДатаНачала И &ДатаОкончания
	|			ИЛИ &ДатаНачала МЕЖДУ Патенты.ДатаНачала И Патенты.ДатаОкончания
	|			ИЛИ &ДатаОкончания МЕЖДУ Патенты.ДатаНачала И Патенты.ДатаОкончания)";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Возвращает признак доступности пользователю более одного патента на указанную дату.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - Организация, количество патентов у которой необходимо проверить.
//  Дата - Дата - Дата, на которую необходимо проверить количество патентов.
//
// Возвращаемое значение:
//  Булево - Признак доступности текущему пользователю нескольких патентов.
//
Функция ИспользуетсяНесколькоПатентов(Организация, Дата) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Период", Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Патенты.Ссылка) КАК КоличествоПатентов
	|ИЗ
	|	Справочник.Патенты КАК Патенты
	|ГДЕ
	|	Патенты.ДатаНачала <= КОНЕЦПЕРИОДА(&Период, ДЕНЬ)
	|	И Патенты.ДатаОкончания >= НАЧАЛОПЕРИОДА(&Период, ДЕНЬ)
	|	И Патенты.Владелец = &Организация
	|	И НЕ Патенты.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КоличествоПатентов > 1;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область ПараметрыОбработкиРеквизитовОбъекта

// Производит формирование параметров проверки заполнения реквизитов объекта на предмет обязательности.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - Объект, для которого выполняется получение параметров проверки.
//
// Возвращаемое значение:
//  Массив - Возвращаемый массив содержит строковые идентификаторы реквизитов.
//
Функция ПолучитьОбязательныеРеквизиты(Объект) Экспорт
	
	// Обязательные реквизиты объекта
	ОбязательныеРеквизиты = Новый Массив();
	ОбязательныеРеквизиты.Добавить("Наименование");
	ОбязательныеРеквизиты.Добавить("ДатаНачала");
	ОбязательныеРеквизиты.Добавить("ДатаОкончания");
	ОбязательныеРеквизиты.Добавить("НомерПатента");
	ОбязательныеРеквизиты.Добавить("ДатаВыдачи");
	ОбязательныеРеквизиты.Добавить("КБК");
	ОбязательныеРеквизиты.Добавить("ПотенциальноВозможныйГодовойДоход");
	ОбязательныеРеквизиты.Добавить("КодПоОКТМО");
	ОбязательныеРеквизиты.Добавить("КодНалоговогоОргана");
	// Возвращаем сформированные параметры проверки
	Возврат ОбязательныеРеквизиты;
	
КонецФункции // ПолучитьОбязательныеРеквизиты()

// Производит формирование параметров проверки заполнения реквизитов объекта на предмет уникальности.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - Объект, для которого выполняется получение параметров проверки.
//
// Возвращаемое значение:
//  Структура - Возвращаемая структура содержит строковые идентификаторы реквизитов.
//  Для описания проверки табличных частей используется
//  вложенная структура.
//
Функция ПолучитьУникальныеРеквизиты(Объект) Экспорт
	
	// Структура уникальных реквизитов
	УникальныеРеквизиты = Новый Структура();
	УникальныеРеквизиты.Вставить("Код");
	
	// Возвращаем сформированные параметры проверки
	Возврат УникальныеРеквизиты;
	
КонецФункции // ПолучитьОбязательныеРеквизиты()

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)

	Если Параметры.Отбор.Свойство("Владелец") Тогда 
		Владелец = Параметры.Отбор.Владелец;
	КонецЕсли;
	Если Параметры.Отбор.Свойство("ДатаНачала") Тогда 
		ПериодДействия = Параметры.Отбор.ДатаНачала;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Владелец) ИЛИ ЗначениеЗаполнено(ПериодДействия) Тогда
		
		ДоступныеПатенты = ДоступныеПатенты(Владелец, ПериодДействия);
		Параметры.Отбор.Очистить();
		Параметры.Отбор.Вставить("Ссылка", Новый ФиксированныйМассив(ДоступныеПатенты));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
