﻿
#Область ОбработчикиСобытийФормы

// Обработчик события возникающего на сервере при создании формы.
//
// Параметры:
//  Отказ                - Булево - Признак отказа от создания формы.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Производим заполнение данных формы на основании переданного объекта
	Если ТипЗнч(Параметры.Объект)=Тип("ДанныеФормыСтруктура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.Объект);
	Иначе
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.Ссылка);
	КонецЕсли;
	VIN = Автомобиль.VIN;
	
	// Инициализируем элементы формы связанные с дополнительными реквизитами
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ИмяЭлементаКоманднойПанели", "ДополнительныеДействия");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	
	ФормаОбъекта = (ТипЗнч(Параметры.Объект)=Тип("ДанныеФормыСтруктура")); 
	
КонецПроцедуры //ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура VINНачалоВыбораНаСервере()
	VIN = Автомобиль.VIN;
КонецПроцедуры

&НаКлиенте
Процедура VINНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	VINНачалоВыбораНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КомментарийОткрытие(Элемент, СтандартнаяОбработка)
	
	// Отказываемся от стандартной обработки события
	СтандартнаяОбработка = ЛОЖЬ;
	
	// Формируем описание обработчика перехвата закрытия формы
	ОбработкаРезультатаЗакрытия = Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаОповещения", ЭтотОбъект, "РасширенноеРедактированиеПоляКомментарий");
	
	// Открываем диалог многострочного редактирования текста коммантария
	ПоказатьВводСтроки(ОбработкаРезультатаЗакрытия, СокрЛП(Комментарий), "Введите комментарий ...",, ИСТИНА);
	
КонецПроцедуры // КомментарийОткрытие()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик события нажатия кнопки "Подбор номенклатуры".
//
// Параметры:
//  Команда - КомандаФормы - Команда, в которой возникло данное событие.
//
&НаКлиенте
Процедура Применить(Команда)
	
	Если НЕ ЗаписатьVINАвтомобиля() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтрШаблон(НСтр("ru = 'Не удалось записать VIN автомобиля <%1>'"),Автомобиль)
		);
	КонецЕсли;
	
	Результат = Новый Структура();
	Результат.Вставить("Комментарий",        Комментарий);
	Результат.Вставить("ВнешнийНомерЗаказа", ВнешнийНомерЗаказа);
	Результат.Вставить("СрокПоставки",       СрокПоставки);
	Результат.Вставить("СтатусАвтомобиля",   СтатусАвтомобиля);
	
	Если ФормаОбъекта И НЕ ЭтотОбъект.ВладелецФормы.ТолькоПросмотр Тогда
		ЭтотОбъект.ВладелецФормы.Модифицированность = Истина;
	КонецЕсли;
	
	Закрыть(Результат);
	ДобавитьДополнительныеРеквизиты();
	Оповестить("ПеречитатьДополнительныеРеквизиты", Объект);
	
КонецПроцедуры //Применить()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗаписатьVINАвтомобиля()
	
	Результат = Истина;
	
	Если НЕ (VIN = Автомобиль.VIN) Тогда
		
		АвтомобильЗаказа = Автомобиль.ПолучитьОбъект();
		АвтомобильЗаказа.VIN = VIN;
		ГосНомер = Справочники.Автомобили.ЧтениеЗначенияРегистраСведения(АвтомобильЗаказа.Ссылка, Перечисления.ДополнительнаяИнформацияАвтомобилей.ГосНомер);
		АвтомобильЗаказа.Наименование = Справочники.Автомобили.СформироватьНаименованиеАвтомобиляПоПолям(Автомобиль.Модель, Автомобиль.Цвет, ГосНомер, VIN);
		Справочники.Автомобили.СформироватьНаименованиеПоУмолчанию(АвтомобильЗаказа);
		Попытка
			АвтомобильЗаказа.Записать();
		Исключение
			Результат = Ложь;
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ДобавитьДополнительныеРеквизиты()
	
	СсылкаОбъект = Ссылка.ПолучитьОбъект();
	
	ЗначениеВДанныеФормы(СсылкаОбъект, Объект);
	УправлениеСвойствами.ПеренестиЗначенияИзРеквизитовФормыВОбъект(ЭтотОбъект, Объект);
	Если НЕ ФормаОбъекта Тогда
		СсылкаОбъект = ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.ЗаказПоставщикуНаАвтомобиль"));
		СсылкаОбъект.Записать();
	КонецЕсли;
	
КонецФункции

#Область ОбработчикиСлужебногоПрограммногоИнтерфейса

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаОповещения(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если ДополнительныеПараметры = "РасширенноеРедактированиеПоляКомментарий" И РезультатОповещения <> Неопределено Тогда
		Комментарий = РезультатОповещения;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры // Подключаемый_ОбработкаРезультатаОповещения()

#КонецОбласти

#КонецОбласти

