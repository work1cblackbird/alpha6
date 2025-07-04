﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Заполним таблицу
	ЗаполнитьПлатежноРасчетныеДокументы(Параметры.ПлатежноРасчетныеДокументы);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "Договор,Основание");
	
	Если Параметры.ТолькоПросмотр Тогда
		Элементы.ФормаПеренестиВДокумент.Видимость = Ложь;
		Элементы.ПлатежноРасчетныеДокументы.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Если ЗавершениеРаботы Тогда
		ТекстПредупреждения = НСтр("ru = 'Данные не перенесены в счет-фактуру.'");
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Данные не перенесены в счет-фактуру. Перенести?'");
	Обработчик = Новый ОписаниеОповещения("Подключаемый_ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Обработчик, ТекстВопроса,  РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Если ЗаполнениеКорректно() Тогда
		Модифицированность = Ложь;
		Закрыть(ПлатежноРасчетныеДокументы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если ПлатежноРасчетныеДокументы.Количество() = 0 Тогда
		ЗаполнитьНаСервере();
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("Подключаемый_ВопросОбОчисткеЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Обработчик, НСтр("ru = 'Табличная часть будет очищена, продолжить?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Модифицированность = Истина;
	ТипЗнчОснования = ТипЗнч(Основание);
	Если ТипЗнчОснования = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") Тогда
		
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, "Номер,Дата");
		РеквизитыДокумента.Номер = СформироватьНомер(РеквизитыДокумента.Номер, "ПКО ");
		ЗаполнитьЗначенияСвойств(ПлатежноРасчетныеДокументы.Добавить(), РеквизитыДокумента);
		
	ИначеЕсли ТипЗнчОснования = Тип("ДокументСсылка.ЧекНаОплату") Тогда
		
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, "Номер,Дата");
		РеквизитыДокумента.Номер = СформироватьНомер(РеквизитыДокумента.Номер, "Чек ");
		ЗаполнитьЗначенияСвойств(ПлатежноРасчетныеДокументы.Добавить(), РеквизитыДокумента);
		
	ИначеЕсли ТипЗнчОснования = Тип("ДокументСсылка.Выписка") Тогда
		
		// выберем строку для заполнения
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ВыпискаСостав.ВхДокНомер КАК Номер,
		|	ВыпискаСостав.ВхДокДата КАК Дата,
		|	ВыпискаСостав.Ссылка.Номер КАК НомерДополнительный,
		|	ВыпискаСостав.Ссылка.Дата КАК ДатаДополнительная
		|ИЗ
		|	Документ.Выписка.Состав КАК ВыпискаСостав
		|ГДЕ
		|	ВыпискаСостав.Ссылка = &Основание
		|	И ВыпискаСостав.СтатьяДДС = ЗНАЧЕНИЕ(Справочник.СтатьиДДС.ПредоплатаОтПокупателя)
		|	И ВыпискаСостав.СуммаПриход > 0";
		
		Запрос.УстановитьПараметр("Основание", Основание);
		ПлатежноРасчетныеДокументы.Очистить();
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			
			Если НЕ ПустаяСтрока(Выборка.Номер) Тогда
				
				НоваяСтрока = ПлатежноРасчетныеДокументы.Добавить();
				НоваяСтрока.Номер = "Платежное поручение " + Выборка.Номер; 	
				НоваяСтрока.Дата = Выборка.Дата;
				
			Иначе
				НоваяСтрока = ПлатежноРасчетныеДокументы.Добавить();
				НоваяСтрока.Номер = СформироватьНомер(Выборка.НомерДополнительный, "Выписка ");; 	
				НоваяСтрока.Дата = Выборка.ДатаДополнительная;
				
			КонецЕсли;
		КонецЕсли;
			
	Иначе
			
		ПлатежноРасчетныеДокументы.Загрузить(
			ПлатежноРасчетныеДокументыСервер.ПолучитьПлатежноРасчетныеДокументы(Основание, Договор));
			
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция СформироватьНомер(НомерИсходный, Префикс)
	
	СокращенныйНомер = НЕ Константы.ПолныйНомерДокументаВПечатныхФормах.Получить();
	
	Если СокращенныйНомер Тогда
		Номер = СокрЛП(НомерИсходный);
			
		Номер =   Префикс + ПрефиксацияОбъектов.ПолучитьНомерНаПечать( Номер,Истина,Истина,Истина);
	Иначе
		Номер = Префикс + НомерИсходный;	
	КонецЕсли;	
	
	Возврат Номер;
	
КонецФункции

&НаКлиенте
Функция ЗаполнениеКорректно()
	
	ВсеОК = Истина;
	
	Если ПлатежноРасчетныеДокументы.Количество() = 0 Тогда
		Возврат ВсеОК;
	КонецЕсли;
	
	Для Индекс = 1 По ПлатежноРасчетныеДокументы.Количество() Цикл
		
		Строка = ПлатежноРасчетныеДокументы[Индекс - 1];
		Если ПустаяСтрока(Строка.Номер) Тогда
			ВсеОК = Ложь;
			ПутьКТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПлатежноРасчетныеДокументы", Индекс, "Номер");
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Не заполнен номер платежного поручения в строке №%1.'"),
					Индекс
				),
				,
				ПутьКТабличнойЧасти,
				"Объект"
			);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Строка.Дата) Тогда
			ВсеОК = Ложь;
			
			ПутьКТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПлатежноРасчетныеДокументы", Индекс, "Дата");
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Не заполнена дата платежного поручения в строке №%1.'"),
					Индекс
				),
				,
				ПутьКТабличнойЧасти,
				"Объект"
			);

		КонецЕсли;
	КонецЦикла;
	
	Возврат ВсеОК;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПлатежноРасчетныеДокументы(Значение)
	
	Для Каждого Строка Из Значение Цикл
		ЗаполнитьЗначенияСвойств(ПлатежноРасчетныеДокументы.Добавить(), Строка);
	КонецЦикла;
	
КонецПроцедуры

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  Ответ     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура Подключаемый_ВопросПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		Закрыть();
		Возврат;
	КонецЕсли;
	
	ПеренестиВДокумент(Неопределено);
	
КонецПроцедуры

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  Ответ     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура Подключаемый_ВопросОбОчисткеЗавершение(Ответ, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПлатежноРасчетныеДокументы.Очистить();
		ЗаполнитьНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

