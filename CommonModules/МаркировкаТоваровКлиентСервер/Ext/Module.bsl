﻿
#Область ПрограммныйИнтерфейс

// Получение кода маркировки без криптохвоста
//
// Параметры:
//  ШтрихКод			 - Строка	 - Штрихкод для преобразования
//  Сообщение			 - Строка - Признак того, что штрихкод не явяется кодом маркировки
//  ФормироватьСкобками	 - Булево - Выбор шаблона формирования кода маркировки
// 
// Возвращаемое значение:
//  Строка - Сформированный код маркировки без криптохвоста или текущий ШК
//
Функция ПолучитьКодМаркировки(ШтрихКод, Сообщение = "", ФормироватьСкобками = Истина) Экспорт
	
	// Разберем маркировку
	СтруктураМаркировки = РазобратьШтриховойКодТовара(Штрихкод);
	
	Если НЕ ЭтоКодТовараВФорматеDataMatrixGS1(ШтрихКод, СтруктураМаркировки, Сообщение) Тогда
		
		Возврат ШтрихКод;
		
	КонецЕсли;
	
	Возврат СформироватьКодМаркировки(
		СтруктураМаркировки,
		ФормироватьСкобками);
	
КонецФункции // ПолучитьКодМаркировки()

// Устарела. Перенесена в модуль МаркировкаТоваровКлиент и МаркировкаТоваровСервер
// Разобрать строку штрихкода в соответствии со стандартом GS1.
//
// Параметры:
//  Штрихкод - Строка - значение штрихкода.
//
// Возвращаемое значение:
//  Структура. 
//
Функция РазобратьШтриховойКодТовара(Штрихкод) Экспорт
	
	Возврат МенеджерОборудованияМаркировкаКлиентСервер.РазобратьШтриховойКодТовара(ШтрихКод);
	
КонецФункции

// Проверяет, является ли полученный код кодом маркировки.
//
// Параметры:
//  ШтрихКод            - Строка    - Штрихкод для преобразования
//  СтруктураМаркировки - Структура - См МенеджерОборудованияМаркировкаКлиентСервер.РазобратьШтриховойКодТовара().
//  Сообщение           - Строка    - Признак того, что штрихкод не явяется кодом маркировки.
//
// Возвращаемое значение:
//  Булево - Истина, если это код маркировки.
//
Функция ЭтоКодТовараВФорматеDataMatrixGS1(ШтрихКод, СтруктураМаркировки, Сообщение = "") Экспорт
	
	Если СтруктураМаркировки.ТипИдентификатораТовара <>
			ПредопределенноеЗначение("Перечисление.ТипыИдентификаторовТовараККТ.КодТовараВФорматеDataMatrixGS1") Тогда
			
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Код <%1> не является кодом маркировки.'"),
			ШтрихКод
		);
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Формирование кода маркировки из структруры разбора штрихкода.
//
// Параметры:
//  СтруктураМаркировки - Структура - см. МенеджерОборудованияМаркировкаКлиентСервер.РазобратьШтриховойКодТовара().
//  ФормироватьСкобками - Булево - Выбор шаблона формирования кода маркировки
// 
// Возвращаемое значение:
//  Строка - Сформированный код маркировки без криптохвоста или текущий ШК
//
Функция СформироватьКодМаркировки(СтруктураМаркировки, ФормироватьСкобками = Истина) Экспорт
	
	Если ПолучитьЗначениеПараметраСтруктуры(СтруктураМаркировки, "ПотребительскаяУпаковкаТабачнойПродукции", Ложь) Тогда
		
		Возврат СтруктураМаркировки.ПредставлениеШтрихкодаБезКриптоХвоста;
		
	ИначеЕсли ФормироватьСкобками Тогда
		
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"(01)%1(21)%2",
			СтруктураМаркировки.GTIN,
			СтруктураМаркировки.СерийныйНомер
		);
		
	Иначе
		
		МассивКода = Новый Массив;
		МассивКода.Добавить("01");
		МассивКода.Добавить(СтруктураМаркировки.GTIN);
		МассивКода.Добавить("21");
		МассивКода.Добавить(СтруктураМаркировки.СерийныйНомер);
		
		Результат = СтрСоединить(МассивКода, "");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Записывает полный код маркировки в формате BASE64 в регистр.
//
// Параметры:
//  СтруктураМаркировки - Структура - см. МенеджерОборудованияМаркировкаКлиентСервер.РазобратьШтриховойКодТовара()
//
Процедура ЗаписатьПолныйШтрихкод(СтруктураМаркировки) Экспорт
	
	МаркировкаТоваровВызовСервера.ЗаписатьПолныйШтрихкод(СтруктураМаркировки);
	
КонецПроцедуры

// Соспоставляет переданное состояние кода маркировки с полученными данными из Честного знака
//
// Параметры:
//  СостояниеИБ - ПеречислениеСсылка.СостоянияКодовМаркировки - проверяемые состояния кода маркировки.
//  СостояниеСМТ - Строка - данные, полученные из Честного знака.
//  РазрешенныеСостояния - Массив из ПеречислениеСсылка.СостоянияКодовМаркировки - состояния, соответствующие
//                                                                              хозоперации.
//  Примечание - Строка - (необязательное) - причина несоответствия хозоперации.
//
// Возвращаемое значение:
//  Булево - Истина, если состояния соответствуют, в противном случае Ложь.
//
Функция СопоставитьСостоянияКодовМаркировкиСЧестнымЗнаком(
		СостояниеИБ,
		СостояниеСМТ,
		РазрешенныеСостояния,
		Примечание) Экспорт
	
	СостоянияВыпущен       = ДайСостоянияВыпущен();
	СостоянияПолучен       = ДайСостоянияПолучен();
	СостоянияВОбороте      = ДайСостоянияВОбороте();
	СостоянияСписан        = ДайСостоянияСписан();
	СостоянияВыбыл         = ДайСостоянияВыбыл();
	СостоянияРасформирован = ДайСостоянияРасформирован();
	
	Если СостояниеСМТ = "EMITTED" Тогда
		// выпущен
		ДляПоиска = СостоянияВыпущен;
	ИначеЕсли СостояниеСМТ = "APPLIED" Тогда
		// получен
		ДляПоиска = СостоянияПолучен;
	ИначеЕсли СостояниеСМТ = "INTRODUCED" Тогда
		// в обороте
		ДляПоиска = СостоянияВОбороте;
	ИначеЕсли СостояниеСМТ = "WRITTEN_OFF" Тогда
		// списан
		ДляПоиска = СостоянияСписан;
	ИначеЕсли СостояниеСМТ = "RETIRED"
		ИЛИ СостояниеСМТ = "WITHDRAWN" Тогда
		// выбыл
		ДляПоиска = СостоянияВыбыл;
	ИначеЕсли СостояниеСМТ = "DISAGGREGATION" Тогда
		// расформирован
		ДляПоиска = СостоянияРасформирован;
	КонецЕсли;
	
	Если ДляПоиска.Найти(СостояниеИБ) = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Если РазрешенныеСостояния <> Неопределено И РазрешенныеСостояния.Найти(СостояниеИБ) = Неопределено Тогда
			Примечание = НСтр("ru = 'Состояние не соответствует хоз. операции.'");
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Возвращает текстовое представление состояний кода маркировки из "Честного знака"
//
// Возвращаемое значение:
//  Соответствие - текстовое представление состояния кода маркировки.
//   * Ключ - Строка - состояние из "Честного знака",
//   * Значение - Строка - текстовое представление.
//
Функция ПредставлениеСостояния() Экспорт
	
	Результат = Новый Соответствие;
	Результат.Вставить("EMITTED"       , НСтр("ru = 'Эмитирован. Выпущен'"));
	Результат.Вставить("APPLIED"       , НСтр("ru = 'Эмитирован. Получен'"));
	Результат.Вставить("INTRODUCED"    , НСтр("ru = 'В обороте'"));
	Результат.Вставить("WRITTEN_OFF"   , НСтр("ru = 'КИ списан'"));
	Результат.Вставить("RETIRED"       , НСтр("ru = 'Выбыл'"));
	Результат.Вставить("DISAGGREGATION", НСтр("ru = 'Расформирован'"));
	Результат.Вставить("WITHDRAWN"     , НСтр("ru = 'Выбыл'"));
	
	Возврат Результат;
	
КонецФункции

// Возращает актуальные параметры адреса подключения к системе маркировки.
//
// Параметры:
//  ТестовыйКонтур - Булево - Признак того, что нужны данные тестового контура
//
// Возвращаемое значение:
//  Структура - Адреса и порты подключения маркировки.
//
Функция АдресаПодключенияКСистемеМаркировки(ТестовыйКонтур) Экспорт
	
	Если ТестовыйКонтур Тогда
		БазовыйАдрес = "markirovka.sandbox.crptech.ru";
		Порт = 443;
		АдресСУЗ = "suz.sandbox.crptech.ru";
		ПортСУЗ = 443;
	Иначе
		БазовыйАдрес = "markirovka.crpt.ru";
		Порт = 443;
		АдресСУЗ = "suzgrid.crpt.ru";
		ПортСУЗ = 443;
	КонецЕсли;
	
	ПараметрыАдресов = Новый Структура;
	ПараметрыАдресов.Вставить("Адрес", БазовыйАдрес);
	ПараметрыАдресов.Вставить("Порт", Порт);
	ПараметрыАдресов.Вставить("АдресСУЗ", АдресСУЗ);
	ПараметрыАдресов.Вставить("ПортСУЗ", ПортСУЗ);
	
	Возврат ПараметрыАдресов;
	
КонецФункции

// Определяет, что переданная товарная группа принадлежит "Упаковонной воде"
//
// Параметры:
//  ТоварнаяГруппа	 - Строка - Имя товарной группы
// 
// Возвращаемое значение:
//  Булево - Признак принадлежности к товарной группе "Упакованная вода"
//
Функция ЭтоТоварнаяГруппаУпакованнойВоды(ТоварнаяГруппа) Экспорт
	
	Возврат НРег(ТоварнаяГруппа) = "water";
	
КонецФункции // ЭтоТоварнаяГруппаУпакованнойВоды()

// Определяет, что переданная товарная группа принадлежит "Молочная продукция"
//
// Параметры:
//  ТоварнаяГруппа	 - Строка - Имя товарной группы
// 
// Возвращаемое значение:
//  Булево - Признак принадлежности к товарной группе "Молочная продукция"
//
Функция ЭтоТоварнаяГруппаМолочнаяПродукция(ТоварнаяГруппа) Экспорт
	
	Возврат НРег(ТоварнаяГруппа) = "milk";
	
КонецФункции // ЭтоТоварнаяГруппаМолочнаяПродукция()

// Предоставляет данные о товарных групп табачной промышленности
// 
// Возвращаемое значение:
//  Массив - Список товарных групп табачной промышленности
//
Функция ТоварныеГруппыТабачнойПродукции() Экспорт
	
	ТабачнаяПродукция = Новый Массив;
	ТабачнаяПродукция.Добавить("tobacco");
	ТабачнаяПродукция.Добавить("otp");
	ТабачнаяПродукция.Добавить("ncp");
	
	Возврат ТабачнаяПродукция;
	
КонецФункции

// Проверяет наличие необходимости формирования отчета о нанесении перед вводом в оборот КМ.
//
// Параметры:
//  ТоварнаяГруппа	 - Строка - Передаваемый вид продукции.
// 
// Возвращаемое значение:
//  Булево - Признак необходимости ввода отчета о нанесении.
//
Функция ТоварнаяГруппаИспользуетОтчетОНанесении(ТоварнаяГруппа) Экспорт
	
	ГруппыОтчета = Новый Массив;
	ГруппыОтчета.Добавить("water");
	ГруппыОтчета.Добавить("milk");
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ГруппыОтчета, ТоварныеГруппыТабачнойПродукции());
	
	Возврат ГруппыОтчета.Найти(НРег(ТоварнаяГруппа)) <> Неопределено;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


Функция ДайСостоянияВыпущен()
	
	Результат = Новый Массив;
	
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ЭмитированВыпущен"));
	
	Возврат Результат;
	
КонецФункции

Функция ДайСостоянияПолучен()
	
	Результат = Новый Массив;
	
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.Эмитирован"));
	
	Возврат Результат;
	
КонецФункции

Функция ДайСостоянияВОбороте()
	
	Результат = Новый Массив;
	
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ВведенВОборот"));
	Результат.Добавить(
		ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ВведенВОборотПриВозврате")
	);
	
	Возврат Результат;
	
КонецФункции

Функция ДайСостоянияСписан()
	
	Результат = Новый Массив;
	
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.Списан"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.НеИспользован"));
	
	Возврат Результат;
	
КонецФункции

Функция ДайСостоянияВыбыл()
	
	Результат = Новый Массив;
	
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ВыведенИзОборота"));
	Результат.Добавить(
		ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ВыведенИзОборотаРозничнаяПродажа"));
	Результат.Добавить(
		ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ВыведенИзОборотаЭкспортированВСтраныЕАЭС"));
	Результат.Добавить(
		ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ВыведенИзОборотаЭкспортированЗаПределыСтранЕАЭС"));
	Результат.Добавить(
		ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ВыведенИзОборотаВозвращенФизическомуЛицу"));
	Результат.Добавить(
		ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ВыведенИзОборотаПриУтратеИлиПовреждении"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ВыведенИзОборотаПриУничтожении"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ВыведенИзОборотаКонфискация"));
	Результат.Добавить(
		ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ВыведенИзОборотаЛиквидацияПредприятия"));
	Результат.Добавить(ПредопределенноеЗначение(
		"Перечисление.СостоянияКодовМаркировки.ВыведенИзОборотаИспользованДляСобственныхНуждПредприятия")
	);
	Результат.Добавить(
		ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ВыведенИзОборотаПоДоговоруРассрочки"));
	Результат.Добавить(
		ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ВыведенИзОборотаПриПеремаркировке"));
	Результат.Добавить(
		ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ВыведенИзОборотаВРезультатеСписания"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.ПередачаДругомуСобственнику"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.Экспортирован"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.Утилизирован"));
	
	Возврат Результат;
	
КонецФункции

Функция ДайСостоянияРасформирован()
	
	Результат = Новый Массив;
	
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияКодовМаркировки.Разагрегирован"));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти