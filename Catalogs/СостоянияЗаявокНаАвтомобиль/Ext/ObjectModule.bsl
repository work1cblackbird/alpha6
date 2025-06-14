﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриУстановкеНовогоКода(СтандартнаяОбработка, Префикс)
	
	ПрефиксацияОбъектов.ПриУстановкеНовогоКода(ЭтотОбъект, СтандартнаяОбработка, Префикс);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	ОбработкаСобытийСправочникаСервер.ОбработкаЗаполнения(
		ЭтотОбъект,
		ДанныеЗаполнения,
		ТекстЗаполнения,
		СтандартнаяОбработка
	);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ОбработкаСобытийСправочникаСервер.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ОбработкаСобытийСправочникаСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	ОбработкаСобытийСправочникаСервер.ПередЗаписью(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	ОбработкаСобытийСправочникаСервер.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	ОбработкаСобытийСправочникаСервер.ПередУдалением(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
