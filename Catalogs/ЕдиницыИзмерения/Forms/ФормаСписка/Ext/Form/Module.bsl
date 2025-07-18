﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") И НЕ Параметры.Отбор.Свойство("Владелец") Тогда
		ОбщегоНазначения.СообщитьПользователю(
		 НСтр("ru='Справочник единиц измерения без указания владельца не имеет смысла. Используйте для открытия единиц справочники ""Номенклатура"" или ""Типы номенклатуры"" .'"),,,,Отказ);
		Возврат;
	КонецЕсли;
	
	// Определим по типу номенклатуры, какой объект является владельцем единиц измерения.
	УстановитьЗаголовок = Ложь;
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда
		
		Владелец = Параметры.Отбор.Владелец;
		
		Если НЕ ОбщегоНазначения.ОбъектЯвляетсяГруппой(Владелец) Тогда
			
			ДанныеВладельца = ВладелецЕдиницИзмерения(Владелец);
			Параметры.Отбор.Владелец = ДанныеВладельца.ВладелецДляОтбора;
			УстановитьЗаголовок = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	РаботаСФормой.СкрытьЭлементыНедоступныеПоКлючу(ЭтотОбъект);
	
	РаботаСФормой.УстановитьРежимВыбора(ЭтотОбъект, Элементы.Список, Параметры);
	
	РаботаСФормой.НастроитьОсновнойДинамическийСписокФормы(ЭтотОбъект);
	
	Закрепить = Параметры.Свойство("ЗакрепитьСПрава");
	
	//Если УстановитьЗаголовок Тогда
	//	
	//	УстановитьЗаголовокФормы(ЭтотОбъект, ДанныеВладельца);
	//	
	//КонецЕсли;
	//
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	Если Закрепить Тогда
		
		УправлениеДиалогомКлиент.ЗакрепитьФорму();
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ПараметрыДействия = Новый Структура;
	
	Если ИмяСобытия = "АктивизацияСтрокиНоменклатуры" И Источник = ВладелецФормы Тогда
		
		ДанныеВладельца = ВладелецЕдиницИзмерения(Параметр);
		
		Если ДанныеВладельца.ВладелецДляОтбора = Неопределено Тогда
			
			Доступность = Ложь;
			ДанныеВладельца.ВладелецДляОтбора     = "";
			ДанныеВладельца.ОбщиеЕдиницыИзмерения = Ложь;
			
		Иначе
			
			Доступность = Истина;
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Владелец",
			ДанныеВладельца.ВладелецДляОтбора,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина
		);
		
		УстановитьЗаголовокФормы(ЭтотОбъект, ДанныеВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	РаботаСФормойКлиент.УстановитьТекущуюСтрокуНаНовыйОбъект(Элементы.Список, НовыйОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры 

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Группа Тогда
		
		Возврат;
		
	КонецЕсли;
	
	// ОценкаПроизводительности
	Если Копирование Тогда
		
		ОценкаПроизводительностиКлиент.ЗамерВремени("КопированиеСправочникаЕдиницыИзмерения");
		
	Иначе
		
		ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеФормыСправочникаЕдиницыИзмерения");
		
	КонецЕсли;
	// Конец ОценкаПроизводительности

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Если
		ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Элемент.ТекущиеДанные, "ЭтоГруппа")
		И Элемент.ТекущиеДанные.ЭтоГруппа
	Тогда
		
		Возврат;
		
	КонецЕсли;
	
	// ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеФормыСправочникаЕдиницыИзмерения");
	// Конец ОценкаПроизводительности

КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
    
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
    
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
    
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
    
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаСервереБезКонтекста
Функция ВладелецЕдиницИзмерения(Владелец)
	
	ВладелецДляОтбора = Неопределено;
	ОбщиеЕдиницыИзмерения = Неопределено;
	
	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		
		НеобходимыеРеквизиты = Новый Структура;
		НеобходимыеРеквизиты.Вставить("ТипНоменклатуры", "ТипНоменклатуры");
		НеобходимыеРеквизиты.Вставить("ИспользованиеЕдиницИзмерения", "ТипНоменклатуры.ИспользованиеЕдиницИзмерения");
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, НеобходимыеРеквизиты);
		РеквизитыОбъекта.Вставить("Номенклатура", Владелец);
		
	ИначеЕсли ТипЗнч(Владелец) = Тип("СправочникСсылка.ТипыНоменклатуры") Тогда
		
		НеобходимыеРеквизиты = Новый Структура;
		НеобходимыеРеквизиты.Вставить("ИспользованиеЕдиницИзмерения", "ИспользованиеЕдиницИзмерения");
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, НеобходимыеРеквизиты);
		РеквизитыОбъекта.Вставить("ТипНоменклатуры", Владелец);
		РеквизитыОбъекта.Вставить("Номенклатура", Неопределено);
		
	КонецЕсли;
	
	Если РеквизитыОбъекта = Неопределено Тогда
		Возврат Новый Структура("ВладелецДляОтбора,ОбщиеЕдиницыИзмерения", "", Ложь);
	КонецЕсли;
	
	Если РеквизитыОбъекта.ИспользованиеЕдиницИзмерения = 1 Тогда
		ВладелецДляОтбора = РеквизитыОбъекта.ТипНоменклатуры;
		ОбщиеЕдиницыИзмерения = Истина;
	ИначеЕсли РеквизитыОбъекта.ИспользованиеЕдиницИзмерения = 2 Тогда
		ВладелецДляОтбора = РеквизитыОбъекта.Номенклатура;
		ОбщиеЕдиницыИзмерения = Ложь;
	КонецЕсли;
	
	Возврат Новый Структура("ВладелецДляОтбора,ОбщиеЕдиницыИзмерения", ВладелецДляОтбора, ОбщиеЕдиницыИзмерения);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокФормы(Форма, ДанныеВладельца)
	
	ПредставлениеВладельца = ?(ДанныеВладельца.ВладелецДляОтбора = Неопределено, "", СтрШаблон("(%1)", СокрЛП(ДанныеВладельца.ВладелецДляОтбора)));
	
	Если ДанныеВладельца.ОбщиеЕдиницыИзмерения Тогда
		ШаблонЗаголовка = НСтр("ru = 'Единицы измерения общие для вида номенклатуры %1'");
	Иначе
		ШаблонЗаголовка = НСтр("ru = 'Единицы измерения %1'");
	КонецЕсли;
	
	ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка, ПредставлениеВладельца);
	Форма.АвтоЗаголовок = Ложь;
	Форма.Заголовок = ТекстЗаголовка;
	Форма.Элементы.Список.ТолькоПросмотр = (ДанныеВладельца.ОбщиеЕдиницыИзмерения=Неопределено ИЛИ НЕ ЗначениеЗаполнено(ДанныеВладельца.ВладелецДляОтбора));
	
КонецПроцедуры

#КонецОбласти

