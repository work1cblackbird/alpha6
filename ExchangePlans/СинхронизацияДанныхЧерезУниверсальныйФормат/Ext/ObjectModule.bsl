﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		
		ИспользоватьОтборПоОрганизациям = Ложь;
		РежимВыгрузкиСправочников       = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		РежимВыгрузкиПриНеобходимости   = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		
	Иначе
		
		РежимВыгрузкиПриНеобходимости    = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		
		Если ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" Тогда
			РежимВыгрузкиСправочников    = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		Иначе
			РежимВыгрузкиСправочников    = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
	ИначеЕсли ПравилаОтправкиДокументов = "ИнтерактивнаяСинхронизация" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
	Иначе
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов <> "АвтоматическаяСинхронизация" Тогда
		ИспользоватьОтборПоВидамДокументов = Ложь;
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов = "ИнтерактивнаяСинхронизация" Тогда
		РучнойОбмен = Истина;
	Иначе
		РучнойОбмен = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
		Организации.Очистить();
	ИначеЕсли Организации.Количество() = 0 И ИспользоватьОтборПоОрганизациям Тогда
		ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьОтборПоВидамДокументов И ВидыДокументов.Количество() <> 0 Тогда
		ВидыДокументов.Очистить();
	ИначеЕсли ВидыДокументов.Количество() = 0 И ИспользоватьОтборПоВидамДокументов Тогда
		ИспользоватьОтборПоВидамДокументов = Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВерсияФорматаОбмена) Тогда
		ВерсияФорматаОбмена = "1.6";
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Попытка
		ОбменДаннымиXDTOСервер.ПропускатьОбъектыСОшибкамиПроверкиПоСхеме(Ссылка, ПропускатьНекорректныеОбъектыПриВыгрузке);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьОбъект(ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОбъект(ДанныеЗаполнения)
	
	Если Не ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	
	// настройка отборов
	ДатаНачалаВыгрузкиДокументов = НачалоГода(ТекущаяДатаСеанса());
	ИспользоватьОтборПоОрганизациям = Ложь;
	ИспользоватьОтборПоВидамДокументов = Ложь;
	РучнойОбмен = Ложь;
	ПропускатьНекорректныеОбъектыПриВыгрузке = Истина;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыОперацийДвиженияДенежныхСредств.Ссылка КАК Ссылка
	|ИЗ
	|	Перечисление.ВидыОперацийДвиженияДенежныхСредств КАК ВидыОперацийДвиженияДенежныхСредств
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтатьиДДС.Ссылка КАК Ссылка,
	|	СтатьиДДС.Операция КАК Операция
	|ИЗ
	|	Справочник.СтатьиДДС КАК СтатьиДДС
	|ГДЕ
	|	СтатьиДДС.Предопределенный = ИСТИНА
	|	И СтатьиДДС.ЭтоГруппа = ЛОЖЬ
	|	И НЕ СтатьиДДС.Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийДвиженияДенежныхСредств.ПустаяСсылка)";
	
	Запросы = Запрос.ВыполнитьПакет();
	ВыборкаОперация = Запросы[0].Выбрать(); 
	ВыборкаСтатья = Запросы[1].Выгрузить();
	
	Пока ВыборкаОперация.Следующий() Цикл  
		
		Строка = СоответствиеОперацииИСтатейДДС.Добавить();
		Строка.Операция = ВыборкаОперация.Ссылка;
		Статья =ВыборкаСтатья.Найти(ВыборкаОперация.Ссылка, "Операция");
		Строка.СтатьяДДС = ?(Статья <> Неопределено, Статья.Ссылка, Справочники.СтатьиДДС.ПустаяСсылка());
		
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
