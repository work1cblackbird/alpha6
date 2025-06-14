﻿// Модуль менеджера справочника "Типы скидок"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

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

// Вызывается при начальном заполнении справочника Организации.
//
// Параметры:
//  КодыЯзыков - Массив - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов
//                                 справочника.
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
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Ограничение";
	Элемент.Код = "000000001";
	Элемент.Наименование = НСтр("ru = 'Ограничение скидки для POS'");
	Элемент.СпособВычисления = Перечисления.СкидкиСпособВычисления.Относительная;
	Элемент.ВидСкидки = Перечисления.ВидыСкидок.НаДокумент;
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "НеНайдена";
	Элемент.Код = "000000002";
	Элемент.Наименование = НСтр("ru = 'Скидка не найдена'");
	Элемент.СпособВычисления = Перечисления.СкидкиСпособВычисления.Относительная;
	Элемент.ВидСкидки = Перечисления.ВидыСкидок.НаДокумент;
	
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// 	 Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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
		ОбязательныеРеквизиты.Добавить("СпособВычисления");
		ОбязательныеРеквизиты.Добавить("ВидСкидки");
	КонецЕсли;
	
	// Возвращаем сформированные параметры проверки
	Возврат ОбязательныеРеквизиты;
	
КонецФункции // ПолучитьОбязательныеРеквизиты()

// Производит формирование параметров проверки заполнения реквизитов объекта на предмет уникальности.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - Объект, для которого выполняется получение параметров проверки.
//
// Возвращаемое значение:
//  Структура - Возвращаемая структура содержит строковые идентификаторы реквизитов.
//  Для описания проверки табличных частей используется
//  вложенная структура.
//
Функция ПолучитьУникальныеРеквизиты(Объект) Экспорт
	
	// Структура уникальных реквизитов
	УникальныеРеквизиты = Новый Структура();
	УникальныеРеквизиты.Вставить("Код");
	
	// Возвращаем сформированные параметры проверки
	Возврат УникальныеРеквизиты;
	
КонецФункции // ПолучитьОбязательныеРеквизиты()

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ФлагВытеснения");
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Функция формирования наименования.
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнении операции.
//
Функция СформироватьНаименованиеПоУмолчанию(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	Если Объект.Предопределенный Тогда
		Возврат Объект.Наименование;
	КонецЕсли;
	
	НовоеНаименование = "";
	
	Если ЗначениеЗаполнено(Объект.СпособВычисления) И ЗначениеЗаполнено(Объект.РучнаяСкидка) Тогда
		
		НовоеНаименование = ?(Объект.СпособВычисления=Перечисления.СкидкиСпособВычисления.Относительная, "Относительная", "Абсолютная");
		НовоеНаименование = НовоеНаименование + ?(Объект.РучнаяСкидка, " ручная"," автоматическая");
		НовоеНаименование = НовоеНаименование + ?(Объект.ФлагВытеснения, " вытесняющая", "");
		НовоеНаименование = НовоеНаименование + " скидка";
		
	КонецЕсли;
	
	Возврат НовоеНаименование;
	
КонецФункции // СформироватьНаименованиеПоУмолчанию()

#КонецОбласти

#Область ЗапретРедактированияРеквизитовОбъектов

// См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
    
    Результат = Новый Массив();
    Результат.Добавить("ФлагВытеснения");
    Возврат Результат;
    
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли