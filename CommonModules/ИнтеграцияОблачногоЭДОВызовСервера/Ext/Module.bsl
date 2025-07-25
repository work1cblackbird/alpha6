﻿// @strict-types

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаРезультатаВыполненияДействийЭДО

#Область ОжиданиеВыполненияДействийЭДО

// Параметры:
//  АдресаРезультатов - см. СервисОблачногоЭДОКлиент.АдресаРезультатовАсинхронныхОпераций
// 
// Возвращаемое значение:
//  См. ИнтеграцияОблачногоЭДО.НовыеРезультатыДействийПоУчетнымЗаписямОблачногоЭДО
Функция РезультатыДействийЭДОАсинхронно(Знач АдресаРезультатов) Экспорт
	
	РезультатыДействийЭДО = ИнтеграцияОблачногоЭДО.НовыеРезультатыДействийПоУчетнымЗаписямОблачногоЭДО();
	
	КонтекстДиагностики = ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики();
	
	Для Каждого АдресРезультата Из АдресаРезультатов Цикл
		ИдентификаторУчетныйЗаписи = АдресРезультата.Ключ;
		АдресВоВременномХранилище = АдресРезультата.Значение;
		
		РезультатыМетодовОперации = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище); // См. ИнтеграцияОблачногоЭДО.ОбработатьРезультатыМетодовОперацииСервисаПоДействиямЭДО.РезультатыМетодовОперации
		УдалитьИзВременногоХранилища(АдресВоВременномХранилище);
	
		ИнтеграцияОблачногоЭДО.ОбработатьРезультатыМетодовОперацииСервисаПоДействиямЭДО(
			ИдентификаторУчетныйЗаписи, РезультатыМетодовОперации, КонтекстДиагностики);
	КонецЦикла;
	
	Возврат РезультатыДействийЭДО;
		
КонецФункции

#КонецОбласти

#Область ЗаполнениеДанныхДляПодписанияПоВыбраннымСертификатам

// Параметры:
//  ДанныеДляЗаполненияПоУчетнымЗаписям - см. ИнтеграцияОблачногоЭДО.ЗаполнитьДанныеДляПодписанияПоВыбраннымСертификатам.ДанныеДляЗаполненияПоУчетнымЗаписям
//  
// Возвращаемое значение:
//  См. ДлительныеОперации.ВыполнитьФункцию
//
Функция ЗаполнитьДанныеДляПодписанияПоВыбраннымСертификатамВФоне(Знач ДанныеДляЗаполненияПоУчетнымЗаписям) Экспорт
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияФункции(Новый УникальныйИдентификатор);
	
	// См. ИнтеграцияОблачногоЭДО.ЗаполнитьДанныеДляПодписанияПоВыбраннымСертификатам
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполненияВФоне,
		"ИнтеграцияОблачногоЭДО.ЗаполнитьДанныеДляПодписанияПоВыбраннымСертификатам",
		ДанныеДляЗаполненияПоУчетнымЗаписям);
	
	Возврат ДлительнаяОперация;
	
КонецФункции

// Параметры:
//  АдресРезультата - Строка
// 
// Возвращаемое значение:
//  См. ИнтеграцияОблачногоЭДО.ЗаполнитьДанныеДляПодписанияПоВыбраннымСертификатам
Функция РезультатЗаполненияДанныхДляПодписанияПоВыбраннымСертификатамВФоне(Знач АдресРезультата) Экспорт
	РезультатЗаполнения = ПолучитьИзВременногоХранилища(АдресРезультата); // См. РезультатЗаполненияДанныхДляПодписанияПоВыбраннымСертификатамВФоне
	УдалитьИзВременногоХранилища(АдресРезультата);
	Возврат РезультатЗаполнения;
КонецФункции

// Параметры:
//  АдресаРезультатов - см. СервисОблачногоЭДОКлиент.АдресаРезультатовАсинхронныхОпераций
// 
// Возвращаемое значение:
//  Структура:
//  * ЗаполненныеДанныеПоУчетнымЗаписям - Соответствие из КлючИЗначение:
//  ** Ключ - Строка - идентификатор учетной записи облачного ЭДО.
//  ** Значение - см. ОбработатьРезультатЗаполненияДанныхДляПодписанияПоВыбраннымСертификатам
//  * КонтекстДиагностики - см. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
Функция РезультатЗаполненияДанныхДляПодписанияПоВыбраннымСертификатамАсинхронно(Знач АдресаРезультатов) Экспорт
	
	ЗаполненныеДанныеПоУчетнымЗаписям = Новый Соответствие;
	КонтекстДиагностики = ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики();
	
	РезультатЗаполнения = Новый Структура;
	РезультатЗаполнения.Вставить("ЗаполненныеДанныеПоУчетнымЗаписям", ЗаполненныеДанныеПоУчетнымЗаписям);
	РезультатЗаполнения.Вставить("КонтекстДиагностики", КонтекстДиагностики);
	
	Для Каждого АдресРезультата Из АдресаРезультатов Цикл
		ИдентификаторУчетныйЗаписи = АдресРезультата.Ключ;
		АдресВоВременномХранилище = АдресРезультата.Значение;
		
		РезультатЗаполненияДанных = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище); // См. ИнтеграцияОблачногоЭДО.ОбработатьРезультатЗаполненияДанныхДляПодписанияПоВыбраннымСертификатам.РезультатЗаполненияДанных
		УдалитьИзВременногоХранилища(АдресВоВременномХранилище);
		
		ЗаполненныеДанные = ИнтеграцияОблачногоЭДО.ОбработатьРезультатЗаполненияДанныхДляПодписанияПоВыбраннымСертификатам(
			РезультатЗаполненияДанных, КонтекстДиагностики);
		
		ЗаполненныеДанныеПоУчетнымЗаписям.Вставить(ИдентификаторУчетныйЗаписи, ЗаполненныеДанные);
		
	КонецЦикла;
	
	Возврат РезультатЗаполнения;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОтражениеВУчете

// Параметры:
//  СпособыОбработкиДокументов - Соответствие из КлючИЗначение:
//  * Ключ - ДокументСсылка.ЭлектронныйДокументВходящийЭДО
//  * Значение - Строка - способ обработки.
//  ИдентификаторФормы - УникальныйИдентификатор
// 
// Возвращаемое значение:
//  см. ДлительныеОперации.ВыполнитьФункцию
Функция СоздатьОбъектыУчетаПоДокументамЭДОВФоне(Знач СпособыОбработкиДокументов, Знач ИдентификаторФормы) Экспорт
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	
	// См. ИнтеграцияОблачногоЭДО.СоздатьОбъектыУчетаПоДокументамЭДО
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполненияВФоне,
		"ИнтеграцияОблачногоЭДО.СоздатьОбъектыУчетаПоДокументамЭДО", СпособыОбработкиДокументов);
	
КонецФункции

#КонецОбласти

#Область Приглашения

// Параметры:
//  Приглашения - Массив из см. ПриглашенияЭДОКлиентСервер.НовоеИсходящееПриглашение
//  РасшифрованныеМаркеры - см. КриптографияБЭДКлиентСервер.НовыйНаборРасшифрованныхДанных
// 
// Возвращаемое значение:
//  См. ДлительныеОперации.ВыполнитьФункцию
Функция ОтправитьПриглашенияВФоне(Знач Приглашения, Знач РасшифрованныеМаркеры) Экспорт
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияФункции(Новый УникальныйИдентификатор);
	
	// см. ИнтеграцияОблачногоЭДО.ОтправитьПриглашения
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполненияВФоне,
		"ИнтеграцияОблачногоЭДО.ОтправитьПриглашения", Приглашения, РасшифрованныеМаркеры);
	
КонецФункции

// Параметры:
//  Приглашения - Массив из см. ПриглашенияЭДОКлиент.НовоеВходящееПриглашение
//  РасшифрованныеМаркеры - см. КриптографияБЭДКлиентСервер.НовыйНаборРасшифрованныхДанных
// 
// Возвращаемое значение:
//  См. ДлительныеОперации.ВыполнитьФункцию
Функция ПринятьПриглашенияВФоне(Знач Приглашения, Знач РасшифрованныеМаркеры) Экспорт
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияФункции(Новый УникальныйИдентификатор);
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполненияВФоне,
		"ИнтеграцияОблачногоЭДО.ПринятьПриглашения", Приглашения, РасшифрованныеМаркеры);
	
КонецФункции

// Параметры:
//  Приглашения - Массив из см. ПриглашенияЭДОКлиент.НовоеВходящееПриглашение
//  РасшифрованныеМаркеры - см. КриптографияБЭДКлиентСервер.НовыйНаборРасшифрованныхДанных
// 
// Возвращаемое значение:
//  См. ДлительныеОперации.ВыполнитьФункцию
Функция ОтклонитьПриглашенияВФоне(Знач Приглашения, Знач РасшифрованныеМаркеры) Экспорт
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияФункции(Новый УникальныйИдентификатор);
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполненияВФоне,
		"ИнтеграцияОблачногоЭДО.ОтклонитьПриглашения", Приглашения, РасшифрованныеМаркеры);
	
КонецФункции

