﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(Объект, Параметры.Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НеДобавлятьНоменклатуруПриСозданииАвтоработПриИзменении(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НеДобавлятьНоменклатуруПриСозданииАвтоработПриИзменении(Элемент)
	
	Элементы.НоменклатураДляАвтоработПоУмолчанию.Доступность = Объект.НеДобавлятьНоменклатуруПриСозданииАвторабот;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьИСохранить(Команда)
	
	Закрыть(Объект);
	
КонецПроцедуры

#КонецОбласти
