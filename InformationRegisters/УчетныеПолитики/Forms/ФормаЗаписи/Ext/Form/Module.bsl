﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы записи регистра "Учетные политики"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отказ = Отказ Или РаботаСФормой.НужноОтменитьОткрытиеФормы();
	
	Если Отказ Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		
		НастроитьПараметрыВыбораЭлементовФормы();
		УправлениеДиалогомНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения

	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();

КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПараметрПриИзменении(Элемент)
	УправлениеДиалогомНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)

	ЗначениеНачалоВыбораНаСервере(ДанныеВыбора, Запись.Период, Запись.Объект, Запись.Параметр, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗначениеНачалоВыбораНаСервере(ДанныеВыбора, Период, Объект, Параметр, СтандартнаяОбработка)

	Если Параметр = ПланыВидовХарактеристик.УчетныеПолитики.ПатентПоУмолчанию Тогда 

		СтандартнаяОбработка = Ложь;
		
		ПериодДействия = ?(ЗначениеЗаполнено(Период), Период, Неопределено);
		Владелец = Неопределено;
		Если ТипЗнч(Объект) = Тип("СправочникСсылка.Организации") Тогда 
			Владелец = Объект;
		ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПодразделенияКомпании") Тогда 
			Владелец = Объект.Организация;
		КонецЕсли;
		ДоступныеПатенты = Справочники.Патенты.ДоступныеПатенты(Владелец, ПериодДействия);

		ДанныеВыбора = Новый СписокЗначений;
		
		Для Каждого ДоступныйПатент Из ДоступныеПатенты Цикл
			ДанныеВыбора.Добавить(ДоступныйПатент);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ЗначениеНачалоВыбораНаСервере(ДанныеВыбора, Запись.Период, Запись.Объект, Запись.Параметр, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Функция ЗначениеСозданиеНаСервере()

	СтруктураПараметров = Неопределено;
	
	Если ЭтотОбъект.Запись.Параметр = ПланыВидовХарактеристик.УчетныеПолитики.ПатентПоУмолчанию Тогда 

		Владелец = Неопределено;
		Если ТипЗнч(ЭтотОбъект.Запись.Объект) = Тип("СправочникСсылка.Организации") Тогда 
			Владелец = ЭтотОбъект.Запись.Объект;
		ИначеЕсли ТипЗнч(ЭтотОбъект.Запись.Объект) = Тип("СправочникСсылка.ПодразделенияКомпании") Тогда 
			Владелец = ЭтотОбъект.Запись.Объект.Организация;
		КонецЕсли;
		
		Если Владелец <> Неопределено Тогда 
			СтандартнаяОбработка = Ложь;
			СтруктураПараметров = Новый Структура;
			ЗначенияЗаполнения  = Новый Структура;
			ЗначенияЗаполнения.Вставить("Владелец", Владелец);
			СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
			СтруктураПараметров.Вставить("РежимВыбора", Истина);
		КонецЕсли;

	КонецЕсли;
	
	Возврат СтруктураПараметров;
		
КонецФункции

&НаКлиенте
Процедура ЗначениеСоздание(Элемент, СтандартнаяОбработка)
	СтруктураПараметров = ЗначениеСозданиеНаСервере();
	Если СтруктураПараметров <> Неопределено Тогда 
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.Патенты.ФормаОбъекта", СтруктураПараметров, Элемент);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()

	УправлениеДиалогомРегистраСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры 

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	// Вызываем общий обработчик действия
	УправлениеДиалогомРегистраСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(Запись.Параметр) Тогда 
		Элементы.Значение.Доступность = Истина;
	Иначе 
		Элементы.Значение.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры // УправлениеДиалогомНаСервере()

#КонецОбласти

#КонецОбласти
