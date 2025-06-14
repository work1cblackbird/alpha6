﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Значение = Перечисления.РежимыКонтроляОстатковНаСкладах.ПоКомпании Тогда
		
		РезультатПроверки = Константы
			.РежимКонтроляОстатковНаСкладах
			.ПроверитьВозможностьУстановкиЗначенияПоКомпании(ЭтотОбъект.Значение);
		
		Если Не РезультатПроверки.Возможно Тогда
			
			ОбщегоНазначения.СообщитьПользователю(РезультатПроверки.ТекстОшибки);
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли