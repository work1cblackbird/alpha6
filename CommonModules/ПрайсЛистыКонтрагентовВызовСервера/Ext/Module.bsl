﻿
#Область ПрограммныйИнтерфейс

// Функция - Получить файл в ожидании
//
// Параметры:
//  ПрайсЛист	 - СправочникСсылка.ПрайсЛистыКонтрагентов	 - Прайс-лист для получения файла в ожидпнии.
// 
// Возвращаемое значение:
//  Строка - Путь.
//
Функция ПолучитьФайлВОжидании(ПрайсЛист) Экспорт
	
	НастройкиОбновления = РегистрыСведений
		.ПрайсЛистыКонтрагентовАвтообновление
		.ПрочитатьНастройкиАвтообновления(ПрайсЛист);
	Справочники.ПрайсЛистыКонтрагентов.ПроверитьНаличиеНовыхФайловВКаталоге(ПрайсЛист, НастройкиОбновления);
	
	Состояние = РегистрыСведений.ПрайсЛистыКонтрагентовЖурналЗагрузки.ТекущиеСостояниеПрайсЛистаВсеПоля(ПрайсЛист);
	
	Если Состояние.Статус = Перечисления.СтатусыЗагрузкиПрайсЛистов.НовыйФайл
		И ЗначениеЗаполнено(Состояние.СтрокаПодключения) Тогда
		Возврат Состояние.СтрокаПодключения;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Производители артикула - Составляет перечень производителей для которых исползуется данный артикул.
//
// Параметры:
//  Артикул	 - Строка	 - Артикул для заполнения.
// 
// Возвращаемое значение:
//  Строка - Артикул.
//
Функция ПроизводителиАртикула(Артикул) Экспорт
	
	Возврат ПрайсЛистыКонтрагентов.ПроизводителиАртикула(Артикул);
	
КонецФункции

// Функция - Объединить группы аналогов
//
// Параметры:
//  ГлавнаяГруппа        - Строка - Идентификатор главной группы
//  ПрисоединяемаяГруппа - Строка - Идентификатор присоединяемой группы.
// 
// Возвращаемое значение:
//  Структура - Результат обработки.
//
Функция ОбъединитьГруппыАналогов(ГлавнаяГруппа, ПрисоединяемаяГруппа) Экспорт
	
	Возврат РегистрыСведений.ГруппыАналогов.ОбъединитьГруппы(ГлавнаяГруппа, ПрисоединяемаяГруппа);
	
КонецФункции

// Функция - Очистить правила по улючу для прайс листа
//
// Параметры:
//  ПрайсЛист	 - СправочникСсылка.ПрайсЛистыКонтрагентов	 - Прайс-лист.
// 
// Возвращаемое значение:
//  Булево - Результат.
//
Функция ОчиститьПравилаПоУлючуДляПрайсЛиста(ПрайсЛист) Экспорт
	
	Возврат РегистрыСведений.ПрайсЛистыКонтрагентовПравилаЗагрузки.ОчиститьПравилаПрайсЛиста(
		ПрайсЛист, Перечисления.НазначениеПравилЗагрузки.КлючСтроки);
	
КонецФункции

// Изменить ключ правил загрузки
//
// Параметры:
//  ПрайсЛист        - СправочникСсылка.ПрайсЛистыКонтрагентов - Прайс-лист
//  НовыйНаборКлючей - Массив из Строка - Массив строк с описание ключевых полей.
// 
// Возвращаемое значение:
//  Булево - Истина - операция выполнена успешно, Ложь - произошли ошибки.
//
Функция ИзменитьКлючПравилЗагрузки(ПрайсЛист, НовыйНаборКлючей) Экспорт
	
	Возврат РегистрыСведений.ПрайсЛистыКонтрагентовПравилаЗагрузки.ИзменитьКлючПравилЗагрузки(ПрайсЛист, НовыйНаборКлючей);
	
КонецФункции

// Возвращает доступные теги прайс-листа
//
// Параметры:
//  ПрайсЛист - СправочникСсылка.ПрайсЛист - Прайс-лист для коготорого будут получены теги
//
// Возвращаемое значение:
//  Массив - Список тегов прайс-листа.
//
Функция ТегиПрайсЛиста(ПрайсЛист) Экспорт
	
	Возврат РегистрыСведений.ПрайсЛистыКонтрагентов.ТегиПрайсЛиста(ПрайсЛист);
	
КонецФункции

// Функция возвращает HTML текст содержания по переданным параметрам.
//
// Параметры:
//	Артикул			- СправочникСсылка.Номенклатура, Строка		- Номенклатура или артикул для которого формируется поле Базовый каталог.
//	Производитель	- СправочникСсылка.Производители	- Производитель, если не указана номенклатура.
//	КнопкаСоздать	- Булево	- Признак добавления кнопки создания номенклатуры по базовому каталогу.
//	КнопкаОбновить	- Булево	- Признак добавления кнопки обновления данных номенклатуры по базовому каталогу.
//
// Возвращаемое значение:
//	Строка	- HTML текст содержания. 
//
Функция СформироватьПредставлениеИзБазовогоКаталога(Артикул, Производитель = Неопределено, КнопкаСоздать = Неопределено, КнопкаОбновить = Истина) Экспорт
	
	Возврат ПрайсЛистыКонтрагентов.СформироватьПредставлениеИзБазовогоКаталога(Артикул, Производитель, КнопкаСоздать, КнопкаОбновить);
	
КонецФункции // СформироватьПредставлениеИзБазовогоКаталога()

#Область ДлительныеОперацииСервис

// Считывает информацию о ходе выполнения фонового задания.
//
// Параметры:
//   ИдентификаторДлительнойОперации - УникальныйИдентификатор - идентификатор фонового задания.
//
// Возвращаемое значение:
//   Неопределено, Структура - информация о ходе выполнения фонового задания, записанная процедурой СообщитьПрогресс:
//    * Процент                 - Число  - Необязательный. Процент выполнения.
//    * Текст                   - Строка - Необязательный. Информация о текущей операции.
//    * ДополнительныеПараметры - Произвольный - Необязательный. Любая дополнительная информация.
//
Функция ПроверитьСообщения(ИдентификаторДлительнойОперации) Экспорт
	
	Возврат ДлительныеОперации.ПрочитатьПрогресс(ИдентификаторДлительнойОперации);
	
КонецФункции

// Проверяет состояние фонового задания по переданному идентификатору.
// При аварийном завершении задания вызывает исключение.
//
// Параметры:
//  Идентификатор - УникальныйИдентификатор - идентификатор фонового задания.
//
// Возвращаемое значение:
//  Булево - состояние выполнения задания.
// 
Функция ЗаданиеВыполнено(Идентификатор) Экспорт
	
	Возврат ПрайсЛистыКонтрагентов.ЗаданиеВыполнено(Идентификатор);
	
КонецФункции

// Отменяет выполнение фонового задания по переданному идентификатору.
// 
// Параметры:
//  ИдентификаторДлительнойОперации - УникальныйИдентификатор - идентификатор фонового задания.
// 
Процедура ОтменитьВыполнениеЗадания(ИдентификаторДлительнойОперации) Экспорт
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторДлительнойОперации);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти