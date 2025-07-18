﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено ИЛИ ПараметрКоманды.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = ПолучитьПараметрыПользователя();
	
	// фильтры
	ОтчетОтбор = Новый Структура;
	ОтчетОтбор.Вставить("Номенклатура",      ПараметрКоманды);
	ОтчетОтбор.Вставить("Организация",       ПараметрыОтбора.Организация);
	ОтчетОтбор.Вставить("НачалоПериода",     НачалоГода(ПараметрыОтбора.ДатаОтчета));
	ОтчетОтбор.Вставить("КонецПериода",      ПараметрыОтбора.ДатаОтчета);
	
	ОткрытьФорму("Отчет.СостояниеЗаказовПокупателей.Форма", Новый Структура("Отбор,КлючВарианта,СформироватьПриОткрытии", ОтчетОтбор, "ДляНоменклатуры", Истина), ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьПараметрыПользователя()
	
	Результат = Новый Структура;
	Результат.Вставить("Организация", ПараметрыСеанса.Организация);
	Результат.Вставить("ДатаОтчета",  ТекущаяДатаСеанса());
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти