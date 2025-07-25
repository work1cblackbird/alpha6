﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы списка регистра "Опции автомобилей"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСФормой.НастроитьОсновнойДинамическийСписокФормы(ЭтотОбъект);
	
	ТолькоАктивные = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить(ЭтотОбъект.ИмяФормы, "ТолькоАктивные", Истина);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТолькоАктивныеПриИзменении();
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Настройки.Вставить("ТолькоАктивные", ТолькоАктивные);

КонецПроцедуры 

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ТолькоАктивные = Настройки.Получить("ТолькоАктивные");
	ТолькоАктивныеПриИзменении();

КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	// ОценкаПроизводительности
	Если Копирование Тогда
		ОценкаПроизводительностиКлиент.ЗамерВремени("КопированиеРегистраСведенийОпцииАвтомобилей");
	Иначе
		ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеРегистраСведенийОпцииАвтомобилей");
	КонецЕсли;
	// Конец ОценкаПроизводительности
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеЗаписиРегистраСведенийОпцииАвтомобилей");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура АктивацияОтбора(Команда)
	
	ТолькоАктивные = НЕ ТолькоАктивные;
	ТолькоАктивныеПриИзменении();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура ТолькоАктивныеПриИзменении()
	
	Если ТолькоАктивные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ЗаписьАктивна", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ЗаписьАктивна",,,,Ложь);
	КонецЕсли;
	
	Элементы.ФормаАктивацияОтбора.Пометка = ТолькоАктивные;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

