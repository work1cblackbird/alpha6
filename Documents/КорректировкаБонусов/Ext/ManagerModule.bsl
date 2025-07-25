﻿// Модуль менеджера документа "Корректировка бонусов"

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
	ОбязательныеРеквизиты=Новый Массив();
	ОбязательныеРеквизиты.Добавить("Организация");
	ОбязательныеРеквизиты.Добавить("ПодразделениеКомпании");
	ОбязательныеРеквизиты.Добавить("Автор");
	
	ОбязательныеРеквизиты.Добавить("БонусыКНачислению.БонусыКСписанию");
	ОбязательныеРеквизиты.Добавить("БонусыКНачислению.ДатаСписания");
	ОбязательныеРеквизиты.Добавить("БонусыКСписанию.Карточка");
	ОбязательныеРеквизиты.Добавить("БонусыКСписанию.ДатаСписания");
	
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
	УникальныеБонусыКНачислению = Новый Массив();
	УникальныеБонусыКНачислению.Добавить("Карточка");
	УникальныеБонусыКНачислению.Добавить("ДатаСписания");
	
	// Структура уникальных реквизитов табличных частей
	УникальныеТабличныеЧасти=Новый Структура();
	УникальныеТабличныеЧасти.Вставить("БонусыКНачислению", УникальныеБонусыКНачислению);
	УникальныеТабличныеЧасти.Вставить("БонусыКСписанию",   УникальныеБонусыКНачислению);
	
	// Возвращаем сформированные параметры проверки
	Возврат УникальныеТабличныеЧасти;
	
КонецФункции // ПолучитьОбязательныеРеквизиты()

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
Функция ПолучитьПараметрыДействия(Объект, ПараметрыДействия = Неопределено) Экспорт
	
	Если ПараметрыДействия = Неопределено Тогда
		ПараметрыДействия = Новый Структура;
	КонецЕсли;
	
	// Производим добавление параметров расширяемых контекст обработки событий объекта
	ПараметрыДействия.Вставить("ОбъектЗаполнен", Объект.БонусыКНачислению.Количество() > 0 ИЛИ Объект.БонусыКСписанию.Количество() > 0);
	
	Возврат ПараметрыДействия;
	
КонецФункции

// Обработчик события пересчета зависимых показателей объекта при изменении значений ведущих реквизитов.
//
// Параметры:
//  Объект            - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//  ПараметрыДействия - Структура            - Набор параметров, использующихся при выполнения операции.
//
Процедура ОбработкаПересчетаПоказателейОбъекта(Объект, ПараметрыДействия=Неопределено) Экспорт
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	
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

#КонецОбласти

#Область ОбработчикиЗаполненияОбъекта

// Процедура используется для указания доступного данному виду объектов перечня вариантов заполнения.
//
// Параметры:
//  КомандыЗаполнения - ТаблицаЗначений - Каждая строка таблицы соответствует одному из вариантов заполнения.
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт

	ТабличныеЧастиСКомандами = Новый Массив();
	ТабличныеЧастиСКомандами.Добавить("БонусыКНачислению");
	ТабличныеЧастиСКомандами.Добавить("БонусыКСписанию");
	
	ОтображатьЗаполнитьИзФайла = ПраваИНастройкиПользователя.Значение("ОтображатьЗаполнитьИзФайла", "КорректировкаБонусов");
	
	Для Каждого ТабличнаяЧасть Из ТабличныеЧастиСКомандами Цикл
		ЗаполнениеОбъектовАльфаАвто.ДобавитьКомандуОчиститкиТабличнойЧасти(КомандыЗаполнения, ТабличнаяЧасть);
		
		Если ОтображатьЗаполнитьИзФайла Тогда
			ЗаполнениеОбъектовАльфаАвто.ДобавитьКомандуЗаполненияТабличнойЧастиИзФайла(КомандыЗаполнения, ТабличнаяЧасть);
		КонецЕсли;
	КонецЦикла;
	//	
	ВыборПрограммы 					= ПоследовательныеОперацииКлиентСервер.НовыйВыборСсылки();
	ВыборПрограммы.ВыборСсылки 		= "Справочник.БонусныеПрограммы.ФормаСписка";
	ВыборПрограммы.Обязательный 	= Истина;
	
	Команда 				= ЗаполнениеОбъектовАльфаАвто.ДобавитьКоманду(КомандыЗаполнения);
	Команда.Подменю			= "БонусыКНачислениюПодменюЗаполнения";
	Команда.Представление	= НСтр("ru = 'Заполнить бонусами к активации'");
	Команда.Идентификатор	= "БонусыКНачислениюЗаполнитьГотовымиКАктивацииБонусами";
	Команда.ДополнительныеПараметры.ИмяТабличнойЧасти = "БонусыКНачислению";
	Команда.ДополнительныеПараметры.ПоследовательныеОперации.Вставить("БонуснаяПрограмма", ВыборПрограммы);
	//	
	Команда 				= ЗаполнениеОбъектовАльфаАвто.ДобавитьКоманду(КомандыЗаполнения);
	Команда.Подменю			= "БонусыКСписаниюПодменюЗаполнения";
	Команда.Представление	= НСтр("ru = 'Заполнить бонусами к активации'");
	Команда.Идентификатор	= "БонусыКНачислениюЗаполнитьГотовымиКАктивацииБонусами";
	Команда.ДополнительныеПараметры.ИмяТабличнойЧасти = "БонусыКСписанию";
	Команда.ДополнительныеПараметры.ПоследовательныеОперации.Вставить("БонуснаяПрограмма", ВыборПрограммы);
	//	
	Команда 				= ЗаполнениеОбъектовАльфаАвто.ДобавитьКоманду(КомандыЗаполнения);
	Команда.Подменю			= "БонусыКСписаниюПодменюЗаполнения";
	Команда.Представление	= НСтр("ru = 'Заполнить просроченными бонусами'");
	Команда.Идентификатор	= "БонусыКСписаниюЗаполнитьПросроченнымиБонусами";
	Команда.ДополнительныеПараметры.ИмяТабличнойЧасти = "БонусыКСписанию";
	Команда.ДополнительныеПараметры.ПоследовательныеОперации.Вставить("БонуснаяПрограмма", ВыборПрограммы);
	
КонецПроцедуры // ДобавитьКомандыЗаполнения()

// Производит формирование структуры с доступностью и видимостью команд заполнения объекта.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - Объект, для которого выполняется обработка события.
//
Функция ПолучитьПараметрыКомандЗаполнения(Объект) Экспорт
	
	// Команды заполнения могут быть недоступны и/или невидимы в зависимости от параметров объекта.
	ПараметрыКоманд = Новый Соответствие;
	ПараметрыКоманд.Вставить("БонусыКНачислениюЗаполнитьГотовымиКАктивацииБонусами.Видимость",    Истина);
	ПараметрыКоманд.Вставить("БонусыКНачислениюЗаполнитьГотовымиКАктивацииБонусами.Доступность",  Истина);
	ПараметрыКоманд.Вставить("БонусыКСписаниюЗаполнитьГотовымиКАктивацииБонусами.Видимость",      Истина);
	ПараметрыКоманд.Вставить("БонусыКСписаниюЗаполнитьГотовымиКАктивацииБонусами.Доступность",    Истина);
	ПараметрыКоманд.Вставить("БонусыКСписаниюЗаполнитьПросроченнымиБонусами.Видимость",           Истина);
	ПараметрыКоманд.Вставить("БонусыКСписаниюЗаполнитьПросроченнымиБонусами.Доступность",         Истина);
	
	// Возвращаем сформированные параметры видимости и доступности команд проверки
	Возврат ПараметрыКоманд;
	
КонецФункции // ПолучитьПараметрыКомандЗаполнения()

// Обработчик заполнения табличных частей документа готовыми бонусами к активации 
//
Функция БонусыКНачислениюЗаполнитьГотовымиКАктивацииБонусами(Ссылка, ПараметрыКоманды, ПараметрыДействия=Неопределено) Экспорт
	
	ПараметрыЗаполнения = ПараметрыКоманды.ОписаниеКоманды.ДополнительныеПараметры.ПараметрыВыполненияКоманды;
	Объект				= ПараметрыКоманды.Источник;
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	
	// Произведем корректировку значений реквизитов объекта в соответствии с параметрами заполнения.
	Если НЕ Объект.БонуснаяПрограмма=ПараметрыЗаполнения.БонуснаяПрограмма Тогда
		Объект.БонуснаяПрограмма = ПараметрыЗаполнения.БонуснаяПрограмма;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	БонусныеБаллыОстатки.БонуснаяКарта,
	|	БонусныеБаллыОстатки.ДатаСписанияБонусов,
	|	БонусныеБаллыОстатки.БонуснаяКарта.БонуснаяПрограмма КАК БонуснаяПрограмма,
	|	БонусныеБаллыОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.БонусныеБаллы.Остатки(
	|			,
	|			ДатаСписанияБонусов < &ТекДата И НЕ АктивностьБонусов" +?(НЕ ЗначениеЗаполнено(Объект.БонуснаяПрограмма), ")"," И БонуснаяКарта.БонуснаяПрограмма = &БонуснаяПрограмма)") + " КАК БонусныеБаллыОстатки";
	Запрос.УстановитьПараметр("ТекДата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("БонуснаяПрограмма", Объект.БонуснаяПрограмма);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Объект.БонусыКНачислению.Добавить();
			НоваяСтрока.Карточка              = Выборка.БонуснаяКарта;
			НоваяСтрока.ДатаСписания          = ?(Выборка.БонуснаяПрограмма.СрокСгоранияБонусов <> 0, НачалоДня(ТекущаяДатаСеанса() + 24*60*60*Выборка.БонуснаяПрограмма.СрокСгоранияБонусов), Дата("39990101"));
			НоваяСтрока.Количество            = Выборка.КоличествоОстаток;
			НоваяСтрока.КоличествоКНачислению = 0;
			
			НоваяСтрокаСписания = Объект.БонусыКСписанию.Добавить();
			НоваяСтрокаСписания.Карточка              = Выборка.БонуснаяКарта;
			НоваяСтрокаСписания.ДатаСписания          = Выборка.ДатаСписанияБонусов;
			НоваяСтрокаСписания.Количество            = 0;
			НоваяСтрокаСписания.КоличествоКНачислению = Выборка.КоличествоОстаток;
		КонецЦикла;
	КонецЕсли;
	
КонецФункции // БонусыКНачислениюЗаполнитьГотовымиКАктивацииБонусами()

// Обработчик заполнения табличной части документа "Бонусы к списанию" просроченными бонусами.
//
Функция БонусыКСписаниюЗаполнитьПросроченнымиБонусами(Ссылка, ПараметрыКоманды, ПараметрыДействия=Неопределено) Экспорт

	ПараметрыЗаполнения = ПараметрыКоманды.ОписаниеКоманды.ДополнительныеПараметры.ПараметрыВыполненияКоманды;
	Объект				= ПараметрыКоманды.Источник;
	
	// Устанавливаем параметры выполнения операции
	ПараметрыДействия = ПолучитьПараметрыДействия(Объект, ПараметрыДействия);
	
	// Произведем корректировку значений реквизитов объекта в соответствии с параметрами заполнения.
	Если НЕ Объект.БонуснаяПрограмма=ПараметрыЗаполнения.БонуснаяПрограмма Тогда
		Объект.БонуснаяПрограмма = ПараметрыЗаполнения.БонуснаяПрограмма;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	БонусныеБаллыОстатки.БонуснаяКарта       КАК Карточка,
	|	БонусныеБаллыОстатки.ДатаСписанияБонусов КАК ДатаСписания,
	|	БонусныеБаллыОстатки.КоличествоОстаток   КАК Количество
	|ИЗ
	|	РегистрНакопления.БонусныеБаллы.Остатки(, ДатаСписанияБонусов < &ТекДата И АктивностьБонусов " +?(НЕ ЗначениеЗаполнено(Объект.БонуснаяПрограмма), ")"," И БонуснаяКарта.БонуснаяПрограмма = &БонуснаяПрограмма)") + " КАК БонусныеБаллыОстатки";
	Запрос.УстановитьПараметр("ТекДата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("БонуснаяПрограмма", Объект.БонуснаяПрограмма);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		// создадим документ
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Объект.БонусыКСписанию.Добавить(), Выборка);
		КонецЦикла;
	КонецЕсли;
	
КонецФункции // БонусыКСписаниюЗаполнитьПросроченнымиБонусами()

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
		Метаданные.Документы.КорректировкаБонусов);

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли