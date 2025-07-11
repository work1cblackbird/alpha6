﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем ДанныеЗаполнения;
	
	Если НЕ Параметры.Свойство("Данные", ДанныеЗаполнения) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПереносимыеПоля = Новый Массив;
	ПереносимыеПоля.Добавить("Модель");
	ПереносимыеПоля.Добавить("Комплектация");
	ПереносимыеПоля.Добавить("ПодразделениеКомпании");
	ПереносимыеПоля.Добавить("РежимПланированияПоРесурсам");
	ПереносимыеПоля.Добавить("ИспользоватьБазовыйГрафик");
	ПереносимыеПоля.Добавить("БазовыйГрафик");
	ПереносимыеПоля.Добавить("УчитыватьДанныеТабеля");
	ПереносимыеПоля.Добавить("ТекущийДокумент");
	
	Если ДанныеЗаполнения.Свойство("НачалоПериодаРасчета") Тогда
		ПереносимыеПоля.Добавить("НачалоПериодаРасчета");
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, ДанныеЗаполнения, СтрСоединить(ПереносимыеПоля, ","));
	
	РесурсПланирования = ПолучитьЗначениеПараметраСтруктуры(ДанныеЗаполнения, "РесурсПланирования");
	ЭтоРесурсПриемкиВыдачи = Ложь;
	
	Если ЗначениеЗаполнено(РесурсПланирования) Тогда
		
		ЭтоРесурсПриемкиВыдачи = ПланированиеРесурсов.ЭтоРесурсПриемкиВыдачи(РесурсПланирования);
		Объект[?(ЭтоРесурсПриемкиВыдачи, "РесурсПриемкиВыдачи", "РесурсПланирования")] = РесурсПланирования;
		
	КонецЕсли;
	
	Объект[?(ЭтоРесурсПриемкиВыдачи, "НачалоПериодаРасчета", "НачалоПериодаРасчетаОтРесурса")]
		= ПолучитьЗначениеПараметраСтруктуры(ДанныеЗаполнения, "НачалоПериодаРасчетаОтРесурса", Дата(1, 1, 1));
	
	ПроверятьНаличиеВыполненныхАвторабот = ПолучитьЗначениеПараметраСтруктуры(
		ДанныеЗаполнения, "ПроверятьНаличиеВыполненныхАвторабот", Ложь);
	
	АвтоматическоеПланированиеРесурсов.ЗаполнитьОбщимиНастройками(Объект);
	
	КонтрольПланированияПрошедшимВременем = Строка(ПраваИНастройкиПользователя.Значение("КонтрольПланированияПрошедшимВременем"));
	
	Если НЕ ЗначениеЗаполнено(Объект.НачалоПериодаРасчета) Тогда
		Объект.НачалоПериодаРасчета = НачалоМинуты(ТекущаяДатаСеанса());
	КонецЕсли;
	
	СмещениеЧасовогоПояса = ДанныеЗаполнения.СмещениеЧасовогоПояса;
	
	УстановитьПредельныйСрокПланирования();
	
	ЗаполнитьПоДаннымДокумента(ДанныеЗаполнения);
	
	Объект.ПланироватьОтРесурса = (ЗначениеЗаполнено(Объект.НачалоПериодаРасчетаОтРесурса)
		ИЛИ ЗначениеЗаполнено(Объект.РесурсПланирования));
	
	Результат = ЗапланироватьНаСервере();
	
	Если Результат.Ошибка Тогда
		
		ЭлементыСтроки = Новый Массив;
		ЭлементыСтроки.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru = 'Ошибка:'"), Новый Шрифт(,, Истина), ЦветаСтиля.ЦветОтрицательногоТекстаВиджета));
		
		ЭлементыСтроки.Добавить(" ");
		ЭлементыСтроки.Добавить(Новый ФорматированнаяСтрока(Результат.ОписаниеОшибки));
		Элементы.РезультатВыполненияОперации.Заголовок = Новый ФорматированнаяСтрока(ЭлементыСтроки);
		Возврат;
		
	КонецЕсли;
	
	// выведем результат планирования
	СформироватьПредставлениеРезультатаПланирования(Результат.Данные);
	
	Результат.Данные = ОбщегоНазначения.ТаблицаЗначенийВМассив(Результат.Данные);
	ДанныеРезультата = Новый ФиксированнаяСтруктура(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Завершить(Команда)
	
	Если ДанныеРезультата <> Неопределено Тогда
		
		Закрыть(ДанныеРезультата.Данные);
		Возврат;
		
	КонецЕсли;
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьПредставлениеРезультатаПланирования(Результат)
	
	Начало = Дата(3999, 1, 1); 
	Конец = Дата(1, 1, 1);
	
	Если Результат.Количество() = 0 Тогда
		
		Элементы.РезультатВыполненияОперации.Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Результат планирования пустой'")
		);
		Возврат;
		
	КонецЕсли;
	
	Для Каждого Строка Из Результат Цикл
		
		Начало = Мин(Начало, Строка.Начало);
		Конец = Макс(Конец, Строка.Конец);
		
	КонецЦикла;
	
	ЭлементыСтроки = Новый Массив;
	ЭлементыСтроки.Добавить(НСтр("ru = 'Работы запланированы с '"));
	ЭлементыСтроки.Добавить(Формат(Начало + СмещениеЧасовогоПояса, "ДЛФ=DDT"));
	ЭлементыСтроки.Добавить(НСтр("ru = ' по '"));
	ЭлементыСтроки.Добавить(Формат(Конец + СмещениеЧасовогоПояса, "ДЛФ=DDT"));
	
	Элементы.РезультатВыполненияОперации.Заголовок = Новый ФорматированнаяСтрока(ЭлементыСтроки);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредельныйСрокПланирования()
	
	Если НЕ ЗначениеЗаполнено(Объект.ПредельныйСрокРасчетаПланирования) Тогда
		
		Объект.ПредельныйСрокРасчетаПланирования = Объект.НачалоПериодаРасчета + Объект.СрокРасчета * 86400;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполнение табличных частей из документа
//
&НаСервере
Процедура ЗаполнитьПоДаннымДокумента(ДанныеЗаполнения = Неопределено)
	
	Если ЭтоАдресВременногоХранилища(ДанныеЗаполнения.ДоступныеРесурсы) Тогда
		
		Объект.ДоступныеРесурсы.Загрузить(ПолучитьИзВременногоХранилища(ДанныеЗаполнения.ДоступныеРесурсы));
		
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(ДанныеЗаполнения.ПланированиеИнтервалы) Тогда
		
		Объект.ПланированиеИнтервалы.Загрузить(ПолучитьИзВременногоХранилища(ДанныеЗаполнения.ПланированиеИнтервалы));
		
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(ДанныеЗаполнения.ПланированиеОбъекты) Тогда
		
		Объект.ПланированиеОбъекты.Загрузить(ПолучитьИзВременногоХранилища(ДанныеЗаполнения.ПланированиеОбъекты));
		
		ЗаполнитьДополнительныеРеквизиты();
		
		ОбновитьПризнакВидимостиСтроки();
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПоДаннымДокумента()

// Заполнение дополнительных реквизитов объектов планирования
//
&НаСервере
Процедура ЗаполнитьДополнительныеРеквизиты()
	// определимся есть ли запланированные работы
	ЕстьДанныеПланирования = (Объект.ПланированиеИнтервалы.Количество() > 0);
	Если ЕстьДанныеПланирования Тогда
		Объект.ПланированиеИнтервалы.Сортировать("Начало");
	КонецЕсли;
	
	Если ПроверятьНаличиеВыполненныхАвторабот Тогда
		закрытыеПакеты = ПолучитьЗакрытыеПакетыРабот();
	КонецЕсли;
	
	ДополнениеКПорядку = Объект.ПланированиеОбъекты.Количество();
	Для Каждого ОбъектПланирования Из Объект.ПланированиеОбъекты Цикл
		// Установим доступность перепланирования авторабот
		// если заявка то работы еще не начинали выполнения и выполнять проверку не требуется.
		Если НЕ ПроверятьНаличиеВыполненныхАвторабот Тогда
			ОбъектПланирования.ДоступноПерепланирование = Истина;
		Иначе
			закрытыеПакеты.Сбросить();
			
			Если ОбъектПланирования.ВидОбъектаПланирования = Перечисления.ВидыОбъектовПланированияРесурсов.ПричинаОбращения Тогда
				условиеПоиска = Новый Структура("ПричинаОбращения", ОбъектПланирования.Идентификатор);
			Иначе
				условиеПоиска = Новый Структура("Авторабота", ОбъектПланирования.Идентификатор);
			КонецЕсли;
			
			Если закрытыеПакеты.НайтиСледующий(условиеПоиска) Тогда
				ОбъектПланирования.Планировать = 1;
				ОбъектПланирования.ДоступноПерепланирование = Ложь;
			Иначе
				ОбъектПланирования.ДоступноПерепланирование = Истина;
			КонецЕсли;
		КонецЕсли;
		
		// Определим порядок выполнения работы
		// уже запланированные работы имеют более высокий приоритет чем новые.
		Если ОбъектПланирования.ВидОбъектаПланирования = Перечисления.ВидыОбъектовПланированияРесурсов.ПричинаОбращения Тогда
			ОбъектПланирования.ТипАвтоработы = ОбъектПланирования.Объект.ТипАвторабот;
			ОбъектПланирования.НомерКартинки = 1;
		Иначе
			ОбъектПланирования.ТипАвтоработы = ОбъектПланирования.Объект.Тип;
			ОбъектПланирования.НомерКартинки = 3;
		КонецЕсли;
		
		Если ЕстьДанныеПланирования Тогда
			СтрокиЗапланированные = Объект.ПланированиеИнтервалы.НайтиСтроки(
				Новый Структура("Идентификатор", ОбъектПланирования.Идентификатор));
				
			Если СтрокиЗапланированные.Количество() > 0 Тогда
				ОбъектПланирования.Порядок = СтрокиЗапланированные[0].НомерСтроки;
				Доступен = Истина;
				Для Каждого Интервал Из СтрокиЗапланированные Цикл
					Если Не ПланированиеРесурсовКлиентСервер.ПроверитьДоступностьВремениИнтервалаПланирования(Интервал.Конец,
						КонтрольПланированияПрошедшимВременем) Тогда
						Доступен = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если Не Доступен Тогда
					ОбъектПланирования.Планировать = 1;
					ОбъектПланирования.ДоступноПерепланирование = Ложь;
				КонецЕсли;
			Иначе
				ОбъектПланирования.Порядок = ОбъектПланирования.ТипАвтоработы.РеквизитДопУпорядочивания + ДополнениеКПорядку;
			КонецЕсли;
		Иначе
			ОбъектПланирования.Порядок = ОбъектПланирования.ТипАвтоработы.РеквизитДопУпорядочивания;
		КонецЕсли;
		
		// Заполним представление продолжительности
		// пересчитам продолжительность из секунд в более понятное пользователю представление.
		ПродолжительностьДляПредставления = Новый Массив;
		
		Если ЗначениеЗаполнено(ОбъектПланирования.НормаВремениСправочная) Тогда
			
			ПродолжительностьДляПредставления .Добавить(ОбъектПланирования.НормаВремениСправочная);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОбъектПланирования.НормаВремениЗапланировано) Тогда
			
			ПродолжительностьДляПредставления.Добавить(ОбъектПланирования.НормаВремениЗапланировано);
			
		КонецЕсли;
		
		ПродолжительностьПредставление = Новый Массив;
		
		Для Каждого Продолжительность Из ПродолжительностьДляПредставления Цикл
			
			ПродолжительностьПредставление.Добавить(ПланированиеРесурсовКлиентСервер.ПолучитьПредставлениеВремени(Продолжительность));
			
		КонецЦикла;
		
		ОбъектПланирования.ПродолжительностьПредставление = СтрСоединить(ПродолжительностьПредставление, " / ");
		
	КонецЦикла;
	
	Объект.ПланированиеОбъекты.Сортировать("Порядок");
КонецПроцедуры // ЗаполнитьДополнительныеРеквизиты()

&НаСервере
Процедура ОбновитьПризнакВидимостиСтроки()
	
	Для Каждого ОбъектПланирования Из Объект.ПланированиеОбъекты Цикл
		Если ОбъектПланирования.ВидОбъектаПланирования = Перечисления.ВидыОбъектовПланированияРесурсов.ПричинаОбращения
			И НЕ ОбъектПланирования.ПланированиеПоГруппе Тогда
			
			ОбъектПланирования.Отображать = Ложь;
			
		ИначеЕсли ОбъектПланирования.ВидОбъектаПланирования = Перечисления.ВидыОбъектовПланированияРесурсов.Авторабота
			И ОбъектПланирования.ПланированиеПоГруппе
			И НЕ ПустаяСтрока(ОбъектПланирования.ИдентификаторГруппы) Тогда
			
			ОбъектПланирования.Отображать = Ложь;
			
		Иначе
			
			ОбъектПланирования.Отображать = Истина;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЗакрытыеПакетыРабот()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоставПакетовРабот.ЗаказНаряд КАК ЗаказНаряд,
	|	СоставПакетовРабот.ПакетРабот КАК ПакетРабот,
	|	СоставПакетовРабот.Авторабота КАК Авторабота
	|ПОМЕСТИТЬ АвтоработыСПакетами
	|ИЗ
	|	РегистрСведений.СоставПакетовРабот КАК СоставПакетовРабот
	|ГДЕ
	|	СоставПакетовРабот.Авторабота В(&Автоработы)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоставПричинОбращенийЗаказНарядов.ПричинаОбращения КАК ПричинаОбращения,
	|	СоставПричинОбращенийЗаказНарядов.Авторабота КАК Авторабота
	|ПОМЕСТИТЬ ПричиныОбращения
	|ИЗ
	|	РегистрСведений.СоставПричинОбращенийЗаказНарядов КАК СоставПричинОбращенийЗаказНарядов
	|ГДЕ
	|	СоставПричинОбращенийЗаказНарядов.Использование = ИСТИНА
	|	И (СоставПричинОбращенийЗаказНарядов.ЗаказНаряд, СоставПричинОбращенийЗаказНарядов.Авторабота) В
	|			(ВЫБРАТЬ
	|				АвтоработыСПакетами.ЗаказНаряд КАК ЗаказНаряд,
	|				АвтоработыСПакетами.Авторабота КАК Авторабота
	|			ИЗ
	|				АвтоработыСПакетами КАК АвтоработыСПакетами)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АвтоработыСПакетами.ПакетРабот КАК ПакетРабот,
	|	ЕСТЬNULL(ПричиныОбращения.ПричинаОбращения, """") КАК ПричинаОбращения,
	|	АвтоработыСПакетами.Авторабота КАК Авторабота
	|ПОМЕСТИТЬ АвтоработыИПричиныОбращения
	|ИЗ
	|	АвтоработыСПакетами КАК АвтоработыСПакетами
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПричиныОбращения КАК ПричиныОбращения
	|		ПО АвтоработыСПакетами.Авторабота = ПричиныОбращения.Авторабота
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ АвтоработыСПакетами
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПричиныОбращения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СостоянияПакетовРаботСрезПоследних.ПакетРабот КАК ПакетРабот,
	|	СостоянияПакетовРаботСрезПоследних.Состояние КАК Состояние
	|ПОМЕСТИТЬ Состояния
	|ИЗ
	|	РегистрСведений.СостоянияПакетовРабот.СрезПоследних КАК СостоянияПакетовРаботСрезПоследних
	|ГДЕ
	|	СостоянияПакетовРаботСрезПоследних.ПакетРабот В
	|			(ВЫБРАТЬ
	|				АвтоработыИПричиныОбращения.ПакетРабот КАК ПакетРабот
	|			ИЗ
	|				АвтоработыИПричиныОбращения КАК АвтоработыИПричиныОбращения)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АвтоработыИПричиныОбращения.ПричинаОбращения КАК ПричинаОбращения,
	|	АвтоработыИПричиныОбращения.Авторабота       КАК Авторабота,
	|	ЕСТЬNULL(Состояния.Состояние, ЗНАЧЕНИЕ(Справочник.ВидыСостоянийПакетовРабот.НеСтартовал)) КАК Состояние
	|ИЗ
	|	АвтоработыИПричиныОбращения КАК АвтоработыИПричиныОбращения
	|		ЛЕВОЕ СОЕДИНЕНИЕ Состояния КАК Состояния
	|		ПО АвтоработыИПричиныОбращения.ПакетРабот = Состояния.ПакетРабот
	|ГДЕ
	|	ЕСТЬNULL(Состояния.Состояние, ЗНАЧЕНИЕ(Справочник.ВидыСостоянийПакетовРабот.НеСтартовал)) = ЗНАЧЕНИЕ(Справочник.ВидыСостоянийПакетовРабот.Закрыт)";
	
	СтрокиАвторабот = Объект.ПланированиеОбъекты.НайтиСтроки(
		Новый Структура("ВидОбъектаПланирования", Перечисления.ВидыОбъектовПланированияРесурсов.Авторабота));
	
	Запрос.УстановитьПараметр(
		"Автоработы",
		Объект.ПланированиеОбъекты.Выгрузить(СтрокиАвторабот).ВыгрузитьКолонку("Идентификатор"));
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

&НаСервере
Функция ЗапланироватьНаСервере()
	
	Результат = АвтоматическоеПланированиеРесурсов.ВыполнитьАвтоматическоеПланирование(
		Объект.ПланированиеОбъекты.Выгрузить(),
		Объект.ДоступныеРесурсы.Выгрузить(),
		Объект.ПланированиеИнтервалы.Выгрузить(),
		АвтоматическоеПланированиеРесурсов.ПодготовитьПараметрыАвтоматическогоПланирования(Объект));
	
	Если Результат.Ошибка Тогда
		
		Результат.Данные = Неопределено;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
