﻿////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиИнтеграцияКлиентСобытия: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ПослеНачалаРаботыСистемы() Экспорт 
	
	Если Не ОбщегоНазначенияКлиент.ДоступноИспользованиеРазделенныхДанных() Тогда 
		Возврат;
	КонецЕсли; 
		
	СостоянияПисем = ОбменСБанкамиСлужебныйВызовСервера.ТекущееСостояниеПисемСБанками();   
	Если Не СостоянияПисем.ЕстьНастройка 
		Или Не СостоянияПисем.ЕстьПравоЧтенияДанных 
		Или Не СостоянияПисем.ИспользуетсяОбменСБанками Тогда
		Возврат;
	КонецЕсли; 
	
	УведомленияОНепрочитанныхПисьмах(СостоянияПисем);
	УведомленияОбИсходящихНеотправленныхПисьмах();   
	
КонецПроцедуры

Процедура УведомленияОНовыхПисьмах(ПолученныеПисьма)
	
	ОтправителиПоБанкам = ОбменСБанкамиСлужебныйВызовСервера.РассчитатьПолученныеПисьмаПоБанкам(ПолученныеПисьма);
	Для Каждого СведенияОПисьмах Из ОтправителиПоБанкам Цикл	
		ОповещениеДляОткрытияФормы = Новый ОписаниеОповещения("ДействиеИнформацияОПисьмах",ЭтотОбъект,"Входящие");
		СтруктураСообщения = ТекстОНовыхСообщениях(СведенияОПисьмах.КоличествоПисем,СведенияОПисьмах.НазваниеБанка); 
		ПоказатьОповещениеПользователя(СтруктураСообщения.Текст,
			ОповещениеДляОткрытияФормы,
			СтруктураСообщения.Пояснение,
			БиблиотекаКартинок.ОповещениеОНовыхПисьмахОбменСБанками, 
			СтатусОповещенияПользователя.Важное,
			"УведомленияОНовыхПисьмахОбменСбанками");
	КонецЦикла;    
	
КонецПроцедуры   

Процедура УведомленияОНепрочитанныхПисьмах(СтруктураСостоянияПисем)
	
	ОповещениеДляОткрытияФормы = Новый ОписаниеОповещения("ДействиеИнформацияОПисьмах",ЭтотОбъект,"Входящие");	
	СведенияОНепрочитанных = СтруктураСостоянияПисем.СведенияОНепрочитанных;                       
	
	Для Каждого СтрСведения Из СведенияОНепрочитанных Цикл
		ВсегоНепрочитанно = СтрСведения.Количество;
		Если ВсегоНепрочитанно = 0 Тогда
			Продолжить;
		КонецЕсли;
		СтруктураСообщения = ТекстОНепрочитанныхСообщениях(ВсегоНепрочитанно, СтрСведения.Банк); 
		ПоказатьОповещениеПользователя(СтруктураСообщения.Текст,
			ОповещениеДляОткрытияФормы,
			СтруктураСообщения.Пояснение,
			БиблиотекаКартинок.ОповещениеОНовыхПисьмахОбменСБанками, 
			СтатусОповещенияПользователя.Важное,
			"УведомленияОНепрочитанныхПисьмахОбменСБанками");
	КонецЦикла;   	
	
КонецПроцедуры 

Процедура УведомленияОбИсходящихНеотправленныхПисьмах()
	
	ОповещениеДляОткрытияФормы = Новый ОписаниеОповещения("ДействиеИнформацияОПисьмах",ЭтотОбъект,"Исходящие");
	ВсегоИсходящих = ОбменСБанкамиСлужебныйВызовСервера.КоличествоНеотправленныхПисем();  
	
	ТекстОповещения = НСтр("ru = 'Проверьте папку ""Исходящие""'");
	Если ВсегоИсходящих > 0 Тогда	
		ПоказатьОповещениеПользователя(
			ТекстОНеотправленныхИсходящих(ВсегоИсходящих),
			ОповещениеДляОткрытияФормы,
			ТекстОповещения,
			БиблиотекаКартинок.Предупреждение32, 
			СтатусОповещенияПользователя.Важное,
			"УведомленияОбИсходящихНеотправленныхПисьмахОбменСБанками");   
	КонецЕсли;
	
КонецПроцедуры

Функция ТекстОНовыхСообщениях(ВсегоКоличество, НазваниеБанка)    
	
	СклоняемыйТекст = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
		НСтр("ru=';1С:ДиректБанк - %1 новое письмо;;1С:ДиректБанк - %1 новых письма;1С:ДиректБанк - %1 новых писем;'"), 
		ВсегоКоличество);		
	
	СтруктураСообщения = Новый Структура;
	СтруктураСообщения.Вставить("Текст",СклоняемыйТекст);
	СтруктураСообщения.Вставить("Пояснение", СтрШаблон("от %1",НазваниеБанка));
	
	Возврат СтруктураСообщения;
	
КонецФункции 

Функция ТекстОНепрочитанныхСообщениях(ВсегоКоличество, НазваниеБанка)	
	
	СклоняемыйТекст = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
		НСтр("ru=';1С:ДиректБанк - %1 непрочтенное письмо;;1С:ДиректБанк - %1 непрочитанных письма;1С:ДиректБанк - %1 непрочитанных писем;'"), 
		ВсегоКоличество);
	
	СтруктураСообщения = Новый Структура;
	СтруктураСообщения.Вставить("Текст",СклоняемыйТекст);
	СтруктураСообщения.Вставить("Пояснение", СтрШаблон("от %1",НазваниеБанка));
	
	Возврат СтруктураСообщения;
	
КонецФункции 

Функция ТекстОНеотправленныхИсходящих(ВсегоКоличество)    
	
	СклоняемыйТекст = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
		НСтр("ru=';1С:ДиректБанк - %1 неотправленное письмо;;1С:ДиректБанк - %1 неотправленных письма;1С:ДиректБанк - %1 неотправленных писем;'"), 
		ВсегоКоличество);		
	
	Возврат СклоняемыйТекст;
	
КонецФункции  

Процедура ДействиеИнформацияОПисьмах(НазваниеРаздела) Экспорт   
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Раздел",НазваниеРаздела);
	
	ОткрытьФорму("Документ.ПисьмоОбменСБанками.ФормаСписка",ПараметрыОткрытия);
	
КонецПроцедуры

// СтандартныеПодсистемы.БазоваяФункциональность

// См. СтандартныеПодсистемыКлиент.ПриПолученииСерверногоОповещения.
//
Процедура ПриПолученииСерверногоОповещения(ИмяОповещения, Результат) Экспорт	
	
	Если ИмяОповещения = "ЭлектронноеВзаимодействие.ОбменСбанками.ЕстьНовыеПисьма" Тогда 
		УведомленияОНовыхПисьмах(Результат);	 		
	ИначеЕсли ИмяОповещения = "ЭлектронноеВзаимодействие.ОбменСбанками.ЕстьНепрочитанныеПисьма" Тогда 
		СтруктураСостоянияПисем = ОбменСБанкамиСлужебныйВызовСервера.ТекущееСостояниеПисемСБанками();
		УведомленияОНепрочитанныхПисьмах(СтруктураСостоянияПисем);     
	ИначеЕсли ИмяОповещения = "ЭлектронноеВзаимодействие.ОбменСбанками.ЕстьНеотправленныеПисьма" Тогда  
		УведомленияОбИсходящихНеотправленныхПисьмах();   
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.БазоваяФункциональность

#КонецОбласти   





