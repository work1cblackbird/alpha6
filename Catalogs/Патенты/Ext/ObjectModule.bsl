﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)

	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполнения = Новый Структура;
	КонецЕсли;
	
	Если НЕ ДанныеЗаполнения.Свойство("ДатаНачала") Тогда
		Если ДанныеЗаполнения.Свойство("ДатаОкончания") Тогда
			ДатаНачала = НачалоГода(ДанныеЗаполнения.ДатаОкончания);
		Иначе
			ДатаНачала = НачалоГода(ОбщегоНазначения.ТекущаяДатаПользователя());
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ДанныеЗаполнения.Свойство("ДатаОкончания") Тогда
		ДатаОкончания = КонецГода(ДатаНачала);
	КонецЕсли;
	
	Если НЕ ДанныеЗаполнения.Свойство("Владелец") Тогда
		Владелец = ПараметрыСеанса.Организация;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) Тогда
		
		Если ДатаНачала > ДатаОкончания Тогда
			ТекстОшибки = НСтр("ru = 'Неверно задан период'");
			ТекстОшибки = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Поле", "Корректность", "Дата окончания",,, ТекстОшибки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "ДатаОкончания", "Объект", Отказ);
		ИначеЕсли Год(ДатаНачала) <> Год(ДатаОкончания) Тогда
			ТекстОшибки = НСтр("ru = 'Патент выдается на период от одного до двенадцати месяцев включительно в пределах календарного года'");
			ТекстОшибки = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Поле", "Корректность", "Дата окончания",,, ТекстОшибки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "ДатаОкончания", "Объект", Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Очищаем ссылки на правило из регистра сведений "ЗадачиБухгалтераНалоговыеПлатежи"
Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
