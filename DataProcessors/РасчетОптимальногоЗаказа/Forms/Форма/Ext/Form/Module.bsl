﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	
	Если НЕ Параметры.Свойство("Дата") Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Самостоятельный запуск обработки не предусмотрен.'"), , ,"Объект" , Отказ);
		Возврат;
	КонецЕсли;
	
	Объект.Дата = ?(ЗначениеЗаполнено(Параметры.Дата), Параметры.Дата, ТекущаяДатаСеанса());
	
	Объект.КонецПериодаВыборки  = ДобавитьМесяц(Объект.Дата, -11);
	Объект.НачалоПериодаВыборки = НачалоМесяца(Объект.КонецПериодаВыборки);
	
	Объект.ТипЦеныЗакупки = Справочники.ТипыЦен.ОсновнойТипЦенЗакупки;
	Объект.ТипЦеныПродажи = Справочники.ТипыЦен.ОсновнойТипЦенПродажи;
	
	Объект.ПоследниеДниПродажи = 60;
	Объект.ГлубинаЗапаса = 10;
	Объект.РасчетТолькоПоГлавнымАналогам = Истина;
	
	СхемаКомпоновкиДанных = Обработки.РасчетОптимальногоЗаказа.ПолучитьМакет("СКД_РасчетОптимальногоЗаказа");
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	ИсточникНастроекКомпоновкиДанных = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	КомпоновщикНастроекКомпоновкиДанных.Инициализировать(ИсточникНастроекКомпоновкиДанных);
	КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура СтраницыПриСменеСтраницыНаСервере()
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаНастройки Тогда
		Элементы.ФормаРассчитатьЗаказ.КнопкаПоУмолчанию = Истина;
		Элементы.ФормаДобавитьВДокумент.КнопкаПоУмолчанию = Ложь;
		Элементы.ФормаРассчитатьЗаказ.Видимость = Истина;
		Элементы.ФормаДобавитьВДокумент.Видимость = Ложь;
	Иначе
		Элементы.ФормаРассчитатьЗаказ.КнопкаПоУмолчанию = Ложь;
		Элементы.ФормаДобавитьВДокумент.КнопкаПоУмолчанию = Истина;
		Элементы.ФормаРассчитатьЗаказ.Видимость = Ложь;
		Элементы.ФормаДобавитьВДокумент.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	СтраницыПриСменеСтраницыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОптимальныйЗаказПриАктивизацииСтроки(Элемент)
	
	// "ОптимальныйЗаказДополнительнаяИнформация"
	// "ОптимальныйЗаказКоличествоПродаж".
	
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Отбор = Неопределено;
	Иначе
		ТекущиеДанные = Объект.ОптимальныйЗаказ.НайтиПоИдентификатору(Элемент.ТекущаяСтрока);
		Отбор = Новый Структура("ГлавныйАналог,Номенклатура", ТекущиеДанные.ГлавныйАналог, ТекущиеДанные.Номенклатура);
		Отбор = Новый ФиксированнаяСтруктура(Отбор);
	КонецЕсли;
	
	Элементы.ОптимальныйЗаказДополнительнаяИнформация.ОтборСтрок = Отбор;
	Элементы.ОптимальныйЗаказКоличествоПродаж.ОтборСтрок = Отбор;
	
КонецПроцедуры

&НаКлиенте
Процедура ОптимальныйЗаказКоличествоПриИзменении(Элемент)
	
	Если Элементы.ОптимальныйЗаказ.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьСуммы(Объект.ОптимальныйЗаказ.НайтиПоИдентификатору(Элементы.ОптимальныйЗаказ.ТекущаяСтрока));
	
КонецПроцедуры

&НаКлиенте
Процедура ОптимальныйЗаказДополнительнаяИнформацияЦенаПродажиПриИзменении(Элемент)
	
	Если Элементы.ОптимальныйЗаказДополнительнаяИнформация.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.ОптимальныйЗаказДополнительнаяИнформация.ТекущаяСтрока;
	РассчитатьСуммы(Объект.ОптимальныйЗаказ.НайтиПоИдентификатору(ТекущаяСтрока));
	
КонецПроцедуры

