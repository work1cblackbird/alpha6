﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы записи регистра "Опции автомобилей"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отказ = Отказ Или РаботаСФормой.НужноОтменитьОткрытиеФормы();
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект.ТолькоПросмотр = Истина;
	Элементы.ФормаЗаписать.Видимость = Ложь;
	
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

