﻿
#Область ПрограммныйИнтерфейс

// Получение номера колонки цены.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма, в которой возникло событие.
// 
// Возвращаемое значение:
//  Число - Номер колонки цены.
//
Функция ПолучитьНомерКолонкиЦена(Форма) Экспорт
	НомерКолонкиЦена = 0;
	Попытка
		СтрокаНастройки = Неопределено;
		ОтборСтрок = Новый Структура("ИмяРеквизита","Цена");
		Строки = Форма.ТаблицаЗагружаемыхРеквизитов.НайтиСтроки(ОтборСтрок);
		Если Строки.Количество() > 0 Тогда
			НомерКолонкиЦена = Строки[0].НомерКолонки;
		КонецЕсли;
	Исключение
		НомерКолонкиЦена = 0;
	КонецПопытки;
	Возврат НомерКолонкиЦена;
КонецФункции

// Процедура - Настроить видимость элементов формы помощника
//
// Параметры:
//  СтрокаНастройкиЗагрузкиНоменклатуры   - СтрокаТабличнойЧасти - Строка выбранной табличной части.
//  Элементы                              - ЭлементыФормы        - Элементы формы.
//  НастройкиЗагрузкиНоменклатурыИскатьПо - Строка               - Имя реквизита номенклатуры для поиска.
//
Процедура НастроитьВидимостьЭлементовФормыПомощника(СтрокаНастройкиЗагрузкиНоменклатуры, Элементы, НастройкиЗагрузкиНоменклатурыИскатьПо) Экспорт
	
	Если СтрокаНастройкиЗагрузкиНоменклатуры=Неопределено Тогда
		Элементы.НомерКолонкиНаименованиеТабличногоДокумента.Видимость = Ложь;
	Иначе
		НастройкиЗагрузкиНоменклатурыИскатьПо = СтрокаНастройкиЗагрузкиНоменклатуры.ИскатьПо;
		Элементы.НомерКолонкиНаименованиеТабличногоДокумента.Видимость = НЕ НастройкиЗагрузкиНоменклатурыИскатьПо="Наименование";
	КонецЕсли;

КонецПроцедуры

#КонецОбласти