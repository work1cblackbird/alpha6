﻿// Модуль объекта документа "Перемещение незавершенного производства"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Производит заполнение объекта на основании документа "Приходный складской ордер"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Обработчик события объекта возникает в момент, когда выполняется установка нового номера.
//
// Параметры:
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//  Префикс              - Строка - Префикс, который будет использоваться для генерации номера.
//
Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	// Вызываем общий обработчик события
	ПрефиксацияОбъектов.ПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
	
КонецПроцедуры // ПриУстановкеНовогоНомера()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения = "", СтандартнаяОбработка = Истина)
	
	// Вызываем общий обработчик события
	ПродолжитьВыполнение = ОбработкаСобытийДокументаСервер.ОбработкаЗаполнения(
		ЭтотОбъект,
		ДанныеЗаполнения,
		ТекстЗаполнения,
		СтандартнаяОбработка
	);
	Если НЕ ПродолжитьВыполнение Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаДокумента = Константы.ВалютаУправленческогоУчетаКомпании.Получить();
	Документы.ПеремещениеНезавершенногоПроизводства.ВалютаДокументаПриИзменении(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(Цех) Тогда
		Цех = ПраваИНастройкиПользователя.Значение("ОсновнойЦех", ЭтотОбъект);
	КонецЕсли;
	
	// Заполним доп. поля для товарной строки
	Для Каждого СтрокаТовар Из Товары Цикл
		Если ПустаяСтрока(СтрокаТовар.ИдентификаторТовара) Тогда
			СтрокаТовар.ИдентификаторТовара = Новый УникальныйИдентификатор;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ОбработкаЗаполнения()

// Обработчик события заполнения объекта копированием.
//
// Параметры:
//  ОбъектКопирования - ДокументОбъект - Исходный объект, который является источником копирования.
//
Процедура ПриКопировании(ОбъектКопирования)
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ПриКопировании(ЭтотОбъект, ОбъектКопирования) Тогда
		Возврат;
	КонецЕсли;
	
	КодыМаркировки.Очистить();
	
КонецПроцедуры // ПриКопировании()

// Обработчик события возникающего при необходимости проверки заполнения реквизитов при записи или при проведении.
//
// Параметры:
//  Отказ                - Булево - Признак отказа от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Предварительно проверим ТЧ Коды маркировки
	МаркировкаТоваровСервер.ПроверкаКодовМаркировкиПередЗаписью(ЭтотОбъект);
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты) Тогда
		Возврат;
	КонецЕсли;
	
	Если БалансВедетсяПоОрганизациям(Дата) Тогда
		Если ЦехПолучатель.Организация <> ЗаказНаряд.Организация Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Организация цеха <%1> не соответствует организации заказ-наряда.'"),
					ЦехПолучатель
				)
			);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Проверим заполнение ТЧ Коды маркировки
	МаркировкаТоваровСервер.ПроверитьЗаполнениеКодовМаркировки(ЭтотОбъект, Отказ, , , Истина);
	
	// Проверим заполнение РНПТ у послеживаемого товара
	УчетПрослеживаемыхТоваровСервер.ПроверитьЗаполнениеРНПТПрослеживаемогоТовара(ЭтотОбъект);
	
КонецПроцедуры

// Обработчик события возникающего после начала транзакции записи, но до начала записи объекта.
//
// Параметры:
//  Отказ           - Булево                   - Признак отказа от совершения операции.
//  РежимЗаписи     - РежимЗаписиДокумента     - Текущий режим записи документа.
//  РежимПроведения - РежимПроведенияДокумента - Текущий режим проведения.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// УтверждениеДокумментов
	УтверждениеДокументовСервер.ОбработкаУтвержденияПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	// Конец УтверждениеДокументов
	
	// Вызываем общий обработчик события
	Если НЕ ОбработкаСобытийДокументаСервер.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения) Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Если ДокументОснование.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Выполнен
			ИЛИ ДокументОснование.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Закрыт Тогда
			Если НЕ Проведен Тогда
				ОбщегоНазначения.СообщитьПользователю(
					НСтр("ru = 'Заказ-наряд источник выполнен или закрыт. Перемещение деталей в производстве запрещено.'")
				);
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
		Если ЗаказНаряд.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Выполнен
			ИЛИ ЗаказНаряд.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Закрыт Тогда
			Если НЕ Проведен Тогда
				ОбщегоНазначения.СообщитьПользователю(
					НСтр("ru = 'Заказ-наряд приемник выполнен или закрыт. Перемещение деталей в производстве запрещено.'")
				);
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Отработаем право "Запись раньше документа-основания"
	Если (Дата < ДокументОснование.Дата) Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Заказ-наряд № %1 от %2'"),
			СокрЛП(ДокументОснование.Номер),
			Формат(ДокументОснование.Дата, "ДЛФ=DT")
		);
		Если ПраваИНастройкиПользователя.Значение("ЗаписьРаньшеДокументаОснования", ЭтотОбъект) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru='Внимание! Документ <%1> записывается раньше создания своего документа-основания: <%2>'"),
					Строка(ЭтотОбъект),
					ТекстСообщения
				)
			);
		Иначе
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru='Нет прав на запись раньше создания чем документ-основание: <%1>'"),
					ТекстСообщения
				)
			);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	ИначеЕсли (ДокументОснование.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Закрыт)
		И (Дата > ДокументОснование.ДатаОкончания) Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Заказ-наряд № %1 от %2'"),
			СокрЛП(ДокументОснование.Номер),
			Формат(ДокументОснование.ДатаОкончания, "ДЛФ=DT")
		);
		Если ПраваИНастройкиПользователя.Значение("ЗаписьРаньшеДокументаОснования", ЭтотОбъект) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Внимание! Документ <%1> записывается позже окончания своего документа-основания: <%2>'"),
					Строка(ЭтотОбъект),
					ТекстСообщения
				)
			);
		Иначе
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Нет прав на запись позже окончания чем документ-основание: <%1>'"),
					ТекстСообщения
				)
			);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Если (Дата < ЗаказНаряд.Дата) Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Заказ-наряд № %1 от %2'"),
			СокрЛП(ЗаказНаряд.Номер),
			Формат(ЗаказНаряд.Дата, "ДЛФ=DT")
		);
		Если ПраваИНастройкиПользователя.Значение("ЗаписьРаньшеДокументаОснования", ЭтотОбъект) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Внимание! Документ <%1> записывается раньше создания своего документа-основания: <%2>'"),
					Строка(ЭтотОбъект),
					ТекстСообщения
				)
			);
		Иначе
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Нет прав на запись раньше создания чем документ-основание: <%1>'"),
					ТекстСообщения
				)
			);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	ИначеЕсли (ЗаказНаряд.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Закрыт)
		И (Дата > ЗаказНаряд.ДатаОкончания) Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Заказ-наряд № %1 от %2'"),
			СокрЛП(ЗаказНаряд.Номер),
			Формат(ЗаказНаряд.ДатаОкончания, "ДЛФ=DT")
		);
		Если ПраваИНастройкиПользователя.Значение("ЗаписьРаньшеДокументаОснования", ЭтотОбъект) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Внимание! Документ <%1> записывается позже окончания своего документа-основания: <%2>'"),
					Строка(ЭтотОбъект),
					ТекстСообщения
				)
			);
		Иначе
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Нет прав на запись позже окончания чем документ-основание: <%1>'"),
					ТекстСообщения
				)
			);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПраваИНастройкиПользователя.Значение("ПеремещениеДеталейВПроизводство", ЭтотОбъект) Тогда
		Если РежимЗаписи = РежимЗаписиДокумента.Проведение ИЛИ РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Нет прав на перемещение деталей в производстве!%1Обратитесь к администратор системы.'"),
					Символы.ПС
				)
			);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если (НЕ Отказ) И (РежимЗаписи <> РежимЗаписиДокумента.Проведение) Тогда
		СуммаДокумента = 0;
	КонецЕсли;	
	
	РаботаСГраницами.МоментВремениПередПроведением(Ссылка, ДополнительныеСвойства);
	РаботаСГраницами.ДвиженияПоПроизводствуПередПроведением(Ссылка, ДополнительныеСвойства);
	
КонецПроцедуры

// Обработчик события возникающего после записи объекта в базу данных, но до окончания транзакции записи.
//
// Параметры:
//  Отказ - Булево - Признак отказа от совершения операции.
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// УтверждениеДокумментов
	УтверждениеДокументовСервер.ОбработкаУтвержденияПриЗаписи(ЭтотОбъект, Отказ);
	// Конец УтверждениеДокументов
	
КонецПроцедуры

// Обработчик события возникающего в транзакции удаления перед непосредственным удалением объекта из базы данных.
//
// Параметры:
//  Отказ - Булево - Признак отказа от совершения операции.
//
Процедура ПередУдалением(Отказ)
	
	Если НЕ ОбработкаСобытийДокументаСервер.ПередУдалением(ЭтотОбъект, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события возникающего при отмене проведения документа. Выполняется в транзакции записи.
//
// Параметры:
//  Отказ - Булево - Признак отказа от совершения операции.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		СуммаДокумента = 0;
		СуммаСписанияИндикатор = 0;
		СуммаСписанияБезНДСИндикатор = 0;
	КонецЕсли;

	
	Если ДокументОснование.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Выполнен
		ИЛИ ДокументОснование.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Закрыт Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Заказ-наряд источник выполнен или закрыт. Отмена перемещения в производстве запрещена.'")
		);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Если ЗаказНаряд.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Выполнен
		ИЛИ ЗаказНаряд.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Закрыт Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Заказ-наряд приемник выполнен или закрыт. Отмена перемещения в производстве запрещена.'")
		);
		Отказ = Истина; 
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события возникающего в транзакции записи для формирования движений документу по подчиненным регистрам.
//
// Параметры:
//  Отказ           - Булево                   - Признак отказа от совершения операции.
//  РежимПроведения - РежимПроведенияДокумента - Текущий режим проведения.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения) Тогда
		Возврат;
	КонецЕсли;
	
	// Проведем партии товаров
	Отказ = НЕ ПровестиПоПартиям(РежимПроведения, Ссылка) ИЛИ Отказ;
	
	Если НЕ Отказ Тогда
		СуммаДокумента = Документы.ПеремещениеНезавершенногоПроизводства.РассчитатьИтогиОперации(ЭтотОбъект).СуммаДокумента;
		
		СуммыСписания = ЗащищенныеФункцииСервер.ПолучитьРеквизитыСуммСписанияВДокументе(ЭтотОбъект, "ТоварыВПроизводстве");
		
		Если СуммаСписанияИндикатор <> СуммыСписания.СуммаСписания Тогда
			СуммаСписанияИндикатор = СуммыСписания.СуммаСписания;
		КонецЕсли;
		Если СуммаСписанияБезНДСИндикатор <> СуммыСписания.СуммаСписанияБезНДС Тогда
			СуммаСписанияБезНДСИндикатор = СуммыСписания.СуммаСписанияБезНДС;
		КонецЕсли;
		
		ОбменДанными.Загрузка = Истина;
		Записать(РежимЗаписиДокумента.Запись);
		ОбменДанными.Загрузка = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиЗаполненияОбъекта

// Производит заполнение объекта на основании документа "Заказ наряд"
//
// Параметры:
//  ДанныеЗаполнения     - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения      - Строка       - Текст, используемый для заполнения объекта.
//  СтандартнаяОбработка - Булево       - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - Признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаполнения_ЗаказНаряд(ДанныеЗаполнения, ТекстЗаполнения = "", СтандартнаяОбработка = Истина) Экспорт

	Если Не ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	ПродолжитьВыполнение = ОбработкаСобытийДокументаСервер.ОбработкаЗаполненияНаОсновании(
		ЭтотОбъект,
		ДанныеЗаполнения,
		ТекстЗаполнения,
		СтандартнаяОбработка
	);
	
	Если Не ПродолжитьВыполнение Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Документы
		.ПеремещениеНезавершенногоПроизводства
		.ЗаполнитьТоваромВПроизводствеПоЗаказНаряду(ЭтотОбъект, ДополнительныеСвойства.ПараметрыДействия);
	
	Возврат Истина;
	
КонецФункции // ОбработкаЗаполнения_ЗаказНаряд()

#КонецОбласти

#Область ФормированиеДвиженийДокумента

// Формирует движения документа по партионным регистрам
// Режим - режим проведения (оперативный/неоперативный)
// ДокументСсылка - ссылка на документ который надо допровести по партиям
// Возвращает Истина - все хорошо, ложь - чего-то не так.
Функция ПровестиПоПартиям(Режим, ДокументСсылка) Экспорт
	Отказ = Ложь;
	
	// Получим шапку документа
	ШапкаДокумента = ПолучитьШапкуДокумента(ДокументСсылка);
	
	// Очистим возможные движения по производственному регистру, 
	// если было отложенное проведение по партиям.
	НаборЗаписейТоварыВПроизводстве = РегистрыНакопления.ТоварыВПроизводстве.СоздатьНаборЗаписей();
	НаборЗаписейТоварыВПроизводстве.Отбор.Регистратор.Значение = ШапкаДокумента.Ссылка;
	НаборЗаписейТоварыВПроизводстве.Отбор.Регистратор.Использование = Истина;
	НаборЗаписейТоварыВПроизводстве.Записать();
	
	// Проверим, если подразделение проводиться по партиям "отложенно", то дальше не идем.
	НаборЗаписейДопроведениеПоПартиям = Движения.ДопроведениеПоПартиям;
	НаборЗаписейДопроведениеПоПартиям.ДокументОбъект = ЭтотОбъект;
	НаборЗаписейДопроведениеПоПартиям.ШапкаДокумента = ШапкаДокумента;
	Если НЕ НаборЗаписейДопроведениеПоПартиям.Зафиксировать() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	// БАЛАНС: Если происходит перемещение товаров между складами подразделений, принадлежащих
	// различным балансовым "веткам", то возможен разрыв баланса.
	ДобавлятьКорректирующиеЗаписи = БалансВедетсяПоПодразделениям(ШапкаДокумента.Дата);
	ПодразделениеОтправителя = Справочники.ПодразделенияКомпании.ПолучитьБалансовоеПодразделение(
		ШапкаДокумента.ПодразделениеОтправителя,
		ШапкаДокумента.Дата
	);
	ПодразделениеПолучатель = Справочники.ПодразделенияКомпании.ПолучитьБалансовоеПодразделение(
		ШапкаДокумента.ПодразделениеПолучателя,
		ШапкаДокумента.Дата
	);
	ДобавлятьКорректирующиеЗаписи = ДобавлятьКорректирующиеЗаписи И (ПодразделениеОтправителя <> ПодразделениеПолучатель);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТоварыВПроизводствеОстатки.Цех КАК Цех,
	               |	ТоварыВПроизводствеОстатки.Номенклатура КАК Номенклатура,
	               |	ТоварыВПроизводствеОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	               |	ТоварыВПроизводствеОстатки.СтатусПартии КАК СтатусПартии,
	               |	ТоварыВПроизводствеОстатки.Партия КАК Партия,
	               |	ТоварыВПроизводствеОстатки.Партия.Дата КАК ПартияДата,
	               |	ТоварыВПроизводствеОстатки.ГТД КАК ГТД,
				   |	ТоварыВПроизводствеОстатки.Организация КАК Организация,
	               |	ЕСТЬNULL(ТоварыВПроизводствеОстатки.КоличествоОстаток, 0) КАК Количество,
	               |	ЕСТЬNULL(ТоварыВПроизводствеОстатки.СуммаОстаток, 0) КАК Сумма,
	               |	ЕСТЬNULL(ТоварыВПроизводствеОстатки.СуммаНДСОстаток, 0) КАК СуммаНДС,
	               |	ЕСТЬNULL(ТоварыВПроизводствеОстатки.СуммаБезНДСОстаток, 0) КАК СуммаБезНДС,
	               |	ЕСТЬNULL(ТоварыВПроизводствеОстатки.СуммаУпрОстаток, 0) КАК СуммаУпр,
	               |	ЕСТЬNULL(ТоварыВПроизводствеОстатки.СуммаНДСУпрОстаток, 0) КАК СуммаНДСУпр,
	               |	ЕСТЬNULL(ТоварыВПроизводствеОстатки.СуммаБезНДСУпрОстаток, 0) КАК СуммаБезНДСУпр,
	               |	ТоварыВПроизводствеОстатки.СкладИсточник КАК СкладИсточник
	               |ИЗ
	               |	РегистрНакопления.ТоварыВПроизводстве.Остатки(
	               |			&НаМомент,
	               |			ЗаказНаряд = &ЗаказНаряд
	               |				И Цех = &Цех
	               |				И (&БезФильтраПоОрганизации
	               |					ИЛИ Организация = &Организация)) КАК ТоварыВПроизводствеОстатки
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ТоварыВПроизводствеОстатки.ХарактеристикаНоменклатуры УБЫВ,
	               |	ТоварыВПроизводствеОстатки.Партия УБЫВ,
	               |	ТоварыВПроизводствеОстатки.ГТД УБЫВ
	               |ИТОГИ
	               |	СУММА(Количество),
	               |	СУММА(Сумма),
	               |	СУММА(СуммаНДС),
	               |	СУММА(СуммаБезНДС),
	               |	СУММА(СуммаУпр),
	               |	СУММА(СуммаНДСУпр),
	               |	СУММА(СуммаБезНДСУпр)
	               |ПО
	               |	Номенклатура";
	Запрос.УстановитьПараметр("НаМомент", ШапкаДокумента.МоментВремени);
	Запрос.УстановитьПараметр("ЗаказНаряд", ШапкаДокумента.ДокументОснование.Ссылка);
	Запрос.УстановитьПараметр("Цех", ШапкаДокумента.Цех);
	Запрос.УстановитьПараметр("БезФильтраПоОрганизации", ЗапасыТоваров.ФильтрЗапросаПоОрганизации(ШапкаДокумента.МоментВремени.Дата));
	Запрос.УстановитьПараметр("Организация", ШапкаДокумента.Организация);
	ТабВПроизводстве = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	// Извлечение товаров из производства
	НаборЗаписейТоварыВПроизводстве = Движения.ТоварыВПроизводстве;
	ВремТовары = ШапкаДокумента.Ссылка.Товары.Выгрузить();
	ВремТовары.Сортировать("Партия Убыв, ГТД Убыв");
	
	// Получим таблицу номенклатуры с ручным списанием характеристик
	ТаблицаРучныхХарактеристик =
		ОбработкаТабличнойЧастиТовары.ПолучитьНоменклатуруСРучнымСписаниемХарактеристик(ШапкаДокумента.Ссылка);
	
	Для каждого СтрокаТоваров Из ВремТовары Цикл
		НадоСписать = Окр(СтрокаТоваров.Количество * СтрокаТоваров.Коэффициент, 3);
		// Инициализируем переменные для расчета усредненной цены списанных партий
		ОбщееКоличество = 0;
		ОбщаяСумма = 0;
		ОбщаяСуммаНДС = 0;
		ОбщаяСуммаБезНДС = 0;
		ОбщаяСуммаУпр = 0;
		ОбщаяСуммаНДСУпр = 0;
		ОбщаяСуммаБезНДСУпр = 0;
		// Получим строки таблицы партий с нашим товаром
		СтрокаПартийНоменклатуры = ТабВПроизводстве.Строки.Найти(СтрокаТоваров.Номенклатура, "Номенклатура");
		Если СтрокаПартийНоменклатуры <> Неопределено Тогда
			СтруктураОтбора = Новый Структура("Номенклатура", СтрокаТоваров.Номенклатура);
			Если
				ЗначениеЗаполнено(СтрокаТоваров.ХарактеристикаНоменклатуры)
				ИЛИ (ТаблицаРучныхХарактеристик <> Неопределено
					И ТаблицаРучныхХарактеристик.Найти(СтрокаТоваров.Номенклатура, "Номенклатура") <> Неопределено)
			Тогда 
				СтруктураОтбора.Вставить("ХарактеристикаНоменклатуры", СтрокаТоваров.ХарактеристикаНоменклатуры);
			КонецЕсли;
			МассивНайденныхСтрок = СтрокаПартийНоменклатуры.Строки.НайтиСтроки(СтруктураОтбора);
			// Теперь идем по партиям товаров и списываем в соответствии с выбранной стратегией
			Для Сч = 0 По МассивНайденныхСтрок.ВГраница() Цикл
				ТекСтрока = МассивНайденныхСтрок[Сч];
				// Проверки на нулевую партию или партию отрицательных остатков
				Если ТекСтрока.Количество = NULL ИЛИ ТекСтрока.Количество = 0 Тогда
					Продолжить;
				КонецЕсли;
				// Если указаны партии, то пропустим все партии не наши
				Если ЗначениеЗаполнено(СтрокаТоваров.Партия) И ТекСтрока.Партия <> СтрокаТоваров.Партия Тогда
					Продолжить;
				КонецЕсли;
				// Если указаны ГТД, то пропустим все ГТД не наши
				Если ЗначениеЗаполнено(СтрокаТоваров.ГТД) И ТекСтрока.ГТД <> СтрокаТоваров.ГТД Тогда
					Продолжить;
				КонецЕсли;
				НоваяЗапись = НаборЗаписейТоварыВПроизводстве.Добавить();
				НоваяЗапись.ВидДвижения = ВидДвиженияНакопления.Расход;
				НоваяЗапись.Период = ШапкаДокумента.Дата;
				НоваяЗапись.Регистратор = ШапкаДокумента.Ссылка;
				НоваяЗапись.ЗаказНаряд = ШапкаДокумента.ДокументОснование.Ссылка;
				НоваяЗапись.Цех = ШапкаДокумента.Цех;
				НоваяЗапись.Организация = ЗапасыТоваров.ОрганизацияДляДвиженийВПроизводстве(
					ШапкаДокумента.Организация,
					НоваяЗапись.Цех,
					НоваяЗапись.Период,
					ТекСтрока.Организация);
				НоваяЗапись.Номенклатура = ТекСтрока.Номенклатура;
				НоваяЗапись.ХарактеристикаНоменклатуры = ТекСтрока.ХарактеристикаНоменклатуры; 
				НоваяЗапись.СкладИсточник = ТекСтрока.СкладИсточник;
				Партия = ТекСтрока.Партия;
				НоваяЗапись.Партия = Партия;
				НоваяЗапись.СтатусПартии = ТекСтрока.СтатусПартии;
				ГТД = ТекСтрока.ГТД;
				НоваяЗапись.ГТД = ГТД;
				НоваяЗапись.ХозОперация = ШапкаДокумента.ХозОперация;
				Если ТекСтрока.Количество > НадоСписать И ТекСтрока.Количество > 0 Тогда
					КоличествоСписания		= НадоСписать;
					СуммаСписания			= Окр(ТекСтрока.Сумма / ТекСтрока.Количество * НадоСписать, 2);
					СуммаНДССписания		= Окр(ТекСтрока.СуммаНДС / ТекСтрока.Количество * НадоСписать, 2);
					СуммаБезНДССписания		= СуммаСписания - СуммаНДССписания;
					СуммаУпрСписания		= Окр(ТекСтрока.СуммаУпр / ТекСтрока.Количество * НадоСписать, 2);
					СуммаНДСУпрСписания		= Окр(ТекСтрока.СуммаНДСУпр / ТекСтрока.Количество * НадоСписать, 2);
					СуммаБезНДСУпрСписания	= СуммаУпрСписания - СуммаНДСУпрСписания;
				Иначе
					КоличествоСписания		= ТекСтрока.Количество;
					СуммаСписания			= Окр(ТекСтрока.Сумма, 2);
					СуммаНДССписания		= Окр(ТекСтрока.СуммаНДС, 2);
					СуммаБезНДССписания		= Окр(ТекСтрока.СуммаБезНДС, 2);
					СуммаУпрСписания		= Окр(ТекСтрока.СуммаУпр, 2);
					СуммаНДСУпрСписания		= Окр(ТекСтрока.СуммаНДСУпр, 2);
					СуммаБезНДСУпрСписания	= Окр(ТекСтрока.СуммаБезНДСУпр, 2);
				КонецЕсли;
				НоваяЗапись.Количество		= КоличествоСписания;
				НоваяЗапись.Сумма			= СуммаСписания;
				НоваяЗапись.СуммаНДС		= СуммаНДССписания;
				НоваяЗапись.СуммаБезНДС		= СуммаБезНДССписания;
				НоваяЗапись.СуммаУпр		= СуммаУпрСписания;
				НоваяЗапись.СуммаНДСУпр		= СуммаНДСУпрСписания;
				НоваяЗапись.СуммаБезНДСУпр	= СуммаБезНДСУпрСписания;
				// Запомним удельные значения списания для отрицательной партии товаров
				ОбщееКоличество = ОбщееКоличество + КоличествоСписания;
				ОбщаяСумма = ОбщаяСумма + СуммаСписания;
				ОбщаяСуммаНДС = ОбщаяСуммаНДС + СуммаНДССписания;
				ОбщаяСуммаБезНДС = ОбщаяСуммаБезНДС + СуммаБезНДССписания;
				ОбщаяСуммаУпр = ОбщаяСуммаУпр + СуммаУпрСписания;
				ОбщаяСуммаНДСУпр = ОбщаяСуммаНДСУпр + СуммаНДСУпрСписания;
				ОбщаяСуммаБезНДСУпр = ОбщаяСуммаБезНДСУпр + СуммаБезНДСУпрСписания;
				// Уменьшим ресурсы для остатка текущей партии
				Если КоличествоСписания >= ТекСтрока.Количество Тогда
					СтрокаПартийНоменклатуры.Строки.Удалить(ТекСтрока);
				Иначе
					ТекСтрока.Количество		= ТекСтрока.Количество - КоличествоСписания;
					ТекСтрока.Сумма				= ТекСтрока.Сумма - СуммаСписания;
					ТекСтрока.СуммаНДС			= ТекСтрока.СуммаНДС - СуммаНДССписания;
					ТекСтрока.СуммаБезНДС		= ТекСтрока.СуммаБезНДС - СуммаБезНДССписания;
					ТекСтрока.СуммаУпр			= ТекСтрока.СуммаУпр - СуммаУпрСписания;
					ТекСтрока.СуммаНДСУпр		= ТекСтрока.СуммаНДСУпр - СуммаНДСУпрСписания;
					ТекСтрока.СуммаБезНДСУпр	= ТекСтрока.СуммаБезНДСУпр - СуммаБезНДСУпрСписания;
				КонецЕсли;
				// Уменьшаем количество которое надо списать (или увеличиваем если это коррекция отрицательной партии).
				НадоСписать = НадоСписать - КоличествоСписания;
				Если НадоСписать <= 0 Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			// Уменьшим ресурсы для остатка по номенклатуре
			Если ОбщееКоличество >= СтрокаПартийНоменклатуры.Количество Тогда
				ТабВПроизводстве.Строки.Удалить(СтрокаПартийНоменклатуры);
			Иначе
				СтрокаПартийНоменклатуры.Количество = СтрокаПартийНоменклатуры.Количество - ОбщееКоличество;
			КонецЕсли;
		КонецЕсли;
		Если НадоСписать > 0 Тогда
			// Попытка перемещения более чем есть в цехе
			Сообщение = СтрШаблон(НСтр("ru = 'Товар ""%1""'"), СокрЛП(СтрокаТоваров.Номенклатура));
			Если ЗначениеЗаполнено(СтрокаТоваров.ХарактеристикаНоменклатуры) Тогда
				Сообщение = Сообщение
					+ Символы.НПП
					+ СтрШаблон(НСтр("ru = 'с характеристикой ""%1""'"), СокрЛП(СтрокаТоваров.ХарактеристикаНоменклатуры));
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТоваров.Партия) Тогда
				Сообщение = Сообщение + Символы.НПП + СтрШаблон(НСтр("ru = '(Партия <%1>)'"), СтрокаТоваров.Партия);
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТоваров.ГТД) Тогда
				Сообщение = Сообщение + Символы.НПП + СтрШаблон(НСтр("ru = '(ГТД <%1>)'"), СокрЛП(СтрокаТоваров.ГТД));
			КонецЕсли; 
			Сообщение = Сообщение + СтрШаблон(
				НСтр("ru = '. Извлекается из производства %1 %2. Помещено в производство %3 %4. Превышение на %5 %6'"),
				СокрЛП(СтрокаТоваров.Количество * СтрокаТоваров.Коэффициент),
				СокрЛП(СтрокаТоваров.Номенклатура.ОсновнаяЕдиницаИзмерения),
				СокрЛП(ОбщееКоличество),
				СокрЛП(СтрокаТоваров.Номенклатура.ОсновнаяЕдиницаИзмерения),
				СокрЛП(НадоСписать),
				СокрЛП(СтрокаТоваров.Номенклатура.ОсновнаяЕдиницаИзмерения)
			);
			ОбщегоНазначения.СообщитьПользователю(Сообщение, ЭтотОбъект);
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	Если НЕ Отказ Тогда
		НаборЗаписейТоварыВПроизводстве.Записать();
	КонецЕсли;
	
	Если НаборЗаписейДопроведениеПоПартиям.НеПроводитьПартии Тогда
		// Доходы и расходы на себестоимость не оприходованных партий
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	СУММА(ТоварыВПроизводстве.СуммаУпр) КАК СуммаУпр
		|ИЗ
		|	РегистрНакопления.ТоварыВПроизводстве КАК ТоварыВПроизводстве
		|ГДЕ
		|	ТоварыВПроизводстве.Регистратор = &Регистратор
		|	И ТоварыВПроизводстве.ВидДвижения = &ВидДвижения
		|	И ТоварыВПроизводстве.СтатусПартии = &СтатусПартии";
		Запрос.УстановитьПараметр("Регистратор", ШапкаДокумента.Ссылка);
		Запрос.УстановитьПараметр("ВидДвижения", ВидДвиженияНакопления.Расход);
		Запрос.УстановитьПараметр("СтатусПартии", Перечисления.СтатусыПартий.ТоварКупленный);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			СуммаВсего = Выборка.СуммаУпр;
			Если СуммаВсего <> 0 Тогда
				НаборЗаписейДоходыИРасходы = Движения.ДоходыИРасходы;
				НаборЗаписейДоходыИРасходы.ДокументОбъект = ЭтотОбъект;
				НаборЗаписейДоходыИРасходы.ШапкаДокумента = ШапкаДокумента;
				НаборЗаписейДоходыИРасходы.СтатьяДоходовИРасходов = 
					Справочники.СтатьиДоходовИРасходов.СебестоимостьНеоприходованныхПартий;
				НаборЗаписейДоходыИРасходы.ВУпрВалюте = Истина;
				НаборЗаписейДоходыИРасходы.Расход = СуммаВсего;
				НаборЗаписейДоходыИРасходы.Приход();
			КонецЕсли;
		КонецЕсли;
	Иначе
		// Оприходуем списанные товары на другой заказ-наряд/цех
		СписанныеТоварыВПроизводстве = НаборЗаписейТоварыВПроизводстве.Выгрузить();
		Для каждого СтрокаСписанныхТоваров Из СписанныеТоварыВПроизводстве Цикл
			НоваяЗапись = НаборЗаписейТоварыВПроизводстве.Добавить();
			НоваяЗапись.ВидДвижения = ВидДвиженияНакопления.Приход;
			НоваяЗапись.Период = СтрокаСписанныхТоваров.Период;
			НоваяЗапись.Регистратор = СтрокаСписанныхТоваров.Регистратор;
			НоваяЗапись.ЗаказНаряд = ШапкаДокумента.ЗаказНаряд;
			НоваяЗапись.Цех = ШапкаДокумента.ЦехПолучатель;     
			НоваяЗапись.Организация = ЗапасыТоваров.ОрганизацияДляДвиженийВПроизводстве(
				ШапкаДокумента.Организация,
				НоваяЗапись.Цех,
				НоваяЗапись.Период,
				СтрокаСписанныхТоваров.Организация
			);
			НоваяЗапись.СкладИсточник = СтрокаСписанныхТоваров.СкладИсточник; 
			НоваяЗапись.Номенклатура = СтрокаСписанныхТоваров.Номенклатура;
			НоваяЗапись.ХарактеристикаНоменклатуры = СтрокаСписанныхТоваров.ХарактеристикаНоменклатуры;
			НоваяЗапись.СтатусПартии = СтрокаСписанныхТоваров.СтатусПартии;
			НоваяЗапись.Партия = СтрокаСписанныхТоваров.Партия;
			НоваяЗапись.ГТД = СтрокаСписанныхТоваров.ГТД;
			НоваяЗапись.ХозОперация = СтрокаСписанныхТоваров.ХозОперация;
			НоваяЗапись.СтавкаНДС = СтрокаСписанныхТоваров.СтавкаНДС;
			НоваяЗапись.Количество = СтрокаСписанныхТоваров.Количество;
			НоваяЗапись.Сумма = СтрокаСписанныхТоваров.Сумма;
			НоваяЗапись.СуммаНДС = СтрокаСписанныхТоваров.СуммаНДС;
			НоваяЗапись.СуммаБезНДС = СтрокаСписанныхТоваров.СуммаБезНДС;
			НоваяЗапись.СуммаУпр = СтрокаСписанныхТоваров.СуммаУпр;
			НоваяЗапись.СуммаНДСУПр = СтрокаСписанныхТоваров.СуммаНДСУпр;
			НоваяЗапись.СуммаБезНДСУпр = СтрокаСписанныхТоваров.СуммаБезНДСУпр;
		КонецЦикла;
	КонецЕсли;
	
	// Маркировка товаров
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	МаркировкаТоваровВПроизводствеОстатки.Номенклатура КАК Номенклатура,
	|	МаркировкаТоваровВПроизводствеОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	МаркировкаТоваровВПроизводствеОстатки.GTIN КАК GTIN,
	|	МаркировкаТоваровВПроизводствеОстатки.СерийныйНомер КАК СерийныйНомер,
	|	МаркировкаТоваровВПроизводствеОстатки.ГТД КАК ГТД,
	|	МаркировкаТоваровВПроизводствеОстатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.МаркировкаТоваровВПроизводстве.Остатки(
	|			&НаМомент,
	|			ЗаказНаряд = &ЗаказНаряд
	|				И Цех = &Цех) КАК МаркировкаТоваровВПроизводствеОстатки";
	Запрос.УстановитьПараметр("НаМомент", ШапкаДокумента.МоментВремени);
	Запрос.УстановитьПараметр("ЗаказНаряд", ШапкаДокумента.ДокументОснование.Ссылка);
	Запрос.УстановитьПараметр("Цех", ШапкаДокумента.Цех);
	
	ТаблицаОстатковМаркировок = Запрос.Выполнить().Выгрузить();
	
	СтруктураПоиска = Новый Структура();
	СтруктураПоиска.Вставить("Номенклатура");
	СтруктураПоиска.Вставить("ХарактеристикаНоменклатуры");
	СтруктураПоиска.Вставить("GTIN");
	СтруктураПоиска.Вставить("СерийныйНомер");
	
	// Спискание с заказ-наряда маркировки
	НаборМаркировкаТоваровВПроизводстве = Движения.МаркировкаТоваровВПроизводстве;
	
	Для Каждого ТекущаяСтрока Из КодыМаркировки Цикл
		
		СтрокаТовара = Товары.Найти(ТекущаяСтрока.ИдентификаторТовара, "ИдентификаторТовара");
		
		Если СтрокаТовара = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТовара);
		
		СтруктураМаркировки = МенеджерОборудованияМаркировка.РазобратьШтриховойКодТовара(ТекущаяСтрока.КодМаркировки);
		Если НЕ СтруктураМаркировки.Разобран
				ИЛИ СтруктураМаркировки.ТипИдентификатораТовара <>
				ПредопределенноеЗначение("Перечисление.ТипыИдентификаторовТовараККТ.КодТовараВФорматеDataMatrixGS1") Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураПоиска.GTIN = СтруктураМаркировки.GTIN;
		СтруктураПоиска.СерийныйНомер = СтруктураМаркировки.СерийныйНомер;
		
		СтрокиОстатка = ТаблицаОстатковМаркировок.НайтиСтроки(СтруктураПоиска);
		
		Если СтрокиОстатка.Количество() = 0 Тогда
			Если ЗначениеЗаполнено(СтрокаТоваров.ХарактеристикаНоменклатуры) Тогда
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(
						НСтр("ru = 'Товар ""%1"" с характеристикой ""%2"" с маркировкой %3 не был в производстве по заказ-наряду.'"),
						СокрЛП(СтрокаТоваров.Номенклатура),
						СокрЛП(СтрокаТоваров.ХарактеристикаНоменклатуры),
						ТекущаяСтрока.КодМаркировки
					),
					ЭтотОбъект,
					,
					,
					Отказ
				);
			Иначе
				
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(
						НСтр("ru = 'Товар ""%1"" с маркировкой %2 не был в производстве по заказ-наряду.'"),
						СокрЛП(СтрокаТоваров.Номенклатура),
						ТекущаяСтрока.КодМаркировки
					),
					ЭтотОбъект,
					,
					,
					Отказ
				);
				
			КонецЕсли;
			
			Продолжить;
			
		КонецЕсли;
		
		НоваяЗапись = НаборМаркировкаТоваровВПроизводстве.Добавить();
		НоваяЗапись.ВидДвижения = ВидДвиженияНакопления.Расход;
		НоваяЗапись.Период = ШапкаДокумента.Дата;
		НоваяЗапись.Регистратор = ШапкаДокумента.Ссылка;
		НоваяЗапись.Номенклатура = СтрокаТовара.Номенклатура;
		НоваяЗапись.ХарактеристикаНоменклатуры = СтрокаТовара.ХарактеристикаНоменклатуры;
		НоваяЗапись.ЗаказНаряд = ШапкаДокумента.ДокументОснование.Ссылка;
		НоваяЗапись.Цех = ШапкаДокумента.Цех;
		НоваяЗапись.GTIN = СтруктураМаркировки.GTIN;
		НоваяЗапись.СерийныйНомер = СтруктураМаркировки.СерийныйНомер;
		НоваяЗапись.КодМаркировки = ТекущаяСтрока.КодМаркировки;
		НоваяЗапись.ГТД = СтрокиОстатка[0].ГТД;
		НоваяЗапись.Количество = СтрокиОстатка[0].Количество;
		
	КонецЦикла;
	
	Если НЕ Отказ Тогда
		НаборЗаписейТоварыВПроизводстве.Записать();
	КонецЕсли;
	
	// Оприходуем списанную маркировку на другой заказ-наряд/цех
	СписанныеМаркировкиТоваровВПроизводстве = НаборМаркировкаТоваровВПроизводстве.Выгрузить();
	
	Для Каждого ТекущаяСтрока Из СписанныеМаркировкиТоваровВПроизводстве Цикл
		НоваяЗапись = НаборМаркировкаТоваровВПроизводстве.Добавить();
		НоваяЗапись.ВидДвижения = ВидДвиженияНакопления.Приход;
		НоваяЗапись.Период = ШапкаДокумента.Дата;
		НоваяЗапись.Регистратор = ШапкаДокумента.Ссылка;
		НоваяЗапись.Номенклатура = ТекущаяСтрока.Номенклатура;
		НоваяЗапись.ХарактеристикаНоменклатуры = ТекущаяСтрока.ХарактеристикаНоменклатуры;
		НоваяЗапись.ЗаказНаряд = ШапкаДокумента.ЗаказНаряд;
		НоваяЗапись.Цех = ШапкаДокумента.ЦехПолучатель;
		НоваяЗапись.GTIN = ТекущаяСтрока.GTIN;
		НоваяЗапись.СерийныйНомер = ТекущаяСтрока.СерийныйНомер;
		НоваяЗапись.КодМаркировки = ТекущаяСтрока.КодМаркировки;
		НоваяЗапись.ГТД = ТекущаяСтрока.ГТД;
		НоваяЗапись.Количество = ТекущаяСтрока.Количество;
	КонецЦикла;
	
	// Доходы и расходы
	Если ДобавлятьКорректирующиеЗаписи
		И ШапкаДокумента.ПодразделениеОтправителя <> ШапкаДокумента.ПодразделениеПолучателя Тогда
		// У подразделения цеха-отправителя возникает расход, а подразделения цеха-получателя доход.
		НаборЗаписейДоходыРасходы = Движения.ДоходыИРасходы;
		ТаблицаПартий = НаборЗаписейТоварыВПроизводстве.Выгрузить();
		ТаблицаПартий.Свернуть("Цех,СтатусПартии", "СуммаУпр");
		Для каждого ТекСтрокаДвижения Из ТаблицаПартий Цикл
			Если ТекСтрокаДвижения.СтатусПартии = Перечисления.СтатусыПартий.ТоварПринятыйКомиссия Тогда
				Продолжить;
			КонецЕсли;
			СуммаДиР = ТекСтрокаДвижения.СуммаУпр;
			Если СуммаДиР <> 0 Тогда
				НаборЗаписейДоходыРасходы.ДокументОбъект = ЭтотОбъект;
				НаборЗаписейДоходыРасходы.ШапкаДокумента = ШапкаДокумента;
				НаборЗаписейДоходыРасходы.ВУпрВалюте     = Истина;
				Если ТекСтрокаДвижения.Цех = ШапкаДокумента.Цех Тогда
					НаборЗаписейДоходыРасходы.Расход = СуммаДиР;
					НаборЗаписейДоходыРасходы.Подразделение = ШапкаДокумента.ПодразделениеОтправителя;
					НаборЗаписейДоходыРасходы.СтатьяДоходовИРасходов = Справочники.СтатьиДоходовИРасходов.Себестоимость;
				Иначе
					НаборЗаписейДоходыРасходы.Доход = СуммаДиР;
					НаборЗаписейДоходыРасходы.Подразделение = ШапкаДокумента.ПодразделениеПолучателя;
					НаборЗаписейДоходыРасходы.СтатьяДоходовИРасходов =
						Справочники.СтатьиДоходовИРасходов.КорректировкаБалансаПоПодразделениям;
				КонецЕсли;
				Если НЕ НаборЗаписейДоходыРасходы.Приход() Тогда
					Отказ = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Двигаем границу последовательности производства
	Если Ссылка <> ДокументСсылка Тогда
		
		РаботаСГраницами.МоментВремениПередПроведением(ДокументСсылка, ДополнительныеСвойства);
		РаботаСГраницами.ДвиженияПоПроизводствуПередПроведением(ДокументСсылка, ДополнительныеСвойства);
		
	КонецЕсли;
	
	РаботаСГраницами.СдвинутьГраницуПроизводства(ДокументСсылка, ДополнительныеСвойства, Движения);
	
	Возврат НЕ Отказ;
	
КонецФункции

// Возвращает выборку по шапке
// ДокументСсылка - Ссылка на документ для которого получаем шапку.
Функция ПолучитьШапкуДокумента(ДокументСсылка)
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Док.Ссылка КАК Ссылка,
	|	Док.Дата КАК Дата,
	|	Док.ХозОперация КАК ХозОперация,
	|	Док.МоментВремени КАК МоментВремени,
	|	Док.Организация КАК Организация,
	|	Док.ПодразделениеКомпании КАК ПодразделениеКомпании,
	/////////// ПРИВАТ ////////////
	|	Док.Цех КАК Цех,
	|	Док.ЦехПолучатель КАК ЦехПолучатель,
	|	Док.Цех.ПодразделениеКомпании КАК ПодразделениеОтправителя,
	|	Док.ЦехПолучатель.ПодразделениеКомпании КАК ПодразделениеПолучателя, 
	|	Док.ДокументОснование КАК ДокументОснование,
	|	Док.ЗаказНаряд КАК ЗаказНаряд
	|
	|ИЗ
	|	Документ." + Метаданные().Имя + " КАК Док
	|ГДЕ
	|	Док.Ссылка=&Ссылка
	|");
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка;
КонецФункции

#КонецОбласти

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

#КонецЕсли

