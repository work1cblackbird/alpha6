﻿// Модуль документа "Перемещение денежных средств"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Обработчик события объекта возникает в момент, когда выполняется установка нового номера.
//
// Параметры:
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//  Префикс              - Строка - Префикс, который будет использоваться для генерации номера.
//
Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	// Вызываем общий обработчик события
	ПрефиксацияОбъектов.ПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
	
КонецПроцедуры // ПриУстановкеНовогоНомера()

// Обработчик события заполнения объекта как при создании нового, так и при вводе на основании существующего.
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения = "", СтандартнаяОбработка = Истина)
	
	// Вызываем общий обработчик события
	ПродолжитьВыполнение = ОбработкаСобытийДокументаСервер.ОбработкаЗаполнения(
		ЭтотОбъект,
		ДанныеЗаполнения,
		ТекстЗаполнения,
		СтандартнаяОбработка
	);
	Если НЕ ПродолжитьВыполнение Тогда
		Возврат;
	КонецЕсли;
	
	Если ХозОперация = Справочники.ХозОперации.ПеремещениеДенежныхСредств Тогда
		КассаКомпанииПолучатель = Справочники.КассыКомпании.ПустаяСсылка();
	Иначе
		КассаКомпанииПолучатель = Справочники.БанковскиеСчета.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполнения()

// Обработчик события заполнения объекта копированием.
//
// Параметры:
//  ОбъектКопирования - ДокументОбъект - Исходный объект, который является источником копирования.
//
Процедура ПриКопировании(ОбъектКопирования)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ПриКопировании(ЭтотОбъект, ОбъектКопирования) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ПриКопировании()

// Обработчик события возникающего при необходимости проверки заполнения реквизитов при записи или при проведении.
//
// Параметры:
//  Отказ                - Булево - Признак отказа от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(КассаКомпанииПолучатель) = Тип("СправочникСсылка.БанковскиеСчета")
		И НЕ ЗначениеЗаполнено(КассаКомпанииПолучатель) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Поле ""Расчетный счет"" не заполнено'"), ЭтотОбъект, , , Отказ);
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("КассаКомпанииПолучатель"));
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Обработчик события возникающего после начала транзакции записи, но до начала записи объекта.
//
// Параметры:
//  Отказ           - Булево                   - Признак отказа от совершения операции.
//  РежимЗаписи     - РежимЗаписиДокумента     - Текущий режим записи документа.
//  РежимПроведения - РежимПроведенияДокумента - Текущий режим проведения.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// УтверждениеДокумментов
	УтверждениеДокументовСервер.ОбработкаУтвержденияПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	// Конец УтверждениеДокументов
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Обработчик события возникающего после записи объекта в базу данных, но до окончания транзакции записи.
//
// Параметры:
//  Отказ - Булево - Признак отказа от совершения операции.
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// УтверждениеДокумментов
	УтверждениеДокументовСервер.ОбработкаУтвержденияПриЗаписи(ЭтотОбъект, Отказ);
	// Конец УтверждениеДокументов
	
КонецПроцедуры // ПриЗаписи()

// Обработчик события возникающего в транзакции удаления перед непосредственным удалением объекта из базы данных.
//
// Параметры:
//  Отказ - Булево - Признак отказа от совершения операции.
//
Процедура ПередУдалением(Отказ)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ПередУдалением(ЭтотОбъект, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ПередУдалением()

// Обработчик события возникающего при отмене проведения документа. Выполняется в транзакции записи.
//
// Параметры:
//  Отказ - Булево - Признак отказа от совершения операции.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

// Обработчик события возникающего в транзакции записи для формирования движений документу по подчиненным регистрам.
//
// Параметры:
//  Отказ           - Булево                   - Признак отказа от совершения операции.
//  РежимПроведения - РежимПроведенияДокумента - Текущий режим проведения.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения) Тогда
		Возврат;
	КонецЕсли;
	
	// расходуем деньги из кассы
	НаборЗаписейДС                    = Движения.ДенежныеСредстваКомпании;
	НаборЗаписейДС.ДокументОбъект     = ЭтотОбъект;
	НаборЗаписейДС.РежимПроведения    = РежимПроведения;
	НаборЗаписейДС.СтруктурнаяЕдиница = КассаКомпанииОтправитель;
	НаборЗаписейДС.Валюта             = Неопределено;
	НаборЗаписейДС.СтатьяДДС          = СтатьяДДС;
	НаборЗаписейДС.Сумма              = СуммаДокумента;
	НаборЗаписейДС.КонтрольВалют	  = Ложь;
	Если НЕ НаборЗаписейДС.Расход() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	// приходуем деньги в кассу
	НаборЗаписейДС                    = Движения.ДенежныеСредстваКомпании;
	НаборЗаписейДС.ДокументОбъект     = ЭтотОбъект;
	НаборЗаписейДС.РежимПроведения    = РежимПроведения;
	НаборЗаписейДС.СтруктурнаяЕдиница = КассаКомпанииПолучатель;
	НаборЗаписейДС.Валюта             = Неопределено;
	НаборЗаписейДС.СтатьяДДС          = СтатьяДДС;
	НаборЗаписейДС.Сумма              = СуммаДокумента;
	НаборЗаписейДС.КонтрольВалют	  = Ложь;
	Если НЕ НаборЗаписейДС.Приход() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	// БАЛАНС: Возможно что подразделения отправителя и получателя не равны в этом случае:
	// Уменьшаем доход на подразделении отправителе;
	// Увеличиваем доход на подразделении получателе.
	БалансВедетсяПоПодразделениям  = БалансВедетсяПоПодразделениям(Дата);
	ПодразделениеОтправитель       = Справочники.ПодразделенияКомпании.ПолучитьБалансовоеПодразделение(КассаКомпанииОтправитель.ПодразделениеКомпании, Дата);
	ПодразделениеПолучатель        = Справочники.ПодразделенияКомпании.ПолучитьБалансовоеПодразделение(КассаКомпанииПолучатель.ПодразделениеКомпании, Дата);
	БалансовыеПодразделенияНеРавны = ПодразделениеОтправитель <> ПодразделениеПолучатель;
	
	Если БалансВедетсяПоПодразделениям И БалансовыеПодразделенияНеРавны Тогда
		ТаблицаДвиженийДСК = Движения.ДенежныеСредстваКомпании.Выгрузить();
		ТаблицаДвиженийДСК.Свернуть("ВидДвижения","СуммаУпр");
		
		// Получим сумму расхода
		СтрокаТаблицаДвиженийДСК = ТаблицаДвиженийДСК.Найти(ВидДвиженияНакопления.Расход, "ВидДвижения");
		СуммаРасход = 0;
		Если СтрокаТаблицаДвиженийДСК <> Неопределено Тогда
			СуммаРасход = СтрокаТаблицаДвиженийДСК.СуммаУпр;
		КонецЕсли;
		
		// Получим сумму дохода
		СтрокаТаблицаДвиженийДСК = ТаблицаДвиженийДСК.Найти(ВидДвиженияНакопления.Приход, "ВидДвижения");
		СуммаДоход = 0;
		Если СтрокаТаблицаДвиженийДСК <> Неопределено Тогда
			СуммаДоход = СтрокаТаблицаДвиженийДСК.СуммаУпр;
		КонецЕсли;
		
		// Уменьшаем доход
		НаборЗаписейДиР = Движения.ДоходыИРасходы;
		НаборЗаписейДиР.Подразделение = КассаКомпанииОтправитель.ПодразделениеКомпании;
		НаборЗаписейДиР.ДокументОбъект = ЭтотОбъект;
		НаборЗаписейДиР.СтатьяДоходовИРасходов = Справочники.СтатьиДоходовИРасходов.КорректировкаБалансаПоПодразделениям;
		НаборЗаписейДиР.ВУпрВалюте = Истина;
		НаборЗаписейДиР.Доход  = СуммаРасход;
		НаборЗаписейДиР.Расход = 0;
		Если НЕ НаборЗаписейДиР.Расход() Тогда
			Отказ = Истина;
		КонецЕсли;
		
		// Увеличиваем доход
		НаборЗаписейДиР = Движения.ДоходыИРасходы;
		НаборЗаписейДиР.Подразделение = КассаКомпанииПолучатель.ПодразделениеКомпании;
		НаборЗаписейДиР.ДокументОбъект = ЭтотОбъект;
		НаборЗаписейДиР.СтатьяДоходовИРасходов = Справочники.СтатьиДоходовИРасходов.КорректировкаБалансаПоПодразделениям;
		НаборЗаписейДиР.ВУпрВалюте = Истина;
		НаборЗаписейДиР.Доход = СуммаДоход;
		НаборЗаписейДиР.Расход = 0;
		Если НЕ НаборЗаписейДиР.Приход() Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	НаборЗаписейПлатежныйКалендарь = Движения.ПлатежныйКалендарь;
	
	Для Каждого ДенежныеСредстваКомпанииДвижения Из НаборЗаписейДС Цикл 
		ПлатежныйКалендарьДвижения = НаборЗаписейПлатежныйКалендарь.Добавить();
		ПлатежныйКалендарьДвижения.Период = ДенежныеСредстваКомпанииДвижения.Период;
		ПлатежныйКалендарьДвижения.Регистратор = Ссылка;
		ПлатежныйКалендарьДвижения.Валюта = ДенежныеСредстваКомпанииДвижения.Валюта;
		ПлатежныйКалендарьДвижения.СтруктурнаяЕдиница = ДенежныеСредстваКомпанииДвижения.СтруктурнаяЕдиница;
		ПлатежныйКалендарьДвижения.СтатьяДДС = ДенежныеСредстваКомпанииДвижения.СтатьяДДС;
		Если ДенежныеСредстваКомпанииДвижения.ВидДвижения = ВидДвиженияНакопления.Расход Тогда 
			ПлатежныйКалендарьДвижения.РасходФакт = ДенежныеСредстваКомпанииДвижения.Сумма;
		Иначе 
			ПлатежныйКалендарьДвижения.ПоступлениеФакт = ДенежныеСредстваКомпанииДвижения.Сумма;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ОбработкаПроведения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДоступенПросмотрОбъекта(Объект)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Объект);
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Ссылка
	|ИЗ
	|	%1
	|ГДЕ
	|	Ссылка = &Ссылка";
	Запрос.Текст = СтрШаблон(ТекстЗапроса, Объект.Метаданные().ПолноеИмя());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции



#Область ОбработчикиЗаполненияОбъекта

// Производит заполнение объекта на основании документа "Приходный кассовый ордер"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ПриходныйКассовыйОрдер(ДанныеЗаполнения,
	ТекстЗаполнения = "",
	СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Вызываем общий обработчик заполнения
	ПродолжитьВыполнение = ОбработкаСобытийДокументаСервер.ОбработкаЗаполненияНаОсновании(
		ЭтотОбъект,
		ДанныеЗаполнения,
		ТекстЗаполнения,
		СтандартнаяОбработка
	);
	Если НЕ ПродолжитьВыполнение Тогда
		Возврат Истина;
	КонецЕсли;
	
	СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_ПриходныйКассовыйОрдер()

#КонецОбласти


#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

#КонецЕсли
