﻿// Модуль менеджера документа "Заказ кодов маркировки"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Производит расчет значений итоговых показателей по операции в целом.
//
// Параметры:
//  Объект		 - ДанныеФормыСтруктура	 - Объект, для которого выполняется обработка события.
//  Расширенные	 - Булево				 - Признак получения расширенных сведений об итогах операци.
// 
// Возвращаемое значение:
//  Структура - Данные с итогами показателей
//
Функция РассчитатьИтогиОперации(Объект, Расширенные = Ложь) Экспорт
	
	// Формируем перечень основной информации об итогах операции
	ИтогиОперации = Новый Структура();
	
	// Производим установку полученных значений в итоговые показатели объекта
	Если НЕ Расширенные Тогда
		Возврат ИтогиОперации;
	КонецЕсли;
	
	// Возвращаем сведения об итогах операции
	Возврат ИтогиОперации;
	
КонецФункции // РассчитатьИтогиОперации()

#Область ПараметрыОбработкиРеквизитовОбъекта

// Производит формирование параметров проверки заполнения реквизитов объекта на предмет обязательности.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - Объект, для которого выполняется получение параметров проверки.
//
// Возвращаемое значение:
//  Массив - Возвращаемый массив содержит строковые идентификаторы реквизитов.
//
Функция ПолучитьОбязательныеРеквизиты(Объект) Экспорт
	
	// Обязательные реквизиты документа
	ОбязательныеРеквизиты = Новый Массив();
	ОбязательныеРеквизиты.Добавить("Организация");
	ОбязательныеРеквизиты.Добавить("СпособВыпускаВОборот");
	ОбязательныеРеквизиты.Добавить("Ответственный");
	ОбязательныеРеквизиты.Добавить("ПодразделениеКомпании");
	ОбязательныеРеквизиты.Добавить("Автор");
	ОбязательныеРеквизиты.Добавить("ХозОперация");
	ОбязательныеРеквизиты.Добавить("Статус");
	ОбязательныеРеквизиты.Добавить("ТоварнаяГруппа");

	Если НЕ ПраваИНастройкиПользователя.Значение("ПроведениеНезаполненныхДокументов", Объект) Тогда
		ОбязательныеРеквизиты.Добавить("Товары");
	КонецЕсли;

	ОбязательныеРеквизиты.Добавить("Товары.Количество");
	ОбязательныеРеквизиты.Добавить("Товары.СпособЗаполненияСерийногоНомера");
	ОбязательныеРеквизиты.Добавить("Товары.Номенклатура");
	Если
		Объект.СпособВыпускаВОборот = ПредопределенноеЗначение("Перечисление.СпособыВыпускаВОборот.МаркировкаОстатков")
	Тогда
		ОбязательныеРеквизиты.Добавить("Товары.КодТНВЭД");
		Если Объект.ТоварнаяГруппа = Справочники.ТипыМаркировки.ШиныИАвтопокрышки Тогда
			ОбязательныеРеквизиты.Добавить("Товары.Модель");
		ИначеЕсли Объект.ТоварнаяГруппа = Справочники.ТипыМаркировки.ЛегкаяПромышленность Тогда
			ОбязательныеРеквизиты.Добавить("Товары.СпособВыпускаТоваровВОборот");
		КонецЕсли;
	КонецЕсли;
	
	ТабачнаяПродукция = МаркировкаТоваровКлиентСервер.ТоварныеГруппыТабачнойПродукции();
	Если ТабачнаяПродукция.Найти(Объект.ТоварнаяГруппа.ТоварнаяГруппа) <> Неопределено Тогда
		ОбязательныеРеквизиты.Добавить("ИдентификаторПроизводства");
		ОбязательныеРеквизиты.Добавить("СтранаПроизводителя");
		ОбязательныеРеквизиты.Добавить("ИдентификаторПроизводственнойЛинии");
		ОбязательныеРеквизиты.Добавить("КодПродукта");
		ОбязательныеРеквизиты.Добавить("ОписаниеПродукта");
		ОбязательныеРеквизиты.Добавить("Товары.МаксимальнаяРозничнаяЦена");
	КонецЕсли;
	
	ТоварнаяГруппа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ТоварнаяГруппа, "ТоварнаяГруппа");
	Если МаркировкаТоваровКлиентСервер.ЭтоТоварнаяГруппаУпакованнойВоды(ТоварнаяГруппа) Тогда
		ОбязательныеРеквизиты.Добавить("ТипОплаты");
	КонецЕсли;
	
	Возврат ОбязательныеРеквизиты;
	
КонецФункции

// Производит формирование параметров проверки заполнения реквизитов объекта на предмет уникальности.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - Объект, для которого выполняется получение параметров проверки.
//
// Возвращаемое значение:
//  Структура - Возвращаемая структура содержит строковые идентификаторы реквизитов.
//  Для описания проверки табличных частей используется
//  вложенная структура.
//
Функция ПолучитьУникальныеРеквизиты(Объект) Экспорт
	
	УникальныеРеквизиты = Новый Структура();
	
	Если
		Объект.СпособВыпускаВОборот <> ПредопределенноеЗначение("Перечисление.СпособыВыпускаВОборот.МаркировкаОстатков")
	Тогда
		УникальныеТовары = Новый Массив();
		УникальныеТовары.Добавить("GTIN");
		УникальныеРеквизиты.Вставить("Товары", УникальныеТовары);
	КонецЕсли;
	
	Возврат УникальныеРеквизиты;
	
КонецФункции

// Производит формирование перечня реквизитов для проверки соответствия Организации и Подразделению.
//
// Параметры:
//  Объект                  - ДанныеФормыСтруктура - Объект, для которого выполняется получение параметров проверки.
//  КонтрольПоПодразделению - Булево               - Признак необходимости выполнить контроль по подразделению.
//
// Возвращаемое значение:
//  Структура - Содержит перечень проверяемых реквизитов.
//
Функция ПолучитьРеквизитыКонтроляПоОрганизации(Объект, КонтрольПоПодразделению) Экспорт
	
	КонтролируемыеРеквизиты = Новый Структура();
	Возврат КонтролируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиИзмененияДанныхОбъекта

// Возвращает предопределенную структуру действий
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
// 
// Возвращаемое значение:
//  Структура - Параметры действия.
//
Функция ПолучитьПараметрыДействия(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	Если ПараметрыДействия = Неопределено Тогда
		ПараметрыДействия = Новый Структура;
	КонецЕсли;
	
	ПараметрыДействия.Вставить("ТребуетсяУстановкаЦен", Ложь);
	
	Возврат ПараметрыДействия;
	
КонецФункции

// Обработчик события пересчета зависимых показателей объекта при изменении значений ведущих реквизитов.
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ОбработкаПересчетаПоказателейОбъекта(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	ОбработкаРеквизитовДокументаСервер.ОбработкаПересчетаПоказателейОбъекта(Объект, ПараметрыДействия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Обработчик события возникающего при изменении данных реквизита "Дата".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ДатаПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	ОбработкаРеквизитовДокументаСервер.ДатаПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Организация".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ОрганизацияПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	ОбработкаРеквизитовДокументаСервер.ОрганизацияПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Автор".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура АвторПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	ОбработкаРеквизитовДокументаСервер.АвторПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Документ основание".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ДокументОснованиеПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	ОбработкаРеквизитовДокументаСервер.ДокументОснованиеПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Хоз. операция".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ХозОперацияПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	ОбработкаРеквизитовДокументаСервер.ХозОперацияПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Подразделение компании".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ПодразделениеКомпанииПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	ОбработкаРеквизитовДокументаСервер.ПодразделениеКомпанииПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

// Обработчик события возникающего при изменении данных реквизита "Номенклатура" в таблице "Товары".
//
// Параметры:
//  Объект - ДанныеФормыСтруктура   - Объект, для которого выполняется обработка события.
//  Строка - Строка табличной части - Строка, при изменении поля которой возникло событие.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ТоварыНоменклатураПриИзменении(Объект, Строка, ПараметрыДействия = Неопределено) Экспорт
	
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	ОбработкаТабличнойЧастиТовары.НоменклатураПриИзменении(Объект, Строка, ПараметрыДействия);
	
	Строка.КодТНВЭД = Строка.Номенклатура.КодТНВЭД;
	
	// Заполним имя модели наименованием номенклатуры
	Если Объект.ТоварнаяГруппа = Справочники.ТипыМаркировки.ШиныИАвтопокрышки
		И Объект.СпособВыпускаВОборот = Перечисления.СпособыВыпускаВОборот.МаркировкаОстатков Тогда
		Строка.Модель = Строка.Номенклатура.Наименование;
	КонецЕсли;
	
	Строка.GTIN = "";
	Если ЗначениеЗаполнено(Строка.Номенклатура) Тогда
		
		ДлинаШК = 14;
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ШтрихКоды.ШтрихКод КАК ШтрихКод
		|ИЗ
		|	РегистрСведений.ШтрихКоды КАК ШтрихКоды
		|ГДЕ
		|	ШтрихКоды.Объект = &Объект
		|	И ШтрихКоды.GTIN";
		Запрос.УстановитьПараметр("Объект", Строка.Номенклатура);
		
		ВыборкаШК = Запрос.Выполнить().Выбрать();
		
		Если ВыборкаШК.Количество() = 1 И ВыборкаШК.Следующий() Тогда
			
			Штрихкод = ВыборкаШК.ШтрихКод;
			
			Пока СтрДлина(Штрихкод) < ДлинаШК Цикл
				Штрихкод = "0" + Штрихкод;
			КонецЦикла;
			
			Если СтрДлина(Штрихкод) > ДлинаШК Тогда
				Штрихкод = Лев(Штрихкод, ДлинаШК);
			КонецЕсли;
			
			Строка.GTIN = Штрихкод;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Строка.СпособЗаполненияСерийногоНомера) Тогда
		Строка.СпособЗаполненияСерийногоНомера =
				ПредопределенноеЗначение("Перечисление.СпособыЗаполненияСерийногоНомера.Автоматически");
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Характеристика номенклатуры" в таблице "Товары".
//
// Параметры:
//  Объект - ДанныеФормыСтруктура   - Объект, для которого выполняется обработка события.
//  Строка - Строка табличной части - Строка, при изменении поля которой возникло событие.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ТоварыХарактеристикаНоменклатурыПриИзменении(Объект, Строка, ПараметрыДействия = Неопределено) Экспорт
	
	// Заполним имя модели наименованием номенклатуры
	Если Объект.ТоварнаяГруппа = Справочники.ТипыМаркировки.ШиныИАвтопокрышки
		И Объект.СпособВыпускаВОборот = Перечисления.СпособыВыпускаВОборот.МаркировкаОстатков Тогда
		Строка.Модель = СтрШаблон("%1 %2", Строка.Номенклатура.Наименование, Строка.ХарактеристикаНоменклатуры.Наименование);
	КонецЕсли;
	
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	ОбработкаТабличнойЧастиТовары.ХарактеристикаНоменклатурыПриИзменении(Объект, Строка, ПараметрыДействия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЗаполненияОбъекта

// Производит формирование структуры с доступностью команд заполнения объекта
//
// Параметры:
//  Объект	 - ДанныеФормыСтруктура	 - Объект, для которого выполняется обработка события.
// 
// Возвращаемое значение:
//  Соответствие - Настройка доступности и видимости команд заполнения
//
Функция ПолучитьПараметрыКомандЗаполнения(Объект) Экспорт
	
	ДоступностьКоманд = Новый Соответствие;
	
	// Возвращаем сформированные параметры видимости и доступности команд проверки
	Возврат ДоступностьКоманд;
	
КонецФункции // ПолучитьДоступностьКомандЗаполнения()

#КонецОбласти

#Область Печать

// Переопределяет настройки печати для объекта.
//
// Параметры:
//  Настройки - см. УправлениеПечатью.НастройкиПечатиОбъекта.
//
Процедура ПриОпределенииНастроекПечати(Настройки) Экспорт
	
	Настройки.ПриДобавленииКомандПечати = Истина;
	
КонецПроцедуры

// Процедура используется для указания доступного данному виду объектов перечня вариантов печати.
//
// Параметры:
//  КомандыПечати - ТаблицаЗначений - Каждая строка таблицы соответствует одному из вариантов печати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	СсылкаНаДокумент = ПолучитьСсылку();
	УправлениеПечатьюПлатформа.ДобавитьКоманду(
		КомандыПечати,
		Неопределено,
		"Этикетки",
		НСтр("ru = 'Печать этикеток'"),
		СсылкаНаДокумент,
		"УправлениеПечатиЭтикетокИЦенниковКлиент.ПодготовкаПечати",
		, , , ,
		Ложь
	);
	
КонецПроцедуры

// Функция помещает необходимые данные в структуру. Структура помещается во временное хранилище.
//
// Параметры:
//  МассивДокументов - Массив - Массив документов для печати.
// 
// Возвращаемое значение:
//  Адрес - адрес структуры данных во временном хранилище.
//
Функция ПолучитьДанныеДляПечатиЭтикеток(МассивДокументов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КодыМаркировкиДляПечати.Номенклатура КАК Номенклатура,
	|	КодыМаркировкиДляПечати.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	КодыМаркировкиДляПечати.КодМаркировки КАК Штрихкод,
	|	КодыМаркировкиДляПечати.ДатаПечати КАК ДатаПечати,
	|	КодыМаркировкиДляПечати.ДокументОснование КАК ДокументОснование
	|ИЗ
	|	РегистрСведений.КодыМаркировкиДляПечати КАК КодыМаркировкиДляПечати
	|ГДЕ
	|	КодыМаркировкиДляПечати.ДокументОснование В(&МассивДокументов)
	|	И КодыМаркировкиДляПечати.КодМаркировки <> """"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаказКодовМаркировки.Организация КАК Организация,
	|	ЗаказКодовМаркировки.ПодразделениеКомпании КАК ПодразделениеКомпании
	|ИЗ
	|	Документ.ЗаказКодовМаркировки КАК ЗаказКодовМаркировки
	|ГДЕ
	|	ЗаказКодовМаркировки.Ссылка В(&МассивДокументов)";
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаРеквизитыДокументов = МассивРезультатов[1].Выгрузить();
	МассивОрганизаций = УправлениеДиалогомСервер
		.СвернутьТаблицуЗначенийПоРеквизиту(ТаблицаРеквизитыДокументов, "Организация").ВыгрузитьКолонку(0);
	МассивПодразделенийКомпании = УправлениеДиалогомСервер
		.СвернутьТаблицуЗначенийПоРеквизиту(ТаблицаРеквизитыДокументов, "ПодразделениеКомпании").ВыгрузитьКолонку(0);
	
	// Подготовка структуры действий для обработки печати ценников и этикеток
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьОрганизацию",
		?(МассивОрганизаций.Количество() = 1, МассивОрганизаций[0], Неопределено)
	);
	СтруктураДействий.Вставить("ЗаполнитьПодразделениеКомпании",
		?(МассивПодразделенийКомпании.Количество() = 1, МассивПодразделенийКомпании[0], Неопределено)
	);
	СтруктураДействий.Вставить("ПоказыватьКолонкуКоличествоВДокументе", Истина);
	СтруктураДействий.Вставить("УстановитьРежимПечатиИзДокумента");
	СтруктураДействий.Вставить("УстановитьРежим", "ПечатьЭтикеток");
	СтруктураДействий.Вставить("ЗаполнитьКоличествоЭтикетокПоДокументу");
	СтруктураДействий.Вставить("ЗаполнитьТаблицуТоваров");
	СтруктураДействий.Вставить("ПечатьКодовМаркировки");
	
	// Подготовка данных для заполнения табличной части обработки печати ценников и этикеток.
	СтруктураРезультат = Новый Структура;
	Товары = МассивРезультатов[0].Выгрузить();
	Товары.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"), "Организация");
	Товары.ЗаполнитьЗначения(СтруктураДействий.ЗаполнитьОрганизацию, "Организация");
	
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("Товары", Товары);
	СтруктураРезультат.Вставить("МассивДокументов", МассивДокументов);
	СтруктураРезультат.Вставить("СтруктураДействий", СтруктураДействий);
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураРезультат);
	
КонецФункции

#КонецОбласти

// Создает документы с разбивкой по 10 строк заказ на маркировку
//
// Параметры:
//  Основание	 - ДокументСсылка.ЗаказКодовМаркировки - Документ основание для разбивки заказа
//
Процедура СформироватьЗаказыНаКодыМаркировки(Основание) Экспорт
	
	Если ТипЗнч(Основание) <> Тип("ДокументОбъект.ЗаказКодовМаркировки") Тогда
		ДокументОбъект = Документы.ЗаказКодовМаркировки.СоздатьДокумент();
		ДокументОбъект.ДополнительныеСвойства.Вставить("НеПроверятьОграничениеСтрок");
		ДокументОбъект.Заполнить(Основание);
		ОснованиеДокумента = Основание;
	Иначе
		ДокументОбъект = Основание;
		ОснованиеДокумента = ДокументОбъект.ДокументОснование;
	КонецЕсли;
	
	// Разберем полученный документ на несколько по 10 строк
	КоличествоСтрок = ДокументОбъект.Товары.Количество();
	
	СписокДокументов = Новый Массив;
	
	НачатьТранзакцию();
	Попытка
		Пока КоличествоСтрок > 0 Цикл
			
			НовыйДокумент = Документы.ЗаказКодовМаркировки.СоздатьДокумент();
			НовыйДокумент.ДополнительныеСвойства.Вставить("НеПроверятьОграничениеСтрок");
			НовыйДокумент.Заполнить(ОснованиеДокумента);
			НовыйДокумент.УстановитьНовыйНомер();
			НовыйДокумент.Товары.Очистить();
			
			КоличествоНоменклатуры = Мин(ДокументОбъект.Товары.Количество(), 10);
			
			МассивУдалить = Новый Массив;
			
			Для Инд = 0 По (КоличествоНоменклатуры - 1) Цикл
				
				НоваяСтрока = НовыйДокумент.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ДокументОбъект.Товары[Инд]);
				
				МассивУдалить.Добавить(ДокументОбъект.Товары[Инд]);
				
			КонецЦикла;
			
			НовыйДокумент.ОбменДанными.Загрузка = Истина;
			НовыйДокумент.Записать(РежимЗаписиДокумента.Запись);
			СписокДокументов.Добавить(НовыйДокумент.Ссылка);
			
			КоличествоСтрок = КоличествоСтрок - КоличествоНоменклатуры;
			
			// Удалим заполненные строки
			Для Каждого ТекущаяСтрока Из МассивУдалить Цикл
				ДокументОбъект.Товары.Удалить(ТекущаяСтрока);
			КонецЦикла;
			
		КонецЦикла;
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Ошибка создания документа ""Заказ кодов маркировки""'",
			ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'При формировании заказа на маркировку обнаружена ошибка.'"));
		Возврат;
	КонецПопытки;
	
	Попытка
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Формирование заказов кодов маркировки отменено'"));
		Возврат;
	КонецПопытки;
	
	ОбщегоНазначения.СообщитьПользователю(
		НСтр("ru = 'Созданы по данному документы заказы на эмиссию кодов маркировки. Необходимо завершить заполнение документов и отправить запрос в Честный знак.'") // BSLLS:LineLength-off
		,,
		"ОтменитьОткрытие"
	);
	Для Каждого ТекущийДокумент Из СписокДокументов Цикл
		ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru = 'Создан документ %1'"), ТекущийДокумент.Ссылка), ТекущийДокумент);
	КонецЦикла;
	
КонецПроцедуры

#Область СозданиеНаОсновании

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	ОбъектыВводимыеНаОсновании = Новый Массив();
	ОбъектыВводимыеНаОсновании.Добавить(Документы.ВводВОборотКодовМаркировки);
	ОбъектыВводимыеНаОсновании.Добавить(Документы.ОтчетОНанесенииКодовМаркировки);
	
	Для Каждого ОбъектВводимыйНаОсновании Из ОбъектыВводимыеНаОсновании Цикл
	
		ОбъектВводимыйНаОсновании.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
		
	КонецЦикла;

КонецПроцедуры

// Заполняет список команд создания на основании.
//
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//	 КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Возврат СозданиеНаОснованииАльфаАвто.ДобавитьКомандуСозданияНаОсновании(КомандыСоздатьНаОсновании,
		Метаданные.Документы.ЗаказКодовМаркировки);

КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// 	 Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// СтандартныеПодсистемы.УправлениеДоступом
// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст = 
		"РазрешитьЧтениеИзменение
		|ГДЕ
		|	ЗначениеРазрешено(ПодразделениеКомпании)
		|	И ЗначениеРазрешено(Организация)";
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получение данных документа для заказов кода маркировки
//
// Параметры:
//  Объект	 - ДокументСсылка.ЗаказКодовМаркировки - Документ, для которого получаем данные
// 
// Возвращаемое значение:
//  Структура - Данные документа в формате для отправки запроса
//
Функция ДанныеЗапросаЗаказаКодов(Объект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ЗаказКодовМаркировки.Номер КАК Номер,
	               |	ЗаказКодовМаркировки.Дата КАК Дата,
	               |	ЗаказКодовМаркировки.Организация КАК Организация,
	               |	ЗаказКодовМаркировки.СпособВыпускаВОборот КАК СпособВыпускаВОборот,
	               |	ЗаказКодовМаркировки.Ответственный КАК Ответственный,
	               |	ЕСТЬNULL(ЗаказКодовМаркировки.Ответственный.Наименование, """") КАК ОтветственныйНаименование,
	               |	ЗаказКодовМаркировки.НомерДоговораСОператором КАК НомерДоговораСОператором,
	               |	ЗаказКодовМаркировки.ДатаДоговораСОператором КАК ДатаДоговораСОператором,
	               |	ЗаказКодовМаркировки.ИдентификаторПроизводственногоЗаказа КАК ИдентификаторПроизводственногоЗаказа,
	               |	ЗаказКодовМаркировки.ТоварнаяГруппа.ТоварнаяГруппа КАК ВидПродукции,
	               |	ЗаказКодовМаркировки.ВвозПослеДатыОбязательнойМаркировки КАК ВвозПослеДатыОбязательнойМаркировки,
	               |	ЗаказКодовМаркировки.ТоварнаяГруппа КАК ТоварнаяГруппа,
	               |	ЗаказКодовМаркировки.ИдентификаторПроизводства КАК ИдентификаторПроизводства,
	               |	ЗаказКодовМаркировки.НаименованиеПроизводства КАК НаименованиеПроизводства,
	               |	ЗаказКодовМаркировки.АдресПроизводства КАК АдресПроизводства,
	               |	ЗаказКодовМаркировки.СтранаПроизводителя.Наименование КАК СтранаПроизводителя,
	               |	ЗаказКодовМаркировки.ИдентификаторПроизводственнойЛинии КАК ИдентификаторПроизводственнойЛинии,
	               |	ЗаказКодовМаркировки.КодПродукта КАК КодПродукта,
	               |	ЗаказКодовМаркировки.ОписаниеПродукта КАК ОписаниеПродукта,
	               |	ЗаказКодовМаркировки.НомерПроизводственногоЗаказа КАК НомерПроизводственногоЗаказа,
	               |	ЗаказКодовМаркировки.ДатаНачалаПроизводстваПродукции КАК ДатаНачалаПроизводстваПродукции,
	               |	ЗаказКодовМаркировки.ТипОплаты КАК ТипОплаты
	               |ИЗ
	               |	Документ.ЗаказКодовМаркировки КАК ЗаказКодовМаркировки
	               |ГДЕ
	               |	ЗаказКодовМаркировки.Ссылка = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ЗаказКодовМаркировкиТовары.GTIN КАК GTIN,
	               |	ЗаказКодовМаркировкиТовары.Количество КАК Количество,
	               |	ЗаказКодовМаркировкиТовары.СпособЗаполненияСерийногоНомера КАК СпособЗаполненияСерийногоНомера,
	               |	ЗаказКодовМаркировкиТовары.Ссылка.ТоварнаяГруппа.КодТоварнойГруппы КАК ШаблонЭтикетки,
	               |	ЗаказКодовМаркировкиТовары.ИдентификаторСтроки КАК ИдентификаторСтроки,
	               |	ЗаказКодовМаркировкиТовары.МаксимальнаяРозничнаяЦена КАК МаксимальнаяРозничнаяЦена
	               |ИЗ
	               |	Документ.ЗаказКодовМаркировки.Товары КАК ЗаказКодовМаркировкиТовары
	               |ГДЕ
	               |	ЗаказКодовМаркировкиТовары.Ссылка = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ЗаказКодовМаркировкиСерийныеНомераКодовМаркировки.ИдентификаторСтроки КАК ИдентификаторСтроки,
	               |	ЗаказКодовМаркировкиСерийныеНомераКодовМаркировки.СерийныйНомерМаркировки КАК СерийныйНомерМаркировки
	               |ИЗ
	               |	Документ.ЗаказКодовМаркировки.СерийныеНомераКодовМаркировки КАК ЗаказКодовМаркировкиСерийныеНомераКодовМаркировки
	               |ГДЕ
	               |	ЗаказКодовМаркировкиСерийныеНомераКодовМаркировки.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Объект);
	
	РезультатЗапросаДокумента = Запрос.ВыполнитьПакет();
	
	ШапкаДокумента = РезультатЗапросаДокумента[0].Выбрать();
	Товары = РезультатЗапросаДокумента[1].Выгрузить();
	СерийныеНомера = РезультатЗапросаДокумента[2].Выгрузить();
	
	ШапкаДокумента.Следующий();
	
	ЭтоТабак =
		МаркировкаТоваровКлиентСервер.ТоварныеГруппыТабачнойПродукции().Найти(ШапкаДокумента.ВидПродукции) <>
			Неопределено;
	
	ТекстСообщения = Новый Структура;
	Если ЭтоТабак Тогда
		ТекстСообщения.Вставить("factoryId", ШапкаДокумента.ИдентификаторПроизводства);
		Если Не ПустаяСтрока(ШапкаДокумента.НаименованиеПроизводства) Тогда
			ТекстСообщения.Вставить("factoryName", ШапкаДокумента.НаименованиеПроизводства);
		КонецЕсли;
		Если Не ПустаяСтрока(ШапкаДокумента.АдресПроизводства) Тогда
			ТекстСообщения.Вставить("factoryAddress", ШапкаДокумента.АдресПроизводства);
		КонецЕсли;
		ТекстСообщения.Вставить("factoryCountry", ШапкаДокумента.СтранаПроизводителя);
		ТекстСообщения.Вставить("productionLineId", ШапкаДокумента.ИдентификаторПроизводственнойЛинии);
		ТекстСообщения.Вставить("productCode", ШапкаДокумента.КодПродукта);
		ТекстСообщения.Вставить("productDescription", ШапкаДокумента.ОписаниеПродукта);
		Если Не ПустаяСтрока(ШапкаДокумента.НомерПроизводственногоЗаказа) Тогда
			ТекстСообщения.Вставить("poNumber", ШапкаДокумента.НомерПроизводственногоЗаказа);
		КонецЕсли;
		Если ШапкаДокумента.ДатаНачалаПроизводстваПродукции <> Дата(1,1,1) Тогда
			ТекстСообщения.Вставить(
				"expectedStartDate",
				Формат(ШапкаДокумента.ДатаНачалаПроизводстваПродукции, "ДФ=yyyy-MM-dd"));
			КонецЕсли;
	Иначе
		ТекстСообщения.Вставить("contactPerson", ШапкаДокумента.ОтветственныйНаименование);
		ТекстСообщения.Вставить("releaseMethodType",
			ОбменССистемойМаркировкиСервер.СпособВыпускаВОборот(ШапкаДокумента.СпособВыпускаВОборот)
		);
		ТекстСообщения.Вставить("createMethodType", "SELF_MADE");
		ТекстСообщения.Вставить("productionOrderId", ШапкаДокумента.ИдентификаторПроизводственногоЗаказа);
		Если ЗначениеЗаполнено(ШапкаДокумента.ДатаДоговораСОператором) Тогда
			ТекстСообщения.Вставить("contractDate", Формат(ШапкаДокумента.ДатаДоговораСОператором, "ДФ=yyyy-MM-dd"));
		КонецЕсли;
		Если ЗначениеЗаполнено(ШапкаДокумента.НомерДоговораСОператором) Тогда
			ТекстСообщения.Вставить("contractNumber", ШапкаДокумента.НомерДоговораСОператором);
		КонецЕсли;
	КонецЕсли;
	
	ЭтоЛегПром = (ШапкаДокумента.ТоварнаяГруппа = Справочники.ТипыМаркировки.ЛегкаяПромышленность);
	Если ЭтоЛегПром
		И ШапкаДокумента.СпособВыпускаВОборот = Перечисления.СпособыВыпускаВОборот.МаркировкаОстатков Тогда
		ТекстСообщения.Вставить("remainsAvailable", "true");
		ТекстСообщения.Вставить("remainsImport", ?(ШапкаДокумента.ВвозПослеДатыОбязательнойМаркировки, "true", "false"));
	КонецЕсли;
	
	ЭтоВода = МаркировкаТоваровКлиентСервер.ЭтоТоварнаяГруппаУпакованнойВоды(ШапкаДокумента.ВидПродукции);
	Если ЭтоВода Тогда
		ТекстСообщения.Вставить("paymentType", ТипОплатыЗаказа(ШапкаДокумента.ТипОплаты));
	КонецЕсли;
	
	УказыватьЕдиницу = 
		ЭтоЛегПром
		ИЛИ ЭтоВода
		ИЛИ (ШапкаДокумента.ТоварнаяГруппа = Справочники.ТипыМаркировки.Парфюмерия)
		ИЛИ МаркировкаТоваровКлиентСервер.ЭтоТоварнаяГруппаМолочнаяПродукция(ШапкаДокумента.ВидПродукции);
	
	ТекстСообщения.Вставить("products", Новый Массив);
	
	Для Каждого СтрокаТовара Из Товары Цикл
		
		СтрокаЗаказа = Новый Структура;
		
		СтрокаЗаказа.Вставить("gtin", СтрокаТовара.GTIN);
		СтрокаЗаказа.Вставить("quantity", Строка(СтрокаТовара.Количество));
		СтрокаЗаказа.Вставить("serialNumberType",
			ОбменССистемойМаркировкиСервер.СпособЗаполненияСерийныхНомеров(СтрокаТовара.СпособЗаполненияСерийногоНомера));
		
		Если УказыватьЕдиницу Тогда
			СтрокаЗаказа.Вставить("cisType", "UNIT"); // Единица товара
		КонецЕсли;
		
		Если ЭтоТабак Тогда
			СтрокаЗаказа.Вставить("mrp", СтрЗаменить(Строка(СтрокаТовара.МаксимальнаяРозничнаяЦена * 100), Символы.НПП, ""));
		КонецЕсли;
		
		СтрокаЗаказа.Вставить("templateId", СтрокаТовара.ШаблонЭтикетки);
		
		Если
			СтрокаТовара.СпособЗаполненияСерийногоНомера = Перечисления.СпособыЗаполненияСерийногоНомера.Ручной
		Тогда
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("ИдентификаторСтроки", СтрокаТовара.ИдентификаторСтроки);
			СтрокаЗаказа.Вставить(
				"serialNumbers",
				СерийныеНомера.Скопировать(СтруктураПоиска).ВыгрузитьКолонку("СерийныйНомерМаркировки")
			);
		КонецЕсли;
		
		ТекстСообщения.products.Добавить(СтрокаЗаказа);
		
	КонецЦикла;
	
	Возврат ТекстСообщения;
	
КонецФункции

Функция ЗапросДокумента(Объект, ПараметрыОбмена, Сообщение) Экспорт
	
	Если ПараметрыОбмена.Действие = "ОтправкаЗапросаНаПолучениеКодовМаркировки" Тогда
		СтруктураСообщения = ДанныеЗапросаЗаказаКодов(Объект);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат СтруктураСообщения;
	
КонецФункции

// Проверить доступность выбора способа ввода "Принят на комиссию от физического лица"
//
// Параметры:
//  ТоварнаяГруппа	 - СправочникСсылка.ТипыМаркировки - Тип маркировки для проверки.
// 
// Возвращаемое значение:
//  Булево - Признак того, что данный способ ввода доступен для выбора.
//
Функция ДоступенСпособПринятНаКомиссиюОтФизическогоЛица(ТоварнаяГруппа) Экспорт
	
	ТоварныеГруппыПередачи = Новый Массив;
	ТоварныеГруппыПередачи.Добавить(Справочники.ТипыМаркировки.ОбувныеТовары);
	ТоварныеГруппыПередачи.Добавить(Справочники.ТипыМаркировки.ЛегкаяПромышленность);
	
	Возврат ТоварныеГруппыПередачи.Найти(ТоварнаяГруппа) <> Неопределено;
	
КонецФункции

// Проверить недоступность выбора способа ввода "Маркировка остатков"
//
// Параметры:
//  ТоварнаяГруппа	 - СправочникСсылка.ТипыМаркировки - Тип маркировки для проверки.
// 
// Возвращаемое значение:
//  Булево - Признак того, что данный способ ввода доступен для выбора.
//
Функция НеДоступенСпособМаркировкаОстатков(ТоварнаяГруппа) Экспорт
	
	ТоварнаяГруппаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТоварнаяГруппа, "ТоварнаяГруппа");
	
	ТоварныеГруппыПередачи = Новый Массив;
	ТоварныеГруппыПередачи.Добавить("water");
	
	Возврат ТоварныеГруппыПередачи.Найти(НРег(ТоварнаяГруппаДокумента)) <> Неопределено;
	
КонецФункции

Функция ТипОплатыЗаказа(ТипОплаты)
	
	ДоступныеТипыОплаты = Новый Соответствие;
	ДоступныеТипыОплаты.Вставить(Перечисления.ТипыОплатыЗаказаКодовМаркировки.ОплатаПоЭмиссии, "1");
	ДоступныеТипыОплаты.Вставить(Перечисления.ТипыОплатыЗаказаКодовМаркировки.ОплатаПоНанесению, "2");
	
	ПолученныйТипОплаты = ДоступныеТипыОплаты.Получить(ТипОплаты);
	
	Возврат ?(ПолученныйТипОплаты = Неопределено, "2", ПолученныйТипОплаты);
	
КонецФункции

#КонецОбласти

#КонецЕсли