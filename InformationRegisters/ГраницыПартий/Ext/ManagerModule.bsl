﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Вызывается при непосредственном удалении проведенного документа
// проверяет есть ли граница с таким документом, если есть, то очищает ссылку.
Процедура УдалитьСсылкуНаДокумент(ДокументСсылка) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ГраницыПартий.СкладКомпании,
	|	ГраницыПартий.МоментВремени
	|ИЗ
	|	РегистрСведений.ГраницыПартий КАК ГраницыПартий
	|ГДЕ
	|	ГраницыПартий.ДокументСсылка = &Ссылка";
	
	Запрос=Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяЗапись = РегистрыСведений.ГраницыПартий.СоздатьМенеджерЗаписи();
		НоваяЗапись.СкладКомпании = Выборка.СкладКомпании;
		НоваяЗапись.МоментВремени = Выборка.МоментВремени;
		НоваяЗапись.ДокументСсылка = Неопределено;
		НоваяЗапись.Записать(ИСТИНА);
	КонецЦикла;
	
КонецПроцедуры // УдалитьСсылкуНаДокумент()

#Область ПараметрыОбработкиРеквизитовОбъекта

Функция ПолучитьОбязательныеРеквизиты(Объект) Экспорт
	
	ОбязательныеРеквизиты = ОбработкаСобытийРегистраСервер.ПолучитьСтандартныеОбязательныеРеквизиты(Объект);
	
	Возврат ОбязательныеРеквизиты;
	
КонецФункции 

Функция ПолучитьУникальныеРеквизиты(Объект) Экспорт
	
	УникальныеРеквизиты = Новый Структура();
	
	Возврат УникальныеРеквизиты;
	
КонецФункции 
#КонецОбласти

#КонецОбласти

#КонецЕсли