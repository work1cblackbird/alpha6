﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Владелец", ПараметрКоманды));
	ОткрытьФорму("Справочник.ВариантыКомплектации.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность,, ПараметрыВыполненияКоманды.НавигационнаяСсылка,, РежимОткрытияОкнаФормы.Независимый);
КонецПроцедуры

#КонецОбласти