﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТипЦен;
Перем Подразделение;
Перем ДанныеПрайсЛиста Экспорт; // Таблица значений, с данными прайс-листа
Перем ОтборНоменклатуры;

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Инициализация параметров обработки
//
// Параметры:
//  ПрайсЛист - СправочникСсылка.ПрайсЛисты - найстройки прайс-листа для рассылки.
//
// Возвращаемое значение:
//  ОбработкаОбъект.ПостроительПрайсЛистаВсяНоменклатура - Объект обработки с параметрами.
//
Функция Инициализировать(ПрайсЛист) Экспорт
	
	РеквизитыПрайсЛиста = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПрайсЛист, "Владелец,ОтборНоменклатуры");
	
	Подразделение = РеквизитыПрайсЛиста.Владелец;
	ОтборНоменклатуры = РеквизитыПрайсЛиста.ОтборНоменклатуры.Получить();
	Возврат ЭтотОбъект;
	
КонецФункции

// Формирование запроса для получения данных по прайс-листу.
//
Процедура Построить() Экспорт
	
	СхемаКомпоновкиДанных = ПолучитьМакет("СхемаКомпоновкиДанных");
	ДанныеПрайсЛиста = Новый ТаблицаЗначений;
	НастройкиКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
	НастройкиКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	НастройкиКомпоновкиДанных.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	Если ОтборНоменклатуры <> Неопределено Тогда
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(
			НастройкиКомпоновкиДанных.Настройки.Отбор,
			ОтборНоменклатуры.Отбор
		);
	КонецЕсли;
	
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

// Установка типа цен прайс-листа
//
// Параметры:
//  НовыйТипЦен - СправочникСсылка.ТипыЦен - Тип цены для инициализации настроек.
//
Процедура УстановитьТипЦен(НовыйТипЦен) Экспорт
	
	ТипЦен = НовыйТипЦен;
	
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
	
	КоличествоЗаписей = 0;
	
	Пока Истина Цикл
		
		ПорцияКЗаписи = СледующаяПорцияКЗаписи(КоличествоЗаписей, ДанныеПрайсЛиста.Количество());
		
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

Функция СледующаяПорцияКЗаписи(КоличествоЗаписей, ВсегоЗаписей, РазмерПорции = 10000)
	
	Порция = Новый Массив;
	
	Пока Порция.Количество() < РазмерПорции И КоличествоЗаписей < ВсегоЗаписей Цикл
		
		Строка = Новый Структура("Номенклатура,Артикул,Код,Производитель,ПроизводительПредставление,Наименование,
			|НаименованиеИностранное,ГруппаТоваров,Количество,Резерв,Цена"
		);
		ЗаполнитьЗначенияСвойств(Строка, ДанныеПрайсЛиста[КоличествоЗаписей]);
		Порция.Добавить(Строка);
		КоличествоЗаписей = КоличествоЗаписей + 1;
	КонецЦикла;
	
	Возврат Порция;
	
КонецФункции

#КонецОбласти

#КонецЕсли