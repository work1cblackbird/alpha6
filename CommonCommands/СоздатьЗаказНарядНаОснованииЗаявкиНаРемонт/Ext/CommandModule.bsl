﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// Проверим, должен ли быть проведен документ основание и проведен ли он
	Если НЕ ДокументПроведен(ПараметрКоманды) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Ввод на основании непроведенного документа запрещен. Процедура заполнения прервана.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
	
	ОткрытьФорму("Документ.ЗаказНаряд.ФормаОбъекта",
	ПараметрыФормы,
	ПараметрыВыполненияКоманды.Источник,
	ПараметрыВыполненияКоманды.Уникальность,
	ПараметрыВыполненияКоманды.Окно,
	ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДокументПроведен(ЗаявкаНаРемонт)
	
	Если ПраваИНастройкиПользователя.Значение("ВводНаОснованииПроведенныхДокументов", ЗаявкаНаРемонт)
		И НЕ ЗаявкаНаРемонт.Проведен Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции // ДокументПроведен()

#КонецОбласти