﻿// Модуль набора записей регистра "Прочие активы в эксплуатации"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ДокументОбъект Экспорт;             // Документ, осуществляющий движение по регистру
// параметры отбора движений
Перем ПодразделениеКомпании Экспорт;      // Подразделение компании, с которым работаем в отборе
Перем ПодразделениеКомпанииПолучатель Экспорт; // Подразделение компании, получатель прочих активов при перемещении
Перем МОЛ Экспорт;                        // МОЛ, с котором работаем в отборе
Перем МОЛПолучатель Экспорт;			  // МОЛ, получатель при перемещении
Перем ТипОбслуживания Экспорт;            // Реквизит регистра, нужный только для обслуживания
Перем ЭтоПервыйВвод Экспорт;              // Флаг первого ввода актива в эксплуатацию
Перем ЭтоВыбытие Экспорт;				  // Флаг выбытия актива из эксплуатации
Перем ЭтоАмортизация Экспорт;			  // Флаг амортизации актива
Перем ДатаДвижений Экспорт;				  // Если неопределена, то берется дата документа
//
Перем РезультатЗапросаПоАктивам Экспорт;  // Выборка табличной части или таблица значений табличной части активов
Перем СуммаАмортизацииУпр100 Экспорт;     // Содержит сумму расходов на 100 процентное начисление амортизации. при вводе
Перем РежимПроведения Экспорт;		// Режим проведения документа оперативный/неоперативный

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Формирует движения по регистру приход (ввод в эксплуатацию)
// Возвращаемое значение: Булево. Истина - все ОК, Ложь - чего-то не так.
Функция Приход() Экспорт
	ВсеОК = Истина;
	СуммаАмортизацииУпр100 = 0;
	
	ДатаДвижений = ?(ДатаДвижений = Неопределено, ДокументОбъект.Дата, ДатаДвижений); 
	
	Если ТипЗнч(РезультатЗапросаПоАктивам) = Тип("РезультатЗапроса") Тогда
		РезультатЗапросаПоАктивам = РезультатЗапросаПоАктивам.Выгрузить();
	КонецЕсли;
	
	// валюты и курсы
	ВалютаРегл = Константы.ВалютаРегламентированногоУчетаОрганизаций.Получить();
	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРегл, ДокументОбъект.Дата);
	КурсРегл   = СтруктураКурса.Курс / ?(СтруктураКурса.Кратность = 0, 1, СтруктураКурса.Кратность);
	ВалютаУпр  = Константы.ВалютаУправленческогоУчетаКомпании.Получить();
	Если НЕ ЗначениеЗаполнено(ДокументОбъект.КурсВалютыУпр) Тогда
		СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаУпр, ДокументОбъект.Дата);
		КурсУпр    = СтруктураКурса.Курс / ?(СтруктураКурса.Кратность = 0, 1, СтруктураКурса.Кратность);
	Иначе
		КурсУпр    = ДокументОбъект.КурсВалютыУпр;
	КонецЕсли;	
	
	// Получим выборку активов, по которым были какие либо движения.
	ВыборкаДвиженийАктивов = ПолучитьНаличиеДвиженийПоАктивам(РезультатЗапросаПоАктивам.ВыгрузитьКолонку("Актив"), Новый Граница(ДокументОбъект.Дата, ВидГраницы.Исключая));
	
	Для каждого ТекАктив Из РезультатЗапросаПоАктивам Цикл
		// проверка на повторяющийся ввод актива для всех, кроме Спецодежды и спецоснастки
		Если НЕ (ТекАктив.Актив.ВидПрочегоАктива = Перечисления.ВидыПрочихАктивов.Спецодежда
				ИЛИ ТекАктив.Актив.ВидПрочегоАктива = Перечисления.ВидыПрочихАктивов.Спецоснастка
				ИЛИ ТекАктив.Актив.ВидПрочегоАктива = Перечисления.ВидыПрочихАктивов.Инструменты
				ИЛИ ТекАктив.Актив.ВидПрочегоАктива = Перечисления.ВидыПрочихАктивов.МалоценноеОборудованиеИЗапасы) Тогда
			ВыборкаДвиженийАктивов.Сбросить();
			Если ЭтоПервыйВвод И ВыборкаДвиженийАктивов.НайтиСледующий(Новый Структура("ПрочийАктив", ТекАктив.Актив)) Тогда
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(НСтр("ru = 'Прочий актив ""%1"" уже был в эксплуатации'"), СокрЛП(ТекАктив.Актив)),
					ДокументОбъект
				);
				ВсеОК = Ложь;
			КонецЕсли;
		КонецЕсли;
		Если ЭтоПервыйВвод
			И (НЕ ТекАктив.Актив.ВидПрочегоАктива = Перечисления.ВидыПрочихАктивов.Оборудование)
			И (НЕ ТекАктив.Актив.ВидПрочегоАктива = Перечисления.ВидыПрочихАктивов.ОсновноеСредство)
			И ТекАктив.ТипЭксплуатации.СпособНачисленияАмортизации = Перечисления.СпособыНачисленияАмортизации.ПоОбъемуВыработки Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Прочий актив ""%1"". Способ начисления амортизации <По объему выработки> не соответствует виду актива <%2>'"),
					СокрЛП(ТекАктив.Актив),
					ТекАктив.Актив.ВидПрочегоАктива
				),
				ДокументОбъект,
				ТекАктив.Актив
			);
			ВсеОК = Ложь;
		КонецЕсли;	
		// проверка на корректность соответствия актива и способа начисления амортизации
		Если ТекАктив.ТипЭксплуатации.СпособНачисленияАмортизации = Перечисления.СпособыНачисленияАмортизации.ПоСуммеЧиселЛет И Цел(ТекАктив.Актив.СрокПолезногоИспользования / 12) <> ТекАктив.Актив.СрокПолезногоИспользования / 12 Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Прочий актив ""%1"". Имеет неверный срок полезного использования (нецелое число лет)'"),
					СокрЛП(ТекАктив.Актив)
				),
				ДокументОбъект,
				ТекАктив.Актив
			);
			ВсеОК = Ложь;
		КонецЕсли;
		// проверка на уже начисленные амортизации в этом месяце для актива
		Если ЭтоАмортизация И ПроверитьНачислениеАмортизации(ТекАктив.Актив) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'Прочий актив ""%1"". Амортизацию в этом месяце начислять не требуется'"), СокрЛП(ТекАктив.Актив)),
				ДокументОбъект, 
				ТекАктив.Актив
			);
			ВсеОК = Ложь;
		КонецЕсли;
		
		// Каждый раз берем МОЛа из РезультатаЗапросаПоТаблицам
		МОЛ = ТекАктив.МОЛ;
		
		// движения регистра
		Если ВсеОК Тогда
			НоваяЗапись = Добавить();
			НоваяЗапись.ВидДвижения           = ВидДвиженияНакопления.Приход;
			НоваяЗапись.Период                = ДатаДвижений;
			НоваяЗапись.Регистратор           = ДокументОбъект.Ссылка;
			
			// измерения
			НоваяЗапись.ПодразделениеКомпании = ПодразделениеКомпании;
			НоваяЗапись.МОЛ                   = МОЛ;
			НоваяЗапись.ПрочийАктив           = ТекАктив.Актив;
			НоваяЗапись.ТипЭксплуатации       = ТекАктив.ТипЭксплуатации;
			
			Попытка
				Если ТекАктив.Актив.ТипНоменклатуры = Справочники.ТипыНоменклатуры.Автомобили Тогда
					НоваяЗапись.Автомобиль       = ТекАктив.Автомобиль;
				КонецЕсли;
			Исключение  
				ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Проведение. Нет реквизита ""Автомобиль""'"),
				УровеньЖурналаРегистрации.Ошибка,,
				ТекАктив.Актив.ТипНоменклатуры, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			
			// ресурсы
			СуммаАмортизации_ = ?(ТекАктив.ТипЭксплуатации.СпособНачисленияАмортизации = Перечисления.СпособыНачисленияАмортизации.СтопроцентныйПриВводе И ЭтоПервыйВвод, 0, ТекАктив.Амортизация);
			
			НоваяЗапись.БалансоваяСтоимость    = Окр(РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(ТекАктив.БалансоваяСтоимость, ДокументОбъект.ВалютаДокумента, ДокументОбъект.КурсДокумента, ВалютаРегл, КурсРегл), 2);
			НоваяЗапись.БалансоваяСтоимостьУпр = Окр(РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(ТекАктив.БалансоваяСтоимость, ДокументОбъект.ВалютаДокумента, ДокументОбъект.КурсДокумента, ВалютаУпр, КурсУпр), 2);
			НоваяЗапись.СуммаАмортизации      = Окр(РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СуммаАмортизации_, ДокументОбъект.ВалютаДокумента, ДокументОбъект.КурсДокумента, ВалютаРегл, КурсРегл), 2);
			НоваяЗапись.СуммаАмортизацииУпр   = Окр(РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СуммаАмортизации_, ДокументОбъект.ВалютаДокумента, ДокументОбъект.КурсДокумента, ВалютаУпр, КурсУпр), 2);
			НоваяЗапись.СуммаОбслуживания     = Окр(РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(ТекАктив.СуммаОбслуживания, ДокументОбъект.ВалютаДокумента, ДокументОбъект.КурсДокумента, ВалютаРегл, КурсРегл), 2);
			НоваяЗапись.СуммаОбслуживанияУпр  = Окр(РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(ТекАктив.СуммаОбслуживания, ДокументОбъект.ВалютаДокумента, ДокументОбъект.КурсДокумента, ВалютаУпр, КурсУпр), 2);
			// Если движение делает документ Амортизация или Обслуживание Актива то в ресурс количество пишем 0.
			Если ДокументОбъект.ХозОперация = Справочники.ХозОперации.Амортизация 
				ИЛИ ДокументОбъект.ХозОперация = Справочники.ХозОперации.ОбслуживаниеАктиваНаРасходыПодразделения
				ИЛИ ДокументОбъект.ХозОперация = Справочники.ХозОперации.ОбслуживаниеАктиваНаСтоимостьАктива Тогда
				НоваяЗапись.Количество = 0;
			Иначе	
				НоваяЗапись.Количество            = Окр(ТекАктив.Количество, 3);
			КонецЕсли;
			
			// реквизиты
			НоваяЗапись.ХозОперация           = ДокументОбъект.ХозОперация;
			Если НЕ ТипОбслуживания = Неопределено Тогда 
				НоваяЗапись.ТипОбслуживания   = ТипОбслуживания;
			КонецЕсли;
		КонецЕсли;
		
		// При способе "100% при вводе" начислим амортизацию отдельным движением.
		Если ВсеОК И ЭтоПервыйВвод 
			И ТекАктив.ТипЭксплуатации.СпособНачисленияАмортизации 
				= Перечисления.СпособыНачисленияАмортизации.СтопроцентныйПриВводе Тогда
			
			НоваяЗапись = Добавить();
			НоваяЗапись.ВидДвижения           = ВидДвиженияНакопления.Приход;
			НоваяЗапись.Период                = ДатаДвижений;
			НоваяЗапись.Регистратор           = ДокументОбъект.Ссылка;
			
			// измерения
			НоваяЗапись.ПодразделениеКомпании = ПодразделениеКомпании;
			НоваяЗапись.МОЛ                   = МОЛ;
			НоваяЗапись.ПрочийАктив           = ТекАктив.Актив;
			НоваяЗапись.ТипЭксплуатации       = ТекАктив.ТипЭксплуатации;
			
			// аренда автомобилей - исправил ошибку
			Попытка
				Если ТекАктив.Актив.ТипНоменклатуры = Справочники.ТипыНоменклатуры.Автомобили Тогда
					НоваяЗапись.Автомобиль       = ТекАктив.Автомобиль;
				КонецЕсли;
			Исключение 
				ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Проведение. Не заполнен реквизит ""Автомобиль""'"),
				УровеньЖурналаРегистрации.Ошибка,,
				ТекАктив.Актив, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			
			// ресурсы
			НоваяЗапись.БалансоваяСтоимость    = 0;
			НоваяЗапись.БалансоваяСтоимостьУпр = 0;
			НоваяЗапись.СуммаАмортизации = Окр(РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(ТекАктив.БалансоваяСтоимость, ДокументОбъект.ВалютаДокумента, ДокументОбъект.КурсДокумента, ВалютаРегл, КурсРегл), 2);
			НоваяЗапись.СуммаАмортизацииУпр = Окр(РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(ТекАктив.БалансоваяСтоимость, ДокументОбъект.ВалютаДокумента, ДокументОбъект.КурсДокумента, ВалютаУпр, КурсУпр), 2);
			НоваяЗапись.СуммаОбслуживания     = 0;
			НоваяЗапись.СуммаОбслуживанияУпр  = 0;
			НоваяЗапись.Количество			  = 0;
			
			// реквизиты
			НоваяЗапись.ХозОперация           = Справочники.ХозОперации.Амортизация;
			
			СуммаАмортизацииУпр100 = СуммаАмортизацииУпр100 + НоваяЗапись.СуммаАмортизацииУпр;
		КонецЕсли;
		
		// реквизиты справочника
		Если ЭтоПервыйВвод И ВсеОК Тогда
			Актив_ = ТекАктив.Актив.ПолучитьОбъект();
			Актив_.ПервоначальнаяСтоимость = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(
					ТекАктив.БалансоваяСтоимость, ДокументОбъект.ВалютаДокумента, ДокументОбъект.Дата, 
					Константы.ВалютаУправленческогоУчетаКомпании.Получить(), 
					?(НЕ ЗначениеЗаполнено(ДокументОбъект.КурсВалютыУпр), ДокументОбъект.Дата, ДокументОбъект.КурсВалютыУпр));
			
			Если ДокументОбъект.ХозОперация = Справочники.ХозОперации.ВводОстатковПрочихАктивов Тогда
				Если ЗначениеЗаполнено(ТекАктив.ДатаВводаВЭксплуатацию) Тогда
					Актив_.ДатаВводаВЭксплуатацию = ТекАктив.ДатаВводаВЭксплуатацию;
				Иначе
					Актив_.ДатаВводаВЭксплуатацию = ДокументОбъект.Дата;
				КонецЕсли;
			Иначе
				Актив_.ДатаВводаВЭксплуатацию = ДокументОбъект.Дата;
			КонецЕсли;
			Актив_.ОбменДанными.Загрузка = Истина;
			
			Попытка
				Актив_.Записать();
			Исключение
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(НСтр("ru = 'Не удалось перезаписать актив ""%1""! %2'"), СокрЛП(Актив_), ОписаниеОшибки()),
					ДокументОбъект,
					ТекАктив.Актив
				);
				ВсеОК = Ложь;
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
	// убиваем циклическую ссылку
	ДокументОбъект = Неопределено;
	ДатаДвижений   = Неопределено;
	РезультатЗапросаПоАктивам = Неопределено;
	
	// все ОК
	Возврат ВсеОК;
КонецФункции

// Формирует движения по регистру расход (списание, реализация)
// Возвращаемое значение: Булево. Истина - все ОК, Ложь - чего-то не так.
Функция Расход() Экспорт
	ВсеОК = Истина;
	
	ДатаДвижений = ?(ДатаДвижений = Неопределено, ДокументОбъект.Дата, ДатаДвижений); 
	
	Если ТипЗнч(РезультатЗапросаПоАктивам) = Тип("РезультатЗапроса") Тогда
		РезультатЗапросаПоАктивам = РезультатЗапросаПоАктивам.Выгрузить();
	КонецЕсли;
	
	ОстаткиАктивов = ПолучитьОстаткиАктивов(ПодразделениеКомпании, МОЛ, РезультатЗапросаПоАктивам, ДокументОбъект.Дата);
	Для каждого ТекАктив Из РезультатЗапросаПоАктивам Цикл
		СтрокаАктива = ОстаткиАктивов.Найти(ТекАктив.Актив, "Актив");
		Если СтрокаАктива = Неопределено Тогда // такого актива нет в эксплуатации
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Прочий актив ""%1"". Подразделение ""%2"". Не обнаружен'"),
					СокрЛП(ТекАктив.Актив),
					СокрЛП(ПодразделениеКомпании)
				),
				ДокументОбъект, 
				ТекАктив.Актив
			);
			ВсеОК = Ложь;
		ИначеЕсли СтрокаАктива.Количество < ТекАктив.Количество Тогда // не хватает такого актива по количеству в эксплуатации
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Прочий актив ""%1"". Остаток %2. Списывается %3. Превышение %4.'"),
					СокрЛП(ТекАктив.Актив),
					СтрокаАктива.Количество,
					ТекАктив.Количество, 
					(ТекАктив.Количество - СтрокаАктива.Количество)
				),
				ДокументОбъект, 
				ТекАктив.Актив
			);
			ВсеОК = Ложь;
		КонецЕсли;
		
		// движения регистра
		Если ВсеОК Тогда
			НоваяЗапись = Добавить();
			НоваяЗапись.ВидДвижения           = ВидДвиженияНакопления.Расход;
			НоваяЗапись.Период                = ДатаДвижений;
			НоваяЗапись.Регистратор           = ДокументОбъект.Ссылка;
			
			// измерения
			НоваяЗапись.ПодразделениеКомпании = СтрокаАктива.ПодразделениеКомпании;
			НоваяЗапись.МОЛ                   = ?(МОЛ = Неопределено, СтрокаАктива.МОЛ, МОЛ);
			НоваяЗапись.ПрочийАктив           = СтрокаАктива.Актив;
			НоваяЗапись.ТипЭксплуатации       = СтрокаАктива.ТипЭксплуатации;
			НоваяЗапись.Автомобиль            = СтрокаАктива.Автомобиль;
			
			// ресурсы
			НоваяЗапись.БалансоваяСтоимость    = Окр(?(ТекАктив.Количество = СтрокаАктива.Количество,
				СтрокаАктива.БалансоваяСтоимостьРегл, 
					СтрокаАктива.БалансоваяСтоимостьРегл / СтрокаАктива.Количество * ТекАктив.Количество), 2);
			НоваяЗапись.БалансоваяСтоимостьУпр = Окр(?(ТекАктив.Количество 
														= СтрокаАктива.Количество, СтрокаАктива.БалансоваяСтоимость,
				СтрокаАктива.БалансоваяСтоимость / СтрокаАктива.Количество * ТекАктив.Количество), 2); 
			НоваяЗапись.СуммаАмортизации       = Окр(?(ТекАктив.Количество = СтрокаАктива.Количество,
				СтрокаАктива.АмортизацияРегл, СтрокаАктива.АмортизацияРегл / СтрокаАктива.Количество * ТекАктив.Количество), 2);
			НоваяЗапись.СуммаАмортизацииУпр    = Окр(?(ТекАктив.Количество = СтрокаАктива.Количество,
				СтрокаАктива.Амортизация, СтрокаАктива.Амортизация / СтрокаАктива.Количество * ТекАктив.Количество), 2); 
			НоваяЗапись.СуммаОбслуживания      = Окр(?(ТекАктив.Количество = СтрокаАктива.Количество,
				СтрокаАктива.СуммаОбслуживанияРегл, 
					СтрокаАктива.СуммаОбслуживанияРегл / СтрокаАктива.Количество * ТекАктив.Количество), 2);
			НоваяЗапись.СуммаОбслуживанияУпр   = Окр(?(ТекАктив.Количество = СтрокаАктива.Количество,
				СтрокаАктива.СуммаОбслуживания, 
					СтрокаАктива.СуммаОбслуживания / СтрокаАктива.Количество * ТекАктив.Количество), 2); 				
			НоваяЗапись.Количество			   = Окр(ТекАктив.Количество, 3);
			
			// реквизиты
			НоваяЗапись.ХозОперация           = ДокументОбъект.ХозОперация;
		КонецЕсли;
		
		// реквизиты справочника
		Если ЭтоВыбытие И ВсеОК Тогда
			Актив_ = ТекАктив.Актив.ПолучитьОбъект();
			Актив_.ДатаВыбытия = ДокументОбъект.Дата;
			Актив_.ОбменДанными.Загрузка = Истина;
			Попытка
				Актив_.Записать();
			Исключение
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(НСтр("ru = 'Не удалось перезаписать актив ""%1""! %2'"), СокрЛП(Актив_), ОписаниеОшибки()),
					ДокументОбъект, 
					ТекАктив.Актив
				);
				ВсеОК = Ложь;
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
	// убиваем циклическую ссылку
	ДокументОбъект = Неопределено;
	ДатаДвижений   = Неопределено;
	РезультатЗапросаПоАктивам = Неопределено;
	
	// все ОК
	Возврат ВсеОК;
КонецФункции

// Формирует движения по регистру расход (перемещение прочих активов) и приходование его на новое подразделение
// Возвращаемое значение: Булево. Истина - все ОК, Ложь - чего-то не так.
Функция Перемещение() Экспорт
	ВсеОК = Расход();
	
	Если ВсеОК Тогда
		// Оприходуем все списанные активы на новое подразделение
		СписанныеАктивы = ЭтотОбъект.Выгрузить();
		Для каждого СписанныйАктив Из СписанныеАктивы Цикл
			НоваяЗапись = Добавить();
			НоваяЗапись.ВидДвижения           = ВидДвиженияНакопления.Приход;
			НоваяЗапись.Период                = СписанныйАктив.Период;
			НоваяЗапись.Регистратор           = СписанныйАктив.Регистратор;
			// измерения
			НоваяЗапись.ПодразделениеКомпании = ПодразделениеКомпанииПолучатель;
			НоваяЗапись.МОЛ                   = МОЛПолучатель;
			НоваяЗапись.ПрочийАктив           = СписанныйАктив.ПрочийАктив;
			НоваяЗапись.ТипЭксплуатации       = СписанныйАктив.ТипЭксплуатации;
			НоваяЗапись.Автомобиль            = СписанныйАктив.Автомобиль;
			// ресурсы
			НоваяЗапись.БалансоваяСтоимость   = СписанныйАктив.БалансоваяСтоимость;
			НоваяЗапись.БалансоваяСтоимостьУпр = СписанныйАктив.БалансоваяСтоимостьУпр;
			НоваяЗапись.СуммаАмортизации      = СписанныйАктив.СуммаАмортизации;
			НоваяЗапись.СуммаАмортизацииУпр   = СписанныйАктив.СуммаАмортизацииУпр;
			НоваяЗапись.СуммаОбслуживания     = СписанныйАктив.СуммаОбслуживания;
			НоваяЗапись.СуммаОбслуживанияУпр  = СписанныйАктив.СуммаОбслуживанияУпр;
			НоваяЗапись.Количество            = СписанныйАктив.Количество;
			// реквизиты
			НоваяЗапись.ТипОбслуживания       = СписанныйАктив.ТипОбслуживания;
			НоваяЗапись.ХозОперация           = СписанныйАктив.ХозОперация;
		КонецЦикла; 
	КонецЕсли;
	
	ДокументОбъект = Неопределено;
	ПодразделениеКомпании = Неопределено;
	МОЛ = Неопределено;
	ПодразделениеКомпанииПолучатель = Неопределено;
	МОЛПолучатель = Неопределено;
	РезультатЗапросаПоАктивам = Неопределено;
	
	Возврат ВсеОК;
КонецФункции 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получить остатки актива
// 	Параметры:
//		ВыбАктив - СправочникСсылка.ПрочиеАктивы или массив Активов отбора,
// 		ВыбПодразделение - СправочникСсылка.ПодразделенияКомпании,
// 		ВыбМОЛ - СправочникСсылка.Сотрудники,
// 		Момент - Момент, на какой необходимо производить расчет
// 	Возвращаемое значение:
//		ТаблицаЗначений - [Актив, МОЛ, Тип эксплуатации, Балансовая стоимость, Амортизация, СуммаОбслуживания].
//
Функция ПолучитьОстаткиАктивов(ВыбПодразделение, ВыбМОЛ, ВыбАктив, Момент)
	// Наложим блокировку на считываемые данные
	СтруктураПараметровБлокировки = Новый Структура("ТипТаблицы, ИмяТаблицы", "РегистрНакопления", "ПрочиеАктивыВЭксплуатации");
	ЗначенияБлокировки = Новый Соответствие;
	
	// Сформируем запрос на получение остатков по активу
	ТекстПараметрыВиртуальнойТаблицы = "&Момент,  ";
	Если ЗначениеЗаполнено(ВыбПодразделение) Тогда
		ТекстПараметрыВиртуальнойТаблицы = ТекстПараметрыВиртуальнойТаблицы + "ПодразделениеКомпании В Иерархии (&Подразделение) И ";
	КонецЕсли; 
	Если ЗначениеЗаполнено(ВыбМОЛ) Тогда
		ТекстПараметрыВиртуальнойТаблицы = ТекстПараметрыВиртуальнойТаблицы + "МОЛ = &МОЛ И ";
		ЗначенияБлокировки.Вставить("МОЛ", ВыбМОЛ); 
	КонецЕсли; 
	Если ЗначениеЗаполнено(ВыбАктив) Тогда
		ТекстПараметрыВиртуальнойТаблицы = ТекстПараметрыВиртуальнойТаблицы + "(ПрочийАктив ";
		Если ТипЗнч(ВыбАктив) = Тип("ТаблицаЗначений") Тогда
			ТекстПараметрыВиртуальнойТаблицы = ТекстПараметрыВиртуальнойТаблицы + "В";
			СтруктураПараметровБлокировки.Вставить("ИсточникДанных", ВыбАктив);
			ОписаниеИсточника = Новый Соответствие;
			ОписаниеИсточника.Вставить("ПрочийАктив", "Актив");
		Иначе
			ТекстПараметрыВиртуальнойТаблицы = ТекстПараметрыВиртуальнойТаблицы + "=";
			ЗначенияБлокировки.Вставить("ПрочийАктив", ВыбАктив); 
		КонецЕсли; 
		ТекстПараметрыВиртуальнойТаблицы = ТекстПараметрыВиртуальнойТаблицы + " (&Актив)) И ";
	КонецЕсли; 
	ТекстПараметрыВиртуальнойТаблицы = Лев(ТекстПараметрыВиртуальнойТаблицы, СтрДлина(ТекстПараметрыВиртуальнойТаблицы) - 3);
	
	Запрос = Новый Запрос();
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	АктивыПодразделенияОстатки.ПрочийАктив КАК Актив,
		|	АктивыПодразделенияОстатки.ТипЭксплуатации КАК ТипЭксплуатации,
		|	АктивыПодразделенияОстатки.ПодразделениеКомпании КАК ПодразделениеКомпании,
		|	АктивыПодразделенияОстатки.МОЛ КАК МОЛ,
		|	АктивыПодразделенияОстатки.Автомобиль КАК Автомобиль,
		|	ЕСТЬNULL(АктивыПодразделенияОстатки.БалансоваяСтоимостьУпрОстаток, 0) КАК БалансоваяСтоимость,
		|	ЕСТЬNULL(АктивыПодразделенияОстатки.СуммаАмортизацииУпрОстаток, 0) КАК Амортизация,
		|	ЕСТЬNULL(АктивыПодразделенияОстатки.СуммаОбслуживанияУпрОстаток, 0) КАК СуммаОбслуживания,
		|	ЕСТЬNULL(АктивыПодразделенияОстатки.БалансоваяСтоимостьОстаток, 0) КАК БалансоваяСтоимостьРегл,
		|	ЕСТЬNULL(АктивыПодразделенияОстатки.СуммаАмортизацииОстаток, 0) КАК АмортизацияРегл,
		|	ЕСТЬNULL(АктивыПодразделенияОстатки.СуммаОбслуживанияОстаток, 0) КАК СуммаОбслуживанияРегл,
		|	ЕСТЬNULL(АктивыПодразделенияОстатки.КоличествоОстаток, 0) КАК Количество
		|ИЗ
		|	РегистрНакопления.ПрочиеАктивыВЭксплуатации.Остатки(" + ТекстПараметрыВиртуальнойТаблицы + ") КАК АктивыПодразделенияОстатки
		|";
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Момент",        ?(Момент = Неопределено, Новый МоментВремени(КонецДня(ТекущаяДатаСеанса())), Момент));
	Запрос.УстановитьПараметр("Подразделение", ВыбПодразделение);
	Запрос.УстановитьПараметр("МОЛ",           ВыбМОЛ);
	Запрос.УстановитьПараметр("Актив",         ВыбАктив);
	
	ЗначенияБлокировки.Вставить("Период", Запрос.Параметры.Момент); 
	ОбработкаСобытийДокументаСервер.УстановитьУправляемуюБлокировку(СтруктураПараметровБлокировки, ЗначенияБлокировки, ОписаниеИсточника);
	
	ТаблАктивы = Запрос.Выполнить().Выгрузить();
	Возврат ТаблАктивы;
КонецФункции

// Проверяет, начислялась ли уже амортизация в этом месяце на актив
// Возвращаемое значение:
//		- Истина, если начислялась,
//		- Ложь, если не начислялась.
Функция ПроверитьНачислениеАмортизации(ВыбАктив)
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ПрочиеАктивы.Ссылка КАК ПрочийАктив,
	|	ПрочиеАктивы.ДатаВводаВЭксплуатацию
	|ПОМЕСТИТЬ
	|	ТаблицаАктива
	|ИЗ
	|	Справочник.ПрочиеАктивы КАК ПрочиеАктивы
	|ГДЕ
	|	ПрочиеАктивы.Ссылка = &Актив
	|ИНДЕКСИРОВАТЬ ПО
	|	ПрочийАктив
	|;
	|
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПрочиеАктивыВЭксплуатации.ПрочийАктив КАК ПрочийАктив
	|ИЗ
	|	РегистрНакопления.ПрочиеАктивыВЭксплуатации КАК ПрочиеАктивыВЭксплуатации
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	ТаблицаАктива КАК ТаблицаАктива
	|ПО
	|	ПрочиеАктивыВЭксплуатации.ПрочийАктив = ТаблицаАктива.ПрочийАктив
	|ГДЕ
	|	ПрочиеАктивыВЭксплуатации.Период МЕЖДУ &НачПериода И &КонПериода
	|	И ПрочиеАктивыВЭксплуатации.ПрочийАктив = &Актив
	|	И НЕ ПрочиеАктивыВЭксплуатации.Регистратор = &Регистратор
	|	И ТИПЗНАЧЕНИЯ(ПрочиеАктивыВЭксплуатации.Регистратор) В (ТИП(Документ.ВводВЭксплуатацию),Тип(Документ.Амортизация),Тип(Документ.ВводОстатковПрочихАктивов),Тип(Документ.ВводВЭксплуатациюАвтомобилей))
	|	И (ТаблицаАктива.ДатаВводаВЭксплуатацию МЕЖДУ &НачПериода И &КонПериода
	|	ИЛИ ТаблицаАктива.ДатаВводаВЭксплуатацию = ДатаВремя(1, 1, 1))";
	
	Запрос = Новый Запрос();
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Актив", ВыбАктив);
	Запрос.УстановитьПараметр("Регистратор", ДокументОбъект.Ссылка);
	Запрос.УстановитьПараметр("НачПериода", НачалоМесяца(ДокументОбъект.Дата));
	Запрос.УстановитьПараметр("КонПериода", КонецДня(КонецМесяца(ДокументОбъект.Дата)));
	Возврат (НЕ Запрос.Выполнить().Пустой());
КонецФункции

// Возвращает выборку активов из указанного списка, по которым были движения.
Функция ПолучитьНаличиеДвиженийПоАктивам(МассивАктивов, Момент = Неопределено)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ПрочиеАктивыВЭксплуатацииОбороты.ПрочийАктив КАК ПрочийАктив
	|ИЗ
	|	РегистрНакопления.ПрочиеАктивыВЭксплуатации.Обороты(, &Момент, , ПрочийАктив В (&ПрочиеАктивы)) КАК ПрочиеАктивыВЭксплуатацииОбороты";
	Запрос.УстановитьПараметр("Момент", ?(Момент = Неопределено, Новый МоментВремени(КонецДня(ТекущаяДатаСеанса())), Момент));
	Запрос.УстановитьПараметр("ПрочиеАктивы", МассивАктивов);
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции 

#КонецОбласти

#Область Инициализация

//////////////////////////////////////////////////////////////////////////
// Инициализация переменных модуля набора записей

ДокументОбъект            = Неопределено; //  Обязательный к заполнению перед началом проведения
ПодразделениеКомпании     = Неопределено; //  Обязательный к заполнению перед началом проведения
МОЛ                       = Неопределено;
ЭтоПервыйВвод             = Ложь;
ЭтоВыбытие                = Ложь;
ЭтоАмортизация            = Ложь;
ДатаДвижений              = Неопределено;
РезультатЗапросаПоАктивам = Неопределено; //  Обязательный к заполнению перед началом проведения
СуммаАмортизацииУпр       = 0;

#КонецОбласти

#КонецЕсли