﻿#Область ПрограммныйИнтерфейс

// Формирует данные номенклатуры для таблицы "ПодобранныеПозиции".
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - номенклатура, для которой формируются данные
//
// Возвращаемое значение:
//  Структура - структура с полями:
//   * ВладелецХарактеристики - СправочникСсылка.Номенклатура,
//								СправочникСсылка.ТипыНоменклатуры, НЕОПРЕДЕЛЕНО - владелец характеристики.
//
Функция ДанныеПодобраннойНоменклатуры(Номенклатура) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		
		Возврат Новый Структура("ВладелецХарактеристики");
		
	КонецЕсли;
	
	Возврат СостояниеОбеспеченияСервер.ДанныеПодобраннойНоменклатуры(Номенклатура);
	
КонецФункции // ДанныеПодобраннойНоменклатуры()

#КонецОбласти
