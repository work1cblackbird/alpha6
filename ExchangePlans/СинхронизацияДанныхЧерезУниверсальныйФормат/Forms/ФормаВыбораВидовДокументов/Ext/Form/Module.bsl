﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ВидыДокументов") Тогда
		ВидыДокументов = Параметры.ВидыДокументов;
	Иначе
		ВидыДокументов = Новый Массив;
	КонецЕсли;
	
	ИмяТаблицыДляЗаполнения = ПолучитьЗначениеПараметраСтруктуры(Параметры, "ИмяТаблицыДляЗаполнения", "ВидыДокументов");
	
	СформироватьДеревоВидовДокументов(ВидыДокументов);
	Элементы.ОтборПоВидамДокументов.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтборПоВидамДокументов

&НаКлиенте
Процедура ОтборПоВидамДокументовПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОтборПоВидамДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ЗначениеОтметки = ТекущиеДанные.Пометка;
		Если ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
			ЗаполнитьОтметки(ЗначениеОтметки, ТекущиеДанные.ПолучитьИдентификатор());
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы 

&НаКлиенте
Процедура СнятьОтметку(Команда)
	
	ЗаполнитьОтметки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	ЗаполнитьОтметки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗакрыть(Команда)
	
	ПараметрыЗакрытияФормы = Новый Структура();
	ПараметрыЗакрытияФормы.Вставить("АдресТаблицыВоВременномХранилище", СформироватьТаблицуВыбранныхЗначений());
	ПараметрыЗакрытияФормы.Вставить("ИмяТаблицыДляЗаполнения", ИмяТаблицыДляЗаполнения);
	
	ОповеститьОВыборе(ПараметрыЗакрытияФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьСтрокуДереваВидовДокументов(ОбъектМетаданных, СтрокаВерхнегоУровня)

	СтрокаДетальныеЗаписи = СтрокаВерхнегоУровня.Строки.Добавить();
	СтрокаДетальныеЗаписи.ИмяОбъектаМетаданных = ОбъектМетаданных.Имя;
	СтрокаДетальныеЗаписи.ПолноеИмяМетаданных = ОбъектМетаданных.ПолноеИмя();
	СтрокаДетальныеЗаписи.Представление = ОбъектМетаданных.Синоним;

КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоВидовДокументов(МассивВыбранныхЗначений)

	ДеревоОтбора = РеквизитФормыВЗначение("ДеревоОтбораПоВидамДокументов", Тип("ДеревоЗначений"));
	ДеревоОтбора.Строки.Очистить();
	
	МетаДокументы = Метаданные.Документы;
	
	Если ИмяТаблицыДляЗаполнения = "ЗапрещенаПовторнаяЗагрузка" Тогда
		СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
		СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Финансы'");
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПлатежноеПоручение, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.Выписка, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПриходныйКассовыйОрдер, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.РасходныйКассовыйОрдер, СтрокаВерхнегоУровня);
	Иначе
		СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
		СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Снабжение'");
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПоступлениеТоваров, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПоступлениеДопРасходов, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПеремещениеТоваров, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетФактураПолученный, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ВозвратПоставщику, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.КорректировкаПоступления, СтрокаВерхнегоУровня);
		
		СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
		СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Финансы'");
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.Взаимозачет, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.КорректировкаДолга, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.АвансовыйОтчет, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПриходныйКассовыйОрдер, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.РасходныйКассовыйОрдер, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.Выписка, СтрокаВерхнегоУровня);
		
		СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
		СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Закупка'");
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетОтПоставщика, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ТаможеннаяДекларацияИмпорт, СтрокаВерхнегоУровня);
		
		СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
		СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Продажи'");
		
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.РеализацияТоваров, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетНаОплату, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетФактураВыданный, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.КорректировкаРеализации, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ЧекНаОплату, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ВозвратОтПокупателя, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ЗакрытиеСмены, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.Инкассация, СтрокаВерхнегоУровня); 
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетКомиссионера, СтрокаВерхнегоУровня);
				
		СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
		СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Автосервис'");
		
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ЗаказНаряд, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПеремещениеТоваровВПроизводство, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ИзвлечениеТоваровИзПроизводства, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПеремещениеНезавершенногоПроизводства, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.РазукомплектацияАвтомобилей, СтрокаВерхнегоУровня);
		
		СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
		СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Склад'");
		
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СписаниеТоваров, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.Комплектация, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.Разукомплектация, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПересортицаТоваров, СтрокаВерхнегоУровня);
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.Инвентаризация, СтрокаВерхнегоУровня); 
		
		СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
		СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Интеркампани'");
		
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПередачаТоваровМеждуОрганизациями, СтрокаВерхнегоУровня); 
		
		СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
		СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Прочие активы'");
		
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ВводВЭксплуатацию, СтрокаВерхнегоУровня); 
		ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СписаниеАктивов, СтрокаВерхнегоУровня);

		Если ПолучитьФункциональнуюОпцию("ДоступенАвтосалон") Тогда
			
			СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
			СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Снабжение автосалона'");
			ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПоступлениеАвтомобилей, СтрокаВерхнегоУровня);
			ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ВозвратПоставщикуАвтомобилей, СтрокаВерхнегоУровня);
			ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПеремещениеАвтомобилей, СтрокаВерхнегоУровня);
			ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.КорректировкаПоступленияАвтомобилей, СтрокаВерхнегоУровня);
			ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетОтПоставщикаЗаАвтомобили, СтрокаВерхнегоУровня);
			
			СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
			СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Продажа автомобилей'");
			ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетНаОплатуЗаАвтомобили, СтрокаВерхнегоУровня);
			ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.РеализацияАвтомобилей, СтрокаВерхнегоУровня); 
			ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ВозвратОтПокупателяАвтомобилей, СтрокаВерхнегоУровня);
			ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.КорректировкаРеализацииАвтомобилей, СтрокаВерхнегоУровня);
			
			СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
			СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Склад автосалона'");
			ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ИнвентаризацияАвтомобилей, СтрокаВерхнегоУровня);
			ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СписаниеАвтомобилей, СтрокаВерхнегоУровня);
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
	СтрокаВерхнегоУровня.Представление = НСтр("ru = 'Прослеживаемые товары'");
	
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.УведомлениеОбОстаткахПрослеживаемыхТоваров, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.УведомлениеОВвозеПрослеживаемыхТоваров, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.УведомлениеОПеремещенииПрослеживаемыхТоваров, СтрокаВерхнегоУровня);
	
	Для каждого СтрокаВерхнегоУровня Из ДеревоОтбора.Строки Цикл
		ВыбраныВсеЭлементы = Истина;
		Для каждого СтрокаДетальныеЗаписи Из СтрокаВерхнегоУровня.Строки Цикл
			Если МассивВыбранныхЗначений.Найти(СтрокаДетальныеЗаписи.ИмяОбъектаМетаданных) = Неопределено Тогда
				ВыбраныВсеЭлементы = Ложь;
			Иначе
				СтрокаДетальныеЗаписи.Пометка = Истина;
			КонецЕсли;
			СтрокаДетальныеЗаписи.ИндексКартинки = -1;
		КонецЦикла;
		Если ВыбраныВсеЭлементы Тогда
			СтрокаВерхнегоУровня.Пометка = Истина;
		КонецЕсли;
		СтрокаВерхнегоУровня.ИндексКартинки = 0;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоОтбора, "ДеревоОтбораПоВидамДокументов");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОтметки(ЗначениеОтметки, ИдентификаторЭлемента = Неопределено)
	Если ИдентификаторЭлемента <> Неопределено Тогда
		ЭлементДерева = ДеревоОтбораПоВидамДокументов.НайтиПоИдентификатору(ИдентификаторЭлемента);
		ЭлементыНижнегоУровня = ЭлементДерева.ПолучитьЭлементы();
		Для Каждого ЭлементНижнегоУровня Из ЭлементыНижнегоУровня Цикл
			ЭлементНижнегоУровня.Пометка = ЗначениеОтметки;
		КонецЦикла;
	Иначе
		ЭлементыВерхнегоУровня = ДеревоОтбораПоВидамДокументов.ПолучитьЭлементы();
		Для Каждого ЭлементВерхнегоУровня Из ЭлементыВерхнегоУровня Цикл
			ЭлементВерхнегоУровня.Пометка = ЗначениеОтметки;
			ЭлементыНижнегоУровня = ЭлементВерхнегоУровня.ПолучитьЭлементы();
			Для каждого ЭлементНижнегоУровня Из ЭлементыНижнегоУровня Цикл
				ЭлементНижнегоУровня.Пометка = ЗначениеОтметки;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьТаблицуВыбранныхЗначений()

	ТаблицаВыбранныхЗначений = Новый ТаблицаЗначений;
	ТаблицаВыбранныхЗначений.Колонки.Добавить("ИмяОбъектаМетаданных");
	ТаблицаВыбранныхЗначений.Колонки.Добавить("Представление");
	ТаблицаВыбранныхЗначений.Колонки.Добавить("Использовать");
	
	ЭлементыВерхнегоУровня = ДеревоОтбораПоВидамДокументов.ПолучитьЭлементы();
	Для каждого ЭлементВерхнегоУровня Из ЭлементыВерхнегоУровня Цикл
		ЭлементыДетальныхЗаписей = ЭлементВерхнегоУровня.ПолучитьЭлементы();
		Для каждого ЭлементДетальныхЗаписей Из ЭлементыДетальныхЗаписей Цикл
			Если Не ЭлементДетальныхЗаписей.Пометка Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрока = ТаблицаВыбранныхЗначений.Добавить();
			НоваяСтрока.ИмяОбъектаМетаданных = ЭлементДетальныхЗаписей.ИмяОбъектаМетаданных;
			НоваяСтрока.Представление = ЭлементДетальныхЗаписей.Представление;
			НоваяСтрока.Использовать = Истина;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаВыбранныхЗначений, УникальныйИдентификатор);

КонецФункции

#КонецОбласти


