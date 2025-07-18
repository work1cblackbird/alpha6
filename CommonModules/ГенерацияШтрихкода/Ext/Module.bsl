﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Пустая структура для заполнения параметра "ПараметрыШтрихкода" используемого для получения изображения штрих кода.
// 
// Возвращаемое значение:
//   Структура:
//   * Ширина - Число - ширина изображения штрих кода.
//   * Высота - Число - высота изображения штрих кода.
//   * ТипКода - Число - штрихкода.
//       Возможные значение:
//      99 -  Авто выбор
//      0 - EAN8
//      1 - EAN13
//      2 - EAN128
//      3 - Code39
//      4 - Code128
//      5 - Code16k
//      6 - PDF417
//      7 - Standart (Industrial) 2 of 5
//      8 - Interleaved 2 of 5
//      9 - Code39 Расширение
//      10 - Code93
//      11 - ITF14
//      12 - RSS14
//      14 - EAN13AddOn2
//      15 - EAN13AddOn5
//      16 - QR
//      17 - GS1DataBarExpandedStacked
//      18 - Datamatrix ASCII
//      19 - Datamatrix BASE256
//      20 - Datamatrix TEXT
//      21 - Datamatrix C40
//      22 - Datamatrix X12
//      23 - Datamatrix EDIFACT
//      24 - Datamatrix GS1ASCII      
//      25 - Aztec      
//   * ОтображатьТекст - Булево - отображать HRI теста для штрихкода.
//   * РазмерШрифта - Число - размер шрифта HRI теста для штрихкода.
//   * УголПоворота - Число - угол поворота.
//      Возможные значения: 0, 90, 180, 270.
//   * Штрихкод - Строка - значение штрихкод в виде строки или Base64.
//   * ТипВходныхДанных - Число - тип входных данных 
//      Возможные значения: 0 - Строка, 1 - Base64
//   * ПрозрачныйФон - Булево - прозрачный фон изображения штрихкода.
//   * Инвертирован - Булево -  цвета пикселей ШК будут изменены на обратные.       
//   * УровеньКоррекцииQR - Число - уровень коррекции штрихкода QR.
//      Возможные значения: 0 - L, 1 - M, 2 - Q, 3 - H.
//   * Масштабировать - Булево -  масштабировать изображение штрихкода.
//   * СохранятьПропорции - Булево - сохранять пропорции изображения штрихкода.                                                              
//   * ВертикальноеВыравнивание - Число - вертикальное выравнивание штрихкода.
//      Возможные значения: 1 - По верхнему краю, 2 - По центру, 3 - По нижнему краю
//   * GS1DatabarКоличествоСтрок - Число - количество строк в штрихкоде GS1Databar.
//   * УбратьЛишнийФон - Булево
//   * ЛоготипКартинка - Строка - строка с base64 представлением png картинки логотипа.
//   * ЛоготипРазмерПроцентОтШК - Число - процент от генерированного QR для вписывания логотипа.
//
Функция ПараметрыГенерацииШтрихкода() Экспорт
	
	ПараметрыШтрихкода = Новый Структура;
	ПараметрыШтрихкода.Вставить("Ширина"            , 100);
	ПараметрыШтрихкода.Вставить("Высота"            , 100);
	ПараметрыШтрихкода.Вставить("ТипКода"           , 99);
	ПараметрыШтрихкода.Вставить("ОтображатьТекст"   , Истина);
	ПараметрыШтрихкода.Вставить("РазмерШрифта"      , 12);
	ПараметрыШтрихкода.Вставить("УголПоворота"      , 0);
	ПараметрыШтрихкода.Вставить("Штрихкод"          , "");
	ПараметрыШтрихкода.Вставить("ПрозрачныйФон"     , Истина);
	ПараметрыШтрихкода.Вставить("Инвертирован"      , Ложь);
	ПараметрыШтрихкода.Вставить("УровеньКоррекцииQR", 1);
	ПараметрыШтрихкода.Вставить("Масштабировать"           , Ложь);
	ПараметрыШтрихкода.Вставить("СохранятьПропорции"       , Ложь);
	ПараметрыШтрихкода.Вставить("ВертикальноеВыравнивание" , 1); 
	ПараметрыШтрихкода.Вставить("GS1DatabarКоличествоСтрок", 2);
	ПараметрыШтрихкода.Вставить("ТипВходныхДанных", 0);
	ПараметрыШтрихкода.Вставить("УбратьЛишнийФон" , Ложь); 
	ПараметрыШтрихкода.Вставить("ЛоготипКартинка");
	ПараметрыШтрихкода.Вставить("ЛоготипРазмерПроцентОтШК");       
	ПараметрыШтрихкода.Вставить("НовыйВызовКомпоненты", Ложь);  
	
	Возврат ПараметрыШтрихкода;
	
КонецФункции                      

// Формирование изображения штрихкода.
//
// Параметры: 
//   ПараметрыШтрихкода - см. ГенерацияШтрихкода.ПараметрыГенерацииШтрихкода.
//
// Возвращаемое значение: 
//   Структура:
//      Результат - Булево - результат генерации штрихкода.
//      ДвоичныеДанные - ДвоичныеДанные - двоичные данные изображения штрихкода.
//      Картинка - Картинка - картинка с сформированным штрихкодом или НЕОПРЕДЕЛЕНО.
//
Функция ИзображениеШтрихкода(ПараметрыШтрихкода) Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ТипПлатформыКомпоненты = Строка(СистемнаяИнформация.ТипПлатформы);
	
	ВнешняяКомпонента = ГенерацияШтрихкодаСерверПовтИсп.ПодключитьКомпонентуГенерацииИзображенияШтрихкода(ТипПлатформыКомпоненты);
	
	Если ВнешняяКомпонента = Неопределено Тогда
		МодульОбщегоНазначения = МодульОбщегоНазначения();
		ТекстСообщения = НСтр("ru = 'Ошибка подключения внешней компоненты печати штрихкода.'", МодульОбщегоНазначения.КодОсновногоЯзыка());
	#Если НЕ МобильноеПриложениеСервер Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка генерации штрихкода'", 
			МодульОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, 
			ТекстСообщения);
	#КонецЕсли
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("НовыйВызовКомпоненты") И ПараметрыШтрихкода.НовыйВызовКомпоненты Тогда
		Возврат ПодготовитьИзображениеШтрихкода(ВнешняяКомпонента, ПараметрыШтрихкода); 
	Иначе
		Возврат ПодготовитьИзображениеШтрихкодаСвойства(ВнешняяКомпонента, ПараметрыШтрихкода); 
	КонецЕсли;
	 
КонецФункции

// Возвращает двоичные данные для формирования QR-кода.
//
// Параметры:
//  QRСтрока         - Строка - данные, которые необходимо разместить в QR-коде.
//
//  УровеньКоррекции - Число - уровень погрешности изображения, при котором данный QR-код все еще возможно 100%
//                             распознать.
//                     Параметр должен иметь тип целого и принимать одно из 4 допустимых значений:
//                     0 (7 % погрешности), 1 (15 % погрешности), 2 (25 % погрешности), 3 (35 % погрешности).
//
//  Размер           - Число - определяет длину стороны выходного изображения в пикселях.
//                     Если минимально возможный размер изображения больше этого параметра - код сформирован не будет.
//
// Возвращаемое значение:
//  ДвоичныеДанные  - буфер, содержащий байты PNG-изображения QR-кода.
// 
// Пример:
//  
//  // Выводим на печать QR-код, содержащий в себе информацию зашифрованную по УФЭБС.
//
//  QRСтрока = УправлениеПечатью.ФорматнаяСтрокаУФЭБС(РеквизитыПлатежа);
//  ТекстОшибки = "";
//  ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(QRСтрока, 0, 190, ТекстОшибки);
//  Если Не ПустаяСтрока(ТекстОшибки)
//      ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
//  КонецЕсли;
//
//  КартинкаQRКода = Новый Картинка(ДанныеQRКода);
//  ОбластьМакета.Рисунки.QRКод.Картинка = КартинкаQRКода;
//
Функция ДанныеQRКода(QRСтрока, УровеньКоррекции, Размер) Экспорт
	
	ПараметрыШтрихкода = ПараметрыГенерацииШтрихкода();
	ПараметрыШтрихкода.Ширина = Размер;
	ПараметрыШтрихкода.Высота = Размер;
	ПараметрыШтрихкода.Штрихкод = QRСтрока;
	ПараметрыШтрихкода.УровеньКоррекцииQR = УровеньКоррекции;
	ПараметрыШтрихкода.ТипКода = 16; // QR
	ПараметрыШтрихкода.УбратьЛишнийФон = Истина;
	
	Попытка
		РезультатФормированияШтрихкода = ИзображениеШтрихкода(ПараметрыШтрихкода);
		ДвоичныеДанныеКартинки = РезультатФормированияШтрихкода.ДвоичныеДанные;
	Исключение
	#Если НЕ МобильноеПриложениеСервер Тогда
		МодульОбщегоНазначения = МодульОбщегоНазначения();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка генерации штрихкода'", 
			МодульОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, 
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	#КонецЕсли
	КонецПопытки;
	
	Возврат ДвоичныеДанныеКартинки;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет подключение внешней компоненты.
//
// Возвращаемое значение: 
//   ОбъектВнешнейКомпоненты
//   Неопределено - если компоненту не удалось загрузить.
//
Функция ПодключитьКомпонентуГенерацииИзображенияШтрихкода() Экспорт
	
	ВнешняяКомпонента = Неопределено;
	ИмяОбъекта = ОписаниеКомпоненты().ИмяОбъекта;
	ПолноеИмяМакета = ОписаниеКомпоненты().ПолноеИмяМакета;
	
	МодульОбщегоНазначения = МодульОбщегоНазначения();
	Если МодульОбщегоНазначения.ПодсистемаСуществует("ПоддержкаОборудования") Тогда
		// подключение компоненты через БПО
		МодульВнешниеКомпонентыБПО = МодульОбщегоНазначения.ОбщийМодуль("ВнешниеКомпонентыБПО");
		ВнешняяКомпонента = МодульВнешниеКомпонентыБПО.ПодключитьКомпоненту(ИмяОбъекта, ПолноеИмяМакета);
	Иначе
		// Подключение компоненты через БСП
		// Вызов БСП
#Если НЕ МобильноеПриложениеСервер Тогда
		УстановитьОтключениеБезопасногоРежима(Истина);
		Если МодульОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
			Если МодульОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВнешниеКомпоненты") Тогда   
				МодульВнешниеКомпонентыСервер = МодульОбщегоНазначения.ОбщийМодуль("ВнешниеКомпонентыСервер");
				ПараметрыПодключения = МодульВнешниеКомпонентыСервер.ПараметрыПодключения();
				РезультатПодключения = МодульВнешниеКомпонентыСервер.ПодключитьКомпоненту(ИмяОбъекта);
				Если РезультатПодключения.Подключено Тогда
					ВнешняяКомпонента = РезультатПодключения.ПодключаемыйМодуль;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если ВнешняяКомпонента = Неопределено Тогда 
			ВнешняяКомпонента = МодульОбщегоНазначения.ПодключитьКомпонентуИзМакета(ИмяОбъекта, ПолноеИмяМакета);
		КонецЕсли;
#КонецЕсли
		// Конец Вызов БСП
	КонецЕсли;
	
	Если ВнешняяКомпонента = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	// Установим основные параметры компоненты.
	// Если в системе установлен шрифт Tahoma.
	Если ВнешняяКомпонента.НайтиШрифт("Tahoma") Тогда
		// Выбираем его как шрифт для формирования картинки.
		ВнешняяКомпонента.Шрифт = "Tahoma";
	Иначе
		// Шрифт Tahoma в системе отсутствует.
		// Обойдем все доступные компоненте шрифты.
		Для Сч = 0 По ВнешняяКомпонента.КоличествоШрифтов -1 Цикл
			// Получим очередной шрифт, доступный компоненте.
			ТекущийШрифт = ВнешняяКомпонента.ШрифтПоИндексу(Сч);
			// Если шрифт доступен
			Если ТекущийШрифт <> Неопределено Тогда
				// Они и будет шрифтом для формирования штрихкода.
				ВнешняяКомпонента.Шрифт = ТекущийШрифт;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	// Установим размер шрифта
	ВнешняяКомпонента.РазмерШрифта = 12;
	
	Возврат ВнешняяКомпонента;
	
КонецФункции

// Описание подключения внешней компоненты печати штрихкодов.
//
// Возвращаемое значение:
//  Структура:
//   * ПолноеИмяМакета - Строка
//   * ИмяОбъекта      - Строка
//
Функция ОписаниеКомпоненты() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ИмяОбъекта", "Barcode");
	Параметры.Вставить("ПолноеИмяМакета", "ОбщийМакет.КомпонентаПечатиШтрихкодов");
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Подготовить изображения штрихкода.
//
// Параметры: 
//   ВнешняяКомпонента - см. ГенерацияШтрихкодаСерверПовтИсп.ПодключитьКомпонентуГенерацииИзображенияШтрихкода
//   ПараметрыШтрихкода - см. ГенерацияШтрихкода.ПараметрыГенерацииШтрихкода
//
// Возвращаемое значение: 
//   Структура:
//      Результат - Булево - результат генерации штрихкода.
//      ДвоичныеДанные - ДвоичныеДанные - двоичные данные изображения штрихкода.
//      Картинка - Картинка - картинка с сформированным штрихкодом или НЕОПРЕДЕЛЕНО.
//
Функция ПодготовитьИзображениеШтрихкода(ВнешняяКомпонента, ПараметрыШтрихкода)
	
	ЗаписьXML = Новый ЗаписьXML; 
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("MakeBarcode");
	ЗаписьXML.ЗаписатьНачалоЭлемента("Parameters");   
	
	// Шрифт установленный по умолчанию.
	ЗаписьXML.ЗаписатьНачалоЭлемента("Font");   
	ЗаписьXML.ЗаписатьТекст(ВнешняяКомпонента.Шрифт);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	// Ширина генерируемого изображения в пикселах	  
	ШиринаШтрихкода = ?(ПараметрыШтрихкода.Ширина <= 0, 1, Окр(ПараметрыШтрихкода.Ширина));
	ЗаписьXML.ЗаписатьНачалоЭлемента("Width");   
	ЗаписьXML.ЗаписатьТекст(Строка(ШиринаШтрихкода));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	// Высота генерируемого изображения в пикселах.
	ВысотаШтрихкода = ?(ПараметрыШтрихкода.Высота <= 0, 1, Окр(ПараметрыШтрихкода.Высота));
	ЗаписьXML.ЗаписатьНачалоЭлемента("Height");   
	ЗаписьXML.ЗаписатьТекст(Строка(ВысотаШтрихкода));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	// Признак использования прозрачного фона.
	ЗаписьXML.ЗаписатьНачалоЭлемента("BgTransparent");   
	ЗаписьXML.ЗаписатьТекст(XMLСтрока(ПараметрыШтрихкода.ПрозрачныйФон));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	// Указывает генератору, что требуется убрать лишний фон по краям ШК.
	ЗаписьXML.ЗаписатьНачалоЭлемента("RemoveExeedBackgroud");   
	ЗаписьXML.ЗаписатьТекст(XMLСтрока(ПараметрыШтрихкода.УбратьЛишнийФон));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	// Угол поворота (в градусах) штрихкода на сгенерированном изображении.     
	УголПоворота = Число(?(ПараметрыШтрихкода.Свойство("УголПоворота"), ПараметрыШтрихкода.УголПоворота, 0));
	ЗаписьXML.ЗаписатьНачалоЭлемента("CanvasRotation");   
	ЗаписьXML.ЗаписатьТекст(XMLСтрока(УголПоворота));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	// Значение уровня коррекции QR-кода: 0 - L, 1 - M, 2 - Q, 3 - H    
	УровеньКоррекцииQR = Число(?(ПараметрыШтрихкода.Свойство("УровеньКоррекцииQR"), ПараметрыШтрихкода.УровеньКоррекцииQR, 1));
	ЗаписьXML.ЗаписатьНачалоЭлемента("QRErrorCorrectionLevel");   
	ЗаписьXML.ЗаписатьТекст(XMLСтрока(УровеньКоррекцииQR));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	// Необходимость отображать подпись штрихкода на сгенерированном изображении.
	ЗаписьXML.ЗаписатьНачалоЭлемента("TextVisible");   
	ЗаписьXML.ЗаписатьТекст(XMLСтрока(ПараметрыШтрихкода.ОтображатьТекст));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	// Размер шрифта в пикселах
	ЗаписьXML.ЗаписатьНачалоЭлемента("FontSize");   
	ЗаписьXML.ЗаписатьТекст(XMLСтрока(Число(ПараметрыШтрихкода.РазмерШрифта)));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	// Вертикального выравнивания штрихкода на сгенерированном изображении: 1 - по верхнему краю, 2 - по центру, 3 - по нижнему краю.
	ЗаписьXML.ЗаписатьНачалоЭлемента("CodeVerticalAlign");   
	ЗаписьXML.ЗаписатьТекст(XMLСтрока(Число(ПараметрыШтрихкода.ВертикальноеВыравнивание)));
	ЗаписьXML.ЗаписатьКонецЭлемента();   
	// Количество строк штрихкода GS1 Databar extended stacked
	ЗаписьXML.ЗаписатьНачалоЭлемента("GS1DatabarRowCount");   
	ЗаписьXML.ЗаписатьТекст(XMLСтрока(Число(ПараметрыШтрихкода.GS1DatabarКоличествоСтрок)));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	// Цвета пикселей ШК будут изменены на обратные.  
	Если ПараметрыШтрихкода.Свойство("Инвертирован") Тогда
		ЗаписьXML.ЗаписатьНачалоЭлемента("Inverted");   
		ЗаписьXML.ЗаписатьТекст(XMLСтрока(ПараметрыШтрихкода.Инвертирован));
		ЗаписьXML.ЗаписатьКонецЭлемента();          
	КонецЕсли;                        
	// Тип штрихкода - QR
	Если ПараметрыШтрихкода.ТипКода = 16 Тогда 
		Если ЗначениеЗаполнено(ПараметрыШтрихкода.ЛоготипКартинка) Тогда 
			ЗаписьXML.ЗаписатьНачалоЭлемента("LogoImageBase64");   
			ЗаписьXML.ЗаписатьТекст(XMLСтрока(ПараметрыШтрихкода.ЛоготипКартинка));
			ЗаписьXML.ЗаписатьКонецЭлемента();
		КонецЕсли;
		Если Не ПустаяСтрока(ПараметрыШтрихкода.ЛоготипРазмерПроцентОтШК) Тогда 
			ЗаписьXML.ЗаписатьНачалоЭлемента("LogoSizePercentFromBarcode");   
			ЗаписьXML.ЗаписатьТекст(XMLСтрока(Число(ПараметрыШтрихкода.ЛоготипРазмерПроцентОтШК)));
			ЗаписьXML.ЗаписатьКонецЭлемента();
		КонецЕсли;
	КонецЕсли;                            
	// Определение типа штрихкода.
	ШтрихкодАвтоТип = (ПараметрыШтрихкода.ТипКода = 99);
	ЗаписьXML.ЗаписатьНачалоЭлемента("CodeAuto");   
	ЗаписьXML.ЗаписатьТекст(XMLСтрока(ШтрихкодАвтоТип));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	Если НЕ ШтрихкодАвтоТип Тогда          
		ЗаписьXML.ЗаписатьНачалоЭлемента("CodeType");   
		ЗаписьXML.ЗаписатьТекст(XMLСтрока(Число(ПараметрыШтрихкода.ТипКода)));
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЕсли;                     
	// ECL
	ЗаписьXML.ЗаписатьНачалоЭлемента("ECL");   
	ЗаписьXML.ЗаписатьТекст("1");
	ЗаписьXML.ЗаписатьКонецЭлемента();
	// Тип данных штрихкода
	ЗаписьXML.ЗаписатьНачалоЭлемента("InputDataType");   
	ЗаписьXML.ЗаписатьТекст(XMLСтрока(Число(ПараметрыШтрихкода.ТипВходныхДанных)));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	// Значение штрихкода
	ЗаписьXML.ЗаписатьНачалоЭлемента("CodeValue");   
	ЗаписьXML.ЗаписатьТекст(XMLСтрока(Строка(ПараметрыШтрихкода.Штрихкод)));
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ПараметрыГенерацииXML = ЗаписьXML.Закрыть();
	
	РезультатXML = "";
	ВнешняяКомпонента.СгенерироватьШтрихкод(ПараметрыГенерацииXML, РезультатXML);
	
	// Результат 
	РезультатОперации = Новый Структура();
	РезультатОперации.Вставить("Результат", Ложь);
	РезультатОперации.Вставить("ДвоичныеДанные");
	РезультатОперации.Вставить("Картинка");
	
	Если Не ПустаяСтрока(РезультатXML) Тогда
		ЧтениеXML = Новый ЧтениеXML; 
		ЧтениеXML.УстановитьСтроку(РезультатXML);
		ЧтениеXML.ПерейтиКСодержимому();
		АтрибутыПараметра = Неопределено;
		Если ЧтениеXML.Имя = "MakeBarcodeResult" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Пока ЧтениеXML.Прочитать() Цикл  
				Если ЧтениеXML.Имя = "Result" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.Прочитать() Тогда
					РезультатОперации.Результат = Число(ЧтениеXML.Значение) = 0;
				ИначеЕсли ЧтениеXML.Имя = "ImageBase64" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.Прочитать() Тогда  
					КартинкаBase64 = ЧтениеXML.Значение;    
					ДвоичныеДанныеКартинки = Base64Значение(КартинкаBase64);   
					// Если картинка сформировалась.
					Если ДвоичныеДанныеКартинки <> Неопределено Тогда
						РезультатОперации.ДвоичныеДанные = ДвоичныеДанныеКартинки;
						РезультатОперации.Картинка = Новый Картинка(ДвоичныеДанныеКартинки); // Формируем из двоичных данных.
					КонецЕсли;
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли;  
	КонецЕсли; 
	
	Возврат РезультатОперации;
	
КонецФункции

// Подготовить изображения штрихкода.
//
// Параметры: 
//   ВнешняяКомпонента - см. ГенерацияШтрихкодаСерверПовтИсп.ПодключитьКомпонентуГенерацииИзображенияШтрихкода
//   ПараметрыШтрихкода - см. ГенерацияШтрихкода.ПараметрыГенерацииШтрихкода
//
// Возвращаемое значение: 
//   Структура:
//      Результат - Булево - результат генерации штрихкода.
//      ДвоичныеДанные - ДвоичныеДанные - двоичные данные изображения штрихкода.
//      Картинка - Картинка - картинка с сформированным штрихкодом или НЕОПРЕДЕЛЕНО.
//
Функция ПодготовитьИзображениеШтрихкодаСвойства(ВнешняяКомпонента, ПараметрыШтрихкода)
	
	// Результат 
	РезультатОперации = Новый Структура();
	РезультатОперации.Вставить("Результат", Ложь);
	РезультатОперации.Вставить("ДвоичныеДанные");
	РезультатОперации.Вставить("Картинка");
	
	// Зададим размер формируемой картинки.
	ШиринаШтрихкода = Окр(ПараметрыШтрихкода.Ширина);
	ВысотаШтрихкода = Окр(ПараметрыШтрихкода.Высота);
	Если ШиринаШтрихкода <= 0 Тогда
		ШиринаШтрихкода = 1
	КонецЕсли;
	Если ВысотаШтрихкода <= 0 Тогда
		ВысотаШтрихкода = 1
	КонецЕсли;
	ВнешняяКомпонента.Ширина = ШиринаШтрихкода;
	ВнешняяКомпонента.Высота = ВысотаШтрихкода;
	ВнешняяКомпонента.АвтоТип = Ложь;
	
	ШтрихкодВрем = Строка(ПараметрыШтрихкода.Штрихкод); // Преобразуем явно в строку.
	
	Если ПараметрыШтрихкода.ТипКода = 99 Тогда
		ВнешняяКомпонента.АвтоТип = Истина;
	Иначе
		ВнешняяКомпонента.АвтоТип = Ложь;
		ВнешняяКомпонента.ТипКода = ПараметрыШтрихкода.ТипКода;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("ПрозрачныйФон") Тогда
		ВнешняяКомпонента.ПрозрачныйФон = ПараметрыШтрихкода.ПрозрачныйФон;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("ТипВходныхДанных") Тогда
		ВнешняяКомпонента.ТипВходныхДанных = ПараметрыШтрихкода.ТипВходныхДанных;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("GS1DatabarКоличествоСтрок") Тогда
		ВнешняяКомпонента.GS1DatabarКоличествоСтрок = ПараметрыШтрихкода.GS1DatabarКоличествоСтрок;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("УбратьЛишнийФон") Тогда
		ВнешняяКомпонента.УбратьЛишнийФон = ПараметрыШтрихкода.УбратьЛишнийФон;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("Инвертирован") Тогда
		ВнешняяКомпонента.Инвертирован = ПараметрыШтрихкода.Инвертирован;
	КонецЕсли;                        
	
	ВнешняяКомпонента.ОтображатьТекст = ПараметрыШтрихкода.ОтображатьТекст;
	// Формируем картинку штрихкода.
	ВнешняяКомпонента.ЗначениеКода = ШтрихкодВрем;
	// Угол поворота штрихкода.
	ВнешняяКомпонента.УголПоворота = ?(ПараметрыШтрихкода.Свойство("УголПоворота"), ПараметрыШтрихкода.УголПоворота, 0);
	// Уровень коррекции QR кода (L=0, M=1, Q=2, H=3).
	ВнешняяКомпонента.УровеньКоррекцииQR = ?(ПараметрыШтрихкода.Свойство("УровеньКоррекцииQR"), ПараметрыШтрихкода.УровеньКоррекцииQR, 1);
	
	// Для обеспечения совместимости с предыдущими версиями БПО.
	Если Не ПараметрыШтрихкода.Свойство("Масштабировать")
		Или (ПараметрыШтрихкода.Свойство("Масштабировать") И ПараметрыШтрихкода.Масштабировать) Тогда
		
		Если Не ПараметрыШтрихкода.Свойство("СохранятьПропорции")
				Или (ПараметрыШтрихкода.Свойство("СохранятьПропорции") И Не ПараметрыШтрихкода.СохранятьПропорции) Тогда
			// Если установленная нами ширина меньше минимально допустимой для этого штрихкода.
			Если ВнешняяКомпонента.Ширина < ВнешняяКомпонента.МинимальнаяШиринаКода Тогда
				ВнешняяКомпонента.Ширина = ВнешняяКомпонента.МинимальнаяШиринаКода;
			КонецЕсли;
			// Если установленная нами высота меньше минимально допустимой для этого штрихкода.
			Если ВнешняяКомпонента.Высота < ВнешняяКомпонента.МинимальнаяВысотаКода Тогда
				ВнешняяКомпонента.Высота = ВнешняяКомпонента.МинимальнаяВысотаКода;
			КонецЕсли;
		ИначеЕсли ПараметрыШтрихкода.Свойство("СохранятьПропорции") И ПараметрыШтрихкода.СохранятьПропорции Тогда
			Пока ВнешняяКомпонента.Ширина < ВнешняяКомпонента.МинимальнаяШиринаКода 
				Или ВнешняяКомпонента.Высота < ВнешняяКомпонента.МинимальнаяВысотаКода Цикл
				// Если установленная нами ширина меньше минимально допустимой для этого штрихкода.
				Если ВнешняяКомпонента.Ширина < ВнешняяКомпонента.МинимальнаяШиринаКода Тогда
					ВнешняяКомпонента.Ширина = ВнешняяКомпонента.МинимальнаяШиринаКода;
					ВнешняяКомпонента.Высота = Окр(ВнешняяКомпонента.МинимальнаяШиринаКода / ШиринаШтрихкода) * ВысотаШтрихкода;
				КонецЕсли;
				// Если установленная нами высота меньше минимально допустимой для этого штрихкода.
				Если ВнешняяКомпонента.Высота < ВнешняяКомпонента.МинимальнаяВысотаКода Тогда
					ВнешняяКомпонента.Высота = ВнешняяКомпонента.МинимальнаяВысотаКода;
					ВнешняяКомпонента.Ширина = Окр(ВнешняяКомпонента.МинимальнаяВысотаКода / ВысотаШтрихкода) * ШиринаШтрихкода;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	// ВертикальноеВыравниваниеКода: 1 - по верхнему краю, 2 - по центру, 3 - по нижнему краю.
	Если ПараметрыШтрихкода.Свойство("ВертикальноеВыравнивание") И (ПараметрыШтрихкода.ВертикальноеВыравнивание > 0) Тогда
		ВнешняяКомпонента.ВертикальноеВыравниваниеКода = ПараметрыШтрихкода.ВертикальноеВыравнивание;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("РазмерШрифта") И (ПараметрыШтрихкода.РазмерШрифта > 0) 
		И (ПараметрыШтрихкода.ОтображатьТекст) И (ВнешняяКомпонента.РазмерШрифта <> ПараметрыШтрихкода.РазмерШрифта) Тогда
			ВнешняяКомпонента.РазмерШрифта = ПараметрыШтрихкода.РазмерШрифта;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.ТипКода = 16 Тогда // QR
		Если ПараметрыШтрихкода.Свойство("ЛоготипКартинка") И ЗначениеЗаполнено(ПараметрыШтрихкода.ЛоготипКартинка) Тогда 
			ВнешняяКомпонента.ЛоготипКартинка = ПараметрыШтрихкода.ЛоготипКартинка;    
		Иначе
			ВнешняяКомпонента.ЛоготипКартинка = "";
		КонецЕсли;
		Если ПараметрыШтрихкода.Свойство("ЛоготипРазмерПроцентОтШК") И Не ПустаяСтрока(ПараметрыШтрихкода.ЛоготипРазмерПроцентОтШК) Тогда 
			ВнешняяКомпонента.ЛоготипРазмерПроцентОтШК = ПараметрыШтрихкода.ЛоготипРазмерПроцентОтШК;
		КонецЕсли;
	КонецЕсли;
		
	// Сформируем картинку
	ДвоичныеДанныеКартинки = ВнешняяКомпонента.ПолучитьШтрихкод();
	РезультатОперации.Результат = ВнешняяКомпонента.Результат = 0;
	// Если картинка сформировалась.
	Если ДвоичныеДанныеКартинки <> Неопределено Тогда
		РезультатОперации.ДвоичныеДанные = ДвоичныеДанныеКартинки;
		РезультатОперации.Картинка = Новый Картинка(ДвоичныеДанныеКартинки); // Формируем из двоичных данных.
	КонецЕсли;
	
	Возврат РезультатОперации;
	
КонецФункции

Функция МодульОбщегоНазначения()
	
	Если Метаданные.Подсистемы.Найти("ПоддержкаОборудования") = Неопределено Тогда
		// Вызов БСП
		Возврат Вычислить("ОбщегоНазначения");
		// Конец Вызов БСП
	Иначе
		Возврат Вычислить("ОбщегоНазначенияБПО");
	КонецЕсли;
	
КонецФункции

#КонецОбласти