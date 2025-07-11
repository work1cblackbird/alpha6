﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДеревоПодразделенийКомпании();
	УстановитьУсловноеОформлениеДерева();
	СтрокВДокументе = 9999;    
	ДобавлятьЕслиЦенаНеИзменилась = Истина;
	ДатаНачалаДействия = ТекущаяДатаСеанса();
	ПодразделениеДокумента = ПараметрыСеанса.ПодразделениеКомпании;
 	СимволРазделитель = ";"; 
	СтрокаНачалаЗагрузки = 1; 
	КодировкаФайла = "ANSI";
	ЗагрузитьТипыЦен();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВидОбновления = 1;
	НастроитьЭлементыФормы();   
	ОбновитьПодсказку();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидОбновленияПриИзменении(Элемент)
	ВидОбновленияПриИзмененииНаСервере();
	НастроитьЭлементыФормы();
КонецПроцедуры  

&НаКлиенте
Процедура СоздаватьНоменклатуруПриИзменении(Элемент)
	Элементы.ПараметрыНоменклатуры.Видимость = СоздаватьНоменклатуру;
КонецПроцедуры 

&НаКлиенте
Процедура ИмяФайлаПриИзменении(Элемент)
	ПрочитатьФайл();
КонецПроцедуры

&НаКлиенте
Процедура ФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыборФайла(Новый ОписаниеОповещения("ВыборФайлаШаблонаЗавершение", ЭтотОбъект), ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПереходКТипамЦенНажатие(Элемент)
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаТипыЦен;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипыЦенПереходКЦенамНажатие(Элемент)
	
	ПереходКЦенамНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура СимволРазделительПриИзменении(Элемент)
	
	ОбновитьПодсказку();
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаНачалаЗагрузкиПриИзменении(Элемент)
	
	ОбновитьПодсказку();
	
КонецПроцедуры

&НаКлиенте
Процедура КодировкаФайлаПриИзменении(Элемент)
	
	ОбновитьПодсказку();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодразделенияКомпании
 
&НаКлиенте
Процедура ПодразделенияКомпанииПриИзменении()
	
	ОбработатьИзменениеПодразделенияКомпании();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыбранныеТипыЦен

&НаКлиенте
Процедура ВыбранныеТипыЦенВыбранПриИзменении(Элемент)
	
	Элементы.ВыбранныеТипыЦен.ТекущиеДанные.ИзмененыПараметрыРасчета
		= Элементы.ВыбранныеТипыЦен.ТекущиеДанные.Выбран; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьЦены()
	
	ДлительнаяОперация = ЗагрузитьЦеныНаСервере();
	
	Если ДлительнаяОперация.Статус = "Выполняется" Тогда
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(
			ДлительнаяОперация,
			Новый ОписаниеОповещения("ПриЗавершенииЗадания", ЭтотОбъект),
			ПараметрыОжидания
		);
		
	Иначе
		
		ПриЗавершенииЗадания(ДлительнаяОперация);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)
	
	ОбщегоНазначенияАвтосалонКлиентСервер.УстановитьЗначениеКолонкиВДереве(ПодразделенияКомпании, Ложь, "Выбран");
	ОбработатьИзменениеПодразделенияКомпании();

КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометки(Команда)
	
	ОбщегоНазначенияАвтосалонКлиентСервер.УстановитьЗначениеКолонкиВДереве(ПодразделенияКомпании, Истина, "Выбран");
	
	ПодразделенияКомпании.ПолучитьЭлементы()[0].Выбран = Ложь;
	ОбработатьИзменениеПодразделенияКомпании();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеТипыЦен(Команда)
	
	УстановитьФлажкиВТаблице(ВыбранныеТипыЦен, "Выбран", Истина);

КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыборВсехТиповЦен(Команда)
	
	УстановитьФлажкиВТаблице(ВыбранныеТипыЦен, "Выбран", Ложь);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьИзменениеПодразделенияКомпании()
	
	Результат = ПланированиеРесурсовКлиентСервер.НайтиВДеревеОбъектов(
		ПодразделенияКомпании,
		Новый Структура("Выбран", Истина)
	);	
	Элементы.ВключаяПодразделения.Заголовок = СтрШаблон(
		НСтр("ru = 'Включая подразделения (%1)'"),
		Результат.Количество()
	);
	
КонецПроцедуры

#Область РаботаСПодразделениямиКомпании

&НаСервере
Процедура ЗаполнитьДеревоПодразделенийКомпании()
	
	// получим подчиненные подразделения
	ЭлементыДерева = ПодразделенияКомпании.ПолучитьЭлементы();
	Строка = ЭлементыДерева.Добавить();
	Строка.ПодразделениеКомпании = Справочники.ПодразделенияКомпании.ОсновноеПодразделение;
	Строка.ЭтоОсновноеПодразделение = Истина;
	
	ТекРодитель = Строка;
	
	Выборка = Справочники.ПодразделенияКомпании.ВыбратьИерархически(Справочники.ПодразделенияКомпании.ОсновноеПодразделение);
	Пока Выборка.Следующий() Цикл
		Пока Выборка.Родитель <> ТекРодитель.ПодразделениеКомпании Цикл
			ТекРодитель = ТекРодитель.ПолучитьРодителя();
		КонецЦикла;
		ТекРодитель = ТекРодитель.ПолучитьЭлементы().Добавить();
		ТекРодитель.ПодразделениеКомпании = Выборка.Ссылка;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеДерева()
	
	// настроим строку корневого подразделения
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПодразделенияКомпании.ЭтоОсновноеПодразделение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодразделенияКомпанииВыбран.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодразделенияКомпанииПодразделениеКомпании.Имя);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	//@skip-check new-font
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,, Истина));
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСФайлом	

&НаКлиенте
Процедура ВыборФайла(ФинальноеОповещение, ПутьПоУмолчанию = "", УстановитьФильт = Ложь)
	
	ДополнительныеПараметры = Новый Структура("Оповещение,ПутьПоУмолчанию", ФинальноеОповещение, ПутьПоУмолчанию);
	Если УстановитьФильт Тогда
		ДополнительныеПараметры.Вставить("УстановитьФильт", Истина);
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	
	ТекстСообщения = НСтр("ru = 'Для загрузки файла рекомендуется установить расширение для веб-клиента 1С:Предприятие.'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыборФайлаЗавершениеКонтроляРасширенияРаботыСФайлами",
		ПрайсЛистыКонтрагентовКлиент,
		ДополнительныеПараметры);
	
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(ОписаниеОповещения, ТекстСообщения, Ложь);
	
КонецПроцедуры // ВыборФайла()

&НаКлиенте
Процедура ВыборФайлаШаблонаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ИмяФайла  = Результат.ПолноеИмя;
		ПрочитатьФайл();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайл()

	НачатьПомещениеФайлаНаСервер(
		Новый ОписаниеОповещения("ПрочитатьФайлЗавершение", ЭтотОбъект),
		,
		,
		,
		ИмяФайла,
		УникальныйИдентификатор
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлЗавершение(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныйФайл = Неопределено Или ПомещенныйФайл.ПомещениеФайлаОтменено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЗагрузитьФайлСДаннымиНаСервере(
		ПомещенныйФайл.Адрес,
		ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(ПомещенныйФайл.СсылкаНаФайл.Расширение)
	);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьФайлСДаннымиНаСервере(АдресВременногоХранилища, Расширение)
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Расширение);
	
	ДвоичныеДанные = ПолучитьИЗВременногоХранилища(АдресВременногоХранилища);
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	
	ЦеныИзФайла.Очистить();
	
	Если Расширение = "txt" Или Расширение = "csv" Тогда
		
		ТекстИзФайла.Прочитать(ИмяВременногоФайла);
	   	ПолучитьТекстИзФайлаНаСервере(Расширение);
		
	Иначе
		
		ТабличныйДокумент.Прочитать(ИмяВременногоФайла);
	   	ПолучитьТЗИзШаблонаНаСервере();
	   	
	КонецЕсли;
	
	УдалитьФайлы(ИмяВременногоФайла);
 
КонецПроцедуры

&НаСервере
Функция ПреобразоватьВЧисло(ЧислоСтрокой)
	Если СокрЛП(ЧислоСтрокой) = "" Тогда
		Возврат 0;
	КонецЕсли;
	ЧислоНорм = СтрЗаменить(ЧислоСтрокой, "р.", "");
	ЧислоНорм = СтрЗаменить(ЧислоНорм, " ", "");
	ЧислоНорм = СтрЗаменить(ЧислоНорм, ",", ".");
	ЧислоНорм = СтрЗаменить(ЧислоНорм, "%", "");  
	ЧислоНорм = СтрЗаменить(ЧислоНорм, Символ(160), "");   
	Попытка
		ГотовоеЧисло = Число(ЧислоНорм);
	Исключение  
		ВывестиСообщение(НСтр("ru = 'Невозможно загрузить число: %1, Цена преобразована в числовую форму.'"),,,,, ЧислоСтрокой);
	   	ГотовоеЧисло = 0;
	КонецПопытки;
	Возврат ГотовоеЧисло;
КонецФункции

&НаСервере
Процедура ПолучитьТекстИзФайлаНаСервере(Расширение)
	Если КодировкаФайла = "ANSI" Тогда
		ТекстИзФайла.УстановитьТипФайла(КодировкаТекста.ANSI);	
	ИначеЕсли КодировкаФайла = "OEM" Тогда
		ТекстИзФайла.УстановитьТипФайла(КодировкаТекста.OEM);
	ИначеЕсли КодировкаФайла = "UTF8" Тогда
		ТекстИзФайла.УстановитьТипФайла(КодировкаТекста.UTF8);
	ИначеЕсли КодировкаФайла = "UTF16" Тогда
		ТекстИзФайла.УстановитьТипФайла(КодировкаТекста.UTF16);
	Иначе
		ТекстИзФайла.УстановитьТипФайла(КодировкаТекста.Системная);
	КонецЕсли;
   	
	Для Сч = СтрокаНачалаЗагрузки По ТекстИзФайла.КоличествоСтрок() Цикл   
		Строка = ТекстИзФайла.ПолучитьСтроку(Сч);
 		МассивПодстрокТовары = СтрРазделить(Строка, СимволРазделитель, Истина);
      		
		Если МассивПодстрокТовары.Количество() >= 2 Тогда
				
			Артикул = ОбщегоНазначенияАвтосалонКлиентСервер.ВАртикулДляПоиска(МассивПодстрокТовары[0]); 
	      	Цена = ПреобразоватьВЧисло(МассивПодстрокТовары[1]); 
			Если ЗначениеЗаполнено(Артикул)
				И Цена <> 0 Тогда
			 	СтрокаТаблицы = ЦеныИзФайла.Добавить();
				СтрокаТаблицы.Артикул = МассивПодстрокТовары[0];  
				СтрокаТаблицы.АртикулДляПоиска = Артикул; 
				СтрокаТаблицы.Цена = Цена;        
				Если МассивПодстрокТовары.Количество() >= 3 Тогда
	            	СтрокаТаблицы.Наименование = СокрЛП(МассивПодстрокТовары[2]); 
				КонецЕсли;
				Если МассивПодстрокТовары.Количество() >= 4 Тогда
	            	СтрокаТаблицы.Производитель = СокрЛП(МассивПодстрокТовары[3]); 
				КонецЕсли;				
			Иначе
				ВывестиСообщение(НСтр("ru = 'В строке %1, не указаны обязательные поля: Артикул и Цена, строка будет пропущена!'"),,,,, Сч);
			КонецЕсли;

		Иначе
			ВывестиСообщение(НСтр("ru = 'В строке %1, не указаны обязательные поля: Артикул и Цена, строка будет пропущена!'"),,,,, Сч);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПолучитьТЗИзШаблонаНаСервере()
	
	НомерСтроки = СтрокаНачалаЗагрузки;  
	ЦеныИзФайла.Очистить();
	
		Пока Истина Цикл
			
			СтрокаДанных = ТабличныйДокумент.Область(НомерСтроки, 1).Текст;
			Если ПустаяСтрока(СтрокаДанных) Тогда
				Прервать;
			КонецЕсли;       
			ВсёКорректно = Истина;
			Артикул = СтрокаДанных;
			
			Попытка
				АртикулДляПоиска = ОбщегоНазначенияАвтосалонКлиентСервер.ВАртикулДляПоиска(СтрокаДанных);
			Исключение 
				ВывестиСообщение(НСтр("ru = 'Некорректная структура файла, в строке %1, колонка 1 (Артикул)'"),,,,, НомерСтроки);  
				ВсёКорректно = Ложь;
			КонецПопытки;
			
			Попытка
				СтрокаДанных = ТабличныйДокумент.Область(НомерСтроки, 2).Текст;   
				Цена = ПреобразоватьВЧисло(СтрокаДанных);
			Исключение        
				ВывестиСообщение(НСтр("ru = 'Некорректная структура файла, в строке %1, колонка 2 (Цена)'"),,,,, НомерСтроки);
				ВсёКорректно = Ложь;
			КонецПопытки;    
			
			Если ВсёКорректно 
				И ЗначениеЗаполнено(Артикул) 
				И Цена <> 0 Тогда
				НовСтрока = ЦеныИзФайла.Добавить();
				НовСтрока.Артикул = Артикул;
				НовСтрока.АртикулДляПоиска = АртикулДляПоиска;
				НовСтрока.Цена = Цена;
				Попытка
					НовСтрока.Наименование = ТабличныйДокумент.Область(НомерСтроки, 3).Текст;  
				Исключение 
					ВывестиСообщение(НСтр("ru = 'Некорректная структура файла, в строке %1, колонка 3 (Наименование)'"),,,,, НомерСтроки);
				КонецПопытки;
				
				Попытка
					НовСтрока.Производитель =  ТабличныйДокумент.Область(НомерСтроки, 4).Текст;
	            Исключение        
					ВывестиСообщение(НСтр("ru = 'Некорректная структура файла, в строке %1, колонка 4 (Производитель)'"),,,,, НомерСтроки);
				КонецПопытки;
				
			Иначе
				ВывестиСообщение(НСтр("ru = 'В строке %1, не указаны обязательные поля: Артикул и Цена, строка будет пропущена!'"),,,,, НомерСтроки);
			КонецЕсли;     
			
            НомерСтроки = НомерСтроки + 1;
		КонецЦикла;                                                          
		
КонецПроцедуры

#КонецОбласти

#Область РаботаСВыбраннымиТипамиЦен

&НаСервере
Процедура ПереходКЦенамНаСервере()
	
	УстановитьФлажкиВТаблице(ВыбранныеТипыЦен, "ИзмененыПараметрыРасчета", Ложь);
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПараметры;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьФлажкиВТаблице(Таблица, ИмяКолонки, Значение)
	
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		
		СтрокаТаблицы[ИмяКолонки] = Значение;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ЗагрузитьЦеныНаСервере()
	
	СтруктураПараметров = Новый Структура;
	ВыбранныеПодразделения = ПланированиеРесурсовКлиентСервер
		.НайтиВДеревеОбъектов(ПодразделенияКомпании, Новый Структура("Выбран", Истина));
	
	МассивПодразделений = Новый Массив;
	
	Для каждого ЭлементМассиваПодр Из ВыбранныеПодразделения Цикл
		
		МассивПодразделений.Добавить(ЭлементМассиваПодр.ПодразделениеКомпании);
		
	КонецЦикла;
	
	СтруктураПараметров.Вставить("СтрокВДокументе",?(СтрокВДокументе = 0, 9999, СтрокВДокументе));
	СтруктураПараметров.Вставить("Подразделения", МассивПодразделений);
	СтруктураПараметров.Вставить("ТипыЦен", ВыбранныеТипыЦен.Выгрузить());
	СтруктураПараметров.Вставить("ВидОбновления", ВидОбновления);
	
	Если ВидОбновления = 1 Тогда
		
		СтруктураПараметров.Вставить("ПрайсЛистКонтрагента", ПрайсЛистКонтрагента);
		
	Иначе
		
		СтруктураПараметров.Вставить("ЦеныИзФайла", ЦеныИзФайла.Выгрузить());
		
	КонецЕсли;
	
	СтруктураПараметров.Вставить("Проводить", Проводить);
	СтруктураПараметров.Вставить("ДобавлятьЕслиЦенаНеИзменилась", ДобавлятьЕслиЦенаНеИзменилась);
	СтруктураПараметров.Вставить("ДатаНачалаДействия", ДатаНачалаДействия);
	
	СтруктураПараметров.Вставить("СоздаватьНоменклатуру", СоздаватьНоменклатуру); 
	СтруктураПараметров.Вставить("Производитель", Производитель);
	СтруктураПараметров.Вставить("ПодразделениеДокумента", ПодразделениеДокумента);
	
	Если СоздаватьНоменклатуру Тогда
		
		СтруктураПараметров.Вставить("ВидНоменклатуры", ВидНоменклатуры);
		СтруктураПараметров.Вставить("ТипНоменклатуры", ТипНоменклатуры);
		СтруктураПараметров.Вставить("ГруппаНоменклатуры", ГруппаНоменклатуры);
		
	КонецЕсли;
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка цен в документ'");
	
	ПараметрыМетода = Новый Структура;
	ПараметрыМетода.Вставить("Параметры", СтруктураПараметров);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"ЗагрузкаЦен.СоздатьДокументыИзмененияЦен",
		ПараметрыМетода,
		ПараметрыВыполненияВФоне
	);
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииЗадания(РезультатЗадания, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатЗадания = Неопределено Или ТипЗнч(РезультатЗадания) <> Тип("Структура") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если РезультатЗадания.Статус = "Выполнено" Тогда
		
		СозданныеДокументы = ПолучитьИзВременногоХранилища(РезультатЗадания.АдресРезультата);
		
		Если Не ЗначениеЗаполнено(СозданныеДокументы) Тогда
			
			ВызватьИсключение НСтр("ru = 'Нет данных для загрузки!'");
			
		КонецЕсли;
		
		Для Каждого ДокументЦены Из СозданныеДокументы Цикл
			
			Если Открывать Тогда
				
				ПоказатьЗначение( , ДокументЦены);
				
			Иначе
				
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					СтрШаблон(НСтр("ru = 'Создан документ: %1'"), ДокументЦены)
				);
				
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли РезультатЗадания.Статус = "Ошибка" Тогда
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Ошибка при создании документов: %1'"), РезультатЗадания.КраткоеПредставлениеОшибки);
				
	ИначеЕсли РезультатЗадания.Статус = "Отменено" Тогда
		
		ВызватьИсключение НСтр("ru = 'Задание отменено администратором.'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьЭлементыФормы()

	Если ВидОбновления = 1  Тогда
		Элементы.ИмяФайла.Видимость = Ложь;
		Элементы.ПрайсЛистКонтрагента.Видимость = Истина;
		Элементы.СоздаватьНоменклатуру.Видимость = Ложь;
		СоздаватьНоменклатуру = Ложь;
		Элементы.ПараметрыНоменклатуры.Видимость = Ложь;
		Элементы.ОписаниеВариантовЗагрузки.Заголовок = НСтр("ru='Прайс-лист должен быть загружен в программу.'");
		Элементы.Подсказка.Видимость = Ложь;    
		Элементы.ГруппаНастроекФайла.Видимость = Ложь;
		Элементы.Производитель.Видимость = Ложь;
		Производитель = ПредопределенноеЗначение("Справочник.Производители.ПустаяСсылка");
	Иначе
		Элементы.ИмяФайла.Видимость = Истина;
		Элементы.ПрайсЛистКонтрагента.Видимость = Ложь;
		Элементы.СоздаватьНоменклатуру.Видимость = Истина;
		Элементы.ОписаниеВариантовЗагрузки.Заголовок = НСтр("ru='Файл должен иметь структуру: Артикул, Цена, Наименование, Производитель. Артикул и цена - обязательны, цена не равна нулю.'");
       	Элементы.Подсказка.Видимость = Истина; 
		Элементы.ГруппаНастроекФайла.Видимость = Истина;
		Элементы.Производитель.Видимость = Истина;
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура ВидОбновленияПриИзмененииНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТипыЦен()
	
	ОсновныеТипыЦенСПараметрамиРасчета = ОсновныеТипыЦенСПараметрамиРасчета();
	ВыбранныеТипыЦен.Загрузить(ОсновныеТипыЦенСПараметрамиРасчета);
	
КонецПроцедуры

&НаСервере
Функция ОсновныеТипыЦенСПараметрамиРасчета()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЛОЖЬ КАК Выбран,
		|	ТипыЦен.Ссылка КАК ТипЦен,
		|	ТипыЦен.ЦенаВключаетНДС КАК ВключаетНДС,
		|	ТипыЦен.ВалютаЦены КАК Валюта,
		|	ТипыЦен.ДляРабот КАК ДляРабот,
		|	ТипыЦен.ДляТоваров КАК ДляТоваров,
		|	ТипыЦен.ДляАвтомобилей КАК ДляАвтомобилей,
		|	ТипыЦен.АлгоритмПолученияЦены КАК АлгоритмПолученияЦены,
		|	0 КАК РасчетЦенОт,
		|	ЛОЖЬ КАК БратьПроцентНаценкиИзНоменклатуры,
		|	0 КАК ПроцентНаценки,
		|	0.01 КАК ОкруглятьДо
		|ИЗ
		|	Справочник.ТипыЦен КАК ТипыЦен
		|ГДЕ
		|	НЕ ТипыЦен.Рассчитывается"
	);
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаКлиенте
Процедура ОбновитьПодсказку()
	
	Элементы.Подсказка.Заголовок = "Разделитель колонок в файле - символ " +
	СимволРазделитель + ", загрузка идет с " + СтрокаНачалаЗагрузки + " строки. Кодировка " + КодировкаФайла;		
	
КонецПроцедуры

#КонецОбласти