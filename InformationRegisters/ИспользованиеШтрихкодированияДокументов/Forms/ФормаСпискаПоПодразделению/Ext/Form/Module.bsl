﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПодразделениеКомпании") Тогда
		ПодразделениеКомпании = Параметры.ПодразделениеКомпании;	
	КонецЕсли;
	
	ПрочитатьДанныеРегистра();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Отбор.ПодразделениеКомпании.Использование = Истина;
	ТекущийОбъект.Отбор.ПодразделениеКомпании.Значение = ПодразделениеКомпании;
	ТекущийОбъект.Прочитать();
	ТекущийОбъект.Очистить();
	Для Каждого ТекСтрока Из ВидыДокументов Цикл
		НоваяСтрока = ТекущийОбъект.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,ТекСтрока);
		НоваяСтрока.ПодразделениеКомпании = ПодразделениеКомпании;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ПрочитатьДанныеРегистра();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	Для Каждого Строка Из ВидыДокументов Цикл
		Строка.Использование = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеОтметки(Команда)
	
	Для Каждого Строка Из ВидыДокументов Цикл
		Строка.Использование = Ложь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьДанныеРегистра()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ИспользованиеШтрихкодированияДокументов.ВидДокументов,
	               |	ИспользованиеШтрихкодированияДокументов.Использование
	               |ИЗ
	               |	РегистрСведений.ИспользованиеШтрихкодированияДокументов КАК ИспользованиеШтрихкодированияДокументов
	               |ГДЕ
	               |	ИспользованиеШтрихкодированияДокументов.ПодразделениеКомпании = &ПодразделениеКомпании";
	Запрос.УстановитьПараметр("ПодразделениеКомпании",ПодразделениеКомпании);					
	ИспользованиеШтрихкодирования = Запрос.Выполнить().Выгрузить();
	
	ВидыДокументов.Очистить();
	
	Для Каждого ТекущийТип Из Метаданные.РегистрыСведений.ШтрихКоды.Измерения.Объект.Тип.Типы() Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТекущийТип);
		Если НЕ Метаданные.Документы.Содержит(ОбъектМетаданных) Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ВидыДокументов.Добавить();	
		НоваяСтрока.ВидДокументов = ОбъектМетаданных.Имя;
		НоваяСтрока.ВидДокументовПредставление = ОбъектМетаданных.Синоним;
		
		НайденнаяСтрока = ИспользованиеШтрихкодирования.Найти(ОбъектМетаданных.Имя,"ВидДокументов");
		Если НайденнаяСтрока = Неопределено Тогда
			НоваяСтрока.Использование = Истина;
		Иначе
			НоваяСтрока.Использование = НайденнаяСтрока.Использование;
		КонецЕсли;
		ВидыДокументов.Сортировать("ВидДокументовПредставление");
	КонецЦикла
	
КонецПроцедуры

#КонецОбласти