﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("СпособУстановкиКурса");
	Результат.Добавить("Наценка");
	Результат.Добавить("ОсновнаяВалюта");
	Результат.Добавить("ФормулаРасчетаКурса");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КодыВалют() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка,
	|	Валюты.Наименование КАК СимвольныйКод,
	|	Валюты.НаименованиеПолное КАК Представление
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.СпособУстановкиКурса <> ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.НаценкаНаКурсДругойВалюты)
	|	И Валюты.СпособУстановкиКурса <> ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.РасчетПоФормуле)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(Запрос.Выполнить().Выгрузить());
	
КонецФункции

#КонецОбласти

#Область ОбновлениеВерсииИБ

// Определяет настройки начального заполнения элементов
//
// Параметры:
//  Настройки - Структура - настройки заполнения
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
//
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;
	
КонецПроцедуры

// Вызывается при начальном заполнении справочника Валюты.
//
// Параметры:
//  КодыЯзыков - Массив - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов
//                                 справочника Валюты.
//  ТабличныеЧасти - Структура - описание табличных частей объекта, где:
//   * Ключ - Строка - имя табличной части;
//   * Значение - ТаблицаЗначений - табличная часть в виде таблицы значений, структуру которой
//                                  необходимо скопировать перед заполнением.
//                                  Например:
//                                    Элемент.Ключи = ТабличныеЧасти.Ключи.Скопировать();
//                                    ЭлементТЧ = Элемент.Ключи.Добавить();
//                                    ЭлементТЧ.ИмяКлюча = "Первичный";
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	ВалютаРубль = Справочники.Валюты.НайтиПоКоду("643");
	Если ВалютаРубль.Пустая() Тогда
		ВалютаРубль 						= Элементы.Добавить();
		ВалютаРубль.Код 					= "643";
		ВалютаРубль.Наименование 			= "RUB";
		ВалютаРубль.НаименованиеПолное 		= НСтр("ru = 'Российский рубль'");
		ВалютаРубль.СпособУстановкиКурса 	= Перечисления.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета;
		ВалютаРубль.ПараметрыПрописи 		= НСтр("ru = 'рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2 знака'");
	КонецЕсли;
	
	ВалютаДоллар = Справочники.Валюты.НайтиПоКоду("840");
	Если ВалютаДоллар.Пустая() Тогда
		ВалютаДоллар 						= Элементы.Добавить();
		ВалютаДоллар.Код 					= "840";
		ВалютаДоллар.Наименование 			= "USD";
		ВалютаДоллар.НаименованиеПолное 	= НСтр("ru = 'Доллар США'");
		ВалютаДоллар.СпособУстановкиКурса 	= Перечисления.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета;
		ВалютаДоллар.ПараметрыПрописи 		= НСтр("ru = 'доллар, доллара, долларов, м, цент, цента, центов, м, 2 знака'");
	КонецЕсли;
	
	ВалютаЕвро = Справочники.Валюты.НайтиПоКоду("978");
	Если ВалютаЕвро.Пустая() Тогда
		ВалютаЕвро 							= Элементы.Добавить();
		ВалютаЕвро.Код 						= "978";
		ВалютаЕвро.Наименование 			= "EUR";
		ВалютаЕвро.НаименованиеПолное 		= НСтр("ru = 'Евро'");
		ВалютаЕвро.СпособУстановкиКурса 	= Перечисления.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета;
		ВалютаЕвро.ПараметрыПрописи 		= НСтр("ru = 'евро, евро, евро, м, цент, цента, центов, м, 2 знака'");
	КонецЕсли;
	
КонецПроцедуры

// Выполняет заполнение параметров прописи
//
Процедура ЗаполнитьПараметрыПрописи() Экспорт
	
	ВалютаРубль = Справочники.Валюты.НайтиПоКоду("643");
	Если Не ВалютаРубль.Пустая() Тогда
		ВалютаРубль = ВалютаРубль.ПолучитьОбъект();
		Если ПустаяСтрока(ВалютаРубль.ПараметрыПрописи) Тогда
			ВалютаРубль.ПараметрыПрописи 	= НСтр("ru = 'рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2 знака'");
			ВалютаРубль.Записать();
		КонецЕсли;
	КонецЕсли;
	
	ВалютаДоллар = Справочники.Валюты.НайтиПоКоду("840");
	Если Не ВалютаДоллар.Пустая() Тогда
		ВалютаДоллар = ВалютаДоллар.ПолучитьОбъект();
		Если ПустаяСтрока(ВалютаДоллар.ПараметрыПрописи) Тогда
			ВалютаДоллар.ПараметрыПрописи = НСтр("ru = 'доллар, доллара, долларов, м, цент, цента, центов, м, 2 знака'");
			ВалютаДоллар.Записать();
		КонецЕсли;
	КонецЕсли;
	
	ВалютаЕвро = Справочники.Валюты.НайтиПоКоду("978");
	Если Не ВалютаЕвро.Пустая() Тогда
		ВалютаЕвро = ВалютаЕвро.ПолучитьОбъект();
		Если ПустаяСтрока(ВалютаЕвро.ПараметрыПрописи) Тогда
			ВалютаЕвро.ПараметрыПрописи = НСтр("ru = 'евро, евро, евро, м, цент, цента, центов, м, 2 знака'");
			ВалютаЕвро.Записать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли