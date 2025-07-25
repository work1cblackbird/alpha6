﻿// Модуль менеджера отчета "ДоступностьРесурсовАвтосервиса"

#Область ПрограммныйИнтерфейс

// Процедура - Установить видимость элементов отбора
//
// Параметры:
//  КлючВарианта	 - Строка			 - Текущий вариант настроек
//  Адрес			 - Строка			 - адрес СКД во временном хранилище.
//  ВидыРесурсов	 - Массив из Строка	 - массив видов ресурсов.
//
Процедура УстановитьОграничениеПолей(КлючВарианта, Адрес, ВидыРесурсов) Экспорт
	
	СКД = ПолучитьИзВременногоХранилища(Адрес);

	// Получим поля скд
	Для каждого ВидРесурса Из ВидыРесурсов Цикл
		
		Поле = СКД.НаборыДанных.Найти("Ресурсы").Поля.Найти(ВидРесурса);
		
		// Определим значение использования
		Использование = ?(КлючВарианта = ВидРесурса, Ложь, Истина);
		Если Поле <> Неопределено Тогда
			
			ПолеИспользования 	= Поле.ОграничениеИспользования;
			ПолеИспользования.Условие 		= Использование;
			ПолеИспользования.Группировка 	= Использование;
			ПолеИспользования.Поле 			= Использование;
			ПолеИспользования.Порядок 		= Использование;
			
			ПолеИспользования 	= Поле.ОграничениеИспользованияРеквизитов;
			ПолеИспользования.Условие 		= Использование;
			ПолеИспользования.Группировка	= Использование;
			ПолеИспользования.Поле 			= Использование;
			ПолеИспользования.Порядок		= Использование;
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(СКД,Адрес);

КонецПроцедуры


#КонецОбласти