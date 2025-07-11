﻿// Модуль набора записей регистра "Товары в оборудовании"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ОбработкаСобытийРегистраСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты) Тогда
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры 

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда	
		Возврат;	
	КонецЕсли;
	
	Если НЕ Замещение Тогда 
		Возврат; 
	КонецЕсли; 
	
	Для каждого ЗаписьНабора Из ЭтотОбъект Цикл
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ТоварыВОборудовании.Номенклатура
		|ИЗ
		|	РегистрСведений.ТоварыВОборудовании КАК ТоварыВОборудовании
		|ГДЕ
		|	ТоварыВОборудовании.ГруппаТоваров = &ГруппаТоваров
		|	И ТоварыВОборудовании.НомерЯчейки = &НомерЯчейки";
		Запрос.УстановитьПараметр("ГруппаТоваров", ЗаписьНабора.ГруппаТоваров);
		Запрос.УстановитьПараметр("НомерЯчейки", ЗаписьНабора.НомерЯчейки);
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если ЗаписьНабора.Номенклатура <> Выборка.Номенклатура Тогда
				Отказ = Истина;
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Ячейка с номером'") + " " +ЗаписьНабора.НомерЯчейки
					+ " " + НСтр("ru = 'занята номенклатурой'") + " " +Выборка.Номенклатура);
				Возврат;
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла; 
КонецПроцедуры 

#КонецОбласти

#КонецЕсли