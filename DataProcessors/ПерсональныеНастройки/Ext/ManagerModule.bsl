﻿// Модуль менеджера обработки "ПерсональныеНастройки"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Заполняет реквизит "СтруктураОписаний" из макета "НастройкиПоУмолчанию".
// В дальнейшем эта структура может использоваться для вывода описаний в форме.
//
// Без параметров.
//
Функция ОписаниеПравИНастроекПоУмолчанию()
	СтруктураОписаний = Новый Структура;
	Макет=ПланыВидовХарактеристик.ПраваИНастройки.ПолучитьМакет("НастройкиПоУмолчанию");	
	Для Номер = 1 По 10000 Цикл	// Заведомо больше, чем есть в макете
		Код=СокрЛП(Макет.ПолучитьОбласть("R"+Строка(Номер)+"C3").ТекущаяОбласть.Текст);
		Описание=СокрЛП(Макет.ПолучитьОбласть("R"+Строка(Номер)+"C8").ТекущаяОбласть.Текст);
		Если Код="" Тогда Прервать;
		ИначеЕсли Описание="" Тогда Продолжить;
		КонецЕсли;
		СтруктураОписаний.Вставить("_"+Код,Описание);
	КонецЦикла;
	Возврат СтруктураОписаний;
КонецФункции

// Возвращает таблицу с учетом фильтров.
//
// Без параметров
//
// Тип возвращаемого значения: ТаблицаЗначений.
//
Функция ПолучитьТаблицуДанных(ИмяСправочника, МассивОбъектов)
	Запрос = Новый Запрос;
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	"+ИмяСправочника+".Ссылка КАК Объект
	|ИЗ
	|	Справочник."+ИмяСправочника+" КАК "+ИмяСправочника+"
	|ГДЕ" +	?(МассивОбъектов.Количество() > 0, " "+ИмяСправочника+".Ссылка В(&МассивОбъектов)", "");
	Если Прав(ТекстЗапроса, 1) = "И" Тогда
		ТекстЗапроса = Лев(ТекстЗапроса, СтрДлина(ТекстЗапроса) - 1);
	КонецЕсли;
	Если Прав(ТекстЗапроса, 3) = "ГДЕ" Тогда
		ТекстЗапроса = Лев(ТекстЗапроса, СтрДлина(ТекстЗапроса) - 3);
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса + " АВТОУПОРЯДОЧИВАНИЕ";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = ТекстЗапроса;
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

// Возвращает представление установленного фильтра строкой.
//
// Без параметров
//
// Возвращаемое значение
//	Стр - Строка.
//
//
Функция ПолучитьПредставлениеФильтра(ОтображатьПрава, ОтображатьНастройки,РежимПечатиПользователей, МассивДанных)
	Стр = "Отбор" + ": ";
	Стр = Стр + "Формировать" + ": ";
	Если ОтображатьПрава Тогда
		Стр = Стр + "Права" + "; ";
	КонецЕсли;
	Если ОтображатьНастройки Тогда
		Стр = Стр + "Настройки" + "; ";
	КонецЕсли;
	
	Если МассивДанных.Количество() > 0 Тогда
		Стр = Стр + ?(РежимПечатиПользователей ,"Пользователи:" + " ", НСтр("ru = 'Группы прав и настроек:'") + " ");
		Для Каждого Элемент Из МассивДанных Цикл
			Если ЗначениеЗаполнено(Элемент.ПользователиГруппы) Тогда
				Стр = Стр + ?(РежимПечатиПользователей ,Элемент.ПользователиГруппы.Наименование, Элемент.ПользователиГруппы.Наименование) + "; ";
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Стр;
КонецФункции

