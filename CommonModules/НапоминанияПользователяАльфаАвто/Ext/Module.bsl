﻿
#Область ПрограммныйИнтерфейс

// Возвращает текстовое представление интервала времени, заданного в секундах.
//
// Параметры:
//
//  Время - Число - интервал времени в секундах.
//
//  ПолноеПредставление	- Булево - кратное или полное представление времени.
//		Например, интервал 1 000 000 секунд:
//		1) полное представление:  11 дней 13 часов 46 минут 40 секунд;
//		2) краткое представление: 11 дней 13 часов.
//  
//  ВыводитьСекунды - Булево - Ложь, если секунды не требуются.
//  
// Возвращаемое значение:
//   Строка - представление интервала времени.
//
Функция ПредставлениеВремени(Знач Время, ПолноеПредставление = Истина, ВыводитьСекунды = Истина) Экспорт
	Результат = "";
	
	// Представление единиц измерения времени в винительном падеже для количеств: 1, 2-4, 5-20.
	ПредставлениеНедель = НСтр("ru = ';%1 неделю;;%1 недели;%1 недель;%1 недели'");
	ПредставлениеДней   = НСтр("ru = ';%1 день;;%1 дня;%1 дней;%1 дня'");
	ПредставлениеЧасов  = НСтр("ru = ';%1 час;;%1 часа;%1 часов;%1 часа'");
	ПредставлениеМинут  = НСтр("ru = ';%1 минуту;;%1 минуты;%1 минут;%1 минуты'");
	ПредставлениеСекунд = НСтр("ru = ';%1 секунду;;%1 секунды;%1 секунд;%1 секунды'");
	
	Время = Число(Время);
	
	Если Время < 0 Тогда
		Время = -Время;
	КонецЕсли;
	
	КоличествоНедель = Цел(Время / 60/60/24/7);
	КоличествоДней   = Цел(Время / 60/60/24);
	КоличествоЧасов  = Цел(Время / 60/60);
	КоличествоМинут  = Цел(Время / 60);
	КоличествоСекунд = Цел(Время);
	
	КоличествоСекунд = КоличествоСекунд - КоличествоМинут * 60;
	КоличествоМинут  = КоличествоМинут - КоличествоЧасов * 60;
	КоличествоЧасов  = КоличествоЧасов - КоличествоДней * 24;
	КоличествоДней   = КоличествоДней - КоличествоНедель * 7;
	
	Если Не ВыводитьСекунды Тогда
		КоличествоСекунд = 0;
	КонецЕсли;
	
	Если КоличествоНедель > 0 И КоличествоДней+КоличествоЧасов+КоличествоМинут+КоличествоСекунд=0 Тогда
		Результат = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеНедель, КоличествоНедель);
	Иначе
		КоличествоДней = КоличествоДней + КоличествоНедель * 7;
		
		Счетчик = 0;
		Если КоличествоДней > 0 Тогда
			Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеДней, КоличествоДней) + " ";
			Счетчик = Счетчик + 1;
		КонецЕсли;
		
		Если КоличествоЧасов > 0 Тогда
			Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеЧасов, КоличествоЧасов) + " ";
			Счетчик = Счетчик + 1;
		КонецЕсли;
		
		Если (ПолноеПредставление Или Счетчик < 2) И КоличествоМинут > 0 Тогда
			Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеМинут, КоличествоМинут) + " ";
			Счетчик = Счетчик + 1;
		КонецЕсли;
		
		Если (ПолноеПредставление Или Счетчик < 2) И (КоличествоСекунд > 0 Или КоличествоНедель+КоличествоДней+КоличествоЧасов+КоличествоМинут = 0) Тогда
			Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеСекунд, КоличествоСекунд);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СокрП(Результат);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет запрос по напоминаниям для текущего пользователя на момент времени ТекущаяДатаСеанса() + 30минут.
// Момент времени смещен от текущего для использования функции из модуля с повторным использованием
// возвращаемых значений.
// При обработке результата выполнения функции необходимо учитывать эту особенность.
//
// Параметры:
//	Нет
//
// Возвращаемое значение
//  Массив - таблица значений, сконвертированная в массив из структур, содержащих данные строк таблицы.
Функция ПолучитьНапоминанияТекущегоПользователя() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Напоминания.Пользователь КАК Пользователь,
	// +РАРУС
	|	Напоминания.Автор КАК Автор,
	|	Напоминания.ДатаСоздания КАК ДатаСоздания,
	// -РАРУС
	|	Напоминания.ВремяСобытия КАК ВремяСобытия,
	|	Напоминания.Источник КАК Источник,
	|	Напоминания.СрокНапоминания КАК СрокНапоминания,
	|	Напоминания.Описание КАК Описание,
	|	2 КАК ИндексКартинки
	|ИЗ
	|	РегистрСведений.НапоминанияПользователя КАК Напоминания
	|ГДЕ
	|	Напоминания.СрокНапоминания <= &ТекущаяДата
	|	И Напоминания.Пользователь = &Пользователь
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВремяСобытия";
	
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса() + 30*60);// +30 минут для кэша
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	
	Результат = ПолучитьМассивСтруктурИзТаблицы(Запрос.Выполнить().Выгрузить());
	
	Возврат Результат;
	
КонецФункции

// Конвертирует таблицу в массив структур.
//
// Параметры:
//  ТаблицаЗначений - произвольная таблица значений, у которой есть имена колонок.
//
// Возвращаемое значение
//  Массив - массив структур, содержащих значения строк таблицы.
Функция ПолучитьМассивСтруктурИзТаблицы(ТаблицаЗначений) Экспорт
	
	Результат = Новый Массив;
	Для Каждого Строка Из ТаблицаЗначений Цикл
		СтруктураСтроки = Новый Структура;
		Для Каждого Колонка Из ТаблицаЗначений.Колонки Цикл
			СтруктураСтроки.Вставить(Колонка.Имя, Строка[Колонка.Имя]);
		КонецЦикла;
		Результат.Добавить(СтруктураСтроки);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти