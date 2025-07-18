﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует дерево зарезервированных автомобилей
//
// Параметры:
//  Объект - ОбработкаОбъект.АвтоматическоеСнятиеРезервовАвтомобилей - Объект обработки.
//  УстановитьСхемуКомпоновкиДанных - Булево - Признак необходимости устанавливать настройки отборов по умолчанию.
//
// Возвращаемое значение:
//  ДеревоЗначений.
//
Функция ПолучитьДеревоЗаказовАвтомобилей(Объект, УстановитьСхемуКомпоновкиДанных = Истина) Экспорт
	
	СхемаКомпановкиДанных = ПодготовитьСКД(Объект, УстановитьСхемуКомпоновкиДанных);
	ДеревоРезультат = Новый ДеревоЗначений();
	
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакетаКомпоновкиДанных.Выполнить(
		СхемаКомпановкиДанных,
		Объект.КомпоновщикНастроекКомпоновкиДанных.Настройки,
		,
		,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ДеревоРезультат);
	ПроцессорВывода.НачатьВывод();
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
	ПроцессорВывода.ЗакончитьВывод();
	
	Возврат ДеревоРезультат;
	
КонецФункции

// Создает документы отмены резервов, по просроченным документам резервирования
//
// Параметры:
//  Дерево - ДеревоЗначений - Дерево с зарезервированными автомобилями.
//  СоздаватьНапоминание - Булево - Признак создания оповещений менеджерам отмененных документов резервирования.
//  СписаниеРезервовСПредоплатой - Булево - Определяет будут ли отменяться резервы для предоплаченых документов.
//  ФоновыйРежим - Булево - Признак выполнения операции в фоновом режиме.
//
// Возвращаемое значение:
//  Структура.
//  Поля:
//   Ошибка - Булево - Признак ошибки в обработке.
//   Данные - Строка, ТаблицаЗначений - Если ошибка представление ошибки.
//                                      Для успешной обработки таблица созданных документов.
//
Функция ВыполнитьСнятиеРезервовАвтомобилей(
	Дерево,
	СоздаватьНапоминание = Ложь,
	СписаниеРезервовСПредоплатой = Ложь,
	ФоновыйРежим = Ложь) Экспорт
	
	РазрешениеСнятияРезервов = ПраваИНастройкиПользователя.Значение("РазрешениеСнятияРезервов");
	Если РазрешениеСнятияРезервов = Перечисления.РезервыСпособыСписания.Запрещено Тогда
		
		Возврат НоваяОшибка(НСтр("ru = 'Запрещено снимать резервы.'"));
		
	КонецЕсли;
	
	ДокументыДляСнятияРезервов = ДокументыДляСнятияРезервов(Дерево, СписаниеРезервовСПредоплатой, НЕ ФоновыйРежим);
	
	// Если ничего не выбрано, прерываем обработку
	Если ДокументыДляСнятияРезервов.Количество() = 0 Тогда
		
		Возврат НоваяОшибка(НСтр("ru = 'Не выбрано документов для формирования снятия резервов'"));
		
	КонецЕсли;
	
	ДокументыКЗаписи = Новый Массив;
	
	// Сначала отменим заказы на автомобили
	ЗаказыДляСнятияРезервов = ДокументыДляСнятияРезервов.НайтиСтроки(Новый Структура("ЭтоЗаказ", Истина));
	
	Для Каждого Строка Из ЗаказыДляСнятияРезервов Цикл
		
		ОтменаЗаказа = Документы.ЗаказНаАвтомобиль.СоздатьДокумент();
		ОтменаЗаказа.ХозОперация = Справочники.ХозОперации.ЗаказНаАвтомобильОтмена;
		ОтменаЗаказа.ДокументОснование = Строка.Заказ;
		ОтменаЗаказа.Заполнить(Строка.Заказ);
		ОтменаЗаказа.Комментарий = НСтр("ru = 'Автоматическое снятие резерва и отмена заказа'");
		ДокументыКЗаписи.Добавить(ОтменаЗаказа);
		
	КонецЦикла;
	
	РезервированияДляОтмены = ДокументыДляСнятияРезервов.НайтиСтроки(Новый Структура("ЭтоЗаказ", Ложь));
	
	Если РезервированияДляОтмены.Количество() > 0 Тогда
		
		СнятиеРезервов = Документы.СнятиеРезервовАвтомобилей.СоздатьДокумент();
		СнятиеРезервов.Заполнить(Неопределено);
		СнятиеРезервов.Комментарий = НСтр("ru = 'Автоматическое снятие резерва и отмена заказа'");
		
		Для Каждого Строка Из РезервированияДляОтмены Цикл
			
			ЗаполнитьЗначенияСвойств(СнятиеРезервов.Автомобили.Добавить(), Строка);
			
		КонецЦикла;
		
		Если РезервированияДляОтмены.Количество() = 1 Тогда
			СнятиеРезервов.ДокументОснование = РезервированияДляОтмены[0].Заказ;	
		КонецЕсли;
		
		ДокументыКЗаписи.Добавить(СнятиеРезервов);
		
	КонецЕсли;
	
	СозданныеДокументы = Новый ТаблицаЗначений;
	СозданныеДокументы.Колонки.Добавить("Ссылка");
	СозданныеДокументы.Колонки.Добавить("Автомобиль", Новый ОписаниеТипов("СправочникСсылка.Автомобили"));
	
	Для Каждого Документ Из ДокументыКЗаписи Цикл
		НачатьТранзакцию();
		Попытка
			
			Документ.Записать(РежимЗаписиДокумента.Проведение);
			
			Если ТипЗнч(Документ) = Тип("ДокументОбъект.ЗаказНаАвтомобиль") Тогда
				
				НоваяСтрока = СозданныеДокументы.Добавить();
				НоваяСтрока.Ссылка = Документ.Ссылка;
				НоваяСтрока.Автомобиль = Документ.Автомобиль;
				
			Иначе
				
				Для Каждого Автомобиль Из Документ.Автомобили Цикл
					
					НоваяСтрока = СозданныеДокументы.Добавить();
					НоваяСтрока.Ссылка = Документ.Ссылка;
					НоваяСтрока.Автомобиль = Автомобиль.Автомобиль;
					
				КонецЦикла;
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();

		Исключение
			
			ОтменитьТранзакцию();
			ЗаписьЖурналаРегистрации(
				"Ошибка снятия резервов автомобилей",
				УровеньЖурналаРегистрации.Ошибка,
				,
				Документ,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			СообщениеПользователю = ОбщегоНазначенияКлиентСервер
				.ЗначениеВМассиве(НСтр("ru = 'Запись была отменена по причине:'"));
			СообщениеПользователю.Добавить(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			СообщениеПользователю.Добавить(НСтр("ru = 'Подробнее в журнале регистрации.'"));
			
			Возврат НоваяОшибка(СтрСоединить(СообщениеПользователю, Символы.ПС));
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если СоздаватьНапоминание Тогда
		
		ОповеститьПользователейОбОтменеЗаказов(ДокументыДляСнятияРезервов.Скопировать(ЗаказыДляСнятияРезервов));
		
	КонецЕсли;
	
	Возврат НовыйРезультат(СозданныеДокументы);
	
КонецФункции

// Снятие резервов автомобилей в автоматическом режиме. Используется в регламентном задании.
//
// Параметры:
//  ПараметрыОбработки - Структура - Доступные значения:
//   *ФормированиеНапоминаний - Булево - Признак необходимости оповещения менеджеров создавших.
//                                      документы резервирования. Используется механизм напоминаний.
//   *СписаниеРезервовСПредоплатой - Булево - Определяет будут ли отменяться резервы для предоплаченых документов.
//
Процедура ВыполнитьАвтоматическоеСнятиеРезервовАвтомобилей(ПараметрыОбработки) Экспорт
	
	Объект = Обработки.АвтоматическоеСнятиеРезервовАвтомобилей.Создать();
	Дерево = ПолучитьДеревоЗаказовАвтомобилей(Объект);
	ВыполнитьСнятиеРезервовАвтомобилей(
		Дерево,
		ПолучитьЗначениеПараметраСтруктуры(ПараметрыОбработки, "ФормированиеНапоминаний", Ложь),
		ПолучитьЗначениеПараметраСтруктуры(ПараметрыОбработки, "СписаниеРезервовСПредоплатой", Ложь),
		Истина);
	
КонецПроцедуры

// Формирует набор напоминаний по просроченным резервам и записывает их
//
// Параметры:
//  ЗаказыСПредоплатой - Неопределено, Булево - заказы с предоплатой
// 
Процедура СформироватьНапоминанияПроСнятиеРезервовАвтомобилей(ЗаказыСПредоплатой) Экспорт
	
	Объект = Обработки.АвтоматическоеСнятиеРезервовАвтомобилей.Создать();
	ОповеститьПользователейОбПросрочке(ДокументыДляОповещенииОПросрочке(ПолучитьДеревоЗаказовАвтомобилей(Объект), ЗаказыСПредоплатой));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПодготовитьСКД(Объект, УстановитьСхемуКомпоновкиДанных = Истина)
	
	Если Объект.СхемаКомпоновкиДанных = Неопределено И УстановитьСхемуКомпоновкиДанных Тогда
		
		Объект.СхемаКомпоновкиДанных = Обработки.АвтоматическоеСнятиеРезервовАвтомобилей.ПолучитьМакет("ЗаказыСоСроками");
		Объект.КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Объект.СхемаКомпоновкиДанных));
		Объект.КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(Объект.СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
		Возврат Объект.СхемаКомпоновкиДанных;
		
	КонецЕсли;
	
	Возврат Обработки.АвтоматическоеСнятиеРезервовАвтомобилей.ПолучитьМакет("ЗаказыСоСроками");
	
КонецФункции

Функция НоваяОшибка(ОписаниеОшибки)
	
	Возврат Новый Структура("Ошибка,Данные", Истина, ОписаниеОшибки);
	
КонецФункции

Функция НовыйРезультат(Данные)
	
	Возврат Новый Структура("Ошибка,Данные", Ложь, Данные);
	
КонецФункции

Функция ДокументыДляСнятияРезервов(Дерево, СписаниеРезервовСПредоплатой = Ложь, ПоИспользованию = Истина)
	
	ТипыДокументов = Новый Массив;
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ЗаказНаАвтомобиль"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РезервированиеАвтомобилей"));
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Заказ", Новый ОписаниеТипов(ТипыДокументов));
	Результат.Колонки.Добавить("Автомобиль", Новый ОписаниеТипов("СправочникСсылка.Автомобили"));
	Результат.Колонки.Добавить("ЭтоЗаказ", Новый ОписаниеТипов("Булево"));
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	Для Каждого Группа Из Дерево.Строки Цикл
		
		Для Каждого Строка Из Группа.Строки Цикл
			
			Если НЕ Строка.Использование Тогда
				Продолжить;
			КонецЕсли;
			
			Если НЕ ПоИспользованию И Строка.СрокСнятияРезерва >= ТекущаяДата Тогда
				Продолжить;
			КонецЕсли;
			
			Если НЕ ПоИспользованию И НЕ СписаниеРезервовСПредоплатой И Строка.Оплата > 0 Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = Результат.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			НоваяСтрока.ЭтоЗаказ = (ТипЗнч(Строка.Заказ) = Тип("ДокументСсылка.ЗаказНаАвтомобиль"));
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ДокументыДляОповещенииОПросрочке(Дерево, ЗаказыСПредоплатой)
	
	СрокНапоминанияСнятияРезервов = Константы.СрокНапоминанияСнятияРезервов.Получить();
	СрокРезервирования = ТекущаяДатаСеанса() + 24 * 3600 * СрокНапоминанияСнятияРезервов;
	
	ТипыДокументов = Новый Массив;
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ЗаказНаАвтомобиль"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РезервированиеАвтомобилей"));
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Заказ", Новый ОписаниеТипов(ТипыДокументов));
	Результат.Колонки.Добавить("СрокСнятияРезерва", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	Результат.Колонки.Добавить("ЭтоЗаказ", Новый ОписаниеТипов("Булево"));
	
	Для Каждого Группа Из Дерево.Строки Цикл
		
		Для Каждого Строка Из Группа.Строки Цикл
			
			Если НЕ ЗначениеЗаполнено(Строка.СрокСнятияРезерва) ИЛИ Строка.СрокСнятияРезерва > СрокРезервирования Тогда
				Продолжить;
			КонецЕсли;
			
			Если НЕ ЗаказыСПредоплатой И Строка.Оплата > 0 Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = Результат.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			НоваяСтрока.ЭтоЗаказ = (ТипЗнч(Строка.Заказ) = Тип("ДокументСсылка.ЗаказНаАвтомобиль"));
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ОповеститьПользователейОбОтменеЗаказов(ОтмененныеРезервы)
	
	Если ОтмененныеРезервы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТаблицаЗаказов.Заказ КАК Документ.ЗаказНаАвтомобиль) КАК Заказ
	|ПОМЕСТИТЬ ТаблицаЗаказов
	|ИЗ
	|	&ТЗаказов КАК ТаблицаЗаказов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказНаАвтомобиль.Заказ КАК Заказ,
	|	ПРЕДСТАВЛЕНИЕ(ЗаказНаАвтомобиль.Заказ) КАК ЗаказПредставление,
	|	ЕСТЬNULL(Пользователи.Ссылка, ЗаказНаАвтомобиль.Заказ.Автор) КАК Пользователь
	|ИЗ
	|	ТаблицаЗаказов КАК ЗаказНаАвтомобиль
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
	|		ПО ЗаказНаАвтомобиль.Заказ.Менеджер = Пользователи.Сотрудник
	|			И (НЕ Пользователи.Сотрудник = ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка))
	|			И (Пользователи.ПометкаУдаления = ЛОЖЬ)
	|ГДЕ
	|	ЕСТЬNULL(Пользователи.Ссылка, ЗаказНаАвтомобиль.Заказ.Автор) <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|ИТОГИ ПО
	|	Пользователь");
	Запрос.УстановитьПараметр("ТЗаказов", ОтмененныеРезервы);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ВыборкаПользователи = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВремяСобытия = ТекущаяДатаСеанса() + 180;
	Расписание = Новый ХранилищеЗначения(Неопределено, Новый СжатиеДанных(9));
	Набор = РегистрыСведений.НапоминанияПользователя.СоздатьНаборЗаписей();
	Набор.Отбор.Автор.Установить(Пользователи.АвторизованныйПользователь());
	Набор.Прочитать();
	
	Пока ВыборкаПользователи.Следующий() Цикл
		
		Выборка = ВыборкаПользователи.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Запись = Набор.Добавить();
			Запись.Пользователь = ВыборкаПользователи.Пользователь;
			Запись.Автор = Пользователи.ТекущийПользователь();
			Запись.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ВУказанноеВремя;
			Запись.ВремяСобытия = ВремяСобытия;
			Запись.СрокНапоминания = ВремяСобытия;
			Запись.Описание = СтрШаблон(НСтр("ru = 'Был отменен документ заказ на автомобиль <%1>'"), 
									Выборка.ЗаказПредставление);
			Запись.Расписание = Расписание;
			Запись.ПредставлениеИсточника = НСтр("ru = 'Автоматическое снятие резервов по заказам автомобилей.'");
			Запись.Источник = Выборка.Заказ;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Попытка
		
		Набор.Записать();
		
	Исключение
		
		ЗаписьЖурналаРегистрации(
			"Оповещение пользователей об отмене заказов на автомобиль",
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
КонецПроцедуры

Процедура ОповеститьПользователейОбПросрочке(ПросроченныеРезервы)
	
	Если ПросроченныеРезервы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СрокНапоминанияСнятияРезервов = Константы.СрокНапоминанияСнятияРезервов.Получить();
	ТекущаяДата = ТекущаяДатаСеанса();
	СрокРезервирования = ТекущаяДата + 24 * 3600 * СрокНапоминанияСнятияРезервов;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаЗаказов.Заказ КАК Документ,
	|	ТаблицаЗаказов.СрокСнятияРезерва КАК СрокСнятияРезерва,
	|	ТаблицаЗаказов.ЭтоЗаказ КАК ЭтоЗаказ
	|ПОМЕСТИТЬ ТаблицаЗаказов
	|ИЗ
	|	&ТЗаказов КАК ТаблицаЗаказов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТаблицаЗаказов.Документ КАК Документ.ЗаказНаАвтомобиль) КАК Документ,
	|	ТаблицаЗаказов.СрокСнятияРезерва КАК СрокСнятияРезерва
	|ПОМЕСТИТЬ ЗаказыНаАвтомобиль
	|ИЗ
	|	ТаблицаЗаказов КАК ТаблицаЗаказов
	|ГДЕ
	|	ТаблицаЗаказов.ЭтоЗаказ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТаблицаЗаказов.Документ КАК Документ.РезервированиеАвтомобилей) КАК Документ,
	|	МИНИМУМ(ТаблицаЗаказов.СрокСнятияРезерва) КАК СрокСнятияРезерва
	|ПОМЕСТИТЬ РезервированияАвтомобилей
	|ИЗ
	|	ТаблицаЗаказов КАК ТаблицаЗаказов
	|ГДЕ
	|	НЕ ТаблицаЗаказов.ЭтоЗаказ
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫРАЗИТЬ(ТаблицаЗаказов.Документ КАК Документ.РезервированиеАвтомобилей)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказыНаАвтомобиль.Документ КАК Документ,
	|	ПРЕДСТАВЛЕНИЕ(ЗаказыНаАвтомобиль.Документ) КАК ДокументПредставление,
	|	ЗаказыНаАвтомобиль.СрокСнятияРезерва КАК СрокСнятияРезерва,
	|	ЕСТЬNULL(Пользователи.Ссылка, ЗаказыНаАвтомобиль.Документ.Автор) КАК Пользователь
	|ПОМЕСТИТЬ ИтоговаяТаблица
	|ИЗ
	|	ЗаказыНаАвтомобиль КАК ЗаказыНаАвтомобиль
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
	|		ПО ЗаказыНаАвтомобиль.Документ.Менеджер = Пользователи.Сотрудник
	|			И (НЕ Пользователи.Сотрудник = ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка))
	|			И (Пользователи.ПометкаУдаления = ЛОЖЬ)
	|ГДЕ
	|	ЕСТЬNULL(Пользователи.Ссылка, ЗаказыНаАвтомобиль.Документ.Автор) <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РезервированияАвтомобилей.Документ,
	|	ПРЕДСТАВЛЕНИЕ(РезервированияАвтомобилей.Документ),
	|	РезервированияАвтомобилей.СрокСнятияРезерва,
	|	РезервированияАвтомобилей.Документ.Автор
	|ИЗ
	|	РезервированияАвтомобилей КАК РезервированияАвтомобилей
	|ГДЕ
	|	РезервированияАвтомобилей.Документ.Автор <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИтоговаяТаблица.Документ КАК Документ,
	|	ИтоговаяТаблица.ДокументПредставление КАК ДокументПредставление,
	|	ИтоговаяТаблица.СрокСнятияРезерва КАК СрокСнятияРезерва,
	|	ИтоговаяТаблица.Пользователь КАК Пользователь
	|ИЗ
	|	ИтоговаяТаблица КАК ИтоговаяТаблица");
	Запрос.УстановитьПараметр("ТЗаказов", ПросроченныеРезервы);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	ВремяСобытия = ТекущаяДатаСеанса() + 180;
	Расписание = Новый ХранилищеЗначения(Неопределено, Новый СжатиеДанных(9));
	Набор = РегистрыСведений.НапоминанияПользователя.СоздатьНаборЗаписей();
	Набор.Отбор.Автор.Установить(Пользователи.ТекущийПользователь());
	Набор.Прочитать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.СрокСнятияРезерва <= ТекущаяДата Тогда
			Описание = СтрШаблон(
				НСтр("ru = 'Истек срок снятия резерва <%1>. Необходимо выполнить снятие резерва.'"),
				Выборка.ДокументПредставление);
		Иначе
			Описание = СтрШаблон(
				НСтр("ru = 'Срок резерва <%1> истекает %2.'"),
				Выборка.ДокументПредставление,
				Формат(Выборка.СрокСнятияРезерва, "ДФ=dd.MM.yyyy"));
		КонецЕсли;
		
		Запись = Набор.Добавить();
		Запись.Пользователь = Выборка.Пользователь;
		Запись.Автор = Пользователи.ТекущийПользователь();
		Запись.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ВУказанноеВремя;
		Запись.ВремяСобытия = ВремяСобытия;
		Запись.СрокНапоминания = ВремяСобытия;
		Запись.Описание = Описание;
		Запись.Расписание = Расписание;
		Запись.ПредставлениеИсточника = НСтр("ru = 'Автоматическое снятие резервов по заказам автомобилей.'");
		Запись.Источник = Выборка.Документ;
		
	КонецЦикла;
	
	Попытка
		
		Набор.Записать();
		
	Исключение
		
		ЗаписьЖурналаРегистрации(
			"Оповещение пользователей о просроченных резервах на автомобили",
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли