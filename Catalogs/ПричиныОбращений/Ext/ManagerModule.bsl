﻿// Модуль менеджера справочника "Причины обращений"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда    
	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// 	 Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти 

#Область ОбновлениеИБ

// Выполняет заполнение реквизита Тип авторабот значением по умолчанию.
//
Процедура ЗаполнитьТипАвтоработПоУмолчанию() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПричиныОбращений.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПричиныОбращений КАК ПричиныОбращений
	|ГДЕ
	|	ПричиныОбращений.ТипАвторабот = ЗНАЧЕНИЕ(Справочник.ТипыАвторабот.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СправочникОбъект.ОбменДанными.Загрузка = Истина;
		СправочникОбъект.ТипАвторабот = Справочники.ТипыАвторабот.ПоУмолчанию;
		
		Попытка
			
			СправочникОбъект.Записать();
			
		Исключение
			
			ТекстОшибки = НСтр("ru = 'Не удалось обновить: '")
				+ Символы.ПС
				+ ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ЗаписьЖурналаРегистрации(
				"Причины обращений.Заполнение типа авторабот",
				УровеньЖурналаРегистрации.Ошибка,
				,
				Выборка.Ссылка,
				ТекстОшибки
			);
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Источник = ПолучитьЗначениеПараметраСтруктуры(Параметры, "Источник", "");
	
	Если Источник = "ЗаявкаНаРемонт_ПричинаОбращения" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПричиныОбращений.Ссылка
		|ИЗ
		|	Справочник.ПричиныОбращений КАК ПричиныОбращений
		|ГДЕ
		|	(ПричиныОбращений.Наименование ПОДОБНО &Наименование СПЕЦСИМВОЛ ""~""
		|			ИЛИ ПричиныОбращений.ПричинаОбращения ПОДОБНО &ПричинаОбращения СПЕЦСИМВОЛ ""~"")
		|	И ПричиныОбращений.ЗапретитьВыбор = ЛОЖЬ";
		
		СтрокаПоиска = ОбщегоНазначения.СформироватьСтрокуДляПоискаВЗапросе(Параметры.СтрокаПоиска);
		Запрос.УстановитьПараметр("Наименование"     , СтрокаПоиска + "%");
		Запрос.УстановитьПараметр("ПричинаОбращения" , "%" + СтрокаПоиска + "%");
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирование причины обращения в виде строки
//
// Параметры
//  СтараяПричинаОбращения  - <Строка> - Старая причина обращения
//                 <продолжение описания параметра>
//  НоваяПричинаОбращения  - <ПричиныОбращений.Ссылка>,<Массив> - Новая причина обращения.
//
// Возвращаемое значение:
//   <Строка>   - Новая причина обращения.
//
Функция СформироватьПричинуОбращения(НоваяПричинаОбращения, СтараяПричинаОбращения = "") Экспорт
	Если ТипЗнч(НоваяПричинаОбращения) = Тип("СправочникСсылка.ПричиныОбращений") Тогда
		МассивПричинОбращения = Новый Массив;
		МассивПричинОбращения.Добавить(НоваяПричинаОбращения);
	ИначеЕсли ТипЗнч(НоваяПричинаОбращения) = Тип("Массив") И НоваяПричинаОбращения.Количество() > 0 Тогда
		МассивПричинОбращения = НоваяПричинаОбращения;
	Иначе
		Возврат СтараяПричинаОбращения;
	КонецЕсли;
	
	НоваяПричинаОбращения = СокрЛП(СтараяПричинаОбращения);
	Для Каждого ПричинаОбращения Из МассивПричинОбращения Цикл
		ПричинаОбращенияАртикул          = СокрЛП(ПричинаОбращения.Артикул);
		ПричинаОбращенияПричинаОбращения = СокрЛП(ПричинаОбращения.ПричинаОбращения);
		
		Если НЕ ПустаяСтрока(НоваяПричинаОбращения) Тогда
			НоваяПричинаОбращения = НоваяПричинаОбращения + Символы.ВК;
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(ПричинаОбращенияАртикул) Тогда
			НоваяПричинаОбращения = НоваяПричинаОбращения + "[" + ПричинаОбращенияАртикул + "] ";
		КонецЕсли;
		
		НоваяПричинаОбращения = НоваяПричинаОбращения + ПричинаОбращенияПричинаОбращения;
	КонецЦикла;
	
	Возврат НоваяПричинаОбращения;
КонецФункции // СформироватьПричинуОбращения()

// Формирует массив причин обращения запрещенных к выбору в документах
//
Функция ПолучитьЗапрещенныеКВыборуПричины() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПричиныОбращений.Ссылка
	|ИЗ
	|	Справочник.ПричиныОбращений КАК ПричиныОбращений
	|ГДЕ
	|	ПричиныОбращений.ЗапретитьВыбор = ИСТИНА";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

#Область ПараметрыОбработкиРеквизитовОбъекта

// Производит формирование параметров проверки заполнения реквизитов объекта на предмет обязательности.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - Объект, для которого выполняется получение параметров проверки.
//
// Возвращаемое значение:
//  Массив - Возвращаемый массив содержит строковые идентификаторы реквизитов.
//
Функция ПолучитьОбязательныеРеквизиты(Объект) Экспорт
	
	// Обязательные реквизиты объекта
	ОбязательныеРеквизиты = Новый Массив();
	ОбязательныеРеквизиты.Добавить("Наименование");
	
	// Обработаем в зависимости от вида элемента
	Если НЕ Объект.ЭтоГруппа Тогда
		ОбязательныеРеквизиты.Добавить("ПричинаОбращения");
		Если Автосервис.АртикулОбязательный() Тогда
			ОбязательныеРеквизиты.Добавить("Артикул");
		КонецЕсли;
	КонецЕсли;
	
	// Возвращаем сформированные параметры проверки
	Возврат ОбязательныеРеквизиты;
	
КонецФункции // ПолучитьОбязательныеРеквизиты()

// Производит формирование параметров проверки заполнения реквизитов объекта на предмет обязательности и уникальности.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - Объект, для которого выполняется получение параметров проверки.
//
// Возвращаемое значение:
//  Структура - Возвращаемая структура содержит строковые идентификаторы реквизитов и вариант проверки его заполнения
//  (1-Обязательный, 2-Уникальный, 3-Уникальный и обязательный). Для описания проверки табличных частей используется
//  вложенная структура.
//
Функция ПолучитьУникальныеРеквизиты(Объект) Экспорт
	
	// Структура уникальных реквизитов
	УникальныеРеквизиты = Новый Структура();
	УникальныеРеквизиты.Вставить("Код");
	
	Если НЕ Объект.ЭтоГруппа Тогда
		РежимКонтроля = Автосервис.РежимКонтроляУникальностиАртикула();
		Если РежимКонтроля <> Перечисления.РежимыКонтроляУникальностиНомераПоКаталогу.НеКонтролировать Тогда
			УникальныеРеквизиты.Вставить("Артикул");
		КонецЕсли;
	КонецЕсли;
	
	// Возвращаем сформированные параметры проверки
	Возврат УникальныеРеквизиты;
	
КонецФункции // ПолучитьОбязательныеРеквизиты()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Обработчик события возникающего при изменении данных реквизита "Наименование".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура НаименованиеПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	Если ПустаяСтрока(СокрЛП(Объект.ПричинаОбращения)) Тогда
		Объект.ПричинаОбращения = Объект.Наименование;
	КонецЕсли;
	
КонецПроцедуры // НаименованиеПриИзменении()

#КонецОбласти

#КонецОбласти

#КонецЕсли
