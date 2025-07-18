﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ВладелецПомеченНаУдаление = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "ПометкаУдаления");
	
	Если ВладелецПомеченНаУдаление = Неопределено
		Или ВладелецПомеченНаУдаление Тогда
		ПредопределеннаяПапка = Ложь;
		Возврат;
	КонецЕсли;

	Если НЕ Взаимодействия.ПользовательЯвляетсяОтветственнымЗаВедениеПапок(Владелец) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Действие доступно только ответственному за ведение папок для данной почты.'"),
			Ссылка,,,Отказ);
	ИначеЕсли ПредопределеннаяПапка И (Не Родитель.Пустая()) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Нельзя переместить предопределенную папку в другую папку.'"),
			Ссылка,,,Отказ);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("Родитель", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Родитель"));
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ПредопределеннаяПапка = Ложь;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("Родитель") И Родитель <> ДополнительныеСвойства.Родитель Тогда
		Если НЕ ДополнительныеСвойства.Свойство("ОбработаноИзменениеРодителя") Тогда
			Взаимодействия.УстановитьРодителяУПапки(Ссылка,Родитель,Истина)
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// АльфаАвто

// Обработчик события объекта возникает в момент, когда выполняется установка нового номера.
//
// Параметры:
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//  Префикс              - Строка - Префикс, который будет использоваться для генерации номера.
//
Процедура ПриУстановкеНовогоКода(СтандартнаяОбработка, Префикс)
	
	// Вызываем общий обработчик события
	ПрефиксацияОбъектов.ПриУстановкеНовогоКода(ЭтотОбъект, СтандартнаяОбработка, Префикс);
	
КонецПроцедуры // ПриУстановкеНовогоКода()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли