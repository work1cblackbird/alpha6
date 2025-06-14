﻿#Область ПрограммныйИнтерфейс

#Область РаботаСФормамиОбъектовИБ

// См. СопоставлениеНоменклатурыКонтрагентовКлиентПереопределяемый.ПриСозданииНоменклатурыПоДаннымКонтрагента
Процедура ПриСозданииНоменклатурыПоДаннымКонтрагента(Знач НаборНоменклатурыКонтрагентов, Знач ОповещениеОЗавершении, СтандартнаяОбработка = Истина) Экспорт
	
	
	
КонецПроцедуры

// См. СопоставлениеНоменклатурыКонтрагентовКлиентПереопределяемый.ОткрытьФормуНоменклатуры
Процедура ОткрытьФормуНоменклатуры(Знач Параметры, Знач Владелец, Знач Уникальность, Знач ОповещениеОЗакрытии) Экспорт

	СписокЗначений = Новый СписокЗначений();
	СписокЗначений.Добавить("Автомобиль");
	СписокЗначений.Добавить("Товар");  
	
	СписокПараметров = Новый Структура("Параметры, Владелец, Уникальность, ОповещениеОЗакрытии", 
										Параметры, Владелец, Уникальность, ОповещениеОЗакрытии);
	
	ВариантСопоставления = СопоставлениеНоменклатурыКонтрагентовАльфаАвтоВызовСервера.ВариантПоискаНоменклатуры();
	
	ВидСправочника = Неопределено;
	Если ВариантСопоставления = 1 Тогда
		ВидСправочника = СписокЗначений.НайтиПоЗначению("Номенклатура");
	ИначеЕсли ВариантСопоставления = 2 Тогда
		ВидСправочника = СписокЗначений.НайтиПоЗначению("Автомобиль");
	КонецЕсли;
	
	Если ВидСправочника <> Неопределено Тогда
		ОбработкаВыбораТипаНоменклатуры(ВидСправочника, СписокПараметров);
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораТипаНоменклатуры", ЭтотОбъект, СписокПараметров); 
	СписокЗначений.ПоказатьВыборЭлемента(ОписаниеОповещения, "Тип создаваемой номенклатуры");
		
КонецПроцедуры  

// Выполняет открытие формы в зависимости от переданного типа элемента
// 
// Параметры:
//  ВыбранныйЭлемент - СписокЗначений - товар, автомобиль
//  СписокПараметров - Структура - параметры выполнения операции
//
Процедура ОбработкаВыбораТипаНоменклатуры(ВыбранныйЭлемент, СписокПараметров) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйЭлемент.Значение = "Автомобиль" Тогда 
		ОткрытьФорму(
		"Справочник.Автомобили.ФормаОбъекта",
		СписокПараметров.Параметры,
		СписокПараметров.Владелец,
		СписокПараметров.Уникальность,
		,
		,
		СписокПараметров.ОповещениеОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
		); 
	ИначеЕсли ВыбранныйЭлемент.Значение = "Товар" Тогда
		ОткрытьФорму(
		"Справочник.Номенклатура.ФормаОбъекта",
		СписокПараметров.Параметры,
		СписокПараметров.Владелец,
		СписокПараметров.Уникальность,
		,
		,
		СписокПараметров.ОповещениеОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
		); 
	КонецЕсли;

КонецПроцедуры

// См. СопоставлениеНоменклатурыКонтрагентовКлиентПереопределяемый.ОткрытьФормуВыбораНоменклатуры
Процедура ОткрытьФормуВыбораНоменклатуры(Знач Параметры, Знач Владелец, Знач Уникальность) Экспорт

	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
