﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Значение = Ложь Тогда
		Константы.ИспользоватьПризнакРассмотрено.Установить(Ложь);
		Константы.ИспользоватьПочтовыйКлиент.Установить(Ложь);
		Константы.ИспользоватьПрочиеВзаимодействия.Установить(Ложь);
		Константы.ОтправлятьПисьмаВФорматеHTML.Установить(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли