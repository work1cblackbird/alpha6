﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы обработки "Календарь пользователя"
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
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// добавим событие
	НоваяСтрока = СписокДокументов.Добавить();
	НоваяСтрока.ПредставлениеДокумента = "Событие";
	НоваяСтрока.ВидДокумента = "Событие";
	Если НЕ Параметры.Объект.СписокОтображаемыхДокументов.НайтиПоЗначению("Событие") = Неопределено Тогда
		НоваяСтрока.Просмотр = Истина;
	КонецЕсли;
	СтрокиЦветов = Параметры.ЦветаСобытий.НайтиСтроки(Новый Структура("ВидДокумента","Событие"));
	Если СтрокиЦветов.Количество() > 0 Тогда
		НоваяСтрока.Цвет = СтрокиЦветов[0].Цвет;
	Иначе
		НоваяСтрока.Цвет = ЦветаСтиля.КалендарьЦветСобытий;
	КонецЕсли;
	
	// добавим напоминание
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНапоминанияПользователя") Тогда
		НоваяСтрока = СписокДокументов.Добавить();
		НоваяСтрока.ПредставлениеДокумента = "Напоминание";
		НоваяСтрока.ВидДокумента = "Напоминание";
		Если НЕ Параметры.Объект.СписокОтображаемыхДокументов.НайтиПоЗначению("Напоминание") = Неопределено Тогда
			НоваяСтрока.Просмотр = Истина;
		КонецЕсли;
		СтрокиЦветов = Параметры.ЦветаСобытий.НайтиСтроки(Новый Структура("ВидДокумента","Напоминание"));
		Если СтрокиЦветов.Количество() > 0 Тогда
			НоваяСтрока.Цвет = СтрокиЦветов[0].Цвет;
		Иначе
			НоваяСтрока.Цвет = ЦветаСтиля.КалендарьЦветПрочихДокументов;
		КонецЕсли;
	КонецЕсли;
	
	// Создадим список видов всех документов
	Для Каждого Документ Из Метаданные.Документы.Событие.ВводитсяНаОсновании Цикл
		
		Если Документ.Имя = "Событие" ИЛИ НЕ ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Документ) ИЛИ НЕ ПравоДоступа("Просмотр",Документ) Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = СписокДокументов.Добавить();
		НоваяСтрока.ПредставлениеДокумента = Документ;
		НоваяСтрока.ВидДокумента = Документ.Имя;
		
		Если НЕ Параметры.Объект.СписокОтображаемыхДокументов.НайтиПоЗначению(Документ.Имя) = Неопределено Тогда
			НоваяСтрока.Просмотр = Истина;
		КонецЕсли;
		
		СтрокиЦветов = Параметры.ЦветаСобытий.НайтиСтроки(Новый Структура("ВидДокумента",Документ.Имя));
		Если СтрокиЦветов.Количество() > 0 Тогда
			НоваяСтрока.Цвет = СтрокиЦветов[0].Цвет;
		Иначе
			НоваяСтрока.Цвет = ЦветаСтиля.КалендарьЦветПрочихДокументов;
		КонецЕсли;
		
	КонецЦикла;
	
	РасположениеШкалыВремени = Параметры.РасположениеШкалыВремени;
	ИнтервалМинут = Параметры.ИнтервалМинут;
	ВремяОтображенияС = Параметры.ВремяОтображенияС;
	ВремяОтображенияПо = Параметры.ВремяОтображенияПо;
	ТолькоРабочиеЧасы = Параметры.ТолькоРабочиеЧасы;
	ГрафикРаботы = Параметры.ГрафикРаботы;
	АвтоОбновление = Параметры.АвтоОбновление;
	
	// Установим доступность
	Элементы.ГруппаВременнойИнтервал.ТолькоПросмотр = ТолькоРабочиеЧасы;
	
	// Раскрасим фон в соответствии с колонкой цвета
	Для каждого Строки Из СписокДокументов Цикл
		РаскраситьФон(Строки.Цвет);
	КонецЦикла;
	
	// Сформируем список возможных интервалов
	Для Номер = 0 По 24 Цикл
		Элементы.ВремяОтображенияС.СписокВыбора.Добавить(Номер);
		Элементы.ВремяОтображенияПо.СписокВыбора.Добавить(Номер);
	КонецЦикла;
	
КонецПроцедуры //ПриСозданииНаСервере()

// Обработчик события возникающего на клиенте перед закрытием формы.
//
// Параметры:
//  Отказ                - Булево - Признак отказа от создания формы.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	УправлениеДиалогомКлиент.ПроверитьМодифицированностьДанныхПриЗакрытии(ЭтотОбъект,Отказ,Новый ОписаниеОповещения("Подключаемый_ПередЗакрытием", ЭтотОбъект));
	
КонецПроцедуры //ПередЗакрытием()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Обработчик события возникающего на клиенте при изменении данных реквизита "Цвет".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура СписокДокументовЦветПриИзменении(Элемент)
	
	РаскраситьФон(Элементы.СписокДокументов.ТекущиеДанные.Цвет);
	
КонецПроцедуры //СписокДокументовЦветПриИзменении()

// Обработчик события возникающего на клиенте при изменении данных реквизита "Только рабочие часы".
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления, в котором возникло данное событие.
//
&НаКлиенте
Процедура ТолькоРабочиеЧасыПриИзменении(Элемент)
	
	Элементы.ГруппаВременнойИнтервал.ТолькоПросмотр = ТолькоРабочиеЧасы;
	
КонецПроцедуры //ТолькоРабочиеЧасыПриИзменении()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик события нажатия кнопки "Применить".
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаКлиенте
Процедура Применить(Команда)
	
	Если Модифицированность Тогда
		
		ПараметрыЗакрытия = Новый Структура;
		ПараметрыЗакрытия.Вставить("Объект",Объект);
		ПараметрыЗакрытия.Вставить("РасположениеШкалыВремени",РасположениеШкалыВремени);
		ПараметрыЗакрытия.Вставить("ВремяОтображенияПо",ВремяОтображенияПо);
		ПараметрыЗакрытия.Вставить("ВремяОтображенияС",ВремяОтображенияС);
		ПараметрыЗакрытия.Вставить("СписокДокументов",СписокДокументов);
		ПараметрыЗакрытия.Вставить("ТолькоРабочиеЧасы",ТолькоРабочиеЧасы);
		ПараметрыЗакрытия.Вставить("ИнтервалМинут",ИнтервалМинут);
		ПараметрыЗакрытия.Вставить("ГрафикРаботы",ГрафикРаботы);
		ПараметрыЗакрытия.Вставить("АвтоОбновление",АвтоОбновление);
		
		Модифицированность = Ложь;
		Закрыть(ПараметрыЗакрытия);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры //Применить()

// Обработчик события нажатия кнопки "Установить/снять флажки использования".
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаКлиенте
Процедура ИспользованиеИзменениеФлажка(Команда)
	
	УправлениеДиалогомКлиент.ГрупповоеИзменениеПоляФлажка(СписокДокументов, "Просмотр", Команда);
	
КонецПроцедуры // ИспользованиеИзменениеФлажка()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Структура - Содержит процедуру в которую будет передан ответ на вопрос и формы из которой
//                                        вызвано оповещение.
//
&НаКлиенте
Процедура Подключаемый_ПередЗакрытием(Результат, ДополнительныеПараметры=Неопределено) Экспорт
	
	// Сохраняем настройки.
	Применить(Неопределено);
	
КонецПроцедуры //Подключаемый_ПередЗакрытием()

// Процедура производить установку условного оформления для цвета фона.
//
&НаСервере
Процедура РаскраситьФон(ЦветОформления)
	
	Если Не ПроверитьСуществованиеЭлементаОформленияЦвета(ЦветОформления, "ЦветФона", "Цвет", "Цвет") Тогда
		НовыйЭлемент = УсловноеОформление.Элементы.Добавить();
		НовыйЭлемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
		Для Каждого ОформлениеЭлемента Из НовыйЭлемент.Оформление.Элементы Цикл
			Если ОформлениеЭлемента.Параметр = Новый ПараметрКомпоновкиДанных("ЦветФона") Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		ОформлениеЭлемента.Значение = ЦветОформления;
		ОформлениеЭлемента.Использование = Истина;
		
		ОформляемоеПоле = НовыйЭлемент.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("СписокДокументовЦвет");
		ОформляемоеПоле.Использование = Истина;
		
		ПолеОтбора = НовыйЭлемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ПолеОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокДокументов.Цвет");
		ПолеОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ПолеОтбора.ПравоеЗначение = ЦветОформления;
		ПолеОтбора.Использование = Истина;
		
		НовыйЭлемент.Использование = Истина;
	КонецЕсли;
		
КонецПроцедуры //()РаскраситьФон

&НаСервере
Функция ПроверитьСуществованиеЭлементаОформленияЦвета(ПроверяемыйЦвет, ИмяЭлементаОформления, ИмяОформляемогоПоля, ИмяПоляЭлементаОтбора)
	
	бЭлементОформленияНайден = Ложь;
	
	Для Каждого ЭлементУсловногоОформления Из УсловноеОформление.Элементы Цикл
		
		Если ЭлементУсловногоОформления.Использование И ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
		
			Для Каждого ЭлементОформления Из ЭлементУсловногоОформления.Оформление.Элементы Цикл
				
				Если ЭлементОформления.Использование И ЭлементОформления.Параметр = Новый ПараметрКомпоновкиДанных(ИмяЭлементаОформления) И ЭлементОформления.Значение = ПроверяемыйЦвет Тогда
					
					Для Каждого ОформляемоеПоле Из ЭлементУсловногоОформления.Поля.Элементы Цикл
						
						Если ОформляемоеПоле.Использование И ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ИмяОформляемогоПоля) Тогда
							
							Для Каждого ЭлементОтбора Из ЭлементУсловногоОформления.Отбор.Элементы Цикл
								
								Если		ЭлементОтбора.Использование
										И	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно
										И	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокДокументов." + ИмяПоляЭлементаОтбора)
										И	ЭлементОтбора.ПравоеЗначение = ПроверяемыйЦвет Тогда
									//
									
									бЭлементОформленияНайден = Истина;
									Прервать;
									
								КонецЕсли;
								
							КонецЦикла;
							
						КонецЕсли;
						
						Если бЭлементОформленияНайден Тогда
							Прервать;
						КонецЕсли;
						
					КонецЦикла;
					
				КонецЕсли;
				
				Если бЭлементОформленияНайден Тогда
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если бЭлементОформленияНайден Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат бЭлементОформленияНайден;
	
КонецФункции //ПроверитьСуществованиеЭлементаОформленияЦвета()

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Текст
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СписокДокументовЦвет");
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", "");
	
КонецПроцедуры

#КонецОбласти

