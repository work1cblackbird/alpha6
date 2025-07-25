﻿///////////////////////////////////////////////////////////////////////////////
// Модуль формы элемента справочника "Настройки печати комплекта"
//
///////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Отказ = Отказ Или РаботаСФормой.НужноОтменитьОткрытиеФормы();
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	РаботаСФормой.ЗаблокироватьРедактированиеПредопределенногоЭлемента(ЭтотОбъект);

	Если Параметры.Свойство("ВыбранныйДокумент") И ЗначениеЗаполнено(Параметры.ВыбранныйДокумент) Тогда
		ОбъектМетаданных = Параметры.ВыбранныйДокумент.Метаданные();
		ДобавитьДокументВДерево(ОбъектМетаданных.ПолноеИмя(), ОбъектМетаданных.Представление());
	КонецЕсли;
	
	СформироватьДеревоДокументов();
	ЗаполнитьСписокДокументов();
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей") Тогда
		Элементы.ТипДоступа.СписокВыбора.Очистить();
		Элементы.ТипДоступа.СписокВыбора.Добавить(Перечисления.ТипыДоступаКВариантуОтчета.БезОграничения);
		Элементы.ТипДоступа.СписокВыбора.Добавить(Перечисления.ТипыДоступаКВариантуОтчета.ПоПодразделениюКомпании);
		Элементы.ТипДоступа.СписокВыбора.Добавить(Перечисления.ТипыДоступаКВариантуОтчета.ПоПользователю);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УправлениеДиалогомНаСервере();
	КонецЕсли;
	
	Элементы.СписокДокументов.Доступность = ПравоДоступа("Изменение", Метаданные.Справочники.НастройкаПечатиКомплекта);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ТребуетсяОбновитьПодменюПечати И НЕ Модифицированность Тогда
		Оповестить("ЗаписьПечатиКомплекта");
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	РаботаСФормойКлиент.ЗамерВремениЗапись("НастройкаПечатиКомплекта");
	
	ОбновитьСписокПечатныхФормИзДерева();
	
КонецПроцедуры 

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

	УправлениеДиалогомНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ТребуетсяОбновитьПодменюПечати = Истина;
	
КонецПроцедуры 

&НаСервере
Процедура ТипДоступаПриИзмененииНаСервере()
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ТипДоступаПриИзменении(Элемент)
	
	ТипДоступаПриИзмененииНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ДеревоПечатныхФормИспользоватьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоПечатныхФорм.ТекущиеДанные;
	Родитель = ТекущиеДанные.ПолучитьРодителя();
	Если ТекущиеДанные.Использовать Тогда
		ТекущиеДанные.Копий = 1;
	Иначе
		ТекущиеДанные.Копий = 0;
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = СписокДокументов.НайтиПоИдентификатору(ВыбраннаяСтрока);
	ДобавитьДокументВДерево(ТекущиеДанные.Значение, ТекущиеДанные.Представление);
	ТребуетсяОбновитьПодменюПечати = Истина;
	
КонецПроцедуры 

&НаКлиенте
Процедура ДеревоПечатныхФормПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ТекущиеДанные = СписокДокументов.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение[0]);
	ДобавитьДокументВДерево(ТекущиеДанные.Значение, ТекущиеДанные.Представление);
	ТребуетсяОбновитьПодменюПечати = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПечатныхФормПередУдалением(Элемент, Отказ)
	
	Отказ = Элементы.ДеревоПечатныхФорм.ТекущиеДанные.Макет;
	ТребуетсяОбновитьПодменюПечати = НЕ Элементы.ДеревоПечатныхФорм.ТекущиеДанные.Макет;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПечатныхФормКопийПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоПечатныхФорм.ТекущиеДанные;
	Если ТекущиеДанные.Копий = 0 Тогда
		ТекущиеДанные.Использовать = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьДокумент(Команда)
	
	ТекущиеДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если НЕ ТекущиеДанные = Неопределено Тогда
		ДобавитьДокументВДерево(ТекущиеДанные.Значение, ТекущиеДанные.Представление);
	КонецЕсли;
	ТребуетсяОбновитьПодменюПечати = Истина;
	
КонецПроцедуры 

&НаСервере
Процедура УдалитьДокументНаСервере(ПолноеИмя)
	
	тДерево = РеквизитФормыВЗначение("ДеревоПечатныхФорм");
	тДерево.Строки.Удалить(тДерево.Строки.Найти(ПолноеИмя,"ПолноеИмя"));
	ЗначениеВРеквизитФормы(тДерево, "ДеревоПечатныхФорм");
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьДокумент(Команда)
	
	ТекущиеДанные = Элементы.ДеревоПечатныхФорм.ТекущиеДанные;
	Если НЕ ТекущиеДанные = Неопределено И НЕ ТекущиеДанные.Макет Тогда
		УдалитьДокументНаСервере(ТекущиеДанные.ПолноеИмя);
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю (НСтр("ru='Печатная форма не может быть удалена. Возможно удаление только документа.'"));	
	КонецЕсли;
	ТребуетсяОбновитьПодменюПечати = Истина;
	КоллекцияЭлементовДерева=ДеревоПечатныхФорм.ПолучитьЭлементы();
	Для Каждого Строка Из КоллекцияЭлементовДерева Цикл
		ИдентификаторСтроки=Строка.ПолучитьИдентификатор();
		Элементы.ДеревоПечатныхФорм.Развернуть(ИдентификаторСтроки);
	КонецЦикла;
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьДокументВДерево(ИмяДокумента,ПредставлениеДокумента)
	
	Если НЕ ТаблицаКонтроляПовтора.НайтиПоЗначению(ИмяДокумента) = Неопределено Тогда
		Для Каждого Строка Из ДеревоПечатныхФорм.ПолучитьЭлементы() Цикл
			Если Строка.ПолноеИмя = ИмяДокумента Тогда
				Элементы.ДеревоПечатныхФорм.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = ДеревоПечатныхФорм.ПолучитьЭлементы().Добавить();
	НоваяСтрока.ДокументМакет = ПредставлениеДокумента;
	НоваяСтрока.ПолноеИмя = ИмяДокумента;
	
	ТаблицаКонтроляПовтора.Добавить(ИмяДокумента);
	Элементы.ДеревоПечатныхФорм.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	ДобавитьПФВДерево(НоваяСтрока,ИмяДокумента);
	
КонецПроцедуры 

&НаСервере
Процедура ДобавитьПФВДерево(Дерево,ИмяДокумента)
	
	ТаблицаПечатныхФорм = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
	
	ДокументМенеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяДокумента);
	ДокументМенеджер.ДобавитьКомандыПечати(ТаблицаПечатныхФорм);
	// добавляем внешние печатные формы
	ВнешниеПечатныеФормы = УправлениеПечатью.СписокПечатныхФормИзВнешнихИсточников(ИмяДокумента);
	ПрефиксВнешнихПечатныхФорм = "ВнешняяПечатнаяФорма.";
	
	Для Каждого ПечатнаяФорма Из ВнешниеПечатныеФормы Цикл
		УправлениеПечатьюПлатформа.ДобавитьКоманду(ТаблицаПечатныхФорм, ИмяДокумента, ПрефиксВнешнихПечатныхФорм + ПечатнаяФорма.Значение, ПечатнаяФорма.Представление);
	КонецЦикла;
	
	Для каждого Строка Из ТаблицаПечатныхФорм Цикл
		Если ПустаяСтрока(Строка.МенеджерПечати) ИЛИ 
			(ИмяДокумента= "Документ.СводныйРемонтныйЗаказ" И Строка.МенеджерПечати <> "Документ.СводныйРемонтныйЗаказ") Тогда
				Продолжить;
		КонецЕсли;
		// Добавить в дерево новою строку
		НоваяСтрока = Дерево.ПолучитьЭлементы().Добавить();
		НоваяСтрока.ДокументМакет = Строка.Представление;
		НоваяСтрока.ПолноеИмя = Строка.Идентификатор;
		НоваяСтрока.Макет = Истина;
		
		ВыбранныйМакет = Объект.СписокПечатныхФорм.НайтиСтроки(Новый Структура("ТипДокумента,ИмяМакета",Дерево.ПолноеИмя,Строка.Идентификатор));
		Если ВыбранныйМакет.Количество()>0 Тогда
			НоваяСтрока.Использовать = Истина;
			НоваяСтрока.Копий = ВыбранныйМакет[0].Копий;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьСписокДокументов()
	
	СписокИсключений = СписокИсключенийДокументовПечати();

	Для Каждого Документ Из Метаданные.Документы Цикл
		Если СписокИсключений.Найти(Документ.Имя)=Неопределено И ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Документ) Тогда
			СписокДокументов.Добавить(Документ.ПолноеИмя(),Документ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры 

&НаСервере
Функция СписокИсключенийДокументовПечати()
	
	СписокИсключений = Новый Массив;
	СписокИсключений.Добавить("Анкета");
	СписокИсключений.Добавить("СообщениеSMS");
	СписокИсключений.Добавить("ЭлектронноеПисьмоВходящее");
	СписокИсключений.Добавить("ЭлектронноеПисьмоИсходящее");
	СписокИсключений.Добавить("НазначениеОпросов");
	СписокИсключений.Добавить("ВводВОборотКодовМаркировки");
	СписокИсключений.Добавить("ВозвратВОборотКодовМаркировки");
	СписокИсключений.Добавить("Встреча");
	СписокИсключений.Добавить("ЗапланированноеВзаимодействие");
	СписокИсключений.Добавить("ЗаявкаНаАвтомобиль");
	СписокИсключений.Добавить("ЗаявкаНаКомпенсациюПоМаркетинговойПрограмме");
	СписокИсключений.Добавить("ИзменениеЦенАренды");
	СписокИсключений.Добавить("КассоваяСмена");
	СписокИсключений.Добавить("КорректировкаБонусов");
	СписокИсключений.Добавить("КорректировкаКомпенсацииПоМаркетинговойПрограмме");
	СписокИсключений.Добавить("КорректировкаСтатусовКодовМаркировки");
	СписокИсключений.Добавить("НазначениеСкидокНаценокПоПрайсЛисту");
	СписокИсключений.Добавить("ОтгрузкаТоваровКодовМаркировки");
	СписокИсключений.Добавить("ОтзывСогласияНаОбработкуПерсональныхДанных");
	СписокИсключений.Добавить("Перемаркировка");
	СписокИсключений.Добавить("ПакетОбменСБанками");
	СписокИсключений.Добавить("ТранспортныйКонтейнерЭДО");
	СписокИсключений.Добавить("ПереносИстории");
	СписокИсключений.Добавить("ПереоценкаВалютныхСредств");
	СписокИсключений.Добавить("РабочийЛистКредитногоОтдела");
	СписокИсключений.Добавить("РабочийЛистВыкупаАвтомобиля");
	СписокИсключений.Добавить("РабочийЛистОтделаСтрахования");
	СписокИсключений.Добавить("РеестрДокументов");
	СписокИсключений.Добавить("СообщениеОбменСБанками");
	СписокИсключений.Добавить("СообщениеЭДО");
	СписокИсключений.Добавить("СписаниеКодовМаркировки");
	СписокИсключений.Добавить("СправкиСПАРКРиски");
	СписокИсключений.Добавить("ТаможеннаяДекларацияИмпорт");
	СписокИсключений.Добавить("Табель");
	СписокИсключений.Добавить("ТелефонныйЗвонок");
	СписокИсключений.Добавить("УдалитьПроизвольныйЭД");
	СписокИсключений.Добавить("ЭлектронныйДокументВходящийЭДО");
	СписокИсключений.Добавить("ЭлектронныйДокументИсходящийЭДО");
	
	Возврат СписокИсключений;
	
КонецФункции 

&НаСервере
Процедура СформироватьДеревоДокументов()
	
	Если Объект.СписокПечатныхФорм.Количество()>0 Тогда
		СписокВыбранныхДокументов = Объект.СписокПечатныхФорм.Выгрузить();
		СписокВыбранныхДокументов.Свернуть("ТипДокумента,Представление");
		
		Для Каждого Документ Из СписокВыбранныхДокументов Цикл
			ДобавитьДокументВДерево(Документ.ТипДокумента,Документ.Представление);
		КонецЦикла;
	КонецЕсли;
		
КонецПроцедуры 

&НаКлиенте
Процедура ОбновитьСписокПечатныхФормИзДерева()
	
	Объект.СписокПечатныхФорм.Очистить();
	
	Для каждого СтрокаДокумента Из ДеревоПечатныхФорм.ПолучитьЭлементы() Цикл
		Для каждого СтрокаПФ Из СтрокаДокумента.ПолучитьЭлементы() Цикл
			Если СтрокаПФ.Копий = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = Объект.СписокПечатныхФорм.Добавить();
			НоваяСтрока.Копий         = СтрокаПФ.Копий;
			НоваяСтрока.ТипДокумента  = СтрокаДокумента.ПолноеИмя;
			НоваяСтрока.ИмяМакета     = СтрокаПФ.ПолноеИмя;
			НоваяСтрока.Представление = СтрокаДокумента.ДокументМакет;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	УправлениеДиалогомСправочникаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
	Элементы.ОбъектДоступа.ТолькоПросмотр = Объект.ТипДоступа = ПредопределенноеЗначение("Перечисление.ТипыДоступаКВариантуОтчета.БезОграничения");
	Если Объект.ТипДоступа = ПредопределенноеЗначение("Перечисление.ТипыДоступаКВариантуОтчета.ПоПользователю") Тогда
		Элементы.ОбъектДоступа.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Пользователи");
	ИначеЕсли Объект.ТипДоступа = ПредопределенноеЗначение("Перечисление.ТипыДоступаКВариантуОтчета.ПоГруппеПользователей") Тогда
		Элементы.ОбъектДоступа.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ГруппыПользователей");
	ИначеЕсли Объект.ТипДоступа = ПредопределенноеЗначение("Перечисление.ТипыДоступаКВариантуОтчета.ПоПодразделениюКомпании") Тогда
		Элементы.ОбъектДоступа.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПодразделенияКомпании");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Вызываем общий обработчик действия.
	УправлениеДиалогомСправочникаСервер.УстановитьУсловноеОформление(ЭтотОбъект);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПечатныхФормМакет.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПечатныхФорм.Макет");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПечатныхФормИспользовать.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПечатныхФорм.Макет");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПечатныхФормКопий.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПечатныхФорм.Использовать");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
		
КонецПроцедуры 

#КонецОбласти

#КонецОбласти

