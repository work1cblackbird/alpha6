﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Расширение подсистемы БСП "Печать"
//
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Процедура ДополнитьОбъектыПечати(ОбъектыПечати, МассивИндексов)
	
	ШаблонЗапроса = "ВЫБРАТЬ
	| Элемент.Ссылка КАК Ссылка
	| %2
	| ИЗ "
	+ ОбъектыПечати[0].Метаданные().ПолноеИмя() + " Как Элемент
	| ГДЕ Элемент.Ссылка В ИЕРАРХИИ(&%1)
	|  И НЕ Элемент.ЭтоГруппа";
	
	РазделительЗапроса = "
	|ОБЪЕДИНИТЬ ВСЕ
	|";
	
	ИтоговыйЗапрос = "
	|;
	| ВЫБРАТЬ РАЗЛИЧНЫЕ
	| ВТ.Ссылка КАК Ссылка
	| ИЗ ВТ КАК ВТ";
	
	Запрос = Новый Запрос;
	
	КоличествоЗаписей = МассивИндексов.Количество();
	Индекс = 0;
	Соединения = Новый Массив;
	Для Каждого Элемент Из МассивИндексов Цикл
		Параметр = Строка("Папка" + Индекс);
		Соединения.Добавить(СтрШаблон(ШаблонЗапроса, Параметр, ?(КоличествоЗаписей>1 И Индекс=0, "ПОМЕСТИТЬ ВТ", "")));
		Индекс = Индекс + 1;
		Запрос.УстановитьПараметр(Параметр, ОбъектыПечати[Элемент]);
	КонецЦикла;
	
	Запрос.Текст = СтрСоединить(Соединения, РазделительЗапроса);
	
	Если Индекс > 1 Тогда
		Запрос.Текст = Запрос.Текст + ИтоговыйЗапрос;
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ОбъектыПечати.Добавить(Выборка.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Формирует перечень данных для печати этикеток и ценников номенклатуры
//
// Параметры:
//  Идентификатор - Строка - "Ценники", "Этикетки"
//  ОбъектыПечати - Массив - массив объектов, для которых выплняется операция
//  ЭтоДокумент   - Булево - признак документа
//
// Возвращаемое значение:
//	Строка - Адрес результата во временном хранилище.
//
Функция ПолучитьДанныеДляПечатиЦенниковИЭтикеток(Идентификатор, ОбъектыПечати, ЭтоДокумент = Истина) Экспорт
	
	Если НЕ ЭтоДокумент Тогда 
		МассивИндексов = Новый Массив;
		Для Каждого Элемент Из ОбъектыПечати Цикл
			Если Элемент.ЭтоГруппа Тогда
				МассивИндексов.Добавить(ОбъектыПечати.Найти(Элемент));
			КонецЕсли;
		КонецЦикла;
		
		ОбъектПечати = ОбъектыПечати[0];
		
		Если МассивИндексов.Количество() > 0 Тогда 
			СписокДляСортировки = Новый СписокЗначений();
			СписокДляСортировки.ЗагрузитьЗначения(МассивИндексов);
			СписокДляСортировки.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
			МассивИндексов = СписокДляСортировки.ВыгрузитьЗначения();
			ДополнитьОбъектыПечати(ОбъектыПечати, МассивИндексов);
			Для Каждого Элемент Из МассивИндексов Цикл 
				ОбъектыПечати.Удалить(Элемент);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если Идентификатор = "Ценники" И ЭтоДокумент Тогда
		Возврат Документы[ОбъектыПечати[0].Метаданные().Имя].ПолучитьДанныеДляПечатиЦенников(ОбъектыПечати);
	ИначеЕсли Идентификатор = "Ценники" И НЕ ЭтоДокумент Тогда
		Возврат Справочники[ОбъектПечати.Метаданные().Имя].ПолучитьДанныеДляПечатиЦенников(ОбъектыПечати);
	ИначеЕсли Идентификатор = "Этикетки" И ЭтоДокумент Тогда 
		Возврат Документы[ОбъектыПечати[0].Метаданные().Имя].ПолучитьДанныеДляПечатиЭтикеток(ОбъектыПечати);
	Иначе 
		Возврат Справочники[ОбъектПечати.Метаданные().Имя].ПолучитьДанныеДляПечатиЭтикеток(ОбъектыПечати);
	КонецЕсли;
	
КонецФункции //-Рарус

#КонецОбласти     

#Область СлужебныеПроцедурыИФункции

// +Рарус
Функция ПодготовитьВхДанныеКарточкаКлиента(МассивЭлементов) Экспорт 
	МассивИндексов = Новый Массив;
	Для Каждого Элемент Из МассивЭлементов Цикл
			Если Элемент.ЭтоГруппа Тогда
				МассивИндексов.Добавить(МассивЭлементов.Найти(Элемент));
			КонецЕсли;
	КонецЦикла;
		
	Если МассивИндексов.Количество() > 0 Тогда 
		СписокДляСортировки = Новый СписокЗначений();
	    СписокДляСортировки.ЗагрузитьЗначения(МассивИндексов);
	    СписокДляСортировки.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
	    МассивИндексов = СписокДляСортировки.ВыгрузитьЗначения();	
		Для Каждого Элемент Из МассивИндексов Цикл 
			МассивЭлементов.Удалить(Элемент);
		КонецЦикла;
	КонецЕсли;
	
	ВходныеПараметры = Новый Структура;
	Если МассивЭлементов.Количество() Тогда 
		Ключ = "Контрагенты";
		ВходныеПараметры.Вставить(Ключ,МассивЭлементов);	
	КонецЕсли;
	
	Возврат ВходныеПараметры;
КонецФункции

// Возвращает описание команды по имени элемента формы.
// 
// Возвращаемое значение
//  Структура - строка таблицы из функции КомандыПечатиФормы, преобразованная в структуру.
Функция ОписаниеКомандыПечати(ИмяКоманды, АдресКомандПечатиВоВременномХранилище) Экспорт
	
	КомандыПечати = ПолучитьИзВременногоХранилища(АдресКомандПечатиВоВременномХранилище);
	Для Каждого КомандаПечати Из КомандыПечати.НайтиСтроки(Новый Структура("ИмяКомандыНаФорме", ИмяКоманды)) Цикл
		Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(КомандаПечати);
	КонецЦикла;
	
КонецФункции

#КонецОбласти