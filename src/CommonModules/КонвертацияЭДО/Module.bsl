////////////////////////////////////////////////////////////////////////////////
// Общий модуль КонвертацияЭДО
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает печатную форму электронного документа по двоичным данным файла.
// 
// Параметры:
// 		ДанныеЭлектронногоДокумента - ДвоичныеДанные - двоичные данные визуализируемого электронного документа.
// 		КонтекстДиагностики - см. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
// 		ПараметрыВизуализации - Структура - параметры визуализации электронного документа.
// 		ДанныеЭлектронногоДокументаДляИзвлеченияПараметров - ДвоичныеДанные, Неопределено - двоичные данные 
// 		электронного документа из которого необходимо извлечь параметры для визуализируемого документа.
// 		 
// Возвращаемое значение:
// 	ТабличныйДокумент, Неопределено - печатная форма электронного документа.
//
Функция ВизуализацияЭлектронногоДокумента(ДанныеЭлектронногоДокумента,
											ДанныеЭлектронногоДокументаДляИзвлеченияПараметров = Неопределено, 
											ПараметрыВизуализации = Неопределено, 
											КонтекстДиагностики = Неопределено) Экспорт
	
	ПараметрыФайла = ПараметрыФайлаПроизвольногоДокумента(ДанныеЭлектронногоДокумента, КонтекстДиагностики);
	
	Если Не ЗначениеЗаполнено(ПараметрыФайла) Тогда
		РезультатФормирования = Новый Структура;
		РезультатФормирования.Вставить("ПредставлениеДокумента", Неопределено);
		РезультатФормирования.Вставить("Успех", Ложь);
		
		Возврат РезультатФормирования;
	КонецЕсли;
	
	ДополнительныеПараметрыПредставления = Новый Структура;
	
	Если ЗначениеЗаполнено(ДанныеЭлектронногоДокументаДляИзвлеченияПараметров)	Тогда
		ПараметрыФайлаИзвлеченияПараметров = ИзвлечьПараметрыЭлектронногоДокумента(ДанныеЭлектронногоДокументаДляИзвлеченияПараметров, КонтекстДиагностики);
		Если ПараметрыФайлаИзвлеченияПараметров <> Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ДополнительныеПараметрыПредставления, ПараметрыФайлаИзвлеченияПараметров);
		КонецЕсли;
	КонецЕсли;	
	
	Если ПараметрыВизуализации <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ДополнительныеПараметрыПредставления, ПараметрыВизуализации);
	КонецЕсли;
	
	
	Если ПараметрыФайла.Свойство("ПараметрыПредставления") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыФайла.ПараметрыПредставления, ДополнительныеПараметрыПредставления);
	Иначе
		ПараметрыФайла.Вставить("ПараметрыПредставления", ДополнительныеПараметрыПредставления);		
	КонецЕсли;
		
	Возврат ПредставлениеПроизвольногоДокумента(ДанныеЭлектронногоДокумента, ПараметрыФайла, КонтекстДиагностики);

КонецФункции

// Обработчик начального заполнения правил преобразования форматов.
// 
// Параметры:
//  Параметры - Структура - параметры обработчика обновления.
//
Процедура ВыполнитьЗаполнениеПравилПреобразования(Параметры) Экспорт

	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Параметры.ПрогрессВыполнения.ОбработаноОбъектов = 1;
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ВсегоОбъектов = 1;
	
	КаталогПравилПреобразования = ФайловаяСистема.СоздатьВременныйКаталог();	
	
	ПотокДанныхМакета = РегистрыСведений.ПравилаПреобразованияФорматов.ПолучитьМакет("ПравилаПреобразованияФорматов").ОткрытьПотокДляЧтения();
	
	АрхивПравилПреобразования = Новый ЧтениеZipФайла(ПотокДанныхМакета); 
 	АрхивПравилПреобразования.ИзвлечьВсе(КаталогПравилПреобразования);

	ПараметрыНачальногоЗаполнения = Новый Структура;
	ПараметрыНачальногоЗаполнения.Вставить("Каталог", КаталогПравилПреобразования);

	ПроизошлаОшибка = Ложь;

	НачатьТранзакцию();
		
	Попытка
		ОбновитьОписаниеФорматовДляПреобразования( , ПараметрыНачальногоЗаполнения);
		ЗафиксироватьТранзакцию();
	Исключение

		ОтменитьТранзакцию();
		ТекстСообщения =  НСтр("ru = 'Не удалось выполнить заполнение правил преобразования форматов по причине:'") + Символы.ПС
			+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Сообщить(ТекстСообщения);

		ПроизошлаОшибка = Истина;

	КонецПопытки;
	
	ФайловаяСистема.УдалитьВременныйКаталог(КаталогПравилПреобразования);
	
	Если Не ПроизошлаОшибка Тогда
		Параметры.ПрогрессВыполнения.ОбработаноОбъектов = 1;
		Параметры.ОбработкаЗавершена = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсиюНачальноеЗаполнение(Параметры) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК ЕстьЗаписи
		|ИЗ
		|	РегистрСведений.ФорматыДляПреобразования КАК ФорматыДляПреобразования";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьЗаполнениеПравилПреобразования(Параметры);
	
КонецПроцедуры

Функция ПреобразоватьФорматЭД(ПотокИсходногоXML, Параметры = Неопределено, КонтекстДиагностики = Неопределено) Экспорт
	
	Если Параметры = Неопределено Тогда
		Преобразователь = КонвертацияЭДОПовтИсп.ПреобразованиеXSL_ПараметрыПроизвольногоДокумента();
		Если Преобразователь = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		ТекстПравила = ТекстПравилаПреобразованияФормата(Параметры, КонтекстДиагностики);
		Если НЕ ЗначениеЗаполнено(ТекстПравила) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Преобразователь = Новый ПреобразованиеXSL;
		Преобразователь.ЗагрузитьТаблицуСтилейXSLИзСтроки(ТекстПравила);
		
		ПараметрыXSL = Неопределено;
		Если Параметры.Свойство("ПараметрыXSL", ПараметрыXSL) И ЗначениеЗаполнено(ПараметрыXSL) Тогда
			
			Для Каждого ПараметрXSL Из ПараметрыXSL Цикл
				Если ТипЗнч(ПараметрXSL.Значение) = Тип("Структура") Тогда
					ЗначениеПараметра = КонвертироватьЗначениеПоИнструкции(ПараметрXSL.Значение);
					Если ЗначениеПараметра = Неопределено Тогда
						Продолжить;
					КонецЕсли;
					Преобразователь.ДобавитьПараметр(ПараметрXSL.Ключ, ЗначениеПараметра);
				Иначе
					
					ЗначениеПараметра = ПараметрXSL.Значение;
					
					Если ТипЗнч(ЗначениеПараметра) = Тип("Строка") Тогда
						Если СтрНайти(ЗначениеПараметра, "'") <> 0 Тогда
							ЗначениеПараметра = СтрШаблон("""%1""", ЗначениеПараметра);
						Иначе
							ЗначениеПараметра = СтрШаблон("'%1'", ЗначениеПараметра);
						КонецЕсли;
					КонецЕсли;
					
					Если ТипЗнч(ЗначениеПараметра) = Тип("Булево") Тогда
						ЗначениеПараметра = ?(ЗначениеПараметра, 1, 0);
					КонецЕсли;

					Преобразователь.ДобавитьПараметр(ПараметрXSL.Ключ, ЗначениеПараметра);
					
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЧтениеИсходногоXML = Новый ЧтениеXML;
	ЧтениеИсходногоXML.ОткрытьПоток(ПотокИсходногоXML);
	
	ПотокИтоговогоXML = Новый ПотокВПамяти;
	
	ЗаписьИтоговогоXML = Новый ЗаписьXML;
	ЗаписьИтоговогоXML.ОткрытьПоток(ПотокИтоговогоXML);
	
	Попытка
		Преобразователь.Преобразовать(ЧтениеИсходногоXML, ЗаписьИтоговогоXML);
	Исключение
		ЧтениеИсходногоXML.Закрыть();
		ЗаписьИтоговогоXML.Закрыть();
		ПотокИтоговогоXML.Закрыть();
		
		//ВидОперации = НСтр("ru = 'Преобразование формата.'");
		//ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.ВидОшибкиНеизвестнаяОшибка();

		//ПредставлениеОшибкиПодробное = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		// 		
		//Ошибка = ОбработкаНеисправностейБЭД.НоваяОшибка(
		//			ВидОперации, ВидОшибки, ПредставлениеОшибкиПодробное, "");
		//ОбработкаНеисправностейБЭД.ДобавитьОшибку(КонтекстДиагностики, Ошибка,
		//	ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСКонтрагентами);
		Возврат Неопределено;
	КонецПопытки;
	
	ЧтениеИсходногоXML.Закрыть();
	ЗаписьИтоговогоXML.Закрыть();
	
	Результат = Неопределено;
	Если Параметры = Неопределено ИЛИ Параметры.ИтоговыйФормат = "ПараметрыЭлектронногоДокумента" Тогда
		Результат = ЗначениеИзПотокаXML(ПотокИтоговогоXML, Тип("Структура"), Параметры, КонтекстДиагностики);
		ПотокИтоговогоXML.Закрыть();
		
	ИначеЕсли Параметры.ИтоговыйФормат = "ТабличныйДокумент" Тогда
		Результат = ЗначениеИзПотокаXML(ПотокИтоговогоXML, Тип("ТабличныйДокумент"), Параметры, КонтекстДиагностики);
		ПотокИтоговогоXML.Закрыть();
		
	ИначеЕсли Параметры.ИтоговыйФормат = "ТаблицаНоменклатуры" Тогда
		Результат = ЗначениеИзПотокаXML(ПотокИтоговогоXML, Тип("ТаблицаЗначений"), Параметры, КонтекстДиагностики);
		ПотокИтоговогоXML.Закрыть();
		
	ИначеЕсли Параметры.ИтоговыйФормат = "CML" Тогда
		Результат = ПотокИтоговогоXML.ЗакрытьИПолучитьДвоичныеДанные();
		
	КонецЕсли;
	
	Если ТипЗнч(Результат) = Тип("ТабличныйДокумент")
		И (Результат.ВысотаТаблицы = 0 Или Результат.ШиринаТаблицы = 0) Тогда
		// Могли не определиться размеры табличного документа, тогда выводим его в новый табличный документ.
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.Вывести(Результат);
		Результат = ТабличныйДокумент;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПараметрыФайлаПроизвольногоДокумента(ФайлXML, КонтекстДиагностики = Неопределено, ПроверятьПоСхемеXML = Истина) Экспорт
	
	Если Не ЗначениеЗаполнено(ФайлXML) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(ФайлXML) = Тип("Строка") Тогда
		ПотокИсходногоXML = Новый ФайловыйПоток(ФайлXML, РежимОткрытияФайла.Открыть);
	Иначе
		ПотокИсходногоXML = ФайлXML.ОткрытьПотокДляЧтения();
	КонецЕсли;
	
	ПараметрыФайлаXML = ПреобразоватьФорматЭД(ПотокИсходногоXML);
	Если ПараметрыФайлаXML = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ПроверятьПоСхемеXML И ПараметрыФайлаXML.Свойство("ИмяТипаXML") Тогда
		ФайлСоответствуетСхемеXML = ПроверитьЭлектронныйДокументПоСхемеXML(ПотокИсходногоXML, ПараметрыФайлаXML, КонтекстДиагностики);
	Иначе
		ФайлСоответствуетСхемеXML = Истина;
	КонецЕсли;
	
	ПотокИсходногоXML.Закрыть();
	
	Если НЕ ФайлСоответствуетСхемеXML Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ПараметрыФайлаXML.Свойство("ОтражениеВУчете") И ЗначениеЗаполнено(ПараметрыФайлаXML.ОтражениеВУчете) Тогда
		Если ПараметрыФайлаXML.ОтражениеВУчете.ВариантЗаполнения = "СвРК" Тогда
			ПараметрыФайлаXML.ТипДокумента = "СведенияОРеализацииКомиссионером";
		ИначеЕсли ПараметрыФайлаXML.ОтражениеВУчете.ВариантЗаполнения = "СвИСРК" Тогда
			ПараметрыФайлаXML.ТипДокумента = "КорректировкаСведенийОРеализацииКомиссионером";
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПараметрыФайлаXML;
	
КонецФункции

Функция ДанныеCMLПроизвольногоДокумента(ДанныеXML, ПараметрыДокумента = Неопределено) Экспорт
	
	ПотокИсходногоXML = ДанныеXML.ОткрытьПотокДляЧтения();
	
	ИсходныйФормат = Неопределено;
	ВариантЗаполнения = Неопределено;
	ОтражениеВУчете = Неопределено;
	Если ПараметрыДокумента = Неопределено 
		ИЛИ НЕ ПараметрыДокумента.Свойство("ИсходныйФормат", ИсходныйФормат)
		ИЛИ НЕ ЗначениеЗаполнено(ИсходныйФормат) Тогда
		ПараметрыФайлаXML = ПреобразоватьФорматЭД(ПотокИсходногоXML);
		Если ПараметрыФайлаXML = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		ПараметрыФайлаXML.Свойство("ИсходныйФормат", ИсходныйФормат);
		ПараметрыФайлаXML.Свойство("ВариантЗаполнения", ВариантЗаполнения);
		ПараметрыФайлаXML.Свойство("ОтражениеВУчете", ОтражениеВУчете);
		ПотокИсходногоXML.Перейти(0, ПозицияВПотоке.Начало);
	Иначе
		ПараметрыДокумента.Свойство("ИсходныйФормат", ИсходныйФормат);
		ПараметрыДокумента.Свойство("ВариантЗаполнения", ВариантЗаполнения);
		ПараметрыДокумента.Свойство("ОтражениеВУчете", ОтражениеВУчете);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИсходныйФормат) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтражениеВУчете)
		И ОтражениеВУчете.Свойство("Формат")
		И ОтражениеВУчете.Формат = "CML" Тогда
		ОтражениеВУчете.Свойство("ВариантЗаполнения", ВариантЗаполнения);
	КонецЕсли;
	
	ПараметрыПреобразования = Новый Структура;
	ПараметрыПреобразования.Вставить("ИтоговыйФормат", "CML");
	ПараметрыПреобразования.Вставить("ИсходныйФормат", ИсходныйФормат);
	Если ВариантЗаполнения <> Неопределено Тогда
		ПараметрыПреобразования.Вставить("ВариантЗаполнения", ВариантЗаполнения);
	КонецЕсли;
	
	Если ПараметрыДокумента <> Неопределено И ПараметрыДокумента.Свойство("ПараметрыОтражения") Тогда
		ПараметрыПреобразования.Вставить("ПараметрыXSL", ПараметрыДокумента.ПараметрыОтражения);
	КонецЕсли;
	
	ДанныеCML = ПреобразоватьФорматЭД(ПотокИсходногоXML, ПараметрыПреобразования);
	
	ПотокИсходногоXML.Закрыть();
	
	Возврат ДанныеCML;
	
КонецФункции

#Область ПоставляемыеДанные	
	
Процедура ПриРегистрацииОбработчиковПоставляемыхДанных(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ВидДанных = "ПравилаПреобразованияФорматовЭДО20";
	Обработчик.КодОбработчика = "ПравилаПреобразованияФорматовЭДО20";
	Обработчик.Обработчик = ОбщегоНазначения.ОбщийМодуль("КонвертацияЭДО");
	
КонецПроцедуры	


// Вызывается при отмене обработки данных в случае сбоя.
//
// Параметры:
//   Дескриптор - ОбъектXDTO - Descriptor.
//@skip-warning
Процедура ОбработкаДанныхОтменена(Знач Дескриптор) Экспорт

КонецПроцедуры

	
#КонецОбласти	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область КонвертерЭлектронныхДокументов

Функция ПредставлениеПроизвольногоДокумента(ФайлXML, ПараметрыДокумента, КонтекстДиагностики = Неопределено)
	
	ПараметрыПреобразования = Новый Структура;
	ПараметрыПреобразования.Вставить("ИтоговыйФормат", "ТабличныйДокумент");
	ПараметрыПреобразования.Вставить("ИсходныйФормат", ПараметрыДокумента.ИсходныйФормат);
	ВариантЗаполнения = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыДокумента, "ВариантЗаполнения", "");
	ПараметрыПреобразования.Вставить("ВариантЗаполнения", ВариантЗаполнения);
	Если ПараметрыДокумента.Свойство("ПараметрыПредставления") Тогда
		ПараметрыПреобразования.Вставить("ПараметрыXSL", ПараметрыДокумента.ПараметрыПредставления);
	КонецЕсли;
	
	Если ТипЗнч(ФайлXML) = Тип("Строка") Тогда
		ПотокИсходногоXML = Новый ФайловыйПоток(ФайлXML, РежимОткрытияФайла.Открыть);
	Иначе
		ПотокИсходногоXML = ФайлXML.ОткрытьПотокДляЧтения();
	КонецЕсли;
	
	ТабличныйДокумент = ПреобразоватьФорматЭД(ПотокИсходногоXML, ПараметрыПреобразования);
	
	ПотокИсходногоXML.Закрыть();
	
	РезультатФормирования = Новый Структура;
	РезультатФормирования.Вставить("ПредставлениеДокумента", ТабличныйДокумент);
	РезультатФормирования.Вставить("Успех", ТабличныйДокумент <> Неопределено);
	
	Возврат РезультатФормирования;
	
КонецФункции

Функция ИзвлечьПараметрыЭлектронногоДокумента(ДанныеЭлектронногоДокумента, КонтекстДиагностики = Неопределено)
	
	ПараметрыФайла = ПараметрыФайлаПроизвольногоДокумента(ДанныеЭлектронногоДокумента, КонтекстДиагностики);
	
	Если ПараметрыФайла <> Неопределено Тогда
		ПараметрыФайла.Вставить("ИтоговыйФормат", "ПараметрыЭлектронногоДокумента");
	КонецЕсли;
	
	Возврат ПреобразоватьФорматЭД(ДанныеЭлектронногоДокумента.ОткрытьПотокДляЧтения(), ПараметрыФайла, КонтекстДиагностики);
	
КонецФункции

Функция КонвертироватьЗначениеПоИнструкции(Инструкция)
	
	Результат = Неопределено;
	
	Если Инструкция.Правило = "СуммаПрописью" Тогда
		
		Если НЕ Инструкция.Свойство("СуммаДокумента")
			ИЛИ НЕ Инструкция.Свойство("КодВалюты") Тогда
			Возврат Результат;
		КонецЕсли;
		
		//ОбменСКонтрагентамиПереопределяемый.СуммаПрописью(Инструкция.СуммаДокумента, Инструкция.КодВалюты, Результат);
	КонецЕсли;
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		Результат = СтрШаблон("'%1'", Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЗначениеИзПотокаXML(ПотокXML, ТипЗначения, ПараметрыПреобразования, КонтекстДиагностики)
	
	ПотокXML.Перейти(0, ПозицияВПотоке.Начало);
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьПоток(ПотокXML);
	Попытка
		Результат = СериализаторXDTO.ПрочитатьXML(ЧтениеXML, ТипЗначения);
	Исключение
		Результат = Неопределено;
	КонецПопытки;
	
	ЧтениеXML.Закрыть();
	
	Возврат Результат;
	
КонецФункции

Функция ПроверитьЭлектронныйДокументПоСхемеXML(ПотокИсходногоXML, ПараметрыФайлаXML, КонтекстДиагностики = Неопределено)
	
	URIПространстваИмен = Неопределено;
	Если НЕ (ПараметрыФайлаXML.Свойство("ИсходныйФормат", URIПространстваИмен)
		И ЗначениеЗаполнено(URIПространстваИмен)) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИмяТипаXML = Неопределено;
	Если НЕ (ПараметрыФайлаXML.Свойство("ИмяТипаXML", ИмяТипаXML)
		И ЗначениеЗаполнено(ИмяТипаXML)) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Фабрика = КонвертацияЭДОПовтИсп.ФабрикаXDTOЭлектронногоДокумента(URIПространстваИмен);
	Если Фабрика = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТипЗначенияXDTO = Фабрика.Тип(URIПространстваИмен, ИмяТипаXML);
	Если ТипЗначенияXDTO = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПотокКонтрольногоXML = Новый ПотокВПамяти;
	
	ПотокИсходногоXML.Перейти(0, ПозицияВПотоке.Начало);
	
	Попытка
		ЧтениеИсходногоXML = Новый ЧтениеXML;
		ЧтениеИсходногоXML.ОткрытьПоток(ПотокИсходногоXML);
		
		ПостроительDOM = Новый ПостроительDOM;
		ДокументDOM = ПостроительDOM.Прочитать(ЧтениеИсходногоXML);
		ЧтениеИсходногоXML.Закрыть();
		
		ДокументDOM.ЭлементДокумента.УстановитьСоответствиеПространстваИмен("", URIПространстваИмен);
		
		ЗаписьКонтрольногоXML = Новый ЗаписьXML;
		ЗаписьКонтрольногоXML.ОткрытьПоток(ПотокКонтрольногоXML);
		
		ЗаписьDOM = Новый ЗаписьDOM;
		ЗаписьDOM.Записать(ДокументDOM, ЗаписьКонтрольногоXML);
		ЗаписьКонтрольногоXML.Закрыть();
		
		ПотокКонтрольногоXML.Перейти(0, ПозицияВПотоке.Начало);
		
		ЧтениеКонтрольногоXML = Новый ЧтениеXML;
		ЧтениеКонтрольногоXML.ОткрытьПоток(ПотокКонтрольногоXML);
		
		ИсходныйЭД = Фабрика.ПрочитатьXML(ЧтениеКонтрольногоXML, ТипЗначенияXDTO);
		
		Результат = Истина;
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	ЧтениеКонтрольногоXML.Закрыть();
	ПотокКонтрольногоXML.Закрыть();
	
	Возврат Результат;
	
КонецФункции

Функция ТекстПравилаПреобразованияФормата(ПараметрыПравила, КонтекстДиагностики = Неопределено) Экспорт
	
	ВерсияИтоговогоФормата = ПоддерживаемаяВерсияИтоговогоФормата(ПараметрыПравила.ИтоговыйФормат);
	
	Если ВерсияИтоговогоФормата = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыПравила.Вставить("ВерсияИтоговогоФормата", ВерсияИтоговогоФормата);
	
	Если НЕ ПараметрыПравила.Свойство("ВариантЗаполнения") Тогда
		ПараметрыПравила.Вставить("ВариантЗаполнения", "");
	КонецЕсли;
	
	РазделениеВыключено = НЕ ОбщегоНазначения.РазделениеВключено();
	
	Если РазделениеВыключено Тогда
		ОбновитьОписаниеФорматовДляПреобразования(КонтекстДиагностики);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ФорматыДляПреобразования.ДатаОбновленияПравил КАК ДатаОбновленияПравил,
		|	ФорматыДляПреобразования.СсылкаНаРесурс КАК СсылкаНаРесурс,
		|	ЕСТЬNULL(ПравилаПреобразованияФорматов.ДатаОбновления, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаОбновления,
		|	ЕСТЬNULL(ПравилаПреобразованияФорматов.Правило, НЕОПРЕДЕЛЕНО) КАК Правило
		|ИЗ
		|	РегистрСведений.ФорматыДляПреобразования КАК ФорматыДляПреобразования
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПравилаПреобразованияФорматов КАК ПравилаПреобразованияФорматов
		|		ПО ФорматыДляПреобразования.ИсходныйФормат = ПравилаПреобразованияФорматов.ИсходныйФормат
		|		И (ПравилаПреобразованияФорматов.ВариантЗаполнения = &ВариантЗаполнения)
		|		И (ПравилаПреобразованияФорматов.ИтоговыйФормат = &ИтоговыйФормат)
		|		И (ПравилаПреобразованияФорматов.ВерсияИтоговогоФормата = &ВерсияИтоговогоФормата)
		|ГДЕ
		|	ФорматыДляПреобразования.ИсходныйФормат = &ИсходныйФормат";
	
	Запрос.УстановитьПараметр("ИсходныйФормат",         ПараметрыПравила.ИсходныйФормат);
	Запрос.УстановитьПараметр("ВариантЗаполнения",      ПараметрыПравила.ВариантЗаполнения);
	Запрос.УстановитьПараметр("ИтоговыйФормат",         ПараметрыПравила.ИтоговыйФормат);
	Запрос.УстановитьПараметр("ВерсияИтоговогоФормата", ПараметрыПравила.ВерсияИтоговогоФормата);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ТекстПравила = Неопределено;
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Правило = Выборка.Правило;
		Если РазделениеВыключено И Выборка.ДатаОбновленияПравил > Выборка.ДатаОбновления Тогда
			ПараметрыПравила.Вставить("ДатаОбновления", Выборка.ДатаОбновления);
			ПараметрыПравила.Вставить("Правило", Правило);
			ТекстПравила = ОбновитьПравилоПреобразования(Выборка.СсылкаНаРесурс, ПараметрыПравила, КонтекстДиагностики);
			Если ТекстПравила = Неопределено И Правило <> Неопределено Тогда
				ТекстПравила = Правило.Получить();
			КонецЕсли;
		ИначеЕсли Правило = Неопределено Тогда

		Иначе
			ТекстПравила = Правило.Получить();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТекстПравила;
	
КонецФункции

Функция ПоддерживаемаяВерсияИтоговогоФормата(ИтоговыйФормат)
	
	Если ИтоговыйФормат = "ПараметрыЭлектронногоДокумента" Тогда
		Возврат "2.0";
	ИначеЕсли ИтоговыйФормат = "СхемаXML" Тогда
		Возврат "1.0";
	ИначеЕсли ИтоговыйФормат = "ТаблицаНоменклатуры" Тогда
		Возврат "1.0";
	ИначеЕсли ИтоговыйФормат = "ТабличныйДокумент" Тогда
		Возврат "1.0";
	ИначеЕсли ИтоговыйФормат = "CML" Тогда
		Возврат ФорматыЭДО_CML.ВерсияСхемыCML208();
	КонецЕсли;
	
КонецФункции

Процедура ОбновитьОписаниеФорматовДляПреобразования(КонтекстДиагностики, ПараметрыНачальногоЗаполнения = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	ДатаЗагрузкиОписанияФорматов = Константы.ДатаЗагрузкиОписанияФорматовДляПреобразования.Получить();
	ТекущаяУниверсальнаяДата = НачалоДня(ТекущаяУниверсальнаяДата());
	Если ТекущаяУниверсальнаяДата = ДатаЗагрузкиОписанияФорматов Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФорматыДляПреобразования.ИсходныйФормат КАК ИсходныйФормат,
		|	ФорматыДляПреобразования.ДатаОбновленияПравил КАК ДатаОбновленияПравил,
		|	ФорматыДляПреобразования.СсылкаНаРесурс КАК СсылкаНаРесурс,
		|	ЛОЖЬ КАК Обработан
		|ИЗ
		|	РегистрСведений.ФорматыДляПреобразования КАК ФорматыДляПреобразования";
	
	ТаблицаФорматов = Запрос.Выполнить().Выгрузить();
	
	Если ЗначениеЗаполнено(ПараметрыНачальногоЗаполнения) Тогда
		ДанныеФайла = Новый ДвоичныеДанные(ПараметрыНачальногоЗаполнения.Каталог + "supported_formats_v20.xml");
		ПотокФайла = ДанныеФайла.ОткрытьПотокДляЧтения();
	Иначе
		URL = АдресФайлаПравилДляПреобразованияФорматов();
		ПотокФайла = ОткрытьПотокДляЧтенияФайлаИзИнтернета(URL, КонтекстДиагностики);
	КонецЕсли;
	
	Если ПотокФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьПоток(ПотокФайла);
	Пока ЧтениеXML.Прочитать() Цикл
		Если ЧтениеXML.Имя <> "fmt" Тогда
			Продолжить;
		КонецЕсли;
		
		НайденныйФормат = ТаблицаФорматов.Найти(ЧтениеXML.ЗначениеАтрибута("id"), "ИсходныйФормат");
		Если НайденныйФормат = Неопределено
			ИЛИ Дата(ЧтениеXML.ЗначениеАтрибута("upd")) > НайденныйФормат.ДатаОбновленияПравил
			ИЛИ ЧтениеXML.ЗначениеАтрибута("src") <> НайденныйФормат.СсылкаНаРесурс Тогда
			
			МенеджерЗаписи = РегистрыСведений.ФорматыДляПреобразования.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ИсходныйФормат       = ЧтениеXML.ЗначениеАтрибута("id");
			МенеджерЗаписи.ДатаОбновленияПравил = Дата(ЧтениеXML.ЗначениеАтрибута("upd"));
			МенеджерЗаписи.СсылкаНаРесурс       = ЧтениеXML.ЗначениеАтрибута("src");
			МенеджерЗаписи.Записать();
			
			Если ЗначениеЗаполнено(ПараметрыНачальногоЗаполнения) Тогда
				
				ПараметрыПравила = Новый Структура;
				
				ПараметрыПравила.Вставить("ИсходныйФормат", ЧтениеXML.ЗначениеАтрибута("id"));
				ПараметрыПравила.Вставить("ВариантЗаполнения", ЧтениеXML.ЗначениеАтрибута("type"));      
				ПараметрыПравила.Вставить("ИтоговыйФормат", ЧтениеXML.ЗначениеАтрибута("out"));          
				ПараметрыПравила.Вставить("ВерсияИтоговогоФормата", ЧтениеXML.ЗначениеАтрибута("ver"));  
				ПараметрыПравила.Вставить("ДатаОбновления", Дата(ЧтениеXML.ЗначениеАтрибута("upd"))); 
				
				СсылкаНаРесурс = ПараметрыНачальногоЗаполнения.Каталог + МенеджерЗаписи.СсылкаНаРесурс; 
				
				ОбновитьПравилоПреобразования(
					СсылкаНаРесурс, ПараметрыПравила, КонтекстДиагностики, ПараметрыНачальногоЗаполнения);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если НайденныйФормат <> Неопределено Тогда
			НайденныйФормат.Обработан = Истина;
		КонецЕсли;
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	ПотокФайла.Закрыть();
	
	ПараметрыОтбора = Новый Структура("Обработан", Ложь);
	МассивКУдалению = ТаблицаФорматов.НайтиСтроки(ПараметрыОтбора);
	Если МассивКУдалению.Количество() Тогда
		Для Каждого СтрокаТаблицы Из МассивКУдалению Цикл
			УдалитьДанныеИсходногоФормата(СтрокаТаблицы.ИсходныйФормат, КонтекстДиагностики);
		КонецЦикла;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыНачальногоЗаполнения) Тогда		
		Константы.ДатаЗагрузкиОписанияФорматовДляПреобразования.Установить(ТекущаяУниверсальнаяДата);
	КонецЕсли;
	
КонецПроцедуры

Функция ОбновитьПравилоПреобразования(СсылкаНаОписаниеФормата, ПараметрыПравила, КонтекстДиагностики, ПараметрыНачальногоЗаполнения = Неопределено)
	
	НачальноеЗаполнение = ЗначениеЗаполнено(ПараметрыНачальногоЗаполнения);
	
	Если НачальноеЗаполнение Тогда
		ДанныеФайла = Новый ДвоичныеДанные(СсылкаНаОписаниеФормата);
		ПотокФайла = ДанныеФайла.ОткрытьПотокДляЧтения();
	Иначе
		URL = АдресФайлаПравилДляПреобразованияФорматов(СсылкаНаОписаниеФормата);
		ПотокФайла = ОткрытьПотокДляЧтенияФайлаИзИнтернета(URL, КонтекстДиагностики);
	КонецЕсли;
	
	Если ПотокФайла = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекстПравила = Неопределено;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьПоток(ПотокФайла);
	
	Пока ЧтениеXML.Прочитать() Цикл
		Если ЧтениеXML.Имя = "convertion-rules" Тогда
			Если ЧтениеXML.ЗначениеАтрибута("fmt") <> ПараметрыПравила.ИсходныйФормат Тогда
				ЧтениеXML.Закрыть();
				ПотокФайла.Закрыть();
				Возврат Неопределено;
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Пока ЧтениеXML.Прочитать() Цикл
		Если ЧтениеXML.Имя <> "rule" Тогда
			Продолжить;
		КонецЕсли;
		
		Если НачальноеЗаполнение
		  Или ПараметрыПравила.ВариантЗаполнения      = ЧтениеXML.ЗначениеАтрибута("type")
			И ПараметрыПравила.ИтоговыйФормат         = ЧтениеXML.ЗначениеАтрибута("out")
			И ПараметрыПравила.ВерсияИтоговогоФормата = ЧтениеXML.ЗначениеАтрибута("ver") Тогда
			
			Если Не НачальноеЗаполнение И ПараметрыПравила.ДатаОбновления > Дата(ЧтениеXML.ЗначениеАтрибута("upd")) Тогда
				Правило = ПараметрыПравила.Правило;
				ТекстПравила = Правило.Получить();
			Иначе
				
				Если НачальноеЗаполнение Тогда
					ДанныеФайлаПравил = Новый ДвоичныеДанные(ПараметрыНачальногоЗаполнения.Каталог + ЧтениеXML.ЗначениеАтрибута("src"));
					ПотокФайлаПравил = ДанныеФайлаПравил.ОткрытьПотокДляЧтения();
				Иначе
					URL = АдресФайлаПравилДляПреобразованияФорматов(ЧтениеXML.ЗначениеАтрибута("src"));
					ПотокФайлаПравил = ОткрытьПотокДляЧтенияФайлаИзИнтернета(URL, КонтекстДиагностики);
				КонецЕсли;
				
				Если ПотокФайлаПравил = Неопределено Тогда
					Прервать;
				КонецЕсли;
				
				ЧтениеТекстаПравил = Новый ЧтениеТекста(ПотокФайлаПравил, "UTF-8");
				ТекстПравила = ЧтениеТекстаПравил.Прочитать();
				Правило = Новый ХранилищеЗначения(ТекстПравила, Новый СжатиеДанных());
				
				ЧтениеТекстаПравил.Закрыть();
				ПотокФайлаПравил.Закрыть();
			КонецЕсли;
			
			МенеджерЗаписи = РегистрыСведений.ПравилаПреобразованияФорматов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ИсходныйФормат         = ПараметрыПравила.ИсходныйФормат;
			МенеджерЗаписи.ВариантЗаполнения      = ЧтениеXML.ЗначениеАтрибута("type");
			МенеджерЗаписи.ИтоговыйФормат         = ЧтениеXML.ЗначениеАтрибута("out");
			МенеджерЗаписи.ВерсияИтоговогоФормата = ЧтениеXML.ЗначениеАтрибута("ver");
			МенеджерЗаписи.ДатаОбновления         = Дата(ЧтениеXML.ЗначениеАтрибута("upd"));
			МенеджерЗаписи.Правило                = Правило;
			
			УстановитьПривилегированныйРежим(Истина);
			МенеджерЗаписи.Записать();
			УстановитьПривилегированныйРежим(Ложь);
			
			Если Не НачальноеЗаполнение Тогда
				Прервать;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	ПотокФайла.Закрыть();
	
	Если ТекстПравила = Неопределено Тогда
		
	КонецЕсли;
	
	Возврат ТекстПравила;
	
КонецФункции

Функция ОткрытьПотокДляЧтенияФайлаИзИнтернета(URL, КонтекстДиагностики)
	
	//РезультатПолученияФайла = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(URL, Неопределено, Ложь);
	//Если НЕ РезультатПолученияФайла.Статус Тогда

	//	Возврат Неопределено;
	//	
	//КонецЕсли;
	//
	//ДанныеФайла = ПолучитьИзВременногоХранилища(РезультатПолученияФайла.Путь);
	//УдалитьИзВременногоХранилища(РезультатПолученияФайла.Путь);
	//
	//Возврат ДанныеФайла.ОткрытьПотокДляЧтения();
	
КонецФункции

Процедура УдалитьДанныеИсходногоФормата(ИсходныйФормат, КонтекстДиагностики)
	
	НачатьТранзакцию();
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.ФорматыДляПреобразования");
		ЭлементБлокировкиДанных.УстановитьЗначение("ИсходныйФормат", ИсходныйФормат);
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.ПравилаПреобразованияФорматов");
		ЭлементБлокировкиДанных.УстановитьЗначение("ИсходныйФормат", ИсходныйФормат);
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		
		БлокировкаДанных.Заблокировать();
		
		МенеджерЗаписи = РегистрыСведений.ФорматыДляПреобразования.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ИсходныйФормат = ИсходныйФормат;
		МенеджерЗаписи.Удалить();
		
		НаборЗаписей = РегистрыСведений.ПравилаПреобразованияФорматов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИсходныйФормат.Установить(ИсходныйФормат);
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();		

	КонецПопытки;
	
КонецПроцедуры

Функция АдресФайлаПравилДляПреобразованияФорматов(СсылкаНаРесурс = "")
	
	АдресПравилПреобразования = СинхронизацияЭДО.АдресОблачногоХранилищаНастроек()
		+ "/format_conversion_rules/";
	
	Если ПустаяСтрока(СсылкаНаРесурс) Тогда
		СсылкаНаРесурс = "supported_formats_v20.xml";
	КонецЕсли;
	
	Возврат АдресПравилПреобразования + СсылкаНаРесурс;
	
КонецФункции

Функция ПараметрыПреобразованияВСтроку(Параметры)
	
	Если Параметры = Неопределено Тогда
		Результат = НСтр("ru = 'ИсходныйФормат=ПроизвольныйXML;
			|ИтоговыйФормат=ПараметрыЭлектронногоДокумента;
			|ВерсияИтоговогоФормата='") + ПоддерживаемаяВерсияИтоговогоФормата("ПараметрыЭлектронногоДокумента");
		Возврат Результат;
	КонецЕсли;
	
	МассивСтрок = Новый Массив;
	
	ЗначениеСвойства="";
	
	Если Параметры.Свойство("ИсходныйФормат", ЗначениеСвойства) И ЗначениеЗаполнено(ЗначениеСвойства) Тогда
		МассивСтрок.Добавить(НСтр("ru = 'ИсходныйФормат='") + ЗначениеСвойства);
	КонецЕсли;
	
	Если Параметры.Свойство("ВариантЗаполнения", ЗначениеСвойства) И ЗначениеЗаполнено(ЗначениеСвойства) Тогда
		МассивСтрок.Добавить(НСтр("ru = 'ВариантЗаполнения='") + ЗначениеСвойства);
	КонецЕсли;
	
	Если Параметры.Свойство("ИтоговыйФормат", ЗначениеСвойства) И ЗначениеЗаполнено(ЗначениеСвойства) Тогда
		МассивСтрок.Добавить(НСтр("ru = 'ИтоговыйФормат='") + ЗначениеСвойства);
	КонецЕсли;
	
	МассивСтрок.Добавить(НСтр("ru = 'ВерсияИтоговогоФормата='") + ПоддерживаемаяВерсияИтоговогоФормата(ЗначениеСвойства));
	
	ПараметрыXSL = Новый Структура;
	
	Если Параметры.Свойство("ПараметрыXSL", ПараметрыXSL) И ЗначениеЗаполнено(ПараметрыXSL) Тогда
		МассивСтрок.Добавить(НСтр("ru = 'ПараметрыXSL:'"));
		
		Для Каждого ПараметрXSL Из ПараметрыXSL Цикл
			
			Если ТипЗнч(ПараметрXSL.Значение) = Тип("Структура") Тогда
				МассивСтрок.Добавить(ПараметрXSL.Ключ + ":");
				Для Каждого ПараметрИнструкции Из ПараметрXSL.Значение Цикл
					МассивСтрок.Добавить(Символы.Таб + СтрШаблон(НСтр("ru = '%1=%2'"),
						ПараметрИнструкции.Ключ, ПараметрИнструкции.Значение));
				КонецЦикла;
			Иначе
				МассивСтрок.Добавить(СтрШаблон(НСтр("ru = '%1=%2'"), ПараметрXSL.Ключ, ПараметрXSL.Значение));
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СтрСоединить(МассивСтрок, Символы.ПС);
	
КонецФункции

#КонецОбласти

#КонецОбласти