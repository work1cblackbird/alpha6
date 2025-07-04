﻿
#Область ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
// Процедура - обработчик события "Выбор" элемента формы "Список"
//
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле.Имя = "ЕстьЗапись" Тогда
		ПараметрыЗвонка = Новый Структура("ИдентификаторЗвонка, ИдентификаторЗаписи, Ответственный, Входящий, НомерТелефона, ВнутреннийНомер, ДатаНачала, ДатаОкончания, Звонок",
			ТД.ИдентификаторЗвонка, ТД.ИдентификаторЗаписи, ТД.Ответственный, ТД.Входящий, ТД.НомерТелефона, ТД.ВнутреннийНомер, ТД.ДатаНачала, ТД.ДатаОкончания, ТД.Звонок);
		сфпСофтФонПроКлиент.НачатьПрослушиваниеЗаписиРазговора(ПараметрыЗвонка, ЭтаФорма, Элементы.Список);
	КонецЕсли;

КонецПроцедуры // СписокВыбор()

&НаКлиенте
// Процедура - обработчик события "ПередНачаломДобавления" элемента формы "Список"
//
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры // СписокПередНачаломДобавления()

&НаКлиенте
// Процедура - обработчик события "ПередУдалением" элемента формы "Список"
//
Процедура СписокПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры // СписокПередУдалением()

#КонецОбласти

#Область ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
// Процедура - обработчик события формы "ПриСозданииНаСервере"
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭлементыСпискаОтбора = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы;
	Для Каждого ТекущийОтбор Из ЭлементыСпискаОтбора Цикл
		Если ТекущийОтбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
			Если ТекущийОтбор.Представление = "ОтборПоЗвонку" Тогда
				Если Параметры.Свойство("Звонок") Тогда
					ТекущийОтбор.ПравоеЗначение	= Параметры.Звонок;	
					ТекущийОтбор.Использование = Истина;
					ТолькоПросмотр = Истина;
				КонецЕсли;
				
			ИначеЕсли ТекущийОтбор.Представление = "ОтборПоКонтакту" Тогда
				Если Параметры.Свойство("Контакт") Тогда
					Для Каждого ПодчиненныйОтбор Из ТекущийОтбор.Элементы Цикл
						ПодчиненныйОтбор.ПравоеЗначение	= Параметры.Контакт;
					КонецЦикла;
					
					ТекущийОтбор.Использование = Истина;
					ТолькоПросмотр = Истина;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти
