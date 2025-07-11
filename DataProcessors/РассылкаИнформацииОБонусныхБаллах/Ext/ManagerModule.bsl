﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеДляРассылки(Объект) Экспорт
	
	Если Объект.СхемаКомпоновкиДанных = Неопределено Тогда
		Объект.СхемаКомпоновкиДанных = ПолучитьМакет("Макет");
		Объект.КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Объект.СхемаКомпоновкиДанных));
		Объект.КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(Объект.СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
		Объект.КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Объект.СхемаКомпоновкиДанных));
		Объект.КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(Объект.СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
	
	Объект.КомпоновщикНастроекКомпоновкиДанных.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ПериодТекущий", Объект.Дата);
	
	ТаблицаРезультат = Новый ТаблицаЗначений();
	
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакетаКомпоновкиДанных.Выполнить(Объект.СхемаКомпоновкиДанных, Объект.КомпоновщикНастроекКомпоновкиДанных.Настройки,,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаРезультат);
	ПроцессорВывода.НачатьВывод();
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
	ПроцессорВывода.ЗакончитьВывод();
	
	Возврат ТаблицаРезультат;
	
КонецФункции

Функция ВыполнитьРассылку(Объект, Регламентно = Ложь) Экспорт
	
	ИспользоватьПрочиеВзаимодействия = ПолучитьФункциональнуюОпцию("ИспользоватьПрочиеВзаимодействия");
	ИспользоватьПочтовыйКлиент       = ПолучитьФункциональнуюОпцию("ИспользоватьПочтовыйКлиент");
	
	// Проверим возможность выполнения рассылки
	Если НЕ ИспользоватьПрочиеВзаимодействия И НЕ ИспользоватьПочтовыйКлиент Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ШаблонРассылкиSMS) И НЕ ЗначениеЗаполнено(Объект.ШаблонРассылкиEMail) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Объект.ДанныеДляРассылки.Количество() = 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	// получим контактную информацию контрагента
	БонусныеПрограммыСервер.ЗаполнитьКонтактнуюИнфрмациюРассылок(Объект.ДанныеДляРассылки);
	
	// создаем документ
	ДокументыКОтправкеSMS   = Новый Массив;
	ДокументыКОтправкеПисем = Новый Массив;
	
	Если Регламентно Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Рассылка оповещений о бонусных баллах'"), 
		УровеньЖурналаРегистрации.Информация, , ,
		НСтр("ru = 'Формирование документов и рассылка'"));
	КонецЕсли;
	
	Для Каждого Рассылка Из Объект.ДанныеДляРассылки Цикл
		// SMS
		Если ИспользоватьПрочиеВзаимодействия
			И Рассылка.ИспользоватьSMSРассылку
			И НЕ ПустаяСтрока(Рассылка.Телефон)
			И ЗначениеЗаполнено(Объект.ШаблонРассылкиSMS)
			И Рассылка.Контрагент.СогласиеНаПолучениеSMS Тогда
			
			СтруктураРассылки = БонусныеПрограммыСервер.СтрокаРассылки();
			ЗаполнитьЗначенияСвойств(СтруктураРассылки, Рассылка);
			ДополнительныеПараметры = Новый Структура("СтрокаДанныхРассылки", СтруктураРассылки);
			
			СтруктураСообщения = ШаблоныСообщений.СформироватьСообщение(
			ОБъект.ШаблонРассылкиSMS,
			Объект,
			Новый УникальныйИдентификатор,
			ДополнительныеПараметры);
			
			ДокументыКОтправкеSMS.Добавить(БонусныеПрограммыСервер.СоздатьSMS(
			СтруктураСообщения,
			,
			Рассылка));
			
		КонецЕсли;
		
		// Email
		Если ИспользоватьПочтовыйКлиент
			И Рассылка.ИспользоватьEMailРассылку
			И НЕ ПустаяСтрока(Рассылка.Адрес)
			И ЗначениеЗаполнено(Объект.УчетнаяЗаписьЭлектроннойПочты)
			И ЗначениеЗаполнено(Объект.ШаблонРассылкиEMail) Тогда
			
			СтруктураРассылки = БонусныеПрограммыСервер.СтрокаРассылки();
			ЗаполнитьЗначенияСвойств(СтруктураРассылки, Рассылка);
			ДополнительныеПараметры = Новый Структура("СтрокаДанныхРассылки", СтруктураРассылки);
			
			СтруктураСообщения = ШаблоныСообщений.СформироватьСообщение(
			Объект.ШаблонРассылкиEMail,
			Объект,
			Новый УникальныйИдентификатор,
			ДополнительныеПараметры);
			
			ДокументыКОтправкеПисем.Добавить(БонусныеПрограммыСервер.СоздатьEmail(
			СтруктураСообщения,
			,
			Объект.УчетнаяЗаписьЭлектроннойПочты,
			Рассылка));
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДокументыКОтправкеSMS.Количество() > 0 Тогда
		
		БонусныеПрограммыСервер.ОтправитьSMS(ДокументыКОтправкеSMS);
		
	КонецЕсли;
	
	Если ДокументыКОтправкеПисем.Количество() > 0 И ЗначениеЗаполнено(Объект.УчетнаяЗаписьЭлектроннойПочты) Тогда
		
		БонусныеПрограммыСервер.ОтправитьEmail(ДокументыКОтправкеПисем, Объект.УчетнаяЗаписьЭлектроннойПочты);		
		
	КонецЕсли;
	
	Если Регламентно Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Рассылка оповещений о бонусных баллах'"), 
		УровеньЖурналаРегистрации.Информация, , ,
		НСтр("ru = 'Окончание формирования документов и рассылки'"));
	КонецЕсли;
		
КонецФункции

Процедура СформироватьСтруктуруЗначений(Параметр, Данные)
	
	СписокРеквизитов = Новый Массив;
	
	Для Каждого ТекущийПараметр Из Параметр Цикл
		СписокРеквизитов.Добавить(ТекущийПараметр.Ключ);
	КонецЦикла;
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Данные, 
		СтрСоединить(СписокРеквизитов, ","));
	Для Каждого Реквизит Из ЗначенияРеквизитов Цикл
		Параметр[Реквизит.Ключ] = Реквизит.Значение;
	КонецЦикла;
	
КонецПроцедуры

// СтандартныеПодсистемы.ШаблоныСообщений

// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты               - ДеревоЗначений - список реквизитов шаблона.
//         ** Имя            - Строка - Уникальное имя общего реквизита.
//         ** Представление  - Строка - Представление общего реквизита.
//         ** Тип            - Тип    - Тип реквизита. По умолчанию строка.
//         ** Формат         - Строка - Формат вывода значения для чисел, дат, строк и булевых значений.
//  Вложения                - ТаблицаЗначений - печатные формы и вложения
//         ** Имя            - Строка - Уникальное имя вложения.
//         ** Представление  - Строка - Представление варианта.
//         ** ТипФайла       - Строка - Тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", mxl"
//                                      и др.
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщений.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, ДополнительныеПараметры) Экспорт
	
	// Заполним только теми полями, что доступны для шаблона
	Реквизиты.Очистить();
	
	НовыйРеквизит = Реквизиты.Добавить();
	НовыйРеквизит.Имя = "Контрагент";
	НовыйРеквизит.Представление = НСтр("ru = 'Контрагент'");
	НовыйРеквизит.Тип = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	
	НовыйРеквизит = Реквизиты.Добавить();
	НовыйРеквизит.Имя = "БонуснаяПрограмма";
	НовыйРеквизит.Представление = НСтр("ru = 'Бонусная программа'");
	НовыйРеквизит.Тип = Новый ОписаниеТипов("СправочникСсылка.БонусныеПрограммы");
	
	НовыйРеквизит = Реквизиты.Добавить();
	НовыйРеквизит.Имя = "Карточка";
	НовыйРеквизит.Представление = НСтр("ru = 'Карточка'");
	НовыйРеквизит.Тип = Новый ОписаниеТипов("СправочникСсылка.Карточки");
	
	НовыйРеквизит = Реквизиты.Добавить();
	НовыйРеквизит.Имя = "Количество";
	НовыйРеквизит.Представление = НСтр("ru = 'Количество активных бонусных баллов'");
	НовыйРеквизит.Тип = Новый ОписаниеТипов("Число");
	
	НовыйРеквизит = Реквизиты.Добавить();
	НовыйРеквизит.Имя = "ДатаСписания";
	НовыйРеквизит.Представление = НСтр("ru = 'Дата списания бонусных баллов'");
	НовыйРеквизит.Тип = Новый ОписаниеТипов("Дата");
	
КонецПроцедуры

// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// Параметры:
//  Сообщение - Структура - структура с ключами:
//    * ЗначенияРеквизитов - Соответствие - список используемых в шаблоне реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * ЗначенияОбщихРеквизитов - Соответствие - список используемых в шаблоне общих реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * Вложения - Соответствие - значения реквизитов 
//      ** Ключ     - Строка - имя вложения в шаблоне;
//      ** Значение - ДвоичныеДанные, Строка - двоичные данные или адрес во временном хранилище вложения.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//  ДополнительныеПараметры - Структура -  Дополнительная информация о шаблоне сообщения.
//
Процедура ПриФормированииСообщения(Сообщение, ПредметСообщения, ДополнительныеПараметры) Экспорт
	
	СтрокаДанных = ПолучитьЗначениеПараметраСтруктуры(Сообщение.ДополнительныеПараметры, "СтрокаДанныхРассылки");
	
	Если СтрокаДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контрагент = Сообщение.ЗначенияРеквизитов.Получить("Контрагент");
	Если Контрагент <> Неопределено Тогда
		СформироватьСтруктуруЗначений(Контрагент, СтрокаДанных.Контрагент);
	КонецЕсли;
	
	БонуснаяПрограмма = Сообщение.ЗначенияРеквизитов.Получить("БонуснаяПрограмма");
	Если БонуснаяПрограмма <> Неопределено Тогда
		СформироватьСтруктуруЗначений(БонуснаяПрограмма, СтрокаДанных.БонуснаяПрограмма);
	КонецЕсли;
	
	Карточка = Сообщение.ЗначенияРеквизитов.Получить("Карточка");
	Если Карточка <> Неопределено Тогда
		СформироватьСтруктуруЗначений(Карточка, СтрокаДанных.Карточка);
	КонецЕсли;
	
	Количество = Сообщение.ЗначенияРеквизитов.Получить("Количество");
	Если Количество <> Неопределено Тогда
		Сообщение.ЗначенияРеквизитов.Вставить("Количество", Строка(СтрокаДанных.Количество));
	КонецЕсли;
	
	ДатаСписания = Сообщение.ЗначенияРеквизитов.Получить("ДатаСписания");
	Если ДатаСписания <> Неопределено Тогда
		Сообщение.ЗначенияРеквизитов.Вставить("ДатаСписания", Формат(СтрокаДанных.ДатаСписания, "ДФ='dd.MM.yyyy'"));
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список получателей SMS при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиSMS - ТаблицаЗначений - список получается SMS.
//     * НомерТелефона - Строка - номер телефона, куда будет отправлено сообщение SMS.
//     * Представление - Строка - представление получателя сообщения SMS.
//     * Контакт       - Произвольный - контакт, которому принадлежит номер телефона.
//  ПредметСообщения - ЛюбаяСсылка, Структура - ссылка на объект являющийся источником данных, либо структура,
//                                              если шаблон содержит произвольные параметры:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект являющийся источником данных
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров.
//
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, ПредметСообщения) Экспорт
	
КонецПроцедуры

// Заполняет список получателей письма при отправки сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма.
//     * Адрес           - Строка - адрес электронной почты получателя.
//     * Представление   - Строка - представление получается письма.
//     * Контакт         - Произвольный - контакт, которому принадлежит адрес электронной почты.
//  ПредметСообщения - ЛюбаяСсылка, Структура - ссылка на объект являющийся источником данных, либо структура,
//                                              если шаблон содержит произвольные параметры:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект являющийся источником данных
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, ПредметСообщения) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ШаблоныСообщений


#КонецОбласти

#КонецЕсли