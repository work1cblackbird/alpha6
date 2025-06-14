﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Физические лица"
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция склоняет переданную фразу
// Параметры:
//  ФИО - Строка - обязательный, должен содержать фамилию имя отчества в именительном падеже,
//                 которые необходимо просклонять.
//
//  Падеж - Число - обязательный. Падеж, в который необходимо поставить ФИО.
//                  1 - Именительный
//                  2 - Родительный
//                  3 - Дательный
//                  4 - Винительный
//                  5 - Творительный
//                  6 - Предложный.
//
//  Результат - Строка - обязательный. Переменная, в которую будет возвращен результат склонения.
//
//  Пол - Перечисление.ПолФизическогоЛиц- необязательный. Пол физического лица.
//
// Возвращаемое значение:
//   Булево - Истина, если операция прошла удачно, Ложь - в противном случае.
//
Функция Просклонять(Знач ФИО, Падеж, Результат, Пол = Неопределено) Экспорт
	
	ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаСклоненияФИО", "Decl");
	Компонента = Новый("AddIn.Decl.CNameDecl");
	
	Результат = "";
	
	МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ФИО, " ");
	
	// Выделим первые 3 слова, так как компонента не умеет склонять фразу большую 3х символов.
	НомерНесклоняемогоСимвола = 4;
	Для Номер = 1 По Мин(МассивСтрок.Количество(), 3) Цикл
		Если Не ФизическиеЛицаКлиентСервер.ФИОНаписаноВерно(МассивСтрок[Номер-1], Истина) Тогда
			НомерНесклоняемогоСимвола = Номер;
			Прервать;
		КонецЕсли;

		Результат = Результат + ?(Номер > 1, " ", "") + МассивСтрок[Номер-1];
	КонецЦикла;
	
	Если ПустаяСтрока(Результат) Тогда
		Результат = ФИО;
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Если Пол = Перечисления.ПолФизическихЛиц.Мужской Тогда
			Результат = Компонента.Просклонять(Результат, Падеж, 1) + " ";
			
		ИначеЕсли Пол = Перечисления.ПолФизическихЛиц.Женский Тогда
			Результат = Компонента.Просклонять(Результат, Падеж, 2) + " ";
			
		Иначе
			Результат = Компонента.Просклонять(Результат, Падеж) + " ";
			
		КонецЕсли;
		
	Исключение
		Результат = ФИО;
		Возврат Ложь;
		
	КонецПопытки;
	
	// Остальные символы добавим без склонения
	Для Номер = НомерНесклоняемогоСимвола По МассивСтрок.Количество() Цикл
		Результат = Результат + " " + МассивСтрок[Номер-1];
	КонецЦикла;
	
	Результат = СокрЛП(Результат);
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"ФизическиеЛица");
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииИсключенийПоискаСсылок"].Добавить(
		"ФизическиеЛица");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий подсистем БСП

// Заполняет массив списком имен объектов метаданных, данные которых могут содержать ссылки
// на различные объекты метаданных, но при этом эти ссылки не должны учитываться в бизнес-логике приложения.
//
// Параметры:
//  Массив       - массив строк, например, "РегистрСведений.ВерсииОбъектов".
//
Процедура ПриДобавленииИсключенийПоискаСсылок(Массив) Экспорт
	
	Зарезервировано = Истина;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Зарезервировано = Истина;
	
КонецПроцедуры

#КонецОбласти