&НаКлиенте
Процедура ОптимальныйЗаказДополнительнаяИнформацияЦенаЗакупкиПриИзменении(Элемент)
	
	Если Элементы.ОптимальныйЗаказДополнительнаяИнформация.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.ОптимальныйЗаказДополнительнаяИнформация.ТекущаяСтрока;
	РассчитатьСуммы(Объект.ОптимальныйЗаказ.НайтиПоИдентификатору(ТекущаяСтрока));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик команды формы на сервере.
&НаСервере
Процедура РассчитатьЗаказНаСервере()
	
	Данные = Обработки.РасчетОптимальногоЗаказа.ДанныеДляСхемыКомпоновкиДанных(ПодготовитьДанныеДляИнициализации());
	
	НастроитьИнтерфейс();
	
	// Вывод на экран
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакетаКомпоновкиДанных.Выполнить(
		ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных),
		КомпоновщикНастроекКомпоновкиДанных.Настройки,
		,
		,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений")
	);
	
	ВнешниеИсточники = Новый Структура("ОптимальныйЗаказ", Данные);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеИсточники);	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	ТаблицаРезультат = Новый ТаблицаЗначений();
	ПроцессорВывода.УстановитьОбъект(ТаблицаРезультат);
	
	ПроцессорВывода.НачатьВывод();
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
	ПроцессорВывода.ЗакончитьВывод();
	
	Объект.ОптимальныйЗаказ.Загрузить(ТаблицаРезультат);
	
КонецПроцедуры

// Обработчик команды формы на клиенте.
&НаКлиенте
Процедура РассчитатьЗаказ(Команда)
	
	Если Объект.ПоследниеДниПродажи = 0 Тогда
		ПоказатьПредупреждение(
			,
			НСтр("ru = 'Количество последних дней не может равняться нулю.'"),
			20,
			НСтр("ru = 'Отмена действия'")
		);
		Возврат;
	КонецЕсли;
	
	Если НачалоДня(Объект.СрокПоставки) <= НачалоДня(Объект.Дата) Тогда
		ПоказатьПредупреждение(
			,
			НСтр("ru = 'Срок поставки должен быть больше даты расчета.'"),
			20,
			НСтр("ru = 'Отмена действия'")
		);
		Возврат;
	КонецЕсли;
	
	РассчитатьЗаказНаСервере();
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРезультат;
	СтраницыПриСменеСтраницы(Неопределено, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВДокумент(Команда)
	
	// Подготовим данные
	ВыбранныеТовары = Новый Соответствие;
	
	Для Каждого Строка Из Объект.ОптимальныйЗаказ Цикл
		Если НЕ Строка.ПеренестиВЗаказ Тогда Продолжить; КонецЕсли;
		
		ВыбранныеТовары.Вставить(Строка.Номенклатура, Строка.Количество);
		
	КонецЦикла;
	
	Закрыть(ВыбранныеТовары);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометки(Команда)
	
	Значение = (Команда.Имя = "УстановитьПометки");
	Для Каждого Строка Из Объект.ОптимальныйЗаказ Цикл
		Строка.ПеренестиВЗаказ = Значение;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьДанныеДляИнициализации()
	
	ПараметрыИнициализации = Новый Структура;
	
	КоличествоДнейДоПоставки = (НачалоДня(Объект.СрокПоставки) - НачалоДня(Объект.Дата)) / 60 / 60 / 24;
	ПоследнийМесяц           = КонецМесяца(ДобавитьМесяц(Объект.Дата, -1));
	НачалоПоследнихДней      = НачалоДня(Объект.Дата - Объект.ПоследниеДниПродажи * 60 * 60 * 24);
	
	// 12 Предыдущих месяцев
	Для Счетчик = 1 По 12 Цикл
		ТекМесяц = НачалоМесяца(ДобавитьМесяц(Объект.Дата, Счетчик - 13));
		ПараметрыИнициализации.Вставить("Месяц" + Счетчик, ТекМесяц);
	КонецЦикла;
	
	// Заполним параметры инициализации.
	ПараметрыИнициализации.Вставить("ПоставщикНеЗаполнен" , НЕ ЗначениеЗаполнено(Объект.Контрагент));
	ПараметрыИнициализации.Вставить("ТекущееПодразделение" , Объект.ПодразделениеКомпании);
	ПараметрыИнициализации.Вставить("Подразделение" , Объект.ПодразделениеКомпании);
	ПараметрыИнициализации.Вставить("РасчетТолькоПоГлавнымАналогам" , Объект.РасчетТолькоПоГлавнымАналогам);
	ПараметрыИнициализации.Вставить("Поставщик" , Объект.Контрагент);
	ПараметрыИнициализации.Вставить("ДатаРасчета" , КонецДня(Объект.Дата));
	КоэффициентТочкиЗаказа = (Объект.ГлубинаЗапаса + КоличествоДнейДоПоставки)/Объект.ПоследниеДниПродажи;
	ПараметрыИнициализации.Вставить("КоэффициентТочкиЗаказа" , КоэффициентТочкиЗаказа);
	
	ПараметрыИнициализации.Вставить("НачалоПоследнихДней" , НачалоПоследнихДней);
	ПараметрыИнициализации.Вставить("НачалоПроизвольногоПериода" , НачалоДня(Объект.НачалоПериодаВыборки));
	ПараметрыИнициализации.Вставить("КонецПроизвольногоПериода" , КонецДня(Объект.КонецПериодаВыборки));
	КоэффициентРасчетногоКоличества = Объект.ПоследниеДниПродажи
		/ ((НачалоДня(ПоследнийМесяц) - НачалоДня(ПараметрыИнициализации.Месяц1)) / 60 / 60 / 24);
	ПараметрыИнициализации.Вставить("КоэффициентРасчетногоКоличества" , КоэффициентРасчетногоКоличества);
	ПараметрыИнициализации.Вставить("ПоследнийМесяц" , ПоследнийМесяц);
	ПараметрыИнициализации.Вставить("Услуга" , Перечисления.ВидыНоменклатуры.Услуга);
	ПараметрыИнициализации.Вставить("КоличествоДнейДоПоставки" , КоличествоДнейДоПоставки);
	
	КурсВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Объект.ВалютаДокумента, Объект.Дата);
	КурсВалюты = КурсВалюты.Курс/?(КурсВалюты.Кратность=0,1,КурсВалюты.Кратность);
	ПараметрыИнициализации.Вставить("КурсВалютыОтчета"              , 1);
	
	ПараметрыИнициализации.Вставить("РабочийТипЦенЗакупки",
		?(ЗначениеЗаполнено(Объект.ТипЦеныЗакупки), Объект.ТипЦеныЗакупки, ПравоПользователя("ОсновнойТипЦенЗакупки"))
	);
	ПараметрыИнициализации.Вставить("ВалютаЗакупки", ПараметрыИнициализации.РабочийТипЦенЗакупки.ВалютаЦены);
	
	ПараметрыИнициализации.Вставить("РабочийТипЦенПродажи",
		?(ЗначениеЗаполнено(Объект.ТипЦеныЗакупки), Объект.ТипЦеныПродажи, ПравоПользователя("ОсновнойТипЦенПродажи"))
	);
	ПараметрыИнициализации.Вставить("ВалютаПродажи" , ПараметрыИнициализации.РабочийТипЦенПродажи.ВалютаЦены);
	
	Возврат ПараметрыИнициализации;
	
КонецФункции

&НаСервере
Процедура НастроитьИнтерфейс()
	
	НачалоПоследнихДней = НачалоДня(Объект.Дата - Объект.ПоследниеДниПродажи * 60 * 60 * 24);
	ПоследнийМесяц = КонецМесяца(ДобавитьМесяц(Объект.Дата, -1));
	
	// 12 Предыдущих месяцев
	Для Счетчик = 1 По 12 Цикл
		ЗаголовокМесяца = Формат(НачалоМесяца(ДобавитьМесяц(Объект.Дата, Счетчик - 13)), "ДФ=MMMM.yyy");
		Элементы["ОптимальныйЗаказКоличествоПродажПродажиМесяц" + Счетчик].Заголовок = ЗаголовокМесяца;
		Если Счетчик = 1 Тогда
			ПервыйМесяц = НачалоМесяца(ДобавитьМесяц(Объект.Дата, Счетчик - 13));
		КонецЕсли;
	КонецЦикла;
	
	// Продажи за последние дни.
	ТекстШапки = Формат(НачалоПоследнихДней, "ДФ=dd.MM.yy") + " по " + Формат(Объект.Дата, "ДФ=dd.MM.yy");
	ЗаголовокПодсказка = СтрШаблон(НСтр("ru = 'Продажи с %1'"), ТекстШапки);
	Элементы.ОптимальныйЗаказКоличествоПродажКоличествоПродажЗаПоследниеДни.Заголовок = ЗаголовокПодсказка;
	Элементы.ОптимальныйЗаказКоличествоПродажКоличествоПродажЗаПоследниеДни.Подсказка = ЗаголовокПодсказка;
	Элементы.ОптимальныйЗаказДополнительнаяИнформацияКоличествоПродажЗаПоследниеДни.Заголовок = ЗаголовокПодсказка;
	Элементы.ОптимальныйЗаказДополнительнаяИнформацияКоличествоПродажЗаПоследниеДни.Подсказка = ЗаголовокПодсказка;
	
	// Израсходовано в производстве за последние дни.
	Элементы.ОптимальныйЗаказДополнительнаяИнформацияИзрасходованоВПроизводствеЗаПоследниеДни.Заголовок = 
			НСтр("ru = 'Израсходовано в производстве с'") + " " + ТекстШапки;
	Элементы.ОптимальныйЗаказДополнительнаяИнформацияИзрасходованоВПроизводствеЗаПоследниеДни.Подсказка = 
			Элементы.ОптимальныйЗаказДополнительнаяИнформацияИзрасходованоВПроизводствеЗаПоследниеДни.Заголовок;
	
	// Расчетные продажи за последние дни.
	Элементы.ОптимальныйЗаказКоличествоПродажРасчетноеКоличествоПродажЗаПоследниеДни.Заголовок = 
			НСтр("ru = 'Расчетные продажи с'") + " "+ТекстШапки;
	Элементы.ОптимальныйЗаказКоличествоПродажРасчетноеКоличествоПродажЗаПоследниеДни.Подсказка = 
			Элементы.ОптимальныйЗаказКоличествоПродажРасчетноеКоличествоПродажЗаПоследниеДни.Заголовок;
	
	ТекстШапки = Формат(ПервыйМесяц, "ДФ=dd.MM.yy") + " по " + Формат(ПоследнийМесяц, "ДФ=dd.MM.yy");
	// Продажи за год
	Элементы.ОптимальныйЗаказКоличествоПродажКоличествоПродажЗаПоследнийГод.Заголовок =
		НСтр("ru = 'Продажи с'") + " " + ТекстШапки;
	Элементы.ОптимальныйЗаказКоличествоПродажКоличествоПродажЗаПоследнийГод.Подсказка = 
			Элементы.ОптимальныйЗаказКоличествоПродажКоличествоПродажЗаПоследнийГод.Заголовок;
	
	// Количество документов за год.
	Элементы.ОптимальныйЗаказДополнительнаяИнформацияКоличествоДокументовПродажЗаГод.Заголовок = 
			НСтр("ru = 'Количество документов продаж с'") + " " +ТекстШапки;
	Элементы.ОптимальныйЗаказДополнительнаяИнформацияКоличествоДокументовПродажЗаГод.Подсказка = 
			Элементы.ОптимальныйЗаказДополнительнаяИнформацияКоличествоДокументовПродажЗаГод.Заголовок;
	
	// Продажи за произвольный период.
	ТекстШапки = СтрШаблон(НСтр("ru = '%1 по %2'"),
		Формат(НачалоДня(Объект.НачалоПериодаВыборки), "ДФ=dd.MM.yy"),
		Формат(КонецДня(Объект.КонецПериодаВыборки), "ДФ=dd.MM.yy")
	);
	Элементы.ОптимальныйЗаказКоличествоПродажКоличествоПродажЗаПроизвольныйПериод.Заголовок =
		НСтр("ru = 'Продажи с'") + " "+ТекстШапки;
	Элементы.ОптимальныйЗаказКоличествоПродажКоличествоПродажЗаПроизвольныйПериод.Подсказка = 
			Элементы.ОптимальныйЗаказКоличествоПродажКоличествоПродажЗаПроизвольныйПериод.Заголовок;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммы(Строка)
	
	Строка.СуммаПродажи = Строка.Количество * Строка.ЦенаПродажи;
	Строка.СуммаЗакупки = Строка.Количество * Строка.ЦенаЗакупки;
	
КонецПроцедуры

#КонецОбласти