// Параметры:
//  ДлительнаяОперация - Неопределено
//                     - См. ДлительныеОперации.ВыполнитьФункцию
// 
// Возвращаемое значение:
//  См. ИнтеграцияОблачногоЭДО.НовыйРезультатДействияСПриглашениями
Функция РезультатДействияСПриглашениямиВФоне(Знач ДлительнаяОперация) Экспорт
	
	Результат = ИнтеграцияОблачногоЭДО.НовыйРезультатДействияСПриглашениями();
	
	Если ДлительнаяОперация <> Неопределено
		И ДлительнаяОперация.Статус = "Выполнено" Тогда
		РезультатОперации = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата); // См. ИнтеграцияОблачногоЭДО.НовыйРезультатДействияСПриглашениями
		УдалитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
		Если ТипЗнч(РезультатОперации) = Тип("Структура") Тогда
			Результат = РезультатОперации;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область УчетныеЗаписиЭДО

// Параметры:
//  ПараметрыРегистрации - см. ИнтеграцияОблачногоЭДОКлиент.НовыеПараметрыРегистрацииСертификатовВЭДО
//  ИдентификаторФормы - Неопределено,УникальныйИдентификатор
// 
// Возвращаемое значение:
//  См. ДлительныеОперации.ВыполнитьФункцию
Функция ПодготовитьДанныеДляПодписанияНаРегистрациюВЭДОВФоне(Знач ПараметрыРегистрации, Знач ИдентификаторФормы) Экспорт
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	
	// См. ИнтеграцияОблачногоЭДО.ПодготовитьДанныеДляПодписанияНаРегистрациюВЭДО
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполненияВФоне,
		"ИнтеграцияОблачногоЭДО.ПодготовитьДанныеДляПодписанияНаРегистрациюВЭДО", ПараметрыРегистрации);
	
КонецФункции

// Параметры:
//  Организация - ОпределяемыйТип.Организация
//  ИдентификаторЗаявки - Строка
//  Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
// 
// Возвращаемое значение:
//  См. ИнтеграцияОблачногоЭДО.ЗаполнитьДанныеДляПодписанияНаРегистрациюВЭДОПоСертификату
Функция ЗаполнитьДанныеДляПодписанияНаРегистрациюВЭДОПоСертификату(Знач Организация, Знач ИдентификаторЗаявки, Знач Сертификат) Экспорт
	Возврат ИнтеграцияОблачногоЭДО.ЗаполнитьДанныеДляПодписанияНаРегистрациюВЭДОПоСертификату(
		Организация, ИдентификаторЗаявки, Сертификат);
КонецФункции

// Параметры:
//  Организация - ОпределяемыйТип.Организация
//  ИдентификаторЗаявки - Строка
//  Подписи - Структура:
//  * ПодписьСоглашения - ДвоичныеДанные
//  * ПодписьДанныхДляРегистрации - ДвоичныеДанные
//  * Доверенность - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций
//  ИдентификаторФормы - УникальныйИдентификатор
// 
// Возвращаемое значение:
//  См. ДлительныеОперации.ВыполнитьФункцию
Функция ОтправитьРегистрационныйПакетЭДОВФоне(Знач Организация, Знач ИдентификаторЗаявки, Знач Подписи, Знач ИдентификаторФормы) Экспорт
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполненияВФоне,
		"ИнтеграцияОблачногоЭДО.ОтправитьРегистрационныйПакетЭДО",
		Организация, ИдентификаторЗаявки, Подписи);
	
КонецФункции

// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения
//  ИдентификаторыЗаявокПоОрганизациям - Соответствие из КлючИЗначение:
//  * Ключ - ОпределяемыйТип.Организация
//  * Значение - Массив из Строка
//  ИдентификаторФормы - УникальныйИдентификатор
// 
// Возвращаемое значение:
//  См. ДлительныеОперации.ВыполнитьФункцию
Функция ПроверитьОбработкуРегистрационныхПакетовЭДОВФоне(Знач ИдентификаторыЗаявокПоОрганизациям, Знач ИдентификаторФормы) Экспорт
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполненияВФоне,
		"ИнтеграцияОблачногоЭДО.ПроверитьОбработкуРегистрационныхПакетовЭДО", ИдентификаторыЗаявокПоОрганизациям);
	
КонецФункции

// Параметры:
//  ИдентификаторУчетнойЗаписиЭДО - Строка
//  ИдентификаторФормы - УникальныйИдентификатор
// 
// Возвращаемое значение:
//  См. ДлительныеОперации.ВыполнитьФункцию
Функция ОбновитьИнформациюОбУчетнойЗаписиЭДОВФоне(Знач ИдентификаторУчетнойЗаписиЭДО, Знач ИдентификаторФормы) Экспорт
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполненияВФоне,
		"ИнтеграцияОблачногоЭДО.ОбновитьИнформациюОбУчетнойЗаписиЭДО", ИдентификаторУчетнойЗаписиЭДО);
	
КонецФункции

// Параметры:
//  ИдентификаторУчетнойЗаписиЭДО - см. ИнтеграцияОблачногоЭДО.ОбновитьНастройкиУведомленийУчетнойЗаписиЭДО.ИдентификаторУчетнойЗаписиЭДО
//  ПараметрыУведомлений - см. ИнтеграцияОблачногоЭДО.ОбновитьНастройкиУведомленийУчетнойЗаписиЭДО.ПараметрыУведомлений
//  РасшифрованныеМаркеры - см. ИнтеграцияОблачногоЭДО.ОбновитьНастройкиУведомленийУчетнойЗаписиЭДО.РасшифрованныеМаркеры
//  ИдентификаторФормы - УникальныйИдентификатор
// 
// Возвращаемое значение:
//  См. ДлительныеОперации.ВыполнитьФункцию
Функция ОбновитьНастройкиУведомленийУчетнойЗаписиЭДОВФоне(Знач ИдентификаторУчетнойЗаписиЭДО, Знач ПараметрыУведомлений, Знач РасшифрованныеМаркеры, Знач ИдентификаторФормы) Экспорт
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполненияВФоне,
		"ИнтеграцияОблачногоЭДО.ОбновитьНастройкиУведомленийУчетнойЗаписиЭДО",
		ИдентификаторУчетнойЗаписиЭДО, РасшифрованныеМаркеры, ПараметрыУведомлений);
	
КонецФункции

// Параметры:
//  ИдентификаторУчетнойЗаписиЭДО - см. ИнтеграцияОблачногоЭДО.НастройкиУведомленийУчетнойЗаписиЭДО.ИдентификаторУчетнойЗаписиЭДО
//  РасшифрованныеМаркеры - см. КриптографияБЭДКлиентСервер.НовыйНаборРасшифрованныхДанных
//  Организация - Неопределено,ОпределяемыйТип.Организация
//  ИдентификаторФормы - Неопределено,УникальныйИдентификатор
// 
// Возвращаемое значение:
//  См. ДлительныеОперации.ВыполнитьФункцию
Функция НастройкиУведомленийУчетнойЗаписиЭДОВФоне(Знач ИдентификаторУчетнойЗаписиЭДО, Знач РасшифрованныеМаркеры, Знач Организация = Неопределено, Знач ИдентификаторФормы = Неопределено) Экспорт
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполненияВФоне,
		"ИнтеграцияОблачногоЭДО.НастройкиУведомленийУчетнойЗаписиЭДО",
		ИдентификаторУчетнойЗаписиЭДО, РасшифрованныеМаркеры, Организация);
	
КонецФункции

#КонецОбласти

#Область АвторизацияВСервисеЭДО

// Параметры:
//  ИдентификаторыУчетныхЗаписейЭДО - Массив из Строка
//  ОтпечаткиПоКонтекстам - см. КриптографияБЭДКлиентСервер.НовыеРезультатыПолученияОтпечатков
//  Организация - Неопределено,ОпределяемыйТип.Организация
//  ВыбранныйСертификат - Неопределено,СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
// 
// Возвращаемое значение:
//  См. ДлительныеОперации.ВыполнитьФункцию
Функция АвторизоватьсяВСервисеЭДОВФоне(Знач ИдентификаторыУчетныхЗаписейЭДО, Знач ОтпечаткиПоКонтекстам, Знач Организация = Неопределено, Знач ВыбранныйСертификат = Неопределено) Экспорт
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияФункции(Новый УникальныйИдентификатор);
	
	// См. ИнтеграцияОблачногоЭДО.АвторизоватьсяВСервисеЭДО
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполненияВФоне,
		"ИнтеграцияОблачногоЭДО.АвторизоватьсяВСервисеЭДО",
		ИдентификаторыУчетныхЗаписейЭДО, ОтпечаткиПоКонтекстам, Организация, ВыбранныйСертификат);
	
КонецФункции

// Параметры:
//  ДлительнаяОперация - Неопределено
//                     - См. ДлительныеОперации.ВыполнитьФункцию
// 
// Возвращаемое значение:
//  См. ИнтеграцияОблачногоЭДО.НовыйРезультатАвторизацииВСервисеЭДО
Функция РезультатАвторизацииВСервисеЭДОВФоне(Знач ДлительнаяОперация) Экспорт
	
	Результат = ИнтеграцияОблачногоЭДО.НовыйРезультатАвторизацииВСервисеЭДО();
	
	Если ДлительнаяОперация <> Неопределено
		И ДлительнаяОперация.Статус = "Выполнено" Тогда
		РезультатОперации = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата); // См. ИнтеграцияОблачногоЭДО.НовыйРезультатАвторизацииВСервисеЭДО
		УдалитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
		Если ТипЗнч(РезультатОперации) = Тип("Структура") Тогда
			Результат = РезультатОперации;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти
