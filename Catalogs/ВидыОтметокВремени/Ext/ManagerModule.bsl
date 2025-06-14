﻿// Модуль менеджера справочника "Виды отметок времени"

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
	Элемент.ИмяПредопределенныхДанных = "НерабочееВремя";
	Элемент.Код                       = "00000003";
	Элемент.Наименование              = НСтр("ru = 'Нерабочее время'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Цвет                      = Новый ХранилищеЗначения(Новый Цвет(255, 255, 255));
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ОтклонениеОтПлана";
	Элемент.Код                       = "00000004";
	Элемент.Наименование              = НСтр("ru = 'Отклонение от плана'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Цвет                      = Новый ХранилищеЗначения(Новый Цвет(250, 181, 181));
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Простой";
	Элемент.Код                       = "00000002";
	Элемент.Наименование              = НСтр("ru = 'Простой'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Цвет                      = Новый ХранилищеЗначения(Новый Цвет(255, 255, 180));
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Работа";
	Элемент.Код                       = "00000001";
	Элемент.Наименование              = НСтр("ru = 'Работа по заказ-наряду'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Цвет                      = Новый ХранилищеЗначения(ЦветаСтиля.ОтметкаВремениРабота);
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РаботаПоУдаленномуПакету";
	Элемент.Код                       = "00000005";
	Элемент.Наименование              = НСтр("ru = 'Работа по удаленному пакету'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Цвет                      = Новый ХранилищеЗначения(ЦветаСтиля.ОтметкаВремениРабота);

КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЦветаВидовОтметокВремени() Экспорт
	
	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыОтметокВремени.Ссылка КАК Ссылка,
	|	ВидыОтметокВремени.Цвет КАК Цвет
	|ИЗ
	|	Справочник.ВидыОтметокВремени КАК ВидыОтметокВремени
	|ГДЕ
	|	НЕ ВидыОтметокВремени.ЭтоГруппа";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			Результат.Вставить(Выборка.Ссылка, Выборка.Цвет.Получить());
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
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
	
	// Обязательные реквизиты документа
	ОбязательныеРеквизиты = Новый Массив();
	ОбязательныеРеквизиты.Добавить("Наименование");
	
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
	
	// Возвращаем сформированные параметры проверки
	Возврат УникальныеРеквизиты;
	
КонецФункции // ПолучитьОбязательныеРеквизиты()

#КонецОбласти 

#КонецОбласти

#КонецЕсли