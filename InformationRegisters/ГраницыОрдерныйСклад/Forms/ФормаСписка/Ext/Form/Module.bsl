﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы списка регистра "Границы ордерный склад"
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
		ОценкаПроизводительностиКлиент.ЗамерВремени("КопированиеРегистраСведенийГраницыОрдерныйСклад");
	Иначе
		ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеРегистраСведенийГраницыОрдерныйСклад");
	КонецЕсли;
	// Конец ОценкаПроизводительности
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеЗаписиРегистраСведенийГраницыОрдерныйСклад");
	
КонецПроцедуры

#КонецОбласти
