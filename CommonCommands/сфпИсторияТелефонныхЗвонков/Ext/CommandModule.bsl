﻿#Область ОбработчикиСобытий

&НаКлиенте
// Процедура - обработчик выполнения команды
//
// Параметры:
//	ПараметрКоманды				- Произвольный	- Параметр команды
//	ПараметрыВыполненияКоманды	- Структура		- Параметры выполнения команды
//
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	сфпСофтФонПроКлиентПереопределяемый.сфпОбработкаКомандыИсторияТелефонныхЗвонков(ПараметрКоманды, ПараметрыВыполненияКоманды);
КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти