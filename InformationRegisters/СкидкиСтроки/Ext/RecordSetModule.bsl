﻿// Модуль набора записей регистра "Скидки строки"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА
Перем ДокументСсылка			Экспорт;	// Документ объект
Перем РезультатЗапросаПоСкидкам Экспорт;	// РезультатЗапроса или ТаблицаЗначений.
Перем ПодразделениеКомпании		Экспорт;	// Подразделение компании

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ОбработкаСобытийРегистраСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты) Тогда
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПараметрыОбработкиРеквизитовОбъекта

// Функция устанавливает скидки
Функция УстановитьСкидки() Экспорт
	Отказ = (НЕ (ЗначениеЗаполнено(ДокументСсылка) И ЗначениеЗаполнено(ПодразделениеКомпании)));
	
	// получаем таблицу товаров
	Если (РезультатЗапросаПоСкидкам = Неопределено) ИЛИ (ТипЗнч(РезультатЗапросаПоСкидкам)<>Тип("РезультатЗапроса")) И (ТипЗнч(РезультатЗапросаПоСкидкам)<>Тип("ТаблицаЗначений")) Тогда
		Отказ = Истина;
	КонецЕсли;
	Если ТипЗнч(РезультатЗапросаПоСкидкам) = Тип("РезультатЗапроса") Тогда
		РезультатЗапросаПоСкидкам = РезультатЗапросаПоСкидкам.Выгрузить();
	КонецЕсли;
	
	// если были обнаружены ошибки, то движения делать не будем
	Если НЕ Отказ Тогда
		// Осуществляем запись данных в регистр
		ТабЗаписей = ПолучитьДанныеПоСкидкам(ДокументСсылка.Ссылка);
		НужнаПроверка = ТабЗаписей.Количество() > 0;
		стрОшибок = "";
		
		Для Каждого ТекСтрока Из РезультатЗапросаПоСкидкам Цикл
			// регистр СкидкиСтроки 
			НоваяЗапись = Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, ТекСтрока);
			НоваяЗапись.Период				= ДокументСсылка.ДатаНачалаДействия;
			НоваяЗапись.ПодразделениеКомпании		= ПодразделениеКомпании;
			НоваяЗапись.Действует			= Истина;
			НоваяЗапись.Регистратор         = ДокументСсылка;
			НоваяЗапись.Свойство			= ?(ЗначениеЗаполнено(НоваяЗапись.Свойство), НоваяЗапись.Свойство, Неопределено);
			НоваяЗапись.МоментИзменения		= ТекущаяДатаСеанса();
			
			Если НужнаПроверка Тогда
				стрПоиск = Новый Структура;
				стрПоиск.Вставить("ПодразделениеКомпании");
				стрПоиск.Вставить("РучнаяСкидка");
				стрПоиск.Вставить("Объект");
				стрПоиск.Вставить("НачВремя");
				стрПоиск.Вставить("КонВремя");
				стрПоиск.Вставить("ДниНедели");
				стрПоиск.Вставить("ДисконтнаяКарта");
				стрПоиск.Вставить("ОтСуммыНакопленияНаКарте");
				стрПоиск.Вставить("ЗалОбслуживания");
				стрПоиск.Вставить("Свойство");
				стрПоиск.Вставить("ОтСуммыСтроки");
				стрПоиск.Вставить("ОтКоличества");
				стрПоиск.Вставить("Правило");
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
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,ДокументСсылка,,,Отказ);
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
	Отказ = Ложь;
	
	Отказ = (НЕ (ЗначениеЗаполнено(ДокументСсылка) И ЗначениеЗаполнено(ПодразделениеКомпании)));
	
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

// получение скидок на дату
Функция ПолучитьДанныеПоСкидкам(ДокСсылка)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СкидкиСтроки.ПодразделениеКомпании,
	|	СкидкиСтроки.РучнаяСкидка,
	|	СкидкиСтроки.Объект,
	|	СкидкиСтроки.НачВремя,
	|	СкидкиСтроки.КонВремя,
	|	СкидкиСтроки.ДниНедели,
	|	СкидкиСтроки.ДисконтнаяКарта,
	|	СкидкиСтроки.ОтСуммыНакопленияНаКарте,
	|	СкидкиСтроки.ЗалОбслуживания,
	|	СкидкиСтроки.Свойство,
	|	СкидкиСтроки.ОтСуммыСтроки,
	|	СкидкиСтроки.ОтКоличества,
	|	СкидкиСтроки.Правило,
	|	СкидкиСтроки.Скидка,
	|	СкидкиСтроки.СкидкаНаТовары,
	|	СкидкиСтроки.СкидкаНаРаботы
	|ИЗ
	|	РегистрСведений.СкидкиСтроки КАК СкидкиСтроки
	|ГДЕ
	|	СкидкиСтроки.Период = &ДатаНачалаДействия
	|	И СкидкиСтроки.Скидка В
	|			(ВЫБРАТЬ
	|				НазначениеСкидокСтроки.Скидка
	|			ИЗ
	|				Документ.НазначениеСкидокСтроки.Скидки КАК НазначениеСкидокСтроки
	|			ГДЕ
	|				НазначениеСкидокСтроки.Ссылка = &ДокСсылка
	|			СГРУППИРОВАТЬ ПО
	|						НазначениеСкидокСтроки.Скидка)";
	
	Запрос.УстановитьПараметр("ДокСсылка", ДокСсылка);
	Запрос.УстановитьПараметр("ДатаНачалаДействия",ДокСсылка.ДатаНачалаДействия);
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли