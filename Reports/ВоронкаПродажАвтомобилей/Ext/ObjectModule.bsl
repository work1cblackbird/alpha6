﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - Настройкм отчета
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Если ТипЗнч(Настройки) = Тип("Структура") И НЕ Настройки.Свойство("Отбор") Тогда
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("ПодразделениеКомпании", ПараметрыСеанса.ПодразделениеКомпании);
		Настройки.Вставить("Отбор", СтруктураОтбора);
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьНачальныеНастройки()


// Стандартная процедура настройки схемы компоновщика данных
//
// Параметры:
//  ФормаОтчета - УправляемаФорма - Форма отчета, в которой возникло событие.
//
Процедура ПриИзмененииВарианта(ФормаОтчета) Экспорт
	
	ПараметрыДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных;
	
	ПодразделениеКомпании = ПараметрыДанных.НайтиЗначениеПараметра(
		Новый ПараметрКомпоновкиДанных("ПодразделениеКомпании"));
	Если НЕ ЗначениеЗаполнено(ПодразделениеКомпании.Значение) Тогда
		ПодразделениеКомпании.Значение = ПараметрыСеанса.ПодразделениеКомпании;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыПлатформаСервер.ВывестиОтчет(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли