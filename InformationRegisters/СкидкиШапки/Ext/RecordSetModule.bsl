﻿// Модуль набора записей регистра "Скидки шапки"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

#Область ОписаниеПеременных

Перем РезультатЗапросаПоСкидкам	Экспорт;	// РезультатЗапроса или ТаблицаЗначений.
Перем ПодразделениеКомпании		Экспорт;	// Подразделение компании
Перем ДокументСсылка Экспорт; // документ ссылка

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ОбработкаСобытийРегистраСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты) Тогда
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Установить скидки
Функция УстановитьСкидки() Экспорт
	
	Отказ = Ложь;
	
	// проверим значения ключевых объектов
	Отказ = НЕ(ЗначениеЗаполнено(ПодразделениеКомпании) И ЗначениеЗаполнено(ДокументСсылка));
	
	// получаем таблицу товаров
	Если (РезультатЗапросаПоСкидкам = Неопределено)
		ИЛИ (ТипЗнч(РезультатЗапросаПоСкидкам)<>Тип("РезультатЗапроса"))
			И (ТипЗнч(РезультатЗапросаПоСкидкам)<>Тип("ТаблицаЗначений")) Тогда
		
		Отказ = Истина;
		
	КонецЕсли;
	
	Если ТипЗнч(РезультатЗапросаПоСкидкам) = Тип("РезультатЗапроса") Тогда
		РезультатЗапросаПоСкидкам = РезультатЗапросаПоСкидкам.Выгрузить();
	КонецЕсли;
	
	// если были обнаружены ошибки, то движения делать не будем
	Если НЕ Отказ Тогда
		ТабЗаписей = ПолучитьДанныеПоСкидкам(ДокументСсылка);
		НужнаПроверка = ТабЗаписей.Количество() > 0;
		
		// Осуществляем запись данных в регистр
		Для Каждого ТекСтрока Из РезультатЗапросаПоСкидкам Цикл
			
			// регистр СкидкиШапки 
			НоваяЗапись = Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, ТекСтрока);
			НоваяЗапись.Период				= ДокументСсылка.ДатаНачалаДействия;
			НоваяЗапись.ПодразделениеКомпании		= ПодразделениеКомпании;
			НоваяЗапись.Действует			= Истина;
			НоваяЗапись.Регистратор         = ДокументСсылка;
			НоваяЗапись.Свойство			= ?(ЗначениеЗаполнено(НоваяЗапись.Свойство), НоваяЗапись.Свойство, Неопределено);
			НоваяЗапись.МоментИзменения		= ТекущаяДатаСеанса(); 
			НоваяЗапись.РучнаяСкидка		= ТекСтрока.Скидка.РучнаяСкидка;
			
			// проверим возможность добавления строки
			Если НужнаПроверка Тогда
				стрПоиск = Новый Структура;
				стрПоиск.Вставить("ПодразделениеКомпании");
				стрПоиск.Вставить("РучнаяСкидка");
				стрПоиск.Вставить("НачВремя");
				стрПоиск.Вставить("КонВремя");
				стрПоиск.Вставить("ДниНедели");
				стрПоиск.Вставить("ДисконтнаяКарта");
				стрПоиск.Вставить("ОтСуммыНакопленияНаКарте");
				стрПоиск.Вставить("ЗалОбслуживания");
				стрПоиск.Вставить("Свойство");
				стрПоиск.Вставить("ОтСуммыЧека");
				стрПоиск.Вставить("Скидка");
				стрПоиск.Вставить("СкидкаНаТовары");
				стрПоиск.Вставить("СкидкаНаРаботы");
				
				ЗаполнитьЗначенияСвойств(стрПоиск,НоваяЗапись);
				
				РезПоиска = ТабЗаписей.НайтиСтроки(стрПоиск);
				Если РезПоиска.Количество() > 0 Тогда
					ТекстСообщения = СтрШаблон(
						НСтр("ru = 'Для скидки <%1> уже есть запись на дату ""%2"".'"),
						ТекСтрока.Скидка,
						Формат(ДокументСсылка.ДатаНачалаДействия,"ДЛФ=DDT")
					);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ДокументСсылка,,,Отказ);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		// Произведем запись набора (т.к. автоматической записи по окончанию транзакции не будет).
		Если НЕ Отказ Тогда
			Записать(ЛОЖЬ);
		КонецЕсли;
	КонецЕсли;
	
	// Очистим основные переменные
	ДокументСсылка				= Неопределено;
	РезультатЗапросаПоСкидкам	= Неопределено;
	ПодразделениеКомпании		= Неопределено;
	
	Возврат Отказ;
КонецФункции

// Отменить скидки
Функция ОтменитьСкидки() Экспорт
	
	// проверим значения ключевых объектов
	Отказ = НЕ (ЗначениеЗаполнено(ДокументСсылка) И ЗначениеЗаполнено(ПодразделениеКомпании));
	
	// получаем таблицу товаров
	Если (РезультатЗапросаПоСкидкам = Неопределено) ИЛИ (ТипЗнч(РезультатЗапросаПоСкидкам)<>Тип("РезультатЗапроса")) И (ТипЗнч(РезультатЗапросаПоСкидкам)<>Тип("ТаблицаЗначений")) Тогда
		Отказ = Истина;
	КонецЕсли;
	Если ТипЗнч(РезультатЗапросаПоСкидкам) = Тип("РезультатЗапроса") Тогда
		РезультатЗапросаПоСкидкам = РезультатЗапросаПоСкидкам.Выгрузить();
	КонецЕсли;
	
	// Осуществляем запись данных в регистр
	Для Каждого ТекСтрока Из РезультатЗапросаПоСкидкам Цикл
		
		Если НЕ ТекСтрока.СкидкаУстановлена Тогда
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Скидка <%1> ранее не была установлена. Отмена скидки не возможно.'"),
				СокрЛП(ТекСтрока.Скидка)
			);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,ДокументСсылка,,,Отказ);
			Продолжить;
			
		КонецЕсли;
		
		// регистр СкидкиШапки 
		НоваяЗапись = Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, ТекСтрока);
		НоваяЗапись.Период              = ДокументСсылка.ДатаНачалаДействия;
		НоваяЗапись.ПодразделениеКомпании       = ПодразделениеКомпании;
		НоваяЗапись.Действует           = ЛОЖЬ;
		НоваяЗапись.Регистратор         = ДокументСсылка;
		НоваяЗапись.МоментИзменения     = ТекущаяДатаСеанса(); //TruA
	КонецЦикла;
	
	// если были обнаружены ошибки, то движения записывать не будем
	Если НЕ Отказ Тогда
		Записать(ЛОЖЬ);
	КонецЕсли;
	
	// Очистим основные переменные
	ДокументСсылка				= Неопределено;
	РезультатЗапросаПоСкидкам	= Неопределено;
	ПодразделениеКомпании		= Неопределено;
	
	Возврат Отказ;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// получение скидок на дату
Функция ПолучитьДанныеПоСкидкам(ДокСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СкидкиШапки.ПодразделениеКомпании,
	|	СкидкиШапки.РучнаяСкидка,
	|	СкидкиШапки.НачВремя,
	|	СкидкиШапки.КонВремя,
	|	СкидкиШапки.ДниНедели,
	|	СкидкиШапки.ДисконтнаяКарта,
	|	СкидкиШапки.ОтСуммыНакопленияНаКарте,
	|	СкидкиШапки.ЗалОбслуживания,
	|	СкидкиШапки.ОтСуммыЧека,
	|	СкидкиШапки.Скидка,
	|	СкидкиШапки.СкидкаНаТовары,
	|	СкидкиШапки.СкидкаНаРаботы,
	|	СкидкиШапки.Свойство
	|ИЗ
	|	РегистрСведений.СкидкиШапки КАК СкидкиШапки
	|ГДЕ
	|	СкидкиШапки.Скидка В
	|			(ВЫБРАТЬ
	|				НазначениеСкидокШапкиСкидки.Скидка
	|			ИЗ
	|				Документ.НазначениеСкидокШапки.Скидки КАК НазначениеСкидокШапкиСкидки
	|			ГДЕ
	|				НазначениеСкидокШапкиСкидки.Ссылка = &ДокСсылка
	|			СГРУППИРОВАТЬ ПО
	|						НазначениеСкидокШапкиСкидки.Скидка)
	|	И СкидкиШапки.Период = &ДатаНачалаДействия";
	
	Запрос.УстановитьПараметр("ДокСсылка", ДокСсылка);
	Запрос.УстановитьПараметр("ДатаНачалаДействия",ДокСсылка.ДатаНачалаДействия);
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

#КонецОбласти

#КонецЕсли