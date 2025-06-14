﻿// Модуль документа "Изменение цен"

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
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ОбработкаЗаполнения_Структура(ДанныеЗаполнения, СтандартнаяОбработка);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПодразделениеКомпанииПолучатель) Тогда
		ПодразделениеКомпанииПолучатель = Справочники.ПодразделенияКомпании.ОсновноеПодразделение;
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(ДатаНачалаДействия) Тогда
		ДатаНачалаДействия = Дата;
	КонецЕсли;
	
	ДобавитьДопРеквизит();
	
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

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ДополнительныеСвойства.Вставить("КонтрольЗаполненияХарактеристик",        Ложь);
	ДополнительныеСвойства.Вставить("КонтрольОперацииНаСоответствиеДоговору", Ложь);
	ОбработкаСобытийДокументаСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

// Обработчик события возникающего после начала транзакции записи, но до начала записи объекта.
//
// Параметры:
//  Отказ           - Булево                   - Признак отказа от совершения операции.
//  РежимЗаписи     - РежимЗаписиДокумента     - Текущий режим записи документа.
//  РежимПроведения - РежимПроведенияДокумента - Текущий режим проведения.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ХозОперация = Справочники.ХозОперации.УстановкаЦенКомпании Тогда
		Если НЕ Контрагент.Пустая() Тогда
			Контрагент = Справочники.Контрагенты.ПустаяСсылка();
		КонецЕсли;
		Если НЕ ДоговорВзаиморасчетов.Пустая() Тогда
			ДоговорВзаиморасчетов = Справочники.ДоговорыВзаиморасчетов.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли; 
	
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
	
	ВыполнитьПереоценкуРозницы(РежимПроведения, Отказ);
	
	Если НЕ Отказ Тогда
		ПодразделенияПолучатели = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПодразделениеКомпанииПолучатель);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
			ПодразделенияПолучатели,
			ПодчиненныеПодразделенияКомпании.ВыгрузитьКолонку("ПодразделениеКомпании"), Истина);
		
		// Устанавливаем цены
		Для Каждого ТекущаяСтрока Из ПараметрыРасчета Цикл
			Если ТекущаяСтрока.ТипЦен.Рассчитывается Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого Подразделение Из ПодразделенияПолучатели Цикл
				НаборЗаписейЦены = Движения.Цены;
				НаборЗаписейЦены.ДокументОбъект         = ЭтотОбъект;
				НаборЗаписейЦены.Контрагент             = Контрагент;
				НаборЗаписейЦены.ДоговорВзаиморасчетов  = ДоговорВзаиморасчетов;
				НаборЗаписейЦены.ТипЦен                 = ТекущаяСтрока.ТипЦен;
				НаборЗаписейЦены.ПодразделениеКомпании  = Подразделение;
				НаборЗаписейЦены.ИмяРеквизитаЦена       = "Цена";
				НаборЗаписейЦены.УстанавливатьЦеныУслуг = Истина;
				НаборЗаписейЦены.ДатаНачалаДействия     = ДатаНачалаДействия;
				НаборЗаписейЦены.МожноСделатьОтменуЦены = Истина;
				НаборЗаписейЦены.ТипЦенВТабличнойЧасти  = Истина;
				
				Отказ = НЕ НаборЗаписейЦены.УстановитьЦены() ИЛИ Отказ;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиЗаполненияОбъекта

// BSLLS:FunctionReturnsSamePrimitive-off

// Производит заполнение объекта на основании документа "Поступление товаров"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ПоступлениеТоваров(ДанныеЗаполнения,
                                               ТекстЗаполнения = "",
	                                             СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаЗаполненияНаОсновании(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ХозОперация           = Справочники.ХозОперации.УстановкаЦенКомпании;
	Контрагент            = Справочники.Контрагенты.ПустаяСсылка();
	ДоговорВзаиморасчетов = Справочники.ДоговорыВзаиморасчетов.ПустаяСсылка();
	
	ТипЦенНоменклатуры = ДанныеЗаполнения.ТипЦен;
	
	ДокументОснование = ДанныеЗаполнения.Ссылка;
	БазовыйТипЦен = ДанныеЗаполнения.ТипЦен;
	
	НоваяСтрока = ПараметрыРасчета.Добавить();
	НоваяСтрока.ТипЦен = ТипЦенНоменклатуры;
	
	Если НоваяСтрока.ТипЦен.Рассчитывается Тогда
		НоваяСтрока.ПроцентНаценки = НоваяСтрока.ТипЦен.ПроцентСкидкиНаценки;
	КонецЕсли;
	НоваяСтрока.РасчетЦенОт   = 1;
	НоваяСтрока.ОкруглятьДо = 0.01;
	
	Для Каждого ТекущаяСтрока Из Товары Цикл
		ТекущаяСтрока.ТипЦен = ТипЦенНоменклатуры;
		ТекущаяСтрока.БазоваяЕдиницаИзмерения = Справочники.Номенклатура.ПолучитьОсновнуюЕдиницуПоБазовой(ТекущаяСтрока.Номенклатура);
	КонецЦикла;
	
	Если ЕстьРеквизит(ДанныеЗаполнения, "СкладКомпании") И
		ЗначениеЗаполнено(ДанныеЗаполнения.СкладКомпании.ТипЦенРозничнойТорговли)
		И ДанныеЗаполнения.СкладКомпании.ТипЦенРозничнойТорговли <> ТипЦенНоменклатуры Тогда
		ТипЦенНоменклатуры = ДанныеЗаполнения.СкладКомпании.ТипЦенРозничнойТорговли;
		НоваяСтрока = ПараметрыРасчета.Добавить();
		НоваяСтрока.ТипЦен = ТипЦенНоменклатуры;
		
		Если НоваяСтрока.ТипЦен.Рассчитывается Тогда
			НоваяСтрока.ПроцентНаценки = НоваяСтрока.ТипЦен.ПроцентСкидкиНаценки;
		КонецЕсли;
		НоваяСтрока.РасчетЦенОт = 1;
		НоваяСтрока.ОкруглятьДо = 0.01;
		Для Каждого ТекСтрока Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.ТипЦен = ТипЦенНоменклатуры;
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.Цена = ТекСтрока.ЦенаРозничная;
			НоваяСтрока.БазоваяЕдиницаИзмерения = Справочники.Номенклатура.ПолучитьОсновнуюЕдиницуПоБазовой(НоваяСтрока.Номенклатура);
		КонецЦикла;
	КонецЕсли;
	
	Документы.ИзменениеЦен.ЗаполнитьБазовыеЦены(ЭтотОбъект);
	
	ОднаСекунда = 1;
	ДатаНачалаДействия	= ДанныеЗаполнения.Дата + ОднаСекунда;
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_ПоступлениеТоваров()

// Производит заполнение объекта на основании документа "Ввод остатков товаров"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ВводОстатковТоваров(ДанныеЗаполнения,
	ТекстЗаполнения = "",
	СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Возвращаем заполнение по поступлению
	Возврат ОбработкаЗаполнения_ПоступлениеТоваров(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецФункции // ОбработкаЗаполнения_ВводОстатковТоваров()

// Производит заполнение объекта на основании документа "Авансовый отчет"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_АвансовыйОтчет(ДанныеЗаполнения,
	ТекстЗаполнения = "",
	СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Возвращаем заполнение по поступлению
	Возврат ОбработкаЗаполнения_ПоступлениеТоваров(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецФункции // ОбработкаЗаполнения_АвансовыйОтчет()

// Производит заполнение объекта на основании документа "Перемещение товаров"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ПеремещениеТоваров(ДанныеЗаполнения,
	ТекстЗаполнения = "",
	СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Вызываем общий обработчик заполнения
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаЗаполненияНаОсновании(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ХозОперация           = Справочники.ХозОперации.УстановкаЦенКомпании;
	Контрагент            = Справочники.Контрагенты.ПустаяСсылка();
	ДоговорВзаиморасчетов = Справочники.ДоговорыВзаиморасчетов.ПустаяСсылка();
	ДокументОснование 	  = ДанныеЗаполнения.Ссылка;
	
	
	Если ТипЗнч(ДанныеЗаполнения.СкладПолучатель) = Тип("СправочникСсылка.СкладыКомпании") Тогда
		ПодразделениеКомпанииПолучатель = ДанныеЗаполнения.СкладПолучатель.ПодразделениеКомпании;
	Иначе
		ПодразделениеКомпанииПолучатель = ДанныеЗаполнения.СкладПолучатель;
	КонецЕсли;
	
	НоваяСтрока = ПараметрыРасчета.Добавить();
	НоваяСтрока.ТипЦен = ДанныеЗаполнения.ТипЦен;
	
	Если НоваяСтрока.ТипЦен.Рассчитывается Тогда
		НоваяСтрока.ПроцентНаценки = НоваяСтрока.ТипЦен.ПроцентСкидкиНаценки;
	КонецЕсли;
	НоваяСтрока.РасчетЦенОт = 6;
	НоваяСтрока.ОкруглятьДо = 0.01;
	
	Если ТипЗнч(ДанныеЗаполнения.СкладКомпании) = Тип("СправочникСсылка.СкладыКомпании") Тогда
		БазовоеПодразделение = ДанныеЗаполнения.СкладКомпании.ПодразделениеКомпании;
	Иначе
		БазовоеПодразделение = ДанныеЗаполнения.СкладКомпании;
	КонецЕсли;
	
	Для Каждого ТекущаяСтрока Из Товары Цикл
		ТекущаяСтрока.ТипЦен = НоваяСтрока.ТипЦен;
	КонецЦикла;
	
	Документы.ИзменениеЦен.ЗаполнитьБазовыеЦены(ЭтотОбъект);
	ДатаНачалаДействия = ДанныеЗаполнения.Дата;
	
	Для Каждого СтрокаТЧ Из Товары Цикл
		
		Если ЗначениеЗаполнено(СтрокаТЧ.ЦенаБазовая) Тогда
			СтрокаТЧ.Цена = СтрокаТЧ.ЦенаБазовая + СтрокаТЧ.ЦенаБазовая * СтрокаТЧ.ПроцентНаценки / 100;
		Иначе
			СтрокаТЧ.ЦенаБазовая = СтрокаТЧ.Цена;
			СтрокаТЧ.Цена = СтрокаТЧ.Цена + СтрокаТЧ.Цена * СтрокаТЧ.ПроцентНаценки / 100;
		КонецЕсли;
		
		СтрокаТЧ.БазоваяЕдиницаИзмерения = Справочники.Номенклатура.ПолучитьОсновнуюЕдиницуПоБазовой(СтрокаТЧ.Номенклатура);
		
	КонецЦикла;
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_ПеремещениеТоваров()

// Производит заполнение объекта на основании справочника "Контрагенты"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_Контрагенты(ДанныеЗаполнения,
	ТекстЗаполнения = "",
	СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Вызываем общий обработчик заполнения
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаЗаполненияНаОсновании(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Заполняем специфические для данной операции реквизиты
	ХозОперация = Справочники.ХозОперации.УстановкаЦенКонтрагента;
	Документы.ИзменениеЦен.ХозОперацияПриИзменении(ЭтотОбъект, ДополнительныеСвойства.ПараметрыДействия);
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_Контрагенты()

// Производит заполнение объекта на основании документа "Ввод остатков товаров в производстве".
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ВводОстатковТоваровВПроизводстве(ДанныеЗаполнения,
	ТекстЗаполнения = "",
	СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Возвращаем заполнение по поступлению
	Возврат ОбработкаЗаполнения_ПоступлениеТоваров(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецФункции // ОбработкаЗаполнения_ВводОстатковТоваровВПроизводстве()

// Производит заполнение объекта на основании документа "Разукомплектация".
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_Разукомплектация(ДанныеЗаполнения,
	ТекстЗаполнения = "",
	СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Возвращаем заполнение по поступлению
	Возврат ОбработкаЗаполнения_ПоступлениеТоваров(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецФункции // ОбработкаЗаполнения_Разукомплектация()

// Производит заполнение объекта на основании документа "Комплектация".
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_Комплектация(ДанныеЗаполнения,
	ТекстЗаполнения = "",
	СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Вызываем общий обработчик заполнения
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаЗаполненияНаОсновании(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Тогда
		Возврат Истина;
	КонецЕсли;

	Товары.Очистить();
	НоваяСтрокаНоменклатуры = Товары.Добавить();
	НоваяСтрокаНоменклатуры.Номенклатура = ДанныеЗаполнения.Комплект;
	
	
	ХозОперация	= Справочники.ХозОперации.УстановкаЦенКомпании;
	Контрагент	= Справочники.Контрагенты.ПустаяСсылка();
	ДоговорВзаиморасчетов = Справочники.ДоговорыВзаиморасчетов.ПустаяСсылка();
	
	ТипЦенНоменклатуры = ДанныеЗаполнения.ТипЦен;
	
	ДокументОснование = ДанныеЗаполнения.Ссылка;
	БазовыйТипЦен = ДанныеЗаполнения.ТипЦен;
	
	НоваяСтрока = ПараметрыРасчета.Добавить();
	НоваяСтрока.ТипЦен = ТипЦенНоменклатуры;
	
	Если НоваяСтрока.ТипЦен.Рассчитывается Тогда
		НоваяСтрока.ПроцентНаценки = НоваяСтрока.ТипЦен.ПроцентСкидкиНаценки;
	КонецЕсли;
	НоваяСтрока.РасчетЦенОт = 1;
	НоваяСтрока.ОкруглятьДо = 0.01;
	
	ВВалютеУчета = НоваяСтрока.ТипЦен.ВВалютеУчета;
	ВалютаЦены   = НоваяСтрока.ТипЦен.ВалютаЦены;
	
	Для Каждого ТекущаяСтрока Из Товары Цикл
		
		Если ВВалютеУчета Тогда
			ВалютаЦены = ТекущаяСтрока.Номенклатура.ВалютаУчета;
		КонецЕсли;
		
		ТекущаяСтрока.ТипЦен = ТипЦенНоменклатуры;
		ТекущаяСтрока.БазоваяЕдиницаИзмерения = Справочники.Номенклатура.ПолучитьОсновнуюЕдиницуПоБазовой(ТекущаяСтрока.Номенклатура);
		ТекущаяСтрока.Цена = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(ТекущаяСтрока.Цена, ДанныеЗаполнения.ВалютаДокумента, ДанныеЗаполнения.КурсДокумента, ВалютаЦены, Дата);
	КонецЦикла;
	
	Если ЕстьРеквизит(ДанныеЗаполнения, "СкладКомпании") Тогда
		Если ЗначениеЗаполнено(ДанныеЗаполнения.СкладКомпании.ТипЦенРозничнойТорговли)
			И ДанныеЗаполнения.СкладКомпании.ТипЦенРозничнойТорговли <> ТипЦенНоменклатуры Тогда
			ТипЦенНоменклатуры = ДанныеЗаполнения.СкладКомпании.ТипЦенРозничнойТорговли;
			НоваяСтрока = ПараметрыРасчета.Добавить();
			НоваяСтрока.ТипЦен = ТипЦенНоменклатуры;
			
			ВВалютеУчета = НоваяСтрока.ТипЦен.ВВалютеУчета;
			ВалютаЦены   = НоваяСтрока.ТипЦен.ВалютаЦены;
			
			Если НоваяСтрока.ТипЦен.Рассчитывается Тогда
				НоваяСтрока.ПроцентНаценки = НоваяСтрока.ТипЦен.ПроцентСкидкиНаценки;
			КонецЕсли;
			НоваяСтрока.РасчетЦенОт = 1;
			НоваяСтрока.ОкруглятьДо = 0.01;
		КонецЕсли;
	КонецЕсли;
	
	Если НайтиАлгоритмРасчетаВТипахЦен(Перечисления.АлгоритмПолученияЦены.ПоЕдиницеИзмерения) Тогда
		 НоваяСтрокаНоменклатуры.ЕдиницаИзмерения = ДанныеЗаполнения.КомплектЕдиницаИзмерения;
		 НоваяСтрокаНоменклатуры.Коэффициент =  ДанныеЗаполнения.КомплектЕдиницаИзмерения.Коэффициент;
	 КонецЕсли;
	 
	 Если НайтиАлгоритмРасчетаВТипахЦен(Перечисления.АлгоритмПолученияЦены.ПоХарактеристике) Тогда
		 НоваяСтрокаНоменклатуры.ХарактеристикаНоменклатуры = ДанныеЗаполнения.ХарактеристикаКомплекта;
	КонецЕсли;

	ДатаНачалаДействия = ДанныеЗаполнения.Дата;
	
	Документы.ИзменениеЦен.ЗаполнитьБазовыеЦены(ЭтотОбъект);
	
	Возврат Истина;
КонецФункции // ОбработкаЗаполнения_Комплектация()

// Производит заполнение объекта на основании документа "ИзменениеЦен".
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ИзменениеЦен(ДанныеЗаполнения,
	ТекстЗаполнения = "",
	СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Вызываем общий обработчик заполнения
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаЗаполненияНаОсновании(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ДанныеЗаполнения.ХозОперация = Справочники.ХозОперации.УстановкаЦенКомпании Тогда	
		ХозОперация			= Справочники.ХозОперации.ОтменаЦенКомпании;
	ИначеЕсли ДанныеЗаполнения.ХозОперация = Справочники.ХозОперации.УстановкаЦенКонтрагента Тогда	
		ХозОперация				= Справочники.ХозОперации.ОтменаЦенКонтрагента;
		Контрагент				= ДанныеЗаполнения.Контрагент;
		ДоговорВзаиморасчетов	= ДанныеЗаполнения.ДоговорВзаиморасчетов;
	КонецЕсли;
	
	ДатаНачалаДействия 		= ТекущаяДата();
	
	ТаблицаТовары			= Товары.Выгрузить();
	ТаблицаТовары.ЗаполнитьЗначения(0, "Цена, ЦенаБазовая, ПроцентНаценки, СуммаНаценки");
	Товары.Загрузить(ТаблицаТовары);
	
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_ИзменениеЦен()

// Производит заполнение объекта по передаваемой структуре
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_Структура(ДанныеЗаполнения, СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("ХозОперация") Тогда
		ХозОперация = ДанныеЗаполнения.ХозОперация;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("БазовыйТипЦен") Тогда
		БазовыйТипЦен = ДанныеЗаполнения.БазовыйТипЦен;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("ПрайсЛистКонтрагента") Тогда
		ПрайсЛистКонтрагента = ДанныеЗаполнения.ПрайсЛистКонтрагента;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("ПодразделениеКомпанииПолучатель") Тогда
		ПодразделениеКомпанииПолучатель = ДанныеЗаполнения.ПодразделениеКомпанииПолучатель;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("Контрагент") И ХозОперация = Справочники.ХозОперации.УстановкаЦенКонтрагента Тогда
		Контрагент = ДанныеЗаполнения.Контрагент;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("ПодчиненныеПодразделения") Тогда
		ПодчиненныеПодразделенияКомпании.Очистить();
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицуИзМассива(
			ПодчиненныеПодразделенияКомпании,
			ДанныеЗаполнения.ПодчиненныеПодразделения,
			"ПодразделениеКомпании");
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("СписокТиповЦен") И (ДанныеЗаполнения.Свойство("Номенклатура")
		ИЛИ ДанныеЗаполнения.Свойство("ПрайсЛистКонтрагента") ИЛИ ДанныеЗаполнения.Свойство("СписокНоменклатуры")) Тогда
		
		ПроцентНаценкиИзНоменклатуры = Ложь;
		РасчетЦенОт                  = 0;
		
		Если ДанныеЗаполнения.Свойство("ПараметрыРасчетаТиповЦен") Тогда
			ПроцентНаценкиИзНоменклатуры = ДанныеЗаполнения.ПараметрыРасчетаТиповЦен.ПроцентНаценкиИзНоменклатуры;
			РасчетЦенОт                  = ДанныеЗаполнения.ПараметрыРасчетаТиповЦен.РасчетЦенОт;
		КонецЕсли;
		
		Для Каждого ТекущийТипЦен Из ДанныеЗаполнения.СписокТиповЦен.ТекущийСписокТипЦен Цикл
			НоваяСтрока = ПараметрыРасчета.Добавить();
			НоваяСтрока.ТипЦен = ТекущийТипЦен.Значение;
			НоваяСтрока.ПроцентНаценкиИзНоменклатуры = ПроцентНаценкиИзНоменклатуры;
			НоваяСтрока.РасчетЦенОт = РасчетЦенОт;
		КонецЦикла;
		
		Если ДанныеЗаполнения.Свойство("Номенклатура") Тогда
			Номенклатура = ДанныеЗаполнения.Номенклатура;
			ОсновнаяЕдиницаИзмерения = Справочники.Номенклатура.ПолучитьОсновнуюЕдиницуПоБазовой(Номенклатура);
			КоэффициентОсновнойЕдиницы = ОсновнаяЕдиницаИзмерения.Коэффициент;
			
			Для Каждого ТекущийТипЦен Из ДанныеЗаполнения.СписокТиповЦен.ТекущийСписокТипЦен Цикл
				НоваяСтрока = Товары.Добавить();
				НоваяСтрока.Номенклатура = Номенклатура;
				НоваяСтрока.ТипЦен = ТекущийТипЦен.Значение;
				НоваяСтрока.ЕдиницаИзмерения = ОсновнаяЕдиницаИзмерения;
				НоваяСтрока.Коэффициент = КоэффициентОсновнойЕдиницы;
				НоваяСтрока.БазоваяЕдиницаИзмерения = Справочники.Номенклатура.ПолучитьОсновнуюЕдиницуПоБазовой(НоваяСтрока.Номенклатура);
			КонецЦикла;
		ИначеЕсли
			ДанныеЗаполнения.Свойство("ПрайсЛистКонтрагента")
			И Не ДанныеЗаполнения.Свойство("СписокНоменклатуры")
		Тогда
			// Получим номенклатуру по прайс-листу контрагента и заполним табличную часть "Товары".
			ТаблицаТоваров = ПрайсЛистыКонтрагентов.ДанныеИзПрайсЛиста(ДанныеЗаполнения.ПрайсЛистКонтрагента, , Истина);
			
			Если НЕ ТаблицаТоваров = Неопределено Тогда
				Для Каждого ТекущийТипЦен Из ДанныеЗаполнения.СписокТиповЦен.ТекущийСписокТипЦен Цикл
					Для Каждого СтрокаТоваров Из ТаблицаТоваров Цикл
						Если НЕ ЗначениеЗаполнено(СтрокаТоваров.Номенклатура) Тогда
							Продолжить;
						КонецЕсли;
						НоваяСтрока = Товары.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТоваров);
						Документы.ИзменениеЦен.ТоварыНоменклатураПриИзменении(ЭтотОбъект, НоваяСтрока);
						НоваяСтрока.ТипЦен = ТекущийТипЦен.Значение;
					КонецЦикла;
				КонецЦикла;
			КонецЕсли;
			
		ИначеЕсли ДанныеЗаполнения.Свойство("СписокНоменклатуры") Тогда
			
			Если НЕ ДанныеЗаполнения.СписокНоменклатуры = Неопределено Тогда
				
				Для Каждого ТекущийТипЦен Из ДанныеЗаполнения.СписокТиповЦен.ТекущийСписокТипЦен Цикл
					
					Для Каждого СтрокаТоваров Из ДанныеЗаполнения.СписокНоменклатуры Цикл
						
						Если НЕ ЗначениеЗаполнено(СтрокаТоваров.Номенклатура) Тогда
							Продолжить;
						КонецЕсли;
						
						НоваяСтрока = Товары.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТоваров);
						Документы.ИзменениеЦен.ТоварыНоменклатураПриИзменении(ЭтотОбъект, НоваяСтрока);
						НоваяСтрока.ТипЦен = ТекущийТипЦен.Значение;
						
					КонецЦикла;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Документы.ИзменениеЦен.ЗаполнитьБазовыеЦены(ЭтотОбъект);
		
	КонецЕсли;
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_Структура()

// BSLLS:FunctionReturnsSamePrimitive-on

#КонецОбласти

Процедура ВыполнитьПереоценкуРозницы(РежимПроведения, Отказ)
	
	// если надо переоценим все склады
	Если ПодразделениеКомпанииПолучатель.ПереоценкаРозницаПоПриходу Тогда
		Возврат;
	КонецЕсли;
	
	// склады
	Запрос=Новый Запрос(
		"ВЫБРАТЬ
		|	СкладыКомпании.Ссылка КАК СкладКомпании
		|ИЗ
		|	Справочник.СкладыКомпании КАК СкладыКомпании
		|ГДЕ
		|	СкладыКомпании.Розничный
		|	И СкладыКомпании.ТипЦенРозничнойТорговли В (&ТипЦен)
		|	И СкладыКомпании.ПодразделениеКомпании = &ПодразделениеКомпании
		|
		|;
		|
		|ВЫБРАТЬ
		|	ДокументТовары.Номенклатура КАК Номенклатура,
		|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК ХарактеристикаНоменклатуры,
		|	0 КАК Количество,
		|	ДокументТовары.Цена КАК ЦенаРозничная,
		|	0 КАК Резерв
		|ИЗ
		|	Документ.ИзменениеЦен.Товары КАК ДокументТовары
		|ГДЕ
		|	ДокументТовары.Ссылка=&Ссылка"
	);
	Запрос.УстановитьПараметр("ТипЦен"               , ПараметрыРасчета.ВыгрузитьКолонку("ТипЦен"));
	Запрос.УстановитьПараметр("ПодразделениеКомпании", ПодразделениеКомпанииПолучатель);
	Запрос.УстановитьПараметр("Ссылка"               , Ссылка);
	
	РезультатыЗапросов = Запрос.ВыполнитьПакет();
	
	// переоцениваем
	Если РезультатыЗапросов.Количество() > 0 И НЕ РезультатыЗапросов[0].Пустой() Тогда
		НаборЗаписейОстатки = Движения.ОстаткиТоваровКомпании;
		
		ВыборкаСклады = РезультатыЗапросов[0].Выбрать();
		Пока ВыборкаСклады.Следующий() Цикл
			НаборЗаписейОстатки.РежимПроведения           = РежимПроведения;
			НаборЗаписейОстатки.ДокументОбъект            = ЭтотОбъект;
			НаборЗаписейОстатки.РезультатЗапросаПоТоварам = РезультатыЗапросов[1];
			НаборЗаписейОстатки.СкладКомпании             = ВыборкаСклады.СкладКомпании;
			
			Отказ = НЕ НаборЗаписейОстатки.Переоценка(ХозОперация, Истина, Истина) ИЛИ Отказ;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьДопРеквизит()
	СтрокаНовый = ДополнительныеРеквизиты.Добавить();
	СтрокаНовый.ТекстоваяСтрока = "ВводНаОсновании";
	СтрокаНовый.Значение = Истина;
КонецПроцедуры

Функция НайтиАлгоритмРасчетаВТипахЦен(Алгоритм)
	Для каждого СтрокаТабл Из ПараметрыРасчета  Цикл
		Если СтрокаТабл.ТипЦен.АлгоритмПолученияЦены = Алгоритм Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

#КонецОбласти

#КонецЕсли
