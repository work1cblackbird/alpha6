﻿		 		 
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьРеквизитыИнформации()
	ВыводимыеОбластиШапки = Новый Массив; ВыводимыеОбластиСтроки = Новый Массив;
	ВыводитьЗаказНаряд = (РазличныеЗаказНаряды.Количество() > 1);
	
	Отбор = Новый Структура("ХарактеристикаНоменклатуры", Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
	ВыводитьХарактеристику = (ЗаказНаряды.НайтиСтроки(Отбор).Количество() <> ЗаказНаряды.Количество());
	
	ТабличныйДокумент.Очистить();
	
	// подготовим области макета
	Макет = ПолучитьОбщийМакет("ИнформацииОбОстаткахНоменклатурыВЗаказНаряде");
	
	ТабличныйДокумент.ФиксацияСлева = 7;
	Если ВыводитьЗаказНаряд Тогда
		ВыводимыеОбластиШапки.Добавить(Макет.ПолучитьОбласть("Шапка|ЗаказНаряд"));
		ВыводимыеОбластиСтроки.Добавить(Макет.ПолучитьОбласть("Строка|ЗаказНаряд"));
		ТабличныйДокумент.ФиксацияСлева = ТабличныйДокумент.ФиксацияСлева + 4;
	КонецЕсли;
	
	ВыводимыеОбластиШапки.Добавить(Макет.ПолучитьОбласть("Шапка|Номенклатура"));
	ВыводимыеОбластиСтроки.Добавить(Макет.ПолучитьОбласть("Строка|Номенклатура"));
	
	Если ВыводитьХарактеристику Тогда
		ВыводимыеОбластиШапки.Добавить(Макет.ПолучитьОбласть("Шапка|Характеристика"));
		ВыводимыеОбластиСтроки.Добавить(Макет.ПолучитьОбласть("Строка|Характеристика"));
		ТабличныйДокумент.ФиксацияСлева = ТабличныйДокумент.ФиксацияСлева + 4;
	КонецЕсли;
	
	ВыводимыеОбластиШапки.Добавить(Макет.ПолучитьОбласть("Шапка|Прочее"));
	ВыводимыеОбластиСтроки.Добавить(Макет.ПолучитьОбласть("Строка|Прочее"));
	
	Отступ = Макет.ПолучитьОбласть("Отступ");
	
	Первый = Истина;
	Для Каждого Область Из ВыводимыеОбластиШапки Цикл
		Если Первый Тогда
			ТабличныйДокумент.Вывести(Область);
			Первый = Ложь;
		Иначе
			ТабличныйДокумент.Присоединить(Область);
		КонецЕсли;
	КонецЦикла;
	
	УровеньСтрок = ?(ВыводитьЗаказНаряд, 2, 1);
	
	Для Каждого ЗаказНаряд Из РазличныеЗаказНаряды Цикл
		ТоварыЗаказНаряда = ЗаказНаряды.НайтиСтроки(Новый Структура("ЗаказНаряд", ЗаказНаряд.Значение));
		
		// заполним доп поля товаров
		ПоказателиЗапасов = Документы.ЗаказНаряд.ПолучитьПоказателиЗапасов(ЗаказНаряд.Значение, ЗаказНаряды.Выгрузить(ТоварыЗаказНаряда));
		
		Если ПоказателиЗапасов.Количество() = 0 Тогда
			ЗакрытыйЗаказНаряд = Макет.ПолучитьОбласть("ЗакрытыйЗаказНаряд");
			ЗакрытыйЗаказНаряд.Параметры.Заполнить(Новый Структура("ЗаказНаряд", ЗаказНаряд.Значение));
			ТабличныйДокумент.Вывести(ЗакрытыйЗаказНаряд);
			ТабличныйДокумент.Вывести(Отступ);
			Продолжить;
		КонецЕсли;
		
		ТабличныйДокумент.НачатьАвтогруппировкуСтрок();
		
		Если ВыводитьЗаказНаряд Тогда
			ВыводимыеОбластиСтроки[0].Параметры.ЗаказНаряд = ЗаказНаряд.Значение;
			ТабличныйДокумент.Вывести(ВыводимыеОбластиСтроки[0], 1);
		КонецЕсли;
		
		Для Каждого Показатель Из ПоказателиЗапасов Цикл
			Первый = Истина;
			Для Каждого Область Из ВыводимыеОбластиСтроки Цикл
				Область.Параметры.Заполнить(Показатель);
				Область.Параметры.Заполнить(Показатель.Номенклатура);
				Если Первый Тогда
					ТабличныйДокумент.Вывести(Область, УровеньСтрок);
					Первый = Ложь;
				Иначе
					ТабличныйДокумент.Присоединить(Область, УровеньСтрок);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		ТабличныйДокумент.ЗакончитьАвтогруппировкуСтрок();
		
		Если ВыводитьЗаказНаряд Тогда
			ТабличныйДокумент.Вывести(Отступ);
		КонецЕсли;
	КонецЦикла;
	
	ТабличныйДокумент.ФиксацияСверху = 2;
	ТабличныйДокумент.Защита = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РазличныеЗаказНаряды = Новый СписокЗначений;
	
	АдресТаблицыВоВременномХранилище =
		ПолучитьЗначениеПараметраСтруктуры(Параметры, "АдресТаблицыВоВременномХранилище", "");
		
	Если НЕ ЭтоАдресВременногоХранилища(АдресТаблицыВоВременномХранилище) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаказНаряды.Очистить();
	
	// заполним таблицу заказ-нарядов
	ТаблицаДокумента = ПолучитьИзВременногоХранилища(АдресТаблицыВоВременномХранилище);
	Для Каждого СтрокаДокумента Из ТаблицаДокумента Цикл
		Если РазличныеЗаказНаряды.НайтиПоЗначению(СтрокаДокумента.ЗаказНаряд) = Неопределено Тогда
			РазличныеЗаказНаряды.Добавить(СтрокаДокумента.ЗаказНаряд);
		КонецЕсли;
		
		НоваяСтрока = ЗаказНаряды.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДокумента);
	КонецЦикла;
	
	ЗаполнитьРеквизитыИнформации();
	
КонецПроцедуры

#КонецОбласти