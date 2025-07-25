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
	
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователи.ТекущийПользователь());
	Элементы.ВсеНапоминания.Видимость = Пользователи.ЭтоПолноправныйПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ОткрытьФорму("РегистрСведений.НапоминанияПользователя.Форма.Напоминание", Новый Структура("Ключ", Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	СтрокаВыбрана = Не Элемент.ТекущаяСтрока = Неопределено;
	Элементы.КнопкаУдалить.Доступность = СтрокаВыбрана;
	Элементы.КнопкаИзменить.Доступность = СтрокаВыбрана;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	УдалитьНапоминание();
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "Источник" Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.Источник) Тогда
			ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.Источник);
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Источник напоминания не задан.'"));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Изменить(Команда)
	ОткрытьФорму("РегистрСведений.НапоминанияПользователя.Форма.Напоминание", Новый Структура("Ключ", Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	УдалитьНапоминание();
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	ОткрытьФорму("РегистрСведений.НапоминанияПользователя.Форма.Напоминание");
КонецПроцедуры

&НаКлиенте
Процедура ВсеНапоминания(Команда)
	
	ОткрытьФорму("РегистрСведений.НапоминанияПользователя.Форма.ВсеНапоминания");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтключитьНапоминание(ПараметрыНапоминания)
	НапоминанияПользователяСлужебный.ОтключитьНапоминание(ПараметрыНапоминания, Ложь, Истина);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНапоминание()
	
	КнопкиДиалога = Новый СписокЗначений;
	КнопкиДиалога.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Удалить'"));
	КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Не удалять'"));
	ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьНапоминаниеЗавершение", ЭтотОбъект);
	
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Удалить напоминание?'"), КнопкиДиалога);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНапоминаниеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	КлючЗаписи = Элементы.Список.ТекущаяСтрока; 
	
	// АльфаАвто
	ПараметрыНапоминания = Новый Структура("Пользователь,Автор,ВремяСобытия,Источник");
	// Конец АльфаАвто
	
	ЗаполнитьЗначенияСвойств(ПараметрыНапоминания, Элементы.Список.ТекущиеДанные);
	
	ОтключитьНапоминание(ПараметрыНапоминания);
	НапоминанияПользователяКлиент.УдалитьЗаписьИзКэшаОповещений(ПараметрыНапоминания);
	Оповестить("Запись_НапоминанияПользователя", Новый Структура, КлючЗаписи);
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.НапоминанияПользователя"));
	
КонецПроцедуры

#КонецОбласти
