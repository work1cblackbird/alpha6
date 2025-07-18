﻿////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Подсистема "Адресный классификатор".
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

//  Имя событие для записи в журнал регистрации.
//
Функция СобытиеЖурналаРегистрации() Экспорт
	
	#Если НЕ ТонкийКлиент И НЕ ВебКлиент И НЕ МобильныйКлиент И НЕ ТолстыйКлиентУправляемоеПриложение Тогда
		МодульОбщегоНазначения = ОбщегоНазначения.ОбщийМодуль("ОбщегоНазначения");
	#Иначе
		МодульОбщегоНазначения = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбщегоНазначенияКлиент");
	#КонецЕсли
	
	Возврат НСтр("ru = 'Адресный классификатор'", МодульОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

// Разделяет исходный текст на наименование и сокращение.
// Сокращением считается последнее слово, отделенное пробельным символом.
//
// Параметры:
//     Название - Строка - Полное название, например "Москва г".
//
// Возвращаемое значение:
//     Структура - содержит поля.
//       * Наименование - Строка - Наименование, например "Москва". Если сокращение выделить не удалось, то исходное
//                                 название.
//       * Сокращение   - Строка - Сокращение, например "г". Если сокращение выделить не удалось, то пустая строка.
//
Функция НаименованиеИСокращение(Название) Экспорт
	ТекстПоиска = СокрП(Название);
	
	Позиция = СтрДлина(ТекстПоиска);
	Пока Позиция > 0 Цикл
		Если ПустаяСтрока(Сред(ТекстПоиска, Позиция, 1)) Тогда
			Прервать;
		КонецЕсли;
		Позиция = Позиция - 1;
	КонецЦикла;
	
	Результат = Новый Структура("Наименование, Сокращение");
	Если Позиция = 0 Тогда
		Результат.Наименование = ТекстПоиска;
		Результат.Сокращение   = "";
	Иначе
		Результат.Наименование = СокрП(Лев(ТекстПоиска, Позиция));
		Результат.Сокращение   = Сред(ТекстПоиска, Позиция + 1);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Набор уровней для запросов в режиме совместимости с КЛАДР.
//
// Возвращаемое значение:
//     ФиксированныйМассив - набор числовых уровней.
//
Функция УровниКлассификатораКЛАДР() Экспорт
	
	Уровни = Новый Массив;
	Уровни.Добавить(1);
	Уровни.Добавить(3);
	Уровни.Добавить(4);
	Уровни.Добавить(6);
	Уровни.Добавить(7);
	
	Возврат Новый ФиксированныйМассив(Уровни);
КонецФункции

// Набор уровней для запросов ФИАС.
//
// Возвращаемое значение:
//     ФиксированныйМассив - набор числовых уровней.
//
Функция УровниКлассификатораФИАС() Экспорт
	
	Уровни = Новый Массив;
	Уровни.Добавить(1);
	Уровни.Добавить(2);
	Уровни.Добавить(3);
	Уровни.Добавить(5);
	Уровни.Добавить(4);
	Уровни.Добавить(6);
	Уровни.Добавить(7);
	Уровни.Добавить(90);
	Уровни.Добавить(91);
	
	Возврат Новый ФиксированныйМассив(Уровни);
КонецФункции

#КонецОбласти

