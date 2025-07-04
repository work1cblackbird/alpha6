﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПроверитьВозможностьУстановкиЗначенияПоКомпании(Значение) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Возможно", Истина);
	Результат.Вставить("ТекстОшибки", "");
	
	Если Значение = Перечисления.РежимыКонтроляОстатковНаСкладах.ПоОрганизации Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если Константы.ИспользоватьПередачуТоваровМеждуОрганизациями.Получить() Тогда
		
		Результат.ТекстОшибки = НСтр(
			"ru = 'В базе включен функционал ""Передача товаров между организациями"".
				|Установка значения ""По компании"" невозможна'"
		);
		Результат.Возможно = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
