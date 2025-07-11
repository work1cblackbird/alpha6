﻿// Модуль объекта документа "Тест-драйв"

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
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ПолучитьЗначениеПараметраСтруктуры(ДанныеЗаполнения, "Имя") = "Событие" Тогда
		ДанныеЗаполненияКопия = ДанныеЗаполнения;
		ДанныеЗаполнения = ДанныеЗаполнения.Событие;
	КонецЕсли;
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ОбработкаЗаполнения_Структура(ДанныеЗаполнения, СтандартнаяОбработка);
	КонецЕсли;

	Если ЭтоНовый() Тогда
		Состояние = Перечисления.СостоянияСобытий.Запланировано;	
	КонецЕсли;
	
	// !!!_shmi подлежит доработке
	//#Если Клиент Тогда
	//МаршрутПоУмолчанию = ВосстановитьЗначение("АРМТД_МаршрутПоУмолчанию");	
	//Если ЗначениеЗаполнено(МаршрутПоУмолчанию) Тогда
	//	Маршрут = МаршрутПоУмолчанию;
	//КонецЕсли;
	//#КонецЕсли
	
	Если ЗначениеЗаполнено(Автомобиль) Тогда
		Пробег = Справочники.Автомобили.ЧтениеЗначенияРегистраСведения(Автомобиль, Перечисления.ДополнительнаяИнформацияАвтомобилей.Пробег, ТекущаяДатаСеанса());
	КонецЕсли;
	
	ДанныеЗаполненияКонтрагент = ПолучитьЗначениеПараметраСтруктуры(ДанныеЗаполненияКопия, "Контрагент");
	Если ДанныеЗаполненияКонтрагент <> Неопределено Тогда
		Контрагент = ДанныеЗаполненияКонтрагент;
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
	
	ПредварительныйОпрос = Документы.Анкета.ПустаяСсылка();
	ИтоговыйОпрос 		 = Документы.Анкета.ПустаяСсылка();
	
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
	
	Если НЕ ЗначениеЗаполнено(Контрагент) И НЕ ЗначениеЗаполнено(ОбращениеККлиенту) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Поля ""Клиент"" и ""Обращение"" не заполнены. Необходимо заполнить хотя бы одно из этих полей.'"),,
			"Контрагент",,
			Отказ);
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
	
	Если Состояние = Перечисления.СостоянияСобытий.Завершено Тогда
		Если НЕ ЗначениеЗаполнено(ДатаФактическогоЗавершения) Тогда
			ДатаФактическогоЗавершения = ТекущаяДатаСеанса();
		КонецЕсли;
	Иначе
		ДатаФактическогоЗавершения = Дата(1,1,1);
	КонецЕсли;
	
	// УтверждениеДокумментов
	УтверждениеДокументовСервер.ОбработкаУтвержденияПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	// Конец УтверждениеДокументов
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения) Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи <> РежимЗаписиДокумента.ОтменаПроведения Тогда
	
		Если ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) Тогда
			Если ДатаНачала > ДатаОкончания Тогда
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Дата начала тест-драйва больше даты окончания.'"), ЭтотОбъект,,, Отказ);
			КонецЕсли;
		КонецЕсли; 
		
		Если ПробегНаНачало > ПробегНаКонец Тогда
				ОбщегоНазначения.СообщитьПользователю(
					НСтр("ru='Пробег на конец тест-драйва не может быть меньше пробега на начало.'"),
					ЭтотОбъект,
					"ПробегНаКонец",,
					Отказ);
		КонецЕсли;
		
		// проверка по состоянию документа
		Документы.ТестДрайв.ПроверитьСостояниеТестДрайва(ЭтотОбъект, Отказ);
		
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
	
	Если НЕ Отказ Тогда
		Отказ = НЕ Документы.ТестДрайв.ЗаполнитьГрафикРаботыАвтомобилей(Ссылка);
	КонецЕсли;

	ТаблицаПересечений = Документы.ТестДрайв.ПолучитьПересечениеДокументов(ЭтотОбъект);
	
	Если ТаблицаПересечений.Количество() > 0 Тогда 
		
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(
			СтрШаблон(НСтр("ru='В период %1—%2 автомобиль %3 уже проходит тест-драйв'"), ДатаНачала, ДатаОкончания, Автомобиль),
			ЭтотОбъект
		);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиЗаполненияОбъекта

// Производит заполнение объекта на основании документа "Заказ на автомобиль"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ЗаказНаАвтомобиль(ДанныеЗаполнения,
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
	Документы.ТестДрайв.КонтрагентПриИзменении(ЭтотОбъект, ЭтотОбъект.ДополнительныеСвойства.ПараметрыДействия);
	
	Автомобиль = ДанныеЗаполнения.Автомобиль;
	Документы.ТестДрайв.АвтомобильПриИзменении(ЭтотОбъект, ЭтотОбъект.ДополнительныеСвойства.ПараметрыДействия);
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_ЗаказНаАвтомобиль()

// Производит заполнение объекта на основании документа "Событие"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_Событие(ДанныеЗаполнения,
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
	Документы.ТестДрайв.КонтрагентПриИзменении(ЭтотОбъект, ЭтотОбъект.ДополнительныеСвойства.ПараметрыДействия);
	
	// !!!_shmi подлежит доработке
	Если ЗначениеЗаполнено(ДанныеЗаполнения.ПредставлениеТелефона) Тогда
		КонтактныйТелефон = ДанныеЗаполнения.ПредставлениеТелефона;
	КонецЕсли;
	
	ДатаНачала 		= ДанныеЗаполнения.ДатаНачала;
	ДатаОкончания 	= ДанныеЗаполнения.ДатаОкончания;
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_Событие()

// Производит заполнение объекта на основании документа "Договор проведения технического осмотра".
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
	
	Контрагент = ДанныеЗаполнения;
	Документы.ТестДрайв.КонтрагентПриИзменении(ЭтотОбъект, ЭтотОбъект.ДополнительныеСвойства.ПараметрыДействия);
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_Контрагенты()

// Производит заполнение объекта на основании документа "Рабочего листа"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_РабочийЛист(ДанныеЗаполнения,
	ТекстЗаполнения = "",
	СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Вызываем общий обработчик заполнения
	Если
		НЕ ОбработкаСобытийДокументаСервер.ОбработкаЗаполненияНаОсновании(
			ЭтотОбъект,
			ДанныеЗаполнения,
			ТекстЗаполнения,
			СтандартнаяОбработка)
	Тогда
		Возврат Истина;
	КонецЕсли;
	
	Контрагент = ДанныеЗаполнения.Контрагент;
	Документы.ТестДрайв.КонтрагентПриИзменении(ЭтотОбъект, ЭтотОбъект.ДополнительныеСвойства.ПараметрыДействия);
	
	Автомобиль = ДанныеЗаполнения.Автомобиль;
	Документы.ТестДрайв.АвтомобильПриИзменении(ЭтотОбъект, ЭтотОбъект.ДополнительныеСвойства.ПараметрыДействия);
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_РабочийЛист()

// Производит заполнение объекта по передаваемой структуре
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
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
	
	ДатаНачала            = ПолучитьЗначениеПараметраСтруктуры(ДанныеЗаполнения, "ДатаНачала");
	ДатаОкончания         = ПолучитьЗначениеПараметраСтруктуры(ДанныеЗаполнения, "ДатаОкончания");
	ВидАренды             = ПолучитьЗначениеПараметраСтруктуры(ДанныеЗаполнения, "ВидАренды");   
	Автомобиль            = ПолучитьЗначениеПараметраСтруктуры(ДанныеЗаполнения, "Автомобиль");
	
	Документы.ТестДрайв.ДатаОкончанияПриИзменении(ЭтотОбъект);
	Документы.ТестДрайв.АвтомобильПриИзменении(ЭтотОбъект);
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

#КонецЕсли
