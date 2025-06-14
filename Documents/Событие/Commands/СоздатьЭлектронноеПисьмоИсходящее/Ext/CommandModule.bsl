﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПроверитьНеобходимостьВызоваФормыНаСервере(ПараметрКоманды) Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Событие", ПараметрКоманды);
		ОбработкаОповещения = Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаОповещенияСозданияДокумента", ЭтотОбъект, ПараметрыФормы);
		ОткрытьФорму("Документ.Событие.Форма.ФормаСозданияДокументаНаОснованииСобытия", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность,,, ОбработкаОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		Основание = Новый Структура;
		Основание.Вставить("Событие", ПараметрКоманды);
		Основание.Вставить("Имя",     "Событие");
		ОткрытьФорму("Документ.ЭлектронноеПисьмоИсходящее.ФормаОбъекта", Новый Структура("Основание", Основание), ПараметрыВыполненияКоманды.Источник);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПроверитьНеобходимостьВызоваФормыНаСервере(ДокументОснование)
	
	Возврат НЕ ЗначениеЗаполнено(ДокументОснование.Контрагент);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаОповещенияСозданияДокумента(РезультатОповещения, ДополнительныеПараметры) Экспорт
	
	Основание = Новый Структура;
	Основание.Вставить("Событие",    ДополнительныеПараметры.Событие);
	Основание.Вставить("Имя",        "Событие");
	Основание.Вставить("Контрагент", РезультатОповещения);
	
	ОткрытьФорму("Документ.ЭлектронноеПисьмоИсходящее.ФормаОбъекта", Новый Структура("Основание", Основание));
	
КонецПроцедуры // Подключаемый_ОбработкаРезультатаОповещенияСозданияДокумента()

#КонецОбласти