﻿
// Альфа-Авто

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обработчик обновления на версию 6.1.03.12
//
Процедура ЗаполнитьНеКорректныеЭлементыДаннымиПоУмолчанию() Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиВерсионированияОбъектов.ТипОбъекта КАК ТипОбъекта,
		|	НастройкиВерсионированияОбъектов.Вариант КАК Вариант,
		|	НастройкиВерсионированияОбъектов.Использовать КАК Использовать,
		|	НастройкиВерсионированияОбъектов.СрокХраненияВерсий КАК СрокХраненияВерсий
		|ИЗ
		|	РегистрСведений.НастройкиВерсионированияОбъектов КАК НастройкиВерсионированияОбъектов";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиВерсионирования = РезультатЗапроса.Выгрузить();
	
	НаборЗаписей = РегистрыСведений.НастройкиВерсионированияОбъектов.СоздатьНаборЗаписей();
	
	Для Каждого ТекНастройка Из НастройкиВерсионирования Цикл
		
		Запись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, ТекНастройка);
		Запись.Вариант = ?(ЗначениеЗаполнено(ТекНастройка.Вариант), ТекНастройка.Вариант, Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать);
		Запись.Использовать = ТекНастройка.Вариант <> Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать;
		Запись.СрокХраненияВерсий = ?(ЗначениеЗаполнено(ТекНастройка.СрокХраненияВерсий), ТекНастройка.СрокХраненияВерсий, Перечисления.СрокиХраненияВерсий.Бессрочно);		
		
	КонецЦикла;
	
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

// Конец Альфа-Авто