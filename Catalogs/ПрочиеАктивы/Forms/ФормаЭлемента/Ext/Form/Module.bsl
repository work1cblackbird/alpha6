﻿
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
	
	РаботаСФормой.ЗаблокироватьРедактированиеПредопределенногоЭлемента(ЭтотОбъект);
	РаботаСФормой.УстановитьДоступностьПоляКодНаФормеСправочника(ЭтотОбъект, Объект);
	
	// ПодключаемоеОборудование
	ТипыОборудования = МенеджерОборудованияКлиентСервер.ПараметрыТипыОборудования();
	ТипыОборудования.СканерШтрихкода = Истина;
	ТипыОборудования.СчитывательМагнитныхКарт = Истина;
	МенеджерОборудования.ПриСозданииНаСервере(ЭтаФорма, ТипыОборудования);
	// Конец ПодключаемоеОборудование
	
	ШтрихКод = ШтрихкодированиеВызовСервера.ПолучитьШтрихКодОбъекта(Объект.Ссылка);
	
	СформироватьНаименованиеПоУмолчанию();
	КэшНаименование = Справочники.ПрочиеАктивы.СформироватьНаименованиеПоУмолчанию(Объект);
	
	ЗаполнитьИнформационныеПоля();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		 УправлениеДиалогомНаСервере();
		 
	КонецЕсли;
	
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
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
	Если ВводДоступен() И ИмяСобытия = "ScanData" Тогда
		ПолученныйШтрихкод = ШтрихкодированиеКлиент.ПолучитьШтрихкодИзПараметровОборудования(ИмяСобытия, Параметр);
		Если ЗначениеЗаполнено(ПолученныйШтрихкод) Тогда
			ПараметрыДействия = Новый Структура;
			ШтрихкодированиеКлиент.ОбработатьПолныйШтрихкод(ПолученныйШтрихкод, ПараметрыДействия);
			Штрихкод = ПараметрыДействия.Штрихкод;
		КонецЕсли;
	КонецЕсли;
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
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	
	РаботаСФормойКлиент.ЗамерВремениЗапись("ПрочиеАктивы");
	
	ПропуститьПроверкуУникальности = ПараметрыЗаписи.Свойство("ПропуститьПроверкуУникальности") ИЛИ (ПараметрыЗаписи.Свойство("ПропуститьПроверкуУникальности") И ПараметрыЗаписи.ПропуститьПроверкуУникальности);
	
	Если ЗначениеЗаполнено(Штрихкод) И НЕ ПропуститьПроверкуУникальности Тогда
		
		// Выполним необходимые проверки штрихкодов
		ШтрихкодированиеКлиент.ПроверкаШтрихкодовПередЗаписью(ЭтотОбъект, Штрихкод, Объект.Ссылка, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
		
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры 

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаписатьШтрихкодыНаСервере();
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РодительПриИзменении(Элемент)
	
	РодительПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура РодительПриИзмененииНаСервере(ПараметрыДействия=Неопределено)

	Справочники.ПрочиеАктивы.РодительПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ВидПрочегоАктиваПриИзменении(Элемент)
	
	ВидПрочегоАктиваПриИзмененииНаСервере();
	
КонецПроцедуры 


&НаСервере
Процедура ВидПрочегоАктиваПриИзмененииНаСервере(ПараметрыДействия=Неопределено)
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	НоменклатураПриИзмененииНаСервере();
	
КонецПроцедуры 

&НаСервере
Процедура НоменклатураПриИзмененииНаСервере(ПараметрыДействия=Неопределено)
	
	Справочники.ПрочиеАктивы.НоменклатураПриИзменении(Объект, ПараметрыДействия);
	
	СформироватьНаименованиеПоУмолчанию();
	
КонецПроцедуры 

&НаКлиенте
Процедура ОсновнойТипЭксплуатацииПриИзменении(Элемент)

	ОсновнойТипЭксплуатацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОсновнойТипЭксплуатацииПриИзмененииНаСервере(ПараметрыДействия=Неопределено)

	Справочники.ПрочиеАктивы.ОсновнойТипЭксплуатацииПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ТипНоменклатурыПриИзменении(Элемент)
	
	ТипНоменклатурыПриИзмененииНаСервере();
	
КонецПроцедуры 

&НаСервере
Процедура ТипНоменклатурыПриИзмененииНаСервере(ПараметрыДействия=Неопределено)
	
	Справочники.ПрочиеАктивы.ТипНоменклатурыПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры 

&НаСервере
Процедура ШтрихкодНачалоВыбораНаСервере()
	
	ШтрихКод = ШтрихкодированиеВызовСервера.СформироватьНовыйШтрихкод(Объект.Ссылка);
	
КонецПроцедуры 

&НаКлиенте
Процедура ШтрихкодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ШтрихКод) Тогда
	
		ОбработчикВопроса = Новый ОписаниеОповещения("ОбработкаРезультатаОповещенияШтрихкод", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Создать новый штрихкод прочего актива?'");
		ПоказатьВопрос(ОбработчикВопроса, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ШтрихкодНачалоВыбораНаСервере();
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура НаименованиеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	КэшНаименование = ВыбранноеЗначение;
	
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
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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

// Для данного актива, если он эксплуатируется, выводятся балансовая стоимость, амортизация, остаточная стоимость.
&НаСервере
Процедура ЗаполнитьИнформационныеПоля()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрыЗапроса = Новый Структура;
		ПараметрыЗапроса.Вставить("Актив",  Объект.Ссылка);
		ПараметрыЗапроса.Вставить("Момент", ТекущаяДатаСеанса());
		ТаблПараметрыАктива = УправлениеПрочимиАктивами.ПолучитьОстаткиАктивов(ПараметрыЗапроса);
		
		БалансоваяСтоимость = ?(ТаблПараметрыАктива.Количество() = 0, 0, ТаблПараметрыАктива[0].БалансоваяСтоимость);
		Амортизация         = ?(ТаблПараметрыАктива.Количество() = 0, 0, ТаблПараметрыАктива[0].Амортизация);
		ОстаточнаяСтоимость = ?(ТаблПараметрыАктива.Количество() = 0, 0, ТаблПараметрыАктива[0].БалансоваяСтоимость - ТаблПараметрыАктива[0].Амортизация);
	КонецЕсли;
	
	// Установим надпись валюты в соответствии с управленческой валютой
	Валюта = СокрЛП(Константы.ВалютаУправленческогоУчетаКомпании.Получить().Наименование);
	Элементы.ДекорацияРуб1.Заголовок = Валюта;
	Элементы.ДекорацияРуб2.Заголовок = Валюта;
	Элементы.ДекорацияРуб3.Заголовок = Валюта;
	Элементы.ДекорацияРуб4.Заголовок = Валюта;
	
КонецПроцедуры // ЗаполнитьИнформационныеПоля()

// Производит запись штрихкодов в регистр сведений
//
&НаСервере
Процедура ЗаписатьШтрихкодыНаСервере()

	СтруктураШтрихкод = Новый Структура("Штрихкод,Запрет",ШтрихКод, ШтрихкодБлокировка);
	Если НЕ ШтрихкодированиеВызовСервера.ЗаписатьШтрихкоды(Объект.Ссылка, СтруктураШтрихкод) Тогда
		ТекстОшибки = НСтр("ru = 'Ошибка записи штрихкода карточки.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события возникающего при выполнении оповещения.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура ОбработкаРезультатаОповещенияПриИзмененииШтрихкода(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	// Проверяем статус закрытия окна параметров
	Если РезультатОповещения=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РезультатОповещения = КодВозвратаДиалога.Да Тогда
		Записать(Новый Структура("ПропуститьПроверкуУникальности",Истина));
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры // ОбработкаРезультатаОповещенияПриСменеШтрихкода()

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура ОбработкаРезультатаОповещенияШтрихкод(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если РезультатОповещения = КодВозвратаДиалога.Да Тогда
		ШтрихкодНачалоВыбораНаСервере();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаРезультатаОповещенияШтрихкод()

// Формирует наименование по умолчанию.
//
// Параметры:
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнении операции.
//
&НаСервере
Процедура СформироватьНаименованиеПоУмолчанию(ПараметрыДействия=Неопределено)
	
	УправлениеДиалогомСервер.СформироватьЗначениеПоУмолчанию(ЭтотОбъект, Объект, ПараметрыДействия);
	
КонецПроцедуры // СформироватьНаименованиеПоУмолчанию()

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	
	УправлениеДиалогомСправочникаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
	ЭтоОборудование = (Объект.ВидПрочегоАктива = Перечисления.ВидыПрочихАктивов.Оборудование ИЛИ Объект.ВидПрочегоАктива = Перечисления.ВидыПрочихАктивов.ОсновноеСредство);
	Элементы.РесурсВыработки.Видимость   = ЭтоОборудование;
	Элементы.ЕдиницаВыработки.Видимость  = ЭтоОборудование;

КонецПроцедуры // УправлениеДиалогомНаСервере()

#КонецОбласти

#КонецОбласти

