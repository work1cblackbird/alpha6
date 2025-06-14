﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПередЗаписьюОбъекта 			= ПолучитьЗначениеПараметраСтруктуры(Параметры, "ПередЗаписьюОбъекта", "");
	ПриЗаписиОбъекта 				= ПолучитьЗначениеПараметраСтруктуры(Параметры, "ПриЗаписиОбъекта", "");
	ПослеДобавленияСтроки 			= ПолучитьЗначениеПараметраСтруктуры(Параметры, "ПослеДобавленияСтроки", "");
	ПередВыгрузкойОбъекта 			= ПолучитьЗначениеПараметраСтруктуры(Параметры, "ПередВыгрузкойОбъекта", "");
	РежимЗагрузки				 	= ПолучитьЗначениеПараметраСтруктуры(Параметры, "РежимЗагрузки", 0);
	
КонецПроцедуры

// Процедура - обработчик события "ПриОткрытии" формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВладелецФормы = Неопределено ИЛИ НЕ МодальныйРежим Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Определим редактируемые реквизиты
	Если РежимЗагрузки = 2 Тогда
		Элементы.СтраницаПередЗаписьюОбъекта.Заголовок = НСтр("ru = 'Перед записью'");
		Элементы.СтраницаПриЗаписиОбъекта   .Заголовок = НСтр("ru = 'При записи'");
	КонецЕсли;
	
	Элементы.СтраницаПослеДобавленияСтроки.Видимость = (РежимЗагрузки=1) ИЛИ (РежимЗагрузки=3);
	УстановитьНадписьТекстВыражения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "ПриСменеСтраницы"
//
&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УстановитьНадписьТекстВыражения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды "ОК"
//
&НаКлиенте
Процедура ОК(Команда)
	
	Результат = Новый Структура("ПередЗаписьюОбъекта,ПослеДобавленияСтроки,ПриЗаписиОбъекта", ПередЗаписьюОбъекта, ПослеДобавленияСтроки, ПриЗаписиОбъекта);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает текст надписи текста выражения.
//
&НаКлиенте
Процедура УстановитьНадписьТекстВыражения()
	
	Если (РежимЗагрузки =1) ИЛИ (РежимЗагрузки = 3) Тогда
		
		Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПослеДобавленияСтроки Тогда
			
			Элементы.НадписьПояснения.Заголовок =
			НСтр("ru = 'В тексте выражения можно использовать следующие предопределенные параметры:
			|   Объект         - Записываемый объект
			|   ТекущиеДанные  - Содержит данные загружаемой строки табличной части.
			|   ТекстыЯчеек    - массив текстов ячеек строки
			|Встроенные функции, функции общих модулей.'");
			
		Иначе
			
			Элементы.НадписьПояснения.Заголовок =
			НСтр("ru = 'В тексте выражения можно использовать следующие предопределенные параметры:
			|   Объект         - Записываемый объект
			|   Отказ          - Признак отказа от записи объекта
			|Встроенные функции, функции общих модулей.'");
			
		КонецЕсли;
		
	ИначеЕсли РежимЗагрузки =0 Тогда
		
		Элементы.НадписьПояснения.Заголовок =
		НСтр("ru = 'В тексте выражения можно использовать следующие предопределенные параметры:
		|   Объект         - Записываемый объект
		|   Отказ          - Признак отказа от записи объекта
		|   ТекстыЯчеек    - массив текстов ячеек строки
		|Встроенные функции, функции общих модулей.'");
		
	ИначеЕсли РежимЗагрузки =2 Тогда
		
		Элементы.НадписьПояснения.Заголовок =
		НСтр("ru = 'В тексте выражения можно использовать следующие предопределенные параметры:
		|   Объект         - Менеджер записи регистра сведений
		|   Отказ          - Признак отказа от записи объекта
		|   ТекстыЯчеек    - массив текстов ячеек строки
		|Встроенные функции, функции общих модулей.'");
		
	КонецЕсли;
	
КонецПроцедуры // УстановитьНадписьТекстВыражения()

#КонецОбласти

