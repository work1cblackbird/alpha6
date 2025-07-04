﻿#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СбросНастроек(Команда)
	СбросНастроекНаСервере();
	ПоказатьОповещениеПользователя(НСтр("ru = 'Проверка контрагентов'"),,НСтр("ru = 'Настройки проверки контрагентов сброшены'"));
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиПроверкиКонтрагентовНажатие(Элемент)
	ОткрытьФорму("ОбщаяФорма.НастройкиПроверкиКонтрагентов");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СбросНастроекНаСервере()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПроверкаКонтрагентов", 
		"ПроверкаКонтрагентов_ДатаПоследнегоОтображенияПредложенияНаВключениеСервиса", Неопределено);
		
	УстановитьПривилегированныйРежим(Истина);
	
	ЭтоМодельСервисаВнутриОбласти = ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
		
	НеМодельСервиса = НЕ ОбщегоНазначения.РазделениеВключено();
	
	ПроверкаКонтрагентов.УдалитьРезультатПроверкиКонтрагентов();
	
	// Очистка регистров.
	Если ЭтоМодельСервисаВнутриОбласти ИЛИ НеМодельСервиса Тогда
		
		// Ветка для разделенной области в модели сервиса
		// или для версии в "коробке".
		ПроверкаКонтрагентов.УдалитьРезультатПроверкиКонтрагентовПоДокументам();
		
		Если ОбщегоНазначения.РазделениеВключено() Тогда
			
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = '1. Очищены состояния контрагентов в данной области.
				|2. Очищены состояния документов.
				|3. Проверка не отключена. Для отключения Запустите сброс настроек повторно из неразделенной области.'"));
				
		Иначе
			ВыключитьПроверку();
		КонецЕсли;
		
	Иначе
		
		// Ветка для модели сервиса, неразделенной области.
		ВыключитьПроверку();
		
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = '1. Очищены состояния контрагентов.
				|2. Проверка отключена.
				|3. Состояния документов не очищены. Данные по документам необходимо очищать из области данных.
				|Запустите сброс настроек повторно из нужной области данных.'"));
		
	КонецЕсли;
		
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВыключитьПроверку()

	Константы.ИспользоватьПроверкуКонтрагентов.Установить(0);
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти
