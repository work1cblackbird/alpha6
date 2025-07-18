﻿///////////////////////////////////////////////////////////////////////////////
// Модуль основной формы документа "Инвентаризация автомобилей"
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
	
	РазрешитьРедактированиеЦенИСумм = ПраваИНастройкиПользователя.Значение("РедактированиеЦенИСуммВНоменклатурныхТаблицах", Объект);
	РаботаСФормой.РазрешитьРедактированиеЦенИСумм(
		РаботаСФормой.ТиповыеПоляСуммовыхРеквизитов(ЭтотОбъект),
		РазрешитьРедактированиеЦенИСумм
	);
	РаботаСФормой.ОткрытьФормуТолькоДляПросмотра(ЭтотОбъект, Объект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда		
		// ПрослеживаемыеТовары
		ЗаполнитьСлужебныйРеквизитПрослеживаемогоТовара();
		// Конец ПрослеживаемыеТовары
		
		Объект.СтатьяСписанияОбнаруженнойНедостачиТМЦ     = Справочники.СтатьиДоходовИРасходов.СписаниеОбнаруженнойНедостачиТМЦ;
		Объект.СтатьяОприходованияОбнаруженныхИзлишковТМЦ = Справочники.СтатьиДоходовИРасходов.ОприходованиеОбнаруженныхИзлишковТМЦ;
		
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
	
	// ПрослеживаемыеТовары
	ЗаполнитьСлужебныйРеквизитПрослеживаемогоТовара();
	// Конец ПрослеживаемыеТовары
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
	ОбновитьРеквизитыРазницы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	РаботаСФормойКлиент.ЗамерВремениЗапись("ИнвентаризацияАвтомобилей", ПараметрыЗаписи.РежимЗаписи,
		Объект.Автомобили.Количество() > 50);
		
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
	
	// ПрослеживаемыеТовары
	ЗаполнитьСлужебныйРеквизитПрослеживаемогоТовара();
	// Конец ПрослеживаемыеТовары
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
	ОбновитьРеквизитыРазницы();
	
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
	
	Документы.ИнвентаризацияАвтомобилей.ДатаПриИзменении(Объект, ПараметрыДействия);
	
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
	
	Документы.ИнвентаризацияАвтомобилей.ХозОперацияПриИзменении(Объект, ПараметрыДействия);

	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ХозОперацияПриИзменении(Команда)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УправлениеДиалогомДокументаКлиент.ОбработатьВыборХозОперации(Объект, Элементы, Команда.Имя);
	
	ПараметрыДействия = Новый Структура;
	ХозОперацияПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

&НаСервере
Процедура СкладКомпанииПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ИнвентаризацияАвтомобилей.СкладКомпанииПриИзменении(Объект, ПараметрыДействия);
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура СкладКомпанииПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	СкладКомпанииПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.ИнвентаризацияАвтомобилей.КонтрагентПриИзменении(Объект, ПараметрыДействия);
	
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
	
	Документы.ИнвентаризацияАвтомобилей.ДоговорВзаиморасчетовПриИзменении(Объект, ПараметрыДействия);
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорВзаиморасчетовПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ДоговорВзаиморасчетовПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

#Область ОбработчикиСобытийЭлементовУправленияОбщегоНазначения

&НаКлиенте
Процедура НадписьВзаиморасчетыНажатие(Элемент)
	
	УправлениеДиалогомДокументаКлиент.НадписьВзаиморасчетыНажатие(ЭтотОбъект);
	
КонецПроцедуры 

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАвтомобили

&НаКлиенте
Процедура АвтомобилиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	УправлениеДиалогомАльфаАвтоКлиент.АвтомобилиПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа, Параметр);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобилиПередНачаломИзменения(Элемент, Отказ)
	
	УправлениеДиалогомАльфаАвтоКлиент.АвтомобилиПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобилиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УправлениеДиалогомАльфаАвтоКлиент.АвтомобилиПриОкончанииРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования);
	
	Элемент.ТекущиеДанные.КоличествоРазница=Элемент.ТекущиеДанные.КоличествоУчет-Элемент.ТекущиеДанные.Количество;
	Элемент.ТекущиеДанные.СуммаРазницы=Элемент.ТекущиеДанные.СуммаУчет-Элемент.ТекущиеДанные.Сумма;
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобилиПередУдалением(Элемент, Отказ)
	
	Если Элементы.Автомобили.ТекущаяСтрока <> Неопределено Тогда
		АвтомобилиПередУдалениемНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура АвтомобилиПередУдалениемНаСервере()
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобилиПослеУдаления(Элемент)
	
	АвтомобилиПослеУдаленияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура АвтомобилиПослеУдаленияНаСервере(ПараметрыДействия = Неопределено)
	
	УправлениеДиалогомАльфаАвтоСервер.АвтомобилиПослеУдаления(ЭтотОбъект, Элементы.Автомобили);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобилиПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	УправлениеДиалогомАльфаАвтоКлиент.АвтомобилиПроверкаПеретаскивания(ЭтаФорма, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобилиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	УправлениеДиалогомАльфаАвтоКлиент.АвтомобилиПриНачалеРедактирования(ЭтаФорма, Элемент, НоваяСтрока, Копирование);
	
КонецПроцедуры

#Область ОбработчикиСобытийПолейТаблицыФормыАвтомобили

&НаКлиенте
Процедура АвтомобилиАвтомобильПриИзменении(Элемент)
	
	АвтомобилиАвтомобильПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура АвтомобилиАвтомобильПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Автомобили.НайтиПоИдентификатору(Элементы.Автомобили.ТекущаяСтрока);
	Документы.ИнвентаризацияАвтомобилей.АвтомобилиАвтомобильПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобилиЦенаПриИзменении(Элемент)
	
	АвтомобилиЦенаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура АвтомобилиЦенаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Автомобили.НайтиПоИдентификатору(Элементы.Автомобили.ТекущаяСтрока);
	Документы.ИнвентаризацияАвтомобилей.АвтомобилиЦенаПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобилиСуммаПриИзменении(Элемент)
	
	АвтомобилиСуммаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура АвтомобилиСуммаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Автомобили.НайтиПоИдентификатору(Элементы.Автомобили.ТекущаяСтрока);
	Документы.ИнвентаризацияАвтомобилей.АвтомобилиСуммаПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобилиКоличествоУчетПриИзменении(Элемент)
	
	АвтомобилиКоличествоУчетПриИзмененииНаСервере();
	АвтомобилиГТДИзлишковПриИзменении(Неопределено);
	
КонецПроцедуры

&НаСервере
Процедура АвтомобилиКоличествоУчетПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Автомобили.НайтиПоИдентификатору(Элементы.Автомобили.ТекущаяСтрока);
	Документы.ИнвентаризацияАвтомобилей.АвтомобилиКоличествоУчетПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобилиКоличествоУчетОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ОчиститьСообщения();
	
	Если Число(Текст) < 0 ИЛИ Число(Текст) > 1 Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю("Количество может быть либо 0, либо 1");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобилиКоличествоПриИзменении(Элемент)
	
	АвтомобилиКоличествоПриИзмененииНаСервере();
	АвтомобилиГТДИзлишковПриИзменении(Неопределено);
	
КонецПроцедуры

&НаСервере
Процедура АвтомобилиКоличествоПриИзмененииНаСервере(ПараметрыДействия = Неопределено)

	ТекущиеДанные = Объект.Автомобили.НайтиПоИдентификатору(Элементы.Автомобили.ТекущаяСтрока);
	Документы.ИнвентаризацияАвтомобилей.АвтомобилиКоличествоПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);

КонецПроцедуры

&НаКлиенте
Процедура АвтомобилиСуммаУчетПриИзменении(Элемент)
	
	АвтомобилиСуммаУчетПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура АвтомобилиСуммаУчетПриИзмененииНаСервере(ПараметрыДействия = Неопределено)

	ТекущиеДанные = Объект.Автомобили.НайтиПоИдентификатору(Элементы.Автомобили.ТекущаяСтрока);
	Документы.ИнвентаризацияАвтомобилей.АвтомобилиСуммаУчетПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтомобилиГТДИзлишковПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Автомобили.ТекущиеДанные;
	КоличествоРазница = ТекущиеДанные.КоличествоУчет - ТекущиеДанные.Количество;
	
	Если КоличествоРазница <= 0 И ЗначениеЗаполнено(ТекущиеДанные.ГТДИзлишков) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтрШаблон(НСтр("ru='Строка № %1 . ГТД используется для только для излишков.'"),Элементы.Автомобили.ТекущиеДанные.НомерСтроки)
		);
		Элементы.Автомобили.ТекущиеДанные.ГТДИзлишков = ПредопределенноеЗначение("Справочник.ГТД.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыИнвентаризационнаяКомиссия

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	УправлениеДиалогомАльфаАвтоКлиент.
		ИнвентаризационнаяКомиссияПриНачалеРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	УправлениеДиалогомАльфаАвтоКлиент.
		ИнвентаризационнаяКомиссияПередОкончаниемРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УправлениеДиалогомАльфаАвтоКлиент.
		ИнвентаризационнаяКомиссияПриОкончанииРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПослеУдаления(Элемент)
	
	УправлениеДиалогомАльфаАвтоКлиент.
		ИнвентаризационнаяКомиссияПослеУдаления(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеДиалогомАльфаАвтоКлиент.
		ИнвентаризационнаяКомиссияОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияЧленКомиссииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УправлениеДиалогомАльфаАвтоКлиент.
		ИнвентаризационнаяКомиссияЧленКомиссииНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
//@skip-warning
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда,
                                                НавигационнаяСсылка = Неопределено,
                                                СтандартнаяОбработка = Неопределено)
	
    УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
    
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ПодборЧленовКомиссии(Команда)
	
	УправлениеДиалогомАльфаАвтоКлиент.ОткрытьПодборЧленовКомиссии(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//@skip-warning
&НаКлиенте
Процедура ПроверкаПодразделенияДокументаИПользователяЗавершение(Контекст) Экспорт
	
	УправлениеДиалогомДокументаКлиент.НастроитьПараметрыДокумента(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьРеквизитыРазницы()
	
	Для Каждого СтрокаАвтомобиля Из Объект.Автомобили Цикл
		СтрокаАвтомобиля.КоличествоРазница = СтрокаАвтомобиля.КоличествоУчет - СтрокаАвтомобиля.Количество;
		СтрокаАвтомобиля.СуммаРазницы      = СтрокаАвтомобиля.СуммаУчет - СтрокаАвтомобиля.Сумма;
	КонецЦикла;
	
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

// ПрослеживаемыеТовары
&НаСервере
Процедура ЗаполнитьСлужебныйРеквизитПрослеживаемогоТовара()
	
	ИменаРеквизитов = УчетПрослеживаемыхТоваровСервер
		.ИменаРеквизитовДляЗаполнитьСлужебныйРеквизитПрослеживаемогоТовара();
	ИменаРеквизитов.ИмяТаблицы = "Автомобили";
	ИменаРеквизитов.ИмяРеквизита = "Автомобиль";
	УчетПрослеживаемыхТоваровСервер.ЗаполнитьСлужебныйРеквизитПрослеживаемогоТовара(Объект,, ИменаРеквизитов);
	
КонецПроцедуры
// Конец ПрослеживаемыеТовары

#КонецОбласти

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	
	// Вызываем общий обработчик события настройки параметров выбора
	УправлениеДиалогомДокументаСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
	УправлениеДиалогомДокументаСервер.НастроитьПараметрыВыбораАвтомобиляДляКомиссионныхДокументов(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	// Вызываем общий обработчик действия
	УправлениеДиалогомАльфаАвтоСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
	Если Объект.ХозОперация=Справочники.ХозОперации.ИнвентаризацияАвтомобилейОтданныхНаКомиссию Тогда
		Элементы.Контрагент.Видимость			= Истина;
		Элементы.ДоговорВзаиморасчетов.Видимость= Истина;
		Элементы.СкладКомпании.Видимость		= Ложь;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СпособЗачетаАвансов",
			"Видимость",
			(Объект.ДоговорВзаиморасчетов.СпособВеденияВзаиморасчетов = Перечисления.СпособыВеденияУчетаВзаиморасчетов.ПоСделкам)
		);
	Иначе
		Элементы.Контрагент.Видимость			= Ложь;
		Элементы.ДоговорВзаиморасчетов.Видимость= Ложь;
		Элементы.СкладКомпании.Видимость		= Истина;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СпособЗачетаАвансов",
			"Видимость",
			Ложь
		);
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура УстановитьУсловноеОформление()
 
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.АвтомобилиСуммаРазницы.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Автомобили.СуммаРазницы");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОтрицательногоЧисла);
	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.АвтомобилиКоличествоРазница.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Автомобили.КоличествоРазница");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОтрицательногоЧисла);
	
КонецПроцедуры 

&НаСервере
Процедура ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры=Неопределено)
	
	Если НЕ УправлениеДиалогомДокументаСервер.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры // ОбработкаРезультатаОповещенияНаСервере()

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаОповещения(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	// Вызываем общий обработчик события в контексте клиента
	Если НЕ УправлениеДиалогомДокументаКлиент.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	// Обработаем событие в контексте сервера
	ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры);
	
	// Вызываем обработчик результата выполнения
	ОбработкаРезультатаВыполненияДействия(РезультатОповещения);
	
КонецПроцедуры // Подключаемый_ОбработкаРезультатаОповещения()

// Отображает результат выполнения действия.
//
// Параметры:
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
&НаКлиенте
Процедура ОбработкаРезультатаВыполненияДействия(ПараметрыДействия)
	
	//Если ОбработкаРеквизитовДокументаКлиент.ПолучитьРазрешениеДляПересчета(ПараметрыДействия, Объект.Автомобили) 
	//	ИЛИ ОбработкаРеквизитовДокументаКлиент.ПолучитьРазрешениеДляКоличественногоПересчета(ПараметрыДействия, Объект.Автомобили) Тогда
	//	ОбработкаПересчетаТабличныхЧастейНаСервере(ПараметрыДействия);
	//КонецЕсли;
	
	// Вызываем общий обработчик проверки необходимости выполнения пересчета табличных частей объекта.
	ОбработкаРеквизитовДокументаКлиент.ПолучитьРазрешенияДляПересчета(ЭтотОбъект, ПараметрыДействия);
	
	// Вызываем общий обработчик результата выполнения действия
	УправлениеДиалогомДокументаКлиент.ОбработкаРезультатаВыполненияДействия(ЭтотОбъект, ПараметрыДействия);
	
КонецПроцедуры // ОбработкаРезультатаВыполненияДействия()

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