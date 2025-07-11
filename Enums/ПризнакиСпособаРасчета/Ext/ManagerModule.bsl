﻿// ++Рарус
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает признак способа расчета.
//
// Параметры:
//  Ссылка					- ДокументСсылка								- Ссылка на документ, для которого выполняется действие.
//  ТаблицаТоваров			- ДокументТабличнаяЧасть						- Таблица товаров документа.
//  ПризнакСпособаРасчета	- Перечисления.ПризнакиСпособаРасчета, Строка	- Способ расчета.
//  ТекстСообщения			- Строка	
//
// Возвращаемое значение:
//  Перечисления.ПризнакиСпособаРасчета
//
Функция ПолучитьПризнакСпособаРасчета(Ссылка, ТаблицаТоваров, ПризнакСпособаРасчета = "Передача", ТекстСообщения = "") Экспорт
	
	ТипСпособаРасчетаККТ = ?(ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПередачаСПолнойОплатой ИЛИ
		ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПередачаСЧастичнойОплатой ИЛИ
		ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПередачаБезОплаты, "Передача", 
		?(ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ОплатаКредита, "Постоплата", "Предоплата"));  
	
	ЕстьОплаты = ЕстьРеквизит(Ссылка,, "Оплаты");
	СуммаОплат = ?(Ссылка.СуммаДокумента<0, -Ссылка.СуммаДокумента, Ссылка.СуммаДокумента);
	
	Если ЕстьОплаты И НЕ Ссылка.Оплаты.Количество()=0 Тогда
		СуммаОплатБезРассрочки = 0;
		Для Каждого СтрокаОплат Из Ссылка.Оплаты Цикл
			Если СтрокаОплат.ТипОплаты <> Перечисления.ТипыОплатыККТ.Постоплата Тогда
				СуммаОплатБезРассрочки = СуммаОплатБезРассрочки + (СтрокаОплат.Сумма - СтрокаОплат.Сдача);
			КонецЕсли;
		КонецЦикла;
	Иначе
		СуммаОплатБезРассрочки = СуммаОплат;
	КонецЕсли;
	
	ЭтоАванс = Ложь;
	
	Если ТаблицаТоваров.Количество() = 0 Тогда
		ЭтоАванс = Истина;
		СуммаТовары = 0;
	Иначе
		СтруктураПоиска = Новый Структура("Номенклатура", Справочники.Номенклатура.Предоплата);
		СуммаТовары = ТаблицаТоваров.Итог("СуммаВсего");
		
		Если СуммаТовары = 0
			ИЛИ ТаблицаТоваров.НайтиСтроки(СтруктураПоиска).Количество() <> 0
			ИЛИ (ТипЗнч(Ссылка.ДокументОснование) = Тип("ДокументСсылка.СчетНаОплатуЗаАвтомобили")
			И Ссылка.ДокументОснование.ХозОперация = Справочники.ХозОперации.СчетНаПредоплатуЗаАвтомобили) Тогда
				ЭтоАванс = Истина;
		КонецЕсли;

	КонецЕсли;
	
	Если ТипСпособаРасчетаККТ = "Передача" И НЕ ЭтоАванс Тогда
		Если СуммаОплатБезРассрочки = 0 Тогда
			ТекстСообщения = НСтр("ru='Для типа оплаты ""Постоплата"" способ расчета должен быть ""Передача без оплаты"".'");
			Возврат Перечисления.ПризнакиСпособаРасчета.ПередачаБезОплаты;
		ИначеЕсли СуммаОплатБезРассрочки < СуммаТовары Тогда
			ТекстСообщения = НСтр("ru='Сумма оплат меньше суммы товаров, способ расчета должен быть ""Передача с частичной оплатой"".'");	
			Возврат Перечисления.ПризнакиСпособаРасчета.ПередачаСЧастичнойОплатой;
		ИначеЕсли СуммаОплатБезРассрочки >= СуммаТовары Тогда
			
			// Полная оплата, в том числе с учетом аванса (предварительной оплаты) в момент передачи предмета расчета
			ТекстСообщения = НСтр("ru='Сумма оплат равна сумме товаров, способ расчета должен быть ""Передача с полной оплатой"".'");	
			Возврат Перечисления.ПризнакиСпособаРасчета.ПередачаСПолнойОплатой;
			
		КонецЕсли;
	ИначеЕсли ТипСпособаРасчетаККТ = "Предоплата" ИЛИ ЭтоАванс Тогда
		Если ЭтоАванс Тогда
			Если (ТипЗнч(Ссылка.ДокументОснование) = Тип("ДокументСсылка.СчетНаОплатуЗаАвтомобили")
				И Ссылка.ДокументОснование.ХозОперация = Справочники.ХозОперации.СчетНаПредоплатуЗаАвтомобили) Тогда
				ТекстСообщения = НСтр("ru='У документа основания Хоз.операция ""Счет на предоплату за автомобили"", способ расчета должен быть ""Аванс"".'")
			Иначе
				ТекстСообщения = НСтр("ru='Товарной части нет, либо в товарной части указана номенклатура ""Предоплата"", способ расчета должен быть ""Аванс"".'");
			КонецЕсли;
			Возврат Перечисления.ПризнакиСпособаРасчета.Аванс;
		ИначеЕсли СуммаОплат < СуммаТовары Тогда
			ТекстСообщения = НСтр("ru='Сумма оплат меньше суммы товаров, способ расчета должен быть ""Предоплата частичная"".'");	
			Возврат Перечисления.ПризнакиСпособаРасчета.ПредоплатаЧастичная;
		ИначеЕсли СуммаОплат >= СуммаТовары Тогда
			ТекстСообщения = НСтр("ru='Сумма оплат равна сумме товаров, способ расчета должен быть ""Предоплата полная"".'");	
			Возврат Перечисления.ПризнакиСпособаРасчета.ПредоплатаПолная;
		КонецЕсли;
	ИначеЕсли ТипСпособаРасчетаККТ = "Постоплата" Тогда
		Возврат Перечисления.ПризнакиСпособаРасчета.ОплатаКредита;
	Иначе
		Возврат Перечисления.ПризнакиСпособаРасчета.ПередачаСПолнойОплатой;
	КонецЕсли;
	
КонецФункции

// Процедура заполнения реквизита "Способ расчета" у документов оплаты.
//
Процедура ЗаполнитьПризнакСпособаРасчетаДокументов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПриходныйКассовыйОрдер.Ссылка КАК Ссылка,
	               |	ПриходныйКассовыйОрдер.СуммаДокумента КАК СуммаОплаты,
	               |	ПриходныйКассовыйОрдер.ДокументОснование КАК ДокументОснование,
	               |	ПриходныйКассовыйОрдер.КурсДокумента КАК КурсДокумента,
	               |	ПриходныйКассовыйОрдер.ВалютаДокумента КАК ВалютаДокумента,
	               |	ПриходныйКассовыйОрдер.УдалитьТипСпособаРасчетаККТ КАК УдалитьТипСпособаРасчетаККТ
	               |ИЗ
	               |	Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
	               |ГДЕ
	               |	ПриходныйКассовыйОрдер.ПризнакСпособаРасчета = ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПустаяСсылка)
	               |	И ПриходныйКассовыйОрдер.ДляПробитияНаФР
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	РасходныйКассовыйОрдер.Ссылка,
	               |	РасходныйКассовыйОрдер.СуммаДокумента,
	               |	РасходныйКассовыйОрдер.ДокументОснование,
	               |	РасходныйКассовыйОрдер.КурсДокумента,
	               |	РасходныйКассовыйОрдер.ВалютаДокумента,
	               |	РасходныйКассовыйОрдер.УдалитьТипСпособаРасчетаККТ
	               |ИЗ
	               |	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	               |ГДЕ
	               |	РасходныйКассовыйОрдер.ПризнакСпособаРасчета = ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПустаяСсылка)
	               |	И РасходныйКассовыйОрдер.ДляПробитияНаФР
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЧекНаОплату.Ссылка КАК Ссылка,
	               |	ЧекНаОплату.СуммаДокумента КАК СуммаДокумента,
	               |	ЧекНаОплату.УдалитьТипСпособаРасчетаККТ КАК УдалитьТипСпособаРасчетаККТ
	               |ПОМЕСТИТЬ ЧекиНаОплату
	               |ИЗ
	               |	Документ.ЧекНаОплату КАК ЧекНаОплату
	               |ГДЕ
	               |	ЧекНаОплату.ПризнакСпособаРасчета = ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПустаяСсылка)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЧекиНаОплату.Ссылка КАК Ссылка,
	               |	ЧекиНаОплату.СуммаДокумента КАК СуммаДокумента,
	               |	СУММА(ЧекНаОплатуТовары.СуммаВсего) КАК СуммаВсего,
	               |	ЧекиНаОплату.УдалитьТипСпособаРасчетаККТ КАК УдалитьТипСпособаРасчетаККТ
	               |ИЗ
	               |	ЧекиНаОплату КАК ЧекиНаОплату
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЧекНаОплату.Товары КАК ЧекНаОплатуТовары
	               |		ПО ЧекиНаОплату.Ссылка = ЧекНаОплатуТовары.Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ЧекиНаОплату.Ссылка,
	               |	ЧекиНаОплату.СуммаДокумента,
	               |	ЧекиНаОплату.УдалитьТипСпособаРасчетаККТ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Выписка.Ссылка КАК Ссылка,
	               |	Выписка.СуммаДокумента КАК СуммаДокумента,
	               |	Выписка.КурсДокумента КАК КурсДокумента,
	               |	Выписка.УдалитьТипСпособаРасчетаККТ КАК УдалитьТипСпособаРасчетаККТ
	               |ИЗ
	               |	Документ.Выписка КАК Выписка
	               |ГДЕ
	               |	Выписка.ПризнакСпособаРасчета = ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПустаяСсылка)
	               |	И Выписка.ДляПробитияНаФР";
	
	
	ПакетЗапросов = Запрос.ВыполнитьПакет();
	
	// ПКО и РКО
	Выборка = ПакетЗапросов[0].Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ОбъектДокумента = Выборка.Ссылка.ПолучитьОбъект();
		
		Если ЗначениеЗаполнено(Выборка.УдалитьТипСпособаРасчетаККТ) Тогда
				ОбъектДокумента.ПризнакСпособаРасчета =
				?(Выборка.УдалитьТипСпособаРасчетаККТ = Перечисления.УдалитьТипыСпособаРасчетаККТ.Постоплата,
				Перечисления.ПризнакиСпособаРасчета.ОплатаКредита,
				Перечисления.ПризнакиСпособаРасчета.ПредоплатаПолная);
		Иначе
		
			ТабличнаяЧастьДокументаОснования = УправлениеДиалогомДокументаСервер.ПолучитьТабличнуюЧастьДокументаОснования(Выборка.Ссылка);
			
			Если НЕ ТабличнаяЧастьДокументаОснования=Неопределено И ТабличнаяЧастьДокументаОснования.Количество()>0 Тогда
				
				ОбъектДокумента.ПризнакСпособаРасчета =
					?(ОбъектДокумента.СуммаДокумента * Выборка.КурсДокумента = ТабличнаяЧастьДокументаОснования.Итог("СуммаВсего") * Выборка.КурсДокумента,
					Перечисления.ПризнакиСпособаРасчета.ПредоплатаПолная,
					Перечисления.ПризнакиСпособаРасчета.ПредоплатаЧастичная);
			Иначе
				ОбъектДокумента.ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПредоплатаПолная;
			КонецЕсли;
			
		КонецЕсли;
		
		ОбъектДокумента.ОбменДанными.Загрузка = Истина;
		
		Попытка
			ОбъектДокумента.Записать();
		Исключение
			ЗаписьЖурналаРегистрации(
				СтрШаблон(НСтр("ru = 'Не удалось записать документ %1 при заполнении способа расчета.'"), Строка(ОбъектДокумента.Ссылка)),
				УровеньЖурналаРегистрации.Ошибка,,,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	КонецЦикла;
	
	// Чек на оплату
	Выборка = ПакетЗапросов[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ОбъектДокумента = Выборка.Ссылка.ПолучитьОбъект();
		
		Если ЗначениеЗаполнено(Выборка.УдалитьТипСпособаРасчетаККТ) Тогда
			ОбъектДокумента.ПризнакСпособаРасчета =
			?(Выборка.УдалитьТипСпособаРасчетаККТ = Перечисления.УдалитьТипыСпособаРасчетаККТ.Постоплата,
			Перечисления.ПризнакиСпособаРасчета.ОплатаКредита, ?(ОбъектДокумента.СуммаДокумента = Выборка.СуммаВсего,
			Перечисления.ПризнакиСпособаРасчета.ПередачаСПолнойОплатой,
			Перечисления.ПризнакиСпособаРасчета.ПредоплатаПолная));
			
		Иначе
			
			ОбъектДокумента.ПризнакСпособаРасчета =
			?(ОбъектДокумента.СуммаДокумента = Выборка.СуммаВсего,
			Перечисления.ПризнакиСпособаРасчета.ПередачаСПолнойОплатой,
			Перечисления.ПризнакиСпособаРасчета.ПредоплатаПолная);
			
			Если ОбъектДокумента.ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПредоплатаПолная Тогда
				
				ТаблицаТоваров = ОбъектДокумента.Товары.Выгрузить();
				
				Документы.ЧекНаОплату.ПроизвестиРаспределениеСуммыОплаты(ОбъектДокумента.СуммаДокумента, ТаблицаТоваров);
				
				// Заполним суммы распределения
				Для Каждого ТекущаяСтрока Из ОбъектДокумента.Товары Цикл
					СтруктураОтбора = Новый Структура;
					СтруктураОтбора.Вставить("НомерСтроки",ТекущаяСтрока.НомерСтроки);
					СтрокаТаблицы = ТаблицаТоваров.НайтиСтроки(СтруктураОтбора);
					ТекущаяСтрока.СуммаОплаты = СтрокаТаблицы[0].СуммаОплаты;
				КонецЦикла;
				
			Иначе
				
				Для Каждого СтрокаТоваров Из ОбъектДокумента.Товары Цикл
					СтрокаТоваров.СуммаОплаты = СтрокаТоваров.СуммаВсего;
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;			
		ОбъектДокумента.ОбменДанными.Загрузка = Истина;
		
		Попытка
			ОбъектДокумента.Записать();
		Исключение
			ЗаписьЖурналаРегистрации(
			СтрШаблон(НСтр("ru = 'Не удалось записать документ %1 при заполнении способа расчета.'"), Строка(ОбъектДокумента.Ссылка)),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;

	КонецЦикла;
	
	// Выписка
	Выборка = ПакетЗапросов[3].Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ОбъектДокумента = Выборка.Ссылка.ПолучитьОбъект();
		
		Если ЗначениеЗаполнено(Выборка.УдалитьТипСпособаРасчетаККТ) Тогда
				ОбъектДокумента.ПризнакСпособаРасчета =
				?(Выборка.УдалитьТипСпособаРасчетаККТ = Перечисления.УдалитьТипыСпособаРасчетаККТ.Постоплата,
				Перечисления.ПризнакиСпособаРасчета.ОплатаКредита,
				Перечисления.ПризнакиСпособаРасчета.ПредоплатаПолная);
				
		Иначе
				
			// Подготовим данные для получение номенклатуры по сделке
			СтрукутраСделки = Новый Структура("ДокументОснование,ВалютаДокумента,КурсДокумента");
			ЗаполнитьЗначенияСвойств(СтрукутраСделки, ОбъектДокумента,, "ДокументОснование");
			
			ЭтоПредоплата = Ложь;
			Для Каждого ТекущаяСтрока Из ОбъектДокумента.Состав Цикл
				
				Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.Сделка) Тогда
					ЭтоПредоплата = Истина;
					Прервать;
				Иначе
					СтрукутраСделки.ДокументОснование = ТекущаяСтрока.Сделка;
					ТабличнаяЧастьДокументаОснования=УправлениеДиалогомДокументаСервер.ПолучитьТабличнуюЧастьДокументаОснования(СтрукутраСделки);
					Если ТабличнаяЧастьДокументаОснования=Неопределено ИЛИ ТабличнаяЧастьДокументаОснования.Количество()=0 Тогда
						ЭтоПредоплата = Истина;
						Прервать;
					ИначеЕсли ТабличнаяЧастьДокументаОснования.Итог("СуммаВсего") * Выборка.КурсДокумента <> ОбъектДокумента.СуммаДокумента Тогда
						ЭтоПредоплата = Истина;
						Прервать;
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла;
			
			ОбъектДокумента.ПризнакСпособаРасчета =
			?(НЕ ЭтоПредоплата,
			Перечисления.ПризнакиСпособаРасчета.ПредоплатаПолная,
			Перечисления.ПризнакиСпособаРасчета.ПредоплатаЧастичная);
			
		КонецЕсли;
		
		ОбъектДокумента.ОбменДанными.Загрузка = Истина;
		
		Попытка
			ОбъектДокумента.Записать();
		Исключение
			ЗаписьЖурналаРегистрации(
				СтрШаблон(НСтр("ru = 'Не удалось записать документ %1 при заполнении способа расчета.'"), Строка(ОбъектДокумента.Ссылка)),
				УровеньЖурналаРегистрации.Ошибка,,,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьПризнакСпособаРасчетаДокументов()

#КонецОбласти

#КонецЕсли

// --Рарус
