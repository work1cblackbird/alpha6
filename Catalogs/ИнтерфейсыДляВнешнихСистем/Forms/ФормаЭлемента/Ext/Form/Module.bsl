﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы элемента справочника "Интерфейсы для внешних систем"
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
	
	РаботаСФормой.ЗаблокироватьРедактированиеПредопределенногоЭлемента(ЭтотОбъект);
	РаботаСФормой.УстановитьДоступностьПоляКодНаФормеСправочника(ЭтотОбъект, Объект);
	
	ДоступноРедактирование = ПравоДоступа("Редактирование", Объект.Ссылка.Метаданные());
	Элементы.ГруппаДополнительныеПараметрыИнтерфейса.ТолькоПросмотр = НЕ ДоступноРедактирование;
		
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СписокКлючиПараметров.ЗагрузитьЗначения(Справочники.ИнтерфейсыДляВнешнихСистем.ПолучитьКлючиПараметров());
		УправлениеДиалогомНаСервере();
	КонецЕсли;
	
	ТабУчастников = ПлатежныйШлюзСБП_1С.ПолучитьИнтегрированныхУчастниковСБП();
	
	СписокВыбора = Элементы.ИдентификаторБанкаУчастникаСБП.СписокВыбора;
	
	СписокВыбора.Очистить();
	
	Для каждого СтрокаТаб Из ТабУчастников Цикл
	
		СписокВыбора.Добавить(СтрокаТаб.ИдентификаторБанка, СтрокаТаб.НаименованиеБанка);
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если СписокКлючиПараметров.Количество() = 0 Тогда
		СписокКлючиПараметров.ЗагрузитьЗначения(Справочники.ИнтерфейсыДляВнешнихСистем.ПолучитьКлючиПараметров());	
	КонецЕсли;
	
	ОтобразитьДополнительныеПараметрыИнтерфейса();
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	РаботаСФормойКлиент.ЗамерВремениЗапись("ИнтерфейсыДляВнешнихСистем");
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	Если ТекущийОбъект.СпособАвторизации <> "" Тогда
		Справочники.ИнтерфейсыДляВнешнихСистем.СохранитьПарольИлиТокен(ТекущийОбъект.Ссылка
		, ЭтотОбъект[ТекущийОбъект.СпособАвторизации], ТекущийОбъект.СпособАвторизации);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ТипИнтерфейсаПриИзмененииНаСервере()
	
	Справочники.ИнтерфейсыДляВнешнихСистем.ТипИнтерфейсаПриИзменении(Объект);
	ОтобразитьДополнительныеПараметрыИнтерфейса();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры // ТипИнтерфейсаПриИзмененииНаСервере()

&НаКлиенте
Процедура ТипИнтерфейсаПриИзменении(Элемент)
	
	ТипИнтерфейсаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура НеИспользуетсяПриИзмененииНаСервере()
	
	Справочники.ИнтерфейсыДляВнешнихСистем.НеИспользуетсяПриИзменении(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура НеИспользуетсяПриИзменении(Элемент)
	
	НеИспользуетсяПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура НазначениеПриИзмененииНаСервере()
	
	Справочники.ИнтерфейсыДляВнешнихСистем.НазначениеПриИзменении(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура НазначениеПриИзменении(Элемент)
	
	НазначениеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СпособАвторизацииПриИзменении(Элемент)
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

#Область ЭлементыГруппыДополнительныеПараметрыИнтерфейса

// Желательно в этой области располагать обработчики в алфавитном порядке

&НаКлиенте
Процедура АдресВозвратаПослеОплатыПриИзменении(Элемент)
	
	ИзменитьПараметрИнтерфейса(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяЖизниПлатежнойСсылкиПриИзменении(Элемент)
	
	ИзменитьПараметрИнтерфейса(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторБанкаУчастникаСБППриИзменении(Элемент)
	
	ИзменитьПараметрИнтерфейса(Элемент.Имя);
	ИдентификаторБанкаУчастникаСБППриИзмененииНаСервере();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ИдентификаторБанкаУчастникаСБППриИзмененииНаСервере()
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторБанкаУчастникаСБП) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТипАутентификации = ПлатежныйШлюзСБП_1С.ПолучитьТипАутентификацииБанка(ИдентификаторБанкаУчастникаСБП);
	
	Если ТипАутентификации = Перечисления.ТипыАутентификацииСБП.BEARER Тогда
		
		Объект.СпособАвторизации = "Токен";
		
	ИначеЕсли ТипАутентификации = Перечисления.ТипыАутентификацииСБП.RESOURCE_OWNER_PASSWORD_CREDENTIALS_GRANT
		ИЛИ ТипАутентификации = Перечисления.ТипыАутентификацииСБП.BASIC Тогда
		
		Объект.СпособАвторизации = "Пароль";
		
	Иначе
		
		Объект.СпособАвторизации = "СекретныйКлюч";
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторМерчантаПриИзменении(Элемент)
	
	ИзменитьПараметрИнтерфейса(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КассаККМПриИзменении(Элемент)
	
	ИзменитьПараметрИнтерфейса(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбрабатыватьВходящиеУведомленияПриИзменении(Элемент)
	
	ИзменитьПараметрИнтерфейса(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздаватьФискальныеЧекиВДанномСервисеПриИзменении(Элемент)
	
	ИзменитьПараметрИнтерфейса(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетАвтомобилиШаблонСообщенийСМСПриИзменении(Элемент)
	
	ИзменитьПараметрИнтерфейса(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетАвтомобилиШаблонЭлектронныхПисемПриИзменении(Элемент)
	
	ИзменитьПараметрИнтерфейса(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетШаблонСообщенийСМСПриИзменении(Элемент)
	
	ИзменитьПараметрИнтерфейса(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетШаблонЭлектронныхПисемПриИзменении(Элемент)
	
	ИзменитьПараметрИнтерфейса(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ФискальныйРегистраторПриИзменении(Элемент)
	
	ИзменитьПараметрИнтерфейса(Элемент.Имя);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Поместить измененные в поле ввода (из группы "Дополнительные параметры") данные в строку табличной части
// ПараметрыИнтерфейса
//
// Параметры:
//  КлючПараметра - Строка - ключ для поиска строки табличной части (совпадает с именем реквизита формы)
//
&НаСервере
Процедура ИзменитьПараметрИнтерфейса(КлючПараметра)
	
	СтруктураКлючПараметра = Новый Структура("КлючПараметра", КлючПараметра);
	НайденныеСтроки = Объект.ПараметрыИнтерфейса.НайтиСтроки(СтруктураКлючПараметра);
	НайденныеСтроки[0].ЗначениеПараметра = ЭтотОбъект[КлючПараметра];
	
КонецПроцедуры

// Отобразить данные табличной части ПараметрыИнтерфейса в реквизитах группы "Дополнительные параметры"
// и пароль в ревизите формы
//
&НаСервере
Процедура ОтобразитьДополнительныеПараметрыИнтерфейса()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если Объект.СпособАвторизации <> "" Тогда
			ЭтотОбъект[Объект.СпособАвторизации] = Справочники.ИнтерфейсыДляВнешнихСистем.ПолучитьПарольИлиТокен(Объект.Ссылка
			, Объект.СпособАвторизации);
		КонецЕсли;
		
	КонецЕсли;
	
	КлючиПараметров = Справочники.ИнтерфейсыДляВнешнихСистем.ПолучитьКлючиПараметров();
	
	Для каждого СтрокаТабЧасти Из Объект.ПараметрыИнтерфейса Цикл
		
		Если КлючиПараметров.Найти(СтрокаТабЧасти.КлючПараметра) = Неопределено Тогда
		
			Продолжить;
		
		КонецЕсли;
		
		ЭтотОбъект[СтрокаТабЧасти.КлючПараметра] = СтрокаТабЧасти.ЗначениеПараметра;
		
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

#КонецОбласти

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	УправлениеДиалогомСправочникаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
	Элементы.ГруппаЛогинПароль.Видимость = (Объект.СпособАвторизации = "Пароль");
	Элементы.ГруппаТокен.Видимость = (Объект.СпособАвторизации = "Токен");
	Элементы.ГруппаСекретныйКлюч.Видимость = (Объект.СпособАвторизации = "СекретныйКлюч");
	
	// Настроить видимость реквизитов группы "Дополнительные параметры" по составу строк табличной части
	// ПараметрыИнтерфейса
	СтруктураКлючПараметра = Новый Структура("КлючПараметра");
	
	Для каждого ЭлементСписка Из СписокКлючиПараметров Цикл
		
		СтруктураКлючПараметра.КлючПараметра = ЭлементСписка.Значение;
		НайденныеСтроки = Объект.ПараметрыИнтерфейса.НайтиСтроки(СтруктураКлючПараметра);
		Элементы[СтруктураКлючПараметра.КлючПараметра].Видимость = (НайденныеСтроки.Количество() > 0);
		
	КонецЦикла;
	
КонецПроцедуры 

#КонецОбласти

#КонецОбласти
