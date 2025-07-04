﻿// Модуль набора записей регистра накоплений "Бюджет закупок автомобилей"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ПодразделениеКомпании Экспорт; // Ссылка на подразделение компании
Перем ДокументОбъект Экспорт;        // Документ объект выполняющий движения
Перем РежимПроведения Экспорт;		 // Режим проведения документа оперативный/неоперативный

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Функция выполняет приход на регистр
Функция Приход() Экспорт
	
	// Получим документ, по которому будем делать записи в регистр
	Запрос = Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	БюджетЗакупокАвтомобилейАвтомобили.Ссылка.ПодразделениеКомпании,
	|	БюджетЗакупокАвтомобилейАвтомобили.Ссылка.СценарийПланирования,
	|	БюджетЗакупокАвтомобилейАвтомобили.Ссылка.ХозОперация,
	|	БюджетЗакупокАвтомобилейАвтомобили.Модель,
	|	БюджетЗакупокАвтомобилейАвтомобили.ВариантКомплектации,
	|	БюджетЗакупокАвтомобилейАвтомобили.Количество,
	|	БюджетЗакупокАвтомобилейАвтомобили.СуммаВсегоУпр КАК СуммаУпр,
	|	БюджетЗакупокАвтомобилейАвтомобили.СуммаВсегоУпр * &Коэффициент КАК СуммаРег,
	|	БюджетЗакупокАвтомобилейАвтомобили.СуммаНДС КАК СуммаНДС,
	|	БюджетЗакупокАвтомобилейАвтомобили.Ссылка.ДатаПланирования КАК Период
	|ИЗ
	|	Документ.БюджетЗакупокАвтомобилей.Автомобили КАК БюджетЗакупокАвтомобилейАвтомобили
	|ГДЕ
	|	БюджетЗакупокАвтомобилейАвтомобили.Ссылка = &Ссылка";
	
	// Найдем коэффициент пересчета из управленческой валюты в валюту регл.учета
	Коэффициент = РаботаСКурсамиВалютПлатформа.ПолучитьКоэффициентПересчетаВалют(ДокументОбъект.Дата);
	
	Запрос.УстановитьПараметр("Ссылка"      , ДокументОбъект);
	Запрос.УстановитьПараметр("Коэффициент" , Коэффициент);

	Загрузить(Запрос.Выполнить().Выгрузить());
		
	ДокументОбъект=Неопределено;
	
	Возврат Истина;
КонецФункции

#КонецОбласти

#КонецЕсли