﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", Новый Структура("Номенклатура", ПараметрКоманды));
	
	ОткрытьФорму(
		"РегистрСведений.УпущенныйСпрос.ФормаЗаписи",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти