﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы элемента справочника "Действия на значимые события"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

// Обработчик события возникающего на сервере при создании формы.
//
// Параметры:
//  Отказ                - Булево - Признак отказа от создания формы.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
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
	
	Если Параметры.ДополнительныеПараметры.Свойство("Источник") Тогда
		Источник = Параметры.ДополнительныеПараметры.Источник;
		СсылочныйТипИсточника = НЕ (Источник.ЗначениеПустойСсылки = Неопределено);
	КонецЕсли;
	
	Если Параметры.Свойство("ВидДействия") Тогда
		Объект.ВидДействия = Параметры.ВидДействия;
		Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
			Справочники.ДействияНаЗначимыеСобытия.СформироватьНаименованиеПоУмолчанию(Объект);
		КонецЕсли;
	КонецЕсли;
	
	// Настроим возможные варианты для выбора вида правила
	Элементы.СоответствияВидПравила.СписокВыбора.Очистить();
	Элементы.СоответствияВидПравила.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПравил.ТочноеЗначение"));
	Если СсылочныйТипИсточника Тогда
		Элементы.СоответствияВидПравила.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПравил.РеквизитОбъектаИсточника"));
	КонецЕсли;
	Элементы.СоответствияВидПравила.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПравил.ПроизвольныйКод"));
	
	ТипОбъектаУст = Объект.ТипОбъекта;
	
	РаботаСФормой.УстановитьДоступностьПоляКодНаФормеСправочника(ЭтотОбъект, Объект);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УправлениеДиалогомНаСервере();
	КонецЕсли;
		
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Настроим командную панель формы
	ЗащищенныеФункцииКлиент.НастроитьЭлементФормыТабличнойЧасти(ЭтотОбъект,"Соответствия");
	
КонецПроцедуры 


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УправлениеДиалогомНаСервере();
	
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
Процедура НаименованиеНачалоВыбораНаСервере(ПараметрыДействия=Неопределено)
	
	Справочники.ДействияНаЗначимыеСобытия.СформироватьНаименованиеПоУмолчанию(Объект,ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура НаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ ПустаяСтрока(Объект.Наименование) Тогда
		
		// Формируем описание обработчика перехвата закрытия формы
		ОбработчикВопроса = Новый ОписаниеОповещения("ОбработкаРезультатаОповещенияСформироватьНаименование", ЭтотОбъект);
		
		// Формируем текст вопроса
		ТекстВопроса = НСтр("ru = 'Сформировать новое наименование?'");
		
		// Получаем подтверждение операции от пользователя
		ПоказатьВопрос(ОбработчикВопроса, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		// Обработаем событие в контексте сервера
		НаименованиеНачалоВыбораНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура ТипОбъектаПриИзмененииНаСервере(ПараметрыДействия=Неопределено)
	
	Объект.ЗаполнитьРеквизитыПоУмолчанию = Ложь;
	Объект.ЗадействоватьВводНаОсновании = Ложь;
	
	Элементы.ЗадействоватьВводНаОсновании.Доступность = Ложь;
	Элементы.ЗаполнитьРеквизитыПоУмолчанию.Доступность = Ложь;

	// Вызываем обработчик изменения данных объекта
	Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
		Справочники.ДействияНаЗначимыеСобытия.СформироватьНаименованиеПоУмолчанию(Объект,ПараметрыДействия);
	КонецЕсли;
	
	Объект.Соответствия.Очистить();
	ТипОбъектаУст = Объект.ТипОбъекта;
	
	Если ЗначениеЗаполнено(Объект.ТипОбъекта) Тогда
		
		ПолноеИмяТипаОбъекта = Объект.ТипОбъекта.ПолноеИмя;
		
		ОбъектТекущий  = Метаданные.НайтиПоПолномуИмени(Объект.ТипОбъекта.ПолноеИмя);
		// Теперь проверяем возможность заполнения реквизитов по-умолчанию.
		// Это возможно только для объектов ссылочного типа.
		Если НЕ СсылочныйТипИсточника Тогда
			Объект.ЗаполнитьРеквизитыПоУмолчанию = Ложь;
			Объект.ЗадействоватьВводНаОсновании = Ложь;
		КонецЕсли;
		
		// Проверяем возможность проведения.
		Если ОбъектТекущий=Неопределено Тогда
			Объект.ПровестиДокумент = Ложь;
		ИначеЕсли Объект.ТипОбъекта.Родитель.ПолноеИмя = "Документы" Тогда
			Проведение = ОбъектТекущий.Проведение;
			Если НЕ Проведение=Метаданные.СвойстваОбъектов.Проведение.Разрешить Тогда
				Объект.ПровестиДокумент = Ложь;
			КонецЕсли;
		Иначе
			Объект.ПровестиДокумент = Ложь;
		КонецЕсли;
		
	Иначе
		
		Объект.ЗадействоватьВводНаОсновании = Ложь;
		Объект.ЗаполнитьРеквизитыПоУмолчанию = Ложь;
		Объект.ПровестиДокумент = Ложь;
		
	КонецЕсли;
	
	// Обновляем отображение элементов формы
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ТипОбъектаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ТипОбъектаУст) И НЕ ТипОбъектаУст = Объект.ТипОбъекта Тогда
		
		// Формируем описание обработчика перехвата закрытия формы
		ОбработчикВопроса = Новый ОписаниеОповещения("ОбработкаРезультатаОповещенияТипОбъекта", ЭтотОбъект);
		
		// Формируем текст вопроса
		ТекстВопроса = НСтр("ru = 'Смена типа объекта приведет к очистке таблицы <Правила заполнения>. Продолжить?'");
		
		// Получаем подтверждение операции от пользователя
		ПоказатьВопрос(ОбработчикВопроса, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		// Обработаем событие в контексте сервера
		ТипОбъектаПриИзмененииНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоУмолчаниюПриИзмененииНаСервере(ПараметрыДействия=Неопределено)
	
	// Вызываем обработчик изменения данных объекта
	Справочники.ДействияНаЗначимыеСобытия.ЗаполнитьРеквизитыПоУмолчаниюПриИзменении(Объект,ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоУмолчаниюПриИзменении(Элемент)
	
	ЗаполнитьРеквизитыПоУмолчаниюПриИзмененииНаСервере();
	
КонецПроцедуры 

&НаСервере
Процедура ЗадействоватьВводНаОснованииПриИзмененииНаСервере(ПараметрыДействия=Неопределено)
	
	Справочники.ДействияНаЗначимыеСобытия.ЗадействоватьВводНаОснованииПриИзменении(Объект,ПараметрыДействия);
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗадействоватьВводНаОснованииПриИзменении(Элемент)
	
	ЗадействоватьВводНаОснованииПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСоответствия

#Область ОбработчикиСобытийПолейТаблицыФормыСоответствия

&НаКлиенте
Процедура СоответствияПредставлениеРеквизитаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ЛОЖЬ;
	
	ТекущаяДанные = Элементы.Соответствия.ТекущиеДанные;
	
	// Сформируем параметры открытия
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Источник", Объект.ТипОбъекта);
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	
	ОткрытьФорму("Справочник.ДействияНаЗначимыеСобытия.Форма.ВыборРеквизитаОбъекта", ПараметрыОткрытия,Элемент,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры 

&НаКлиенте
Процедура СоответствияПредставлениеРеквизитаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Соответствия.ТекущиеДанные;
	
	// Сохраняем тип выбранного значения
	ОписаниеТипа = Новый ОписаниеТипов(ВыбранноеЗначение.ТипМетаданного); 
	
	ТекущиеДанные.Правило = ОписаниеТипа.ПривестиЗначение(); 
	ТекущиеДанные.ТипРеквизита = ОписаниеТипа.ПривестиЗначение(); 
	ТекущиеДанные.РеквизитОбъекта = ВыбранноеЗначение.ИмяМетаданного;
	ВыбранноеЗначение = ВыбранноеЗначение.Поле;
	
КонецПроцедуры 

&НаКлиенте
Процедура СоответствияПравилоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Соответствия.ТекущиеДанные;
	
	Если ТекущиеДанные.ВидПравила=ПредопределенноеЗначение("Перечисление.ВидыПравил.РеквизитОбъектаИсточника") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		// Сформируем параметры открытия
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Источник", Источник);
		ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
		
		// Получаем форму, производим ее настройку и открытие
		ОткрытьФорму("Справочник.ДействияНаЗначимыеСобытия.Форма.ВыборРеквизитаОбъекта", ПараметрыОткрытия,Элемент,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли ТекущиеДанные.ВидПравила=ПредопределенноеЗначение("Перечисление.ВидыПравил.ПроизвольныйКод") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		// Сформируем параметры открытия
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Источник", Объект.ТипОбъекта);
		ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
		ПараметрыОткрытия.Вставить("Текст", ?(ЗначениеЗаполнено(ТекущиеДанные.ПроизвольныйКод),ТекущиеДанные.ПроизвольныйКод,"Соответствия"));
		
		// Получаем форму, производим ее настройку и открытие
		ОткрытьФорму("Справочник.ДействияНаЗначимыеСобытия.Форма.РедакторВыражений", ПараметрыОткрытия, Элемент,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СоответствияПравилоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Соответствия.ТекущиеДанные;
	
	Если ТекущиеДанные.ВидПравила=ПредопределенноеЗначение("Перечисление.ВидыПравил.ПроизвольныйКод") Тогда
		
		ТекущиеДанные.ПроизвольныйКод = ВыбранноеЗначение;
		ТекущиеДанные.ПутьКДанным = "";
		ВыбранноеЗначение = "<" + НСтр("ru = 'Произвольное выражение'") + ">";
		
	ИначеЕсли ТекущиеДанные.ВидПравила=ПредопределенноеЗначение("Перечисление.ВидыПравил.РеквизитОбъектаИсточника") Тогда
		
		// проверим соответствие типов
		Если НЕ ВыбранноеЗначение.ТипМетаданного.СодержитТип(ТипЗнч(ТекущиеДанные.Правило)) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю (НСтр("ru='Тип выбранного реквизита объекта-источника не соответствует типу реквизита создаваемого объекта.'"));
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
		
		ТекущиеДанные.ПутьКДанным = ВыбранноеЗначение.ИмяМетаданного;
		ВыбранноеЗначение = ВыбранноеЗначение.Поле + " (Владелец)";
		ТекущиеДанные.ПроизвольныйКод = "";
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СоответствияВидПравилаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Соответствия.ТекущиеДанные;
	ТекущиеДанные.ПроизвольныйКод  = "";
	ТекущиеДанные.ПутьКДанным  = "";
	
	// Сохраняем тип выбранного значения
	Если НЕ ТекущиеДанные.ТипРеквизита = Неопределено Тогда
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(ТекущиеДанные.ТипРеквизита));
		ОписаниеТипа = Новый ОписаниеТипов(МассивТипов); 
		ТекущиеДанные.Правило = Неопределено;
		ТекущиеДанные.Правило = ОписаниеТипа.ПривестиЗначение(); 
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СоответствияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	СтрокаТабличнойЧасти = Элемент.ТекущиеДанные;
	
	Если НоваяСтрока И (НЕ Копирование) Тогда
		СтрокаТабличнойЧасти.ВидПравила = ПредопределенноеЗначение("Перечисление.ВидыПравил.ТочноеЗначение");
	КонецЕсли;
	
КонецПроцедуры //СоответствияПриНачалеРедактирования()

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик события возникающего на клиенте при выполнении команды "Очистить".
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаКлиенте
Процедура Очистить(Команда)
	
	Если Объект.Соответствия.Количество()>0 Тогда
		
		// Формируем описание обработчика перехвата закрытия формы
		ОбработчикВопроса = Новый ОписаниеОповещения("ОбработкаРезультатаОповещенияЗаполнение", ЭтотОбъект, "ОчиститьПравила");
		
		// Формируем текст вопроса
		ТекстВопроса = НСтр("ru = 'Очистить табличную часть ""Правила заполнения""?'");
		
		// Получаем подтверждение операции от пользователя
		ПоказатьВопрос(ОбработчикВопроса, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры //Очистить()

// Обработчик события возникающего на клиенте при выполнении команды "ЗаполнитьРеквизитами".
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаСервере
Процедура ЗаполнитьРеквизитамиНаСервере()
	
	ДеревоРеквизитов = ЗначимыеСобытия.ПолучитьДеревоМетаданныхОбъекта(Объект.ТипОбъекта,,Ложь);
	Корень = ДеревоРеквизитов.Строки[0];
	Для каждого Строка Из Корень.Строки Цикл
		
			НовоеПравило = Объект.Соответствия.Добавить();
			НовоеПравило.ПредставлениеРеквизита = Строка.Поле;
			НовоеПравило.РеквизитОбъекта = Строка.ИмяМетаданного;
			НовоеПравило.ВидПравила = ПредопределенноеЗначение("Перечисление.ВидыПравил.ТочноеЗначение");
			
			// Сохраняем тип выбранного значения
			ОписаниеТипа = Новый ОписаниеТипов(Строка.ТипМетаданного); 
			НовоеПравило.Правило = ОписаниеТипа.ПривестиЗначение(); 
			
		КонецЦикла;
	
	// Проверим возможно в качестве источника передана константа
	Если Корень.ВидМетаданного = "Константа" Тогда
		
		НовоеПравило = Объект.Соответствия.Добавить();
		НовоеПравило.ПредставлениеРеквизита = Корень.Поле;
		НовоеПравило.РеквизитОбъекта = Корень.ИмяМетаданного;
		НовоеПравило.ВидПравила = ПредопределенноеЗначение("Перечисление.ВидыПравил.ТочноеЗначение");
		
		// Сохраняем тип выбранного значения
		ОписаниеТипа = Новый ОписаниеТипов(Корень.ТипМетаданного); 
		НовоеПравило.Правило = ОписаниеТипа.ПривестиЗначение(); 
		
	КонецЕсли;
	
КонецПроцедуры //ЗаполнитьРеквизитамиНаСервере()

// Обработчик события возникающего на клиенте при выполнении команды "ЗаполнитьРеквизитами".
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаКлиенте
Процедура ЗаполнитьРеквизитами(Команда)
	
	Если ПолноеИмяТипаОбъекта = "Константы" ИЛИ ПолноеИмяТипаОбъекта = "РегистрыСведений" Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Соответствия.Количество()>0 Тогда
		
		// Формируем описание обработчика перехвата закрытия формы
		ОбработчикВопроса = Новый ОписаниеОповещения("ОбработкаРезультатаОповещенияЗаполнение", ЭтотОбъект, "ОчиститьПравилаИЗаполнить");
		
		// Формируем текст вопроса
		ТекстВопроса = НСтр("ru = 'Табличная часть ""Правила заполнения"" будет очищена. Продолжить?'");
		
		// Получаем подтверждение операции от пользователя
		ПоказатьВопрос(ОбработчикВопроса, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		ЗаполнитьРеквизитамиНаСервере();
	КонецЕсли;
	
КонецПроцедуры //ЗаполнитьРеквизитами()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура ОбработкаРезультатаОповещенияСформироватьНаименование(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если РезультатОповещения = КодВозвратаДиалога.Да Тогда
		
		// Обработаем событие в контексте сервера
		НаименованиеНачалоВыбораНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаРезультатаОповещенияСформироватьНаименование()

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура ОбработкаРезультатаОповещенияТипОбъекта(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если РезультатОповещения = КодВозвратаДиалога.Да Тогда
		
		// Обработаем событие в контексте сервера
		ТипОбъектаПриИзмененииНаСервере();
		
	ИначеЕсли РезультатОповещения = КодВозвратаДиалога.Нет Тогда
		
		Объект.ТипОбъекта = ТипОбъектаУст;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура ОбработкаРезультатаОповещенияЗаполнение(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если ДополнительныеПараметры = "ОчиститьПравила" Тогда
		
		Если РезультатОповещения = КодВозвратаДиалога.Да Тогда
			
			// Очистим табличную часть "Соответствия"
			Объект.Соответствия.Очистить();
			
		КонецЕсли;
		
	ИначеЕсли ДополнительныеПараметры = "ОчиститьПравилаИЗаполнить" Тогда
		
		Если РезультатОповещения = КодВозвратаДиалога.Да Тогда
			
			// Очистим табличную часть "Соответствия"
			Объект.Соответствия.Очистить();
			ЗаполнитьРеквизитамиНаСервере();
			
		КонецЕсли;
		
	КонецЕсли;
	
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
	
	// Вызываем общий обработчик действия
	УправлениеДиалогомСправочникаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(Объект.ТипОбъекта) Тогда
		
		Элементы.Соответствия.Доступность = Истина;
		ПолноеИмяТипаОбъекта = Объект.ТипОбъекта.ПолноеИмя;
		
		// Сначала проверяем ввод на основании.
		ОбъектТекущий  = Метаданные.НайтиПоПолномуИмени(Объект.ТипОбъекта.ПолноеИмя);
		
		// Проверяем возможность проведения.
		Если ОбъектТекущий=Неопределено Тогда
			Элементы.ПровестиДокумент.Видимость = Ложь;
		Иначе
			Если Объект.ТипОбъекта.Родитель.ПолноеИмя = "Документы" Тогда
				Проведение = ОбъектТекущий.Проведение;
				Элементы.ЗадействоватьВводНаОсновании.Доступность = Истина;
				Если Проведение=Метаданные.СвойстваОбъектов.Проведение.Разрешить Тогда
					Элементы.ПровестиДокумент.Видимость = Истина;
				Иначе
					Элементы.ПровестиДокумент.Видимость = Ложь;
					Объект.ПровестиДокумент = Ложь;
				КонецЕсли;
			Иначе
				Элементы.ЗадействоватьВводНаОсновании.Доступность = Ложь;
				Элементы.ПровестиДокумент.Видимость = Ложь;
				Объект.ПровестиДокумент = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		// Теперь проверяем возможность заполнения реквизитов по-умолчанию.
		// Это возможно только для объектов ссылочного типа.
		Если Объект.ТипОбъекта.ЗначениеПустойСсылки = Неопределено Тогда
			Элементы.ЗаполнитьРеквизитыПоУмолчанию.Доступность = Ложь;
		Иначе
			Элементы.ЗаполнитьРеквизитыПоУмолчанию.Доступность = Истина;
		КонецЕсли;
		
	Иначе
		
		Элементы.ЗадействоватьВводНаОсновании.Доступность = Ложь;
		Элементы.ЗаполнитьРеквизитыПоУмолчанию.Доступность = Ложь;
		Элементы.ПровестиДокумент.Видимость = Ложь;
		Элементы.Соответствия.Доступность = Ложь;
		
	КонецЕсли; 
	
	Элементы.Наименование.СписокВыбора.Очистить();
	Элементы.Наименование.СписокВыбора.Добавить(
		Справочники.ДействияНаЗначимыеСобытия.ПолучитьНаименованиеПоУмолчанию(Объект)
		, "Автоматическое наименование");
	
КонецПроцедуры // УправлениеДиалогомНаСервере()
#КонецОбласти

#КонецОбласти
