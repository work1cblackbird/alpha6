﻿// Модуль объекта справочника "Подразделения компании"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Рекурсивная функция по поиску балансовых родителей у элемента.
//
// Параметры:
//  Ссылка - "СправочникСсылка.ПодразделенияКомпании" - текущее подразделение компании.
//
// Возвращаемое значение:
//   Ссылка - ссылка на балансового родителя.
// 
Функция НайтиБалансовогоРодителя(ТекущийРодитель)
	
	Если ТекущийРодитель.Пустая() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТекущийРодитель.Балансовое Тогда
		Возврат ТекущийРодитель;
	Иначе
		Возврат НайтиБалансовогоРодителя(ТекущийРодитель.Родитель);
	КонецЕсли;
	
КонецФункции // НайтиБалансовогоРодителя()

// Рекурсивная функция по поиску балансовых подразделений, подчиненных текущему
//
// Параметры:
//  Ссылка - "СправочникСсылка.ПодразделенияКомпании" - текущее подразделение.
//
// Возвращаемое значение:
//   Массив - массив подчиненных подразделений, по которым ведется балансовый учет.
// 
Функция НайтиБалансовыхДетей(Ссылка)
	
	Массив = Новый Массив;
	Если Ссылка.Пустая() Тогда
		Возврат Массив;
	КонецЕсли;
	
	Выборка = Справочники.ПодразделенияКомпании.ВыбратьИерархически(Ссылка);
	Пока Выборка.Следующий() Цикл
		Если Выборка.Балансовое Тогда
			Массив.Добавить(Строка(Выборка));
		КонецЕсли;
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции // НайтиБалансовыхДетей()

#КонецОбласти

#Область ОбработчикиСобытий

// Обработчик события объекта возникает в момент, когда выполняется установка нового номера.
//
// Параметры:
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//  Префикс              - Строка - Префикс, который будет использоваться для генерации номера.
//
Процедура ПриУстановкеНовогоКода(СтандартнаяОбработка, Префикс)
	
	// Вызываем общий обработчик события
	ПрефиксацияОбъектов.ПриУстановкеНовогоКода(ЭтотОбъект, СтандартнаяОбработка, Префикс);
	
КонецПроцедуры // ПриУстановкеНовогоКода()

// Обработчик события заполнения объекта как при создании нового, так и при вводе на основании существующего.
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для формирования наименования/кода нового элемента.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийСправочникаСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыРодителя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Родитель,
		"ОбособленноеПодразделение,ЦифровойИндексОбособленногоПодразделения,КПП");
	
	Если РеквизитыРодителя.ОбособленноеПодразделение = Истина Тогда //  Не убирать. На тестах возникали ситуации с NULL в значении.
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыРодителя);
		
	КонецЕсли;
	
	СпособРаспределенияЗаказовПоУмолчанию = ПредопределенноеЗначение("Перечисление.СпособыРаспределенияЗаказов.Автоматическое");
	СопоставлениеЧерезНоменклатуру = Истина;
	СопоставлениеЧерезАвтомобили = Истина;
	
КонецПроцедуры

// Обработчик события заполнения объекта копированием.
//
// Параметры:
//  ОбъектКопирования - СправочникОбъект - Исходный объект, который является источником копирования.
//
Процедура ПриКопировании(ОбъектКопирования)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийСправочникаСервер.ПриКопировании(ЭтотОбъект, ОбъектКопирования) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ПриКопировании()

