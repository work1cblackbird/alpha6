﻿///////////////////////////////////////////////////////////////////////////////
// Модуль основной формы документа "Отгрузка товаров".
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
	РаботаСФормой.ОграничитьВыборКонтактныхЛиц(Элементы.Контрагент);
	РаботаСФормой.НастроитьОтображениеСИспользованиемБазовогоКоличества(Элементы.ТоварыКоличество);
	РаботаСФормой.ЗаблокироватьРедактированиеНомераИДатыДокумента(ЭтотОбъект, Объект);
	
	РазрешитьРедактированиеЦенИСумм = ПраваИНастройкиПользователя.Значение("РедактированиеЦенИСуммВНоменклатурныхТаблицах", Объект);
	РаботаСФормой.РазрешитьРедактированиеЦенИСумм(
		РаботаСФормой.ТиповыеПоляСуммовыхРеквизитов(ЭтотОбъект),
		РазрешитьРедактированиеЦенИСумм
	);
	
	ОписаниеНовойКолонкиПроизводитель = РаботаСФормой.ОписаниеНовойКолонкиПроизводитель();
	ОписаниеНовойКолонкиПроизводитель.ТабличнаяЧасть = Элементы.Товары;
	ОписаниеНовойКолонкиПроизводитель.ПоставитьПеред = Элементы.ТоварыНоменклатураАртикул;
	НоваяКолонкаПроизводитель = РаботаСФормой.НоваяКолонкаПроизводитель(ЭтотОбъект, ОписаниеНовойКолонкиПроизводитель);
	
	КолонкиКодАртикулИПроизводитель = Новый Структура();
	КолонкиКодАртикулИПроизводитель.Вставить("Код", Элементы.ТоварыНоменклатураКод);
	КолонкиКодАртикулИПроизводитель.Вставить("Артикул", Элементы.ТоварыНоменклатураАртикул);
	КолонкиКодАртикулИПроизводитель.Вставить("Производитель", НоваяКолонкаПроизводитель);
	РаботаСФормой.НастроитьВидимостьКолонокКодАртикулИПроизводитель(КолонкиКодАртикулИПроизводитель);
	РаботаСФормой.ОткрытьФормуТолькоДляПросмотра(ЭтотОбъект, Объект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		// Заполним данные для отгрузки неучастнику
		Если Объект.ОтгрузкаНеучастнику И Параметры.Свойство("ЗаполнениеДокументаНеучастиника") Тогда
			ЗаполнитьЗначенияСвойств(Объект, Параметры.ЗаполнениеДокументаНеучастиника);
		КонецЕсли;
		
		РаботаСФормой.ЗаполнитьСлужебныеРеквизитыТоваров(Объект.Товары);
		РаботаСФормой.УстановитьВидимостьКолонкиХарактеристика(ЭтотОбъект, Объект);
		
		// Маркировка
		МаркировкаТоваровСервер.ИнициализироватьСлужебныеРеквизиты(ЭтотОбъект);
		МаркировкаТоваровСервер.ПриСозданииЧтенииНаСервере(ЭтотОбъект, Объект);
		// Конец Маркировка
		
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

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ПараметрыДействия = Новый Структура;
	ОбработкаВыбораНаСервере(ВыбранноеЗначение, ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораНаСервере(ВыбранноеЗначение, ПараметрыДействия=Неопределено)
	
	Если НЕ УправлениеДиалогомДокументаСервер.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, ПараметрыДействия) Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
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
	МаркировкаТоваровСервер.ИнициализироватьСлужебныеРеквизиты(ЭтотОбъект);
	МаркировкаТоваровСервер.ПриСозданииЧтенииНаСервере(ЭтотОбъект, Объект);
	// Конец Маркировка
	
	УправлениеДиалогомАльфаАвтоСервер.ПриЧтенииНаСервере(ЭтотОбъект); 
	ЗаполнитьСтатусИИдентификаторДокумента();
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	РаботаСФормойКлиент.ЗамерВремениЗапись("ОтгрузкаТоваровКодовМаркировки", ПараметрыЗаписи.РежимЗаписи,
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
		
	Если Объект.ВидТоварооборота <> Перечисления.ВидыОтгрузкиТоваров.Продажа Тогда
		Объект.ПричинаВыводаИзОборота = Неопределено;
	КонецЕсли;
	
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
	РаботаСФормой.УстановитьВидимостьКолонкиХарактеристика(ЭтотОбъект, Объект);
	
	// Маркировка
	МаркировкаТоваровСервер.ИнициализироватьСлужебныеРеквизиты(ЭтотОбъект);
	МаркировкаТоваровСервер.ЗаполнитьСлужебныйРеквизитКодыМаркировки(Объект);
	// Конец Маркировка
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	РаботаСФормойКлиент.ОповеститьОЗаписиДокумента(Объект.Ссылка);
	РаботаСФормойКлиент.ОбновитьПодчиненныеСчета(Объект.Ссылка, Неопределено);
	
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
	
	Документы.ОтгрузкаТоваровКодовМаркировки.ДатаПриИзменении(Объект, ПараметрыДействия);
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ХозОперацияПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ОтгрузкаТоваровКодовМаркировки.ХозОперацияПриИзменении(Объект, ПараметрыДействия);
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
Процедура ТоварнаяГруппаПриИзмененииНаСервере()
	
	МаркировкаТоваровСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварнаяГруппаПриИзменении(Элемент)
	
	ТоварнаяГруппаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ДокументОснованиеПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ОтгрузкаТоваровКодовМаркировки.ДокументОснованиеПриИзменении(Объект, ПараметрыДействия);
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ДокументОснованиеПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидТоварооборотаПриИзменении(Элемент)
	
	ВидТоварооборотаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ВидТоварооборотаПриИзмененииНаСервере()
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПричинаВыводаИзОборотаПриИзменении(Элемент)
	
	ПричинаВыводаИзОборотаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПричинаВыводаИзОборотаПриИзмененииНаСервере()
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводИзОборотаПриИзменении(Элемент)
	
	ВыводИзОборотаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ВыводИзОборотаПриИзмененииНаСервере()
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ОтгрузкаТоваровКодовМаркировки.КонтрагентПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	КонтрагентПриИзмененииНаСервере();
	
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
	
	Документы.ОтгрузкаТоваровКодовМаркировки.ТоварыНоменклатураПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
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
	.ОтгрузкаТоваровКодовМаркировки
	.ТоварыХарактеристикаНоменклатурыПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНоменклатурыПриИзменении(Элемент)
	
	ТоварыХарактеристикаНоменклатурыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ТоварыКоличествоПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	Документы.ОтгрузкаТоваровКодовМаркировки.ТоварыКоличествоПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ТоварыКоличествоПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ТоварыЦенаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	Документы.ОтгрузкаТоваровКодовМаркировки.ТоварыЦенаПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	ТоварыЦенаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	
	ТоварыСуммаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ТоварыСуммаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	Документы.ОтгрузкаТоваровКодовМаркировки.ТоварыСуммаПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСтавкаНДСПриИзменении(Элемент)
	
	ТоварыСтавкаНДСПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ТоварыСтавкаНДСПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	Документы.ОтгрузкаТоваровКодовМаркировки.ТоварыСтавкаНДСПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаНДСПриИзменении(Элемент)
	
	ТоварыСуммаНДСПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ТоварыСуммаНДСПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	Документы.ОтгрузкаТоваровКодовМаркировки.ТоварыСуммаНДСПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура АннулироватьОтгрузку(Команда)
	
	Если Статус = ПредопределенноеЗначение("Перечисление.СтатусыДокументовМаркировки.АннулированаОтгрузка") Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Данная отгрузка товаров находится в статусе аннулирования. Операция отменена'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторДокумента) Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Документ не был создан в системе маркировки. Операция отменена'"));
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ДатаВыводаИзОборота)
		И Объект.ПричинаВыводаИзОборота = ПредопределенноеЗначение("Перечисление.ВидыОтгрузкиТоваров.Продажа") Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Товар был выведен из оборота. Операция отменена'"));
		Возврат;
	КонецЕсли;
	
	ИмяДействия = "АннулироватьОтгрузкуТоваров";
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Действие", ИмяДействия);
	ДополнительныеПараметры.Вставить("Документ", Объект.Ссылка);
	ДополнительныеПараметры.Вставить("Организация", Объект.Организация);
	ДополнительныеПараметры.Вставить("СтатусДокумента",
		ПредопределенноеЗначение("Перечисление.СтатусыДокументовМаркировки.АннулированаОтгрузка"));
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

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	
	УправлениеДиалогомДокументаСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
	СписокВыбора = Элементы.Статус.СписокВыбора;
	СписокВыбора.ЗагрузитьЗначения(МаркировкаТоваровСервер.РазрешенныеСтатусыДокументовМаркировки(Объект.Ссылка));
	
	СписокВыбораТоварооборота = Элементы.ВидТоварооборота.СписокВыбора;
	СписокВыбораТоварооборота.Очистить();
	СписокВыбораТоварооборота.Добавить(Перечисления.ВидыОтгрузкиТоваров.Продажа);
	СписокВыбораТоварооборота.Добавить(Перечисления.ВидыОтгрузкиТоваров.Комиссия);
	СписокВыбораТоварооборота.Добавить(Перечисления.ВидыОтгрузкиТоваров.Агент);
	
	СписокВыбораПричинаВыводаИзОборота = Элементы.ПричинаВыводаИзОборота.СписокВыбора;
	СписокВыбораПричинаВыводаИзОборота.Очистить();
	СписокВыбораПричинаВыводаИзОборота.Добавить(Перечисления.ПричиныОтгрузкиТоваров.БезВозмезднаяПередача);
	СписокВыбораПричинаВыводаИзОборота.Добавить(
		Перечисления.ПричиныОтгрузкиТоваров.ИспользованиеДляСобственныхНуждПокупателем);
	СписокВыбораПричинаВыводаИзОборота.Добавить(Перечисления.ПричиныОтгрузкиТоваров.ПриобретениеГосПредприятием);
	
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
		ОтображениеПодсказки.Нет);
	
	Элементы.ВыводИзОборота.ТолькоПросмотр = НЕ (Объект.ВидТоварооборота = Перечисления.ВидыОтгрузкиТоваров.Продажа);
	Элементы.ДатаВыводаИзОборота.ТолькоПросмотр = НЕ Объект.ВыводИзОборота ИЛИ Элементы.ВыводИзОборота.ТолькоПросмотр;
	Элементы.ПричинаВыводаИзОборота.ТолькоПросмотр = НЕ Объект.ВыводИзОборота ИЛИ Элементы.ВыводИзОборота.ТолькоПросмотр;
	Элементы.ИдентификаторГосКонтракта.ТолькоПросмотр = НЕ (Объект.ВыводИзОборота
		И НЕ Элементы.ПричинаВыводаИзОборота.ТолькоПросмотр
		И (Объект.ПричинаВыводаИзОборота = Перечисления.ПричиныОтгрузкиТоваров.ПриобретениеГосПредприятием));
	
	ЧерезAPI =
		ЭтотОбъект.РежимОбменаСЧестнымЗнаком = ПредопределенноеЗначение("Перечисление.СпособыОбменаСЧестнымЗнаком.ЧерезAPI");
	
	Элементы.ПервичныйДокумент.ТолькоПросмотр = ЗначениеЗаполнено(Объект.ДокументОснование);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ИдентификаторДокумента",
		"Видимость",
		ЧерезAPI
	);
	
	Если ЧерезAPI Тогда
		ЭтотОбъект.ТолькоПросмотр = Статус = Перечисления.СтатусыДокументовМаркировки.ОжидаетОбработки;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"АннулироватьОтгрузку",
			"Доступность",
			НЕ Статус = Перечисления.СтатусыДокументовМаркировки.Принят
		);
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
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УправлениеДиалогомДокументаСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	
	// Маркировка
	МаркировкаТоваровСервер.УстановитьУсловноеОформлениеКодыМаркировок(ЭтотОбъект);
	// Конец Маркировка
	
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
	
	ПродолжитьВыполнение = УправлениеДиалогомДокументаКлиент.ОбработкаРезультатаОповещения(
		ЭтотОбъект,
		РезультатОповещения,
		ДополнительныеПараметры
	);
	Если НЕ ПродолжитьВыполнение Тогда
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
Процедура ЗаполнитьСтатусИИдентификаторДокумента()
	
	Запись = РегистрыСведений.СтатусыДокументовМаркировки.ПолучитьСтатусДокумента(Объект.Ссылка);
	Статус = Запись.Статус;
	ИдентификаторДокумента = Запись.ИдентификаторДокумента;
	ОписаниеОшибки = Запись.ОписаниеОшибки;
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

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