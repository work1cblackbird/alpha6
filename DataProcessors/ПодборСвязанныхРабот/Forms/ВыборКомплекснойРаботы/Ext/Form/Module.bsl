﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СвязанныеРаботы.Авторабота КАК КомплекснаяРабота,
	|	СвязанныеРаботы.Авторабота.Артикул КАК Артикул,
	|	ВЫБОР
	|		КОГДА СвязанныеРаботы.Авторабота ССЫЛКА Справочник.Автоработы
	|			ТОГДА 3
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Картинка
	|ИЗ
	|	РегистрСведений.СвязанныеРаботы КАК СвязанныеРаботы
	|
	|СГРУППИРОВАТЬ ПО
	|	СвязанныеРаботы.Авторабота,
	|	СвязанныеРаботы.Авторабота.Артикул");
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(КомплексныеРаботы.Добавить(), Выборка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьПометки(Команда)
	
	ОбщегоНазначенияАвтосалонКлиентСервер.УстановитьЗначениеКолонкиПометки(Истина, КомплексныеРаботы, "Выбрать");
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)
	
	ОбщегоНазначенияАвтосалонКлиентСервер.УстановитьЗначениеКолонкиПометки(Ложь, КомплексныеРаботы, "Выбрать");
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбранныеРаботы = Новый Массив;
	
	Для Каждого Строка Из КомплексныеРаботы Цикл
		
		Если Строка.Выбрать Тогда
			
			ВыбранныеРаботы.Добавить(Строка.КомплекснаяРабота);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Закрыть(ВыбранныеРаботы);
	
КонецПроцедуры

#КонецОбласти