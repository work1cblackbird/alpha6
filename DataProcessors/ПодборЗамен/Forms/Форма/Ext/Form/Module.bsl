﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшТекущаяСтрока; // Храним значение номенклатуры для которой выводится информация.

&НаКлиенте
Перем КэшТекущаяНоменклатура; // Храним значение номенклатуры для которой выводится информация.

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// заполним таблицу подбора
	Если Параметры.Свойство("ТаблицаДокумента") Тогда
		ЗагрузитьДанныеДокумента(Параметры.ТаблицаДокумента);
	КонецЕсли;
	
	Если Параметры.Свойство("СкладКомпанииОстатки")
		И ЗначениеЗаполнено(Параметры.СкладКомпанииОстатки) Тогда
		
		Склады = Новый Массив;
		Склады.Добавить(Параметры.СкладКомпанииОстатки);
		ДоступныеСклады = Новый ФиксированныйМассив(Склады);
		
	Иначе
		ДоступныеСклады = Новый ФиксированныйМассив(Новый Массив);
	КонецЕсли;
	
	Если Параметры.ДоступныеСклады = "установить" И ЗначениеЗаполнено(Параметры.ПодразделениеКомпании) Тогда
		
		ДоступныеСклады = СкладыПоПодразделению(Параметры.ПодразделениеКомпании);
		
	КонецЕсли;
	
	ДоступныеСкладыПредставление = ПредставлениеДоступныхСкладов(ДоступныеСклады);
	ОстаткиТоваров.Параметры.УстановитьЗначениеПараметра("СкладыКомпании", ДоступныеСклады);
	
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	
	Элементы.СписокНоменклатура.ОтборСтрок = Новый ФиксированнаяСтруктура("ОтображатьВПодборе", Истина);
	УстановитьПараметрыСпискаАналогов(ЭтотОбъект);
	УстановитьПараметрыСписковЗаказов(ЭтотОбъект, Объект.ПодразделениеКомпании);
	ОбновитьДополнительныеСвойстваСписков(ЭтотОбъект);
	
	Поля = Новый Массив();
	Поля.Добавить("Цена");
	
	Аналоги.УстановитьОграниченияИспользованияВГруппировке(Поля);
	Аналоги.УстановитьОграниченияИспользованияВПорядке(Поля);
	Аналоги.УстановитьОграниченияИспользованияВОтборе(Поля);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Для Каждого КлючЗначение Из Настройки Цикл
		Если КлючЗначение.Ключ = "ДоступныеСклады" Тогда
			Склады = Новый Массив(КлючЗначение.Значение);
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Склады, Новый Массив(ДоступныеСклады), Истина);
			ДоступныеСклады = Новый ФиксированныйМассив(Склады);
			ДоступныеСкладыПредставление = ПредставлениеДоступныхСкладов(ДоступныеСклады);
			ОстаткиТоваров.Параметры.УстановитьЗначениеПараметра("СкладыКомпании", ДоступныеСклады);
		КонецЕсли;
		Если КлючЗначение.Ключ = "ТолькоВНаличии" Тогда
			ТолькоВНаличииПриИзмененииНаСервере();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказатьДополнительнуюИнформациюНажатие(Элемент)
	
	Элементы.ПоказатьДополнительнуюИнформацию.Видимость = Ложь;
	Элементы.СкрытьДополнительнуюИнформацию.Видимость = Истина;
	Элементы.СтраницыДополнительнаяИнформация.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьДополнительнуюИнформациюНажатие(Элемент)
	
	Элементы.ПоказатьДополнительнуюИнформацию.Видимость = Истина;
	Элементы.СкрытьДополнительнуюИнформацию.Видимость = Ложь;
	Элементы.СтраницыДополнительнаяИнформация.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеКомпанииПриИзменении(Элемент)
	
	УстановитьПараметрыСписковЗаказов(ЭтотОбъект, Объект.ПодразделениеКомпании);
	ДоступныеСклады = СкладыПоПодразделению(Объект.ПодразделениеКомпании);
	ДоступныеСкладыПредставление = ПредставлениеДоступныхСкладов(ДоступныеСклады);
	ОстаткиТоваров.Параметры.УстановитьЗначениеПараметра("СкладыКомпании", ДоступныеСклады);
	
	Если Элементы.СписокНоменклатура.ТекущиеДанные <> Неопределено Тогда
		
		ТекущийАртикул = Элементы.СписокНоменклатура.ТекущиеДанные.Артикул;
		ТекущийПроизводитель = Элементы.СписокНоменклатура.ТекущиеДанные.Производитель;
		ОбновитьСвязаннуюИнформацию(
			Элементы.СписокНоменклатура.ТекущиеДанные.Номенклатура, ТекущийАртикул, ТекущийПроизводитель);
		
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ПриАктивизацииСтроки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоИзСправочникаПриИзменении(Элемент)
	
	Если ТолькоИзСправочника Тогда
		
		Если ТолькоВНаличии Тогда
			Элементы.Замены.ОтборСтрок = Новый ФиксированнаяСтруктура("ЕстьВНаличии, ЕстьВСправочнике", Истина, Истина);
		Иначе
			Элементы.Замены.ОтборСтрок = Новый ФиксированнаяСтруктура("ЕстьВСправочнике", Истина);
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Аналоги,
			"Номенклатура",
			ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"),
			ВидСравненияКомпоновкиДанных.НеРавно,
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,
			"ТолькоИзСправочника");
			
	Иначе
		
		Если ТолькоВНаличии Тогда
			Элементы.Замены.ОтборСтрок = Новый ФиксированнаяСтруктура("ЕстьВНаличии", Истина);
		Иначе
			Элементы.Замены.ОтборСтрок = Неопределено;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.
			УдалитьЭлементыГруппыОтбораДинамическогоСписка(Аналоги, "Номенклатура", "ТолькоИзСправочника");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоВНаличииПриИзменении(Элемент)
	
	ТолькоВНаличииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ТолькоВНаличииПриИзмененииНаСервере()

	Если ТолькоВНаличии Тогда
		
		Если ТолькоИзСправочника Тогда
			Элементы.Замены.ОтборСтрок = Новый ФиксированнаяСтруктура("ЕстьВНаличии, ЕстьВСправочнике", Истина, Истина);
		Иначе
			Элементы.Замены.ОтборСтрок = Новый ФиксированнаяСтруктура("ЕстьВНаличии", Истина);
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Аналоги,
			"Количество",
			0,
			ВидСравненияКомпоновкиДанных.Больше,
			"ТолькоВНаличии",
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный,
			"ТолькоВНаличии");
		
	Иначе
		
		Если ТолькоИзСправочника Тогда 
			Элементы.Замены.ОтборСтрок = Новый ФиксированнаяСтруктура("ЕстьВСправочнике", Истина);
		Иначе
			Элементы.Замены.ОтборСтрок = Неопределено;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.
			УдалитьЭлементыГруппыОтбораДинамическогоСписка(Аналоги, "Количество", "ТолькоВНаличии");
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДоступныеСкладыПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Обработчик = Новый ОписаниеОповещения("РедактированиеДоступныхСкладовЗавершение", ЭтотОбъект);
	ПараметрыФормы = Новый Структура("ДоступныеСклады", ДоступныеСклады);
	
	ОткрытьФорму(
		"Обработка.ПодборЗамен.Форма.РедактированиеДоступныхСкладов",
		ПараметрыФормы,
		ЭтотОбъект,
		ЭтотОбъект,
		,
		,
		Обработчик,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаменыИАналогиПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница.Имя = "СтраницаАналоги" Тогда
		//@skip-check invocation-form-event-handler
		АналогиПриАктивизацииСтроки(Элементы.Аналоги);
	Иначе
		//@skip-check invocation-form-event-handler
		ЗаменыПриАктивизацииСтроки(Элементы.Замены);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательЦеныПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("Подключаемый_ПриАктивизацииСтроки", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокНоменклатура

&НаКлиенте
Процедура СписокНоменклатураНоменклатураПриИзменении(Элемент)
	
	ОбработатьИзменениеНоменклатуры();
	ПодключитьОбработчикОжидания("Подключаемый_ОтложеноСписокНоменклатураПриАктивизацииСтроки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатураПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("Подключаемый_ОтложеноСписокНоменклатураПриАктивизацииСтроки", 0.3 , Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатураПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.СтрокаВДокументе = -1;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьКарточкуТовара(Команда)
	
	ТекДанные = ТекущийЭлемент.ТекущиеДанные;
	Если ТекДанные <> Неопределено
		И ТекДанные.Свойство("Номенклатура")
		И ЗначениеЗаполнено(ТекДанные.Номенклатура) Тогда
		
		ПараметрыОткрытия = Новый Структура("Ключ", ТекДанные.Номенклатура);
		ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", ПараметрыОткрытия);
		
	ИначеЕсли ТекДанные <> Неопределено
		И ТекДанные.Свойство("Номенклатура") Тогда
		
		НачатьСозданиеНоменклатуры(ТекущийЭлемент.Имя);
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовуюНоменклатуру(Команда)
	
	Если ТекущийЭлемент.Имя = "Замены" ИЛИ ТекущийЭлемент.Имя = "Аналоги" Тогда
		
		НачатьСозданиеНоменклатуры(ТекущийЭлемент.Имя, , Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВДокумент(Команда)
	
	Закрыть(УпаковатьДанныеКЗакрытию(Объект.СписокНоменклатура, ВладелецФормы.УникальныйИдентификатор));
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПараметры(Команда)
	
	Элементы.ФильтрыИПараметры.Видимость = Истина;
	Элементы.ПоказатьПараметры.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьПараметры(Команда)
	
	Элементы.ФильтрыИПараметры.Видимость = Ложь;
	Элементы.ПоказатьПараметры.Видимость = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИнформациюОНоменклатуре(Форма,Номенклатура = Неопределено, Артикул = "")
	
	Форма.Элементы.ИнформацияОНоменклатуре.Заголовок = НСтр("ru = 'Артикул:'")
		+ Символы.НПП + Артикул + Символы.НПП + НСтр("ru = 'Номенклатура:'") + Символы.НПП + Строка(Номенклатура);
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция СкладыПоПодразделению(Подразделение = Неопределено)
	
	Если Подразделение = Неопределено Тогда
		
		Возврат Новый ФиксированныйМассив(Новый Массив);
		
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СкладыКомпании.Ссылка
	|ИЗ
	|	Справочник.СкладыКомпании КАК СкладыКомпании
	|ГДЕ
	|	СкладыКомпании.ПодразделениеКомпании В ИЕРАРХИИ (&Подразделение)");
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат Новый ФиксированныйМассив(Новый Массив);
		
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ИменаТаблицЗамен = Новый Массив;
	ИменаТаблицЗамен.Добавить("Замены");
	ИменаТаблицЗамен.Добавить("Аналоги");
	ЗаменыСервер.УстановитьУсловноеОформление(ЭтотОбъект, ИменаТаблицЗамен);
	
	// Цены.
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Представление = НСтр("ru = 'Цена'");
	
	ЭлементОформления.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.Цены.Имя);
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Цены.ТипЦен");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТипЦен");
	ЭлементОтбора.Использование = Истина;
	
	//@skip-check new-font
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт",
		Новый Шрифт(WindowsШрифты.ШрифтДиалоговИМеню,, 8, Истина));
	
	// Замены
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Представление = НСтр("ru = 'Замены'");
	
	ЭлементОформления.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.Замены.Имя);
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Замены.СвободныйОстаток");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ЭлементОтбора.ПравоеЗначение = 0;
	ЭлементОтбора.Использование = Истина;
	
	//@skip-check new-color
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(0 , 128, 0));
	
	// Аналоги
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Представление = НСтр("ru = 'Цена'");
	
	ЭлементОформления.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.Аналоги.Имя);
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Аналоги.СвободныйОстаток");	
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ЭлементОтбора.ПравоеЗначение = 0;
	ЭлементОтбора.Использование = Истина;
	
	//@skip-check new-color
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(0 , 128, 0));
	
КонецПроцедуры

&НаКлиенте
Функция ТребуетсяОбновлениеСвязаннойИнформации(ТекущаяСтрока)
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат КэшТекущаяНоменклатура <> Объект.СписокНоменклатура.НайтиПоИдентификатору(ТекущаяСтрока).Номенклатура;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСвязаннуюИнформацию(Номенклатура=Неопределено, Артикул = "", Производитель = Неопределено)
	
	УстановитьПараметрыСпискаАналогов(ЭтотОбъект, Артикул, Производитель);
	НачатьОбновлениеЗаменНоменклатуры(Артикул, Производитель);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыСпискаАналогов(Форма, Артикул = "", Производитель = Неопределено)
	
	Форма.Аналоги.Параметры.УстановитьЗначениеПараметра(
		"АртикулДляПоиска", ПодборТоваровКлиентСервер.ВАртикулДляПоиска(Артикул));
	Форма.Аналоги.Параметры.УстановитьЗначениеПараметра(
		"Производитель", Производитель);
	
	СписокСкладов = Новый СписокЗначений;
	СписокСкладов.ЗагрузитьЗначения(Новый Массив(Форма.ДоступныеСклады));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Аналоги,
		"Склад",
		СписокСкладов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыСписковЗаказов(Форма, Подразделение)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.ЗаказыПокупателей,
			"ПодразделениеКомпании",
			Подразделение,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.ЗаказыПоставщикам,
			"ПодразделениеКомпании",
			Подразделение,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьДополнительныеСвойстваСписков(Форма)
	
	ДобавляемыеЗначения = Новый Структура("ТипЦен,Валюта,ПодразделениеКомпании");
	
	ЗаполнитьЗначенияСвойств(ДобавляемыеЗначения, Форма.Объект);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(
		Форма.Аналоги.КомпоновщикНастроек.Настройки.ДополнительныеСвойства,
		ДобавляемыеЗначения,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеЗаменНоменклатуры(Артикул, Производитель)
	
	ИдентификаторЗадания = Неопределено;
	
	Если Не ЗначениеЗаполнено(Артикул) Тогда
		
		Элементы.СостоянияЗамен.ТекущаяСтраница = Элементы.ЗаменыИнформация;
		Возврат;
		
	КонецЕсли;
	
	ДополнительныеДанные = Новый Структура("НаСкладе", ДоступныеСклады);
	
	Элементы.СостоянияЗамен.ТекущаяСтраница = Элементы.ЗаменыОбновление;
	ПодборТоваровКлиент.НачатьОбновлениеЗаменНоменклатуры(
		Артикул,
		Производитель,
		ЭтотОбъект,
		"Подключаемый_ОбновлениеЗаменНоменклатурыЗавершение",
		ДополнительныеДанные
	);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьСозданиеНоменклатуры(ТочкаВызова, Интерактивно = Ложь, Выбор = Ложь)
	
	ТекущиеДанные = ТекущийЭлемент.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбрана строка для создания номенклатуры.'"));
		Возврат;
		
	КонецЕсли;
	
	Если НЕ ТекущиеДанные.Номенклатура.Пустая() Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Для выбраной строки уже существует номенклатура.'"));
		Возврат;
		
	КонецЕсли;
	
	//@skip-check structure-consructor-too-many-keys
	ДанныеЗаполнения = Новый Структура("Артикул,АртикулДляПоиска,Производитель,Наименование");
	ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, ТекущиеДанные);
	ДанныеЗаполнения.АртикулДляПоиска = ПодборТоваровКлиентСервер.ВАртикулДляПоиска(ТекущиеДанные.Артикул);
	ПараметрыОбратногоВызова = Новый Структура;
	ИдентификаторСтроки = Новый Структура;
	ИдентификаторСтроки.Вставить("ТочкаВызова", ТочкаВызова);
	ИдентификаторСтроки.Вставить("ИдентификаторСтроки", ТекущийЭлемент.ТекущаяСтрока);
	ПараметрыОбратногоВызова.Вставить("ИдентификаторСтроки", ИдентификаторСтроки);
	ПараметрыОбратногоВызова.Вставить("ПродолжитьВыбор", Выбор);
	ОбратныйВызов = Новый ОписаниеОповещения(
		"Подключаемый_СозданиеНоменклатурыЗавершение", ЭтотОбъект, ПараметрыОбратногоВызова);
	ПоискВПрайсЛистахКлиент.НачатьСозданиеНоменклатуры(ДанныеЗаполнения, ЭтотОбъект, ОбратныйВызов, Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УпаковатьДанныеКЗакрытию(Знач Таблица, ИдентификаторВладельца)
	
	Возврат ПоместитьВоВременноеХранилище(Таблица.Выгрузить(), ИдентификаторВладельца);
	
КонецФункции

&НаКлиенте
Процедура РедактированиеДоступныхСкладовЗавершение(Результат, ДопСвойства=Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	ДоступныеСклады = Результат;
	ДоступныеСкладыПредставление = ПредставлениеДоступныхСкладов(Результат);
	ОстаткиТоваров.Параметры.УстановитьЗначениеПараметра("СкладыКомпании", ДоступныеСклады);
	
	ЕстьДанные = Элементы.СписокНоменклатура.ТекущиеДанные <> Неопределено;
	ОбновитьСвязаннуюИнформацию(?(ЕстьДанные, Элементы.СписокНоменклатура.ТекущиеДанные.Номенклатура, Неопределено),
		?(ЕстьДанные, Элементы.СписокНоменклатура.ТекущиеДанные.Артикул, ""),
		?(ЕстьДанные, Элементы.СписокНоменклатура.ТекущиеДанные.Производитель, Неопределено));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеДоступныхСкладов(Склады)
	
	Если НЕ ЗначениеЗаполнено(Склады) ИЛИ Склады.Количество() = 0 Тогда
		
		Возврат НСтр("ru = 'Не заданы доступные склады'");
		
	КонецЕсли;
	
	Возврат СтрСоединить(Склады, ", ");
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ОбновитьИнформациюОНоменклатуре()
	
	ОбновитьИнформациюОНоменклатуре(ЭтотОбъект, ТекущаяНоменклатура, ТекущийАртикул);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриАктивизацииСтроки()
	
	Если ПереключательЦены = 0 Тогда
		НачатьОбновлениеЦен(ТекущаяНоменклатура);
	ИначеЕсли ПереключательЦены = 1 Тогда
		НачатьОбновлениеЦенКонтрагентов(ТекущаяНоменклатура);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеЦен(Номенклатура)
	
	Цены.Очистить();
	ИдентификаторЗаданияЦен = Неопределено;
	
	Если Не ЗначениеЗаполнено(Номенклатура) Тогда
		
		Элементы.СтраницыЦены.ТекущаяСтраница = Элементы.СтраницаЦеныКомпании;
		Возврат;
		
	КонецЕсли;
	
	Элементы.СтраницыЦены.ТекущаяСтраница = Элементы.ЦеныОбновление;
	
	ПодборТоваровКлиент.НачатьОбновлениеЦен(
		Номенклатура,
		Объект.ПодразделениеКомпании,
		ЭтотОбъект,
		"Подключаемый_ОбновлениеЦенЗавершение"
	);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеЦенКонтрагентов(Номенклатура)
	
	ЦеныКонтрагентов.Очистить();
	ИдентификаторЗаданияЦенКонтрагентов = Неопределено;
	
	Если Не ЗначениеЗаполнено(Номенклатура) Тогда
		
		Элементы.СтраницыЦены.ТекущаяСтраница = Элементы.СтраницаЦеныКомпании;
		Возврат;
		
	КонецЕсли;
	
	Элементы.СтраницыЦены.ТекущаяСтраница = Элементы.ЦеныОбновление;
	
	ПодборТоваровКлиент.НачатьОбновлениеЦенКонтрагентов(
		Номенклатура,
		Объект.ПодразделениеКомпании,
		ЭтотОбъект,
		"Подключаемый_ОбновлениеЦенКонтрагентовЗавершение"
	);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновлениеЦенЗавершение(Результат, ИдентификаторВыполненогоЗадания) Экспорт
	
	Если
		Не ЗначениеЗаполнено(Результат)
		Или Результат.Статус <> "Выполнено"
		Или ИдентификаторВыполненогоЗадания <> ИдентификаторЗаданияЦен
	Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЗначенияЦен = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Для Каждого Строка Из ЗначенияЦен Цикл
		
		ЗаполнитьЗначенияСвойств(Цены.Добавить(), Строка);
		
	КонецЦикла;
	
	Элементы.СтраницыЦены.ТекущаяСтраница = Элементы.СтраницаЦеныКомпании;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновлениеЦенКонтрагентовЗавершение(Результат, ИдентификаторВыполненогоЗадания) Экспорт
	
	Если
		Не ЗначениеЗаполнено(Результат)
		Или Результат.Статус <> "Выполнено"
		Или ИдентификаторВыполненогоЗадания <> ИдентификаторЗаданияЦенКонтрагентов
	Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЗначенияЦен = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Для Каждого Строка Из ЗначенияЦен Цикл
		
		ЗаполнитьЗначенияСвойств(ЦеныКонтрагентов.Добавить(), Строка);
		
	КонецЦикла;
	
	Элементы.СтраницыЦены.ТекущаяСтраница = Элементы.СтраницаЦеныКонтрагентов;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеДокумента(АдресДанных)
	
	ДанныеДокумента = ПолучитьИзВременногоХранилища(АдресДанных);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТЧДокумента.Номенклатура КАК Номенклатура,
	|	ТЧДокумента.СтрокаВДокументе КАК СтрокаВДокументе,
	|	ТЧДокумента.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ТЧДокумента.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ТЧДокумента.Коэффициент КАК Коэффициент,
	|	ТЧДокумента.Количество КАК Количество,
	|	ТЧДокумента.Цена КАК Цена
	|ПОМЕСТИТЬ ВТ_ТЧДокументаПредв
	|ИЗ
	|	&ТЧДокумента КАК ТЧДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТЧДокументаПредв.Номенклатура КАК Номенклатура,
	|	ВТ_ТЧДокументаПредв.СтрокаВДокументе КАК СтрокаВДокументе,
	|	ВТ_ТЧДокументаПредв.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ВТ_ТЧДокументаПредв.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВТ_ТЧДокументаПредв.Коэффициент КАК Коэффициент,
	|	ВТ_ТЧДокументаПредв.Номенклатура.Артикул КАК Артикул,
	|	ВТ_ТЧДокументаПредв.Количество КАК Количество,
	|	ВТ_ТЧДокументаПредв.Цена КАК Цена,
	|	спрНоменклатура.АртикулДляПоиска КАК АртикулДляПоиска,
	|	спрНоменклатура.Производитель КАК Производитель
	|ПОМЕСТИТЬ ВТ_ТЧДокумента
	|ИЗ
	|	ВТ_ТЧДокументаПредв КАК ВТ_ТЧДокументаПредв
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК спрНоменклатура
	|		ПО ВТ_ТЧДокументаПредв.Номенклатура = спрНоменклатура.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТЧДокумента.Номенклатура КАК Номенклатура,
	|	ИСТИНА КАК ЕстьЗамены
	|ПОМЕСТИТЬ НоменклатурыСЗаменами
	|ИЗ
	|	РегистрСведений.Замены КАК Замены
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ТЧДокумента КАК ВТ_ТЧДокумента
	|		ПО Замены.АртикулДляПоиска = ВТ_ТЧДокумента.АртикулДляПоиска
	|			И Замены.Производитель = ВТ_ТЧДокумента.Производитель
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_ТЧДокумента.Номенклатура,
	|	ИСТИНА
	|ИЗ
	|	РегистрСведений.Замены КАК Замены
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ТЧДокумента КАК ВТ_ТЧДокумента
	|		ПО Замены.АртикулЗаменыДляПоиска = ВТ_ТЧДокумента.АртикулДляПоиска
	|			И Замены.Производитель = ВТ_ТЧДокумента.Производитель
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_ТЧДокумента.Номенклатура,
	|	ИСТИНА
	|ИЗ
	|	РегистрСведений.ГруппыАналогов КАК ГруппыАналогов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ТЧДокумента КАК ВТ_ТЧДокумента
	|		ПО ГруппыАналогов.АртикулДляПоиска = ВТ_ТЧДокумента.АртикулДляПоиска
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_ТЧДокумента.Номенклатура КАК Номенклатура,
	|	ВТ_ТЧДокумента.СтрокаВДокументе КАК СтрокаВДокументе,
	|	ВТ_ТЧДокумента.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ВТ_ТЧДокумента.Артикул КАК Артикул,
	|	ВТ_ТЧДокумента.Производитель КАК Производитель,
	|	ВТ_ТЧДокумента.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВТ_ТЧДокумента.Коэффициент КАК Коэффициент,
	|	ВТ_ТЧДокумента.Количество КАК Количество,
	|	ВТ_ТЧДокумента.Цена КАК Цена,
	|	ЕСТЬNULL(НоменклатурыСЗаменами.ЕстьЗамены, ЛОЖЬ) КАК ОтображатьВПодборе
	|ИЗ
	|	ВТ_ТЧДокумента КАК ВТ_ТЧДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ НоменклатурыСЗаменами КАК НоменклатурыСЗаменами
	|		ПО ВТ_ТЧДокумента.Номенклатура = НоменклатурыСЗаменами.Номенклатура";
	
	Запрос.УстановитьПараметр("ТЧДокумента", ДанныеДокумента);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(Объект.СписокНоменклатура.Добавить(), Выборка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура АналогиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбраннаяСтрока = Элементы.Аналоги.ТекущиеДанные;
	
	Если НЕ ЗначениеЗаполнено(ВыбраннаяСтрока.Номенклатура) Тогда
		НачатьСозданиеНоменклатуры("Аналоги", , Истина);
		Возврат;
	КонецЕсли;
	
	ТекСтрока = Объект.СписокНоменклатура.НайтиПоИдентификатору(КэшТекущаяСтрока);
	
	Если ТекСтрока <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ТекСтрока, ВыбраннаяСтрока, "Номенклатура, Артикул, Производитель");
		ТекСтрока.ХарактеристикаНоменклатуры = Неопределено;
		КэшТекущаяСтрока = Неопределено;
		ТекСтрока.Цена = 0;
		КэшТекущаяНоменклатура = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
		ПодключитьОбработчикОжидания("Подключаемый_ОтложеноСписокНоменклатураПриАктивизацииСтроки", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОтложеноСписокНоменклатураПриАктивизацииСтроки()
	
	Если Элементы.СписокНоменклатура.ТекущиеДанные = Неопределено Тогда
		КэшТекущаяСтрока = Неопределено;
		Возврат;
	КонецЕсли;
	
	КэшТекущаяСтрока = Элементы.СписокНоменклатура.ТекущиеДанные.ПолучитьИдентификатор();
	
	Если НЕ ТребуетсяОбновлениеСвязаннойИнформации(Элементы.СписокНоменклатура.ТекущиеДанные.ПолучитьИдентификатор()) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	КэшТекущаяНоменклатура = Элементы.СписокНоменклатура.ТекущиеДанные.Номенклатура;
	
	ТекущийАртикул = Элементы.СписокНоменклатура.ТекущиеДанные.Артикул;
	ТекущийПроизводитель = Элементы.СписокНоменклатура.ТекущиеДанные.Производитель;
		
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьИнформациюОНоменклатуре", 0.1, Истина);
	
	ОбновитьСвязаннуюИнформацию(КэшТекущаяНоменклатура, ТекущийАртикул, ТекущийПроизводитель);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновлениеЗаменНоменклатурыЗавершениеНаСервере()
	
	Для Каждого Строка Из Замены Цикл
		
		Строка.Цена = ЦенообразованиеСервер.ПолучитьЦену(
			Объект.ТипЦен,
			Строка.Номенклатура,
			, ,
			Объект.Валюта,
			, , ,
			Объект.ПодразделениеКомпании
		);
		
	КонецЦикла;
	
КонецПроцедуры

#Область ПрограммныйИнтерфейс

// Завершение обработки обновления замен номенклатуры.
//
// Параметры:
//  Результат - Структура - Результат выполнения обновления замен номенклатуры.
//  ИдентификаторВыполненогоЗадания - УникальныйИдентификатор - Идентификатор текущего активного задания
//
&НаКлиенте
Процедура Подключаемый_ОбновлениеЗаменНоменклатурыЗавершение(Результат, ИдентификаторВыполненогоЗадания) Экспорт
	
	Если ИдентификаторВыполненогоЗадания = ИдентификаторЗадания ИЛИ Не ЗначениеЗаполнено(ИдентификаторВыполненогоЗадания) Тогда
		
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
			Если Результат.Статус <> "Выполнено" Тогда
				
				Возврат;
				
			КонецЕсли;
			
			СтарыеЗамены = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
			НовыеЗамены = ПолучитьИзВременногоХранилища(Результат.АдресДополнительногоРезультата);
			
			Замены.Очистить();
			
			Для Каждого Строка Из СтарыеЗамены Цикл
				
				Замена = Замены.Добавить();
				ЗаполнитьЗначенияСвойств(Замена, Строка);
				Замена.ЕстьВСправочнике = Строка.Номенклатура <> ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
				Замена.ЕстьВНаличии = Строка.Количество > 0;
				
			КонецЦикла;
			
			Для Каждого Строка Из НовыеЗамены Цикл
				
				Замена = Замены.Добавить();
				ЗаполнитьЗначенияСвойств(Замена, Строка);
				Замена.ЕстьВСправочнике = Строка.Номенклатура <> ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
				Замена.ЕстьВНаличии = Строка.Количество > 0;
				
			КонецЦикла;
			
			Элементы.СостоянияЗамен.ТекущаяСтраница = Элементы.ЗаменыИнформация;
			Подключаемый_ОбновлениеЗаменНоменклатурыЗавершениеНаСервере();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Завершение обработки создания номенклатуры.
//
// Параметры:
//  Результат - СправочникСсылка.Номенклатура - Ссылка на созданную номенклатуру.
//  Контекст     - Структура                     - Дополнительные параметры обработки события.
//
&НаКлиенте
Процедура Подключаемый_СозданиеНоменклатурыЗавершение(Результат, Контекст) Экспорт
	
	Номенклатура = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Результат, "Номенклатура");
	
	Если Номенклатура = Неопределено Тогда
		
		Номенклатура = ПолучитьЗначениеПараметраСтруктуры(Контекст, "ДобавленнаяСсылка");
		Производитель = ПолучитьЗначениеПараметраСтруктуры(Контекст, "Производитель");
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекСтрока = Элементы[Контекст.ИдентификаторСтроки.ТочкаВызова].ТекущиеДанные;
	
	Если Контекст.ИдентификаторСтроки.ТочкаВызова = "Замены" Тогда
		
		СтрокаДобавления = Замены.НайтиПоИдентификатору(Контекст.ИдентификаторСтроки.ИдентификаторСтроки);
		СтрокаДобавления.Номенклатура = Номенклатура;
		
	Иначе
		
		Элементы.Аналоги.Обновить();
		
	КонецЕсли;
	
	Если НЕ ПолучитьЗначениеПараметраСтруктуры(Контекст, "ПродолжитьВыбор", Ложь) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Строка = Объект.СписокНоменклатура.НайтиПоИдентификатору(КэшТекущаяСтрока);
	
	Если Строка <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Строка, ТекСтрока, "Артикул");
		Строка.Номенклатура = Номенклатура;
		Строка.Производитель = Производитель;
		Строка.Цена = 0;
		КэшТекущаяСтрока = Неопределено;
		КэшТекущаяНоменклатура = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
		ПодключитьОбработчикОжидания("Подключаемый_ОтложеноСписокНоменклатураПриАктивизацииСтроки", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ОбработатьИзменениеНоменклатуры()
	
	ТекущиеДанные = Объект.СписокНоменклатура.НайтиПоИдентификатору(Элементы.СписокНоменклатура.ТекущаяСтрока);
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) Тогда

		РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТекущиеДанные.Номенклатура,
			"Артикул,Производитель");
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, РеквизитыНоменклатуры);
		
	Иначе
		
		ТекущиеДанные.Артикул = "";
		ТекущиеДанные.Производитель = Неопределено;
		
	КонецЕсли;
	
	ТекущиеДанные.ОтображатьВПодборе	= Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАналоги

&НаСервереБезКонтекста
Процедура АналогиПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	// TODO: Работает довольно медлено подумать как по другому оформить.
	
	Валюта = ПолучитьЗначениеПараметраСтруктуры(Настройки.ДополнительныеСвойства, "Валюта");
	Подразделение = ПолучитьЗначениеПараметраСтруктуры(Настройки.ДополнительныеСвойства, "ПодразделениеКомпании");
	ТипЦены = ПолучитьЗначениеПараметраСтруктуры(Настройки.ДополнительныеСвойства, "ТипЦен");
	
	Если НЕ ЗначениеЗаполнено(Валюта)
		ИЛИ НЕ ЗначениеЗаполнено(Подразделение)
		ИЛИ НЕ ЗначениеЗаполнено(ТипЦены) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Товары    = Строки.ПолучитьКлючи();
	
	НоменклатураЦена = Новый Соответствие();
	
	ПредставлениеПустойЦены = НСтр("ru = '<нет>'");
	ЦветПустойЦены = ЦветаСтиля.НедоступныеДанныеЦвет;
	
	Для Каждого Товар Из Товары Цикл
		
		Если НоменклатураЦена.Получить(Товар.Номенклатура) = Неопределено Тогда
			НоменклатураЦена.Вставить(
				Товар.Номенклатура,
				ЦенообразованиеСервер.ПолучитьЦену(ТипЦены, Товар.Номенклатура,,, Валюта,,,, Подразделение)
			);
		КонецЕсли;
				
		Если НоменклатураЦена[Товар.Номенклатура] <= 0  Тогда
			
			ОформлениеПоляЦена = Строки.Получить(Товар).Оформление.Получить("Цена");
			ОформлениеПоляЦена.УстановитьЗначениеПараметра("Текст", ПредставлениеПустойЦены);
			ОформлениеПоляЦена.УстановитьЗначениеПараметра("ЦветТекста", ЦветПустойЦены);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура АналогиПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ЗаменыИАналоги.ТекущаяСтраница.Имя <> "СтраницаАналоги" Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные <> Неопределено 
		И Элемент.ТекущиеДанные.Номенклатура = ТекущаяНоменклатура Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ОбновляемыеСписки = Новый Массив(3);
	ОбновляемыеСписки[0] = ОстаткиТоваров;
	ОбновляемыеСписки[1] = ЗаказыПокупателей;
	ОбновляемыеСписки[2] = ЗаказыПоставщикам;
	
	ТекущаяНоменклатура = ?(Элемент.ТекущиеДанные = Неопределено, Неопределено, Элемент.ТекущиеДанные.Номенклатура);
	ТекущийАртикул = ?(Элемент.ТекущиеДанные = Неопределено, "", Элемент.ТекущиеДанные.Артикул);
	
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьИнформациюОНоменклатуре", 0.1, Истина);
	
	Для Каждого ТекущийСписок Из ОбновляемыеСписки Цикл
	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ТекущийСписок,
			"Номенклатура",
			?(ТекущаяНоменклатура=Неопределено, ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"),ТекущаяНоменклатура),
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ТекущийСписок,
			"ХарактеристикаНоменклатуры",
			Неопределено,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Ложь,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	КонецЦикла;
	
	ПодключитьОбработчикОжидания("Подключаемый_ПриАктивизацииСтроки", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗамены

&НаКлиенте
Процедура ЗаменыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбраннаяСтрока = Замены.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	Если НЕ ЗначениеЗаполнено(ВыбраннаяСтрока.Номенклатура) Тогда
		НачатьСозданиеНоменклатуры("Замены", , Истина);
		Возврат;
	КонецЕсли;
	
	ТекСтрока = Объект.СписокНоменклатура.НайтиПоИдентификатору(КэшТекущаяСтрока);
	
	Если ТекСтрока <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ТекСтрока, ВыбраннаяСтрока, "Номенклатура, Артикул, Производитель");
		ТекСтрока.ХарактеристикаНоменклатуры = Неопределено;
		ТекСтрока.Цена = 0;
		КэшТекущаяСтрока = Неопределено;
		КэшТекущаяНоменклатура = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
		ПодключитьОбработчикОжидания("Подключаемый_ОтложеноСписокНоменклатураПриАктивизацииСтроки", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаменыПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ЗаменыИАналоги.ТекущаяСтраница.Имя <> "СтраницаЗамены" Тогда
		Возврат;
	КонецЕсли;
		
	Если Элемент.ТекущиеДанные <> Неопределено 
		И Элемент.ТекущиеДанные.Номенклатура = ТекущаяНоменклатура Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекущаяНоменклатура = ?(Элемент.ТекущиеДанные = Неопределено, Неопределено, Элемент.ТекущиеДанные.Номенклатура);
	ТекущийАртикул = ?(Элемент.ТекущиеДанные = Неопределено, "", Элемент.ТекущиеДанные.Артикул);
	
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьИнформациюОНоменклатуре", 0.1, Истина);
	
	ОбновляемыеСписки = Новый Массив(3);
	ОбновляемыеСписки[0] = ОстаткиТоваров;
	ОбновляемыеСписки[1] = ЗаказыПокупателей;
	ОбновляемыеСписки[2] = ЗаказыПоставщикам;
	
	Для Каждого ТекущийСписок Из ОбновляемыеСписки Цикл
	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ТекущийСписок,
			"Номенклатура",
			?(ТекущаяНоменклатура = Неопределено, ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"), ТекущаяНоменклатура),
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ТекущийСписок,
			"ХарактеристикаНоменклатуры",
			Неопределено,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Ложь,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	КонецЦикла;
	
	ПодключитьОбработчикОжидания("Подключаемый_ПриАктивизацииСтроки", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти
