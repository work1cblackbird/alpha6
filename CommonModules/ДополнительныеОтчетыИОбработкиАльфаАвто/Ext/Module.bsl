﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. ДополнительныеОтчетыИОбработкиПереопределяемый.ОпределитьРазделыСДополнительнымиОбработками
Процедура ОпределитьРазделыСДополнительнымиОбработками(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.АвтомобилиСПробегом);
	Разделы.Добавить(Метаданные.Подсистемы.АвтосалонЗаказы);
	Разделы.Добавить(Метаданные.Подсистемы.АвтосалонПродажи);
	Разделы.Добавить(Метаданные.Подсистемы.АвтосалонСклад);
	Разделы.Добавить(Метаданные.Подсистемы.АвтосалонСнабжение);
	Разделы.Добавить(Метаданные.Подсистемы.Автосервис);
	Разделы.Добавить(Метаданные.Подсистемы.Маркетинг);
	Разделы.Добавить(Метаданные.Подсистемы.Предприятие);
	Разделы.Добавить(Метаданные.Подсистемы.Продажи);
	Разделы.Добавить(Метаданные.Подсистемы.Розница);
	Разделы.Добавить(Метаданные.Подсистемы.Склад);
	Разделы.Добавить(Метаданные.Подсистемы.Снабжение);
	Разделы.Добавить(Метаданные.Подсистемы.Финансы);
		
КонецПроцедуры

// См. ДополнительныеОтчетыИОбработкиПереопределяемый.ОпределитьРазделыСДополнительнымиОтчетами
Процедура ОпределитьРазделыСДополнительнымиОтчетами(Разделы) Экспорт
	
	 Разделы.Добавить(Метаданные.Подсистемы.АвтомобилиСПробегом);
	 Разделы.Добавить(Метаданные.Подсистемы.АвтосалонЗаказы);
	 Разделы.Добавить(Метаданные.Подсистемы.АвтосалонПродажи);
	 Разделы.Добавить(Метаданные.Подсистемы.АвтосалонСклад);
	 Разделы.Добавить(Метаданные.Подсистемы.АвтосалонСнабжение);
	 Разделы.Добавить(Метаданные.Подсистемы.Автосервис);
	 Разделы.Добавить(Метаданные.Подсистемы.Маркетинг);
	 Разделы.Добавить(Метаданные.Подсистемы.Предприятие);
	 Разделы.Добавить(Метаданные.Подсистемы.Продажи);
	 Разделы.Добавить(Метаданные.Подсистемы.Розница);
	 Разделы.Добавить(Метаданные.Подсистемы.Склад);
	 Разделы.Добавить(Метаданные.Подсистемы.Снабжение);
	 Разделы.Добавить(Метаданные.Подсистемы.Финансы);
		
КонецПроцедуры

// Установка параметров функциональных опций формы (требуется для формирования
// командного интерфейса формы).
//
// Параметры:
//   Форма    - УправляемаяФорма - Форма, из которой вызвана команда.
//   ТипФормы - Строка - Необязательный. "ФормаСписка" для форм списков и "ФормаОбъекта" для форм элементов.
//       См. также функции ТипФормыСписка() и ТипФормыОбъекта() общего модуля
//       ДополнительныеОтчетыИОбработкиКлиентСервер.
//
Процедура ПриСозданииНаСервере(Форма, ТипФормы = Неопределено) Экспорт
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеОтчетыИОбработки") Тогда
		ПараметрыФункциональныхОпций = Новый Структура;
		ПараметрыФункциональныхОпций.Вставить("ДополнительныеОтчетыИОбработкиОбъектНазначения", Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка());
		ПараметрыФункциональныхОпций.Вставить("ДополнительныеОтчетыИОбработкиТипФормы",         Неопределено);
		Форма.УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФункциональныхОпций);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ФормаОбщаяКомандаЗаполнениеОбъекта",
			"Видимость",
			Ложь);
		Возврат;
	КонецЕсли;
	
	// Установка параметров формы для команд вызова дополнительных отчетов и обработок.
	Параметры = ДополнительныеОтчетыИОбработкиПовтИсп.ПараметрыФормыНазначаемогоОбъекта(Форма.ИмяФормы, ТипФормы);
	Если ТипЗнч(Параметры) <> Тип("ФиксированнаяСтруктура") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФункциональныхОпций = Новый Структура;
	ПараметрыФункциональныхОпций.Вставить("ДополнительныеОтчетыИОбработкиОбъектНазначения", Параметры.СсылкаРодителя);
	ПараметрыФункциональныхОпций.Вставить("ДополнительныеОтчетыИОбработкиТипФормы",         ?(ТипФормы = Неопределено, Параметры.ТипФормы, ТипФормы));
	
	Форма.УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФункциональныхОпций);
	
	Если ПолучитьЗначениеПараметраСтруктуры(Параметры, "ВыводитьПодменюЗаполнениеОбъекта", Ложь) Тогда
	//Если Параметры.ВыводитьПодменюЗаполнениеОбъекта Тогда
		ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ДополнительныеОтчетыИОбработкиНазначение.Ссылка
		|ПОМЕСТИТЬ втСсылки
		|ИЗ
		|	Справочник.ДополнительныеОтчетыИОбработки.Назначение КАК ДополнительныеОтчетыИОбработкиНазначение
		|ГДЕ
		|	ДополнительныеОтчетыИОбработкиНазначение.ОбъектНазначения = &ОбъектНазначения
		|	И ДополнительныеОтчетыИОбработкиНазначение.Ссылка.Вид = &Вид
		|	И ДополнительныеОтчетыИОбработкиНазначение.Ссылка.ИспользоватьДляФормыОбъекта = ИСТИНА
		|	И ДополнительныеОтчетыИОбработкиНазначение.Ссылка.Публикация = &Публикация
		|	И ДополнительныеОтчетыИОбработкиНазначение.Ссылка.ПометкаУдаления = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДополнительныеОтчетыИОбработкиКоманды.Ссылка,
		|	ДополнительныеОтчетыИОбработкиКоманды.Идентификатор,
		|	ДополнительныеОтчетыИОбработкиКоманды.ВариантЗапуска,
		|	ДополнительныеОтчетыИОбработкиКоманды.Представление КАК Представление,
		|	ДополнительныеОтчетыИОбработкиКоманды.ПоказыватьОповещение,
		|	ДополнительныеОтчетыИОбработкиКоманды.Модификатор,
		|	ДополнительныеОтчетыИОбработкиКоманды.Ссылка.Вид
		|ИЗ
		|	втСсылки КАК втСсылки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Команды КАК ДополнительныеОтчетыИОбработкиКоманды
		|		ПО втСсылки.Ссылка = ДополнительныеОтчетыИОбработкиКоманды.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Представление";
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ОбъектНазначения", Параметры.СсылкаРодителя);
		Запрос.УстановитьПараметр("Вид", Перечисления.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта);
		Запрос.УстановитьПараметр("ВариантЗапуска", Перечисления.СпособыВызоваДополнительныхОбработок.ЗаполнениеФормы);
		Если Пользователи.РолиДоступны("ДобавлениеИзменениеДополнительныхОтчетовИОбработок") Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Публикация = &Публикация", "Публикация <> &Публикация");
			Запрос.УстановитьПараметр("Публикация", Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена);
		Иначе
			Запрос.УстановитьПараметр("Публикация", Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется);
		КонецЕсли;
		Запрос.Текст = ТекстЗапроса;
		
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Возврат;
		КонецЕсли;
		
		// Определение группы, в которую будут добавлены команды.
		Элементы = Форма.Элементы;
		
		ПредустановленныеКоманды = Новый Массив;
		Подменю = Элементы.Найти("ПодменюЗаполнитьСмТакже");
		Если Подменю = Неопределено Тогда
			Подменю = Элементы.Найти("ПодменюЗаполнитьОбычное");
		КонецЕсли;
		Если Подменю = Неопределено Тогда
			Подменю = Элементы.Найти("ПодменюЗаполнить");
		КонецЕсли;
		Если Подменю = Неопределено Тогда
			Подменю = Элементы.Найти("ПодменюДополнительныхОбработокЗаполнения");
		КонецЕсли;
		Если Подменю = Неопределено Тогда
			// +РАРУС В случае добавления в объекты ТП3 команда должна добавляться в нужную группу.
			Подменю = ЗащищенныеФункцииСервер.ДобавитьГруппуКоманд(Форма, "ПодменюДополнительныхОбработокЗаполнения", ?(Элементы.Найти("ГлобальныеКоманды")=Неопределено, "ФормаКоманднаяПанель", "ГлобальныеКоманды"), ИСТИНА, НСтр("ru = 'Заполнить'"), БиблиотекаКартинок.ЗаполнитьФорму,, "ФормаСоздатьНаОсновании");
			// -РАРУС
		Иначе
			Для Каждого Элемент Из Подменю.ПодчиненныеЭлементы Цикл
				ПредустановленныеКоманды.Добавить(Элемент);
			КонецЦикла;
		КонецЕсли;
		
		ТаблицаКоманд = Результат.Выгрузить();
		ТаблицаКоманд.Колонки.Добавить("ИмяЭлемента", Новый ОписаниеТипов("Строка"));
		ТаблицаКоманд.Колонки.Добавить("ЭтоОтчет", Новый ОписаниеТипов("Булево"));
		
		Для НомерЭлемента = 0 По ТаблицаКоманд.Количество() - 1 Цикл
			ОписаниеКоманды = ТаблицаКоманд[НомерЭлемента];
			ИмяЭлемента = "КомандаДополнительнойОбработки" + Формат(НомерЭлемента, "ЧГ=");
			ОписаниеКоманды.ИмяЭлемента = ИмяЭлемента;
			
			// +РАРУС  Внесены правки, так как нужно использовать другое действие команды.
			ОписаниеКомандыФормы = ЗащищенныеФункцииСервер.СоздатьОписаниеКомандыФормы();
			ОписаниеКомандыФормы.ИмяКоманды            = ИмяЭлемента;
			ОписаниеКомандыФормы.ИмяГруппы             = Подменю.Имя;
			ОписаниеКомандыФормы.Заголовок             = ОписаниеКоманды.Представление;
			ОписаниеКомандыФормы.ТолькоВоВсехДействиях = Ложь;
			ОписаниеКомандыФормы.Отображение           = ОтображениеКнопки.Картинка;
			ЗащищенныеФункцииСервер.ДобавитьКомандуФормы(Форма, ОписаниеКомандыФормы);
			// -РАРУС
			
		КонецЦикла;
		Команда = Форма.Команды.Добавить("АдресКомандДополнительныхОбработокВоВременномХранилище");
		Команда.Действие = ПоместитьВоВременноеХранилище(ТаблицаКоманд, Форма.УникальныйИдентификатор);
		
		Для Каждого Элемент Из ПредустановленныеКоманды Цикл
			Элементы.Переместить(Элемент, Подменю);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Выполняет назначаемую команду контекстно из формы объекта назначения.
// Предназначена для вызова кодом этой подсистемы из формы элемента назначаемого объекта 
// (например, справочника или документа).
//
// Важно: проверка функциональной опции "ИспользоватьДополнительныеОтчетыИОбработки"
// должна выполняться вызывающим кодом.
//
// Параметры:
//   Форма               - УправляемаяФорма - Форма, из которой вызвана команда.
//   ИмяЭлемента         - Строка           - Имя команды формы, которая была нажата.
//   РезультатВыполнения - Структура        - для служебного использования.
//
Процедура ВыполнитьНазначаемуюКомандуНаСервере(Форма, ИмяЭлемента, РезультатВыполнения = Неопределено) Экспорт
	
	ОписаниеКоманды = ОписаниеКомандыОбработки(ИмяЭлемента, 
		Форма.Команды.Найти("АдресКомандДополнительныхОбработокВоВременномХранилище").Действие);
		
	ПараметрыКоманды = Новый Структура;   
	ПараметрыКоманды.Вставить("ДополнительнаяОбработкаСсылка", ОписаниеКоманды.Ссылка);
	ПараметрыКоманды.Вставить("ИдентификаторКоманды", ОписаниеКоманды.Идентификатор);
	ПараметрыКоманды.Вставить("ЭтаФорма", Форма);
	
	РезультатВыпонения = ДополнительныеОтчетыИОбработки.ВыполнитьКоманду(ПараметрыКоманды, Неопределено);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеКомандыОбработки(ИмяЭлемента, АдресТаблицыКомандВоВременномХранилище) Экспорт
	ТаблицаКоманд = ПолучитьИзВременногоХранилища(АдресТаблицыКомандВоВременномХранилище);
	Для Каждого КомандаОбработки Из ТаблицаКоманд.НайтиСтроки(Новый Структура("ИмяЭлемента", ИмяЭлемента)) Цикл
		Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(КомандаОбработки);
	КонецЦикла;
КонецФункции

#КонецОбласти