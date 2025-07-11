﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	ПрефиксацияОбъектов.ПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения = "", СтандартнаяОбработка = Истина)
	
	Если ОбработкаСобытийДокументаСервер.ВводСПустымОснованием(ДанныеЗаполнения) Тогда
		
		ТипЦен = ПраваИНастройкиПользователя.Значение("ОсновнойТипЦенПродажиАвтомобилей", ЭтотОбъект);
		//@skip-check module-unused-local-variable
		// Это общий реквизит
		ВалютаДокумента = РаботаСКурсамиВалютПлатформа.ВалютаТипаЦены(ТипЦен,, Ложь);
		
	КонецЕсли;
	
	ПродолжитьЗаполнение = ОбработкаСобытийДокументаСервер.ОбработкаЗаполнения(
		ЭтотОбъект,
		ДанныеЗаполнения,
		ТекстЗаполнения,
		СтандартнаяОбработка
	);
	
	Если Не ПродолжитьЗаполнение Тогда
		Возврат;
	КонецЕсли;
	
	Состояние = Перечисления.СостоянияОптовогоЗаказаКлиентаНаАвтомобили.Черновик;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если Не ОбработкаСобытийДокументаСервер.ПриКопировании(ЭтотОбъект, ОбъектКопирования) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Состояние = Перечисления.СостоянияОптовогоЗаказаКлиентаНаАвтомобили.Черновик;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты) Тогда
		
		Возврат;
		
	КонецЕсли;

КонецПроцедуры

//@skip-check data-exchange-load
// ОбменДанными.Загрузка обрабатывается в общем модуле ОбработкаСобытийДокументаСервер
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// УтверждениеДокумментов
	УтверждениеДокументовСервер.ОбработкаУтвержденияПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	// Конец УтверждениеДокументов
	
	Если Не ОбработкаСобытийДокументаСервер.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не ТипЦен.Пустая() И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТипЦен, "Рассчитывается") Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Использование расчетных типов цен запрещено.'"),
			ЭтотОбъект,
			,
			,
			Отказ
		);
		
	КонецЕсли;
	
	Если Состояние <> Перечисления.СостоянияОптовогоЗаказаКлиентаНаАвтомобили.Черновик Тогда
		
		ЗаказыСервер.СопоставитьСпецификацииИАвтомобили(ЭтотОбъект, Отказ);
		
	КонецЕсли;
	
	РаботаСГраницами.МоментВремениПередПроведением(Ссылка, ДополнительныеСвойства);
	РаботаСГраницами.ДвиженияПоЗаказамАвтомобилейПередПроведением(Ссылка, ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// УтверждениеДокумментов
	УтверждениеДокументовСервер.ОбработкаУтвержденияПриЗаписи(ЭтотОбъект, Отказ);
	// Конец УтверждениеДокументов
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		
		Возврат;
		
	КонецЕсли;
	
	РаботаСГраницами.ПередУдалением(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗаказыАвтомобилей.Автомобиль КАК Автомобиль
		|ИЗ
		|	РегистрНакопления.ЗаказыАвтомобилей КАК ЗаказыАвтомобилей
		|ГДЕ
		|	ЗаказыАвтомобилей.Регистратор = &Регистратор"
	);
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	АвтомобилиКПроверке = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Автомобиль");
	
	Если Не ОбработкаСобытийДокументаСервер.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ОптовыйЗаказКлиентаНаАвтомобили.ПроверитьКорректностьИзмененияЗаказа(ЭтотОбъект, АвтомобилиКПроверке,
		Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если Не ОбработкаСобытийДокументаСервер.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Документы.ОптовыйЗаказКлиентаНаАвтомобили.ИнициализироватьДанныеДокумента(ЭтотОбъект, ДополнительныеСвойства);
	
	Если Состояние <> Перечисления.СостоянияОптовогоЗаказаКлиентаНаАвтомобили.Черновик Тогда
		
		Документы.ОптовыйЗаказКлиентаНаАвтомобили.ПроверитьПроцентПредоплаты(ЭтотОбъект, ДополнительныеСвойства, Отказ);
		
		Если Не Отказ Тогда
		
			Документы.ОптовыйЗаказКлиентаНаАвтомобили.СформироватьДвиженияЗаказовНаАвтомобили(ЭтотОбъект,
				ДополнительныеСвойства);
			Движения.Записать();
			Документы.ОптовыйЗаказКлиентаНаАвтомобили.ПроверитьЗаказыНаАвтомобиль(ЭтотОбъект,
				ДополнительныеСвойства, Отказ);
			
			АвтомобилиКПроверке = ДополнительныеСвойства
				.ДвиженияПередПроведением
				.ЗаказыАвтомобилей
				.ВыгрузитьКолонку("Автомобиль");
			Документы.ОптовыйЗаказКлиентаНаАвтомобили.ПроверитьКорректностьИзмененияЗаказа(
				ЭтотОбъект,
				АвтомобилиКПроверке,
				Отказ
			);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		РаботаСГраницами.СдвинутьГраницуЗаказовАвтомобилей(Ссылка, ДополнительныеСвойства, Движения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли