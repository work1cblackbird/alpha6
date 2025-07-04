﻿
#Область ПрограммныйИнтерфейс

// См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами
//
Процедура ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты) Экспорт
	
	Если ПраваИНастройкиПользователя.ЕстьРоль("РедактированиеРеквизитовОбъектов")
		И ПраваИНастройкиПользователя.Значение("РазрешитьРедактированиеБлокируемыхРеквизитов") Тогда
		Возврат;
	КонецЕсли;
	
	// Справочники
	Объекты.Вставить(Метаданные.Справочники.Автоработы.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.БанковскиеСчета.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.СкидкиАвтомобилей.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.СкладыКомпании.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.Цеха.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.ТипыЦен.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.ПодразделенияКомпании.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.ДоговорыВзаиморасчетов.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.ГТД.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.ВидыПлановКомпании.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.ТипыНоменклатуры.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.ТипыСкидок.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.БонусныеПрограммы.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.Номенклатура.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.Автомобили.ПолноеИмя(), "");

	// Документы
	Объекты.Вставить(Метаданные.Документы.ВыводИзЭксплуатацииАвтомобилей.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.Выписка.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.ЗаявкаНаРемонт.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.Инкассация.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.КорректировкаПоступления.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.КорректировкаРеализации.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.ПеремещениеАктивов.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.ПриходныйКассовыйОрдер.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.РасходныйКассовыйОрдер.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.РеализацияАктивов.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.СписаниеАктивов.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.СчетФактураВыданный.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.СчетФактураПолученный.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.Чек.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.ЧекКоррекции.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.ЧекНаОплату.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Документы.Событие.ПолноеИмя(), "");
	
КонецПроцедуры

// Выполняет блокировку реквизитов на форме возвращаемых фискальным регистратом.
// Блокировка производиться только если указана дата пробития чека на ФР
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа пробиваемого на ФР
Процедура ЗаблокироватьФискальныеРеквизиты(Форма) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПараметрыЗапретаРедактированияРеквизитов") Тогда
		
		Реквизиты = Новый Структура();
		Реквизиты.Вставить("НомерСмены", "Номер смены");
		Реквизиты.Вставить("НомерЧека", "Номер чека");
		Реквизиты.Вставить("ДатаФР", "Дата пробития на ФР");
		Реквизиты.Вставить("НомерДокумента", "Номер документа");
		
		Для Каждого Реквизит Из Реквизиты Цикл
			
			УсловиеПоиска = Новый Структура("ИмяРеквизита", Реквизит.Ключ);
			Найденные = Форма.ПараметрыЗапретаРедактированияРеквизитов.НайтиСтроки(УсловиеПоиска);
			
			Если Найденные.Количество() > 0 Тогда
				
				БлокируемыйРеквизит = Найденные[0];
				
			Иначе
				
				БлокируемыйРеквизит = Форма.ПараметрыЗапретаРедактированияРеквизитов.Добавить();
				
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Форма.Элементы,
				Реквизит.Ключ,
				"ТолькоПросмотр",
				ЗначениеЗаполнено(Форма.Объект.ДатаФР)
			);
			
			БлокируемыйРеквизит.ИмяРеквизита = Реквизит.Ключ;
			БлокируемыйРеквизит.Представление = Реквизит.Значение;
			БлокируемыйРеквизит.ПравоРедактирования = Истина;
			
			БлокируемыеЭлементы = Новый СписокЗначений;
			БлокируемыеЭлементы.Добавить(Реквизит.Ключ);
			БлокируемыйРеквизит.БлокируемыеЭлементы = БлокируемыеЭлементы;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет блокировку реквизитов формы, т.к. стандартная процедура блокирует только реквизиты объекта.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа
Процедура ЗаблокироватьРеквизитыФормы(Форма) Экспорт
	
	ЭтоНовыйОбъект 	= Форма.Объект.Ссылка.Пустая();
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПараметрыЗапретаРедактированияРеквизитов") Тогда
		Для Каждого Элемент Из Форма.ПараметрыЗапретаРедактированияРеквизитов Цикл
			Если Не Элемент.ЭтоРеквизитФормы Тогда	
				Продолжить;    
			КонецЕсли;
			
			РедактированиеРазрешено = Элемент.ПравоРедактирования И ЭтоНовыйОбъект;
			Если РедактированиеРазрешено Тогда
				Продолжить;
			КонецЕсли;
			
			ЭлементФормы = Форма.Элементы.Найти(Элемент.ИмяРеквизита);
			Если ЭлементФормы = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если ТипЗнч(ЭлементФормы) = Тип("ПолеФормы") И ЭлементФормы.Вид <> ВидПоляФормы.ПолеНадписи
				Или ТипЗнч(ЭлементФормы) = Тип("ТаблицаФормы") Тогда
				ЭлементФормы.ТолькоПросмотр = НЕ РедактированиеРазрешено;
			Иначе
				ЭлементФормы.Доступность = РедактированиеРазрешено;
			КонецЕсли;
			
			Элемент.РедактированиеРазрешено = Истина;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Функция МетаданныеОбщегоРеквизита(МетаданныеОбъекта, ИмяРеквизита) Экспорт
	
	Результат = Неопределено;
	
	МетаданныеОбщегоРеквизита = Метаданные.ОбщиеРеквизиты.Найти(ИмяРеквизита);
	Если МетаданныеОбщегоРеквизита = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	АвтоИспользованиеРеквизита = МетаданныеОбщегоРеквизита.АвтоИспользование;
	ИспользованиеДляОбъекта = МетаданныеОбщегоРеквизита.Состав.Найти(МетаданныеОбъекта).Использование;
	
	Если ИспользованиеДляОбъекта = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать
		ИЛИ АвтоИспользованиеРеквизита = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать
		И ИспользованиеДляОбъекта = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Авто Тогда
		
		Результат = МетаданныеОбщегоРеквизита;
		
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

#КонецОбласти