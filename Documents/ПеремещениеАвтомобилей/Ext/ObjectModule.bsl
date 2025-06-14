﻿// Модуль объекта документа "Перемещение автомобилей"

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
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ТаможеннаяДекларацияИмпорт")
		И НЕ ДанныеЗаполнения.ХозОперация = Справочники.ХозОперации.ТаможеннаяДекларацияИмпортАвтомобилей Тогда
		
		УправлениеДиалогомСервер.ЗапретитьОткрытиеФормыОбъекта(
			ЭтотОбъект,
			НСтр(
				"ru = 'Ввод возможен только на основании документа с хоз. операцией Таможенная декларация(импорт автомобилей)'"
			)
		);
		Возврат;
		
	КонецЕсли;
	
	Если ОбработкаСобытийДокументаСервер.ВводСПустымОснованием(ДанныеЗаполнения) Тогда
		ТипЦен          = ПраваИНастройкиПользователя.Значение("ОсновнойТипЦенЗакупкиАвтомобилей", ЭтотОбъект);
		ВалютаДокумента = РаботаСКурсамиВалютПлатформа.ВалютаТипаЦены(ТипЦен, , Ложь);
	КонецЕсли;
	
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
	
	Если ЕстьРеквизит(ДанныеЗаполнения, "Грузополучатель") И  
		ЗначениеЗаполнено(ДанныеЗаполнения.Грузополучатель) Тогда 
		
		Грузоотправитель = ДанныеЗаполнения.Грузополучатель;
	КонецЕсли;
	Грузополучатель = Неопределено;

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
	
	Если ХозОперация <> Справочники.ХозОперации.ПеремещениеАвтомобилейИзФилиала Тогда
		Для Каждого СтрокаАвтомобилей Из Автомобили Цикл
			Если СтрокаАвтомобилей.Цена <> 0 Тогда
				СтрокаАвтомобилей.Цена = 0;
				Документы.ПеремещениеАвтомобилей.АвтомобилиЦенаПриИзменении(ЭтотОбъект, СтрокаАвтомобилей);
			КонецЕсли;
		КонецЦикла;
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
	
	// Проверка корректности типа цен.
	Если ТипЦен.Рассчитывается Тогда
		
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Использование расчетных типов цен запрещено.'"), ЭтотОбъект);
		
	КонецЕсли;
	
	РаботаСГраницами.МоментВремениПередПроведением(Ссылка, ДополнительныеСвойства);
	РаботаСГраницами.ДвиженияПоОстаткамАвтомобилейПередПроведением(Ссылка, ДополнительныеСвойства);
	РаботаСГраницами.ДвиженияПоКомплектацииПередПроведением(Ссылка, ДополнительныеСвойства);
	
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
	
	ПолучитьСуммыСписания(Истина);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

// Обработчик события возникающего в транзакции записи для формирования движений документу по подчиненным регистрам.
//
// Параметры:
//  Отказ           - Булево                   - Признак отказа от совершения операции.
//  РежимПроведения - РежимПроведенияДокумента - Текущий режим проведения.
//
Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаПроведения(ЭтотОбъект, Отказ, Режим) Тогда
		Возврат;
	КонецЕсли;
	
	// проверим, а не равны ли склады
	Если СкладПолучатель = СкладКомпании Тогда
		
		ТекстСообщения = НСтр("ru = 'Склад-отправитель равен складу-получателю. Движения бессмысленны.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		
		Возврат;
	КонецЕсли;
	
	Если ХозОперация = Справочники.ХозОперации.ПеремещениеАвтомобилейВФилиал Тогда
		Если ПроверитьЗаказыНаАвтомобиль() Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	НаборЗаписейОстаткиАвтомобилей = Движения.ОстаткиАвтомобилей;
	
	// получим шапку документа
	ШапкаДокумента = ПолучитьШапкуДокумента(Ссылка);
	
	Если ХозОперация = Справочники.ХозОперации.ПеремещениеАвтомобилей Тогда
		// Спишем автомобиль со склада отправителя
		НаборЗаписейОстаткиАвтомобилей.РежимПроведения               = Режим;
		НаборЗаписейОстаткиАвтомобилей.ДокументОбъект                = ЭтотОбъект;
		НаборЗаписейОстаткиАвтомобилей.РезультатЗапросаПоАвтомобилям = Неопределено;
		НаборЗаписейОстаткиАвтомобилей.СкладКомпании                 = СкладКомпании;
		НаборЗаписейОстаткиАвтомобилей.СкладПолучатель               = СкладПолучатель;
		
		Если НЕ НаборЗаписейОстаткиАвтомобилей.Переместить() Тогда
			Отказ = Истина;
		КонецЕсли;
	ИначеЕсли ХозОперация = Справочники.ХозОперации.ПеремещениеАвтомобилейВФилиал Тогда
		// Спишем автомобиль со склада отправителя
		НаборЗаписейОстаткиАвтомобилей.РежимПроведения               = Режим;
		НаборЗаписейОстаткиАвтомобилей.ДокументОбъект                = ЭтотОбъект;
		НаборЗаписейОстаткиАвтомобилей.РезультатЗапросаПоАвтомобилям = Неопределено;
		НаборЗаписейОстаткиАвтомобилей.СкладКомпании                 = СкладКомпании;
		НаборЗаписейОстаткиАвтомобилей.ШапкаДокумента                = ШапкаДокумента;
		
		Если НЕ НаборЗаписейОстаткиАвтомобилей.Расход() Тогда
			Отказ = Истина;
		КонецЕсли;
	ИначеЕсли ХозОперация = Справочники.ХозОперации.ПеремещениеАвтомобилейИзФилиала Тогда
		// Оприходуем на склад получатель
		НаборЗаписейОстаткиАвтомобилей.РежимПроведения               = Режим;
		НаборЗаписейОстаткиАвтомобилей.ДокументОбъект                = ЭтотОбъект;
		НаборЗаписейОстаткиАвтомобилей.РезультатЗапросаПоАвтомобилям = Неопределено;
		НаборЗаписейОстаткиАвтомобилей.СкладКомпании                 = СкладПолучатель;
		НаборЗаписейОстаткиАвтомобилей.СтатусПартии                  = Перечисления.СтатусыПартий.ТоварКупленный;
		НаборЗаписейОстаткиАвтомобилей.Партия                        = Ссылка;
		НаборЗаписейОстаткиАвтомобилей.ШапкаДокумента                = ШапкаДокумента;
		
		Если НЕ НаборЗаписейОстаткиАвтомобилей.Приход() Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		НаборЗаписейОстаткиАвтомобилей.Записать();
	КонецЕсли;
	
	// проведем партии товаров
	Если  НЕ ПровестиПоПартиям(Режим, Ссылка) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	РаботаСГраницами.СдвинутьГраницуОстатковАвтомобилей(Ссылка, ДополнительныеСвойства, Движения);
	
	Если Не Отказ Тогда
		СуммаДокумента = Документы.ПеремещениеАвтомобилей.РассчитатьИтогиОперации(ЭтотОбъект, Ложь).СуммаДокумента;
		
		СуммыСписания = ПолучитьСуммыСписания();
		
		Если СуммыСписания <> Неопределено Тогда
			Если СуммаСписания <> СуммыСписания.СуммаСписания Тогда
				СуммаСписания = СуммыСписания.СуммаСписания;
			КонецЕсли;
			
			Если СуммаСписанияБезНДС <> СуммыСписания.СуммаСписанияБезНДС Тогда
				СуммаСписанияБезНДС = СуммыСписания.СуммаСписанияБезНДС;
			КонецЕсли;
		КонецЕсли;
		
		Попытка
			ОбменДанными.Загрузка = Истина;
			Записать(РежимЗаписиДокумента.Запись);
		Исключение
			ПричинаОшибки = ИнформацияОбОшибке();
			Отказ = Истина;
		КонецПопытки;
		ОбменДанными.Загрузка = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиЗаполненияОбъекта

// Производит заполнение объекта на основании документа "Поступление автомобилей"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ПоступлениеАвтомобилей(ДанныеЗаполнения,
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
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_ПоступлениеАвтомобилей()

// Производит заполнение объекта на основании документа "Ввод остатков автомобилей"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ВводОстатковАвтомобилей(ДанныеЗаполнения,
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
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_ВводОстатковАвтомобилей()

// Производит заполнение объекта на основании документа "Перемещение автомобилей"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ПеремещениеАвтомобилей(ДанныеЗаполнения,
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
	
	Если ДанныеЗаполнения.ХозОперация = Справочники.ХозОперации.ПеремещениеАвтомобилейВФилиал Тогда
		ХозОперация = Справочники.ХозОперации.ПеремещениеАвтомобилейИзФилиала;
		Для Каждого СтрокаТЧ Из Автомобили Цикл
			Документы
			.ПеремещениеАвтомобилей
			.АвтомобилиАвтомобильПриИзменении(ЭтотОбъект, СтрокаТЧ, ДополнительныеСвойства.ПараметрыДействия);
		КонецЦикла;
	КонецЕсли;
	
	СкладКомпании   = ДанныеЗаполнения.СкладПолучатель;
	СкладПолучатель = ДанныеЗаполнения.СкладКомпании;
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_ПеремещениеАвтомобилей()

// Производит заполнение объекта на основании документа "Таможенная декларация импорт".
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ТаможеннаяДекларацияИмпорт(ДанныеЗаполнения,
	ТекстЗаполнения = "",
	СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаЗаполненияНаОсновании(
		ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Автомобили.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ТаможеннаяДекларацияИмпортАвтомобили.Автомобиль КАК Автомобиль,
	               |	1 КАК Количество
	               |ИЗ
	               |	Документ.ТаможеннаяДекларацияИмпорт.Автомобили КАК ТаможеннаяДекларацияИмпортАвтомобили
	               |ГДЕ
	               |	ТаможеннаяДекларацияИмпортАвтомобили.Ссылка = &Основание";
	
	Запрос.УстановитьПараметр("Основание", ДанныеЗаполнения);
	Автомобили.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_ТаможеннаяДекларацияИмпорт()

#КонецОбласти

#Область ФормированиеДвиженийДокумента

// Возвращает выборку по шапке
// ДокументСсылка - Ссылка на документ для которого получаем шапку.
Функция ПолучитьШапкуДокумента(ДокументСсылка) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Док.Ссылка КАК Ссылка,
	|	Док.Дата КАК Дата,
	|	Док.ВалютаДокумента КАК ВалютаДокумента,
	|	Док.КурсДокумента КАК КурсДокумента,
	|	Док.ТипЦен КАК ТипЦен,
	|	Док.ХозОперация КАК ХозОперация,
	|	Док.КурсВалютыУпр КАК КурсВалютыУпр,
	|	Док.МоментВремени КАК МоментВремени,
	|	Док.ПодразделениеКомпании КАК ПодразделениеКомпании,
	/////////// ПРИВАТ ////////////
	|	" + ?(ТипЗнч(ДокументСсылка.СкладКомпании) = Тип("СправочникСсылка.СкладыКомпании"), "
	|	Док.СкладКомпании КАК СкладКомпании,
	|	Док.СкладКомпании.ПодразделениеКомпании КАК ПодразделениеОтправителя,", "
	|	ЗНАЧЕНИЕ(Справочник.СкладыКомпании.ПустаяСсылка) КАК СкладКомпании,
	|	Док.СкладКомпании КАК ПодразделениеОтправителя,") +
		?(ТипЗнч(ДокументСсылка.СкладПолучатель) = Тип("СправочникСсылка.СкладыКомпании"), "
	|	Док.СкладПолучатель КАК СкладПолучатель,
	|	Док.СкладПолучатель.ПодразделениеКомпании КАК ПодразделениеПолучателя,", "
	|	ЗНАЧЕНИЕ(Справочник.СкладыКомпании.ПустаяСсылка) КАК СкладПолучатель,
	|	Док.СкладПолучатель КАК ПодразделениеПолучателя,") + "
	|	Док.ДокументОснование КАК ДокументОснование
	|
	|ИЗ
	|	Документ.ПеремещениеАвтомобилей КАК Док
	|ГДЕ
	|	Док.Ссылка=&Ссылка
	|");
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка;
	
КонецФункции

// Формирует движения документа по партионным регистрам
// Режим - режим проведения (оперативный/неоперативный)
// ДокументСсылка - ссылка на документ который надо допровести по партиям
// Возвращает Истина - все хорошо, ложь - чего-то не так.
Функция ПровестиПоПартиям(Режим, ДокументСсылка) Экспорт
	Отказ = Ложь;
	
	// получим шапку документа
	ШапкаДокумента = ПолучитьШапкуДокумента(ДокументСсылка);
	
	// Получим способ ведения баланса.
	БалансВедетсяПоПодразделениям = БалансВедетсяПоПодразделениям(ШапкаДокумента.Дата);
		
	// Если было отложенное проведение по партиям, то :
	// Очистим возможные движения по регистру комплектации автомобилей.
	НаборЗаписейПартионногоРегистра = РегистрыНакопления.КомплектацияАвтомобилей.СоздатьНаборЗаписей();
	НаборЗаписейПартионногоРегистра.Отбор.Регистратор.Значение      = ШапкаДокумента.Ссылка;
	НаборЗаписейПартионногоРегистра.Отбор.Регистратор.Использование = Истина;
	
	НаборЗаписейПартионногоРегистра.Записать();
	
	// Проверим, если подразделение проводиться по партиям "отложено", то дальше не идем.
	НаборЗаписейДопроведениеПоПартиям                = Движения.ДопроведениеПоПартиям;
	НаборЗаписейДопроведениеПоПартиям.ДокументОбъект = ЭтотОбъект;
	НаборЗаписейДопроведениеПоПартиям.ШапкаДокумента = ШапкаДокумента;
	
	Если НЕ НаборЗаписейДопроведениеПоПартиям.Зафиксировать() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если НаборЗаписейДопроведениеПоПартиям.НеПроводитьПартии Тогда
		Возврат НЕ Отказ;
	КонецЕсли;
	
	Если ХозОперация = Справочники.ХозОперации.ПеремещениеАвтомобилей
		ИЛИ ХозОперация = Справочники.ХозОперации.ПеремещениеАвтомобилейВФилиал Тогда
	
		// Спишем и оприходуем оборудование автомобиля
		НаборЗаписейКомплектацияАвтомобилей = Движения.КомплектацияАвтомобилей;
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПеремещениеАвтомобилейАвтомобили.Автомобиль
		|ИЗ
		|	Документ.ПеремещениеАвтомобилей.Автомобили КАК ПеремещениеАвтомобилейАвтомобили
		|ГДЕ
		|	ПеремещениеАвтомобилейАвтомобили.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", ШапкаДокумента.Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			// Спишем оборудование по документу
			НаборЗаписейКомплектацияАвтомобилей.РежимПроведения           = Режим;
			НаборЗаписейКомплектацияАвтомобилей.ДокументОбъект            = ЭтотОбъект;
			НаборЗаписейКомплектацияАвтомобилей.РезультатЗапросаПоТоварам = Неопределено;
			НаборЗаписейКомплектацияАвтомобилей.Автомобиль                = Выборка.Автомобиль;
			НаборЗаписейКомплектацияАвтомобилей.СкладКомпании             = ШапкаДокумента.СкладКомпании;
			НаборЗаписейКомплектацияАвтомобилей.ПериодДвижения            = ШапкаДокумента.МоментВремени;
			НаборЗаписейКомплектацияАвтомобилей.ШапкаДокумента            = ШапкаДокумента;
			
			Если НЕ НаборЗаписейКомплектацияАвтомобилей.Расход() Тогда
				Отказ =  Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если ХозОперация = Справочники.ХозОперации.ПеремещениеАвтомобилей Тогда
			СписаннаяКомплектацияАвтомобилей = НаборЗаписейКомплектацияАвтомобилей.Выгрузить();
			
			Для каждого СписаннаяОпция Из СписаннаяКомплектацияАвтомобилей Цикл
				НоваяЗапись = НаборЗаписейКомплектацияАвтомобилей.Добавить();
				
				ЗаполнитьЗначенияСвойств(НоваяЗапись, СписаннаяОпция);
				
				НоваяЗапись.ВидДвижения   = ВидДвиженияНакопления.Приход;
				НоваяЗапись.Регистратор   = ШапкаДокумента.Ссылка;
				НоваяЗапись.СкладКомпании = ШапкаДокумента.СкладПолучатель;
				НоваяЗапись.ХозОперация   = ШапкаДокумента.ХозОперация;
			КонецЦикла;
		КонецЕсли;
		
		// БАЛАНС: Если происходит перемещение товаров между складами подразделений, принадлежащих
		// различным балансовым "веткам", то возможен разрыв баланса.
		Если ХозОперация = Справочники.ХозОперации.ПеремещениеАвтомобилей Тогда
			ПодразделениеОтправителя = Справочники.ПодразделенияКомпании.ПолучитьБалансовоеПодразделение(
				ШапкаДокумента.ПодразделениеОтправителя,
				ШапкаДокумента.Дата
			);
			ПодразделениеПолучатель = Справочники.ПодразделенияКомпании.ПолучитьБалансовоеПодразделение(
				ШапкаДокумента.ПодразделениеПолучателя,
				ШапкаДокумента.Дата
			);
			ДобавлятьКорректирующиеЗаписи = БалансВедетсяПоПодразделениям
				И (ПодразделениеОтправителя <> ПодразделениеПолучатель);
		Иначе
			ДобавлятьКорректирующиеЗаписи = Ложь;
		КонецЕсли; 
		
		// Доходы и расходы
		Если ДобавлятьКорректирующиеЗаписи ИЛИ (ХозОперация = Справочники.ХозОперации.ПеремещениеАвтомобилейВФилиал) Тогда
			// У подразделения склада-отправителя возникает расход.
			// У подразделения склада-получателя - доход.
			// Если это перемещение в филиал, то движений "приход" не будет.
			НаборЗаписейКомплектацияАвтомобилей.Записать();
			СебестоимостьАвтомобилейУпр  = 0;
			СебестоимостьОборудованияУпр = 0;
			СебестоимостьПриход          = 0;
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Регистратор", ШапкаДокумента.Ссылка);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ОстаткиАвтомобилей.ВидДвижения КАК ВидДвижения,
			|	ЕСТЬNULL(СУММА(ОстаткиАвтомобилей.СуммаУпр), 0) КАК СуммаУпр
			|ИЗ
			|	РегистрНакопления.ОстаткиАвтомобилей КАК ОстаткиАвтомобилей
			|ГДЕ
			|	ОстаткиАвтомобилей.Регистратор = &Регистратор
			|	И ОстаткиАвтомобилей.СтатусПартии = ЗНАЧЕНИЕ(Перечисление.СтатусыПартий.ТоварКупленный)
			|
			|СГРУППИРОВАТЬ ПО
			|	ОстаткиАвтомобилей.ВидДвижения";
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				Если Выборка.ВидДвижения = ВидДвиженияНакопления.Расход Тогда
					СебестоимостьАвтомобилейУпр = СебестоимостьАвтомобилейУпр + Выборка.СуммаУпр;
				Иначе
					СебестоимостьПриход = СебестоимостьПриход + Выборка.СуммаУпр;
				КонецЕсли;
			КонецЦикла;
			Запрос.Текст =
			"ВЫБРАТЬ
			|	КомплектацияАвтомобилей.ВидДвижения КАК ВидДвижения,
			|	ЕСТЬNULL(СУММА(КомплектацияАвтомобилей.СуммаУпр), 0) КАК СуммаУпр
			|ИЗ
			|	РегистрНакопления.КомплектацияАвтомобилей КАК КомплектацияАвтомобилей
			|ГДЕ
			|	КомплектацияАвтомобилей.Регистратор = &Регистратор
			|	И КомплектацияАвтомобилей.СтатусПартии = ЗНАЧЕНИЕ(Перечисление.СтатусыПартий.ТоварКупленный)
			|
			|СГРУППИРОВАТЬ ПО
			|	КомплектацияАвтомобилей.ВидДвижения";
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				Если Выборка.ВидДвижения = ВидДвиженияНакопления.Расход Тогда
					СебестоимостьОборудованияУпр = СебестоимостьОборудованияУпр + Выборка.СуммаУпр;
				Иначе
					СебестоимостьПриход = СебестоимостьПриход + Выборка.СуммаУпр;
				КонецЕсли;
			КонецЦикла;
			
			Если НаборЗаписейДопроведениеПоПартиям.НеПроводитьПартии Тогда
				СебестоимостьРасход = СебестоимостьАвтомобилейУпр + СебестоимостьОборудованияУпр;
				Если СебестоимостьРасход <> 0 Тогда
					НаборЗаписейДоходыРасходы = Движения.ДоходыИРасходы;
					НаборЗаписейДоходыРасходы.ДокументОбъект         = ЭтотОбъект;
					Если БалансВедетсяПоПодразделениям Тогда
						НаборЗаписейДоходыРасходы.Подразделение    = ШапкаДокумента.ПодразделениеОтправителя;
					КонецЕсли; 
					НаборЗаписейДоходыРасходы.ВУпрВалюте             = Истина;
					НаборЗаписейДоходыРасходы.СтатьяДоходовИРасходов =
						Справочники.СтатьиДоходовИРасходов.СебестоимостьНеоприходованныхПартий;
					НаборЗаписейДоходыРасходы.Расход                 = СебестоимостьРасход;
					НаборЗаписейДоходыРасходы.ШапкаДокумента         = ШапкаДокумента;
					
					Если НЕ НаборЗаписейДоходыРасходы.Приход() Тогда
						Отказ =  Истина;
					КонецЕсли;
				КонецЕсли;
			Иначе
				Если СебестоимостьАвтомобилейУпр <> 0 Тогда
					НаборЗаписейДоходыРасходы = Движения.ДоходыИРасходы;
					НаборЗаписейДоходыРасходы.ДокументОбъект         = ЭтотОбъект;
					Если БалансВедетсяПоПодразделениям Тогда
						НаборЗаписейДоходыРасходы.Подразделение    = ШапкаДокумента.ПодразделениеОтправителя;
					КонецЕсли; 
					НаборЗаписейДоходыРасходы.ВУпрВалюте             = Истина;
					НаборЗаписейДоходыРасходы.СтатьяДоходовИРасходов = Справочники.СтатьиДоходовИРасходов.СебестоимостьАвтомобилей;
					НаборЗаписейДоходыРасходы.Расход                 = СебестоимостьАвтомобилейУпр;
					НаборЗаписейДоходыРасходы.ШапкаДокумента         = ШапкаДокумента;
					
					Если НЕ НаборЗаписейДоходыРасходы.Приход() Тогда
						Отказ = Истина;
					КонецЕсли;
				КонецЕсли;
				
				Если СебестоимостьОборудованияУпр <> 0 Тогда
					НаборЗаписейДоходыРасходы = Движения.ДоходыИРасходы;
					НаборЗаписейДоходыРасходы.ДокументОбъект         = ЭтотОбъект;
					Если БалансВедетсяПоПодразделениям Тогда
						НаборЗаписейДоходыРасходы.Подразделение    = ШапкаДокумента.ПодразделениеОтправителя;
					КонецЕсли; 
					НаборЗаписейДоходыРасходы.ВУпрВалюте             = Истина;
					НаборЗаписейДоходыРасходы.СтатьяДоходовИРасходов = Справочники.СтатьиДоходовИРасходов.Себестоимость;
					НаборЗаписейДоходыРасходы.Расход                 = СебестоимостьОборудованияУпр;
					НаборЗаписейДоходыРасходы.ШапкаДокумента         = ШапкаДокумента;
					
					Если НЕ НаборЗаписейДоходыРасходы.Приход() Тогда
						Отказ = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			Если СебестоимостьПриход <> 0 Тогда
				НаборЗаписейДоходыРасходы = Движения.ДоходыИРасходы;
				
				НаборЗаписейДоходыРасходы.ДокументОбъект      = ЭтотОбъект;
				Если БалансВедетсяПоПодразделениям Тогда
					НаборЗаписейДоходыРасходы.Подразделение = ШапкаДокумента.ПодразделениеПолучателя;
				КонецЕсли;
				
				НаборЗаписейДоходыРасходы.ВУпрВалюте = Истина;
				
				Если НаборЗаписейДопроведениеПоПартиям.НеПроводитьПартии Тогда
					НаборЗаписейДоходыРасходы.СтатьяДоходовИРасходов =
						Справочники.СтатьиДоходовИРасходов.СебестоимостьНеоприходованныхПартий;
				Иначе
					НаборЗаписейДоходыРасходы.СтатьяДоходовИРасходов =
						Справочники.СтатьиДоходовИРасходов.КорректировкаБалансаПоПодразделениям;
				КонецЕсли;
				
				НаборЗаписейДоходыРасходы.Доход          = СебестоимостьПриход;
				НаборЗаписейДоходыРасходы.ШапкаДокумента = ШапкаДокумента;
				
				Если НЕ НаборЗаписейДоходыРасходы.Приход() Тогда
					Отказ = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	
	ИначеЕсли ХозОперация = Справочники.ХозОперации.ПеремещениеАвтомобилейИзФилиала Тогда
		// доходы и расходы
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЕСТЬNULL(СУММА(ОстаткиАвтомобилей.СуммаУпр), 0) КАК СуммаУпр
		|ИЗ
		|	РегистрНакопления.ОстаткиАвтомобилей КАК ОстаткиАвтомобилей
		|ГДЕ
		|	ОстаткиАвтомобилей.Регистратор = &Регистратор
		|	И ОстаткиАвтомобилей.СтатусПартии = ЗНАЧЕНИЕ(Перечисление.СтатусыПартий.ТоварКупленный)";
		Запрос.УстановитьПараметр("Регистратор", ШапкаДокумента.Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			Если Выборка.СуммаУпр <> 0 Тогда
				НаборЗаписейДоходыРасходы = Движения.ДоходыИРасходы;
				
				НаборЗаписейДоходыРасходы.ДокументОбъект             = ЭтотОбъект;
				НаборЗаписейДоходыРасходы.ВУпрВалюте                 = Истина;
				Если БалансВедетсяПоПодразделениям Тогда
					НаборЗаписейДоходыРасходы.Подразделение          = ШапкаДокумента.ПодразделениеПолучателя;
				КонецЕсли;
				Если НаборЗаписейДопроведениеПоПартиям.НеПроводитьПартии Тогда
					НаборЗаписейДоходыРасходы.СтатьяДоходовИРасходов =
						Справочники.СтатьиДоходовИРасходов.СебестоимостьНеоприходованныхПартий;
				Иначе
					НаборЗаписейДоходыРасходы.СтатьяДоходовИРасходов = Справочники.СтатьиДоходовИРасходов.СебестоимостьАвтомобилей;
				КонецЕсли;
				НаборЗаписейДоходыРасходы.Доход                      = Выборка.СуммаУпр;
				НаборЗаписейДоходыРасходы.ШапкаДокумента             = ШапкаДокумента;
				
				Отказ = НЕ НаборЗаписейДоходыРасходы.Приход() ИЛИ Отказ;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	
	Если Ссылка <> ДокументСсылка Тогда
		
		РаботаСГраницами.МоментВремениПередПроведением(ДокументСсылка, ДополнительныеСвойства);
		РаботаСГраницами.ДвиженияПоКомплектацииПередПроведением(ДокументСсылка, ДополнительныеСвойства);
		
	КонецЕсли;
	
	РаботаСГраницами.СдвинутьГраницуКомплектации(ДокументСсылка, ДополнительныеСвойства, Движения);

	Возврат НЕ Отказ;
КонецФункции

// Проверка наличия резервов на автомобиль
//
// Возвращаемое значение:
//  Булево - Заказов на данный автомобиль нет.
//
Функция ПроверитьЗаказыНаАвтомобиль()
	
	ДокументОбъектСтруктура = Новый Структура();
	ДокументОбъектСтруктура.Вставить("МоментВремени", МоментВремени());
	ДокументОбъектСтруктура.Вставить("Автомобили", Автомобили.ВыгрузитьКолонку("Автомобиль"));
	
	Возврат ЗащищенныеФункцииАльфаАвтоСервер.РезервыАвтомобиляПроверитьЗаказыНаАвтомобиль(ДокументОбъектСтруктура);
	
КонецФункции // ПроверитьЗаказыНаАвтомобиль()

Функция ПолучитьСуммыСписания(ЭтоОтменаПроведения = Ложь)
	
	Если ЭтоОтменаПроведения Тогда
		СуммаСписания = 0;
		СуммаСписанияБезНДС = 0;
		Возврат Неопределено;
	КонецЕсли;
	
	ВалютаУпр  = Константы.ВалютаУправленческогоУчетаКомпании.Получить();
	ВалютаРегл = Константы.ВалютаРегламентированногоУчетаОрганизаций.Получить();
	
	Если НЕ ЗначениеЗаполнено(КурсВалютыУпр) Тогда
		СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаУпр, Дата);
		КурсУпр        = СтруктураКурса.Курс / ?(СтруктураКурса.Кратность = 0, 1, СтруктураКурса.Кратность);
	Иначе
		КурсУпр = КурсВалютыУпр;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОбъединенныйЗапрос.Автомобиль КАК Автомобиль,
		|	ОбъединенныйЗапрос.Сумма КАК Сумма,
		|	ОбъединенныйЗапрос.СуммаБезНДС КАК СуммаБезНДС
		|ИЗ
		|	(ВЫБРАТЬ
		|		ОстаткиАвтомобилей.Автомобиль КАК Автомобиль,
		|		ОстаткиАвтомобилей." + ?(ВалютаДокумента = ВалютаРегл, "Сумма", "СуммаУпр") + " КАК Сумма,
		|		ОстаткиАвтомобилей." + ?(ВалютаДокумента = ВалютаРегл, "СуммаБезНДС", "СуммаБезНДСУпр") + " КАК СуммаБезНДС
		|	ИЗ
		|		РегистрНакопления.ОстаткиАвтомобилей КАК ОстаткиАвтомобилей
		|	ГДЕ
		|		ОстаткиАвтомобилей.Регистратор = &Регистратор
		|		И ОстаткиАвтомобилей.ВидДвижения = &ВидДвиженияРасход
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		КомплектацияАвтомобилей.Автомобиль,
		|		КомплектацияАвтомобилей." + ?(ВалютаДокумента = ВалютаРегл, "Сумма", "СуммаУпр") + ",
		|		КомплектацияАвтомобилей." + ?(ВалютаДокумента = ВалютаРегл, "СуммаБезНДС", "СуммаБезНДСУпр") + "
		|	ИЗ
		|		РегистрНакопления.КомплектацияАвтомобилей КАК КомплектацияАвтомобилей
		|	ГДЕ
		|		КомплектацияАвтомобилей.Регистратор = &Регистратор
		|		И КомплектацияАвтомобилей.ВидДвижения = &ВидДвиженияРасход) КАК ОбъединенныйЗапрос
		|
		|СГРУППИРОВАТЬ ПО
		|	ОбъединенныйЗапрос.Автомобиль,
		|	ОбъединенныйЗапрос.Сумма,
		|	ОбъединенныйЗапрос.СуммаБезНДС";
	Запрос.УстановитьПараметр("Регистратор"       , Ссылка);
	Запрос.УстановитьПараметр("ВидДвиженияРасход" , ВидДвиженияНакопления.Расход);
	КэшСуммСписания = Запрос.Выполнить().Выгрузить();
	
	Сумма = КэшСуммСписания.Итог("Сумма");
	СуммаБезНДС = КэшСуммСписания.Итог("СуммаБезНДС");
	
	Если ВалютаДокумента <> ВалютаРегл И ВалютаДокумента <> ВалютаУпр Тогда
		
		СуммаСписания = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СуммаСписания,
				ВалютаУпр, КурсУпр, ВалютаДокумента, КурсДокумента, 2);
		СуммаСписанияБезНДС = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СуммаСписанияБезНДС,
				ВалютаУпр, КурсУпр, ВалютаДокумента, КурсДокумента, 2);
		
	КонецЕсли;
	
	Возврат Новый Структура("СуммаСписания, СуммаСписанияБезНДС", Сумма, СуммаБезНДС);
	
КонецФункции

#КонецОбласти

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

#КонецЕсли
