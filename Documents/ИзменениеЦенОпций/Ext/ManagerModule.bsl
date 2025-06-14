﻿// Модуль менеджера документа "Изменение цен опций"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы. 
//
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

// Производит расчет значений итоговых показателей по операции в целом.
//
// Параметры:
//  Объект      - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  Расширенные - Булево               - Признак получения расширенных сведений об итогах операци.
//
Функция РассчитатьИтогиОперации(Объект, Расширенные=ЛОЖЬ) Экспорт
	
	// Формируем перечень основной информации об итогах операции
	ИтогиОперации = Новый Структура();
	ИтогиОперации.Вставить("СуммаДокумента", 0);
	
	// Возвращаем сведения об итогах операции
	Возврат ИтогиОперации;
	
КонецФункции // РассчитатьИтогиОперации()

// Используеся в механизме взаимодействий. Формирует текст запроса по контактам предмета взаимодействия.
//
// Параметры:
//  Ссылка - Ссылка - Содержит ссылку на передаваемый объект метаданных.
//  ИмяТаблицы             - Строка    - Полное имя объекта метаданных.
//  ТекстВременнаяТаблица  - Строка    - Строка в которой может находиться часть текста запроса, которая отвечает за
//                                       помещение результата запроса во временную таблицу.
//  Объединить             - Булево    - Признак который указывает на режим формирования запроса. В случае, если данный
//                                       параметр имеет значение Истина, то формируемый в функции запрос являются частью
//                                       другого запроса и должен начинаться с конструкции ОБЪЕДИНИТЬ.
//  ТолькоОсновныеКонтакты - Булево    - Признак который указывает на необходимость выводв только основных контактов.
//
// Возвращаемое значение:
//  Строка - Возращаемая сторка содержащая в себе текст запроса по контактам предмета взаимодействий.
//
Функция ПолучитьТекстЗапросаПоКонтактам(Ссылка, ТекстВременнаяТаблица = "", Объединить = ЛОЖЬ, ТолькоОсновныеКонтакты = ИСТИНА) Экспорт
	
	// Вызываем общий обработчик действия
	Параметры = Новый Структура;
	Параметры.Вставить("ТекстВременнаяТаблица", ТекстВременнаяТаблица);
	Параметры.Вставить("Объединить", Объединить);
	Параметры.Вставить("ТолькоОсновныеКонтакты", ТолькоОсновныеКонтакты);
	
	Возврат УправлениеДиалогомСервер.ПолучитьТекстЗапросаПоКонтактам(Ссылка, Параметры);
	
КонецФункции //ПолучитьТекстЗапросаПоКонтактам()

// Заполнение базовой цены в строке табличной части
//
// Параметры:
//	Объект - Документ объект или объект формы - объект заполнения
//	Строка - Строка табличной части в которой заполняется базовая цена.
//
Процедура ЗаполнитьБазовуюЦену(Объект, Строка) Экспорт
	
	ДокументОбъектСтруктура=Новый Структура();
	
	ДокументОбъектСтруктура.Вставить("Ссылка"            , Объект.Ссылка);
	ДокументОбъектСтруктура.Вставить("Дата"              , Объект.Дата);
	ДокументОбъектСтруктура.Вставить("МоментВремени"     , ?(Объект.Ссылка.Пустая(), Объект.Дата, Объект.Ссылка.МоментВремени()));
	ДокументОбъектСтруктура.Вставить("ВалютаДокумента"   , Объект.ВалютаДокумента);
	ДокументОбъектСтруктура.Вставить("КурсДокумента"     , Объект.КурсДокумента);
	ДокументОбъектСтруктура.Вставить("РасчетЦенОт"       , Объект.РасчетЦенОт);
	ДокументОбъектСтруктура.Вставить("БазовыйТипЦен"     , Объект.БазовыйТипЦен);
	ДокументОбъектСтруктура.Вставить("ДокументОснование" , Объект.ДокументОснование);
	ДокументОбъектСтруктура.Вставить("ТипЦен"            , Объект.ТипЦен);
	
	ДокументОбъектСтрока=Новый Структура();
	Для каждого РеквизитТабличнойЧасти Из Объект.Ссылка.Метаданные().ТабличныеЧасти.Опции.Реквизиты Цикл
		ДокументОбъектСтрока.Вставить(РеквизитТабличнойЧасти.Имя,Строка[РеквизитТабличнойЧасти.Имя]);
	КонецЦикла; 
	
	ЗащищенныеФункцииАльфаАвтоСервер.ИзменениеЦенОпцийЗаполнитьБазовуюЦену(ДокументОбъектСтруктура,ДокументОбъектСтрока);
	
	Для каждого РеквизитТабличнойЧасти Из ДокументОбъектСтрока Цикл
		Строка[РеквизитТабличнойЧасти.Ключ]=РеквизитТабличнойЧасти.Значение;
	КонецЦикла; 
	
КонецПроцедуры // ЗаполнитьБазовуюЦену()

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
	ОбязательныеРеквизиты=Новый Массив();
	ОбязательныеРеквизиты.Добавить("Организация");
	ОбязательныеРеквизиты.Добавить("ПодразделениеКомпании");
	ОбязательныеРеквизиты.Добавить("Автор");
	ОбязательныеРеквизиты.Добавить("ВалютаДокумента");
	ОбязательныеРеквизиты.Добавить("КурсДокумента");
	ОбязательныеРеквизиты.Добавить("ДатаНачалаДействия");
	ОбязательныеРеквизиты.Добавить("ТипЦен");
	ОбязательныеРеквизиты.Добавить("ХозОперация");
	
	Если НЕ ПраваИНастройкиПользователя.Значение("ПроведениеНезаполненныхДокументов", Объект) Тогда
		ОбязательныеРеквизиты.Добавить("Опции");
	КонецЕсли;
	ОбязательныеРеквизиты.Добавить("Опции.Модель");
	ОбязательныеРеквизиты.Добавить("Опции.Опция");
	ОбязательныеРеквизиты.Добавить("Опции.Цена");
	
	// Возвращаем сформированные параметры проверки
	Возврат ОбязательныеРеквизиты;
	
КонецФункции // ПолучитьОбязательныеРеквизиты()

// Производит формирование параметров проверки заполнения реквизитов объекта на предмет обязательности и уникальности.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - Объект, для которого выполняется получение параметров проверки.
//
// Возвращаемое значение:
//  Структура - Возвращаемая структура содержит строковые идентификаторы реквизитов и вариант проверки его заполнения
//  (1-Обязательный, 2-Уникальный, 3-Уникальный и обязательный). Для описания проверки табличных частей используется
//  вложенная структура.
//
Функция ПолучитьУникальныеРеквизиты(Объект) Экспорт
	
	// Уникальные поля таблицы товаров
	УникальныеОпции = Новый Массив();
	УникальныеОпции.Добавить("Опция");
	УникальныеОпции.Добавить("ВариантКомплектации");
	УникальныеОпции.Добавить("Модель");
	
	// Структура уникальных реквизитов табличных частей
	УникальныеРеквизиты = Новый Структура();
	УникальныеРеквизиты.Вставить("Опции", УникальныеОпции);
	
	// Возвращаем сформированные параметры проверки
	Возврат УникальныеРеквизиты;
	
КонецФункции // ПолучитьУникальныеРеквизиты()

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
	
	// Структура параметров проверки реквизитов объекта
	КонтролируемыеРеквизиты = Новый Структура();
	
	// Возвращаем сформированные параметры проверки
	Возврат КонтролируемыеРеквизиты;
	
КонецФункции // ПолучитьРеквизитыКонтроляПоОрганизации()

#КонецОбласти

#Область ОбработчикиИзмененияДанныхОбъекта

// Возвращает предопределенную структуру действий
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Функция ПолучитьПараметрыДействия(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	Если ПараметрыДействия=Неопределено Тогда
		ПараметрыДействия = Новый Структура;
	КонецЕсли;
	
	// Производим добавление параметров расширяемых контекст обработки событий объекта
	ПараметрыДействия.Вставить("ОбъектЗаполнен", Объект.Опции.Количество() > 0);
	
	Возврат ПараметрыДействия;
	
КонецФункции // ПолучитьПараметрыДействия()

// Обработчик события пересчета зависимых показателей объекта при изменении значений ведущих реквизитов.
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ОбработкаПересчетаПоказателейОбъекта(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	
	ТребуетсяУстановкаЦен = ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "ТребуетсяУстановкаЦен", Ложь);
	ТребуетсяПересчетЦен  = ПолучитьЗначениеПараметраСтруктуры(ПараметрыДействия, "ТребуетсяПересчетЦен",  Ложь);
	
	Если ТребуетсяУстановкаЦен ИЛИ ТребуетсяПересчетЦен Тогда
		ПараметрыДействия.Вставить("ТребуетсяУстановкаЦен", Ложь);
		ПараметрыДействия.Вставить("ТребуетсяПересчетЦен",  Ложь);
		Для Каждого Строка Из Объект.Опции Цикл
			ЗаполнитьБазовуюЦену(Объект, Строка);
			ОпцииПроцентНаценкиПриИзменении(Объект, Строка);
		КонецЦикла;
	КонецЕсли;
	
	// Вызываем общий обработчик действия
	ОбработкаРеквизитовДокументаСервер.ОбработкаПересчетаПоказателейОбъекта(Объект, ПараметрыДействия);
	
КонецПроцедуры // ОбработкаПересчетаПоказателейОбъекта()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Обработчик события возникающего при изменении данных реквизита "Дата".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ДатаПриИзменении(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);

	// Вызываем общий обработчик события
	ОбработкаРеквизитовДокументаСервер.ДатаПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Документ основание".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ДокументОснованиеПриИзменении(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);

	// Вызываем общий обработчик события
	ОбработкаРеквизитовДокументаСервер.ДокументОснованиеПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Подразделение компании".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ПодразделениеКомпанииПриИзменении(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);

	// Вызываем общий обработчик события
	ОбработкаРеквизитовДокументаСервер.ПодразделениеКомпанииПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры // ПодразделениеКомпанииПриИзменении()

// Обработчик события возникающего при изменении данных реквизита "Организация".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ОрганизацияПриИзменении(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);

	// Вызываем общий обработчик события
	ОбработкаРеквизитовДокументаСервер.ОрганизацияПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры // ОрганизацияПриИзменении()

// Обработчик события возникающего при изменении данных реквизита "Автор".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура АвторПриИзменении(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);

	// Вызываем общий обработчик события
	ОбработкаРеквизитовДокументаСервер.АвторПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры // АвторПриИзменении()

// Обработчик события возникающего при изменении данных реквизита "Проект".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ПроектПриИзменении(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);

	// Вызываем общий обработчик события
	ОбработкаРеквизитовДокументаСервер.ПроектПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры // ПроектПриИзменении()

// Обработчик события возникающего при изменении данных реквизита "Хоз. операция".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ХозОперацияПриИзменении(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);

	// Вызываем общий обработчик события
	ОбработкаРеквизитовДокументаСервер.ХозОперацияПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры // ХозОперацияПриИзменении()

// Обработчик события возникающего при изменении данных реквизита "Тип цен".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ТипЦенПриИзменении(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	// Тип цен не должен быть рассчитываемым 
	Если Объект.ТипЦен.Рассчитывается Тогда
		Объект.ТипЦен = Справочники.ТипыЦен.ПустаяСсылка();
		ТекстСообщения = НСтр("ru = 'Тип цен не должен быть рассчитываемым.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,Объект.Ссылка);
		Возврат;
	КонецЕсли;
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);

	// Вызываем общий обработчик события
	ОбработкаРеквизитовДокументаСервер.ТипЦенПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры // ТипЦенПриИзменении()

// Обработчик события возникающего при изменении данных реквизита "Валюта".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ВалютаДокументаПриИзменении(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);

	// Вызываем общий обработчик события
	ОбработкаРеквизитовДокументаСервер.ВалютаДокументаПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры // ВалютаДокументаПриИзменении()

// Обработчик события возникающего при изменении данных реквизита "Курс документа".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура КурсДокументаПриИзменении(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);

	// Вызываем общий обработчик события
	ОбработкаРеквизитовДокументаСервер.КурсДокументаПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры // КурсДокументаПриИзменении()

// Обработчик события возникающего при изменении данных реквизита "Курс валюты взаиморасчетов".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура КурсВалютыВзаиморасчетовПриИзменении(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);

	// Вызываем общий обработчик события
	ОбработкаРеквизитовДокументаСервер.КурсВалютыВзаиморасчетовПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры // КурсВалютыВзаиморасчетовПриИзменении()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОпции

// Обработчик события возникающего при изменении данных реквизита "Автомобиль" в таблице "Опции".
//
// Параметры:
//  Объект - ДанныеФормыСтруктура   - Объект, для которого выполняется обработка события.
//  Строка - Строка табличной части - Строка, при изменении поля которой возникло событие.
//
Процедура ОпцииОпцияПриИзменении(Объект, Строка, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	
	Если ЗначениеЗаполнено(Строка.Опция) Тогда
		
		// получим базовую цену
		ЗаполнитьБазовуюЦену(Объект, Строка);
		
		Если Объект.ПроцентНаценки = 0 Тогда
			Строка.ПроцентНаценки = Объект.БазовыйТипЦен.ПроцентСкидкиНаценки;
		Иначе
			Строка.ПроцентНаценки = Объект.ПроцентНаценки;
		КонецЕсли;
		
		Строка.Цена         = Строка.ЦенаБазовая + ((Строка.ЦенаБазовая*Строка.ПроцентНаценки)/100);
		Строка.СуммаНаценки = Строка.Цена - Строка.ЦенаБазовая;
		
	КонецЕсли;
	
КонецПроцедуры // АвтомобилиАвтомобильПриИзменении()

// Обработчик события возникающего при изменении данных реквизита "Вариант комплектации" в таблице "Опции".
//
// Параметры:
//  Объект - ДанныеФормыСтруктура   - Объект, для которого выполняется обработка события.
//  Строка - Строка табличной части - Строка, при изменении поля которой возникло событие.
//
Процедура ОпцииВариантКомплектацииПриИзменении(Объект, Строка, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	
	Если НЕ ЗначениеЗаполнено(Строка.Модель) Тогда 
		Возврат; 
	КонецЕсли;
	
	Если (ЗначениеЗаполнено(Строка.ВариантКомплектации)) И
		 (Строка.ВариантКомплектации.Владелец<>Строка.Модель) Тогда
		 Строка.ВариантКомплектации = Неопределено;
	КонецЕсли;
	
	ОпцииОпцияПриИзменении(Объект, Строка, ПараметрыДействия);
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Вариант комплектации" в таблице "Опции".
//
// Параметры:
//  Объект - ДанныеФормыСтруктура   - Объект, для которого выполняется обработка события.
//  Строка - Строка табличной части - Строка, при изменении поля которой возникло событие.
//
Процедура ОпцииМодельПриИзменении(Объект, Строка, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	
	Если НЕ ЗначениеЗаполнено(Строка.Модель) Тогда 
		Возврат; 
	КонецЕсли;
	
	Если (ЗначениеЗаполнено(Строка.ВариантКомплектации)) И
		 (Строка.ВариантКомплектации.Владелец<>Строка.Модель) Тогда
		 Строка.ВариантКомплектации = Неопределено;
	КонецЕсли;
	
	ОпцииОпцияПриИзменении(Объект, Строка, ПараметрыДействия);
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Цена" в таблице "Опции".
//
// Параметры:
//  Объект - ДанныеФормыСтруктура   - Объект, для которого выполняется обработка события.
//  Строка - Строка табличной части - Строка, при изменении поля которой возникло событие.
//
Процедура ОпцииЦенаПриИзменении(Объект, Строка, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	
	Строка.ПроцентНаценки = ?(Строка.ЦенаБазовая = 0, 0, ((Строка.Цена - Строка.ЦенаБазовая)/Строка.ЦенаБазовая)*100);
	Строка.СуммаНаценки   = Строка.Цена - Строка.ЦенаБазовая;
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Процент наценки" в таблице "Опции".
//
// Параметры:
//  Объект - ДанныеФормыСтруктура   - Объект, для которого выполняется обработка события.
//  Строка - Строка табличной части - Строка, при изменении поля которой возникло событие.
//
Процедура ОпцииПроцентНаценкиПриИзменении(Объект, Строка, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	
	Строка.Цена         = Строка.ЦенаБазовая + ((Строка.ЦенаБазовая*Строка.ПроцентНаценки)/100);
	Строка.СуммаНаценки = Строка.Цена - Строка.ЦенаБазовая;
	
	//округляем
	НоваяЦена = Строка.Цена;
	ДельтаОкругления    = ?(Объект.ОкруглятьДо = 0, 0, НоваяЦена/Объект.ОкруглятьДо);
	ДельтаОкругленияЦел = Цел(ДельтаОкругления);
	Если ДельтаОкругления <> ДельтаОкругленияЦел Тогда
		НоваяЦена = (ДельтаОкругленияЦел + 1)*Объект.ОкруглятьДо;
	КонецЕсли;
	Если НоваяЦена <> Строка.Цена Тогда
		Строка.Цена = НоваяЦена;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Сумма наценки" в таблице "Опции".
//
// Параметры:
//  Объект - ДанныеФормыСтруктура   - Объект, для которого выполняется обработка события.
//  Строка - Строка табличной части - Строка, при изменении поля которой возникло событие.
//
Процедура ОпцииСуммаНаценкиПриИзменении(Объект, Строка, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	
	Строка.Цена           = Строка.ЦенаБазовая + Строка.СуммаНаценки;
	Строка.ПроцентНаценки = ?(Строка.ЦенаБазовая = 0, 0, ((Строка.Цена - Строка.ЦенаБазовая)/Строка.ЦенаБазовая)*100);
	
	//округляем
	НоваяЦена = Строка.Цена;
	ДельтаОкругления    = ?(Объект.ОкруглятьДо=0, 0, НоваяЦена/Объект.ОкруглятьДо);
	ДельтаОкругленияЦел = Цел(ДельтаОкругления);
	
	Если ДельтаОкругления <> ДельтаОкругленияЦел Тогда
		НоваяЦена = (ДельтаОкругленияЦел + 1)*Объект.ОкруглятьДо;
	КонецЕсли;
	
	Если НоваяЦена <> Строка.Цена Тогда
		Строка.Цена = НоваяЦена;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЗаполненияОбъекта

// Процедура используется для указания доступного данному виду объектов перечня вариантов заполнения.
//
// Параметры:
//  КомандыЗаполнения - ТаблицаЗначений - Каждая строка таблицы соответствует одному из вариантов заполнения.
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт

	ЗаполнениеОбъектовАльфаАвто.ДобавитьКомандуОчиститкиТабличнойЧасти(КомандыЗаполнения, "Опции");
	
	ОтображатьЗаполнитьИзФайла = ПраваИНастройкиПользователя.Значение("ОтображатьЗаполнитьИзФайла", "ИзменениеЦенОпций");
	Если ОтображатьЗаполнитьИзФайла Тогда
		ЗаполнениеОбъектовАльфаАвто.ДобавитьКомандуЗаполненияТабличнойЧастиИзФайла(КомандыЗаполнения, "Опции");
	КонецЕсли;
	
	ВыборКомплектации 				= ПоследовательныеОперацииКлиентСервер.НовыйВыборСсылки();
	ВыборКомплектации.ВыборСсылки 	= "Документ.ИзменениеЦенОпций.Форма.ФормаЗаполненияОпциями";
	ВыборКомплектации.Обязательный 	= Истина;
	
	Команда 				= ЗаполнениеОбъектовАльфаАвто.ДобавитьКоманду(КомандыЗаполнения);
	Команда.Подменю			= "ОпцииПодменюЗаполнения";
	Команда.Представление	= НСтр("ru = 'Заполнить опциями вариантов комплектации автомобилей'");
	Команда.Идентификатор	= "Подключаемый_ОпцииЗаполнитьОпциямиВариантовКомплектации";
	Команда.ДополнительныеПараметры.ИмяТабличнойЧасти = "Опции";
	Команда.ДополнительныеПараметры.ПоследовательныеОперации.Вставить("ВариантыКомплектации", ВыборКомплектации);
	
КонецПроцедуры

// Производит формирование структуры с доступностью и видимостью команд заполнения объекта.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//
Функция ПолучитьПараметрыКомандЗаполнения(Объект) Экспорт
	
	// Команды заполнения могут быть недоступны и/или невидимы в зависимости от параметров объекта.
	ПараметрыКоманд = Новый Соответствие;
	ПараметрыКоманд.Вставить("Подключаемый_ОпцииЗаполнитьОпциямиВариантовКомплектации.Видимость",   Истина);
	ПараметрыКоманд.Вставить("Подключаемый_ОпцииЗаполнитьОпциямиВариантовКомплектации.Доступность", Истина);
	
	// Возвращаем сформированные параметры видимости и доступности команд проверки
	Возврат ПараметрыКоманд;
	
КонецФункции // ПолучитьПараметрыКомандЗаполнения()

// Обработчик заполнения документа по заказам контрагенту
//
Функция Подключаемый_ОпцииЗаполнитьОпциямиВариантовКомплектации(Ссылка, ПараметрыКоманды, ПараметрыДействия = Неопределено) Экспорт

	ПараметрыЗаполнения = ПараметрыКоманды.ОписаниеКоманды.ДополнительныеПараметры.ПараметрыВыполненияКоманды;
	Объект				= ПараметрыКоманды.Источник;
												   
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	УсловиеПоискаСтроки = Новый Структура("Модель,ВариантКомплектации,Опция");
	
	Для Каждого Строка Из ПараметрыЗаполнения.ВариантыКомплектации Цикл
		
		ЗаполнитьЗначенияСвойств(УсловиеПоискаСтроки, Строка);
		
		Если Объект.Опции.НайтиСтроки(УсловиеПоискаСтроки).Количество() = 0 Тогда
			
			НоваяСтрока = Объект.Опции.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			ОпцииОпцияПриИзменении(Объект, НоваяСтрока, ПараметрыДействия);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

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
	УправлениеПечатьюПлатформа.ДобавитьКоманду(КомандыПечати,
		"Документ.ИзменениеЦенОпций",
		"ИзменениеЦенОпций",
		НСтр("ru = 'Изменение цен опций'"),
		СсылкаНаДокумент);
	
КонецПроцедуры // ДобавитьКомандыПечати()

// Обработчик печати документа
//
// Параметры:
//  МассивОбъектов         - Массив           - массив объектов для формирования печатных форм
//  ПараметрыПечати        - Структура        - дополнительные параметры печати
//  КоллекцияПечатныхФорм  - Таблица значений - таблица с идентификаторами печатных форм и макетами печати
//  ОбъектыПечати          - Структура        - список областьей печатной формы в разрезе документов
//  ПараметрыВывода        - Структура        - дополнительтые параметры вывода формы.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИзменениеЦенОпций") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
															"ИзменениеЦенОпций",
															"Изменение цен опций",
															ПечатьИзменениеЦенОпций(МассивОбъектов, ОбъектыПечати));
															
	КонецЕсли;
	
КонецПроцедуры // Печать()

// Формирует печатную форму "ИзменениеЦенОпций"
// Возвращает сформированный табличный документ:
Функция ПечатьИзменениеЦенОпций(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	// Добавим установку параметров печати
	ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИзменениеЦенОпций_ИзменениеЦенОпций";
	УправлениеПечатьюПлатформа.УстановитьСтандартныеПараметрыПечати(ИмяПараметровПечати, ТабличныйДокумент);
	ТабличныйДокумент.ИмяПараметровПечати = ИмяПараметровПечати;

	ПервыйДокумент = Истина;
	Для Каждого Документ Из МассивОбъектов Цикл
		Если НЕ ПервыйДокумент Тогда // новый документ должен быть на дотдельной странице
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИзменениеЦенОпций.ПФ_MXL_ИзменениеЦенОпций");
		
		ФорматВыводаСуммы      = УправлениеПечатьюПлатформа.ПолучитьФорматВыводаСуммы(Документ);
		
		ОбластьШапкаТаблицы    = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ОбластьЗаголовок       = Макет.ПолучитьОбласть("Заголовок");
		ОбластьСтрока          = Макет.ПолучитьОбласть("Строка");
		ОбластьИтогоПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
		ОбластьПодвал          = Макет.ПолучитьОбласть("Подвал");
		
		// для начала настроим макет
		ОбластьШапкаТаблицы.Параметры.МодельВариантКомплектации = "Модель";
		Таб = Документ.Опции.Выгрузить();
		Таб.Свернуть("ВариантКомплектации");
		Если Таб.Количество() > 0 Тогда
			Если ЗначениеЗаполнено(Таб[0].ВариантКомплектации) Тогда
				ОбластьШапкаТаблицы.Параметры.МодельВариантКомплектации = НСтр("ru = 'Модель / Вариант комплектации'");
			КонецЕсли;
		КонецЕсли;
		
		// дата документа
		ДатаДокумента = Документ.Дата;
		ДополнительныеПараметры = Новый Структура("ПодразделениеКомпании", Документ.ПодразделениеКомпании);
		
		// вывод заголовка документа
		ОбластьЗаголовок.Параметры.Заполнить(Документ);
		ТекстЗаголовка = УправлениеПечатьюПлатформа.ПолучитьПредставлениеДокумента(Документ);
		ОбластьЗаголовок.Параметры.ТекстЗаголовка = ТекстЗаголовка;
		
		ДополнительныеПараметры = УправлениеПечатьюПлатформа.ПолучитьПараметрыВызоваПредставленияСправочника();
		ДополнительныеПараметры.Вставить("ПодразделениеКомпании", Документ.ПодразделениеКомпании);
		ДополнительныеПараметры.ИспользоватьКИПодразделения = Истина;
		ДополнительныеПараметры.НаДату = ДатаДокумента;
		ОбластьЗаголовок.Параметры.ПредставлениеОрганизации = 
			УправлениеПечатьюПлатформа.ПолучитьПредставлениеСправочника(Документ.Организация, , ДополнительныеПараметры);
		
		ОбластьЗаголовок.Параметры.ПредставлениеТипаЦен =
			УправлениеПечатьюПлатформа.ПолучитьНаименованиеСправочника(Документ.ТипЦен);
		
		// выведем или удалим ШК
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
		
		// готовим шапку
		НомерСтраницы = 2; НомерСтраницыПредыдущий = 2;
		СтруктураИтоговПоСтранице = Новый Структура();
		ОбластьШапкаТаблицы.Параметры.ТекстЗаголовка = ТекстЗаголовка;
		ОбластьШапкаТаблицы.Параметры.НомерСтраницы  = "Страница: " + НомерСтраницы;
		
		МоментВремени = ?(НЕ ЗначениеЗаполнено(Документ.ДатаНачалаДействия), Документ.Ссылка.МоментВремени(),
			Новый МоментВремени(Документ.ДатаНачалаДействия, Документ.Ссылка));
		МоментВремени = Новый Граница(МоментВремени, ВидГраницы.Исключая);
		
		// перебор строк
		ВыборкаТабличнойЧасти = Документ.Опции.Выгрузить();
		Для Каждого СтрокаТЧ Из ВыборкаТабличнойЧасти Цикл
			// заполняем данные строки
			СтруктураСтроки = УправлениеПечатьюПлатформа.ЗаполнитьПредставлениеДанныхСтрокиДляАвтомобилей(СтрокаТЧ,
				Документ, "Опции");
			
			// найдём старую цену
			СтруктураОтбора = Новый Структура("ТипЦен,Модель,ВариантКомплектации",
				Документ.ТипЦен, СтрокаТЧ.Модель, СтрокаТЧ.ВариантКомплектации);
			
			СтруктураЦен = РегистрыСведений.ЦеныОпций.ПолучитьПоследнее(МоментВремени, СтруктураОтбора);
			ЦенаСтарая = СтруктураЦен.Цена;
			
			ВалютаТипаЦены = РаботаСКурсамиВалютПлатформа.ВалютаТипаЦены(Документ.ТипЦен, СтрокаТЧ.Модель);
			Если НЕ ВалютаТипаЦены = Документ.ВалютаДокумента Тогда
				ЦенаСтарая = РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(ЦенаСтарая, ВалютаТипаЦены, Документ.Дата,
					Документ.ВалютаДокумента, Документ.КурсДокумента);
			КонецЕсли;
			СтруктураСтроки.Вставить("ЦенаСтарая", Формат(ЦенаСтарая, ФорматВыводаСуммы));
			
			НетВарианта = НЕ ЗначениеЗаполнено(СтрокаТЧ.ВариантКомплектации);
			МодельНаименование = УправлениеПечатьюПлатформа.ПолучитьНаименованиеСправочника(СтрокаТЧ.Модель);
			ВариантНаименование = УправлениеПечатьюПлатформа.ПолучитьНаименованиеСправочника(СтрокаТЧ.ВариантКомплектации);
			МодельВариантКомплектации = ?(НетВарианта, МодельНаименование, МодельНаименование + " / " + ВариантНаименование);
			СтруктураСтроки.Вставить("МодельВариантКомплектации", МодельВариантКомплектации);
			СтруктураСтроки.Вставить("Модель_ВариантКомплектации", ?(НетВарианта, СтрокаТЧ.Модель, СтрокаТЧ.ВариантКомплектации));
			
			ОбластьСтрока.Параметры.Заполнить(СтруктураСтроки);
			
			// доп. области
			мсвДопОбластиПодвала = Неопределено;
			Если Документ.Опции.Индекс(СтрокаТЧ) = Документ.Опции.Количество() - 1 Тогда
				мсвДопОбластиПодвала = Новый Массив;
				мсвДопОбластиПодвала.Добавить(ОбластьПодвал);
			КонецЕсли;
			
			НомерСтраницы = УправлениеПечатьюПлатформа.ВывестиГоризонтальнуюОбласть(ТабличныйДокумент, ОбластьСтрока,
				ОбластьШапкаТаблицы, ОбластьИтогоПоСтранице, НомерСтраницы, СтруктураИтоговПоСтранице, Документ,
				мсвДопОбластиПодвала);
			
			// инициализация итогов по странице
			Если НомерСтраницы <> НомерСтраницыПредыдущий Тогда
				НомерСтраницыПредыдущий = НомерСтраницы;
				ОбластьШапкаТаблицы.Параметры.НомерСтраницы = "Страница: " + НомерСтраницы;
			КонецЕсли;
			
			// добавляем итоги
			УправлениеПечатьюПлатформа.ДобавитьИтогиПоСтранице(СтрокаТЧ, СтруктураИтоговПоСтранице);
			
		КонецЦикла;
		
		// итоги
		ОбластьПодвал.Параметры.СуммаПрописью = "Всего наименований " + ВыборкаТабличнойЧасти.Количество();
		ОбластьПодвал.Параметры.Заполнить(
			УправлениеПечатьюПлатформа.ДанныеОтветственногоЛица(Документ, "ПредседательКомиссии"));
		ОбластьПодвал.Параметры.Заполнить(УправлениеПечатьюПлатформа.ДанныеОтветственногоЛица(Документ, "ГлавныйБухгалтер"));
		
		УправлениеПечатьюПлатформа.
		ВывестиГоризонтальнуюОбласть(ТабличныйДокумент, ОбластьПодвал, , , НомерСтраницы, , Документ);
		
		// отметим конец области документа
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Документ);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

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
	ОбъектыВводимыеНаОсновании.Добавить(Документы.Событие);
	
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
		Метаданные.Документы.ИзменениеЦенОпций);

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли