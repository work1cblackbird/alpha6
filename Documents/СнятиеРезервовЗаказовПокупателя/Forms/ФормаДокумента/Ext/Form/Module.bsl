﻿///////////////////////////////////////////////////////////////////////////////
// Модуль основной формы документа "Снятие резервов заказов покупателя"
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
	ОписаниеНовойКолонкиПроизводитель.ПоставитьПеред = Элементы.ТоварыАртикул;
	НоваяКолонкаПроизводитель = РаботаСФормой.НоваяКолонкаПроизводитель(ЭтотОбъект, ОписаниеНовойКолонкиПроизводитель);
	
	КолонкиКодАртикулИПроизводитель = Новый Структура();
	КолонкиКодАртикулИПроизводитель.Вставить("Код", Элементы.ТоварыКод);
	КолонкиКодАртикулИПроизводитель.Вставить("Артикул", Элементы.ТоварыАртикул);
	КолонкиКодАртикулИПроизводитель.Вставить("Производитель", НоваяКолонкаПроизводитель);
	РаботаСФормой.НастроитьВидимостьКолонокКодАртикулИПроизводитель(КолонкиКодАртикулИПроизводитель);
	РаботаСФормой.ОткрытьФормуТолькоДляПросмотра(ЭтотОбъект, Объект);
	
	Если Объект.КорректировкаЗаказа <> Неопределено Тогда
		Объект.КорректировкаЗаказа = Объект.КорректировкаЗаказа ИЛИ ПолучитьЗначениеПараметраСтруктуры(Параметры, "КорректировкаЗаказа", Ложь);
	Иначе
		Объект.КорректировкаЗаказа = ПолучитьЗначениеПараметраСтруктуры(Параметры, "КорректировкаЗаказа", Ложь);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		НастроитьПараметрыВыбораЭлементовФормы();
		УправлениеДиалогомНаСервере();
		УправлениеДиалогомПриСменеХозОперации();
		РаботаСФормой.ЗаполнитьСлужебныеРеквизитыТоваров(Объект.Товары);
		
		РазрешениеСнятияРезервов = ПраваИНастройкиПользователя.Значение("РазрешениеСнятияРезервов", Объект);
		Если РазрешениеСнятияРезервов = Перечисления.РезервыСпособыСписания.Запрещено Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Запрещено снимать резервы.'"));
		ИначеЕсли РазрешениеСнятияРезервов = Перечисления.РезервыСпособыСписания.РазрешеноРезервыИзСвободногоЗапаса Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Разрешено снимать только резерв из свободных запасов.'"));
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыДокумента = ОбщиеПараметрыДокументов.СформироватьПредставлениеПараметровДокумента(Объект);

КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// Штрихкодирование
	ШтрихкодированиеКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец Штрихкодирование
	
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
	
    РаботаСФормой.ЗаполнитьСлужебныеРеквизитыТоваров(Объект.Товары);
    РаботаСФормой.УстановитьВидимостьКолонкиХарактеристика(ЭтотОбъект, Объект);
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	УправлениеДиалогомПриСменеХозОперации();
	
КонецПроцедуры 

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	РаботаСФормойКлиент.ЗамерВремениЗапись("СнятиеРезервовЗаказовПокупателя", ПараметрыЗаписи.РежимЗаписи,
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
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
		
КонецПроцедуры 

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	РаботаСФормой.ЗаполнитьСлужебныеРеквизитыТоваров(Объект.Товары);
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
	// Обновляем отображение элементов формы
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ДатаПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.СнятиеРезервовЗаказовПокупателя.ДатаПриИзменении(Объект, ПараметрыДействия);
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииНаСервере();
	
КонецПроцедуры 

&НаСервере
Процедура ХозОперацияПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.СнятиеРезервовЗаказовПокупателя.ХозОперацияПриИзменении(Объект, ПараметрыДействия);
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	УправлениеДиалогомПриСменеХозОперации();
	
КонецПроцедуры 

&НаКлиенте
Процедура ХозОперацияПриИзменении(Команда)
	
	Если ((Объект.ХозОперация = ПредопределенноеЗначение("Справочник.ХозОперации.СнятиеРезерваВнутреннего")
			И Команда.Имя = "ХозОперацияСнятиеРезерваПокупателя")
		ИЛИ (Объект.ХозОперация = ПредопределенноеЗначение("Справочник.ХозОперации.СнятиеРезерваПокупателя")
			И Команда.Имя = "ХозОперацияСнятиеРезерваВнутреннего")) Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИмяКоманды", Команда.Имя);
		// Описание оповещения
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаРезультатаВопросПриСменеХозОперации", ЭтотОбъект, ДополнительныеПараметры);
		// Зададим вопрос пользователю
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Табличная часть и документ основание будут очищены. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
	Иначе
		// Вызываем общий обработчик события выбора одного из пунктов меню доступных хоз. операций.
		УправлениеДиалогомДокументаКлиент.ОбработатьВыборХозОперации(Объект, Элементы, Команда.Имя);
		ХозОперацияПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	Документы.СнятиеРезервовЗаказовПокупателя.КонтрагентПриИзменении(Объект, ПараметрыДействия);
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	КонтрагентПриИзмененииНаСервере();
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаСервере
Процедура ТоварыПослеУдаленияНаСервере(ПараметрыДействия = Неопределено)
	
	УправлениеДиалогомДокументаСервер.ТоварыПослеУдаления(ЭтотОбъект, Элементы.Товары);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	ТоварыПослеУдаленияНаСервере();
	
КонецПроцедуры 

#Область ОбработчикиСобытийПолейТаблицыФормыТовары

&НаСервере
Процедура ТоварыНоменклатураПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	Документы.СнятиеРезервовЗаказовПокупателя.ТоварыНоменклатураПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	УправлениеДиалогомДокументаСервер.НоменклатураПриИзменении(ЭтотОбъект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТоварыНоменклатураПриИзмененииНаСервере();
	
КонецПроцедуры 

&НаСервере
Процедура ТоварыХарактеристикаНоменклатурыПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	Документы.СнятиеРезервовЗаказовПокупателя.ТоварыХарактеристикаНоменклатурыПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ТоварыХарактеристикаНоменклатурыПриИзменении(Элемент)
	
	ТоварыХарактеристикаНоменклатурыПриИзмененииНаСервере();
	
КонецПроцедуры 

&НаСервере
Процедура ТоварыЕдиницаИзмеренияПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	Документы.СнятиеРезервовЗаказовПокупателя.ТоварыЕдиницаИзмеренияПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ТоварыЕдиницаИзмеренияПриИзменении(Элемент)
	
	ТоварыЕдиницаИзмеренияПриИзмененииНаСервере();
	
КонецПроцедуры 

&НаСервере
Процедура ТоварыКоличествоПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	Документы.СнятиеРезервовЗаказовПокупателя.ТоварыКоличествоПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ТоварыКоличествоПриИзмененииНаСервере();
	
КонецПроцедуры 

&НаСервере
Процедура ТоварыМестоРазмещенияПриИзмененииНаСервере(ПараметрыДействия = Неопределено)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	Документы.СнятиеРезервовЗаказовПокупателя.ТоварыМестоРазмещенияПриИзменении(Объект, ТекущиеДанные, ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ТоварыМестоРазмещенияПриИзменении(Элемент)
	
	ТоварыМестоРазмещенияПриИзмененииНаСервере();
	
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
Процедура ПодборНоменклатуры(Команда)
	
	ПараметрыДействия = Новый Структура();
	ПараметрыДействия.Вставить("НеУстанавливатьОтборНаОстаток", Истина);
	УправлениеДиалогомКлиент.ОткрытьПодборНоменклатуры(ЭтотОбъект,,,,, ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПодборПоЗаказам(Команда)
	
	Отборы = Новый Соответствие;
	Отборы.Вставить("Контрагент"                 , Объект.Контрагент);
	Отборы.Вставить("Заказ.ПодразделениеКомпании", Объект.ПодразделениеКомпании);
	
	ИспользоватьЗаказыПокупателей =
		(Объект.ХозОперация = ПредопределенноеЗначение("Справочник.ХозОперации.СнятиеРезерваПокупателя"));
	
	ИспользоватьЗаказыВнутренние  =
		(Объект.ХозОперация = ПредопределенноеЗначение("Справочник.ХозОперации.СнятиеРезерваВнутреннего"));
	
	УправлениеДиалогомКлиент.ОткрытьПодборПоЗаказам(ЭтотОбъект,
		"СКД_ПоУмолчанию",
		Отборы,
		"Резерв",
		ИспользоватьЗаказыПокупателей,
		ИспользоватьЗаказыВнутренние);
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаРезультатаВопросПриСменеХозОперации(РезультатОповещения, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатОповещения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РезультатОповещения = КодВозвратаДиалога.Да Тогда
		Объект.Товары.Очистить();
		Объект.ДокументОснование = Неопределено;

		УправлениеДиалогомДокументаКлиент.ОбработатьВыборХозОперации(Объект, Элементы, ДополнительныеПараметры.ИмяКоманды);
		ХозОперацияПриИзмененииНаСервере();
	КонецЕсли;
	
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
// Конец Ядро

#КонецОбласти

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	
	УправлениеДиалогомДокументаСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры 

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	// Вызываем общий обработчик действия.
	УправлениеДиалогомДокументаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
	Если Объект.ХозОперация = Справочники.ХозОперации.СнятиеРезерваПокупателя Тогда
		Если Не Элементы.Найти("ТоварыЗаказПокупателя")=Неопределено Тогда
			УправлениеДиалогомСервер.УдалитьПараметрВыбора(Элементы.ТоварыЗаказПокупателя.ПараметрыВыбора, "Отбор.ПодразделениеПолучатель");
			Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
				УправлениеДиалогомСервер.ОбновитьПараметрВыбора(Элементы.ТоварыЗаказПокупателя.ПараметрыВыбора, "Отбор.Контрагент", Объект.Контрагент);
			КонецЕсли;
		КонецЕсли;
		
		Элементы.Контрагент.Заголовок = "Контрагент";
		Элементы.Контрагент.Подсказка = НСтр("ru = 'Покупатель, чьи заказы снимаются с резерва'");
	ИначеЕсли Объект.ХозОперация = Справочники.ХозОперации.СнятиеРезерваВнутреннего Тогда
		Если Не Элементы.Найти("ТоварыЗаказПокупателя")=Неопределено Тогда
			УправлениеДиалогомСервер.УдалитьПараметрВыбора(Элементы.ТоварыЗаказПокупателя.ПараметрыВыбора, "Отбор.Контрагент");
			Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
				УправлениеДиалогомСервер.ОбновитьПараметрВыбора(Элементы.ТоварыЗаказПокупателя.ПараметрыВыбора, "Отбор.ПодразделениеПолучатель", Объект.Контрагент);
			КонецЕсли;
		КонецЕсли;
		
		Элементы.Контрагент.Заголовок = "Подразделение";
		Элементы.Контрагент.Подсказка = НСтр("ru = 'Подразделение компании, чьи заказы снимаются с резерва'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
 
	УправлениеДиалогомДокументаСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	УправлениеДиалогомДокументаСервер.УстановитьУсловноеОформлениеРучногоСписанияХарактеристик(ЭтотОбъект);
	
КонецПроцедуры 

&НаСервере
Процедура ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры=Неопределено)
	
	Если НЕ УправлениеДиалогомДокументаСервер.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры = "ПодборПоСпискуЗаказанного" И ЭтоАдресВременногоХранилища(РезультатОповещения) Тогда
		ПодобранныеТовары = ПолучитьИзВременногоХранилища(РезультатОповещения);
		
		УсловиеПоиска = Новый Структура("Номенклатура,ХарактеристикаНоменклатуры,ЕдиницаИзмерения");
		Для Каждого Строка Из ПодобранныеТовары Цикл
			ЗаполнитьЗначенияСвойств(УсловиеПоиска, Строка);
			
			ПараметрыДействия = Новый Структура;
			
			ПодходящиеСтроки = Объект.Товары.НайтиСтроки(УсловиеПоиска);
			Если ПодходящиеСтроки.Количество() = 0 Тогда
				НоваяСтрока = Объект.Товары.Добавить();
				
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка, "Номенклатура,ХарактеристикаНоменклатуры,ЕдиницаИзмерения,Количество,Коэффициент");
				НоваяСтрока.ЗаказПокупателя = Строка.Заказ;
				
				Документы.СнятиеРезервовЗаказовПокупателя.ТоварыНоменклатураПриИзменении(Объект, НоваяСтрока, ПараметрыДействия);
				
				// Вызываем общий обработчик изменения реквизитов формы
				УправлениеДиалогомДокументаСервер.НоменклатураПриИзменении(ЭтотОбъект, НоваяСтрока, ПараметрыДействия);
			Иначе
				НоваяСтрока = ПодходящиеСтроки[0];
				НоваяСтрока.Количество = НоваяСтрока.Количество + Строка.Количество;
				
				Документы.СнятиеРезервовЗаказовПокупателя.ТоварыКоличествоПриИзменении(Объект, НоваяСтрока, ПараметрыДействия);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаОповещения(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	// Вызываем общий обработчик события в контексте клиента
	Если НЕ УправлениеДиалогомДокументаКлиент.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли;
	// Обработаем изменение документа основания из формы параметров
	Если ТипЗнч(РезультатОповещения) = Тип("Структура") И РезультатОповещения.Свойство("ИзмененныеРеквизиты") И РезультатОповещения.ИзмененныеРеквизиты.Свойство("ДокументОснование") Тогда
		Если Не Объект.ХозОперация = ПредопределенноеЗначение("Справочник.ХозОперации.СнятиеРезерваВнутреннего") И ТипЗнч(РезультатОповещения.ИзмененныеРеквизиты.ДокументОснование) = Тип("ДокументСсылка.ЗаказВнутренний") Тогда
			Объект.ХозОперация = ПредопределенноеЗначение("Справочник.ХозОперации.СнятиеРезерваВнутреннего");
			
			Команда = Новый Структура();
			Команда.Вставить("Имя", "ХозОперацияСнятиеРезерваВнутреннего");
			
			ХозОперацияПриИзменении(Команда);
		ИначеЕсли Не Объект.ХозОперация = ПредопределенноеЗначение("Справочник.ХозОперации.СнятиеРезерваПокупателя") И ТипЗнч(РезультатОповещения.ИзмененныеРеквизиты.ДокументОснование) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
			Объект.ХозОперация = ПредопределенноеЗначение("Справочник.ХозОперации.СнятиеРезерваПокупателя");
			
			Команда = Новый Структура();
			Команда.Вставить("Имя", "ХозОперацияСнятиеРезерваПокупателя");
			
			ХозОперацияПриИзменении(Команда);
		КонецЕсли;
	КонецЕсли;
	
	ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры);
	ОбработкаРезультатаВыполненияДействия(РезультатОповещения);
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаРезультатаВыполненияДействия(ПараметрыДействия)
	
	ОбработкаРеквизитовДокументаКлиент.ПолучитьРазрешенияДляПересчета(ЭтотОбъект, ПараметрыДействия);
	УправлениеДиалогомДокументаКлиент.ОбработкаРезультатаВыполненияДействия(ЭтотОбъект, ПараметрыДействия);
	
КонецПроцедуры 

&НаСервере
Процедура УправлениеДиалогомПриСменеХозОперации()
	
	Если Объект.ХозОперация = Справочники.ХозОперации.СнятиеРезерваПокупателя Тогда
		Элементы.Контрагент.ОграничениеТипа            = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
		Элементы.ТоварыЗаказПокупателя.ОграничениеТипа = Новый ОписаниеТипов("ДокументСсылка.ЗаказПокупателя");
	ИначеЕсли Объект.ХозОперация = Справочники.ХозОперации.СнятиеРезерваВнутреннего Тогда
		Элементы.Контрагент.ОграничениеТипа            = Новый ОписаниеТипов("СправочникСсылка.ПодразделенияКомпании");
		Элементы.ТоварыЗаказПокупателя.ОграничениеТипа = Новый ОписаниеТипов("ДокументСсылка.ЗаказВнутренний");
	КонецЕсли;
	
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