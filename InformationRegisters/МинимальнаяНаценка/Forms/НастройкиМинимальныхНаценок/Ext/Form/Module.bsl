﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("Владелец") И Параметры.Владелец <> Неопределено Тогда
		
		Если ТипЗнч(Параметры.Владелец) = Тип("СправочникСсылка.Пользователи") Тогда
			ИмяКоманды = Элементы.Назначение1.ИмяКоманды;
		ИначеЕсли ТипЗнч(Параметры.Владелец) = Тип("СправочникСсылка.ГруппыДоступа") Тогда
			ИмяКоманды = Элементы.Назначение2.ИмяКоманды;
		ИначеЕсли ТипЗнч(Параметры.Владелец) = Тип("СправочникСсылка.ТипыНоменклатуры") Тогда
			ИмяКоманды = Элементы.Назначение3.ИмяКоманды;
		КонецЕсли;
		
		ВыборПользовательТипНоменклатуры = Параметры.Владелец;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОчищатьПользователяТипНоменклатуры = Истина;
	
	Если ИмяКоманды = "" Тогда
		ИмяКоманды = "ВыборНазначения1";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВыборПользовательТипНоменклатуры) Тогда
		ОчищатьПользователяТипНоменклатуры = Ложь;
	КонецЕсли;
	
	УправлениеДиалогом(ИмяКоманды, ОчищатьПользователяТипНоменклатуры);
	ОбновитьТаблицыДатИНаценок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыборПользовательТипНоменклатурыПриИзменении(Элемент)
	
	ОбновитьТаблицыДатИНаценок();
	Подключаемый_СписокДатПриАктивизацииСтроки();
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДат

&НаКлиенте
Процедура СписокДатВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекСтрока = Элементы.СписокДат.ТекущиеДанные;
	
	Если НЕ ТекСтрока = Неопределено
		И ТекСтрока.Представление = "ВЫБРАТЬ дату" Тогда
		Подключаемый_СписокДатПриАктивизацииСтроки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДатПриАктивизацииСтроки(Элемент)
	
	Если ТекСтрокаСписка = Элемент.ТекущаяСтрока Тогда
		Возврат;
	Иначе
		ТекСтрокаСписка = Элемент.ТекущаяСтрока;
	КонецЕсли;
	
	// Производим подключение обработчика события выполняемого с задержкой
	ПодключитьОбработчикОжидания("Подключаемый_СписокДатПриАктивизацииСтроки", 0.5, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗначенияМинимальныхНаценок

&НаКлиенте
Процедура ЗначенияМинимальныхНаценокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураПоиска = Новый Структура("Значение", ВыбранноеЗначение);
	
	Если ЗначенияМинимальныхНаценок.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда 
		Строка = ЗначенияМинимальныхНаценок.Добавить();
		Строка.Значение = ВыбранноеЗначение;
		Строка.Активна = Истина;
		Элементы.ЗначенияМинимальныхНаценок.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
		Если НЕ Модифицированность Тогда
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияМинимальныхНаценокПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ЗначенияМинимальныхНаценок.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные.Активна = Истина;
		ТекущиеДанные.ЗначениеНаТекущуюДату = Истина;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияМинимальныхНаценокПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	ТекущиеДанные = Элементы.ЗначенияМинимальныхНаценок.ТекущиеДанные;
	
	Если НЕ НоваяСтрока И Элемент.ТекущаяСтрока = 0 И ЗначениеЗаполнено(ТекущиеДанные.Значение) Тогда
		ТекущиеДанные.Значение = ПредопределенноеЗначение("Справочник.ТипыНоменклатуры.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияМинимальныхНаценокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УдалитьДату(Команда)
	
	Если Элементы.СписокДат.ТекущиеДанные.Представление = "ВЫБРАТЬ дату" 
			ИЛИ Элементы.СписокДат.ТекущиеДанные.Представление = НСтр("ru = 'Текущая дата'") Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Выбранное значение даты удалить нельзя.'"));
		
	Иначе
		
		// Формируем описание обработчика перехвата закрытия формы
		ОбработчикВопроса = Новый ОписаниеОповещения("Подключаемый_ОбработкаОтветаНаВопрос", ЭтотОбъект, "УдалитьДату");
		
		// Формируем текст вопроса
		ТекстВопроса = НСтр("ru = 'Настройка минимальной наценки на выбранную дату будет удалена. Продолжить?'");
		
		// Получаем подтверждение операции от пользователя
		ПоказатьВопрос(ОбработчикВопроса, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьДату(Команда)
	
	Подключаемый_СписокДатПриАктивизацииСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипНоменклатуры(Команда)
	
	ИмяКоманды = Команда.Имя;
	ОбработкаВыбораТиповНоменклатурПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура Пользователь(Команда)
	
	ИмяКоманды = Команда.Имя;
	ОбработкаВыбораТиповНоменклатурПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаДоступа(Команда)
	
	ИмяКоманды = Команда.Имя;
	ОбработкаВыбораТиповНоменклатурПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьТипНоменклатуры(Команда)
	
	ПараметрыДобавления = Новый Структура;
	ПараметрыДобавления.Вставить("РежимВыбора", Истина);
	ОткрытьФорму(
		"Справочник.ТипыНоменклатуры.ФормаСписка",
		ПараметрыДобавления,
		Элементы.ЗначенияМинимальныхНаценок,
		, , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьГруппуДоступа(Команда)
	
	ПараметрыДобавления = Новый Структура;
	ПараметрыДобавления.Вставить("РежимВыбора", Истина);
	ОткрытьФорму(
		"Справочник.ГруппыДоступа.ФормаВыбора",
		ПараметрыДобавления,
		Элементы.ЗначенияМинимальныхНаценок,
		, , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПользователя(Команда)
	
	ПараметрыДобавления = Новый Структура;
	ПараметрыДобавления.Вставить("РежимВыбора", Истина);
	ОткрытьФорму(
		"Справочник.Пользователи.ФормаСписка",
		ПараметрыДобавления,
		Элементы.ЗначенияМинимальныхНаценок,
		, , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗначение(Команда)
	
	ТекущиеДанные = Элементы.ЗначенияМинимальныхНаценок.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		Если Не ТекущиеДанные.ЗначениеНаТекущуюДату Тогда
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ИдентификаторСтроки", ТекущиеДанные.ПолучитьИдентификатор());
			Обработчик = Новый ОписаниеОповещения("ПродолжитьУдалитьЗначение", ЭтотОбъект, ДополнительныеПараметры);
			ПоказатьВопрос(
				Обработчик,
				СтрШаблон(
					НСтр("ru = 'Данная наценка установлена %1. Вы действительно хотите ее удалить?'"),
					Формат(ТекущиеДанные.Период, "ДЛФ=D")),
				РежимДиалогаВопрос.ДаНет
			);
		Иначе
			ТекущиеДанные.Активна = Ложь;
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура ЗаполнитьДатыМинимальныеНаценки()
	
	СписокДат.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МинимальнаяНаценка.Период КАК Период
	|ИЗ
	|	РегистрСведений.МинимальнаяНаценка КАК МинимальнаяНаценка
	|ГДЕ
	|	МинимальнаяНаценка.Активна
	|	И &УсловиеПоТипуНоменклатуры
	|	И &УсловиеПоПользователю
	|СГРУППИРОВАТЬ ПО
	|	МинимальнаяНаценка.Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ";
	
	Если ЭтоГруппаДоступа Или ЭтоПользователь Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеПоТипуНоменклатуры", "ИСТИНА");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеПоПользователю", "МинимальнаяНаценка.Пользователь = &Значение");
		Запрос.УстановитьПараметр("Значение",
			?(ЗначениеЗаполнено(ВыборПользовательТипНоменклатуры), ВыборПользовательТипНоменклатуры, Неопределено)
		);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеПоТипуНоменклатуры", "МинимальнаяНаценка.ТипНоменклатуры = &Значение");
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеПоПользователю", "ИСТИНА");
		Запрос.УстановитьПараметр("Значение", ВыборПользовательТипНоменклатуры);
	КонецЕсли;
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	// Добавим текущую дату
	НоваяДатаМинимальныеНаценки = СписокДат.Добавить();
	НоваяДатаМинимальныеНаценки.Значение = Дата("39991231") - 1;
	НоваяДатаМинимальныеНаценки.Представление = НСтр("ru = 'Текущая дата'");
	Элементы.СписокДат.ТекущаяСтрока = НоваяДатаМинимальныеНаценки.ПолучитьИдентификатор();
	Дата = ТекущаяДатаСеанса();
	УстДата = Дата;
	
	// Добавим возможность добавления новой записи за любое число
	НоваяДатаМинимальныеНаценки = СписокДат.Добавить();
	НоваяДатаМинимальныеНаценки.Значение = Дата("39991231") - 2;
	НоваяДатаМинимальныеНаценки.Представление = "ВЫБРАТЬ дату";
	
	Пока Выборка.Следующий() Цикл
		
		НоваяДатаМинимальныеНаценки = СписокДат.Добавить();
		НоваяДатаМинимальныеНаценки.Значение = Выборка.Период;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуМинимальныхНаценок()
	
	ЗначенияМинимальныхНаценок.Очистить();
	
	Если УстДата = Неопределено Тогда
		УстДата = НачалоДня(ТекущаяДатаСеанса());
	КонецЕсли;
	
	ЗапросМинимальныеНаценки = Новый Запрос;
	ЗапросМинимальныеНаценки.Текст = 
	"ВЫБРАТЬ
	|	МинимальнаяНаценкаСрезПоследних.Период,
	|	МинимальнаяНаценкаСрезПоследних.ТипНоменклатуры,
	|	МинимальнаяНаценкаСрезПоследних.Пользователь,
	|	МинимальнаяНаценкаСрезПоследних.ПроцентНаценки,
	|	МинимальнаяНаценкаСрезПоследних.Активна,
	|	МинимальнаяНаценкаСрезПоследних.Период = &МоментВремени КАК ЗначениеНаТекущуюДату
	|ИЗ
	|	РегистрСведений.МинимальнаяНаценка.СрезПоследних(&МоментВремени, ) КАК МинимальнаяНаценкаСрезПоследних
	|ГДЕ
	|	МинимальнаяНаценкаСрезПоследних.Активна";
	
	ЗапросМинимальныеНаценки.УстановитьПараметр("МоментВремени", УстДата);
	
	Если ЭтоТипНоменклатуры Тогда
		Если ТипЗнч(ВыборПользовательТипНоменклатуры) = Тип("СправочникСсылка.ТипыНоменклатуры") Тогда
			ТипНоменклатуры = ВыборПользовательТипНоменклатуры;
		Иначе
			ТипНоменклатуры = Справочники.ТипыНоменклатуры.ПустаяСсылка();
		КонецЕсли;
		ЗапросМинимальныеНаценки.УстановитьПараметр("ТипНоменклатуры", ТипНоменклатуры);
		ЗапросМинимальныеНаценки.Текст = СтрЗаменить(
			ЗапросМинимальныеНаценки.Текст,
			"&МоментВремени,",
			"&МоментВремени, ТипНоменклатуры = &ТипНоменклатуры"
		);
	Иначе
		Если ЭтоПользователь Тогда
			Если ТипЗнч(ВыборПользовательТипНоменклатуры) = Тип("СправочникСсылка.Пользователи")
				 И ВыборПользовательТипНоменклатуры <> Справочники.Пользователи.ПустаяСсылка() Тогда
				Пользователь = ВыборПользовательТипНоменклатуры;
			Иначе
				Пользователь = Неопределено;
			КонецЕсли;
		Иначе
			Если ТипЗнч(ВыборПользовательТипНоменклатуры) = Тип("СправочникСсылка.ГруппыДоступа")
				 И ВыборПользовательТипНоменклатуры <> Справочники.ГруппыДоступа.ПустаяСсылка() Тогда
				Пользователь = ВыборПользовательТипНоменклатуры;
			Иначе
				Пользователь = Неопределено;
			КонецЕсли;
		КонецЕсли;
		ЗапросМинимальныеНаценки.УстановитьПараметр("Пользователь", Пользователь);
		ЗапросМинимальныеНаценки.Текст = СтрЗаменить(
			ЗапросМинимальныеНаценки.Текст,
			"&МоментВремени,",
			"&МоментВремени, Пользователь = &Пользователь"
		);
	КонецЕсли;
	
	Результат = ЗапросМинимальныеНаценки.Выполнить();
	ПерваяСтрокаМинимальныхНаценок = ЗначенияМинимальныхНаценок.Добавить();
	Если ЭтоТипНоменклатуры Тогда
		ПерваяСтрокаМинимальныхНаценок.Значение = Неопределено;
	Иначе
		ПерваяСтрокаМинимальныхНаценок.Значение = Справочники.ТипыНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	ПерваяСтрокаМинимальныхНаценок.ПроцентНаценки = 0;
	ПерваяСтрокаМинимальныхНаценок.Активна = Истина;
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ДобавитьСтроку = Истина;
			Если ЭтоТипНоменклатуры Тогда
				Если Выборка.Пользователь = Неопределено Тогда
					ПерваяСтрокаМинимальныхНаценок.ПроцентНаценки = Выборка.ПроцентНаценки;
					ПерваяСтрокаМинимальныхНаценок.ЗначениеНаТекущуюДату = Выборка.ЗначениеНаТекущуюДату;
					ПерваяСтрокаМинимальныхНаценок.Период = Выборка.Период;
					ДобавитьСтроку = Ложь;
				КонецЕсли;
			Иначе
				Если Выборка.ТипНоменклатуры = Справочники.ТипыНоменклатуры.ПустаяСсылка() Тогда
					ПерваяСтрокаМинимальныхНаценок.ПроцентНаценки = Выборка.ПроцентНаценки;
					ПерваяСтрокаМинимальныхНаценок.ЗначениеНаТекущуюДату = Выборка.ЗначениеНаТекущуюДату;
					ПерваяСтрокаМинимальныхНаценок.Период = Выборка.Период;
					ДобавитьСтроку = Ложь;
				КонецЕсли;
			КонецЕсли;
			
			Если ДобавитьСтроку Тогда
				СтрокаМинимальныхНаценок = ЗначенияМинимальныхНаценок.Добавить();
				Если ЭтоТипНоменклатуры Тогда
					СтрокаМинимальныхНаценок.Значение = Выборка.Пользователь;
				Иначе
					СтрокаМинимальныхНаценок.Значение = Выборка.ТипНоменклатуры;
				КонецЕсли;
				СтрокаМинимальныхНаценок.ПроцентНаценки = Выборка.ПроцентНаценки;
				СтрокаМинимальныхНаценок.Активна = Выборка.Активна;
				СтрокаМинимальныхНаценок.ЗначениеНаТекущуюДату = Выборка.ЗначениеНаТекущуюДату;
				СтрокаМинимальныхНаценок.Период = Выборка.Период;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПерваяСтрокаМинимальныхНаценок.Период) Тогда
		ПерваяСтрокаМинимальныхНаценок.ЗначениеНаТекущуюДату = Истина;
		ПерваяСтрокаМинимальныхНаценок.Период = НачалоДня(УстДата);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура Подключаемый_ОбработкаОтветаНаВопрос(РезультатОповещения, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры = "ДатаПриИзменении" Тогда
		
		Если РезультатОповещения = КодВозвратаДиалога.Нет Тогда
			Модифицированность = Ложь;
			Дата = НачалоДня(Дата);
			УстДата = Дата;
			ЗаполнитьТаблицуМинимальныхНаценок();
		ИначеЕсли РезультатОповещения = КодВозвратаДиалога.Да Тогда
			Записать();
			Дата = НачалоДня(Дата);
			УстДата = Дата;
			ЗаполнитьТаблицуМинимальныхНаценок();
		ИначеЕсли РезультатОповещения = КодВозвратаДиалога.Отмена Тогда
			Дата = УстДата;
		КонецЕсли;
		
		Подключаемый_СписокДатПриАктивизацииСтроки();
		
	ИначеЕсли ДополнительныеПараметры = "ВыборДаты" И НЕ РезультатОповещения = Неопределено Тогда
		
		// Добавим выбранную дату в список и установим ее текущей
		Дата = РезультатОповещения;
		Если Дата = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса()) Тогда
			НайденнаяДата = СписокДат.НайтиПоЗначению(Дата("39991231") - 1);
		Иначе
			НайденнаяДата = СписокДат.НайтиПоЗначению(Дата);
		КонецЕсли;
		Если НайденнаяДата = Неопределено Тогда
			НоваяДатаМинимальныеНаценки = СписокДат.Добавить();
			НоваяДатаМинимальныеНаценки.Значение = Дата;
			СписокДат.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
			Элементы.СписокДат.ТекущаяСтрока = НоваяДатаМинимальныеНаценки.ПолучитьИдентификатор();
		Иначе
			Элементы.СписокДат.ТекущаяСтрока = НайденнаяДата.ПолучитьИдентификатор();
		КонецЕсли;
		УстДата = Дата;
		ЗаполнитьТаблицуМинимальныхНаценок();
		Подключаемый_СписокДатПриАктивизацииСтроки();
		
	ИначеЕсли ДополнительныеПараметры = "УдалитьДату" Тогда
		
		Если РезультатОповещения = КодВозвратаДиалога.Да Тогда
			УдалитьМинимальныеНаценки(Элементы.СписокДат.ТекущиеДанные.Значение);
			СписокДат.Удалить(СписокДат.НайтиПоЗначению(Элементы.СписокДат.ТекущиеДанные.Значение));
			Элементы.СписокДат.ТекущаяСтрока = СписокДат.НайтиПоЗначению(Дата("39991231") - 1).ПолучитьИдентификатор();
		КонецЕсли;
		
	ИначеЕсли ДополнительныеПараметры = "ЗакрытьФорму" Тогда
		
		Если РезультатОповещения = КодВозвратаДиалога.Нет Тогда
			Модифицированность = Ложь;
			Закрыть();
		ИначеЕсли РезультатОповещения = КодВозвратаДиалога.Да Тогда
			Записать();
			Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // Подключаемый_ОбработкаРезультатаОповещения()

&НаКлиенте
Процедура УправлениеДиалогом(ИмяКоманды = "", ОчищатьПользователяТипНоменклатуры = Истина);

	Если ИмяКоманды <> "" Тогда
		
		МассивТипов = Новый Массив;
		МассивТиповМинимальныхНаценок = Новый Массив;
		ИзменитьВизуальноеОформление = Ложь;
		Если ИмяКоманды = "ВыборНазначения1" Тогда
			Если НЕ ЭтоПользователь Тогда
				Если ОчищатьПользователяТипНоменклатуры Тогда
					ВыборПользовательТипНоменклатуры = Неопределено;
				КонецЕсли;
				ЭтоПользователь = Истина;
				ЭтоГруппаДоступа = Ложь;
				ЭтоТипНоменклатуры = Ложь;
				Элементы.ВыборТиповНоменклатурПользователей.Заголовок = Элементы.Назначение1.Заголовок;
				Элементы.ВыборПользовательТипНоменклатуры.ПодсказкаВвода = "< Все пользователи >";
				Элементы.ЗначенияМинимальныхНаценокЗначение.Заголовок = НСтр("ru = 'Типы номенклатуры'");
				МассивТипов.Добавить(Тип("СправочникСсылка.Пользователи"));
				МассивТиповМинимальныхНаценок.Добавить(Тип("СправочникСсылка.ТипыНоменклатуры"));
				ИзменитьВизуальноеОформление = Истина;
			КонецЕсли;
		ИначеЕсли ИмяКоманды = "ВыборНазначения2" Тогда
			Если НЕ ЭтоГруппаДоступа Тогда
				Если ОчищатьПользователяТипНоменклатуры Тогда
					ВыборПользовательТипНоменклатуры = Неопределено;
				КонецЕсли;
				ЭтоГруппаДоступа = Истина;
				ЭтоПользователь = Ложь;
				ЭтоТипНоменклатуры = Ложь;
				Элементы.ВыборТиповНоменклатурПользователей.Заголовок = Элементы.Назначение2.Заголовок;
				Элементы.ВыборПользовательТипНоменклатуры.ПодсказкаВвода = "< Все пользователи >";
				Элементы.ЗначенияМинимальныхНаценокЗначение.Заголовок = НСтр("ru = 'Типы номенклатуры'");
				МассивТипов.Добавить(Тип("СправочникСсылка.ГруппыДоступа"));
				МассивТиповМинимальныхНаценок.Добавить(Тип("СправочникСсылка.ТипыНоменклатуры"));
				ИзменитьВизуальноеОформление = Истина;
			КонецЕсли;
		ИначеЕсли ИмяКоманды = "ВыборНазначения3" Тогда
			Если НЕ ЭтоТипНоменклатуры Тогда
				Если ОчищатьПользователяТипНоменклатуры Тогда
					ВыборПользовательТипНоменклатуры = ПредопределенноеЗначение("Справочник.ТипыНоменклатуры.ПустаяСсылка");
				КонецЕсли;
				ЭтоТипНоменклатуры = Истина;
				ЭтоПользователь = Ложь;
				ЭтоГруппаДоступа = Ложь;
				Элементы.ВыборТиповНоменклатурПользователей.Заголовок = Элементы.Назначение3.Заголовок;
				Элементы.ВыборПользовательТипНоменклатуры.ПодсказкаВвода = "< " + НСтр("ru = 'Все типы номенклатур'") + " >";
				Элементы.ЗначенияМинимальныхНаценокЗначение.Заголовок = "Пользователь";
				МассивТипов.Добавить(Тип("СправочникСсылка.ТипыНоменклатуры"));
				МассивТиповМинимальныхНаценок.Добавить(Тип("СправочникСсылка.Пользователи"));
				МассивТиповМинимальныхНаценок.Добавить(Тип("СправочникСсылка.ГруппыДоступа"));
				ИзменитьВизуальноеОформление = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ИзменитьВизуальноеОформление Тогда
			Элементы.ЗначенияМинимальныхНаценокДобавитьПользователя.Видимость = ЭтоТипНоменклатуры;
			Элементы.ЗначенияМинимальныхНаценокДобавитьГруппуДоступа.Видимость = ЭтоТипНоменклатуры;
			Элементы.ЗначенияМинимальныхНаценокДобавитьТипНоменклатуры.Видимость = НЕ ЭтоТипНоменклатуры;
			
			Элементы.Назначение1.Пометка = ЭтоПользователь;
			Элементы.Назначение2.Пометка = ЭтоГруппаДоступа;
			Элементы.Назначение3.Пометка = ЭтоТипНоменклатуры;
			
			Типы = Новый ОписаниеТипов(МассивТипов);
			ТипыДляНаценок = Новый ОписаниеТипов(МассивТиповМинимальныхНаценок);
			Элементы.ВыборПользовательТипНоменклатуры.ОграничениеТипа = Типы;
			Элементы.ЗначенияМинимальныхНаценокЗначение.ОграничениеТипа = ТипыДляНаценок;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Записать()
	
	ТекДата = Дата;
	
	Если Модифицированность Тогда
		ЗаписатьНаСервере();
	КонецЕсли;
	
	НайденнаяСтрока = СписокДат.НайтиПоЗначению(ТекДата);
	Если НайденнаяСтрока <> Неопределено Тогда
		Дата = ТекДата;
		Элементы.СписокДат.ТекущаяСтрока = НайденнаяСтрока.ПолучитьИдентификатор();
	КонецЕсли;
	УстДата = Дата;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	
	Если НЕ ЗначениеЗаполнено(ВыборПользовательТипНоменклатуры) И НЕ ЭтоТипНоменклатуры Тогда
		ВыборПользовательТипНоменклатуры = Неопределено;
	КонецЕсли;
	
	НаборЗаписейМинимальныхНаценок = РегистрыСведений.МинимальнаяНаценка.СоздатьНаборЗаписей();
	Если ЭтоПользователь Или ЭтоГруппаДоступа Тогда
		НаборЗаписейМинимальныхНаценок.Отбор.Пользователь.Установить(ВыборПользовательТипНоменклатуры);
	ИначеЕсли ЭтоТипНоменклатуры Тогда
		НаборЗаписейМинимальныхНаценок.Отбор.ТипНоменклатуры.Установить(ВыборПользовательТипНоменклатуры);
	КонецЕсли;
	НаборЗаписейМинимальныхНаценок.Отбор.Период.Установить(НачалоДня(УстДата));
	НаборЗаписейМинимальныхНаценок.Прочитать();
	
	ТаблицаМинимальныхНаценок = НаборЗаписейМинимальныхНаценок.Выгрузить();
	
	Для Каждого Строка Из ЗначенияМинимальныхНаценок Цикл
		
		Если Не Строка.ЗначениеНаТекущуюДату И Не Строка.Активна Тогда
			УдалитьНаценкуСтарогоПериодаНаСервере(Строка);
			Продолжить;
		КонецЕсли;
		
		Если Не Строка.ЗначениеНаТекущуюДату Тогда
			Продолжить;
		КонецЕсли;
		
		КоличествоЗаписей = 0;
		Отбор = Новый Структура;
		Если ЭтоПользователь Или ЭтоГруппаДоступа Тогда
			Отбор.Вставить("Пользователь", ВыборПользовательТипНоменклатуры);
			Отбор.Вставить("ТипНоменклатуры", Строка.Значение);
		Иначе
			Отбор.Вставить("Пользователь", Строка.Значение);
			Отбор.Вставить("ТипНоменклатуры", ВыборПользовательТипНоменклатуры);
		КонецЕсли;
		Отбор.Вставить("Период", НачалоДня(УстДата));
		
		Если ТаблицаМинимальныхНаценок.НайтиСтроки(Отбор).Количество() = 0 Тогда
			НоваяЗапись = НаборЗаписейМинимальныхНаценок.Добавить();
			НоваяЗапись.Период = (НачалоДня(УстДата));
			Если ЭтоПользователь ИЛИ ЭтоГруппаДоступа Тогда
				НоваяЗапись.Пользователь = ВыборПользовательТипНоменклатуры;
				НоваяЗапись.ТипНоменклатуры = Строка.Значение;
			ИначеЕсли ЭтоТипНоменклатуры Тогда
				НоваяЗапись.ТипНоменклатуры = ВыборПользовательТипНоменклатуры;
				Если ЗначениеЗаполнено(Строка.Значение) Тогда
					НоваяЗапись.Пользователь = Строка.Значение;
				Иначе
					НоваяЗапись.Пользователь = Неопределено;
				КонецЕсли;
			КонецЕсли;
			НоваяЗапись.ПроцентНаценки = Строка.ПроцентНаценки;
			НоваяЗапись.Активна = Строка.Активна;
		Иначе
			Для Каждого Запись Из НаборЗаписейМинимальныхНаценок Цикл
				Если Запись.Пользователь = Отбор.Пользователь
					И Запись.ТипНоменклатуры = Отбор.ТипНоменклатуры
					И Запись.Период = Отбор.Период Тогда
					
					Запись.ПроцентНаценки = Строка.ПроцентНаценки;
					Запись.Активна = Строка.Активна;
					
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		КоличествоЗаписей = КоличествоЗаписей + 1;
	КонецЦикла;
	
	Если КоличествоЗаписей > 0 Тогда
		НаборЗаписейМинимальныхНаценок.Записать();
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	ЗаполнитьДатыМинимальныеНаценки();
	ЗаполнитьТаблицуМинимальныхНаценок();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНаценкуСтарогоПериодаНаСервере(СтрокаНаценки)
	
	НаборЗаписейМинимальныхНаценок = РегистрыСведений.МинимальнаяНаценка.СоздатьНаборЗаписей();
	Если ЭтоПользователь Или ЭтоГруппаДоступа Тогда
		НаборЗаписейМинимальныхНаценок.Отбор.Пользователь.Установить(ВыборПользовательТипНоменклатуры);
		НаборЗаписейМинимальныхНаценок.Отбор.ТипНоменклатуры.Установить(СтрокаНаценки.Значение);
	ИначеЕсли ЭтоТипНоменклатуры Тогда
		НаборЗаписейМинимальныхНаценок.Отбор.Пользователь.Установить(СтрокаНаценки.Значение);
		НаборЗаписейМинимальныхНаценок.Отбор.ТипНоменклатуры.Установить(ВыборПользовательТипНоменклатуры);
	КонецЕсли;
	НаборЗаписейМинимальныхНаценок.Отбор.Период.Установить(НачалоДня(СтрокаНаценки.Период));
	НаборЗаписейМинимальныхНаценок.Прочитать();
	Для Каждого Запись Из НаборЗаписейМинимальныхНаценок Цикл
		Запись.Активна = Ложь;
	КонецЦикла;
	
	НаборЗаписейМинимальныхНаценок.Записать();
	
КонецПроцедуры

// Удаляет значение минимальных наценок на выбранную дату
&НаСервере
Процедура УдалитьМинимальныеНаценки(УдаляемаяДата)
	
КонецПроцедуры // УдалитьМинимальныеНаценки()

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Текст
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ЗначенияМинимальныхНаценокЗначение");
	
	ГруппаОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭтоТипНоменклатуры");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗначенияМинимальныхНаценок.Значение");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '< Все пользователи >'"));
	
	// Текст
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ЗначенияМинимальныхНаценокЗначение");
	
	ГруппаОтбора1 = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ГруппаОтбора2 = ГруппаОтбора1.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗначенияМинимальныхНаценок.Значение");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЭтоПользователь");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЭтоТипНоменклатуры");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ГруппаОтбора2 = ГруппаОтбора1.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗначенияМинимальныхНаценок.Значение");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЭтоГруппаДоступа");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЭтоТипНоменклатуры");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '< Все типы номенклатуры >'"));
	
	// Видимость
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ЗначенияМинимальныхНаценокЗначение");
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ЗначенияМинимальныхНаценокПроцентНаценки");
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ЗначенияМинимальныхНаценокАктивна");
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗначенияМинимальныхНаценок.Активна");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ЗначенияМинимальныхНаценокЗначение");
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ЗначенияМинимальныхНаценокПроцентНаценки");
	
	ГруппаОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗначенияМинимальныхНаценок.ЗначениеНаТекущуюДату");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокДат.Представление");
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = НСтр("ru = 'Текущая дата'");
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ВычисленноеПравоДоступаЦвет);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокДатПриАктивизацииСтроки()Экспорт
	
	// Если форма была изменена, зададим вопрос пользователю.
	Если Модифицированность Тогда
		
		// Формируем описание обработчика перехвата закрытия формы.
		ОбработчикВопроса = Новый ОписаниеОповещения("Подключаемый_ОбработкаОтветаНаВопрос", ЭтотОбъект, "ДатаПриИзменении");
		
		// Формируем текст вопроса
		ТекстВопроса = НСтр("ru = 'Настройки были изменены. Сохранить?'");
		
		// Получаем подтверждение операции от пользователя.
		ПоказатьВопрос(ОбработчикВопроса, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	ИначеЕсли Элементы.СписокДат.ТекущиеДанные.Представление = "ВЫБРАТЬ дату" Тогда
		
		// Формируем описание обработчика перехвата закрытия формы.
		ОбработчикВопроса = Новый ОписаниеОповещения("Подключаемый_ОбработкаОтветаНаВопрос", ЭтотОбъект,"ВыборДаты");
		ПоказатьВводДаты(ОбработчикВопроса,Дата, , ЧастиДаты.Дата);
		
	ИначеЕсли Элементы.СписокДат.ТекущиеДанные.Представление = НСтр("ru = 'Текущая дата'") Тогда
		
		Дата = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
		УстДата = Дата;
		
		ЗаполнитьТаблицуМинимальныхНаценок();
		
	ИначеЕсли НЕ Элементы.СписокДат.ТекущиеДанные = Неопределено
		И НЕ Дата = НачалоДня(Элементы.СписокДат.ТекущиеДанные.Значение) Тогда
		
		Дата = НачалоДня(Элементы.СписокДат.ТекущиеДанные.Значение);
		УстДата = Дата;
		ЗаполнитьТаблицуМинимальныхНаценок();
		
	Иначе
		
		ЗаполнитьТаблицуМинимальныхНаценок();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТаблицыДатИНаценок()
	
	ЗаполнитьДатыМинимальныеНаценки();
	УстДата = Дата;
	ЗаполнитьТаблицуМинимальныхНаценок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьУдалитьЗначение(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Не Результат = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	ТекущиеДанные = ЗначенияМинимальныхНаценок.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
	Если Не ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные.Активна = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораТиповНоменклатурПользователей()
	
	УправлениеДиалогом(ИмяКоманды);
	
	ЗаполнитьДатыМинимальныеНаценки();
	УстДата = Дата;
	ЗаполнитьТаблицуМинимальныхНаценок();
	
	Подключаемый_СписокДатПриАктивизацииСтроки();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти