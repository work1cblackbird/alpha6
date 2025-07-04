﻿// Общий модуль "Обработка событий регистра (сервер)"

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ОБЪЕКТА

// Устарела. Будет удалена.
// Общий обработчик события заполнения объекта как при создании нового, так и при вводе на основании существующего.
//
// Параметры:
//  Объект						- СправочникОбъект	- Объект, для которого выполняется обработка события.
//  ДанныеЗаполнения			- Произвольный		- Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка		- Булево			- В данный параметр передается признак выполнения системной обработки события.
//  ИменаИсключаемыхРеквизитов	- Строка			- текст, содержащий имена реквизитов, которые не будут заполняться.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события
//
Функция ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка, ИменаИсключаемыхРеквизитов="") Экспорт
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат ИСТИНА;
	
КонецФункции // ОбработкаЗаполнения()

// Общий обработчик события заполнения объекта как при создании нового, так и при вводе на основании существующего.
//
// Параметры:
//  Объект            - СправочникОбъект - Объект, для которого выполняется обработка события.
//  ОбъектКопирования - СправочникОбъект - Исходный объект, который является источником копирования.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события
//
Функция ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат ИСТИНА;
	
КонецФункции // ПриКопировании()

// Общий обработчик события возникающего при необходимости проверки заполнения реквизитов при записи объекта.
//
// Параметры:
//  Объект               - СправочникОбъект - Объект, для которого выполняется обработка события.
//  Отказ                - Булево - Признак отказа от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события
//
Функция ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	// Проверку обязательных реквизитов производим по данным служебных функций из модуля менеджера.
	ПроверяемыеРеквизиты.Очистить();
	
	// Получим признак обработки события в упрощенном режиме, когда проверка корректности не производится.
	Если ОбработкаСобытийОбъектаСервер.РежимУпрощеннойЗагрузкиОбъекта(Объект) Тогда
		Возврат ЛОЖЬ;
	КонецЕсли;
	
	// Выполняем общую проверку корректности заполнения объекта
	ОбработкаСобытийОбъектаСервер.ПроверитьЗаполнениеРеквизитовОбъекта(Объект, Отказ, ПроверяемыеРеквизиты);
	
	// Выполняем общую проверку соответствия установленным в конфигураторе параметрам выбора.
	ОбработкаСобытийОбъектаСервер.ПроверитьПараметрыВыбораРеквизитовОбъекта(Объект, Отказ);
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат ИСТИНА;
	
КонецФункции // ОбработкаПроверкиЗаполнения()

// Устарела. Будет удалена.
// Общий обработчик события возникающего после начала транзакции записи, но до начала записи объекта.
//
// Параметры:
//  Объект - СправочникОбъект - Объект, для которого выполняется обработка события.
//  Отказ  - Булево           - Признак отказа от совершения операции.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события
//
Функция ПередЗаписью(Объект, Отказ) Экспорт
	
	// Получим признак обработки события в упрощенном режиме, когда проверка корректности не производится.
	Если ОбработкаСобытийОбъектаСервер.РежимУпрощеннойЗагрузкиОбъекта(Объект) Тогда
		Возврат ЛОЖЬ;
	КонецЕсли;
	
	// Проверка на допустимость редактирования по датам разрешенного интервала редактирования.
	ПроверкаДатыЗапретаИзменения = ПолучитьЗначениеПараметраСтруктуры(Объект.ДополнительныеСвойства, "ПроверкаДатыЗапретаИзменения",             ИСТИНА);
	Если ПроверкаДатыЗапретаИзменения Тогда
		
		// Вызываем обработчик из подсистемы БСП
		ДатыЗапретаИзменения.ПроверитьДатуЗапретаИзмененияПередЗаписьюНабораЗаписей(Объект,Отказ,Ложь);
		
	КонецЕсли;
	
	// Дальнейшие операции будем выполнять только в случае успешного выполнения предшествующих.
	Если Отказ Тогда
		Возврат ИСТИНА;
	КонецЕсли;
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат ИСТИНА;
	
КонецФункции // ПередЗаписью()

// Общий обработчик события возникающего после записи объекта в базу данных, но до окончания транзакции записи.
//
// Параметры:
//  Объект - СправочникОбъект - Объект, для которого выполняется обработка события.
//  Отказ  - Булево           - Признак отказа от совершения операции.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события
//
Функция ПриЗаписи(Объект, Отказ) Экспорт
	
	// Получим признак обработки события в упрощенном режиме, когда проверка корректности не производится.
	Если ОбработкаСобытийОбъектаСервер.РежимУпрощеннойЗагрузкиОбъекта(Объект) Тогда
		Возврат ЛОЖЬ;
	КонецЕсли;
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат ИСТИНА;
	
КонецФункции // ПриЗаписи()

// Общий обработчик события возникающего в транзакции удаления перед непосредственным удалением объекта из базы данных.
//
// Параметры:
//  Объект - СправочникОбъект - Объект, для которого выполняется обработка события.
//  Отказ  - Булево           - Признак отказа от совершения операции.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события
//
Функция ПередУдалением(Объект, Отказ) Экспорт
	
	// Получим признак обработки события в упрощенном режиме, когда проверка корректности не производится.
	Если ОбработкаСобытийОбъектаСервер.РежимУпрощеннойЗагрузкиОбъекта(Объект) Тогда
		Возврат ЛОЖЬ;
	КонецЕсли;
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат ИСТИНА;
	
КонецФункции // ПередУдалением()

// Производит формирование параметров проверки заполнения реквизитов объекта на предмет обязательности.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - Объект, для которого выполняется получение параметров проверки.
//
// Возвращаемое значение:
//  Массив - Возвращаемый массив содержит строковые идентификаторы реквизитов.
//
Функция ПолучитьСтандартныеОбязательныеРеквизиты(Объект) Экспорт
	
	// Обязательные реквизиты документа
	ОбязательныеРеквизиты = Новый Массив();
	
	// Получим параметры текущего проверяемого объекта
	ОбъектМетаданных = Объект.Метаданные();
	
	Для Каждого Измерение Из ОбъектМетаданных.Измерения Цикл
		Если
			ОбязательныеРеквизиты.Найти(Измерение.Имя) = Неопределено
			И (Измерение.ЗапрещатьНезаполненныеЗначения ИЛИ Измерение.ПроверкаЗаполнения = ПроверкаЗаполнения.ВыдаватьОшибку)
		Тогда
			ОбязательныеРеквизиты.Добавить(Измерение.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Ресурс Из ОбъектМетаданных.Ресурсы Цикл
		Если ОбязательныеРеквизиты.Найти(Ресурс.Имя) = Неопределено
			И Ресурс.ПроверкаЗаполнения = ПроверкаЗаполнения.ВыдаватьОшибку Тогда
			ОбязательныеРеквизиты.Добавить(Ресурс.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
		Если ОбязательныеРеквизиты.Найти(Реквизит.Имя) = Неопределено
			И Реквизит.ПроверкаЗаполнения = ПроверкаЗаполнения.ВыдаватьОшибку Тогда
			ОбязательныеРеквизиты.Добавить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	// Возвращаем сформированные параметры проверки
	Возврат ОбязательныеРеквизиты;

КонецФункции // ПолучитьСтандартныеОбязательныеРеквизиты()

#КонецОбласти
