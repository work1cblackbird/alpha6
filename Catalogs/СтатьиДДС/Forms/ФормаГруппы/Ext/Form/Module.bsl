﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы группы справочника "Статьи ДДС"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	РаботаСФормой.ЗаблокироватьРедактированиеПредопределенногоЭлемента(ЭтотОбъект);

КонецПроцедуры 

#КонецОбласти
