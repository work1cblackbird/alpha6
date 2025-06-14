﻿///////////////////////////////////////////////////////////////////////////////
// Модуль произвольной формы отчета "Анализ потерянных клиентов"
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
	
	НачальныеЗначенияКоличественныеГруппы = ПолучитьЗначениеПараметраСтруктуры(Параметры, "НачальныеЗначенияКоличественныеГруппы", Неопределено);
	НачальныеЗначенияСуммовыеГруппы       = ПолучитьЗначениеПараметраСтруктуры(Параметры, "НачальныеЗначенияСуммовыеГруппы", Неопределено);
	
	Если НЕ НачальныеЗначенияКоличественныеГруппы = Неопределено И НЕ НачальныеЗначенияСуммовыеГруппы = Неопределено Тогда
		ЗаполнитьНачальноеЗаполнение(НачальныеЗначенияКоличественныеГруппы, НачальныеЗначенияСуммовыеГруппы);
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

// Обработчик события возникающего на клиенте при открытии формы, до показа окна пользователю.
//
// Параметры:
//  Отказ - Булево - Признак отказа от создания формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЭтотОбъект.ВладелецФормы = Неопределено Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Запрещен самостоятельный вызов.'"),,
			НСтр("ru = 'Данная форма используется другими объектами конфигурации.'"),
			БиблиотекаКартинок.Предупреждение32,
			СтатусОповещенияПользователя.Важное);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗащищенныеФункцииКлиент.НастроитьЭлементФормыТабличнойЧасти(ЭтотОбъект, "КоличествоГрупп");
	ЗащищенныеФункцииКлиент.НастроитьЭлементФормыТабличнойЧасти(ЭтотОбъект, "СуммовыеГруппы");
	
КонецПроцедуры // ПриОткрытии()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКоличествоГрупп

#Область ОбработчикиСобытийПолейТаблицыФормыКоличествоГрупп

// Обработчик события возникающегопри изменении данных реквизита "Количество ремонтов" в контексте сервера.
//
&НаСервере
Процедура КоличествоГруппКоличествоРемонтовПриИзмененииНаСервере()
	
	КоличествоГрупп.Сортировать("КоличествоРемонтов");
	
КонецПроцедуры // КоличествоГруппКоличествоРемонтовПриИзмененииНаСервере()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Количество ремонтов".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура КоличествоГруппКоличествоРемонтовПриИзменении(Элемент)
	
	КоличествоГруппКоличествоРемонтовПриИзмененииНаСервере();
	
КонецПроцедуры // КоличествоГруппКоличествоРемонтовПриИзменении()

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСуммовыеГруппы

#Область ОбработчикиСобытийПолейТаблицыФормыСуммовыеГруппы

// Обработчик события возникающегопри изменении данных реквизита "Сумма ремонта" в контексте сервера.
//
&НаСервере
Процедура СуммовыеГруппыСуммаРемонтаПриИзмененииНаСервере()
	
	СуммовыеГруппы.Сортировать("СуммаРемонта");
	
КонецПроцедуры // СуммовыеГруппыСуммаРемонтаПриИзмененииНаСервере()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Сумма ремонта".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура СуммовыеГруппыСуммаРемонтаПриИзменении(Элемент)
	
	СуммовыеГруппыСуммаРемонтаПриИзмененииНаСервере();
	
КонецПроцедуры // СуммовыеГруппыСуммаРемонтаПриИзменении()

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик события нажатия кнопки "Применить".
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаКлиенте
Процедура Применить(Команда)
	
	Закрыть(СформироватьРезультат());
	
КонецПроцедуры // Применить()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНачальноеЗаполнение(НачальныеЗначенияКоличественныеГруппы, НачальныеЗначенияСуммовыеГруппы)
	
	КоличествоГрупп.Загрузить(НачальныеЗначенияКоличественныеГруппы.Получить());
	СуммовыеГруппы.Загрузить(НачальныеЗначенияСуммовыеГруппы.Получить());
	
КонецПроцедуры // ЗаполнитьНачальноеЗаполнение()

&НаСервере
Функция СформироватьРезультат()
	
	Результат = Новый Структура();
	Результат.Вставить("КоличественныеГруппы", Новый ХранилищеЗначения(КоличествоГрупп.Выгрузить()));
	Результат.Вставить("СуммовыеГруппы", Новый ХранилищеЗначения(СуммовыеГруппы.Выгрузить()));
	
	Возврат Результат;
	
КонецФункции // СформироватьРезультат()

#КонецОбласти

