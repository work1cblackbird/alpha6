﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы записи регистра "Кураторы"
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

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьПараметрыВыбораНоменклатуры();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТипНоменклатуры = (ТипЗнч(Запись.Номенклатура) = Тип("СправочникСсылка.Автоработы"));
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Модифицированность Тогда
		ОбновитьХэши();
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипНоменклатурыПриИзменении(Элемент)
	
	ОбновитьПараметрыВыбораНоменклатуры();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьПараметрыВыбораНоменклатуры()
	
	Элементы.Номенклатура.ОграничениеТипа =
		Новый ОписаниеТипов(СтрШаблон("СправочникСсылка.%1", ?(ТипНоменклатуры = 0, "Номенклатура", "Автоработы")));
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьХэши()
	
	Если ТипНоменклатуры Тогда
		Запись.Хеш1 = ОбменСAudaPadWeb.СформироватьХешСтроки(Запись.Артикул+Запись.Наименование);
		Запись.Хеш2 = ОбменСAudaPadWeb.СформироватьХешСтроки(Запись.Артикул+Запись.Наименование+Запись.НаименованиеПолное);
	Иначе
		Запись.Хеш1 = ОбменСAudaPadWeb.СформироватьХешСтроки(Запись.Артикул);
		Запись.Хеш2 = ОбменСAudaPadWeb.СформироватьХешСтроки(Запись.Артикул+Запись.Наименование);
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	
	УправлениеДиалогомРегистраСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры 

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	УправлениеДиалогомРегистраСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
КонецПроцедуры 

#КонецОбласти

#КонецОбласти

