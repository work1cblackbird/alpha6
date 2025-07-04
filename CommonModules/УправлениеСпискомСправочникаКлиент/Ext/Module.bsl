﻿// Общий модуль "Управление списком справочника (клиент)"

#Область ПрограммныйИнтерфейс

// Устарела. Будет удалена.
// Общий обработчик события возникающего на клиенте при открытии формы, до показа окна пользователю.
//
// Параметры:
//  Форма				- УправляемаяФорма	- Форма, в которой возникло событие.
//  Отказ				- Булево			- Признак отказа от создания формы.
//  ПрефиксКнопок		- Строка			- Начальное имя для кнопок
//  ИмяКоманднойПанели	- Строка			- Имя элемента Командная панель.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события.
//
Функция ПриОткрытии(Форма, Отказ=ЛОЖЬ, ПрефиксКнопок = "Форма", ИмяКоманднойПанели = "ФормаКоманднаяПанель") Экспорт
	
	ЗащищенныеФункцииКлиент.НастроитьКоманднуюПанельФормы(Форма,Истина, ПрефиксКнопок, ИмяКоманднойПанели);
	
	// Произведем настройку основного динамического списка формы
	ЗащищенныеФункцииКлиент.НастроитьОсновнойДинамическийСписокФормы(Форма);
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат (НЕ Отказ);
	
КонецФункции // ПриОткрытии()

// Устарела. Будет удалена.
// Общий обработчик события возникающего на клиенте перед закрытием формы.
//
// Параметры:
//  Форма                - УправляемаяФорма - Форма, в которой возникло событие.
//  Отказ                - Булево - Признак отказа от создания формы.
//  ЗавершениеРаботы     - Булево - Признак закрытия формы в процессе завершения работы приложения.
//  ТекстПредупреждения  - Булево - Сообщение пользователю не завершенной работе в данном окне.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события.
//
Функция ПередЗакрытием(Форма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка) Экспорт
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат (НЕ Отказ);
	
КонецФункции // ПередЗакрытием()

// Устарела. Будет удалена.
// Общий обработчик события возникающего на клиенте при закрытии формы.
//
// Параметры:
//  Форма            - УправляемаяФорма - Форма, в которой возникло событие.
//  ЗавершениеРаботы - Булево - Признак закрытия формы в процессе завершения работы приложения.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события.
//
Функция ПриЗакрытии(Форма, ЗавершениеРаботы=ЛОЖЬ) Экспорт
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат ИСТИНА;
	
КонецФункции // ПриЗакрытии()

// Устарела. Будет удалена
// Общий обработчик события возникающего на клиенте во всех формах при вызове метода Оповестить.
//
// Параметры:
//  Форма               - УправляемаяФорма - Форма, в которой возникло событие.
//  ИмяСобытия          - Строка           - Имя, идентифицирующее событие.
//  Параметр            - Произвольный     - Параметр сообщения.
//  Источник            - Произвольный     - Источник события.
//  ПараметрыДействия   - Структура        - Набор параметров, использующихся при выполнения операции.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события.
//
Функция ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ПараметрыДействия=Неопределено) Экспорт
	
	// Обработаем в зависимости от вида события
	Если Источник="ПодключаемоеОборудование" Тогда
		Если НЕ Форма.ВводДоступен() Тогда
			Возврат ЛОЖЬ;
			
		ИначеЕсли ИмяСобытия = "TracksData" Тогда
			ПараметрыДействия.Вставить("КодКарты", Параметр[0]);
			Возврат ИСТИНА;
			
		ИначеЕсли ИмяСобытия = "ScanData" Тогда
			
			ШтрихКод = ?((Параметр.Количество() > 1) И (Параметр[1] <> Неопределено), Параметр[1][1], Параметр[0]);
			
			// Удалим из кода маркировки криптохвосты
			ШтрихКод = МаркировкаТоваровКлиентСервер.ПолучитьКодМаркировки(ШтрихКод);
			
			ПараметрыДействия.Вставить("ШтрихКод", ШтрихКод);
			Возврат ИСТИНА;
			
		КонецЕсли;
	КонецЕсли;
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат ЛОЖЬ;
	
КонецФункции // ОбработкаОповещения()

// Устарела. Будет удалена.
// Общий обработчик события возникающего на клиенте при вызове метода ОповеститьОбАктивизации из формы-владельца.
//
// Параметры:
//  Форма          - УправляемаяФорма - Форма, в которой возникло событие.
//  АктивныйОбъект - Произвольный     - Активный объект.
//  Источник       - УправляемаяФорма - Форма, источник сообщения.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события.
//
Функция ОбработкаАктивизации(Форма, АктивныйОбъект, Источник) Экспорт
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат ИСТИНА;
	
КонецФункции // СписокОбработкаАктивизации()

// Устарела. Будет удалена.
// Общий обработчик события возникающего на клиенте при записи объекта в одной из подчиненных форм.
//
// Параметры:
//  Форма                - УправляемаяФорма - Форма, в которой возникло событие.
//  НовыйОбъект          - Произвольный     - Добавленный в подчиненной форме объект.
//  Источник             - УправляемаяФорма - Форма, источник сообщения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения системной обработки события.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события.
//
Функция ОбработкаЗаписиНового(Форма, НовыйОбъект, Источник, СтандартнаяОбработка=ИСТИНА) Экспорт
	
	// Позиционирование на новом объекте в форме списка
	Если ЗначениеЗаполнено(НовыйОбъект) Тогда
		Форма.Элементы.Список.ТекущаяСтрока = НовыйОбъект;
	КонецЕсли;
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат ИСТИНА;
	
КонецФункции // СписокОбработкаЗаписиНового()

// Устарела. Будет удалена.
// Общий обработчик события возникающего при выборе строки списка.
//
// Параметры:
//  Форма					- УправляемаяФорма				- Форма, в которой возникло событие.
//  Элемент					- ТаблицаФормы					- Элемент управления, в котором возникло данное событие.
//  ВыбраннаяСтрока			- ДанныеФормыЭлементКоллекции	- выбранная строка
//  Поле					- ПолеФормы						- Активное поле (колонка).
//  СтандартнаяОбработка	- Булево						- В данный параметр передается признак выполнения системной обработки события.
//
Процедура СписокВыбор(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка=ИСТИНА) Экспорт
	
	Зарезервировано = ИСТИНА;
	
КонецПроцедуры // СписокВыбор()

// Общий обработчик события возникающего при активизации строки списка.
//
// Параметры:
//  Форма      - УправляемаяФорма - Форма, в которой возникло событие.
//  Элемент    - ТаблицаФормы     - Элемент управления, в котором возникло данное событие.
//  ПоЗадержке - Булево           - Признак выполнения обработчика после окончания пользователем серфинга по списку.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события.
//
Функция СписокПриАктивизацииСтроки(Форма, Элемент, ПоЗадержке=ЛОЖЬ) Экспорт
	
	// По-умолчанию обработка на сервере не требуется
	ОбработатьНаСервере = ЛОЖЬ;
	
	// Обработаем в зависимости от режима вызова общего обработчика
	Если ПоЗадержке Тогда
		
		// Проверим наличие поля расширенной информации на форме
		Если НЕ Форма.Элементы.Найти("РасширеннаяИнформация")=Неопределено Тогда
			ОбработатьНаСервере = ИСТИНА;
		КонецЕсли;
		
		// Проверим наличие подменю печати
		Если НЕ Форма.Элементы.Найти("ПодменюПечать")=Неопределено И Форма.Элементы.ПодменюПечать.ПодчиненныеЭлементы.Количество() > 0 Тогда
			ОбработатьНаСервере = ИСТИНА;
		КонецЕсли;
		
	Иначе
		
		// Пропустим лишние события активизации строк списка
		Если Форма.ТекущийЭлементСписка=Элемент.ТекущаяСтрока Тогда
			Возврат ЛОЖЬ;
		Иначе
			Форма.ТекущийЭлементСписка = Элемент.ТекущаяСтрока;
		КонецЕсли;
		
		// Производим подключение обработчика события выполняемого с задержкой
		Форма.ПодключитьОбработчикОжидания("Подключаемый_СписокПриАктивизацииСтроки", 0.5, ИСТИНА);
		
	КонецЕсли;
	
	// Возвращаем признак возможности дальнейшей обработки события в контексте сервера
	Возврат ОбработатьНаСервере;
	
КонецФункции // СписокПриАктивизацииСтроки()

// Общий обработчик события возникающего при активизации строки списка.
//
// Параметры:
//  Форма   - УправляемаяФорма - Форма, в которой возникло событие.
//  Элемент - ТаблицаФормы     - Элемент управления, в котором возникло данное событие.
//
Процедура СписокПриАктивизацииЯчейки(Форма, Элемент) Экспорт
	
	// Произведем установку доступности пункта меню "Группировать по значению колонки"
	УправлениеДиалогомКлиент.ОбновитьДоступностьКомандГруппировкиСписка(Форма, Элемент.ТекущиеДанные, Элемент.ТекущийЭлемент);
	
	// Произведем установку доступности пункта меню "Поиск по текущему значению"
	УправлениеДиалогомКлиент.ОбновитьДоступностьКомандПоискаПоТекущемуЗначениюСписка(Форма, Элемент.ТекущиеДанные, Элемент.ТекущийЭлемент);
	
КонецПроцедуры // СписокПриАктивизацииЯчейки()

// Устарела. Переносим в форму списка. Будет удалена.
// Общий обработчик события возникающего  перед началом добавления строки в  список.
//
// Параметры:
//  Форма       - УправляемаяФорма - Форма, в которой возникло событие.
//  Элемент     - ТаблицаФормы     - Элемент управления, в котором возникло данное событие.
//  Отказ       - Булево           - Признак отказа от действия.
//  Копирование - Булево           - Определяет режим копирования.
//  Родитель    - Ссылка           - Ссылка на элемент, который будет использован при добавлении в качестве родителя.
//  Группа      - Булево           - Признак добавления группы.
//  Параметр    - Структура        - Набор параметров, использующихся при выполнения операции.
//
Процедура СписокПередНачаломДобавления(Форма,
		Элемент,
		Отказ,
		Копирование,
		Родитель,
		Группа,
		Параметр = Неопределено) Экспорт
	
	Если НЕ Группа Тогда
		Справочник = СтрНайти(Форма.ПолноеИмяОбъекта, "Справочник") > 0;
		ИмяОбъекта = ?(Справочник, "Справочник.", "ПланВидовХарактеристик.");
		Если Копирование Тогда
			КлючеваяОперация = "Копирование" + ?(Справочник, "Справочника", "ПланаВидаХарактеристик")
				+ СтрЗаменить(Форма.ПолноеИмяОбъекта, ИмяОбъекта, "");
		Иначе
			КлючеваяОперация = "СозданиеФормы" + ?(Справочник, "Справочника", "ПланаВидаХарактеристик")
				+ СтрЗаменить(Форма.ПолноеИмяОбъекта, ИмяОбъекта, "");
		КонецЕсли;
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры // СписокПередНачаломДобавления()

// Устарела. Переносим в форму списка. Будет удалена.
// Общий обработчик события возникающего перед началом изменения списка.
//
// Параметры:
//  Форма   - УправляемаяФорма - Форма, в которой возникло событие.
//  Элемент - ТаблицаФормы     - Элемент управления, в котором возникло данное событие.
//  Отказ   - Булево           - Признак отказа от действия.
//
Процедура СписокПередНачаломИзменения(Форма, Элемент, Отказ) Экспорт
	
	Если НЕ ЕстьРеквизитНаКлиенте(Элемент.ТекущиеДанные, "ЭтоГруппа") ИЛИ НЕ Элемент.ТекущиеДанные.ЭтоГруппа Тогда
		Справочник = СтрНайти(Форма.ПолноеИмяОбъекта, "Справочник") > 0;
		ИмяОбъекта = ?(Справочник,"Справочник.","ПланВидовХарактеристик.");
		КлючеваяОперация = "ОткрытиеФормы"
			+ ?(Справочник, "Справочника", "ПланаВидаХарактеристик")
			+ СтрЗаменить(Форма.ПолноеИмяОбъекта, ИмяОбъекта, "");
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры // СписокПередНачаломИзменения()

// Устарела. Бдует удалена. 
// Общий обработчик события возникающего после удаления строки списка.
//
// Параметры:
//  Форма   - УправляемаяФорма - Форма, в которой возникло событие.
//  Элемент - ТаблицаФормы     - Элемент управления, в котором возникло данное событие.
//
Процедура СписокПослеУдаления(Форма, Элемент) Экспорт
	
	Зарезервировано = ИСТИНА;
	
КонецПроцедуры // СписокПослеУдаления()

// Устарела. Бдует удалена.
// Общий обработчик события возникающего на клиенте при изменении текущего родителя в режиме иерархического списка.
//
// Параметры:
//  Форма   - УправляемаяФорма - Форма, в которой возникло событие.
//  Элемент - ТаблицаФормы     - Элемент управления, в котором возникло данное событие.
//
Процедура СписокПриСменеТекущегоРодителя(Форма, Элемент) Экспорт
	
	Зарезервировано = ИСТИНА;
	
КонецПроцедуры // СписокПриСменеТекущегоРодителя()

// Общий обработчик события возникающего на клиенте при движении курсора в поле приемнике данных.
//
// Параметры:
//  Форма                   - УправляемаяФорма - Форма, в которой возникло событие.
//  Элемент                 - ТаблицаФормы     - Элемент управления, в котором возникло данное событие.
//  ПараметрыПеретаскивания - ПараметрыПеретаскивания - Содержат тип действия, возможные действия и значение.
//  СтандартнаяОбработка    - Булево - В данный параметр передается признак выполнения системной обработки события.
//  Строка                  - Число, СправочникСсылка - Содержит порядковый номер строки или ссылку на текущий объект.
//  Поле                    - ПолеФормы - Поле с которым связана данная колонка таблицы, над которой находится объект.
//
Процедура СписокПроверкаПеретаскивания(Форма, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле) Экспорт
	
	// Необходимо чтобы при переносе курсор находился над группой, в которую следует перенести элемент.
	Если Строка=Неопределено Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
	// Перенос корня дерева не имеет смысла
	Если НЕ ЗначениеЗаполнено(ПараметрыПеретаскивания.Действие) Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
	// Производим формирование списка родителей переносимых элементов
	#Если ТолстыйКлиентУправляемоеПриложение Тогда
		Родители = Новый Массив();
		Если ТипЗнч(ПараметрыПеретаскивания.Значение)=Тип("Массив") Тогда
			Для каждого ТекущийЭлемент Из ПараметрыПеретаскивания.Значение Цикл
				Если ЗначениеЗаполнено(ТекущийЭлемент) И Родители.Найти(ТекущийЭлемент.Родитель)=Неопределено Тогда
					Родители.Добавить(ТекущийЭлемент.Родитель);
				КонецЕсли;
			КонецЦикла;
		Иначе
			Родители.Добавить(ПараметрыПеретаскивания.Значение.Родитель);
		КонецЕсли;
		
		// Перенос элементов в собственную группу не имеет смысла
		Если Родители.Количество()=1 И Родители[0]=Строка Тогда
			ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
			Возврат;
		КонецЕсли;
	#КонецЕсли
	
	// Если выполняются все критерии переноса, то разрешаем действие
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение;
	
КонецПроцедуры // СписокПроверкаПеретаскивания()

// Общий обработчик события возникающего на клиенте при окончании перетаскивания в поле-приемнике данных.
//
// Параметры:
//  Форма                   - УправляемаяФорма - Форма, в которой возникло событие.
//  Элемент                 - ТаблицаФормы     - Элемент управления, в котором возникло данное событие.
//  ПараметрыПеретаскивания - ПараметрыПеретаскивания - Содержат тип действия, возможные действия и значение.
//  СтандартнаяОбработка    - Булево - В данный параметр передается признак выполнения системной обработки события.
//  Строка                  - Число, СправочникСсылка - Содержит порядковый номер строки или ссылку на текущий объект.
//  Поле                    - ПолеФормы - Поле с которым связана данная колонка таблицы, над которой находится объект.
//
Процедура СписокПеретаскивание(Форма, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	// При переносе элементов не была выбрана группа, в которую перенести элемента, отказываемся от обработки события.
	Если Строка=Неопределено ИЛИ ТипЗнч(Строка) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
	// Производим чистку перечня переносимых элементов
	Если ТипЗнч(ПараметрыПеретаскивания.Значение)=Тип("Массив") Тогда
		Индекс = ПараметрыПеретаскивания.Значение.Количество()-1;
		Пока Индекс >= 0 Цикл
			
			#Если ТолстыйКлиентУправляемоеПриложение Тогда
				ИсключитьЭлемент = (НЕ ЗначениеЗаполнено(ПараметрыПеретаскивания.Значение)) ИЛИ ПараметрыПеретаскивания.Значение[Индекс]=Строка ИЛИ ПараметрыПеретаскивания.Значение[Индекс].Родитель=Строка ИЛИ ТипЗнч(ПараметрыПеретаскивания.Значение[Индекс]) = Тип("СтрокаГруппировкиДинамическогоСписка");
			#Иначе
				ИсключитьЭлемент = (НЕ ЗначениеЗаполнено(ПараметрыПеретаскивания.Значение)) ИЛИ ПараметрыПеретаскивания.Значение[Индекс]=Строка ИЛИ ТипЗнч(ПараметрыПеретаскивания.Значение[Индекс]) = Тип("СтрокаГруппировкиДинамическогоСписка");
			#КонецЕсли
			
			Если ИсключитьЭлемент Тогда
				ПараметрыПеретаскивания.Значение.Удалить(Индекс);
			КонецЕсли;
			
			Индекс = Индекс - 1;
			
		КонецЦикла;
	КонецЕсли;
	
	// Отказываемся от обработки действия, если переносить нечего
	Если ТипЗнч(ПараметрыПеретаскивания.Значение)=Тип("Массив") И ПараметрыПеретаскивания.Значение.Количество()=0 ИЛИ (НЕ ЗначениеЗаполнено(ПараметрыПеретаскивания.Действие)) ИЛИ (НЕ ЗначениеЗаполнено(ПараметрыПеретаскивания.Значение))  Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
	// Получим представления элементов списка
	Если ТипЗнч(ПараметрыПеретаскивания.Значение)=Тип("Массив") И ПараметрыПеретаскивания.Значение.Количество() > 1 Тогда
		ПредставлениеЭлемента = НСтр("ru = 'выбранные элементы'");
	Иначе
		ПредставлениеЭлемента = "элемент" + " <"+СокрЛП(?(ТипЗнч(ПараметрыПеретаскивания.Значение)=Тип("Массив"), ПараметрыПеретаскивания.Значение[0], ПараметрыПеретаскивания.Значение))+">";
	КонецЕсли;
	ПредставлениеПриемника = ?(Строка.Пустая(), НСтр("ru = 'корень справочника'"), "группу" + " <"+СокрЛП(Строка(Строка))+">");
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("Элемент",ПараметрыПеретаскивания.Значение);
	ПараметрыОбработки.Вставить("Приемник",Строка);
	ПараметрыОбработки.Вставить("Список", Форма.Элементы.Список);
	
	Если ЕстьРеквизитНаКлиенте(Форма, "Дерево") Тогда
		ПараметрыОбработки.Вставить("Дерево", Форма.Элементы.Дерево);
	КонецЕсли;
	
	// Формируем описание обработчика перехвата закрытия формы.
	ОбработчикВопроса = Новый ОписаниеОповещения("Подключаемый_СписокПеретаскивание", ЭтотОбъект, ПараметрыОбработки);
	
	// Формируем текст вопроса
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Перенести %1 в %2?'"), ПредставлениеЭлемента, ПредставлениеПриемника);
	
	// Получаем подтверждение операции от пользователя.
	ПоказатьВопрос(ОбработчикВопроса, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,, НСтр("ru = 'Перенос элемента'"));
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	
КонецПроцедуры // СписокПеретаскивание()

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
Процедура Подключаемый_СписокПеретаскивание(РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если РезультатОповещения = КодВозвратаДиалога.Да Тогда
		Список = ДополнительныеПараметры.Список;
		ДополнительныеПараметры.Удалить("Список");
		
		Дерево = Неопределено;
		Если ДополнительныеПараметры.Свойство("Дерево") Тогда
			Дерево = ДополнительныеПараметры.Дерево;
		КонецЕсли;
		ДополнительныеПараметры.Удалить("Дерево");
		
		// Обработаем в контексте сервера
		УправлениеДиалогомВызовСервера.СписокПеретаскиваниеНаСервере(ДополнительныеПараметры);
		
		Список.Обновить();
		
		Если Дерево <> Неопределено Тогда
			Дерево.Обновить();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // Подключаемый_СписокПеретаскивание()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ ОБЩЕГО НАЗНАЧЕНИЯ

// Общий обработчик события возникающего при нажатии программно добавленной кнопки.
//
// Параметры:
//  Форма         - УправляемаяФорма          - Форма, в которой возникло событие.
//  Команда       - КомандаФормы              - Команда, в которой возникло данное событие.
//  ТекущиеДанные - СправочникСсылка            - Ссылка, для которой выполняется обработка события.
//  Окно          - ОкноКлиентскогоПриложения - Содержит окно, в котором требуется открыть форму.
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события.
//
Функция ОбработкаКомандыФормы(Форма, Команда, ТекущиеДанные, Окно=Неопределено,ПараметрыДействия=Неопределено) Экспорт
	
	// Обработаем в зависимости от выбранной команды
	Если Команда.Имя="ПоказатьРасширеннуюИнформацию" Тогда
		
		// Определим новое значение статуса отображения расширенной информации
		ПоказатьРасширеннуюИнформацию = (НЕ Форма.Элементы.СтраницыРасширеннаяИнформация.Видимость);
		
		// Произведем настройку параметров отображения полей расширенной информации
		Форма.Элементы.СтраницыРасширеннаяИнформация.Видимость = ПоказатьРасширеннуюИнформацию;
		Форма.Элементы.ПоказатьРасширеннуюИнформацию.Пометка   = ПоказатьРасширеннуюИнформацию;
		
		// Взведем признак необходимости выполнить сохранение настроек формы при закрытии
		Форма.СохраняемыеВНастройкахДанныеМодифицированы = ИСТИНА;
		
		// Обновим информации по строке
		Форма.ПодключитьОбработчикОжидания("Подключаемый_СписокПриАктивизацииСтроки", 0.5, ИСТИНА);
		
	ИначеЕсли Команда.Имя="ПоказатьДерево" Тогда
		
		// Определим новое значение статуса отображения дерева
		ПоказатьДерево = (НЕ Форма.Элементы.Дерево.Видимость);
		
		// Произведем настройку параметров отображения полей расширенной информации
		Форма.Элементы.Дерево.Видимость       = ПоказатьДерево;
		Форма.Элементы.ПоказатьДерево.Пометка = ПоказатьДерево;
		
		// Взведем признак необходимости выполнить сохранение настроек формы при закрытии
		Форма.СохраняемыеВНастройкахДанныеМодифицированы = ИСТИНА;
		
	Иначе
		УправлениеДиалогомКлиент.ОбработкаКомандыФормы(Форма, Команда, ТекущиеДанные, Окно, ПараметрыДействия);
		Возврат ПараметрыДействия.Свойство("Результат") И Тип("Булево") = ТипЗнч(ПараметрыДействия.Результат) И ПараметрыДействия.Результат;
	КонецЕсли;
	
	// Возвращаем признак возможности дальнейшей обработки события
	Возврат ИСТИНА;
	
КонецФункции // ОбработкаКомандыФормы()

// Обработчик события возникающего при выполнении оповещения данной формы о прекращении работы подчиненной.
//
// Параметры:
//  Форма              - УправляемаяФорма - Форма, в которой возникло событие.
//  РезультатОповещения     - Произвольный - Результат выполнения операции в подчиненной форме.
//  ДополнительныеПараметры - Произвольный - Значение, которое было указано при создании объекта описания оповещения.
//
// Возвращаемое значение:
//  Булево - признак возможности дальнейшей обработки события.
//
Функция ОбработкаРезультатаОповещения(Форма, РезультатОповещения, ДополнительныеПараметры=Неопределено) Экспорт
	
	// Проверяем статус закрытия окна параметров
	Если РезультатОповещения=Неопределено Тогда
		Возврат ЛОЖЬ;
	КонецЕсли;
	
	// Вызываем общий обработчик действия
	Возврат УправлениеДиалогомКлиент.ОбработкаРезультатаОповещения(Форма, РезультатОповещения, ДополнительныеПараметры);
	
КонецФункции // ОбработкаРезультатаОповещения()

// Отображает результат выполнения действия.
//
// Параметры:
//  Форма             - УправляемаяФорма          - Форма, в которой возникло событие.
//  ПараметрыДействия - Структура - Набор параметров, использующихся при выполнения операции.
//
Процедура ОбработкаРезультатаВыполненияДействия(Форма, ПараметрыДействия) Экспорт
	
	Если ПараметрыДействия.Свойство("ИмяФормыСписка") И  ПараметрыДействия.Свойство("НайтиОбъект") Тогда
		
		Если ЗначениеЗаполнено(ПараметрыДействия.НайтиОбъект)
			И Форма.ИмяФормы = ПараметрыДействия.ИмяФормыСписка И Форма.Открыта() Тогда
			Форма.Активизировать();
			СписокФормы = Форма.Элементы.Найти("Список");
			Если СписокФормы <> Неопределено И ТипЗнч(СписокФормы) = Тип("ТаблицаФормы") Тогда
				Форма.Элементы.Список.ТекущаяСтрока = ПараметрыДействия.НайтиОбъект;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ПараметрыДействия.Свойство("ПечатьРеестра") Тогда
		
		ПараметрыДействия.Вставить("СформироватьПриОткрытии", Истина);
		ОткрытьФорму("Отчет.ПечатьРеестра.Форма", ПараметрыДействия);
		
	КонецЕсли;
	
	УправлениеДиалогомКлиент.ПоказатьРезультатВыполнения(Форма, ПараметрыДействия);
	
КонецПроцедуры // ОбработкаРезультатаВыполненияДействия()

#КонецОбласти
