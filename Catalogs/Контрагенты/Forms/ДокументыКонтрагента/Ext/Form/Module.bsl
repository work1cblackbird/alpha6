﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы "Документы контрагента"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Контрагент = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Контрагент", Неопределено);
	СформироватьТекстЗапросаДокументов(Контрагент);
	
	Список.Параметры.УстановитьЗначениеПараметра ("Значение", Контрагент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Контрагент = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Значение"));
	
	Если Контрагент = Неопределено Или Не ЗначениеЗаполнено(Контрагент.Значение) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Выписки = ОбщегоНазначенияАвтосалонКлиентСервер
		.ВыбратьИзМассиваПоТипу(Строки.ПолучитьКлючи(), Тип("ДокументСсылка.Выписка"));
	
	Если ЗначениеЗаполнено(Выписки) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВыпискаСостав.Ссылка КАК Документ,
		|	СУММА(ВыпискаСостав.СуммаПриход) - СУММА(ВыпискаСостав.СуммаРасход) КАК Сумма
		|ИЗ
		|	Документ.Выписка.Состав КАК ВыпискаСостав
		|ГДЕ
		|	ВыпискаСостав.Ссылка В(&Выписки)
		|	И ВыпискаСостав.Контрагент = &Контрагент
		|
		|СГРУППИРОВАТЬ ПО
		|	ВыпискаСостав.Ссылка");
		Запрос.УстановитьПараметр("Выписки", Выписки);
		Запрос.УстановитьПараметр("Контрагент", Контрагент.Значение);
		РезультатЗапроса = Запрос.Выполнить();
		СуммыПоКлючам = Новый Соответствие;
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				СуммыПоКлючам.Вставить(Выборка.Документ, Выборка.Сумма);
				
			КонецЦикла;
			
		КонецЕсли;
		
		Для Каждого Выписка Из Выписки Цикл
			
			Строка = Строки.Получить(Выписка);
			СуммаДокумента = СуммыПоКлючам.Получить(Выписка);
			
			Если СуммаДокумента = Неопределено Тогда
				
				СуммаДокумента = 0;
				
			КонецЕсли;
			
			ОформлениеПоля = Строка.Оформление.Получить("СуммаДокумента").Элементы.Найти("Text");
			ОформлениеПоля.Значение = Формат(СуммаДокумента, "ЧДЦ=2");
			ОформлениеПоля = Строка.Оформление.Получить("СуммаДокумента").Элементы.Найти("TextColor");
			
			Если СуммаДокумента > 0 Тогда
				
				ОформлениеПоля.Значение = ЦветаСтиля.ДосьеХорошаяОценкаЦвет;
				
			ИначеЕсли СуммаДокумента < 0 Тогда
				
				ОформлениеПоля.Значение = ЦветаСтиля.ДосьеПлохаяОценкаЦвет;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ИсторическиеДанные = ОбщегоНазначенияАвтосалонКлиентСервер
		.ВыбратьИзМассиваПоТипу(Строки.ПолучитьКлючи(), Тип("ДокументСсылка.ПереносИстории"));
		
	Если ЗначениеЗаполнено(ИсторическиеДанные) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПредставлениеСсылки(ПереносИстории.ВидДокумента) КАК ВидДокумента,
		|	ПереносИстории.Ссылка КАК Документ
		|ИЗ
		|	Документ.ПереносИстории КАК ПереносИстории
		|ГДЕ
		|	ПереносИстории.Ссылка В(&ИсторическиеДанные)
		|	И ПереносИстории.Контрагент = &Контрагент");
		
		
		Запрос.УстановитьПараметр("ИсторическиеДанные", ИсторическиеДанные);
		Запрос.УстановитьПараметр("Контрагент", Контрагент.Значение);
		РезультатЗапроса = Запрос.Выполнить();
		ВидыДокументовПоКлючам = Новый Соответствие;
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				ВидыДокументовПоКлючам.Вставить(Выборка.Документ, Выборка.ВидДокумента);
				
			КонецЦикла;
			
		КонецЕсли;
		
		Для Каждого ИсторическийДокумент Из ИсторическиеДанные Цикл
			
			Строка = Строки.Получить(ИсторическийДокумент);
			ВидДокумента = ВидыДокументовПоКлючам.Получить(ИсторическийДокумент);
			
			Если ВидДокумента = Неопределено Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			ОформлениеПоля = Строка.Оформление.Получить("ХозОперация").Элементы.Найти("Text");
			ОформлениеПоля.Значение = СтрШаблон(НСтр("ru = '%1 (история)'"), ВидДокумента);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ВводыОстатков = ОбщегоНазначенияАвтосалонКлиентСервер
		.ВыбратьИзМассиваПоТипу(Строки.ПолучитьКлючи(), Тип("ДокументСсылка.ВводОстатковВзаиморасчетов"));
		
	Если ЗначениеЗаполнено(ВводыОстатков) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ВводОстатковВзаиморасчетовСостав.Ссылка КАК Документ,
		               |	СУММА(ВводОстатковВзаиморасчетовСостав.СуммаДебет + ВводОстатковВзаиморасчетовСостав.СуммаКредит) КАК СуммаПоКонтрагенту
		               |ИЗ
		               |	Документ.ВводОстатковВзаиморасчетов.Состав КАК ВводОстатковВзаиморасчетовСостав
		               |ГДЕ
		               |	ВводОстатковВзаиморасчетовСостав.Ссылка В(&ВводыОстатков)
		               |	И ВводОстатковВзаиморасчетовСостав.Контрагент = &Контрагент
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	ВводОстатковВзаиморасчетовСостав.Ссылка";
		Запрос.УстановитьПараметр("Контрагент", Контрагент.Значение);
		Запрос.УстановитьПараметр("ВводыОстатков", ВводыОстатков);
		Результат = Запрос.Выполнить();
		СуммыПоКлючам = Новый Соответствие;
		
		Если НЕ Результат.Пустой() Тогда
			
			Выборка = Результат.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				СуммыПоКлючам.Вставить(Выборка.Документ, Выборка.СуммаПоКонтрагенту);
				
			КонецЦикла;
			
		КонецЕсли;
		
		Для Каждого ВводОстатков Из ВводыОстатков Цикл
			Строка = Строки.Получить(ВводОстатков);
			СуммаКонтрагента = СуммыПоКлючам[ВводОстатков];
			
			Если СуммаКонтрагента = Неопределено Тогда
				
				СуммаКонтрагента = 0;
				
			КонецЕсли;
			
			ОформлениеПоля = Строка.Оформление.Получить("СуммаДокумента").Элементы.Найти("Text");
			ОформлениеПоля.Значение = Формат(СуммаКонтрагента, "ЧДЦ=2");
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьТекстЗапросаДокументов(Контрагент)
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		// Для полноправного пользователя менять запрос не будем.
		
		ТекстЗапроса =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Документы.Ссылка КАК Ссылка,
			|	Документы.Ссылка.Номер КАК Номер,
			|	Документы.Ссылка.Дата КАК Дата,
			|	Документы.Ссылка.ВалютаДокумента КАК ВалютаДокумента,
			|	Документы.Ссылка.СуммаДокумента КАК СуммаДокумента,
			|	Документы.Ссылка.Организация КАК Организация,
			|	Документы.Ссылка.ПодразделениеКомпании КАК ПодразделениеКомпании,
			|	Документы.Ссылка.ХозОперация КАК ХозОперация
			|ПОМЕСТИТЬ втИтог
			|ИЗ
			|	(ВЫБРАТЬ
			|		ЗаказНаряд.Ссылка КАК Ссылка
			|	ИЗ
			|		Документ.ЗаказНаряд КАК ЗаказНаряд
			|	ГДЕ
			|		(ЗаказНаряд.Контрагент = &Значение
			|				ИЛИ ЗаказНаряд.СводныйРемонтныйЗаказ.Заказчик = &Значение)
			|	
			|	ОБЪЕДИНИТЬ
			|	
			|	ВЫБРАТЬ
			|		Контрагенты.Ссылка
			|	ИЗ
			|		КритерийОтбора.Контрагенты(&Значение) КАК Контрагенты) КАК Документы
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	втИтог.Ссылка КАК Ссылка,
			|	втИтог.Номер КАК Номер,
			|	втИтог.Дата КАК Дата,
			|	втИтог.ВалютаДокумента КАК ВалютаДокумента,
			|	втИтог.СуммаДокумента КАК СуммаДокумента,
			|	втИтог.Организация КАК Организация,
			|	втИтог.ПодразделениеКомпании КАК ПодразделениеКомпании,
			|	втИтог.ХозОперация КАК ХозОперация
			|ИЗ
			|	втИтог КАК втИтог";
		Список.ТекстЗапроса = ТекстЗапроса;
		Возврат;
		
	КонецЕсли;
	
	ТекстЗапроса = "";
	ЭтоПервыйЗапрос = Истина;
	
	Для Каждого ЭлементСостава Из Метаданные.КритерииОтбора.Контрагенты.Состав Цикл
		
		ПутьКДанным = ЭлементСостава.ПолноеИмя();
		СтруктураПутьКДанным = РазобратьПутьКОбъектуМетаданных(ПутьКДанным);
		
		Если СтруктураПутьКДанным = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ПравоДоступа("Просмотр", СтруктураПутьКДанным.Метаданные) Тогда
			Продолжить;
		КонецЕсли;
		
		ЭтоЗаказНаряд = СтруктураПутьКДанным.ВидОбъекта = "ЗаказНаряд";
		
		ИмяОбъекта = СтруктураПутьКДанным.ТипОбъекта + "." + СтруктураПутьКДанным.ВидОбъекта;
		ЕстьСуммаДокумента = ЕстьРеквизит(СтруктураПутьКДанным.Метаданные, "СуммаДокумента");
		ЕстьВалютаДокумента = ЕстьРеквизит(СтруктураПутьКДанным.Метаданные, "ВалютаДокумента");
		
		ТекущаяСтрокаГДЕ = "ГДЕ Документ" + СтруктураПутьКДанным.ВидОбъекта + "." + СтруктураПутьКДанным.ИмяРеквизита
			+ " = &Значение";
			
		ИмяРеквизита = Лев(СтруктураПутьКДанным.ИмяРеквизита, СтрНайти(СтруктураПутьКДанным.ИмяРеквизита, ".") - 1);
		ТекстЗапроса = ТекстЗапроса + ?(ЭтоПервыйЗапрос, "ВЫБРАТЬ РАЗРЕШЕННЫЕ", "ОБЪЕДИНИТЬ
		|ВЫБРАТЬ") + "
		|Документ" + СтруктураПутьКДанным.ВидОбъекта +".Ссылка,
		|Документ" + СтруктураПутьКДанным.ВидОбъекта +".Ссылка.Номер КАК Номер,
		|Документ" + СтруктураПутьКДанным.ВидОбъекта +".Ссылка.Дата КАК Дата,
		|" + ?(ЕстьВалютаДокумента,
			"Документ" + СтруктураПутьКДанным.ВидОбъекта +".Ссылка.ВалютаДокумента",
			"ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)") + " КАК ВалютаДокумента,
		|" + ?(ЕстьСуммаДокумента,
			"Документ" + СтруктураПутьКДанным.ВидОбъекта +".Ссылка.СуммаДокумента",
			"0") + " КАК СуммаДокумента,
		|Документ" + СтруктураПутьКДанным.ВидОбъекта +".Ссылка.Организация КАК Организация,
		|Документ" + СтруктураПутьКДанным.ВидОбъекта +".Ссылка.ПодразделениеКомпании КАК ПодразделениеКомпании,
		|Документ" + СтруктураПутьКДанным.ВидОбъекта +".Ссылка.ХозОперация КАК ХозОперация "
		+ ?(ЭтоПервыйЗапрос, "ПОМЕСТИТЬ втИтог", "") + "
		|ИЗ " + ИмяОбъекта + ?(ПустаяСтрока(СтруктураПутьКДанным.ИмяТаблЧасти), "", "." + СтруктураПутьКДанным.ИмяТаблЧасти)
		+ " КАК Документ" + СтруктураПутьКДанным.ВидОбъекта + "
		|" + СтрЗаменить(ТекущаяСтрокаГДЕ, "..", ".")
		+ ?(ЭтоЗаказНаряд, "
		|ИЛИ ДокументЗаказНаряд.СводныйРемонтныйЗаказ.Заказчик = &Значение", "") + "
		|";
		ЭтоПервыйЗапрос = Ложь;
		
	КонецЦикла;
	
	Если ТекстЗапроса <> "" Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втИтог.Ссылка КАК Ссылка,
		|	ВЫРАЗИТЬ(втИтог.Номер КАК СТРОКА(100)) КАК Номер,
		|	втИтог.Дата КАК Дата,
		|	втИтог.ВалютаДокумента КАК ВалютаДокумента,
		|	ВЫРАЗИТЬ(втИтог.СуммаДокумента КАК ЧИСЛО(15,2)) КАК СуммаДокумента,
		|	втИтог.Организация КАК Организация,
		|	втИтог.ПодразделениеКомпании КАК ПодразделениеКомпании,
		|	втИтог.ХозОперация КАК ХозОперация
		|ИЗ
		|	втИтог КАК втИтог";
		Список.ТекстЗапроса = ТекстЗапроса;
		
	КонецЕсли;
	
КонецПроцедуры // СформироватьТекстЗапросаДокументов()

Функция РазобратьПутьКОбъектуМетаданных(ПутьКДанным) Экспорт
	
	Структура = Новый Структура;
	
	СоответствиеИмен = Новый Массив();
	СоответствиеИмен.Добавить("ТипОбъекта");
	СоответствиеИмен.Добавить("ВидОбъекта");
	СоответствиеИмен.Добавить("ПутьКДанным");
	СоответствиеИмен.Добавить("ИмяТаблЧасти");
	СоответствиеИмен.Добавить("ИмяРеквизита");
	
	Для индекс = 1 По 3 Цикл
		
		Точка = СтрНайти(ПутьКДанным, ".");
		ТекущееЗначение = Лев(ПутьКДанным, Точка-1);
		Структура.Вставить(СоответствиеИмен[индекс-1], ТекущееЗначение);
		ПутьКДанным = Сред(ПутьКДанным, Точка+1);
		
	КонецЦикла;
	
	ПутьКДанным = СтрЗаменить(ПутьКДанным, "Реквизит.", "");
	
	Если Структура.ПутьКДанным = "ТабличнаяЧасть" Тогда
		
		Для индекс = 4 По 5  Цикл 
			
			Точка = СтрНайти(ПутьКДанным, ".");
			Если Точка = 0 Тогда
				ТекущееЗначение = ПутьКДанным;
			Иначе
				ТекущееЗначение = Лев(ПутьКДанным, Точка-1);
			КонецЕсли;
			
			Структура.Вставить(СоответствиеИмен[индекс-1], ТекущееЗначение);
			ПутьКДанным = Сред(ПутьКДанным,  Точка+1);
			
		КонецЦикла;
		
	Иначе
		
		Структура.Вставить(СоответствиеИмен[3], "");
		Структура.Вставить(СоответствиеИмен[4], ПутьКДанным);
		
	КонецЕсли;
	
	Если Структура.ТипОбъекта = "Документ" Тогда
		Структура.Вставить("Метаданные", Метаданные.Документы[Структура.ВидОбъекта]);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Структура;
	
КонецФункции // РазобратьПутьКОбъектуМетаданных()

#КонецОбласти
