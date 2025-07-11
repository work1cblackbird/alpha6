﻿// Модуль менеджера регистра "Коды маркировки для печати."

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Делает запись в регистр "Коды маркировки для печати" кодов маркировки с криптохвостами.
//
// Параметры:
//  Ссылка - ДокументСсылка.ЗаказКодовМаркировки - документ заказа кодов маркировки;
//  КодыМаркировки - ТаблицаЗначений - таблица, содержащая информацию о кодах маркировки:
//    * Номенклатура - СправочникСсылка.Номенклатура - номенклатура;
//    * ХарактеристикаНоменклатуры - СправочникСсылка.ХарактеристикаНоменклатуры - характеристика номенклатуры;
//    * КодМаркировки - Строка - полученный полный код маркировки.
//
Процедура ДобавитьЗаписиВРегистр(Ссылка, КодыМаркировки) Экспорт
	
	НаборЗаписей = РегистрыСведений.КодыМаркировкиДляПечати.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументОснование.Установить(Ссылка);
	
	НаборЗаписей.Прочитать();
	ТаблицаНабора = НаборЗаписей.Выгрузить();
	
	СимволГруппировки = ОбщегоНазначенияБПОКлиентСервер.РазделительGS1();
	СимволЭкранирования = ОбщегоНазначенияБПОКлиентСервер.ЭкранированныйСимволGS1();
	
	Для Каждого Строка Из КодыМаркировки Цикл
		
		ТекущийКодМаркировки = Строка.КодМаркировки;
		ТекущийКодМаркировки = СтрЗаменить(ТекущийКодМаркировки, СимволГруппировки, СимволЭкранирования);
		
		// Проверим, что ранее не было записи с таким кодом маркировки
		Если ТаблицаНабора.Найти(ТекущийКодМаркировки, "КодМаркировки") <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаНабора.Добавить();
		НоваяСтрока.ДокументОснование = Ссылка;
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка, "Номенклатура, ХарактеристикаНоменклатуры");
		НоваяСтрока.КодМаркировки = ТекущийКодМаркировки;
		НоваяСтрока.ДатаПечати = Дата("00010101000000");
		
	КонецЦикла;
	
	НаборЗаписей.Загрузить(ТаблицаНабора);
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли