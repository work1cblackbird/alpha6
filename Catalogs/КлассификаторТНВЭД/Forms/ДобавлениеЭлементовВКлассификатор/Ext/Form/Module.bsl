﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();

	ИмяСправочника 			= "КлассификаторТНВЭД";
	
	Элементы.Классификатор.МножественныйВыбор = Истина;
	ЗакрыватьПриВыборе = Ложь;
		
	ИнициализироватьКлассификатор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКлассификатор

// Вызывается при двойном щелчке мыши или нажатии Enter
//
&НаКлиенте
Процедура КлассификаторВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДобавленыНовыеЭлементыКлассификатора = Ложь;
	ВыбранныйЭлемент = КлассификаторВыборНаСервере(ВыбраннаяСтрока, ДобавленыНовыеЭлементыКлассификатора);
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ОповеститьФормуИПользователяИЗакрыть(ВыбранныйЭлемент, ДобавленыНовыеЭлементыКлассификатора);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при нажатии на кнопку выбрать
//
&НаКлиенте
Процедура КлассификаторВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДобавленыНовыеЭлементыКлассификатора = Ложь;
	ВыбранныйЭлемент = КлассификаторВыборНаСервере(Значение, ДобавленыНовыеЭлементыКлассификатора);
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ОповеститьФормуИПользователяИЗакрыть(ВыбранныйЭлемент, ДобавленыНовыеЭлементыКлассификатора);
	КонецЕсли;
	Закрыть();
	
КонецПроцедуры

// Функция обрабатывает данные выбора пользователя
//
// В случае, если выбранные элементы классификатора отсутствуют в справочнике
// они будут добавлены.
//
// Если был осуществлен множественный выбор, то все выбранные элементы будут обработаны
// (добавлены в справочник в случае отсутствия), в возвращаемый параметр, будет передан
// массив ссылок на элементы.
//
// Параметры:
// ВыбранныеСтроки - Массив, массив выбранных строк таблицы формы классификатор
// ДобавленыНовыеЭлементыКлассификатора - Булево, флаг устанавливается 
//  если в справочник были добавлены элементы.
//
// Возвращаемое значение:
// Неопределено или СправочникСсылка: 
// 		КлассификаторВидовЭкономическойДеятельности 
// 		или  КлассификаторПродукцииПоВидамДеятельности 
//		или КлассификаторУслугНаселению
//
&НаСервере
Функция КлассификаторВыборНаСервере(Знач ВыбранныеСтроки, ДобавленыНовыеЭлементыКлассификатора = Ложь)

	СсылкаНаЭлемент = Неопределено;
	
	МассивСсылок = Новый Массив();
	
	Если ТипЗнч(ВыбранныеСтроки) = тип("Массив") Тогда
		
		Для Каждого ИдентификаторСтроки Из ВыбранныеСтроки Цикл
			
			Элемент = Классификатор.НайтиПоИдентификатору(ИдентификаторСтроки);
			
			Если НЕ ЗначениеЗаполнено(Элемент.Ссылка) Тогда
				
				ДобавитьЭлементКлассификатора(Элемент);
				ДобавленыНовыеЭлементыКлассификатора = Истина;
				
			КонецЕсли;
			
			МассивСсылок.Добавить(Элемент.Ссылка);
			СсылкаНаЭлемент = Элемент.Ссылка;
			
		КонецЦикла;	
		
	ИначеЕсли ТипЗнч(ВыбранныеСтроки) = тип("Число") Тогда	
		
		Элемент = Классификатор.НайтиПоИдентификатору(ВыбранныеСтроки);
		
		Если НЕ ЗначениеЗаполнено(Элемент.Ссылка) Тогда
			
			ДобавитьЭлементКлассификатора(Элемент);
			ДобавленыНовыеЭлементыКлассификатора = Истина;
			
		КонецЕсли;
		
		МассивСсылок.Добавить(Элемент.Ссылка);
		СсылкаНаЭлемент = Элемент.Ссылка;
		
	КонецЕсли;

	Если Подбор Тогда
		Возврат МассивСсылок;
	Иначе	
		Возврат СсылкаНаЭлемент;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Добавляет в коллекцию оформляемых полей компоновки данных новое поле
//
// Параметры:
//	КоллекцияОформляемыхПолей 	- коллекция оформляемых полей КД
//	ИмяПоля						- Строка - имя поля.
//
// Возвращаемое значение:
//	ОформляемоеПолеКомпоновкиДанных - созданное поле.
//
// Пример:
// 	Форма.УсловноеОформление.Элементы[0].Поля.
//
&НаСервере
Функция ДобавитьОформляемоеПоле(КоллекцияОформляемыхПолей, ИмяПоля)
	
	ПолеЭлемента 		= КоллекцияОформляемыхПолей.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных(ИмяПоля);

	Возврат ПолеЭлемента;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();

	// Классификатор

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Классификатор");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Классификатор.ЕстьСсылка", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветФонаВыделенияПоля);

КонецПроцедуры

&НаСервере
Функция ПолучитьРанееДобавленныеЭлементы()
	
	Запрос = Новый Запрос;
	ЗапросТекст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	%1.Код,
				   |	%1.Ссылка
	               |ИЗ
	               |	Справочник.%1 КАК %1";
				   
	МетаданныеСправочник = Метаданные.Справочники[ИмяСправочника];
	ТекстПараметра2 = "%1.";
	Запрос.Текст = СтрЗаменить(ЗапросТекст, "%1", ИмяСправочника);			   
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Функция ПолучитьЗначенияКлассификатораИзМакета()
	
	ТаблицаПоказателей = Новый ТаблицаЗначений;
	
	Макет = Справочники.КлассификаторТНВЭД.ПолучитьМакет("КлассификаторТоварнойНоменклатурыВнешнеэкономическойДеятельности");
	
	// В полученном макете содержатся значения всех списков используемых в отчете.
	// Ищем переданный.
	Список = Макет.Области.Найти("Строки");
	
	Если Список.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
		// заполнение дерева данными списка
		ВерхОбласти = Список.Верх;
		НизОбласти = Список.Низ;
		
		НомерКолонки = 1;
		Область = Макет.Область(ВерхОбласти - 1, НомерКолонки);
		ИмяКолонки = Область.Текст;
		ДлинаКодаКлассификатора = 7;
		
		Пока ЗначениеЗаполнено(ИмяКолонки) Цикл
			
			Если ИмяКолонки = "Код" Тогда
				ТаблицаПоказателей.Колонки.Добавить("Код", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(12)));
			ИначеЕсли ИмяКолонки = "Наименование" Тогда
				ТаблицаПоказателей.Колонки.Добавить("Наименование",Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(255)));
			ИначеЕсли ИмяКолонки = "ЕдиницаИзмерения" Тогда
				ТаблицаПоказателей.Колонки.Добавить("ЕдиницаИзмерения", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(3)));
			КонецЕсли;	
			
			НомерКолонки = НомерКолонки + 1;
			Область = Макет.Область(ВерхОбласти - 1, НомерКолонки);
			ИмяКолонки = Область.Текст;
			
		КонецЦикла;
		
		Для НомСтр = ВерхОбласти По НизОбласти Цикл
			// Отображаем только элементы
			
			Код = СокрП(Макет.Область(НомСтр, 1).Текст);
			Если СтрДлина(Код) = 2 Тогда
				Продолжить;
			КонецЕсли;
			СтрокаСписка = ТаблицаПоказателей.Добавить();
			
			Для Каждого Колонка Из ТаблицаПоказателей.Колонки Цикл
				
				ЗначениеКолонки = СокрП(Макет.Область(НомСтр, ТаблицаПоказателей.Колонки.Индекс(Колонка) + 1).Текст);
				СтрокаСписка[Колонка.Имя] = ЗначениеКолонки;
				
			КонецЦикла;
			
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаПоказателей.Сортировать(ТаблицаПоказателей.Колонки[0].Имя + " Возр");
	
	Возврат ТаблицаПоказателей;
	
КонецФункции

// Заполняет классификатор данными
//
&НаСервере
Процедура ЗаполнитьКлассификатор()
	
	Классификатор.Очистить();
	
	// Получаем полную таблицу элементов классификатора.
	// В таблице содержатся Код и Наименование, элементов классификатора.
	ЭлементыКлассификатораИзМакета = ПолучитьЗначенияКлассификатораИзМакета();
	
	// Получаем таблицу элементов классификатора уже имеющихся в справочнике.
	РанееДобавленныеЭлементыКлассификатора = ПолучитьРанееДобавленныеЭлементы();
	РанееДобавленныеЭлементыКлассификатора.Индексы.Добавить("Код");
	
	ЭлементыКлассификатора = ЭлементыКлассификатораИзМакета;
	
	Если ЭлементыКлассификатора.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Инициализируем структуру которую будем использовать для поиска существующих элементов.
	СтруктураПоискаРанееСозданных = Новый Структура();
	
	Для Каждого Элемент Из ЭлементыКлассификатора Цикл
		
		НоваяСтрока = Классификатор.Добавить();
		НоваяСтрока.Код   = Элемент.Код;
		
		Наименование = Элемент.Наименование;
		НоваяСтрока.Наименование = Наименование;
		НоваяСтрока.ЕдиницаИзмерения = Элемент.ЕдиницаИзмерения;
		
		СтруктураПоискаРанееСозданных.Вставить("Код",        Элемент.Код);
		НайденныйЭлемент = РанееДобавленныеЭлементыКлассификатора.НайтиСтроки(СтруктураПоискаРанееСозданных);
		
		Если НайденныйЭлемент.Количество() > 0 Тогда
			
			НоваяСтрока.Ссылка = НайденныйЭлемент[0].Ссылка;
			НоваяСтрока.ЕстьСсылка = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Классификатор.Сортировать("ЕстьСсылка Убыв, Код Возр");
		
КонецПроцедуры	

// Добавляет новый элемент в классификатор
// Параметры:
// - ВыбраннаяСтрока - Строка таблицы, источник данных для заполнения реквизитов классификатора
// 		Если в строке присутствуют данные о единице измерения, 
//		запускается поиск и добавление единицы измерения.
//
&НаСервере
Процедура ДобавитьЭлементКлассификатора(ВыбраннаяСтрока)
	
	ЭлементКлассификатора = Справочники[ИмяСправочника].СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(ЭлементКлассификатора, ВыбраннаяСтрока);
	ЭлементКлассификатора.НаименованиеПолное = ВыбраннаяСтрока.Наименование;
	ЭлементКлассификатора.ЕдиницаИзмерения = Справочники.КлассификаторЕдиницИзмерения.ПолучитьЕдиницуИзмерения(ВыбраннаяСтрока.ЕдиницаИзмерения);
	
	ОбщегоНазначения.СообщитьПользователю(
		НСтр("ru = 'В справочник <Классификатор ТН ВЭД> добавлен новый элемент'")
		+ " "
		+ ВыбраннаяСтрока.Код 
		+ " (" + ВыбраннаяСтрока.Наименование + ")"
	);
	
	МетаданныеСправочник = Метаданные.Справочники[ИмяСправочника];
	
	ЭлементКлассификатора.Записать();
	ВыбраннаяСтрока.Ссылка = ЭлементКлассификатора.Ссылка;
	
КонецПроцедуры	
	
// Вызывает оповещение об изменении справочника
// вызывает оповещение пользователя
// закрывает форму подбора из классификатора.
//
&НаКлиенте
Процедура ОповеститьФормуИПользователяИЗакрыть(ВыбранныйЭлемент, ДобавленыНовыеЭлементыКлассификатора = Ложь)
	
	Если ДобавленыНовыеЭлементыКлассификатора Тогда
		
		ОповеститьОбИзменении(Тип("СправочникСсылка." + ИмяСправочника));	
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Сохранение'"),
			,
			Заголовок,
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ОповеститьОВыборе(ВыбранныйЭлемент);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьКлассификатор()
	
	ЗаполнитьКлассификатор();
	
КонецПроцедуры

#КонецОбласти

