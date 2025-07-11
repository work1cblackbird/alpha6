﻿
#Область ПрограммныйИнтерфейс

// Определяет объекты конфигурации, в формах списках которых размещены команды учета оригиналов первичных документов,
//
// Параметры:
//  СписокОбъектов - Массив из Строка - менеджеры объектов с процедурой ДобавитьКомандыПечати.
//
Процедура ПриОпределенииОбъектовСКомандамиУчетаОригиналов(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить("Документ.АвансовыйОтчет.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.ВозвратОтПокупателя.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.ВозвратОтПокупателяАвтомобилей.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.ВозвратПоставщику.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.ВозвратПоставщикуАвтомобилей.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.ЗаказНаряд.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.КорректировкаПоступления.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.КорректировкаПоступленияАвтомобилей.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.КорректировкаРеализации.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.КорректировкаРеализацииАвтомобилей.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.ПоступлениеАвтомобилей.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.ПоступлениеТоваров.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.РеализацияАвтомобилей.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.РеализацияАктивов.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.РеализацияТоваров.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.СчетНаОплату.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.СчетНаОплатуЗаАвтомобили.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.СчетФактураВыданный.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.СчетФактураПолученный.Форма.ФормаСписка");
	СписокОбъектов.Добавить("ЖурналДокументов.Автосалон.Форма.ФормаСписка");
	СписокОбъектов.Добавить("ЖурналДокументов.ЗаказНаряд.Форма.ФормаСписка");
	СписокОбъектов.Добавить("ЖурналДокументов.ОбслуживаниеАвтомобиля.Форма.ФормаСписка");
	СписокОбъектов.Добавить("ЖурналДокументов.Покупатели.Форма.ФормаСписка");
	СписокОбъектов.Добавить("ЖурналДокументов.Поставщики.Форма.ФормаСписка");
	СписокОбъектов.Добавить("ЖурналДокументов.ПрочиеАктивы.Форма.ФормаСписка");
	СписокОбъектов.Добавить("ЖурналДокументов.ТоварныеДокументы.Форма.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти
