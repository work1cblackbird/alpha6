﻿///////////////////////////////////////////////////////////////////////////////
// Модуль основной формы документа "План поступления денежных средств"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отказ = Отказ Или РаботаСФормой.НужноОтменитьОткрытиеФормы();
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ИмяЭлементаКоманднойПанели", "ГлобальныеКоманды");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// УтверждениеДокументов
	УтверждениеДокументовСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	// Конец УтверждениеДокументов
	
	РаботаСФормой.ИнициализироватьМенюВыбораХозОперации(ЭтотОбъект);
	РаботаСФормой.РасставитьСвязиПараметровВыбораПоОрганизации(ЭтотОбъект, Объект);
	РаботаСФормой.ОграничитьВыборКонтактныхЛиц(Элементы.Контрагент);
	РаботаСФормой.ЗаблокироватьРедактированиеНомераИДатыДокумента(ЭтотОбъект, Объект);
	РаботаСФормой.ОткрытьФормуТолькоДляПросмотра(ЭтотОбъект, Объект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.КнопкаСписок.Пометка = Истина;
		
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
	
	// УтверждениеДокументов
	УтверждениеДокументовКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец УтверждениеДокументов
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
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
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// УтверждениеДокументов
	УтверждениеДокументовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец УтверждениеДокументов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Если Объект.Платежи.Количество() = 1 Тогда
		Элементы.КнопкаСписок.Пометка = Ложь;
		// объявим первую строку табл. части Платежи текущей для корректной индикации
		ДатаПлатежа    = Объект.Платежи[0].ДатаПлатежа;
		Описание       = Объект.Платежи[0].Описание;
		Сумма          = Объект.Платежи[0].Сумма;
	Иначе
		Элементы.КнопкаСписок.Пометка = Истина;
	КонецЕсли;

	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	РаботаСФормойКлиент.ЗамерВремениЗапись("ПланПоступленияДС", ПараметрыЗаписи.РежимЗаписи, Ложь);
		
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
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
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
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
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

&НаСервере
Процедура ДатаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ПланПоступленияДС.ДатаПриИзменении(Объект, ПараметрыДействия);

	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	ПараметрыДействия = Новый Структура;
	ДатаПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

&НаСервере
Процедура ХозОперацияПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ПланПоступленияДС.ХозОперацияПриИзменении(Объект, ПараметрыДействия);

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
Процедура СтруктурнаяЕдиницаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ПланПоступленияДС.КассаКомпанииПриИзменении(Объект, ПараметрыДействия);

	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура СтруктурнаяЕдиницаПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	СтруктурнаяЕдиницаПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ПланПоступленияДС.КонтрагентПриИзменении(Объект, ПараметрыДействия);

	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	КонтрагентПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

&НаСервере
Процедура ДоговорВзаиморасчетовПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ПланПоступленияДС.ДоговорВзаиморасчетовПриИзменении(Объект, ПараметрыДействия);

	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ДоговорВзаиморасчетовПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ДоговорВзаиморасчетовПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ДатаПлатежаПриИзменении(Элемент)
	
	Если Объект.Платежи.Количество() = 1 Тогда
		Объект.Платежи[0].ДатаПлатежа = ДатаПлатежа;
	ИначеЕсли  Объект.Платежи.Количество() = 0 Тогда
		НоваяСтрока                = Объект.Платежи.Добавить();
		НоваяСтрока.ДатаПлатежа    = ?(ЗначениеЗаполнено(ДатаПлатежа), ДатаПлатежа, Объект.Дата);
		НоваяСтрока.Описание       = Описание;
		НоваяСтрока.Сумма          = Сумма;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПлатежаПриИзменении(Элемент)
	
	Если Объект.Платежи.Количество() = 1 Тогда
		Объект.Платежи[0].Сумма = Сумма;
	ИначеЕсли  Объект.Платежи.Количество() = 0 Тогда
		НоваяСтрока                = Объект.Платежи.Добавить();
		НоваяСтрока.ДатаПлатежа    = ?(ЗначениеЗаполнено(ДатаПлатежа), ДатаПлатежа, Объект.Дата);
		НоваяСтрока.Описание       = Описание;
		НоваяСтрока.Сумма          = Сумма;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеПлатежаТекущееПриИзменении(Элемент)
	
	Если Объект.Платежи.Количество() = 1 Тогда
		Объект.Платежи[0].Описание = Описание;
	ИначеЕсли  Объект.Платежи.Количество() = 0 Тогда
		НоваяСтрока                = Объект.Платежи.Добавить();
		НоваяСтрока.ДатаПлатежа    = ?(ЗначениеЗаполнено(ДатаПлатежа), ДатаПлатежа, Объект.Дата);
		НоваяСтрока.Описание       = Описание;
		НоваяСтрока.Сумма          = Сумма;
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовУправленияОбщегоНазначения

&НаКлиенте
Процедура НадписьВзаиморасчетыНажатие(Элемент)
	
	УправлениеДиалогомДокументаКлиент.НадписьВзаиморасчетыНажатие(ЭтотОбъект);
	
КонецПроцедуры 

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПлатежи

&НаКлиенте
Процедура ПлатежиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УправлениеДиалогомДокументаКлиент.ТоварыПриОкончанииРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования, "Платежи");
	
КонецПроцедуры 

&НаСервере
Процедура ПлатежиПослеУдаленияНаСервере(ПараметрыДействия=Неопределено)
	
	УправлениеДиалогомДокументаСервер.ТоварыПослеУдаления(ЭтотОбъект, Элементы.Платежи, ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПлатежиПослеУдаления(Элемент)
	
	ПлатежиПослеУдаленияНаСервере();
	
КонецПроцедуры 

#Область ОбработчикиСобытийПолейТаблицыФормыПлатежи

&НаСервере
Процедура ПлатежиСуммаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Платежи.НайтиПоИдентификатору(Элементы.Платежи.ТекущаяСтрока);

	Документы.ПланПоступленияДС.ПлатежиСуммаПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПлатежиСуммаПриИзменении(Элемент)
	
	ПлатежиСуммаПриИзмененииНаСервере();
	
КонецПроцедуры 

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьСписок(Команда)
	
	Если Элементы.КнопкаСписок.Пометка Тогда
		Если Объект.Платежи.Количество() > 1 Тогда
			ОбработкаОтветаНаВопрос = Новый ОписаниеОповещения("ОбработкаРезультатаОповещенияПоказатьСписок", ЭтотОбъект);
			ПоказатьВопрос(ОбработкаОтветаНаВопрос, НСтр("ru = 'Все строки расшифровки платежа, кроме первой, будут удалены. Продолжить?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
			Возврат;
		ИначеЕсли Объект.Платежи.Количество() = 1 Тогда
			ДатаПлатежа    = Объект.Платежи[0].ДатаПлатежа;
			Описание       = Объект.Платежи[0].Описание;
			Сумма          = Объект.Платежи[0].Сумма;
		КонецЕсли;
	Иначе
		Если Объект.Платежи.Количество() = 0 Тогда
			НоваяСтрока                = Объект.Платежи.Добавить();
			НоваяСтрока.ДатаПлатежа    = ?(ЗначениеЗаполнено(ДатаПлатежа), ДатаПлатежа, Объект.Дата);
			НоваяСтрока.Описание       = Описание;
			НоваяСтрока.Сумма          = Сумма;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.КнопкаСписок.Пометка = Не Элементы.КнопкаСписок.Пометка;
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаРезультатаОповещенияПоказатьСписок(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если РезультатОповещения <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	// Запомним общую сумму платежа
	СуммаИтог = Объект.Платежи.Итог("Сумма");
	
	ДатаПлатежа    = Объект.Платежи[0].ДатаПлатежа;
	Описание       = Объект.Платежи[0].Описание;
	Сумма          = СуммаИтог;
	
	// удалим все строки в табличной части, кроме первой
	Пока Объект.Платежи.Количество() > 0 Цикл
		СтрокаУдаления = Объект.Платежи[0];
		Объект.Платежи.Удалить(СтрокаУдаления);
	КонецЦикла;
	
	НоваяСтрока                = Объект.Платежи.Добавить();
	НоваяСтрока.ДатаПлатежа    = ?(ЗначениеЗаполнено(ДатаПлатежа), ДатаПлатежа, Объект.Дата);
	НоваяСтрока.Описание       = Описание;
	НоваяСтрока.Сумма          = Сумма;
	
	Элементы.КнопкаСписок.Пометка = Не Элементы.КнопкаСписок.Пометка;
	УправлениеДиалогомНаСервере();
	
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

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
    УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

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

&НаКлиенте
Процедура НадписьСуммаДокументаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УправлениеДиалогомДокументаКлиент.ПоказатьРасширенныеИтогиОперации(ЭтотОбъект, Элемент);
	
КонецПроцедуры
// Конец Ядро

#КонецОбласти

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	// Вызываем общий обработчик события настройки параметров выбора
	УправлениеДиалогомДокументаСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
	Если Не Элементы.Найти("СтруктурнаяЕдиница")=Неопределено Тогда
		Если Объект.ХозОперация = Справочники.ХозОперации.ПланПоступленияВКассу Тогда
			УправлениеДиалогомСервер.УдалитьПараметрВыбора(Элементы.СтруктурнаяЕдиница.ПараметрыВыбора, "Отбор.Владелец");
			УправлениеДиалогомСервер.ОбновитьПараметрВыбора(Элементы.СтруктурнаяЕдиница.ПараметрыВыбора,
															"Отбор.ПодразделениеКомпании", Объект.ПодразделениеКомпании);
		Иначе
			УправлениеДиалогомСервер.УдалитьПараметрВыбора(Элементы.СтруктурнаяЕдиница.ПараметрыВыбора,
															"Отбор.ПодразделениеКомпании");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	// Вызываем общий обработчик действия.
	УправлениеДиалогомДокументаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
	Если Объект.ХозОперация = Справочники.ХозОперации.ПланПоступленияВКассу Тогда
		Элементы.СтруктурнаяЕдиница.Заголовок       = НСтр("ru = 'Касса организации'");
		Элементы.СтруктурнаяЕдиница.Подсказка       = НСтр("ru = 'Касса организации'");
		Элементы.СтруктурнаяЕдиница.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.КассыКомпании");
		
		Если Не ТипЗнч(Объект.СтруктурнаяЕдиница) = Тип("СправочникСсылка.КассыКомпании") Тогда
			Объект.СтруктурнаяЕдиница = Справочники.КассыКомпании.ПустаяСсылка();
		КонецЕсли;
	Иначе
		Элементы.СтруктурнаяЕдиница.Заголовок       = НСтр("ru = 'Счет организации'");
		Элементы.СтруктурнаяЕдиница.Подсказка       = НСтр("ru = 'Счет организации'");
		Элементы.СтруктурнаяЕдиница.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.БанковскиеСчета");
		
		Если Не ТипЗнч(Объект.СтруктурнаяЕдиница) = Тип("СправочникСсылка.БанковскиеСчета")Тогда
			Объект.СтруктурнаяЕдиница = Справочники.БанковскиеСчета.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	// Активируем необходимую страничку с или без списка.
	Если Элементы.КнопкаСписок.Пометка Тогда		
		Элементы.ГруппаСписокПлатежей.Видимость = Истина;
		Элементы.ГруппаЕдиничныйПлатеж.Видимость = Ложь;
	Иначе
		Элементы.ГруппаСписокПлатежей.Видимость = Ложь;
		Элементы.ГруппаЕдиничныйПлатеж.Видимость = Истина;
		Элементы.ГруппаПлатеж.Заголовок = "Платежи";
	КонецЕсли;	
	
	Если Объект.Платежи.Количество() = 1 Тогда
		// Объявим первую строку табл. части Платежи текущей для корректной индикации.
		Элементы.Платежи.ТекущаяСтрока = 0;		
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры=Неопределено)
	
	Если НЕ УправлениеДиалогомДокументаСервер.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаОповещения(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
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

#Область УтверждениеДокументов

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуУтверждения(Команда)
	
	УтверждениеДокументовКлиент.ОбработкаКомандыФормы(ЭтотОбъект, Команда, Объект.Ссылка);
	Прочитать();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьОбработкуКомандыУтвержденияНаСервере(ПараметрыОбработки,
		ДополнительныеПараметры) Экспорт
	
	ОбработкаКомандыУтвержденияНаСервере(ПараметрыОбработки, ДополнительныеПараметры);
	Оповестить("ПослеУтвержденияДокументов", Объект.Ссылка, ИмяФормы);
	ОповеститьОбИзменении(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаКомандыУтвержденияНаСервере(ПараметрыОбработки, ДополнительныеПараметры)
	
	УтверждениеДокументовВызовСервера.ОбработкаКомандыФормы(ЭтотОбъект, ПараметрыОбработки.ИмяКоманды, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКомандыУтвержденияДокументов()
	
	ОбновитьКомандыУтвержденияДокументовНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКомандыУтвержденияДокументовНаСервере()
	
	УтверждениеДокументовКлиентСервер.УстановитьДоступностьКнопокУтверждения(ЭтотОбъект, Объект, ТолькоПросмотр);
	УтверждениеДокументовВызовСервера.УстановитьДоступностьФормыДляРедактирования(ЭтотОбъект, Объект, ТолькоПросмотр);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти