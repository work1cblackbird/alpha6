﻿// Модуль менеджера перечисления "Виды договоров"

#Область СлужебныеПроцедурыИФункции

// Формирует данные выбора в зависимости от включенной функциональной опции
//  Использовать "Комиссионная торговля". Если ф.о. выключена, то из данных
//  выбора исключаются значения "С комиссионером" и "С комитентом".
//
// Параметры:
//  ДанныеВыбора         - СписокЗначений - Можно сформировать и передать в этом параметре данные для выбора.
//  Параметры            - Структура      - Содержит параметры выбора.
//  СтандартнаяОбработка - Булево         - В данный параметр передается признак выполнения системной обработки события.
//
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Константы.ИспользоватьКомиссионнаяТорговля.Получить() Тогда
	
		ДанныеВыбора = Новый СписокЗначений;
		СтандартнаяОбработка = ЛОЖЬ;
		
		Для каждого ВидДоговора Из Перечисления.ВидыДоговоров Цикл
			
			// Если была передана строка поиска, то дополнительно фильтруем список по ней,
			// при этом регистр не имеет значения.
			ВидДоговораНайден = СтрНайти(НРег(Лев(ВидДоговора,СтрДлина(Параметры.СтрокаПоиска))),НРег(Параметры.СтрокаПоиска));
			
			Если ВидДоговора <> Перечисления.ВидыДоговоров.СКомиссионером
				И ВидДоговора <> Перечисления.ВидыДоговоров.СКомитентом
				И ВидДоговораНайден Тогда
				
				ДанныеВыбора.Добавить(ВидДоговора);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПолученияДанныхВыбора()

#КонецОбласти