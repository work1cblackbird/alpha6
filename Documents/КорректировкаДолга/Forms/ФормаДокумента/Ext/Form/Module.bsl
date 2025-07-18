﻿///////////////////////////////////////////////////////////////////////////////
// Модуль основной формы документа "Корректировка долга"
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
	РаботаСФормой.ОткрытьФормуТолькоДляПросмотра(ЭтотОбъект, Объект);
	
	ЗаполнениеРазницыИВалюты();
	
	ТипыДляРасчетныхДокументов = РасчетыСКонтрагентамиСервер.ДоступныеТипыДокументовРасчета();
	ТипыДляСделок = Новый ОписаниеТипов(ПланыВидовХарактеристик.ТипыСделок.ПолучитьРазрешенныеТипыСделок(Ложь, Ложь));
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьСлужебныеРеквизиты();
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
	
	ЗаполнитьСлужебныеРеквизиты();
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	РаботаСФормойКлиент.ЗамерВремениЗапись("КорректировкаДолга", ПараметрыЗаписи.РежимЗаписи, Ложь);
		
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
	
	ЗаполнитьСлужебныеРеквизиты();
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	ЗаполнениеРазницыИВалюты();
	
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
	
	Документы.КорректировкаДолга.ДатаПриИзменении(Объект, ПараметрыДействия);

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
	
	Документы.КорректировкаДолга.ХозОперацияПриИзменении(Объект, ПараметрыДействия);
	
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
Процедура КонтрагентПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
			
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ВалютаУпр = Константы.ВалютаРегламентированногоУчетаОрганизаций.Получить();
		
		Отбор = Новый Структура("Контрагент", Объект.Контрагент);
		Долги = РасчетыСКонтрагентамиСервер.ВзаиморасчетыСКонтрагентомПоОтбору(
			Отбор,,
			"СуммаУпр,СуммаБаз",
			Перечисления.СпособыВеденияУчетаВзаиморасчетов.ПоРасчетнымДокументам);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
			РасчетыСКонтрагентамиСервер.ВзаиморасчетыСКонтрагентомПоОтбору(
				Отбор,,
				"СуммаУпр,СуммаБаз",
				Перечисления.СпособыВеденияУчетаВзаиморасчетов.ПоСделкам),
			Долги);
		
		Если Объект.ВалютаДокумента = ВалютаУпр Тогда
			Долг = Долги.Итог("СуммаБаз");
		Иначе
			Долг = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(Долги.Итог("СуммаУпр"), ВалютаУпр, Объект.Дата, Объект.ВалютаДокумента, Объект.Дата);
		КонецЕсли;
		// выведем на экран этот долг
		ДолгТекст = Формат(Долг,"ЧЦ=15; ЧДЦ=2; ЧН=0.00");
		Элементы.Контрагент.РасширеннаяПодсказка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Долг контрагента составляет %1 %2'"), ДолгТекст, УправлениеПечатьюПлатформа.ПолучитьНаименованиеСправочника(Объект.ВалютаДокумента));
	Иначе
		Элементы.Контрагент.РасширеннаяПодсказка.Заголовок = НСтр("ru = '<Контрагент не выбран>'");
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	КонтрагентПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия); 
	
КонецПроцедуры 

#Область ОбработчикиСобытийЭлементовУправленияОбщегоНазначения

&НаКлиенте
Процедура НадписьВзаиморасчетыНажатие(Элемент)
	
	Если (Не ЗначениеЗаполнено(Объект.Контрагент)) Тогда
		Возврат;
	КонецЕсли;
	// фильтры
	Отбор = Новый Структура;
	Отбор.Вставить("Контрагент",Объект.Контрагент);
	ОтчетыПлатформаКлиент.ОткрытьОтчет("Отчет.ВзаиморасчетыСКонтрагентом", "ВзаиморасчетыКомпании",,,, Отбор, , ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры 

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостав

&НаСервереБезКонтекста
Функция СоставПриОкончанииРедактированияНаСервере(ДоговорВзаиморасчетов)
	
	Возврат ДоговорВзаиморасчетов.ВалютаВзаиморасчетов;
	
КонецФункции 

&НаКлиенте
Процедура СоставПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УправлениеДиалогомДокументаКлиент.ТоварыПриОкончанииРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования, "Состав");
	// Получим данные текущей строки табличной части
	ТекущиеДанные = Объект.Состав.НайтиПоИдентификатору(Элементы.Состав.ТекущаяСтрока);
	ТекущиеДанные.Разница = ТекущиеДанные.УвеличениеДолга - ТекущиеДанные.УменьшениеДолга;
	ТекущиеДанные.Валюта = СоставПриОкончанииРедактированияНаСервере(ТекущиеДанные.ДоговорВзаиморасчетов);
	
КонецПроцедуры

#Область ОбработчикиСобытийПолейТаблицыФормыСостав

&НаСервере
Процедура СоставДоговорВзаиморасчетовПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Состав.НайтиПоИдентификатору(Элементы.Состав.ТекущаяСтрока);
	Документы.КорректировкаДолга.СоставДоговорВзаиморасчетовПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	ЗаполнитьСлужебныеРеквизиты();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура СоставДоговорВзаиморасчетовПриИзменении(Элемент)
	
	СоставДоговорВзаиморасчетовПриИзмененииНаСервере();
	
КонецПроцедуры 

&НаСервере
Процедура СоставСделкаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Состав.НайтиПоИдентификатору(Элементы.Состав.ТекущаяСтрока);
	Документы.КорректировкаДолга.СоставСделкаПриИзменении(Объект, ТекущиеДанные,ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура СоставСделкаПриИзменении(Элемент)
	
	СоставСделкаПриИзмененииНаСервере();

КонецПроцедуры 

&НаКлиенте
Процедура СоставСделкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрокаСостава = Элементы.Состав.ТекущиеДанные;
	
	Если ТекущаяСтрокаСостава = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элемент.ОграничениеТипа = ?(
		ТекущаяСтрокаСостава.СпособВеденияВзаиморасчетов =
			ПредопределенноеЗначение("Перечисление.СпособыВеденияУчетаВзаиморасчетов.ПоРасчетнымДокументам"),
		ТипыДляРасчетныхДокументов,
		ТипыДляСделок);
	
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Просмотр типа расчетов и заказа
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоставТипРасчета.Имя);
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоставЗаказ.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = 
		Новый ПолеКомпоновкиДанных("Объект.Состав.СпособВеденияВзаиморасчетов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СпособыВеденияУчетаВзаиморасчетов.ПоСделкам;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоставСпособЗачетаАвансов.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = 
		Новый ПолеКомпоновкиДанных("Объект.Состав.СпособВеденияВзаиморасчетов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СпособыВеденияУчетаВзаиморасчетов.ПоРасчетнымДокументам;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры 

&НаСервере
Процедура ЗаполнениеРазницыИВалюты()
	
	Для Каждого ТекущаяСтрока Из Объект.Состав Цикл
		ТекущаяСтрока.Разница = ТекущаяСтрока.УвеличениеДолга - ТекущаяСтрока.УменьшениеДолга;
		ТекущаяСтрока.Валюта  = ТекущаяСтрока.ДоговорВзаиморасчетов.ВалютаВзаиморасчетов;
	КонецЦикла;
	
КонецПроцедуры 

//@skip-warning
&НаКлиенте
Процедура ПроверкаПодразделенияДокументаИПользователяЗавершение(Контекст) Экспорт
	
	УправлениеДиалогомДокументаКлиент.НастроитьПараметрыДокумента(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизиты()
	
	ДоговораСостава = Объект.Состав.Выгрузить(, "ДоговорВзаиморасчетов");
	СпособВеденияВзаиморасчетовДоговоров = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(
		ДоговораСостава.ВыгрузитьКолонку("ДоговорВзаиморасчетов"),
		"СпособВеденияВзаиморасчетов");
	
	Для Каждого СтрокаСостава Из Объект.Состав Цикл
		
		СтрокаСостава.СпособВеденияВзаиморасчетов =
			СпособВеденияВзаиморасчетовДоговоров.Получить(СтрокаСостава.ДоговорВзаиморасчетов);
		
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
	
	// Заполнить валюту документа
	СписокДоговоров = Объект.Состав.Выгрузить().ВыгрузитьКолонку("ДоговорВзаиморасчетов");
	ВалютыДоговоров = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(СписокДоговоров, "ВалютаВзаиморасчетов");
	
	Для Каждого СтрокаСостава Из Объект.Состав Цикл
		СтрокаСостава.Валюта = ВалютыДоговоров.Получить(СтрокаСостава.ДоговорВзаиморасчетов);
	КонецЦикла;
	
	ЗаполнитьСлужебныеРеквизиты();
	УправлениеДиалогомНаСервере();
	
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

#КонецОбласти

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	
	УправлениеДиалогомДокументаСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры 

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	УправлениеДиалогомДокументаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
	Элементы.Контрагент.РасширеннаяПодсказка.ЦветТекста = ЦветаСтиля.ТекстИнформационнойНадписи;
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда 
		Элементы.Контрагент.РасширеннаяПодсказка.Заголовок= НСтр("ru = '<Контрагент не выбран>'");
	Иначе
		// Получим долг
		СтруктураОтбора=Новый Структура();
		СтруктураОтбора.Вставить("Контрагент",Объект.Контрагент);
		тзДолги = РасчетыСКонтрагентамиСервер.ВзаиморасчетыСКонтрагентомПоОтбору(
			СтруктураОтбора,,
			"Сумма,СуммаУпр",
			Перечисления.СпособыВеденияУчетаВзаиморасчетов.ПоРасчетнымДокументам);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
			РасчетыСКонтрагентамиСервер.ВзаиморасчетыСКонтрагентомПоОтбору(
				СтруктураОтбора,,
				"Сумма,СуммаУпр",
				Перечисления.СпособыВеденияУчетаВзаиморасчетов.ПоСделкам),
			тзДолги);
		Если Объект.ВалютаДокумента=Константы.ВалютаРегламентированногоУчетаОрганизаций.Получить() Тогда
			Долг=тзДолги.Итог("Сумма");
		Иначе
			Долг=РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(тзДолги.Итог("СуммаУпр"),Константы.ВалютаУправленческогоУчетаКомпании.Получить(),Объект.Дата,Объект.ВалютаДокумента,Объект.Дата);
		КонецЕсли; 
		
		Если Долг < 0 Тогда
			Элементы.Контрагент.РасширеннаяПодсказка.ЦветТекста = WebЦвета.ТемноКрасный;
		КонецЕсли;
		// Выведем на экран этот долг
		Элементы.Контрагент.РасширеннаяПодсказка.Заголовок= НСтр("ru = 'Долг контрагент'") +  ?(Долг < 0,"у","а") + " составляет: " + Формат(?(Долг < 0,-Долг,Долг),"ЧДЦ = 2; ЧН = 0,00") + " " + СокрЛП(Объект.ВалютаДокумента.Наименование);
	КонецЕсли;
	
	СоставДокумента = Объект.Состав.Выгрузить(, "ДоговорВзаиморасчетов");
	ЕстьВзаиморасчетыСДебеторомПоРасчетнымДокументам = РасчетыСКонтрагентамиСервер.ЕстьДоговорПоРасчетнымДокументам(
		СоставДокумента.ВыгрузитьКолонку("ДоговорВзаиморасчетов"));
	
	Элементы.СоставСделка.Заголовок = ?(
		ЕстьВзаиморасчетыСДебеторомПоРасчетнымДокументам,
		НСтр("ru = 'Сделка / Документ расчетов'"),
		НСтр("ru = 'Сделка'"));
	Элементы.СоставТипРасчета.Видимость = ЕстьВзаиморасчетыСДебеторомПоРасчетнымДокументам;
	Элементы.СоставЗаказ.Видимость = ЕстьВзаиморасчетыСДебеторомПоРасчетнымДокументам;
	Элементы.СоставСпособЗачетаАвансов.Видимость = РасчетыСКонтрагентамиСервер.ЕстьДоговорПоРасчетнымДокументам(
		СоставДокумента.ВыгрузитьКолонку("ДоговорВзаиморасчетов"),
		Перечисления.СпособыВеденияУчетаВзаиморасчетов.ПоСделкам);
	
КонецПроцедуры 

&НаСервере
Процедура ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры=Неопределено)
	
	Если НЕ УправлениеДиалогомДокументаСервер.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЛЕВ(ДополнительныеПараметры, 17)="КомандаЗаполнения" Тогда
		ЗаполнениеРазницыИВалюты();
	КонецЕсли;	
	
	ЗаполнитьСлужебныеРеквизиты();
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