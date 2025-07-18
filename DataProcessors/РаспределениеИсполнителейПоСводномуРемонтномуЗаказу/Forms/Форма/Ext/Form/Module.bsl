﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.СводныйРемонтныйЗаказ.Доступность = НЕ ПолучитьЗначениеПараметраСтруктуры(Параметры, "ЗаблокироватьСводныйРемонтныйЗаказ", Ложь);
	Объект.СводныйРемонтныйЗаказ = ПолучитьЗначениеПараметраСтруктуры(Параметры, "СводныйРемонтныйЗаказ", Неопределено);
	Объект.ЦехПоУмолчанию = ПравоПользователя(ПланыВидовХарактеристик.ПраваИНастройки.ОсновнойЦех);
	
	ЗаполнитьВспомогательныеТаблицы();
	СформироватьУсловноеОформление();
	
	Объект.АвтоматическоеРаспределениеПроцентаУчастия = Истина;
	
	Если Объект.ПодразделениеКомпании.Пустая() Тогда
		Объект.ПодразделениеКомпании = Пользователи.ТекущийПользователь().ПодразделениеКомпании;
	КонецЕсли;
	
	// Установим параметры начисления сотрудников и вывод параметров пользователю
	УровеньДоступаКНачислениямСотрудникамВЗаказНарядах =
			ПравоПользователя("УровеньДоступаКНачислениямСотрудникамВЗаказНарядах");
	ОтображатьСотрудникамНачисления = Автосервис.ДоступноНачислениеСотрудникам();
	
	Если УровеньДоступаКНачислениямСотрудникамВЗаказНарядах =
		Перечисления.УровеньДоступаКНачислениямСотрудникамВЗаказНарядах.Запрещено
		ИЛИ НЕ ОтображатьСотрудникамНачисления Тогда
		Элементы.ТекущиеИсполнителиВидНачисления.Видимость = Ложь;
		Элементы.ТекущиеИсполнителиСпособРасчета.Видимость = Ложь;
		Элементы.ТекущиеИсполнителиПараметрРасчетаНачисления.Видимость = Ложь;
		Элементы.ТекущиеИсполнителиНачислено.Видимость = Ложь;
		Элементы.ПодобранныеИсполнителиВидНачисления.Видимость = Ложь;
		Элементы.ПодобранныеИсполнителиСпособРасчета.Видимость = Ложь;
		Элементы.ПодобранныеИсполнителиПараметрРасчетаНачисления.Видимость = Ложь;
	Иначе
		ДоступноРедактирование = (УровеньДоступаКНачислениямСотрудникамВЗаказНарядах =
				Перечисления.УровеньДоступаКНачислениямСотрудникамВЗаказНарядах.Редактирование);
		Элементы.ПодобранныеИсполнителиВидНачисления.Доступность = ДоступноРедактирование;
		Элементы.ПодобранныеИсполнителиПараметрРасчетаНачисления.Доступность = ДоступноРедактирование;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.СводныйРемонтныйЗаказ) Тогда
		Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СводныйРемонтныйЗаказ, "Организация");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьДеревоАвторабот();
	ПодразделениеКомпанииПриИзменении(Неопределено);
	
	ОбновитьПометкиКоманд();
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура СводныйРемонтныйЗаказПриИзмененииНаСервере()
	
	ЗаполнитьВспомогательныеТаблицы();
	
	Если ЗначениеЗаполнено(Объект.СводныйРемонтныйЗаказ) Тогда
		Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СводныйРемонтныйЗаказ, "Организация");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СводныйРемонтныйЗаказПриИзменении(Элемент)
	
	СводныйРемонтныйЗаказПриИзмененииНаСервере();
	ЗаполнитьДеревоАвторабот();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоАвтоработПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоАвторабот.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И НЕ ТекущиеДанные.ЭтоГруппа Тогда
		ОтборСтрок = Новый ФиксированнаяСтруктура("ЗаказНаряд,ИдентификаторАвтоработы", ТекущиеДанные.ЗаказНаряд, ТекущиеДанные.ИдентификаторАвтоработы);
	ИначеЕсли ТекущиеДанные <> Неопределено И ТекущиеДанные.ЭтоГруппа Тогда
		ОтборСтрок = Новый ФиксированнаяСтруктура("ЗаказНаряд,ИдентификаторПричиныОбращения", ТекущиеДанные.ЗаказНаряд, ТекущиеДанные.ИдентификаторПричиныОбращения);
	Иначе
		ОтборСтрок = Новый ФиксированнаяСтруктура("ИдентификаторАвтоработы", " ");
	КонецЕсли;
	
	Элементы.ТекущиеИсполнители.ОтборСтрок = ОтборСтрок;
	
	ОбновитьПредставлениеИсполнителей(?(ТекущиеДанные <> Неопределено, ТекущиеДанные.ЭтоГруппа, Ложь));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИсполнителиСправочникВыборНаСервереБезКонтекста(ВыбраннаяСтрока)
	
	Возврат НЕ ВыбраннаяСтрока.ЭтоГруппа;
	
КонецФункции

&НаКлиенте
Процедура ИсполнителиСправочникВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Если ИсполнителиСправочникВыборНаСервереБезКонтекста(ВыбраннаяСтрока) Тогда
			
			СтандартнаяОбработка = Ложь;
			
			Если Объект.ПодобранныеИсполнители.НайтиСтроки(Новый Структура("Исполнитель", ВыбраннаяСтрока)).Количество() = 0 Тогда
				
				НоваяСтрока = Объект.ПодобранныеИсполнители.Добавить();
				НоваяСтрока.Исполнитель = ВыбраннаяСтрока;
				НоваяСтрока.Цех         = Объект.ЦехПоУмолчанию;
				РасчетПроцентаУчастия();
				
				Если НЕ ОтображатьСотрудникамНачисления Тогда
					Возврат;
				КонецЕсли;
				СписокСотрудников = Новый Массив;
				СписокСотрудников.Добавить(ВыбраннаяСтрока);
				НайстройкиНачислений = НастройкиНачисленияСотрудников(СписокСотрудников, Организация);
				НастройкаСотрудника = НайстройкиНачислений.Получить(ВыбраннаяСтрока);
				Если НастройкаСотрудника <> Неопределено Тогда
					ЗаполнитьЗначенияСвойств(НоваяСтрока, НастройкаСотрудника);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобранныеИсполнителиПроцентУчастияПриИзменении(Элемент)
	
	РасчетПроцентаУчастия(Объект.ПодобранныеИсполнители.НайтиПоИдентификатору(Элементы.ПодобранныеИсполнители.ТекущаяСтрока));
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеКомпанииПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ИсполнителиСправочник,
																			"ПодразделениеКомпании",
																			Объект.ПодразделениеКомпании,
																			ВидСравненияКомпоновкиДанных.ВИерархии,,
																			НЕ Объект.ПодразделениеКомпании.Пустая());
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобранныеИсполнителиПослеУдаления(Элемент)
	
	РасчетПроцентаУчастия();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодобранныеИсполнители

&НаКлиенте
Процедура ПодобранныеИсполнителиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	ПеретаскиваемыеСотрудники = ПараметрыПеретаскивания.Значение;
	
	Если ОтображатьСотрудникамНачисления Тогда
		НайстройкиНачислений = НастройкиНачисленияСотрудников(ПеретаскиваемыеСотрудники, Организация);
	Иначе
		НайстройкиНачислений = Новый Соответствие;
	КонецЕсли;
	
	Для Каждого Сотрудник Из ПеретаскиваемыеСотрудники Цикл
		НоваяСтрока = Объект.ПодобранныеИсполнители.Добавить();
		НоваяСтрока.Исполнитель = Сотрудник;
		НоваяСтрока.Цех         = Объект.ЦехПоУмолчанию;
		НастройкаСотрудника = НайстройкиНачислений.Получить(Сотрудник);
		Если НастройкаСотрудника <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(НоваяСтрока, НастройкаСотрудника);
		КонецЕсли;
	КонецЦикла;
	
	РасчетПроцентаУчастия();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобранныеИсполнителиПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	ПеретаскиваемыеСотрудники = ПараметрыПеретаскивания.Значение;
	
	Для Каждого Сотрудник Из ПеретаскиваемыеСотрудники Цикл
		Если Объект.ПодобранныеИсполнители.НайтиСтроки(Новый Структура("Исполнитель", Сотрудник)).Количество() > 0 Тогда
			ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПодобранныеИсполнителиВидНачисленияПриИзмененииНаСервере()
	
	ТекущиеДанные = Объект.ПодобранныеИсполнители.НайтиПоИдентификатору(Элементы.ПодобранныеИсполнители.ТекущаяСтрока);
	ТекущиеДанные.СпособРасчета = ТекущиеДанные.ВидНачисления.СпособРасчета;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобранныеИсполнителиВидНачисленияПриИзменении(Элемент)
	
	ПодобранныеИсполнителиВидНачисленияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПодобранныеИсполнителиИсполнительПриИзмененииНаСервере()
	
	ТекущиеДанные = Объект.ПодобранныеИсполнители.НайтиПоИдентификатору(Элементы.ПодобранныеИсполнители.ТекущаяСтрока);
	
	Если НЕ ОтображатьСотрудникамНачисления Тогда
		Возврат;
	КонецЕсли;
	СписокСотрудников = Новый Массив;
	СписокСотрудников.Добавить(ТекущиеДанные.Исполнитель);
	НайстройкиНачислений = НастройкиНачисленияСотрудников(СписокСотрудников, Организация);
	НастройкаСотрудника = НайстройкиНачислений.Получить(ТекущиеДанные.Исполнитель);
	Если НастройкаСотрудника <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, НастройкаСотрудника);
	Иначе
		ТекущиеДанные.ВидНачисления = Неопределено;
		ТекущиеДанные.СпособРасчета = Неопределено;
		ТекущиеДанные.ПараметрРасчетаНачисления = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобранныеИсполнителиИсполнительПриИзменении(Элемент)
	
	ПодобранныеИсполнителиИсполнительПриИзмененииНаСервере();
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	Отказ = Ложь;
	
	// выполним проверки
	Если Объект.ПодобранныеИсполнители.Итог("ПроцентУчастия") <> 100 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не верно распределено участие исполнителей.'"),
			,
			"ПодобранныеИсполнители",
			,
			Отказ
		);
		Возврат;
	КонецЕсли;
	
	Для Каждого Исполнитель Из Объект.ПодобранныеИсполнители Цикл
		Если Исполнитель.ПроцентУчастия = 0 Тогда
			ПутьКТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
				"ПодобранныеИсполнители",
				Исполнитель.НомерСтроки,
				"ПроцентУчастия"
			);
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'Не указан процент участия для исполнителя <%1>'"), Исполнитель.Исполнитель),
				,
				ПутьКТабличнойЧасти,
				"Объект",
				Отказ
			);
		КонецЕсли;
	КонецЦикла;    
	
	СтрокаДерева = Элементы.ДеревоАвторабот.ТекущиеДанные;
	Если СтрокаДерева = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не выбрана строка в дереве.",, "ДеревоАвторабот",, Отказ);
		Возврат;
	КонецЕсли;
	
	ВыделенныеСтроки = Элементы.ДеревоАвторабот.ВыделенныеСтроки;
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл 
		
		СтрокаДерева = ДеревоАвторабот.НайтиПоИдентификатору(Строка);		
		Если НЕ ЗаказНарядДоступенДляРедактирования(СтрокаДерева.ЗаказНаряд, СтрокаДерева.СостояниеЗаказНаряда) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				СтрШаблон(Нстр("ru = 'Заказ-наряд <%1> не доступен для редактирования.'"), СтрокаДерева.ЗаказНаряд),
				,
				"ДеревоАвторабот",,
				Отказ
			);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Отказ Тогда Возврат; КонецЕсли;
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		
		СтрокаДерева = ДеревоАвторабот.НайтиПоИдентификатору(Строка);
		ЭтоГруппа = СтрокаДерева.ЭтоГруппа;
		ЗаказНаряд = СтрокаДерева.ЗаказНаряд;
		ПричинаОбращения = СтрокаДерева.ИдентификаторПричиныОбращения;

		Если Объект.ОдинаковыеИсполнителиДляАвторабот Тогда
						
			НайденныеСтроки = Объект.Автоработы.НайтиСтроки(Новый Структура("ЗаказНаряд", ЗаказНаряд));
			
			Для Каждого ЭлементСтроки Из НайденныеСтроки Цикл 
				
				НайденныеСтроки = АвтоработыДляПрименения.НайтиСтроки(
					Новый Структура(
						"ИдентификаторАвтоработы, ЗаказНаряд",
						ЭлементСтроки.ИдентификаторАвтоработы, ЭлементСтроки.ЗаказНаряд)
				); 
				
				Если НайденныеСтроки.Количество() = 0 Тогда 
					СтрокаАвтоработы =АвтоработыДляПрименения.Добавить();
					СтрокаАвтоработы.ИдентификаторАвтоработы = ЭлементСтроки.ИдентификаторАвтоработы;
					СтрокаАвтоработы.ЭтоГруппа = ЭтоГруппа;
					СтрокаАвтоработы.ЗаказНаряд = ЗаказНаряд;
					СтрокаАвтоработы.ПричинаОбращения = ПричинаОбращения;
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли ЭтоГруппа Тогда
			
			ЭлементыСтроки = СтрокаДерева.ПолучитьЭлементы();
				
			Для Каждого ЭлементСтроки Из ЭлементыСтроки Цикл 
				
				НайденныеСтроки = АвтоработыДляПрименения.НайтиСтроки(
					Новый Структура(
						"ИдентификаторАвтоработы, ЗаказНаряд",
						ЭлементСтроки.ИдентификаторАвтоработы, ЭлементСтроки.ЗаказНаряд)
				); 

				Если НайденныеСтроки.Количество() = 0 Тогда
					СтрокаАвтоработы = АвтоработыДляПрименения.Добавить();
					СтрокаАвтоработы.ИдентификаторАвтоработы = ЭлементСтроки.ИдентификаторАвтоработы;
					СтрокаАвтоработы.ЭтоГруппа = ЭтоГруппа;
					СтрокаАвтоработы.ЗаказНаряд = ЗаказНаряд;
					СтрокаАвтоработы.ПричинаОбращения = ПричинаОбращения;
				КонецЕсли; 
				
			КонецЦикла;
			
		Иначе
			
			СтрокаАвтоработы =АвтоработыДляПрименения.Добавить();
			СтрокаАвтоработы.ИдентификаторАвтоработы = СтрокаДерева.ИдентификаторАвтоработы;
			СтрокаАвтоработы.ЭтоГруппа = ЭтоГруппа;
			СтрокаАвтоработы.ЗаказНаряд = ЗаказНаряд;
			СтрокаАвтоработы.ПричинаОбращения = ПричинаОбращения;
			
		КонецЕсли;  
		
	КонецЦикла;	
	
		
	Для Каждого СтрокаАвтоработы ИЗ  АвтоработыДляПрименения Цикл
		
		// добавим заказ-наряд в модифицированные
		ДобавитьМодифицированныйЗаказНаряд(СтрокаАвтоработы.ЗаказНаряд);
		
		СтрокиДляУдаления = Объект.ТекущиеИсполнители.НайтиСтроки(
			Новый Структура(
				"ЗаказНаряд,ИдентификаторАвтоработы",
				СтрокаАвтоработы.ЗаказНаряд,
				СтрокаАвтоработы.ИдентификаторАвтоработы)
		);
			
		Для Каждого УдаляемаяСтрока Из СтрокиДляУдаления Цикл
			Объект.ТекущиеИсполнители.Удалить(УдаляемаяСтрока);
		КонецЦикла;
			
		Для Каждого Исполнитель Из Объект.ПодобранныеИсполнители Цикл
			НоваяСтрока = Объект.ТекущиеИсполнители.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Исполнитель);
				
			НоваяСтрока.ЗаказНаряд                    = СтрокаАвтоработы.ЗаказНаряд;
			НоваяСтрока.ИдентификаторАвтоработы       = СтрокаАвтоработы.ИдентификаторАвтоработы;
			НоваяСтрока.ИдентификаторПричиныОбращения = СтрокаАвтоработы.ПричинаОбращения;
		КонецЦикла;
				
		ОбновитьПредставлениеИсполнителей(СтрокаАвтоработы.ЭтоГруппа);
			
	КонецЦикла;
	
КонецПроцедуры  

&НаКлиенте
Процедура ЗаполнитьПоТекущейСтроке(Команда)
	Попытка
		//ТекущаяСтрокаДерева = Элементы.ДеревоАвторабот.ТекущаяСтрока;
		//Если ТекущаяСтрокаДерева = Неопределено Тогда
		//	
		//КонецЕсли;
		
	Исключение
		ПоказатьПредупреждение(,КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
КонецПроцедуры

&НаСервере
Функция ЗаписатьИзмененияНаСервере()
	
	МодифицированныеЗаказНарядыОбъекты = Новый Массив;
	
	Для Каждого ИзмененныйЗаказНаряд Из Объект.МодифицированныеЗаказНаряды Цикл
		Попытка
			МодифицированныеЗаказНарядыОбъекты.Добавить(ИзмененныйЗаказНаряд.ЗаказНаряд.ПолучитьОбъект());
		Исключение
			ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат Ложь;
		КонецПопытки;
	КонецЦикла;
	
	Для Каждого ОбъектЗаказНаряд Из МодифицированныеЗаказНарядыОбъекты Цикл
		ОбъектЗаказНаряд.Исполнители.Очистить();
		ИсполнителиЗаказНаряда = Объект.ТекущиеИсполнители.НайтиСтроки(Новый Структура("ЗаказНаряд", ОбъектЗаказНаряд.Ссылка));
		
		Для Каждого Исполнитель Из ИсполнителиЗаказНаряда Цикл
			СтрокиАвтоработы = ОбъектЗаказНаряд.Автоработы.НайтиСтроки(Новый Структура("ИдентификаторРаботы", Исполнитель.ИдентификаторАвтоработы));
			Если СтрокиАвтоработы.Количество() > 0 Тогда
				НовыйИсполнитель = ОбъектЗаказНаряд.Исполнители.Добавить();
				
				НовыйИсполнитель.ИдентификаторРаботы = Исполнитель.ИдентификаторАвтоработы;
				НовыйИсполнитель.Исполнитель         = Исполнитель.Исполнитель;
				НовыйИсполнитель.Цех                 = Исполнитель.Цех;
				НовыйИсполнитель.Процент             = Исполнитель.ПроцентУчастия;
				
				Если НЕ ОтображатьСотрудникамНачисления Тогда
					Продолжить;
				КонецЕсли;
				
				ПараметрыРасчетаНачислений =
					Автосервис.ПараметрыРасчетаНачисленийАвтоработы(ОбъектЗаказНаряд, СтрокиАвтоработы[0]);
				НовыйИсполнитель.ВидНачисления = Исполнитель.ВидНачисления;
				НовыйИсполнитель.СпособРасчета = Исполнитель.СпособРасчета;
				НовыйИсполнитель.ПараметрРасчетаНачисления = Исполнитель.ПараметрРасчетаНачисления;
				
				// Сделаем пересчет коэффициента в валюте документа перед формированием суммы начислений
				Если НовыйИсполнитель.СпособРасчета <> ПредопределенноеЗначение("Перечисление.СпособыРасчета.Процентом") Тогда
					НовыйИсполнитель.ПараметрРасчетаНачисления =
						РаботаСКурсамиВалютПлатформа.ПересчетПоВалюте(
							НовыйИсполнитель.ПараметрРасчетаНачисления,
							ПараметрыРасчетаНачислений.ВалютаРегл,
							ПараметрыРасчетаНачислений.КурсРегл,
							ПараметрыРасчетаНачислений.ВалютаДокумента,
							ПараметрыРасчетаНачислений.КурсДокумента);
				КонецЕсли;
				
				АвтосервисКлиентСервер.РассчитатьСуммуНачисленияСотрудника(НовыйИсполнитель, ПараметрыРасчетаНачислений);
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	
	Попытка
		Для Каждого ОбъектЗаказНаряд Из МодифицированныеЗаказНарядыОбъекты Цикл
			ОбъектЗаказНаряд.ОбменДанными.Загрузка = Истина;
			ОбъектЗаказНаряд.Записать();
		КонецЦикла;
	Исключение
		ОтменитьТранзакцию();
		ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
	КонецПопытки;
	
	ЗафиксироватьТранзакцию();
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьИзменения(Команда)
	
	Если ЗаписатьИзмененияНаСервере() Тогда
		Если Объект.МодифицированныеЗаказНаряды.Количество() = 0 Тогда
			Закрыть(Ложь);
		Иначе
			Закрыть(Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическоеРаспределениеПроцентаУчастия(Команда)
	
	Объект[Команда.Имя] = НЕ Объект[Команда.Имя];
	ОбновитьПометкиКоманд();
	
	Если НЕ СтрНачинаетсяС(Команда.Имя, "ОдинаковыеИсполнителиДляАвторабот") И Объект[Команда.Имя] Тогда
		РасчетПроцентаУчастия();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗаказНарядДоступенДляРедактирования(ЗаказНаряд, Состояние = Неопределено)
	
	Если Состояние = Неопределено Тогда
		Состояние = ЗаказНаряд;
	КонецЕсли;
	
	Если Состояние = Справочники.ВидыСостоянийЗаказНарядов.Выполнен ИЛИ
		Состояние = Справочники.ВидыСостоянийЗаказНарядов.Закрыт ИЛИ
		РегистрыСведений.БлокировкаЗаказНарядов.ПроверкаБлокировкиИзменений(ЗаказНаряд).Количество() > 0 Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Функция ДобавитьМодифицированныйЗаказНаряд(ЗаказНаряд)
	
	Если Объект.МодифицированныеЗаказНаряды.НайтиСтроки(Новый Структура("ЗаказНаряд", ЗаказНаряд)).Количество() = 0 Тогда
		НоваяСтрока = Объект.МодифицированныеЗаказНаряды.Добавить();
		НоваяСтрока.ЗаказНаряд = ЗаказНаряд;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ОбновитьПометкиКоманд()
	
	Элементы.РавныйПроцентУчастияДляИсполнителей.Пометка        = Объект.РавныйПроцентУчастияДляИсполнителей;
	Элементы.АвтоматическоеРаспределениеПроцентаУчастия.Пометка = Объект.АвтоматическоеРаспределениеПроцентаУчастия;
	Элементы.ОдинаковыеИсполнителиДляАвторабот.Пометка          = Объект.ОдинаковыеИсполнителиДляАвторабот;
	
КонецФункции

// Формирование условного обозначения для форм списка справочников и документов
//
// Параметры:
//  Форма - УправляемаяФорма - ФормаСписка, в которой возникло событие
//  Отображает цвет строки соответствующего вида.
//
&НаСервере
Процедура СформироватьУсловноеОформление()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	Справочник.Ссылка,
	|	Справочник.Цвет КАК Цвет
	|ИЗ
	|	Справочник.ВидыСостоянийЗаказНарядов КАК Справочник";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ЭлементОформления = УсловноеОформление.Элементы.Добавить();
		
		// Создаем условие отбора
		ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоАвторабот.СостояниеЗаказНаряда");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
		
		// Значение для отбора
		ЭлементОтбора.ПравоеЗначение = Выборка.Ссылка;
		ЭлементОтбора.Использование = Истина;
		
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", Выборка.Цвет.Получить());
		ЭлементОформления.Использование = Истина;
		
		ПолеДляОформления = ЭлементОформления.Поля.Элементы.Добавить();
		ПолеДляОформления.Поле          = Новый ПолеКомпоновкиДанных("ДеревоАвторабот");
		ПолеДляОформления.Использование = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкиНачисленияСотрудников(Сотрудники, Организация)
	
	ПараметрыПоискаНастройки = Новый Структура;
	ПараметрыПоискаНастройки.Вставить("Сотрудники", Сотрудники);
	ПараметрыПоискаНастройки.Вставить("Организация", Организация);
	
	НастройкаНачислений = Автосервис.НастройкиНачисленияСотрудников(ПараметрыПоискаНастройки);
	
	Возврат НастройкаНачислений;
	
КонецФункции

#Область ЗаполнениеДанных

&НаСервере
Процедура ЗаполнитьВспомогательныеТаблицы()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СводныйРемонтныйЗаказ", Объект.СводныйРемонтныйЗаказ);
	
	Менеджер = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = Менеджер;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказНаряд.Ссылка КАК ЗаказНаряд
	|ПОМЕСТИТЬ ЗаказНаряды
	|ИЗ
	|	Документ.ЗаказНаряд КАК ЗаказНаряд
	|ГДЕ
	|	ЗаказНаряд.СводныйРемонтныйЗаказ = &СводныйРемонтныйЗаказ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказНарядПричиныОбращения.ИдентификаторПричиныОбращения,
	|	ЗаказНарядПричиныОбращения.ПричинаОбращения,
	|	ЗаказНарядПричиныОбращения.ПричинаОбращенияСодержание,
	|	ЗаказНарядПричиныОбращения.Ссылка
	|ПОМЕСТИТЬ ПричиныОбращения
	|ИЗ
	|	Документ.ЗаказНаряд.ПричиныОбращения КАК ЗаказНарядПричиныОбращения
	|ГДЕ
	|	ЗаказНарядПричиныОбращения.Ссылка В
	|			(ВЫБРАТЬ
	|				ЗаказНаряды.ЗаказНаряд
	|			ИЗ
	|				ЗаказНаряды КАК ЗаказНаряды)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказНаряды.ЗаказНаряд,
	|	ЕСТЬNULL(ПричиныОбращения.ПричинаОбращения, ЗНАЧЕНИЕ(Справочник.ПричиныОбращений.ПустаяСсылка)) КАК ПричинаОбращения,
	|	ЕСТЬNULL(ПричиныОбращения.ПричинаОбращенияСодержание, """") КАК ПричинаОбращенияПредставление,
	|	ЕСТЬNULL(ПричиныОбращения.ИдентификаторПричиныОбращения, """") КАК ИдентификаторПричиныОбращения,
	|	ЗаказНаряды.ЗаказНаряд.Состояние КАК СостояниеЗаказНаряда
	|ИЗ
	|	ЗаказНаряды КАК ЗаказНаряды
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПричиныОбращения КАК ПричиныОбращения
	|		ПО ЗаказНаряды.ЗаказНаряд = ПричиныОбращения.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказНарядАвтоработы.Авторабота,
	|	ЗаказНарядАвтоработы.ИдентификаторРаботы,
	|	ЗаказНарядАвтоработы.Коэффициент * ЗаказНарядАвтоработы.Количество КАК НормаВремени,
	|	ЗаказНарядАвтоработы.Ссылка КАК ЗаказНаряд
	|ПОМЕСТИТЬ Автоработы
	|ИЗ
	|	Документ.ЗаказНаряд.Автоработы КАК ЗаказНарядАвтоработы
	|ГДЕ
	|	ЗаказНарядАвтоработы.Ссылка В
	|			(ВЫБРАТЬ
	|				ЗаказНаряды.ЗаказНаряд
	|			ИЗ
	|				ЗаказНаряды КАК ЗаказНаряды)
	|	И ЗаказНарядАвтоработы.Контрагент=ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоставПричинОбращенийЗаказНарядов.ЗаказНаряд,
	|	СоставПричинОбращенийЗаказНарядов.ПричинаОбращения,
	|	СоставПричинОбращенийЗаказНарядов.Авторабота
	|ПОМЕСТИТЬ СоставПричинОбращений
	|ИЗ
	|	РегистрСведений.СоставПричинОбращенийЗаказНарядов КАК СоставПричинОбращенийЗаказНарядов
	|ГДЕ
	|	СоставПричинОбращенийЗаказНарядов.Использование = ИСТИНА
	|	И СоставПричинОбращенийЗаказНарядов.ЗаказНаряд В
	|			(ВЫБРАТЬ
	|				ЗаказНаряды.ЗаказНаряд
	|			ИЗ
	|				ЗаказНаряды КАК ЗаказНаряды)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Автоработы.Авторабота,
	|	Автоработы.ИдентификаторРаботы КАК ИдентификаторАвтоработы,
	|	Автоработы.НормаВремени,
	|	Автоработы.ЗаказНаряд,
	|	ЕСТЬNULL(СоставПричинОбращений.ПричинаОбращения, """") КАК ИдентификаторПричиныОбращения
	|ИЗ
	|	Автоработы КАК Автоработы
	|		ЛЕВОЕ СОЕДИНЕНИЕ СоставПричинОбращений КАК СоставПричинОбращений
	|		ПО Автоработы.ИдентификаторРаботы = СоставПричинОбращений.Авторабота
	|			И Автоработы.ЗаказНаряд = СоставПричинОбращений.ЗаказНаряд
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказНарядИсполнители.Исполнитель,
	|	ЗаказНарядИсполнители.Цех,
	|	ЗаказНарядИсполнители.Процент КАК ПроцентУчастия,
	|	ЗаказНарядИсполнители.ВидНачисления,
	|	ЗаказНарядИсполнители.ПараметрРасчетаНачисления,
	|	ЗаказНарядИсполнители.Начислено,
	|	ЗаказНарядИсполнители.СпособРасчета,
	|	ЗаказНарядИсполнители.ИдентификаторРаботы КАК ИдентификаторАвтоработы,
	|	ЗаказНарядИсполнители.Ссылка КАК ЗаказНаряд,
	|	ЕСТЬNULL(СоставПричинОбращений.ПричинаОбращения, """") КАК ИдентификаторПричиныОбращения
	|ИЗ
	|	Документ.ЗаказНаряд.Исполнители КАК ЗаказНарядИсполнители
	|		ЛЕВОЕ СОЕДИНЕНИЕ СоставПричинОбращений КАК СоставПричинОбращений
	|		ПО ЗаказНарядИсполнители.Ссылка = СоставПричинОбращений.ЗаказНаряд
	|			И ЗаказНарядИсполнители.ИдентификаторРаботы = СоставПричинОбращений.Авторабота
	|ГДЕ
	|	ЗаказНарядИсполнители.Ссылка В
	|			(ВЫБРАТЬ
	|				ЗаказНаряды.ЗаказНаряд
	|			ИЗ
	|				ЗаказНаряды КАК ЗаказНаряды)";
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Объект.ЗаказНарядыИПричиныОбращений.Загрузить(Результаты[2].Выгрузить());
	Объект.Автоработы.Загрузить(Результаты[5].Выгрузить());
	Объект.ТекущиеИсполнители.Загрузить(Результаты[6].Выгрузить());
	
	Для Каждого Строка Из Объект.ЗаказНарядыИПричиныОбращений Цикл
		
		Строка.Представление = СтрШаблон(
			"%1 [%2]",
			?(
				ЗначениеЗаполнено(Строка.ПричинаОбращенияПредставление),
				Строка.ПричинаОбращенияПредставление,
				НСтр("ru = 'Причина обращения не указана'")
			),
			Строка.ЗаказНаряд
		);
		
	КонецЦикла;
	
	Для Каждого Строка Из Объект.Автоработы Цикл
		
		Строка.Представление = СтрШаблон("%1 [%2]", Строка.Авторабота, Строка.Авторабота.Артикул);
		
	КонецЦикла;
	
	Менеджер.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДеревоАвторабот()
	
	ЭлементыДерева = ДеревоАвторабот.ПолучитьЭлементы();
	ЭлементыДерева.Очистить();
	
	Для Каждого ЗаказНаряд Из Объект.ЗаказНарядыИПричиныОбращений Цикл
		СтрокаРодитель = ЭлементыДерева.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаРодитель, ЗаказНаряд);
		СтрокаРодитель.ЭтоГруппа = Истина;
		
		СтрокиАвторабот = Объект.Автоработы.НайтиСтроки(Новый Структура("ИдентификаторПричиныОбращения,ЗаказНаряд", ЗаказНаряд.ИдентификаторПричиныОбращения, ЗаказНаряд.ЗаказНаряд));
		ЭлементыСтрокиРодителя = СтрокаРодитель.ПолучитьЭлементы();
		Для Каждого СтрокаАвтоработы Из СтрокиАвторабот Цикл
			Строка = ЭлементыСтрокиРодителя.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, СтрокаАвтоработы);
		КонецЦикла;
		
		Элементы.ДеревоАвторабот.Развернуть(СтрокаРодитель.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредставлениеИсполнителей(ВыводитьАвтоработы = Ложь)
	
	Для Каждого Исполнитель Из Объект.ТекущиеИсполнители Цикл
		Авторабота = Неопределено;
		
		Если ВыводитьАвтоработы Тогда
			Автоработы = Объект.Автоработы.НайтиСтроки(Новый Структура("ИдентификаторАвтоработы,ЗаказНаряд", Исполнитель.ИдентификаторАвтоработы, Исполнитель.ЗаказНаряд));
			Если Автоработы.Количество() > 0 Тогда
				Авторабота = Автоработы[0].Авторабота;
			КонецЕсли;
		КонецЕсли;
		
		Если Авторабота = Неопределено Тогда
			Представление = СтрШаблон("%1", Исполнитель.Исполнитель);
		Иначе
			Представление = СтрШаблон("[%2] %1", Исполнитель.Исполнитель, Авторабота);
		КонецЕсли;
		
		Исполнитель.Представление = Представление;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Расчет

&НаКлиенте
Процедура РасчетПроцентаУчастия(Строка = Неопределено)
	
	Если НЕ Объект.АвтоматическоеРаспределениеПроцентаУчастия ИЛИ Объект.ПодобранныеИсполнители.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ПодобранныеИсполнители.Количество() = 1 Тогда
		Объект.ПодобранныеИсполнители[0].ПроцентУчастия = 100;
		Возврат;
	КонецЕсли;
	
	Если Объект.РавныйПроцентУчастияДляИсполнителей ИЛИ Строка = Неопределено Тогда
		ПроцентНаСтроку = 100/Объект.ПодобранныеИсполнители.Количество();
		Для Каждого Исполнитель Из Объект.ПодобранныеИсполнители Цикл
			Исполнитель.ПроцентУчастия = ПроцентНаСтроку;
		КонецЦикла;
		
		Исполнитель.ПроцентУчастия = Исполнитель.ПроцентУчастия + (100 - Объект.ПодобранныеИсполнители.Итог("ПроцентУчастия"));
	Иначе
		ПроцентОстальныхИсполнителей = 100 - Строка.ПроцентУчастия;
		
		ПроцентНаСтроку = ПроцентОстальныхИсполнителей/(Объект.ПодобранныеИсполнители.Количество()-1);
		СтрокаРаспределения = Неопределено;
		Для Каждого Исполнитель Из Объект.ПодобранныеИсполнители Цикл
			Если Исполнитель = Строка Тогда Продолжить; КонецЕсли;
			
			СтрокаРаспределения = Исполнитель;
			Исполнитель.ПроцентУчастия = ПроцентНаСтроку;
		КонецЦикла;
		
		Если СтрокаРаспределения <> Неопределено Тогда
			СтрокаРаспределения.ПроцентУчастия = СтрокаРаспределения.ПроцентУчастия + (100 - Объект.ПодобранныеИсполнители.Итог("ПроцентУчастия"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

