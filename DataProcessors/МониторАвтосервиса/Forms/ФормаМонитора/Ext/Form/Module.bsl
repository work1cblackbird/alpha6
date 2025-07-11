﻿
#Область ОписаниеПеременных

// Хранит сопоставление мастеров адресам их фотографий.
&НаКлиенте
Перем ФотографииСотрудников;

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Обработчик события возникающего на сервере при создании формы.
//
// Параметры:
//  Отказ                - Булево - Признак отказа от создания формы.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.ПоказыватьВРаботе    = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ПоказыватьВРаботе",    Истина);
	Объект.ПоказыватьВыдачу     = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ПоказыватьВыдачу",     Истина);
	Объект.ПоказыватьНевыданные = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ПоказыватьНевыданные", Истина);
	Объект.ПоказыватьПриемку    = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ПоказыватьПриемку",    Истина);
	Объект.ПериодСменыСтраниц   = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ПериодСменыСтраниц",   7);
	Объект.СтрокНаСтраницу      = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "СтрокНаСтраницу",      10);
	Объект.ЦветоваяСхема        = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ЦветоваяСхема",        "CSSBlue");
	Объект.РазмерШрифта         = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "РазмерШрифта",         20);
	Объект.ШиринаЛоготипа       = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ШиринаЛоготипа",       320);
	Объект.ВысотаЛоготипа       = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ВысотаЛоготипа",       240);
	Объект.ШиринаФото           = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ШиринаФото",           150);
	Объект.ВысотаФото           = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ВысотаФото",           100);
	Объект.ПутьКартинки         = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ПутьКартинки",         "");
	Объект.ФотоНаЭкран          = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ФотоНаЭкран",          99);
	Объект.ОтображатьСотрудника = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ОтображатьСотрудника", Истина);
	Объект.ВыводДиспетчера      = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ВыводДиспетчера",      Ложь);
	Объект.ВариантОтображения   = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ВариантОтображения",   "ДиспетчерВТаблицеДиспетчерФото");
	Объект.Организация          = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "Организация",          Справочники.Организации.ПустаяСсылка());
	Объект.Идентификатор        = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "Идентификатор",        Справочники.ОрганизацииПрисоединенныеФайлы.ПустаяСсылка());
	Объект.АвтоВНевыданные      = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить(
										"ФормаНастроекОбработкиМониторАвтосервиса", 
										"АвтоВНевыданные",   
										Перечисления.РежимыПопаданияВТаблицуНевыданные.НаСледующийДень);
	Объект.ВремяКонтроляНевыданных      = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить(
										"ФормаНастроекОбработкиМониторАвтосервиса", 
										"ВремяКонтроляНевыданных",  
										'00010101');
	
 
	СхемаКомпановкиДанных = Обработки.МониторАвтосервиса.ПолучитьМакет("Макет");
	АдресСхемыКомпановкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпановкиДанных, УникальныйИдентификатор);
	Объект.ФильтрыОтчета.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпановкиДанных));
	Объект.ФильтрыОтчета.ЗагрузитьНастройки(СхемаКомпановкиДанных.НастройкиПоУмолчанию);
	
	Объект.ФильтрыОтчета.Настройки.Отбор.Элементы[0].Использование  = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ВидРемонтаИспользование",    Ложь);
	Объект.ФильтрыОтчета.Настройки.Отбор.Элементы[0].ВидСравнения   = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ВидРемонтаВидСравнения",     ВидСравненияКомпоновкиДанных.Равно);
	Объект.ФильтрыОтчета.Настройки.Отбор.Элементы[0].ПравоеЗначение = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ВидРемонтаЗначение",         Справочники.ВидыРемонта.ПустаяСсылка());
	Объект.ФильтрыОтчета.Настройки.Отбор.Элементы[1].Использование  = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ОрганизацияИспользование",   Ложь);
	Объект.ФильтрыОтчета.Настройки.Отбор.Элементы[1].ВидСравнения   = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ОрганизацияВидСравнения",    ВидСравненияКомпоновкиДанных.Равно);
	Объект.ФильтрыОтчета.Настройки.Отбор.Элементы[1].ПравоеЗначение = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ОрганизацияЗначение",        ПараметрыСеанса.Организация);
	Объект.ФильтрыОтчета.Настройки.Отбор.Элементы[2].Использование  = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ПодразделениеИспользование", Ложь);
	Объект.ФильтрыОтчета.Настройки.Отбор.Элементы[2].ВидСравнения   = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ПодразделениеВидСравнения",  ВидСравненияКомпоновкиДанных.Равно);
	Объект.ФильтрыОтчета.Настройки.Отбор.Элементы[2].ПравоеЗначение = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ФормаНастроекОбработкиМониторАвтосервиса", "ПодразделениеЗначение",      ПараметрыСеанса.ПодразделениеКомпании);

	ПустаяСтраница = Ложь;
	НужноПереоткрытьФорму = Ложь;
	ПоказатьКомандуПолногоЭкрана = Параметры.Свойство("ПоказатьКомандуПолногоЭкрана");
	
КонецПроцедуры

// Обработчик события возникающего на клиенте при открытии формы, до показа окна пользователю.
//
// Параметры:
//  Отказ - Булево - Признак отказа от создания формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Запрещено использование обработки ""Монитор автосервиса"" в веб-клиенте.'"));
		Отказ = Истина;
		Возврат;
	#КонецЕсли
	
	Если НЕ Объект.ПоказыватьВРаботе И НЕ Объект.ПоказыватьВыдачу И НЕ Объект.ПоказыватьНевыданные И НЕ Объект.ПоказыватьПриемку Тогда
		Объект.ПоказыватьВРаботе    = Истина;
		Объект.ПоказыватьВыдачу     = Истина;
		Объект.ПоказыватьНевыданные = Истина;
		Объект.ПоказыватьПриемку    = Истина;
	КонецЕсли;
	
	ВыведеноСотрудников = 0;
	НомерТаблицы = 0;
	Если Объект.ПоказыватьПриемку Тогда
		НомерТаблицы = 1;
	ИначеЕсли Объект.ПоказыватьВРаботе Тогда
		НомерТаблицы = 2;
	ИначеЕсли Объект.ПоказыватьВыдачу Тогда
		НомерТаблицы = 3;
	ИначеЕсли Объект.ПоказыватьНевыданные Тогда
		НомерТаблицы = 4;
	КонецЕсли;
	ПолеHTMLДокумента = "";
    ВывестиСтраницу();
	
	#Если НЕ МобильныйКлиент Тогда
		Если ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
			РежимОкнаПрограммы = КлиентскоеПриложение.ПолучитьРежимОсновногоОкна();
			Если РежимОкнаПрограммы <> РежимОсновногоОкнаКлиентскогоПриложения.ПолноэкранноеРабочееМесто Тогда
				Элементы.РазвернутьСвернутьОкно.Видимость = ПоказатьКомандуПолногоЭкрана;
				Если ЭтотОбъект.РежимОткрытияОкна <> РежимОткрытияОкнаФормы.Независимый Тогда
					// Горячие клавиши максимизации окна
					WSHShell = Новый COMОбъект("WScript.Shell");	
					WSHShell.SendKeys("% ");
					WSHShell.SendKeys("{UP}{UP}{ENTER}");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	#КонецЕсли
	
	НужноПереоткрытьФорму = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы И НужноПереоткрытьФорму Тогда
		Если ЭтотОбъект.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый Тогда
			РежимОкна = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
		Иначе
			РежимОкна = РежимОткрытияОкнаФормы.Независимый;
		КонецЕсли;
		ПараметрыФормы = Новый Структура("ПоказатьКомандуПолногоЭкрана");
		ОткрытьФорму("Обработка.МониторАвтосервиса.Форма.ФормаМонитора", ПараметрыФормы, , , , , , РежимОкна);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Открытие формы настройки отчета
//
&НаКлиенте
Процедура КоманднаяПанельНастройка(Кнопка)
	ОткрытьФорму("Обработка.МониторАвтосервиса.Форма.ФормаНастроек", СобратьПараметрыДляПередачи(), ЭтаФорма,,,, Новый ОписаниеОповещения("Подключаемый_ОбновитьНастройки", ЭтотОбъект, Параметры), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает структуру реквизитов объекта для передачи в форму настроек
//
&НаКлиенте
Функция СобратьПараметрыДляПередачи()
	
	ПараметрыМонитора = Новый Структура;
	ПараметрыМонитора.Вставить("ПоказыватьВРаботе",          Объект.ПоказыватьВРаботе);
	ПараметрыМонитора.Вставить("ПоказыватьВыдачу",           Объект.ПоказыватьВыдачу);
	ПараметрыМонитора.Вставить("ПоказыватьНевыданные",       Объект.ПоказыватьНевыданные);
	ПараметрыМонитора.Вставить("ПоказыватьПриемку",          Объект.ПоказыватьПриемку);
	ПараметрыМонитора.Вставить("ПериодСменыСтраниц",         Объект.ПериодСменыСтраниц);
	ПараметрыМонитора.Вставить("СтрокНаСтраницу",            Объект.СтрокНаСтраницу);
	ПараметрыМонитора.Вставить("ЦветоваяСхема",              Объект.ЦветоваяСхема);
	ПараметрыМонитора.Вставить("РазмерШрифта",               Объект.РазмерШрифта);
	ПараметрыМонитора.Вставить("ФильтрыОтчета",              Объект.ФильтрыОтчета);
	ПараметрыМонитора.Вставить("ВысотаЛоготипа",             Объект.ВысотаЛоготипа);
	ПараметрыМонитора.Вставить("ШиринаЛоготипа",             Объект.ШиринаЛоготипа);
	ПараметрыМонитора.Вставить("ВысотаФото",                 Объект.ВысотаФото);
	ПараметрыМонитора.Вставить("ШиринаФото",                 Объект.ШиринаФото);
	ПараметрыМонитора.Вставить("Организация",                Объект.Организация);
	ПараметрыМонитора.Вставить("Идентификатор",              Объект.Идентификатор);
	ПараметрыМонитора.Вставить("ПутьКартинки",               Объект.ПутьКартинки);
	ПараметрыМонитора.Вставить("ФотоНаЭкран",                Объект.ФотоНаЭкран);
	ПараметрыМонитора.Вставить("ОтображатьСотрудника",       Объект.ОтображатьСотрудника);
	ПараметрыМонитора.Вставить("ВариантОтображения",         Объект.ВариантОтображения);
	
	Возврат Новый Структура("ПараметрыМонитора", ПараметрыМонитора);
	
КонецФункции

// Вызывает процедуру формирования html макета в зависимости от текущего номера таблицы
//
&НаСервере
Процедура СформироватьОтчет(НомерТаблицы, Выборка)
	
	Если НомерТаблицы = 1 Тогда
		НомерПоследнейСтроки = Обработки.МониторАвтосервиса.СформироватьОтчетПриемка(Объект, Выборка, ПолеHTMLДокумента, ВыведеноСотрудников);
	ИначеЕсли НомерТаблицы = 2 Тогда
		НомерПоследнейСтроки = Обработки.МониторАвтосервиса.СформироватьОтчетВРаботе(Объект, Выборка, ПолеHTMLДокумента, ВыведеноСотрудников);
	ИначеЕсли НомерТаблицы = 3 Тогда
		НомерПоследнейСтроки = Обработки.МониторАвтосервиса.СформироватьОтчетВыдача(Объект, Выборка, ПолеHTMLДокумента, ВыведеноСотрудников);
	ИначеЕсли НомерТаблицы = 4 Тогда
		НомерПоследнейСтроки = Обработки.МониторАвтосервиса.СформироватьОтчетНевыданные(Объект, Выборка, ПолеHTMLДокумента, ВыведеноСотрудников);
	КонецЕсли;
	
КонецПроцедуры //СформироватьОтчет()

// Вызывает процедуру получения выборки данных на сервере в зависимости от текущего номера таблицы
//
&НаСервере
Функция ПолучитьВыборку(НомерТаблицы)
	
	Если НомерТаблицы = 1 Тогда
		Возврат Обработки.МониторАвтосервиса.ПолучитьВыборкуПриемка(Объект, НомерПоследнейСтроки);
	ИначеЕсли НомерТаблицы = 2 Тогда
		Возврат Обработки.МониторАвтосервиса.ПолучитьВыборкуВРаботе(Объект, НомерПоследнейСтроки);
	ИначеЕсли НомерТаблицы = 3 Тогда
		Возврат Обработки.МониторАвтосервиса.ПолучитьВыборкуВыдача(Объект, НомерПоследнейСтроки);
	ИначеЕсли НомерТаблицы = 4 Тогда
		Возврат Обработки.МониторАвтосервиса.ПолучитьВыборкуНевыданные(Объект, НомерПоследнейСтроки);
	КонецЕсли;
	
КонецФункции //ПолучитьВыборкуНаСервере()

// Определяет номер следующей таблицы в зависимости от настроек пользователя
//
&НаСервере
Функция ПолучитьСледующийНомерТаблицы(НомерТаблицы)
	
	Если НомерПоследнейСтроки <> 0 Тогда
		// Для наглядности - если в текущей таблице оставались строки, то выводим ее же.
		НомерТаблицы = НомерТаблицы;
	ИначеЕсли НомерТаблицы = 1 Тогда
		Если Объект.ПоказыватьВРаботе Тогда
			НомерТаблицы = 2;
		ИначеЕсли Объект.ПоказыватьВыдачу Тогда
			НомерТаблицы = 3;
		ИначеЕсли Объект.ПоказыватьНевыданные Тогда
			НомерТаблицы = 4;
		КонецЕсли;
	ИначеЕсли НомерТаблицы = 2 Тогда
		Если Объект.ПоказыватьВыдачу Тогда
			НомерТаблицы = 3;
		ИначеЕсли Объект.ПоказыватьНевыданные Тогда
			НомерТаблицы = 4;
		ИначеЕсли Объект.ПоказыватьПриемку Тогда
			НомерТаблицы = 1;
		КонецЕсли;
	ИначеЕсли НомерТаблицы = 3 Тогда
		Если Объект.ПоказыватьНевыданные Тогда
			НомерТаблицы = 4;
		ИначеЕсли Объект.ПоказыватьПриемку Тогда
			НомерТаблицы = 1;
		ИначеЕсли Объект.ПоказыватьВРаботе Тогда
			НомерТаблицы = 2;
		КонецЕсли;
	ИначеЕсли НомерТаблицы = 4 Тогда
		Если Объект.ПоказыватьПриемку Тогда
			НомерТаблицы = 1;
		ИначеЕсли Объект.ПоказыватьВРаботе Тогда
			НомерТаблицы = 2;
		ИначеЕсли Объект.ПоказыватьВыдачу Тогда
			НомерТаблицы = 3;
		КонецЕсли;
	Иначе
		Если Объект.ПоказыватьПриемку Тогда
			НомерТаблицы = 1;
		ИначеЕсли Объект.ПоказыватьВРаботе Тогда
			НомерТаблицы = 2;
		ИначеЕсли Объект.ПоказыватьВыдачу Тогда
			НомерТаблицы = 3;
		ИначеЕсли Объект.ПоказыватьНевыданные Тогда
			НомерТаблицы = 4;
		КонецЕсли;
	КонецЕсли;
	
	Возврат НомерТаблицы;
	
КонецФункции //ПолучитьСледующийНомерТаблицы()

// Вызывается периодически и выводит одну из страниц отчета
//
&НаКлиенте
Процедура ВывестиСтраницу()
	
	Если Объект.ОтображатьСотрудника Тогда
		пМинШирина = 99999;
		ИнформацияЭкрановКлиента = ПолучитьИнформациюЭкрановКлиента();
		Для Каждого ЭкранКлиента Из ИнформацияЭкрановКлиента Цикл
			Если ЭкранКлиента.Ширина < пМинШирина Тогда
				пМинШирина = ЭкранКлиента.Ширина;
			КонецЕсли;
		КонецЦикла;
		Объект.ФотоНаЭкран = Цел(пМинШирина * 0.8 / Объект.ШиринаФото);
	КонецЕсли;
	
	ЗаполнитьСотрудников(Объект.ВыводДиспетчера);
	ВывестиСтраницуНаСервере();
	
	Если ПустаяТаблица Тогда
		ПодключитьОбработчикОжидания("ВывестиСтраницу", Объект.ПериодСменыСтраниц);
	Иначе
		ПодключитьОбработчикОжидания("ВывестиСтраницу",1);
	КонецЕсли;
	
КонецПроцедуры //ВывестиСтраницу()

// Процедура получает сотрудников, которые участвуют в заявках на ремонт из монитора
//
&НаСервере
Процедура ЗаполнитьСотрудников(ЗаполнятьДиспетчеров)
	Объект.Сотрудники.Очистить();
	Выборка = ПолучитьВыборку(НомерТаблицы);
	
	Пока Выборка.Следующий() Цикл
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Выборка, "Заявка") Тогда
			ПолеВыборкиСотрудника = Выборка.Заявка;
		Иначе
			ПолеВыборкиСотрудника = Выборка;
		КонецЕсли;
		
		Если ЗаполнятьДиспетчеров И Объект.ВариантОтображения = "ДиспетчерВТаблицеДиспетчерФото" Тогда
			
			Если ПолеВыборкиСотрудника.Диспетчер = Справочники.Сотрудники.ПустаяСсылка() Тогда
				Продолжить;
			КонецЕсли;
			НовыйДиспетчер = Объект.Сотрудники.Добавить();
			НовыйДиспетчер.Отображать = Объект.ОтображатьСотрудника;
			НовыйДиспетчер.Сотрудник = ПолеВыборкиСотрудника.Диспетчер;
			НовыйДиспетчер.Идентификатор = ПолеВыборкиСотрудника.Диспетчер.ФайлКартинки;
			
		Иначе
			
			Если ПолеВыборкиСотрудника.Мастер = Справочники.Сотрудники.ПустаяСсылка() Тогда
				Продолжить;
			КонецЕсли;
			НовыйМастер = Объект.Сотрудники.Добавить();
			НовыйМастер.Отображать = Объект.ОтображатьСотрудника;
			НовыйМастер.Сотрудник = ПолеВыборкиСотрудника.Мастер;
			НовыйМастер.Идентификатор = ПолеВыборкиСотрудника.Мастер.ФайлКартинки;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Таб = Объект.Сотрудники.Выгрузить();
	Таб.Свернуть("Отображать, Идентификатор, Сотрудник");
	Объект.Сотрудники.Загрузить(Таб);
КонецПроцедуры //ЗаполнитьСотрудников()

// Вызывается периодически и выводит одну из страниц отчета
//
&НаСервере
Процедура ВывестиСтраницуНаСервере()
	
	Выборка = ПолучитьВыборку(НомерТаблицы);
	Объект.ДатаОтчета = ТекущаяДатаСеанса();
	Если НЕ Выборка.Количество() = 0 Тогда 
		Если НомерТаблицы = 1 И Объект.ОтображатьСотрудника Тогда
			Если Выборка.Следующий() Тогда
				СформироватьОтчет(НомерТаблицы, Выборка);
				ПустаяТаблица = Истина;
				ВыведеноСотрудников = ВыведеноСотрудников + Объект.ФотоНаЭкран;
				Если ВыведеноСотрудников < Объект.Сотрудники.Количество() Тогда
					Возврат;
				Иначе
					ВыведеноСотрудников = 0;
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если Выборка.Следующий() Тогда
				СформироватьОтчет(НомерТаблицы, Выборка);
				ПустаяТаблица = Истина;
			КонецЕсли;
		КонецЕсли;
	Иначе
		НомерПоследнейСтроки = 0;
		ПустаяТаблица = Ложь;
	КонецЕсли;

	НомерТаблицы = ПолучитьСледующийНомерТаблицы(НомерТаблицы);
	
КонецПроцедуры //ВывестиСтраницуНаСервере()

// Обработчик события возникающего после закрытия вопроса.
//
// Параметры:
//  Результат - КодВозвратаДиалога - Результат выполнения операции в подчиненной форме.
//  Параметры - Произвольный       - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура Подключаемый_ОбновитьНастройки(Результат, Параметры) Экспорт
	ПриСозданииНаСервере(Ложь, Истина);
	ПоказатьКомандуПолногоЭкрана = Истина;
	ПриОткрытии(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьСвернутьОкно(Команда)
	
	НужноПереоткрытьФорму = Истина;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ФотографииСотрудников = Новый Соответствие;

#КонецОбласти