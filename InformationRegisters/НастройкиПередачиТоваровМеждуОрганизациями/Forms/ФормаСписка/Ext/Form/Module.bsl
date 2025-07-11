﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы списка регистра сведений "Настройки передачи товаров между организациями"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСФормой.НастроитьОсновнойДинамическийСписокФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	// ОценкаПроизводительности
	Если Копирование Тогда
		
		ОценкаПроизводительностиКлиент.ЗамерВремени("КопированиеРегистраСведенийНастройкиПередачиТоваровМеждуОрганизациями");
		
	Иначе
		
		ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеРегистраСведенийНастройкиПередачиТоваровМеждуОрганизациями");
		
	КонецЕсли;
	// Конец ОценкаПроизводительности
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеЗаписиРегистраСведенийНастройкиПередачиТоваровМеждуОрганизациями");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ=Истина;
	
	Если Не ЭтоПолноправныйПользователь() Тогда
		
		ПоказатьПредупреждение(,НСтр("ru = 'Недостаточно прав для настройки передачи товаров между организациями (требуются полные права).'"));
		Возврат;
		
	КонецЕсли;
	
	УдалитьНастройку();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УдалитьНастройку()
	
	КнопкиДиалога = Новый СписокЗначений;
	КнопкиДиалога.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Удалить'"));
	КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Не удалять'"));
	ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьНастройкуЗавершение", ЭтотОбъект);
	
	ПоказатьВопрос(ОписаниеОповещения, 
		НСтр("ru = 'Для того чтобы не допустить рассогласования данных в программе,
				   |а также блокировку проведения старых документов.
				   |Перед тем, как удалять настройку, рекомендуется оценить последствия,
				   |вручную проверив движения по регистру <Товары организаций к передаче>'"),
		КнопкиДиалога,,КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНастройкуЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	КлючЗаписи = Элементы.Список.ТекущаяСтрока;
	
	УдалитьНастройкуНаСервере(КлючЗаписи);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьНастройкуНаСервере(КлючЗаписи)
	
	МенеджерЗаписи = РегистрыСведений.НастройкиПередачиТоваровМеждуОрганизациями.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, КлючЗаписи);
	МенеджерЗаписи.Прочитать();
	МенеджерЗаписи.Удалить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоПолноправныйПользователь()

	Возврат Пользователи.ЭтоПолноправныйПользователь();
	
КонецФункции

#КонецОбласти
