﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы элемента справочника "Мессенджеры"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отказ = Отказ Или РаботаСФормой.НужноОтменитьОткрытиеФормы();
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФормой.УстановитьДоступностьПоляКодНаФормеСправочника(ЭтотОбъект, Объект);
	
КонецПроцедуры

#КонецОбласти

