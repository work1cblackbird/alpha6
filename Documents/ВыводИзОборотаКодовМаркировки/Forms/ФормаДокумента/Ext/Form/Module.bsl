﻿///////////////////////////////////////////////////////////////////////////////
// Модуль основной формы документа "Вывод из оборота кодов маркировки".
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	Отказ = Отказ Или РаботаСФормой.НужноОтменитьОткрытиеФормы();
	
	Если Отказ Тогда
		
		Возврат;
		
	КонецЕсли;
	
	// ПодключаемоеОборудование
	ТипыОборудования = МенеджерОборудованияКлиентСервер.ПараметрыТипыОборудования();
	ТипыОборудования.СканерШтрихкода = Истина;
	ТипыОборудования.СчитывательМагнитныхКарт = Истина;
	МенеджерОборудования.ПриСозданииНаСервере(ЭтаФорма, ТипыОборудования);
	// Конец ПодключаемоеОборудование
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	РаботаСФормой.ИнициализироватьМенюВыбораХозОперации(ЭтотОбъект);
	РаботаСФормой.РасставитьСвязиПараметровВыбораПоОрганизации(ЭтотОбъект, Объект);
	РаботаСФормой.ЗаблокироватьРедактированиеНомераИДатыДокумента(ЭтотОбъект, Объект);
	
	РазрешитьРедактированиеЦенИСумм = ПраваИНастройкиПользователя.Значение("РедактированиеЦенИСуммВНоменклатурныхТаблицах", Объект);
	РаботаСФормой.РазрешитьРедактированиеЦенИСумм(
		РаботаСФормой.ТиповыеПоляСуммовыхРеквизитов(ЭтотОбъект),
		РазрешитьРедактированиеЦенИСумм
	);
	РаботаСФормой.ОткрытьФормуТолькоДляПросмотра(ЭтотОбъект, Объект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		РаботаСФормой.ЗаполнитьСлужебныеРеквизитыТоваров(Объект.Товары);
		РаботаСФормой.УстановитьВидимостьКолонкиХарактеристика(ЭтотОбъект, Объект);
		
		// Маркировка
		МаркировкаТоваровСервер.ПриСозданииЧтенииНаСервере(ЭтотОбъект, Объект);
		МаркировкаТоваровСервер.ИнициализироватьСлужебныеРеквизиты(ЭтотОбъект);
		// Конец Маркировка
		
		ЗаполнитьАдресМестаВыбытия();
		ЗаполнитьСтатусИИдентификаторДокумента();
		НастроитьПараметрыВыбораЭлементовФормы();
		УправлениеДиалогомНаСервере();
		
	КонецЕсли;
	
	ПараметрыДокумента = ОбщиеПараметрыДокументов.СформироватьПредставлениеПараметровДокумента(Объект);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
	УправлениеДиалогомАльфаАвтоКлиент.ПриОткрытии(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораНаСервере(ВыбранноеЗначение, ПараметрыДействия = Неопределено)
	
	Если НЕ УправлениеДиалогомДокументаСервер.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, ПараметрыДействия) Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ПараметрыДействия = Новый Структура;
	ОбработкаВыбораНаСервере(ВыбранноеЗначение, ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Штрихкодирование
	ШтрихкодированиеКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец Штрихкодирование
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	РаботаСФормой.ЗаполнитьСлужебныеРеквизитыТоваров(Объект.Товары);
	РаботаСФормой.УстановитьВидимостьКолонкиХарактеристика(ЭтотОбъект, Объект);
	
	// Маркировка
	МаркировкаТоваровСервер.ПриСозданииЧтенииНаСервере(ЭтотОбъект, Объект);
	МаркировкаТоваровСервер.ИнициализироватьСлужебныеРеквизиты(ЭтотОбъект);
	// Конец Маркировка
	
	ЗаполнитьАдресМестаВыбытия();
	УправлениеДиалогомАльфаАвтоСервер.ПриЧтенииНаСервере(ЭтотОбъект);
	ЗаполнитьСтатусИИдентификаторДокумента();
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	РаботаСФормойКлиент.ЗамерВремениЗапись("ВыводИзОборотаКодовМаркировки", ПараметрыЗаписи.РежимЗаписи,
		Объект.Товары.Количество() > 50);
		
	Отказ = Отказ Или РаботаСФормойКлиент.НачатьПроверкуПодразделенияДокументаИПользователя(
		Объект.ПодразделениеКомпании,
		Новый ОписаниеОповещения(
			"ПроверкаПодразделенияДокументаИПользователяЗавершение",
			ЭтотОбъект,
			Новый Структура("ПараметрыЗаписи", ПараметрыЗаписи)
		)
	);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ИдентификаторДокумента", ИдентификаторДокумента);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Статус", Статус);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ОписаниеОшибки", ОписаниеОшибки);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	РаботаСФормой.ЗаполнитьСлужебныеРеквизитыТоваров(Объект.Товары);
	
	// Маркировка
	МаркировкаТоваровСервер.ЗаполнитьСлужебныйРеквизитКодыМаркировки(Объект);
	МаркировкаТоваровСервер.ИнициализироватьСлужебныеРеквизиты(ЭтотОбъект);
	// Конец Маркировка
	
	РаботаСФормой.УстановитьВидимостьКолонкиХарактеристика(ЭтотОбъект, Объект);
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	РаботаСФормойКлиент.ОповеститьОЗаписиДокумента(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Настройки.Вставить("ПоказыватьПараметрыДокумента", Элементы.ПараметрыДокумента.Видимость);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки.Получить("ПоказыватьПараметрыДокумента") = Ложь Тогда
		Элементы.ПараметрыДокумента.Видимость = Ложь;
		Элементы.НомерДата         .Видимость = Ложь;
	КонецЕсли;
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ДатаПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ВыводИзОборотаКодовМаркировки.ДатаПриИзменении(Объект, ПараметрыДействия);
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ХозОперацияПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ВыводИзОборотаКодовМаркировки.ХозОперацияПриИзменении(Объект, ПараметрыДействия);
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ХозОперацияПриИзменении(Команда)
	
	УправлениеДиалогомДокументаКлиент.ОбработатьВыборХозОперации(Объект, Элементы, Команда.Имя);
	ПараметрыДействия = Новый Структура;
	ХозОперацияПриИзмененииНаСервере(ПараметрыДействия);	
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры

&НаСервере
Процедура СтатусПриИзмененииНаСервере()
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)

	Модифицированность = Истина;
	СтатусПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусРасширеннаяПодсказкаНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Ошибка при отправке запроса'"));
	ПараметрыФормы.Вставить("Сообщение", ОписаниеОшибки);
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормаСообщенияПользователю",
		ПараметрыФормы,
		ЭтотОбъект,
		, , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);
	
КонецПроцедуры

&НаСервере
Процедура ДокументОснованиеПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ВыводИзОборотаКодовМаркировки.ДокументОснованиеПриИзменении(Объект, ПараметрыДействия);
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ДокументОснованиеПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры

&НаСервере
Процедура ПричинаВыводаПриИзмененииНаСервере()
	
	НастроитьПараметрыВыбораВидаПервичногоДокумента();
	
	Документы.ВыводИзОборотаКодовМаркировки.ПричинаВыводаПриИзменении(Объект);
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПричинаВыводаПриИзменении(Элемент)
	
	ПричинаВыводаПриИзмененииНаСервере();
	
	Если Элементы.ВидПервичногоДокумента.СписокВыбора.Количество() = 1 Тогда
		Объект.ВидПервичногоДокумента = Элементы.ВидПервичногоДокумента.СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ТоварнаяГруппаПриИзмененииНаСервере()
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварнаяГруппаПриИзменении(Элемент)
	
	ТоварнаяГруппаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресМестаВыбытияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВидКонтактнойИнформации = Новый Структура();
	ВидКонтактнойИнформации.Вставить("ТолькоНациональныйАдрес", Истина);
	ВидКонтактнойИнформации.Вставить("ВключатьСтрануВПредставление", Ложь);
	ВидКонтактнойИнформации.Вставить("Используется", Истина);
	ВидКонтактнойИнформации.Вставить("МожноИзменятьСпособРедактирования", Ложь);
	ВидКонтактнойИнформации.Вставить("ОбязательноеЗаполнение", Ложь);
	ВидКонтактнойИнформации.Вставить("ПроверятьКорректность", Истина);
	ВидКонтактнойИнформации.Вставить("ПроверятьПоФИАС", Истина);
	ВидКонтактнойИнформации.Вставить("РазрешитьВводНесколькихЗначений", Ложь);
	ВидКонтактнойИнформации.Вставить("РедактированиеТолькоВДиалоге", Истина);
	ВидКонтактнойИнформации.Вставить("Тип", ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес"));
	ВидКонтактнойИнформации.Вставить("ХранитьИсториюИзменений", Ложь);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВидКонтактнойИнформации", ВидКонтактнойИнформации);
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Адрес места выбытия'"));
	Если НЕ СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(АдресМестаВыбытияПредставление) Тогда
		ПараметрыФормы.Вставить("ЗначенияПолей", Объект.АдресМестаВыбытия);
		ПараметрыФормы.Вставить("Представление", АдресМестаВыбытияПредставление);
	КонецЕсли;
	ПараметрыФормы.Вставить("ОткрытаПоСценарию");
	
	ОбработчикОповещения = Новый ОписаниеОповещения("Подключаемый_ВыборАдреса", ЭтотОбъект);
	
	ОткрытьФорму(
		"Обработка.РасширенныйВводКонтактнойИнформации.Форма.ВводАдреса",
		ПараметрыФормы,
		ЭтотОбъект,,,,
		ОбработчикОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресМестаВыбытияОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.АдресМестаВыбытия = "";
	
КонецПроцедуры

&НаКлиенте
Процедура АдресМестаВыбытияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если НЕ СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(, НСтр("ru = 'Введенный ФИАС ID не соответствует требуемому формату.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресМестаВыбытияПриИзменении(Элемент)
	
	Если СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(АдресМестаВыбытияПредставление)
		ИЛИ ПустаяСтрока(АдресМестаВыбытияПредставление) Тогда
		Объект.АдресМестаВыбытия = АдресМестаВыбытияПредставление;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// Маркировка
	МаркировкаТоваровКлиент.ОткрытьСписокКодовМаркировки(
		ЭтотОбъект,
		ВыбраннаяСтрока,
		Поле,
		СтандартнаяОбработка
	);
	// Конец Маркировка
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УправлениеДиалогомДокументаКлиент.ТоварыПриОкончанииРедактирования(
		ЭтотОбъект,
		Элемент,
		НоваяСтрока,
		ОтменаРедактирования,
		, ,
		""
	);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыПослеУдаленияНаСервере(ПараметрыДействия = Неопределено)
	
	УправлениеДиалогомДокументаСервер.ТоварыПослеУдаления(ЭтотОбъект, Элементы.Товары, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	ТоварыПослеУдаленияНаСервере();
	
КонецПроцедуры


#Область ОбработчикиСобытийПолейТаблицыФормыТовары

&НаСервере
Процедура ТоварыНоменклатураПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Номенклатура)
		И НЕ ТекущиеДанные.Номенклатура.ТипНоменклатуры.ВедетсяМаркировка Тогда
		
		ПутьКТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары",ТекущиеДанные.НомерСтроки, "Номенклатура");
		ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'В таблицу нельзя вводить номенклатуру по которой не ведется учет по маркировке'"),
				,
				ПутьКТабличнойЧасти,
				"Объект"
		);

		ТекущиеДанные.Номенклатура = Неопределено;
	КонецЕсли;
	
	Документы.ВыводИзОборотаКодовМаркировки.ТоварыНоменклатураПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	УправлениеДиалогомДокументаСервер.НоменклатураПриИзменении(ЭтотОбъект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТоварыНоменклатураПриИзмененииНаСервере();
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		// Маркировка
		МаркировкаТоваровКлиент.НачатьСканированиеМаркировки(Объект, ТекущиеДанные, ЭтотОбъект);
		// Конец Маркировка
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ТоварыХарактеристикаНоменклатурыПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	Документы
	.ВыводИзОборотаКодовМаркировки
	.ТоварыХарактеристикаНоменклатурыПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНоменклатурыПриИзменении(Элемент)
	
	ТоварыХарактеристикаНоменклатурыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ТоварыКоличествоПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	
	Документы.ВыводИзОборотаКодовМаркировки.ТоварыКоличествоПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ТоварыКоличествоПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ТоварыЦенаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	Документы.ВыводИзОборотаКодовМаркировки.ТоварыЦенаПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	ТоварыЦенаПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выгрузить(Команда)
	
	ИмяДействия = "ОтправкаЗапросаВыводаИзОборотаКодовМаркировки";
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Действие", ИмяДействия);
	ДополнительныеПараметры.Вставить("Документ", Объект.Ссылка);
	ДополнительныеПараметры.Вставить("Организация", Объект.Организация);
	ДополнительныеПараметры.Вставить("ОбработкаРезультата",
		Новый ОписаниеОповещения("ПолучитьЗапросЗавершение", ЭтотОбъект, ИмяДействия));
	
	МаркировкаТоваровКлиент.ОтправитьПолучитьДокумент(
		ЭтотОбъект,
		Объект,
		ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатус(Команда)
	
	ТекущийСтатус = Статус;
	ЗаполнитьСтатусИИдентификаторДокумента();
	Если Статус = ТекущийСтатус Тогда
		МаркировкаТоваровКлиент.ОбновитьСтатусДокумента(ЭтотОбъект, Объект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПолучитьЗапросЗавершение(РезультатОбмена, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьСтатусИИдентификаторДокумента();
	
КонецПроцедуры

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	
	УправлениеДиалогомДокументаСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
	СписокВыбора = Элементы.Статус.СписокВыбора;
	СписокВыбора.ЗагрузитьЗначения(МаркировкаТоваровСервер.РазрешенныеСтатусыДокументовМаркировки(Объект.Ссылка));
	
	СписокВыбораПричин = Элементы.ПричинаВывода.СписокВыбора;
	СписокВыбораПричин.Очистить();
	СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.Другое);
	СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.ДляСобственныхНужд);
	СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.Конфискация);
	СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.ПродажаПоГосКонтракту);
	СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.ПродажаПоСделкеСГосТайной);
	СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.РозничнаяПродажа);
	СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.ЭкспортЕАЭС);
	СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.Уничтожение);
	СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.Утилизация);
	СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.УтратаПовреждение);
	СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.Экспорт);
	
	ТабачнаяПродукция = МаркировкаТоваровКлиентСервер.ТоварныеГруппыТабачнойПродукции();
	ТоварнаяГруппа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ТоварнаяГруппа, "ТоварнаяГруппа");
	Если ТабачнаяПродукция.Найти(Объект.ТоварнаяГруппа.ТоварнаяГруппа) <> Неопределено Тогда
		СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.ОтзывТоваровСРынка);
	Иначе
		ЭтоУпакованнаяВода = МаркировкаТоваровКлиентСервер.ЭтоТоварнаяГруппаУпакованнойВоды(ТоварнаяГруппа);
		ЭтоМолочнаяПродукция = МаркировкаТоваровКлиентСервер.ЭтоТоварнаяГруппаМолочнаяПродукция(ТоварнаяГруппа);
		СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.БезвозмезднаяПередача);
		Если ЭтоУпакованнаяВода ИЛИ ЭтоМолочнаяПродукция Тогда
			СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.ПродажаЧерезВендинговыйАппарат);
			СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.ИстечениеСрокаГодности);
			СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.ИспользованиеДляПроизводственныхЦелей);
			Если ЭтоМолочнаяПродукция Тогда
				СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.Фасовка);
			КонецЕсли;
		Иначе
			СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.Возврат);
		КонецЕсли;
		СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.ДистанционнаяПродажа);
		СписокВыбораПричин.Добавить(Перечисления.ПричиныВыводаИзОборота.ПродажаПоОбразцам);
	КонецЕсли;
	
	СписокВыбораПричин.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	
	НастроитьПараметрыВыбораВидаПервичногоДокумента();
	
	СписокВыбора = Элементы.ТоварнаяГруппа.СписокВыбора;
	СписокВыбора.ЗагрузитьЗначения(МаркировкаТоваровСервер.СписокТоварныхГрупп(Объект.Ссылка));
	
	МаркировкаТоваровСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	УправлениеДиалогомДокументаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
	Элементы.Статус.ОтображениеПодсказки = ?(
		ЗначениеЗаполнено(ОписаниеОшибки),
		ОтображениеПодсказки.ОтображатьСправа,
		ОтображениеПодсказки.Нет
	);
	
	ЧерезAPI =
		ЭтотОбъект.РежимОбменаСЧестнымЗнаком = ПредопределенноеЗначение("Перечисление.СпособыОбменаСЧестнымЗнаком.ЧерезAPI");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ИдентификаторДокумента",
		"Видимость",
		ЧерезAPI
	);
	
	Если ЧерезAPI Тогда
		ЭтотОбъект.ТолькоПросмотр = Статус = Перечисления.СтатусыДокументовМаркировки.ОжидаетОбработки;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОбновитьСтатус",
		"Видимость",
		ЧерезAPI
	);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Статус",
		"ТолькоПросмотр",
		ЭтотОбъект.ТолькоПросмотр
	);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Контрагент",
		"Видимость",
		Документы.ВыводИзОборотаКодовМаркировки.ЗаполнятьКонтрагента(Объект.ПричинаВывода)
	);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОписаниеПричины",
		"Видимость",
		Документы.ВыводИзОборотаКодовМаркировки.УказыватьОписаниеПричиныВывода(Объект.ПричинаВывода)
	);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Импортер",
		"Видимость",
		Документы.ВыводИзОборотаКодовМаркировки.ЗаполнятьИмпортера(Объект.ПричинаВывода)
	);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ИдентификаторГосударственногоКонтракта",
		"Видимость",
		Документы.ВыводИзОборотаКодовМаркировки.ВыводитьИдентификаторГосКонтракта(Объект.ПричинаВывода)
	);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"АдресМестаВыбытия",
		"Видимость",
		Документы.ВыводИзОборотаКодовМаркировки.ВыводитьАдресМестаВыбития(Объект.ПричинаВывода)
	);
	
	ЗаполнятьПервичныйДокумент = НЕ Документы.ВыводИзОборотаКодовМаркировки.НеПередаватьПервичныйДокумент(
		Объект.ПричинаВывода); 
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВидПервичногоДокумента",
		"Видимость",
		ЗаполнятьПервичныйДокумент
	);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"НаименованиеПервичногоДокумента",
		"Видимость",
		ЗаполнятьПервичныйДокумент
	);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДатаПервичногоДокумента",
		"Видимость",
		ЗаполнятьПервичныйДокумент
	);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"НомерПервичногоДокумента",
		"Видимость",
		ЗаполнятьПервичныйДокумент
	);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ТоварыВидПервичногоДокумента",
		"Видимость",
		ЗаполнятьПервичныйДокумент
	);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ТоварыНаименованиеПервичногоДокумента",
		"Видимость",
		ЗаполнятьПервичныйДокумент
	);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ТоварыДатаПервичногоДокумента",
		"Видимость",
		ЗаполнятьПервичныйДокумент
	);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ТоварыНомерПервичногоДокумента",
		"Видимость",
		ЗаполнятьПервичныйДокумент
	);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ТоварыЦена",
		"Видимость",
		Документы.ВыводИзОборотаКодовМаркировки.ВидимостьЦеныТоваров(Объект.ПричинаВывода)
	);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры = Неопределено)
	
	ПродолжитьВыполнение = УправлениеДиалогомДокументаСервер.ОбработкаРезультатаОповещения(
		ЭтотОбъект,
		РезультатОповещения,
		ДополнительныеПараметры
	);
	Если НЕ ПродолжитьВыполнение Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаОповещения(РезультатОповещения,
		ДополнительныеПараметры = Неопределено) Экспорт
	
	Если НЕ УправлениеДиалогомДокументаКлиент.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры);
	ОбработкаРезультатаВыполненияДействия(РезультатОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаРезультатаВыполненияДействия(ПараметрыДействия)
	
	ОбработкаРеквизитовДокументаКлиент.ПолучитьРазрешенияДляПересчета(ЭтотОбъект, ПараметрыДействия);
	УправлениеДиалогомДокументаКлиент.ОбработкаРезультатаВыполненияДействия(ЭтотОбъект, ПараметрыДействия);
	
КонецПроцедуры

#КонецОбласти

// Маркировка
&НаКлиенте
Процедура Подключаемый_СканированиеМаркировкиЗавершение(КодМаркировки, ДополнительныеПараметры = Неопределено) Экспорт
	
	МаркировкаТоваровКлиент.ДобавитьКодМаркировки(Объект.КодыМаркировки, КодМаркировки, ДополнительныеПараметры);
	
	// Обновим отображение на форме
	Результат = Новый Структура;
	ОбработкаРезультатаОповещенияНаСервере(Результат, "РазрешенияДляПересчета");
	
КонецПроцедуры
// Конец Маркировка

&НаСервере
Функция ВидыДокументовПоПричинеВывода()
	
	ВидыДокументов = Новый Соответствие;
	
	СписокВидовДокументов = Новый Массив;
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.КассовыйЧек);
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.ТоварныйЧек);
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.Прочее);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.РозничнаяПродажа, СписокВидовДокументов);
	
	СписокВидовДокументов = Новый Массив;
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.ТаможеннаяДекларация);
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.Прочее);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.Экспорт, СписокВидовДокументов);
	
	СписокВидовДокументов = Новый Массив;
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.ТоварнаяНакладная);
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.УПД);
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.Прочее);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.Конфискация, СписокВидовДокументов);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.Ликвидация, СписокВидовДокументов);
	
	СписокВидовДокументов = Новый Массив;
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.Прочее);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.Возврат, СписокВидовДокументов);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.Другое, СписокВидовДокументов);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.ДляСобственныхНужд, СписокВидовДокументов);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.УтратаПовреждение, СписокВидовДокументов);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.Утилизация, СписокВидовДокументов);
	
	СписокВидовДокументов = Новый Массив;
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.КассовыйЧек);
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.ТоварныйЧек);
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.УПД);
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.Прочее);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.ДистанционнаяПродажа, СписокВидовДокументов);
	
	СписокВидовДокументов = Новый Массив;
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.АктУничтожения);
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.Прочее);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.Уничтожение, СписокВидовДокументов);
	
	СписокВидовДокументов = Новый Массив;
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.ТоварнаяНакладная);
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.Прочее);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.БезвозмезднаяПередача, СписокВидовДокументов);
	
	СписокВидовДокументов = Новый Массив;
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.КассовыйЧек);
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.ТоварныйЧек);
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.ТоварнаяНакладная);
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.УПД);
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.Прочее);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.ПродажаПоОбразцам, СписокВидовДокументов);
	
	СписокВидовДокументов = Новый Массив;
	СписокВидовДокументов.Добавить(Перечисления.ВидыПервичныхДокументов.Прочее);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.ОтзывТоваровСРынка, СписокВидовДокументов);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.ПродажаЧерезВендинговыйАппарат, СписокВидовДокументов);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.ИстечениеСрокаГодности, СписокВидовДокументов);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.ИспользованиеДляПроизводственныхЦелей, СписокВидовДокументов);
	ВидыДокументов.Вставить(Перечисления.ПричиныВыводаИзОборота.Фасовка, СписокВидовДокументов);
	
	Возврат ВидыДокументов;
	
КонецФункции

&НаСервере
Процедура НастроитьПараметрыВыбораВидаПервичногоДокумента()
	
	Элементы.ВидПервичногоДокумента.СписокВыбора.Очистить();
	Элементы.ТоварыВидПервичногоДокумента.СписокВыбора.Очистить();
	
	ПередаватьПервичныйДокумент = НЕ Документы.ВыводИзОборотаКодовМаркировки.НеПередаватьПервичныйДокумент(
		Объект.ПричинаВывода);
	
	Если НЕ ПередаватьПервичныйДокумент Тогда
		Возврат;
	КонецЕсли;
	
	ВидыДокументовПопричинам = ВидыДокументовПоПричинеВывода();
	СписокВидовДокументов = ВидыДокументовПопричинам.Получить(Объект.ПричинаВывода);
	
	Если СписокВидовДокументов = Неопределено Тогда
		СписокВидовДокументов = Новый Массив;
	КонецЕсли;
	
	Элементы.ВидПервичногоДокумента.СписокВыбора.ЗагрузитьЗначения(СписокВидовДокументов);
	Элементы.ТоварыВидПервичногоДокумента.СписокВыбора.ЗагрузитьЗначения(СписокВидовДокументов);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусИИдентификаторДокумента()
	
	Запись = РегистрыСведений.СтатусыДокументовМаркировки.ПолучитьСтатусДокумента(Объект.Ссылка);
	Статус = Запись.Статус;
	ИдентификаторДокумента = Запись.ИдентификаторДокумента;
	ОписаниеОшибки = Запись.ОписаниеОшибки;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыборАдреса(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Объект.АдресМестаВыбытия = Результат.Значение;
	АдресМестаВыбытияПредставление = Результат.Представление;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАдресМестаВыбытия()
	
	// Заполним адрес места выбытия
	Если ЗначениеЗаполнено(Объект.АдресМестаВыбытия) Тогда
		Если СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(Объект.АдресМестаВыбытия) Тогда
			АдресМестаВыбытияПредставление = Объект.АдресМестаВыбытия;
		ИначеЕсли УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВJSON(Объект.АдресМестаВыбытия) Тогда
			АдресМестаВыбытияПредставление =
				УправлениеКонтактнойИнформациейСлужебный.ПредставлениеКонтактнойИнформации(Объект.АдресМестаВыбытия);
		Иначе
			ЗначениеАдреса = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВJSON(
				Объект.АдресМестаВыбытия, Перечисления.ТипыКонтактнойИнформации.Адрес);
			АдресМестаВыбытияПредставление = УправлениеКонтактнойИнформациейСлужебный.ПредставлениеКонтактнойИнформации(
				ЗначениеАдреса);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УправлениеДиалогомДокументаСервер.УстановитьУсловноеОформление(ЭтотОбъект);
	УправлениеДиалогомДокументаСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	
	// Маркировка
	МаркировкаТоваровСервер.УстановитьУсловноеОформлениеКодыМаркировок(ЭтотОбъект);
	// Конец Маркировка
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура ПроверкаПодразделенияДокументаИПользователяЗавершение(Контекст) Экспорт
	
	УправлениеДиалогомДокументаКлиент.НастроитьПараметрыДокумента(ЭтотОбъект);
	
КонецПроцедуры

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиАльфаАвто

// Ядро
&НаКлиенте
Процедура ПараметрыДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;;
	УправлениеДиалогомДокументаКлиент.НастроитьПараметрыДокумента(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыДокументаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УправлениеДиалогомДокументаКлиент.НастроитьПараметрыДокумента(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийОткрытие(Элемент, СтандартнаяОбработка)
	
	УправлениеДиалогомДокументаКлиент.РасширенноеРедактированиеПоляКомментарий(ЭтотОбъект, Элемент,
		СтандартнаяОбработка);
	
КонецПроцедуры
// Конец Ядро

#КонецОбласти

#Область ПараметрыДокумента

&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаЗакрытияПараметровДокумента(РезультатОповещения, ДополнительныеПараметры = Неопределено) Экспорт
	                                                                                                                
	ОбработкаРезультатаЗакрытияПараметровДокументаНаСервере(РезультатОповещения, ДополнительныеПараметры);
	ОбработкаРеквизитовДокументаКлиент.ПолучитьРазрешенияДляПересчета(ЭтотОбъект, РезультатОповещения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаРезультатаЗакрытияПараметровДокументаНаСервере(РезультатОповещения, ДополнительныеПараметры)
	
	ОбщиеПараметрыДокументов.ПараметрыДокументаПриИзмененииРеквизитов(Объект, 	РезультатОповещения);
	ОбщиеПараметрыДокументов.ПараметрыДокументаПриИзменении(ЭтотОбъект,			РезультатОповещения);
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область Штрихкодирование

&НаКлиенте
Процедура Подключаемый_ШтрихкодированиеОбработкаОповещения(РезультатОповещения,
	ДополнительныеПараметры = Неопределено) Экспорт

	Если РезультатОповещения = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если РезультатОповещения.Свойство("Действие") Тогда
		ШтрихкодированиеОбработкаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ШтрихкодированиеОбработкаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры)

	ШтрихкодированиеВызовСервера.ОбработкаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры, , Объект);

КонецПроцедуры

#КонецОбласти

#КонецОбласти