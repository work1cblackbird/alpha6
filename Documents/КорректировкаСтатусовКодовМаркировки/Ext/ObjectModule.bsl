﻿// Модуль документа Корректировка статусов кодов маркировки

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	ПрефиксацияОбъектов.ПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ПродолжитьВыполнение = ОбработкаСобытийДокументаСервер.ОбработкаЗаполнения(
		ЭтотОбъект,
		ДанныеЗаполнения,
		ТекстЗаполнения,
		СтандартнаяОбработка
	);
	Если НЕ ПродолжитьВыполнение Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если НЕ ОбработкаСобытийДокументаСервер.ПриКопировании(ЭтотОбъект, ОбъектКопирования) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// Переведем вид кода маркировки
	Для Каждого ТекущаяСтрока Из Товары Цикл
		
		ТекущаяСтрока.КодМаркировки = МаркировкаТоваровКлиентСервер.ПолучитьКодМаркировки(
			ТекущаяСтрока.КодМаркировки,
			,
			СтрНачинаетсяС(ТекущаяСтрока.КодМаркировки, "(")
		);
		
	КонецЦикла;
	
	Если НЕ ОбработкаСобытийДокументаСервер.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьНовыеШтрихкоды();
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если НЕ ОбработкаСобытийДокументаСервер.ПередУдалением(ЭтотОбъект, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
	// Удалим коды маркировки
	НаборЗаписейСостоянияКодовМаркировки = РегистрыСведений.СостоянияКодовМаркировки.СоздатьНаборЗаписей();
	НаборЗаписейСостоянияКодовМаркировки.ДокументОбъект = ЭтотОбъект;
	НаборЗаписейСостоянияКодовМаркировки.ОтменаПроведения();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если НЕ ОбработкаСобытийДокументаСервер.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		ТаблицаМаркировки = Товары.Выгрузить();
		
		НаборЗаписейСостоянияКодовМаркировки = РегистрыСведений.СостоянияКодовМаркировки.СоздатьНаборЗаписей();
		НаборЗаписейСостоянияКодовМаркировки.ДокументОбъект = ЭтотОбъект;
		НаборЗаписейСостоянияКодовМаркировки.Организация = Организация;
		НаборЗаписейСостоянияКодовМаркировки.РезультатЗапросаПоКодамМаркировки = ТаблицаМаркировки;
		НаборЗаписейСостоянияКодовМаркировки.РежимПроведения = РежимПроведения;
		Если НЕ НаборЗаписейСостоянияКодовМаркировки.КорректировкаСостоянийКодовМаркировки() Тогда
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


#Область ОбработчикиЗаполненияОбъекта

Функция ОбработкаЗаполнения_ВводОстатковТоваров(ДанныеЗаполнения,
	ТекстЗаполнения = "",
	СтандартнаяОбработка = Истина) Экспорт
	
	// Если данные заполнения не указаны, значит производиться проверка существования обработчика заполнения у объекта.
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Вызываем общий обработчик заполнения
	ПродолжитьВыполнение = ОбработкаСобытийДокументаСервер.ОбработкаЗаполненияНаОсновании(
		ЭтотОбъект,
		ДанныеЗаполнения,
		ТекстЗаполнения,
		СтандартнаяОбработка,
		"Товары"
	);
	Если НЕ ПродолжитьВыполнение Тогда
		Возврат Истина;
	КонецЕсли;
	
	Товары.Загрузить(ТоварыДокументаОснование(ДанныеЗаполнения));
	
	Для Каждого Строка Из Товары Цикл
		
		Документы.КорректировкаСтатусовКодовМаркировки.ТоварыНоменклатураПриИзменении(ЭтотОбъект, Строка);
		
	КонецЦикла;
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Процедура ЗаписатьНовыеШтрихкоды()
	
	НовыеШтрихкоды = Товары.Выгрузить(, "Номенклатура,КодМаркировки,ХарактеристикаНоменклатуры");
	УдалитьСтроки = Новый Массив;
	Для Каждого Строка Из НовыеШтрихкоды Цикл
		
		СтруктураКодаМаркировки =
			МенеджерОборудованияМаркировка.РазобратьШтриховойКодТовара(Строка.КодМаркировки);
		ГТИН = СтруктураКодаМаркировки.GTIN;
		Если ЗначениеЗаполнено(ГТИН) И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ГТИН) Тогда
			ГТИН = Строка(Число(ГТИН));
			ГТИН = СтрЗаменить(ГТИН, Символы.НПП, "");
		Иначе
			УдалитьСтроки.Добавить(Строка);
		КонецЕсли;
		Строка.КодМаркировки = ГТИН;
	КонецЦикла;
	
	Для Каждого Строка Из УдалитьСтроки Цикл
		НовыеШтрихкоды.Удалить(Строка);
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	НовыеШтрихкоды.КодМаркировки КАК Штрихкод,
	|	НовыеШтрихкоды.Номенклатура КАК Номенклатура,
	|	НовыеШтрихкоды.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры
	|ПОМЕСТИТЬ ТаблицаШтрихкодов
	|ИЗ
	|	&НовыеШтрихкоды КАК НовыеШтрихкоды
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаШтрихкодов.Штрихкод КАК Штрихкод,
	|	ТаблицаШтрихкодов.Номенклатура КАК Номенклатура,
	|	ТаблицаШтрихкодов.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры
	|ИЗ
	|	ТаблицаШтрихкодов КАК ТаблицаШтрихкодов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК Штрихкоды
	|		ПО ТаблицаШтрихкодов.Штрихкод = Штрихкоды.Штрихкод
	|			И ТаблицаШтрихкодов.Номенклатура = Штрихкоды.Объект
	|ГДЕ
	|	ЕСТЬNULL(Штрихкоды.GTIN, ИСТИНА)
	|	И Штрихкоды.Объект ЕСТЬ NULL
	|";
	Запрос.УстановитьПараметр("НовыеШтрихкоды", НовыеШтрихкоды);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			НоваяЗапись = РегистрыСведений.ШтрихКоды.СоздатьМенеджерЗаписи();
			НоваяЗапись.Штрихкод = Выборка.Штрихкод;
			НоваяЗапись.Объект = Выборка.Номенклатура;
			НоваяЗапись.ХарактеристикаНоменклатуры = Выборка.ХарактеристикаНоменклатуры;
			НоваяЗапись.GTIN = Истина;
			НоваяЗапись.Запрет = Ложь;
			НоваяЗапись.Записать();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ТоварыДокументаОснование(ДанныеЗаполнения)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ТаблицаТоваров = ПолучитьЗначениеПараметраСтруктуры(ДанныеЗаполнения, "ТаблицаТоваров", Неопределено);
	Иначе
		ТаблицаТоваров = ДанныеЗаполнения.Товары.Выгрузить();
	КонецЕсли;
	
	Результат = ТаблицаТоваров.СкопироватьКолонки("Номенклатура, ХарактеристикаНоменклатуры");
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТаблицаТоваров", ТаблицаТоваров);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТаблицаТоваров.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ТаблицаТоваров.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ТаблицаТоваров.Количество КАК Количество
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ТаблицаТоваров.Количество КАК Количество
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.Номенклатура.ТипНоменклатуры.ВедетсяМаркировка
	|	И ТаблицаТоваров.Количество > 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Для Счетчик = 0 По Выборка.Количество - 1 Цикл
				ЗаполнитьЗначенияСвойств(Результат.Добавить(), Выборка);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
