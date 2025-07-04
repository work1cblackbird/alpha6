﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОсновнаяСхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, ОсновнаяСхемаКомпоновкиДанных, "dataCompositionScheme", "http://v8.1c.ru/8.1/data-composition-system/scheme");
	ТекстЗапроса = ЗаписьXML.Закрыть();
	
	ИзмерениеСтроки  = ОтчетыПлатформаСервер.КомпоновщикПолучитьЗначениеПараметра("ИзмерениеСтроки",  КомпоновщикНастроек.Настройки);
	ИзмерениеКолонки = ОтчетыПлатформаСервер.КомпоновщикПолучитьЗначениеПараметра("ИзмерениеКолонки", КомпоновщикНастроек.Настройки);
	
	Если ИзмерениеСтроки >= ИзмерениеКолонки + 1 Тогда
		ВызватьИсключение НСтр("ru = 'Неверно указаны измерения строки и колонки.'");
	КонецЕсли;
	
	ФорматПредставленияПериодаСтроки = "";
	ФорматПредставленияПериодаКолонки = "";
	ЗаголовокПериодаСтроки = "Период ";
	
	Если ИзмерениеСтроки = 1 Тогда
		ФорматПредставленияПериодаСтроки = "ДФ='гггг ""г.""'";
		ЗаголовокПериодаСтроки = ЗаголовокПериодаСтроки + "год";
	ИначеЕсли ИзмерениеСтроки = 2 Тогда
		ФорматПредставленияПериодаСтроки = "ДФ='к ""квартал"" гггг ""г.""'";
		ЗаголовокПериодаСтроки = ЗаголовокПериодаСтроки + "квартал";
	ИначеЕсли ИзмерениеСтроки = 3 Тогда
		ФорматПредставленияПериодаСтроки = "ДФ='ММММ гггг ""г.""'";
		ЗаголовокПериодаСтроки = ЗаголовокПериодаСтроки + "месяц";
	ИначеЕсли ИзмерениеСтроки = 4 Тогда
		ФорматПредставленияПериодаСтроки = "ДФ='""Неделя с"" дд.ММ.гггг ""г.""'";
		ЗаголовокПериодаСтроки = ЗаголовокПериодаСтроки + "неделя";
	КонецЕсли;
	
	Если ИзмерениеКолонки = 1 Тогда
		ФорматПредставленияПериодаКолонки = "ДФ='к ""квартал""'";
	ИначеЕсли ИзмерениеКолонки = 2 Тогда
		ФорматПредставленияПериодаКолонки = "ДФ='ММММ'";
	ИначеЕсли ИзмерениеКолонки = 3 Тогда
		ФорматПредставленияПериодаКолонки = "ДФ='""Неделя с"" дд.ММ.гггг ""г.""'";
	ИначеЕсли ИзмерениеКолонки = 4 Тогда
		Если ИзмерениеСтроки > 2 Тогда
			ФорматПредставленияПериодаКолонки = "ДФ=дд";
		Иначе
			ФорматПредставленияПериодаКолонки = "ДФ=дд.ММ";
		КонецЕсли;
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ТекстЗапроса);
	КопияСхемы = СериализаторXDTO.ПрочитатьXML(ЧтениеXML, Тип("СхемаКомпоновкиДанных"));
	
	Для Каждого ТекНабор Из КопияСхемы.НаборыДанных Цикл
		Для Каждого ТекПоле Из ТекНабор.Поля Цикл
			Если НЕ ТипЗнч(ТекПоле) = Тип("ПолеНабораДанныхСхемыКомпоновкиДанных") Тогда
				Продолжить;
			КонецЕсли;
			ИмяПоля = СокрЛП(ТекПоле.Поле);
			Если ИмяПоля = "ПериодСтроки" Тогда
				ТекПоле.Оформление.УстановитьЗначениеПараметра("Формат", ФорматПредставленияПериодаСтроки);
				ТекПоле.Заголовок = ЗаголовокПериодаСтроки;
			ИначеЕсли ИмяПоля = "ПериодКолонки" Тогда
				ТекПоле.Оформление.УстановитьЗначениеПараметра("Формат", ФорматПредставленияПериодаКолонки);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Запрос = ПолучитьОсновнойЗапрос();
	
	ОтборКомпоновки  = КомпоновщикНастроек.Настройки.Отбор;
	
	// Заполним параметры
	НачалоПериода    = ОтчетыПлатформаСервер.КомпоновщикПолучитьЗначениеПараметра("НачалоПериода",    КомпоновщикНастроек.Настройки);
	КонецПериода     = ОтчетыПлатформаСервер.КомпоновщикПолучитьЗначениеПараметра("КонецПериода",     КомпоновщикНастроек.Настройки);
	
	ТаблицаПериодов = Новый ТаблицаЗначений;
	ТаблицаПериодов.Колонки.Добавить("ПериодСтроки", Новый ОписаниеТипов("Дата"));
	ТаблицаПериодов.Колонки.Добавить("ПериодКолонки", Новый ОписаниеТипов("Дата"));
	ТаблицаПериодов.Колонки.Добавить("ПериодНижнийПредел", Новый ОписаниеТипов("Дата"));
	ТаблицаПериодов.Колонки.Добавить("ПериодВерхнийПредел", Новый ОписаниеТипов("Дата"));
	ТаблицаПериодов.Колонки.Добавить("НомерКолонки", Новый ОписаниеТипов("Число"), Новый КвалификаторыЧисла(2));
	
	ТекДата = НачалоПериода;
	МинимальныйПределПериода = 1;
	Если ИзмерениеСтроки=1 Тогда // Год
		МинимальныйПределМесяца = 29;
		МинимальныйПределПериода = 366;
		ТекДата	= НачалоГода(НачалоПериода);
	ИначеЕсли ИзмерениеСтроки=2 Тогда // Квартал
		МинимальныйПределМесяца = 29;
		МинимальныйПределПериода = 92;
		ТекДата = НачалоКвартала(НачалоПериода);
	ИначеЕсли ИзмерениеСтроки=3 Тогда // Месяц
		МинимальныйПределМесяца = 31;
		МинимальныйПределПериода = 31;
		ТекДата = НачалоМесяца(НачалоПериода);
	ИначеЕсли ИзмерениеСтроки=4 Тогда // Неделя
		МинимальныйПределМесяца = 29;
		МинимальныйПределПериода = 7;
		ТекДата	= НачалоНедели(НачалоПериода);
	КонецЕсли;
	
	Шаг = 0;
	Если ИзмерениеКолонки = 1 Тогда
		Шаг = 3;
	ИначеЕсли ИзмерениеКолонки = 2 Тогда
		Шаг = 1;
	ИначеЕсли ИзмерениеКолонки = 3 Тогда
		Шаг = 60*60*24*7;
	ИначеЕсли ИзмерениеКолонки = 4 Тогда
		Шаг = 60*60*24;
	КонецЕсли;
	
	КолонкаДата = (ИзмерениеСтроки = 1 И ИзмерениеКолонки = 2 ИЛИ ИзмерениеСтроки = 1 И ИзмерениеКолонки = 4);
	Если ИзмерениеКолонки = 3 Тогда // Неделя
		ПустаяДата = Дата(1904, 1, 1);
		МинимальныйПределПериода = Окр(МинимальныйПределПериода/7+0.5, 0, 0)+?(ИзмерениеСтроки=3, 1, 0);
		Пока ТекДата<КонецПериода Цикл // Период от начальной даты до конечной даты
			Если ИзмерениеСтроки=1 Тогда
				ПериодСтроки = НачалоГода(ТекДата);
				ТекКонДата = КонецГода(ТекДата);
			ИначеЕсли ИзмерениеСтроки=2 Тогда
				ПериодСтроки = НачалоКвартала(ТекДата);
				ТекКонДата = КонецКвартала(ТекДата);
			ИначеЕсли ИзмерениеСтроки=3 Тогда
				ПериодСтроки = НачалоМесяца(ТекДата);
				ТекКонДата = КонецМесяца(ТекДата);
			КонецЕсли;
			
			Счетчик = 1;
			ТекДата	= НачалоНедели(ТекДата);
			ТекКонДата = Мин(ТекКонДата, КонецПериода);
			Пока ТекДата<ТекКонДата Цикл // период по группировке строки
				НоваяСтрока = ТаблицаПериодов.Добавить();
				НоваяСтрока.ПериодСтроки = ПериодСтроки;
				НоваяСтрока.ПериодКолонки = ТекДата;
				НоваяСтрока.НомерКолонки = Счетчик;
				НоваяСтрока.ПериодНижнийПредел = Макс(ТекДата, ПериодСтроки);
				ТекДата = ТекДата + Шаг;
				НоваяСтрока.ПериодВерхнийПредел = ТекДата;
				Счетчик = Счетчик + 1;
			КонецЦикла;
			
			// добавим пустышки до последнего дня
			Если ТекДата<КонецПериода И Счетчик <= МинимальныйПределПериода Тогда
				ТекДатаКолонки = ТекДата - Шаг;
				Пока Счетчик <= МинимальныйПределПериода Цикл
					НоваяСтрока = ТаблицаПериодов.Добавить();
					НоваяСтрока.ПериодСтроки = ПериодСтроки;
					НоваяСтрока.ПериодКолонки = ТекДатаКолонки;
					НоваяСтрока.НомерКолонки = Счетчик;
					НоваяСтрока.ПериодНижнийПредел = ПустаяДата;
					НоваяСтрока.ПериодВерхнийПредел = ПустаяДата;
					Счетчик = Счетчик + 1;
				КонецЦикла;
			Иначе
				НоваяСтрока.ПериодВерхнийПредел = ТекКонДата+1;
			КонецЕсли;
			ТекДата = ТекКонДата+1;
		КонецЦикла;
	
	ИначеЕсли ИзмерениеСтроки<>4 И ИзмерениеКолонки = 4 Тогда // день
		
		Пока ТекДата<КонецПериода Цикл // Период от начальной даты до конечной даты
			Если ИзмерениеСтроки=1 Тогда
				ТекКонДата = КонецГода(ТекДата);
			ИначеЕсли ИзмерениеСтроки=2 Тогда
				ТекКонДата = КонецКвартала(ТекДата);
			ИначеЕсли ИзмерениеСтроки=3 Тогда
				ТекКонДата = КонецМесяца(ТекДата);
			КонецЕсли;
			
			Счетчик = 1;
			ПериодСтроки = ТекДата;
			НетПустышек = Истина;
			ТекКонДата = Мин(ТекКонДата, КонецПериода);
			Пока ТекДата<ТекКонДата Цикл // период по группировке строки
				
				Если МинимальныйПределМесяца = 29 Тогда
					ТекДатаКолонки = Дата(1904, Месяц(ТекДата), День(ТекДата));
				Иначе
					ТекДатаКолонки = Дата(1904, 1, День(ТекДата));
				КонецЕсли;
				ТекДень = День(ТекДата);
				ПоследнийДень = День(КонецМесяца(ТекДата));
				Пока ТекДень <= ПоследнийДень Цикл // период по месяцу
					НоваяСтрока = ТаблицаПериодов.Добавить();
					НоваяСтрока.ПериодСтроки = ПериодСтроки;
					НоваяСтрока.ПериодКолонки = ТекДатаКолонки;
					НоваяСтрока.НомерКолонки = Счетчик;
					НоваяСтрока.ПериодНижнийПредел = ТекДата;
					ТекДатаКолонки = ТекДатаКолонки + Шаг;
					ТекДата = ТекДата + Шаг;
					НоваяСтрока.ПериодВерхнийПредел = ТекДата;
					ТекДень = ТекДень + 1;
					Счетчик = Счетчик + 1;
					Если ТекДата>КонецПериода Тогда
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Если ТекДата>КонецПериода Тогда
					Прервать;
				КонецЕсли;
				
				// добавим пустышки до последнего дня
				НетПустышек = Истина;
				Если ТекДень <= МинимальныйПределМесяца Тогда
					ТекДатаКолонки = Дата(1904, Месяц(ТекДатаКолонки), ПоследнийДень+1);
					Пока ТекДень <= МинимальныйПределМесяца Цикл
						НоваяСтрока = ТаблицаПериодов.Добавить();
						НоваяСтрока.ПериодСтроки = ПериодСтроки;
						НоваяСтрока.ПериодКолонки = ТекДатаКолонки;
						НоваяСтрока.НомерКолонки = Счетчик;
						НоваяСтрока.ПериодНижнийПредел = ТекДатаКолонки;
						НоваяСтрока.ПериодВерхнийПредел = ТекДатаКолонки;
						ТекДатаКолонки = ТекДатаКолонки + Шаг;
						ТекДень = ТекДень + 1;
						Счетчик = Счетчик + 1;
					КонецЦикла;
					НетПустышек = Ложь;
				КонецЕсли;
			КонецЦикла;
			
			// добавим пустышки до последнего дня
			Если ТекДата<КонецПериода И Счетчик <= МинимальныйПределПериода Тогда
				ТекДатаКолонки = ТекДатаКолонки-Шаг;
				Пока Счетчик <= МинимальныйПределПериода Цикл
					НоваяСтрока = ТаблицаПериодов.Добавить();
					НоваяСтрока.ПериодСтроки = ПериодСтроки;
					НоваяСтрока.ПериодКолонки = ТекДатаКолонки;
					НоваяСтрока.НомерКолонки = Счетчик;
					НоваяСтрока.ПериодНижнийПредел = ТекДатаКолонки;
					НоваяСтрока.ПериодВерхнийПредел = ТекДатаКолонки;
					Счетчик = Счетчик + 1;
				КонецЦикла;
				НетПустышек = Ложь;
			КонецЕсли;
			ТекДата = ТекКонДата+1;
			Если НетПустышек Тогда
				НоваяСтрока.ПериодВерхнийПредел = ТекДата;
			КонецЕсли;
		КонецЦикла;

	Иначе // Год, Квартал, Месяц
		
		Пока ТекДата<КонецПериода Цикл
			Если ИзмерениеСтроки=1 Тогда
				ТекКонДата = КонецГода(ТекДата);
			ИначеЕсли ИзмерениеСтроки=2 Тогда
				ТекКонДата = КонецКвартала(ТекДата);
			ИначеЕсли ИзмерениеСтроки=4 Тогда
				ТекКонДата = КонецНедели(ТекДата);
			КонецЕсли;
			ПериодСтроки = ТекДата;
			ТекКонДата = Мин(ТекКонДата, КонецПериода);
			Счетчик = 1;
			Пока ТекДата < ТекКонДата Цикл
				НоваяСтрока = ТаблицаПериодов.Добавить();
				НоваяСтрока.ПериодСтроки = ПериодСтроки;
				НоваяСтрока.ПериодКолонки = Дата(1904, Месяц(ТекДата), День(ТекДата));
				НоваяСтрока.НомерКолонки = Счетчик;
				НоваяСтрока.ПериодНижнийПредел = ТекДата;
				Если ИзмерениеСтроки = 4 Тогда
					ТекДата = ТекДата + Шаг;
				Иначе
					ТекДата = ДобавитьМесяц(ТекДата, Шаг);
				КонецЕсли;
				НоваяСтрока.ПериодВерхнийПредел = ТекДата;
				Счетчик = Счетчик+1;
			КонецЦикла;
			ТекДата = ТекКонДата+1;
			НоваяСтрока.ПериодВерхнийПредел = ТекДата;
		КонецЦикла;
	КонецЕсли;

	ТекстЗапроса = " ВЫБРАТЬ
	|	ТаблицаДанных.ПериодСтроки КАК ПериодСтроки,
	|	ТаблицаДанных."+?(КолонкаДата,"ПериодКолонки","НомерКолонки")+" КАК ПериодКолонки,
	|	ТаблицаДанных.ПериодНижнийПредел,
	|	ТаблицаДанных.ПериодВерхнийПредел
	|ПОМЕСТИТЬ
	|	ВременнаяТаблица
	|ИЗ
	|	&ТаблицаДанных КАК ТаблицаДанных";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	ВременныйМенеджер = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = ВременныйМенеджер;
	Запрос.УстановитьПараметр("ТаблицаДанных", ТаблицаПериодов);
	Запрос.Выполнить();
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ДатаНач", НачалоПериода);
	Запрос.УстановитьПараметр("ДатаКон", КонецПериода);
	
	ТекстОтбораДвижений = ОтчетыПлатформаСервер.КомпоновщикПолучитьТекстОтбора(ОтборКомпоновки.Элементы, ОтборКомпоновки.ДоступныеПоляОтбора, "ТоварыВПроизводстве",Запрос.Параметры);
	ТекстОтбора = СтрЗаменить(ТекстОтбораДвижений, "ТоварыВПроизводстве.", "");
	
	Если НЕ ПустаяСтрока(ТекстОтбораДвижений) Тогда
		ТекстОтбораДвижений = " И " + ТекстОтбораДвижений;
	КонецЕсли;
	
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СУММА(ЕСТЬNULL(ВложенныйЗапрос.Сумма, 0)) КАК Сумма,
	|	СУММА(ЕСТЬNULL(ВложенныйЗапрос.СуммаУпр, 0)) КАК СуммаУпр,
	|	СУММА(ЕСТЬNULL(ВложенныйЗапрос.Количество, 0)) КАК Количество,
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ВложенныйЗапрос.СтатусПартии КАК СтатусПартии,
	|	ВложенныйЗапрос.Партия КАК Партия,
	|	ВложенныйЗапрос.ЗаказНаряд КАК ЗаказНаряд,
	|	ВложенныйЗапрос.Цех КАК Цех,
	|	ВременнаяТаблица.ПериодСтроки КАК ПериодСтроки,
	|	ВременнаяТаблица.ПериодКолонки КАК ПериодКолонки
	|ИЗ
	|	ВременнаяТаблица КАК ВременнаяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ОбъединенныйЗапрос.Период КАК Период,
	|			ОбъединенныйЗапрос.Сумма КАК Сумма,
	|			ОбъединенныйЗапрос.СуммаУпр КАК СуммаУпр,
	|			ОбъединенныйЗапрос.Количество КАК Количество,
	|			ОбъединенныйЗапрос.Номенклатура КАК Номенклатура,
	|			ОбъединенныйЗапрос.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|			ОбъединенныйЗапрос.СтатусПартии КАК СтатусПартии,
	|			ОбъединенныйЗапрос.Партия КАК Партия,
	|			ОбъединенныйЗапрос.ЗаказНаряд КАК ЗаказНаряд,
	|			ОбъединенныйЗапрос.Цех КАК Цех
	|		ИЗ
	|			(ВЫБРАТЬ
	|				&ДатаНач КАК Период,
	|				ТоварыВПроизводствеОстатки.СуммаОстаток КАК Сумма,
	|				ТоварыВПроизводствеОстатки.СуммаУпрОстаток КАК СуммаУпр,
	|				ТоварыВПроизводствеОстатки.КоличествоОстаток КАК Количество,
	|				ТоварыВПроизводствеОстатки.Номенклатура КАК Номенклатура,
	|				ТоварыВПроизводствеОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|				ТоварыВПроизводствеОстатки.СтатусПартии КАК СтатусПартии,
	|				ТоварыВПроизводствеОстатки.Партия КАК Партия,
	|				ТоварыВПроизводствеОстатки.ЗаказНаряд КАК ЗаказНаряд,
	|				ТоварыВПроизводствеОстатки.Цех КАК Цех
	|			ИЗ
	|				РегистрНакопления.ТоварыВПроизводстве.Остатки(&ДатаНач, "+ТекстОтбора+") КАК ТоварыВПроизводствеОстатки
	|			
	|			ОБЪЕДИНИТЬ ВСЕ
	|			
	|			ВЫБРАТЬ
	|				ТоварыВПроизводстве.Период,
	|				ВЫБОР
	|					КОГДА ТоварыВПроизводстве.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|						ТОГДА ТоварыВПроизводстве.Сумма
	|					ИНАЧЕ -ТоварыВПроизводстве.Сумма
	|				КОНЕЦ,
	|				ВЫБОР
	|					КОГДА ТоварыВПроизводстве.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|						ТОГДА ТоварыВПроизводстве.СуммаУпр
	|					ИНАЧЕ -ТоварыВПроизводстве.СуммаУпр
	|				КОНЕЦ,
	|				ВЫБОР
	|					КОГДА ТоварыВПроизводстве.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|						ТОГДА ТоварыВПроизводстве.Количество
	|					ИНАЧЕ -ТоварыВПроизводстве.Количество
	|				КОНЕЦ,
	|				ТоварыВПроизводстве.Номенклатура,
	|				ТоварыВПроизводстве.ХарактеристикаНоменклатуры,
	|				ТоварыВПроизводстве.СтатусПартии,
	|				ТоварыВПроизводстве.Партия,
	|				ТоварыВПроизводстве.ЗаказНаряд,
	|				ТоварыВПроизводстве.Цех
	|			ИЗ
	|				РегистрНакопления.ТоварыВПроизводстве КАК ТоварыВПроизводстве
	|			ГДЕ
	|				ТоварыВПроизводстве.Период МЕЖДУ &ДатаНач И &ДатаКон "+ТекстОтбораДвижений+") КАК ОбъединенныйЗапрос
	|) КАК ВложенныйЗапрос
	|		ПО ВременнаяТаблица.ПериодНижнийПредел <= ВложенныйЗапрос.Период
	|			И ВременнаяТаблица.ПериодВерхнийПредел > ВложенныйЗапрос.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	ВременнаяТаблица.ПериодСтроки,
	|	ВременнаяТаблица.ПериодКолонки,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.ХарактеристикаНоменклатуры,
	|	ВложенныйЗапрос.СтатусПартии ,
	|	ВложенныйЗапрос.Партия,
	|	ВложенныйЗапрос.ЗаказНаряд,
	|	ВложенныйЗапрос.Цех
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВременнаяТаблица.ПериодСтроки,
	|	ВременнаяТаблица.ПериодКолонки";
	Запрос.Текст = ТекстЗапроса;
	Запрос.МенеджерВременныхТаблиц = ВременныйМенеджер;
	Выборка = Запрос.Выполнить().Выгрузить();
	ВременныйМенеджер.Закрыть();
	
	КоличествоСтрок = Выборка.Количество()-1;
	Если КоличествоСтрок > 0 Тогда
		ПериодСтрокиПредыдущей  = Выборка[0].ПериодСтроки;
		ПериодКолонкиПредыдущей = Выборка[0].ПериодКолонки;
		Для Счетчик=1 По КоличествоСтрок Цикл
			Если ПериодКолонкиПредыдущей <> Выборка[Счетчик].ПериодКолонки Тогда
				НайденныеСтроки = Выборка.НайтиСтроки(Новый Структура("ПериодКолонки,ПериодСтроки", ПериодКолонкиПредыдущей, ПериодСтрокиПредыдущей));
				Сумма = 0;
				СуммаУпр = 0;
				Количество = 0;
				Для Каждого ТекущаяСтрока Из НайденныеСтроки Цикл
					Сумма      = Сумма + ТекущаяСтрока.Сумма;
					СуммаУпр   = СуммаУпр + ТекущаяСтрока.СуммаУпр;
					Количество = Количество + ТекущаяСтрока.Количество;
				КонецЦикла;
				Выборка[Счетчик].Сумма 		= Выборка[Счетчик].Сумма+Сумма;
				Выборка[Счетчик].СуммаУпр 	= Выборка[Счетчик].СуммаУпр+СуммаУпр;
				Выборка[Счетчик].Количество = Выборка[Счетчик].Количество+Количество;
				ПериодКолонкиПредыдущей = Выборка[Счетчик].ПериодКолонки;
				ПериодСтрокиПредыдущей  = Выборка[Счетчик].ПериодСтроки;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаОстатков", Выборка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблицаОстатков.Сумма КАК Сумма,
	               |	ТаблицаОстатков.СуммаУпр КАК СуммаУпр,
	               |	ТаблицаОстатков.Количество КАК Количество,
	               |	ТаблицаОстатков.ПериодСтроки КАК ПериодСтроки,
	               |	ТаблицаОстатков.ПериодКолонки КАК ПериодКолонки,
	               |	ТаблицаОстатков.Номенклатура КАК Номенклатура,
	               |	ТаблицаОстатков.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	               |	ТаблицаОстатков.СтатусПартии КАК СтатусПартии,
	               |	ТаблицаОстатков.Партия КАК Партия,
	               |	ТаблицаОстатков.ЗаказНаряд КАК ЗаказНаряд,
	               |	ТаблицаОстатков.Цех КАК Цех
	               |ПОМЕСТИТЬ ТаблицаОстатков
	               |ИЗ
	               |	&ТаблицаОстатков КАК ТаблицаОстатков
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТаблицаОстатков.Сумма,
	               |	ТаблицаОстатков.СуммаУпр,
	               |	ТаблицаОстатков.Количество,
	               |	ТаблицаОстатков.ПериодСтроки,
	               |	ТаблицаОстатков.ПериодКолонки,
	               |	ТаблицаОстатков.Номенклатура,
	               |	ТаблицаОстатков.ХарактеристикаНоменклатуры,
	               |	ТаблицаОстатков.СтатусПартии,
	               |	ТаблицаОстатков.Партия,
	               |	ТаблицаОстатков.ЗаказНаряд,
	               |	ТаблицаОстатков.Цех
	               |ИЗ
	               |	ТаблицаОстатков КАК ТаблицаОстатков";
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТаблицаОстатков", Запрос.Выполнить());
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		КопияСхемы,
		КомпоновщикНастроек.ПолучитьНастройки(),
		ДанныеРасшифровки
	);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.НачатьВывод();
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
	ПроцессорВывода.ЗакончитьВывод();
	
КонецПроцедуры // ПриКомпоновкеРезультата()

#КонецОбласти

#КонецЕсли