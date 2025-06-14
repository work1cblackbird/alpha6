﻿#Область ПрограммныйИнтерфейс

// Проверяем доступность опции для комплектации
//
// Параметры:
//  Опция - СправочникСсылка.Опция - опция
//  Комплектация - СправочникСсылка.ВариантыКомплектации - комплектация
// 
// Возвращаемое значение:
//   Булево
//
Функция МожноУстанавливатьОпциюДляКомплектации(Опция, Комплектация) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Комплектация) Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат ДополнительныеОпцииКомплектации(Комплектация).Найти(Опция) <> Неопределено;
	
КонецФункции

// Проверяем доступность опции для автомобиля
//
// Параметры:
//  Опция - СправочникСсылка.Опция - опция
//  Автомобиль - СправочникСсылка.ВариантыКомплектации - автомобиль
// 
// Возвращаемое значение:
//   Булево
//
Функция МожноУстанавливатьОпциюДляАвтомобиля(Опция, Автомобиль) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Автомобиль) Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат ОпцииУстановленныеНаАвтомобиль(Автомобиль).Найти(Опция) <> Неопределено;
	
КонецФункции

// Готовит коллекцию с опциями варианта комплектации
//
// Параметры:
//  Комплектация - СправочникСсылка.ВариантыКомплектации
//
// Возвращаемое значение:
//  ТаблицаЗначений - с колонками:
//    * ВидОпции - ПеречислениеСсылка.ВидыОпцийАвтомобилей
//    * Опция - СправочникСсылка.Опции
//    * Количество - Число
//    * ЦенаЗакупки - Число
//
Функция ОпцииКомплектации(Комплектация) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ОпцииВариантовКомплектации.ВидОпции КАК ВидОпции,
		|	ОпцииВариантовКомплектации.Опция КАК Опция,
		|	ОпцииВариантовКомплектации.Количество КАК Количество,
		|	ОпцииВариантовКомплектации.ЦенаЗакупки КАК ЦенаЗакупки
		|ИЗ
		|	РегистрСведений.ОпцииВариантовКомплектации КАК ОпцииВариантовКомплектации
		|ГДЕ
		|	ОпцииВариантовКомплектации.ВариантКомплектации = &ВариантКомплектации"
	);
	Запрос.УстановитьПараметр("ВариантКомплектации", Комплектация);
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Коллекцию базовых опций для комплектации
//
// Параметры:
//  Комплектация - СправочникСсылка.ВариантыКомплектации - комплектация автомобиля
// 
// Возвращаемое значение:
//  Массив из СправочникСсылка.Опции
//
Функция БазовыеОпцииКомплектации(Комплектация) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ОпцииВариантовКомплектации.Опция КАК Опция
		|ИЗ
		|	РегистрСведений.ОпцииВариантовКомплектации КАК ОпцииВариантовКомплектации
		|ГДЕ
		|	ОпцииВариантовКомплектации.ВариантКомплектации = &Комплектация
		|	И ОпцииВариантовКомплектации.ВидОпции = ЗНАЧЕНИЕ(Перечисление.ВидыОпцийАвтомобилей.БазоваяОпция)"
	);
	Запрос.УстановитьПараметр("Комплектация", Комплектация);
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Опция");
	
КонецФункции

// Коллекцию доступных дополнительных опций для комплектации
//
// Параметры:
//  Комплектация - СправочникСсылка.ВариантыКомплектации - комплектация автомобиля
// 
// Возвращаемое значение:
//  Массив из СправочникСсылка.Опции
//
Функция ДополнительныеОпцииКомплектации(Комплектация) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ОпцииВариантовКомплектации.Опция КАК Опция
		|ИЗ
		|	РегистрСведений.ОпцииВариантовКомплектации КАК ОпцииВариантовКомплектации
		|ГДЕ
		|	ОпцииВариантовКомплектации.ВариантКомплектации = &Комплектация
		|	И ОпцииВариантовКомплектации.ВидОпции = ЗНАЧЕНИЕ(Перечисление.ВидыОпцийАвтомобилей.ДополнительнаяОпция)"
	);
	Запрос.УстановитьПараметр("Комплектация", Комплектация);
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Опция");
	
КонецФункции

// Коллекция опций установленных на автомобиль
//
// Параметры:
//  Автомобиль - СправочникСсылка.Автомобили - автомобиль
// 
// Возвращаемое значение:
//  Массив из СправочникСсылка.Опции
//
Функция ОпцииУстановленныеНаАвтомобиль(Автомобиль) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ОпцииАвтомобилей.Опция КАК Опция
		|ИЗ
		|	РегистрСведений.ОпцииАвтомобилей КАК ОпцииАвтомобилей
		|ГДЕ
		|	ОпцииАвтомобилей.Автомобиль = &Автомобиль
		|	И ОпцииАвтомобилей.ЗаписьАктивна
		|	И ОпцииАвтомобилей.Количество > 0"
	);
	Запрос.УстановитьПараметр("Автомобиль", Автомобиль);
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Опция");
	
КонецФункции

// Возвращает коллекцию дополнительных опций, которые не совместимы с теми, которые находятся в таблице опций.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события
// 
// Возвращаемое значение:
//  Массив из СправочникСсылка.Опции
//
Функция ПолучитьНесовместимыеДополнительныеОпции(Объект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОпцииВариантовКомплектации.Опция КАК Опция
		|ПОМЕСТИТЬ втОпцииВариантаКомплектации
		|ИЗ
		|	РегистрСведений.ОпцииВариантовКомплектации КАК ОпцииВариантовКомплектации
		|ГДЕ
		|	ОпцииВариантовКомплектации.ВариантКомплектации = &ВариантКомплектации
		|	И ОпцииВариантовКомплектации.ВидОпции = ЗНАЧЕНИЕ(Перечисление.ВидыОпцийАвтомобилей.ДополнительнаяОпция)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОпцииДокумента.Опция КАК Опция
		|ПОМЕСТИТЬ втОпцииДокумента
		|ИЗ
		|	&ТаблицаОпций КАК ОпцииДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втОпцииДокумента.Опция КАК Опция
		|ИЗ
		|	втОпцииДокумента КАК втОпцииДокумента
		|ГДЕ
		|	НЕ втОпцииДокумента.Опция В
		|				(ВЫБРАТЬ
		|					втОпцииВариантаКомплектации.Опция КАК Опция
		|				ИЗ
		|					втОпцииВариантаКомплектации КАК втОпцииВариантаКомплектации)";
	
	Запрос.УстановитьПараметр("ВариантКомплектации", Объект.ВариантКомплектации);
	Запрос.УстановитьПараметр("ТаблицаОпций", Объект.Опции.Выгрузить());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Опция");
	
КонецФункции

#КонецОбласти
