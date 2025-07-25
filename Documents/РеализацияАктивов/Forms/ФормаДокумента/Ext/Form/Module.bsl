﻿///////////////////////////////////////////////////////////////////////////////
// Модуль основной формы документа "Реализация активов"
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
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	НалоговыйДокумент = ЗащищенныеФункцииСервер.УстановитьЗаголовокНадписиНалоговыйДокумент(ЭтотОбъект, Объект);
	
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
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ИмяЭлементаКоманднойПанели", "ГлобальныеКоманды");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// УтверждениеДокументов
	УтверждениеДокументовСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	// Конец УтверждениеДокументов
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументовАльфаАвто.ПриСозданииНаСервере_ФормаДокумента(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
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
		Для каждого ТекущаяСтрока Из Объект.Активы Цикл
			ТекущаяСтрока.Количество = 0;
		КонецЦикла;
		
		ОбработкаТабличнойЧастиАктивы.ЗаполнитьСлужебныеРеквизиты(Объект);
		
		Для каждого ТекущаяСтрока Из Объект.Активы Цикл
			Если ТекущаяСтрока.Количество = 0 Тогда
				Объект.Активы.Удалить(Объект.Активы.Индекс(ТекущаяСтрока));
			Иначе
				Документы.РеализацияАктивов.АктивыПрочийАктивПриИзменении(Объект, ТекущаяСтрока);
			КонецЕсли;
		КонецЦикла;
		
		РасчетыСКонтрагентамиСервер.ЗаполнитьСлужебныйРеквизитОстатокПоДокументуОплаты(Объект);
		
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
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
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
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ПараметрыДействия = Новый Структура;
	ОбработкаВыбораНаСервере(ВыбранноеЗначение, ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// Штрихкодирование
	ШтрихкодированиеКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец Штрихкодирование
	
	// УтверждениеДокументов
	УтверждениеДокументовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец УтверждениеДокументов
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументовКлиент.ОбработчикОповещенияФормаДокумента(ИмяСобытия,ЭтотОбъект);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
	РаботаСФормойКлиент.ТребуетсяОбновитьЗаголовокНадписиНалоговыйДокумент(ЭтотОбъект, ИмяСобытия);
	
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
	
	РасчетыСКонтрагентамиСервер.ЗаполнитьСлужебныйРеквизитОстатокПоДокументуОплаты(Объект);
	
	ОбработкаТабличнойЧастиАктивы.ЗаполнитьСлужебныеРеквизиты(Объект);
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
	НалоговыйДокумент = ЗащищенныеФункцииСервер.УстановитьЗаголовокНадписиНалоговыйДокумент(ЭтотОбъект, Объект);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	РаботаСФормойКлиент.ЗамерВремениЗапись("РеализацияАктивов", ПараметрыЗаписи.РежимЗаписи,
		Объект.Активы.Количество() > 50);
		
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
	
	Если НЕ ЭтотОбъект.Элементы.Найти("НадписьНалоговыйДокумент") = Неопределено Тогда
		ЭтотОбъект.НалоговыйДокумент = ЗащищенныеФункцииСервер.УстановитьЗаголовокНадписиНалоговыйДокумент(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли; 
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	РасчетыСКонтрагентамиСервер.ЗаполнитьСлужебныйРеквизитОстатокПоДокументуОплаты(Объект);
	
	ОбработкаТабличнойЧастиАктивы.ЗаполнитьСлужебныеРеквизиты(Объект);
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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
	// Обновляем отображение элементов формы
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ДатаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.РеализацияАктивов.ДатаПриИзменении(Объект, ПараметрыДействия);
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
	
	Документы.РеализацияАктивов.ХозОперацияПриИзменении(Объект, ПараметрыДействия);

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
	
	Документы.РеализацияАктивов.КонтрагентПриИзменении(Объект, ПараметрыДействия);
	
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
	
	Документы.РеализацияАктивов.ДоговорВзаиморасчетовПриИзменении(Объект, ПараметрыДействия);
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ДоговорВзаиморасчетовПриИзменении(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ДоговорВзаиморасчетовПриИзмененииНаСервере(ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура СпособЗачетаАвансовПриИзменении(Элемент)
	
	СпособЗачетаАвансовПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СпособЗачетаАвансовПриИзмененииНаСервере()
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАктивы

&НаКлиенте
Процедура АктивыПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.Активы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		Элементы.АктивыСоздатьПодтверждающийДокумент.Доступность = ПроверитьПрочийАктив(ТекущиеДанные.ПрочийАктив); 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АктивыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УправлениеДиалогомДокументаКлиент.ТоварыПриОкончанииРедактирования(ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования, "Активы");
	
КонецПроцедуры 

&НаСервере
Процедура АктивыПослеУдаленияНаСервере(ПараметрыДействия = Неопределено)
	
	УправлениеПрочимиАктивами.АктивыПослеУдаления(ЭтотОбъект, Элементы.Активы);
	
КонецПроцедуры 

&НаКлиенте
Процедура АктивыПослеУдаления(Элемент)
	
	АктивыПослеУдаленияНаСервере(); 
	
	ТекущиеДанные = Элементы.Активы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Элементы.АктивыСоздатьПодтверждающийДокумент.Доступность = Ложь; 
	КонецЕсли;

КонецПроцедуры 

#Область ОбработчикиСобытийПолейТаблицыФормыАктивы

&НаСервере
Процедура АктивыПрочийАктивПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Активы.НайтиПоИдентификатору(Элементы.Активы.ТекущаяСтрока);
	Документы.РеализацияАктивов.АктивыПрочийАктивПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура АктивыПрочийАктивПриИзменении(Элемент)
	
	АктивыПрочийАктивПриИзмененииНаСервере();
	
	ТекущиеДанные = Элементы.Активы.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда 
		Элементы.АктивыСоздатьПодтверждающийДокумент.Доступность = ПроверитьПрочийАктив(ТекущиеДанные.ПрочийАктив); 
	КонецЕсли;

КонецПроцедуры 

&НаСервере
Процедура АктивыСуммаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Активы.НайтиПоИдентификатору(Элементы.Активы.ТекущаяСтрока);
	Документы.РеализацияАктивов.АктивыСуммаПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура АктивыСуммаПриИзменении(Элемент)
	
	АктивыСуммаПриИзмененииНаСервере();
	
КонецПроцедуры 

&НаСервере
Процедура АктивыСтавкаНДСПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Активы.НайтиПоИдентификатору(Элементы.Активы.ТекущаяСтрока);
	Документы.РеализацияАктивов.АктивыСтавкаНДСПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура АктивыСтавкаНДСПриИзменении(Элемент)
	
	АктивыСтавкаНДСПриИзмененииНаСервере();
	
КонецПроцедуры 


#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийПолейТаблицыФормыЗачетАвансов

&НаСервере
Процедура ЗачетАвансовДокументАвансаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.ЗачетАвансов.НайтиПоИдентификатору(Элементы.ЗачетАвансов.ТекущаяСтрока);
	Документы.РеализацияАктивов.ЗачетАвансовДокументАвансаПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗачетАвансовДокументАвансаПриИзменении(Элемент)
	
	ЗачетАвансовДокументАвансаПриИзмененииНаСервере();
	
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
Процедура ПодборАвансов(Команда)
	
	УправлениеДиалогомКлиент.ОткрытьПодборАвансов(ЭтотОбъект,,, Объект.Активы.Итог("Сумма"));
	
КонецПроцедуры

&НаСервере
Процедура СоздатьПодтверждающийДокументНаСервере()
	 
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПодтверждающийДокумент(Команда) 
	ТекущиеДанные = Элементы.Активы.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено И ЭтоАвтомобиль(ТекущиеДанные.ПолучитьИдентификатор()) Тогда  
		
		ПараметрыФормы = ПолучитьПараметрыЗаполнения(ТекущиеДанные.ПолучитьИдентификатор()); 
		Если ПараметрыФормы.Свойство("Владелец") Тогда
			ОткрытьФорму("Справочник.ПодтверждающиеДокументы.ФормаОбъекта", ПараметрыФормы);
		Иначе 
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(НСтр("ru = 'Для Актива %1 не найден автомобиль'"), ТекущиеДанные.Актив));
		КонецЕсли;
	Иначе 
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выберите автомобиль для создания документа ПТС.'"));	
	КонецЕсли; 
	СоздатьПодтверждающийДокументНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЭтоАвтомобиль(ИдентификаторСтроки)
	
    Строка = Объект.Активы.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если Строка <> Неопределено И  Строка.ПрочийАктив.Номенклатура = Справочники.Номенклатура.Автомобиль Тогда 	
		
		Возврат Истина;
				
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПроверитьПрочийАктив(ПрочийАктив)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПрочиеАктивы.Номенклатура КАК Номенклатура
		|ИЗ
		|	Справочник.ПрочиеАктивы КАК ПрочиеАктивы
		|ГДЕ
		|	ПрочиеАктивы.Номенклатура = &Автомобиль
		|	И ПрочиеАктивы.Ссылка = &Актив";
	
	Запрос.УстановитьПараметр("Автомобиль", Справочники.Номенклатура.Автомобиль);
	Запрос.УстановитьПараметр("Актив", ПрочийАктив);
	
	РезультатЗапроса = Запрос.Выполнить(); 
	
	Если Не РезультатЗапроса.Пустой() Тогда 
		
		Возврат Истина;    
		
	КонецЕсли;

	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция ПолучитьПараметрыЗаполнения(ИдентификаторСтроки)
	
	ПараметрыЗаполнения = Новый Структура();
	
	ПараметрыЗаполнения.Вставить("ВидПодтверждающегоДокумента", Перечисления.ВидыДокументов.ПТС);
	
	Строка = Объект.Активы.НайтиПоИдентификатору(ИдентификаторСтроки);  
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВводВЭксплуатациюАвтомобилейАвтомобили.Автомобиль КАК Автомобиль
		|ИЗ
		|	Документ.ВводВЭксплуатациюАвтомобилей.Автомобили КАК ВводВЭксплуатациюАвтомобилейАвтомобили
		|ГДЕ
		|	ВводВЭксплуатациюАвтомобилейАвтомобили.Актив = &Актив";
	
		Запрос.УстановитьПараметр("Актив", Строка.ПрочийАктив);  
		РезультатЗапроса = Запрос.Выполнить();

	Если Не  РезультатЗапроса.Пустой() Тогда 
			
        Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();  
	
		ПараметрыЗаполнения.Вставить("ВидПодтверждающегоДокумента", Перечисления.ВидыДокументов.ПТС);	
		ПараметрыЗаполнения.Вставить("Владелец", Выборка.Автомобиль);  
		ПараметрыЗаполнения.Вставить("ВалютаДокумента", Объект.ВалютаДокумента);
		ПараметрыЗаполнения.Вставить("СуммаДокумента", Строка.Сумма);
		ПараметрыЗаполнения.Вставить("Контрагент",  Объект.Контрагент);
		
		ДокументДоверенности = Справочники.ПодтверждающиеДокументы.ПолучитьПодтверждающийДокументОбъектаПоВиду(
			Объект.Контрагент,
			Перечисления.ВидыДокументов.Паспорт); 
		ПараметрыЗаполнения.Вставить("ДокументДоверенности", ДокументДоверенности);


	КонецЕсли;
	
	Возврат ПараметрыЗаполнения; 

КонецФункции
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

&НаКлиенте
Процедура Подключаемый_ДекорацияСостояниеОригиналаНажатие()
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументовКлиент.ОткрытьМенюВыбораСостояния(ЭтотОбъект, Элементы.ДекорацияСостояниеОригинала);
	//Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

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

// СчетаФактуры
&НаКлиенте
Процедура НадписьНалоговыйДокументНажатие(Элемент)
	
	УправлениеДиалогомДокументаКлиент.НадписьНалоговыйДокументНажатие(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВзаиморасчетыНажатие(Элемент)
	
	УправлениеДиалогомДокументаКлиент.НадписьВзаиморасчетыНажатие(ЭтотОбъект);
	
КонецПроцедуры
// Конец СчетаФактуры

#КонецОбласти

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	
	УправлениеДиалогомДокументаСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	УправлениеДиалогомДокументаСервер.РасставитьСвязиПараметровВыбораДокументовАванса(ЭтотОбъект);
	
КонецПроцедуры 

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	УправлениеДиалогомДокументаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
КонецПроцедуры 

&НаСервере
Процедура УстановитьУсловноеОформление()
 
	// Только просмотр
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.АктивыКоличество.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Активы.УникальныйНомер");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.АктивыСуммаСписания.Имя);
	
	ГруппаОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТоварыСуммаВсегоТолькоПросмотр");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Активы.Количество");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
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

&НаКлиенте
Процедура НадписьРеквизитыПечатиНажатие(Элемент)
	
	УправлениеПечатьюКлиентАльфаАвто.ОткрытьФормуРедактированияРеквизитовДоставки(ЭтотОбъект); 
	
КонецПроцедуры

#КонецОбласти

#Область Штрихкодирование

&НаКлиенте
Процедура Подключаемый_ШтрихкодированиеОбработкаОповещения(РезультатОповещения,
		ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатОповещения.Свойство("Действие") И ЗначениеЗаполнено(РезультатОповещения.Действие) Тогда
		ШтрихкодированиеОбработкаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ШтрихкодированиеОбработкаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры)
	
	ШтрихкодированиеВызовСервера.ОбработкаОповещения(
		ЭтотОбъект,
		РезультатОповещения,
		ДополнительныеПараметры,
		"Активы",
		Объект
	);
	
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

&НаКлиенте
Процедура Подключаемый_ОбновитьЗаголовокНадписиНалоговыйДокумент(РезультатОповещения, ДополнительныеПараметры) Экспорт
	
	ОбновитьЗаголовокНадписиНалоговыйДокументНаСервере();
	
КонецПроцедуры

Процедура ОбновитьЗаголовокНадписиНалоговыйДокументНаСервере()
	
	РаботаСФормойВызовСервера.ОбновитьЗаголовокНадписиНалоговыйДокумент(ЭтотОбъект, Объект);
	
КонецПроцедуры

#КонецОбласти