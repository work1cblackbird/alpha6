﻿///////////////////////////////////////////////////////////////////////////////
// Модуль основной формы документа "Бюджет оказания услуг по автоработам"
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
	РаботаСФормой.ЗаблокироватьРедактированиеНомераИДатыДокумента(ЭтотОбъект, Объект);
	
	РазрешитьРедактированиеЦенИСумм = ПраваИНастройкиПользователя.Значение("РедактированиеЦенИСуммВНоменклатурныхТаблицах", Объект);
	РаботаСФормой.РазрешитьРедактированиеЦенИСумм(
		РаботаСФормой.ТиповыеПоляСуммовыхРеквизитов(ЭтотОбъект),
		РазрешитьРедактированиеЦенИСумм
	);
	РаботаСФормой.ОткрытьФормуТолькоДляПросмотра(ЭтотОбъект, Объект);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.ДатаПланирования) Тогда
			Объект.ДатаПланирования = НачалоМесяца(ТекущаяДатаСеанса());
		КонецЕсли;
		
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
	
	УправлениеДиалогомАльфаАвтоКлиент.ПриОткрытии(ЭтотОбъект);
	
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
	
	НастроитьПараметрыВыбораЭлементовФормы();
	
	// Заполним ставки НДС
	Для Каждого Авторабота Из Объект.Автоработы Цикл
		Если ЗначениеЗаполнено(Авторабота.Авторабота) Тогда
			Авторабота.СтавкаНДС = Авторабота.Авторабота.Номенклатура.СтавкаНДС;
		КонецЕсли;
	КонецЦикла;

	УправлениеДиалогомНаСервере();
	
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
	
	Документы.БюджетОказанияУслугПоАвтоработам.ДатаПриИзменении(Объект, ПараметрыДействия);
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
	
	Документы.БюджетОказанияУслугПоАвтоработам.ХозОперацияПриИзменении(Объект, ПараметрыДействия);
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаСервере
Процедура СценарийПланированияПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.БюджетОказанияУслугПоАвтоработам.СценарийПланированияПриИзменении(Объект, ПараметрыДействия);
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СценарийПланированияПриИзменении(Элемент)
	
	// зададим вопрос
	Если Объект.СценарийПланирования <> ПредыдущийСценарийПланирования И Объект.Автоработы.Количество() > 0 Тогда
		
		// Формируем описание обработчика перехвата закрытия формы
		ОбработчикВопроса = Новый ОписаниеОповещения("ОбработкаРезультатаПриИзмененииСценарияПланирования", ЭтотОбъект);
		
		// Формируем текст вопроса
		ТекстВопроса = НСтр("ru = 'Изменился сценарий планирования. Табличная часть будет очищена. Продолжить?'");
		
		// Получаем подтверждение операции от пользователя
		ПоказатьВопрос(ОбработчикВопроса, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ПредыдущийСценарийПланирования = Объект.СценарийПланирования;
		
		// Обработаем событие в контексте сервера
		ПараметрыДействия = Новый Структура;
		
		СценарийПланированияПриИзмененииНаСервере(ПараметрыДействия);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьИнформацияОТипеЦенНажатие(Элемент)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Курс",   Объект.КурсДокумента);
	СтруктураПараметров.Вставить("ТипЦен", Объект.ТипЦен);
	СтруктураПараметров.Вставить("Дата",   Объект.Дата);
	
	ОбработкаОповещения = Новый ОписаниеОповещения("ОбработкаРезультатаВыбораТипаЦен", ЭтотОбъект, "ВыборТипаЦен");
	
	ОткрытьФорму("Документ.БюджетОказанияУслугПоАвтоработам.Форма.ФормаДляВыбораТипаЦены", СтруктураПараметров, ЭтаФорма,,,, ОбработкаОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры // НадписьИнформацияОТипеЦенНажатие()

&НаКлиенте
Процедура НадписьПараметрыНажатие(Элемент)
	
	ОткрытьФормуЗаполнения(Объект.СпособПоследнегоЗаполнения);
	
КонецПроцедуры // НадписьПараметрыНажатие()


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАвтоработы

&НаКлиенте
Процедура АвтоработыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УправлениеДиалогомАльфаАвтоКлиент.АвтоработыПриОкончанииРедактирования(
		ЭтотОбъект,
		Элемент, 
		НоваяСтрока,
		ОтменаРедактирования
	);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоработыПослеУдаления(Элемент)
	АвтоработыПослеУдаленияНаСервере();
КонецПроцедуры

&НаСервере
Процедура АвтоработыПослеУдаленияНаСервере(ПараметрыДействия=Неопределено)
	
	УправлениеДиалогомАльфаАвтоСервер.АвтоработыПослеУдаления(ЭтотОбъект, Элементы.Автоработы);
	
КонецПроцедуры

#Область ОбработчикиСобытийПолейТаблицыФормыАвтоработы

&НаКлиенте
Процедура АвтоработыАвтоработаПриИзменении(Элемент)
	АвтоработыАвтоработаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура АвтоработыАвтоработаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Автоработы.НайтиПоИдентификатору(Элементы.Автоработы.ТекущаяСтрока);
	Документы.БюджетОказанияУслугПоАвтоработам.АвтоработыАвтоработаПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоработыКоличествоПриИзменении(Элемент)
	АвтоработыКоличествоПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура АвтоработыКоличествоПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Автоработы.НайтиПоИдентификатору(Элементы.Автоработы.ТекущаяСтрока);
	Документы.БюджетОказанияУслугПоАвтоработам.АвтоработыКоличествоПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоработыЦенаПриИзменении(Элемент)
	
	АвтоработыЦенаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура АвтоработыЦенаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Автоработы.НайтиПоИдентификатору(Элементы.Автоработы.ТекущаяСтрока);
	Документы.БюджетОказанияУслугПоАвтоработам.АвтоработыЦенаПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоработыСуммаВсегоУпрПриИзменении(Элемент)
	
	АвтоработыСуммаВсегоУпрПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура АвтоработыСуммаВсегоУпрПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Автоработы.НайтиПоИдентификатору(Элементы.Автоработы.ТекущаяСтрока);
	Документы.БюджетОказанияУслугПоАвтоработам.АвтоработыСуммаВсегоУпрПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПериодВперед(Команда)
	ПериодВпередНазадНаСервере(+1);
КонецПроцедуры

&НаКлиенте
Процедура ПериодНазад(Команда)
	ПериодВпередНазадНаСервере(-1)
КонецПроцедуры

// Процедура изменения периода
// %
// Параметры:
//	Действие - Число - Содержит прзнак действия над периодом.
//
&НаСервере
Процедура ПериодВпередНазадНаСервере(Действие)
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("ДатаИзПериода" , Объект.ДатаПланирования);
	ПараметрыДействия.Вставить("Периодичность" , Объект.СценарийПланирования.Периодичность);
	ПараметрыДействия.Вставить("Действие"      , Действие);
	
	ПланированиеСервер.ПолучитьДатыПланируемогоПериода(ПараметрыДействия);
	
	Объект.ДатаПланирования = ПараметрыДействия.ДатаНачала;
	
	УправлениеДиалогомНаСервере();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьСтрокуПоследнегоЗаполнения(СпособЗаполнения = -1)
	
	Если СпособЗаполнения=-1 Тогда
		СпособЗаполнения = Объект.СпособПоследнегоЗаполнения;
	Иначе
		СпособПоследнегоЗаполнения = СпособЗаполнения;
	КонецЕсли;	
	
	Если СпособЗаполнения=-2 Тогда
		Элементы.НадписьПараметры.Заголовок = "";
		Возврат;
	КонецЕсли;
		
	Текст = "";
	
	Если СпособЗаполнения=0 Тогда
		
		Текст = "Тип анализа: " + СокрЛП(Объект.ТипАнализа);
		Текст = Текст + " (Коэф.роста=" + СокрЛП(Объект.КоэффициентРоста) + ";  Коэф.сез.=" + СокрЛП(Объект.КоэффициентСезонности) + ")" + Символы.ПС;
		Текст = Текст + "Показатель планирования: " + ?(Объект.ПоказательПланирования, "Количество", "Сумма (упр.)") + Символы.ПС;
		Текст = Текст + "Периоды планирования: " + ПланированиеСервер.ВывестиПредставлениеПериода(Объект, Объект.СценарийПланирования.Периодичность, Объект.ДатаПланирования);
		
	ИначеЕсли СпособЗаполнения=1 Тогда
		
		Текст = Текст + "Тип анализа: " + СокрЛП(Объект.ТипАнализа) + Символы.ПС;
		Текст = Текст + "Модель: " + СокрЛП(Объект.МодельПрогнозирования);
		
		Если Объект.МодельПрогнозирования=Перечисления.МоделиПрогнозирования.Сглаживанием Тогда
			
			Текст = Текст + "; Постоянная уровня: " + СокрЛП(Объект.Параметр1) + "; Постоянная тренда: "+ СокрЛП(Объект.Параметр2);
			Если ( (Объект.СценарийПланирования.Периодичность = Перечисления.ПериодичностьПланирования.Месяц) И
				(Объект.КоличествоПериодов >= 24) ) 
				ИЛИ				
				( (Объект.СценарийПланирования.Периодичность = Перечисления.ПериодичностьПланирования.Квартал) И
				(Объект.КоличествоПериодов >= 8)   ) Тогда  
				Текст = Текст + "; Постоянная сезонности: " + СокрЛП(Объект.Параметр3);
			КонецЕсли;
			
		ИначеЕсли Объект.МодельПрогнозирования=Перечисления.МоделиПрогнозирования.Полиномиальный Тогда
			Текст = Текст + "; Степень полинома: " + СокрЛП(Объект.Параметр1);
		КонецЕсли;
		
		Если Объект.ХозОперация=Справочники.ХозОперации.БюджетЗакупокПоНоменклатуре Тогда
			Текст = Текст + Символы.ПС + "Показатель планирования:  " + ?(Объект.ПоказательПланирования,"Количество","Сумма (упр.)");
		КонецЕсли;
		Текст = Текст + Символы.ПС + "Периоды планирования: " + ПланированиеСервер.ВывестиПредставлениеПериода(Объект, Объект.СценарийПланирования.Периодичность, Объект.ДатаПланирования);
		
	ИначеЕсли СпособЗаполнения=2 Тогда		
		Если НЕ ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
			Текст = "";
		Иначе
			Текст = Текст + "Док.основание:  " + Объект.ДокументОснование;
		КонецЕсли; 			
	КонецЕсли;
	
	Элементы.НадписьПараметры.Заголовок = Текст;
	
КонецПроцедуры 

&НаКлиенте
Процедура ОткрытьФормуЗаполнения(Способ = 0)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СценарийПланирования",            Объект.СценарийПланирования);
	ПараметрыФормы.Вставить("КоличествоПериодов",              Объект.КоличествоПериодов);
	ПараметрыФормы.Вставить("КоэффициентРоста",                Объект.КоэффициентРоста);
	ПараметрыФормы.Вставить("КоэффициентСезонности",           Объект.КоэффициентСезонности);
	ПараметрыФормы.Вставить("ТипАнализа",                      Объект.ТипАнализа);
	ПараметрыФормы.Вставить("ПоказательПланирования",          Объект.ПоказательПланирования);
	ПараметрыФормы.Вставить("СпособОкругления",                Объект.СпособОкругления);
	ПараметрыФормы.Вставить("НеУчитыватьПериодыБезДанных",     Объект.НеУчитыватьПериодыБезДанных);
	ПараметрыФормы.Вставить("КоличествоСезонов",               Объект.КоличествоСезонов);
	ПараметрыФормы.Вставить("СмещениеПланирования",            Объект.СмещениеПланирования);
	ПараметрыФормы.Вставить("ДатаПланирования",                Объект.ДатаПланирования);
	ПараметрыФормы.Вставить("МодельПрогнозирования",           Объект.МодельПрогнозирования);
	ПараметрыФормы.Вставить("Параметр1",                       Объект.Параметр1);
	ПараметрыФормы.Вставить("Параметр2",                       Объект.Параметр2);
	ПараметрыФормы.Вставить("Параметр3",                       Объект.Параметр3);
	ПараметрыФормы.Вставить("РасчетСезонности",                Объект.РасчетСезонности);
	ПараметрыФормы.Вставить("ДокументОснование",               Объект.ДокументОснование);
	ПараметрыФормы.Вставить("ТипЦен",                          Объект.ТипЦен);
	ПараметрыФормы.Вставить("Дата",                            Объект.Дата);
	ПараметрыФормы.Вставить("КурсДокумента",                   Объект.КурсДокумента);
	ПараметрыФормы.Вставить("ПодразделениеКомпании",           Объект.ПодразделениеКомпании);
	ПараметрыФормы.Вставить("Владелец",                        Объект.Ссылка);
	ПараметрыФормы.Вставить("ТолькоПросмотр",                  ЭтотОбъект.ТолькоПросмотр);
	
	Если Способ = 0 Тогда
		
		// Простым способом
		ОповещениеРезультата = Новый ОписаниеОповещения("ОбработкаРезультатаПоПоследнемуСпособуЗаполнения", ЭтотОбъект, "ЗаполнениеПростымСпособом");
		ОткрытьФорму("Документ.БюджетОказанияУслугПоАвтоработам.Форма.ФормаДляЗаполненияПростымСпособом", ПараметрыФормы, ЭтотОбъект, ,,, ОповещениеРезультата, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли Способ = 1 Тогда
		
		// Метод математического прогнозирования
		ОповещениеРезультата = Новый ОписаниеОповещения("ОбработкаРезультатаПоПоследнемуСпособуЗаполнения", ЭтотОбъект, "ЗаполнениеМатМетодами");
		ОткрытьФорму("Документ.БюджетОказанияУслугПоАвтоработам.Форма.ФормаДляЗаполненияМатМетодами", ПараметрыФормы, ЭтотОбъект, ,,, ОповещениеРезультата, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли Способ = 2 Тогда
		
		// Заполнение по документу основанию
		ОповещениеРезультата = Новый ОписаниеОповещения("ОбработкаРезультатаПоПоследнемуСпособуЗаполнения", ЭтотОбъект, "ЗаполнениеДокументомОснование");
		ОткрытьФорму("Документ.БюджетОказанияУслугПоАвтоработам.Форма.ФормаДляЗаполненияПоДокументуОснованию", ПараметрыФормы, ЭтотОбъект, ,,, ОповещениеРезультата, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаРезультатаПриИзмененииСценарияПланирования(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.ДокументОснование = ПредопределенноеЗначение("Документ.БюджетОказанияУслугПоАвтоработам.ПустаяСсылка");
		Объект.Автоработы.Очистить();
		ПредыдущийСценарийПланирования = Объект.СценарийПланирования;
		Объект.СпособПоследнегоЗаполнения = -2;
	Иначе
		Объект.СценарийПланирования = ПредыдущийСценарийПланирования;
	КонецЕсли;
	
	ПараметрыДействия = Новый Структура;
	СценарийПланированияПриИзмененииНаСервере(ПараметрыДействия);
	
КонецПроцедуры 

&НаСервере
Процедура ОбработкаРезультатаПоПоследнемуСпособуЗаполненияНаСервере(Результат, ДополнительныеПараметры = Неопределено)
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		ПараметрыКоманды = Новый Структура("РезультатВыбора, Источник", Результат, Объект);
		Объект.Автоработы.Очистить();
		Документы.БюджетОказанияУслугПоАвтоработам.ЗаполнениеТабличнойЧастиАвтоработы(Объект, ПараметрыКоманды);
		
		Если ДополнительныеПараметры = "ЗаполнениеПростымСпособом" Тогда
			Объект.СпособПоследнегоЗаполнения = 0;
		ИначеЕсли ДополнительныеПараметры = "ЗаполнениеМатМетодами" Тогда
			Объект.СпособПоследнегоЗаполнения = 1;
		ИначеЕсли ДополнительныеПараметры = "ЗаполнениеДокументомОснование" Тогда
			Объект.СпособПоследнегоЗаполнения = 2;
		КонецЕсли;
		
	КонецЕсли;
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаРезультатаПоПоследнемуСпособуЗаполнения(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОбработкаРезультатаПоПоследнемуСпособуЗаполненияНаСервере(Результат, ДополнительныеПараметры);
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаРезультатаВыбораТипаЦен(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Объект.КурсДокумента = Результат.КурсДокумента;
		Объект.ТипЦен        = Результат.ТипЦен;
	КонецЕсли;
	
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

// ЗаполнениеОбъектов
&НаКлиенте
Процедура ПослеОбработкиЗаполнения(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	ПослеОбработкиЗаполненияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеОбработкиЗаполненияНаСервере()
	
	ЗаполнениеОбъектовАльфаАвто.ПослеОбработкиЗаполнения(ЭтотОбъект, Объект);
	СформироватьСтрокуПоследнегоЗаполнения();
	
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

// Конец Ядро

#КонецОбласти

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	
	УправлениеДиалогомДокументаСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры 

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	УправлениеДиалогомДокументаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
	// Период планирования
	Если ЗначениеЗаполнено(Объект.СценарийПланирования) И ЗначениеЗаполнено(Объект.СценарийПланирования.Периодичность) Тогда
		ПараметрыПериода = Новый Структура;
		ПараметрыПериода.Вставить("ДатаИзПериода" , Объект.ДатаПланирования);
		ПараметрыПериода.Вставить("Периодичность" , Объект.СценарийПланирования.Периодичность);
		ПараметрыПериода.Вставить("Действие"      , 0);
		
		ПериодПланирования = ПланированиеСервер.ПолучитьДатыПланируемогоПериода(ПараметрыПериода);
		
		Если Объект.СпособПоследнегоЗаполнения = 2 Тогда
			Если НЕ ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
				Объект.СпособПоследнегоЗаполнения = -2;
			Иначе
				Если Объект.СценарийПланирования.Периодичность <> Объект.ДокументОснование.СценарийПланирования.Периодичность Тогда
					Объект.ДокументОснование = Новый (ТипЗнч(Объект.ДокументОснование));
					УправлениеДиалогомНаСервере();
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	Иначе
		ПериодПланирования = "<Неопределен>";
	КонецЕсли;
	
	// заполнение надписей по типу цен
	ПараметрыПериода = Новый Структура;
	ПараметрыПериода.Вставить("ТипЦен"                    , Объект.ТипЦен);
	ПараметрыПериода.Вставить("КурсДокумента"             , 1);
	ПараметрыПериода.Вставить("НадписьИнформацияОТипеЦен" , Элементы.НадписьИнформацияОТипеЦен);
	
	ПланированиеСервер.СформироватьНадписьТипаЦены(ПараметрыПериода);
	
	СформироватьСтрокуПоследнегоЗаполнения();
	
КонецПроцедуры // УправлениеДиалогомНаСервере()

&НаСервере
Процедура УстановитьУсловноеОформление()
 
	// Вызываем общий обработчик действия
	УправлениеДиалогомДокументаСервер.УстановитьУсловноеОформление(ЭтотОбъект);
	
КонецПроцедуры 

&НаСервере
Процедура ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры=Неопределено)
	
	
	Если НЕ УправлениеДиалогомДокументаСервер.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры = "КомандаЗаполненияАвтоработыЗаполнениеПоДаннымПрошлогоПериода" Тогда
		Объект.СпособПоследнегоЗаполнения = 0;
	ИначеЕсли ДополнительныеПараметры = "КомандаЗаполненияАвтоработыЗаполнениеМетодамиМатематическогоПрогнозирования" Тогда
		Объект.СпособПоследнегоЗаполнения = 1;
	ИначеЕсли ДополнительныеПараметры = "КомандаЗаполненияАвтоработыЗаполнениеПоДокументуОснованию" Тогда
		Объект.СпособПоследнегоЗаполнения = 2;
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