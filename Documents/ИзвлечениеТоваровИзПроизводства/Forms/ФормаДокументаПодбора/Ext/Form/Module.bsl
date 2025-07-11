﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Отказ = Отказ Или РаботаСФормой.НужноОтменитьОткрытиеФормы();
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Установим вариант отображения дополнительных полей "Код" и "Артикул"
	УправлениеДиалогомДокументаСервер.УстановитьВидимостьКолонокКодАртикул(ЭтотОбъект, "ТоварыВЦехе");
	
	ЗащищенныеФункцииСервер.ЗаполнитьСлужебныеРеквизитыТабличнойЧасти(ТоварыВЦехе);
		
	// Установим вариант отображения дополнительного поля "Производитель".
	УправлениеДиалогомДокументаСервер.УстановитьВидимостьКолонкиПроизводитель(ЭтотОбъект, "Товары", "НоменклатураАртикул");
	
	ПолучитьТоварыВПроизводстве();
	Объект.Товары.Очистить();
	ЗакрытьФорму = Истина;
	
	ОтображатьАртикул = ПолучитьФункциональнуюОпцию("ИспользоватьАртикул");
	Элементы.ТоварыВЦехеПроизводитель.Видимость = ОтображатьАртикул = Перечисления.РежимыВыводаКодаВДокументах.АртикулИПроизводитель
		ИЛИ ОтображатьАртикул = Перечисления.РежимыВыводаКодаВДокументах.КодИПроизводитель
		ИЛИ ОтображатьАртикул = Перечисления.РежимыВыводаКодаВДокументах.АртикулКодПроизводитель;
	
	// Дальнейшие операции выполняются только для новых объектов
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) И ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ЗаказНаряд") Тогда
		Если Объект.ДокументОснование.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Выполнен 
			ИЛИ Объект.ДокументОснование.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Закрыт	Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Перемещение деталей в производство на основании выполненных и закрытых заказ-нарядов запрещено.'"));
			Отказ = Истина; 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	НастроитьПараметрыВыбораЭлементовФормы();
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Отказ = НЕ ЗакрытьФорму;
	
	Если (НЕ Отказ) И (Модифицированность) Тогда
		
		Модифицированность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура ОбработкаВыбораНаСервере(ВыбранноеЗначение, ПараметрыДействия = Неопределено)
	
	// Вызываем общий обработчик события
	Если НЕ УправлениеДиалогомДокументаСервер.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, ПараметрыДействия) Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьПараметрыВыбораЭлементовФормы();
	// Обновляем отображение элементов формы
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры // ОбработкаВыбораНаСервере()

// Обработчик события возникающего на клиенте при выборе объекта без привязки к элементу формы.
//
// Параметры:
//  ВыбранноеЗначение - Произвольный - Результат выбора в подчиненной форме.
//  ИсточникВыбора    - Произвольный - Форма, в которой осуществлен выбор.
//
&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ПараметрыДействия = Новый Структура;	
	
	ОбработкаВыбораНаСервере(ВыбранноеЗначение, ПараметрыДействия);
	ОбработкаРезультатаВыполненияДействия(ПараметрыДействия);
	
КонецПроцедуры // ОбработкаВыбора()

// Обработчик события возникающего на сервере при чтении данных объекта.
//
// Параметры:
//  ТекущийОбъект - ДокументОбъект - Объект, который будет прочитан.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	РаботаСФормой.ЗаполнитьСлужебныеРеквизитыТоваров(Объект.Товары);
	РаботаСФормой.УстановитьВидимостьКолонкиХарактеристика(ЭтотОбъект, Объект);
	
	// ПрослеживаемыеТовары
	УчетПрослеживаемыхТоваровСервер.ЗаполнитьСлужебныйРеквизитПрослеживаемогоТовара(Объект);
	// Конец ПрослеживаемыеТовары
	
	НастроитьПараметрыВыбораЭлементовФормы();
	
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 

// Обработчик события возникающего на сервере перед записью объекта.
//
// Параметры:
//  Отказ           - Булево         - Признак отказа от создания формы.
//  ТекущийОбъект   - ДокументОбъект - Записываемый объект.
//  ПараметрыЗаписи - Структура      - Структура, содержащая параметры записи.
//
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// проверка возможности записи документа
	Если Объект.ДокументОснование.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Выполнен 
		ИЛИ Объект.ДокументОснование.Состояние = Справочники.ВидыСостоянийЗаказНарядов.Закрыт Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Заказ-наряд выполнен или закрыт. Извлечение из производства запрещено.'"));
		Отказ=Истина;
		Возврат;
	КонецЕсли;
		
	
КонецПроцедуры 
// Обработчик события возникающего на сервере после записи объекта и после завершения транзакции.
//
// Параметры:
//  ТекущийОбъект   - ДокументОбъект - Записываемый объект.
//  ПараметрыЗаписи - Структура      - Структура, содержащая параметры записи.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ИмяРегистра", "ТоварыВПроизводстве");
	
	РаботаСФормой.ЗаполнитьСлужебныеРеквизитыТоваров(Объект.Товары);
	РаботаСФормой.УстановитьВидимостьКолонкиХарактеристика(ЭтотОбъект, Объект);
	
	// ПрослеживаемыеТовары
	УчетПрослеживаемыхТоваровСервер.ЗаполнитьСлужебныйРеквизитПрослеживаемогоТовара(Объект);
	// Конец ПрослеживаемыеТовары
	
	НастроитьПараметрыВыбораЭлементовФормы();
	ЗащищенныеФункцииСервер.УстановитьВидимостьКолонкиКодыМаркировки(ЭтотОбъект,,,Объект);
	ОбработкаТабличнойЧастиТовары.ЗаполнитьСлужебныйРеквизитКодыМаркировки(ЭтотОбъект, , ПараметрыЗаписи);
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры 
// Обработчик события возникающего на клиенте после записи объекта и после завершения транзакции.
//
// Параметры:
//  ПараметрыЗаписи - Структура - Структура, содержащая параметры записи.
//
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	РаботаСФормойКлиент.ОповеститьОЗаписиДокумента(Объект.Ссылка);
	
	// При успешном проведении извлечения предложим скорректировать количество деталей в ЗН
	Если Объект.Проведен И ВладелецФормы <> Неопределено Тогда
		
		ОбработчикОповещения = Новый ОписаниеОповещения("Подключаемый_УменьшитьКоличествоДеталейВЗаказНаряде", ЭтотОбъект);
		ПоказатьВопрос(
			ОбработчикОповещения,
			НСтр("ru = 'Уменьшить количество возвращаемых на склад деталей в заказ-наряде?'"),
			РежимДиалогаВопрос.ДаНет);
			
		ЗакрытьФорму = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ЦехПриИзмененииНаСервере()
	
	Объект.Товары.Очистить();
	ПолучитьТоварыВПроизводстве();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦехПриИзменении(Элемент)
	
	ЦехПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыВЦехеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле <> Элементы.ТоварыВЦехеКоличество Тогда
		
		ИзвлечьДеталь(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВЦехеНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.Значение = Новый Структура("Источник,Строка", "ТоварыВЦехе", ПараметрыПеретаскивания.Значение);
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВЦехеПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ПараметрыПеретаскивания.Значение.Источник <> "Товары" Тогда
		
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
		
	КонецЕсли;
	
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВЦехеПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ПараметрыПеретаскивания.Действие <> ДействиеПеретаскивания.Перемещение Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СтрокаВозврата = Объект.Товары.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение.Строка);
	ВернутьТоварыВПроизводство(
		СтрокаВозврата.Номенклатура,
		СтрокаВозврата.ХарактеристикаНоменклатуры,
		СтрокаВозврата.Количество,
		СтрокаВозврата.ЕдиницаИзмерения,
		СтрокаВозврата.Коэффициент,
		СтрокаВозврата.КартинкаПрослеживаемогоТовара,
		СтрокаВозврата.ПрослеживаемыйТовар);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВЦехеКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТоварыВЦехе.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ВернутьТоварыВПроизводство(
		ТекущиеДанные.Номенклатура,
		ТекущиеДанные.ХарактеристикаНоменклатуры,
		0,
		ТекущиеДанные.ЕдиницаИзмерения,
		ТекущиеДанные.Коэффициент,
		ТекущиеДанные.КартинкаПрослеживаемогоТовара,
		ТекущиеДанные.ПрослеживаемыйТовар
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ТоварыКодыМаркировки Тогда
		
		// Маркировка
		МаркировкаТоваровКлиент.ОткрытьСписокКодовМаркировки(
			ЭтотОбъект,
			ВыбраннаяСтрока,
			Поле,
			СтандартнаяОбработка
		);
		// Конец Маркировка
		
	ИначеЕсли Поле <> Элементы.ТоварыКоличество Тогда
		
		ВозвратДетали(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.Значение = Новый Структура("Источник,Строка", "Товары", ПараметрыПеретаскивания.Значение);
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ПараметрыПеретаскивания.Значение.Источник <> "ТоварыВЦехе" Тогда
		
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
		
	КонецЕсли;
	
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ПараметрыПеретаскивания.Действие <> ДействиеПеретаскивания.Перемещение Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СтрокаВЦехе = ТоварыВЦехе.НайтиПоИдентификатору(ПараметрыПеретаскивания.Значение.Строка);
	ИзвлечьТоварыИзПроизводства(
		СтрокаВЦехе.Номенклатура,
		СтрокаВЦехе.ХарактеристикаНоменклатуры,
		СтрокаВЦехе.Количество,
		СтрокаВцехе.ЕдиницаИзмерения,
		СтрокаВЦехе.Коэффициент,
		СтрокаВЦехе.КартинкаПрослеживаемогоТовара,
		СтрокаВЦехе.ПрослеживаемыйТовар);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыКоличествоПриИзмененииНаСервере()
	
	// Получим данные текущей строки табличной части
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(Элементы.Товары.ТекущаяСтрока);
	
	// Вызываем обработчик изменения данных объекта
	Документы.ИзвлечениеТоваровИзПроизводства.ТоварыКоличествоПриИзменении(Объект, ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	// Обработаем событие в контексте сервера
	ТоварыКоличествоПриИзмененииНаСервере();

	ИзвлечьТоварыИзПроизводства(
		ТекущиеДанные.Номенклатура,
		ТекущиеДанные.ХарактеристикаНоменклатуры,
		0, 
		ТекущиеДанные.ЕдиницаИзмерения,
		ТекущиеДанные.Коэффициент,
		ТекущиеДанные.КартинкаПрослеживаемогоТовара,
		ТекущиеДанные.ПрослеживаемыйТовар
	);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзвлечьДеталь(Команда)
	
	ТекущиеДанные = Элементы.ТоварыВЦехе.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ИзвлечьТоварыИзПроизводства(
		ТекущиеДанные.Номенклатура,
		ТекущиеДанные.ХарактеристикаНоменклатуры,
		ТекущиеДанные.Количество,
		ТекущиеДанные.ЕдиницаИзмерения,
		ТекущиеДанные.Коэффициент,
		ТекущиеДанные.КартинкаПрослеживаемогоТовара,
		ТекущиеДанные.ПрослеживаемыйТовар
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзвлечьВсеДетали(Команда)
	
	Пока ТоварыВЦехе.Количество() > 0 Цикл
		
		ИзвлечьТоварыИзПроизводства(
			ТоварыВЦехе[0].Номенклатура,
			ТоварыВЦехе[0].ХарактеристикаНоменклатуры,
			ТоварыВЦехе[0].Количество,
			ТоварыВЦехе[0].ЕдиницаИзмерения,
			ТоварыВЦехе[0].Коэффициент,
			ТоварыВЦехе[0].КартинкаПрослеживаемогоТовара,
			ТоварыВЦехе[0].ПрослеживаемыйТовар
		);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратДетали(Команда)
	
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ВернутьТоварыВПроизводство(
		ТекущиеДанные.Номенклатура,
		ТекущиеДанные.ХарактеристикаНоменклатуры,
		ТекущиеДанные.Количество,
		ТекущиеДанные.ЕдиницаИзмерения,
		ТекущиеДанные.Коэффициент,
		ТекущиеДанные.КартинкаПрослеживаемогоТовара,
		ТекущиеДанные.ПрослеживаемыйТовар
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратВсеДетали(Команда)
	
	Пока Объект.Товары.Количество() > 0 Цикл
		
		ВернутьТоварыВПроизводство(
			Объект.Товары[0].Номенклатура,
			Объект.Товары[0].ХарактеристикаНоменклатуры,
			Объект.Товары[0].Количество,
			Объект.Товары[0].ЕдиницаИзмерения,
			Объект.Товары[0].Коэффициент,
			Объект.Товары[0].КартинкаПрослеживаемогоТовара,
			Объект.Товары[0].ПрослеживаемыйТовар
			);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	
	РежимЗаписи = РежимЗаписиДокумента.Запись;
	
	Если ПраваИНастройкиПользователяКлиент.Значение("ПеремещениеДеталейВПроизводство") Тогда
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
	КонецЕсли;
	
	ЗакрытьФорму = Истина;
	
	Если Записать(Новый Структура("РежимЗаписи", РежимЗаписи)) И ЗакрытьФорму Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Марировка
&НаКлиенте
Процедура Подключаемый_СканированиеМаркировкиЗавершение(КодМаркировки, ДополнительныеПараметры = Неопределено) Экспорт
	
	МаркировкаТоваровКлиент.ДобавитьКодМаркировки(Объект.КодыМаркировки, КодМаркировки, ДополнительныеПараметры);
	
	// Обновим отображение на форме
	Результат = Новый Структура;
	ОбработкаРезультатаОповещенияНаСервере(Результат, "РазрешенияДляПересчета");
	
КонецПроцедуры
// Конец Маркировка

// Процедура заполнение табличного поля товарами из производства по данному заказу
//
&НаСервере
Процедура ПолучитьТоварыВПроизводстве()
	
	ТоварыВЦехе.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры
	|ПОМЕСТИТЬ ВТ_Товары
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыВПроизводствеОстатки.Номенклатура КАК Номенклатура,
	|	ТоварыВПроизводствеОстатки.КоличествоОстаток КАК Количество,
	|	ТоварыВПроизводствеОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ТоварыВПроизводствеОстатки.Номенклатура.ОсновнаяЕдиницаИзмерения.Коэффициент КАК Коэффициент,
	|	ТоварыВПроизводствеОстатки.Номенклатура.ОсновнаяЕдиницаИзмерения КАК ЕдиницаИзмерения
	|ИЗ
	|	РегистрНакопления.ТоварыВПроизводстве.Остатки(
	|			,
	|			ЗаказНаряд = &ЗаказНаряд
	|				И Цех = &Цех
	|				И (Номенклатура, ХарактеристикаНоменклатуры) В
	|					(ВЫБРАТЬ
	|						ВТ_Товары.Номенклатура КАК Номенклатура,
	|						ВТ_Товары.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры
	|					ИЗ
	|						ВТ_Товары КАК ВТ_Товары)) КАК ТоварыВПроизводствеОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура,
	|	ХарактеристикаНоменклатуры,
	|	Количество";
	
	Запрос.УстановитьПараметр("ЗаказНаряд", Объект.ДокументОснование);
	Запрос.УстановитьПараметр("Цех", Объект.Цех);
	Запрос.УстановитьПараметр("ТаблицаТоваров", Объект.Товары.Выгрузить(, "Номенклатура, ХарактеристикаНоменклатуры"));
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЕстьХарактеристики = Ложь;
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаВЦехе = ТоварыВЦехе.Добавить();
		СтрокаВЦехе.Номенклатура = Выборка.Номенклатура;
		СтрокаВЦехе.ХарактеристикаНоменклатуры = Выборка.ХарактеристикаНоменклатуры;
		
		Если Выборка.Количество <> 0 Тогда
			
			СтрокаВЦехе.Количество = Окр (Выборка.Количество / Выборка.Коэффициент, 3); 
			
		КонецЕсли;
		
		СтрокаВЦехе.ЕдиницаИзмерения = Выборка.ЕдиницаИзмерения;
		СтрокаВЦехе.Коэффициент = Выборка.Коэффициент;
		
		СтрокаВПроизводстве = ТоварыВПроизводстве.Добавить();
		СтрокаВПроизводстве.Номенклатура = Выборка.Номенклатура;
		СтрокаВПроизводстве.ХарактеристикаНоменклатуры =Выборка.ХарактеристикаНоменклатуры;
	
		СтрокаВПроизводстве.Количество = СтрокаВЦехе.Количество;		
		
		Если ЗначениеЗаполнено(Выборка.ХарактеристикаНоменклатуры) Тогда
			
			ЕстьХарактеристики = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.ТоварыВЦехеХарактеристикаНоменклатуры.Видимость = ЕстьХарактеристики;
	КоличествоВЦехе = ТоварыВЦехе.Итог("Количество");
	
	ИменаРеквизитов = УчетПрослеживаемыхТоваровСервер.ИменаРеквизитовДляЗаполнитьСлужебныйРеквизитПрослеживаемогоТовара();
	ИменаРеквизитов.ИмяТаблицы = "ТоварыВЦехе";
	УчетПрослеживаемыхТоваровСервер.ЗаполнитьСлужебныйРеквизитПрослеживаемогоТовара(ЭтотОбъект, , ИменаРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УменьшитьКоличествоДеталейВЗаказНаряде(
		РезультатОтвета, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗакрытьФорму = Истина;
	
	Если РезультатОтвета <> КодВозвратаДиалога.Да Тогда
		
		Закрыть();
		Возврат;
		
	КонецЕсли;
	
	Если НЕ ПраваИНастройкиПользователяКлиент.Значение("РедактированиеДеталейЗаказНаряда") Тогда
		
		Закрыть();
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Нет прав на редактирование деталей заказ-наряда. Количество уменьшено не будет.'"));
		Возврат;
		
	КонецЕсли;
	
	АдресРезультата = ТоварыКИзвлечениюИзПроизводства();
	Закрыть(АдресРезультата);
	
КонецПроцедуры

&НаСервере
Функция ТоварыКИзвлечениюИзПроизводства()
	
	ТаблициИзвлеченияИзПроизводства =
		Объект.Товары.Выгрузить(, "Номенклатура,ХарактеристикаНоменклатуры,Количество,Коэффициент");
	
	Возврат ПоместитьВоВременноеХранилище(ТаблициИзвлеченияИзПроизводства);
	
КонецФункции

// Извлечение товаров из производства
//
&НаКлиенте
Процедура ИзвлечьТоварыИзПроизводства(
		Знач Номенклатура,
		Знач ХарактеристикаНоменклатуры,
		Знач Количество,
		Знач ЕдиницаИзмерения,
		Знач Коэффициент,
		Знач КартинкаПрослеживаемогоТовара,
		Знач ПрослеживаемыйТовар)
	
	СтруктураПоиска = Новый Структура();
	СтруктураПоиска.Вставить("Номенклатура", Номенклатура);
	СтруктураПоиска.Вставить("ХарактеристикаНоменклатуры", ХарактеристикаНоменклатуры);
	
	СтрокаВПроизводстве = ТоварыВПроизводстве.НайтиСтроки(СтруктураПоиска);
	
	Если СтрокаВПроизводстве.Количество() = 0 Тогда
		
		КоличествоВПроизводстве = 0;
		
	Иначе
		
		КоличествоВПроизводстве = СтрокаВПроизводстве[0].Количество;
		
	КонецЕсли;
	
	СтрокаВЦехе = ТоварыВЦехе.НайтиСтроки(СтруктураПоиска);
	
	Если СтрокаВЦехе.Количество() = 0 Тогда
		
		СтрокаВЦехе = Неопределено;
		КоличествоВЦехе = 0;
		
	Иначе
		
		СтрокаВЦехе = СтрокаВЦехе[0];
		СтрокаВЦехе.Количество = СтрокаВЦехе.Количество - Количество;
		
		Если СтрокаВЦехе.Количество < 0 Тогда
			
			СтрокаВЦехе.Количество = 0;
			
		КонецЕсли; 
		
		КоличествоВЦехе = СтрокаВЦехе.Количество;
		
	КонецЕсли;
	
	СтрокаНаСкладе = Объект.Товары.НайтиСтроки(СтруктураПоиска);
	
	Если СтрокаНаСкладе.Количество() = 0 Тогда
		
		СтрокаНаСкладе = Объект.Товары.Добавить();
		СтрокаНаСкладе.Номенклатура = Номенклатура;
		СтрокаНаСкладе.ХарактеристикаНоменклатуры = ХарактеристикаНоменклатуры;
		ТоварыНоменклатураПриИзмененииНаСервере(СтрокаНаСкладе.ПолучитьИдентификатор());
		СтрокаНаСкладе.Количество = Количество;
		СтрокаНаСкладе.ЕдиницаИзмерения = ЕдиницаИзмерения;
		СтрокаНаСкладе.Коэффициент = Коэффициент;
		КоличествоНаСкладе = СтрокаНаСкладе.Количество;
		
	Иначе
		
		СтрокаНаСкладе = СтрокаНаСкладе[0];
		СтрокаНаСкладе.Количество = СтрокаНаСкладе.Количество + Количество;
		КоличествоНаСкладе = СтрокаНаСкладе.Количество;
		
	КонецЕсли;
	
	Если Количество = 0 Тогда
		
		Если КоличествоНаСкладе > КоличествоВПроизводстве Тогда
			
			КоличествоНаСкладе = КоличествоВПроизводстве;
			
		КонецЕсли;
		
		КоличествоВЦехе = КоличествоВПроизводстве - КоличествоНаСкладе;
		
	КонецЕсли;
	
	Если (КоличествоВЦехе + КоличествоНаСкладе) > КоличествоВПроизводстве Тогда
		
		КоличествоНаСкладе = КоличествоВПроизводстве - КоличествоВЦехе;
		СтрокаНаСкладе.Количество = КоличествоНаСкладе;
		
	КонецЕсли;
	
	КоличествоВЦехе = КоличествоВПроизводстве - КоличествоНаСкладе;
	
	Если КоличествоВЦехе <> 0 Тогда
		
		Если СтрокаВЦехе = Неопределено Тогда
			
			СтрокаВЦехе = ТоварыВЦехе.Добавить();
			СтрокаВЦехе.Номенклатура = Номенклатура;
			СтрокаВЦехе.ХарактеристикаНоменклатуры = ХарактеристикаНоменклатуры;
			СтрокаВЦехе.ЕдиницаИзмерения = ЕдиницаИзмерения;
			СтрокаВЦехе.Коэффициент = Коэффициент;
			СтрокаВЦехе.КартинкаПрослеживаемогоТовара = КартинкаПрослеживаемогоТовара;
			СтрокаВЦехе.ПрослеживаемыйТовар = ПрослеживаемыйТовар;

		КонецЕсли;
		
		СтрокаВЦехе.Количество = КоличествоВЦехе;
		
	КонецЕсли;
	
	Если СтрокаВЦехе <> Неопределено
		И СтрокаВЦехе.Количество = 0 Тогда
		
		ТоварыВЦехе.Удалить(СтрокаВЦехе);
		
	КонецЕсли;
	
	Если СтрокаНаСкладе <> Неопределено
		И СтрокаНаСкладе.Количество = 0 Тогда
		
		// Удалим коды маркировки
		НайденныеКМ = Объект.КодыМаркировки.НайтиСтроки(
			Новый Структура("ИдентификаторТовара", СтрокаНаСкладе.ИдентификаторТовара));
		
		Для Каждого ТекущаяСтрока Из НайденныеКМ Цикл
			
			Объект.КодыМаркировки.Удалить(ТекущаяСтрока);
			
		КонецЦикла;
		
		Объект.Товары.Удалить(СтрокаНаСкладе);
		
	КонецЕсли;
	
	КоличествоВЦехе = ТоварыВЦехе.Итог("Количество");
	
КонецПроцедуры

// Возврат товаров в производство
//
&НаКлиенте
Процедура ВернутьТоварыВПроизводство(
		Знач Номенклатура,
		Знач ХарактеристикаНоменклатуры,
		Знач Количество,
		Знач ЕдиницаИзмерения,
		Знач Коэффициент,
		Знач КартинкаПрослеживаемогоТовара,
		Знач ПрослеживаемыйТовар)
	
	СтруктураПоиска = Новый Структура();
	СтруктураПоиска.Вставить("Номенклатура", Номенклатура);
	СтруктураПоиска.Вставить("ХарактеристикаНоменклатуры", ХарактеристикаНоменклатуры);
	
	СтрокаВПроизводстве = ТоварыВПроизводстве.НайтиСтроки(СтруктураПоиска);
	
	Если СтрокаВПроизводстве.Количество() = 0 Тогда
		
		КоличествоВПроизводстве = 0;
		
	Иначе
		
		КоличествоВПроизводстве = СтрокаВПроизводстве[0].Количество;
		
	КонецЕсли;
	
	СтрокаНаСкладе = Объект.Товары.НайтиСтроки(СтруктураПоиска);
	
	Если СтрокаНаСкладе.Количество() = 0 Тогда
		
		СтрокаНаСкладе = Неопределено;
		КоличествоНаСкладе = 0;
		
	Иначе
		
		СтрокаНаСкладе = СтрокаНаСкладе[0];
		СтрокаНаСкладе.Количество = СтрокаНаСкладе.Количество - Количество;
		
		Если СтрокаНаСкладе.Количество < 0 Тогда
			
			СтрокаНаСкладе.Количество = 0;
			
		КонецЕсли;
		
		КоличествоНаСкладе = СтрокаНаСкладе.Количество;
		
	КонецЕсли;
	
	СтрокаВЦехе = ТоварыВЦехе.НайтиСтроки(СтруктураПоиска);
	
	Если СтрокаВЦехе.Количество() = 0 Тогда
		
		СтрокаВЦехе = ТоварыВЦехе.Добавить();
		СтрокаВЦехе.Номенклатура = Номенклатура;
		СтрокаВЦехе.ХарактеристикаНоменклатуры = ХарактеристикаНоменклатуры;
		СтрокаВЦехе.Количество = Количество;
		СтрокаВЦехе.ЕдиницаИзмерения = ЕдиницаИзмерения;
		СтрокаВЦехе.Коэффициент = Коэффициент;
		КоличествоВЦехе = СтрокаВЦехе.Количество;
		СтрокаВЦехе.КартинкаПрослеживаемогоТовара = КартинкаПрослеживаемогоТовара;
		СтрокаВЦехе.ПрослеживаемыйТовар = ПрослеживаемыйТовар;
	Иначе
		
		СтрокаВЦехе = СтрокаВЦехе[0];
		СтрокаВЦехе.Количество = СтрокаВЦехе.Количество + Количество;
		КоличествоВЦехе = СтрокаВЦехе.Количество;
		
	КонецЕсли;
	
	Если (КоличествоВЦехе + КоличествоНаСкладе) > КоличествоВПроизводстве Тогда
		
		КоличествоВЦехе = КоличествоВПроизводстве - КоличествоНаСкладе;
		СтрокаВЦехе.Количество = КоличествоВЦехе;
		
	КонецЕсли;
	
	КоличествоНаСкладе = КоличествоВПроизводстве - КоличествоВЦехе;
	
	Если КоличествоНаСкладе <> 0 Тогда
		
		Если СтрокаНаСкладе = Неопределено Тогда
			
			СтрокаНаСкладе = Объект.Товары.Добавить();
			СтрокаНаСкладе.Номенклатура = Номенклатура;
			СтрокаНаСкладе.ХарактеристикаНоменклатуры = ХарактеристикаНоменклатуры; 
			СтрокаНаСкладе.ЕдиницаИзмерения = ЕдиницаИзмерения;
			СтрокаНаСкладе.Коэффициент = Коэффициент;
			
			ТоварыНоменклатураПриИзмененииНаСервере(СтрокаНаСкладе.ПолучитьИдентификатор());
			
		КонецЕсли;
		
		СтрокаНаСкладе.Количество = КоличествоНаСкладе;
		
	КонецЕсли;
	
	Если СтрокаВЦехе <> Неопределено И СтрокаВЦехе.Количество = 0 Тогда
		
		ТоварыВЦехе.Удалить(СтрокаВЦехе);
		
	КонецЕсли;
	
	Если СтрокаНаСкладе <> Неопределено И СтрокаНаСкладе.Количество = 0 Тогда
		
		// Удалим коды маркировки
		НайденныеКМ = Объект.КодыМаркировки.НайтиСтроки(
			Новый Структура("ИдентификаторТовара", СтрокаНаСкладе.ИдентификаторТовара));
		
		Для Каждого ТекущаяСтрока Из НайденныеКМ Цикл
			
			Объект.КодыМаркировки.Удалить(ТекущаяСтрока);
			
		КонецЦикла;
		
		Объект.Товары.Удалить(СтрокаНаСкладе);
		
	КонецЕсли;
	
	КоличествоВЦехе = ТоварыВЦехе.Итог("Количество");
	
КонецПроцедуры

&НаСервере
Процедура ТоварыНоменклатураПриИзмененииНаСервере(ИдентификаторСтроки, ПараметрыДействия = Неопределено)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	// Вызываем обработчик изменения данных объекта
	Документы.ИзвлечениеТоваровИзПроизводства.ТоварыНоменклатураПриИзменении(Объект, ТекущаяСтрока, ПараметрыДействия);
	
	// Вызываем общий обработчик изменения реквизитов формы
	УправлениеДиалогомДокументаСервер.НоменклатураПриИзменении(ЭтотОбъект, ТекущаяСтрока, ПараметрыДействия);
	
КонецПроцедуры

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

&НаСервере
Процедура НастроитьПараметрыВыбораЭлементовФормы()
	
	УправлениеДиалогомДокументаСервер.НастроитьПараметрыВыбораЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры 

// Производит настройку параметров отображения элементов управления диалога в зависимости от значений реквизитов
// объекта.
//
&НаСервере
Процедура УправлениеДиалогомНаСервере()
	
	// Вызываем общий обработчик действия
	УправлениеДиалогомДокументаСервер.УправлениеДиалогомНаСервере(ЭтотОбъект);
	
КонецПроцедуры // УправлениеДиалогомНаСервере()

// Производит настройку условного оформления формы.
//
&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Вызываем общий обработчик действия
	УправлениеДиалогомДокументаСервер.УстановитьУсловноеОформление(ЭтотОбъект);
	
	УправлениеДиалогомДокументаСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтотОбъект,
		"ТоварыВЦехеХарактеристикаНоменклатуры",
		"ТоварыВЦехе.ВладелецХарактеристики"
	);
	// Маркировка
	МаркировкаТоваровСервер.УстановитьУсловноеОформлениеКодыМаркировок(ЭтотОбъект);
	// Конец Маркировка
	
КонецПроцедуры

// Обработчик события возникающего при оповещении данной формы о прекращении работы подчиненной в контексте сервера.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаСервере
Процедура ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры=Неопределено)
	
	Если ДополнительныеПараметры = "РедактированиеКодовМаркировкиСтрокиТовара" Тогда
		
		РезультатОповещения.Вставить("НеПерерасчитыватьКоличествоТовара", Истина);
		
	КонецЕсли;
	
	// Вызываем общий обработчик события
	Если НЕ УправлениеДиалогомДокументаСервер.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	// Обновляем отображение элементов формы
	УправлениеДиалогомНаСервере();
	
КонецПроцедуры // ОбработкаРезультатаОповещенияНаСервере()

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаОповещения(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	// Вызываем общий обработчик события в контексте клиента
	Если НЕ УправлениеДиалогомДокументаКлиент.ОбработкаРезультатаОповещения(ЭтотОбъект, РезультатОповещения, ДополнительныеПараметры) Тогда
		Возврат;
	КонецЕсли;
	
	// Обработаем событие в контексте сервера
	ОбработкаРезультатаОповещенияНаСервере(РезультатОповещения, ДополнительныеПараметры);
	
	// Вызываем обработчик результата выполнения
	ОбработкаРезультатаВыполненияДействия(РезультатОповещения);
	
КонецПроцедуры // Подключаемый_ОбработкаРезультатаОповещения()

// Отображает результат выполнения действия.
//
// Параметры:
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
&НаКлиенте
Процедура ОбработкаРезультатаВыполненияДействия(ПараметрыДействия)
	
	// Вызываем общий обработчик проверки необходимости выполнения пересчета табличных частей объекта.
	ОбработкаРеквизитовДокументаКлиент.ПолучитьРазрешенияДляПересчета(ЭтотОбъект, ПараметрыДействия);
	
	// Вызываем общий обработчик результата выполнения действия
	УправлениеДиалогомДокументаКлиент.ОбработкаРезультатаВыполненияДействия(ЭтотОбъект, ПараметрыДействия);
	
КонецПроцедуры // ОбработкаРезультатаВыполненияДействия()

#КонецОбласти

#КонецОбласти
