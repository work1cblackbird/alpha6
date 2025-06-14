﻿
#Область ПрограммныйИнтерфейс

// Общий обработчик события возникающего при открытии настройки параметров документа.
//
// Параметры:
//  СсылкаНаОбъект     	- ДокументСсылка 	- Ссылка на объект, для которого выполняется обработка события.
//  ПараметрыДействия 	- Структура 		- Набор параметров, использующихся при выполнения операции.
//
Процедура НастроитьПараметрыДокумента(СсылкаНаОбъект, ПараметрыДействия = Неопределено) Экспорт
	
	Форма = ПараметрыДействия.Форма;
	Объект = Неопределено;
	
	ПолучитьОсновнойОбъектФормы(Форма, Объект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Объект", Объект);
	ПараметрыФормы.Вставить("ТолькоПросмотр", Форма.ТолькоПросмотр);
	ПараметрыФормы.Вставить("ИдентификаторФормы", Форма.УникальныйИдентификатор);
	ПараметрыФормы.Вставить("НеотображаемыеРеквизиты", Новый Массив);
	
	// Для выполненных заказ-нарядов запретить параметры документа к редактированию
	Если ТипЗнч(СсылкаНаОбъект) = Тип("ДокументСсылка.ЗаказНаряд")
		И (ПараметрыДействия.Источник.Состояние = ПредопределенноеЗначение("Справочник.ВидыСостоянийЗаказНарядов.Закрыт")
		ИЛИ ПараметрыДействия.Источник.Состояние = ПредопределенноеЗначение("Справочник.ВидыСостоянийЗаказНарядов.Выполнен")) Тогда
	
		ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
	КонецЕсли;
	
	Если ТипЗнч(СсылкаНаОбъект) = Тип("ДокументСсылка.Переоценка") Тогда
		МассивРеквизитов = Новый Массив();
		МассивРеквизитов.Добавить("ТипЦен");
		ПараметрыФормы.НеотображаемыеРеквизиты = МассивРеквизитов;
	КонецЕсли;
	
	Если ЕстьРеквизитНаКлиенте(Объект, "ХозОперация") Тогда
		ПараметрыФормы.Вставить("Операция", Объект.ХозОперация);
	КонецЕсли;

	Если ЕстьРеквизитНаКлиенте(Форма, "ПараметрыДокумента") Тогда
		ПараметрыФормы.Вставить("ПоказыватьПараметрыДокумента",Форма.Элементы.ПараметрыДокумента.Видимость);
	КонецЕсли;

	Если ЕстьРеквизитНаКлиенте(Форма, "Штрихкод") Тогда
		ПараметрыФормы.Вставить("Штрихкод",Форма.Штрихкод);
	КонецЕсли;

	Если Форма.Элементы.Найти("ДокументОснование") <> Неопределено
		И Форма.Элементы.ДокументОснование.Вид = ВидПоляФормы.ПолеВвода Тогда
		
		ПараметрыФормы.Вставить("ПараметрыВыбораДокументаОснование",Форма.Элементы.ДокументОснование.ПараметрыВыбора);
		ПараметрыФормы.Вставить("ОграничениеТипаДокументаОснование",Форма.Элементы.ДокументОснование.ОграничениеТипа);
	КонецЕсли;

	Если НЕ ПараметрыДействия = Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыФормы,ПараметрыДействия);
	КонецЕсли;

	ПараметрыФормы.Вставить(
		"ДопПараметры",
		ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "ДопПараметры", Неопределено)
	);

	ОткрытьФорму(
		"ОбщаяФорма.ПараметрыДокумента",
		ПараметрыФормы,
		Форма,
		, , ,
		Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаЗакрытияПараметровДокумента", Форма, "ПараметрыДокумента")
	);
	
КонецПроцедуры

#КонецОбласти

