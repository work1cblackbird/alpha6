﻿// Модуль набора записей регистра накоплений "Заказы поставщикам"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем РежимПроведения Экспорт;		// Режим проведения документа оперативный/неоперативный

Перем ДокументОбъект Экспорт; // документ выполняющий движения
Перем РезультатЗапросаПоТоварам Экспорт; // если неопределен, то в документе стандартная таблица
Перем РезультатЗапросаПоЗаказам Экспорт; // если неопределен, то в документе стандартная таблица
Перем ЗаказПоставщику Экспорт; // Заказ поставщику
Перем ЗаказОснование Экспорт; // Заказ основание
Перем Контрагент Экспорт; // Ссылка на контрагента
Перем ПоБазовомуКоличеству Экспорт; // Булево. Ложь - количество товаров будет рассчитываться как "Количество*Коэффициент", Истина - количество будет браться из реквизита "КоличествоБазовое"

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСостоянияВЗаказах")
		И НЕ ПолучитьЗначениеПараметраСтруктуры(ЭтотОбъект.ДополнительныеСвойства, "ОтменаПроведения", Ложь) Тогда
		ЗаказыСервер.УстановитьСостояниеЗаказаПоставщика(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Формирует движения по регистру приход (регистрируем заказ поставщика)
// Возвращаемое значение: Булево. Истина - все ОК, Ложь - чего-то не так.
Функция Приход() Экспорт
	ВсеОК = Истина;
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчетаКомпании.Получить();
	
	// получим таблицу товарного состава
	Если (РезультатЗапросаПоТоварам = Неопределено) ИЛИ (ТипЗнч(РезультатЗапросаПоТоварам) <> Тип("РезультатЗапроса")) 
		И (ТипЗнч(РезультатЗапросаПоТоварам) <> Тип("ТаблицаЗначений")) Тогда
		РезультатЗапросаПоТоварам = ПолучитьТаблицуТоваров();
	КонецЕсли;
	
	Если ТипЗнч(РезультатЗапросаПоТоварам) = Тип("РезультатЗапроса") Тогда
		РезультатЗапросаПоТоварам = РезультатЗапросаПоТоварам.Выгрузить();
	КонецЕсли;
	
	Если ТипЗнч(ЗаказПоставщику) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		ВалютаДоговора = ЗаказПоставщику.ДоговорВзаиморасчетов.ВалютаВзаиморасчетов;
	Иначе
		ВалютаДоговора = ДокументОбъект.ДоговорВзаиморасчетов.ВалютаВзаиморасчетов;
	КонецЕсли;
	
	// Перебираем строки товаров
	Для Каждого СтрокаТоваров Из РезультатЗапросаПоТоварам Цикл
		Заказ = ЗаказПоставщику;
		КАгент = Контрагент;
		// добавляем 
		НоваяЗапись = Добавить();
		НоваяЗапись.ВидДвижения = ВидДвиженияНакопления.Приход;
		НоваяЗапись.Период = ДокументОбъект.Дата;
		НоваяЗапись.Регистратор = ДокументОбъект.Ссылка;
		НоваяЗапись.Контрагент = КАгент;
		НоваяЗапись.ЗаказПоставщику = Заказ;
		НоваяЗапись.Номенклатура = СтрокаТоваров.Номенклатура;
		НоваяЗапись.ХарактеристикаНоменклатуры = СтрокаТоваров.ХарактеристикаНоменклатуры;
		// определяемся с хоз. операцией
		НоваяЗапись.ХозОперация = ДокументОбъект.ХозОперация;
		// количество
		НоваяЗапись.Заказано = СтрокаТоваров.Количество;
		// суммы
		НоваяЗапись.Сумма = Окр(?(СтрокаТоваров.СуммаВсего = NULL, 0, 
			РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте((СтрокаТоваров.СуммаВсего / СтрокаТоваров.Количество) 
				* НоваяЗапись.Заказано, ДокументОбъект.ВалютаДокумента, ДокументОбъект.КурсДокумента, 
							ВалютаДоговора, ДокументОбъект.Дата)), 2);
		КурсВалютыУпрВыбор = ?(НЕ ЗначениеЗаполнено(ДокументОбъект.КурсВалютыУпр), 
									ДокументОбъект.Дата, ДокументОбъект.КурсВалютыУпр);		
		НоваяЗапись.СуммаУпр = Окр(?(СтрокаТоваров.СуммаВсего = NULL, 0, 
			РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте((СтрокаТоваров.СуммаВсего / СтрокаТоваров.Количество) 
				* НоваяЗапись.Заказано, ДокументОбъект.ВалютаДокумента, 
					ДокументОбъект.КурсДокумента, ВалютаУпр, КурсВалютыУпрВыбор)), 2);
	КонецЦикла;
	
	// убиваем циклическую ссылку
	ДокументОбъект = Неопределено;
	
	Возврат Истина;
КонецФункции

// Формирует движения по регистру приход (корректируем заказ поставщика)
// Возвращаемое значение: Булево. Истина - все ОК, Ложь - чего-то не так.
Функция КорректировкаЗаказаПоставщика() Экспорт
	
	ВсеОК = Истина;
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчетаКомпании.Получить();
	
	// Получим таблицу товарного состава
	Если (РезультатЗапросаПоТоварам = Неопределено) ИЛИ (ТипЗнч(РезультатЗапросаПоТоварам) <> Тип("РезультатЗапроса")) 
		И (ТипЗнч(РезультатЗапросаПоТоварам) <> Тип("ТаблицаЗначений")) Тогда
		РезультатЗапросаПоТоварам = ПолучитьТаблицуТоваров();
	КонецЕсли;
	
	Если ТипЗнч(РезультатЗапросаПоТоварам) = Тип("РезультатЗапроса") Тогда
		РезультатЗапросаПоТоварам = РезультатЗапросаПоТоварам.Выгрузить();
	КонецЕсли;
	
	// Получение остатков по заказу поставщику
	Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаказыПоставщикамОстатки.Номенклатура КАК Номенклатура,
		|	ЗаказыПоставщикамОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	ЕСТЬNULL(ЗаказыПоставщикамОстатки.ЗаказаноОстаток, 0) КАК Количество,
		|	ЕСТЬNULL(ЗаказыРаспределениеОстатки.КоличествоОстаток, 0) КАК МинимальныйОстаток,
		|	ЕСТЬNULL(ЗаказыПоставщикамОстатки.СуммаОстаток,0) КАК СуммаОстаток,
		|	ЕСТЬNULL(ЗаказыПоставщикамОстатки.СуммаУпрОстаток,0) КАК СуммаУпрОстаток
		|ИЗ
		|	РегистрНакопления.ЗаказыПоставщикам.Остатки(&Момент,
		|			ЗаказПоставщику = &ЗаказПоставщику
		|			И Номенклатура В (&Номенклатура)
		|			И ХарактеристикаНоменклатуры В (&ХарактеристикаНоменклатуры)) КАК ЗаказыПоставщикамОстатки
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрНакопления.ЗаказыРаспределение.Остатки(&Момент,
		|			ЗаказПоставщика = &ЗаказПоставщику
		|			И Номенклатура В (&Номенклатура)
		|			И ХарактеристикаНоменклатуры В (&ХарактеристикаНоменклатуры)) КАК ЗаказыРаспределениеОстатки
		|ПО
		|	ЗаказыПоставщикамОстатки.Номенклатура               = ЗаказыРаспределениеОстатки.Номенклатура
		|	И ЗаказыПоставщикамОстатки.ХарактеристикаНоменклатуры = ЗаказыРаспределениеОстатки.ХарактеристикаНоменклатуры
		|");
	Запрос.УстановитьПараметр("Момент",                     ?(РежимПроведения = РежимПроведенияДокумента.Оперативный, Неопределено, ДокументОбъект.МоментВремени()));
	Запрос.УстановитьПараметр("ЗаказПоставщику",            ЗаказПоставщику);
	Запрос.УстановитьПараметр("Номенклатура",               РезультатЗапросаПоТоварам.ВыгрузитьКолонку("Номенклатура"));
	Запрос.УстановитьПараметр("ХарактеристикаНоменклатуры", РезультатЗапросаПоТоварам.ВыгрузитьКолонку("ХарактеристикаНоменклатуры"));
	
	// Наложим блокировку на считываемые данные
	СтруктураПараметровБлокировки = Новый Структура("ТипТаблицы, ИмяТаблицы", "РегистрНакопления", "ЗаказыПоставщикам");
	ЗначенияБлокировки = Новый Соответствие;
	ОписаниеИсточника  = Новый Соответствие;
	ЗначенияБлокировки.Вставить("Период", Новый Диапазон(, ДокументОбъект.Дата));
	ЗначенияБлокировки.Вставить("ЗаказПоставщику", ЗаказПоставщику);
	
	ОписаниеИсточника.Вставить("Номенклатура", "Номенклатура");
	ОписаниеИсточника.Вставить("ХарактеристикаНоменклатуры", "ХарактеристикаНоменклатуры");
	СтруктураПараметровБлокировки.Вставить("ИсточникДанных", РезультатЗапросаПоТоварам);
	ОбработкаСобытийДокументаСервер.УстановитьУправляемуюБлокировку(СтруктураПараметровБлокировки, ЗначенияБлокировки, ОписаниеИсточника);
	
	ВыборкаОстатковТоваров = Запрос.Выполнить().Выбрать();
	СтруктураОтбораОстатковТоваров = Новый Структура("Номенклатура, ХарактеристикаНоменклатуры");
	
	ВремКонтрагент = ЗаказПоставщику.Контрагент;
	ВалютаДоговора = ЗаказПоставщику.ДоговорВзаиморасчетов.ВалютаВзаиморасчетов;
	ИмяКолонкиКода = УправлениеПечатьюПлатформа.ПолучитьПараметрыРежимаВыводаКодаВДокументах().Имя;
	// Спишем заказанный товар с регистра заказов покупателей
	Для Каждого СтрокаТоваров Из РезультатЗапросаПоТоварам Цикл
		
		Количество = СтрокаТоваров.Количество;
		ВыборкаОстатковТоваров.Сбросить();
		СтруктураОтбораОстатковТоваров.Номенклатура               = СтрокаТоваров.Номенклатура;
		СтруктураОтбораОстатковТоваров.ХарактеристикаНоменклатуры = СтрокаТоваров.ХарактеристикаНоменклатуры;
		
		Если ВыборкаОстатковТоваров.НайтиСледующий(СтруктураОтбораОстатковТоваров) Тогда
			КоличествоОстаток  = ВыборкаОстатковТоваров.Количество;
			МинимальныйОстаток = ВыборкаОстатковТоваров.МинимальныйОстаток;
			СуммаОстаток       = ВыборкаОстатковТоваров.СуммаОстаток;
			СуммаУпрОстаток    = ВыборкаОстатковТоваров.СуммаУпрОстаток;
		Иначе
			КоличествоОстаток  = 0;
			МинимальныйОстаток = 0;
			СуммаОстаток       = 0;
			СуммаУпрОстаток    = 0;
		КонецЕсли;
		
		ЗначениеКорректировки = Количество - КоличествоОстаток;
		СуммаПоДокументу      = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СтрокаТоваров.СуммаВсего, ДокументОбъект.ВалютаДокумента, ДокументОбъект.КурсДокумента, ВалютаДоговора, ДокументОбъект.Дата);
		
		Если ЗначениеКорректировки = 0 И (СуммаПоДокументу - СуммаОстаток) = 0 Тогда
			Продолжить;
		ИначеЕсли МинимальныйОстаток > Количество Тогда
			// Попытка снятия с заказа большего количества, чем заказано.
			НаименованиеЕдиницы = СокрЛП(СтрокаТоваров.Номенклатура.ОсновнаяЕдиницаИзмерения);
			ЗначениеКолонкиКода = УправлениеПечатьюПлатформа.ПолучитьЗначениеКолонкиКода(СтрокаТоваров.Номенклатура);
			Если НЕ ЗначениеЗаполнено(СтрокаТоваров.ХарактеристикаНоменклатуры) Тогда
				ТекстСообщения = "" + СокрЛП(ЗаказПоставщику) + ": ["+ЗначениеКолонкиКода + "] " + "Товар" + " """
					+ СокрЛП(СтрокаТоваров.Номенклатура) + """. " + НСтр("ru = 'Снимается с заказа'") + " "
					+ Формат(-ЗначениеКорректировки,"ЧДЦ=3; ЧН=0,00") + " " + НаименованиеЕдиницы + ". " + "Заказано" + " "
					+ Формат(КоличествоОстаток,"ЧДЦ=3; ЧН=0,00") + " " + НаименованиеЕдиницы + ". " 
					+ НСтр("ru = 'Запрещено корректировать'") + " " + Формат(МинимальныйОстаток, "ЧДЦ=3; ЧН=0,00") + " "
					+ НаименованиеЕдиницы+". " + "Превышение" + " " + Формат(МинимальныйОстаток-Количество,"ЧДЦ=3; ЧН=0,00") + " "
					+ НаименованиеЕдиницы;
					
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(НСтр("ru = '%1'"), ТекстСообщения),
					ДокументОбъект,
					,,
					Истина
				);
			Иначе
				ТекстСообщения = "" + СокрЛП(ЗаказПоставщику) + ": ["+ЗначениеКолонкиКода + "] " + "Товар" + " """
					+ СокрЛП(СтрокаТоваров.Номенклатура) + """ " + НСтр("ru = 'с характеристикой'") + " """
					+ СокрЛП(СтрокаТоваров.ХарактеристикаНоменклатуры) + """. " + НСтр("ru = 'Снимается с заказа'") + " "
					+ Формат(-ЗначениеКорректировки,"ЧДЦ=3; ЧН=0,00") + " " + НаименованиеЕдиницы + ". " + "Заказано" + " "
					+ Формат(КоличествоОстаток,"ЧДЦ=3; ЧН=0,00") + " " + НаименованиеЕдиницы + ". " + НСтр("ru = 'Запрещено корректировать'") + " "
					+ Формат(МинимальныйОстаток, "ЧДЦ=3; ЧН=0,00") + " " + НаименованиеЕдиницы + ". " + "Превышение" + " "
					+ Формат(МинимальныйОстаток - Количество,"ЧДЦ=3; ЧН=0,00") + " " + НаименованиеЕдиницы;
					
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(НСтр("ru = '%1'"), ТекстСообщения),
					ДокументОбъект,
					,,
					Истина
				);

			КонецЕсли;
			ВсеОК=Ложь;
		КонецЕсли;
		
		Если ВсеОК Тогда
			// Создаем запись регистра заказов покупателей
			НоваяЗапись = Добавить();
			НоваяЗапись.ВидДвижения                = ВидДвиженияНакопления.Приход;
			НоваяЗапись.Период                     = ДокументОбъект.Дата;
			НоваяЗапись.Регистратор                = ДокументОбъект.Ссылка;
			НоваяЗапись.Контрагент                 = ВремКонтрагент;
			НоваяЗапись.ЗаказПоставщику            = ЗаказПоставщику;
			НоваяЗапись.Номенклатура               = СтрокаТоваров.Номенклатура;
			НоваяЗапись.ХарактеристикаНоменклатуры = СтрокаТоваров.ХарактеристикаНоменклатуры;
			// Определяемся с хоз. операцией
			НоваяЗапись.ХозОперация                = ДокументОбъект.ХозОперация;
			// Количество
			НоваяЗапись.Заказано                   = ЗначениеКорректировки;
			
			Если Количество = 0 Тогда
				НоваяЗапись.Сумма                  = -СуммаОстаток;
				НоваяЗапись.СуммаУпр               = -СуммаУпрОстаток;
			Иначе
				СуммаУпрСуммаПоДокументу           = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СтрокаТоваров.СуммаВсего, ДокументОбъект.ВалютаДокумента, ДокументОбъект.КурсДокумента, ВалютаУпр,?(НЕ ЗначениеЗаполнено(ДокументОбъект.КурсВалютыУпр), ДокументОбъект.Дата, ДокументОбъект.КурсВалютыУпр));
				НоваяЗапись.Сумма                  = СуммаПоДокументу - СуммаОстаток;
				НоваяЗапись.СуммаУпр               = СуммаУпрСуммаПоДокументу - СуммаУпрОстаток;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	// Убиваем циклическую ссылку
	ДокументОбъект = Неопределено;
	
	Возврат ВсеОК;
КонецФункции

// Формирует движения по регистру приход (корректируем заказ поставщика)
// Возвращаемое значение: Булево. Истина - все ОК, Ложь - чего-то не так.
Функция КорректировкаСписаниемЗаказаПоставщика() Экспорт
	
	ВсеОК = Истина;
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчетаКомпании.Получить();
	
	// Получим таблицу товарного состава
	Если (РезультатЗапросаПоТоварам=Неопределено) ИЛИ (ТипЗнч(РезультатЗапросаПоТоварам)<>Тип("РезультатЗапроса")) И (ТипЗнч(РезультатЗапросаПоТоварам)<>Тип("ТаблицаЗначений")) Тогда
		РезультатЗапросаПоТоварам=ПолучитьТаблицуТоваров();
	КонецЕсли;
	
	Если ТипЗнч(РезультатЗапросаПоТоварам)=Тип("РезультатЗапроса") Тогда
		РезультатЗапросаПоТоварам=РезультатЗапросаПоТоварам.Выгрузить();
	КонецЕсли;
	
	ЗаказПоставщикаВТаблице = (ЗаказПоставщику = Неопределено);
	
	// Получение остатков по заказу поставщику
	Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаказыПоставщикамОстатки.ЗаказПоставщику КАК ЗаказПоставщику,
		|	ЗаказыПоставщикамОстатки.ЗаказПоставщику.Контрагент КАК Контрагент,
		|	ЗаказыПоставщикамОстатки.Номенклатура КАК Номенклатура,
		|	ЗаказыПоставщикамОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	ЕСТЬNULL(ЗаказыПоставщикамОстатки.ЗаказаноОстаток, 0) КАК Количество,
		|	ЕСТЬNULL(ЗаказыПоставщикамОстатки.СуммаОстаток,0) КАК СуммаОстаток,
		|	ЕСТЬNULL(ЗаказыПоставщикамОстатки.СуммаУпрОстаток,0) КАК СуммаУпрОстаток
		|ИЗ
		|	РегистрНакопления.ЗаказыПоставщикам.Остатки(&Момент,
		|			ЗаказПоставщику В (&ЗаказПоставщику)
		|			И Номенклатура В (&Номенклатура)
		|			И ХарактеристикаНоменклатуры В (&ХарактеристикаНоменклатуры)) КАК ЗаказыПоставщикамОстатки
		|");
	Запрос.УстановитьПараметр("Момент",                     ?(РежимПроведения = РежимПроведенияДокумента.Оперативный, Неопределено, ДокументОбъект.МоментВремени()));
	Запрос.УстановитьПараметр("ЗаказПоставщику",            РезультатЗапросаПоТоварам.ВыгрузитьКолонку("ЗаказПоставщику"));
	Запрос.УстановитьПараметр("Номенклатура",               РезультатЗапросаПоТоварам.ВыгрузитьКолонку("Номенклатура"));
	Запрос.УстановитьПараметр("ХарактеристикаНоменклатуры", РезультатЗапросаПоТоварам.ВыгрузитьКолонку("ХарактеристикаНоменклатуры"));
	
	// Наложим блокировку на считываемые данные
	СтруктураПараметровБлокировки = Новый Структура("ТипТаблицы, ИмяТаблицы", "РегистрНакопления", "ЗаказыПоставщикам");
	
	ЗначенияБлокировки = Новый Соответствие;
	ЗначенияБлокировки.Вставить("Период", Новый Диапазон(, ДокументОбъект.Дата));
	
	ОписаниеИсточника  = Новый Соответствие;
	ОписаниеИсточника.Вставить("ЗаказПоставщику", "ЗаказПоставщику");
	ОписаниеИсточника.Вставить("Номенклатура", "Номенклатура");
	ОписаниеИсточника.Вставить("ХарактеристикаНоменклатуры", "ХарактеристикаНоменклатуры");
	
	СтруктураПараметровБлокировки.Вставить("ИсточникДанных", РезультатЗапросаПоТоварам);
	ОбработкаСобытийДокументаСервер.УстановитьУправляемуюБлокировку(СтруктураПараметровБлокировки, ЗначенияБлокировки, ОписаниеИсточника);
	
	ВыборкаОстатковТоваров = Запрос.Выполнить().Выбрать();
	СтруктураОтбораОстатковТоваров = Новый Структура("Номенклатура, ХарактеристикаНоменклатуры, ЗаказПоставщику");
	
	ИмяКолонкиКода = УправлениеПечатьюПлатформа.ПолучитьПараметрыРежимаВыводаКодаВДокументах().Имя;
	// Спишем заказанный товар с регистра заказов покупателей
	Для Каждого СтрокаТоваров Из РезультатЗапросаПоТоварам Цикл
		
		Количество = СтрокаТоваров.Количество;
		ВыборкаОстатковТоваров.Сбросить();
		СтруктураОтбораОстатковТоваров.Номенклатура               = СтрокаТоваров.Номенклатура;
		СтруктураОтбораОстатковТоваров.ХарактеристикаНоменклатуры = СтрокаТоваров.ХарактеристикаНоменклатуры;
		СтруктураОтбораОстатковТоваров.ЗаказПоставщику        = СтрокаТоваров.ЗаказПоставщику;
		
		Если ВыборкаОстатковТоваров.НайтиСледующий(СтруктураОтбораОстатковТоваров) Тогда
			КоличествоОстаток = ВыборкаОстатковТоваров.Количество;
			СуммаОстаток      = ВыборкаОстатковТоваров.СуммаОстаток;
			СуммаУпрОстаток   = ВыборкаОстатковТоваров.СуммаУпрОстаток;
			ВремКонтрагент    = ВыборкаОстатковТоваров.Контрагент;
		Иначе
			КоличествоОстаток = 0;
			СуммаОстаток      = 0;
			СуммаУпрОстаток   = 0;
			ВремКонтрагент    = СтрокаТоваров.ЗаказПоставщику.Контрагент;
		КонецЕсли;
		
		Если Количество > КоличествоОстаток Тогда
			// Попытка снятия с заказа большего количества, чем заказано
			НаименованиеЕдиницы = СокрЛП(СтрокаТоваров.Номенклатура.ОсновнаяЕдиницаИзмерения);
			ЗначениеКолонкиКода = УправлениеПечатьюПлатформа.ПолучитьЗначениеКолонкиКода(СтрокаТоваров.Номенклатура);
			Если НЕ ЗначениеЗаполнено(СтрокаТоваров.ХарактеристикаНоменклатуры) Тогда
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(
						НСтр("ru = '%1: [%2] Товар ""%3"". Снимается с заказа %4 %5. Заказано %6 %7. Превышение %8 %9'"),
						СокрЛП(СтрокаТоваров.ЗаказПоставщику),
						ЗначениеКолонкиКода,
						СокрЛП(СтрокаТоваров.Номенклатура), 
						Формат(Количество,"ЧДЦ=3; ЧН=0,00"),
						НаименованиеЕдиницы,
						Формат(КоличествоОстаток,"ЧДЦ=3; ЧН=0,00"),
						НаименованиеЕдиницы, 
						Формат(Количество - КоличествоОстаток,"ЧДЦ=3; ЧН=0,00"),
						НаименованиеЕдиницы
						),
						ДокументОбъект,,, Истина
					);
			Иначе
				
				ТекстСообщения = ""+СокрЛП(СтрокаТоваров.ЗаказПоставщику)+": ["+ЗначениеКолонкиКода+"] " + "Товар" + " """
					+ СокрЛП(СтрокаТоваров.Номенклатура)+""" " + НСтр("ru = 'с характеристикой'") + " """
					+ СокрЛП(СтрокаТоваров.ХарактеристикаНоменклатуры)+""". " + НСтр("ru = 'Снимается с заказа'") + " "
					+ Формат(Количество,"ЧДЦ=3; ЧН=0,00")+" "+НаименованиеЕдиницы+". " + "Заказано" + " "
					+ Формат(КоличествоОстаток,"ЧДЦ=3; ЧН=0,00")+" "+НаименованиеЕдиницы+". " + "Превышение" + " "
					+ Формат(Количество-КоличествоОстаток,"ЧДЦ=3; ЧН=0,00")+" "+НаименованиеЕдиницы;
					
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(НСтр("ru = '%1'"), ТекстСообщения),
					ДокументОбъект,
					,,
					Истина
				);

			КонецЕсли;
			ВсеОК=Ложь;
		КонецЕсли;
		
		Если ВсеОК И Количество<>0 Тогда
			// Создаем запись регистра заказов покупателей
			НоваяЗапись = Добавить();
			НоваяЗапись.ВидДвижения                = ВидДвиженияНакопления.Приход;
			НоваяЗапись.Период                     = ДокументОбъект.Дата;
			НоваяЗапись.Регистратор                = ДокументОбъект.Ссылка;
			НоваяЗапись.Контрагент                 = ВремКонтрагент;
			НоваяЗапись.ЗаказПоставщику            = СтрокаТоваров.ЗаказПоставщику;
			НоваяЗапись.Номенклатура               = СтрокаТоваров.Номенклатура;
			НоваяЗапись.ХарактеристикаНоменклатуры = СтрокаТоваров.ХарактеристикаНоменклатуры;
			// Определяемся с хоз. операцией
			НоваяЗапись.ХозОперация                = ДокументОбъект.ХозОперация;
			// Количество
			НоваяЗапись.Заказано                   = -Количество;
			
			Если Количество = КоличествоОстаток Тогда
				НоваяЗапись.Сумма                  = -СуммаОстаток;
				НоваяЗапись.СуммаУпр               = -СуммаУпрОстаток;
			Иначе
				НоваяЗапись.Сумма                  = -Окр(СуммаОстаток/Количество, 2);
				НоваяЗапись.СуммаУпр               = -Окр(СуммаУпрОстаток/Количество, 2);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	// Убиваем циклическую ссылку
	ДокументОбъект = Неопределено;
	
	Возврат ВсеОК;
КонецФункции

// Формирует движения по регистру расход (снимаем заказ поставщика)
// Возвращаемое значение: Булево. Истина - все ОК, Ложь - чего-то не так.
Функция ЗакрытиеЗаказовПоставщику() Экспорт
	ВсеОК=Истина;
	
	// Получим таблицу товарного состава
	Если (РезультатЗапросаПоТоварам=Неопределено) ИЛИ (ТипЗнч(РезультатЗапросаПоТоварам)<>Тип("РезультатЗапроса")) И (ТипЗнч(РезультатЗапросаПоТоварам)<>Тип("ТаблицаЗначений")) Тогда
		РезультатЗапросаПоТоварам=ПолучитьТаблицуТоваров();
	КонецЕсли;
	Если ТипЗнч(РезультатЗапросаПоТоварам)=Тип("РезультатЗапроса") Тогда
		РезультатЗапросаПоТоварам=РезультатЗапросаПоТоварам.Выгрузить();
	КонецЕсли;
	
	Если РезультатЗапросаПоЗаказам=Неопределено Тогда
		// Получим не закрытые заказы поставщикам, нашего контрагента
		Запрос=Новый Запрос("
		|ВЫБРАТЬ * ИЗ(
		|ВЫБРАТЬ
		|	ЗаказыПоставщикамОстатки.Контрагент КАК Контрагент,
		|	ВЫБОР КОГДА ЗаказыПоставщикамОстатки.ЗаказПоставщику=&ЗаказОснование ТОГДА 0 ИНАЧЕ 1 КОНЕЦ КАК ЗаказОснование,
		|	ЗаказыПоставщикамОстатки.ЗаказПоставщику КАК ЗаказПоставщику,
		|	ЗаказыПоставщикамОстатки.Номенклатура КАК Номенклатура,
		|	ЗаказыПоставщикамОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	ЗаказыПоставщикамОстатки.СуммаОстаток КАК Сумма,
		|	ЗаказыПоставщикамОстатки.СуммаУпрОстаток КАК СуммаУпр,
		|	ЗаказыПоставщикамОстатки.ЗаказаноОстаток КАК Заказано
		|ИЗ
		|	РегистрНакопления.ЗаказыПоставщикам.Остатки(&Момент,
		|		Номенклатура В (&Номенклатура)
		|		И (ХарактеристикаНоменклатуры В (&ХарактеристикаНоменклатуры) ИЛИ ХарактеристикаНоменклатуры=&ПустаяХарактеристика)
		|   	"+?(Контрагент=Неопределено,"","И Контрагент=&Контрагент")+"
		|		"+?(ЗаказПоставщику=Неопределено,"","И ЗаказПоставщику=&ЗаказПоставщику")+"
		|	) КАК ЗаказыПоставщикамОстатки
		|) КАК ЗаказыПоставщикамОстатки
		|УПОРЯДОЧИТЬ ПО
		|	ЗаказыПоставщикамОстатки.ЗаказОснование ВОЗР,
		|	ЗаказыПоставщикамОстатки.ЗаказПоставщику.Дата,
		|	ЗаказыПоставщикамОстатки.Номенклатура,
		|	ЗаказыПоставщикамОстатки.ХарактеристикаНоменклатуры.Сортировка ВОЗР
		|");
		Запрос.УстановитьПараметр("Момент",?(РежимПроведения=РежимПроведенияДокумента.Оперативный,Неопределено,ДокументОбъект.МоментВремени()));
		Запрос.УстановитьПараметр("Контрагент",Контрагент);
		Запрос.УстановитьПараметр("ЗаказПоставщику",ЗаказПоставщику);
		Запрос.УстановитьПараметр("ЗаказОснование",ЗаказОснование);
		Запрос.УстановитьПараметр("Номенклатура",РезультатЗапросаПоТоварам.ВыгрузитьКолонку("Номенклатура"));
		Запрос.УстановитьПараметр("ХарактеристикаНоменклатуры",РезультатЗапросаПоТоварам.ВыгрузитьКолонку("ХарактеристикаНоменклатуры"));
		Запрос.УстановитьПараметр("ПустаяХарактеристика",Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
		
		// Наложим блокировку на считываемые данные
		СтруктураПараметровБлокировки = Новый Структура("ТипТаблицы, ИмяТаблицы", "РегистрНакопления", "ЗаказыПоставщикам");
		ЗначенияБлокировки = Новый Соответствие;
		ЗначенияБлокировки.Вставить("Период", Новый Диапазон(, ДокументОбъект.Дата));
		Если Контрагент <> Неопределено Тогда
			ЗначенияБлокировки.Вставить("Контрагент", Контрагент);
		КонецЕсли;
		Если ЗаказПоставщику <> Неопределено Тогда
			ЗначенияБлокировки.Вставить("ЗаказПоставщику", ЗаказПоставщику);
		КонецЕсли;
		СтруктураПараметровБлокировки.Вставить("ИсточникДанных", РезультатЗапросаПоТоварам);
		ОписаниеИсточника = Новый Соответствие;
		ОписаниеИсточника.Вставить("Номенклатура", "Номенклатура");
		ОписаниеИсточника.Вставить("ХарактеристикаНоменклатуры", "ХарактеристикаНоменклатуры");
		ОбработкаСобытийДокументаСервер.УстановитьУправляемуюБлокировку(СтруктураПараметровБлокировки, ЗначенияБлокировки, ОписаниеИсточника);
		
		РезультатЗапросаПоЗаказам = Запрос.Выполнить();
		РезультатЗапросаПоЗаказам = РезультатЗапросаПоЗаказам.Выгрузить();
	КонецЕсли; 
	
	ПустаяХарактеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
		// Получим таблицу номенклатуры с ручным списанием характеристик
	ЗапросСписокРучныхХарактеристик = Новый Запрос;
	ЗапросСписокРучныхХарактеристик.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Номенклатура
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка В(&СписокНоменклатуры)
	|	И Номенклатура.ТипНоменклатуры.АвтоСписаниеХарактеристик В 
	|		(ЗНАЧЕНИЕ(Перечисление.РежимыАвтоСписанияХарактеристик.РучноеСписание),
	|		ЗНАЧЕНИЕ(Перечисление.РежимыАвтоСписанияХарактеристик.ПустаяСсылка))
	|
	|СГРУППИРОВАТЬ ПО
	|	Номенклатура.Ссылка";
	ЗапросСписокРучныхХарактеристик.УстановитьПараметр("СписокНоменклатуры", РезультатЗапросаПоЗаказам.ВыгрузитьКолонку("Номенклатура"));
	СписокРучныхХарактеристик = ЗапросСписокРучныхХарактеристик.Выполнить().Выгрузить();
	
	Для Каждого СтрокаПоЗаказам Из РезультатЗапросаПоЗаказам Цикл
		РучноеСписание = НЕ СписокРучныхХарактеристик.Найти(СтрокаПоЗаказам.Номенклатура)=Неопределено;
		
		НадоЗакрыть = СтрокаПоЗаказам.Заказано;
		Сумма       = СтрокаПоЗаказам.Сумма;
		СуммаУпр    = СтрокаПоЗаказам.СуммаУпр;
		СтруктураОтбора = Новый Структура("Номенклатура");
		СтруктураОтбора.Номенклатура=СтрокаПоЗаказам.Номенклатура;
		Если РучноеСписание Тогда
			СтруктураОтбора.Вставить("ХарактеристикаНоменклатуры", СтрокаПоЗаказам.ХарактеристикаНоменклатуры);
		КонецЕсли;
		ВыборкаТовары = РезультатЗапросаПоТоварам.НайтиСтроки(СтруктураОтбора);
		Для Каждого Товар Из ВыборкаТовары Цикл
			// Если все закрыли, то выходим
			Если НадоЗакрыть=0 Тогда
				Прервать;
			КонецЕсли;
			// Если товара 0 продолжаем
			Если Товар.Количество=0 Тогда
				Продолжить;
			КонецЕсли;
			// Закрываем заказ
			НоваяЗапись=Добавить();
			НоваяЗапись.ВидДвижения     = ВидДвиженияНакопления.Расход;
			НоваяЗапись.Период          = ДокументОбъект.Дата;
			НоваяЗапись.Регистратор     = ДокументОбъект.Ссылка;
			НоваяЗапись.Контрагент      = Контрагент;
			НоваяЗапись.ЗаказПоставщику = СтрокаПоЗаказам.ЗаказПоставщику;
			НоваяЗапись.Номенклатура    = Товар.Номенклатура;
			Если РучноеСписание Тогда
				НоваяЗапись.ХарактеристикаНоменклатуры = Товар.ХарактеристикаНоменклатуры;
			КонецЕсли;
			НоваяЗапись.ХозОперация     = ДокументОбъект.ХозОперация;
			// Количество
			Если НадоЗакрыть > Товар.Количество Тогда
				НоваяЗапись.Заказано    = Товар.Количество;
				// Суммы
				НоваяЗапись.Сумма       = Окр(Сумма/НадоЗакрыть*Товар.Количество, 2);
				НоваяЗапись.СуммаУпр    = Окр(СуммаУпр/НадоЗакрыть*Товар.Количество, 2);
				РезультатЗапросаПоТоварам.Удалить(Товар);
			Иначе
				НоваяЗапись.Заказано    = НадоЗакрыть;
				// Суммы
				НоваяЗапись.Сумма       = Сумма;
				НоваяЗапись.СуммаУпр    = СуммаУпр;
				Товар.Количество = Товар.Количество-НоваяЗапись.Заказано;
			КонецЕсли;
			НадоЗакрыть = НадоЗакрыть - НоваяЗапись.Заказано;
			Сумма       = Сумма       - НоваяЗапись.Сумма;
			СуммаУпр    = СуммаУпр    - НоваяЗапись.СуммаУпр;
		КонецЦикла;
	КонецЦикла;
	
	РезультатЗапросаПоТоварам=Неопределено;
	РезультатЗапросаПоЗаказам=Неопределено;
	// Убиваем циклическую ссылку
	ДокументОбъект=Неопределено;
	
	Возврат ВсеОк;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает результат запроса по таблице товаров
Функция ПолучитьТаблицуТоваров()
	// получим результат запроса по товарной таблице
    ВидДок=ДокументОбъект.Метаданные().Имя;
	ПоБазовомуКоличеству=?(ПоБазовомуКоличеству=Неопределено,Ложь,ПоБазовомуКоличеству);
	Запрос=Новый Запрос();
	ТекстЗапроса="
	|ВЫБРАТЬ
	|	ДокументТовары.Номенклатура КАК Номенклатура,
	|	ДокументТовары.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ДокументТовары.Количество"+?(ПоБазовомуКоличеству,"Базовое","*ДокументТовары.Коэффициент")+" КАК Количество,
	|	ДокументТовары.СуммаВсего КАК СуммаВсего
	|ИЗ
	|	Документ."+ВидДок+".Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка=&Ссылка
	|";
	Запрос.Текст=ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка",ДокументОбъект.Ссылка);
	Запрос.УстановитьПараметр("ЗаказПоставщику",ЗаказПоставщику);
	Запрос.УстановитьПараметр("Контрагент",Контрагент);
	Возврат Запрос.Выполнить();
КонецФункции

#КонецОбласти

#Область Инициализация

////////////////////////////////////////////////////////////////////////
// Инициализация переменных модуля набора записей
РежимПроведения=РежимПроведенияДокумента.Оперативный;

ДокументОбъект=Неопределено; // Обязательный к заполнению перед началом проведения
РезультатЗапросаПоТоварам=Неопределено;
РезультатЗапросаПоЗаказам=Неопределено;
ЗаказПоставщику=Неопределено;
Контрагент=Неопределено;
ПоБазовомуКоличеству=Ложь;

#КонецОбласти

#КонецЕсли