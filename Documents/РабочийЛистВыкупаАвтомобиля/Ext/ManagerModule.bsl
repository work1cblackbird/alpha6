﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом
// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст = 
		"РазрешитьЧтениеИзменение
		|ГДЕ
		|	ЗначениеРазрешено(ПодразделениеКомпании)
		|	И ЗначениеРазрешено(Организация)
		|	И ЗначениеРазрешено(Контрагент)";
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

// Производит расчет значений итоговых показателей по операции в целом.
//
// Параметры:
//  Объект      - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события;
//  Расширенные - Булево               - Признак получения расширенных сведений об итогах операци.
// 
// Возвращаемое значение:
//  Структура - Итог операции.
//
Функция РассчитатьИтогиОперации(Объект, Расширенные = Ложь) Экспорт
	
	Возврат Новый Структура();
	
КонецФункции

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
	
	ОбязательныеРеквизиты = Новый Массив();
	ОбязательныеРеквизиты.Добавить("Организация");
	ОбязательныеРеквизиты.Добавить("ПодразделениеКомпании");
	ОбязательныеРеквизиты.Добавить("Автор");
	ОбязательныеРеквизиты.Добавить("ВалютаДокумента");
	ОбязательныеРеквизиты.Добавить("КурсДокумента");
	ОбязательныеРеквизиты.Добавить("ОбращениеККлиенту");
	
	ОбязательныеРеквизиты.Добавить("Возражения.Возражение");
	
	Возврат ОбязательныеРеквизиты;
	
КонецФункции // ПолучитьОбязательныеРеквизиты()

// Производит формирование параметров проверки заполнения реквизитов объекта на предмет обязательности и уникальности.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - Объект, для которого выполняется получение параметров проверки.
//
// Возвращаемое значение:
//  Структура - Возвращаемая структура содержит строковые идентификаторы реквизитов и вариант проверки его заполнения
//
Функция ПолучитьУникальныеРеквизиты(Объект) Экспорт
	
	УникальныеВозражения = Новый Массив();
	УникальныеВозражения.Добавить("Возражение");
	
	УникальныеРеквизиты = Новый Структура();
	УникальныеРеквизиты.Вставить("Возражения", УникальныеВозражения);
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
// Возвращаемое значение:
//  Структура - Параметры действия.
//
Функция ПолучитьПараметрыДействия(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	Если ПараметрыДействия = Неопределено Тогда
		ПараметрыДействия = Новый Структура;
	КонецЕсли;
	
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

#Область ОбработчикиРеквизитов

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

// Обработчик события возникающего при изменении данных реквизита "Проект".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ПроектПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	ОбработкаРеквизитовДокументаСервер.ПроектПриИзменении(Объект, ПараметрыДействия);
	
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

// Обработчик события возникающего при изменении данных реквизита "Валюта".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ВалютаДокументаПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	ОбработкаРеквизитовДокументаСервер.ВалютаДокументаПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Курс документа".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура КурсДокументаПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	ОбработкаРеквизитовДокументаСервер.КурсДокументаПриИзменении(Объект, ПараметрыДействия);
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Контрагент".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура, ДокументОбъект.РабочийЛистВыкупаАвтомобиля - Объект документа;
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура КонтрагентПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	ОбработкаРеквизитовДокументаСервер.КонтрагентПриИзменении(Объект, ПараметрыДействия);
	ПараметрыДействия.Удалить("ТребуетсяУстановкаЦен");
	
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		
		Реквизиты = Новый Структура;
		Реквизиты.Вставить("ИсточникИнформации", "РекламныйИсточник");
		Реквизиты.Вставить("ФормаСобственности", "ФормаСобственности");
		Реквизиты.Вставить("ПолКлиента", "Пол");
		
		Если ПустаяСтрока(Объект.ОбращениеККлиенту) Тогда
			
			Реквизиты.Вставить("ОбращениеККлиенту", "Наименование");
			
		КонецЕсли;
		
		ДанныеКонтрагента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Контрагент, Реквизиты);
		
		Если ДанныеКонтрагента.ФормаСобственности <> Перечисления.ФормыСобственности.ЧастноеЛицо Тогда
			
			ДанныеКонтрагента.ПолКлиента = Перечисления.ПолФизическихЛиц.НеУказан;
			
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Объект, ДанныеКонтрагента);
		
		// Заполняет системные поля телефона и электронной почты в документе
		УправлениеКонтактнойИнформациейАльфаАвто.ЗаполнитьКонтактнуюИнформациюВДокументе(
			Объект,
			Объект.Контрагент,
			ПараметрыДействия
		);
		
	Иначе
		
		Объект.ИсточникИнформации           = Неопределено;
		Объект.ФормаСобственности           = Неопределено;
		Объект.ПолКлиента                   = Перечисления.ПолФизическихЛиц.НеУказан;
		Объект.ПредставлениеТелефона        = "";
		Объект.АдресЭлектроннойПочты        = "";
		Объект.ПредставлениеТелефонаСтрокой = "";
		Объект.АдресЭлектроннойПочтыСтрокой = "";
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Автомобиль".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура АвтомобильПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	
	Если ЗначениеЗаполнено(Объект.Автомобиль) Тогда
		
		Владелец = Справочники.Автомобили.ЧтениеЗначенияРегистраСведения(
			Объект.Автомобиль,
			Перечисления.ДополнительнаяИнформацияАвтомобилей.Хозяин,
			Объект.Дата
		);
		
		ПараметрыДействия.Вставить("ВладелецВИБ", Владелец);
		ПараметрыДействия.Вставить("ВладелецВИБПредставление", Строка(Владелец));
		
		ОписаниеАвтомобиля = АвтомобилиСервер.ДанныеАвтомобиля(Объект.Автомобиль);
		ЗаполнитьЗначенияСвойств(Объект, ОписаниеАвтомобиля, , "Пробег");
		Объект.Комплектация = ОписаниеАвтомобиля.ВариантКомплектации;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Марка".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура МаркаПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	Если
		ЗначениеЗаполнено(Объект.Модель)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Модель, "Марка") <> Объект.Марка
	Тогда
		
		Объект.Модель = Справочники.Модели.ПустаяСсылка();
		Объект.Комплектация = Справочники.ВариантыКомплектации.ПустаяСсылка();
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Модель".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура МодельПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	Если НЕ Объект.Модель.Пустая() Тогда
		
		Объект.Марка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Модель, "Марка");
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события возникающего при изменении данных реквизита "Комплектация".
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура КомплектацияПриИзменении(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	ЗначенияРеквизитов = Новый Структура("ТипКПП,ТипДвигателя,ТипДвигателяВМодели,ТипКузова");
	
	Если НЕ Объект.Комплектация.Пустая() Тогда
		
		Реквизиты = Новый Структура(
			"ТипКПП,ТипДвигателя,ТипДвигателяВМодели,ТипКузова",
			"ТипКПП",
			"ТипДвигателя",
			"МодельДвигателя.Тип",
			"ТипКузова"
		);
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Комплектация, Реквизиты);
		
		Если НЕ ЗначениеЗаполнено(ЗначенияРеквизитов.ТипДвигателя) Тогда
			
			ЗначенияРеквизитов.ТипДвигателя = ЗначенияРеквизитов.ТипДвигателяВМодели;
			
		КонецЕсли;
		
		ЗначенияРеквизитов.Удалить("ТипДвигателяВМодели");
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, ЗначенияРеквизитов);
	
КонецПроцедуры

#КонецОбласти

// Расчитывает срок действия комерческого предложения. За дату оценки принемается дата начала действия
// документа изменение цен полученого методом ПолучитьДокументСогласованияЦены
// см. Документы.АктОценкиАвтомобиля.ПолучитьДокументСогласованияЦены 
//
// Параметры:
//  РабочийЛист - ДокументСсылка.РабочийЛистВыкупаАвтомобиля - Документ для которого производилось согласование.
//
// Возвращаемое значение:
//  Дата - дата до которой дествительно комерческое предложение
//
Функция СрокДействия(РабочийЛист) Экспорт
	
	Если ТипЗнч(РабочийЛист) <> Тип("ДокументСсылка.РабочийЛистВыкупаАвтомобиля") Тогда
		
		ВызватьИсключение НСтр("ru = 'Не верный тип параметра ""РабочийЛист""'");
		
	КонецЕсли;
	
	ДокументОсмотра = ПолучитьДокументОсмотра(РабочийЛист);
	
	Если ДокументОсмотра = Неопределено Или Не ЗначениеЗаполнено(ДокументОсмотра.Оценка) Тогда
		
		Возврат Дата(1, 1, 1);
		
	КонецЕсли;
	
	Возврат Документы.АктОценкиАвтомобиля.СрокДействия(ДокументОсмотра.Оценка);
	
КонецФункции

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
	ОбъектыВводимыеНаОсновании.Добавить(Документы.АктОценкиАвтомобиля);
	ОбъектыВводимыеНаОсновании.Добавить(Документы.ПоступлениеАвтомобилей);
	
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
		Метаданные.Документы.РабочийЛистВыкупаАвтомобиля);

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьДокументОсмотра(Документ) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫРАЗИТЬ(ПодчиненныеДокументы.Ссылка КАК Документ.АктОценкиАвтомобиля) КАК Оценка
		|ПОМЕСТИТЬ Оценки
		|ИЗ
		|	КритерийОтбора.ПодчиненныеДокументы(&Документ) КАК ПодчиненныеДокументы
		|
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	Оценки.Оценка КАК Оценка,
		|	Оценки.Оценка.ВалютаДокумента КАК ВалютаДокумента,
		|	Оценки.Оценка.Автомобиль КАК Автомобиль
		|ИЗ
		|	Оценки КАК Оценки
		|ГДЕ
		|	НЕ Оценки.Оценка.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Оценки.Оценка.МоментВремени УБЫВ"
	);
	Запрос.УстановитьПараметр("Документ", Документ);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить()[0];
	
КонецФункции // ПолучитьДокументОсмотра()

Функция ПолучитьДокументСогласованияЦены(Документ) Экспорт
	
	Если ТипЗнч(Документ) <> Тип("ДокументСсылка.РабочийЛистВыкупаАвтомобиля") Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	// получим для начала документ осмотра
	ДанныеДокументаОсмотра = АвтомобилиСПробегомСервер.ПолучитьДокументОсмотра(Документ);
	
	Если ДанныеДокументаОсмотра = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат АвтомобилиСПробегомЗащищенныеФункцииСервер.ПолучитьДокументСогласованияЦены(ДанныеДокументаОсмотра.Оценка);
	
КонецФункции // ПолучитьДокументОценки()

#КонецОбласти

#КонецЕсли
