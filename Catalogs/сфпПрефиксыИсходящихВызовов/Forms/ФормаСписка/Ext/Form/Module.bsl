﻿
&НаКлиенте
Процедура КомандаДобавитьКлиента(Команда)

	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("ПрефиксНабора", ТекДанные.Ссылка);
	Оповещение = Новый ОписаниеОповещения("ПриВыбореКлиента", ЭтаФорма, ДополнительныеПараметры);
	ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора",,,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореКлиента(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Возврат;
	КонецЕсли;
	
    ПриВыбореКлиентаНаСервере(ДополнительныеПараметры.ПрефиксНабора, РезультатЗакрытия);

	Элементы.Клиенты.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ПриВыбореКлиентаНаСервере(Префикс, ВыбранныйКлиент)
	
	ТекОбъект = Префикс.ПолучитьОбъект();
	Если ТекОбъект.Клиенты.Найти(ВыбранныйКлиент, "Клиент") = Неопределено Тогда
		НоваяСтрока = ТекОбъект.Клиенты.Добавить();
		НоваяСтрока.Клиент = ВыбранныйКлиент;
		
		ТекОбъект.Записать();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		  ЗначениеОтбора = Неопределено;
	Иначе ЗначениеОтбора = ТекДанные.Ссылка;
	КонецЕсли;	
	
	сфпОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Клиенты.Отбор, "Префикс", ЗначениеОтбора, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУдалитьКлиента(Команда)
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КлиентыКУдалению = Новый Массив();
	
	Для Каждого ТекСтрока Из Элементы.Клиенты.ВыделенныеСтроки Цикл
		ТекСтрока = Элементы.Клиенты.ДанныеСтроки(ТекСтрока);
		КлиентыКУдалению.Добавить(ТекСтрока.Клиент);
	КонецЦикла;	
	
	УдалитьКлиентаНаСервере(ТекДанные.Ссылка, КлиентыКУдалению);

	Элементы.Клиенты.Обновить();

КонецПроцедуры

&НаСервере
Процедура УдалитьКлиентаНаСервере(Префикс, КлиентыКУдалению)
	
	ТекОбъект = Префикс.ПолучитьОбъект();
		
	Для Каждого ТекКлиент Из КлиентыКУдалению Цикл
		СтрокаКлиента = ТекОбъект.Клиенты.Найти(ТекКлиент, "Клиент");
		Если СтрокаКлиента <> Неопределено Тогда
			ТекОбъект.Клиенты.Удалить(СтрокаКлиента);
		КонецЕсли;
	КонецЦикла;	
	
	ТекОбъект.Записать();
	
КонецПроцедуры