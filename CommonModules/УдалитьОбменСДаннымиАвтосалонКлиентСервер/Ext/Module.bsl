﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Если Не ВебКлиент И Не МобильныйКлиент Тогда

Функция НовыйФайлЗапускаКомандыWindows(СтрокаКоманды, ТекущийКаталог, ДождатьсяЗавершения, КодировкаИсполнения) Экспорт
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.ДобавитьСтроку("@echo off");
	
	Если ЗначениеЗаполнено(КодировкаИсполнения) Тогда 
		
		Если КодировкаИсполнения = "OEM" Тогда
			КодировкаИсполнения = 437;
		ИначеЕсли КодировкаИсполнения = "CP866" Тогда
			КодировкаИсполнения = 866;
		ИначеЕсли КодировкаИсполнения = "UTF8" Тогда
			КодировкаИсполнения = 65001;
		КонецЕсли;
		
		ТекстовыйДокумент.ДобавитьСтроку("chcp " + Формат(КодировкаИсполнения, "ЧГ="));
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекущийКаталог) Тогда 
		ТекстовыйДокумент.ДобавитьСтроку("cd /D """ + ТекущийКаталог + """");
	КонецЕсли;
	ТекстовыйДокумент.ДобавитьСтроку("cmd /S /C "" " + СтрокаКоманды + " """);
	
	Возврат ТекстовыйДокумент;
	
КонецФункции

#КонецЕсли

#Область ЗапускВнешнихПриложений

Функция БезопаснаяСтрокаКоманды(КомандаЗапуска) Экспорт
	
	Результат = "";
	
	Если ТипЗнч(КомандаЗапуска) = Тип("Строка") Тогда 
		
		Если СодержитНебезопасныеДействия(КомандаЗапуска) Тогда 
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось запустить программу
				           |по причине:
				           |Недопустимая строка команды
				           |%1
				           |по причине:
				           |Строка команды не должна содержать символы: ""$"", ""`"", ""|"", "";"", ""&"".'"),
				КомандаЗапуска);
		КонецЕсли;
		
		Результат = КомандаЗапуска;
		
	ИначеЕсли ТипЗнч(КомандаЗапуска) = Тип("Массив") Тогда
		
		Если КомандаЗапуска.Количество() > 0 Тогда 
			
			Если СодержитНебезопасныеДействия(КомандаЗапуска[0]) Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось запустить программу
				           |по причине:
				           |Недопустимая команда или путь к исполняемому файлу
				           |%1
				           |по причине:
				           |Команда не должна содержать символы: ""$"", ""`"", ""|"", "";"", ""&"".'"),
				КомандаЗапуска[0]);
			КонецЕсли;
			
			Результат = МассивВСтрокуКоманды(КомандаЗапуска);
			
		Иначе
			ВызватьИсключение
				НСтр("ru = 'Ожидалось, что первый элемент массива КомандаЗапуска будет командой или путем к исполняемому файлу.'");
		КонецЕсли;
		
	Иначе 
		ВызватьИсключение 
			НСтр("ru = 'Ожидалось, что значение КомандаЗапуска будет <Строка> или <Массив>'");
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область БезопаснаяСтрокаКоманды

Функция СодержитНебезопасныеДействия(Знач СтрокаКоманды)
	
	Возврат СтрНайти(СтрокаКоманды, "$") <> 0
		Или СтрНайти(СтрокаКоманды, "`") <> 0
		Или СтрНайти(СтрокаКоманды, "|") <> 0
		Или СтрНайти(СтрокаКоманды, ";") <> 0
		Или СтрНайти(СтрокаКоманды, "&") <> 0;
	
КонецФункции

Функция МассивВСтрокуКоманды(КомандаЗапуска)
	
	Результат = Новый Массив;
	НужныКавычки = Ложь;
	Для Каждого Аргумент Из КомандаЗапуска Цикл
		
		Если Результат.Количество() > 0 Тогда 
			Результат.Добавить(" ");
		КонецЕсли;
		
		НужныКавычки = Аргумент = Неопределено
			Или ПустаяСтрока(Аргумент)
			Или СтрНайти(Аргумент, " ")
			Или СтрНайти(Аргумент, Символы.Таб)
			Или СтрНайти(Аргумент, "&")
			Или СтрНайти(Аргумент, "(")
			Или СтрНайти(Аргумент, ")")
			Или СтрНайти(Аргумент, "[")
			Или СтрНайти(Аргумент, "]")
			Или СтрНайти(Аргумент, "{")
			Или СтрНайти(Аргумент, "}")
			Или СтрНайти(Аргумент, "^")
			Или СтрНайти(Аргумент, "=")
			Или СтрНайти(Аргумент, ";")
			Или СтрНайти(Аргумент, "!")
			Или СтрНайти(Аргумент, "'")
			Или СтрНайти(Аргумент, "+")
			Или СтрНайти(Аргумент, ",")
			Или СтрНайти(Аргумент, "`")
			Или СтрНайти(Аргумент, "~")
			Или СтрНайти(Аргумент, "$")
			Или СтрНайти(Аргумент, "|");
		
		Если НужныКавычки Тогда 
			Результат.Добавить("""");
		КонецЕсли;
		
		Результат.Добавить(СтрЗаменить(Аргумент, """", """"""));
		
		Если НужныКавычки Тогда 
			Результат.Добавить("""");
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтрСоединить(Результат);
	
КонецФункции

#КонецОбласти

// Определяет режим эксплуатации информационной базы файловый (Истина) или серверный (Ложь).
// При проверке используется СтрокаСоединенияИнформационнойБазы, которую можно указать явно.
//
// См. ОбщегоНазначения.ИнформационнаяБазаФайловая
//
// Параметры:
//  СтрокаСоединенияИнформационнойБазы - Строка - параметр используется, если
//                 нужно проверить строку соединения не текущей информационной базы.
//
// Возвращаемое значение:
//  Булево - Истина, если файловая.
//
Функция ИнформационнаяБазаФайловая(Знач СтрокаСоединенияИнформационнойБазы = "") Экспорт
	
	Если ПустаяСтрока(СтрокаСоединенияИнформационнойБазы) Тогда
		СтрокаСоединенияИнформационнойБазы =  СтрокаСоединенияИнформационнойБазы();
	КонецЕсли;
	Возврат СтрНайти(Врег(СтрокаСоединенияИнформационнойБазы), "FILE=") = 1;
	
КонецФункции


#КонецОбласти