// Возвращает выборку прав и настроек с учетом установленных настроек.
//
// Параметры
//	Объект - СправочникСсылка
//
// Тип возвращаемого значения - РезультатЗапроса                            
//
Функция ПолучитьВыборкуПравИНастроек(ТекОбъект, ОтображатьПрава, ОтображатьНастройки)
	
	Если ТипЗнч(ТекОбъект) = Тип("СправочникСсылка.Пользователи") Тогда
		ПараметрПользователь = ТекОбъект;
		ГруппаПравИНастроекПользователя = Неопределено;
		ПользовательВходитВГруппуНастройки(ТекОбъект, ГруппаПравИНастроекПользователя);
		ПараметрГруппаПравИНастроек = ГруппаПравИНастроекПользователя;
		
	ИначеЕсли ТипЗнч(ТекОбъект) = Тип("СправочникСсылка.ГруппыПравИНастроек") Тогда
		ПараметрПользователь = Неопределено;
		ПараметрГруппаПравИНастроек = ТекОбъект;
	Иначе
		ПараметрГруппаПравИНастроек = Неопределено;
		ПараметрПользователь = Неопределено;
	КонецЕсли;
		
	УсловияНаНастройку = НЕ ОтображатьПрава = ОтображатьНастройки;
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	0 КАК ПустойИтог,
	|	ПланВидовХарактеристикПраваИНастройки.Код,
	|	ПланВидовХарактеристикПраваИНастройки.Наименование,
	|	ПланВидовХарактеристикПраваИНастройки.Ссылка,
	|	ПланВидовХарактеристикПраваИНастройки.Родитель,
	|	ПланВидовХарактеристикПраваИНастройки.ЭтоГруппа,
	|	ПланВидовХарактеристикПраваИНастройки.ТипЗначения,
	|	ПланВидовХарактеристикПраваИНастройки.ЭтоНастройка,
	|	ПланВидовХарактеристикПраваИНастройки.ЗначениеПоУмолчанию,
	|	РегистрСведенийПраваИНастройкиПользователь.Значение КАК ЗначениеПользователь,
	|	РегистрСведенийПраваИНастройкиГруппаПравИНастроек.Значение КАК ЗначениеГруппаПравИНастроек
	|ИЗ
	|	ПланВидовХарактеристик.ПраваИНастройки КАК ПланВидовХарактеристикПраваИНастройки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПраваИНастройки КАК РегистрСведенийПраваИНастройкиПользователь
	|		ПО ПланВидовХарактеристикПраваИНастройки.Ссылка = РегистрСведенийПраваИНастройкиПользователь.ПравоНастройка
	|			И (РегистрСведенийПраваИНастройкиПользователь.ПользовательПрофиль = &Пользователь)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПраваИНастройки КАК РегистрСведенийПраваИНастройкиГруппаПравИНастроек
	|		ПО ПланВидовХарактеристикПраваИНастройки.Ссылка = РегистрСведенийПраваИНастройкиГруппаПравИНастроек.ПравоНастройка
	|			И (РегистрСведенийПраваИНастройкиГруппаПравИНастроек.ПользовательПрофиль = &ГруппаПравИНастроек)
	|ГДЕ
	|	ПланВидовХарактеристикПраваИНастройки.ЭтоГруппа = ЛОЖЬ"
	+ ?(УсловияНаНастройку, " И ПланВидовХарактеристикПраваИНастройки.ЭтоНастройка = &ЭтоНастройка", "") + "
	|УПОРЯДОЧИТЬ ПО 
	|	ПланВидовХарактеристикПраваИНастройки.Код
	|ИТОГИ Среднее(ПустойИтог) ПО ПланВидовХарактеристикПраваИНастройки.Ссылка ТОЛЬКО ИЕРАРХИЯ
	|";
			
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Пользователь",ПараметрПользователь);
	Запрос.УстановитьПараметр("ГруппаПравИНастроек",ПараметрГруппаПравИНастроек);
	Запрос.УстановитьПараметр("ЭтоНастройка",ОтображатьНастройки);
	Возврат Запрос.Выполнить();
КонецФункции // ПолучитьВыборкуПравИНастроек()

// Возвращает значение права или настройки
//
// Параметры
//	Выборка - Выборка
//
Функция ПолучитьЗначениеИзВыборки(Выборка, РежимПечатиПользователь, ТекОбъект)
	Значение = NULL;
	Если РежимПечатиПользователь Тогда
		ГруппаПравИНастроекПользователя = Неопределено;
		Если Выборка.ЭтоНастройка Тогда 
			Значение = Выборка.ЗначениеПользователь;
			Если Значение = NULL Тогда
				ПользовательВходитВГруппуНастройки(ТекОбъект, ГруппаПравИНастроекПользователя);
				Если ЗначениеЗаполнено(ГруппаПравИНастроекПользователя) Тогда 
					Значение = Выборка.ЗначениеГруппаПравИНастроек;
				КонецЕсли;	
			КонецЕсли;
		Иначе
			ПользовательВходитВГруппуНастройки(ТекОбъект, ГруппаПравИНастроекПользователя);
			Если ЗначениеЗаполнено(ГруппаПравИНастроекПользователя) Тогда 
				Значение = Выборка.ЗначениеГруппаПравИНастроек;
			Иначе
				Значение = Выборка.ЗначениеПользователь;
			КонецЕсли;	
		КонецЕсли;
	Иначе	
		Значение = Выборка.ЗначениеГруппаПравИНастроек;
	КонецЕсли;
	
	Если Значение = NULL Тогда
		Значение = Выборка.ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Значение) Тогда
		Значение = Выборка.ТипЗначения.ПривестиЗначение(Неопределено);
	КонецЕсли;
		
    Возврат Значение;
КонецФункции // ПолучитьЗначениеИзВыборки()

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Макет") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
															"Макет",
															НСтр("ru = 'Печать прав и настроек'"),
															СформироватьТабличныйДокумент(МассивОбъектов, ОбъектыПечати, ПараметрыПечати.СтруктураНастроек));
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "МакетСписокДокументов") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
															"МакетСписокДокументов",
															НСтр("ru = 'Утверждения документов'"),
															СформироватьСписокУтверждениеДокументов(МассивОбъектов, ОбъектыПечати, ПараметрыПечати.СтруктураНастроек));
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "МакетУчастники") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
															"МакетУчастники",
															НСтр("ru = 'Группы прав и настроек и пользователи'"),
															СформироватьСписокУчастников(МассивОбъектов, ОбъектыПечати, ПараметрыПечати.СтруктураНастроек));
	КонецЕсли;
КонецПроцедуры

Функция СформироватьТабличныйДокумент(МассивОбъектов, ОбъектыПечати ,СтруктураНастроек = Неопределено)
    
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	// Добавим установку параметров печати
	ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПерсональныеНастройки";
	УправлениеПечатьюПлатформа.УстановитьСтандартныеПараметрыПечати(ИмяПараметровПечати,ТабличныйДокумент);
	ТабличныйДокумент.ИмяПараметровПечати = ИмяПараметровПечати;
	
	ПервыйДокумент = Истина;
	Для Каждого ТекущийОбъект Из МассивОбъектов Цикл
		Если НЕ ПервыйДокумент Тогда // новый документ должен быть на отдельной странице
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

		СтруктураОписаний = ОписаниеПравИНастроекПоУмолчанию();
	
		Если СтруктураНастроек.РежимПечатиПользователей Тогда
			ТаблицаВыборка = ПолучитьТаблицуДанных("Пользователи", СтруктураНастроек.ДанныеДляПечати.Выгрузить(,"ПользователиГруппы"));
		Иначе
			ТаблицаВыборка = ПолучитьТаблицуДанных("ГруппыПравИНастроек", СтруктураНастроек.ДанныеДляПечати.Выгрузить(,"ПользователиГруппы"));
		КонецЕсли;
		
		Макет = Обработки.ПерсональныеНастройки.ПолучитьМакет("Макет");
		Область = Макет.ПолучитьОбласть("Заголовок|Общая");
		ТабличныйДокумент.Вывести(Область);
		Область = Макет.ПолучитьОбласть("Фильтр|Общая");
		Область.Параметры.Отбор = ПолучитьПредставлениеФильтра(СтруктураНастроек.ОтображатьПрава, СтруктураНастроек.ОтображатьНастройки, СтруктураНастроек.РежимПечатиПользователей, СтруктураНастроек.ДанныеДляПечати);
		ТабличныйДокумент.Вывести(Область);
		
		ВсегоВВыборке = ТаблицаВыборка.Количество();
		Если ВсегоВВыборке = 0 Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'По установленному отбору нет данных для отчета'"));
			Возврат ТабличныйДокумент;
		КонецЕсли;
		
		ИндексСтолбцы = 4;
		
		Область = Макет.ПолучитьОбласть("Шапка|ПравоНастройка");
		ТабличныйДокумент.Вывести(Область);
		
		Если СтруктураНастроек.ВыводитьОписаниеПрава Тогда
			Область = Макет.ПолучитьОбласть("Шапка|Описание");
			ТабличныйДокумент.Присоединить(Область);
			ИндексСтолбцы = ИндексСтолбцы + 1;
		КонецЕсли;
		
		Если СтруктураНастроек.ПоказыватьЗначениеПоУмолчанию Тогда
			Область = Макет.ПолучитьОбласть("Шапка|ЗначениеПоУмолчанию");
			ТабличныйДокумент.Присоединить(Область);
			ИндексСтолбцы = ИндексСтолбцы + 1;
		КонецЕсли;
		
		СоответствиеПравНастроек = Новый Соответствие;
		ВыборкаШаблон = Неопределено;
		
		Для Каждого ВыборкаСтр Из ТаблицаВыборка Цикл
			ТекОбъект = ВыборкаСтр.Объект;
			ОбъектСтрокой = Строка(ТекОбъект);
			РезультатПравНастроек = ПолучитьВыборкуПравИНастроек(ТекОбъект, СтруктураНастроек.ОтображатьПрава, СтруктураНастроек.ОтображатьНастройки);
			Если ВыборкаШаблон = Неопределено Тогда
				ВыборкаШаблон = РезультатПравНастроек.Выбрать();
			КонецЕсли;
			ТаблицаПравНастроек = РезультатПравНастроек.Выгрузить();
			СоответствиеПравНастроек.Вставить(ТекОбъект, ТаблицаПравНастроек);
			
			Область = Макет.ПолучитьОбласть("Шапка|Значение");
			Область.Параметры.Значение = ОбъектСтрокой;
			ТабличныйДокумент.Присоединить(Область);
			
			ИндексСтолбцы = ИндексСтолбцы + 1;
			
		КонецЦикла;
		ВсегоВВыборке = ВыборкаШаблон.Количество();
		ТаблицаГрупп = Новый ТаблицаЗначений;
		ТаблицаГрупп.Колонки.Добавить("Группа");
		ТаблицаГрупп.Колонки.Добавить("Уровень");
		ТабличныйДокумент.НачатьАвтогруппировкуСтрок();
		Пока ВыборкаШаблон.Следующий() Цикл
			Если ВыборкаШаблон.ЭтоГруппа = NULL Тогда
				Продолжить;
			КонецЕсли;
				
			Если ВыборкаШаблон.ЭтоГруппа И ТаблицаГрупп.Найти(ВыборкаШаблон.Ссылка, "Группа") <> Неопределено Тогда
				Продолжить;
			Иначе
				НоваяСтрока = ТаблицаГрупп.Добавить();
				НоваяСтрока.Группа = ВыборкаШаблон.Ссылка;
				НоваяСтрока.Уровень = ВыборкаШаблон.Уровень() + 1;
			КонецЕсли;
				
			Если ВыборкаШаблон.ЭтоГруппа Тогда
				ИмяСекции = "СтрокаГруппа";
			ИначеЕсли ВыборкаШаблон.ЭтоНастройка Тогда
				ИмяСекции = "СтрокаНастройка";
			Иначе
				ИмяСекции = "СтрокаПраво";
			КонецЕсли;
				
			СтрУровень = ТаблицаГрупп.Найти(ВыборкаШаблон.Родитель, "Группа");
			Если СтрУровень = Неопределено Тогда
				ТекУровень = 0;
			Иначе
				ТекУровень = СтрУровень.Уровень;
			КонецЕсли;
				
			Область = Макет.ПолучитьОбласть(ИмяСекции + "|ПравоНастройка");
			Область.Параметры.Код = ВыборкаШаблон.Код;
			Область.Параметры.Наименование = ВыборкаШаблон.Наименование;
			ТабличныйДокумент.Вывести(Область, ТекУровень);
				
			ИндексПоГоризонтали = 4;
				
			СтрокаОписание = "";
			СтруктураОписаний.Свойство("_" + СокрЛП(ВыборкаШаблон.Код), СтрокаОписание);
			Если СтруктураНастроек.ВыводитьОписаниеПрава Тогда
				Область = Макет.ПолучитьОбласть(ИмяСекции + "|Описание");
				Область.Параметры.Описание = СтрокаОписание;
				ТабличныйДокумент.Присоединить(Область);
				ИндексПоГоризонтали = ИндексПоГоризонтали + 1;
			КонецЕсли;
				
			Если СтруктураНастроек.ПоказыватьЗначениеПоУмолчанию Тогда
				Если ВыборкаШаблон.ЭтоГруппа Тогда
					Область = Макет.ПолучитьОбласть(ИмяСекции + "|ЗначениеПоУмолчанию");
					ТабличныйДокумент.Присоединить(Область);
				Иначе
					ТекОбъект = ВыборкаСтр.Объект;
												
					ЗначениеВОтчет = ВыборкаШаблон.ЗначениеПоУмолчанию;
					МассивТипов = ВыборкаШаблон.ТипЗначения.Типы();
					Если МассивТипов.Количество() = 1 Тогда
						Если МассивТипов[0] = Тип("Булево") Тогда
							Если ЗначениеВОтчет = Истина Тогда
								ИмяСекцияБулево = "|ЗначениеБулевоИстина";
							Иначе
								ИмяСекцияБулево = "|ЗначениеБулевоЛожь";
							КонецЕсли;
							Область = Макет.ПолучитьОбласть(ИмяСекции + ИмяСекцияБулево);
						Иначе
							Область = Макет.ПолучитьОбласть(ИмяСекции + "|ЗначениеПоУмолчанию");
							Область.Параметры.Значение = ЗначениеВОтчет;
						КонецЕсли;
					Иначе
						Область = Макет.ПолучитьОбласть(ИмяСекции + "|ЗначениеПоУмолчанию");
						Область.Параметры.Значение = НСтр("ru = '<Ошибка в заданных типах>'");
					КонецЕсли;
					ТабличныйДокумент.Присоединить(Область);
				КонецЕсли;
				ИндексПоГоризонтали = ИндексПоГоризонтали + 1;
			КонецЕсли;

			ИндексПоГоризонтали = ИндексПоГоризонтали + 1;
				
			Для Каждого ВыборкаСтр Из ТаблицаВыборка Цикл
				Если ВыборкаШаблон.ЭтоГруппа Тогда
					Область = Макет.ПолучитьОбласть(ИмяСекции + "|Значение");
					ТабличныйДокумент.Присоединить(Область);
				Иначе
					ТекОбъект = ВыборкаСтр.Объект;
											
					ТабЗначения = СоответствиеПравНастроек[ТекОбъект];
					СтрЗначение = ТабЗначения.Найти(ВыборкаШаблон.Ссылка, "Ссылка");
					ЗначениеВОтчет = ПолучитьЗначениеИзВыборки(СтрЗначение,СтруктураНастроек.РежимПечатиПользователей,ТекОбъект);
					МассивТипов = СтрЗначение.ТипЗначения.Типы();
					Если МассивТипов.Количество() = 1 Тогда
						Если МассивТипов[0] = Тип("Булево") Тогда
							Если ЗначениеВОтчет = Истина Тогда
								ИмяСекцияБулево = "|ЗначениеБулевоИстина";
							Иначе
								ИмяСекцияБулево = "|ЗначениеБулевоЛожь";
							КонецЕсли;
							Область = Макет.ПолучитьОбласть(ИмяСекции + ИмяСекцияБулево);
						Иначе
							Область = Макет.ПолучитьОбласть(ИмяСекции + "|Значение");
							Область.Параметры.Значение = ЗначениеВОтчет;
						КонецЕсли;
					Иначе
						Область = Макет.ПолучитьОбласть(ИмяСекции + "|Значение");
						Область.Параметры.Значение = НСтр("ru = '<Ошибка в заданных типах>'");
					КонецЕсли;				
					ТабличныйДокумент.Присоединить(Область);
						
				КонецЕсли;
				ИндексПоГоризонтали = ИндексПоГоризонтали + 1;
				
			КонецЦикла;
				
		КонецЦикла;
		
		Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2);
		ТабличныйДокумент.Область("R5C"+ИндексПоГоризонтали+":R"+ТабличныйДокумент.ВысотаТаблицы+"C"+ИндексПоГоризонтали+"").ГраницаСлева = Линия;
		ТабличныйДокумент.Область("R"+ТабличныйДокумент.ВысотаТаблицы+"C2:R"+ТабличныйДокумент.ВысотаТаблицы+"C"+ИндексСтолбцы+"").ГраницаСнизу = Линия;
	
		ТабличныйДокумент.ЗакончитьАвтогруппировкуСтрок();
		
		ТабличныйДокумент.ОтображатьСетку = Ложь;
		ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
		ТабличныйДокумент.ФиксацияСверху = 5;
		ТабличныйДокумент.ТолькоПросмотр = Истина;
		
		// отметим конец области документа
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийОбъект);
	КонецЦикла;	
	
	Возврат ТабличныйДокумент;	
КонецФункции // СформироватьТабличныйДокумент()

// Вывод в печатную форму списка Утверждение документов
Функция СформироватьСписокУтверждениеДокументов(МассивОбъектов, ОбъектыПечати ,СтруктураНастроек = Неопределено)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	// Добавим установку параметров печати
	ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПерсональныеНастройки_СписокУтверждениеДокументов";
	УправлениеПечатьюПлатформа.УстановитьСтандартныеПараметрыПечати(ИмяПараметровПечати,ТабличныйДокумент);
	ТабличныйДокумент.ИмяПараметровПечати = ИмяПараметровПечати;
	
	Макет = Обработки.ПерсональныеНастройки.ПолучитьМакет("МакетСписокДокументов");
	Область = Макет.ПолучитьОбласть("Заголовок|Общая");
	ТабличныйДокумент.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("Шапка|Общая");
	ТабличныйДокумент.Вывести(Область);
	
	Если СтруктураНастроек.РежимПечатиПользователей Тогда
		ТаблицаВыборка = ПолучитьТаблицуДанных("Пользователи", СтруктураНастроек.ДанныеДляПечати.Выгрузить(,"ПользователиГруппы"));
		ИмяСправочника = "Пользователи";
	Иначе
		ТаблицаВыборка = ПолучитьТаблицуДанных("ГруппыПравИНастроек", СтруктураНастроек.ДанныеДляПечати.Выгрузить(,"ПользователиГруппы"));
		ИмяСправочника = "ГруппыПравИНастроек";
	КонецЕсли;
	
	МассивОбъектов = Новый Массив;
	
	Для Каждого Строка Из ТаблицаВыборка Цикл
		МассивОбъектов.Добавить(Строка.Объект);
	КонецЦикла;
	
    Для Каждого Строка Из МассивОбъектов Цикл
		Область = Макет.ПолучитьОбласть("Шапка|ГруппаДоступа");
		Область.Параметры.Объект = Строка;
		ТабличныйДокумент.Присоединить(Область);
	КонецЦикла;
	
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
	
	// Получаем список документов, для которых используется утверждение документов
	ВыборкаДокументов = РегистрыСведений.ИспользоватьУтверждениеДокументов.Выбрать();
	
	// Получаем перечень документов, для которых настроено утверждение документов по группам доступа.
	Запрос = Новый Запрос;
	Запрос.Текст = 
	
	"ВЫБРАТЬ
	|	ИспользоватьУтверждениеДокументов.Документ КАК ДокументИмя,
	|	ИспользоватьУтверждениеДокументов.ОтклонениеПриОтменеПроведения КАК ОтклонениеПриОтменеПроведения,
	|	ЕСТЬNULL(НастройкиУтвержденияДокументов.Согласован, ЛОЖЬ) КАК Согласован,
	|	ЕСТЬNULL(НастройкиУтвержденияДокументов.Утвержден, ЛОЖЬ) КАК Утвержден,
	|	НастройкиУтвержденияДокументов.Объект КАК Объект
	|ИЗ
	|	РегистрСведений.ИспользоватьУтверждениеДокументов КАК ИспользоватьУтверждениеДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиУтвержденияДокументов КАК НастройкиУтвержденияДокументов
	|		ПО ИспользоватьУтверждениеДокументов.Документ = НастройкиУтвержденияДокументов.Документ
	|			И (НастройкиУтвержденияДокументов.Объект В (&Объект))";
	
	Запрос.УстановитьПараметр("Объект", МассивОбъектов);
	ТаблицаУтверждениеДокументов = Запрос.Выполнить().Выгрузить();
	
	// Заполняем табличную часть макета
	Пока ВыборкаДокументов.Следующий() Цикл
	
		Область = Макет.ПолучитьОбласть("СтрокаДокумент|Общая");
		Область.Параметры.ДокументСиноним = ВыборкаДокументов.Документ;
		Если ВыборкаДокументов.ОтклонениеПриОтменеПроведения Тогда
			Область.Параметры.ОтклонениеПриОтменеПроведения = ВыборкаДокументов.ОтклонениеПриОтменеПроведения;
		КонецЕсли;
		ТабличныйДокумент.Вывести(Область);
		
		Для Каждого Строка Из МассивОбъектов Цикл
			Отбор = Новый Структура("ДокументИмя, Объект", ВыборкаДокументов.Документ, Строка);
			НайденныеДокументы = ТаблицаУтверждениеДокументов.НайтиСтроки(Отбор);
			Область = Макет.ПолучитьОбласть("СтрокаДокумент|ГруппаДоступа");
			Область.Параметры.Подготовлен = Истина;
			Если НайденныеДокументы.Количество() > 0 Тогда
				Если НайденныеДокументы[0].Согласован Тогда
					Область.Параметры.Согласован = НайденныеДокументы[0].Согласован;
				КонецЕсли;
				Если НайденныеДокументы[0].Утвержден Тогда
					Область.Параметры.Утвержден = НайденныеДокументы[0].Утвержден;
				КонецЕсли;
				Если НайденныеДокументы[0].Согласован Или НайденныеДокументы[0].Утвержден Тогда 
					Область.Параметры.Отклонен = Истина;
				КонецЕсли;
			КонецЕсли;
			ТабличныйДокумент.Присоединить(Область);
		КонецЦикла;
		
	КонецЦикла;
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2);
	
	ТабличныйДокумент.Область("R"+ТабличныйДокумент.ВысотаТаблицы+"C2:R"+ТабличныйДокумент.ВысотаТаблицы+"C"+ТабличныйДокумент.ШиринаТаблицы+"").ГраницаСнизу = Линия;
	ТабличныйДокумент.Область("R5C"+(ТабличныйДокумент.ШиринаТаблицы+1)+":R"+ТабличныйДокумент.ВысотаТаблицы+"C"+(ТабличныйДокумент.ШиринаТаблицы+1)+"").ГраницаСлева = Линия;
	
	ТабличныйДокумент.ОтображатьСетку = Ложь;
	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	
	// отметим конец области документа
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
		ТабличныйДокумент,
		НомерСтрокиНачало,
		ОбъектыПечати,
		ОбъектыПечати[0].Значение);
	
	Возврат ТабличныйДокумент;
КонецФункции

// Вывод в печатную форму участников ГруппДоступа
Функция СформироватьСписокУчастников(МассивОбъектов, ОбъектыПечати ,СтруктураНастроек = Неопределено)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	// Добавим установку параметров печати
	ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПерсональныеНастройки_СписокУчастников";
	УправлениеПечатьюПлатформа.УстановитьСтандартныеПараметрыПечати(ИмяПараметровПечати,ТабличныйДокумент);
	ТабличныйДокумент.ИмяПараметровПечати = ИмяПараметровПечати;
	
	Макет = Обработки.ПерсональныеНастройки.ПолучитьМакет("МакетУчастники");
	
	Область = Макет.ПолучитьОбласть("Заголовок");
	ТабличныйДокумент.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("Шапка");
	ТабличныйДокумент.Вывести(Область);
	
	ТаблицаГруппы = Новый ТаблицаЗначений;
	
	ТаблицаГруппы = СтруктураНастроек.ДанныеДляПечати.Выгрузить();
	
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
	
	МассивОбъектов = Новый Массив;
	
	Для Каждого Строка Из ТаблицаГруппы Цикл
		МассивОбъектов.Добавить(Строка.ПользователиГруппы);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Пользователи.ГруппаПравИНастроек КАК ГруппаПравИНастроек,
	               |	Пользователи.Ссылка КАК Пользователь
	               |ИЗ
	               |	Справочник.Пользователи КАК Пользователи
	               |ГДЕ
	               |	Пользователи.ГруппаПравИНастроек В(&МассивОбъектов)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Пользователи.ГруппаПравИНастроек.Наименование,
	               |	Пользователи.Ссылка.Наименование
	               |ИТОГИ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Пользователь)
	               |ПО
	               |	ГруппаПравИНастроек";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ГруппаПравИНастроек = "";
	
	Пока Выборка.Следующий() Цикл
		Область = Макет.ПолучитьОбласть("СтрокаПользователи");
		Область.Параметры.ГруппаПравИНастроек = Выборка.ГруппаПравИНастроек;
		ДетальнаяВыборка = Выборка.Выбрать();
		НомерПервойСтроки = ТабличныйДокумент.ВысотаТаблицы + 1;
		Пока ДетальнаяВыборка.Следующий() Цикл
			Область.Параметры.Пользователь = ДетальнаяВыборка.Пользователь;
			ТабличныйДокумент.Вывести(Область);
		КонецЦикла;
		НомерПоследнейСтроки = ТабличныйДокумент.ВысотаТаблицы + 1;
		Если (НомерПоследнейСтроки - НомерПервойСтроки) > 1 Тогда
			Область = ТабличныйДокумент.Область(НомерПервойСтроки, 2, НомерПоследнейСтроки - 1, 2);
			Область.Объединить();
			Область.ВертикальноеПоложение = ВертикальноеПоложение.Центр;
			Область.Текст = Выборка.ГруппаПравИНастроек;
		КонецЕсли;
	КонецЦикла;
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2);
	ТабличныйДокумент.Область("R"+(ТабличныйДокумент.ВысотаТаблицы + 1)+"C2:R"+(ТабличныйДокумент.ВысотаТаблицы + 1)+"C3").ГраницаСверху = Линия;
	
	ТабличныйДокумент.ОтображатьСетку = Ложь;
	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	
	// отметим конец области документа
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
		ТабличныйДокумент,
		НомерСтрокиНачало,
		ОбъектыПечати,
		ОбъектыПечати[0].Значение);
	
	Возврат ТабличныйДокумент;
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли