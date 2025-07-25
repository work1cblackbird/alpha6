﻿
#Область СлужебныйПрограммныйИнтерфейс

// Получение параметров для формирования запроса в личный кабинет Честного знака
//
// Параметры:
//  Организация	 - СправочникСсылка.Организации - Организация, для которой выполняется получение параметров
// 
// Возвращаемое значение:
//  Структура - Содержит информурмацию по организации
//
Функция ПараметрыЗапроса(Организация = Неопределено) Экспорт
	
	// Заполним по умолчанию
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("АдресКонтура", "ismp.crpt.ru");
	ПараметрыЗапроса.Вставить("ВерсияФорматаОбмена", "v3");
	ПараметрыЗапроса.Вставить("Порт", 443);
	ПараметрыЗапроса.Вставить("ВремяОжидания", 60);
	ПараметрыЗапроса.Вставить("ЗащищенноеСоединение", Истина);
	ПараметрыЗапроса.Вставить("СписокУстройств", Новый ТаблицаЗначений);
	ПараметрыЗапроса.Вставить("Сертификат", Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка());
	ПараметрыЗапроса.Вставить("omsId", "");
	ПараметрыЗапроса.Вставить("АдресСУЗ", "suz2.crpt.ru");
	ПараметрыЗапроса.Вставить("ПортСУЗ", 443);
	ПараметрыЗапроса.Вставить("ТокенДляККТ", "");
	ПараметрыЗапроса.Вставить("АдресCDNПлощадок", "");
	ПараметрыЗапроса.Вставить("Адрес", ПараметрыЗапроса.АдресКонтура);
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		ЗначенияПоОрганизации = НастройкаПодключения(Организация);
		
		Если ЗначенияПоОрганизации <> Неопределено Тогда
			ПараметрыЗапроса.omsId = ЗначенияПоОрганизации.omsId;
			ПараметрыЗапроса.АдресКонтура = ЗначенияПоОрганизации.Адрес;
			ПараметрыЗапроса.ВерсияФорматаОбмена = 
					Перечисления.ВерсииФорматовОбменаЧестногоЗнака.ЗначениеВерсииФормата(ЗначенияПоОрганизации.ВерсияФорматаОбмена);
			ПараметрыЗапроса.Порт = ЗначенияПоОрганизации.Порт;
			ПараметрыЗапроса.ВремяОжидания = ЗначенияПоОрганизации.ВремяОжидания;
			ПараметрыЗапроса.ЗащищенноеСоединение = ЗначенияПоОрганизации.ЗащищенноеСоединение;
			ПараметрыЗапроса.СписокУстройств = ЗначенияПоОрганизации.СписокУстройств;
			ПараметрыЗапроса.Сертификат = ЗначенияПоОрганизации.Сертификат;
			ПараметрыЗапроса.АдресСУЗ = ЗначенияПоОрганизации.АдресСУЗ;
			ПараметрыЗапроса.ПортСУЗ = ЗначенияПоОрганизации.ПортСУЗ;
			ПараметрыЗапроса.ТокенДляККТ = ЗначенияПоОрганизации.ТокенДляККТ;
			Если ЗначенияПоОрганизации.ТестовыйКонтур Тогда
				ПараметрыЗапроса.АдресCDNПлощадок = ПараметрыЗапроса.АдресКонтура;
			Иначе
				ПараметрыЗапроса.АдресCDNПлощадок = "cdn.crpt.ru";
			КонецЕсли;
			ПараметрыЗапроса.Адрес = ПараметрыЗапроса.АдресКонтура;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции // ПараметрыЗапроса()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получение настроек подключения из справочника настроек
//
// Параметры:
//  Организация	 - СправочникСсылка.Организации - Организация, для которой выполняется получение параметров
// 
// Возвращаемое значение:
//  Структура - Указанные параметры для данной организации
//
Функция НастройкаПодключения(Организация)
	
	Результат = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	НастройкаОбменаМаркировкиТоваров.ИдентификаторСУЗ КАК omsId,
	               |	НастройкаОбменаМаркировкиТоваров.Адрес КАК Адрес,
	               |	НастройкаОбменаМаркировкиТоваров.Порт КАК Порт,
	               |	НастройкаОбменаМаркировкиТоваров.ВремяОжидания КАК ВремяОжидания,
	               |	НастройкаОбменаМаркировкиТоваров.ВерсияФорматаОбмена КАК ВерсияФорматаОбмена,
	               |	НастройкаОбменаМаркировкиТоваров.ЗащищенноеСоединение КАК ЗащищенноеСоединение,
	               |	НастройкаОбменаМаркировкиТоваров.ТестовыйКонтур КАК ТестовыйКонтур,
	               |	НастройкаОбменаМаркировкиТоваров.АдресСУЗ КАК АдресСУЗ,
	               |	НастройкаОбменаМаркировкиТоваров.ПортСУЗ КАК ПортСУЗ,
	               |	НастройкаОбменаМаркировкиТоваров.Сертификат КАК Сертификат,
	               |	НастройкаОбменаМаркировкиТоваров.ТокенДляККТ КАК ТокенДляККТ,
	               |	НастройкаОбменаМаркировкиТоваров.СписокУстройств.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		ПодразделениеКомпании КАК ПодразделениеКомпании,
	               |		ИдентификаторСоединения КАК ИдентификаторСоединения
	               |	) КАК СписокУстройств
	               |ИЗ
	               |	Справочник.НастройкаОбменаМаркировкиТоваров КАК НастройкаОбменаМаркировкиТоваров
	               |ГДЕ
	               |	НастройкаОбменаМаркировкиТоваров.Организация = &Организация";
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Результат = Новый Структура();
		Результат.Вставить("Адрес");
		Результат.Вставить("ВерсияФорматаОбмена");
		Результат.Вставить("Порт");
		Результат.Вставить("ВремяОжидания");
		Результат.Вставить("ЗащищенноеСоединение");
		Результат.Вставить("Сертификат");
		Результат.Вставить("omsId");
		Результат.Вставить("АдресСУЗ");
		Результат.Вставить("ПортСУЗ");
		Результат.Вставить("ТокенДляККТ");
		Результат.Вставить("ТестовыйКонтур");
		
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
		
		Результат.Вставить("СписокУстройств", Выборка.СписокУстройств.Выгрузить());
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // НастройкаПодключения()

#КонецОбласти
