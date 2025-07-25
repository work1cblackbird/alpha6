﻿
#Область ПрограммныйИнтерфейс

// Получает текущее состояние бонусной программы
//
// Параметры:
//  БонуснаяПрограмма - СправочникСсылка.БонусныеПрограммы - бонусная программа.
//  Дата              - Дата - дата проверки состояния.
// 
// Возвращаемое значение:
//  Булево - признак активности бонусной программы.
//
Функция БонуснаяПрограммаАктивна(БонуснаяПрограмма, Дата = Неопределено) Экспорт
	
	Если БонуснаяПрограмма.Пустая() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АктивныеБонусныеПрограммыСрезПоследних.Активна
	|ИЗ
	|	РегистрСведений.АктивныеБонусныеПрограммы.СрезПоследних(&Момент, БонуснаяПрограмма = &БонуснаяПрограмма) КАК АктивныеБонусныеПрограммыСрезПоследних";
	Запрос.УстановитьПараметр("Момент", ?(Дата <> Неопределено, Дата, ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("БонуснаяПрограмма", БонуснаяПрограмма);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать(); 
	Выборка.Следующий();
	
	Возврат Выборка.Активна;
	
КонецФункции

// Устанавиливает активность программы
//
// Параметры:
//  БонуснаяПрограмма - СправочникСсылка.БонусныеПрограммы - Бонусная программа.
//  Активность        - Булево - Признак того, что программа активна.
//
Процедура УстановитьАктивностьБонуснойПрограммы(БонуснаяПрограмма, Активность) Экспорт
	
	РегистрыСведений.АктивныеБонусныеПрограммы.ЗаписатьАктивностьБонуснойПрограммы(БонуснаяПрограмма, Активность);
	
КонецПроцедуры

#Область ОбщиеПроцедурыИФункции

// Возвращает структуру параметров для распределения сумм
//
// Возвращаемое значение:
//  Структура - структура параметров для распределения сумм
//
Функция СоздатьПараметрыРаспределитьСуммуПоТаблице() Экспорт 
	
	СтруктураВозврата = Новый Структура();
	СтруктураВозврата.Вставить("Таблица", 				Неопределено);
	СтруктураВозврата.Вставить("СуммаРаспределения",	Неопределено);
	СтруктураВозврата.Вставить("КолонкаРаспределения", 	Неопределено);
	СтруктураВозврата.Вставить("ВМинус",				Истина);
	СтруктураВозврата.Вставить("ТаблицаПроцентов", 		Неопределено);
	СтруктураВозврата.Вставить("Объект", 				Неопределено);
	
	Возврат СтруктураВозврата;
	
КонецФункции

// Распределение суммы по таблице.
//
// Параметры:
//  СтруктураДанных - структура - содержит следующие параметры расчета:
//   *Таблица				 - ТаблицаЗначений - Таблица распределения.
// 	 *СуммаРаспределения	 - Число  - Сумма бонусных баллов.
//   *КолонкаРаспределения - Строка - Имя колонки распределения.
//   *ВМинус				 - Булево - Признак отрицательного распределения.
//
Процедура РаспределитьСуммуПоТаблице(СтруктураДанных) Экспорт

	Таблица 				= СтруктураДанных.Таблица;
	СуммаРаспределения 		= СтруктураДанных.СуммаРаспределения;
	КолонкаРаспределения 	= СтруктураДанных.КолонкаРаспределения;
	ВМинус 					= СтруктураДанных.ВМинус;
		
	СуммаВКолонке   		= Таблица.Итог(КолонкаРаспределения);
	
	Если СуммаВКолонке = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СуммаЗаЕдиницу = СуммаРаспределения / СуммаВКолонке;
	
	ОсталосьРаспределить = СуммаРаспределения;
	
	СтрокаСМаксимальнойСуммой = Таблица[0]; 
	СуммаСтрокиСМаксимальнойСуммой = Таблица[0][КолонкаРаспределения];

	Для Каждого Строка Из Таблица Цикл
		Если ОсталосьРаспределить = 0 И СтруктураДанных.Объект = Неопределено Или СуммаРаспределения = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если Строка[КолонкаРаспределения] > СтрокаСМаксимальнойСуммой[КолонкаРаспределения] Тогда
			СтрокаСМаксимальнойСуммой = Строка;
			СуммаСтрокиСМаксимальнойСуммой = Строка[КолонкаРаспределения];
		КонецЕсли;
		
		Если СтруктураДанных.Объект = Неопределено Тогда 
			Строка.РаспределенноеЗначение = Окр(СуммаЗаЕдиницу*Строка[КолонкаРаспределения], 2, РежимОкругления.Окр15как20);
			Строка[КолонкаРаспределения]  = Строка[КолонкаРаспределения] + ?(ВМинус, -Строка.РаспределенноеЗначение, Строка.РаспределенноеЗначение);
		Иначе
			СтрокаПроцента 					= СтруктураДанных.ТаблицаПроцентов.Найти(Строка.Строка[Строка.ИмяКолонки], "Номенклатура");
			Строка.РаспределенноеЗначение 	= Окр(СтрокаПроцента.Процент / 100 * Строка[КолонкаРаспределения], 2, РежимОкругления.Окр15как20);
		КонецЕсли;
		
		ОсталосьРаспределить = ОсталосьРаспределить - Строка.РаспределенноеЗначение;
	КонецЦикла;

	Если СтруктураДанных.Объект <> Неопределено И СуммаРаспределения <> 0 Тогда
		Если ОсталосьРаспределить < 0 Тогда
			МассивПроцентов 								= ?(ОсталосьРаспределить < 0, Таблица.ВыгрузитьКолонку("РаспределенноеЗначение"), СтруктураДанных.ТаблицаПроцентов.ВыгрузитьКолонку("Процент"));
			МассивРаспределения 							= ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаРаспределения, МассивПроцентов);
			Для Индекс = 0 По Таблица.Количество() - 1 Цикл
				Если Таблица[Индекс].Сумма = 0 Тогда Продолжить; КонецЕсли; 
				Если Таблица[Индекс].РаспределенноеЗначение < МассивРаспределения[Индекс] Тогда
					СуммаРаспределения 						= СуммаРаспределения - Таблица[Индекс].РаспределенноеЗначение;
					МассивПроцентов[Индекс]					= 0;
					МассивРаспределения 					= ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(СуммаРаспределения, МассивПроцентов);
				Иначе
					Таблица[Индекс].РаспределенноеЗначение 	= МассивРаспределения[Индекс];		
				КонецЕсли;
				Таблица[Индекс][КолонкаРаспределения] 		= Таблица[Индекс][КолонкаРаспределения]
					+ ?(ВМинус, -Таблица[Индекс].РаспределенноеЗначение, Таблица[Индекс].РаспределенноеЗначение);
			КонецЦикла;
		Иначе
			Для Каждого Строка Из Таблица Цикл
				Строка[КолонкаРаспределения]  				= Строка[КолонкаРаспределения] + ?(ВМинус, -Строка.РаспределенноеЗначение, Строка.РаспределенноеЗначение);			
			КонецЦикла;
		КонецЕсли;
		ОсталосьРаспределить 								= 0;
	КонецЕсли;

	Если ОсталосьРаспределить <> 0 Тогда
		СтрокаСМаксимальнойСуммой.РаспределенноеЗначение = СтрокаСМаксимальнойСуммой.РаспределенноеЗначение + ОсталосьРаспределить;
		СтрокаСМаксимальнойСуммой[КолонкаРаспределения]  = СтрокаСМаксимальнойСуммой[КолонкаРаспределения]
			+ ?(ВМинус, -ОсталосьРаспределить, ОсталосьРаспределить);
	КонецЕсли;
	
КонецПроцедуры

// Получить сумму баллов.
//
// Параметры:
//  КоличествоБаллов	 - Число								 - Количество баллов.
//  БонуснаяПрограмма	 - СправочникСсылка.БонусныеПрограммы	 - Бонусная программа.
//  Валюта				 - СправочникСсылка.Валюты				 - Валюта бонусной программы.
//  Дата				 - Дата									 - Дата перевода количества в сумму баллов.
// 
// Возвращаемое значение:
//  Число - Сумма бонусных баллов.
//
Функция БаллыВВалюту(КоличествоБаллов, БонуснаяПрограмма, Валюта, Дата) Экспорт
	
	СуммаВВалютеБонуснойПрограммы = КоличествоБаллов * БонуснаяПрограмма.КратностьБонусов;
	Возврат РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СуммаВВалютеБонуснойПрограммы, БонуснаяПрограмма.ВалютаБонуса, 
				Дата, Валюта, Дата, РежимОкругления.Окр15как20);
	
КонецФункции

// Проверка остатков бонусных баллов.
//
// Параметры:
//  БонуснаяПрограмма - СправочникСсылка.БонусныеПрограммы - бонусная программа.
// 
// Возвращаемое значение:
//  Булево - истина-есть остатки, ложь нет.
//
Функция ОстаткиБалловБонуснойПрограммы(БонуснаяПрограмма) Экспорт
	
	ТекстЗапрос =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	БонусныеБаллыОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.БонусныеБаллы.Остатки(, БонуснаяКарта.БонуснаяПрограмма = &БонуснаяПрограмма) КАК БонусныеБаллыОстатки";
	
	Запрос = Новый Запрос(ТекстЗапрос);
	Запрос.УстановитьПараметр("БонуснаяПрограмма", БонуснаяПрограмма);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

// Проверка блокировки дисконтной карты.
//
// Параметры:
//  ДисконтнаяКарта - СпрвавочникСсылка.Карты - Дисконтная карта проверки.
// 
// Возвращаемое значение:
//  Булево - Карта активна: истина. Иначе: ложь.
//
Функция ДисконтнаяКартаЗаблокирована(ДисконтнаяКарта) Экспорт
	
	ТаблицаШтрихКодов = ШтрихкодированиеВызовСервера.ПолучитьШтрихКодОбъекта(ДисконтнаяКарта,,, Истина);
	
	Если ТаблицаШтрихКодов.Количество() > 0 Тогда
		Возврат ТаблицаШтрихКодов[0].Запрет;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции // ДисконтнаяКартаЗаблокирована()

#КонецОбласти

#Область РасчетБаллов

// Расчитать бонусные баллы к начислению
//
// Параметры:
//  Объект				 - ДанныеФормыСтруктура				 - Объект, для которого выполняется обработка события.
//  БонуснаяПрограмма 	- СправочникСсылка.БонусныеПрограммы - Бонусная программа.
//
Процедура РассчитатьБонусныеБаллыКНачислению(Объект, Знач БонуснаяПрограмма = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(БонуснаяПрограмма) Тогда
		Попытка
			БонуснаяПрограмма = Объект.Карточка.БонуснаяПрограмма;
		Исключение

		КонецПопытки;
		
		Если НЕ ЗначениеЗаполнено(БонуснаяПрограмма) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ БонуснаяПрограммаАктивна(БонуснаяПрограмма, Объект.Дата) Тогда
		Объект.КоличествоКНачислению = 0;
		Возврат;
	КонецЕсли;
	
	Если БонуснаяПрограмма.ЗапретНачисленияПриОплатеБонусами И Объект.КоличествоКСписанию <> 0 Тогда
		Объект.КоличествоКНачислению = 0;
		Возврат;
	КонецЕсли;
	
	// заполнить таблицу авторабот и товаров
	ТаблицаТоваров = ИнициализироватьТаблицуНоменклатур(Объект);
	
	// получим процент начисления для строки
	Для Каждого Строка Из ТаблицаТоваров Цикл
		ПолучитьПроцентНачисленияДляСтроки(Строка, БонуснаяПрограмма);
	КонецЦикла;
	
	ТаблицаТоваров.Свернуть("Процент", "Сумма");
	
	ВалютаДокумента = Объект.ВалютаДокумента;
	КурсДокумента   = Объект.КурсДокумента;
	
	ВалютаПрограммы = БонуснаяПрограмма.ВалютаБонуса;
	КурсПрограммы  = РаботаСКурсамиВалютПлатформа.ПолучитьКурсВалюты(ВалютаПрограммы, Объект.Дата);
	
	СуммаБонусов = 0;
	Для Каждого Строка Из ТаблицаТоваров Цикл
		СуммаБонусов = СуммаБонусов + Строка.Сумма / 100 * Строка.Процент;
	КонецЦикла;
	
	СуммаБонусовВВал = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СуммаБонусов, ВалютаДокумента, 
			КурсДокумента, ВалютаПрограммы, КурсПрограммы, РежимОкругления.Окр15как20);
	КоличествоБаллов = ?(БонуснаяПрограмма.КратностьБонусов = 0, СуммаБонусовВВал, 
			СуммаБонусовВВал / БонуснаяПрограмма.КратностьБонусов);
	
	Объект.КоличествоКНачислению = ОкруглитьКоличествоБаллов(КоличествоБаллов, БонуснаяПрограмма);
	
КонецПроцедуры

// Получение максимального количества баллов
//
// Параметры:
//  Объект				 - ДанныеФормыСтруктура				 - Объект, для которого выполняется обработка события.
//  БонуснаяПрограмма 	- СправочникСсылка.БонусныеПрограммы - Бонусная программа.
// 
// Возвращаемое значение:
//  Число - Максимальное количество баллов.
//
Функция МаксимальноеКоличествоБаллов(Объект, Знач БонуснаяПрограмма = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(БонуснаяПрограмма) Тогда
		Попытка
			БонуснаяПрограмма = Объект.Карточка.БонуснаяПрограмма;
		Исключение 
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка получения бонусной программы'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		Если НЕ ЗначениеЗаполнено(БонуснаяПрограмма) Тогда
			Возврат 0;
		КонецЕсли;
	КонецЕсли;
	
	// заполнить таблицу авторабот и товаров
	ТаблицаТоваров = ИнициализироватьТаблицуНоменклатур(Объект);
	
	// получим процент начисления для строки
	Для Каждого Строка Из ТаблицаТоваров Цикл
		ПолучитьПроцентНачисленияДляСтроки(Строка, БонуснаяПрограмма, Ложь);
	КонецЦикла;
	
	ТаблицаТоваров.Свернуть("Процент", "Сумма");
	
	ВалютаДокумента = Объект.ВалютаДокумента;
	КурсДокумента   = Объект.КурсДокумента;
	
	ВалютаПрограммы = БонуснаяПрограмма.ВалютаБонуса;
	КурсПрограммы  = РаботаСКурсамиВалютПлатформа.ПолучитьКурсВалюты(ВалютаПрограммы, Объект.Дата);
	
	СуммаБонусов = 0;
	Для Каждого Строка Из ТаблицаТоваров Цикл
		СуммаБонусов = СуммаБонусов + Строка.Сумма / 100 * Строка.Процент;
	КонецЦикла;
	
	СуммаБонусовВВал = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СуммаБонусов, 
			ВалютаДокумента, КурсДокумента, ВалютаПрограммы, КурсПрограммы, РежимОкругления.Окр15как20);
	КоличествоБаллов = ?(БонуснаяПрограмма.КратностьБонусов = 0, СуммаБонусовВВал, 
			СуммаБонусовВВал / БонуснаяПрограмма.КратностьБонусов);
	Возврат ОкруглитьКоличествоБаллов(КоличествоБаллов, БонуснаяПрограмма);
	
КонецФункции

// Получение количества баллов в сумме документа
//
// Параметры:
//  Объект				 - ДанныеФормыСтруктура				 - Объект, для которого выполняется обработка события.
//  БонуснаяПрограмма 	- СправочникСсылка.БонусныеПрограммы - Бонусная программа.
// 
// Возвращаемое значение:
//  Число - Количество баллов.
//
Функция КоличествоБалловВСуммеДокумента(Объект, Знач БонуснаяПрограмма = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(БонуснаяПрограмма) Тогда
		Попытка
			БонуснаяПрограмма = Объект.Карточка.БонуснаяПрограмма;
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка получения бонусной программы'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		Если НЕ ЗначениеЗаполнено(БонуснаяПрограмма) Тогда
			Возврат 0;
		КонецЕсли;
	КонецЕсли;
	
	СуммаДокумента = Объект.Товары.Итог("СуммаВсего") + Объект.Товары.Итог("СуммаСкидкиБонусами");
	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.Заказнаряд") Тогда
		СуммаДокумента = СуммаДокумента + Объект.Автоработы.Итог("СуммаВсего") 
					+ Объект.Автоработы.Итог("СуммаСкидкиБонусами");
	КонецЕсли;
	
	СуммаВВалютеБонусов = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СуммаДокумента, 
			Объект.ВалютаДокумента, Объект.Дата, БонуснаяПрограмма.ВалютаБонуса, Объект.Дата);
	КоличествоБаллов = ?(БонуснаяПрограмма.КратностьБонусов = 0, СуммаВВалютеБонусов, 
			СуммаВВалютеБонусов / БонуснаяПрограмма.КратностьБонусов);
	
	Возврат ОкруглитьКоличествоБаллов(КоличествоБаллов, БонуснаяПрограмма);
	
КонецФункции

// Округлить количество баллов
//
// Параметры:
//  КоличествоБалов		 - Число								 - Количество баллов.
//  БонуснаяПрограмма	 - СправочникСсылка.БонусныеПрограммы	 - Бонусная программа.
// 
// Возвращаемое значение:
//  Число - Количество баллов с учетом округления.
//
Функция ОкруглитьКоличествоБаллов(КоличествоБалов, Знач БонуснаяПрограмма) Экспорт
	
	КоличествоБалловОкругленная = КоличествоБалов;
	
	ДанныеБонуснойПрограммы = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(БонуснаяПрограмма, 
															"ОкруглятьПоАрифметическимПравилам,Точность");
	
	Если ДанныеБонуснойПрограммы.ОкруглятьПоАрифметическимПравилам Тогда
		КоличествоБалловОкругленная = Окр(КоличествоБалов, ДанныеБонуснойПрограммы.Точность, РежимОкругления.Окр15как10);
	Иначе
		КоличествоБалловОкругленная = Окр(КоличествоБалов, ДанныеБонуснойПрограммы.Точность, РежимОкругления.Окр15как20);
	КонецЕсли;
	
	Возврат КоличествоБалловОкругленная;
	
КонецФункции // ОкруглитьКоличествоБаллов()

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИнициализироватьТаблицуНоменклатур(Объект) Экспорт
	
	// описания типов

	ТипыНоменклатуры = Новый Массив;
	ТипыНоменклатуры.Добавить(Тип("СправочникСсылка.Номенклатура"));
	ТипыНоменклатуры.Добавить(Тип("СправочникСсылка.Автоработы"));
	
	// получим таблицу авторабот с родителями
	ТаблицаНоменклатур = Новый ТаблицаЗначений;
	ТаблицаНоменклатур.Колонки.Добавить("Номенклатура"    , Новый ОписаниеТипов(ТипыНоменклатуры));
	ТаблицаНоменклатур.Колонки.Добавить("ТипНоменклатуры" , Новый ОписаниеТипов("СправочникСсылка.ТипыНоменклатуры"));
	ТаблицаНоменклатур.Колонки.Добавить("Сумма"      , Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(15, 2)));
	ТаблицаНоменклатур.Колонки.Добавить("Процент"    , Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(15, 2)));
	
	Для Каждого Строка Из Объект.Товары Цикл
		НоваяСтрока = ТаблицаНоменклатур.Добавить();
		НоваяСтрока.Номенклатура    = Строка.Номенклатура;
		НоваяСтрока.ТипНоменклатуры = Строка.Номенклатура.ТипНоменклатуры;
		НоваяСтрока.Сумма           = Строка.СуммаВсего + Строка.СуммаСкидкиБонусами;
		НоваяСтрока.Процент         = -1;
	КонецЦикла;
	
	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ЗаказНаряд") Тогда
		Для Каждого Строка Из Объект.Автоработы Цикл
			НоваяСтрока = ТаблицаНоменклатур.Добавить();
			НоваяСтрока.Номенклатура    = Строка.Авторабота;
			НоваяСтрока.ТипНоменклатуры = Строка.Авторабота.Номенклатура.ТипНоменклатуры;
			НоваяСтрока.Сумма           = Строка.СуммаВсего + Строка.СуммаСкидкиБонусами;
			НоваяСтрока.Процент         = -1;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТаблицаНоменклатур;
	
КонецФункции

Процедура ПолучитьПроцентНачисленияДляСтроки(Строка, БонуснаяПрограмма, Начисление = Истина) Экспорт
	
	// поиск по родителю
	Родитель = Строка.Номенклатура.Родитель;
	
	ПроцентыНачислений = ?(Начисление, БонуснаяПрограмма.ПравилаНачисленияБонусов, 
												БонуснаяПрограмма.ПравилаСписанияБонусов);
	
	Пока НЕ Родитель.Пустая() Цикл
		НайденнаяСтрока = ПроцентыНачислений.Найти(Родитель, "Группа");
		Если НайденнаяСтрока <> Неопределено Тогда
			Строка.Процент = НайденнаяСтрока.Процент;
			Прервать;
		КонецЕсли;
		Родитель = Родитель.Родитель;
	КонецЦикла;
	
	Если Строка.Процент <> -1 Тогда
		Возврат;
	КонецЕсли;
	
	НайденнаяСтрока = ПроцентыНачислений.Найти(Строка.ТипНоменклатуры, "Группа");
	Если НайденнаяСтрока <> Неопределено Тогда
		Строка.Процент = НайденнаяСтрока.Процент;
	КонецЕсли;
	
	Если Строка.Процент <> -1 Тогда
		Возврат;
	КонецЕсли;
	
	Строка.Процент = ?(Начисление, БонуснаяПрограмма.ПроцентНачисленияБонусов, 
										БонуснаяПрограмма.МаксимальныйПроцентОплатыБонусами);
	
КонецПроцедуры

Процедура ЗаполнитьКонтактнуюИнфрмациюРассылок(ТаблицаРассылок)Экспорт
	
	// получим КИ для рассылки
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КонтрагентыКонтактнаяИнформация.Ссылка КАК Контрагент,
	|	КонтрагентыКонтактнаяИнформация.Вид,
	|	КонтрагентыКонтактнаяИнформация.Представление
	|ИЗ
	|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
	|ГДЕ
	|	КонтрагентыКонтактнаяИнформация.Ссылка В(&Контрагенты)
	|	И КонтрагентыКонтактнаяИнформация.Вид В(&ВидыКИ)";
	
	ВидыКИ = Новый Массив;
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.EmailКонтрагента);
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента);
	
	Контрагенты = ТаблицаРассылок.ВыгрузитьКолонку("Контрагент");
	
	Запрос.УстановитьПараметр("Контрагенты", Контрагенты);
	Запрос.УстановитьПараметр("ВидыКИ", ВидыКИ);
	
	ТаблицаКИ = Запрос.Выполнить().Выгрузить();
	
	Отбор = Новый Структура("Контрагент");
	
	// Найдем эл. почту и телефон конрагента
	Для Каждого ТекущаяСтрока Из ТаблицаРассылок Цикл
		
		Для Каждого ВидКИ Из ВидыКИ Цикл
			
			ИмяКи = ?(ВидКИ = Справочники.ВидыКонтактнойИнформации.EmailКонтрагента, "Адрес", "Телефон");
			
			// Если имеется основной вид связи КИ, то возьмем его для рассылки
			ОсновнойКИ = ТаблицаКИ.НайтиСтроки(Новый Структура("Контрагент, Вид", ТекущаяСтрока.Контрагент, ВидКИ));
			
			Если ОсновнойКИ.Количество() > 0 Тогда
				ТекущаяСтрока[ИмяКИ] = ОсновнойКИ[0].Представление;
				Продолжить;
			КонецЕсли;
			
			НайденныеСтроки = ТаблицаКИ.НайтиСтроки(Новый Структура("Контрагент, Вид", ТекущаяСтрока.Контрагент, ВидКИ));
			
			// Если есть один КИ данного вида, то запишем его, иначе - первый попавшийся
			Если НайденныеСтроки.Количество() > 0 Тогда
				ТекущаяСтрока[ИмяКИ] = НайденныеСтроки[0].Представление;
				Продолжить;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьКонтактнуюИнфрмациюРассылок()

Функция СтрокаРассылки() Экспорт
	
	СтрокаДобавления = Новый Структура();
	СтрокаДобавления.Вставить("Контрагент");
	СтрокаДобавления.Вставить("БонуснаяПрограмма");
	СтрокаДобавления.Вставить("БонуснаяКарта");
	СтрокаДобавления.Вставить("Количество");
	СтрокаДобавления.Вставить("ДатаСписания");
	
	Возврат СтрокаДобавления;
	
КонецФункции

Функция СоздатьSMS(СтруктураСообщения, ДокументОснование = Неопределено, Рассылка) Экспорт
	
	ДокументSMS = Документы.СообщениеSMS.СоздатьДокумент();
	ДокументSMS.Заполнить(ДокументОснование);
	ДокументSMS.Дата = ТекущаяДатаСеанса();
	ДокументSMS.УстановитьНовыйНомер();

	ДокументSMS.ДатаКогдаОтправить = ТекущаяДатаСеанса();
	ДокументSMS.Состояние   = Перечисления.СостоянияДокументаСообщениеSMS.Исходящее;
	ДокументSMS.Комментарий = СтрШаблон( НСтр("ru = 'Создан регламентным заданием ""%1""'"),СтруктураСообщения.ДополнительныеПараметры.Назначение);
	Получатель = ДокументSMS.Адресаты.Добавить();
	Получатель.Контакт       = Рассылка.Контрагент;
	Получатель.ПредставлениеКонтакта = Рассылка.Контрагент.НаименованиеПолное;
	Получатель.НомерДляОтправки = Рассылка.Телефон;
	Получатель.КакСвязаться     = Рассылка.Телефон;
	
	ДокументSMS.ТекстСообщения = СтруктураСообщения.Текст;
	
	Попытка
		ДокументSMS.Записать(); 
		
	Исключение
		
		ЗаписьЖурналаРегистрации(СтрШаблон( НСтр("ru = '""%1""'"),
			СтруктураСообщения.ДополнительныеПараметры.Назначение), 
			УровеньЖурналаРегистрации.Ошибка, , ,
			НСтр("ru = 'Документ SMS не может быть создан'"));

	КонецПопытки;
	
	Возврат ДокументSMS;
	
КонецФункции

Функция СоздатьEmail(СтруктураСообщения, ДокументОснование = Неопределено, УчетнаяЗаписьЭлектроннойПочты, Рассылка)Экспорт
	
	НовоеЭлектронноеПисьмо = Документы.ЭлектронноеПисьмоИсходящее.СоздатьДокумент();
	НовоеЭлектронноеПисьмо.Заполнить(ДокументОснование);
	НовоеЭлектронноеПисьмо.Дата = ТекущаяДатаСеанса();
	НовоеЭлектронноеПисьмо.УстановитьНовыйНомер();
	НовоеЭлектронноеПисьмо.ХозОперация = Справочники.ХозОперации.ЭлектронноеПисьмоИсходящее;
	НовоеЭлектронноеПисьмо.УчетнаяЗапись = УчетнаяЗаписьЭлектроннойПочты;
	НовоеЭлектронноеПисьмо.ОтправительПредставление = УчетнаяЗаписьЭлектроннойПочты.АдресЭлектроннойПочты;
	НовоеЭлектронноеПисьмо.Комментарий = СтрШаблон( НСтр("ru = 'Создан регламентным заданием ""%1""'"),СтруктураСообщения.ДополнительныеПараметры.Назначение);

	Получатель = НовоеЭлектронноеПисьмо.ПолучателиПисьма.Добавить();
	Получатель.Адрес		 = Рассылка.Адрес;
	Получатель.Контакт       = Рассылка.Контрагент;
	Получатель.Представление = Рассылка.Адрес;
	
	СписокАдресатов =
		ВзаимодействияКлиентСервер.ПолучитьПредставлениеСпискаАдресатов(НовоеЭлектронноеПисьмо.ПолучателиПисьма, Ложь);
	НовоеЭлектронноеПисьмо.СписокПолучателейПисьма = СписокАдресатов;
	
	НовоеЭлектронноеПисьмо.Тема = НСтр("ru = 'Оповещение о бонусах'");
	
	Если СтруктураСообщения.ДополнительныеПараметры.ФорматПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
		НовоеЭлектронноеПисьмо.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML;
		НовоеЭлектронноеПисьмо.ТекстHTML = СтруктураСообщения.Текст;
	Иначе
		НовоеЭлектронноеПисьмо.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.ПростойТекст;
		НовоеЭлектронноеПисьмо.Текст = СтруктураСообщения.Текст;
	КонецЕсли;
	
	Попытка
		НовоеЭлектронноеПисьмо.Записать();
	Исключение
		ЗаписьЖурналаРегистрации(СтрШаблон( НСтр("ru = '""%1""'"),
			СтруктураСообщения.ДополнительныеПараметры.Назначение), 
			УровеньЖурналаРегистрации.Ошибка, ,,
			НСтр("ru = 'Документ электронное исходящее письмо не может быть создан'"));

	КонецПопытки;
	
	Возврат НовоеЭлектронноеПисьмо;
	
КонецФункции

Процедура ОтправитьSMS(ДокументыКОтправкеSMS)Экспорт
	
	ТаблицаАдресатовСообщения = Новый ТаблицаЗначений;
	ТаблицаАдресатовСообщения.Колонки.Добавить("НомерСтроки");
	ТаблицаАдресатовСообщения.Колонки.Добавить("НомерДляОтправки");
	ТаблицаАдресатовСообщения.Колонки.Добавить("КакСвязаться");
	
	Для Каждого ДокументSMS Из ДокументыКОтправкеSMS Цикл
		ТаблицаАдресатовСообщения.Очистить();
		
		Для Каждого ТекущаяСтрока Из ДокументSMS.Адресаты Цикл
			НоваяСтрока = ТаблицаАдресатовСообщения.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
		КонецЦикла;
		
		Если ТаблицаАдресатовСообщения.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		МассивНомеров = ТаблицаАдресатовСообщения.ВыгрузитьКолонку("НомерДляОтправки");
		РезультатОтправки = ОтправкаSMS.ОтправитьSMS(
		МассивНомеров,
		ДокументSMS.ТекстСообщения,
		"",
		ДокументSMS.ОтправлятьВТранслите
		);
		
		Если РезультатОтправки.ОтправленныеСообщения.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Взаимодействия.ОтразитьРезультатыОтправкиSMSВДокументе(ДокументSMS, РезультатОтправки);
		ДокументSMS.ДополнительныеСвойства.Вставить("НеЗаписыватьКонтакты", Истина);
		Попытка
			
			ДокументSMS.Записать();
			
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Документ SMS не может быть отправлен'"), 
									УровеньЖурналаРегистрации.Ошибка);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтправитьEmail(ДокументыКОтправкеПисем, УчетнаяЗаписьЭлектроннойПочты) Экспорт
	
	СозданПрофиль = Истина;
	
	Профиль = РаботаСПочтовымиСообщениямиСлужебный.ИнтернетПочтовыйПрофиль(УчетнаяЗаписьЭлектроннойПочты);
	
	Попытка
		Соединение = Новый ИнтернетПочта;
		Соединение.Подключиться(Профиль);
	Исключение
		
		ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Во время подключения к учетной записи %1 произошла ошибка
		|%2'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УчетнаяЗаписьЭлектроннойПочты,
		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
		
		ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Рассылка оповещений бонусной программы'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		ТекстСообщенияОбОшибке
		);
		СозданПрофиль = Ложь;
		
	КонецПопытки;
	
	Если СозданПрофиль Тогда
		
		Для Каждого ДокументEMail Из ДокументыКОтправкеПисем Цикл
			
			Попытка
				ИдентификаторПисьма = Взаимодействия.ВыполнитьОтправкуПисьма(
					ДокументEMail,
					Соединение).ИдентификаторПисьмаSMTP;
			Исключение
				ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Во время отправки электронного письма %1 произошла ошибка
				|%2'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				ДокументEMail.Ссылка,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
				);
				
				ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Рассылка оповещений о бонусных баллах'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				, ,
				ТекстСообщенияОбОшибке
				);
				
				Продолжить;
			КонецПопытки;
			
			Если ДокументEMail.УдалятьПослеОтправки Тогда
				ДокументEMail.Удалить();
			Иначе
				ДокументEMail.ИдентификаторСообщения = ИдентификаторПисьма;
				ДокументEMail.СтатусПисьма = Перечисления.СтатусыИсходящегоЭлектронногоПисьма.Отправлено;
				ДокументEMail.Размер = Взаимодействия.ОценитьРазмерИсходящегоЭлектронногоПисьма(ДокументEMail.Ссылка);
				ДокументEMail.ДатаОтправления = ТекущаяДатаСеанса();
				ДокументEMail.ДополнительныеСвойства.Вставить("НеЗаписыватьКонтакты", Истина);
				ДокументEMail.Записать(РежимЗаписиДокумента.Запись);
			КонецЕсли;
			
		КонецЦикла;
		
		Соединение.Отключиться();
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
