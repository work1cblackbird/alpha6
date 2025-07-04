﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы списка документа "Заказ поставщику"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ПараметрыПриСозданииНаСервере.КолонкаСостоянияЭДО = Элементы.ПредставлениеСостояния;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(ПараметрыПриСозданииНаСервере);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	РаботаСФормой.СкрытьЭлементыНедоступныеПоКлючу(ЭтотОбъект);
	РаботаСФормой.УстановитьРежимВыбора(ЭтотОбъект, Элементы.Список, Параметры);
	РаботаСФормой.НастроитьОсновнойДинамическийСписокФормы(ЭтотОбъект);
	РаботаСФормой.УстановитьФормаСуммыДокумента(Элементы.СуммаДокумента);
	
	// УтверждениеДокументов
	УтверждениеДокументовСервер.ПриСозданииНаСервере(ЭтотОбъект, Неопределено);
	// Конец УтверждениеДокументов
	
	// РасширеннаяИнформация
	ОписаниеЭлементов = Новый Структура(
		"Поле,КомандаПереключатель",
		Элементы.РасширеннаяИнформация,
		Элементы.ПоказатьРасширеннуюИнформацию
	);
	РасширеннаяИнформацияВызовСервера.ПриСозданииНаСервере(ОписаниеЭлементов);
	// Конец РасширеннаяИнформация
	
	СформироватьУсловноеОформление();
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормы.ПриСозданииНаСервере_ФормаСписка(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	// Конец АльфаАвто.СобытияОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормыКлиент.ПриОткрытии_ФормаСписка(ЭтотОбъект, Отказ);
	// Конец АльфаАвто.СобытияОбъектов
	
КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// АльфаАвто.СобытияОбъектов
	СобытияОбъектовФормыКлиент.ОбработкаОповещения_ФормаСписка(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец АльфаАвто.СобытияОбъектов
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ПараметрыОповещенияЭДО.ЕстьОбработчикОбновленияВидимостиСостоянияЭДО = Истина;
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// УтверждениеДокументов
	УтверждениеДокументовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец УтверждениеДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	РаботаСФормойКлиент.УстановитьТекущуюСтрокуНаНовыйОбъект(Элементы.Список, НовыйОбъект);

КонецПроцедуры 

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	РасширеннаяИнформацияВызовСервера.ПриСохраненииДанныхВНастройкахНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры 

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	РасширеннаяИнформацияВызовСервера.ПриЗагрузкеДанныхИзНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиКомандФормы

// РасширеннаяИнформация
&НаКлиенте
Процедура ПоказатьРасширеннуюИнформацию(Команда)
	
	РасширеннаяИнформацияКлиент.ПоказатьРасширеннуюИнформацию(ЭтотОбъект);

КонецПроцедуры
// Конец РасширеннаяИнформация

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ПредставлениеСостояния Тогда
		// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
		ОбменСКонтрагентамиКлиент.СостояниеЭДОНажатие_ФормаСписка(ВыбраннаяСтрока, СтандартнаяОбработка);  
		// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами 
	ИначеЕсли Поле = Элементы.ЕстьКорректировки 
		И ЕстьПравоНаПросмотрКорректировки() Тогда
		
		ПоследняяКорректировка = ПолучитьПоследнююКорректировку(ВыбраннаяСтрока);
		
		Если ЗначениеЗаполнено(ПоследняяКорректировка) Тогда 
			СтандартнаяОбработка = Ложь;
			
			ПараметрыФормы = Новый Структура("Ключ", ПоследняяКорректировка);
			ОткрытьФорму("Документ.КорректировкаЗаказаПоставщику.ФормаОбъекта", ПараметрыФормы);
		КонецЕсли;
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// УтверждениеДокументов
	УтверждениеДокументовКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец УтверждениеДокументов
	
	// РасширеннаяИнформация
	РасширеннаяИнформацияКлиент.НачатьОбновление(ЭтотОбъект);
	// Конец РасширеннаяИнформация
	
КонецПроцедуры 

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	// ОценкаПроизводительности
	Если Копирование Тогда
		
		ОценкаПроизводительностиКлиент.ЗамерВремени("КопированиеДокументаЗаказПоставщику");
		
	Иначе
		
		ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеФормыДокументаЗаказПоставщику");
		
	КонецЕсли;
	// Конец ОценкаПроизводительности

КонецПроцедуры 

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	// ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеФормыДокументаЗаказПоставщику");
	// Конец ОценкаПроизводительности

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КорректировкаЗаказаПоставщику.ДокументОснование КАК Ссылка
		|ИЗ
		|	Документ.КорректировкаЗаказаПоставщику КАК КорректировкаЗаказаПоставщику
		|ГДЕ
		|	КорректировкаЗаказаПоставщику.ДокументОснование В(&СписокОснований)
		|	И КорректировкаЗаказаПоставщику.Проведен";
	Запрос.УстановитьПараметр("СписокОснований", Строки.ПолучитьКлючи()); 
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаСписка = Строки[Выборка.Ссылка];
		СтрокаСписка.Данные["ЕстьКорректировки"] = Истина;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
    
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
    
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
    
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
    
КонецПроцедуры

&НаСервере
Процедура СформироватьУсловноеОформление()
	
	// Обновление условного оформления строк в ТЧ
	СправочникМенеджер = Справочники.ВидыСостоянийЗаказНарядов;
	УправлениеДиалогомАльфаАвтоСервер.СформироватьУсловноеОформление(ЭтотОбъект, СправочникМенеджер,"Состояние");
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьВидимостьСостоянияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОбновленияВидимостьСостоянияЭДО(ЭтотОбъект, Элементы.ПредставлениеСостояния);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

#КонецОбласти

#Область ОбработчикиАльфаАвто

&НаСервере
Функция ЕстьПравоНаПросмотрКорректировки()
	Возврат ПравоДоступа("Просмотр", Метаданные.Документы.КорректировкаЗаказаПоставщику);
КонецФункции 

&НаСервере
Функция ПолучитьПоследнююКорректировку(СсылкаНаЗаказ)

	СсылкаНаКорректировку = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	КорректировкаЗаказаПоставщику.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.КорректировкаЗаказаПоставщику КАК КорректировкаЗаказаПоставщику
		|ГДЕ
		|	КорректировкаЗаказаПоставщику.ДокументОснование = &ДокументОснование
		|	И КорректировкаЗаказаПоставщику.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	КорректировкаЗаказаПоставщику.Дата УБЫВ";
	Запрос.УстановитьПараметр("ДокументОснование", СсылкаНаЗаказ);   
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
	        СсылкаНаКорректировку = ВыборкаДетальныеЗаписи.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Возврат СсылкаНаКорректировку;
	
КонецФункции

// РасширеннаяИнформация
&НаКлиенте
Процедура РасширеннаяИнформацияПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	КонтекстНажатия = РасширеннаяИнформацияКлиент.НовыйКонтекстНажатия(ЭтотОбъект, Элементы.Список);
	КонтекстНажатия.ПолноеИмяОбъекта = "Документ.ЗаказПоставщику";	
	РасширеннаяИнформацияКлиент.Нажатие(КонтекстНажатия, ДанныеСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьРасширеннуюИнформацию()
	
	Контекст = РасширеннаяИнформацияКлиент.НовыйКонтекстОбновления();
	Контекст.ПолеОтображаетсяНаФорме = Элементы.РасширеннаяИнформация.Видимость;
	Контекст.ОбъектДляОбновления = Элементы.Список.ТекущаяСтрока;
    РасширеннаяИнформация = РасширеннаяИнформацияКлиент.СформироватьРасширеннуюИнформациюОбОбъекте(Контекст);
    
КонецПроцедуры
// Конец РасширеннаяИнформация

#Область ПечатьРеестра

&НаКлиенте
Процедура Подключаемый_ОбработкаКомандыПечатиРеестра(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	ОбработкаКомандыПечатиРеестраНаСервере(ПараметрыВыполнения, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаКомандыПечатиРеестраНаСервере(ПараметрыВыполнения, ДополнительныеПараметры)
	
	ПечатьРеестраДокументов.ПолучитьНастройкиСКД(ЭтотОбъект.Элементы.Список, ПараметрыВыполнения);	
	
КонецПроцедуры

#КонецОбласти

#Область УтверждениеДокументов

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуУтверждения(Команда)
	
	УтверждениеДокументовКлиент.ОбработкаКомандыФормы(ЭтотОбъект, Команда, Элементы.Список.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьОбработкуКомандыУтвержденияНаСервере(ПараметрыОбработки,
		ДополнительныеПараметры) Экспорт
	
	ОбработкаКомандыУтвержденияНаСервере(ПараметрыОбработки, ДополнительныеПараметры);
	Оповестить("ПослеУтвержденияДокументов", ПараметрыОбработки.Документ, ИмяФормы);
	ОповеститьОбИзменении(ПараметрыОбработки.Документ);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаКомандыУтвержденияНаСервере(ПараметрыОбработки, ДополнительныеПараметры)
	
	УтверждениеДокументовВызовСервера.ОбработкаКомандыФормы(
		ЭтотОбъект,
		ПараметрыОбработки.ИмяКоманды,
		ПараметрыОбработки.Документ
	);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКомандыУтвержденияДокументов()
	
	УтверждениеДокументовКлиентСервер.УстановитьДоступностьКнопокУтверждения(ЭтотОбъект, Элементы.Список.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

