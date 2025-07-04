﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Источник") Тогда
		ОбъектГруппы = РеквизитФормыВЗначение("ЛеваяГруппа", Тип("ОбработкаОбъект.ГруппаАналогов"));
		Если ТипЗнч(Параметры.Источник) = Тип("Строка") Тогда
			ОбъектГруппы.ИдентификаторГруппы = Параметры.Источник;
			ОбъектГруппы.ЗаполнитьПоИдентификаторуГруппы();
		Иначе
			ОбъектГруппы.Номенклатура = Параметры.Источник;
			ОбъектГруппы.ОбработкаИзмененияНоменклатуры();
		КонецЕсли;
		
		ЗначениеВРеквизитФормы(ОбъектГруппы, "ЛеваяГруппа");
	КонецЕсли;
	
	// Группы источника
	Если Параметры.Свойство("ГруппыИсточники") Тогда
		Для Каждого ГруппаИсточник Из Параметры.ГруппыИсточники Цикл
			ИмяОбъекта = ДобавитьНовуюГруппуНаСервере();
			ОбъектГруппы = РеквизитФормыВЗначение(ИмяОбъекта, Тип("ОбработкаОбъект.ГруппаАналогов"));
			
			ОбъектГруппы.ИдентификаторГруппы = ГруппаИсточник;
			ОбъектГруппы.ЗаполнитьПоИдентификаторуГруппы();
			
			ОбновитьСписокГруппы(ЭтотОбъект["Аналоги" + ИмяОбъекта], ОбъектГруппы);
			
			ЗначениеВРеквизитФормы(ОбъектГруппы, ИмяОбъекта);
		КонецЦикла;
	КонецЕсли;
	
	ОбновитьСписокГруппы(АналогиЛеваяГруппа, ЛеваяГруппа);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьКнопокДействий();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура("РежимВыбора", Истина);
	
	ОткрытьФорму(
		"Справочник.Номенклатура.ФормаВыбора",
		ПараметрыОткрытия,
		Элемент,
		УникальныйИдентификатор,
		,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеАвтоПодбор(
	Элемент,
	Текст,
	ДанныеВыбора,
	ПараметрыПолученияДанных,
	Ожидание,
	СтандартнаяОбработка)
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("Отбор"                , Новый Структура);
	ПараметрыПодбора.Вставить("ВыборГруппИЭлементов" , ПредопределенноеЗначение("ИспользованиеГруппИЭлементов.Элементы"));
	ПараметрыПодбора.Вставить("СтрокаПоиска"         , Текст);
	ПараметрыПодбора.Вставить("Источник"             , "ФормаЗаписи_ГруппыАналогов");
	
	ДанныеВыбора = ПолучитьДанныеВыбора(Тип("СправочникСсылка.Номенклатура"), ПараметрыПодбора);
	
КонецПроцедуры

&НаКлиенте
Процедура АртикулНаименованиеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Номенклатура") Тогда
		СтандартнаяОбработка = Ложь;
		
		ЗаполнитьПоляЭлементаГруппы(ВыбранноеЗначение, Элемент.Имя);
		
		УстановитьДоступностьКнопокДействий();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура АртикулПриИзмененииНаСервере(ИмяЭлемента)
	
	ИмяОбъекта = ПолучитьИмяОбъектаПоЭлементу(ИмяЭлемента);
	
	ГруппаОбъект = РеквизитФормыВЗначение(ИмяОбъекта, Тип("ОбработкаОбъект.ГруппаАналогов"));
	
	ГруппаОбъект.ОбработкаИзмененияАртикула();
	
	ЗначениеВРеквизитФормы(ГруппаОбъект, ИмяОбъекта);
	
	// заполим список производителей для артикула
	Производители = ПрайсЛистыКонтрагентов.ПроизводителиАртикула(ГруппаОбъект.Артикул);
	Элементы["Производитель"+ИмяОбъекта].СписокВыбора.Очистить();
	
	Для Каждого Производитель Из Производители Цикл
		Элементы["Производитель"+ИмяОбъекта].СписокВыбора.Добавить(
			Производитель,
			?(Производитель.Пустая(), "<Пустое значение>", Производитель));
	КонецЦикла;
	
	// Обновим список значений
	ОбновитьСписокГруппы(ЭтотОбъект["Аналоги" + ИмяОбъекта], ГруппаОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура АртикулПриИзменении(Элемент)
	
	// Изменим данные
	АртикулПриИзмененииНаСервере(Элемент.Имя);
	
	УстановитьДоступностьКнопокДействий();
	
КонецПроцедуры

&НаКлиенте
Процедура АртикулАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ОбъектИмя = СтрЗаменить(Элемент.Имя, "Артикул", "");
	
	ПараметрыПодбора = Новый Структура;
	
	Если ЗначениеЗаполнено(ЛеваяГруппа.Производитель) Тогда
		
		Отбор = Новый Структура("Производитель", ЭтотОбъект[ОбъектИмя].Производитель);
		ПараметрыПодбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
	
	ПараметрыПодбора.Вставить("ВыборГруппИЭлементов" , ПредопределенноеЗначение("ИспользованиеГруппИЭлементов.Элементы"));
	ПараметрыПодбора.Вставить("СтрокаПоиска"         , Текст);
	
	ДанныеВыбора = ПолучитьДанныеВыбора(Тип("СправочникСсылка.Номенклатура"), ПараметрыПодбора);
	
КонецПроцедуры

&НаСервере
Процедура ПроизводительПриИзмененииНаСервере(ИмяЭлемента)
	
	ИмяОбъекта = ПолучитьИмяОбъектаПоЭлементу(ИмяЭлемента);
	
	ГруппаОбъект = РеквизитФормыВЗначение(ИмяОбъекта, Тип("ОбработкаОбъект.ГруппаАналогов"));
	
	ГруппаОбъект.ОбработкаИзмененияПроизводителя();
	
	ЗначениеВРеквизитФормы(ГруппаОбъект, ИмяОбъекта);
	
	// Обновим список значений
	ОбновитьСписокГруппы(ЭтотОбъект["Аналоги" + ИмяОбъекта], ГруппаОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроизводительПриИзменении(Элемент)
	
	ПроизводительПриИзмененииНаСервере(Элемент.Имя);
	
	УстановитьДоступностьКнопокДействий();
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УстановитьДоступностьКнопокДействий();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ДобавитьНовуюГруппу(Команда)
	
	ДобавитьНовуюГруппуНаСервере();
	
	УстановитьДоступностьКнопокДействий();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъединитьГруппы(Команда)
	
	ИмяОбъекта = СтрЗаменить(Элементы.ДополнительныеСтраницы.ТекущаяСтраница.Имя, "Страница", "");
	
	Если ПустаяСтрока(ЛеваяГруппа.ИдентификаторГруппы) ИЛИ ПустаяСтрока(ЭтотОбъект[ИмяОбъекта].ИдентификаторГруппы) Тогда
		Возврат;
	КонецЕсли;
	
	ПрайсЛистыКонтрагентовВызовСервера.ОбъединитьГруппыАналогов(
		ЛеваяГруппа.ИдентификаторГруппы,
		ЭтотОбъект[ИмяОбъекта].ИдентификаторГруппы);
	
	ЭтотОбъект[ИмяОбъекта].Артикул             = "";
	ЭтотОбъект[ИмяОбъекта].АртикулДляПоиска    = "";
	ЭтотОбъект[ИмяОбъекта].ИдентификаторГруппы = "";
	ЭтотОбъект[ИмяОбъекта].Наименование        = "";
	ЭтотОбъект[ИмяОбъекта].Производитель       = Неопределено;
	ЭтотОбъект[ИмяОбъекта].Номенклатура        = Неопределено;
	
	ЭтотОбъект["Аналоги" + ИмяОбъекта].Параметры.
		УстановитьЗначениеПараметра("Артикул"      , ЭтотОбъект[ИмяОбъекта].АртикулДляПоиска);
	
	ЭтотОбъект["Аналоги" + ИмяОбъекта].Параметры.
		УстановитьЗначениеПараметра("Производитель", ЭтотОбъект[ИмяОбъекта].Производитель);
	
	Элементы.АналогиЛеваяГруппа.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиВыделенныеВОсновнуюГруппуНаСервере(Знач ВыделенныеСтроки, ИмяОбъекта)
	
	Если РегистрыСведений.ГруппыАналогов.ПеренестиЭлементы(
		ВыделенныеСтроки, ЛеваяГруппа.ИдентификаторГруппы, ВыделенныеСтроки[0].ИдентификаторГруппы) Тогда
		
		ЭтотОбъект[ИмяОбъекта].Артикул             = "";
		ЭтотОбъект[ИмяОбъекта].АртикулДляПоиска    = "";
		ЭтотОбъект[ИмяОбъекта].ИдентификаторГруппы = "";
		ЭтотОбъект[ИмяОбъекта].Наименование        = "";
		ЭтотОбъект[ИмяОбъекта].Производитель       = Неопределено;
		ЭтотОбъект[ИмяОбъекта].Номенклатура        = Неопределено;
		
		ЭтотОбъект["Аналоги" + ИмяОбъекта].Параметры.
			УстановитьЗначениеПараметра("Артикул"      , ЭтотОбъект[ИмяОбъекта].АртикулДляПоиска);
	
		ЭтотОбъект["Аналоги" + ИмяОбъекта].Параметры.
			УстановитьЗначениеПараметра("Производитель", ЭтотОбъект[ИмяОбъекта].Производитель);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВыделенныеВОсновнуюГруппу(Команда)
	
	ИмяТекущегоДинамическогоСписка = СтрЗаменить(Элементы.ДополнительныеСтраницы.ТекущаяСтраница.Имя, "Страница", "Аналоги");
	Элемент = Элементы[ИмяТекущегоДинамическогоСписка];
	
	Если Элемент.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПеренестиВыделенныеВОсновнуюГруппуНаСервере(
		Элемент.ВыделенныеСтроки,
		СтрЗаменить(ИмяТекущегоДинамическогоСписка, "Аналоги", ""));
	
	Элементы.АналогиЛеваяГруппа.Обновить();
	Элемент.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступностьКнопокДействий()
	
	Если (Элементы.ДополнительныеСтраницы.ПодчиненныеЭлементы.Количество() = 0) Тогда
		Элементы.ОбъединитьГруппы.Доступность                   = Ложь;
		Элементы.ПеренестиВыделенныеВОсновнуюГруппу.Доступность = Ложь;
		
		Возврат;
	КонецЕсли;
	
	ИмяОбъектаТекущейСтраницы = СтрЗаменить(Элементы.ДополнительныеСтраницы.ТекущаяСтраница.Имя, "Страница", "");
	Если ЛеваяГруппа.ИдентификаторГруппы = ЭтотОбъект[ИмяОбъектаТекущейСтраницы].ИдентификаторГруппы Тогда
		Элементы.ОбъединитьГруппы.Доступность                   = Ложь;
		Элементы.ПеренестиВыделенныеВОсновнуюГруппу.Доступность = Ложь;
		
		Возврат;
	КонецЕсли;
	
	Элементы.ОбъединитьГруппы.Доступность                   = Истина;
	Элементы.ПеренестиВыделенныеВОсновнуюГруппу.Доступность = Истина;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИмяОбъектаПоЭлементу(Элемент)
	
	Возврат СтрРазделить(Элементы[Элемент].ПутьКДанным, ".")[0];
	
КонецФункции

&НаСервере
Процедура ОбновитьСписокГруппы(ДинамическийСписок, Источник)
	
	ДинамическийСписок.Параметры.УстановитьЗначениеПараметра("Артикул"      , Источник.АртикулДляПоиска);
	ДинамическийСписок.Параметры.УстановитьЗначениеПараметра("Производитель", Источник.Производитель);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоляЭлементаГруппыНаСервере(Номенклатура, ЭлементЗаполнения)
	
	// получим реквизит для заполнения
	ИмяОбъекта   = ПолучитьИмяОбъектаПоЭлементу(ЭлементЗаполнения);
	ГруппаОбъект = РеквизитФормыВЗначение(ИмяОбъекта, Тип("ОбработкаОбъект.ГруппаАналогов"));
	
	ГруппаОбъект.Номенклатура = Номенклатура;
	ГруппаОбъект.ОбработкаИзмененияНоменклатуры();
	
	ОбновитьСписокГруппы(ЭтотОбъект["Аналоги" + ИмяОбъекта], ГруппаОбъект);
	
	ЗначениеВРеквизитФормы(ГруппаОбъект, ИмяОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоляЭлементаГруппы(Номенклатура, ЭлементЗаполнения)
	
	ЗаполнитьПоляЭлементаГруппыНаСервере(Номенклатура, ЭлементЗаполнения);
	
КонецПроцедуры

&НаСервере
Функция ДобавитьНовуюГруппуНаСервере()
	
	// добавим реквизиты
	ИмяДобавляемойГруппы = "ГруппаАналогов" + СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", "");
	
	ДобавитьРеквизиты(ИмяДобавляемойГруппы);
	
	ДобавитьЭлементыФормы(ИмяДобавляемойГруппы);
	
	ОбновитьУсловноеОформление(ИмяДобавляемойГруппы);
	
	Возврат ИмяДобавляемойГруппы;
	
КонецФункции

&НаСервере
Процедура ДобавитьРеквизиты(Суффикс)
	
	НовыеРеквизиты = Новый Массив;
	
	// добавим объект обработки
	ОбъектГруппы = Новый РеквизитФормы(Суффикс, Новый ОписаниеТипов("ОбработкаОбъект.ГруппаАналогов"));
	НовыеРеквизиты.Добавить(ОбъектГруппы);
	
	ДинамическийСписок = Новый РеквизитФормы("Аналоги" + Суффикс, Новый ОписаниеТипов("ДинамическийСписок"));
	НовыеРеквизиты.Добавить(ДинамическийСписок);
	
	ИзменитьРеквизиты(НовыеРеквизиты);
	
	// настроим динамический список
	ДинамическийСписок = ЭтотОбъект["Аналоги" + Суффикс];
	ЗаполнитьЗначенияСвойств(ДинамическийСписок, АналогиЛеваяГруппа);
	ДинамическийСписок.УстановитьОбязательноеИспользование("ТекущаяНоменклатура", Истина);
	ДинамическийСписок.УстановитьОбязательноеИспользование("АртикулДляПоиска"   , Истина);
	ДинамическийСписок.УстановитьОбязательноеИспользование("Номенклатура"       , Истина);
	
	ОбновитьСписокГруппы(ДинамическийСписок, ЭтотОбъект[Суффикс]);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЭлементыФормы(Суффикс)
	
	// страница контейнер
	СтраницаКонтейнер = Элементы.Добавить("Страница" + Суффикс, Тип("ГруппаФормы"), Элементы.ДополнительныеСтраницы);
	СтраницаКонтейнер.Заголовок   = "Группа аналогов";
	СтраницаКонтейнер.Вид         = ВидГруппыФормы.Страница;
	СтраницаКонтейнер.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	СтраницаКонтейнер.ЦветФона    = ЦветаСтиля.ЦветОсновнойПанелиФормы;
	
	Шапка = Элементы.Добавить("Шапка" + Суффикс, Тип("ГруппаФормы"), СтраницаКонтейнер);
	Шапка.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Шапка.ОтображатьЗаголовок = Ложь;
	Шапка.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	
	
	// группа заголовков
	ГруппаЗаголовков = Элементы.Добавить("ГруппаЗаголовков" + Суффикс, Тип("ГруппаФормы"), Шапка);
	ГруппаЗаголовков.Вид                 = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаЗаголовков.ОтображатьЗаголовок = Ложь;
	
	ДекорацияАртикул = Элементы.Добавить("ДекорацияАртикул" + Суффикс, Тип("ДекорацияФормы"), ГруппаЗаголовков);
	ДекорацияАртикул.Вид = ВидДекорацииФормы.Надпись;
	ДекорацияАртикул.Заголовок = "Артикул :";
	
	ДекорацияНаименование = Элементы.Добавить("ДекорацияНаименование" + Суффикс, Тип("ДекорацияФормы"), ГруппаЗаголовков);
	ДекорацияНаименование.Вид       = ВидДекорацииФормы.Надпись;
	ДекорацияНаименование.Заголовок = "Наименование :";
	
	// группа полей ввода
	ГруппаПолейВвода = Элементы.Добавить("ГруппаПолейВвода" + Суффикс, Тип("ГруппаФормы"), Шапка);
	ГруппаПолейВвода.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаПолейВвода.ОтображатьЗаголовок = Ложь;
	
	ГруппаАртикулИПроизводитель = Элементы.Добавить("АртикулИПроизводитель" + Суффикс, Тип("ГруппаФормы"), ГруппаПолейВвода);
	ГруппаАртикулИПроизводитель.Вид         = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаАртикулИПроизводитель.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	ГруппаАртикулИПроизводитель.ОтображатьЗаголовок = Ложь;
	
	// поле ввода артикул
	ПолеВводаАртикул = Элементы.Добавить("Артикул" + Суффикс, Тип("ПолеФормы"), ГруппаАртикулИПроизводитель);
	ПолеВводаАртикул.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВводаАртикул.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	
	ПолеВводаАртикул.ПутьКДанным  = Суффикс + ".Артикул";
	ПолеВводаАртикул.КнопкаВыбора = Истина;
	
	ПолеВводаАртикул.УстановитьДействие("ПриИзменении"    , "АртикулПриИзменении");
	ПолеВводаАртикул.УстановитьДействие("НачалоВыбора"    , "НоменклатураНачалоВыбора");
	ПолеВводаАртикул.УстановитьДействие("ОбработкаВыбора" , "АртикулНаименованиеОбработкаВыбора");
	ПолеВводаАртикул.УстановитьДействие("АвтоПодбор"      , "АртикулАвтоПодбор");
	
	// поле ввода производитель
	ПолеВводаПроизводитель = Элементы.Добавить("Производитель" + Суффикс, Тип("ПолеФормы"), ГруппаАртикулИПроизводитель);
	ПолеВводаПроизводитель.Вид = ВидПоляФормы.ПолеВвода;
	
	ПолеВводаПроизводитель.ПутьКДанным = Суффикс + ".Производитель";
	
	ПолеВводаПроизводитель.УстановитьДействие("ПриИзменении", "ПроизводительПриИзменении");
	
	// поле ввода наименование
	ПолеВводаНаименование = Элементы.Добавить("Наименование" + Суффикс, Тип("ПолеФормы"), ГруппаПолейВвода);
	ПолеВводаНаименование.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВводаНаименование.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	
	ПолеВводаНаименование.ПутьКДанным  = Суффикс + ".Наименование";
	ПолеВводаНаименование.КнопкаВыбора = Истина;
	
	ПолеВводаНаименование.УстановитьДействие("НачалоВыбора"   , "НоменклатураНачалоВыбора");
	ПолеВводаНаименование.УстановитьДействие("ОбработкаВыбора", "АртикулНаименованиеОбработкаВыбора");
	ПолеВводаНаименование.УстановитьДействие("АвтоПодбор"     , "НаименованиеАвтоПодбор");
	
	// поле динамичского списка
	ПолеДинамическогоСписка = Элементы.Добавить("Аналоги" + Суффикс, Тип("ТаблицаФормы"), СтраницаКонтейнер);
	ПолеДинамическогоСписка.ПутьКДанным           = "Аналоги" + Суффикс;
	ПолеДинамическогоСписка.ВысотаВСтрокахТаблицы = 3;
	
	ПолеДинамическогоСписка.ПоложениеСтрокиПоиска       = ПоложениеСтрокиПоиска.Нет;
	ПолеДинамическогоСписка.ПоложениеСостоянияПросмотра = ПоложениеСостоянияПросмотра.Нет;
	ПолеДинамическогоСписка.ПоложениеУправленияПоиском  = ПоложениеУправленияПоиском.Нет;
	
	ПолеДинамическогоСписка.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
	ПолеДинамическогоСписка.КоманднаяПанель.Видимость = Ложь;
	
	// колонки
	КолонкаАртикул = Элементы.Добавить("АналогиАртикул" + Суффикс, Тип("ПолеФормы"), ПолеДинамическогоСписка);
	КолонкаАртикул.Вид         = ВидПоляФормы.ПолеНадписи;
	КолонкаАртикул.ПутьКДанным = "Аналоги" + Суффикс + ".Артикул";
	КолонкаАртикул.Видимость   = Истина;
	
	КолонкаПроизводитель = Элементы.Добавить("АналогиПроизводитель" + Суффикс, Тип("ПолеФормы"), ПолеДинамическогоСписка);
	КолонкаПроизводитель.Вид         = ВидПоляФормы.ПолеНадписи;
	КолонкаПроизводитель.ПутьКДанным = "Аналоги" + Суффикс + ".Производитель";
	КолонкаПроизводитель.Видимость   = Истина;
	
	КолонкаНаименование = Элементы.Добавить("АналогиНаименование" + Суффикс, Тип("ПолеФормы"), ПолеДинамическогоСписка);
	КолонкаНаименование.Вид         = ВидПоляФормы.ПолеНадписи;
	КолонкаНаименование.ПутьКДанным = "Аналоги" + Суффикс + ".Наименование";
	КолонкаНаименование.Видимость   = Истина;
	
	КолонкаГлавныйПоГруппе = Элементы.Добавить("АналогиГлавныйПоГруппе" + Суффикс, Тип("ПолеФормы"), ПолеДинамическогоСписка);
	КолонкаГлавныйПоГруппе.Вид         = ВидПоляФормы.ПолеФлажка;
	КолонкаГлавныйПоГруппе.ПутьКДанным = "Аналоги" + Суффикс + ".ГлавныйПоГруппе";
	КолонкаГлавныйПоГруппе.Видимость   = Истина;
	
	КолонкаГлавныйПоПроизводителю = Элементы.Добавить("АналогиГлавныйПоПроизводителю" + Суффикс, Тип("ПолеФормы"), ПолеДинамическогоСписка);
	КолонкаГлавныйПоПроизводителю.Вид         = ВидПоляФормы.ПолеФлажка;
	КолонкаГлавныйПоПроизводителю.ПутьКДанным = "Аналоги" + Суффикс + ".ГлавныйПоПроизводителю";
	КолонкаГлавныйПоПроизводителю.Видимость   = Истина;
	
	КолонкаТекущаяНоменклатура = Элементы.Добавить("АналогиТекущаяНоменклатура" + Суффикс, Тип("ПолеФормы"), ПолеДинамическогоСписка);
	КолонкаТекущаяНоменклатура.Вид         = ВидПоляФормы.ПолеНадписи;
	КолонкаТекущаяНоменклатура.ПутьКДанным = "Аналоги" + Суффикс + ".ТекущаяНоменклатура";
	КолонкаТекущаяНоменклатура.Видимость   = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьУсловноеОформление(Суффикс)
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	// Создаем условие отбора
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(СтрШаблон("Аналоги%1.ТекущаяНоменклатура", Суффикс));
	ЭлементОтбора.ВидСравнения  = ВидСравненияКомпоновкиДанных.Равно;
	
	// Значение для отбора
	ЭлементОтбора.ПравоеЗначение = Истина;
	ЭлементОтбора.Использование  = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,, Истина));
	ЭлементОформления.Использование = Истина;
	
	ПолеДляОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеДляОформления.Поле          = Новый ПолеКомпоновкиДанных("Аналоги" + Суффикс);
	ПолеДляОформления.Использование = Истина;
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	// Создаем условие отбора
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(СтрШаблон("Аналоги%1.ТекущаяНоменклатура", Суффикс));
	ЭлементОтбора.ВидСравнения  = ВидСравненияКомпоновкиДанных.Равно;
	
	// Значение для отбора
	ЭлементОтбора.ПравоеЗначение = Ложь;
	ЭлементОтбора.Использование  = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(0, 120, 0));
	ЭлементОформления.Использование = Истина;
	
	ПолеДляОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеДляОформления.Поле          = Новый ПолеКомпоновкиДанных("Аналоги" + Суффикс);
	ПолеДляОформления.Использование = Истина;
	
КонецПроцедуры

#КонецОбласти





