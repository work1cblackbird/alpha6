﻿// Модуль документа "Замена в заказе поставщику"

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
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения="", СтандартнаяОбработка=ИСТИНА)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Тогда
		Возврат;
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
	
	Отказ = Отказ ИЛИ ПроверитьПараметрыЗапретаВыбораНоменклатуры();
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Обработчик события возникающего после начала транзакции записи, но до начала записи объекта.
//
// Параметры:
//  Отказ           - Булево                   - Признак отказа от совершения операции.
//  РежимЗаписи     - РежимЗаписиДокумента     - Текущий режим записи документа.
//  РежимПроведения - РежимПроведенияДокумента - Текущий режим проведения.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// Проверим, чтоб для каждого товара была указана хотя бы одна замена 	
	Для Каждого Товар Из Замены Цикл
		Если ТоварыЗаменители.Найти(Товар.ИдентификаторСтроки, "ИдентификаторСтроки") = Неопределено Тогда
			ТекстСообщения = СтрШаблон(
				НСтр("ru='Для товара %1 %2 не указана замена.'"),
				Товар.Номенклатура,
				Товар.Номенклатура.Артикул
			);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,,,Отказ);
		КонецЕсли;
	КонецЦикла;
	
	// УтверждениеДокумментов
	УтверждениеДокументовСервер.ОбработкаУтвержденияПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	// Конец УтверждениеДокументов
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения) Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСГраницами.МоментВремениПередПроведением(Ссылка, ДополнительныеСвойства);
	РаботаСГраницами.ДвиженияПоЗаказамПередПроведением(Ссылка, ДополнительныеСвойства);
	
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
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДокументТовары.Ссылка.ДокументОснование КАК ЗаказПоставщику,
	|	ДокументТовары.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ДокументТовары.Номенклатура КАК Номенклатура,
	|	ДокументТовары.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ДокументТовары.Количество*ДокументТовары.Коэффициент КАК Количество
	|ИЗ
	|	Документ.ЗаменаВЗаказеПоставщику.Замены КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка = &Ссылка
	|	И ДокументТовары.Количество > 0
	|");
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	
	РезультатЗапросаПоТоварам = Запрос.Выполнить().Выгрузить();
	
	НаборЗаписейЗаказыПоставщикам = Движения.ЗаказыПоставщикам;
	НаборЗаписейЗаказыПоставщикам.РежимПроведения           = РежимПроведения;
	НаборЗаписейЗаказыПоставщикам.ДокументОбъект            = ЭтотОбъект;
	НаборЗаписейЗаказыПоставщикам.РезультатЗапросаПоТоварам = РезультатЗапросаПоТоварам;
	НаборЗаписейЗаказыПоставщикам.ЗаказПоставщику           = Неопределено;
	Отказ = НЕ НаборЗаписейЗаказыПоставщикам.КорректировкаСписаниемЗаказаПоставщика() ИЛИ Отказ;
	
	// Снимаем распределение заказов покупателя
	РезультатЗакрытияЗаказов = НаборЗаписейЗаказыПоставщикам.Выгрузить();
	РезультатЗакрытияЗаказов.Свернуть("Номенклатура, ХарактеристикаНоменклатуры", "Заказано");
	
	КолонкаКоличества = РезультатЗакрытияЗаказов.Колонки.Найти("Заказано");
	КолонкаКоличества.Имя = "Количество";
	
	НаборЗаписейРаспределениеЗаказов = Движения.ЗаказыРаспределение;
	НаборЗаписейРаспределениеЗаказов.РежимПроведения           = РежимПроведения;
	НаборЗаписейРаспределениеЗаказов.ДокументОбъект            = ЭтотОбъект;
	НаборЗаписейРаспределениеЗаказов.РезультатЗапросаПоТоварам = РезультатЗакрытияЗаказов;
	НаборЗаписейРаспределениеЗаказов.ЗаказПокупателя           = Неопределено;
	НаборЗаписейРаспределениеЗаказов.ЗаказПоставщика           = ДокументОснование;
	НаборЗаписейРаспределениеЗаказов.ПорядокЗакрытияЗаказовПоставщику = "ЗаказыРаспределениеОстатки.ЗаказПокупателя.Дата ВОЗР";
	Отказ=НЕ НаборЗаписейРаспределениеЗаказов.КорректировкаРаспределенияЗаказаПоставщику() ИЛИ Отказ;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаменаВЗаказеПоставщикуТовары.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ЗаменаВЗаказеПоставщикуТовары.Номенклатура КАК Номенклатура,
	|	ЗаменаВЗаказеПоставщикуТовары.Количество * ЗаменаВЗаказеПоставщикуТовары.Коэффициент КАК Количество,
	|	ЗаменаВЗаказеПоставщикуТовары.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ЗаменаВЗаказеПоставщикуТовары.СуммаВсего КАК СуммаВсего
	|ИЗ
	|	Документ.ЗаменаВЗаказеПоставщику.ТоварыЗаменители КАК ЗаменаВЗаказеПоставщикуТовары
	|ГДЕ
	|	ЗаменаВЗаказеПоставщикуТовары.Ссылка = &Ссылка
	|	И ЗаменаВЗаказеПоставщикуТовары.Количество > 0";
	
	// Проводим заказ поставщику
	НаборЗаписейЗаказыПоставщикам = Движения.ЗаказыПоставщикам;
	НаборЗаписейЗаказыПоставщикам.РежимПроведения           = РежимПроведения;
	НаборЗаписейЗаказыПоставщикам.ДокументОбъект            = ЭтотОбъект;
	НаборЗаписейЗаказыПоставщикам.РезультатЗапросаПоТоварам = Запрос.Выполнить();
	НаборЗаписейЗаказыПоставщикам.ЗаказПоставщику           = ДокументОснование;
	НаборЗаписейЗаказыПоставщикам.Контрагент                = ДокументОснование.Контрагент;
	Отказ = НЕ НаборЗаписейЗаказыПоставщикам.Приход() ИЛИ Отказ;
	
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		СуммаКорректировки = НаборЗаписейЗаказыПоставщикам.Итог("Сумма");
		ТаблицаДолгов = ЗаказыСервер.ДолгиПоПредоплате(ЭтотОбъект, ДокументОснование, СуммаКорректировки);
		Если ТаблицаДолгов.Количество() > 0 Тогда
			СтрокаДолга = ТаблицаДолгов[0];
			СуммаЗаказа       = Формат(СтрокаДолга.СуммаЗаказа,       "ЧЦ=15; ЧДЦ=2; ЧН=0") + " " + СокрЛП(СтрокаДолга.Валюта);
			Предоплата        = Формат(СтрокаДолга.Предоплата,        "ЧЦ=15; ЧДЦ=2; ЧН=0") + " " + СокрЛП(СтрокаДолга.Валюта);
			Долг              = Формат(СтрокаДолга.Долг,              "ЧЦ=15; ЧДЦ=2; ЧН=0") + " " + СокрЛП(СтрокаДолга.Валюта);
			ПроцентПредоплаты = Формат(СтрокаДолга.ПроцентПредоплаты, "ЧЦ=15; ЧДЦ=2; ЧН=0") + "%";
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Стоимость заказа после замены составит: %1, внесена предоплата %2, установленный процент предоплаты %3.
			|	Для замены в заказе необходимо доплатить %4.'"),СуммаЗаказа,Предоплата,ПроцентПредоплаты,Долг);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,,,Отказ);
			
		КонецЕсли;
	КонецЕсли;
	
	// двигаем границу последовательности заказов
	РаботаСГраницами.СдвинутьГраницуЗаказов(Ссылка,  ДополнительныеСвойства, Движения);
	
КонецПроцедуры // ОбработкаПроведения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиЗаполненияОбъекта

// Производит заполнение объекта на основании документа "Заказ поставщику"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ЗаказПоставщику(ДанныеЗаполнения,
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

	Контрагент = ДанныеЗаполнения.Контрагент;
	
	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказыПоставщикамОстатки.Номенклатура КАК Номенклатура,
	|	ЕСТЬNULL(ЗаказыПоставщикамОстатки.ЗаказаноОстаток,0) КАК Количество,
	|	ЗаказыПоставщикамОстатки.ЗаказПоставщику КАК ЗаказПоставщика,
	|	ЗаказыПоставщикамОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам.Остатки(&НаМомент, ЗаказПоставщику = &Заказ) КАК ЗаказыПоставщикамОстатки
	|ГДЕ
	|	ЕСТЬNULL(ЗаказыПоставщикамОстатки.ЗаказаноОстаток, 0) > 0
	|";
	
	Запрос.УстановитьПараметр("НаМомент", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Заказ",    ДанныеЗаполнения);
	Замены.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Для Каждого СтрокаТоваров Из Замены Цикл
		
		Документы.ЗаменаВЗаказеПоставщику.ЗаменыНоменклатураПриИзменении(ЭтотОбъект, СтрокаТоваров, ДополнительныеСвойства.ПараметрыДействия);
		СтрокаТоваров.ИдентификаторСтроки = Новый УникальныйИдентификатор;
		
		Если (НЕ СтрокаТоваров.Коэффициент = 0) И (НЕ СтрокаТоваров.Коэффициент = 1) Тогда
			СтрокаТоваров.Количество = Окр(СтрокаТоваров.Количество/СтрокаТоваров.Коэффициент, 3);
			Документы.ЗаменаВЗаказеПоставщику.ЗаменыКоличествоПриИзменении(ЭтотОбъект, СтрокаТоваров, ДополнительныеСвойства.ПараметрыДействия);
		КонецЕсли;
		
	КонецЦикла;
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_ЗаказПоставщику()

#КонецОбласти

Функция ПараметрыПроверкиОперацийСНоменклатурой()
	
	Параметры = Новый Структура;
	
	// заполняем
	Параметры.Вставить("ЗапретЗакупки", Истина);
	ТаблицыДляПроверки = Новый Массив;
	ТаблицыДляПроверки.Добавить("ТоварыЗаменители");
	Параметры.Вставить("ТаблицыДляПроверки", ТаблицыДляПроверки);
	
	Возврат Параметры;
	
КонецФункции

Функция ПроверитьПараметрыЗапретаВыбораНоменклатуры()
	
	ПараметрыПроверки = ПараметрыПроверкиОперацийСНоменклатурой();
	ДополнительныеСвойства.Вставить("ПараметрыПроверки", ПараметрыПроверки);
	
	Возврат ОбработкаСобытийДокументаСервер.ПроверитьПараметрыЗапретаВыбораНоменклатуры(ЭтотОбъект, ПараметрыПроверки);
	
КонецФункции

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

#КонецЕсли
