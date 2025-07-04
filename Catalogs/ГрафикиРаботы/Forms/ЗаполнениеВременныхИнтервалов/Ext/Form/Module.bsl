﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы справочника "Графики работы"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

// Обработчик события возникающего на сервере при создании формы.
//
// Параметры:
//  Отказ                - Булево - Признак отказа от создания формы.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Смена = Справочники.Смены.ОсновнаяСменаКомпании;
	Справочники.ГрафикиРаботы.СменаПоУмолчаниюПриИзменении(ЭтотОбъект,,Неопределено);
	Элементы.ВременныеИнтервалы.Доступность = НЕ ЗначениеЗаполнено(Смена);
	
КонецПроцедуры //ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Обработчик события возникающего при изменении данных реквизита "Смена" в контексте сервера.
//
&НаСервере
Процедура СменаПриИзмененииНаСервере(ПараметрыДействия=Неопределено)
	
	// Вызываем обработчик изменения данных объекта
	Справочники.ГрафикиРаботы.СменаПоУмолчаниюПриИзменении(ЭтотОбъект,,ПараметрыДействия);
	
	Элементы.ВременныеИнтервалы.Доступность = НЕ ЗначениеЗаполнено(Смена);
	
КонецПроцедуры //СменаПриИзмененииНаСервере()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Смена".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура СменаПриИзменении(Элемент)
	
	// Обработаем событие в контексте сервера
	СменаПриИзмененииНаСервере();
	
КонецПроцедуры //СменаПриИзменении()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Начало рабочего времени".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура НачалоРабочегоВремениПриИзменении(Элемент)
	
	РассчитатьПродолжительностьИнтервала();;
	
КонецПроцедуры //НачалоРабочегоВремениПриИзменении()

// Обработчик события возникающего на клиенте в момент нажатия кнопки выбора или клавиши F4 при начале выбора реквизита
// "Начало рабочего времени".
//
// Параметры:
//  Элемент              - ПолеФормы      - Элемент управления, в котором возникло данное событие.
//  ДанныеВыбора         - СписокЗначений - В обработчике можно сформировать и передать в этом параметре данные для выбора.
//  СтандартнаяОбработка - Булево         - В данный параметр передается признак выполнения стандартной (системной)
//                                          обработки события.
//
&НаКлиенте
Процедура НачалоРабочегоВремениНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений();
	
	// Вызываем обработчик события
	ЗаполнитьСписокВыбораВремени(ДанныеВыбора);
	
КонецПроцедуры // НачалоРабочегоВремениНачалоВыбора()

// Обработчик события возникающего на клиенте при изменении данных реквизита "конец рабочего времени".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура КонецРабочегоВремениПриИзменении(Элемент)
	
	РассчитатьПродолжительностьИнтервала();;
	
КонецПроцедуры //КонецРабочегоВремениПриИзменении()

// Обработчик события возникающего на клиенте в момент нажатия кнопки выбора или клавиши F4 при начале выбора реквизита
// "Конец рабочего времени".
//
// Параметры:
//  Элемент              - ПолеФормы      - Элемент управления, в котором возникло данное событие.
//  ДанныеВыбора         - СписокЗначений - В обработчике можно сформировать и передать в этом параметре данные для выбора.
//  СтандартнаяОбработка - Булево         - В данный параметр передается признак выполнения стандартной (системной)
//                                          обработки события.
//
&НаКлиенте
Процедура КонецРабочегоВремениНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений();
	
	// Вызываем обработчик события
	ЗаполнитьСписокВыбораВремени(ДанныеВыбора);
	
КонецПроцедуры // КонецРабочегоВремениНачалоВыбора()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Продолжительность".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура ПродолжительностьПриИзменении(Элемент)
	
	// Определим структуру параметров обработки текущего события
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("РасчетПродолжительности",Истина);
	
	РассчитатьПродолжительностьИнтервала(ПараметрыДействия);
	
КонецПроцедуры //ПродолжительностьПриИзменении()

// Обработчик события возникающего на клиенте в момент нажатия кнопки выбора или клавиши F4 при начале выбора реквизита "Продолжительность".
//
// Параметры:
//  Элемент              - ПолеФормы      - Элемент управления, в котором возникло данное событие.
//  ДанныеВыбора         - СписокЗначений - В обработчике можно сформировать и передать в этом параметре данные для выбора.
//  СтандартнаяОбработка - Булево         - В данный параметр передается признак выполнения стандартной (системной)
//                                          обработки события.
//
&НаКлиенте
Процедура ПродолжительностьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений();
	
	// Вызываем обработчик события
	ЗаполнитьСписокВыбораВремени(ДанныеВыбора);
	
КонецПроцедуры // ПродолжительностьПоУмолчаниюНачалоВыбора()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик события возникающего на клиенте при нажатии на кнопку "Да".
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаКлиенте
Процедура ПоложительныйОтвет(Команда)
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("Смена",Смена);
	ПараметрыЗакрытия.Вставить("НачалоРабочегоВремени",НачалоРабочегоВремени);
	ПараметрыЗакрытия.Вставить("КонецРабочегоВремени",КонецРабочегоВремени);
	ПараметрыЗакрытия.Вставить("Продолжительность",Продолжительность);
	
	Закрыть(ПараметрыЗакрытия)
	
КонецПроцедуры //ПоложительныйОтвет()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Рассчитывает продолжительность временного интервала.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура   - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
&НаКлиенте
Процедура РассчитатьПродолжительностьИнтервала(ПараметрыДействия=Неопределено)
	
	Если ТипЗнч(ПараметрыДействия) = Тип("Структура") И ПараметрыДействия.РасчетПродолжительности Тогда
		
		ПродолжительностьМаксимум = 24*3600 - (НачалоРабочегоВремени - КонецРабочегоВремени);
		ПродолжительностьНовая = Продолжительность - '00010101';
		Если ПродолжительностьНовая > ПродолжительностьМаксимум Тогда
			Продолжительность = '00010101' + ПродолжительностьМаксимум;
		КонецЕсли;
		
		КонецРабочегоВремени = '00010101' + (НачалоРабочегоВремени - '00010101')+(Продолжительность - '00010101');
		
	Иначе
		
		// Установим окончание рабочего времени
		Если НачалоРабочегоВремени <> '00010101' И КонецРабочегоВремени = '00010101' Тогда
			КонецРабочегоВремени = '00010101235959';
			РассчитатьПродолжительностьИнтервала(ПараметрыДействия);
		КонецЕсли;
		
		// Рассчитаем продолжительность
		Если НачалоРабочегоВремени > КонецРабочегоВремени Тогда
			Продолжительность = '00010101' + (24*3600 - (НачалоРабочегоВремени - КонецРабочегоВремени));
		Иначе
			Продолжительность = '00010101' + (КонецРабочегоВремени - НачалоРабочегоВремени);
			Если КонецРабочегоВремени = '00010101235959' Тогда
				Продолжительность = Продолжительность + 1;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // РассчитатьПродолжительностьИнтервала()

// Процедура заполняет список выбора для поля ввода времени
//
// Параметры:
//	Список								- СписокЗначений	- Список выбора элемента формы
//	ВремяНачало							- Дата				- Время с которого формируется список
//	ДобавлятьПредставлениеДлительности	- Булево			- Признак добавления в список представления длительности.
//
&НаКлиенте
Процедура ЗаполнитьСписокВыбораВремени(Список, ВремяНачало = Неопределено, ДобавлятьПредставлениеДлительности = Ложь)
	
	Список.Очистить();
	ПустаяДата = Дата("00010101");
	ДобавлятьДлительность = (ДобавлятьПредставлениеДлительности И ТипЗнч(ВремяНачало) = Тип("Дата"));
	
	Если ДобавлятьДлительность Тогда
		// Если ВремяНачало содержит так же и дату
		ЗначениеВремяНачало = ПустаяДата + (ВремяНачало - НачалоДня(ВремяНачало));
	Иначе
		ЗначениеВремяНачало = Неопределено
	КонецЕсли;
	
	ТекВремя = ?(ЗначениеВремяНачало = Неопределено, ПустаяДата, ЗначениеВремяНачало + 60 * 60);
	
	Пока НачалоДня(ТекВремя) <= НачалоДня(ПустаяДата) Цикл
		ПредставлениеВремени = Формат(ТекВремя, "ДФ=HH:mm; ДП=00:00");
		
		Если ДобавлятьДлительность Тогда
			ПредставлениеПериодаВремени = ПолучитьПредставлениеПериодаВремени(ЗначениеВремяНачало, ТекВремя);
			Если ЗначениеЗаполнено(ПредставлениеПериодаВремени) Тогда
				ПредставлениеВремени = ПредставлениеВремени + " (" + ПредставлениеПериодаВремени + ")";
			КонецЕсли;
		КонецЕсли;
		
		Список.Добавить(ТекВремя, ПредставлениеВремени);
		ТекВремя = ТекВремя + 60 * 60;
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьСписокВыбораВремени()

// Функция возвращает представление периода времени (1,5 часа, 6 часов, 30 минут, ...).
//
// Параметры:
//  ВремяНачало    - Дата - Время начала
//  ВремяОкончание - Дата - Время окончания.
//
// Возвращаемое значение:
//  Строка - Представление времени.
//
&НаКлиенте
Функция ПолучитьПредставлениеПериодаВремени(ВремяНачало, ВремяОкончание)
	
	ПустаяДата = Дата("00010101");
	// На случай если время содержит так же и дату
	ЗначениеВремяНачало		= ПустаяДата + (ВремяНачало - НачалоДня(ВремяНачало));
	ЗначениеВремяОкончание	= ПустаяДата + (ВремяОкончание - НачалоДня(ВремяОкончание));
	ВремяНачалоВМинутах		= Цел((ЗначениеВремяНачало - НачалоДня(ЗначениеВремяНачало)) / 60);
	ВремяОкончанияВМинутах	= Цел((ЗначениеВремяОкончание - НачалоДня(ЗначениеВремяОкончание)) / 60);
	РазницаВМинутах = ВремяОкончанияВМинутах - ВремяНачалоВМинутах;
	Если РазницаВМинутах <= 0 Тогда
		Возврат "";
	КонецЕсли;
	// 1 минута
	// 2 - 4 минуты
	// 5 и далее - минут
	// 1 час
	// 2 - 4 часа
	// 5 часов
	// 5,5 часов
	Если РазницаВМинутах < 60 Тогда
		ВремяСтрокой = Формат(РазницаВМинутах, "ЧДЦ=0; ЧН=0; ЧГ=");
		Если РазницаВМинутах = 1 Тогда
			ПредставлениеВремя = НСтр("ru = 'минута'");
		ИначеЕсли РазницаВМинутах <= 4 Тогда
			ПредставлениеВремя = НСтр("ru = 'минуты'");
		Иначе
			ПредставлениеВремя = НСтр("ru = 'минут'");
		КонецЕсли;
	Иначе
		РазницаВЧасах = РазницаВМинутах / 60;
		Если РазницаВЧасах = Цел(РазницаВМинутах / 60) Тогда
			ВремяСтрокой = Формат(РазницаВЧасах, "ЧДЦ=0; ЧРД=,; ЧН=0; ЧГ=");
		Иначе
			ВремяСтрокой = Формат(РазницаВЧасах, "ЧДЦ=1; ЧРД=,; ЧН=0; ЧГ=");
		КонецЕсли;
		Если РазницаВЧасах = 1 Тогда
			ПредставлениеВремя = НСтр("ru = 'час'");
		ИначеЕсли РазницаВЧасах <= 4 Тогда
			ПредставлениеВремя = НСтр("ru = 'часа'");
		Иначе
			ПредставлениеВремя = НСтр("ru = 'часов'");
		КонецЕсли;
	КонецЕсли;
	Возврат ВремяСтрокой + " " + ПредставлениеВремя;
	
КонецФункции // ПолучитьПредставлениеПериодаВремени()

#КонецОбласти

