﻿// Модуль набора записей регистра накоплений "Комплектация автомобилей"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем РежимПроведения Экспорт;           // Режим проведения документа. Если проведение неоперативное - проверок остатков нет

Перем ДокументОбъект Экспорт;            // Документ, осуществляющий движение по регистру
Перем РезультатЗапросаПоТоварам Экспорт; // Выборка табличной части или таблица значений табличной части товаров
Перем Автомобиль Экспорт;                // Ссылка на автомобиль, комплектация которого производится. Если значение неопределено автомобиль находится в табличной части товаров
Перем СкладКомпании Экспорт;             // Ссылка на склад компании
Перем ПериодДвижения Экспорт;            // Период движения регистра. Если период не задан, он берется из ДокументОбъект.Дата
Перем ШапкаДокумента Экспорт;            // Выборка или строка таблицы значений, в которой содержаться необходимые данные о шапке документа
Перем СторноПриход Экспорт;              // Флаг используется в функции Расход() и означает, что будет операция не расхода, а сторно.

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////
// Функции модуля набора записей

// Формирует движения по регистру приход (увеличение комплектации автомобиля)
// Возвращаемое значение: Булево. Истина - все ОК, Ложь - ошибка.
Функция Приход() Экспорт
	ВсеОК = Истина;
	
	ВалютаРегл     = Константы.ВалютаРегламентированногоУчетаОрганизаций.Получить();
	ВалютаУпр      = Константы.ВалютаУправленческогоУчетаКомпании.Получить(); 
	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРегл, ШапкаДокумента.МоментВремени);
	КурсРегл       = СтруктураКурса.Курс / ?(СтруктураКурса.Кратность = 0, 1, СтруктураКурса.Кратность);
	
	Если ЕстьРеквизит(ДокументОбъект, "КурсВалютыУпр") Тогда
		КурсУпр = ШапкаДокумента.КурсВалютыУпр;
	Иначе
		КурсУпр = Неопределено;
	КонецЕсли;
	
	Если КурсУпр = Неопределено ИЛИ НЕ ЗначениеЗаполнено(КурсУпр) Тогда
		СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаУпр, ШапкаДокумента.МоментВремени);
		КурсУпр        = СтруктураКурса.Курс / ?(СтруктураКурса.Кратность = 0, 1, СтруктураКурса.Кратность);
	КонецЕсли;
	
	ПериодДвижения = ?(ПериодДвижения = Неопределено, ШапкаДокумента.Дата, ПериодДвижения);
	
	// Перебираем строки товаров
	Для Каждого СтрокаТоваров Из РезультатЗапросаПоТоварам Цикл
		НоваяЗапись = Добавить();
		НоваяЗапись.ВидДвижения                = ВидДвиженияНакопления.Приход;
		НоваяЗапись.Период                     = ПериодДвижения;
		НоваяЗапись.Регистратор                = ШапкаДокумента.Ссылка;
		НоваяЗапись.Автомобиль                 = ?(Автомобиль = Неопределено, СтрокаТоваров.Автомобиль, Автомобиль);
		НоваяЗапись.СкладКомпании              = СкладКомпании;
		НоваяЗапись.Номенклатура               = СтрокаТоваров.Номенклатура;
		НоваяЗапись.ХарактеристикаНоменклатуры = СтрокаТоваров.ХарактеристикаНоменклатуры;
		НоваяЗапись.СтатусПартии               = СтрокаТоваров.СтатусПартии;
		НоваяЗапись.Партия                     = СтрокаТоваров.Партия;
		НоваяЗапись.ГТД                        = СтрокаТоваров.ГТД;
		НоваяЗапись.ХозОперация                = ШапкаДокумента.ХозОперация;
		НоваяЗапись.СтавкаНДС                  = СтрокаТоваров.СтавкаНДС;
		НоваяЗапись.Количество                 = СтрокаТоваров.Количество;
		НоваяЗапись.Сумма                      = СтрокаТоваров.Сумма;
		НоваяЗапись.СуммаНДС                   = СтрокаТоваров.СуммаНДС;
		НоваяЗапись.СуммаБезНДС                = СтрокаТоваров.Сумма - СтрокаТоваров.СуммаНДС;
		Попытка
			СуммаУпр    = СтрокаТоваров.СуммаУпр;
			СуммаНДСУпр = СтрокаТоваров.СуммаНДСУпр;
		Исключение
			СуммаУпр    = Окр(РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СтрокаТоваров.Сумма, ШапкаДокумента.ВалютаДокумента, ШапкаДокумента.КурсДокумента, ВалютаУпр, КурсУпр), 2);
			СуммаНДСУпр = Окр(РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СтрокаТоваров.СуммаНДС, ШапкаДокумента.ВалютаДокумента, ШапкаДокумента.КурсДокумента, ВалютаУпр, КурсУпр), 2);
		КонецПопытки;
		
		НоваяЗапись.СуммаУпр       = Окр(СуммаУпр, 2);
		НоваяЗапись.СуммаНДСУпр    = Окр(СуммаНДСУпр, 2);
		НоваяЗапись.СуммаБезНДСУпр = НоваяЗапись.СуммаУпр - НоваяЗапись.СуммаНДСУпр;
		
		Попытка
			НоваяЗапись.СуммаПродажи    = Окр(РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СтрокаТоваров.Цена * СтрокаТоваров.Количество, ШапкаДокумента.ВалютаДокумента, ШапкаДокумента.КурсДокумента, ВалютаРегл, КурсРегл), 2);
			НоваяЗапись.СуммаПродажиУпр = Окр(РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СтрокаТоваров.Цена * СтрокаТоваров.Количество, ШапкаДокумента.ВалютаДокумента, ШапкаДокумента.КурсДокумента, ВалютаУпр, КурсУпр), 2);
		Исключение 
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Не прошел пересчет по валюте'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));	
		КонецПопытки;
	КонецЦикла; 
	
	// запись движений
	Если ВсеОК Тогда
		Записать();
	КонецЕсли; 
	
	ДокументОбъект            = Неопределено;
	ШапкаДокумента            = Неопределено;
	РезультатЗапросаПоТоварам = Неопределено;
	Автомобиль                = Неопределено;
	СкладКомпании             = Неопределено;
	
	Возврат ВсеОК;
КонецФункции

// Формирует движения по регистру расход (уменьшение комплектации автомобиля)
// Возвращаемое значение: Булево. Истина - все ОК, Ложь - ошибка.
Функция Расход() Экспорт
	ВсеОК = Истина;
	
	ВалютаРегл     = Константы.ВалютаРегламентированногоУчетаОрганизаций.Получить();
	ВалютаУпр      = Константы.ВалютаУправленческогоУчетаКомпании.Получить();
	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРегл, ШапкаДокумента.МоментВремени);
	КурсРегл	   = СтруктураКурса.Курс / ?(СтруктураКурса.Кратность = 0, 1, СтруктураКурса.Кратность);
	
	Если ЕстьРеквизит(ДокументОбъект, "КурсВалютыУпр") Тогда
		КурсУпр = ШапкаДокумента.КурсВалютыУпр;
	Иначе
		КурсУпр = Неопределено;
	КонецЕсли;
	
	Если КурсУпр = Неопределено ИЛИ НЕ ЗначениеЗаполнено(КурсУпр) Тогда
		СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаУпр, ШапкаДокумента.МоментВремени);
		КурсУпр        = СтруктураКурса.Курс / ?(СтруктураКурса.Кратность = 0, 1, СтруктураКурса.Кратность);
	КонецЕсли;
	
	ПериодДвижения = ?(ПериодДвижения = Неопределено, ШапкаДокумента.Дата, ПериодДвижения);
	СторноПриход   = ?(СторноПриход = Неопределено, Ложь, СторноПриход);
	
	// получим таблицу товарного состава
	Если (РезультатЗапросаПоТоварам = Неопределено) ИЛИ (ТипЗнч(РезультатЗапросаПоТоварам) <> Тип("РезультатЗапроса")) И (ТипЗнч(РезультатЗапросаПоТоварам) <> Тип("ТаблицаЗначений")) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	КомплектацияАвтомобилейОстатки.Номенклатура КАК Номенклатура,
		|	КомплектацияАвтомобилейОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	СУММА(КомплектацияАвтомобилейОстатки.КоличествоОстаток) КАК Количество,
		|	СУММА(КомплектацияАвтомобилейОстатки.СуммаОстаток) КАК Сумма,
		|	СУММА(КомплектацияАвтомобилейОстатки.СуммаНДСОстаток) КАК СуммаНДС,
		|	СУММА(КомплектацияАвтомобилейОстатки.СуммаБезНДСОстаток) КАК СуммаБезНДС,
		|	СУММА(КомплектацияАвтомобилейОстатки.СуммаУпрОстаток) КАК СуммаУпр,
		|	СУММА(КомплектацияАвтомобилейОстатки.СуммаНДСУпрОстаток) КАК СуммаНДСУпр,
		|	СУММА(КомплектацияАвтомобилейОстатки.СуммаБезНДСУпрОстаток) КАК СуммаБезНДСУпр,
		|	СУММА(КомплектацияАвтомобилейОстатки.СуммаПродажиОстаток) КАК СуммаПродажи,
		|	СУММА(КомплектацияАвтомобилейОстатки.СуммаПродажиУпрОстаток) КАК СуммаПродажиУпр
		|ИЗ
		|	РегистрНакопления.КомплектацияАвтомобилей.Остатки(&НаДату,Автомобиль=&Автомобиль И СкладКомпании=&СкладКомпании) КАК КомплектацияАвтомобилейОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	КомплектацияАвтомобилейОстатки.Номенклатура,
		|	КомплектацияАвтомобилейОстатки.ХарактеристикаНоменклатуры";
		Запрос.УстановитьПараметр("НаДату"        , ПериодДвижения);
		Запрос.УстановитьПараметр("Автомобиль"    , Автомобиль);
		Запрос.УстановитьПараметр("СкладКомпании" , СкладКомпании);
		
		РезультатЗапросаПоТоварам = Запрос.Выполнить();
	КонецЕсли;
	
	Если ТипЗнч(РезультатЗапросаПоТоварам) = Тип("РезультатЗапроса") Тогда
		РезультатЗапросаПоТоварам = РезультатЗапросаПоТоварам.Выгрузить();
	КонецЕсли;
	
	ВремРезультатЗапросаПоТоварам = РезультатЗапросаПоТоварам.Скопировать();
	
	ЕстьПартия = ВремРезультатЗапросаПоТоварам.Колонки.Найти("Партия") <> Неопределено;
	ЕстьГТД    = ВремРезультатЗапросаПоТоварам.Колонки.Найти("ГТД") <> Неопределено;
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КомплектацияАвтомобилейОстатки.Номенклатура КАК Номенклатура,
	|	КомплектацияАвтомобилейОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	КомплектацияАвтомобилейОстатки.СтатусПартии КАК СтатусПартии,
	|	КомплектацияАвтомобилейОстатки.Партия КАК Партия,
	|	КомплектацияАвтомобилейОстатки.ГТД КАК ГТД,
	|	СУММА(КомплектацияАвтомобилейОстатки.КоличествоОстаток) КАК Количество,
	|	СУММА(КомплектацияАвтомобилейОстатки.СуммаОстаток) КАК Сумма,
	|	СУММА(КомплектацияАвтомобилейОстатки.СуммаНДСОстаток) КАК СуммаНДС,
	|	СУММА(КомплектацияАвтомобилейОстатки.СуммаБезНДСОстаток) КАК СуммаБезНДС,
	|	СУММА(КомплектацияАвтомобилейОстатки.СуммаУпрОстаток) КАК СуммаУпр,
	|	СУММА(КомплектацияАвтомобилейОстатки.СуммаНДСУпрОстаток) КАК СуммаНДСУпр,
	|	СУММА(КомплектацияАвтомобилейОстатки.СуммаБезНДСУпрОстаток) КАК СуммаБезНДСУпр,
	|	СУММА(КомплектацияАвтомобилейОстатки.СуммаПродажиОстаток) КАК СуммаПродажи,
	|	СУММА(КомплектацияАвтомобилейОстатки.СуммаПродажиУпрОстаток) КАК СуммаПродажиУпр
	|ИЗ
	|	РегистрНакопления.КомплектацияАвтомобилей.Остатки(
	|		&НаДату,
	|		Автомобиль = &Автомобиль И
	|		СкладКомпании = &СкладКомпании И
	|		Номенклатура В (&Номенклатура) И
	|		ХарактеристикаНоменклатуры В (&ХарактеристикаНоменклатуры)) КАК КомплектацияАвтомобилейОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	КомплектацияАвтомобилейОстатки.Номенклатура,
	|	КомплектацияАвтомобилейОстатки.ХарактеристикаНоменклатуры,
	|	КомплектацияАвтомобилейОстатки.СтатусПартии,
	|	КомплектацияАвтомобилейОстатки.Партия,
	|	КомплектацияАвтомобилейОстатки.ГТД";
	Запрос.УстановитьПараметр("НаДату"                     , ПериодДвижения);
	Запрос.УстановитьПараметр("Автомобиль"                 , Автомобиль);
	Запрос.УстановитьПараметр("СкладКомпании"              , СкладКомпании);
	Запрос.УстановитьПараметр("Номенклатура"               , ВремРезультатЗапросаПоТоварам.ВыгрузитьКолонку("Номенклатура"));
	Запрос.УстановитьПараметр("ХарактеристикаНоменклатуры" , ВремРезультатЗапросаПоТоварам.ВыгрузитьКолонку("ХарактеристикаНоменклатуры"));
	
	ВыборкаПоКомплектации = Запрос.Выполнить().Выгрузить();
	
	// Перебираем строки товаров
	Для Каждого СтрокаТоваров Из ВремРезультатЗапросаПоТоварам Цикл
		СтруктураОтбораТоваров = Новый Структура("Номенклатура,ХарактеристикаНоменклатуры", СтрокаТоваров.Номенклатура, СтрокаТоваров.ХарактеристикаНоменклатуры);
		
		Если ЕстьПартия И ЗначениеЗаполнено(СтрокаТоваров.Партия) Тогда
			СтруктураОтбораТоваров.Вставить("Партия", СтрокаТоваров.Партия);
		КонецЕсли;
		Если ЕстьГТД И ЗначениеЗаполнено(СтрокаТоваров.ГТД) Тогда
			СтруктураОтбораТоваров.Вставить("ГТД", СтрокаТоваров.ГТД);
		КонецЕсли; 
		
		СтрокиНоменклатурыКомплектации = ВыборкаПоКомплектации.НайтиСтроки(СтруктураОтбораТоваров);
		Количество = СтрокаТоваров.Количество;
		КоличествоУстановлено = 0;
		
		Для Каждого СтрокаКомплектации Из СтрокиНоменклатурыКомплектации Цикл
			Если Количество = 0 Тогда
				Прервать;
			КонецЕсли;
			
			КоличествоСписания = Мин(Количество, СтрокаКомплектации.Количество);
			НоваяЗапись = Добавить();
			
			НоваяЗапись.ВидДвижения                = ?(СторноПриход, ВидДвиженияНакопления.Приход, ВидДвиженияНакопления.Расход);
			НоваяЗапись.Период                     = ШапкаДокумента.Дата;
			НоваяЗапись.Регистратор                = ШапкаДокумента.Ссылка;
			НоваяЗапись.Автомобиль                 = Автомобиль;
			НоваяЗапись.СкладКомпании              = СкладКомпании;
			НоваяЗапись.Номенклатура               = СтрокаКомплектации.Номенклатура;
			НоваяЗапись.ХарактеристикаНоменклатуры = СтрокаКомплектации.ХарактеристикаНоменклатуры;
			НоваяЗапись.СтатусПартии               = СтрокаКомплектации.СтатусПартии;
			НоваяЗапись.Партия                     = СтрокаКомплектации.Партия;
			НоваяЗапись.ГТД                        = СтрокаКомплектации.ГТД;
			НоваяЗапись.Количество                 = КоличествоСписания;
			Если СтрокаКомплектации.Количество <= Количество Тогда
				НоваяЗапись.Сумма           = Окр(СтрокаКомплектации.Сумма, 2);
				НоваяЗапись.СуммаНДС        = Окр(СтрокаКомплектации.СуммаНДС, 2);
				НоваяЗапись.СуммаБезНДС		= Окр(СтрокаКомплектации.СуммаБезНДС, 2);
				НоваяЗапись.СуммаУпр        = Окр(СтрокаКомплектации.СуммаУпр, 2);
				НоваяЗапись.СуммаНДСУпр		= Окр(СтрокаКомплектации.СуммаНДСУпр, 2);
				НоваяЗапись.СуммаБезНДСУпр	= Окр(СтрокаКомплектации.СуммаБезНДСУпр, 2);
				НоваяЗапись.СуммаПродажи    = Окр(СтрокаКомплектации.СуммаПродажи, 2);
				НоваяЗапись.СуммаПродажиУпр = Окр(СтрокаКомплектации.СуммаПродажиУпр, 2);
			Иначе
				НоваяЗапись.Сумма           = Окр(СтрокаКомплектации.Сумма / (СтрокаКомплектации.Количество * Количество), 2);
				НоваяЗапись.СуммаНДС        = Окр(СтрокаКомплектации.СуммаНДС / (СтрокаКомплектации.Количество * Количество), 2);
				НоваяЗапись.СуммаБезНДС		= Окр(СтрокаКомплектации.СуммаБезНДС / (СтрокаКомплектации.Количество * Количество), 2);
				НоваяЗапись.СуммаУпр        = Окр(СтрокаКомплектации.СуммаУпр / (СтрокаКомплектации.Количество * Количество), 2);
				НоваяЗапись.СуммаНДСУпр		= Окр(СтрокаКомплектации.СуммаНДСУпр / (СтрокаКомплектации.Количество * Количество), 2);
				НоваяЗапись.СуммаБезНДСУпр	= Окр(СтрокаКомплектации.СуммаБезНДСУпр / (СтрокаКомплектации.Количество * Количество), 2);
				НоваяЗапись.СуммаПродажи    = Окр(СтрокаКомплектации.СуммаПродажи / (СтрокаКомплектации.Количество * Количество), 2);
				НоваяЗапись.СуммаПродажиУпр = Окр(СтрокаКомплектации.СуммаПродажиУпр / (СтрокаКомплектации.Количество * Количество), 2);
			КонецЕсли;
			
			НоваяЗапись.ХозОперация = ШапкаДокумента.ХозОперация;
			
			Если СторноПриход Тогда
				НоваяЗапись.Количество		= -НоваяЗапись.Количество;
				НоваяЗапись.Сумма			= -НоваяЗапись.Сумма;
				НоваяЗапись.СуммаНДС		= -НоваяЗапись.СуммаНДС;
				НоваяЗапись.СуммаБезНДС		= -НоваяЗапись.СуммаБезНДС;
				НоваяЗапись.СуммаУпр		= -НоваяЗапись.СуммаУпр;
				НоваяЗапись.СуммаНДСУпр		= -НоваяЗапись.СуммаНДСУпр;
				НоваяЗапись.СуммаБезНДСУпр	= -НоваяЗапись.СуммаБезНДСУпр;
				НоваяЗапись.СуммаПродажи	= -НоваяЗапись.СуммаПродажи;
				НоваяЗапись.СуммаПродажиУпр	= -НоваяЗапись.СуммаПродажиУпр;
			КонецЕсли;
			
			Количество                    = Количество - КоличествоСписания;
			КоличествоУстановлено         = КоличествоУстановлено + КоличествоСписания;
			СтрокаКомплектации.Количество = СтрокаКомплектации.Количество - КоличествоСписания;
			
			Если СтрокаКомплектации.Количество  = 0 Тогда
				ВыборкаПоКомплектации.Удалить(СтрокаКомплектации);
			КонецЕсли;
		КонецЦикла;
		
		Если Количество > 0 Тогда
			Если НЕ ЗначениеЗаполнено(СтрокаТоваров.ХарактеристикаНоменклатуры) Тогда
				ЗначениеКолонкиКода = УправлениеПечатьюПлатформа.ПолучитьЗначениеКолонкиКода(СтрокаТоваров.Номенклатура);	
				ТекстСообщения = СтрШаблон(
					НСтр("ru = '[%1] Оборудование <%2>. Установлено на автомобиль %3 %4. Списывается %5 %6. Превышение %7 %8'"),
					ЗначениеКолонкиКода,
					СтрокаТоваров.Номенклатура,
					КоличествоУстановлено,
					СтрокаТоваров.Номенклатура.ОсновнаяЕдиницаИзмерения,
					Количество,
					СтрокаТоваров.Номенклатура.ОсновнаяЕдиницаИзмерения,
					Количество - КоличествоУстановлено,
					СтрокаТоваров.Номенклатура.ОсновнаяЕдиницаИзмерения
				);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, СтрокаТоваров.Номенклатура);
			Иначе
				
				ТекстСообщения = СтрШаблон(
					НСтр("ru = '[%1] Оборудование %2 с характеристикой %3. Установлено на автомобиль %4 %5. Списывается %6 %7. Превышение %8 %9'"),
					ЗначениеКолонкиКода,
					СтрокаТоваров.Номенклатура,
					СтрокаТоваров.ХарактеристикаНоменклатуры,
					КоличествоУстановлено, СтрокаТоваров.Номенклатура.ОсновнаяЕдиницаИзмерения,
					Количество,
					СтрокаТоваров.Номенклатура.ОсновнаяЕдиницаИзмерения,
					Количество - КоличествоУстановлено,
					СтрокаТоваров.Номенклатура.ОсновнаяЕдиницаИзмерения
				);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, СтрокаТоваров.Номенклатура);
			КонецЕсли;
			
			ВсеОК = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	// запись движений
	Если ВсеОК Тогда
		Записать();
	КонецЕсли;
	
	ДокументОбъект            = Неопределено;
	ШапкаДокумента            = Неопределено;
	РезультатЗапросаПоТоварам = Неопределено;
	Автомобиль                = Неопределено;
	СкладКомпании             = Неопределено;
	СторноПриход              = Неопределено;
	
	Возврат ВсеОК;
КонецФункции

#КонецОбласти

#Область Инициализация

////////////////////////////////////////////////////////////////////////
// Инициализация переменных модуля набора записей

РежимПроведения = РежимПроведенияДокумента.Оперативный;

ДокументОбъект            = Неопределено; // Обязательный к заполнению перед началом проведения
РезультатЗапросаПоТоварам = Неопределено;
Автомобиль                = Неопределено;
ПериодДвижения            = Неопределено;
СторноПриход              = Неопределено;

#КонецОбласти

#КонецЕсли