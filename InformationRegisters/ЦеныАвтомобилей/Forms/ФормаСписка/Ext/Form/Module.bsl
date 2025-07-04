﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы списка регистра сведений "Цены автомобилей"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСФормой.УстановитьАвтоматическоеСохранениеПользовательскихНастроек(Список, Параметры);
	
	РаботаСФормой.НастроитьОсновнойДинамическийСписокФормы(ЭтотОбъект);
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	// ОценкаПроизводительности
	Если Копирование Тогда
		
		ОценкаПроизводительностиКлиент.ЗамерВремени("КопированиеРегистраСведенийЦеныАвтомобилей");
		
	Иначе
		
		ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеРегистраСведенийЦеныАвтомобилей");
		
	КонецЕсли;
	// Конец ОценкаПроизводительности
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеЗаписиРегистраСведенийЦеныАвтомобилей");
	
КонецПроцедуры

#КонецОбласти

