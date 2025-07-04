﻿///////////////////////////////////////////////////////////////////////////////
// Модуль основной формы документа "Инкассация"
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
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	ЗапретРедактированияРеквизитовОбъектовАльфаАвто.ЗаблокироватьФискальныеРеквизиты(ЭтотОбъект);
	
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
	РаботаСФормой.ЗаблокироватьРедактированиеНомераИДатыДокумента(ЭтотОбъект, Объект);
	РаботаСФормой.ОткрытьФормуТолькоДляПросмотра(ЭтотОбъект, Объект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		НастроитьПараметрыВыбораЭлементовФормы();
		УправлениеДиалогомНаСервере();
	КонецЕсли;
	
	ПараметрыДокумента = ОбщиеПараметрыДокументов.СформироватьПредставлениеПараметровДокумента(Объект);
	
	Элементы.КассаККМРасширеннаяПодсказка.Гиперссылка = ПравоДоступа("Просмотр", Метаданные.Отчеты.ДенежныеСредстваВКассахККМ);
	
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
	
   	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	РаботаСФормойКлиент.ЗамерВремениЗапись("Инкассация", ПараметрыЗаписи.РежимЗаписи, Ложь);
		
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
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	ЗапретРедактированияРеквизитовОбъектовАльфаАвто.ЗаблокироватьФискальныеРеквизиты(ЭтотОбъект);
	
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
	
	Документы.Инкассация.ДатаПриИзменении(Объект, ПараметрыДействия);

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
	
	Документы.Инкассация.ХозОперацияПриИзменении(Объект, ПараметрыДействия);
	
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
Процедура КассаККМПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.Инкассация.КассаККМПриИзменении(Объект, ПараметрыДействия);
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура КассаККМПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	КассаККМПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

&НаСервере
Процедура ИнкассаторПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.Инкассация.ИнкассаторПриИзменении(Объект, ПараметрыДействия);
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ИнкассаторПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ИнкассаторПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры

&НаСервере
Процедура ДоговорВзаиморасчетовИнкассаторПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.Инкассация.ДоговорВзаиморасчетовИнкассаторПриИзменении(Объект, ПараметрыДействия);
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ДоговорВзаиморасчетовИнкассаторПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ДоговорВзаиморасчетовИнкассаторПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры  

&НаСервере
Процедура ПлатежнаяСистемаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.Инкассация.ПлатежнаяСистемаПриИзменении(Объект, ПараметрыДействия);
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ПлатежнаяСистемаПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ПлатежнаяСистемаПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

&НаСервере
Процедура ДоговорВзаиморасчетовПлатежнаяСистемаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.Инкассация.ДоговорВзаиморасчетовПлатежнаяСистемаПриИзменении(Объект, ПараметрыДействия);
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ДоговорВзаиморасчетовПлатежнаяСистемаПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ДоговорВзаиморасчетовПлатежнаяСистемаПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

#Область ОбработчикиСобытийЭлементовУправленияОбщегоНазначения

&НаКлиенте
Процедура НадписьВзаиморасчетыИнкассаторНажатие(Элемент)
	
	УправлениеДиалогомДокументаКлиент.НадписьВзаиморасчетыНажатие(ЭтотОбъект, "Инкассатор", "ДоговорВзаиморасчетовИнкассатор");
	
КонецПроцедуры 

&НаКлиенте
Процедура НадписьВзаиморасчетыПСНажатие(Элемент)
	
	УправлениеДиалогомДокументаКлиент.НадписьВзаиморасчетыНажатие(ЭтотОбъект, "ПлатежнаяСистема", "ДоговорВзаиморасчетовПлатежнаяСистема");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьКассаККМОстатокНажатие(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.КассаККМ) Тогда
		Возврат;
	КонецЕсли;
	// фильтры
	ОтчетОтбор = Новый Структура;
	ОтчетОтбор.Вставить("КассаККМ", Объект.КассаККМ);
	
	НастройкиВарианта = ПолучитьНастройкуОтчета();
	ОтчетыПлатформаКлиент.ОткрытьОтчет("Отчет.ДенежныеСредстваВКассахККМ", "Остатки", НастройкиВарианта,,, ОтчетОтбор, , ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры 

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОплаты

&НаСервере
Процедура ОплатыПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ЗащищенныеФункцииСервер.УстановитьЗаголовокНадписиСуммаДокумента(ЭтотОбъект);
	
	Объект.СуммаДокумента = Объект.Оплаты.Итог("Сумма");
	Если Элементы.Оплаты.ТекущаяСтрока <> Неопределено Тогда
		ТекущиеДанные = Объект.Оплаты.НайтиПоИдентификатору(Элементы.Оплаты.ТекущаяСтрока);
		Если ТекущиеДанные.ТипОплаты = Перечисления.ТипыОплатыККТ.Наличные И ТекущиеДанные.СуммаВозврат <> 0 Тогда
			ТекстСообщения = НСтр("ru = 'Для наличной оплаты невозможно изъять сумму возврата'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатыПриИзменении(Элемент)
	
	ОплатыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОплатыПослеУдаленияНаСервере(ПараметрыДействия = Неопределено)
	
	ЗащищенныеФункцииСервер.УстановитьЗаголовокНадписиСуммаДокумента(ЭтотОбъект);
	
КонецПроцедуры 

&НаКлиенте
Процедура ОплатыПослеУдаления(Элемент)
	
	ОплатыПослеУдаленияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УправлениеДиалогомДокументаКлиент.ТоварыПриОкончанииРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования, "Оплаты");
	
КонецПроцедуры

&НаСервере
Процедура ОплатыТипОплатыПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Оплаты.НайтиПоИдентификатору(Элементы.Оплаты.ТекущаяСтрока);
	Документы.Инкассация.ОплатыТипОплатыПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ОплатыТипОплатыПриИзменении(Элемент)
	
	ОплатыТипОплатыПриИзмененииНаСервере();
	
КонецПроцедуры 

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
Процедура ПробитьЧек(Команда)
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("ОповещениеПробитьЧекЗавершениеФР",Новый ОписаниеОповещения("ПробитьЧекЗавершениеФР", ЭтотОбъект,ПараметрыДействия));
	УправлениеДиалогомДокументаКлиент.ПробитьЧек(ЭтотОбъект,ПараметрыДействия);		
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьИндикациюОстаткаДСВКассе()
	
	Если ЗначениеЗаполнено(Объект.КассаККМ) Тогда
		ТаблицаОстатковКассы = документы.Инкассация.ПолучитьОстатокПоКассеККМ(Объект.КассаККМ,?(ЗначениеЗаполнено(Объект.Ссылка), Объект.Ссылка.МоментВремени(), КонецДня(Объект.Дата)));  
		
		текстЗаголовок = "";
		Для Каждого СтрокаОстаткиККМ Из ТаблицаОстатковКассы Цикл
			Если СтрокаОстаткиККМ.ТипОплаты = Перечисления.ТипыОплатыККТ.Наличные Тогда
				текстЗаголовок = текстЗаголовок + СтрокаОстаткиККМ.ТипОплаты + " : "+ Формат(СтрокаОстаткиККМ.Сумма,			"ЧЦ=15; ЧДЦ=2; ЧРГ=' '; ЧН=0.00") +" "+ СокрЛП(Объект.ВалютаДокумента.Наименование) + "; ";
			Иначе
				текстЗаголовок = текстЗаголовок + СтрокаОстаткиККМ.ТипОплаты + " : "+ Формат(СтрокаОстаткиККМ.Сумма,			"ЧЦ=15; ЧДЦ=2; ЧРГ=' '; ЧН=0.00") +" "+ СокрЛП(Объект.ВалютаДокумента.Наименование) + "; ";
				текстЗаголовок = текстЗаголовок + СтрокаОстаткиККМ.ТипОплаты + " возвр.: "+Формат(СтрокаОстаткиККМ.СуммаВозврат,	"ЧЦ=15; ЧДЦ=2; ЧРГ=' '; ЧН=0.00") +" "+ СокрЛП(Объект.ВалютаДокумента.Наименование) + "; ";
			КонецЕсли;
		КонецЦикла;
		Элементы.КассаККМ.РасширеннаяПодсказка.Заголовок = текстЗаголовок;
	Иначе
		Элементы.КассаККМ.РасширеннаяПодсказка.Заголовок= НСтр("ru = '<Касса ККМ не выбрана>'");
	КонецЕсли; 

КонецПроцедуры 

&НаСервере
Процедура ВывестиЗаголовокВзаиморасчеты()
	
	Если ЗначениеЗаполнено(Объект.ДоговорВзаиморасчетовИнкассатор) Тогда
		МоментВремени = ?(ЗначениеЗаполнено(Объект.Ссылка), Объект.Ссылка.МоментВремени(), КонецДня(Объект.Дата));
		СтруктураОтбора	= Новый Структура("Контрагент,ДоговорВзаиморасчетов",Объект.Инкассатор,Объект.ДоговорВзаиморасчетовИнкассатор);
		Долг = РасчетыСКонтрагентамиСервер.ВзаиморасчетыСКонтрагентомПоОтбору(
			СтруктураОтбора,
			МоментВремени,
			"Сумма").Итог("Сумма");
		// Выведем на экран долг.
		Элементы.ДоговорВзаиморасчетовИнкассатор.РасширеннаяПодсказка.Заголовок = НСтр("ru = 'По договору долг контрагента составляет:'") 
																					+ Символы.НПП + Формат(Долг,"ЧЦ=10; ЧДЦ=2; ЧН=0,00") + " "
																					+ СокрЛП(Объект.ДоговорВзаиморасчетовИнкассатор.ВалютаВзаиморасчетов.Наименование);
	Иначе
		Элементы.ДоговорВзаиморасчетовИнкассатор.РасширеннаяПодсказка.Заголовок = НСтр("ru = '<Договор не выбран>'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ДоговорВзаиморасчетовПлатежнаяСистема) Тогда
		МоментВремени = ?(ЗначениеЗаполнено(Объект.Ссылка), Объект.Ссылка.МоментВремени(), КонецДня(Объект.Дата));
		СтруктураОтбора	= Новый Структура("Контрагент,ДоговорВзаиморасчетов",Объект.ПлатежнаяСистема,Объект.ДоговорВзаиморасчетовПлатежнаяСистема);
		Долг = РасчетыСКонтрагентамиСервер.ВзаиморасчетыСКонтрагентомПоОтбору(
			СтруктураОтбора,
			МоментВремени,
			"Сумма").Итог("Сумма");
		// Выведем на экран долг.
		Элементы.ДоговорВзаиморасчетовПлатежнаяСистема.РасширеннаяПодсказка.Заголовок = НСтр("ru = 'По договору долг контрагента составляет:'")
																						+ Символы.НПП + Формат(Долг,"ЧЦ=10; ЧДЦ=2; ЧН=0,00")+ " "
																						+ СокрЛП(Объект.ДоговорВзаиморасчетовПлатежнаяСистема.ВалютаВзаиморасчетов.Наименование);
	Иначе
		Элементы.ДоговорВзаиморасчетовПлатежнаяСистема.РасширеннаяПодсказка.Заголовок = НСтр("ru = '<Договор не выбран>'");
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Функция ПолучитьНастройкуОтчета()
	
	Отчет = Отчеты.ДенежныеСредстваВКассахККМ.Создать();
	ВариантОтчета = Отчет.СхемаКомпоновкиДанных.ВариантыНастроек.Остатки.Настройки;
	
	Показатели      = ВариантОтчета.Выбор;
	СтруктураОтчета = ВариантОтчета.Структура;
	ОтборОтчета = ВариантОтчета.Отбор;
	СтруктураОтчета.Очистить();
	
	Для Каждого ТекПоказатель Из Показатели.Элементы Цикл
		Если ТипЗнч(ТекПоказатель) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			ТекПоказатель.Использование = Истина;
			Для Каждого ТекВложенныйПоказатель Из ТекПоказатель.Элементы Цикл
				ТекВложенныйПоказатель.Использование = Истина;
			КонецЦикла;
		ИначеЕсли НЕ ТипЗнч(ТекПоказатель) = Тип("АвтоВыбранноеПолеКомпоновкиДанных") Тогда
			ТекПоказатель.Использование = Истина;
		КонецЕсли;
	КонецЦикла;
	
	// фильтры
	КоличествоПодчиненных = ОтборОтчета.Элементы.Количество()-1;
	Пока КоличествоПодчиненных >= 0 Цикл
		Если НЕ ОтборОтчета.Элементы[КоличествоПодчиненных].ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КассаККМ") Тогда
			ОтборОтчета.Элементы.Удалить(ОтборОтчета.Элементы[КоличествоПодчиненных]);
		КонецЕсли;
			КоличествоПодчиненных = КоличествоПодчиненных - 1;
	КонецЦикла;
	
	ТаблицаОтчета = СтруктураОтчета.Добавить(Тип("ТаблицаКомпоновкиДанных"));
	// добавляем измерения строки
	ГруппировкаСкладКомпании = ОтчетыПлатформаСервер.СКД_ДобавитьГруппировку(ТаблицаОтчета.Строки, "ТипОплаты");
	
	Возврат ВариантОтчета;
	
КонецФункции 

// Обработчик события возникающего при оповещении данной формы о прекращении работы подчиненной в контексте сервера.
//
// Параметры:
//  РезультатВыполнения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  Параметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура ПробитьЧекЗавершениеФР(РезультатВыполнения, Параметры) Экспорт
	
	//// Определим структуру параметров обработки текущего события
	ПараметрыОперации = Новый Структура();
	ПараметрыОперации.Вставить("ТипИнкассации",?(Объект.ХозОперация = ПредопределенноеЗначение("Справочник.ХозОперации.ВнесениеВКассуККМ"),1,0));
	ПараметрыОперации.Вставить("Сумма",Объект.СуммаДокумента);
	ПараметрыОперации.Вставить("ДокументОснование" , Объект.Ссылка);
	Кассир = "";
	ИННКассира = "";
	МенеджерОборудованияВызовСервераПереопределяемый.ТекущийКассир(Кассир, ИННКассира);
	ПараметрыОперации.Вставить("Кассир", Кассир);
	ПараметрыОперации.Вставить("КассирИНН", ИННКассира);
	Параметры.Вставить("ПараметрыВыбранногоЭТ", РезультатВыполнения);

	Оповещение = Новый ОписаниеОповещения("НапечататьЧекКлиентИнкассацияЗавершение", ЭтотОбъект, Параметры);
	ОборудованиеЧекопечатающиеУстройстваКлиент.НачатьИнкассациюНаФискальномУстройстве(
		Оповещение,
		УникальныйИдентификатор,
		Объект.ФР,
		ПараметрыОперации
	);
	
КонецПроцедуры

// Обработчик события возникающего при оповещении данной формы о прекращении работы подчиненной в контексте сервера.
//
// Параметры:
//  РезультатВыполнения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ПараметрыОперации - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура НапечататьЧекКлиентИнкассацияЗавершение(РезультатВыполнения, ПараметрыОперации) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр("ru = 'При операции внесения/выемки произошла ошибка.
		|Дополнительное описание: %ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	// Для фиксации пробития чека
	Объект.ДатаФР = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	Если НЕ УправлениеДиалогомВызовСервера.ЗаписатьОбъект(Объект, ИСТИНА) Тогда
		ВывестиСообщение(НСтр("ru='Не удалось записать сведения о фискальных реквизитах в документ %1. Необходимо вручную внести данные в документ: номер чека - %2, дата чека - %3, номер смены - %4, номер документа - %5'"), Объект, "НомерЧека",,, Объект.Ссылка, Объект.НомерЧека, Объект.ДатаФР, Объект.НомерСмены, Объект.НомерДокумента);
	КонецЕсли;
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = НСтр("ru = 'Операция выполнена успешно.'");
	Сообщение.Сообщить();
	
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

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
//@skip-warning
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

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
	
	УправлениеДиалогомДокументаСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
	ТипыОплат = Новый Массив;
	ТипыОплат.Добавить(Перечисления.ТипыОплатыККТ.Электронно);
	ТипыОплат.Добавить(Перечисления.ТипыОплатыККТ.Наличные);
	УправлениеДиалогомСервер.ОбновитьПараметрВыбора(Элементы.ОплатыТипОплаты.ПараметрыВыбора, "Отбор.Ссылка", ТипыОплат);

КонецПроцедуры 

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	// Вызываем общий обработчик действия
	УправлениеДиалогомДокументаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
	Если Объект.ХозОперация=Справочники.ХозОперации.ВнесениеВКассуККМ Тогда
		Элементы.ПлатежнаяСистема.Доступность                      = Ложь;
		Элементы.ДоговорВзаиморасчетовПлатежнаяСистема.Доступность = Ложь;
	ИначеЕсли Объект.ХозОперация=Справочники.ХозОперации.ИзъятиеИзКассыККМ Тогда
		Элементы.ПлатежнаяСистема.Доступность                      = Истина;
		Элементы.ДоговорВзаиморасчетовПлатежнаяСистема.Доступность = Истина;
	КонецЕсли;
	
	Элементы.ФормаПробитьЧек.Доступность = НЕ ЗначениеЗаполнено(Объект.ДатаФР);
	
	ОбновитьИндикациюОстаткаДСВКассе();
	ВывестиЗаголовокВзаиморасчеты();
	
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