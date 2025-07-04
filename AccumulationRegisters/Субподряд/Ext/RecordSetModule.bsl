﻿// Модуль набора записей регистра накоплений "Субподряд"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ДокументОбъект Экспорт;            // документ объект
Перем ДатаВыполнения Экспорт;			 // дата выполнения субподряда
Перем РезультатЗапросаПоРаботам Экспорт; // результат запроса по работам
Перем РасчетыСКонтрагентами Экспорт; // Расчеты с контрагентами для формирования суммы услуг
Перем ПересчитаныСуммы Экспорт;
Перем ТребуетсяПересчетНДС Экспорт;


#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Фиксируем движения по субподрядным работам
Функция Движение(РеализацияПоСубподряду) Экспорт
	Результат = Истина;
	
	ВалютаРегл = Константы.ВалютаРегламентированногоУчетаОрганизаций.Получить();
	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРегл, ДокументОбъект.Дата);
	КурсРегл  = СтруктураКурса.Курс / ?(СтруктураКурса.Кратность = 0, 1, СтруктураКурса.Кратность);
	ВалютаУпр = Константы.ВалютаУправленческогоУчетаКомпании.Получить();
	Если ЗначениеЗаполнено(ДокументОбъект.КурсВалютыУпр) Тогда
		КурсУпр = ДокументОбъект.КурсВалютыУпр;
	Иначе
		СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаУпр, ДокументОбъект.Дата);
		КурсУпр = СтруктураКурса.Курс / ?(СтруктураКурса.Кратность = 0, 1, СтруктураКурса.Кратность);
	КонецЕсли;
	
	// Пересчитать суммы документа
	ПересчитаныСуммы = ?(ПересчитаныСуммы = Неопределено, Ложь, ПересчитаныСуммы);
	Если РасчетыСКонтрагентами <> Неопределено
		И РасчетыСКонтрагентами.Количество() > 0 Тогда
		
		СведенияОВалюте = Новый Структура();
		СведенияОВалюте.Вставить("ВалютаРегл", ВалютаРегл);
		СведенияОВалюте.Вставить("ВалютаУпр", ВалютаУпр);
		СведенияОВалюте.Вставить("КурсРегл", КурсРегл);
		СведенияОВалюте.Вставить("КурсУпр", КурсУпр);
		
		ПересчитаныСуммы = ОбработкаСобытийДокументаСервер.ПересчитанаВВалюту(
			ДокументОбъект,
			РезультатЗапросаПоРаботам,
			РасчетыСКонтрагентами,
			СведенияОВалюте,
			РеализацияПоСубподряду);
			
		
	КонецЕсли;
	
	Для каждого СтрокаТЧ Из РезультатЗапросаПоРаботам Цикл
		НоваяЗапись=Добавить();
		НоваяЗапись.Период = ?(ДатаВыполнения=Неопределено,ДокументОбъект.Дата,ДатаВыполнения);
		НоваяЗапись.Регистратор = ДокументОбъект.Ссылка;
		НоваяЗапись.ПодразделениеКомпании = ДокументОбъект.ПодразделениеКомпании;
		НоваяЗапись.Контрагент = СтрокаТЧ.Контрагент;
		НоваяЗапись.ДоговорВзаиморасчетов = СтрокаТЧ.ДоговорВзаиморасчетов;
		НоваяЗапись.ЗаказНаряд = СтрокаТЧ.ЗаказНаряд;
		НоваяЗапись.Работа = СтрокаТЧ.Работа;
		
		Если РеализацияПоСубподряду Тогда
			Если ПересчитаныСуммы Тогда
				НоваяЗапись.Сумма = СтрокаТЧ.Сумма;
				Если ТребуетсяПересчетНДС Тогда
					ПроцентНДС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТЧ.СтавкаНДС, "Ставка");
					НоваяЗапись.СуммаНДС = Окр(СтрокаТЧ.Сумма * ПроцентНДС / (100 + ПроцентНДС), 2);
				Иначе
					НоваяЗапись.СуммаНДС = СтрокаТЧ.СуммаНДС;
				КонецЕсли;
				НоваяЗапись.СуммаУпр = СтрокаТЧ.СуммаУпр;
			Иначе
				НоваяЗапись.Сумма = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СтрокаТЧ.СуммаВсего,ДокументОбъект.ВалютаДокумента,ДокументОбъект.КурсДокумента,ВалютаРегл,КурсРегл);
				НоваяЗапись.СуммаНДС = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СтрокаТЧ.СуммаНДС,ДокументОбъект.ВалютаДокумента,ДокументОбъект.КурсДокумента,ВалютаРегл,КурсРегл);
				НоваяЗапись.СуммаУпр = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СтрокаТЧ.СуммаВсего,ДокументОбъект.ВалютаДокумента,ДокументОбъект.КурсДокумента,ВалютаУпр,КурсУпр);
			КонецЕсли;
			НоваяЗапись.Себестоимость = 0;
			НоваяЗапись.СуммаНДСВходящий = 0;
			НоваяЗапись.СебестоимостьУпр = 0;
		Иначе
			НоваяЗапись.Сумма = 0;
			НоваяЗапись.СуммаНДС = 0;
			НоваяЗапись.СуммаУпр = 0;
			Если ПересчитаныСуммы Тогда
				НоваяЗапись.Себестоимость = СтрокаТЧ.Сумма;
				НоваяЗапись.СуммаНДСВходящий = СтрокаТЧ.СуммаНДС;
				НоваяЗапись.СебестоимостьУпр = СтрокаТЧ.СуммаУпр;
			Иначе
				НоваяЗапись.Себестоимость = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СтрокаТЧ.Сумма,ДокументОбъект.ВалютаДокумента,ДокументОбъект.КурсДокумента,ВалютаРегл,КурсРегл);
				НоваяЗапись.СуммаНДСВходящий = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СтрокаТЧ.СуммаНДС,ДокументОбъект.ВалютаДокумента,ДокументОбъект.КурсДокумента,ВалютаРегл,КурсРегл);
				НоваяЗапись.СебестоимостьУпр = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(СтрокаТЧ.Сумма,ДокументОбъект.ВалютаДокумента,ДокументОбъект.КурсДокумента,ВалютаУпр,КурсУпр);
			КонецЕсли;
		КонецЕсли;
		
		НоваяЗапись.ХозОперация = ДокументОбъект.ХозОперация;
	КонецЦикла; 
	
	// Убиваем циклическую ссылку
	ДокументОбъект=Неопределено;
	ДатаВыполнения=Неопределено;
	ЗаказНаряд=Неопределено;
	Контрагент=Неопределено;
	ДоговорВзаиморасчетов=Неопределено;
	РезультатЗапросаПоРаботам=Неопределено;
	РасчетыСКонтрагентами = Неопределено;
	ПересчитаныСуммы = Неопределено;
	ТребуетсяПересчетНДС = Неопределено;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#КонецЕсли