﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура помогает настроить отчет непосредственно перед выводом
//
// Параметры:
//  ПараметрСхемаКомпоновкиДанных - СхемаКомпоновкиДанных - Схема компоновки данных.
//  Настройки - НастройкиКомпоновкиДанных - Копия настроек компоновки данных.
//
Процедура ПередФормированиемМакетаКомпоновки(ПараметрСхемаКомпоновкиДанных, Настройки) Экспорт
	
	Поля = Новый Массив;
	Поля.Добавить("ПериодРегистратор");
	Поля.Добавить("Заказ");
	Поля.Добавить("Контрагент");
	
	ОтчетыПлатформаСервер.КомпоновщикУстановитьОтборПустыхГруппировок(Настройки.Структура, Поля);
	
КонецПроцедуры // ПередФормированиемМакетаКомпоновки()

// Обработчик после формирования макета компоновки.
//
// Параметры:
//  МакетКомпоновки - МакетКомпоновкиДанных - Макет компоновки отчета.
//
Процедура ПослеФормированияМакетаКомпоновки(МакетКомпоновки) Экспорт
	НовыйМакет = МакетКомпоновки;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыПлатформаСервер.ВывестиОтчет(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли