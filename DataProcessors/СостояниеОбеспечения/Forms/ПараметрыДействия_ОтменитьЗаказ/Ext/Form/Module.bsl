﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Заказ = Параметры.Заказ;
	Заголовок = СостояниеОбеспеченияСервер.ЗаголовокОкна(Заказ, "Отмена заказа для");
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

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтменитьЗаказ(Команда)
	
	Отказ = Ложь;
	
	КОтмене = ТоварыКОтменеРаспределенияРезерва(Отказ);
	
	Если Отказ Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Нет корректных строк для выполнения отмены'"));
		Возврат;
		
	КонецЕсли;
	
	Закрыть(ВыполнитьОтменуЗаказа(Заказ, КОтмене, Комментарий));
	
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
	
	ОбщегоНазначенияАвтосалон.УстановитьУсловноеОформление(УсловноеОформление.Элементы, ЭлементыУсловногоОформления);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТовары()
	
	Построитель = Новый ПостроительЗапроса(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказыПокупателейОстатки.Номенклатура КАК Номенклатура,
	|	ЗаказыПокупателейОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ЗаказыПокупателейОстатки.СкладКомпании КАК СкладКомпании,
	|	ЗаказыПокупателейОстатки.ЗаказаноОстаток КАК ЗаказаноОстаток,
	|	ЗаказыПокупателейОстатки.РезервОстаток КАК РезервОстаток,
	|	ЗаказыПокупателейОстатки.РезервСвободныйОстаток КАК РезервСвободныйОстаток,
	|	NULL КАК ЗаказПоставщика,
	|	NULL КАК КоличествоОстаток
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	РегистрНакопления.ЗаказыПокупателей.Остатки(, Заказ = &Заказ) КАК ЗаказыПокупателейОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗаказыРаспределениеОстатки.Номенклатура,
	|	ЗаказыРаспределениеОстатки.ХарактеристикаНоменклатуры,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ЗаказыРаспределениеОстатки.ЗаказПоставщика,
	|	ЗаказыРаспределениеОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ЗаказыРаспределение.Остатки(, ЗаказПокупателя = &Заказ) КАК ЗаказыРаспределениеОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ.Номенклатура КАК Номенклатура,
	|	ВТ.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ВТ.СкладКомпании КАК СкладКомпании,
	|	ВТ.ЗаказаноОстаток КАК ИзЗаказа,
	|	ВТ.РезервОстаток КАК ВРезерве,
	|	ВТ.ЗаказПоставщика КАК МестоРазмещения,
	|	ВТ.КоличествоОстаток КАК Распределено,
	|	ВТ.ЗаказаноОстаток КАК Количество
	|ИЗ
	|	ВТ КАК ВТ
	|ИТОГИ
	|	МАКСИМУМ(Количество),
	|	СУММА(ИзЗаказа),
	|	СУММА(ВРезерве),
	|	СУММА(Распределено)
	|ПО
	|	Номенклатура,
	|	ХарактеристикаНоменклатуры");
	
	Построитель.Параметры.Вставить("Заказ", Параметры.Заказ);
	
	Построитель.Выполнить();
	ЗаполнитьДеревоТоваровПоПостроителю(Построитель);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоТоваровПоПостроителю(Построитель)
	
	Если Построитель.Результат.Пустой() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ВыборкаНоменклатура = Построитель.Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ЭлементыТоваров = ТоварыДерево.ПолучитьЭлементы();
	
	Пока ВыборкаНоменклатура.Следующий() Цикл
		
		ВыборкаХарактеристика = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаХарактеристика.Следующий() Цикл
			
			НовыйТовар = ЭлементыТоваров.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйТовар, ВыборкаХарактеристика);
			НовыйТовар.Характеристика = ВыборкаХарактеристика.ХарактеристикаНоменклатуры;
			
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаХарактеристика);
			НоваяСтрока.Характеристика = ВыборкаХарактеристика.ХарактеристикаНоменклатуры;
			НоваяСтрока.ИдентификаторСтрокиДерева = НовыйТовар.ПолучитьИдентификатор();
			
			Выборка = ВыборкаХарактеристика.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				ЗаполнитьЗначенияСвойств(НовыйТовар.ПолучитьЭлементы().Добавить(), Выборка);
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ТоварыКОтменеРаспределенияРезерва(Отказ)
	
	КОтмене = Новый Массив;
	
	Для Каждого Товар Из Товары Цикл
		
		Если Товар.Количество = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если Товар.Количество > Товар.ИзЗаказа Тогда
			Отказ = Истина;
			Прервать;
		КонецЕсли;
		
		Свободно = Товар.ИзЗаказа - Товар.ВРезерве - Товар.Распределено;
		
		Если Свободно >= Товар.Количество Тогда
			Продолжить;
		Иначе
			НадоСнять = Товар.Количество - Свободно;
		КонецЕсли;
		
		СтрокаТовар = ТоварыДерево.НайтиПоИдентификатору(Товар.ИдентификаторСтрокиДерева);
		
		Если ПриоритетРезервированиеРаспределение Тогда
			
			// Снимаем распределение
			Для Каждого Товар Из СтрокаТовар.ПолучитьЭлементы() Цикл
				
				Если Товар.Распределено = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				Элемент = Новый Структура("Номенклатура,ХарактеристикаНоменклатуры,Количество,ЗаказПоставщика");
				ЗаполнитьЗначенияСвойств(Элемент, Товар);
				Элемент.ХарактеристикаНоменклатуры = СтрокаТовар.Характеристика;
				Элемент.Количество = Мин(Товар.Распределено, НадоСнять);
				Элемент.ЗаказПоставщика = Товар.МестоРазмещения;
				КОтмене.Добавить(Элемент);
				НадоСнять = НадоСнять - Элемент.Количество;
				
				Если НадоСнять = 0 Тогда
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
			Если НадоСнять = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			// Если еще что-то осталось - то снимаем резервы 
			
			Для Каждого Товар Из СтрокаТовар.ПолучитьЭлементы() Цикл
				
				Если Товар.ВРезерве = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				Элемент = Новый Структура("Номенклатура,ХарактеристикаНоменклатуры,Количество,СкладКомпании");
				ЗаполнитьЗначенияСвойств(Элемент, Товар);
				Элемент.ХарактеристикаНоменклатуры = СтрокаТовар.Характеристика;
				Элемент.Количество = Мин(Товар.ВРезерве, НадоСнять);
				Элемент.СкладКомпании = Товар.СкладКомпании;
				КОтмене.Добавить(Элемент);
				НадоСнять = НадоСнять - Элемент.Количество;
				
				Если НадоСнять = 0 Тогда
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе
			// Сначала снимаем резерв, а потом если нужно - распределение...
			
			Для Каждого Товар Из СтрокаТовар.ПолучитьЭлементы() Цикл
				
				Если Товар.ВРезерве = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				Элемент = Новый Структура("Номенклатура,ХарактеристикаНоменклатуры,Количество,СкладКомпании");
				ЗаполнитьЗначенияСвойств(Элемент, Товар);
				Элемент.ХарактеристикаНоменклатуры = СтрокаТовар.Характеристика;
				Элемент.Количество = Мин(Товар.ВРезерве, НадоСнять);
				Элемент.СкладКомпании = Товар.СкладКомпании;
				КОтмене.Добавить(Элемент);
				НадоСнять = НадоСнять - Элемент.Количество;
				
				Если НадоСнять = 0 Тогда
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
			Если НадоСнять = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого Товар Из СтрокаТовар.ПолучитьЭлементы() Цикл
				
				Если Товар.Распределено = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				Элемент = Новый Структура("Номенклатура,ХарактеристикаНоменклатуры,Количество,ЗаказПоставщика");
				ЗаполнитьЗначенияСвойств(Элемент, Товар);
				Элемент.ХарактеристикаНоменклатуры = СтрокаТовар.Характеристика;
				Элемент.Количество = Мин(Товар.Распределено, НадоСнять);
				Элемент.ЗаказПоставщика = Товар.МестоРазмещения;
				КОтмене.Добавить(Элемент);
				НадоСнять = НадоСнять - Элемент.Количество;
				
				Если НадоСнять = 0 Тогда
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ТоварыПоМестам = Новый Соответствие;
	
	Для Каждого Товар Из КОтмене Цикл
		
		Если Товар.Свойство("ЗаказПоставщика") Тогда
			
			Значение = ТоварыПоМестам.Получить(Товар.ЗаказПоставщика);
			
			Если Значение = Неопределено Тогда
				
				Значение = Новый Массив;
				
			КонецЕсли;
			
			Значение.Добавить(Товар);
			ТоварыПоМестам.Вставить(Товар.ЗаказПоставщика, Значение);
			
		Иначе
			
			Значение = ТоварыПоМестам.Получить(Товар.СкладКомпании);
			
			Если Значение = Неопределено Тогда
				
				Значение = Новый Массив;
				
			КонецЕсли;
			
			Значение.Добавить(Товар);
			ТоварыПоМестам.Вставить(Товар.СкладКомпании, Значение);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТоварыПоМестам;
	
КонецФункции

&НаСервере
Функция ВыполнитьОтменуЗаказа(Заказ, КОтмене, Комментарий)
	
	ЗаказыПоставщикам = Новый Массив;
	ЗаказыВнутренние = Новый Массив;
	
	СнятиеРезерва = Документы.СнятиеРезервовЗаказовПокупателя.СоздатьДокумент();
	СнятиеРезерва.Комментарий = Комментарий;
	СнятиеРезерва.Заполнить(Заказ);
	СнятиеРезерва.Товары.Очистить();
	
	Для Каждого КлючЗначение Из КОтмене Цикл
		
		Если ТипЗнч(КлючЗначение.Ключ) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
			
			ЗаказыПоставщикам.Добавить(КлючЗначение.Ключ);
			
		ИначеЕсли ТипЗнч(КлючЗначение.Ключ) = Тип("ДокументСсылка.ЗаказВнутренний") Тогда
			
			ЗаказыВнутренние.Добавить(КлючЗначение.Ключ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	КонтрагентыЗаказов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ЗаказыПоставщикам, "Контрагент");
	ПодразделенияЗаказов = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ЗаказыВнутренние, "ПодразделениеКомпании");
	
	ДокументыПоОбъектам = Новый Соответствие;
	
	Для Каждого КлючЗначение Из КОтмене Цикл
		
		Если ТипЗнч(КлючЗначение.Ключ) = Тип("СправочникСсылка.СкладыКомпании") Тогда
			
			Для Каждого Товар Из КлючЗначение.Значение Цикл
				
				НоваяСтрока = СнятиеРезерва.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Товар);
				Документы.СнятиеРезервовЗаказовПокупателя.ТоварыНоменклатураПриИзменении(СнятиеРезерва, НоваяСтрока);
				НоваяСтрока.ЗаказПокупателя = Заказ;
				НоваяСтрока.МестоРазмещения = Товар.СкладКомпании;
				
			КонецЦикла;
			
			Продолжить;
			
		КонецЕсли;
		
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
	
	Если СнятиеРезерва.Товары.Количество() > 0 Тогда
		
		ДокументыПоОбъектам.Вставить("СнятиеРезерва", СнятиеРезерва);
		
	КонецЕсли;
	
	// Создадим документ Корректировка заказа
	
	Документ = Документы.КорректировкаЗаказаПокупателя.СоздатьДокумент();
	Документ.Заполнить(Заказ);
	Документ.Комментарий = Комментарий;
	
	Для Каждого Строка Из Документ.Товары Цикл
		
		НоваяСтрока = Товары.НайтиСтроки(Новый Структура("Номенклатура, Характеристика", Строка.Номенклатура, Строка.ХарактеристикаНоменклатуры));
		
		Если НоваяСтрока.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = НоваяСтрока[0];
		
		Строка.Количество = Строка.Количество - НоваяСтрока.Количество;

		Документы.КорректировкаЗаказаПокупателя.ТоварыКоличествоПриИзменении(Документ, Строка);

	КонецЦикла;
	
	СозданныеДокументы = Новый Массив;
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	
	Для Каждого КлючЗначение Из ДокументыПоОбъектам Цикл
		
		Попытка
			
			КлючЗначение.Значение.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Оперативный);
			СозданныеДокументы.Добавить(КлючЗначение.Значение.Ссылка);
			
		Исключение
			
			ОтменитьТранзакцию();
			ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			Возврат Новый ФиксированныйМассив(Новый Массив);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Попытка
		
		Документ.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Оперативный);
		СозданныеДокументы.Добавить(Документ.Ссылка);
		
	Исключение
		
		ОтменитьТранзакцию();
		ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		Возврат Новый ФиксированныйМассив(Новый Массив);
		
	КонецПопытки;
	
	ЗафиксироватьТранзакцию();
	
	Возврат Новый ФиксированныйМассив(СозданныеДокументы);
	
КонецФункции

#КонецОбласти
