﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы записи регистра "ИспользованиеШтрихкодированияДокументов"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отказ = Отказ Или РаботаСФормой.НужноОтменитьОткрытиеФормы();
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ВидДокументов.СписокВыбора.Очистить();
	Для Каждого ТекущийТип Из Метаданные.РегистрыСведений.ШтрихКоды.Измерения.Объект.Тип.Типы() Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТекущийТип);
		Если НЕ Метаданные.Документы.Содержит(ОбъектМетаданных) Тогда
			Продолжить;
		КонецЕсли;
		Элементы.ВидДокументов.СписокВыбора.Добавить(ОбъектМетаданных.Имя, ОбъектМетаданных.Синоним);	
	КонецЦикла;
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		НастроитьПараметрыВыбораЭлементовФормы();
		УправлениеДиалогомНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	
	УправлениеДиалогомРегистраСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры 

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	УправлениеДиалогомРегистраСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
КонецПроцедуры 

#КонецОбласти

#КонецОбласти

