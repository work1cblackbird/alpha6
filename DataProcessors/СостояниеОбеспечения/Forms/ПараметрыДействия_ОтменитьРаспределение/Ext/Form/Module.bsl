﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Заказ = Параметры.Заказ;
	Заголовок = СостояниеОбеспеченияСервер.ЗаголовокОкна(Заказ, "Отмена распределения для");
	ЗаполнитьТовары();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗакрытьПодчиненные" И ЭтотОбъект.ВладелецФормы = Источник Тогда
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если
		ВладелецФормы <> Неопределено
		И ВладелецФормы.ИмяФормы = "Обработка.СостояниеОбеспечения.Форма.Форма"
	Тогда
		
		ВладелецФормы.ОткрытаПодчиненнаяФорма = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ТоварыКВысвобождениюПриИзменении(Элемент)
	
	Товар = Элементы.Товары.ТекущиеДанные.ПолучитьРодителя();
	
	Если Товар = Неопределено Тогда
		
		РаспределитьКоличество(Элементы.Товары.ТекущиеДанные);
		Возврат;
		
	КонецЕсли;
	
	РассчитатьИтог(Товар);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтменитьРаспределение(Команда)
	
	КОтмене = ТоварыКОтменеРаспределения();
	
	Если НЕ ЗначениеЗаполнено(КОтмене) Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Нет корректных строк для выполнения отмены'"));
		Возврат;
		
	КонецЕсли;
	
	Закрыть(ВыполнитьОтменуРаспределения(Заказ, КОтмене, Комментарий));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементыУсловногоОформления = Новый Массив;
	
	ВыделениеГруппыШрифтом = ОбщегоНазначенияАвтосалон.НовыйЭлементОформления();
	ВыделениеГруппыШрифтом.Поля.Добавить(Элементы.Товары.Имя);
	Условие = ОбщегоНазначенияАвтосалон.НовоеУсловиеОформления();
	Условие.Левое = "Товары.МестоРазмещения";
	Условие.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ВыделениеГруппыШрифтом.Условия.Добавить(Условие);
	ВыделениеГруппыШрифтом.Оформление.Вставить("Шрифт", ШрифтыСтиля.СостояниеОбеспеченияШрифтГруппы);
	ЭлементыУсловногоОформления.Добавить(ВыделениеГруппыШрифтом);
	
	СкрытиеКолонокНоменклатуры = ОбщегоНазначенияАвтосалон.НовыйЭлементОформления();
	СкрытиеКолонокНоменклатуры.Поля.Добавить(Элементы.ТоварыНоменклатура.Имя);
	СкрытиеКолонокНоменклатуры.Поля.Добавить(Элементы.ТоварыХарактеристика.Имя);
	Условие = ОбщегоНазначенияАвтосалон.НовоеУсловиеОформления();
	Условие.Левое = "Товары.МестоРазмещения";
	Условие.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	СкрытиеКолонокНоменклатуры.Условия.Добавить(Условие);
	СкрытиеКолонокНоменклатуры.Оформление.Вставить("Отображать", Ложь);
	ЭлементыУсловногоОформления.Добавить(СкрытиеКолонокНоменклатуры);
	
	ВыделениеНеКорректногоКоличества = ОбщегоНазначенияАвтосалон.НовыйЭлементОформления();
	ВыделениеНеКорректногоКоличества.Поля.Добавить(Элементы.ТоварыКВысвобождению.Имя);
	Условие = ОбщегоНазначенияАвтосалон.НовоеУсловиеОформления();
	Условие.Левое = "Товары.КВысвобождению";
	Условие.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	Условие.Правое = "Товары.Распределено";
	ВыделениеНеКорректногоКоличества.Условия.Добавить(Условие);
	ВыделениеНеКорректногоКоличества.Оформление.Вставить("ЦветФона", ЦветаСтиля.ЦветФонаНекорректногоКонтрагентаВДокументе);
	ЭлементыУсловногоОформления.Добавить(ВыделениеНеКорректногоКоличества);
	
	ОбщегоНазначенияАвтосалон.УстановитьУсловноеОформление(УсловноеОформление.Элементы, ЭлементыУсловногоОформления);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТовары()
	
	Построитель = Новый ПостроительЗапроса(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказыРаспределениеОстатки.Номенклатура КАК Номенклатура,
	|	ЗаказыРаспределениеОстатки.ХарактеристикаНоменклатуры КАК Характеристика,
	|	ЗаказыРаспределениеОстатки.ЗаказПоставщика КАК МестоРазмещения,
	|	ЗаказыРаспределениеОстатки.КоличествоОстаток КАК КВысвобождению,
	|	ЗаказыРаспределениеОстатки.КоличествоОстаток КАК Распределено
	|ИЗ
	|	РегистрНакопления.ЗаказыРаспределение.Остатки(, ЗаказПокупателя = &Заказ {(Номенклатура), (ХарактеристикаНоменклатуры)}) КАК ЗаказыРаспределениеОстатки
	|ИТОГИ
	|	СУММА(КВысвобождению),
	|	СУММА(Распределено)
	|ПО
	|	Номенклатура,
	|	Характеристика");
	Построитель.Параметры.Вставить("Заказ", Параметры.Заказ);
	
	Если ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		
		НовыйЭлемент = Построитель.Отбор.Добавить("Номенклатура");
		НовыйЭлемент.ВидСравнения = ВидСравнения.Равно;
		НовыйЭлемент.Значение = Параметры.Номенклатура;
		НовыйЭлемент.Использование = Истина;
		
		НовыйЭлемент = Построитель.Отбор.Добавить("ХарактеристикаНоменклатуры");
		НовыйЭлемент.ВидСравнения = ВидСравнения.Равно;
		НовыйЭлемент.Значение = Параметры.ХарактеристикаНоменклатуры;
		НовыйЭлемент.Использование = Истина;
		
	КонецЕсли;
	
	Построитель.Выполнить();
	ЗаполнитьДеревоТоваровПоПостроителю(Построитель);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоТоваровПоПостроителю(Построитель)
	
	Если Построитель.Результат.Пустой() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ВыборкаНоменклатура = Построитель.Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ЭлементыТоваров = Товары.ПолучитьЭлементы();
	
	Пока ВыборкаНоменклатура.Следующий() Цикл
		
		ВыборкаХарактеристика = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаХарактеристика.Следующий() Цикл
			
			НовыйТовар = ЭлементыТоваров.Добавить();
			Выборка = ВыборкаХарактеристика.Выбрать();
			ЗаполнитьЗначенияСвойств(НовыйТовар, ВыборкаХарактеристика);
			
			Пока Выборка.Следующий() Цикл
				
				ЗаполнитьЗначенияСвойств(НовыйТовар.ПолучитьЭлементы().Добавить(), Выборка);
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьКоличество(Товар)
	
	Осталось = Товар.КВысвобождению;
	
	Для Каждого Строка Из Товар.ПолучитьЭлементы() Цикл
		
		Строка.КВысвобождению = Мин(Осталось, Строка.Распределено);
		Осталось = Осталось - Строка.КВысвобождению;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьИтог(Товар)
	
	Итог = 0;
	
	Для Каждого Строка Из Товар.ПолучитьЭлементы() Цикл
		
		Итог = Итог + Строка.КВысвобождению;
		
	КонецЦикла;
	
	Товар.КВысвобождению = Итог;
	
КонецПроцедуры

&НаКлиенте
Функция ТоварыКОтменеРаспределения()
	
	КОтмене = Новый Массив;
	Отказ = Ложь;
	
	Для Каждого Товар Из Товары.ПолучитьЭлементы() Цикл
		Для Каждого Место Из Товар.ПолучитьЭлементы() Цикл
			
			Если Место.КВысвобождению <= 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Если Место.КВысвобождению > Место.Распределено Тогда
				Отказ = Истина;
				Продолжить;
			КонецЕсли;
			
			Элемент = Новый Структура("Номенклатура,ХарактеристикаНоменклатуры,Количество,ЗаказПоставщика");
			ЗаполнитьЗначенияСвойств(Элемент, Место);
			Элемент.ХарактеристикаНоменклатуры = Место.Характеристика;
			Элемент.Количество = Место.КВысвобождению;
			Элемент.ЗаказПоставщика = Место.МестоРазмещения;
			КОтмене.Добавить(Элемент);
			
		КонецЦикла;
	КонецЦикла;
	
	Если Отказ Тогда
		
		Возврат Новый Соответствие;
		
	КонецЕсли;
	
	ТоварыПоМестам = Новый Соответствие;
	
	Для Каждого Товар Из КОтмене Цикл
		
		Значение = ТоварыПоМестам.Получить(Товар.ЗаказПоставщика);
		
		Если Значение = Неопределено Тогда
			
			Значение = Новый Массив;
			
		КонецЕсли;
		
		Значение.Добавить(Товар);
		ТоварыПоМестам.Вставить(Товар.ЗаказПоставщика, Значение);
		
	КонецЦикла;
	
	Возврат ТоварыПоМестам;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВыполнитьОтменуРаспределения(Заказ, КОтмене, Комментарий)
	
	ЗаказыПоставщикам = Новый Массив;
	ЗаказыВнутренние = Новый Массив;
	
	Для Каждого КлючЗначение Из КОтмене Цикл
		
		Если ТипЗнч(КлючЗначение.Ключ) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
			
			ЗаказыПоставщикам.Добавить(КлючЗначение.Ключ);
			Продолжить;
			
		КонецЕсли;
		
		ЗаказыВнутренние.Добавить(КлючЗначение.Ключ);
		
	КонецЦикла;
	
	КонтрагентыЗаказов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ЗаказыПоставщикам, "Контрагент");
	ПодразделенияЗаказов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ЗаказыВнутренние, "ПодразделениеКомпании");
	
	ДокументыПоОбъектам = Новый Соответствие;
	
	Для Каждого КлючЗначение Из КОтмене Цикл
		ЭтоЗаказПоставщику = ТипЗнч(КлючЗначение.Ключ) = Тип("ДокументСсылка.ЗаказПоставщику");
		
		Объект = ?(
			ЭтоЗаказПоставщику,
			КонтрагентыЗаказов.Получить(КлючЗначение.Ключ),
			ПодразделенияЗаказов.Получить(КлючЗначение.Ключ));
		
		Документ = ДокументыПоОбъектам.Получить(Объект);
		
		Если Документ = Неопределено Тогда
			
			Документ = Документы.СнятиеРаспределенияЗаказовПокупателя.СоздатьДокумент();
			Документ.Заполнить(Неопределено);
			Документ.ДокументОснование = Заказ;
			Документ.Контрагент = Объект;
			Документ.Комментарий = Комментарий;
			
			Если НЕ ЭтоЗаказПоставщику Тогда
				
				Документ.ХозОперация = Справочники.ХозОперации.СнятиеРаспределенияВнутреннего;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Для Каждого Товар Из КлючЗначение.Значение Цикл
			
			НоваяСтрока = Документ.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Товар);
			Документы.СнятиеРаспределенияЗаказовПокупателя.ТоварыНоменклатураПриИзменении(Документ, НоваяСтрока);
			
		КонецЦикла;
		
		ДокументыПоОбъектам.Вставить(Объект, Документ);
		
	КонецЦикла;
	
	СозданныеДокументы = Новый Массив;
	
	;
	
	Для Каждого КлючЗначение Из ДокументыПоОбъектам Цикл
		
		НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
		Попытка
			
			КлючЗначение.Значение.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Оперативный);
			СозданныеДокументы.Добавить(КлючЗначение.Значение.Ссылка);
			ЗафиксироватьТранзакцию();

		Исключение
			
			ОтменитьТранзакцию();
			ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат Новый ФиксированныйМассив(Новый Массив);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(СозданныеДокументы);
	
КонецФункции

#КонецОбласти
