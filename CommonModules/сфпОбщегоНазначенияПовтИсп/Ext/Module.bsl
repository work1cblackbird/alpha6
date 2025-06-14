﻿#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает признак наличия в конфигурации общих реквизитов-разделителей.
//
// Возвращаемое значение:
//  Булево - Признак разделенной конфигурации.
//
Функция сфпЭтоРазделеннаяКонфигурация() Экспорт
	
	ЕстьРазделители = Ложь;
	Для каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
		Если ОбщийРеквизит.РазделениеДанных = Метаданные.СвойстваОбъектов.РазделениеДанныхОбщегоРеквизита.Разделять Тогда
			ЕстьРазделители = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЕстьРазделители;
	
КонецФункции

// Возвращает признак включения условного разделения.
// В случае вызова в неразделенной конфигурации возвращает Ложь.
//
// Возвращаемое значение:
//  Булево - Признак включенного разделения данных.
//
Функция сфпРазделениеВключено() Экспорт
	
	Попытка
		ИмяОпции = "РаботаВМоделиСервиса";
		ЗначениеОпции = ПолучитьФункциональнуюОпцию(ИмяОпции);
	Исключение
		ЗначениеОпции = Ложь;
	КонецПопытки;
	
	Возврат сфпЭтоРазделеннаяКонфигурация() И ЗначениеОпции;
	
КонецФункции

// Возвращает Истина, если привилегированный режим был установлен
// при запуске с помощью параметра UsePrivilegedMode.
// Поддерживается только при запуске клиентских приложений
// (внешнее соединение не поддерживается).
//
// Возвращаемое значение:
//  Булево - Признак установки привилегированного режима.
//
Функция сфпПривилегированныйРежимУстановленПриЗапуске() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		Возврат ПараметрыСеанса["ПараметрыКлиентаНаСервере"].Получить(
			"ПривилегированныйРежимУстановленПриЗапуске") = Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

// Возвращает список используемых типов контактов.
//
// Возвращаемое значение:
//  СписокЗначений - Список используемых типов контактов.
//
Функция сфпПолучитьИспользуемыеТипыКонтактов() Экспорт

	ИспользуемыеТипы = Новый СписокЗначений();

	Если Метаданные.РегистрыСведений.Найти("КонтактнаяИнформация") <> Неопределено Тогда
		МассивТипов = Метаданные.РегистрыСведений["КонтактнаяИнформация"].Измерения.Объект.Тип.Типы();

	Иначе
		МассивТипов = Метаданные.ОпределяемыеТипы["сфпКонтактВзаимодействия"].Тип.Типы();
	КонецЕсли;

	Для Каждого ТипСправочника Из МассивТипов Цикл
		СправочникСсылка = Новый(ТипСправочника);
		МетаданныеСправочника = СправочникСсылка.Метаданные();
		ИмяМетаданных = МетаданныеСправочника.Имя;
		
		Окончание = "";
		Если ИмяМетаданных = "КонтактныеЛица" Тогда
			Окончание = " (Контрагенты)";

		ИначеЕсли ИмяМетаданных = "КонтактныеЛицаПартнеров" Тогда
			Окончание = " (Партнеры)";	
		КонецЕсли;
		
		ИспользуемыеТипы.Добавить(ИмяМетаданных, МетаданныеСправочника.Представление() + Окончание);
	КонецЦикла;
		
	Возврат ИспользуемыеТипы;
				
КонецФункции

// Функция - Действие при исходящем звонке.
// 
// Возвращаемое значение:
//  Строка - описание действия при звонке.
// 
Функция ДействиеПриИсходящемЗвонке() Экспорт
	
	Возврат сфпСофтФонПроСервер.ПолучитьНастройкиТелефонии().ДействиеИсходящегоЗвонка;
	
КонецФункции

// Получение значения константы.
//
// Параметры:
//  ИмяКонстанты - Строка	 -  имя константы.
// 
// Возвращаемое значение:
//  Произвольный - значение константы.
// 
Функция ПолучитьЗначениеКонстанты(ИмяКонстанты) Экспорт

	Возврат Константы[ИмяКонстанты].Получить();

КонецФункции

// Разделяет переданную строку на массив строк по разделителю.
//
// Параметры:
//  ПутьКОбъектуКоллекции - Строка - Полный путь к объекту метаданных.
//  Имя	                  - Строка - Имя метаданных объекта.
// 
// Возвращаемое значение:
//  Булево - Если нашли в метаданных, возвращается Истина.
// 
Функция НайтиВМетаданныхПоИмени(ПутьКОбъектуКоллекции = "", Имя = "") Экспорт
	
	Результат		= Ложь;
	ВыполняемыйКод	= "Результат = НЕ Метаданные";
	Массив			= сфпСтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПутьКОбъектуКоллекции, ".", Ложь);
	
	Для Каждого ЭлементМассива ИЗ Массив Цикл
		ВыполняемыйКод = ВыполняемыйКод + "["""+ЭлементМассива+"""]";
	КонецЦикла;
	ВыполняемыйКод = ВыполняемыйКод + ".Найти("""+Имя+""") = Неопределено";
	
	Попытка
		Выполнить(ВыполняемыйКод);
	Исключение
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти