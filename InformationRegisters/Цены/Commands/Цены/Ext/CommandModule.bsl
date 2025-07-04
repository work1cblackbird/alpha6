﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Номенклатура") Тогда
		
		ПараметрыОтбора = Новый Структура("Номенклатура", ПараметрКоманды);
		
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.ТипыЦен") Тогда
		
		ПараметрыОтбора = Новый Структура("ТипЦен", ПараметрКоманды);
		
	Иначе
		
		ПараметрыОтбора = Новый Структура("ХарактеристикаНоменклатуры", ПараметрКоманды);
		
	КонецЕсли;
	
	ОткрытьФорму(
		"РегистрСведений.Цены.ФормаСписка",
		Новый Структура("Отбор", ПараметрыОтбора),
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно
	);
	
КонецПроцедуры

#КонецОбласти