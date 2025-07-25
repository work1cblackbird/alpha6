﻿// Общий модуль "Префиксация объектов"
// Решено использовать свою подсистему формирования префиксации объектов поскольку текущий шаблон
// префиксации БСП не дает необходимый формат. Шаблон префикса БСП: [ОР][ИБ]-[Префикс]
// Здесь всегда должен быть префикс организации и/или префикс информационной базы, что нас не устраивает.

#Область ПрограммныйИнтерфейс

// Обработчик при установке нового кода
//
// Параметры:
//  Источник			 - СправочникОбъект	 - Объект, для которого устанавливается код.
//  СтандартнаяОбработка - Булево			 - Использование стандартной обработки.
//  Префикс				 - Строка			 - Получение префикса по шаблону.
//
Процедура ПриУстановкеНовогоКода(Источник, СтандартнаяОбработка, Префикс) Экспорт
	
	Шаблон  = ПолучитьШаблонПрефиксаОбъекта(Источник);
	Префикс = ПолучитьЗначениеПрефиксаПоШаблону(Шаблон, Источник);
	
КонецПроцедуры // ПриУстановкеНовогоКода()

// Обработчик при установке нового номера
//
// Параметры:
//  Источник			 - ДокументОбъект	 - Объект, для которого устанавливается номер.
//  СтандартнаяОбработка - Булево			 - Использование стандартной обработки.
//  Префикс				 - Строка			 - Получение префикса по шаблону.
//
Процедура ПриУстановкеНовогоНомера(Источник, СтандартнаяОбработка, Префикс) Экспорт
	
	Шаблон  = ПолучитьШаблонПрефиксаОбъекта(Источник);
	Префикс = ПолучитьЗначениеПрефиксаПоШаблону(Шаблон, Источник);
	
	Если Префикс = "" Тогда
		Префикс = "0";
	КонецЕсли;
	
КонецПроцедуры // ПриУстановкеНовогоНомера()

// Проверка префикса документа
//
// Параметры:
//  Источник		 - ДокументОбъект			 - Объект, для которого устанавливается номер.
//  Отказ			 - Булево					 - Признак отказа.
//  РежимЗаписи		 - РежимЗаписиДокумента		 - Режим записи документа.
//  РежимПроведения	 - РежимПроведенияДокумента	 - Режим проведения документа.
//
Процедура ПроверитьПрефиксДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	// проверим необходимость переопределения номера
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	ИначеЕсли НЕ ЗначениеЗаполнено(Источник.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	// Если номер был изменен вручную - проверка не требуется.
	Если Источник.Ссылка.Номер <> Источник.Номер И ЗначениеЗаполнено(Источник.Номер) Тогда
		Возврат;
	КонецЕсли;
	
	Если ИзменилисьПрефиксообразующиеРеквизиты(Источник) Тогда
		Источник.Номер = "";
	КонецЕсли;
	
КонецПроцедуры // ПроверитьПрефиксДокумента()

// Получает номер документа для вывода на печать. Из номера лидирующие нули и отбрасываются префикс организации,
// префикс информационной базы и пользовательские префиксы.
//
// Параметры:
//  НомерОбъекта                     - Строка - номер для форматирования;
//  УдалитьПрефиксИнформационнойБазы - Булево - признак удаления префикса информационной базы;
//  УдалитьПользовательскийПрефикс   - Булево - признак удаления пользовательских префиксов;
//  УдалитьНулиВНомере               - Булево - признак удаления лидирующих нулей;
// 
// Возвращаемое значение:
//  Строка - отформатированный номер
//
Функция ПолучитьНомерНаПечать(
		Знач НомерОбъекта,
		УдалитьПрефиксИнформационнойБазы = Ложь,
		УдалитьПользовательскийПрефикс = Ложь,
		УдалитьНулиВНомере = Истина) Экспорт
	
	// удаляем пользовательские префиксы из номера объекта
	Если УдалитьПользовательскийПрефикс Тогда
		
		НомерОбъекта = ПрефиксацияОбъектовКлиентСервер.УдалитьПользовательскиеПрефиксыИзНомераОбъекта(НомерОбъекта);
		
	КонецЕсли;
	
	// удаляем лидирующие нули из номера объекта
	Если УдалитьНулиВНомере Тогда
		
		НомерОбъекта = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(НомерОбъекта);
		
	КонецЕсли;
	
	// удаляем префикс организации и префикс информационной базы из номера объекта
	НомерОбъекта = ПрефиксацияОбъектовКлиентСервер.УдалитьПрефиксыИзНомераОбъекта(
		НомерОбъекта,
		Истина,
		УдалитьПрефиксИнформационнойБазы
	);
	Возврат НомерОбъекта;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьШаблонПрефиксаОбъекта(Источник)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ПрефиксацияОбъектов.Шаблон,
	|	ПрефиксацияОбъектов.ПоУмолчанию
	|ИЗ
	|	РегистрСведений.ПрефиксацияОбъектов КАК ПрефиксацияОбъектов
	|ГДЕ
	|	ПрефиксацияОбъектов.Объект = &Объект";
	Запрос.УстановитьПараметр("Объект", Источник.Ссылка.Метаданные().ПолноеИмя());
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить()[0].Шаблон;
	
КонецФункции

Функция ПолучитьЗначениеПрефиксаПоШаблону(Шаблон, Источник)
	
	УстановитьПривилегированныйРежим(Истина);
	ИсточникСправочник = НЕ (Метаданные.Справочники.Найти(Источник.Ссылка.Метаданные().Имя)=Неопределено);
	ЕстьРеквизитДата = НЕ (Метаданные.Документы.Найти(Источник.Ссылка.Метаданные().Имя)=Неопределено) ИЛИ ЕстьРеквизит(Источник.Ссылка,"Дата");
	
	Если СтрНайти(Шаблон, "[У]") <> 0 Тогда
		ЗначениеПрефикса = Константы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Получить();
		// Если в шаблоне указан узел, но узел не заполнен - добавим лидирующие нули, для корректного формирования номера.
		Если ЗначениеПрефикса = "" Тогда
			ЗначениеПрефикса = "00";
		КонецЕсли;
		Шаблон = СтрЗаменить(Шаблон,"[У]",Константы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Получить());
	КонецЕсли;
	
	Если СтрНайти(Шаблон, "[О]") <> 0 Тогда
		Если ЕстьРеквизит(Источник.Ссылка,"Организация") И НЕ ИсточникСправочник Тогда
			ЗначениеПрефикса = Источник.Организация.Префикс;
		Иначе
			ЗначениеПрефикса = ПараметрыСеанса.Организация.Префикс;
		КонецЕсли;
		// Если в шаблоне указана организация, но префикс не заполнен - добавим лидирующие нули,
		// для корректного формирования номера.
		Если ЗначениеПрефикса = "" Тогда
			ЗначениеПрефикса = "00";
		КонецЕсли;
		
		Шаблон = СтрЗаменить(Шаблон,"[О]",ЗначениеПрефикса);
	КонецЕсли;
	
	Если СтрНайти(Шаблон, "[П]") <> 0 Тогда
		Если ЕстьРеквизит(Источник.Ссылка,"ПодразделениеКомпании")И НЕ ИсточникСправочник Тогда
			ЗначениеПрефикса = Источник.ПодразделениеКомпании.Префикс;
		Иначе
			ЗначениеПрефикса = ПараметрыСеанса.ПодразделениеКомпании.Префикс;
		КонецЕсли;
		// Если в шаблоне указано подразделение, но префикс не заполнен - добавим лидирующие нули,
		// для корректного формирования номера.
		Если ЗначениеПрефикса = "" Тогда
			ЗначениеПрефикса = "000";
		КонецЕсли;
		
		Шаблон = СтрЗаменить(Шаблон,"[П]",ЗначениеПрефикса);
	КонецЕсли;
	
	Если СтрНайти(Шаблон, "[yy]") <> 0 Тогда
		Если ЕстьРеквизитДата И НЕ ИсточникСправочник Тогда
			ЗначениеПрефикса = Формат(Источник.Дата,"ДФ=yy");
		Иначе
			ЗначениеПрефикса = Формат(ТекущаяДатаСеанса(),"ДФ=yy");;
		КонецЕсли;
		Шаблон = СтрЗаменить(Шаблон,"[yy]",ЗначениеПрефикса);
	КонецЕсли;
	
	Если СтрНайти(Шаблон, "[yyyy]") <> 0 Тогда
		Если ЕстьРеквизитДата И НЕ ИсточникСправочник Тогда
			ЗначениеПрефикса = Формат(Источник.Дата,"ДФ=yyyy");
		Иначе
			ЗначениеПрефикса = Формат(ТекущаяДатаСеанса(),"ДФ=yyyy");;
		КонецЕсли;
		Шаблон = СтрЗаменить(Шаблон,"[yyyy]",ЗначениеПрефикса);
	КонецЕсли;
	
	Если СтрНайти(Шаблон, "[M]") <> 0 Тогда
		Если ЕстьРеквизитДата И НЕ ИсточникСправочник Тогда
			ЗначениеПрефикса = Формат(Источник.Дата,"ДФ=M");
		Иначе
			ЗначениеПрефикса = Формат(ТекущаяДатаСеанса(),"ДФ=M");;
		КонецЕсли;
		Шаблон = СтрЗаменить(Шаблон,"[M]",ЗначениеПрефикса);
	КонецЕсли;
	
	Если СтрНайти(Шаблон, "[MM]") <> 0 Тогда
		Если ЕстьРеквизитДата И НЕ ИсточникСправочник Тогда
			ЗначениеПрефикса = Формат(Источник.Дата,"ДФ=MM");
		Иначе
			ЗначениеПрефикса = Формат(ТекущаяДатаСеанса(),"ДФ=MM");;
		КонецЕсли;
		Шаблон = СтрЗаменить(Шаблон,"[MM]",ЗначениеПрефикса);
	КонецЕсли;
	
	Если СтрНайти(Шаблон, "[d]") <> 0 Тогда
		Если ЕстьРеквизитДата И НЕ ИсточникСправочник Тогда
			ЗначениеПрефикса = Формат(Источник.Дата,"ДФ=d");
		Иначе
			ЗначениеПрефикса = Формат(ТекущаяДатаСеанса(),"ДФ=d");;
		КонецЕсли;
		Шаблон = СтрЗаменить(Шаблон,"[d]",ЗначениеПрефикса);
	КонецЕсли;
	
	Если СтрНайти(Шаблон, "[dd]") <> 0 Тогда
		Если ЕстьРеквизитДата И НЕ ИсточникСправочник Тогда
			ЗначениеПрефикса = Формат(Источник.Дата,"ДФ=dd");
		Иначе
			ЗначениеПрефикса = Формат(ТекущаяДатаСеанса(),"ДФ=dd");;
		КонецЕсли;
		Шаблон = СтрЗаменить(Шаблон,"[dd]",ЗначениеПрефикса);
	КонецЕсли;
	
	Возврат Шаблон;
	
КонецФункции

// Определяет изменились ли реквизиты подразделение компании и организация, и влияют ли они на шаблон.
Функция ИзменилисьПрефиксообразующиеРеквизиты(Источник)
	
	ТребуетсяПереопределение = Ложь;
	ТекстВставки             = "";
	ЕстьОрганизация          = Ложь;
	ЕстьПодразделение        = Ложь;
	ЕстьДата                 = Ложь;
	
	Если ЕстьРеквизит(Источник.Ссылка, "Организация") Тогда
		ЕстьОрганизация = Истина;
		ТекстВставки = ТекстВставки + "Объект.Организация КАК ОрганизацияДоИзменения";
	КонецЕсли;
	
	Если ЕстьРеквизит(Источник.Ссылка, "ПодразделениеКомпании") Тогда
		ЕстьПодразделение = Истина;
		Если НЕ ПустаяСтрока(ТекстВставки) Тогда
			ТекстВставки = ТекстВставки + ", ";
		КонецЕсли;
		ТекстВставки = ТекстВставки + "Объект.ПодразделениеКомпании КАК ПодразделениеКомпанииДоИзменения";
	КонецЕсли;
	
	// добавили проверку на дату
	Если НЕ (Метаданные.Документы.Найти(Источник.Ссылка.Метаданные().Имя)=Неопределено) ИЛИ ЕстьРеквизит(Источник.Ссылка, "Дата") Тогда
		ЕстьДата = Истина;
		Если НЕ ПустаяСтрока(ТекстВставки) Тогда
			ТекстВставки = ТекстВставки + ", ";
		КонецЕсли;
		ТекстВставки = ТекстВставки + "Объект.Дата КАК ДатаДоИзменения";
	КонецЕсли;
	
	Если НЕ ЕстьПодразделение И НЕ ЕстьОрганизация И НЕ ЕстьДата Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ "
		+ТекстВставки
		+" ИЗ
		|	" + Источник.Ссылка.Метаданные().ПолноеИмя() + " КАК Объект
		|ГДЕ
		|	Объект.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Источник.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Шаблон = ПолучитьШаблонПрефиксаОбъекта(Источник);
	
	// проверки
	Если ЕстьОрганизация И (СтрНайти(Шаблон,"[О]") <> 0) Тогда
		ИзменилсяПрефикс = Выборка.ОрганизацияДоИзменения.Префикс <> Источник.Организация.Префикс;
		ТребуетсяПереопределение = ТребуетсяПереопределение ИЛИ ИзменилсяПрефикс;
	КонецЕсли;
	
	Если ЕстьПодразделение И (СтрНайти(Шаблон,"[П]") <> 0) Тогда
		ИзменилсяПрефикс = Выборка.ПодразделениеКомпанииДоИзменения.Префикс <> Источник.ПодразделениеКомпании.Префикс;
		ТребуетсяПереопределение = ТребуетсяПереопределение ИЛИ ИзменилсяПрефикс;
	КонецЕсли;
	
	Если ЕстьДата Тогда
		Если (СтрНайти(Шаблон,"[yy]") <> 0) Тогда
			ТребуетсяПереопределение = ТребуетсяПереопределение ИЛИ (Формат(Выборка.ДатаДоИзменения, "ДФ=гг")   <> Формат(Источник.Дата, "ДФ=гг"));
		КонецЕсли;
		Если (СтрНайти(Шаблон,"[yyyy]") <> 0) Тогда
			ТребуетсяПереопределение = ТребуетсяПереопределение ИЛИ (Формат(Выборка.ДатаДоИзменения, "ДФ=гггг") <> Формат(Источник.Дата, "ДФ=гггг"));
		КонецЕсли;
		Если (СтрНайти(Шаблон,"[M]") <> 0) Тогда
			ТребуетсяПереопределение = ТребуетсяПереопределение ИЛИ (Формат(Выборка.ДатаДоИзменения, "ДФ=М")    <> Формат(Источник.Дата, "ДФ=М"));
		КонецЕсли;
		Если (СтрНайти(Шаблон,"[MM]") <> 0) Тогда
			ТребуетсяПереопределение = ТребуетсяПереопределение ИЛИ (Формат(Выборка.ДатаДоИзменения, "ДФ=ММ")   <> Формат(Источник.Дата, "ДФ=ММ"));
		КонецЕсли;
		Если (СтрНайти(Шаблон,"[d]") <> 0) Тогда
			ТребуетсяПереопределение = ТребуетсяПереопределение ИЛИ (Формат(Выборка.ДатаДоИзменения, "ДФ=d")    <> Формат(Источник.Дата, "ДФ=d"));
		КонецЕсли;
		Если (СтрНайти(Шаблон,"[dd]") <> 0) Тогда
			ТребуетсяПереопределение = ТребуетсяПереопределение ИЛИ (Формат(Выборка.ДатаДоИзменения, "ДФ=dd")   <> Формат(Источник.Дата, "ДФ=dd"));
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТребуетсяПереопределение;
	
КонецФункции

#КонецОбласти