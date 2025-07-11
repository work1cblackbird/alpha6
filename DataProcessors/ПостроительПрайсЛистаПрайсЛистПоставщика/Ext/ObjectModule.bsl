﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем РеквизитыПрайсЛиста;
Перем ТипЦен;
Перем ДанныеПрайсЛиста Экспорт; // Таблица значений, с данными прайс-листа
Перем ПараметрыРасчетаЦен;
Перем ПустойПроизводитель;
Перем ИдентификаторПустойПроизводитель;
Перем Курс;
Перем СтруктураПрайсЛиста;

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Инициализация параметров обработки
//
// Параметры:
//  ПрайсЛист - СправочникСсылка.ПрайсЛисты - найстройки прайс-листа для рассылки.
//
// Возвращаемое значение:
//  ОбработкаОбъект.ПостроительПрайсЛистаОстаткиНаСкладах - Объект обработки с параметрами.
//
Функция Инициализировать(ПрайсЛист) Экспорт
	
	ПустойПроизводитель = ПредопределенноеЗначение("Справочник.Производители.ПустаяСсылка");
	ИдентификаторПустойПроизводитель = ПустойПроизводитель.УникальныйИдентификатор();
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ПрайсЛистПоставщика", "ПрайсЛистПоставщика");
	Реквизиты.Вставить("Подразделение", "Владелец");
	Реквизиты.Вставить("ФайлИсточникДанных", "ПрайсЛистПоставщика.ФайлИсточникДанных");
	Реквизиты.Вставить("ХранитьДанныеЛокально", "ПрайсЛистПоставщика.ХранитьДанныеЛокально");
	Реквизиты.Вставить("Валюта", "ПрайсЛистПоставщика.Валюта");
	Реквизиты.Вставить("СтрокаПодключения", "ПрайсЛистПоставщика.СтрокаПодключения");
	Реквизиты.Вставить("ИмяТаблицы", "ПрайсЛистПоставщика.ИмяТаблицы");
	Реквизиты.Вставить("Производитель", "ПрайсЛистПоставщика.Производитель");
	Реквизиты.Вставить("ОтборНоменклатуры", "ОтборНоменклатуры");
	РеквизитыПрайсЛиста = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПрайсЛист, Реквизиты);
	
	Курс = 1;
	
	Если ЗначениеЗаполнено(РеквизитыПрайсЛиста.Валюта) Тогда
		
		ПараметрыКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(РеквизитыПрайсЛиста.Валюта, КонецДня(ТекущаяДатаСеанса()));
		Курс = ПараметрыКурса.Курс / ?(ПараметрыКурса.Кратность = 0, 1, ПараметрыКурса.Кратность);
		
	КонецЕсли;
	
	Возврат ЭтотОбъект;
	
КонецФункции

// Формирование запроса для получения данных по прайс-листу.
//
Процедура Построить() Экспорт
	
	Если РеквизитыПрайсЛиста.ФайлИсточникДанных ИЛИ РеквизитыПрайсЛиста.ХранитьДанныеЛокально Тогда
		
		ИнформацияИзИБ();
		Возврат;
		
	КонецЕсли;
	
	СтруктураПрайсЛиста = СтруктураПрайсЛиста();
	ДанныеПрайсЛиста = ИнформацияИзВнешнегоФайла();
	
КонецПроцедуры

// Установка типа цен прайс-листа
//
// Параметры:
//  НовыйТипЦен - СправочникСсылка.ТипыЦен - Тип цены для инициализации настроек.
//
Процедура УстановитьТипЦен(НовыйТипЦен) Экспорт
	
	ТипЦен = НовыйТипЦен;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПрайсЛистыКонтрагентовСкидкиСрезПоследних.Производитель КАК Производитель,
		|	МИНИМУМ(ПрайсЛистыКонтрагентовСкидкиСрезПоследних.Скидка) КАК Скидка
		|ИЗ
		|	РегистрСведений.ПрайсЛистыКонтрагентовСкидки.СрезПоследних(, ПрайсЛист = &ПрайсЛист) КАК ПрайсЛистыКонтрагентовСкидкиСрезПоследних
		|ГДЕ
		|	НЕ ПрайсЛистыКонтрагентовСкидкиСрезПоследних.Отменена
		|
		|СГРУППИРОВАТЬ ПО
		|	ПрайсЛистыКонтрагентовСкидкиСрезПоследних.Производитель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПрайсЛистыКонтрагентовНаценкиСрезПоследних.Производитель КАК Производитель,
		|	ПрайсЛистыКонтрагентовНаценкиСрезПоследних.ТегПозиции КАК ТегПозиции,
		|	МИНИМУМ(ПрайсЛистыКонтрагентовНаценкиСрезПоследних.Наценка) КАК Наценка,
		|	МИНИМУМ(ПрайсЛистыКонтрагентовНаценкиСрезПоследних.ОкруглятьДо) КАК ОкруглятьДо,
		|	ПрайсЛистыКонтрагентовНаценкиСрезПоследних.АлгоритмРасчетаЦены КАК АлгоритмРасчетаЦены
		|ИЗ
		|	РегистрСведений.ПрайсЛистыКонтрагентовНаценки.СрезПоследних(
		|			,
		|			ПодразделениеКомпании = &ПодразделениеКомпании
		|				И ПрайсЛист = &ПрайсЛист
		|				И ТипЦен = &ТипЦен) КАК ПрайсЛистыКонтрагентовНаценкиСрезПоследних
		|ГДЕ
		|	НЕ ПрайсЛистыКонтрагентовНаценкиСрезПоследних.Отменена
		|
		|СГРУППИРОВАТЬ ПО
		|	ПрайсЛистыКонтрагентовНаценкиСрезПоследних.Производитель,
		|	ПрайсЛистыКонтрагентовНаценкиСрезПоследних.АлгоритмРасчетаЦены,
		|	ПрайсЛистыКонтрагентовНаценкиСрезПоследних.ТегПозиции"
	);
	Запрос.УстановитьПараметр("ПрайсЛист", РеквизитыПрайсЛиста.ПрайсЛистПоставщика);
	Запрос.УстановитьПараметр("ПодразделениеКомпании", РеквизитыПрайсЛиста.Подразделение);
	Запрос.УстановитьПараметр("ТипЦен", ТипЦен);
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ПараметрыРасчетаЦен = Новый Структура();
	ПараметрыРасчетаЦен.Вставить("Скидки");
	ПараметрыРасчетаЦен.Вставить("Наценки");
	
	Если НЕ РезультатыЗапроса[0].Пустой() Тогда
		
		Скидки = Новый Соответствие;
		Выборка = РезультатыЗапроса[0].Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Скидки.Вставить(Выборка.Производитель, Выборка.Скидка);
			
		КонецЦикла;
		
		ПараметрыРасчетаЦен.Скидки = Скидки;
		
	КонецЕсли;
	
	Если НЕ РезультатыЗапроса[1].Пустой() Тогда
		
		Наценки = Новый Соответствие;
		Выборка = РезультатыЗапроса[1].Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Значение = Новый Массив(3);
			Значение[0] = Выборка.Наценка;
			Значение[1] = Выборка.ОкруглятьДо;
			Значение[2] = Выборка.АлгоритмРасчетаЦены;
			Наценки.Вставить(Строка(Выборка.Производитель.УникальныйИдентификатор()) + Выборка.ТегПозиции, Значение);
			
		КонецЦикла;
		
		ПараметрыРасчетаЦен.Наценки = Наценки;
		
	КонецЕсли;
	
КонецПроцедуры

// Формирование строки с данными прайс-листа
//
// Параметры:
//  Писатель - ТабличныйДокумент - Данные хранения добавляемых данных.
//
// Возвращаемое значение:
//  Неопределено - данная функция не возвращает данные.
//
Функция Сформировать(Писатель) Экспорт
	
	Если РеквизитыПрайсЛиста.ФайлИсточникДанных ИЛИ РеквизитыПрайсЛиста.ХранитьДанныеЛокально Тогда
		
		КоличествоЗаписей = 0;
		ВсегоЗаписей = ДанныеПрайсЛиста.Количество();
		
	Иначе
		
		ДанныеПрайсЛиста.MoveFirst();
		КоличествоЗаписей = 0;
		ВсегоЗаписей = 0;
		
	КонецЕсли;
	
	Пока Истина Цикл
		
		ПорцияКЗаписи = СледующаяПорцияКЗаписи(КоличествоЗаписей, ВсегоЗаписей);
		
		Если ПорцияКЗаписи.Количество() = 0 Тогда
			
			Прервать;
			
		КонецЕсли;
		
		Для Каждого Строка Из ПорцияКЗаписи Цикл
			
			Писатель.СохранитьСтроку(Строка);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнформацияИзИБ()
	
	СхемаКомпоновкиДанных = ПолучитьМакет("СхемаКомпоновкиДанных");
	ДанныеПрайсЛиста = Новый ТаблицаЗначений;
	НастройкиКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
	НастройкиКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	НастройкиКомпоновкиДанных.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	ОтборНоменклатуры = РеквизитыПрайсЛиста.ОтборНоменклатуры.Получить();
	
	Если ОтборНоменклатуры <> Неопределено Тогда
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(
			НастройкиКомпоновкиДанных.Настройки.Отбор,
			ОтборНоменклатуры.Отбор
		);
	КонецЕсли;
	НастройкиКомпоновкиДанных.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра(
		"ПрайсЛист",
		РеквизитыПрайсЛиста.ПрайсЛистПоставщика
	);
	
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакетаКомпоновкиДанных.Выполнить(
		СхемаКомпоновкиДанных,
		НастройкиКомпоновкиДанных.Настройки,
		, ,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений")
	);
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ДанныеПрайсЛиста);
	ПроцессорВывода.НачатьВывод();
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
	ПроцессорВывода.ЗакончитьВывод();
	
КонецПроцедуры

Функция СтруктураПрайсЛиста()
	
	ИменаПолей = Новый Структура("Артикул,Производитель,Наименование,ТегПозиции,Количество,Цена");
	ЗначенияПоУмолчанию = Новый Структура("Артикул,Производитель,Наименование,ТегПозиции,Количество,Цена");
	СтруктураФайлаПрайсЛиста = РеквизитыПрайсЛиста.ПрайсЛистПоставщика.СтруктураФайлаПрайсЛиста;
	
	Для Каждого КлючЗначение Из ИменаПолей Цикл
		
		Поле = СтруктураФайлаПрайсЛиста.Найти(КлючЗначение.Ключ, "ИмяРеквизитаПрайсЛиста");
		
		Если Поле = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ИменаПолей[КлючЗначение.Ключ] = Поле.ИмяПоляФайла;
		
		Если КлючЗначение.Ключ <> "Производитель" Тогда
			
			ЗначенияПоУмолчанию[КлючЗначение.Ключ] = Поле.ЗначениеПоУмолчанию;
			
		Иначе
			
			ЗначенияПоУмолчанию[КлючЗначение.Ключ] = РеквизитыПрайсЛиста.Производитель;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Новый Структура("ИменаПолей,ЗначенияПоУмолчанию", ИменаПолей, ЗначенияПоУмолчанию);
	
КонецФункции

Функция ИнформацияИзВнешнегоФайла()
	
	Connection = Новый COMОбъект("ADODB.Connection");
	Коннект = Connection.Open(РеквизитыПрайсЛиста.СтрокаПодключения);
	Command = Новый COMОбъект("ADODB.Command");
	Command.ActiveConnection = Connection;
	Recordset = Новый COMОбъект("ADODB.Recordset");
	Recordset.ActiveConnection = Connection;
	ПоляЗапроса = Новый Массив;
	
	Для Каждого КлючЗначение Из СтруктураПрайсЛиста.ИменаПолей Цикл
		
		Если НЕ ЗначениеЗаполнено(КлючЗначение.Значение) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ПоляЗапроса.Добавить(СтрШаблон("%1.[%2]", РеквизитыПрайсЛиста.ИмяТаблицы, КлючЗначение.Значение));
		
	КонецЦикла;
	
	Command.CommandText = СтрШаблон("SELECT %1 FROM %2", СтрСоединить(ПоляЗапроса, ", "), РеквизитыПрайсЛиста.ИмяТаблицы);
	Возврат Command.Execute();
	
КонецФункции

Функция ПолучитьЦену(ЦенаПрайсЛиста, Строка)
	
	Если ПараметрыРасчетаЦен.Скидки = Неопределено И ПараметрыРасчетаЦен.Наценки = Неопределено И Курс = 1 Тогда
		
		Возврат 0;
		
	КонецЕсли;
	
	Цена = ЦенаПрайсЛиста;
	
	Если ПараметрыРасчетаЦен.Скидки <> Неопределено Тогда
		
		Скидка = ПараметрыРасчетаЦен.Скидки.Получить(Строка.Производитель);
		
		Если Скидка = Неопределено Тогда
			
			Скидка = ПараметрыРасчетаЦен.Скидки.Получить(ПустойПроизводитель);
			
		КонецЕсли;
		
		Если Скидка <> Неопределено Тогда
			
			Цена = Макс(0, Окр(Цена * (100 - Скидка) / 100, 2));
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПараметрыРасчетаЦен.Наценки <> Неопределено Тогда
		
		Наценка = ПараметрыРасчетаЦен.Наценки.Получить(Строка(Строка.Производитель.УникальныйИдентификатор()) + Строка.ТегПозиции);
		
		Если Наценка = Неопределено И ЗначениеЗаполнено(Строка.ТегПозиции) Тогда
			
			Наценка = ПараметрыРасчетаЦен.Наценки.Получить(Строка(Строка.Производитель.УникальныйИдентификатор()));
			
		КонецЕсли;
		
		Если Наценка = Неопределено Тогда
			
			Наценка = ПараметрыРасчетаЦен.Наценки.Получить(ИдентификаторПустойПроизводитель);
			
		КонецЕсли;
		
		Если Наценка <> Неопределено Тогда
			
			ОкруглятьДо = Наценка[1]; АлгоритмРасчетаЦены = Наценка[2]; Наценка = Наценка[0];
			
			Если НЕ ЗначениеЗаполнено(АлгоритмРасчетаЦены) Тогда
				
				Цена = Макс(0, Окр(Цена * (100 + Наценка) / 100, 2))
				
			Иначе
				
				ВыражениеРасчетаЦены = Лев(СокрЛП(АлгоритмРасчетаЦены), 989);
				
				Если Найти(ВыражениеРасчетаЦены, "#Процедура") > 0 Тогда
					
					Попытка
						
						Выполнить(СтрЗаменить(ВыражениеРасчетаЦены, "#Процедура", ""));
						
					Исключение
						
						Цена = 0;
						
					КонецПопытки;
					
				Иначе
					
					Попытка
						
						Выполнить(ВыражениеРасчетаЦены);
						Цена = Макс(0, Цена);
						
					Исключение
						
						Цена = 0;
						
					КонецПопытки;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Окр(Цена * Курс, 2);
	
КонецФункции

Функция СледующаяПорцияКЗаписи(КоличествоЗаписей, ВсегоЗаписей, РазмерПорции = 10000)
	
	Порция = Новый Массив;
	
	Если РеквизитыПрайсЛиста.ФайлИсточникДанных ИЛИ РеквизитыПрайсЛиста.ХранитьДанныеЛокально Тогда
		
		Пока Порция.Количество() < РазмерПорции И КоличествоЗаписей < ВсегоЗаписей  Цикл
			
			Строка = Новый Структура(
				"Номенклатура,
				|Артикул,
				|Производитель,
				|ПроизводительПредставление,
				|Наименование,
				|НаименованиеИностранное,
				|ГруппаТоваров,
				|Количество,
				|Резерв,
				|Цена"
			);
			ЗаполнитьЗначенияСвойств(Строка, ДанныеПрайсЛиста[КоличествоЗаписей]);
			Строка.Цена = ПолучитьЦену(ДанныеПрайсЛиста[КоличествоЗаписей].БазоваяЦена, ДанныеПрайсЛиста[КоличествоЗаписей]);
			Порция.Добавить(Строка);
			КоличествоЗаписей = КоличествоЗаписей + 1;
			
		КонецЦикла;
		
	Иначе
		
		Пока НЕ ДанныеПрайсЛиста.EOF Цикл
			
			НоваяСтрока = Новый Структура(
				"Номенклатура,
				|Артикул,
				|Производитель,
				|ПроизводительПредставление,
				|Наименование,
				|НаименованиеИностранное,
				|ТегПозиции,
				|ГруппаТоваров,
				|Количество,
				|Резерв,
				|БазоваяЦена,
				|Цена"
			);
			ЗначенияВВыборке = Новый Соответствие;
			
			Для Каждого Field Из ДанныеПрайсЛиста.Fields Цикл
				
				ЗначенияВВыборке.Вставить(Field.Name, Field.Value);
				
			КонецЦикла;
			
			Для Каждого КлючЗначение Из СтруктураПрайсЛиста.ИменаПолей Цикл
				
				Если ЗначениеЗаполнено(КлючЗначение.Значение) Тогда
					
					Если КлючЗначение.Ключ = "Производитель" Тогда
						
						НоваяСтрока.ПроизводительПредставление = ЗначенияВВыборке.Получить(КлючЗначение.Значение);
						НоваяСтрока.Производитель = РаботаСПроизводителямиПовтИсп
						.НайтиПроизводителяПоНаименованию(НоваяСтрока.ПроизводительПредставление);
						Продолжить;
						
					ИначеЕсли КлючЗначение.Ключ = "Артикул" Тогда
						
						НоваяСтрока.Артикул = ОбщегоНазначенияАвтосалонКлиентСервер
						.ВАртикулДляПоиска(ЗначенияВВыборке.Получить(КлючЗначение.Значение));
						
					ИначеЕсли КлючЗначение.Ключ = "Цена" Тогда
						
						НоваяСтрока.БазоваяЦена = ЗначенияВВыборке.Получить(КлючЗначение.Значение);
						
					КонецЕсли;
					
					НоваяСтрока[КлючЗначение.Ключ] = ЗначенияВВыборке.Получить(КлючЗначение.Значение);
					
				ИначеЕсли ЗначениеЗаполнено(СтруктураПрайсЛиста.ЗначенияПоУмолчанию[КлючЗначение.Ключ]) Тогда
					
					НоваяСтрока[КлючЗначение.Ключ] = СтруктураПрайсЛиста.ЗначенияПоУмолчанию[КлючЗначение.Ключ];
					
					Если КлючЗначение.Ключ = "Производитель" Тогда
						
						НоваяСтрока.ПроизводительПредставление = Строка(НоваяСтрока[КлючЗначение.Ключ]);
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Порция.Добавить(НоваяСтрока);
			ДанныеПрайсЛиста.MoveNext();
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Порция;
	
КонецФункции

#КонецОбласти

#КонецЕсли