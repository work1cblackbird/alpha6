﻿
#Область ПрограммныйИнтерфейс

#Область ДлительныеОперации

// Замены для номенклатуры по артикулу и производителю.
//
// Параметры:
//  Номенклатура - Структура - Описание ключевых полей номенклатуры:
//    Артикул - артикул для поиска номенклатуры См. ПодборТоваровКлиентСервер.ВАртикулДляПоиска.
//  АдресДляСтарыхЗамен - Строка - Адрес во временном хранилище для размещения старых замен номенклатуры.
//  АдресДляНовыхЗамен - Строка - Адрес во временном хранилище для размещения новых замен номенклатуры.
//
Процедура ЗаменыНоменклатуры(Номенклатура, АдресДляСтарыхЗамен, АдресДляНовыхЗамен) Экспорт
	
	ДополнительныеДанные = Неопределено;
	Номенклатура.Свойство("ДополнительныеДанные", ДополнительныеДанные);
	ТаблицаЗамен = ЗаменыСервер.ЗаменыНоменклатурыПоПолям(
		Номенклатура.Артикул,
		Номенклатура.Производитель,
		ДополнительныеДанные);
	ТаблицаЗамен.Колонки.Добавить("НомерСтроки", ОбщегоНазначения.ОписаниеТипаЧисло(3, 0));
	СтарыеЗамены = ТаблицаЗамен.НайтиСтроки(Новый Структура("Новая", Ложь));
	НовыеЗамены = ТаблицаЗамен.НайтиСтроки(Новый Структура("Новая", Истина));
	ПоместитьВоВременноеХранилище(
		ОбщегоНазначения.ТаблицаЗначенийВМассив(ЗаполнитьНомераСтрок(ТаблицаЗамен.Скопировать(СтарыеЗамены))),
		АдресДляСтарыхЗамен);
	ПоместитьВоВременноеХранилище(
		ОбщегоНазначения.ТаблицаЗначенийВМассив(ЗаполнитьНомераСтрок(ТаблицаЗамен.Скопировать(НовыеЗамены))),
		АдресДляНовыхЗамен);
	
КонецПроцедуры

// Уникальные позиции из спр. Номенклатура, аналогов, замен и прайс-листов.
// Ключ уникальности связка артикул и производитель.
//
// Параметры:
//  ПараметрыПоиска - Структура - Параметры поиска позиций:
//   - Артикул - Строка - Строка поиска по артикулу.
//   - ИспользованиеФильтраПроизводитель - Булево - Признак отбора по производителю.
//   - Производитель - СправочникСсылка.Производители - Фильтр производитель.
//   - ТочныйПоиск - Булево - Признак поиска на равно, а не содержит.
//   - ИскатьВоВнешнихПрайсЛистахКонтрагентов - Булево - Признак необходимости поиска во внешних источниках.
//  АдресРезультата - Строка - Адрес во временном хранилище в которое будет помещен результат выполнения.
//
Процедура ПоискНоменклатуры(ПараметрыПоиска, АдресРезультата) Экспорт
	
	Результат = ПоискВПрайсЛистах.ВыполнитьПоискУникальныхПозиций(
		ПараметрыПоиска.Артикул,
		ПодборТоваровКлиентСервер.ВАртикулДляПоиска(ПараметрыПоиска.Артикул),
		ПараметрыПоиска.Наименование,
		ПараметрыПоиска.ИспользованиеФильтраПроизводитель,
		ПараметрыПоиска.Производитель,
		ПараметрыПоиска);
	
	ПоместитьВоВременноеХранилище(ОбщегоНазначения.ТаблицаЗначенийВМассив(Результат), АдресРезультата);
	
КонецПроцедуры

// ++ siniko

// Цены номенклатуры по подразделению.
//
// Параметры:
//  Параметры - Структура - Описание параметров цен:
//    *Номенклатура - СправочникСсылка.Номенклатура - Номенклатура для которой получаются цены.
//    *ПодразделениеКомпании - СправочникСсылка.ПодразделенияКомпании - Подразделение цены.
//  АдресРезультата - Строка - Адрес во временном хранилище для размещения цен номенклатуры.
//
Процедура ЦеныНоменклатуры(Параметры, АдресРезультата) Экспорт
	
	#Область ТекстЗапроса
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ЦеныСрезПоследних.ТипЦен КАК ТипЦен,
	|	ВЫБОР
	|		КОГДА ЦеныСрезПоследних.ТипЦен.ВВалютеУчета = ИСТИНА
	|			ТОГДА ЦеныСрезПоследних.Номенклатура.ВалютаУчета
	|		ИНАЧЕ ЦеныСрезПоследних.ТипЦен.ВалютаЦены
	|	КОНЕЦ КАК ВалютаЦены,
	|	ЦеныСрезПоследних.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ЦеныСрезПоследних.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЦеныСрезПоследних.ПодразделениеКомпании КАК Подразделение,
	|	ЦеныСрезПоследних.Цена КАК Цена,
	|	0 КАК ЦенаРегл
	|ПОМЕСТИТЬ ТаблицаЦен
	|ИЗ
	|	РегистрСведений.Цены.СрезПоследних(
	|			&НаДату,
	|			ПодразделениеКомпании В(&СписокПодразделений)
	|			И Номенклатура = &Номенклатура
	|				И Контрагент = &Контрагент) КАК ЦеныСрезПоследних
	|ГДЕ
	|	ЦеныСрезПоследних.Цена > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаЦен.ТипЦен КАК ТипЦен,
	|	ТаблицаЦен.ВалютаЦены КАК ВалютаЦены,
	|	ТаблицаЦен.ВалютаЦены КАК БазоваяВалюта,
	|	ТаблицаЦен.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ТаблицаЦен.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ТаблицаЦен.Подразделение КАК Подразделение,
	|	ТаблицаЦен.Цена КАК Цена,
	|	ТаблицаЦен.ЦенаРегл КАК ЦенаРегл,
	|	NULL КАК ОкруглятьВБольшуюСторону,
	|	NULL КАК Точность,
	|	0 КАК ПолеСортировки,
	|	ТаблицаЦен.ТипЦен.Рассчитывается КАК Рассчитывается,
	|	ЗНАЧЕНИЕ(Справочник.ЦеновыеГруппы.ПустаяСсылка) КАК ЦеноваяГруппа
	|ПОМЕСТИТЬ ВТ_ЦеныПодразделений
	|ИЗ
	|	ТаблицаЦен КАК ТаблицаЦен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТипыЦенПоВидамНоменклатуры.Ссылка,
	|	ТипыЦенПоВидамНоменклатуры.ВалютаЦены,
	|	ТипыЦенПоВидамНоменклатуры.БазоваяВалюта,
	|	ТаблицаЦен.ХарактеристикаНоменклатуры,
	|	ТаблицаЦен.ЕдиницаИзмерения,
	|	ТаблицаЦен.Подразделение,
	|	ТаблицаЦен.Цена + ТаблицаЦен.Цена * (ЕСТЬNULL(ТипыЦенПоВидамНоменклатуры.ПроцентСкидкиНаценкиТаблица, 0) / 100),
	|	ТаблицаЦен.ЦенаРегл,
	|	ТипыЦенПоВидамНоменклатуры.ОкруглятьВБольшуюСторону,
	|	ТипыЦенПоВидамНоменклатуры.Точность,
	|	1,
	|	ТаблицаЦен.ТипЦен.Рассчитывается,
	|	ЕСТЬNULL(ТипыЦенПоВидамНоменклатуры.ЦеноваяГруппа, ЗНАЧЕНИЕ(Справочник.ЦеновыеГруппы.ПустаяСсылка))
	|ИЗ
	|	ТаблицаЦен КАК ТаблицаЦен
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ВЫБОР
	|				КОГДА ТипыЦенПроцентыСкидкиНаценки.БазовыйТипЦен ЕСТЬ NULL
	|					ТОГДА ТипыЦен.БазовыйТипЦен
	|				ИНАЧЕ ТипыЦенПроцентыСкидкиНаценки.БазовыйТипЦен
	|			КОНЕЦ КАК БазовыйТипЦен,
	|			ВЫБОР
	|				КОГДА ТипыЦенПроцентыСкидкиНаценки.БазовыйТипЦен ЕСТЬ NULL
	|					ТОГДА ТипыЦен.БазовыйТипЦен.ВалютаЦены
	|				ИНАЧЕ ТипыЦенПроцентыСкидкиНаценки.БазовыйТипЦен.ВалютаЦены
	|			КОНЕЦ КАК БазоваяВалюта,
	|			ТипыЦен.ВалютаЦены КАК ВалютаЦены,
	|			ТипыЦен.ОкруглятьВБольшуюСторону КАК ОкруглятьВБольшуюСторону,
	|			ТипыЦен.Точность КАК Точность,
	|			ВЫБОР
	|				КОГДА ТипыЦенПроцентыСкидкиНаценки.ПроцентСкидкиНаценки ЕСТЬ NULL
	|					ТОГДА ТипыЦен.ПроцентСкидкиНаценки
	|				ИНАЧЕ ТипыЦенПроцентыСкидкиНаценки.ПроцентСкидкиНаценки
	|			КОНЕЦ КАК ПроцентСкидкиНаценкиТаблица,
	|			ТипыЦен.Ссылка КАК Ссылка,
	|			ЕСТЬNULL(ТипыЦенПроцентыСкидкиНаценки.ЦеноваяГруппа, ЗНАЧЕНИЕ(Справочник.ЦеновыеГруппы.ПустаяСсылка)) КАК ЦеноваяГруппа
	|		ИЗ
	|			Справочник.ТипыЦен КАК ТипыЦен
	|				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТипыЦен.ПроцентыСкидкиНаценки КАК ТипыЦенПроцентыСкидкиНаценки
	|				ПО (ТипыЦенПроцентыСкидкиНаценки.Ссылка = ТипыЦен.Ссылка)
	|					И (ТипыЦенПроцентыСкидкиНаценки.ЦеноваяГруппа = &ЦеноваяГруппа)) КАК ТипыЦенПоВидамНоменклатуры
	|		ПО ТаблицаЦен.ТипЦен = ТипыЦенПоВидамНоменклатуры.БазовыйТипЦен
	|ГДЕ
	|	ТаблицаЦен.Цена > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ЦеныПодразделений.ТипЦен КАК ТипЦен,
	|	ВТ_ЦеныПодразделений.ВалютаЦены КАК ВалютаЦены,
	|	ВТ_ЦеныПодразделений.БазоваяВалюта КАК БазоваяВалюта,
	|	ВТ_ЦеныПодразделений.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ВТ_ЦеныПодразделений.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВТ_ЦеныПодразделений.Подразделение КАК Подразделение,
	|	ВТ_ЦеныПодразделений.Цена КАК Цена,
	|	ВТ_ЦеныПодразделений.ЦенаРегл КАК ЦенаРегл,
	|	ВТ_ЦеныПодразделений.ОкруглятьВБольшуюСторону КАК ОкруглятьВБольшуюСторону,
	|	ВТ_ЦеныПодразделений.Точность КАК Точность,
	|	ВТ_ЦеныПодразделений.ПолеСортировки КАК ПолеСортировки,
	|	ВТ_ЦеныПодразделений.Рассчитывается КАК Рассчитывается,
	|	0 КАК ЦенаБезНДС,
	|	0 КАК ЦенаБезНДСРегл
	|ИЗ
	|	ВТ_ЦеныПодразделений КАК ВТ_ЦеныПодразделений
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПолеСортировки,
	|	ТипЦен";
	
	#КонецОбласти
	
	СписокПодразделений = Новый СписокЗначений;
	СписокПодразделений.Добавить(Параметры.ПодразделениеКомпании);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("НаДату", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Контрагент", Справочники.Контрагенты.ПустаяСсылка());
	Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
	Запрос.УстановитьПараметр("Номенклатура", Параметры.Номенклатура);
	Запрос.УстановитьПараметр("ЦеноваяГруппа", Параметры.Номенклатура.ЦеноваяГруппа);
	ТаблицаЦены = Запрос.Выполнить().Выгрузить();
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчетаОрганизаций.Получить();
	Ставка = Параметры.Номенклатура.СтавкаНДС.Ставка;
	
	Для Каждого ТекСтрока Из ТаблицаЦены Цикл
		
		Если ТекСтрока.ВалютаЦены <> ТекСтрока.БазоваяВалюта Тогда
			
			ТекСтрока.Цена = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(
				ТекСтрока.Цена,
				ТекСтрока.БазоваяВалюта,
				ТекущаяДатаСеанса(),
				ТекСтрока.ВалютаЦены,
				ТекущаяДатаСеанса());
		
		КонецЕсли;
		
		РежимОкругленияЦены = ?(ТекСтрока.ТипЦен.ОкруглятьВБольшуюСторону, 1, 0);
		ТекСтрока.Цена = Окр(ТекСтрока.Цена, ТекСтрока.ТипЦен.Точность, РежимОкругленияЦены);
		
		Если ВалютаРегламентированногоУчета <> Справочники.Валюты.ПустаяСсылка() Тогда
			
			Если ТекСтрока.ВалютаЦены = ВалютаРегламентированногоУчета Тогда
				
				ТекСтрока.ЦенаРегл = ТекСтрока.Цена;
				
			Иначе
				
				ТекСтрока.ЦенаРегл = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(
					ТекСтрока.Цена,
					ТекСтрока.ВалютаЦены,
					ТекущаяДатаСеанса(),
					ВалютаРегламентированногоУчета,
					ТекущаяДатаСеанса());
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ТекСтрока.ТипЦен.ЦенаВключаетНДС Тогда
			
			ТекСтрока.ЦенаБезНДС     = ТекСтрока.Цена - Окр((ТекСтрока.Цена * Ставка)/(100 + Ставка), 2);
			ТекСтрока.ЦенаБезНДСРегл = ТекСтрока.ЦенаРегл - Окр((ТекСтрока.ЦенаРегл * Ставка)/(100 + Ставка), 2);
			
		Иначе
			
			ТекСтрока.ЦенаБезНДС     = ТекСтрока.Цена;
			ТекСтрока.ЦенаБезНДСРегл = ТекСтрока.ЦенаРегл;
			ТекСтрока.Цена           = ТекСтрока.Цена + Окр((ТекСтрока.Цена * Ставка)/100, 2);
			ТекСтрока.ЦенаРегл       = ТекСтрока.ЦенаРегл + Окр((ТекСтрока.ЦенаРегл * Ставка)/100, 2);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаЦены), АдресРезультата);
	
КонецПроцедуры

// Цены номенклатуры контрагентов.
//
// Параметры:
//  Параметры - Структура - Описание параметров цен:
//    *Номенклатура - СправочникСсылка.Номенклатура - Номенклатура для которой получаются цены.
//  АдресРезультата - Строка - Адрес во временном хранилище для размещения цен номенклатуры.
//
Процедура ЦеныКонтрагентов(Параметры, АдресРезультата) Экспорт
	
	// Загрузка цен контрагентов
	Запрос=Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	                    |	ЦеныСрезПоследних.ТипЦен КАК ТипЦен,
	                    |	ЦеныСрезПоследних.Контрагент КАК Контрагент,
						|	ЦеныСрезПоследних.ДоговорВзаиморасчетов КАК ДоговорВзаиморасчетов,
	                    |	ВЫБОР
	                    |		КОГДА ЦеныСрезПоследних.ТипЦен.ВВалютеУчета = ИСТИНА
	                    |			ТОГДА ЦеныСрезПоследних.Номенклатура.ВалютаУчета
	                    |		ИНАЧЕ ЦеныСрезПоследних.ТипЦен.ВалютаЦены
	                    |	КОНЕЦ КАК ВалютаЦены,
	                    |	ЦеныСрезПоследних.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	                    |	ЦеныСрезПоследних.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	                    |	ЦеныСрезПоследних.ПодразделениеКомпании КАК Подразделение,
	                    |	ЦеныСрезПоследних.Цена КАК Цена,
	                    |	0 КАК ЦенаРегл
	                    |ПОМЕСТИТЬ ТаблицаЦен
	                    |ИЗ
	                    |	РегистрСведений.Цены.СрезПоследних(
	                    |			&НаДату,
	                    |			Номенклатура = &Номенклатура
	                    |				И Контрагент <> &Контрагент) КАК ЦеныСрезПоследних
	                    |ГДЕ
	                    |	ЦеныСрезПоследних.Цена > 0
	                    |;
	                    |
	                    |////////////////////////////////////////////////////////////////////////////////
	                    |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                    |	ТаблицаЦен.Контрагент,
	                    |	ТаблицаЦен.ДоговорВзаиморасчетов,
	                    |	ТаблицаЦен.ТипЦен КАК ТипЦен,
	                    |	ТаблицаЦен.ВалютаЦены,
	                    |	ТаблицаЦен.ВалютаЦены КАК БазоваяВалюта,
	                    |	ТаблицаЦен.ХарактеристикаНоменклатуры,
	                    |	ТаблицаЦен.ЕдиницаИзмерения,
	                    |	ТаблицаЦен.Подразделение,
	                    |	ТаблицаЦен.Цена,
	                    |	ТаблицаЦен.ЦенаРегл,
	                    |	NULL КАК ОкруглятьВБольшуюСторону,
	                    |	NULL КАК Точность,
	                    |	0 КАК ПолеСортировки,
	                    |	ТаблицаЦен.ТипЦен.Рассчитывается КАК Рассчитывается
	                    |ИЗ
	                    |	ТаблицаЦен КАК ТаблицаЦен
	                    |
	                    |ОБЪЕДИНИТЬ ВСЕ
	                    |
	                    |ВЫБРАТЬ
	                    |	ТаблицаЦен.Контрагент,
	                    |	ТаблицаЦен.ДоговорВзаиморасчетов,
	                    |	ТипыЦенПоВидамНоменклатуры.Ссылка,
	                    |	ТипыЦенПоВидамНоменклатуры.ВалютаЦены,
	                    |	ТипыЦенПоВидамНоменклатуры.БазоваяВалюта,
	                    |	ТаблицаЦен.ХарактеристикаНоменклатуры,
	                    |	ТаблицаЦен.ЕдиницаИзмерения,
	                    |	ТаблицаЦен.Подразделение,
	                    |	ТаблицаЦен.Цена + ТаблицаЦен.Цена * (ЕСТЬNULL(ТипыЦенПоВидамНоменклатуры.ПроцентСкидкиНаценкиТаблица, 0) / 100),
	                    |	ТаблицаЦен.ЦенаРегл,
	                    |	ТипыЦенПоВидамНоменклатуры.ОкруглятьВБольшуюСторону,
	                    |	ТипыЦенПоВидамНоменклатуры.Точность,
	                    |	1,
	                    |	ТаблицаЦен.ТипЦен.Рассчитывается
	                    |ИЗ
	                    |	ТаблицаЦен КАК ТаблицаЦен
	                    |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	                    |			ВЫБОР
	                    |				КОГДА ТипыЦенПроцентыСкидкиНаценки.БазовыйТипЦен ЕСТЬ NULL
	                    |					ТОГДА ТипыЦен.БазовыйТипЦен
	                    |				ИНАЧЕ ТипыЦенПроцентыСкидкиНаценки.БазовыйТипЦен
	                    |			КОНЕЦ КАК БазовыйТипЦен,
	                    |			ВЫБОР
	                    |				КОГДА ТипыЦенПроцентыСкидкиНаценки.БазовыйТипЦен ЕСТЬ NULL
	                    |					ТОГДА ТипыЦен.БазовыйТипЦен.ВалютаЦены
	                    |				ИНАЧЕ ТипыЦенПроцентыСкидкиНаценки.БазовыйТипЦен.ВалютаЦены
	                    |			КОНЕЦ КАК БазоваяВалюта,
	                    |			ТипыЦен.ВалютаЦены КАК ВалютаЦены,
	                    |			ТипыЦен.ОкруглятьВБольшуюСторону КАК ОкруглятьВБольшуюСторону,
	                    |			ТипыЦен.Точность КАК Точность,
	                    |			ВЫБОР
	                    |				КОГДА ТипыЦенПроцентыСкидкиНаценки.ПроцентСкидкиНаценки ЕСТЬ NULL 
	                    |					ТОГДА ТипыЦен.ПроцентСкидкиНаценки
	                    |				ИНАЧЕ ТипыЦенПроцентыСкидкиНаценки.ПроцентСкидкиНаценки
	                    |			КОНЕЦ КАК ПроцентСкидкиНаценкиТаблица,
	                    |			ТипыЦен.Ссылка КАК Ссылка
	                    |		ИЗ
	                    |			Справочник.ТипыЦен КАК ТипыЦен
	                    |				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТипыЦен.ПроцентыСкидкиНаценки КАК ТипыЦенПроцентыСкидкиНаценки
	                    |				ПО (ТипыЦенПроцентыСкидкиНаценки.Ссылка = ТипыЦен.Ссылка)
	                    |					И (ТипыЦенПроцентыСкидкиНаценки.ЦеноваяГруппа = &ЦеноваяГруппа)) КАК ТипыЦенПоВидамНоменклатуры
	                    |		ПО ТаблицаЦен.ТипЦен = ТипыЦенПоВидамНоменклатуры.БазовыйТипЦен
	                    |ГДЕ
	                    |	ТаблицаЦен.Цена > 0
	                    |
	                    |УПОРЯДОЧИТЬ ПО
	                    |	ПолеСортировки,
	                    |	ТипЦен");
	
	Запрос.УстановитьПараметр("НаДату",ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Номенклатура",Параметры.Номенклатура);
	Запрос.УстановитьПараметр("ЦеноваяГруппа",Параметры.Номенклатура.ЦеноваяГруппа);
	Запрос.УстановитьПараметр("Контрагент",Справочники.Контрагенты.ПустаяСсылка());
	
	ТаблицаЦеныКонтрагентов = Запрос.Выполнить().Выгрузить();
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчетаОрганизаций.Получить();
	Ставка = Параметры.Номенклатура.СтавкаНДС.Ставка;
	
	Для Каждого ТекСтрока Из ТаблицаЦеныКонтрагентов Цикл
		
		// для рассчетных типов цен перерасчет из валюты базового типа цен
		ТекСтрока.Цена = ?(ТекСтрока.ВалютаЦены <> ТекСтрока.БазоваяВалюта, РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(ТекСтрока.Цена, ТекСтрока.БазоваяВалюта, ТекущаяДатаСеанса(), ТекСтрока.ВалютаЦены, ТекущаяДатаСеанса()), ТекСтрока.Цена);
		
		Если ТекСтрока.ТипЦен.ОкруглятьВБольшуюСторону Тогда
			ТекСтрока.Цена = Окр(ТекСтрока.Цена,ТекСтрока.ТипЦен.Точность,1);
		Иначе
			ТекСтрока.Цена = Окр(ТекСтрока.Цена,ТекСтрока.ТипЦен.Точность,0);
		КонецЕсли;
		
		Если ВалютаРегламентированногоУчета <> Справочники.Валюты.ПустаяСсылка() Тогда
			ТекСтрока.ЦенаРегл = ?(ТекСтрока.ВалютаЦены = ВалютаРегламентированногоУчета, ТекСтрока.Цена,
				РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(ТекСтрока.Цена, ТекСтрока.ВалютаЦены, ТекущаяДатаСеанса(), ВалютаРегламентированногоУчета, ТекущаяДатаСеанса()))	
		КонецЕсли;
		
		//НоваяСтрока = ЦеныКонтрагентов.Добавить();
		//НоваяСтрока.Характеристика = ТекСтрока.ХарактеристикаНоменклатуры;
		//ЗаполнитьЗначенияСвойств(НоваяСтрока,ТекСтрока);
		//
		//Если ТекСтрока.ТипЦен.ЦенаВключаетНДС Тогда
		//	НоваяСтрока.ЦенаБезНДС     = ТекСтрока.Цена - Окр((ТекСтрока.Цена * Ставка)/(100 + Ставка), 2);
		//	НоваяСтрока.ЦенаБезНДСРегл = ТекСтрока.ЦенаРегл - Окр((ТекСтрока.ЦенаРегл * Ставка)/(100 + Ставка), 2);
		//Иначе
		//	НоваяСтрока.ЦенаБезНДС     = ТекСтрока.Цена;
		//	НоваяСтрока.ЦенаБезНДСРегл = ТекСтрока.ЦенаРегл;
		//	НоваяСтрока.Цена           = ТекСтрока.Цена + Окр((ТекСтрока.Цена * Ставка)/100, 2);
		//	НоваяСтрока.ЦенаРегл       = ТекСтрока.ЦенаРегл + Окр((ТекСтрока.ЦенаРегл * Ставка)/100, 2);
		//КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаЦеныКонтрагентов), АдресРезультата);
	
КонецПроцедуры // ЦеныКонтрагентов()
// -- siniko

#КонецОбласти

#Область УсловноеОформление

// Добавление элементов условного оформления к списку номенклатуры.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма в которой располагается список.
//  ИмяСписка - Строка - Имя списка и элемента номенклатуры в форме.
//
Процедура УсловноеОформлениеСпискаНоменклатура(Форма, ИмяСписка="СписокНоменклатура") Экспорт
	
	ЭлементОформления = Форма.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Представление = НСтр("ru = 'Доступная номенклатура'");
	
	ЭлементОформления.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Форма.Элементы[ИмяСписка].Имя);
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(СтрШаблон("%1.Доступно", ИмяСписка));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ЭлементОтбора.ПравоеЗначение = 0;
	ЭлементОтбора.Использование = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.РезультатУспехЦвет);
	
КонецПроцедуры

// Добавление элементов условного оформления к расширенному списку номенклатуры.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма в которой располагается список.
//  ИмяСписка - Строка - Имя списка и элемента номенклатуры в форме.
//
Процедура УсловноеОформлениеРасширенногоПоискаНоменклатуры(Форма, ИмяСписка="РасширенныйПоискСписокНоменклатура") Экспорт
	
	ЭлементОформления = Форма.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Представление = НСтр("ru = 'Номенклатура не существующая в базе данных'");
	
	ЭлементОформления.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Форма.Элементы[ИмяСписка].Имя);
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(СтрШаблон("%1.Номенклатура", ИмяСписка));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.Использование = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЦвет);
	
КонецПроцедуры

#КонецОбласти

// Формирование списка вариантов поиска
//
// Параметры:
//  СписокВыбора - СписокВыбора - Список выбора элемента управления "переключатель вариантов выбора".
//
Процедура ЗаполнитьВыборВариантовПоиска(СписокВыбора) Экспорт
	
	СписокВыбора.Очистить();
	
	Для Каждого Вариант Из ПодборТоваровКлиентСервер.ВариантыПоиска() Цикл
		
		СписокВыбора.Добавить(Вариант.Значение);
		
	КонецЦикла;
	
КонецПроцедуры

// Общий обработчик переноса товаров из корзины в документ для документов автосервиса.
//
// Параметры:
//  Объект - ДокументОбъект, ДанныеФормыСтрктура - Документ для заполнения.
//  ТоварыОбъекта - ТабличнаяЧасть - Табличная часть товаров для заполнения.
//  Корзина - Массив - Товары подобранные на этапе подбора.
//  Контекст - Структура - Контекст добавления.
//
Процедура ЗаполнитьТоварыИзКорзиныВДокументахАвтосервиса(Объект, ТоварыОбъекта, Корзина, Контекст) Экспорт
	
	Менеджер = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка);
	Причина = ПолучитьЗначениеПараметраСтруктуры(Контекст, "ИдентификаторПричиныОбращения");
	ЕстьПричина = ЗначениеЗаполнено(Причина);
	ЕстьЦена = Не ТипЗнч(Корзина) = Тип("ТаблицаЗначений") ИЛИ ЕстьРеквизит(Корзина, "Цена");
	
	УсловиеПоиска = Новый Структура("Номенклатура,ХарактеристикаНоменклатуры,ЕдиницаИзмерения");
	
	Если ЕстьПричина Тогда
		
		УсловиеПоиска.Вставить("ИдентификаторПричиныОбращения", Причина);
		
	КонецЕсли;
	
	// Заблокируем пересчет скидок построчный
	ПараметрыДействия = Менеджер.ПолучитьПараметрыДействия(Объект);
	ПересчитыватьСкидки = Ложь;
	Если НЕ ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "НеРассчитыватьСкидки", Ложь) Тогда
		ПересчитыватьСкидки = Истина;
		ПараметрыДействия.Вставить("НеРассчитыватьСкидки", Истина);
	КонецЕсли;
	
	Для Каждого Товар Из Корзина Цикл
		
		ЗаполнитьЗначенияСвойств(УсловиеПоиска, Товар);
		НайденныеПоУсловию = ТоварыОбъекта.НайтиСтроки(УсловиеПоиска);
		
		Если НЕ НайденныеПоУсловию.Количество() Тогда
			
			НовыйТовар = ТоварыОбъекта.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйТовар, Товар);
			
			Если ЕстьПричина Тогда
				
				НовыйТовар.ИдентификаторПричиныОбращения = Причина;
				
			КонецЕсли;
			
			Менеджер.ТоварыНоменклатураПриИзменении(Объект, НовыйТовар, ПараметрыДействия);
			
			Если ЕстьЦена И ЗначениеЗаполнено(Товар.Цена) И Товар.Цена <> НовыйТовар.Цена Тогда
				
				НовыйТовар.Цена = Товар.Цена;
				Менеджер.ТоварыЦенаПриИзменении(Объект, НовыйТовар);
				
			КонецЕсли;
			
			Продолжить;
			
		КонецЕсли;
		
		НовыйТовар = НайденныеПоУсловию[0];
		НовыйТовар.Количество = НовыйТовар.Количество + Товар.Количество;
		Менеджер.ТоварыКоличествоПриИзменении(Объект, НовыйТовар, ПараметрыДействия);
		
	КонецЦикла;
	
	// Пересчитаем скидки для табличной части
	Если ПересчитыватьСкидки Тогда
		ПараметрыДействия.Удалить("НеРассчитыватьСкидки");
		СкидкиНаценкиСервер.УстановитьСкидкиНаценки(Объект, ПараметрыДействия);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗаполнитьНомераСтрок(Таблица)
	
	НомерСтроки = 1;
	
	Для Каждого Строка Из Таблица Цикл
		
		Строка.НомерСтроки = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

#КонецОбласти