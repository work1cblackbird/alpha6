﻿// Модуль менеджера регистра сведений "Состав пакетов работ"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Формирует таблицу с полной информацией по пакетам указаного документа
//
// Параметры:
//	Документ - ДокументСсылка.ЗаказНаряд, ДокументСсылка.СводныйРемонтныйЗаказ - Документ для которого сормируется список пакетов
//	Пакеты - Массив - Набор уникальных идентификаторв для которых необходимо составить таблицу.
//
Функция ПолучитьДанныеПакетовДокумента(Документ, Пакеты = Неопределено) Экспорт
	ЭтоСводныйРемонтныйЗаказ = (ТипЗнч(Документ) = Тип("ДокументСсылка.СводныйРемонтныйЗаказ"));
	
	Запрос = Новый Запрос;
	ОтборЗаказНаряд   = "= &Документ"; ОтборСводныйРемонтныйЗаказ = "В (ВЫБРАТЬ Документ ИЗ Документы)";
	ЗапросКДокументам = "ВЫБРАТЬ ЗаказНаряд.Ссылка КАК Документ ПОМЕСТИТЬ Документы ИЗ Документ.ЗаказНаряд КАК ЗаказНаряд ГДЕ ЗаказНаряд.СводныйРемонтныйЗаказ = &Документ;";
	
	ТекстЗапроса =
	"%2
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказНарядАвтоработы.Ссылка,
	|	ЗаказНарядАвтоработы.ИдентификаторРаботы
	|ПОМЕСТИТЬ АвтоработыДокументов
	|ИЗ
	|	Документ.ЗаказНаряд.Автоработы КАК ЗаказНарядАвтоработы
	|ГДЕ
	|	ЗаказНарядАвтоработы.Ссылка %1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоставПакетовРабот.ЗаказНаряд,
	|	СоставПакетовРабот.ПакетРабот,
	|	СоставПакетовРабот.Авторабота
	|ПОМЕСТИТЬ СоставПакетовРабот
	|ИЗ
	|	РегистрСведений.СоставПакетовРабот КАК СоставПакетовРабот
	|ГДЕ
	|	СоставПакетовРабот.ЗаказНаряд %1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СостоянияПакетовРаботСрезПоследних.ПакетРабот,
	|	СостоянияПакетовРаботСрезПоследних.Состояние
	|ПОМЕСТИТЬ СостоянияПакетовРабот
	|ИЗ
	|	РегистрСведений.СостоянияПакетовРабот.СрезПоследних(
	|			,
	|			ПакетРабот В
	|				(ВЫБРАТЬ
	|					СоставПакетовРабот.ПакетРабот
	|				ИЗ
	|					СоставПакетовРабот КАК СоставПакетовРабот)) КАК СостоянияПакетовРаботСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИнформацияОПакетахАвторабот.ПакетРабот,
	|	ИнформацияОПакетахАвторабот.Представление,
	|	ИнформацияОПакетахАвторабот.ТекущиеИсполнители,
	|	ИнформацияОПакетахАвторабот.НомерПакета
	|ПОМЕСТИТЬ ИнформацияПакетовРабот
	|ИЗ
	|	РегистрСведений.ИнформацияОПакетахАвторабот КАК ИнформацияОПакетахАвторабот
	|ГДЕ
	|	ИнформацияОПакетахАвторабот.ПакетРабот В
	|			(ВЫБРАТЬ
	|				СоставПакетовРабот.ПакетРабот
	|			ИЗ
	|				СоставПакетовРабот КАК СоставПакетовРабот)
	|;
	|
	|%3
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АвтоработыДокументов.Ссылка,
	|	АвтоработыДокументов.ИдентификаторРаботы,
	|	ЕСТЬNULL(СоставПакетовРабот.ПакетРабот, &ПустойПакет) КАК ПакетРабот
	|ПОМЕСТИТЬ ПолныйСотав
	|ИЗ
	|	АвтоработыДокументов КАК АвтоработыДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ СоставПакетовРабот КАК СоставПакетовРабот
	|		ПО АвтоработыДокументов.ИдентификаторРаботы = СоставПакетовРабот.Авторабота
	|			И АвтоработыДокументов.Ссылка = СоставПакетовРабот.ЗаказНаряд
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ АвтоработыДокументов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ СоставПакетовРабот
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПолныйСотав.Ссылка,
	|	ПолныйСотав.ИдентификаторРаботы,
	|	ПолныйСотав.ПакетРабот,
	|	ЕСТЬNULL(ИнформацияПакетовРабот.Представление, &ПредставлениеПустогоПакета) КАК Представление,
	|	ЕСТЬNULL(ИнформацияПакетовРабот.ТекущиеИсполнители, """") КАК ТекущиеИсполнители,
	|	ЕСТЬNULL(ИнформацияПакетовРабот.НомерПакета, 0) КАК НомерПакета,
	|	ЕСТЬNULL(СостоянияПакетовРабот.Состояние, ЗНАЧЕНИЕ(Справочник.ВидыСостоянийПакетовРабот.НеСтартовал)) КАК СтатусПакета,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(СостоянияПакетовРабот.Состояние, ЗНАЧЕНИЕ(Справочник.ВидыСостоянийПакетовРабот.НеСтартовал)) = ЗНАЧЕНИЕ(Справочник.ВидыСостоянийПакетовРабот.НеСтартовал)
	|		ТОГДА 3
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ЕСТЬNULL(СостоянияПакетовРабот.Состояние, ЗНАЧЕНИЕ(Справочник.ВидыСостоянийПакетовРабот.НеСтартовал)) = ЗНАЧЕНИЕ(Справочник.ВидыСостоянийПакетовРабот.ВРаботе)
	|				ТОГДА 0
	|				ИНАЧЕ ВЫБОР
	|						КОГДА ЕСТЬNULL(СостоянияПакетовРабот.Состояние, ЗНАЧЕНИЕ(Справочник.ВидыСостоянийПакетовРабот.НеСтартовал)) = ЗНАЧЕНИЕ(Справочник.ВидыСостоянийПакетовРабот.Закрыт)
	|						ТОГДА 2
	|						ИНАЧЕ 1
	|					  КОНЕЦ
	|			  КОНЕЦ
	|	КОНЕЦ КАК НомерКартинкиСостоянияПакетаРабот
	|ИЗ
	|	ПолныйСотав КАК ПолныйСотав
	|		ЛЕВОЕ СОЕДИНЕНИЕ СостоянияПакетовРабот КАК СостоянияПакетовРабот
	|		ПО ПолныйСотав.ПакетРабот = СостоянияПакетовРабот.ПакетРабот
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИнформацияПакетовРабот КАК ИнформацияПакетовРабот
	|		ПО ПолныйСотав.ПакетРабот = ИнформацияПакетовРабот.ПакетРабот";
	
	Запрос = Новый Запрос(СтрШаблон(ТекстЗапроса, ?(ЭтоСводныйРемонтныйЗаказ, ОтборСводныйРемонтныйЗаказ, ОтборЗаказНаряд), ?(ЭтоСводныйРемонтныйЗаказ, ЗапросКДокументам, ""), ?(ЭтоСводныйРемонтныйЗаказ, "УНИЧТОЖИТЬ Документы;", "")));
	ИнформацияПоПустомуПакету = РаботаСПакетамиРаботПовтИсп.ИнформацияПоПустомуПакету();
	
	Запрос.УстановитьПараметр("ПустойПакет"                , ИнформацияПоПустомуПакету.ПакетРабот);
	Запрос.УстановитьПараметр("ПредставлениеПустогоПакета" , ИнформацияПоПустомуПакету.Представление);
	Запрос.УстановитьПараметр("Документ"                   , Документ);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#Область ПараметрыОбработкиРеквизитовОбъекта

Функция ПолучитьОбязательныеРеквизиты(Объект) Экспорт
	
	ОбязательныеРеквизиты = ОбработкаСобытийРегистраСервер.ПолучитьСтандартныеОбязательныеРеквизиты(Объект);
	
	Возврат ОбязательныеРеквизиты;
	
КонецФункции 

Функция ПолучитьУникальныеРеквизиты(Объект) Экспорт
	
	УникальныеРеквизиты = Новый Структура();
	
	Возврат УникальныеРеквизиты;
	
КонецФункции 
#КонецОбласти

#КонецОбласти

#КонецЕсли