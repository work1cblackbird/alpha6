﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Функция - Проверка наличия блокировки от изменений документа
//
// Параметры:
//  ДокументЗаказНаряд	 - ДокументСсылка.ЗаказНаряд - Документ, для которого производиться проверка блокировки.
// 
// Возвращаемое значение:
//   - Данные о блокировки документа.
//
Функция ПроверкаБлокировкиИзменений(ДокументЗаказНаряд) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Массив;
	
	Если НЕ ЗначениеЗаполнено(ДокументЗаказНаряд) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	БлокировкаЗаказНарядов.ДатаБлокировки КАК ДатаБлокировки,
	               |	БлокировкаЗаказНарядов.ДатаСнятияБлокировки КАК ДатаСнятияБлокировки,
	               |	БлокировкаЗаказНарядов.Пользователь КАК Пользователь,
	               |	БлокировкаЗаказНарядов.ТекстовоеОписание КАК ТекстовоеОписание
	               |ИЗ
	               |	РегистрСведений.БлокировкаЗаказНарядов КАК БлокировкаЗаказНарядов
	               |ГДЕ
	               |	БлокировкаЗаказНарядов.ЗаказНаряд = &ЗаказНаряд
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ДатаСнятияБлокировки УБЫВ";
	Запрос.УстановитьПараметр("ЗаказНаряд", ДокументЗаказНаряд);
	
	Выборка = Запрос.Выполнить().Выгрузить();
	
	Если Выборка.Количество() > 0 Тогда
		
		Если Не ЗначениеЗаполнено(Выборка[Выборка.Количество() - 1].ДатаСнятияБлокировки) Тогда
			
			// По незаполненной дате блокировки
			Результат.Добавить(Выборка[Выборка.Количество() - 1]);
			
		ИначеЕсли Выборка[0].ДатаСнятияБлокировки > ТекущаяДатаСеанса() Тогда
			
			// По крайней дате блокировки
			Результат.Добавить(Выборка[0]);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ПроверкаБлокировкиИзменений()

#Область ПараметрыОбработкиРеквизитовОбъекта

Функция ПолучитьОбязательныеРеквизиты(Объект) Экспорт
	
	ОбязательныеРеквизиты = ОбработкаСобытийРегистраСервер.ПолучитьСтандартныеОбязательныеРеквизиты(Объект);
	
	Возврат ОбязательныеРеквизиты;
	
КонецФункции 

Функция ПолучитьУникальныеРеквизиты(Объект) Экспорт
	
	УникальныеРеквизиты = Новый Структура();
	
	Возврат УникальныеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли