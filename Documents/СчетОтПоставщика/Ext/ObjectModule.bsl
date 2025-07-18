﻿///////////////////////////////////////////
// Модуль документа "Счет от поставщика" //
///////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	ПрефиксацияОбъектов.ПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
	
КонецПроцедуры // ПриУстановкеНовогоНомера()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения = "", СтандартнаяОбработка = Истина)
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) И ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ЗаполнениеИзКорзины") Тогда
			Для Каждого Строка Из ДанныеЗаполнения.Товары Цикл
				
				НоваяСтрока 						   = Товары.Добавить();	
				НоваяСтрока.Номенклатура 			   = Строка.Номенклатура; 
				НоваяСтрока.ХарактеристикаНоменклатуры = Строка.ХарактеристикаНоменклатуры;
				НоваяСтрока.Количество 				   = Строка.Количество;
				НоваяСтрока.ЕдиницаИзмерения 		   = Строка.ЕдиницаИзмерения;
				НоваяСтрока.Коэффициент		 		   = Строка.Коэффициент;
				
			КонецЦикла;
		КонецЕсли;

	КонецЕсли;
	
	ПродолжатьЗаполнение = ОбработкаСобытийДокументаСервер.ОбработкаЗаполнения(
		ЭтотОбъект,
		ДанныеЗаполнения,
		ТекстЗаполнения,
		СтандартнаяОбработка,
		"ВхДокНомер,ВхДокДатаВрем",
		ПолучитьЗначениеПараметраСтруктуры(ДанныеЗаполнения, "ЗаполнятьПоСтуктуре", Ложь)
	);
	
	Если НЕ ПродолжатьЗаполнение Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьРасчетныйСчетКонтрагента();
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ПриКопировании(ОбъектКопирования)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ПриКопировании(ЭтотОбъект, ОбъектКопирования) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ПриКопировании()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты) Тогда
		
		Возврат;

	КонецЕсли;
	
	Если ЗначениеЗаполнено(РасчетныйСчетКонтрагента) И ВалютаДокумента <> РасчетныйСчетКонтрагента.ВалютаДенежныхСредств Тогда
		
		Отказ = Истина;
		ТекстСообщения = СтрШаблон(
			НСтр("ru='Валюта документа (<%1>) не соответствует валюте банковского счета (<%2>).'"),
			ВалютаДокумента,
			РасчетныйСчетКонтрагента.ВалютаДенежныхСредств
		);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "РасчетныйСчетКонтрагента");
		
	КонецЕсли;

КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// АПК:75-выкл

Процедура ПередУдалением(Отказ)
	
	ОбработкаСобытийДокументаСервер.ПередУдалением(ЭтотОбъект, Отказ);
	
КонецПроцедуры

// АПК:75-вкл

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиЗаполненияОбъекта

// Производит заполнение объекта на основании документа "Заказ поставщику"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ЗаказПоставщику(
	ДанныеЗаполнения,
	ТекстЗаполнения = "",
	СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ПродолжатьЗаполнение = ОбработкаСобытийДокументаСервер.ОбработкаЗаполненияНаОсновании(
		ЭтотОбъект,
		ДанныеЗаполнения,
		ТекстЗаполнения,
		СтандартнаяОбработка
	);
	
	Если НЕ ПродолжатьЗаполнение Тогда
		Возврат Истина;
	КонецЕсли;
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказыПоставщикамОстатки.Номенклатура КАК Номенклатура,
	|	ЗаказыПоставщикамОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ЗаказыПоставщикамОстатки.Заказано КАК ЗаказаноОстаток,
	|	ЗаказыПоставщикамОстатки.Сумма КАК Сумма,
	|	ЕСТЬNULL(ЗаказПоставщикуТовары.Количество * ЗаказПоставщикуТовары.Коэффициент, 1) КАК КоличествоБазовое,
	|	ЕСТЬNULL(ЗаказПоставщикуТовары.ЕдиницаИзмерения, Значение(Справочник.ЕдиницыИзмерения.ПустаяСсылка)) КАК ЕдиницаИзмерения,
	|	ЕСТЬNULL(ЗаказПоставщикуТовары.Коэффициент, 1) КАК Коэффициент,
	|	ЕСТЬNULL(ЗаказПоставщикуТовары.СтавкаНДС, ЗаказыПоставщикамОстатки.Номенклатура.СтавкаНДС) КАК СтавкаНДС,
	|	ЕСТЬNULL(ЗаказПоставщикуТовары.НомерСтроки, 1000000) КАК НомерСтроки
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаказыПоставщикам.Номенклатура КАК Номенклатура,
	|		ЗаказыПоставщикам.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		СУММА(ЗаказыПоставщикам.Заказано) КАК Заказано,
	|		СУММА(ЗаказыПоставщикам.Сумма) КАК Сумма
	|		ИЗ
	|			РегистрНакопления.ЗаказыПоставщикам КАК ЗаказыПоставщикам
	|		ГДЕ
	|			ЗаказыПоставщикам.Период<=&Момент
	|			И (НЕ ЗаказыПоставщикам.Регистратор ССЫЛКА Документ.ПоступлениеТоваров)
	|			И ЗаказыПоставщикам.ЗаказПоставщику = &ВыбЗаказПоставщику
	|			И ЗаказыПоставщикам.Контрагент = &ВыбКонтрагент
	|		СГРУППИРОВАТЬ ПО
	|			ЗаказыПоставщикам.Номенклатура,
	|			ЗаказыПоставщикам.ХарактеристикаНоменклатуры
	|		ИМЕЮЩИЕ
	|			(НЕ СУММА(ЗаказыПоставщикам.Заказано) = 0)
	|			ИЛИ (НЕ СУММА(ЗаказыПоставщикам.Сумма) = 0)) КАК ЗаказыПоставщикамОстатки
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.ЗаказПоставщику.Товары КАК ЗаказПоставщикуТовары
	|ПО
	|	ЗаказПоставщикуТовары.Ссылка                        = &ВыбЗаказПоставщику
	|	И ЗаказыПоставщикамОстатки.Номенклатура               = ЗаказПоставщикуТовары.Номенклатура
	|	И ЗаказыПоставщикамОстатки.ХарактеристикаНоменклатуры = ЗаказПоставщикуТовары.ХарактеристикаНоменклатуры
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|ИТОГИ
	|	СУММА(КоличествоБазовое),
	|	МАКСИМУМ(ЗаказаноОстаток),
	|	МАКСИМУМ(Сумма)
	|ПО
	|	Номенклатура,
	|	ХарактеристикаНоменклатуры";
	
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Момент", КонецДня(Дата));
	Запрос.УстановитьПараметр("ВыбКонтрагент", Контрагент);
	Запрос.УстановитьПараметр("ВыбЗаказПоставщику", ДанныеЗаполнения);
	
	Товары.Очистить();
	
	ВалютаЗаказа = ДанныеЗаполнения.ДоговорВзаиморасчетов.ВалютаВзаиморасчетов;
	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаЗаказа, Дата);
	КурсЗаказа = СтруктураКурса.Курс / ?(СтруктураКурса.Кратность = 0, 1, СтруктураКурса.Кратность);
	
	ВыборкаНоменклатуры = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаНоменклатуры.Следующий() Цикл
		
		ВыборкаХарактеристик = ВыборкаНоменклатуры.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаХарактеристик.Следующий() Цикл
			
			ВсегоОсталось = ВыборкаХарактеристик.ЗаказаноОстаток;
			КоличествоБазовоеПоЗаказу = ВыборкаХарактеристик.КоличествоБазовое;
			СуммаОсталось = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(
				ВыборкаХарактеристик.Сумма,
				ВалютаЗаказа,
				КурсЗаказа,
				ВалютаДокумента,
				КурсДокумента
			);
			ВыборкаДетали = ВыборкаХарактеристик.Выбрать(ОбходРезультатаЗапроса.Прямой);
			НоваяСтрока = Неопределено;
			
			Пока ВыборкаДетали.Следующий() Цикл
				
				Если ВсегоОсталось = 0 Тогда
					Прервать;
				КонецЕсли;
				
				Если ВыборкаДетали.ЗаказаноОстаток = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				КоличествоСтроки = ВыборкаДетали.ЗаказаноОстаток * (ВыборкаДетали.КоличествоБазовое / КоличествоБазовоеПоЗаказу);
				ТекущееКоличество = Мин(ВсегоОсталось, КоличествоСтроки);
				НоваяСтрока = Товары.Добавить();
				ЗаполнитьЗначенияСвойств(
					НоваяСтрока,
					ВыборкаДетали,
					"Номенклатура,ХарактеристикаНоменклатуры,ЕдиницаИзмерения,Коэффициент,СтавкаНДС"
				);
				Документы.СчетОтПоставщика.ТоварыНоменклатураПриИзменении(
					ЭтотОбъект,
					НоваяСтрока,
					ДополнительныеСвойства.ПараметрыДействия
				);
				Коэффициент = ?(ЗначениеЗаполнено(НоваяСтрока.Коэффициент), НоваяСтрока.Коэффициент, 1);
				НоваяСтрока.Количество = ТекущееКоличество / Коэффициент;
				НоваяСтрока.СуммаВсего = СуммаОсталось / ВсегоОсталось * ТекущееКоличество;
				СуммаОсталось = СуммаОсталось - НоваяСтрока.СуммаВсего;
				Документы.СчетОтПоставщика.ТоварыСуммаВсегоПриИзменении(
					ЭтотОбъект,
					НоваяСтрока,
					ДополнительныеСвойства.ПараметрыДействия
				);
				ВсегоОсталось = ВсегоОсталось - ТекущееКоличество;
				
			КонецЦикла;
			
			Если ВсегоОсталось = 0 И СуммаОсталось = 0 Тогда
				Продолжить;
			КонецЕсли;
				
			Если НоваяСтрока <> Неопределено Тогда
				
				НоваяСтрока.Количество = НоваяСтрока.Количество + (ВсегоОсталось / НоваяСтрока.Коэффициент);
				Документы.СчетОтПоставщика.ТоварыКоличествоПриИзменении(
					ЭтотОбъект,
					НоваяСтрока,
					ДополнительныеСвойства.ПараметрыДействия
				);
				НоваяСтрока.СуммаВсего = НоваяСтрока.СуммаВсего + СуммаОсталось;
				
			ИначеЕсли ВсегоОсталось > 0 Тогда
				
				НоваяСтрока = Товары.Добавить();
				НоваяСтрока.Номенклатура = ВыборкаХарактеристик.Номенклатура;
				НоваяСтрока.ХарактеристикаНоменклатуры = ВыборкаХарактеристик.ХарактеристикаНоменклатуры;
				Документы.СчетОтПоставщика.ТоварыНоменклатураПриИзменении(
					ЭтотОбъект,
					НоваяСтрока,
					ДополнительныеСвойства.ПараметрыДействия
				);
				НоваяСтрока.СтавкаНДС = Справочники.СтавкиНДС.ОсновнаяСтавкаНДС;
				Коэффициент = ?(ЗначениеЗаполнено(НоваяСтрока.Коэффициент), НоваяСтрока.Коэффициент, 1);
				НоваяСтрока.Количество = ВсегоОсталось / Коэффициент;
				Документы.СчетОтПоставщика.ТоварыКоличествоПриИзменении(
					ЭтотОбъект,
					НоваяСтрока,
					ДополнительныеСвойства.ПараметрыДействия
				);
				НоваяСтрока.СуммаВсего = СуммаОсталось;
				
			КонецЕсли;
			
			Документы.СчетОтПоставщика.ТоварыСуммаВсегоПриИзменении(
				ЭтотОбъект,
				НоваяСтрока,
				ДополнительныеСвойства.ПараметрыДействия
			);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_ЗаказПоставщику()

// Производит заполнение объекта на основании документа "Поступление товаров"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ПоступлениеТоваров(
	ДанныеЗаполнения,
	ТекстЗаполнения = "",
	СтандартнаяОбработка = Истина) Экспорт

	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ПродолжатьЗаполение = ОбработкаСобытийДокументаСервер.ОбработкаЗаполненияНаОсновании(
		ЭтотОбъект,
		ДанныеЗаполнения,
		ТекстЗаполнения,
		СтандартнаяОбработка
	);
	
	Если НЕ ПродолжатьЗаполение Тогда
		Возврат Истина;
	КонецЕсли;
	
	ТоварыСКоличествомНоль = Товары.НайтиСтроки(Новый Структура("Количество", 0));
	
	Для Каждого ТоварСКоличествомНоль Из ТоварыСКоличествомНоль Цикл
		Товары.Удалить(ТоварСКоличествомНоль);
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_ПоступлениеТоваров()

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьРасчетныйСчетКонтрагента()
	
	Если РасчетныйСчетКонтрагента.Пустая() И НЕ Контрагент.Пустая() Тогда
		
		РасчетныйСчетКонтрагента = Справочники.БанковскиеСчета.ОсновнойБанковскийСчет(Контрагент);
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ДополнительныеСвойства.Вставить("ТоварыЗапретАвтоСписанияХарактеристик", Истина);

#КонецОбласти

#КонецЕсли
