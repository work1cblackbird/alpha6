﻿// Модуль менеджера регистра сведений "Префиксация объектов"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура сверяет список метаданных со списком регистра и удаляет или добавляет необходимые записи.
//
Процедура ВыполнитьНачальноеЗаполнение() Экспорт
	
	// сформирует текущую таблицу метаданных конфигурации
	ТаблицаМетаданных = Новый ТаблицаЗначений;
	ТаблицаМетаданных.Колонки.Добавить("Объект",Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(150)));
	ТаблицаМетаданных.Колонки.Добавить("ЕстьРегламентированныйУчет",Новый ОписаниеТипов("Булево"));
	
	Для Каждого Справочник Из Метаданные.Справочники Цикл
		НоваяСтрока                            = ТаблицаМетаданных.Добавить();
		НоваяСтрока.Объект                     = Справочник.ПолноеИмя();
	КонецЦикла;
	
	Для Каждого Документ Из Метаданные.Документы Цикл
		НоваяСтрока                            = ТаблицаМетаданных.Добавить();
		НоваяСтрока.Объект                     = Документ.ПолноеИмя();
		ЭлементВСоставе = Метаданные.ОбщиеРеквизиты.РегламентированныйУчет.Состав.Найти(Документ);
		Если ЭлементВСоставе <> Неопределено Тогда
			Если ЭлементВСоставе.Использование = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать Тогда
				НоваяСтрока.ЕстьРегламентированныйУчет = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// получим расхождения
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаМетаданных", ТаблицаМетаданных);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрефиксацияОбъектов.Объект                     КАК Объект,
	|	ПрефиксацияОбъектов.ЕстьРегламентированныйУчет КАК ЕстьРеглУчет
	|ПОМЕСТИТЬ ТаблицаМетаданных
	|ИЗ
	|	&ТаблицаМетаданных КАК ПрефиксацияОбъектов
	|;
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаМетаданных.Объект, """") КАК ОбъектМетаданных,
	|	ЕСТЬNULL(ПрефиксацияОбъектов.Объект, """") КАК Объект,
	|	ЕСТЬNULL(ТаблицаМетаданных.ЕстьРеглУчет, ЛОЖЬ) КАК ЕстьРеглУчет
	|ИЗ
	|	ТаблицаМетаданных КАК ТаблицаМетаданных
	|		ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.ПрефиксацияОбъектов КАК ПрефиксацияОбъектов
	|		ПО ТаблицаМетаданных.Объект = ПрефиксацияОбъектов.Объект
	|ГДЕ
	|	(ЕСТЬNULL(ТаблицаМетаданных.Объект, """") = """"
	|			ИЛИ ЕСТЬNULL(ПрефиксацияОбъектов.Объект, """") = """")";
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// удаляем или добавляем записи
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ПустаяСтрока(Выборка.ОбъектМетаданных) Тогда
			// удалим запись
			Менеджер = РегистрыСведений.ПрефиксацияОбъектов.СоздатьМенеджерЗаписи();
			Менеджер.Объект = Выборка.Объект;
			Менеджер.Удалить();
			Продолжить;
		КонецЕсли;
		
		Если ПустаяСтрока(Выборка.Объект) Тогда
			ЗначениеШаблона = ?(Выборка.ЕстьРеглУчет,"[П]","[О]");
			
			Если СтрНачинаетсяС(Выборка.ОбъектМетаданных, "Справочник") Тогда
				ЗначениеШаблона = "[У]";	
			КонецЕсли;
			
			// добавляем строку
			Менеджер = РегистрыСведений.ПрефиксацияОбъектов.СоздатьМенеджерЗаписи();
			
			Менеджер.Объект      = Выборка.ОбъектМетаданных;
			Менеджер.Шаблон      = ЗначениеШаблона;
			Менеджер.ПоУмолчанию = ЗначениеШаблона;
			Менеджер.Записать(Истина);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры // ВыполнитьНачальноеЗаполнение()

// устанавливает все шаблоны записи регистра в значение по умолчанию
Процедура ВосстановитьЗначенияПоУмолчанию() Экспорт
	НаборЗаписей = РегистрыСведений.ПрефиксацияОбъектов.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	Для Каждого Запись Из НаборЗаписей Цикл
		Запись.Шаблон = Запись.ПоУмолчанию;
	КонецЦикла;
	НаборЗаписей.Записать(Истина);
КонецПроцедуры

Процедура УстановитьСправочникамЗначениеПоУмолчанию() Экспорт
	
	Запрос          = Новый Запрос;
	Запрос.Текст    = 
	    "ВЫБРАТЬ
		|	ПрефиксацияОбъектов.Объект КАК Объект,
		|	ПрефиксацияОбъектов.Шаблон КАК Шаблон,
		|	ПрефиксацияОбъектов.ПоУмолчанию КАК ПоУмолчанию
		|ИЗ
		|	РегистрСведений.ПрефиксацияОбъектов КАК ПрефиксацияОбъектов";
	
	НаборЗаписей = РегистрыСведений.ПрефиксацияОбъектов.СоздатьНаборЗаписей();
	НаборЗаписей.Загрузить(Запрос.Выполнить().Выгрузить());
	НаборЗаписей.Прочитать();
	
	Для Каждого Запись Из НаборЗаписей Цикл
		Если СтрНачинаетсяС(Запись.Объект, "Справочник") Тогда
			Запись.ПоУмолчанию = "[У]";
		КонецЕсли;
	КонецЦикла;
	
	НаборЗаписей.Записать();	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли