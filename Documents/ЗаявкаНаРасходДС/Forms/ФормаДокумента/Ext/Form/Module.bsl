﻿///////////////////////////////////////////////////////////////////////////////
// Модуль основной формы документа "Заявка на расход денежных средств"
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
	
	// УтверждениеДокументов
	УтверждениеДокументовСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	// Конец УтверждениеДокументов
	
	РаботаСФормой.ИнициализироватьМенюВыбораХозОперации(ЭтотОбъект);
	РаботаСФормой.РасставитьСвязиПараметровВыбораПоОрганизации(ЭтотОбъект, Объект);
	РаботаСФормой.ОграничитьВыборКонтактныхЛиц(Элементы.Контрагент);
	РаботаСФормой.ЗаблокироватьРедактированиеНомераИДатыДокумента(ЭтотОбъект, Объект);
	
	РазрешитьРедактированиеЦенИСумм = ПраваИНастройкиПользователя.Значение("РедактированиеЦенИСуммВНоменклатурныхТаблицах", Объект);
	РаботаСФормой.РазрешитьРедактированиеЦенИСумм(
		РаботаСФормой.ТиповыеПоляСуммовыхРеквизитов(ЭтотОбъект),
		РазрешитьРедактированиеЦенИСумм
	);
	РаботаСФормой.ОткрытьФормуТолькоДляПросмотра(ЭтотОбъект, Объект);
	
	// Штрихкодирование
	ШтрихкодированиеВызовСервера.ПрочитатьШтрихкодДокумента(ЭтотОбъект, Объект);
	// Конец Штрихкодирование
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормы.ПриСозданииНаСервере_ФормаДокумента(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	// Конец АльфаАвто.СобытияОбъектов
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.КнопкаСписок.Пометка = Истина;
		// Онлайн-оплата
		ДоступностьОнлайнОплата();
		// Конец Онлайн-оплата
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
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
	// Онлайн-оплата
	ОтображениеСтатусаВозврата();
	// Конец Онлайн-оплата
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормыКлиент.ПриОткрытии_ФормаДокумента(ЭтотОбъект, Отказ);
	// Конец АльфаАвто.СобытияОбъектов
	
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
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормыКлиент.ОбработкаОповещения_ФормаДокумента(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец АльфаАвто.СобытияОбъектов
		
	// Штрихкодирование
	ШтрихкодированиеКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец Штрихкодирование
	
	// УтверждениеДокументов
	УтверждениеДокументовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец УтверждениеДокументов
	
КонецПроцедуры 

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
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
		СтатьяРасходов = Объект.Платежи[0].СтатьяРасходов;
		Описание       = Объект.Платежи[0].Описание;
		Сумма          = Объект.Платежи[0].Сумма;
	Иначе
		Элементы.КнопкаСписок.Пометка = Истина;
	КонецЕсли;
	
	// Онлайн-оплата
	ДоступностьОнлайнОплата();
	Если Объект.ОплатаОнлайн Тогда
		ПроверитьРегистрациюЗаявкиНаРасход();
	КонецЕсли;
	// Конец Онлайн-оплата
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормы.ПриЧтенииНаСервере_ФормаДокумента(ЭтотОбъект, ТекущийОбъект);
	// Конец АльфаАвто.СобытияОбъектов
	
КонецПроцедуры 

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
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
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормы.ПередЗаписьюНаСервере_ФормаДокумента(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	// Конец АльфаАвто.СобытияОбъектов
	
КонецПроцедуры 

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Штрихкодирование
	ШтрихкодированиеВызовСервера.ЗаписатьШтрихкодДокумента(ЭтотОбъект, Объект);
	// Конец Штрихкодирование
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормы.ПослеЗаписиНаСервере_ФормаДокумента(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец АльфаАвто.СобытияОбъектов
	
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

	Документы.ЗаявкаНаРасходДС.ДатаПриИзменении(Объект, ПараметрыДействия);
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
Процедура ХозОперацияПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ЗаявкаНаРасходДС.ХозОперацияПриИзменении(Объект, ПараметрыДействия);
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурнаяЕдиницаПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	СтруктурнаяЕдиницаПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

&НаСервере
Процедура СтруктурнаяЕдиницаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ЗаявкаНаРасходДС.КассаКомпанииПриИзменении(Объект, ПараметрыДействия);
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	КонтрагентПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере(ПараметрыДействия = Неопределено)

	Документы.ЗаявкаНаРасходДС.КонтрагентПриИзменении(Объект, ПараметрыДействия);
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ДоговорВзаиморасчетовПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ДоговорВзаиморасчетовПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

&НаСервере
Процедура ДоговорВзаиморасчетовПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ЗаявкаНаРасходДС.ДоговорВзаиморасчетовПриИзменении(Объект, ПараметрыДействия);
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ДатаПлатежаТекущаяПриИзменении(Элемент)
	
	Если Объект.Платежи.Количество() = 1 Тогда
		Объект.Платежи[0].ДатаПлатежа = ДатаПлатежа;
	ИначеЕсли  Объект.Платежи.Количество() = 0 Тогда
		НоваяСтрока                = Объект.Платежи.Добавить();
		НоваяСтрока.ДатаПлатежа    = ?(ЗначениеЗаполнено(ДатаПлатежа), ДатаПлатежа, Объект.Дата);
		НоваяСтрока.СтатьяРасходов = СтатьяРасходов;
		НоваяСтрока.Описание       = Описание;
		НоваяСтрока.Сумма          = Сумма;
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СтатьяРасходовТекущаяПриИзменении(Элемент)
	
	Если Объект.Платежи.Количество() = 1 Тогда
		Объект.Платежи[0].СтатьяРасходов = СтатьяРасходов;
	ИначеЕсли  Объект.Платежи.Количество() = 0 Тогда
		НоваяСтрока                = Объект.Платежи.Добавить();
		НоваяСтрока.ДатаПлатежа    = ?(ЗначениеЗаполнено(ДатаПлатежа), ДатаПлатежа, Объект.Дата);
		НоваяСтрока.СтатьяРасходов = СтатьяРасходов;
		НоваяСтрока.Описание       = Описание;
		НоваяСтрока.Сумма          = Сумма;
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СуммаПлатежаПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	СуммаПлатежаПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

&НаСервере
Процедура СуммаПлатежаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Если Объект.Платежи.Количество() = 1 Тогда
		Объект.Платежи[0].Сумма = Сумма;
	ИначеЕсли Объект.Платежи.Количество() = 0 Тогда
		НоваяСтрока                = Объект.Платежи.Добавить();
		НоваяСтрока.ДатаПлатежа    = ?(ЗначениеЗаполнено(ДатаПлатежа), ДатаПлатежа, Объект.Дата);
		НоваяСтрока.СтатьяРасходов = СтатьяРасходов;
		НоваяСтрока.Описание       = Описание;
		НоваяСтрока.Сумма          = Сумма;
	КонецЕсли;
	
	УправлениеДиалогомНаСервере();
	
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

// Онлайн-оплата
&НаКлиенте
Процедура ОплатаОнлайнПриИзменении(Элемент)
	
	Элементы.КнопкаЗапросВозврата.Видимость = Объект.ОплатаОнлайн;
	Элементы.ДекорацияСтатусВозврата.Видимость = Объект.ОплатаОнлайн;
	
	Если Объект.ОплатаОнлайн Тогда
		
		ПроверитьРегистрациюЗаявкиНаРасход();
		УправлениеДиалогомНаСервереОнлайнОплата();
		ОтображениеСтатусаВозврата();
		
	Иначе
		
		ОтключитьОбработчикОжидания("Подключаемый_ПолучитьСтатусВозврата");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВозвратПоСчетуПриИзмененииНаСервере()
	
	Если НЕ ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		
		Возврат "";
		
	КонецЕсли;
	
	Документы.ЗаявкаНаРасходДС.ВозвратПоСчетуПриИзменении(Объект);
	
	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.КорректировкаРеализации")
		ИЛИ ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.КорректировкаРеализацииАвтомобилей") Тогда
		
		Возврат НСтр("ru='Проверьте значение суммы на возврат'");
		
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаКлиенте
Процедура ВозвратПоСчетуПриИзменении(Элемент)
	
	// Предупредить пользователя о необходимости проверить сумму возврата по корректировкам реализации
	ТекстПредупреждения = ВозвратПоСчетуПриИзмененииНаСервере();
	Если ТекстПредупреждения <> "" Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры
// Конец Онлайн-оплата

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПлатежи

&НаКлиенте
Процедура ПлатежиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элементы.Платежи.ТекущиеДанные.ДатаПлатежа = Объект.Дата;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежиПриИзменении(Элемент)
	
	ПлатежиПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПлатежиПриИзмененииНаСервере()
	
	ЗащищенныеФункцииСервер.УстановитьЗаголовокНадписиСуммаДокумента(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежиПослеУдаления(Элемент)
	
	ПлатежиПослеУдаленияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПлатежиПослеУдаленияНаСервере(ПараметрыДействия = Неопределено)

	ЗащищенныеФункцииСервер.УстановитьЗаголовокНадписиСуммаДокумента(ЭтотОбъект);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПлатежиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УправлениеДиалогомДокументаКлиент.ТоварыПриОкончанииРедактирования(
		ЭтотОбъект,
		Элемент,
		НоваяСтрока,
		ОтменаРедактирования,
		"Платежи"
	);
	
КонецПроцедуры

#Область ОбработчикиСобытийПолейТаблицыФормыПлатежи

&НаСервере
Процедура ПлатежиСуммаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ЗаявкаНаРасходДС.СуммаДокументаПриИзменении(Объект, ПараметрыДействия);
	УправлениеДиалогомНаСервере();

КонецПроцедуры 

&НаКлиенте
Процедура ПлатежиСуммаПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ПлатежиСуммаПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
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
			СтатьяРасходов = Объект.Платежи[0].СтатьяРасходов;
			Описание       = Объект.Платежи[0].Описание;
			Сумма          = Объект.Платежи[0].Сумма;
		КонецЕсли;
		
	Иначе
		
		Если Объект.Платежи.Количество() = 0 Тогда
			НоваяСтрока                = Объект.Платежи.Добавить();
			НоваяСтрока.ДатаПлатежа    = ?(ЗначениеЗаполнено(ДатаПлатежа), ДатаПлатежа, Объект.Дата);
			НоваяСтрока.СтатьяРасходов = СтатьяРасходов;
			НоваяСтрока.Описание       = Описание;
			НоваяСтрока.Сумма          = Сумма;
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.КнопкаСписок.Пометка = Не Элементы.КнопкаСписок.Пометка;
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры // ПоказатьСписок()

// Онлайн-оплата
&НаСервере
Процедура КомандаЗапроситьВозвратНаСервере()
	
	Если НЕ ЗначениеЗаполнено(Объект.ВозвратПоСчету) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Не выбран счет, по которому выполняется возврат'"), Объект.Ссылка);
		
		Возврат;
		
	КонецЕсли;
	
	ОстатокВБанке = ОнлайнОплата.ПолучитьОстатокВБанке(Объект.ВозвратПоСчету, Объект.Ссылка);
	
	Если ОстатокВБанке < Объект.СуммаДокумента Тогда
		
		ШаблонСообщения = НСтр("ru='Остаток в банке %1 меньше суммы заявки %2'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ОстатокВБанке, Объект.СуммаДокумента);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект.Ссылка);
		
		Возврат;
		
	КонецЕсли;
	
	РезультатВыполнения = ОнлайнОплата.ЗарегистрироватьВозврат(Объект.ВозвратПоСчету, Объект.Ссылка);
	
	Если РезультатВыполнения.Успешно Тогда
		
		ЗаявкаЗарегистрирована = Истина;
		
	Иначе
		
		Для каждого ТекстСообщения Из РезультатВыполнения.ТекстыСообщений Цикл
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект.Ссылка);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗапроситьВозврат(Команда)
	
	Если Модифицированность ИЛИ НЕ Объект.Проведен Тогда
		
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Проведение);
		Если НЕ Записать(ПараметрыЗаписи) Тогда
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	КомандаЗапроситьВозвратНаСервере();
	
КонецПроцедуры
// Конец Онлайн-оплата

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
	СтатьяРасходов = Объект.Платежи[0].СтатьяРасходов;
	Описание       = Объект.Платежи[0].Описание;
	Сумма          = СуммаИтог;
	
	// удалим все строки в табличной части, кроме первой
	Пока Объект.Платежи.Количество() > 0 Цикл
		СтрокаУдаления = Объект.Платежи[0];
		Объект.Платежи.Удалить(СтрокаУдаления);
	КонецЦикла;
	
	НоваяСтрока                = Объект.Платежи.Добавить();
	НоваяСтрока.ДатаПлатежа    = ?(ЗначениеЗаполнено(ДатаПлатежа), ДатаПлатежа, Объект.Дата);
	НоваяСтрока.СтатьяРасходов = СтатьяРасходов;
	НоваяСтрока.Описание       = Описание;
	НоваяСтрока.Сумма          = Сумма;
	
	Элементы.КнопкаСписок.Пометка = Не Элементы.КнопкаСписок.Пометка;
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаСервере
Процедура УстановитьУсловноеОформление()
 
	УправлениеДиалогомДокументаСервер.УстановитьУсловноеОформление(ЭтотОбъект);
	
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

// ЗаполнениеОбъектов
&НаКлиенте
Процедура ПослеОбработкиЗаполнения(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	ПослеОбработкиЗаполненияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеОбработкиЗаполненияНаСервере()
	
	ЗаполнениеОбъектовАльфаАвто.ПослеОбработкиЗаполнения(ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ЗаполнениеОбъектов

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

// СчетаФактуры

&НаКлиенте
Процедура НадписьВзаиморасчетыНажатие(Элемент)
	
	УправлениеДиалогомДокументаКлиент.НадписьВзаиморасчетыНажатие(ЭтотОбъект);
	
КонецПроцедуры
// Конец СчетаФактуры

#КонецОбласти

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	
	// Вызываем общий обработчик события настройки параметров выбора
	УправлениеДиалогомДокументаСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
	Если НЕ Элементы.Найти("СтруктурнаяЕдиница")=Неопределено Тогда
		Если Объект.ХозОперация = Справочники.ХозОперации.ЗаявкаНаРасходИзКассы Тогда
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
	
	// Вызываем общий обработчик действия
	УправлениеДиалогомДокументаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда		
		
		// Присвоим тип данных Касс или Банковских счетов в зависимости от хоз операции.
		Если Объект.ХозОперация = Справочники.ХозОперации.ЗаявкаНаРасходИзКассы Тогда
			Элементы.СтруктурнаяЕдиница.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.КассыКомпании");
		Иначе
			Элементы.СтруктурнаяЕдиница.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.БанковскиеСчета");
		КонецЕсли;
	
	КонецЕсли;
	
	// Присвоим тип данных Касс или Банковских счетов в зависимости от хоз операции.
	Если Объект.ХозОперация = Справочники.ХозОперации.ЗаявкаНаРасходИзКассы Тогда
		Элементы.СтруктурнаяЕдиница.Заголовок = НСтр("ru = 'Касса организации'");
	Иначе
		Элементы.СтруктурнаяЕдиница.Заголовок = НСтр("ru = 'Счет организации'");
	КонецЕсли;
	
	// активируем необходимую страничку с или без списка
	Если Элементы.КнопкаСписок.Пометка Тогда		
		Элементы.ГруппаСписокПлатежей.Видимость = Истина;
		Элементы.ГруппаЕдиничныйПлатеж.Видимость = Ложь;
	Иначе
		Элементы.ГруппаСписокПлатежей.Видимость = Ложь;
		Элементы.ГруппаЕдиничныйПлатеж.Видимость = Истина;
		Элементы.ГруппаПлатеж.Заголовок = "Платежи";
	КонецЕсли;	
	
	Если Объект.Платежи.Количество() = 1 Тогда
		// объявим первую строку табл. части Платежи текущей для корректной индикации
		Элементы.Платежи.ТекущаяСтрока = 0;		
	КонецЕсли;	
	
	// Онлайн-оплата
	УправлениеДиалогомНаСервереОнлайнОплата();
	// Конец Онлайн-оплата
	
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

// Онлайн-оплата
&НаСервере
Процедура ДоступностьОнлайнОплата()
	
	ВозвратОнлайнОплатыРазрешен = ПравоПользователя("РазрешитьВозвратОнлайнОплаты");
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьРегистрациюЗаявкиНаРасход()
	
	Если Объект.ОплатаОнлайн И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		РезультатВыполнения = ОнлайнОплата.ПроверитьРегистрациюЗаявкиНаРасход(Объект.Ссылка);
		ЗаявкаЗарегистрирована = РезультатВыполнения.ЗаявкаЗарегистрирована;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеДиалогомНаСервереОнлайнОплата()
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОнлайнОплаты") Тогда
		
		Элементы.КнопкаЗапросВозврата.Видимость = Ложь;
		Элементы.ДекорацияСтатусВозврата.Видимость = Ложь;
		
		Возврат;
		
	КонецЕсли;
	
	Элементы.ВозвратПоСчету.Видимость = Объект.ОплатаОнлайн;
	Элементы.КнопкаЗапросВозврата.Видимость = Объект.ОплатаОнлайн;
	Элементы.ДекорацияСтатусВозврата.Видимость = Объект.ОплатаОнлайн;
	
	ДоступностьКомандыЗапросВозврата = НЕ ЗаявкаЗарегистрирована И ВозвратОнлайнОплатыРазрешен;
	Элементы.КнопкаЗапросВозврата.Доступность = ДоступностьКомандыЗапросВозврата;
	Элементы.ВозвратПоСчету.Доступность = ДоступностьКомандыЗапросВозврата;
	Элементы.ОплатаОнлайн.Доступность = ВозвратОнлайнОплатыРазрешен;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображениеСтатусаВозврата()
	
	Если НЕ Объект.ОплатаОнлайн Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДанныеДляОтображения = ПолучитьДанныеДляОтображенияСтатусаВозврата(Объект.ВозвратПоСчету, Объект.Ссылка);
	
	Элементы.ДекорацияСтатусВозврата.Заголовок = ДанныеДляОтображения.Заголовок;
	Элементы.ДекорацияСтатусВозврата.ЦветТекста = ДанныеДляОтображения.ЦветТекста;
	
	ОбновитьОтображениеДанных();
	
	Если НЕ (ДанныеДляОтображения.ВыполненВозврат ИЛИ ДанныеДляОтображения.ОтказВозврата) Тогда
		
		ПодключитьОбработчикОжидания("Подключаемый_ПолучитьСтатусВозврата", 5, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеДляОтображенияСтатусаВозврата(СчетНаОплату, ЗаявкаНаРасходДС)
	
	Возврат ОнлайнОплата.ПолучитьДанныеВозвратаДляОтображенияНаФорме(СчетНаОплату, ЗаявкаНаРасходДС);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПолучитьСтатусВозврата()
	
	ДанныеДляОтображения = ПолучитьДанныеДляОтображенияСтатусаВозврата(Объект.ВозвратПоСчету, Объект.Ссылка);
	
	Элементы.ДекорацияСтатусВозврата.Заголовок = ДанныеДляОтображения.Заголовок;
	Элементы.ДекорацияСтатусВозврата.ЦветТекста = ДанныеДляОтображения.ЦветТекста;
	
	ОбновитьОтображениеДанных();
	
	Если ДанныеДляОтображения.ВыполненВозврат ИЛИ ДанныеДляОтображения.ОтказВозврата Тогда
		ОтключитьОбработчикОжидания("Подключаемый_ПолучитьСтатусВозврата");
	КонецЕсли;
	
КонецПроцедуры
// Конец Онлайн-оплата

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