﻿// Модуль менеджера регистра сведений "Выполнение сервисных компаний"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Функция записи параметров в регистр сведений
//
Функция ЗаписатьВыполненныеСервисныеКампании(
	VIN,
	СервиснаяКампания,
	Автор=Неопределено,
	ДатаВыполнения=Неопределено,
	ДокументВыполнения=Неопределено,
	НеИзменятьАвтора=Истина) Экспорт
	
	Отказ=Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = РегистрыСведений.ВыполнениеСервисныхКампаний.СоздатьНаборЗаписей();
	Набор.Отбор.VIN.Установить(VIN);
	Набор.Отбор.СервиснаяКампания.Установить(СервиснаяКампания);
	Набор.Прочитать();
	
	НаваяСтрока = Набор.Добавить();
	НаваяСтрока.VIN = VIN;
	Если НЕ Автор = Неопределено Тогда
		НаваяСтрока.Автор = Автор;
	КонецЕсли;
	НаваяСтрока.СервиснаяКампания = СервиснаяКампания;
	
	Если НЕ ДатаВыполнения = Неопределено Тогда
		НаваяСтрока.ДатаВыполнения = ДатаВыполнения;
	КонецЕсли;
	
	Если НЕ ДокументВыполнения = Неопределено Тогда
		НаваяСтрока.ДокументВыполнения = ДокументВыполнения;
	КонецЕсли;
	
	// Чтобы автоматически не устанавливался пользователь как автор
	Если НеИзменятьАвтора Тогда
		Набор.ДополнительныеСвойства.Вставить("НеИзменятьАвтора");
	КонецЕсли;
	
	Попытка
		Набор.Записать();
	Исключение
		ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),,,, Отказ);
	КонецПопытки;
	
	Возврат Отказ;
	
КонецФункции // ЗаписатьВыполненныеСервисныеКампании()

// Функция записи параметров в регистр сведений
//
Функция ЗаполнитьВыполненныеСервисныеКампании(
	VIN,
	СервиснаяКампания,
	Автор=Неопределено,
	ДатаВыполнения=Неопределено,
	ДокументВыполнения=Неопределено,
	НеИзменятьАвтора=Истина) Экспорт
	
	Отказ=Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВыполнениеСервисныхКампанийНаборЗаписей=РегистрыСведений.ВыполнениеСервисныхКампаний.СоздатьНаборЗаписей();
	ВыполнениеСервисныхКампанийНаборЗаписей.Отбор.VIN.Значение=VIN;
	ВыполнениеСервисныхКампанийНаборЗаписей.Отбор.VIN.Использование=Истина;
	ВыполнениеСервисныхКампанийНаборЗаписей.Отбор.СервиснаяКампания.Значение=СервиснаяКампания;
	ВыполнениеСервисныхКампанийНаборЗаписей.Отбор.СервиснаяКампания.Использование=Истина;
	ВыполнениеСервисныхКампанийНаборЗаписей.Прочитать();
	
	Если НеИзменятьАвтора Тогда
		ВыполнениеСервисныхКампанийНаборЗаписей.ДополнительныеСвойства.Вставить("НеИзменятьАвтора");
	КонецЕсли;
	Для Каждого СтрокаНабора Из ВыполнениеСервисныхКампанийНаборЗаписей Цикл
		СтрокаНабора.ДатаВыполнения=ДатаВыполнения;
		СтрокаНабора.ДокументВыполнения=ДокументВыполнения;
	КонецЦикла;
	Попытка
		ВыполнениеСервисныхКампанийНаборЗаписей.Записать(Истина);
	Исключение
		ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначения.СообщитьПользователю(
			СтрШаблон(
				НСтр("ru = 'Ошибка записи сервисной кампании: <%1> обнаружены ошибки :'"),
				ПредставлениеОшибки
				),
			,
			,
			,
			Отказ
		);
					
	КонецПопытки;
	
	Возврат Отказ;
	
КонецФункции // ЗаполнитьВыполненныеСервисныеКампании()

#Область ПараметрыОбработкиРеквизитовОбъекта

Функция ПолучитьОбязательныеРеквизиты(Объект) Экспорт
	
	ОбязательныеРеквизиты = ОбработкаСобытийРегистраСервер.ПолучитьСтандартныеОбязательныеРеквизиты(Объект);
	
	Возврат ОбязательныеРеквизиты;
	
КонецФункции 

Функция ПолучитьУникальныеРеквизиты(Объект) Экспорт
	
	УникальныеРеквизиты = Новый Структура();
	
	Возврат УникальныеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли