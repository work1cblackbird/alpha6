﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПараметры()
	
	ЕстьОтборПоПодразделению          = (ОтчетыПлатформаСервер.КомпоновщикСчетчикУсловийПоля(Новый ПолеКомпоновкиДанных("Подразделение"), КомпоновщикНастроек.Настройки.Отбор) = 1);
	ЕстьОтборПоПодразделениюИлиСкладу = (ОтчетыПлатформаСервер.КомпоновщикСчетчикУсловийПоля(Новый ПолеКомпоновкиДанных("СкладКомпании"), КомпоновщикНастроек.Настройки.Отбор) > 0);
	ЕстьПодразделение                 = ОтчетыПлатформаСервер.КомпоновщикЕстьПолеВСтруктуре(Новый ПолеКомпоновкиДанных("Подразделение"),  КомпоновщикНастроек.Настройки.Структура);
	
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ЕстьПодразделение",                 ЕстьПодразделение);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ЕстьОтборПоПодразделениюИлиСкладу", ЕстьОтборПоПодразделениюИлиСкладу);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ЕстьОтборПоПодразделению",          ЕстьОтборПоПодразделению);
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	УстановитьПараметры();
	ОтчетыПлатформаСервер.ВывестиОтчет(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЕстьОтборПоПодразделению = (ОтчетыПлатформаСервер.КомпоновщикСчетчикУсловийПоля(Новый ПолеКомпоновкиДанных("Подразделение"), КомпоновщикНастроек.Настройки.Отбор) = 1);
	ЕстьПодразделение        = ОтчетыПлатформаСервер.КомпоновщикЕстьПолеВСтруктуре(Новый ПолеКомпоновкиДанных("Подразделение"), КомпоновщикНастроек.Настройки.Структура);
	
	Если (НЕ ЕстьПодразделение) И (НЕ ЕстьОтборПоПодразделению) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Не задано подразделение. Будут выбраны минимальные остатки по компании.'");
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли