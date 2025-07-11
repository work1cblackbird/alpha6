﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Функция записи параметров в регистр сведений
//
Функция ЗаписатьАктивностьБонуснойПрограммы(БонуснаяПрограмма, Активность) Экспорт
	
	Отказ = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписей = РегистрыСведений.АктивныеБонусныеПрограммы.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписей.Активна = Активность;
	МенеджерЗаписей.Период  = ТекущаяДатаСеанса();
	МенеджерЗаписей.БонуснаяПрограмма = БонуснаяПрограмма;
	
	Попытка
		МенеджерЗаписей.Записать(Истина);
	Исключение
		ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), , , , Отказ);
	КонецПопытки;
	
	Возврат Отказ;
	
КонецФункции
#Область ПараметрыОбработкиРеквизитовОбъекта

Функция
	ПолучитьОбязательныеРеквизиты(Объект) Экспорт
	
	ОбязательныеРеквизиты = ОбработкаСобытийРегистраСервер.ПолучитьСтандартныеОбязательныеРеквизиты(Объект);
	
	Возврат ОбязательныеРеквизиты;
	
КонецФункции

Функция ПолучитьУникальныеРеквизиты(Объект) Экспорт
	
	УникальныеРеквизиты = Новый Структура();
	
	Возврат УникальныеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли