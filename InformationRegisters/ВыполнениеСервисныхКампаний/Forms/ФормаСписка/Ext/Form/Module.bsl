﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы списка регистра "Выполнение сервисных кампаний"
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
		ОценкаПроизводительностиКлиент.ЗамерВремени("КопированиеРегистраСведенийВыполнениеСервисныхКампаний");
	Иначе
		ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеРегистраСведенийВыполнениеСервисныхКампаний");
	КонецЕсли;
	// Конец ОценкаПроизводительности
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеЗаписиРегистраСведенийВыполнениеСервисныхКампаний");
	
КонецПроцедуры

#КонецОбласти
