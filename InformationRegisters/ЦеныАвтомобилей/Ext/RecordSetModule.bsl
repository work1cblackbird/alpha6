﻿// Модуль набора записей регистра "Цены автомобилей"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ДокументОбъект Экспорт;               	// Документа объект выполняющий движения
Перем ТипЦен Экспорт;							// тип устанавливаемых цен
Перем РезультатЗапросаПоАвтомобилям Экспорт;	// РезультатЗапроса или ТаблицаЗначений. Устанавливается если документ имеет "необычную" ТЧ
Перем ПроверятьОдинаковыеЦены Экспорт;			// Булево. Если Истина, то перед установкой цен проверяется не дублируются ли цены
Перем ДатаНачалаДействия Экспорт;    			// Дата начала действий

// ускоряющие переменные
Перем ВалютаТипаЦен;            // Ссылка на валюту типа цен
Перем КурсВалютыТипаЦен;        // Курс вылюты типа цен
Перем ТочностьТипаЦен;          // Точность типа цен
Перем ОкруглятьВБольшуюСторону; // Признак округления в обльшую сторону

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ОбработкаСобытийРегистраСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты) Тогда
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверка, не пытаемся ли мы в документе установить на один и тот же автомобиль разные цены
// Возвращает Истина - если все в порядке, Ложь - если есть дубли.
Функция ПроверитьУстановкуОдинаковыхЦен()
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДокАвтомобили.НомерСтроки КАК НомерСтроки,
	|	ДокАвтомобили.Автомобиль КАК Автомобиль,
	|	ДокАвтомобили.ВариантКомплектации КАК ВариантКомплектации
	|ИЗ
	|	Документ."+ДокументОбъект.Метаданные().Имя+".Автомобили КАК ДокАвтомобили
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ."+ДокументОбъект.Метаданные().Имя+".Автомобили КАК ДокАвтомобили2
	|	ПО ДокАвтомобили2.Ссылка=&Ссылка
	|	И ДокАвтомобили2.Автомобиль=ДокАвтомобили.Автомобиль
	|	И ДокАвтомобили2.ВариантКомплектации=ДокАвтомобили.ВариантКомплектации
	|	И ДокАвтомобили2.Цена<>ДокАвтомобили.Цена
	|ГДЕ
	|	ДокАвтомобили.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка" , ДокументОбъект.Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		// сообщим о разных ценах
		ТаблицаОшибок = Результат.Выгрузить();
		ТаблицаОшибок.Сортировать("Автомобиль Возр, ВариантКомплектации Возр, НомерСтроки Возр");
		Пока ТаблицаОшибок.Количество() > 0 Цикл
			Автомобиль          = ТаблицаОшибок[0].Автомобиль;
			ВариантКомплектации = ТаблицаОшибок[0].ВариантКомплектации;
			
			СтруктураОтбора      = Новый Структура("Автомобиль,ВариантКомплектации",Автомобиль,ВариантКомплектации);
			МассивНайденныхСтрок = ТаблицаОшибок.НайтиСтроки(СтруктураОтбора); СтрНомерСтрок="";
			Для Сч=0 По МассивНайденныхСтрок.ВГраница() Цикл
				ТекСтрока     = МассивНайденныхСтрок[Сч];
				СтрНомерСтрок = СтрНомерСтрок+?(ПустаяСтрока(СтрНомерСтрок),"",",")+Формат(ТекСтрока.НомерСтроки,"ЧГ=0");
				ТаблицаОшибок.Удалить(ТекСтрока);
			КонецЦикла;
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Для автомобиля <%1> %2 установлены разные цены в строках %3.'"),
				Автомобиль, 
				?(НЕ ЗначениеЗаполнено(ВариантКомплектации), "", " в комплектации <" + СокрЛП(ВариантКомплектации) + ">"),
				СтрНомерСтрок
			);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Автомобиль);
		КонецЦикла;
		Возврат Ложь;
	КонецЕсли;
		
	Возврат Истина
КонецФункции

// получаем таблицу автомобилей и их цен
Функция ПолучитьТаблицуАвтомобилей()
	Запрос=Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументАвтомобили.Автомобиль КАК Автомобиль,
	|	ДокументАвтомобили.ВариантКомплектации КАК ВариантКомплектации,
	|	ДокументАвтомобили.Цена КАК НоваяЦена,
	|	ЕСТЬNULL(ЦеныВБазе.Цена,0) КАК ЦенаВБазе
	|ИЗ
	|	Документ."+ДокументОбъект.Метаданные().Имя+".Автомобили КАК ДокументАвтомобили
	|	ЛЕВОЕ ВНЕШНЕЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ЦеныАвтомобилей.СрезПоследних(&Момент,	  ТипЦен=&ТипЦен 
	//|															И Автомобиль В (ВЫБРАТЬ Автомобиль ИЗ Документ."+ДокументОбъект.Метаданные().Имя
	//|															+".Автомобили ГДЕ Ссылка=&Ссылка) 
	|															И ВариантКомплектации В (ВЫБРАТЬ ВариантКомплектации ИЗ Документ."+ДокументОбъект.Метаданные().Имя+".Автомобили ГДЕ Ссылка=&Ссылка) 
	|												  ) КАК ЦеныВБазе
	|
	|	ПО
	|		(ДокументАвтомобили.Автомобиль = ЦеныВБазе.Автомобиль) И
	|		(ДокументАвтомобили.ВариантКомплектации = ЦеныВБазе.ВариантКомплектации)
	|
	|ГДЕ
	|	(ДокументАвтомобили.Ссылка = &Ссылка) И
	|	(ДокументАвтомобили.Цена > 0)
	|");
	Запрос.УстановитьПараметр("Ссылка",ДокументОбъект.Ссылка);
	Запрос.УстановитьПараметр("ТипЦен",ТипЦен);
	Запрос.УстановитьПараметр("Момент",ДатаНачалаДействия);
	
	Возврат Запрос.Выполнить();
КонецФункции

// устанавливает цены
Функция УстановитьЦены() Экспорт
	
	// заполним незаполненные переменные.
	ДатаПереоценки = ?(ТипЗнч(ДатаНачалаДействия) = Тип("Дата"), ДатаНачалаДействия, ДокументОбъект.Дата);
	
	// заполним незаполненные переменные
	ПроверятьОдинаковыеЦены = ?(ПроверятьОдинаковыеЦены = Неопределено, Истина, ПроверятьОдинаковыеЦены);
	
	// проверим, а не пытаемся ли установить одинаковые цены
	Если ПроверятьОдинаковыеЦены И НЕ ПроверитьУстановкуОдинаковыхЦен() Тогда
		// скинем переменные
		ТипЦен                        = Неопределено;
		РезультатЗапросаПоАвтомобилям = Неопределено;
		ПроверятьОдинаковыеЦены       = Неопределено;
		
		// убиваем циклическую ссылку
		ДокументОбъект = Неопределено;
		Возврат Ложь;
	КонецЕсли;

	// получаем таблицу автомобилей
	Если (РезультатЗапросаПоАвтомобилям = Неопределено) ИЛИ (ТипЗнч(РезультатЗапросаПоАвтомобилям) <> Тип("РезультатЗапроса")) И (ТипЗнч(РезультатЗапросаПоАвтомобилям) <> Тип("ТаблицаЗначений")) Тогда
		РезультатЗапросаПоАвтомобилям = ПолучитьТаблицуАвтомобилей();
	КонецЕсли;
	Если ТипЗнч(РезультатЗапросаПоАвтомобилям) = Тип("РезультатЗапроса") Тогда
		РезультатЗапросаПоАвтомобилям = РезультатЗапросаПоАвтомобилям.Выгрузить();
	КонецЕсли;
	
	// ускоряющие переменные
	СтрТипЦен           = ТипЦен.Наименование;
	СообщатьОбИзменении = ПраваИНастройкиПользователя.Значение("СообщатьОбИзмененииЦен", ДокументОбъект);
	
	ВалютаТипаЦен     = ТипЦен.ВалютаЦены;
	СтрВалютаТипаЦен  = СокрЛП(ВалютаТипаЦен.Наименование);
	СтруктураКурса    = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаТипаЦен, ДокументОбъект.Дата);
	КурсВалютыТипаЦен = СтруктураКурса.Курс/?(СтруктураКурса.Кратность = 0, 1, СтруктураКурса.Кратность);
	
	// устанавливаем цены
	Для Каждого СтрокаАвтомобиль Из РезультатЗапросаПоАвтомобилям Цикл
		Если ТипЦен.ВВалютеУчета Тогда
			ВалютаТипаЦен = Справочники.Валюты.ПустаяСсылка();
			Если ТипЗнч(СтрокаАвтомобиль.Автомобиль) = Тип("СправочникСсылка.Автомобили") Тогда
				ВалютаТипаЦен = СтрокаАвтомобиль.Автомобиль.ВалютаУчета;
			ИначеЕсли ТипЗнч(СтрокаАвтомобиль.Автомобиль) = Тип("СправочникСсылка.Модели") Тогда
				Если НЕ ЗначениеЗаполнено(СтрокаАвтомобиль.ВариантКомплектации) Тогда
					ВалютаТипаЦен = СтрокаАвтомобиль.Автомобиль.ВалютаУчета;
				Иначе
					ВалютаТипаЦен = СтрокаАвтомобиль.ВариантКомплектации.ВалютаУчета;
				КонецЕсли; 
			КонецЕсли; 
			СтрВалютаТипаЦен  = СокрЛП(ВалютаТипаЦен.Наименование);
			СтруктураКурса    = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаТипаЦен,ДокументОбъект.Дата);
			КурсВалютыТипаЦен = СтруктураКурса.Курс/?(СтруктураКурса.Кратность = 0, 1, СтруктураКурса.Кратность);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВалютаТипаЦен) Тогда
			НоваяЦена = Окр(РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СтрокаАвтомобиль.НоваяЦена, ДокументОбъект.ВалютаДокумента, ДокументОбъект.КурсДокумента, ВалютаТипаЦен,КурсВалютыТипаЦен),2);
			
			// если цена не была установлена или изменилась тогда установим ее
			Если НоваяЦена <> СтрокаАвтомобиль.ЦенаВБазе Тогда
				
				НоваяЗапись 					= Добавить();
				НоваяЗапись.Период              = ДатаПереоценки;
				НоваяЗапись.Регистратор         = ДокументОбъект.Ссылка;
				НоваяЗапись.ТипЦен              = ТипЦен;
				НоваяЗапись.Автомобиль          = СтрокаАвтомобиль.Автомобиль;
				НоваяЗапись.ВариантКомплектации = СтрокаАвтомобиль.ВариантКомплектации;
				НоваяЗапись.Цена                = НоваяЦена;
				
				// сообщим, если надо
				Если СообщатьОбИзменении Тогда
					
					ТекстСообщения = СтрШаблон(
						НСтр("ru = '<%1>%2. Старая цена: %3. Новая цена: %4 %5. Тип цен: %6.'"),
						СтрокаАвтомобиль.Автомобиль,
						?(НЕ ЗначениеЗаполнено(СтрокаАвтомобиль.ВариантКомплектации), "", " в комплектации <"+СокрЛП(СтрокаАвтомобиль.ВариантКомплектации)+">"),
						Формат(СтрокаАвтомобиль.ЦенаВБазе,"ЧЦ=15; ЧДЦ=2; ЧН=0,00"),
						Формат(НоваяЦена,"ЧЦ=15; ЧДЦ=2; ЧН=0,00"),
						СтрВалютаТипаЦен,
						СтрТипЦен
					);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, СтрокаАвтомобиль.Автомобиль);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// скинем переменные
	ТипЦен                        = Неопределено;
	РезультатЗапросаПоАвтомобилям = Неопределено;
	ПроверятьОдинаковыеЦены       = Неопределено;
	ДатаНачалаДействия        	  = Неопределено;
	ДокументОбъект                = Неопределено;
	
	Возврат Истина;
КонецФункции

#КонецОбласти

#КонецЕсли