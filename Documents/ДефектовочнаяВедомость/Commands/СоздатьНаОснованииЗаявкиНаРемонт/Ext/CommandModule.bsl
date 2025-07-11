﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Источник",     ПараметрыВыполненияКоманды.Источник);
	ПараметрыФормы.Вставить("Уникальность", ПараметрыВыполненияКоманды.Уникальность);
	
	Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ЗаявкаНаРемонт") Тогда
		
		Если ПроверкаРеквизитовЗаявкиНаРемонт(ПараметрКоманды) Тогда
			ПараметрыФормы.Вставить("Основание", ПараметрКоманды);
			ОткрытьФормуВводаДефектовочнойВедомости(ПараметрКоманды, ПараметрыФормы);
		Иначе
			ПараметрыФормы = Новый Структура();
			ПараметрыФормы.Вставить("Основание", ПараметрКоманды);
			ОткрытьФорму(
				"Документ.ДефектовочнаяВедомость.ФормаОбъекта",
				ПараметрыФормы,
				ПараметрыВыполненияКоманды.Источник,
				ПараметрыВыполненияКоманды.Уникальность);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьФормуВводаДефектовочнойВедомости(Основание, ДополнительныеПараметры)
	
	Если ТипЗнч(Основание) = Тип("Структура") Тогда
		ПараметрыФормы = Основание;
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗаявкаНаРемонт", Основание);
	КонецЕсли;
	Оповещение = Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаОповещенияСозданияДефектовочнойВедомости", ЭтотОбъект, ДополнительныеПараметры); 
	
	ОткрытьФорму("Документ.ДефектовочнаяВедомость.Форма.ФормаСозданияДефектовочнойВедомости", ПараметрыФормы, ДополнительныеПараметры.Источник, ДополнительныеПараметры.Уникальность, ,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры // ОткрытьФормуВводаСводногоРемонтногоЗаказа()

&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаОповещенияСозданияДефектовочнойВедомости(РезультатОповещения, ДополнительныеПараметры) Экспорт
	
	Если РезультатОповещения = Неопределено Тогда
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Основание", ДополнительныеПараметры.Основание);
	Иначе
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Основание", ДополнительныеПараметры.Основание);
		ДанныеЗаполнения = ПолучитьИзВременногоХранилища(РезультатОповещения);
		ПараметрыФормы.Вставить("Автомобиль", ДанныеЗаполнения.Автомобиль);
		ПараметрыФормы.Вставить("Заказчик", ДанныеЗаполнения.Заказчик);
	КонецЕсли;
	
	ОткрытьФорму("Документ.ДефектовочнаяВедомость.ФормаОбъекта", ПараметрыФормы); 
	
КонецПроцедуры // Подключаемый_ОбработкаРезультатаОповещенияСозданияДефектовочнойВедомости()

&НаСервере
Функция ПроверкаРеквизитовЗаявкиНаРемонт(ЗаявкаНаРемонт)
	
	Возврат (НЕ ЗначениеЗаполнено(ЗаявкаНаРемонт.Заказчик) ИЛИ НЕ ЗначениеЗаполнено(ЗаявкаНаРемонт.Автомобиль));
	
КонецФункции // ПроверкаРеквизитовЗаявкиНаРемонт()

#КонецОбласти