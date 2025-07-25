﻿
#Область ОбработчикиМетодовHTTP

Функция EventPOST(Запрос)
	
	ИмяСобытияДляЖурналаРегистрации = "/event";
	
	Если НЕ ПолучитьФункциональнуюОпцию("сфпИспользоватьОблачнуюТелефонию") Тогда
		Возврат СообщениеОбОшибке(500, ИмяСобытияДляЖурналаРегистрации, НСтр("ru='Использование телефонии Билайн отключено в настройках';en='Use of telephony Beeline turned off in settings'"));
	КонецЕсли;
	
	Попытка
		ТелоЗапроса = РаскодироватьСтроку(Запрос.ПолучитьТелоКакСтроку(), СпособКодированияСтроки.КодировкаURL);
		сфпСофтФонПроСерверПереопределяемый.ЗаписатьЗапросВЖурналРегистрации(ИмяСобытияДляЖурналаРегистрации, ТелоЗапроса);
		
		ЧтениеXML = Новый ЧтениеXML();
		ЧтениеXML.УстановитьСтроку(СтрЗаменить(ТелоЗапроса, "address countryCode=""7"">", "address>"));
		ПараметрыЗапроса = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		ЧтениеXML.Закрыть();
		
		Пользователь = "";
		НомерКонтакта = "";
		ИдентификаторЗвонка = "";
	
		Запрос = Новый Запрос("
		|ВЫБРАТЬ ВнутреннийНомерАТС КАК ВнутреннийНомер, Объект КАК Абонент
		|ИЗ РегистрСведений.сфпКонтактыТелефонии
		|ГДЕ ЛогинАТС = &Логин");
		Запрос.УстановитьПараметр("Логин", ПараметрыЗапроса.targetId);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Пользователь = Выборка.Абонент;
		КонецЕсли;
		
		ДанныеЗвонка = ПараметрыЗапроса.eventData.call;
		НомерКонтакта = сфпСофтФонПроСервер.сфпУбратьИзНомераТелефонаВсеПрефиксы(ДанныеЗвонка.remoteParty.address);
		ИдентификаторЗвонка = ДанныеЗвонка.callId;
			
		Если ЗначениеЗаполнено(ИдентификаторЗвонка) И ЗначениеЗаполнено(НомерКонтакта) И ЗначениеЗаполнено(Пользователь) Тогда
			Если Найти(ТелоЗапроса, "CallOriginatingEvent") > 0 Тогда
				// Отзвон АТС

			ИначеЕсли Найти(ТелоЗапроса, "CallOriginatedEvent") > 0 Тогда
				// Исходящий звонок
				сфпСофтФонПроСервер.ОбработатьИсходящийЗвонок(ТекущаяДатаСеанса(), Пользователь,, НомерКонтакта, ИдентификаторЗвонка);

			ИначеЕсли ДанныеЗвонка.state = "Alerting" Тогда //Найти(ТелоЗапроса, "CallReceivedEvent") > 0 Тогда
				// Входящий звонок
				сфпСофтФонПроСервер.ОбработатьВходящийЗвонок(НомерКонтакта, Пользователь, ТекущаяДатаСеанса(), ИдентификаторЗвонка);
				
			ИначеЕсли ДанныеЗвонка.state = "Active" Тогда //Найти(ТелоЗапроса, "CallAnsweredEvent") > 0 Тогда
				// Установлено соединение
				сфпСофтФонПроСервер.ОбработатьИзменениеЗвонка(ИдентификаторЗвонка, ТекущаяДатаСеанса(), Пользователь);
								
			ИначеЕсли ДанныеЗвонка.state = "Released" Тогда //Найти(ТелоЗапроса, "CallReleasedEvent") > 0 Тогда
				// Завершение звонка
				ИдентификаторЗаписи = ДанныеЗвонка.extTrackingId + "/" + ПараметрыЗапроса.targetId;
				сфпСофтФонПроСервер.ОбработатьЗавершениеЗвонка(,,, ТекущаяДатаСеанса(),,, ИдентификаторЗаписи,, ИдентификаторЗвонка,, Пользователь);
			КонецЕсли;
		КонецЕсли;
	Исключение КонецПопытки;
	
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
	
КонецФункции

Функция pingGET(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.УстановитьТелоИзСтроки("ok");
	Возврат Ответ;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СообщениеОбОшибке(КодСостояния, ВложенноеИмяСобытия, Комментарий = Неопределено)
	
	ЗаписьЖурналаРегистрации(
		сфпСофтФонПроСерверПереопределяемый.СобытиеЖурналаРегистрации() + "." + ВложенноеИмяСобытия,
		УровеньЖурналаРегистрации.Ошибка,,,
		Комментарий);
	
	Ответ = Новый HTTPСервисОтвет(КодСостояния);
	Возврат Ответ;
	
КонецФункции

#КонецОбласти
