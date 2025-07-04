﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Обработки.ЗагрузкаДанныхБух.СформироватьОтчет(ТабличныйДокумент, Параметры);
	ВремяЗавершения = Параметры.ОкончаниеРаботы;
	ИмяФайла        = Параметры.ИмяФайла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьКакExcel(Команда)
	
	ФайлЗагрузкиИсходный = Новый Файл(ИмяФайла);
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Заголовок		= НСтр("ru = 'Сохранение табличного документа'");
	Диалог.Фильтр			= "Табличный документ (*.mxl)|*.mxl";
	Диалог.Расширение		= "mxl";
	Диалог.ПолноеИмяФайла	= ФайлЗагрузкиИсходный.ИмяБезРасширения
								+ " " + СтрЗаменить(Формат(ВремяЗавершения, "ДЛФ=ДВ"), ":", "");
	
	ПараметрыОповещения = Новый Структура("Диалог, ТипФайла", Диалог, ТипФайлаТабличногоДокумента.MXL);
	Диалог.Показать(Новый ОписаниеОповещения("СохранитьКакЗавершение", ЭтотОбъект, ПараметрыОповещения));
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКакTXT(Команда)
	
	ФайлЗагрузкиИсходный = Новый Файл(ИмяФайла);
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Заголовок		= НСтр("ru = 'Сохранение табличного документа'");
	Диалог.Фильтр			= "Табличный документ (*.txt)|*.txt";
	Диалог.Расширение		= "txt";
	Диалог.ПолноеИмяФайла	= ФайлЗагрузкиИсходный.ИмяБезРасширения
								+ " " + СтрЗаменить(Формат(ВремяЗавершения, "ДЛФ=ДВ"), ":", "");
	
	ПараметрыОповещения = Новый Структура("Диалог, ТипФайла", Диалог, ТипФайлаТабличногоДокумента.TXT);
	Диалог.Показать(Новый ОписаниеОповещения("СохранитьКакЗавершение", ЭтотОбъект, ПараметрыОповещения));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьКакЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Диалог = ДополнительныеПараметры.Диалог;
	ТипФайла = ДополнительныеПараметры.ТипФайла;
	
	Если НЕ (ВыбранныеФайлы <> Неопределено) Тогда
		ТабличныйДокумент.НачатьЗапись(Неопределено, Диалог.ПолноеИмяФайла, ТипФайла);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти