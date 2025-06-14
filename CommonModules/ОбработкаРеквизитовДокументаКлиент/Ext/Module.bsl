﻿// Общий модуль "Обработка событий документа (клиент)"


#Область ПрограммныйИнтерфейс

// Формирует коллекцию вопросов для пересчета цен.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой возникло событие.
//  ПараметрыДействия - Структура - Набор параметров, используемых при выполнении операции.
//  КоллекцияОпераций - Структура - (необязательное) Список последовательных операций.
//  ОбработчикСобытия - ОписаниеОповещения - (необязательное) Описание процедуры обработки действия.
//  Объект - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//
Процедура ПолучитьРазрешенияДляПересчета(Форма,
		ПараметрыДействия,
		КоллекцияОпераций = Неопределено,
		ОбработчикСобытия = Неопределено,
		Объект = Неопределено) Экспорт
	
	ПолучитьОсновнойОбъектФормы(Форма, Объект);
	
	// Получаем статус заполнения объекта из параметров действия.
	ОбъектЗаполнен = ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "ОбъектЗаполнен", Истина);
	
	// Получаем признаки необходимости произвести пересчет.
	ВозможенПересчетСуммы = ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "ПересчетСуммы", Истина);
	ТребуетсяИзменитьКурс = ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "ТребуетсяИзменитьКурс", Ложь);
	ТребуетсяУстановкаЦен = ОбъектЗаполнен
							И ВозможенПересчетСуммы 
							И ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "ТребуетсяУстановкаЦен", Ложь);
	ТребуетсяПересчетЦен  = ОбъектЗаполнен
							И ВозможенПересчетСуммы
							И ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "ТребуетсяПересчетЦен", Ложь);
	ТребуетсяЗаполнитьНаОсновании = ПолучитьЗначениеПараметраСтруктуры(
		ПараметрыДействия, "ТребуетсяЗаполнитьНаОсновании", Ложь
	);
	
	ТребуетсяПересчетКоличестваРабочихДней = ОбъектЗаполнен
		И ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "ТребуетсяПересчетКоличестваРабочихДней", Ложь);
	
	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.РабочийЛист") Тогда
		
		Если Объект.Опции.Количество() = 0 Тогда
			
			ТребуетсяУстановкаЦен = Ложь;
			
			Если НЕ ПараметрыДействия = Неопределено
				И ПараметрыДействия.Количество() = 1 Тогда
				
				ПараметрыДействия = Неопределено;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Инициализируем коллекцию вопросов/
	Если КоллекцияОпераций = Неопределено Тогда
		КоллекцияОпераций = Новый Структура();
	КонецЕсли;
	
	// Формируем комплект параметров, который будет передаваться между формами.
	ПараметрыВопросов = Новый Структура();
	
	// Инициализируем обработчик результата всех опросов
	Если ОбработчикСобытия = Неопределено Тогда
		ОбработчикСобытия = Новый ОписаниеОповещения(
			"Подключаемый_ОбработкаРезультатаОповещения",
			Форма,
			"РазрешенияДляПересчета"
		);
	КонецЕсли;
	
	// Набиваем коллекцию параметров значениями
	ПараметрыВопросов.Вставить("ПараметрыДействия", ПараметрыДействия);
	ПараметрыВопросов.Вставить("ТребуетсяПересчет", Ложь);
	ПараметрыВопросов.Вставить("ОбработчикСобытия", ОбработчикСобытия);
	
	// Добавляем вопрос перезаполнение документа по основанию.
	Если ТребуетсяЗаполнитьНаОсновании Тогда
		ТребуетсяЗаполнитьНаОсновании = Новый ОписаниеОповещения(
			"ОбработкаРезультатаОтветаНаВопросТребуетсяЗаполнитьНаОсновании",
			ОбработкаРеквизитовДокументаКлиент,
			ПараметрыВопросов
		);
		ПоследовательныеОперацииКлиентСервер.ДобавитьВопросДаНет(
			КоллекцияОпераций,
			"ТребуетсяЗаполнитьНаОсновании",
			СтрШаблон(НСтр("ru = 'Был изменен документ основание. %1Выполнить перезаполнение?'"), Символы.ПС),
			, ,
			ТребуетсяЗаполнитьНаОсновании
		);
	КонецЕсли;
	
	// Добавляем вопрос о перезаполнении цен.
	Если ТребуетсяИзменитьКурс Тогда
		ДобавитьВопросОбИзмененииКурса(Форма, ПараметрыДействия, КоллекцияОпераций, Объект);
	КонецЕсли;
	
	// Добавляем вопрос пересчета суммовых показателей
	СтруктураПересчетЦен = Новый Структура();
	Если ТребуетсяПересчетЦен Тогда
		ПоследовательныеОперацииКлиентСервер.ДобавитьВопросДаНет(
			СтруктураПересчетЦен,
			"ТребуетсяПересчетЦен",
			НСтр("ru='Были изменены данные, влияющие на суммовые показатели документа.'") + Символы.ПС
				+ НСтр("ru = 'Выполнить пересчет?'")
		);
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "РазрешитьРедактированиеЦенИСумм") И
			НЕ Форма.РазрешитьРедактированиеЦенИСумм Тогда
				СтруктураПересчетЦен.ТребуетсяПересчетЦен.Результат = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТребуетсяПересчетКоличестваРабочихДней Тогда
				
		ПоследовательныеОперацииКлиентСервер.ДобавитьВопросДаНет(
			СтруктураПересчетЦен,
			"ТребуетсяПересчетКоличестваРабочихДней",
			НСтр("ru='Были изменены данные, влияющие на суммовые показатели документа.'") + Символы.ПС
				+ НСтр("ru = 'Выполнить пересчет?'")
		);
	
	КонецЕсли;

	// Добавляем вопрос о перезаполнении цен
	СтруктураУстановкаЦен = Новый Структура();
	Если ТребуетсяУстановкаЦен Тогда
		ПараметрыВопросовКопия = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ПараметрыВопросов);
		КоллекцияОперацийКопия = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(КоллекцияОпераций);
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(КоллекцияОперацийКопия, СтруктураПересчетЦен);
		ПараметрыВопросовКопия.Вставить("КоллекцияОпераций", КоллекцияОперацийКопия);
		ОбработчикТребуетсяУстановкаЦен = Новый ОписаниеОповещения(
			"ОбработкаРезультатаОтветаНаВопросТребуетсяУстановкаЦен",
			ОбработкаРеквизитовДокументаКлиент,
			ПараметрыВопросовКопия
		);
		ПоследовательныеОперацииКлиентСервер.ДобавитьВопросДаНет(
			СтруктураУстановкаЦен,
			"ТребуетсяУстановкаЦен",
			СтрШаблон(НСтр("ru = 'Были изменены данные, влияющие на цены номенклатуры.%1Перезаполнить цены?'"), Символы.ПС),
			, ,
			ОбработчикТребуетсяУстановкаЦен
		);
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "РазрешитьРедактированиеЦенИСумм") И
			НЕ Форма.РазрешитьРедактированиеЦенИСумм Тогда
				СтруктураУстановкаЦен.ТребуетсяУстановкаЦен.Результат = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(КоллекцияОпераций, СтруктураУстановкаЦен);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(КоллекцияОпераций, СтруктураПересчетЦен);
	
	// Производим финальную проверку целесообразности дальнейших действий
	Если КоллекцияОпераций.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	// Набиваем коллекцию параметров значениями
	ПараметрыВопросов.Вставить("КоллекцияОпераций", КоллекцияОпераций);
	
	// Вызываем служебную процедуру для организации последовательного опроса пользователя.
	ПоследовательныеОперацииКлиент.ВыполнитьПоследовательно(ПараметрыВопросов);
	
КонецПроцедуры // ПолучитьРазрешенияДляПересчета()

// Обработка получения разрешений для пересчета.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой возникло событие.
//  ПараметрыВопросов - Структура - Результат выполнения операции в подчиненной форме.
//
// Возвращаемое значение:
//  Булево - Истина, если требоется пересчет, Ложь - в противном случае.
//
Функция ОбработкаПолученияРазрешенийДляПересчета(Форма, ПараметрыВопросов) Экспорт
	
	// Получим исходные параметры действия
	ПараметрыДействия = ПараметрыВопросов.ПараметрыДействия;
	
	// Произведем перемещение всех накопленных ответов в коллекцию параметров действия
	Для Каждого Операция Из ПараметрыВопросов.КоллекцияОпераций Цикл
		ПараметрыДействия[Операция.Ключ]    = Операция.Значение;
		ПараметрыВопросов.ТребуетсяПересчет = ПараметрыВопросов.ТребуетсяПересчет ИЛИ Операция.Значение;
	КонецЦикла;
	
	// По ответам пользователя уточним значения признаков необходимости пересчета объекта.
	Если ПараметрыВопросов.КоллекцияОпераций.Свойство("ТребуетсяЗаполнитьНаОсновании") Тогда
		ПараметрыВопросов.ТребуетсяПересчет = ПараметрыВопросов.ТребуетсяПересчет
			ИЛИ ПараметрыДействия.ТребуетсяЗаполнитьНаОсновании
			ИЛИ ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "ТребуетсяПересчетЦен", Ложь)
			ИЛИ ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "ТребуетсяИзменитьКурс", Ложь)
			ИЛИ ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "ТребуетсяУстановкаЦен", Ложь);
	КонецЕсли;
	
	Если ПараметрыВопросов.КоллекцияОпераций.Свойство("ТребуетсяИзменитьКурс") Тогда
		ПараметрыВопросов.ТребуетсяПересчет = ПараметрыВопросов.ТребуетсяПересчет
			ИЛИ ПараметрыДействия.ТребуетсяИзменитьКурс;
	КонецЕсли;
	Если ПараметрыВопросов.КоллекцияОпераций.Свойство("ТребуетсяУстановкаЦен") Тогда
		ПараметрыВопросов.ТребуетсяПересчет = ПараметрыВопросов.ТребуетсяПересчет
			ИЛИ ПараметрыДействия.ТребуетсяУстановкаЦен;
	КонецЕсли;
	Если ПараметрыВопросов.КоллекцияОпераций.Свойство("ТребуетсяПересчетЦен") Тогда
		ПараметрыВопросов.ТребуетсяПересчет = ПараметрыВопросов.ТребуетсяПересчет ИЛИ ПараметрыДействия.ТребуетсяПересчетЦен;
	КонецЕсли;
	
	// Если пересчет объекта не требуется, прекращаем всю цепочку обработки события
	Если НЕ ПараметрыВопросов.ТребуетсяПересчет Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Восстанавливаем параметры исходного действия. Параметры опроса более не нужны
	ПараметрыВопросов = ПараметрыДействия;
	
	// Возвращаем признак того что действие не обработано и его следует обработать в контексте сервера.
	Возврат Истина;
	
КонецФункции // ОбработкаПолученияРазрешенийДляПересчета()

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Служебная процедура. Используется для перехвата ответа пользователя на вопрос об установке новых цен.
//
// Параметры:
//  КодОтвета         - КодВозвратаДиалога - Ответ, который дал пользователь на очередной вопрос
//  ПараметрыВопросов - Структура          - Коллекция содержащая набор вопросов и прочие параметры обработки.
//
Процедура ОбработкаРезультатаОтветаНаВопросТребуетсяУстановкаЦен(КодОтветаДа, ПараметрыВопросов) Экспорт
	
	// В случае если пользователь хочет полностью переустановить цены на все позиции, пересчет сумм не требуется.
	Если КодОтветаДа И ПараметрыВопросов.КоллекцияОпераций.Свойство("ТребуетсяПересчетЦен") Тогда
		ПараметрыВопросов.КоллекцияОпераций["ТребуетсяПересчетЦен"].Результат = Ложь;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаРезультатаОтветаНаВопросТребуетсяУстановкаЦен()

// Служебная процедура. Используется для перехвата ответа пользователя на вопрос об установке новых цен.
//
// Параметры:
//  КодОтвета         - КодВозвратаДиалога - Ответ, который дал пользователь на очередной вопрос
//  ПараметрыВопросов - Структура          - Коллекция содержащая набор вопросов и прочие параметры обработки.
//
Процедура ОбработкаРезультатаОтветаНаВопросТребуетсяЗаполнитьНаОсновании(КодОтветаДа, ПараметрыВопросов) Экспорт
	
	// В случае если пользователь хочет полностью перезаполнить документ, то другие изменения будут не актуальны.
	Если КодОтветаДа И ПараметрыВопросов.КоллекцияОпераций.Свойство("ТребуетсяЗаполнитьНаОсновании") Тогда
		Если ПараметрыВопросов.КоллекцияОпераций.Свойство("ТребуетсяИзменитьКурс") Тогда
			ПараметрыВопросов.КоллекцияОпераций.ТребуетсяИзменитьКурс.Результат = Ложь;
		КонецЕсли;
		Если ПараметрыВопросов.КоллекцияОпераций.Свойство("ТребуетсяПересчетЦен") Тогда
			ПараметрыВопросов.КоллекцияОпераций.ТребуетсяПересчетЦен.Результат = Ложь;
		КонецЕсли;
		Если ПараметрыВопросов.КоллекцияОпераций.Свойство("ТребуетсяУстановкаЦен") Тогда
			ПараметрыВопросов.КоллекцияОпераций.ТребуетсяУстановкаЦен.Результат = Ложь;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаРезультатаОтветаНаВопросТребуетсяЗаполнитьНаОсновании()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьВопросОбИзмененииКурса(Форма, ПараметрыДействия, КоллекцияОпераций, Объект)
	
	// Получим новые значения курсов валют.
	КурсВалютыДокумента = ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "НовыйКурс",               0);
	КурсУправленческий  = ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "НовыйКурсУпр",            0);
	КурсВзаиморасчетов  = ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "НовыйКурсВзаиморасчетов", 0);
	
	ТекстВопроса = "";
	ТекстОбъекта = НСтр("ru='Изменить курс'");
	
	Если КурсВалютыДокумента > 0 Тогда
		ТекстВопроса = ТекстВопроса
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Валюта документа <%1> на дату %2 имеет курс %3, отличный от курса в документе %4.'"),
				Объект.ВалютаДокумента, Формат(Объект.Дата, "ДЛФ=D"),
				Формат(КурсВалютыДокумента, "ЧЦ=10; ЧДЦ=4"),
				Формат(Объект.КурсДокумента, "ЧЦ=10; ЧДЦ=4")
			)
			+ Символы.ПС;
		ТекстОбъекта = ТекстОбъекта + ?(ПустаяСтрока(ТекстОбъекта), "", ",") + " "+ НСтр("ru='документа'");
	КонецЕсли;
	Если КурсУправленческий > 0 Тогда
		ТекстВопроса = ТекстВопроса
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Курс валюты управленческого учета на дату %1 имеет курс %2, отличный от курса в документе %3.'"),
				Формат(Объект.Дата, "ДЛФ=D"),
				Формат(КурсУправленческий, "ЧЦ=10; ЧДЦ=4"),
				Формат(Объект.КурсВалютыУпр, "ЧЦ=10; ЧДЦ=4")
			)
			+ Символы.ПС;
		ТекстОбъекта = ТекстОбъекта
			+ ?(ПустаяСтрока(ТекстОбъекта), "", ",")
			+ " "
			+ НСтр("ru='валюты управленческого учета'");
	КонецЕсли;
	Если КурсВзаиморасчетов > 0 Тогда
		ТекстВопроса = ТекстВопроса
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Курс валюты взаиморасчетов на дату %1 имеет курс %2, отличный от курса в документе %3.'"),
				Формат(Объект.Дата, "ДЛФ=D"),
				Формат(КурсВзаиморасчетов, "ЧЦ=10; ЧДЦ=4"),
				Формат(Объект.КурсВалютыВзаиморасчетов, "ЧЦ=10; ЧДЦ=4")
			)
			+ Символы.ПС;
		ТекстОбъекта = ТекстОбъекта + ?(ПустаяСтрока(ТекстОбъекта), "", ",") + " " + НСтр("ru='валюты взаиморасчетов'");
	КонецЕсли;
	
	// Производим добавление вопроса в очередь
	Если НЕ ПустаяСтрока(ТекстВопроса) Тогда
		ПоследовательныеОперацииКлиентСервер.ДобавитьВопросДаНет(
			КоллекцияОпераций,
			"ТребуетсяИзменитьКурс",
			ТекстВопроса + ТекстОбъекта + "?"
		);		
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "РазрешитьРедактированиеЦенИСумм") И
			НЕ Форма.РазрешитьРедактированиеЦенИСумм Тогда
			КоллекцияОпераций.ТребуетсяИзменитьКурс.Результат = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти