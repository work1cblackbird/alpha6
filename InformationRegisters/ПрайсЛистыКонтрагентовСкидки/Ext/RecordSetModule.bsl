﻿// Модуль набора записей регистра "Прайс-листы контрагентов скидки"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ДокументОбъект              Экспорт;  // документ объект для записи
Перем РезультатЗапросаПоСкидкам   Экспорт;	// РезультатЗапроса или ТаблицаЗначений. Устанавливается если документ имеет "необычную" ТЧ
Перем ДатаНачалаДействия          Экспорт;  // дата начала действия

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ОбработкаСобытийРегистраСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты) Тогда
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры 

// получаем таблицу прайс-листов и скидок на них
Функция ПолучитьТаблицуСкидок()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаСкидок.ПрайсЛист,
	|	ТаблицаСкидок.ТегПозиции,
	|	ТаблицаСкидок.Производитель,
	|	ТаблицаСкидок.Скидка
	|ПОМЕСТИТЬ втСкидкиДокумента
	|ИЗ
	|	&ТаблицаСкидок КАК ТаблицаСкидок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СкидкиДокумента.ПрайсЛист, Скидки.ПрайсЛист) КАК ПрайсЛист,
	|	ЕСТЬNULL(СкидкиДокумента.ТегПозиции, Скидки.ТегПозиции) КАК ТегПозиции,
	|	ЕСТЬNULL(СкидкиДокумента.Производитель, Скидки.Производитель) КАК Производитель,
	|	СкидкиДокумента.Скидка КАК Скидка,
	|	Скидки.Скидка КАК СкидкаВБазе
	|ИЗ
	|	втСкидкиДокумента КАК СкидкиДокумента
	|		ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			Рег.ПрайсЛист КАК ПрайсЛист,
	|			Рег.ТегПозиции КАК ТегПозиции,
	|			Рег.Производитель КАК Производитель,
	|			Рег.Скидка КАК Скидка,
	|			Рег.Отменена КАК Отменена
	|		ИЗ
	|			РегистрСведений.ПрайсЛистыКонтрагентовСкидки.СрезПоследних(
	|					&ДатаКон,
	|					ПрайсЛист В
	|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|							СкидкиДокумента.ПрайсЛист
	|						ИЗ
	|							втСкидкиДокумента КАК СкидкиДокумента)) КАК Рег
	|		ГДЕ
	|			НЕ Рег.Отменена) КАК Скидки
	|		ПО СкидкиДокумента.ПрайсЛист = Скидки.ПрайсЛист
	|			И СкидкиДокумента.ТегПозиции = Скидки.ТегПозиции
	|			И СкидкиДокумента.Производитель = Скидки.Производитель";
	
	Запрос.УстановитьПараметр("ТаблицаСкидок" , РезультатЗапросаПоСкидкам);
	Запрос.УстановитьПараметр("ДатаКон"       ,
		Новый Граница(Новый МоментВремени(ДатаНачалаДействия, ДокументОбъект.Ссылка), ВидГраницы.Исключая));
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции //ПолучитьТаблицуСкидок()

// Функция производит установку скидок.
Функция УстановитьСкидки() Экспорт
	
	// заполним незаполненные переменные.
	ДатаПереоценки = ?(ТипЗнч(ДатаНачалаДействия) = Тип("Дата"), ДатаНачалаДействия, ДокументОбъект.Дата);
	
	Если РезультатЗапросаПоСкидкам = Неопределено Тогда
		РезультатЗапросаПоСкидкам = ДокументОбъект.ПрайсЛисты.Выгрузить();
	Иначе
		Если ТипЗнч(РезультатЗапросаПоСкидкам) = Тип("РезультатЗапроса") Тогда
			РезультатЗапросаПоСкидкам = РезультатЗапросаПоСкидкам.Выгрузить();
		КонецЕсли;
	КонецЕсли;
	
	// Сформируем таблицу, содержащую как новые, так и старые скидки
	РезультатЗапросаПоСкидкам = ПолучитьТаблицуСкидок();
	
	// ускоряющие переменные
	СообщатьОбИзменении = ПраваИНастройкиПользователя.Значение("СообщатьОбИзмененииЦен");
	
	// Устанавливаем скидки
	Результат = Истина;
	
	Для Каждого СтрокаПрайса Из РезультатЗапросаПоСкидкам Цикл
		// если скидка не была установлена или изменилась тогда установим ее
		Если СтрокаПрайса.Скидка = NULL Тогда
			// Отменена
			НоваяЗапись = Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, СтрокаПрайса);
			НоваяЗапись.Скидка = СтрокаПрайса.СкидкаВБазе;
			НоваяЗапись.Отменена = Истина;
			НоваяЗапись.Период = ДатаПереоценки;
			НоваяЗапись.Регистратор = ДокументОбъект.Ссылка;
			// сообщим, если надо
			Если СообщатьОбИзменении Тогда
				ТекстТега = "";
				Если НЕ ПустаяСтрока(СтрокаПрайса.ТегПозиции) Тогда
					ТекстТега = СтрШаблон(" Тег <%1>;", СтрокаПрайса.ТегПозиции);
				КонецЕсли;
				
				ТекстПроизводителя = "";
				Если ЗначениеЗаполнено(СтрокаПрайса.Производитель) Тогда
					ТекстПроизводителя = СтрШаблон(" Производитель <%1>;", СтрокаПрайса.Производитель);
				КонецЕсли;
				
				ТекстСообщения = СтрШаблон(
					НСтр("ru = 'Прайс-лист <%1>;%2%3 Старая наценка: %4; Новая наценка: Отменена'"),
					СтрокаПрайса.ПрайсЛист,
					ТекстТега,
					ТекстПроизводителя,
					Формат(СтрокаПрайса.СкидкаВБазе, "ЧЦ=15; ЧДЦ=2; ЧН=0,00")
				);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ДокументОбъект);
			КонецЕсли;
		ИначеЕсли СтрокаПрайса.Скидка <> СтрокаПрайса.СкидкаВБазе Тогда
			НоваяЗапись = Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись,СтрокаПрайса);
			НоваяЗапись.Период = ДатаПереоценки;
			НоваяЗапись.Регистратор = ДокументОбъект.Ссылка;
			// сообщим, если надо
			Если СообщатьОбИзменении Тогда
				ТекстТега = "";
				Если НЕ ПустаяСтрока(СтрокаПрайса.ТегПозиции) Тогда
					ТекстТега = СтрШаблон(" Тег <%1>;", СтрокаПрайса.ТегПозиции);
				КонецЕсли;
				
				ТекстПроизводителя = "";
				Если ЗначениеЗаполнено(СтрокаПрайса.Производитель) Тогда
					ТекстПроизводителя = СтрШаблон(" Производитель <%1>;", СтрокаПрайса.Производитель);
				КонецЕсли;
				
				ТекстСообщения = СтрШаблон(
					НСтр("ru = 'Прайс-лист <%1>;%2%3 Старая наценка: %4; Новая наценка: %5'"),
					СтрокаПрайса.ПрайсЛист,
					ТекстТега,
					ТекстПроизводителя,
					Формат(СтрокаПрайса.СкидкаВБазе, "ЧЦ=15; ЧДЦ=2; ЧН=0,00"),
					Формат(СтрокаПрайса.Скидка,"ЧЦ=15; ЧДЦ=2; ЧН=0,00")
				);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ДокументОбъект);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// скинем некоторые переменные
	РезультатЗапросаПоСкидкам  = Неопределено;
	ДатаНачалаДействия         = Неопределено;
	
	// убиваем циклическую ссылку
	ДокументОбъект = Неопределено;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#КонецЕсли