// Обработчик события возникающего при необходимости проверки заполнения реквизитов при записи объекта.
//
// Параметры:
//  Отказ                - Булево - Признак отказа от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийСправочникаСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты) Тогда
		Возврат;
	КонецЕсли;
	
	Если Ссылка=Справочники.ПодразделенияКомпании.ОсновноеПодразделение И (НЕ Балансовое) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Корневое подразделение не может быть небалансовым.'"),ЭтотОбъект,"Балансовое",,Отказ);
	КонецЕсли;
	
	// Строгое правило. В одной ветке может быть только одно балансовое подразделение.
	Если (НЕ Ссылка=Справочники.ПодразделенияКомпании.ОсновноеПодразделение) И Балансовое Тогда
		
		// Сначала поднимаемся вверх
		БалансовыйРодитель = НайтиБалансовогоРодителя(Родитель);
		Если (БалансовыйРодитель<>Неопределено) И (БалансовыйРодитель<>Справочники.ПодразделенияКомпании.ОсновноеПодразделение) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru='У подразделения, по которому ведется балансовый учет, не может быть родительских подразделений, по которым также ведется балансовый учет (кроме корневого подразделения). Балансовое подразделение: %1'"),
					БалансовыйРодитель
				),
				ЭтотОбъект,
				"Балансовое"
				,
				Отказ
			);
		КонецЕсли;
		
		// Теперь опускаемся вниз.
		МассивБалансовыхДетей = НайтиБалансовыхДетей(Ссылка);
		Если МассивБалансовыхДетей.Количество()<>0 Тогда
			ПредставлениеБалансовыхДетей = "";
			Для каждого ТекПодразделение Из МассивБалансовыхДетей Цикл
				ПредставлениеБалансовыхДетей = ПредставлениеБалансовыхДетей + ", " + ТекПодразделение;
			КонецЦикла;
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru='У подразделения, по которому ведется балансовый учет, не может быть родительских подразделений, по которым также ведется балансовый учет (кроме корневого подразделения). Балансовое подразделение: %1'"),
					Сред(ПредставлениеБалансовыхДетей, 3)
				),
				ЭтотОбъект,
				"Балансовое",
				,
				Отказ
			);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОсновнойБанковскийСчет) Тогда
		ВладелецСчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОсновнойБанковскийСчет, "Владелец");
		Если НЕ (ВладелецСчета = Ссылка ИЛИ ВладелецСчета = Организация) Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Введен основной банковский счет, который не принадлежит данному подразделению/организации подразделения.'"), ЭтотОбъект,"ОсновнойБанковскийСчет",, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если ОбособленноеПодразделение Тогда
		
		// Проверим корректность КПП
		ОшибкаКПП = "";
		Если НЕ РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(КПП,ОшибкаКПП) Тогда
			ОбщегоНазначения.СообщитьПользователю(ОшибкаКПП);
		КонецЕсли;
		
	КонецЕсли;	
	
	Если Не СопоставлениеЧерезНоменклатуру И Не СопоставлениеЧерезАвтомобили Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru='Укажите один из возможных вариантов сопоставления номенклатуры со справочником базы.'"),
			ЭтотОбъект,
			"СопоставлениеЧерезНоменклатуру",
			,
			Отказ
		);
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Обработчик события возникающего после начала транзакции записи, но до начала записи объекта.
//
// Параметры:
//  Отказ - Булево - Признак отказа от совершения операции.
//
Процедура ПередЗаписью(Отказ)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийСправочникаСервер.ПередЗаписью(ЭтотОбъект, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Ссылка <> Справочники.ПодразделенияКомпании.ОсновноеПодразделение Тогда
		
		// На нулевом уровне может находится только одно подразделение - "Вся компания"
		Если НЕ ЗначениеЗаполнено(Родитель) Тогда
			Родитель = Справочники.ПодразделенияКомпании.ОсновноеПодразделение;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ОбособленноеПодразделение Тогда
		КПП = "";
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("СтароеЗначениеРодителя",Ссылка.Родитель);
	РедактированиеИстории.ПередЗаписью(ЭтотОбъект);
	
	
	Если Не ОтправлятьКакАктОбОказанииУслуг Тогда
		
		ВариантРаспределенияСуммыТоваровПриОтправкеПоЭДО = Неопределено;
		
	КонецЕсли;
	
	Если НастройкаАвтоматическойУстановкиУниверсальногоДокумента.Количество() = 0 Тогда
		Справочники.ПодразделенияКомпании.НастройкаАвтоматическойУстановкиУниверсальногоДокументаПоУмолчанию(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Обработчик события возникающего после записи объекта в базу данных, но до окончания транзакции записи.
//
// Параметры:
//  Отказ - Булево - Признак отказа от совершения операции.
//
Процедура ПриЗаписи(Отказ)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийСправочникаСервер.ПриЗаписи(ЭтотОбъект, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ПриЗаписи()

// Обработчик события возникающего в транзакции удаления перед непосредственным удалением объекта из базы данных.
//
// Параметры:
//  Отказ - Булево - Признак отказа от совершения операции.
//
Процедура ПередУдалением(Отказ)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийСправочникаСервер.ПередУдалением(ЭтотОбъект, Отказ) Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры // ПередУдалением()

#КонецОбласти

#КонецЕсли
