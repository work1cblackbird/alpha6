﻿// Общий модуль "Расширенная информация (клиент)"

#Область ПрограммныйИнтерфейс

// Обновляет поле расширенной информации в зависимости от текущего контекста формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//
Процедура НачатьОбновление(Форма) Экспорт
	
	Форма.ОтключитьОбработчикОжидания("Подключаемый_ОбновитьРасширеннуюИнформацию");
	Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбновитьРасширеннуюИнформацию", 0.2, Истина);
	
КонецПроцедуры

// Возвращает расширенную информацию объекта
// 
// Параметры:
//  Контекст - Структура - содержит параметры выполнения операции
//   *ОбъектДляОбновления     - Произвольный - Ссылка или дерево настроек или объект.
//   *ПолеОтображаетсяНаФорме - Булево		 - отображение расширенной информации на форме
//  
// Возвращаемое значение:
//  Строка - пустая строка / сформированная расширенная информация
//
Функция СформироватьРасширеннуюИнформациюОбОбъекте(Контекст) Экспорт
	
	Если Контекст.ПолеОтображаетсяНаФорме Тогда
		
		Возврат РасширеннаяИнформацияВызовСервера.
			СформироватьРасширеннуюИнформациюОбОбъекте(Контекст.ОбъектДляОбновления);
		
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Возвращает параметры обновления расширенной информации
//
// Возвращаемое значение: 
//  Структура - параметры обновления
//
Функция НовыйКонтекстОбновления() Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("ПолеОтображаетсяНаФорме", Ложь);
	Результат.Вставить("ОбъектДляОбновления", Неопределено);
	Возврат Результат;
	
КонецФункции

// Общий обработчик события возникающего при нажатии на кнопку "Показать расширенную информацию".
//
// Параметры:
//  Форма - УправляемаяФорма - Форма, в которой возникло событие.
//
Процедура ПоказатьРасширеннуюИнформацию(Форма) Экспорт
	
	ПоказатьРасширеннуюИнформацию = Не Форма.Элементы.РасширеннаяИнформация.Видимость;
	
	Форма.Элементы.РасширеннаяИнформация.Видимость       = ПоказатьРасширеннуюИнформацию;
	Форма.Элементы.ПоказатьРасширеннуюИнформацию.Пометка = ПоказатьРасширеннуюИнформацию;
	Форма.СохраняемыеВНастройкахДанныеМодифицированы = Истина;
	
	НачатьОбновление(Форма);
		
КонецПроцедуры

// Процедура обрабатывает нажатие на поле расширенной информации
// 
// Параметры: 
//  Контекст 			 - Структура - 
//  ДанныеСобытия 		 - ФиксированнаяСтруктура -
//  СтандартнаяОбработка - Булево - 
//
Процедура Нажатие(Контекст, ДанныеСобытия, СтандартнаяОбработка = Истина) Экспорт
	
	Если ДанныеСобытия.Anchor <> Неопределено Тогда
		
		Если ДанныеСобытия.Anchor.name = "НастройкаПолейОтображения" Тогда
			
			Если Контекст.ЭтоЖурнал И Контекст.ЕстьТекущаяСтрока Тогда
				
				ОткрытьФорму(
					"Обработка.НастройкаПоляРасширеннойИнформации.Форма",
					Новый Структура(
						"ПолноеИмяОбъекта,СсылкаНаОбъект",
						Контекст.ПолноеИмяОбъекта,
						Контекст.ТекущаяСтрока
					),
					Контекст.ФормаВладелец
				);
				
			Иначе
				
				ОткрытьФорму(
					"Обработка.НастройкаПоляРасширеннойИнформации.Форма",
					Новый Структура("ПолноеИмяОбъекта", Контекст.ПолноеИмяОбъекта),
					Контекст.ФормаВладелец
				);
				
			КонецЕсли;
			
		ИначеЕсли ДанныеСобытия.Anchor.name = "НастройкаПечати" Тогда
			
			ДанныеСобытия.Document.execCommand("Print");
			
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ДанныеСобытия.href) Тогда
		
		Попытка
			
			ПерейтиПоНавигационнойСсылке(ДанныеСобытия.href);
			
		Исключение
			
			ТехнологическаяПлатформаВызовСервера.СделатьЗаписьЖурналаРегистрации(
				НСтр("ru = 'Ошибка перехода по ссылке'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка())
					+ " "
					+ СокрЛП(ДанныеСобытия.href),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
			);
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

// Возращает структуру параметров нажатия
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - 
//  Список - ТаблицаФормы 			   -
// 
// Возвращаемое значение:
//  Структура - параметры контекста нажатия
//
Функция НовыйКонтекстНажатия(Форма, Список) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("ПолноеИмяОбъекта", "");
	Результат.Вставить("ЭтоЖурнал", Ложь);
	Результат.Вставить("ЕстьТекущаяСтрока", Список.ТекущаяСтрока <> Неопределено);
	Результат.Вставить("ТекущаяСтрока", Список.ТекущаяСтрока);
	Результат.Вставить("ФормаВладелец", Форма);
	Возврат Результат;
	
КонецФункции

// Устарела. Будет удалена. см. РасширеннаяИнформацияКлиент.Нажатие
// Общий обработчик события возникающего на клиенте при нажатии на поле "Расширенная информация".
//
// Параметры:
//  Форма                - УправляемаяФорма       - Форма, в которой возникло событие.
//  Элемент              - ПолеФормы              - Элемент управления, в котором возникло данное событие.
//  ДанныеСобытия        - ФиксированнаяСтруктура - Параметр заполняется фиксированной структурой со свойствами:
//                         Anchor, Element, Button, Event, Document, Href.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
Процедура ПриНажатии(Форма, Элемент, ДанныеСобытия, СтандартнаяОбработка=ИСТИНА) Экспорт
	
	// Отказываемся от стандартной обработки события
	СтандартнаяОбработка = ЛОЖЬ;
	
	// Обработаем в зависимости от вида нажатой гиперссылки
	Если НЕ ДанныеСобытия.Anchor = Неопределено Тогда
		Если ДанныеСобытия.Anchor.name = "НастройкаПолейОтображения" Тогда
			Если Лев(Форма.ПолноеИмяОбъекта, 16) = "ЖурналДокументов" И НЕ Форма.Элементы.Список.ТекущаяСтрока = Неопределено Тогда
				ОткрытьФорму("Обработка.НастройкаПоляРасширеннойИнформации.Форма", Новый Структура("ПолноеИмяОбъекта,СсылкаНаОбъект", Форма.ПолноеИмяОбъекта, Форма.Элементы.Список.ТекущаяСтрока),Форма);
			Иначе
				ОткрытьФорму("Обработка.НастройкаПоляРасширеннойИнформации.Форма", Новый Структура("ПолноеИмяОбъекта", Форма.ПолноеИмяОбъекта),Форма);
			КонецЕсли;
		ИначеЕсли ДанныеСобытия.Anchor.name = "НастройкаПечати" Тогда
			ДанныеСобытия.Document.execCommand("Print")
		КонецЕсли;
	ИначеЕсли НЕ ЗначениеЗаполнено(ДанныеСобытия.href) Тогда
		// Клик по пустому полю
	Иначе
		Попытка
			ПерейтиПоНавигационнойСсылке(ДанныеСобытия.href);
		Исключение
			ТехнологическаяПлатформаВызовСервера.СделатьЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка перехода по ссылке'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()) + " " + СокрЛП(ДанныеСобытия.href), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры // ПриНажатии()

#КонецОбласти
