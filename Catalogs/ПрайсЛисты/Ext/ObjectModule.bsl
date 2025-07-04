﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Обработчик события объекта возникает в момент, когда выполняется установка нового номера.
//
// Параметры:
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//  Префикс              - Строка - Префикс, который будет использоваться для генерации номера.
//
Процедура ПриУстановкеНовогоКода(СтандартнаяОбработка, Префикс)
	
	// Вызываем общий обработчик события
	ПрефиксацияОбъектов.ПриУстановкеНовогоКода(ЭтотОбъект, СтандартнаяОбработка, Префикс);
	
КонецПроцедуры // ПриУстановкеНовогоКода()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	ОбработкаСобытийСправочникаСервер
		.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Источник <> ПредопределенноеЗначение("Перечисление.ИсточникиПрайсЛистов.ПрайсЛистПоставщика") Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПрайсЛистПоставщика");
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ПередЗаписью(Отказ)
	
	ОбработкаСобытийСправочникаСервер.ПередЗаписью(ЭтотОбъект, Отказ);
	
КонецПроцедуры // ПередЗаписью()

Процедура ПриЗаписи(Отказ)
	
	ОбработкаСобытийСправочникаСервер.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры // ПриЗаписи()

Процедура ПередУдалением(Отказ)
	
	ОбработкаСобытийСправочникаСервер.ПередУдалением(ЭтотОбъект, Отказ);
	
КонецПроцедуры // ПередУдалением()

#КонецОбласти

#КонецЕсли
