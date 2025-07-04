﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы списка регистра "Сведения о сотрудниках"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСФормой.НастроитьОсновнойДинамическийСписокФормы(ЭтотОбъект);
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	// ОценкаПроизводительности
	Если Копирование Тогда
		
		ОценкаПроизводительностиКлиент.ЗамерВремени("КопированиеРегистраСведенийСведенияОСотрудниках");
		
	Иначе
		
		ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеРегистраСведенийСведенияОСотрудниках");
		
	КонецЕсли;
	// Конец ОценкаПроизводительности

КонецПроцедуры 

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	 
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеЗаписиРегистраСведенийСведенияОСотрудниках");
		
КонецПроцедуры 

#КонецОбласти

