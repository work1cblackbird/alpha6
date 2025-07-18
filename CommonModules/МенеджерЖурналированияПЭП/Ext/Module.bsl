﻿
#Область ПрограммныйИнтерфейс

// Выполняет запись информации о запросе в регистр.
// 
// Параметры:
//  ТипЗапроса - Строка - Тип запроса;
//  Запрос - HTTPЗапрос - Запрос
//  Ответ - HTTPОтвет - Ответ
//  Длительность - Число - Длительность
//
Процедура Записать(ТипЗапроса, Запрос, Ответ, Длительность) Экспорт
	
	Если ПустаяСтрока(ТипЗапроса) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.ЖурналЗапросовПЭП.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ИдентификаторЗапроса = Новый УникальныйИдентификатор();
	
	МенеджерЗаписи.Таймстэмп = ТекущаяУниверсальнаяДатаВМиллисекундах();
	МенеджерЗаписи.Дата = ТекущаяДатаСеанса();
	МенеджерЗаписи.ДатаUTC = ТекущаяУниверсальнаяДата();
	МенеджерЗаписи.Длительность = Длительность;
	
	МенеджерЗаписи.Путь = Запрос.АдресРесурса;
	МенеджерЗаписи.ТипЗапроса = ТипЗапроса;
	МенеджерЗаписи.Статус = Ответ.КодСостояния;
	МенеджерЗаписи.ТелоЗапроса = ПредставлениеЗапросаОтвета(Запрос);
	МенеджерЗаписи.ТелоОтвета = ПредставлениеЗапросаОтвета(Ответ);
	
	МенеджерЗаписи.Пользователь = ОбщегоНазначенияПЭП.ТекущийПользователь();
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Представление запроса или ответа.
// 
// Параметры:
//  ЗапросОтвет - HTTPЗапрос, HTTPОтвет - Запрос или ответ
// 
// Возвращаемое значение:
//  Строка
Функция ПредставлениеЗапросаОтвета(ЗапросОтвет)
	
	Заголовки = Новый Массив();
	
	Для Каждого Заголовок Из ЗапросОтвет.Заголовки Цикл
		
		Если Заголовок.Ключ = "Authorization" Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Заголовки.Добавить(СтрШаблон("%1: %2", Заголовок.Ключ, Заголовок.Значение));
		
	КонецЦикла;
	
	ШаблонПредставления =
		"Заголовки
		|%1
		|
		|Тело
		|%2";
	Возврат СтрШаблон(ШаблонПредставления, СтрСоединить(Заголовки, Символы.ПС), ЗапросОтвет.ПолучитьТелоКакСтроку());
	
КонецФункции

#КонецОбласти