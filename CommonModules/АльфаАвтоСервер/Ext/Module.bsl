﻿// Общий модуль "Альфа-авто (сервер)"


#Область СлужебныйПрограммныйИнтерфейс

// Возвращает соответствие имен параметров сеанса и обработчиков для их инициализации.
//
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
КонецПроцедуры // ПриДобавленииОбработчиковУстановкиПараметровСеанса()

// Заполняет структуру параметров, необходимых для работы клиентского кода конфигурации.
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗапуске(Параметры) Экспорт
	
КонецПроцедуры // ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗапуске()

// Доопределяет структуру параметров, необходимых для работы клиентского кода при запуске конфигурации.
//
// Параметры:
//   Параметры  - Структура - структура параметров опций интерфейса.
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ОпцииИнтерфейса = ПолучитьЗначениеПараметраСтруктуры(Параметры, "ОпцииИнтерфейса", Неопределено);
	Если ОпцииИнтерфейса = Неопределено ИЛИ ТипЗнч(ОпцииИнтерфейса) <> Тип("Структура") Тогда
		Параметры.Вставить("ОпцииИнтерфейса", Новый Структура);
	КонецЕсли;
	
	Попытка
		Параметры.ОпцииИнтерфейса.Вставить("ДоступностьПодсистемПоКлючуМаскаКлюча", ПараметрыСеанса.МаскаЛицензирования);
	Исключение
		Попытка
			Обработка = ЛицензированиеСервер.
				ПолучитьЗащищеннуюОбработку(ЗащищенныеФункцииСервер.ПолучитьИмяЗащищеннойОбработкиПоУмолчанию());
			
			Обработка.ПроверитьЗащиту();
			ОпцииИнтерфейса.Вставить("ДоступностьПодсистемПоКлючуМаскаКлюча", ПараметрыСеанса.МаскаЛицензирования);
		Исключение 
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка при лицензировании'"),
       УровеньЖурналаРегистрации.Ошибка,,,
       ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецПопытки;
	
КонецПроцедуры // ПриДобавленииПараметровРаботыКлиентаПриЗапуске()

// Задает параметры функциональных опций, действие которых распространяется на командный интерфейс и рабочий стол.
// Например, если значения функциональной опции хранятся в ресурсах регистра сведений,
// то параметры функциональных опций могут определять условия отборов по измерениям регистра,
// которые будут применяться при чтении значения этой функциональной опции.
//
// См. в синтакс-помощнике методы ПолучитьФункциональнуюОпциюИнтерфейса,
// УстановитьПараметрыФункциональныхОпцийИнтерфейса и ПолучитьПараметрыФункциональныхОпцийИнтерфейса.
//
// Параметры:
//   ОпцииИнтерфейса - Структура - значения параметров функциональных опций, установленных для командного интерфейса.
//       Ключ элемента структуры определяет имя параметра, а значение элемента - текущее значение параметра.
//
Процедура ПриОпределенииПараметровФункциональныхОпцийИнтерфейса(ОпцииИнтерфейса) Экспорт
	
	МаскаЛицензирования = АльфаАвтоВызовСервера.ПолучитьМаскуЛицензирования();
	
	Если МаскаЛицензирования <> Неопределено Тогда
		ОпцииИнтерфейса.Вставить("ДоступностьПодсистемПоКлючуМаскаКлюча", АльфаАвтоВызовСервера.ПолучитьМаскуЛицензирования());
	КонецЕсли;
	
КонецПроцедуры // ПриОпределенииПараметровФункциональныхОпцийИнтерфейса()

#КонецОбласти