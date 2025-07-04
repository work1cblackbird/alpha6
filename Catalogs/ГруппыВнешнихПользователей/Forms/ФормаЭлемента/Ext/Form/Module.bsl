﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПользователиСлужебный.ВнешниеПользователиВнедрены() Тогда
		ВызватьИсключение НСтр("ru = 'Внешние пользователи не предусмотрены в данной версии приложения.'");
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбработатьИнтерфейсРолей("ЗаполнитьРоли", Объект.Роли);
		ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриСозданииФормы", Ложь);
	КонецЕсли;
	
	// Подготовка вспомогательных данных.
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ВсеОбъектыАвторизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Родитель,
			"ВсеОбъектыАвторизации");
		ВсеОбъектыАвторизации = ?(ВсеОбъектыАвторизации = Неопределено, Ложь, ВсеОбъектыАвторизации);
		
		Если ВсеОбъектыАвторизации
		 Или Объект.Родитель = ВнешниеПользователи.ГруппаВсеВнешниеПользователи() Тогда
			
			Объект.Родитель = Справочники.ГруппыВнешнихПользователей.ПустаяСсылка();
		КонецЕсли;
		
	КонецЕсли;
	
	ОтобратьДоступныеДляВыбораТипыУчастниковГруппы();
	
	ОпределитьДействияВФорме();
	
	// Установка постоянной доступности свойств.
	
	Элементы.Наименование.Видимость     = ЗначениеЗаполнено(ДействияВФорме.СвойстваЭлемента);
	Элементы.Родитель.Видимость         = ЗначениеЗаполнено(ДействияВФорме.СвойстваЭлемента);
	Элементы.Комментарий.Видимость      = ЗначениеЗаполнено(ДействияВФорме.СвойстваЭлемента);
	Элементы.Состав.Видимость           = ЗначениеЗаполнено(ДействияВФорме.СоставГруппы);
	Элементы.ОтображениеРолей.Видимость = ЗначениеЗаполнено(ДействияВФорме.Роли);
	
	УчастникиГруппы = ?(Объект.ВсеОбъектыАвторизации, "ВсеПользователиУказанныхВидов", "ВыбранныеПользователиУказанныхВидов");
	
	ЭтоГруппаВсеВнешниеПользователи = 
		Объект.Ссылка = ВнешниеПользователи.ГруппаВсеВнешниеПользователи();
	
	Если ЭтоГруппаВсеВнешниеПользователи Тогда
		Элементы.Наименование.ТолькоПросмотр = Истина;
		Элементы.Родитель.ТолькоПросмотр     = Истина;
		Элементы.Комментарий.ТолькоПросмотр  = Истина;
		Элементы.ВнешниеПользователиГруппы.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ТолькоПросмотр
	 ИЛИ НЕ ЭтоГруппаВсеВнешниеПользователи
	     И ДействияВФорме.Роли             <> "Редактирование"
	     И ДействияВФорме.СоставГруппы     <> "Редактирование"
	     И ДействияВФорме.СвойстваЭлемента <> "Редактирование"
	 ИЛИ ЭтоГруппаВсеВнешниеПользователи
	   И ПользователиСлужебный.ЗапретРедактированияРолей() Тогда
		
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ДействияВФорме.СвойстваЭлемента <> "Редактирование" Тогда
		Элементы.Наименование.ТолькоПросмотр = Истина;
		Элементы.Родитель.ТолькоПросмотр     = Истина;
		Элементы.Комментарий.ТолькоПросмотр  = Истина;
	КонецЕсли;
	
	Если ДействияВФорме.СоставГруппы <> "Редактирование" Тогда
		Элементы.ВнешниеПользователиГруппы.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ОбработатьИнтерфейсРолей(
		"УстановитьТолькоПросмотрРолей",
		    ПользователиСлужебный.ЗапретРедактированияРолей()
		ИЛИ ДействияВФорме.Роли <> "Редактирование");
	
	ОбновитьСписокНедействительныхПользователей(Истина);
	ЗаполнитьСтатусПользователей();
	
	Если ЗначениеЗаполнено(Объект.Родитель) И Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		НазначениеРодителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Родитель, "Назначение");
		Если ТипЗнч(НазначениеРодителя) = Тип("РезультатЗапроса") Тогда
			Объект.Назначение.Загрузить(НазначениеРодителя.Выгрузить());
		Иначе
			Объект.Назначение.Очистить();
		КонецЕсли;
	КонецЕсли;
	ПользователиСлужебный.ОбновитьНазначениеПриСозданииНаСервере(ЭтотОбъект, Ложь);
	
	УстановитьДоступностьСвойств(ЭтотОбъект);
	
	Если ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ГруппаШапка.ВыравниваниеЭлементовИЗаголовков = ВариантВыравниванияЭлементовИЗаголовков.ЭлементыПравоЗаголовкиЛево;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОбработатьИнтерфейсРолей("ЗаполнитьРоли", Объект.Роли);
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриЧтенииНаСервере", Истина);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Заполнение ролей объекта из коллекции.
	ТекущийОбъект.Роли.Очистить();
	Для каждого Строка Из КоллекцияРолей Цикл
		ТекущийОбъект.Роли.Добавить().Роль = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			"Роль." + Строка.Роль);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьСтатусПользователей();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ГруппыВнешнихПользователей", Новый Структура, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	ПроверенныеРеквизитыОбъекта = Новый Массив;
	Ошибки = Неопределено;
	
	// Проверка наличия ролей в метаданных.
	ПроверенныеРеквизитыОбъекта.Добавить("Роли.Роль");
	Если Не Элементы.Роли.ТолькоПросмотр Тогда
		ЭлементыДерева = Роли.ПолучитьЭлементы();
		Для Каждого Строка Из ЭлементыДерева Цикл
			Если Не Строка.Пометка Тогда
				Продолжить;
			КонецЕсли;
			Если Строка.ЭтоНесуществующаяРоль Тогда
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
					"Роли[%1].РолиСиноним",
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Несуществующая роль ""%1"".'"), Строка.Синоним),
					"Роли",
					ЭлементыДерева.Индекс(Строка),
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Несуществующая роль ""%1"" в строке %2.'"), Строка.Синоним, "%1"));
			КонецЕсли;
			Если Строка.ЭтоНедоступнаяРоль Тогда
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
					"Роли[%1].РолиСиноним",
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Роль ""%1"" недоступна для внешних пользователей.'"), Строка.Синоним),
					"Роли",
					ЭлементыДерева.Индекс(Строка),
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Роль ""%1"" в строке %2 недоступна для внешних пользователей.'"), Строка.Синоним, "%1"));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	НепроверяемыеРеквизиты.Добавить("Объект");
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить(
		"ПроверенныеРеквизитыОбъекта", ПроверенныеРеквизитыОбъекта);
	
	Если НЕ ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриЗагрузкеНастроек", Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СоставУчастниковПриИзменении(Элемент)
	
	Объект.ВсеОбъектыАвторизации = (УчастникиГруппы = "ВсеПользователиУказанныхВидов");
	Если Объект.ВсеОбъектыАвторизации Тогда
		Объект.Состав.Очистить();
	КонецЕсли;
	
	УстановитьДоступностьСвойств(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РодительПриИзменении(Элемент)
	
	Объект.ВсеОбъектыАвторизации = Ложь;
	ОтобратьДоступныеДляВыбораТипыУчастниковГруппы();
	
	УстановитьДоступностьСвойств(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РодительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ВыборРодителя");
	
	ОткрытьФорму("Справочник.ГруппыВнешнихПользователей.ФормаВыбора", ПараметрыФормы, Элементы.Родитель);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРоли

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей.

&НаКлиенте
Процедура РолиПометкаПриИзменении(Элемент)
	
	Если Элементы.Роли.ТекущиеДанные <> Неопределено Тогда
		ОбработатьИнтерфейсРолей("ОбновитьСоставРолей");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостав

&НаКлиенте
Процедура СоставОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Объект.Состав.Очистить();
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		Для каждого Значение Из ВыбранноеЗначение Цикл
			ОбработкаВыбораВнешнегоПользователя(Значение);
		КонецЦикла;
	Иначе
		ОбработкаВыбораВнешнегоПользователя(ВыбранноеЗначение);
	КонецЕсли;
	ЗаполнитьСтатусПользователей();
	Элементы.Состав.Обновить();
	УстановитьДоступностьСвойств(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставПриИзменении(Элемент)
	УстановитьДоступностьСвойств(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СоставВнешнийПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбратьПодобратьПользователей(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	СообщениеПользователю = ПеремещениеПользователяВГруппу(ПараметрыПеретаскивания.Значение, Объект.Ссылка);
	Если СообщениеПользователю <> Неопределено Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Перемещение пользователей'"), , СообщениеПользователю, БиблиотекаКартинок.ДиалогИнформация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьВнешнихПользователей(Команда)

	ВыбратьПодобратьПользователей(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительныхПользователей(Команда)
	
	ОбновитьСписокНедействительныхПользователей(Ложь);
	УстановитьДоступностьСвойств(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоВозрастанию(Команда)
	СоставСортироватьСтроки("ПоВозрастанию");
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоУбыванию(Команда)
	СоставСортироватьСтроки("ПоУбыванию");
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	СоставПереместитьСтроку("Вверх");
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	СоставПереместитьСтроку("Вниз");
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьНазначение(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораНазначения", ЭтотОбъект);
	ПользователиСлужебныйКлиент.ВыбратьНазначение(ЭтотОбъект, НСтр("ru = 'Выбор вида пользователей'"), Ложь, Ложь, ОписаниеОповещения);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей.

&НаКлиенте
Процедура ПоказатьТолькоВыбранныеРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ТолькоВыбранныеРоли");
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаРолейПоПодсистемам(Команда)
	
	ОбработатьИнтерфейсРолей("ГруппировкаПоПодсистемам");
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ОбновитьСоставРолей", "ВключитьВсе");
	
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ОбновитьСоставРолей", "ИсключитьВсе");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоставВнешнийПользователь.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Состав.Недействителен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Серый);

КонецПроцедуры

&НаСервере
Функция ПеремещениеПользователяВГруппу(МассивПользователей, НоваяГруппаВладелец)
	
	МассивПеремещенныхПользователей = Новый Массив;
	МассивНеПеремещенныхПользователей = Новый Массив;
	Для Каждого ПользовательСсылка Из МассивПользователей Цикл
		
		ПараметрыОтбора = Новый Структура("ВнешнийПользователь", ПользовательСсылка);
		Если ТипЗнч(ПользовательСсылка) = Тип("СправочникСсылка.ВнешниеПользователи")
			И Объект.Состав.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда
			Объект.Состав.Добавить().ВнешнийПользователь = ПользовательСсылка;
			МассивПеремещенныхПользователей.Добавить(ПользовательСсылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПользователиСлужебный.ФормированиеСообщенияПользователю(
		МассивПеремещенныхПользователей, НоваяГруппаВладелец, Ложь, МассивНеПеремещенныхПользователей);
	
КонецФункции

&НаСервере
Процедура ОтобратьДоступныеДляВыбораТипыУчастниковГруппы()
	
	Если ЗначениеЗаполнено(Объект.Родитель)
		И Объект.Родитель <> ВнешниеПользователи.ГруппаВсеВнешниеПользователи() Тогда
		
		Элементы.ТипПользователей.Доступность = Ложь;
		УчастникиГруппы = Элементы.УчастникиГруппы.СписокВыбора.НайтиПоЗначению("ВыбранныеПользователиУказанныхВидов").Значение;
		
	Иначе
		
		Элементы.ТипПользователей.Доступность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьДействияВФорме()
	
	ДействияВФорме = Новый Структура;
	
	// "", "Просмотр", "Редактирование".
	ДействияВФорме.Вставить("Роли", "");
	
	// "", "Просмотр", "Редактирование".
	ДействияВФорме.Вставить("СоставГруппы", "");
	
	// "", "Просмотр", "Редактирование".
	ДействияВФорме.Вставить("СвойстваЭлемента", "");
	
	Если Пользователи.ЭтоПолноправныйПользователь()
	 ИЛИ ПравоДоступа("Добавление", Метаданные.Справочники.Пользователи) Тогда
		// Администратор.
		ДействияВФорме.Роли             = "Редактирование";
		ДействияВФорме.СоставГруппы     = "Редактирование";
		ДействияВФорме.СвойстваЭлемента = "Редактирование";
		
	ИначеЕсли ПравоДоступа("Редактирование", Метаданные.Справочники.ГруппыВнешнихПользователей) Тогда
		// Менеджер внешних пользователей.
		ДействияВФорме.Роли             = "";
		ДействияВФорме.СоставГруппы     = "Редактирование";
		ДействияВФорме.СвойстваЭлемента = "Редактирование";
		
	Иначе
		// Читатель внешних пользователей.
		ДействияВФорме.Роли             = "";
		ДействияВФорме.СоставГруппы     = "Просмотр";
		ДействияВФорме.СвойстваЭлемента = "Просмотр";
	КонецЕсли;
	
	ПользователиСлужебный.ПриОпределенииДействийВФорме(Объект.Ссылка, ДействияВФорме);
	
	// Проверка имен действий в форме.
	Если СтрНайти(", Просмотр, Редактирование,", ", " + ДействияВФорме.Роли + ",") = 0 Тогда
		ДействияВФорме.Роли = "";
	ИначеЕсли ДействияВФорме.Роли = "Редактирование"
	        И ПользователиСлужебный.ЗапретРедактированияРолей() Тогда
		ДействияВФорме.Роли = "Просмотр";
	КонецЕсли;
	Если СтрНайти(", Просмотр, Редактирование,", ", " + ДействияВФорме.СоставГруппы + ",") = 0 Тогда
		ДействияВФорме.СвойстваПользователяИБ = "";
	КонецЕсли;
	Если СтрНайти(", Просмотр, Редактирование,", ", " + ДействияВФорме.СвойстваЭлемента + ",") = 0 Тогда
		ДействияВФорме.СвойстваЭлемента = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьСвойств(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.Состав.ТолькоПросмотр = Форма.Объект.ВсеОбъектыАвторизации;
	
	ДоступностьКоманд =
		НЕ Форма.ТолькоПросмотр
		И НЕ Элементы.ВнешниеПользователиГруппы.ТолькоПросмотр
		И НЕ Элементы.Состав.ТолькоПросмотр
		И Элементы.Состав.Доступность
		И Форма.Объект.Назначение.Количество() <> 0;
	
	СоставГруппы = Форма.Объект.Состав;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Недействителен", Ложь);
	ЕстьДействительныеПользователи = СоставГруппы.НайтиСтроки(ПараметрыОтбора).Количество() > 0;
	
	ПараметрыОтбора.Вставить("Недействителен", Истина);
	ЕстьНедействительныеПользователи = СоставГруппы.НайтиСтроки(ПараметрыОтбора).Количество() > 0;
	
	ДоступностьКомандПеремещения =
		ЕстьДействительныеПользователи
		Или (ЕстьНедействительныеПользователи
			И Элементы.ПоказыватьНедействительныхПользователей.Пометка);
	
	Элементы.Состав.ТолькоПросмотр		                = Не ДоступностьКоманд;
	
	Элементы.СоставПодобрать.Доступность                = ДоступностьКоманд;
	Элементы.СоставКонтекстноеМенюПодобрать.Доступность = ДоступностьКоманд;
	
	Элементы.СоставСортироватьПоВозрастанию.Доступность = ДоступностьКоманд;
	Элементы.СоставСортироватьПоУбыванию.Доступность    = ДоступностьКоманд;
	
	Элементы.СоставПереместитьВверх.Доступность         = ДоступностьКоманд И ДоступностьКомандПеремещения;
	Элементы.СоставПереместитьВниз.Доступность          = ДоступностьКоманд И ДоступностьКомандПеремещения;
	Элементы.СоставКонтекстноеМенюПереместитьВверх.Доступность = ДоступностьКоманд И ДоступностьКомандПеремещения;
	Элементы.СоставКонтекстноеМенюПереместитьВниз.Доступность  = ДоступностьКоманд И ДоступностьКомандПеремещения;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНеТипичныеВнешниеПользователи()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВыбранныеВнешниеПользователи", Объект.Состав.Выгрузить().ВыгрузитьКолонку("ВнешнийПользователь"));
	Запрос.УстановитьПараметр("ТипыПользователей", Объект.Назначение.Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТипыПользователей.ТипПользователей
	|ПОМЕСТИТЬ ТипыПользователей
	|ИЗ
	|	&ТипыПользователей КАК ТипыПользователей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВнешниеПользователи.Ссылка
	|ИЗ
	|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи
	|ГДЕ
	|	НЕ ЛОЖЬ В
	|			(ВЫБРАТЬ ПЕРВЫЕ 1
	|				ЛОЖЬ
	|			ИЗ
	|				ТипыПользователей КАК ТипыПользователей
	|			ГДЕ
	|				ТИПЗНАЧЕНИЯ(ТипыПользователей.ТипПользователей) = ТИПЗНАЧЕНИЯ(ВнешниеПользователи.ОбъектАвторизации))
	|	И ВнешниеПользователи.Ссылка В(&ВыбранныеВнешниеПользователи)";
	
	НачатьТранзакцию();
	Попытка
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НайденныеСтроки = Объект.Состав.НайтиСтроки(
				Новый Структура("ВнешнийПользователь", Выборка.Ссылка));
			
			Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				Объект.Состав.Удалить(Объект.Состав.Индекс(НайденнаяСтрока));
			КонецЦикла;
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПодобратьПользователей(Подобрать)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ТекущаяСтрока", ?(
		Элементы.Состав.ТекущиеДанные = Неопределено,
		Неопределено,
		Элементы.Состав.ТекущиеДанные.ВнешнийПользователь));
	
	Если Подобрать Тогда
		ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
		ПараметрыФормы.Вставить("МножественныйВыбор", Истина);
		ПараметрыФормы.Вставить("РасширенныйПодбор", Истина);
		ПараметрыФормы.Вставить("ПараметрыРасширеннойФормыПодбора", ПараметрыРасширеннойФормыПодбора());
	КонецЕсли;
	
	МассивПустыхСсылок = Новый Массив;
	Для Каждого СтрокаНазначения Из Объект.Назначение Цикл
		МассивПустыхСсылок.Добавить(СтрокаНазначения.ТипПользователей);
	КонецЦикла;
	
	ПараметрыФормы.Вставить("Назначение", МассивПустыхСсылок);
	
	ОткрытьФорму(
		"Справочник.ВнешниеПользователи.ФормаВыбора",
		ПараметрыФормы,
		?(Подобрать,
			Элементы.Состав,
			Элементы.СоставВнешнийПользователь));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораВнешнегоПользователя(ВыбранноеЗначение)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		Объект.Состав.Добавить().ВнешнийПользователь = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыРасширеннойФормыПодбора()
	
	ПараметрыПодбора = ПользователиСлужебный.НовыеПараметрыРасширеннойФормыПодбора();
	ПараметрыПодбора.ЗаголовокФормыПодбора = НСтр("ru = 'Подбор участников группы внешних пользователей'");
	
	ПараметрыПодбора.ВыбранныеПользователи =
		Объект.Состав.Выгрузить(, "ВнешнийПользователь").ВыгрузитьКолонку("ВнешнийПользователь");
	
	Возврат ПоместитьВоВременноеХранилище(ПараметрыПодбора, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСтатусПользователей()
	
	Для Каждого СтрокаСоставаГруппы Из Объект.Состав Цикл
		СтрокаСоставаГруппы.Недействителен = 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаСоставаГруппы.ВнешнийПользователь, "Недействителен");
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокНедействительныхПользователей(ПередОткрытиемФормы)
	
	Элементы.ПоказыватьНедействительныхПользователей.Пометка = ?(ПередОткрытиемФормы, Ложь,
		НЕ Элементы.ПоказыватьНедействительныхПользователей.Пометка);
	
	Отбор = Новый Структура;
	
	Если Не Элементы.ПоказыватьНедействительныхПользователей.Пометка Тогда
		Отбор.Вставить("Недействителен", Ложь);
		Элементы.Состав.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);
	Иначе
		Элементы.Состав.ОтборСтрок = Новый ФиксированнаяСтруктура();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СоставСортироватьСтроки(ТипСортировки)
	Если Не Элементы.ПоказыватьНедействительныхПользователей.Пометка Тогда
		Элементы.Состав.ОтборСтрок = Новый ФиксированнаяСтруктура();
	КонецЕсли;
	
	Если ТипСортировки = "ПоВозрастанию" Тогда
		Объект.Состав.Сортировать("ВнешнийПользователь Возр");
	Иначе
		Объект.Состав.Сортировать("ВнешнийПользователь Убыв");
	КонецЕсли;
	
	Если Не Элементы.ПоказыватьНедействительныхПользователей.Пометка Тогда
		Отбор = Новый Структура;
		Отбор.Вставить("Недействителен", Ложь);
		Элементы.Состав.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СоставПереместитьСтроку(НаправлениеПеремещения)
	
	Строка = Объект.Состав.НайтиПоИдентификатору(Элементы.Состав.ТекущаяСтрока);
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИндексТекущейСтроки = Строка.НомерСтроки - 1;
	Сдвиг = 0;
	
	Пока Истина Цикл
		Сдвиг = Сдвиг + ?(НаправлениеПеремещения = "Вверх", -1, 1);
		
		Если ИндексТекущейСтроки + Сдвиг < 0
		Или ИндексТекущейСтроки + Сдвиг >= Объект.Состав.Количество() Тогда
			Возврат;
		КонецЕсли;
		
		Если Элементы.ПоказыватьНедействительныхПользователей.Пометка
		 Или Объект.Состав[ИндексТекущейСтроки + Сдвиг].Недействителен = Ложь Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Объект.Состав.Сдвинуть(ИндексТекущейСтроки, Сдвиг);
	Элементы.Состав.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораНазначения(МассивТипов, ДополнительныеПараметры) Экспорт
	
	Модифицированность = Истина;
	УдалитьНеТипичныеВнешниеПользователи();
	УстановитьДоступностьСвойств(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей.

&НаСервере
Процедура ОбработатьИнтерфейсРолей(Действие, ОсновнойПараметр = Неопределено)
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("ОсновнойПараметр", ОсновнойПараметр);
	ПараметрыДействия.Вставить("Форма",            ЭтотОбъект);
	ПараметрыДействия.Вставить("КоллекцияРолей",   КоллекцияРолей);
	ПараметрыДействия.Вставить("НазначениеРолей",  "ДляВнешнихПользователей");
	
	ПользователиСлужебный.ОбработатьИнтерфейсРолей(Действие, ПараметрыДействия);
	
КонецПроцедуры

#КонецОбласти
