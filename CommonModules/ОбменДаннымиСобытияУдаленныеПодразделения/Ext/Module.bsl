﻿// Общий модуль "Обмен данными события - Удаленные подразделения (сервер)"

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ПОДПИСОК НА СОБЫТИЯ

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник		 - ДокументОбъект			 - источник события
//  Отказ			 - Булево					 - флаг отказа от выполнения обработчика.
//  РежимЗаписи		 - РежимЗаписиДокумента		 - Текущий режим записи.
//  РежимПроведения	 - РежимПроведенияДокумента	 - Текущий режим проведения.
// 
Процедура ПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	// Выполним базовые проверки возможности регистрации изменений источника
	Если Отказ ИЛИ ПолучитьЗначениеПараметраСтруктуры(Источник.ДополнительныеСвойства, "ОтключитьМеханизмРегистрацииОбъектов", ЛОЖЬ) ИЛИ Метаданные.ПланыОбмена.УдаленныеПодразделения.Состав.Найти(Источник.Метаданные())=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Вызываем обработчик регистрации объекта к выгрузке
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("УдаленныеПодразделения", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры // ПередЗаписьюДокумента()

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных
// (кроме документов) для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник       - Произвольный - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
//
Процедура ПередЗаписью(Источник, Отказ) Экспорт
	
	// Выполним базовые проверки возможности регистрации изменений источника
	Если Отказ ИЛИ ПолучитьЗначениеПараметраСтруктуры(Источник.ДополнительныеСвойства, "ОтключитьМеханизмРегистрацииОбъектов", ЛОЖЬ) ИЛИ Метаданные.ПланыОбмена.УдаленныеПодразделения.Состав.Найти(Источник.Метаданные())=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Вызываем обработчик регистрации объекта к выгрузке
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("УдаленныеПодразделения", Источник, Отказ);
	
КонецПроцедуры // ПередЗаписью()

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей.
// 
Процедура ПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	// Выполним базовые проверки возможности регистрации изменений источника
	Если Отказ ИЛИ ПолучитьЗначениеПараметраСтруктуры(Источник.ДополнительныеСвойства, "ОтключитьМеханизмРегистрацииОбъектов", ЛОЖЬ) ИЛИ Метаданные.ПланыОбмена.УдаленныеПодразделения.Состав.Найти(Источник.Метаданные())=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Отбросим объекты, которые должны участвовать в обмене, но не должны быть прописаны в подписке на событие.
	Если СтрНайти("ВерсииПодсистем,ВерсииПодсистемОбластейДанных,СоответствияОбъектовИнформационныхБаз", Источник.Метаданные().Имя) > 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Вызываем обработчик регистрации объекта к выгрузке
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("УдаленныеПодразделения", Источник, Отказ, Замещение);
	
КонецПроцедуры // ПередЗаписьюРегистра()

// Процедура-обработчик события "ПередЗаписью" константы для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник       - КонстантаМенеджерЗначения - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура ПередЗаписьюКонстанты(Источник, Отказ) Экспорт
	
	// Выполним базовые проверки возможности регистрации изменений источника
	Если Отказ ИЛИ ПолучитьЗначениеПараметраСтруктуры(Источник.ДополнительныеСвойства, "ОтключитьМеханизмРегистрацииОбъектов", ЛОЖЬ) ИЛИ Метаданные.ПланыОбмена.УдаленныеПодразделения.Состав.Найти(Источник.Метаданные())=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Отбросим объекты, которые должны участвовать в обмене, но не должны быть прописаны в подписке на событие.
	Если СтрНайти("ПараметрыАдминистрированияИБ,ПараметрыБазовойФункциональности,ПараметрыИтоговИАгрегатов,ПараметрыОграниченияДоступа,ПараметрыРаботыПользователей,ПараметрыСлужебныхСобытий,НастройкиПодчиненногоУзлаРИБ,СведенияОбОбновленииИБ", Источник.Метаданные().Имя) > 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Вызываем обработчик регистрации объекта к выгрузке
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюКонстанты("УдаленныеПодразделения", Источник, Отказ);
	
КонецПроцедуры // ПередЗаписьюКонстанты()

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник       - Произвольный - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура ПередУдалением(Источник, Отказ) Экспорт
	
	// Выполним базовые проверки возможности регистрации изменений источника
	Если Отказ ИЛИ ПолучитьЗначениеПараметраСтруктуры(Источник.ДополнительныеСвойства, "ОтключитьМеханизмРегистрацииОбъектов", ЛОЖЬ) ИЛИ Метаданные.ПланыОбмена.УдаленныеПодразделения.Состав.Найти(Источник.Метаданные())=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Вызываем обработчик регистрации объекта к выгрузке
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("УдаленныеПодразделения", Источник, Отказ);
	
КонецПроцедуры // ПередУдалением()

#КонецОбласти