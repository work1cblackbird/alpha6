﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Модель              = ПолучитьЗначениеПараметраСтруктуры(Параметры, "Модель", Неопределено);
	ВариантКомплектации = ПолучитьЗначениеПараметраСтруктуры(Параметры, "ВариантКомплектации", Неопределено);
	Салон               = ПолучитьЗначениеПараметраСтруктуры(Параметры, "ТипСалона", Неопределено);
	Марка               = ПолучитьЗначениеПараметраСтруктуры(Параметры, "Марка", Неопределено);
	
	Элементы.Шапка.Видимость = Элементы.УстановитьОтбор.Пометка;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	ОбновитьОтбор();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТолькоЗаказанныеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Заказан", Истина, ВидСравненияКомпоновкиДанных.Равно,, ТолькоЗаказанные);

КонецПроцедуры

&НаКлиенте
Процедура МодельПриИзменении(Элемент)
	
	ОбновитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура МаркаПриИзменении(Элемент)
	
	ОбновитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантКомплектацииПриИзменении(Элемент)
	
	ОбновитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура СалонПриИзменении(Элемент)
	
	ОбновитьОтбор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Список.ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Если Элементы.Список.ТекущиеДанные.ЭтоГруппа И Элементы.Список.Развернут(Элементы.Список.ТекущаяСтрока) Тогда
		Элементы.Список.Свернуть(Элементы.Список.ТекущаяСтрока);
	ИначеЕсли НЕ Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда
		Закрыть(Элементы.Список.ТекущиеДанные.Ссылка);
	Иначе
		Элементы.Список.Развернуть(Элементы.Список.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если НЕ Элементы.Список.ТекущиеДанные = Неопределено И НЕ Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда
		Закрыть(Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьПанельОтборов(Команда)
	
	Элементы.УстановитьОтбор.Пометка = НЕ Элементы.УстановитьОтбор.Пометка;
	Элементы.Шапка.Видимость         = Элементы.УстановитьОтбор.Пометка;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьОтбор()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Марка", Марка, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Марка));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Модель", Модель, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Модель));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ВариантКомплектации", ВариантКомплектации, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ВариантКомплектации));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ТипСалона", Салон, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Салон));
	
КонецПроцедуры

#КонецОбласти

