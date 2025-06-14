﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Выражение 		= ПолучитьЗначениеПараметраСтруктуры(Параметры, "Выражение", "");
	Представление 	= ПолучитьЗначениеПараметраСтруктуры(Параметры, "Представление", "");
	
КонецПроцедуры

// Процедура - обработчик события "ПриОткрытии" формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВладелецФормы = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПриОткрытии()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды "ОК"
//
&НаКлиенте
Процедура ОК(Команда)
	
	Если ПустаяСтрока(Представление) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю (НСтр("ru = 'Поле ""Представление"" не заполнено.'"));
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура("Представление, Выражение", Представление, Выражение);
	Закрыть(Результат);
	
КонецПроцедуры

// Процедура - обработчик команды "ШтрихКодНоменклатуры"
//
&НаКлиенте
Процедура ШтрихКодНоменклатуры(Команда)
	УстановитьТекстШаблона("ШтрихКодНоменклатуры");
КонецПроцедуры

// Процедура - обработчик команды "ШаблонСтрока"
//
&НаКлиенте
Процедура ШаблонСтрока(Команда)
	УстановитьТекстШаблона("Строка");
КонецПроцедуры

// Процедура - обработчик команды "ШаблонЧисло"
//
&НаКлиенте
Процедура ШаблонЧисло(Команда)
	УстановитьТекстШаблона("Число");
КонецПроцедуры

// Процедура - обработчик команды "ШаблонДата"
//
&НаКлиенте
Процедура ШаблонДата(Команда)
	УстановитьТекстШаблона("Дата");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура установки текста шаблона на форму
//
&НаКлиенте
Процедура УстановитьТекстШаблона(Шаблон)
	
	НовоеПредставление = "";
	Текст = "";
	Если Шаблон = "ШтрихКодНоменклатуры" Тогда
		Текст = 
		"// Штрихкод номенклатуры (для документов)
		|// Данный фрагмент построен при помощи предопределенного шаблона.
		|// При повторном использовании шаблона, внесенные вручную изменения будут утеряны.
		|Результат = """";
		|
		|НаборЗаписей = РегистрыСведений.Штрихкоды.СоздатьНаборЗаписей();
		|НаборЗаписей.Отбор.Объект.Установить(ТекущиеДанные.Номенклатура);
		|НаборЗаписей.Прочитать();
		|Если НаборЗаписей.Количество()>0 Тогда
		|	Результат = НаборЗаписей[0].Штрихкод;
		|КонецЕсли;";
		НовоеПредставление = НСтр("ru = 'Штрихкод'");
	ИначеЕсли Шаблон = "Строка" Тогда
		Строка = "";
		ПоказатьВводСтроки(Новый ОписаниеОповещения("УстановитьТекстШаблонаСтрокаЗавершение", ЭтотОбъект, Новый Структура("Шаблон, Строка", Шаблон, Строка)), Строка, "Строка");
        Возврат;
		
	ИначеЕсли Шаблон = "Число" Тогда
		Число = "";
		ПоказатьВводЧисла(Новый ОписаниеОповещения("УстановитьТекстШаблонаЧислоЗавершение", ЭтотОбъект, Новый Структура("Шаблон, Число", Шаблон, Число)), Число, "Число");
        Возврат;
		
	ИначеЕсли Шаблон = "Дата" Тогда
		Дата = "";
		ПоказатьВводДаты(Новый ОписаниеОповещения("УстановитьТекстШаблонаДатаЗавершение", ЭтотОбъект, Новый Структура("Дата", Дата)), Дата, "Дата", ЧастиДаты.Дата);
        Возврат;

	КонецЕсли;
	
	УстановитьТекстШаблонаОбщиеДействия(НовоеПредставление, Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекстШаблонаДатаЗавершение(Дата, ДополнительныеПараметры) Экспорт
    
    Дата = ?(Дата = Неопределено, ДополнительныеПараметры.Дата, Дата);
    
    
    Если НЕ (Дата <> Неопределено) Тогда
        Возврат;
    КонецЕсли;
    Текст = "Результат = '"+Формат(Дата,"ДФ=yyyyMMdd; ДП=00000000")+"';";
    НовоеПредставление = НСтр("ru = 'Дата'") + " ("+Формат(Дата,"ДЛФ=D")+")";
    
    УстановитьТекстШаблонаОбщиеДействия(НовоеПредставление, Текст);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекстШаблонаЧислоЗавершение(Число, ДополнительныеПараметры) Экспорт
    
    Шаблон = ДополнительныеПараметры.Шаблон;
    Число = ?(Число = Неопределено, ДополнительныеПараметры.Число, Число);
    
    
    Если НЕ (Число <> Неопределено) Тогда
        Возврат;
    КонецЕсли;
    Текст = "Результат = "+Формат(Число,"ЧРД=.; ЧН=; ЧГ=0")+";";
    НовоеПредставление = НСтр("ru = 'Число'") + " ("+Число+")";
    
    УстановитьТекстШаблонаОбщиеДействия(НовоеПредставление, Текст);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекстШаблонаСтрокаЗавершение(Строка, ДополнительныеПараметры) Экспорт
    
    Шаблон = ДополнительныеПараметры.Шаблон;
    Строка = ?(Строка = Неопределено, ДополнительныеПараметры.Строка, Строка);
    
    Если НЕ (Строка <> Неопределено) Тогда
        Возврат;
    КонецЕсли;
    Текст = "Результат = """+СтрЗаменить(Строка,"""","""""")+""";";
    НовоеПредставление = НСтр("ru = 'Строка'") + " ("+Строка+")";
    
    УстановитьТекстШаблонаОбщиеДействия(НовоеПредставление, Текст);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекстШаблонаОбщиеДействия(Знач НовоеПредставление, Знач Текст)
    
    Перем ТекстВопроса;
    
    Если НЕ ПустаяСтрока(Текст) Тогда
        ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Текущее выражение будет заменено.%1Продолжить?'"), Символы.ПС);
        ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьТекстШаблонаОбщиеДействияЗавершение", ЭтотОбъект, Новый Структура("НовоеПредставление, Текст", НовоеПредставление, Текст)), ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекстШаблонаОбщиеДействияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    НовоеПредставление = ДополнительныеПараметры.НовоеПредставление;
    Текст = ДополнительныеПараметры.Текст;
    
    Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
        Возврат;
    КонецЕсли;
    Представление = НовоеПредставление;
    Выражение = Текст;

КонецПроцедуры // УстановитьТекстШаблонаОбщиеДействия()

#КонецОбласти



