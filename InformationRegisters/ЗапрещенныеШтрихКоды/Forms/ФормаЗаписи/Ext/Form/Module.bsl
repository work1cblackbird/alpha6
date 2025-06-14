﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы записи регистра "Сведения о сотрудниках"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отказ = Отказ Или РаботаСФормой.НужноОтменитьОткрытиеФормы();
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		НастроитьПараметрыВыбораЭлементовФормы();
		УправлениеДиалогомНаСервере();
	КонецЕсли;
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = 
		МенеджерОборудованияВызовСервераПереопределяемый.ИспользоватьПодключаемоеОборудование();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(
		Неопределено,
		ЭтотОбъект, 
		"СканерШтрихкода, СчитывательМагнитныхКарт"
	);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВводДоступен() И Источник = "ПодключаемоеОборудование" Тогда
		Если ТолькоПросмотр Тогда
			Возврат;
		КонецЕсли;
		
		Штрихкод = ШтрихкодированиеКлиент.ПолучитьШтрихкодИзПараметровОборудования(ИмяСобытия, Параметр);
		ПараметрыДействия = Новый Структура();
		ШтрихкодированиеКлиент.ОбработатьПолныйШтрихкод(Штрихкод, ПараметрыДействия);
		Штрихкод = ПараметрыДействия.Штрихкод;
		
		Если ЗначениеЗаполнено(Штрихкод)Тогда
			Запись.Штрихкод = ПараметрыДействия.Штрихкод;
		КонецЕсли;
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

