﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Предназначена для внесения изменений в форму Обслуживание обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ОбслуживаниеПриСозданииНаСервере(Форма) Экспорт
	
	// АльфаАвто
	// Добавление группы формы "Значимые события" 
	
	ГруппаЗначимыеСобытия = Форма.Элементы.Добавить("ГруппаЗначимыеСобытия", Тип("ГруппаФормы"));
	ГруппаЗначимыеСобытия.Заголовок				= Нстр("ru = 'Значимые события'");
	ГруппаЗначимыеСобытия.Вид					= ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаЗначимыеСобытия.Поведение				= ПоведениеОбычнойГруппы.Свертываемая;	
	ГруппаЗначимыеСобытия.ОтображениеУправления = ОтображениеУправленияОбычнойГруппы.Картинка;
	
	Форма.Элементы.ГруппаЗначимыеСобытия.Скрыть();
	Форма.Элементы.Переместить(
		ГруппаЗначимыеСобытия, Форма, Форма.Элементы.ГруппаРегламентныеОперации);
	
	ГруппаЗначимыеСобытияЛево = Форма.Элементы.Добавить(
		"ГруппаЗначимыеСобытияЛево", Тип("ГруппаФормы"), ГруппаЗначимыеСобытия);
	ГруппаЗначимыеСобытияЛево.Вид						= ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаЗначимыеСобытияЛево.Отображение				= ОтображениеОбычнойГруппы.Нет; 	
	ГруппаЗначимыеСобытияЛево.Группировка 				= ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаЗначимыеСобытияЛево.ОтображатьЗаголовок		= Ложь;
	ГруппаЗначимыеСобытияЛево.Ширина					= 43;
	ГруппаЗначимыеСобытияЛево.РастягиватьПоГоризонтали	= Ложь;
	
	ИспользоватьЗначимыеСобытия = Форма.Элементы.Добавить(
		"ИспользоватьЗначимыеСобытия", Тип("ПолеФормы"), ГруппаЗначимыеСобытияЛево); 
	ИспользоватьЗначимыеСобытия.Заголовок			= Нстр("ru = 'Значимые события'");
	ИспользоватьЗначимыеСобытия.Вид					= ВидПоляФормы.ПолеФлажка;
	ИспользоватьЗначимыеСобытия.ПутьКДанным			= "НаборКонстант.ИспользоватьЗначимыеСобытия";
	ИспользоватьЗначимыеСобытия.ПоложениеЗаголовка	= ПоложениеЗаголовкаЭлементаФормы.Право;
	ИспользоватьЗначимыеСобытия.УстановитьДействие("ПриИзменении", "Подключаемый_ПриИзмененииРеквизита");
	
	ПояснениеИспользоватьЗначимыеСобытия = Форма.Элементы.Добавить(
		"ПояснениеИспользоватьЗначимыеСобытия", Тип("ДекорацияФормы"), ГруппаЗначимыеСобытияЛево);
	ЗаголовокГруппы = Нстр("ru = 'Использовать обработку различных событий от прикладных объектов конфигурации.'");
	ПояснениеИспользоватьЗначимыеСобытия.Заголовок					= ЗаголовокГруппы;
	ПояснениеИспользоватьЗначимыеСобытия.Вид						= ВидДекорацииФормы.Надпись;
	ПояснениеИспользоватьЗначимыеСобытия.ЦветТекста					= ЦветаСтиля.ПоясняющийТекст;
	ПояснениеИспользоватьЗначимыеСобытия.ГоризонтальноеПоложение	= ГоризонтальноеПоложениеЭлемента.Лево;
	
	ГруппаЗначимыеСобытияПраво = Форма.Элементы.Добавить(
		"ГруппаЗначимыеСобытияПраво", Тип("ГруппаФормы"), ГруппаЗначимыеСобытия);
	ГруппаЗначимыеСобытияПраво.Вид					= ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаЗначимыеСобытияПраво.Отображение			= ОтображениеОбычнойГруппы.Нет; 	
	ГруппаЗначимыеСобытияПраво.Группировка			= ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаЗначимыеСобытияПраво.ОтображатьЗаголовок	= Ложь;
	
	НастроитьЗначимыеСобытия = Форма.Элементы.Добавить(
		"НастроитьЗначимыеСобытия", Тип("ДекорацияФормы"), ГруппаЗначимыеСобытияПраво);
	Заголовок = Новый ФорматированнаяСтрока(НСтр("ru = 'Настроить значимые события'"),,,, "e1cib/list/Справочник.ЗначимыеСобытия");
	НастроитьЗначимыеСобытия.Заголовок = Заголовок;
	
	ПояснениеРегистрСведенийНастройкиНастроитьЗначимыеСобытия = Форма.Элементы.Добавить(
		"ПояснениеРегистрСведенийНастройкиНастроитьЗначимыеСобытия", Тип("ДекорацияФормы"), ГруппаЗначимыеСобытияПраво);
	ЗаголовокГруппы = Нстр("ru = 'Создание значимых событий и действий на значимое событие.'");
	ПояснениеРегистрСведенийНастройкиНастроитьЗначимыеСобытия.Заголовок					= ЗаголовокГруппы;
	ПояснениеРегистрСведенийНастройкиНастроитьЗначимыеСобытия.Вид						= ВидДекорацииФормы.Надпись;
	ПояснениеРегистрСведенийНастройкиНастроитьЗначимыеСобытия.ЦветТекста				= ЦветаСтиля.ПоясняющийТекст;	
	ПояснениеРегистрСведенийНастройкиНастроитьЗначимыеСобытия.ГоризонтальноеПоложение	= ГоризонтальноеПоложениеЭлемента.Лево;
	// Конец АльфаАвто
	
КонецПроцедуры

// Предназначена для внесения изменений в форму ОбщиеНастройки обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ОбщиеНастройкиПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму Обслуживание обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура НастройкиПользователейИПравПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму ИнтернетПоддержкаИСервисы обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ИнтернетПоддержкаИСервисыПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму Органайзер обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ОрганайзерПриСозданииНаСервере(Форма) Экспорт
	
	// АльфаАвто
	// Добавление констант События, Жалобы, Рассылка
	
	Заголовок = Нстр("ru = 'События, жалобы, рассылка, заметки, напоминания, анкетирование, шаблоны сообщений'");
	Форма.Элементы.ГруппаЗаметкиНапоминанияАнкетированиеШаблоны.Заголовок = Заголовок;
	
	ГруппаДокументыТП3 = Форма.Элементы.Добавить(
		"ГруппаДокументыТП3", Тип("ГруппаФормы"), Форма.Элементы.ГруппаЗаметкиНапоминанияАнкетированиеШаблоны);
	ГруппаДокументыТП3.Вид					= ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаДокументыТП3.Отображение 			= ОтображениеОбычнойГруппы.Нет;
	ГруппаДокументыТП3.Группировка 			= ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаДокументыТП3.ОтображатьЗаголовок	= Ложь;
	
	// Перемещаем в начало родительской группы
	Форма.Элементы.Переместить(
		ГруппаДокументыТП3, Форма.Элементы.ГруппаЗаметкиНапоминанияАнкетированиеШаблоны, Форма.Элементы.ГруппаЗаметкиНапоминания);
	
	ГруппаСобытия = Форма.Элементы.Добавить(
		"События", Тип("ГруппаФормы"), ГруппаДокументыТП3);
	ГруппаСобытия.Вид					= ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаСобытия.ОтображатьЗаголовок	= Ложь;
	
	ГруппаИспользоватьВзаимодействия = Форма.Элементы.Добавить(
		"ГруппаИспользоватьВзаимодействия", Тип("ГруппаФормы"), ГруппаСобытия);
	ГруппаИспользоватьВзаимодействия.Вид						= ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаИспользоватьВзаимодействия.Отображение 				= ОтображениеОбычнойГруппы.СлабоеВыделение;
	ГруппаИспользоватьВзаимодействия.Группировка 				= ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаИспользоватьВзаимодействия.ОтображатьЗаголовок 		= Ложь;
	ГруппаИспользоватьВзаимодействия.Ширина 					= 43;
	ГруппаИспользоватьВзаимодействия.РастягиватьПоГоризонтали 	= Ложь; 
	
	ИспользоватьВзаимодействия = Форма.Элементы.Добавить(
		"ИспользоватьВзаимодействия", Тип("ПолеФормы"), ГруппаИспользоватьВзаимодействия); 
	ИспользоватьВзаимодействия.Заголовок 			= Нстр("ru = 'События'");
	ИспользоватьВзаимодействия.Вид 					= ВидПоляФормы.ПолеФлажка;
	ИспользоватьВзаимодействия.ПутьКДанным 			= "НаборКонстант.ИспользоватьСобытия";
	ИспользоватьВзаимодействия.ПоложениеЗаголовка 	= ПоложениеЗаголовкаЭлементаФормы.Право;
	ИспользоватьВзаимодействия.УстановитьДействие("ПриИзменении", "ИспользоватьПрочиеВзаимодействияПриИзменении");
	
	ПояснениеИспользоватьВзаимодействия = Форма.Элементы.Добавить(
		"ПояснениеИспользоватьВзаимодействия", Тип("ДекорацияФормы"), ГруппаИспользоватьВзаимодействия);
	ЗаголовокГруппы = Нстр("ru = 'Использовать документ планирования и отработки контактов, встреч и прочих событий, связанных с управлением проектами.'");
	ПояснениеИспользоватьВзаимодействия.Заголовок				= ЗаголовокГруппы;
	ПояснениеИспользоватьВзаимодействия.Вид						= ВидДекорацииФормы.Надпись;
	ПояснениеИспользоватьВзаимодействия.ЦветТекста				= ЦветаСтиля.ПоясняющийТекст;
	ПояснениеИспользоватьВзаимодействия.ГоризонтальноеПоложение	= ГоризонтальноеПоложениеЭлемента.Лево;
	ПояснениеИспользоватьВзаимодействия.ВертикальноеПоложение	= ВертикальноеПоложениеЭлемента.Верх;
	
	ГруппаВидыСобытий = Форма.Элементы.Добавить(
		"ГруппаВидыСобытий", Тип("ГруппаФормы"), ГруппаСобытия);
	ГруппаВидыСобытий.Вид					= ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаВидыСобытий.Отображение			= ОтображениеОбычнойГруппы.Нет;
	ГруппаВидыСобытий.ОтображатьЗаголовок	= Ложь;
	ГруппаВидыСобытий.Группировка			= ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	
	КнопкаНастроитьВидыСобытий = Форма.Элементы.Добавить(
		"КнопкаНастроитьВидыСобытий", Тип("ДекорацияФормы"), ГруппаВидыСобытий);
	Заголовок = Новый ФорматированнаяСтрока(НСтр("ru = 'Настроить виды событий'"),,,, "e1cib/list/Справочник.ВидыСобытий");
	КнопкаНастроитьВидыСобытий.Заголовок = Заголовок;
	
	ПояснениеНастройкаВидов = Форма.Элементы.Добавить(
		"ПояснениеНастройкаВидов", Тип("ДекорацияФормы"), ГруппаВидыСобытий);
	ЗаголовокГруппы = Нстр("ru = 'Настроить список возможных видов событий. 
								 |Используется для более подробной детализации событий.'");
	ПояснениеНастройкаВидов.Заголовок				= ЗаголовокГруппы;
	ПояснениеНастройкаВидов.Вид						= ВидДекорацииФормы.Надпись;
	ПояснениеНастройкаВидов.ЦветТекста				= ЦветаСтиля.ПоясняющийТекст;	
	ПояснениеНастройкаВидов.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Лево;
	
	ПрочиеДокументыВзаимодействия = Форма.Элементы.Добавить(
		"ПрочиеДокументыВзаимодействия", Тип("ГруппаФормы"), ГруппаДокументыТП3);
	ПрочиеДокументыВзаимодействия.Вид					= ВидГруппыФормы.ОбычнаяГруппа;
	ПрочиеДокументыВзаимодействия.ОтображатьЗаголовок	= Ложь;
	
	ГруппаЖалобыКлиента = Форма.Элементы.Добавить(
		"ЖалобыКлиента", Тип("ГруппаФормы"), ПрочиеДокументыВзаимодействия);
	ГруппаЖалобыКлиента.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаЖалобыКлиента.Группировка					= ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаЖалобыКлиента.ОтображатьЗаголовок 		= Ложь;
	ГруппаЖалобыКлиента.Подсказка 					= Нстр("ru = 'Жалобы клиента'");
	ГруппаЖалобыКлиента.Ширина 						= 43;
	ГруппаЖалобыКлиента.РастягиватьПоГоризонтали	= Ложь;
	
	ИспользоватьЖалобы = Форма.Элементы.Добавить(
		"ИспользоватьЖалобы", Тип("ПолеФормы"), ГруппаЖалобыКлиента); 
	ИспользоватьЖалобы.Заголовок			= Нстр("ru = 'Жалобы клиента'");
	ИспользоватьЖалобы.Вид 					= ВидПоляФормы.ПолеФлажка;
	ИспользоватьЖалобы.ПутьКДанным 			= "НаборКонстант.ИспользоватьЖалобы";
	ИспользоватьЖалобы.ПоложениеЗаголовка	= ПоложениеЗаголовкаЭлементаФормы.Право;
	ИспользоватьЖалобы.УстановитьДействие("ПриИзменении", "ИспользоватьПрочиеВзаимодействияПриИзменении");
	
	ПояснениеИспользоватьЖалобы = Форма.Элементы.Добавить(
		"ПояснениеИспользоватьЖалобы", Тип("ДекорацияФормы"), ГруппаЖалобыКлиента);
	ЗаголовокГруппы = Нстр("ru = 'Позволяет фиксировать и обрабатывать жалобы клиентов.'");
	ПояснениеИспользоватьЖалобы.Заголовок				= ЗаголовокГруппы;
	ПояснениеИспользоватьЖалобы.Вид						= ВидДекорацииФормы.Надпись;
	ПояснениеИспользоватьЖалобы.ЦветТекста				= ЦветаСтиля.ПоясняющийТекст;
	ПояснениеИспользоватьЖалобы.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Лево;
	
	ГруппаСрокиОбработки = Форма.Элементы.Добавить(
		"ГруппаСрокиОбработки", Тип("ГруппаФормы"), ГруппаЖалобыКлиента);
	ГруппаСрокиОбработки.Вид					= ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаСрокиОбработки.ОтображатьЗаголовок	= Ложь;
	ГруппаСрокиОбработки.Группировка 			= ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	
	ПояснениеВремяРазбораЖалобы = Форма.Элементы.Добавить(
		"ПояснениеВремяРазбораЖалобы", Тип("ДекорацияФормы"), ГруппаСрокиОбработки);
	ПояснениеВремяРазбораЖалобы.Заголовок 				= Нстр("ru = 'Сроки обработки жалоб клиентов.'");
	ПояснениеВремяРазбораЖалобы.Вид 					= ВидДекорацииФормы.Надпись;
	ПояснениеВремяРазбораЖалобы.ЦветТекста 				= ЦветаСтиля.ПоясняющийТекст;
	ПояснениеВремяРазбораЖалобы.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Лево;
	ПояснениеВремяРазбораЖалобы.ВертикальноеПоложение 	= ВертикальноеПоложениеЭлемента.Верх;
	
	ВремяРазбораЖалобы = Форма.Элементы.Добавить(
		"ВремяРазбораЖалобы", Тип("ПолеФормы"), ГруппаСрокиОбработки);
	ВремяРазбораЖалобы.Вид 					= ВидПоляФормы.ПолеВвода;
	ВремяРазбораЖалобы.ПутьКДанным 			= "НаборКонстант.ВремяРазбораЖалобы";
	ВремяРазбораЖалобы.ПоложениеЗаголовка 	= ПоложениеЗаголовкаЭлементаФормы.Право;
	ВремяРазбораЖалобы.УстановитьДействие("ПриИзменении", "ИспользоватьПрочиеВзаимодействияПриИзменении");
	
	ВремяРеакцииНаЖалобу = Форма.Элементы.Добавить(
		"ВремяРеакцииНаЖалобу", Тип("ПолеФормы"), ГруппаСрокиОбработки); 
	ВремяРеакцииНаЖалобу.Вид				= ВидПоляФормы.ПолеВвода;
	ВремяРеакцииНаЖалобу.ПутьКДанным		= "НаборКонстант.ВремяРеакцииНаЖалобу";
	ВремяРеакцииНаЖалобу.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	ВремяРеакцииНаЖалобу.УстановитьДействие("ПриИзменении", "ИспользоватьПрочиеВзаимодействияПриИзменении");
	
	Рассылка = Форма.Элементы.Добавить(
		"Рассылка", Тип("ГруппаФормы"), ПрочиеДокументыВзаимодействия);
	Рассылка.Вид					= ВидГруппыФормы.ОбычнаяГруппа;
	Рассылка.ОтображатьЗаголовок	= Ложь;
	Рассылка.Группировка 			= ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	
	ИспользоватьРассылку = Форма.Элементы.Добавить(
		"ИспользоватьРассылку", Тип("ПолеФормы"), Рассылка);
	ИспользоватьРассылку.Заголовок			= Нстр("ru = 'Рассылка'");
	ИспользоватьРассылку.Вид 				= ВидПоляФормы.ПолеФлажка;
	ИспользоватьРассылку.ПутьКДанным 		= "НаборКонстант.ИспользоватьРассылку";
	ИспользоватьРассылку.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	ИспользоватьРассылку.УстановитьДействие("ПриИзменении", "ИспользоватьПрочиеВзаимодействияПриИзменении");
	
	ПояснениеИспользоватьРассылку = Форма.Элементы.Добавить(
		"ПояснениеИспользоватьРассылку", Тип("ДекорацияФормы"), Рассылка);

	Заголовок = Нстр("ru = 'Позволяет осуществлять рассылку указанным клиентам с помощью электронных писем, SMS, телемаркетинга.'");
	ПояснениеИспользоватьРассылку.Заголовок					= Заголовок;
	ПояснениеИспользоватьРассылку.Вид 						= ВидДекорацииФормы.Надпись;
	ПояснениеИспользоватьРассылку.ЦветТекста 				= ЦветаСтиля.ПоясняющийТекст;
	ПояснениеИспользоватьРассылку.ГоризонтальноеПоложение 	= ГоризонтальноеПоложениеЭлемента.Лево;
	ПояснениеИспользоватьРассылку.ВертикальноеПоложение 	= ВертикальноеПоложениеЭлемента.Верх;

	ГруппаСрокиОбработки.Видимость = Форма.НаборКонстант.ИспользоватьЖалобы;
	// Конец АльфаАвто
	
КонецПроцедуры

// Предназначена для внесения изменений в форму СинхронизацияДанных обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура СинхронизацияДанныхПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму НастройкиРаботыСФайлами обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура НастройкиРаботыСФайламиПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму ПечатныеФормыОтчетыИОбработки обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ПечатныеФормыОтчетыИОбработкиПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

#КонецОбласти