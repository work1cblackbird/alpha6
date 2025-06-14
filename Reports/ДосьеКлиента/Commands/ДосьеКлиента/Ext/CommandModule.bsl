﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// фильтры
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Клиент", ПараметрКоманды);
	
	ОткрытьФорму("Отчет.ДосьеКлиента.ФормаНастроек", ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно
	);
	
КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти