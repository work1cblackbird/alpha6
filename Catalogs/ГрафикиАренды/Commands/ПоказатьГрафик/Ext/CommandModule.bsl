﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОтбора = Новый Структура("ГрафикАренды", ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура("Отбор", ПараметрыОтбора);
	ОткрытьФорму("РегистрСведений.ГрафикПериодовАренды.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти