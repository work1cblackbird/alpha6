﻿
#Область ПрограммныйИнтерфейс

// Удаляет из артикула все символы которые не являются русскими или латинскими символами и цифрами.
// Переводит строку в верхний регистр.
//
// Параметры:
//  Артикул - Строка - Артикул для преобразования.
//
// Возвращаемое значение:
//  Строка - Артикул для поиска.
//
Функция ВАртикулДляПоиска(Знач Артикул) Экспорт
	
	Артикул=СокрЛП(ВРег(Артикул));
	ДопустимыеСимволы="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ";
	Возврат ОтфильтроватьСтроку(Артикул, ДопустимыеСимволы);
	
КонецФункции // ВАртикулДляПоиска()

// Устанавливает отбор на спиоск номенклатуры по артикулу и наименованию
//
// Параметры:
//  Список - ДинамическийСписок - Список на который накладывается отбор.
//  СтрокаПоиска - Строка - Значение поиска.
//  ПоТочномуСоответствию - Булево - Определяет вид сравнения "Равно" или "Содержит".
//
Процедура УстановитьОтборНаСписокНоменклатура(Список, СтрокаПоиска, ПоТочномуСоответствию) Экспорт
	
	ОчиститьОтборСписокаНоменклатура(Список);
	
	Если НЕ ЗначениеЗаполнено(СтрокаПоиска) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ГруппаОтборов = Список
		.КомпоновщикНастроек
		.ФиксированныеНастройки
		.Отбор
		.Элементы
		.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтборов.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ВидСравненияОтбора = ВидСравненияКомпоновкиДанных[?(ПоТочномуСоответствию, "Равно", "Содержит")];
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ГруппаОтборов,
		"АртикулДляПоиска",
		ВАртикулДляПоиска(СтрокаПоиска),
		ВидСравненияОтбора,
		,
		Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ГруппаОтборов,
		"Наименование",
		СтрокаПоиска,
		ВидСравненияОтбора,
		,
		Истина);
	
КонецПроцедуры

// Выполняет очистку отборов фиксированных настроке динамического списка
//
// Параметры:
//  Список - ДинамическийСписок - Список для которого необходимо выполнить очистку.
//
Процедура ОчиститьОтборСписокаНоменклатура(Список) Экспорт
	
	Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы.Очистить();
	
КонецПроцедуры

// Доступные варианты поиска для подборов.
// 
// Возвращаемое значение:
//  Структура - Структура поиска для подбора.
//
Функция ВариантыПоиска() Экспорт
	
	Возврат Новый Структура("Стандартный,Расширенный", "Стандартный", "Расширенный");
	
КонецФункции

// Устанавливает видимость колонки с характеристикой если она не пустая хотя бы в одной строек таблицы.
//
// Параметры:
//  КолонкаХарактеристики - ПолеФормы - Элемент формы колонка характеристик.
//  Таблица - ТабличнаяЧасть, ДанныеФормыКоллекция - Таблица с товарами.
//
Процедура ОбновитьВидимостьХарактеристики(КолонкаХарактеристики, Таблица) Экспорт
	
	Если КолонкаХарактеристики <> Неопределено И НЕ КолонкаХарактеристики.Видимость Тогда
		
		УсловиеПоиска = Новый Структура(
			"ХарактеристикаНоменклатуры",
			ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка"));
		СтрокиБезХарактеристик = Таблица.НайтиСтроки(УсловиеПоиска);
		КолонкаХарактеристики.Видимость = (Таблица.Количество() <> СтрокиБезХарактеристик.Количество());
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Удаляет из строки недопустимые в ней символы.
//
// Параметры:
//  Строка - Строка - Фильтруемая строка.
//  ЗапрещенныеСимволы - Строка - Символы которые необходимо удалить из строки
//
// Возвращаемое значение:
//  Строка. Строка без запрещенных символов.
//
Функция ОтфильтроватьСтроку(Строка, ДоступныеСимволы)
	
	Результат = "";
	
	Если ПустаяСтрока(ДоступныеСимволы) Тогда
		
		Возврат Строка;
		
	КонецЕсли;
	
	Для НомерСимвола = 1 По СтрДлина(Строка) Цикл
		
		Символ = Сред(Строка, НомерСимвола, 1);
		
		Если СтрНайти(ДоступныеСимволы, Символ) > 0 Тогда
			
			Результат = Результат + Символ;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции // ОтфильтроватьСтроку()

#КонецОбласти