﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура - При изменении настроек
//
// Параметры:
//  Форма	 - Форма	 - Форма отчета.
//
Процедура ПриИзмененииНастроекФормы(Форма) Экспорт
	Если Форма.ИмяФормы<>"Отчет.ПрайсЛистНаАвтоработы.Форма.ФормаНастроек" Тогда
		// Заполняем типы цен
		ЗаполнитьТипыЦен();
		// Выводим на форму
		Форма.ЗначениеВРеквизитФормы(ЭтотОбъект, "Отчет");
	КонецЕсли;
КонецПроцедуры

// Процедура - Заполнить типы цен
//
Процедура ЗаполнитьТипыЦен()
	// Очищаем ТЧ ТипыЦен
 	ТипыЦен.Очистить();
	// Очищаем параметр скд, путем вставки пустого значения.
    ПараметрыОтчета = КомпоновщикНастроек.Настройки.ПараметрыДанных;
	СписокТиповЦен = Новый СписокЗначений;	
	ПараметрыОтчета.УстановитьЗначениеПараметра("ТипыЦен", СписокТиповЦен);
	// Получаем все типы цен
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	ТипыЦен.Ссылка КАК Ссылка,
	                      |	ТипыЦен.Наименование КАК Наименование,
	                      |	ТипыЦен.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
	                      |ИЗ
	                      |	Справочник.ТипыЦен КАК ТипыЦен
	                      |ГДЕ
	                      |	ТипыЦен.ДляРабот = ИСТИНА
	                      |	И ТипыЦен.ПометкаУдаления = &ПометкаУдаления
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ТипыЦен.Наименование УБЫВ");

	Запрос.УстановитьПараметр("ПометкаУдаления",Ложь);
	Выборка=Запрос.Выполнить().Выбрать();
	// Добавляем в параметр СКД типы цен
	Пока Выборка.Следующий() Цикл                  
		СтрокаТиповЦен=ТипыЦен.Добавить();
		СтрокаТиповЦен.ТипЦены=Выборка.Ссылка; 
		
		// По умолчанию галочки сняты, но те типы цен, на которые имеет права пользователь,
		// выставляем в истину,а попытка необходима для успешности операции, т.к. если у пользователя нет прав на операцию,
		// то функция не сможет вернуть поле массива с несуществующим индексом.
		Попытка
			Если ПравоПользователя(Выборка.ИмяПредопределенныхДанных)<>Ложь Тогда
				СтрокаТиповЦен.Использование=Истина;
			КонецЕсли;		
		Исключение
		КонецПопытки;
	
	КонецЦикла;
	
 КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	// MIKOLV 
	// Внешний набор данных
	ВнешниеНаборыДанных=Новый Структура;
	// Получаем параметры, для того чтобы вставить в запрос.
	МассивТиповЦен =Новый Массив;
	МассивТиповЦен= ЭтотОбъект.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ТипыЦен");
	// Новый запрос
	Запрос = Новый Запрос;
	// Получаем внешний набор данных.
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	АвтоработыНормыВремени.Модель КАК Модель,
	               |	АвтоработыНормыВремени.ВариантКомплектации КАК ВариантКомплектации,
	               |	АвтоработыНормыВремени.ВремяВыполнения КАК ВремяВыполненияТЧ,
	               |	АвтоработыНормыВремени.Ссылка КАК Ссылка,
	               |	NULL КАК ВремяВыполнения
	               |ПОМЕСТИТЬ ВТ_Автоработы
	               |ИЗ
	               |	Справочник.Автоработы.НормыВремени КАК АвтоработыНормыВремени
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	NULL,
	               |	NULL,
	               |	NULL,
	               |	Автоработы.Ссылка,
	               |	Автоработы.ВремяВыполнения
	               |ИЗ
	               |	Справочник.Автоработы КАК Автоработы
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЦеныАвтоработСрезПоследних.ТипЦен КАК ТипЦен,
	               |	ЦеныАвтоработСрезПоследних.Авторабота КАК Авторабота,
	               |	ЦеныАвтоработСрезПоследних.Модель КАК Модель,
	               |	ЦеныАвтоработСрезПоследних.Контрагент КАК Контрагент,
	               |	ЦеныАвтоработСрезПоследних.ДоговорВзаиморасчетов КАК ДоговорВзаиморасчетов,
	               |	ЦеныАвтоработСрезПоследних.Цех КАК Цех,
	               |	ЦеныАвтоработСрезПоследних.ВидРемонта КАК ВидРемонта,
	               |	ЦеныАвтоработСрезПоследних.Нормочас КАК Нормочас,
	               |	ЦеныАвтоработСрезПоследних.Валюта КАК Валюта,
	               |	ЦеныАвтоработСрезПоследних.Цена КАК Цена
	               |ПОМЕСТИТЬ ВТ_Результат
	               |ИЗ
	               |	РегистрСведений.ЦеныАвторабот.СрезПоследних(&МоментВремени, ТипЦен В (&ТипЦен)) КАК ЦеныАвтоработСрезПоследних
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Автоработы КАК ВТ_Автоработы
	               |		ПО ЦеныАвтоработСрезПоследних.Авторабота = ВТ_Автоработы.Ссылка
	               |			И ЦеныАвтоработСрезПоследних.Модель = ВТ_Автоработы.Модель
	               |			И ЦеныАвтоработСрезПоследних.Модель = ВТ_Автоработы.Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_Результат.ТипЦен КАК ТипЦен,
	               |	ВТ_Результат.Авторабота КАК Авторабота,
	               |	ВТ_Результат.Модель КАК Модель,
	               |	ВТ_Результат.Контрагент КАК Контрагент,
	               |	ВТ_Результат.ДоговорВзаиморасчетов КАК ДоговорВзаиморасчетов,
	               |	ВТ_Результат.Цех КАК Цех,
	               |	ВТ_Результат.ВидРемонта КАК ВидРемонта,
	               |	ВТ_Результат.Нормочас КАК Нормочас,
	               |	ВТ_Результат.Валюта КАК Валюта,
	               |	ВТ_Результат.Цена КАК Цена,
	               |	МАКСИМУМ(ВЫБОР
	               |			КОГДА ВТ_Результат.Модель = ВТ_Автоработы.Модель
	               |					ИЛИ ВТ_Результат.Модель = ВТ_АвтоработыТЧ.Модель
	               |				ТОГДА ВТ_АвтоработыТЧ.ВремяВыполненияТЧ
	               |			ИНАЧЕ ВТ_Автоработы.ВремяВыполнения
	               |		КОНЕЦ) КАК ВремяВыполнения,
	               |	ВТ_АвтоработыТЧ.ВариантКомплектации КАК ВариантКомплектации
	               |ИЗ
	               |	ВТ_Результат КАК ВТ_Результат
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Автоработы КАК ВТ_Автоработы
	               |		ПО ВТ_Результат.Авторабота = ВТ_Автоработы.Ссылка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Автоработы КАК ВТ_АвтоработыТЧ
	               |		ПО ВТ_Результат.Авторабота = ВТ_АвтоработыТЧ.Ссылка
	               |			И ВТ_Результат.Модель = ВТ_АвтоработыТЧ.Модель
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВТ_Результат.ТипЦен,
	               |	ВТ_Результат.Авторабота,
	               |	ВТ_Результат.Модель,
	               |	ВТ_Результат.Контрагент,
	               |	ВТ_Результат.ДоговорВзаиморасчетов,
	               |	ВТ_Результат.Цех,
	               |	ВТ_Результат.ВидРемонта,
	               |	ВТ_Результат.Нормочас,
	               |	ВТ_Результат.Валюта,
	               |	ВТ_Результат.Цена,
	               |	ВТ_АвтоработыТЧ.ВариантКомплектации";
	// Устанавливаем дату указанную пользователем.
	Запрос.УстановитьПараметр("МоментВремени", ЭтотОбъект.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Период").Значение);
	// Если хоть один из типов цен выделен, то ставим параметром выделенные значения,
	// иначе если галочки все сняты, то ничего не выводим.
	Если МассивТиповЦен.Значение.Количество()<>0 Тогда
		Запрос.УстановитьПараметр("ТипЦен", МассивТиповЦен.Значение);
	Иначе
		Запрос.УстановитьПараметр("ТипЦен",  "НЕСУЩЕСТВУЮЩИЙПАРАМЕТР");
	КонецЕсли;
	// Выполняем запрос
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	// Вставляем.
	ВнешниеНаборыДанных.Вставить("ТаблицаПрайсЛиста",ВыборкаДетальныеЗаписи);
	// Выводим отчет.
	ОтчетыПлатформаСервер.ВывестиОтчет(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, ВнешниеНаборыДанных);
	// MIKOLV
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
