﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы списка регистра "Границы заказы на атомобиль"
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
		ОценкаПроизводительностиКлиент.ЗамерВремени("КопированиеРегистраСведенийГраницыЗаказыНаАвтомобили");
	Иначе
		ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеРегистраСведенийГраницыЗаказыНаАвтомобили");
	КонецЕсли;
	// Конец ОценкаПроизводительности
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеЗаписиРегистраСведенийГраницыЗаказыНаАвтомобили");
	
КонецПроцедуры

#КонецОбласти
