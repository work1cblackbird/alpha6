﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Источник",     ПараметрыВыполненияКоманды.Источник);
	ПараметрыФормы.Вставить("Уникальность", ПараметрыВыполненияКоманды.Уникальность);
	
	Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ЗаявкаНаРемонт") Тогда
		
		// проверим, должен ли быть проведен документ основание и проведен ли он
		Если НЕ ДокументПроведен(ПараметрКоманды) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Ввод на основании непроведенного документа запрещен. Процедура заполнения прервана.'"));
			Возврат;
		КонецЕсли;
		
		Если ПроверкаНаличияПричиныОбращения(ПараметрКоманды) Тогда
			ПараметрыФормы.Вставить("Основание", ПараметрКоманды);
			ОбработчикОповещения = Новый ОписаниеОповещения("РезультатОповещенияДобавленияПричиныОбращения", ЭтотОбъект, ПараметрыФормы);
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Документ <%1> введен без причин обращения. %2Добавить причину обращения?'"), ПараметрКоманды, Символы.ПС);
			ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		ИначеЕсли ПроверкаРеквизитовЗаявкиНаРемонт(ПараметрКоманды) Тогда
			ПараметрыФормы.Вставить("Основание", ПараметрКоманды);
			ОткрытьФормуСозданияСводногоРемонтногоЗаказа(ПараметрКоманды, ПараметрыФормы);
		Иначе
			ОткрытьФормуВводаСводногоРемонтногоЗаказа(ПараметрКоманды, ПараметрыФормы);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Автомобили") Тогда
		
		Основание = Новый Структура;
		Основание.Вставить("Автомобиль", ПараметрКоманды);
		ОткрытьФорму("Документ.СводныйРемонтныйЗаказ.ФормаОбъекта", Новый Структура("Основание", Основание), ПараметрыВыполненияКоманды.Источник);
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьФормуВводаСводногоРемонтногоЗаказа(Основание, ДополнительныеПараметры)
	
	Если ТипЗнч(Основание) = Тип("Структура") Тогда
		ПараметрыФормы = Основание;
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗаявкаНаРемонт", Основание);
	КонецЕсли;
	
	ОткрытьФорму("Документ.СводныйРемонтныйЗаказ.Форма.ФормаВводаСводногоРемонтногоЗаказа", ПараметрыФормы, ДополнительныеПараметры.Источник, ДополнительныеПараметры.Уникальность, ,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры // ОткрытьФормуВводаСводногоРемонтногоЗаказа()

&НаСервере
Функция ДокументПроведен(ЗаявкаНаРемонт)
	
	Если ПраваИНастройкиПользователя.Значение("ВводНаОснованииПроведенныхДокументов", ЗаявкаНаРемонт) И НЕ ЗаявкаНаРемонт.Проведен Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции // ДокументПроведен()

&НаСервере
Функция ПроверкаНаличияПричиныОбращения(ЗаявкаНаРемонт)
	
	Возврат ЗаявкаНаРемонт.ПричиныОбращения.Количество() = 0;
	
КонецФункции // ПроверкаНаличияПричиныОбращения()

&НаКлиенте
Процедура РезультатОповещенияДобавленияПричиныОбращения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ОбработчикОповещения = Новый ОписаниеОповещения("ОбработкаРезультатаВыбораПричиныОбращения", ЭтотОбъект, ДополнительныеПараметры);
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ОткрытьФорму("Справочник.ПричиныОбращений.ФормаСписка", ПараметрыФормы, ,,,, ОбработчикОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		
		ПараметрыФормы = Новый Структура("Основание", ДополнительныеПараметры.Основание);
		ПараметрыФормы.Вставить("СоздаватьЗН", Истина);
		ПараметрыФормы.Вставить("ВводБезПричиныОбращения", Истина);
		ОткрытьФорму("Документ.СводныйРемонтныйЗаказ.ФормаОбъекта", ПараметрыФормы, ДополнительныеПараметры.Источник);
		
	КонецЕсли;
	
КонецПроцедуры // РезультатОповещенияДобавленияпричиныОбращения()

&НаКлиенте
Процедура ОбработкаРезультатаВыбораПричиныОбращения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавленаПричина = ДобавитьПричинуОбращения(Результат, ДополнительныеПараметры.Основание);
	
	Если НЕ ДобавленаПричина Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтрШаблон(
				НСтр("ru = 'Не удалось добавить причину обращения <%1> в документ <%2>.'"), 
			 	Результат,
				ДополнительныеПараметры.Основание
			)
		);
		Возврат;
	КонецЕсли;
	
	Если СтрНайти(ДополнительныеПараметры.Источник.ИмяФормы, "ФормаДокумента") <> 0 Тогда
		ДополнительныеПараметры.Источник.Прочитать();
	КонецЕсли;
	
	Если ПроверкаРеквизитовЗаявкиНаРемонт(ДополнительныеПараметры.Основание) Тогда
		ОткрытьФормуСозданияСводногоРемонтногоЗаказа(ДополнительныеПараметры.Основание, ДополнительныеПараметры);
	Иначе
		ОткрытьФормуВводаСводногоРемонтногоЗаказа(ДополнительныеПараметры.Основание, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаРезультатаВыбораПричиныОбращения()

&НаСервере
Функция ДобавитьПричинуОбращения(ПричинаОбращения, ДокументЗаявкаНаРемонт)
	
	ДокументОбъект = ДокументЗаявкаНаРемонт.ПолучитьОбъект();
	НоваяСтрока = ДокументОбъект.ПричиныОбращения.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ПричинаОбращения);
	НоваяСтрока.ПричинаОбращения = ПричинаОбращения;
	НоваяСтрока.ВидРемонтаПричиныОбращения = ПричинаОбращения.ВидРемонта;
	НоваяСтрока.ИдентификаторПричиныОбращения = Новый УникальныйИдентификатор;
	НоваяСтрока.ПричинаОбращенияСодержание = ?(НЕ ПустаяСтрока(ПричинаОбращения.ПричинаОбращения), ПричинаОбращения.ПричинаОбращения, Строка(ПричинаОбращения));
	ДокументОбъект.ОписаниеПричиныОбращения = ДокументОбъект.ОписаниеПричиныОбращения + ?(ПустаяСтрока(ДокументОбъект.ОписаниеПричиныОбращения), "", "; ") + ДокументОбъект.ПричиныОбращения[0].ПричинаОбращенияСодержание;
	
	Если СтрДлина(ДокументОбъект.ОписаниеПричиныОбращения) > 300 Тогда
		ДокументОбъект.ОписаниеПричиныОбращения = Лев(ДокументОбъект.ОписаниеПричиныОбращения, 297) + "...";
	КонецЕсли;
	Для Каждого Строка Из ДокументОбъект.Автоработы Цикл
		Если ПустаяСтрока(Строка.ИдентификаторПричиныОбращения) Тогда
			Строка.ИдентификаторПричиныОбращения = НоваяСтрока.ИдентификаторПричиныОбращения;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Строка Из ДокументОбъект.Товары Цикл
		Если ПустаяСтрока(Строка.ИдентификаторПричиныОбращения) Тогда
			Строка.ИдентификаторПричиныОбращения = НоваяСтрока.ИдентификаторПричиныОбращения;
		КонецЕсли;
	КонецЦикла;

	Попытка
		ДокументОбъект.Записать();
		Возврат Истина;
	Исключение
	КонецПопытки;
	
	Возврат Ложь;
	
КонецФункции // ДобавитьПричинуОбращения()

&НаСервере
Функция ПроверкаРеквизитовЗаявкиНаРемонт(ЗаявкаНаРемонт)
	
	Возврат (НЕ ЗначениеЗаполнено(ЗаявкаНаРемонт.Заказчик) ИЛИ НЕ ЗначениеЗаполнено(ЗаявкаНаРемонт.Автомобиль));
	
КонецФункции // ПроверкаРеквизитовЗаявкиНаРемонт()

&НаКлиенте
Процедура ОткрытьФормуСозданияСводногоРемонтногоЗаказа(Основание, ДополнительныеПараметры)
	
	ПараметрыФормы = Новый Структура("ЗаявкаНаРемонт", Основание);
	ОбработкаОповещения = Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаОповещенияСозданияСводногоРемонтногоЗаказа", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Документ.СводныйРемонтныйЗаказ.Форма.ФормаСозданияСводногоРемонтногоЗаказа", ПараметрыФормы, ДополнительныеПараметры.Источник, ДополнительныеПараметры.Уникальность,,, ОбработкаОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры // ОткрытьФормуСозданияСводногоРемонтногоЗаказа()

&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаОповещенияСозданияСводногоРемонтногоЗаказа(РезультатОповещения, ДополнительныеПараметры) Экспорт
	
	Если РезультатОповещения = Неопределено Тогда
		ПараметрыФормы = ДополнительныеПараметры.Основание;
	Иначе
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ЗаявкаНаРемонт", ДополнительныеПараметры.Основание);
		ПараметрыФормы.Вставить("АдресЗначенияРеквизитовДокумента", РезультатОповещения);
	КонецЕсли;
	
	ОткрытьФормуВводаСводногоРемонтногоЗаказа(ПараметрыФормы, ДополнительныеПараметры);
	
КонецПроцедуры // Подключаемый_ОбработкаРезультатаОповещенияСозданияСводногоРемонтногоЗаказа()

#КонецОбласти