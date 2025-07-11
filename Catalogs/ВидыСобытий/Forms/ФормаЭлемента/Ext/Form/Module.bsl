﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Отказ = Отказ Или РаботаСФормой.НужноОтменитьОткрытиеФормы();
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	РаботаСФормой.ЗаблокироватьРедактированиеПредопределенногоЭлемента(ЭтотОбъект);
	РаботаСФормой.УстановитьДоступностьПоляКодНаФормеСправочника(ЭтотОбъект, Объект);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УправлениеДиалогомНаСервере();
	КонецЕсли;
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормы.ПриСозданииНаСервере_ФормаДокумента(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	// Конец АльфаАвто.СобытияОбъектов
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормыКлиент.ПриОткрытии_ФормаДокумента(ЭтотОбъект, Отказ);
	// Конец АльфаАвто.СобытияОбъектов
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормыКлиент.ОбработкаОповещения_ФормаДокумента(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец АльфаАвто.СобытияОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	УправлениеДиалогомНаСервере();
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормы.ПриЧтенииНаСервере_ФормаДокумента(ЭтотОбъект, ТекущийОбъект);
	// Конец АльфаАвто.СобытияОбъектов
	
КонецПроцедуры 

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
		
	РаботаСФормойКлиент.ЗамерВремениЗапись("ВидыСобытий");
		
КонецПроцедуры 

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормы.ПередЗаписьюНаСервере_ФормаДокумента(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	// Конец АльфаАвто.СобытияОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры 

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормы.ПослеЗаписиНаСервере_ФормаДокумента(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец АльфаАвто.СобытияОбъектов
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	УправлениеДиалогомСправочникаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
КонецПроцедуры 

#КонецОбласти

#КонецОбласти