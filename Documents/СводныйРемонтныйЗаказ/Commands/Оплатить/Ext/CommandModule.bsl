﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Результат = ПолучитьТаблицуДолгов(ПараметрКоманды);
	
	Если Результат = "" Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Задолженности по сделкам сводного ремонтного заказа нет.'"), 10);
		Возврат;
	ИначеЕсли ЭтоАдресВременногоХранилища(Результат) Тогда
		
		Описание = Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаОповещения", ЭтотОбъект, "ВыборОбъекта");
		
		ПараметрыВыбора = Новый Структура;
		ПараметрыВыбора.Вставить("ЗакрыватьПриВыборе",            Истина);
		ПараметрыВыбора.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
		ПараметрыВыбора.Вставить("МножественныйВыбор",            Ложь);
		ПараметрыВыбора.Вставить("РежимВыбора",                   Истина);
		ПараметрыВыбора.Вставить("АдресСписка",                   Результат);
		
		ОткрытьФорму("Документ.СводныйРемонтныйЗаказ.Форма.ФормаВыборСделки", ПараметрыВыбора, ЭтотОбъект,,,, Описание, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе
		
		// ПараметрыОткрытия = Новый Структура;
		// ПараметрыОткрытия.Вставить("Основание", Результат);
		//
		// ОткрытьФорму("Документ.ПриходныйКассовыйОрдер.ФормаОбъекта", ПараметрыОткрытия);
		
		ПараметрыФормы = Новый Структура("Основание, Команда", Результат, "ОплатитьЧерезКассу");
		ОткрытьФорму("Документ.ЧекНаОплату.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
	// Вставить содержимое обработчика.
	// ПараметрыФормы = Новый Структура("", );
	// ОткрытьФорму("Документ.СводныйРемонтныйЗаказ.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик события возникающего при получении результата работы подчиненной формы.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Дополнительные параметры вызова обработчика.
//
&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаОповещения(РезультатОповещения, ДополнительныеПараметры = Неопределено) Экспорт
	
	// Вызываем общий обработчик события в контексте клиента
	Если НЕ УправлениеДиалогомДокументаКлиент.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры = "ВыборОбъекта" Тогда
		
		// ПараметрыОткрытия = Новый Структура;
		// ПараметрыОткрытия.Вставить("Основание", РезультатОповещения);
		//
		// ОткрытьФорму("Документ.ПриходныйКассовыйОрдер.ФормаОбъекта", ПараметрыОткрытия);
		
		ПараметрыФормы = Новый Структура("Основание, Команда", РезультатОповещения, "ОплатитьЧерезКассу");
		ОткрытьФорму("Документ.ЧекНаОплату.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры // Подключаемый_ОбработкаРезультатаОповещения()

&НаСервере
Функция ПолучитьТаблицуДолгов(СводныйРемонтныйЗаказ)
	
	Результат = "";
	
	ПересчетНаДату = ТекущаяДатаСеанса();
	КассаККМ       = Справочники.КассыККМ.ПолучитьОсновнуюКассуККМ();
	
	Если КассаККМ = Неопределено Тогда
		КассаККМ = Справочники.КассыККМ.ПустаяСсылка();
	КонецЕсли;
	
	ВалютаКассыККМ = КассаККМ.ВалютаДенежныхСредств;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЗаказНаряд.Контрагент КАК Контрагент,
	|	ЗаказНаряд.ДоговорВзаиморасчетов КАК ДоговорВзаиморасчетов,
	|	ЗаказНаряд.ДоговорВзаиморасчетов.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ЗаказНаряд.ВалютаДокумента КАК ВалютаДокумента,
	|	ЗаказНаряд.КурсДокумента КАК КурсДокумента,
	|	ЗаказНаряд.СуммаДокумента КАК СуммаДокумента,
	|	ЗаказНаряд.Ссылка КАК Сделка,
	|	ЗаказНаряд.ДокументОснование КАК ДокументОснование
	|ПОМЕСТИТЬ ТаблицаСделок
	|ИЗ
	|	Документ.ЗаказНаряд КАК ЗаказНаряд
	|ГДЕ
	|	ЗаказНаряд.СводныйРемонтныйЗаказ = &СводныйРемонтныйЗаказ
	|	И ЗаказНаряд.ВидРемонта.ТипРемонта = ЗНАЧЕНИЕ(Перечисление.ТипыРемонта.Платный)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСделок.Контрагент КАК Контрагент,
	|	ТаблицаСделок.ДоговорВзаиморасчетов КАК ДоговорВзаиморасчетов,
	|	ТаблицаСделок.Сделка КАК Сделка,
	|	МАКСИМУМ(ТаблицаСделок.ВалютаВзаиморасчетов) КАК ВалютаВзаиморасчетов,
	|	МАКСИМУМ(ТаблицаСделок.ВалютаДокумента) КАК ВалютаДокумента,
	|	МАКСИМУМ(ТаблицаСделок.КурсДокумента) КАК КурсДокумента,
	|	СУММА(ТаблицаСделок.СуммаДокумента) КАК СуммаДокумента,
	|	СУММА(ВЫБОР
	|			КОГДА РасчетыСКонтрагентами.ВидДвижения ЕСТЬ NULL
	|				ТОГДА ВЫБОР
	|						КОГДА ВзаиморасчетыКомпании.ВидДвижения ЕСТЬ NULL
	|							ТОГДА 0
	|						КОГДА ВзаиморасчетыКомпании.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|							ТОГДА ВзаиморасчетыКомпании.Сумма
	|						ИНАЧЕ -ВзаиморасчетыКомпании.Сумма
	|					КОНЕЦ
	|			КОГДА РасчетыСКонтрагентами.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА РасчетыСКонтрагентами.Сумма
	|			ИНАЧЕ -РасчетыСКонтрагентами.Сумма
	|		КОНЕЦ) КАК Сумма
	|ИЗ
	|	ТаблицаСделок КАК ТаблицаСделок
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКонтрагентами КАК РасчетыСКонтрагентами
	|		ПО ТаблицаСделок.Контрагент = РасчетыСКонтрагентами.Контрагент
	|			И ТаблицаСделок.ДоговорВзаиморасчетов = РасчетыСКонтрагентами.ДоговорВзаиморасчетов
	|			И (ТаблицаСделок.Сделка = РасчетыСКонтрагентами.ДокументРасчетов
	|				ИЛИ ТаблицаСделок.ДокументОснование = РасчетыСКонтрагентами.ДокументРасчетов
	|				ИЛИ ТаблицаСделок.Сделка = РасчетыСКонтрагентами.Заказ
	|				ИЛИ ТаблицаСделок.ДокументОснование = РасчетыСКонтрагентами.Заказ)
	|			И (НЕ ТаблицаСделок.Сделка = РасчетыСКонтрагентами.Регистратор)
	|			И (ТаблицаСделок.ДоговорВзаиморасчетов.СпособВеденияВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.СпособыВеденияУчетаВзаиморасчетов.ПоРасчетнымДокументам))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВзаиморасчетыКомпании КАК ВзаиморасчетыКомпании
	|		ПО ТаблицаСделок.Контрагент = ВзаиморасчетыКомпании.Контрагент
	|			И ТаблицаСделок.ДоговорВзаиморасчетов = ВзаиморасчетыКомпании.ДоговорВзаиморасчетов
	|			И (ТаблицаСделок.Сделка = ВзаиморасчетыКомпании.Сделка
	|				ИЛИ ТаблицаСделок.ДокументОснование = ВзаиморасчетыКомпании.Сделка)
	|			И (НЕ ТаблицаСделок.Сделка = ВзаиморасчетыКомпании.Регистратор)
	|			И (НЕ ТаблицаСделок.ДоговорВзаиморасчетов.СпособВеденияВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.СпособыВеденияУчетаВзаиморасчетов.ПоРасчетнымДокументам))
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСделок.Контрагент,
	|	ТаблицаСделок.ДоговорВзаиморасчетов,
	|	ТаблицаСделок.Сделка
	|
	|ИМЕЮЩИЕ
	|	(НЕ СУММА(ВЫБОР
	|					КОГДА РасчетыСКонтрагентами.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|						ТОГДА РасчетыСКонтрагентами.Сумма
	|					ИНАЧЕ -РасчетыСКонтрагентами.Сумма
	|				КОНЕЦ) = 0
	|		ИЛИ НЕ СУММА(ТаблицаСделок.СуммаДокумента) = 0)";
	
	Запрос.УстановитьПараметр("СводныйРемонтныйЗаказ", СводныйРемонтныйЗаказ);
	
	СписокДокументов = Новый ТаблицаЗначений;
	СписокДокументов.Колонки.Добавить("Контрагент");
	СписокДокументов.Колонки.Добавить("ДоговорВзаиморасчетов");
	СписокДокументов.Колонки.Добавить("Сделка");
	СписокДокументов.Колонки.Добавить("СуммаСделки");
	СписокДокументов.Колонки.Добавить("ВалютаСделки");
	СписокДокументов.Колонки.Добавить("Сумма");
	СписокДокументов.Колонки.Добавить("Валюта");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ВалютаКассыККМ = Выборка.ВалютаДокумента Тогда
			СуммаДокумента = Выборка.СуммаДокумента;
		Иначе
			СуммаДокумента = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(Выборка.СуммаДокумента, Выборка.ВалютаДокумента, Выборка.КурсДокумента, ВалютаКассыККМ, ПересчетНаДату);
		КонецЕсли;
		
		Если ВалютаКассыККМ = Выборка.ВалютаВзаиморасчетов Тогда
			ОстатокДолга = СуммаДокумента + Выборка.Сумма;
		Иначе
			ОстатокДолга = СуммаДокумента + РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(Выборка.Сумма, Выборка.ВалютаВзаиморасчетов, ПересчетНаДату, ВалютаКассыККМ, ПересчетНаДату);
		КонецЕсли;
		
		Если ОстатокДолга < 0.01 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = СписокДокументов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.Сумма        = ОстатокДолга;
		НоваяСтрока.Валюта       = ВалютаКассыККМ;
		НоваяСтрока.СуммаСделки  = Выборка.СуммаДокумента;
		НоваяСтрока.ВалютаСделки = Выборка.ВалютаДокумента;
		
	КонецЦикла;
	
	Если СписокДокументов.Количество() = 1 Тогда
		Результат = СписокДокументов[0].Сделка;
	ИначеЕсли СписокДокументов.Количество() > 0 Тогда
		Результат = ПоместитьВоВременноеХранилище(СписокДокументов);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти


////// Если объект не содержит фискальные реквизиты и его основании можно ввести Чек на оплату, то добавим команду оплаты
//// Если (НЕ ЕстьРеквизит(ОбъектМетаданных, "НомерЧека"))
//	 И Метаданные.Документы.ЧекНаОплату.ВводитсяНаОсновании.Содержит(ОбъектМетаданных) Тогда
// ЗащищенныеФункцииСервер.ДобавитьКоманду(
//	 Форма,
//	 "ОплатитьЧерезКассу",
//	 "ДополнительныеДействия",
//	 БиблиотекаКартинок.ОплатитьЧерезКассу,
//	 НСтр("ru = 'Оплатить'"),
//	 НСтр("ru = 'Оплатить через кассу'"),
//	 ЛОЖЬ,
//	 ,
//	 ,
//	 ОтображениеКнопки.КартинкаИТекст);
//// КонецЕсли;

