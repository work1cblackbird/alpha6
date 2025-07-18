﻿

#Область СлужебныйПрограммныйИнтерфейс

// Формирует структуру сообщения об ошибке
//
// Параметры:
//  Текст - Строка - Сообщение об ошибке
// 
// Возвращаемое значение:
//  Структура - Структура сообщения об ошибке
//
Функция Ошибка(Текст) Экспорт
	
	Возврат Новый Структура("Ошибка,ОписаниеОшибки,Данные", Истина, Текст, Неопределено);
	
КонецФункции

// Запуск на выполнение расчета планирования по ресурсам
//
// Параметры:
//  ПланированиеОбъекты - ТаблицаЗначений - Таблица с перечнем объектов достпных для планирования
//  ДоступныеРесурсы - ТаблицаЗначений = Перечень ресурсов доступных для планирования
//  ПланированиеИнтервалы - ТаблицаЗначений - Имеющиеся временные интервалы объектов планирования
//  Параметры - Структура - Настройки планирования. Ключ структуры имя настройки, Значение - значение настройки.
//
Функция ВыполнитьАвтоматическоеПланирование(
	ПланированиеОбъекты, ДоступныеРесурсы, ПланированиеИнтервалы, Параметры) Экспорт
	
	АвтоматическоеПланированиеРесурсовОбъект = Обработки.АвтоматическоеПланированиеРесурсов.Создать();
	ЗаполнитьЗначенияСвойств(АвтоматическоеПланированиеРесурсовОбъект, Параметры);
	АвтоматическоеПланированиеРесурсовОбъект.ДоступныеРесурсы.Загрузить(ДоступныеРесурсы);
	АвтоматическоеПланированиеРесурсовОбъект.ПланированиеОбъекты.Загрузить(ПланированиеОбъекты);
	АвтоматическоеПланированиеРесурсовОбъект.ПланированиеИнтервалы.Загрузить(ПланированиеИнтервалы);
	
	Возврат АвтоматическоеПланированиеРесурсовОбъект.ВыполнитьАвтоматическоеПланирование();
	
КонецФункции

// Упаковка параметров планирования из реквизитов обработки в структуру
//
// Параметры:
//  ОбъектАПР - ДанныеФормыСтруктура, ОбработкаОбъект.АвтоматическоеПланированиеРесурсов - Упаковываемый объект.
//
// Возвращаемое значение - Структура.
// Объект упакованный в структуру.
//
Функция ПодготовитьПараметрыАвтоматическогоПланирования(ОбъектАПР) Экспорт
	
	Параметры = Новый Структура();
	
	Параметры.Вставить("ПредельныйСрокРасчетаПланирования", ОбъектАПР.ПредельныйСрокРасчетаПланирования);
	Параметры.Вставить("Модель", ОбъектАПР.Модель);
	Параметры.Вставить("Комплектация", ОбъектАПР.Комплектация);
	Параметры.Вставить("ПодразделениеКомпании", ОбъектАПР.ПодразделениеКомпании);
	Параметры.Вставить("РежимПланированияПоРесурсам", ОбъектАПР.РежимПланированияПоРесурсам);
	Параметры.Вставить("НачалоПериодаРасчета", ОбъектАПР.НачалоПериодаРасчета);
	Параметры.Вставить("ПланированиеВПределахОдногоДня", ОбъектАПР.ПланированиеВПределахОдногоДня);
	Параметры.Вставить("НеУчитыватьПерерывы", ОбъектАПР.НеУчитыватьПерерывы);
	Параметры.Вставить("ИспользоватьБазовыйГрафик", ОбъектАПР.ИспользоватьБазовыйГрафик);
	Параметры.Вставить("БазовыйГрафик", ОбъектАПР.БазовыйГрафик);
	Параметры.Вставить("УчитыватьДанныеТабеля", ОбъектАПР.УчитыватьДанныеТабеля);
	Параметры.Вставить("ТекущийДокумент", ОбъектАПР.ТекущийДокумент);
	Параметры.Вставить("ОдинИнтервалНаОдинОбъект", ОбъектАПР.ОдинИнтервалНаОдинОбъект);
	Параметры.Вставить("ПланироватьОтРесурса", ОбъектАПР.ПланироватьОтРесурса);
	Параметры.Вставить("РесурсПланирования", ОбъектАПР.РесурсПланирования);
	Параметры.Вставить("НачалоПериодаРасчетаОтРесурса", ОбъектАПР.НачалоПериодаРасчетаОтРесурса);
	Параметры.Вставить("РесурсПриемкиВыдачи", ОбъектАПР.РесурсПриемкиВыдачи);
	Параметры.Вставить("СрокРасчета", ОбъектАПР.СрокРасчета);
	Параметры.Вставить("Организация", ОбъектАПР.Организация);
	Параметры.Вставить("ОсновнойЦех", ОбъектАПР.ОсновнойЦех);
	Параметры.Вставить("ПланироватьНаЦехДокумента", ОбъектАПР.ПланироватьНаЦехДокумента);
	
	Возврат Параметры;
	
КонецФункции

// Заполнение объекта автоматического планирования значениями настроек из контакт
//
// Объект - ДанныеФормыСтруктура, ОбработкаОбъект.АвтоматическоеПланированиеРесурсов - Заполняемый объект.
//
Процедура ЗаполнитьОбщимиНастройками(Объект) Экспорт
	
	ЗаполнитьЗначенияСвойств(Объект, ПолучитьОбщиеНастройки());
	
	СрокРасчета = ПолучитьСрокРасчетаПодразделения(Объект.ПодразделениеКомпании);
	Если СрокРасчета = Неопределено Тогда
		СрокРасчета = 7; // по умрлчанию 7 дней
	КонецЕсли;
	
	Объект.СрокРасчета = СрокРасчета;
	
КонецПроцедуры

#Область Обновление

// Заполнение реквизита при старте новой базы и смене релиза.
//
Процедура ЗаполнитьВидРазбиенияИнтерваловПриПланировании() Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ ТипыАвторабот.Ссылка КАК Ссылка ИЗ Справочник.ТипыАвторабот КАК ТипыАвторабот");
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		БезРазбиения = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Справочники.ТипыАвторабот.Приемка);
		БезРазбиения.Добавить(Справочники.ТипыАвторабот.Выдача);
		
		Пока Выборка.Следующий() Цикл
			
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			
			Если БезРазбиения.Найти(Выборка.Ссылка) <> Неопределено Тогда
				
				Объект.ВидРазбиенияИнтерваловПриПланировании = Перечисления.ВидыРазбиенияИнтерваловПланирования.НеРазбивать;
				
			Иначе
				
				Объект.ВидРазбиенияИнтерваловПриПланировании = Перечисления.ВидыРазбиенияИнтерваловПланирования.Разбивать;
				
			КонецЕсли;
			
			Объект.ОбменДанными.Загрузка = Истина;
			Объект.Записать();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьВидРазбиенияИнтервалов()

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьОбщиеНастройки()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Настройки = Новый Структура;
	Настройки.Вставить("ОдинИнтервалНаОдинОбъект", Константы.ПланироватьБезРазбиения.Получить());
	Настройки.Вставить("ПланированиеВПределахОдногоДня", Константы.ПланированиеВПределахОдногоДня.Получить());
	Настройки.Вставить("НеУчитыватьПерерывы", Константы.НеУчитыватьПерерывы.Получить());
	
	Возврат Настройки;
	
КонецФункции

Функция ПолучитьСрокРасчетаПодразделения(ПодразделениеКомпании)
	
	Если ПодразделениеКомпании.СрокРасчетаАвтоматическогоПланирования > 0 Тогда
		Возврат ПодразделениеКомпании.СрокРасчетаАвтоматическогоПланирования;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
