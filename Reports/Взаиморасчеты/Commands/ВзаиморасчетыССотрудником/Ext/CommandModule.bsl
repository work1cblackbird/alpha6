﻿
#Область ОбработчикиСобытий

// Обработчик события нажатия кнопки "Взаиморасчеты".
//
// Параметры:
//  ПараметрКоманды - Произвольный - В параметр передается значение от источника, в котором реализована команда
//  ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды - В обработчике команды можно изменить значение свойств
//                                                            параметра Окно и Уникальность.
//
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// !!!_Доработать отчет. нет отбора.
	// Формирование отчета по взаиморасчетам с контрагентом, связанным с сотрудником
//Процедура ВзаиморасчетыССотрудником() Экспорт
//	// проверки
//	Если Ссылка.Пустая() Тогда
//		Возврат;
//	КонецЕсли;
//	
//	// заполним параметры отчета
//	Отчет=Отчеты.Взаиморасчеты.Создать();
//	Отчет.ВидОтчета=Перечисления.ВидыОтчетов.Остатки;
//	Отчет.ДатаКонца=Неопределено;
//	Отчет.РежимВыводаОтчета=Перечисления.РежимыВыводаОтчета.ТабличныйДокумент;
//	Отчет.РежимНастройки=Перечисления.РежимыНастройкиОтчетов.Эксперт;
//	Отчет.ИмяФормыНастроек="НастройкиОстатки";
//	Отчет.ЗаполнитьНачальныеНастройки("ТекстЗапросаОстатки");
//	
//	УдаляемоеИзмерение=Отчет.ИзмеренияСтроки.Найти("Организация");
//	Если УдаляемоеИзмерение<>Неопределено Тогда УдаляемоеИзмерение.Использование=Ложь; КонецЕсли;
//	УдаляемоеИзмерение=Отчет.ИзмеренияСтроки.Найти("ПодразделениеКомпании");
//	Если УдаляемоеИзмерение<>Неопределено Тогда УдаляемоеИзмерение.Использование=Ложь; КонецЕсли;
//	УдаляемоеИзмерение=Отчет.ИзмеренияСтроки.Найти("Сделка");
//	Если УдаляемоеИзмерение<>Неопределено Тогда УдаляемоеИзмерение.Использование=Ложь; КонецЕсли;
//	
//	// показатели все
//	Для Каждого СтрокаПоказателей Из Отчет.Показатели Цикл
//		СтрокаПоказателей.Использование=Истина;
//	КонецЦикла;
//	
//	// фильтры
//	НовыйОтбор=Отчет.ПостроительОтчета.Отбор.Добавить("Контрагент.Сотрудник","Сотрудник","Сотрудник");
//	НовыйОтбор.Значение=Ссылка;
//	Если Ссылка.ЭтоГруппа Тогда
//		НовыйОтбор.ВидСравнения=ВидСравнения.ВИерархии;
//	Иначе
//		НовыйОтбор.ВидСравнения=ВидСравнения.Равно;
//		УдаляемоеИзмерение=Отчет.ИзмеренияСтроки.Найти("Контрагент");
//		Если УдаляемоеИзмерение<>Неопределено Тогда УдаляемоеИзмерение.Использование=Ложь; КонецЕсли;
//	КонецЕсли; 
//	НовыйОтбор.Использование=Истина;
//	
//	ФормаОтчета=ПолучитьОбщуюФорму("Отчет");
//	ФормаОтчета.ОтчетОбъект=Отчет;
//	ФормаОтчета.Заголовок="Взаиморасчеты компании";
//	ФормаОтчета.Открыть();
//КонецПроцедуры // ВзаиморасчетыССотрудником()

	// фильтры
	Контрагент = Новый Структура;
	Контрагент.Вставить("Сотрудник", ПараметрКоманды);
	
	Отбор = Новый Структура;
	Отбор.Вставить("Контрагент", Контрагент);
	ОтчетыПлатформаКлиент.ОткрытьОтчет("Отчет.Взаиморасчеты", "Остатки",,,, Отбор, ,ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры //ОбработкаКоманды()

#КонецОбласти