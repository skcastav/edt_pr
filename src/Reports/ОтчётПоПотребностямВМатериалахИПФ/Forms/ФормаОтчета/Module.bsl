
&НаСервере
Перем оптМВТ, оптЗапросНорм, оптСоотРезультатов;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Отчет.Период.ДатаНачала = НачалоМесяца(ТекущаяДата());
Отчет.Период.ДатаОкончания = КонецГода(ТекущаяДата());
ТипСправочника = 1;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
Элементы.СписокГруппМПЗ.Видимость = ?(ТипСправочника = 1,Истина,Ложь);
Элементы.СписокВидовКанбанов.Видимость = ?(ТипСправочника = 1,Ложь,Истина);
КонецПроцедуры
         
&НаСервере
Процедура ДобавитьМПЗ(ТаблицаМПЗ,ТаблицаАналоговМПЗ,Номенклатура,НормРасх,Количество,КолУзла,Знач МПЗ = Неопределено,ДатаС,ДатаПо)
	Если МПЗ = Неопределено Тогда 
	МПЗ = ОбщегоНазначенияПовтИсп.ПолучитьЗначениеРеквизита(НормРасх,"Элемент");
	КонецЕсли;	
Выборка = ТаблицаМПЗ.НайтиСтроки(Новый Структура("МПЗ",МПЗ));
	Если Выборка.Количество() = 0 Тогда 
	ТЧ = ТаблицаМПЗ.Добавить();
	ТЧ.МПЗ = МПЗ;
		Если ТипСправочника = 1 Тогда
		ТЧ.ГруппаМПЗ = МПЗ.Родитель;
		Иначе
		ТЧ.ГруппаМПЗ = МПЗ.Канбан;
		КонецЕсли;
	ТЧ.ТаблицаНоменклатуры.Колонки.Добавить("Номенклатура");
	ТЧ.ТаблицаНоменклатуры.Индексы.Добавить("Номенклатура");
	ТЧ.ТаблицаНоменклатуры.Колонки.Добавить("Количество");
	ТЧ.ТаблицаНоменклатуры.Колонки.Добавить("ДатаС");
	ТЧ.ТаблицаНоменклатуры.Колонки.Добавить("ДатаПо") 	
	Иначе
	ТЧ = Выборка[0];
	КонецЕсли;
Выборка = ТЧ.ТаблицаНоменклатуры.НайтиСтроки(Новый Структура("Номенклатура,ДатаС,ДатаПо",Номенклатура,ДатаС,ДатаПо));
	Если Выборка.Количество() = 0 Тогда
	ТЧ_Ном = ТЧ.ТаблицаНоменклатуры.Добавить();
	ТЧ_Ном.Номенклатура = Номенклатура;
	ТЧ_Ном.Количество = Количество;
	ТЧ_Ном.ДатаС = ДатаС;	
	ТЧ_Ном.ДатаПо = ДатаПо;
	Иначе
	Выборка[0].Количество = Выборка[0].Количество + Количество;
	КонецЕсли;
ТаблицаАналогов = ОбщегоНазначенияПовтИсп.ПолучитьАналогиНормРасходов(НормРасх);
	Для каждого ТЧ_ТА Из ТаблицаАналогов Цикл 
		Если ТипЗнч(ТЧ_ТА.Ссылка.Элемент) = Тип("СправочникСсылка.Материалы") Тогда
		Аналог = ТЧ_ТА.Ссылка.Элемент;
		Выборка = ТаблицаАналоговМПЗ.НайтиСтроки(Новый Структура("МПЗ,АналогМПЗ",МПЗ,Аналог));
			Если Выборка.Количество() = 0 Тогда
			ТЧ = ТаблицаАналоговМПЗ.Добавить();
			ТЧ.МПЗ = МПЗ;
			ТЧ.АналогМПЗ = Аналог;
			ТЧ.ТаблицаНоменклатуры.Колонки.Добавить("Номенклатура");
			ТЧ.ТаблицаНоменклатуры.Индексы.Добавить("Номенклатура");
			ТЧ.ТаблицаНоменклатуры.Колонки.Добавить("Количество");
			ТЧ.ТаблицаНоменклатуры.Колонки.Добавить("ДатаС");
			ТЧ.ТаблицаНоменклатуры.Колонки.Добавить("ДатаПо");
			Иначе
			ТЧ = Выборка[0];
			КонецЕсли;
		Выборка = ТЧ.ТаблицаНоменклатуры.НайтиСтроки(Новый Структура("Номенклатура,ДатаС,ДатаПо",Номенклатура,ДатаС,ДатаПо));
			Если Выборка.Количество() = 0 Тогда
			ТЧ_Ном = ТЧ.ТаблицаНоменклатуры.Добавить();
			ТЧ_Ном.Номенклатура = Номенклатура;
			ТЧ_Ном.Количество = ОбщегоНазначенияПовтИсп.ПолучитьБазовоеКоличествоБезОкругленияПИ(ТЧ_ТА.Норма,Аналог.ОсновнаяЕдиницаИзмерения)*КолУзла;
			ТЧ_Ном.ДатаС = ДатаС;	
			ТЧ_Ном.ДатаПо = ДатаПо;
			Иначе
			Выборка[0].Количество = Выборка[0].Количество + ОбщегоНазначенияПовтИсп.ПолучитьБазовоеКоличествоБезОкругленияПИ(ТЧ_ТА.Норма,Аналог.ОсновнаяЕдиницаИзмерения)*КолУзла;
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла;	
КонецПроцедуры 

&НаСервере
Процедура РаскрытьНаМПЗ(ТаблицаМПЗ,ТаблицаАналоговМПЗ,Номенклатура,ЭтапСпецификации,КолУзла,ДатаС,ДатаПо)
	Если оптМВТ = Неопределено Тогда
	оптМВТ = Новый МенеджерВременныхТаблиц;
	оптЗапрос = Новый Запрос;
	оптЗапрос.УстановитьПараметр("НаДату", ТекущаяДата());
	оптЗапрос.МенеджерВременныхТаблиц = оптМВТ;
	оптЗапрос.Текст = 			
		"ВЫБРАТЬ
  		|	Т.НормаРасходов КАК НормаРасходов,
  		|	Т.Норма КАК Норма
  		|ПОМЕСТИТЬ втНРСрезПоследних
  		|ИЗ
  		|	РегистрСведений.НормыРасходов.СрезПоследних(
  		|			&НаДату,
  		|			ТИПЗНАЧЕНИЯ(НормаРасходов.Элемент) = ТИП(Справочник.Номенклатура)
  		|				ИЛИ ТИПЗНАЧЕНИЯ(НормаРасходов.Элемент) = ТИП(Справочник.Материалы)) КАК Т
  		|ГДЕ
  		|	Т.Норма > 0
  		|
  		|ИНДЕКСИРОВАТЬ ПО
  		|	НормаРасходов";
	оптЗапрос.Выполнить();
	КонецЕсли;
		Если оптЗапросНорм = Неопределено Тогда
		оптЗапросНорм = Новый Запрос;
		оптЗапросНорм.МенеджерВременныхТаблиц = оптМВТ;
		оптЗапросНорм.Текст = 
			"ВЫБРАТЬ
			|	НормыРасходов.Ссылка КАК Ссылка,
			|	НормыРасходов.Элемент КАК Элемент,
			|	НормыРасходов.Элемент.ОсновнаяЕдиницаИзмерения КАК ЭлементОЕИ,
			|	НормыРасходовСрезПоследних.Норма КАК Норма
			|ИЗ
			|	втНРСрезПоследних КАК НормыРасходовСрезПоследних
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НормыРасходов КАК НормыРасходов
			|		ПО НормыРасходовСрезПоследних.НормаРасходов = НормыРасходов.Ссылка
			|ГДЕ
			|	НормыРасходов.ПометкаУдаления = ЛОЖЬ
			|	И НормыРасходов.Владелец = &Владелец
			|	И (ТИПЗНАЧЕНИЯ(НормыРасходов.Элемент) = ТИП(Справочник.Номенклатура)
			|			ИЛИ ТИПЗНАЧЕНИЯ(НормыРасходов.Элемент) = ТИП(Справочник.Материалы))";
		КонецЕсли;
			Если оптСоотРезультатов = Неопределено Тогда
			оптСоотРезультатов = Новый Соответствие;
			КонецЕсли;
				Если оптСоотРезультатов.Получить(ЭтапСпецификации) = Неопределено Тогда 
				Запрос = оптЗапросНорм;
				Запрос.УстановитьПараметр("Владелец", ЭтапСпецификации);
				РезультатЗапроса = Запрос.Выполнить();
				оптСоотРезультатов.Вставить(ЭтапСпецификации, РезультатЗапроса);
				Иначе
				РезультатЗапроса = оптСоотРезультатов[ЭтапСпецификации];
				КонецЕсли;
ВыборкаНР = РезультатЗапроса.Выбрать();
	Пока ВыборкаНР.Следующий() Цикл 
	БазовоеКоличество = ОбщегоНазначенияПовтИсп.ПолучитьБазовоеКоличествоБезОкругленияПИ(ВыборкаНР.Норма,ВыборкаНР.ЭлементОЕИ);
		Если ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Материалы") Тогда
			Если СписокГруппМПЗ.Количество() > 0 Тогда
				Если Не ОбщийМодульВызовСервера.ПринадлежитСпискуГруппМПЗ(ВыборкаНР.Элемент,СписокГруппМПЗ) Тогда
				Продолжить;
				КонецЕсли;					
			КонецЕсли;
		ДобавитьМПЗ(ТаблицаМПЗ,ТаблицаАналоговМПЗ,Номенклатура,ВыборкаНР.Ссылка,БазовоеКоличество*КолУзла,КолУзла, ВыборкаНР.Элемент,ДатаС,ДатаПо);  					
		Иначе
		Результат = ОбщийМодульРаботаСРегистрами.ПолучитьПФРедизайна(Номенклатура,ВыборкаНР.Элемент);
			Если Результат <> Неопределено Тогда
			ДатаПоНовая = НачалоМесяца(Результат.ДатаС-1);
			Иначе
			ДатаПоНовая = ДатаПо;
			КонецЕсли;
		РаскрытьНаМПЗ(ТаблицаМПЗ,ТаблицаАналоговМПЗ,Номенклатура,ВыборкаНР.Элемент,БазовоеКоличество*КолУзла,ДатаС,ДатаПоНовая);
			Если Результат <> Неопределено Тогда
			РаскрытьНаМПЗ(ТаблицаМПЗ,ТаблицаАналоговМПЗ,Номенклатура,Результат.ЭлементНовый,БазовоеКоличество*КолУзла,Результат.ДатаС,ДатаПо);
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура РаскрытьНаКанбаны(ТаблицаМПЗ,ТаблицаАналоговМПЗ,Номенклатура,ЭтапСпецификации,КолУзла,ДатаС,ДатаПо)
	Если оптМВТ = Неопределено Тогда
	оптМВТ = Новый МенеджерВременныхТаблиц;
	оптЗапрос = Новый Запрос;
	оптЗапрос.УстановитьПараметр("НаДату", ТекущаяДата());
	оптЗапрос.МенеджерВременныхТаблиц = оптМВТ;
	оптЗапрос.Текст = 			
		"ВЫБРАТЬ
		|	Т.НормаРасходов КАК НормаРасходов,
		|	Т.Норма КАК Норма
		|ПОМЕСТИТЬ втНРСрезПоследних
		|ИЗ
		|	РегистрСведений.НормыРасходов.СрезПоследних(&НаДату, ТИПЗНАЧЕНИЯ(НормаРасходов.Элемент) = ТИП(Справочник.Номенклатура)) КАК Т
		|ГДЕ
		|	Т.Норма > 0
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	НормаРасходов";
	оптЗапрос.Выполнить();
	КонецЕсли;
		Если оптЗапросНорм = Неопределено Тогда
		оптЗапросНорм = Новый Запрос;
		оптЗапросНорм.МенеджерВременныхТаблиц = оптМВТ;
		оптЗапросНорм.Текст = 
			"ВЫБРАТЬ
			|	НормыРасходов.Ссылка КАК Ссылка,
			|	НормыРасходов.Элемент КАК Элемент,
			|	НормыРасходов.Элемент.ОсновнаяЕдиницаИзмерения КАК ЭлементОЕИ,
			|	НормыРасходовСрезПоследних.Норма КАК Норма
			|ИЗ
			|	втНРСрезПоследних КАК НормыРасходовСрезПоследних
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НормыРасходов КАК НормыРасходов
			|		ПО НормыРасходовСрезПоследних.НормаРасходов = НормыРасходов.Ссылка
			|ГДЕ
			|	НормыРасходов.ПометкаУдаления = ЛОЖЬ
			|	И НормыРасходов.Владелец = &Владелец
			|	И ТИПЗНАЧЕНИЯ(НормыРасходов.Элемент) = ТИП(Справочник.Номенклатура)";
		КонецЕсли;
			Если оптСоотРезультатов = Неопределено Тогда
			оптСоотРезультатов = Новый Соответствие;
			КонецЕсли;
				Если оптСоотРезультатов.Получить(ЭтапСпецификации) = Неопределено Тогда 
				Запрос = оптЗапросНорм;
				Запрос.УстановитьПараметр("Владелец", ЭтапСпецификации);
				РезультатЗапроса = Запрос.Выполнить();
				оптСоотРезультатов.Вставить(ЭтапСпецификации, РезультатЗапроса);
				Иначе
				РезультатЗапроса = оптСоотРезультатов[ЭтапСпецификации];
				КонецЕсли;
ВыборкаНР = РезультатЗапроса.Выбрать();
	Пока ВыборкаНР.Следующий() Цикл
	БазовоеКоличество = ОбщегоНазначенияПовтИсп.ПолучитьБазовоеКоличествоБезОкругленияПИ(ВыборкаНР.Норма,ВыборкаНР.ЭлементОЕИ);
		Если Не ВыборкаНР.Элемент.Канбан.Пустая() Тогда
			Если СписокВидовКанбанов.Количество() > 0 Тогда
				Если СписокВидовКанбанов.НайтиПоЗначению(ВыборкаНР.Элемент.Канбан) <> Неопределено Тогда
				ДобавитьМПЗ(ТаблицаМПЗ,ТаблицаАналоговМПЗ,Номенклатура,ВыборкаНР.Ссылка,БазовоеКоличество*КолУзла,КолУзла, ВыборкаНР.Элемент,ДатаС,ДатаПо);  					
				КонецЕсли;
			Иначе
			ДобавитьМПЗ(ТаблицаМПЗ,ТаблицаАналоговМПЗ,Номенклатура,ВыборкаНР.Ссылка,БазовоеКоличество*КолУзла,КолУзла, ВыборкаНР.Элемент,ДатаС,ДатаПо);  					
			КонецЕсли;
		КонецЕсли;
	Результат = ОбщийМодульРаботаСРегистрами.ПолучитьПФРедизайна(Номенклатура,ВыборкаНР.Элемент);
		Если Результат <> Неопределено Тогда
		ДатаПоНовая = НачалоМесяца(Результат.ДатаС-1);
		Иначе
		ДатаПоНовая = ДатаПо;
		КонецЕсли;
	РаскрытьНаКанбаны(ТаблицаМПЗ,ТаблицаАналоговМПЗ,Номенклатура,ВыборкаНР.Элемент,БазовоеКоличество*КолУзла,ДатаС,ДатаПоНовая);
		Если Результат <> Неопределено Тогда
		РаскрытьНаКанбаны(ТаблицаМПЗ,ТаблицаАналоговМПЗ,Номенклатура,Результат.ЭлементНовый,БазовоеКоличество*КолУзла,Результат.ДатаС,ДатаПо);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();

ТаблицаМПЗ = Новый ТаблицаЗначений;

ТаблицаМПЗ.Колонки.Добавить("МПЗ");
ТаблицаМПЗ.Индексы.Добавить("МПЗ");
ТаблицаМПЗ.Колонки.Добавить("ГруппаМПЗ");
ТаблицаМПЗ.Колонки.Добавить("ГруппаПоЗакупкам");
ТаблицаМПЗ.Колонки.Добавить("КоличествоОстаток");
ТаблицаМПЗ.Колонки.Добавить("НаличиеДоговора");
ТаблицаМПЗ.Колонки.Добавить("ТаблицаНоменклатуры",Новый ОписаниеТипов("ТаблицаЗначений"));

ТаблицаАналоговМПЗ = Новый ТаблицаЗначений;

ТаблицаАналоговМПЗ.Колонки.Добавить("МПЗ");
ТаблицаАналоговМПЗ.Индексы.Добавить("МПЗ");
ТаблицаАналоговМПЗ.Колонки.Добавить("АналогМПЗ");
ТаблицаАналоговМПЗ.Колонки.Добавить("КоличествоОстаток");
ТаблицаАналоговМПЗ.Колонки.Добавить("НаличиеДоговора");
ТаблицаАналоговМПЗ.Колонки.Добавить("ТаблицаНоменклатуры",Новый ОписаниеТипов("ТаблицаЗначений"));

	Если ТипСправочника = 1 Тогда
		Для каждого ТЧ Из ЭтаФорма.Номенклатура Цикл
		РаскрытьНаМПЗ(ТаблицаМПЗ,ТаблицаАналоговМПЗ,ТЧ.Номенклатура,ТЧ.Номенклатура,1,Отчет.Период.ДатаНачала,Отчет.Период.ДатаОкончания);
		КонецЦикла;		
	Иначе
		Для каждого ТЧ Из ЭтаФорма.Номенклатура Цикл	
		РаскрытьНаКанбаны(ТаблицаМПЗ,ТаблицаАналоговМПЗ,ТЧ.Номенклатура,ТЧ.Номенклатура,1,Отчет.Период.ДатаНачала,Отчет.Период.ДатаОкончания);		
		КонецЦикла;
	КонецЕсли;
ТаблицаМПЗ.Сортировать("ГруппаМПЗ,МПЗ"); 
ТаблицаАналоговМПЗ.Сортировать("МПЗ,АналогМПЗ");
СписокМПЗ = Новый СписокЗначений;

	Для каждого ТЧ Из ТаблицаМПЗ Цикл
	СписокМПЗ.Добавить(ТЧ.МПЗ);
	КонецЦикла;
		Для каждого ТЧ Из ТаблицаАналоговМПЗ Цикл
			Если СписокМПЗ.НайтиПоЗначению(ТЧ.МПЗ) = Неопределено Тогда
			СписокМПЗ.Добавить(ТЧ.МПЗ);
			КонецЕсли; 
		КонецЦикла; 

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапкаОбщая = Макет.ПолучитьОбласть("Шапка|Общая");
ОблШапкаПериод = Макет.ПолучитьОбласть("Шапка|Период");
ОблШапкаИтого = Макет.ПолучитьОбласть("Шапка|Итого");
ОблМПЗОбщая = Макет.ПолучитьОбласть("МПЗ|Общая");
ОблМПЗПериод = Макет.ПолучитьОбласть("МПЗ|Период");
ОблМПЗИтого = Макет.ПолучитьОбласть("МПЗ|Итого");
ОблАналогОбщая = Макет.ПолучитьОбласть("Аналог|Общая");
ОблАналогПериод = Макет.ПолучитьОбласть("Аналог|Период");
ОблАналогИтого = Макет.ПолучитьОбласть("Аналог|Итого");
ОблКонецОбщая = Макет.ПолучитьОбласть("Конец|Общая");
ОблКонецПериод = Макет.ПолучитьОбласть("Конец|Период");
ОблКонецИтого = Макет.ПолучитьОбласть("Конец|Итого");

ЭтаФорма_Номенклатура = РеквизитФормыВЗначение("Номенклатура"); // оптимизация
ЭтаФорма_Номенклатура.Индексы.Добавить("Номенклатура");

ТабДок.Вывести(ОблШапкаОбщая);
	Для Каждого Стр Из СписокПериодов Цикл
	ОблШапкаПериод.Параметры.ММГГ = Формат(Стр.Значение,"ДФ=MM.yy");
	ТабДок.Присоединить(ОблШапкаПериод);
	КонецЦикла;	
ТабДок.Присоединить(ОблШапкаИтого);
	Для каждого ТЧ Из ТаблицаМПЗ Цикл
	КоличествоРасходИтого = 0;
	ОблМПЗОбщая.Параметры.Наименование = СокрЛП(ТЧ.МПЗ.Наименование); 
	ОблМПЗОбщая.Параметры.МПЗ = ТЧ.МПЗ;
	ОблМПЗОбщая.Параметры.ЕдиницаИзмерения = ТЧ.МПЗ.ЕдиницаИзмерения;
	ОблМПЗОбщая.Параметры.ГруппаМПЗ = СокрЛП(ТЧ.ГруппаМПЗ.Наименование);
	ТабДок.Вывести(ОблМПЗОбщая);
	НомСтр = 1;
		Для Каждого Стр Из СписокПериодов Цикл
		КоличествоРасход = 0;
			Для Каждого ТЧ_Ном Из ТЧ.ТаблицаНоменклатуры Цикл			
			Выборка = ЭтаФорма_Номенклатура.НайтиСтроки(Новый Структура("Номенклатура",ТЧ_Ном.Номенклатура));
				Для к = 0 по Выборка.ВГраница() Цикл
					Если (Стр.Значение>=ТЧ_Ном.ДатаС)и(Стр.Значение<=ТЧ_Ном.ДатаПо) Тогда
					КоличествоРасход = КоличествоРасход + Выборка[к]["Д"+НомСтр]*ТЧ_Ном.Количество;
					КоличествоРасходИтого = КоличествоРасходИтого + Выборка[к]["Д"+НомСтр]*ТЧ_Ном.Количество;										
					КонецЕсли;
				КонецЦикла; 
			КонецЦикла;
 		ОблМПЗПериод.Параметры.КоличествоРасход = КоличествоРасход;
		ТабДок.Присоединить(ОблМПЗПериод);
		НомСтр = НомСтр + 1;
		КонецЦикла;
	ОблМПЗИтого.Параметры.КоличествоИтого = КоличествоРасходИтого;
	ТабДок.Присоединить(ОблМПЗИтого);
	ВыборкаАналоги = ТаблицаАналоговМПЗ.НайтиСтроки(Новый Структура("МПЗ",ТЧ.МПЗ));
		Если ВыборкаАналоги.Количество() > 0 Тогда
		ТабДок.НачатьГруппуСтрок("По МПЗ", Истина);
			Для м = 0 по ВыборкаАналоги.ВГраница() Цикл	
			КоличествоРасходАналогиИтого = 0;
			Аналог = ВыборкаАналоги[м].АналогМПЗ;
			ОблАналогОбщая.Параметры.Наименование = СокрЛП(Аналог.Наименование); 
			ОблАналогОбщая.Параметры.МПЗ = Аналог;
			ОблАналогОбщая.Параметры.ЕдиницаИзмерения = Аналог.ЕдиницаИзмерения;
			ТабДок.Вывести(ОблАналогОбщая);
			НомСтр = 1;
				Для Каждого Стр Из СписокПериодов Цикл
				КоличествоРасход = 0;
					Для Каждого ТЧ_Ном Из ВыборкаАналоги[м].ТаблицаНоменклатуры Цикл	
					Выборка = ЭтаФорма_Номенклатура.НайтиСтроки(Новый Структура("Номенклатура",ТЧ_Ном.Номенклатура));
						Для к = 0 по Выборка.ВГраница() Цикл
							Если (Стр.Значение>=ТЧ_Ном.ДатаС)и(Стр.Значение<=ТЧ_Ном.ДатаПо) Тогда
							КоличествоРасход = КоличествоРасход + Выборка[к]["Д"+НомСтр]*ТЧ_Ном.Количество;
							КоличествоРасходАналогиИтого = КоличествоРасходАналогиИтого + Выборка[к]["Д"+НомСтр]*ТЧ_Ном.Количество;										
							КонецЕсли; 
						КонецЦикла; 
					КонецЦикла;
				ОблАналогПериод.Параметры.КоличествоРасход = КоличествоРасход;
				ТабДок.Присоединить(ОблАналогПериод);
				НомСтр = НомСтр + 1;
				КонецЦикла;
			ОблАналогИтого.Параметры.КоличествоИтого = КоличествоРасходАналогиИтого;
			ТабДок.Присоединить(ОблАналогИтого);
			КонецЦикла;
		ТабДок.ЗакончитьГруппуСтрок();
		КонецЕсли; 
	КонецЦикла;
ТабДок.Вывести(ОблКонецОбщая);
	Для Каждого Стр Из СписокПериодов Цикл
	ТабДок.Присоединить(ОблКонецПериод);
	КонецЦикла;	
ТабДок.Присоединить(ОблКонецИтого);
ТабДок.ФиксацияСверху = 2;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
Состояние("Обработка...",,"Формирование таблицы отчёта...");
СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьПерспективныйПланНаСервере()
ТЗ = Новый ТаблицаЗначений;

ТЗ.Колонки.Добавить("Статус",Новый ОписаниеТипов("ПеречислениеСсылка.СтатусыСпецификаций"),"Ст.");
ТЗ.Колонки.Добавить("Номенклатура",Новый ОписаниеТипов("СправочникСсылка.Номенклатура"),"Номенклатура");
СписокПериодов.Очистить();
ТекДата = Отчет.Период.ДатаНачала;
	Пока ТекДата <= Отчет.Период.ДатаОкончания Цикл
		Если День(ТекДата) = 1 Тогда
		СписокПериодов.Добавить(ТекДата);	
		ТЗ.Колонки.Добавить("Д"+СписокПериодов.Количество(),Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(14,3)),Формат(ТекДата,"ДФ=MM.yy"));	
		КонецЕсли;			
	ТекДата = ТекДата + 86400;
	КонецЦикла;
	
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПерспективныеПланы.МПЗ КАК МПЗ,
	|	ПерспективныеПланы.Количество КАК Количество,
	|	ПерспективныеПланы.Период КАК Период
	|ИЗ
	|	РегистрСведений.ПерспективныеПланы КАК ПерспективныеПланы
	|ГДЕ
	|	ПерспективныеПланы.Период МЕЖДУ &ДатаНач И &ДатаКон";
	Если СписокГруппНоменклатуры.Количество() > 0 Тогда
	Запрос.Текст = Запрос.Текст + " И ПерспективныеПланы.МПЗ В ИЕРАРХИИ(&СписокГруппНоменклатуры)";
	Запрос.УстановитьПараметр("СписокГруппНоменклатуры", СписокГруппНоменклатуры);
	КонецЕсли;
Запрос.Текст = Запрос.Текст + " ИТОГИ СУММА(Количество) ПО МПЗ,Период ПЕРИОДАМИ(МЕСЯЦ, , )";
Запрос.УстановитьПараметр("ДатаНач", Отчет.Период.ДатаНачала);
Запрос.УстановитьПараметр("ДатаКон", Отчет.Период.ДатаОкончания);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаМПЗ = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаМПЗ.Следующий() Цикл
		Если ВыборкаМПЗ.Количество = 0 Тогда
		Продолжить;
		КонецЕсли;
	ТЧ = ТЗ.Добавить();
	ТЧ.Статус = ПолучитьСтатус(ВыборкаМПЗ.МПЗ);		
	ТЧ.Номенклатура = ВыборкаМПЗ.МПЗ;
	ВыборкаПериод = ВыборкаМПЗ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	НомСтр = 0;
		Для Каждого Стр Из СписокПериодов Цикл
		НомСтр = НомСтр + 1;
	    ВыборкаПериод.Сбросить();
			Если ВыборкаПериод.НайтиСледующий(Новый Структура("Период",Стр.Значение)) Тогда
			ТЧ["Д"+НомСтр] = ВыборкаПериод.Количество;			
			Иначе
			ТЧ["Д"+НомСтр] = 0;
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;
МассивРеквизитов = Новый Массив;
МассивУдаляемыхРеквизитов = Новый Массив;
МассивРеквизитов.Добавить(Новый РеквизитФормы("Номенклатура", Новый ОписаниеТипов("ТаблицаЗначений"), "", "Номенклатура"));
	Для Каждого Колонка Из ТЗ.Колонки Цикл
    МассивРеквизитов.Добавить(Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения, "Номенклатура", Колонка.Заголовок)); 
	КонецЦикла;
МассивУдаляемыхРеквизитов.Добавить("Номенклатура");
	Если Элементы.Найти("Номенклатура") <> Неопределено Тогда
	Элементы.Удалить(Элементы["Номенклатура"]);
	ИзменитьРеквизиты(,МассивУдаляемыхРеквизитов);
	КонецЕсли;
ИзменитьРеквизиты(МассивРеквизитов);
//Помещаем Элементы на форму 
Таблица = Элементы.Добавить("Номенклатура", Тип("ТаблицаФормы"),Элементы.ПерспективныйПлан); 
Таблица.ПутьКДанным = "Номенклатура"; 
Таблица.Отображение = ОтображениеТаблицы.Список;
Таблица.ЧередованиеЦветовСтрок = Истина; 
	Для Каждого Колонка Из ТЗ.Колонки Цикл
    НовыйЭлемент = Элементы.Добавить("Номенклатура_" + Колонка.Имя, Тип("ПолеФормы"), Таблица); 
    НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода; 
    НовыйЭлемент.ПутьКДанным = "Номенклатура." + Колонка.Имя; 
	КонецЦикла;
//переносим таблицу значений на форму 
ЗначениеВРеквизитФормы(ТЗ,"Номенклатура");
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьПерспективныйПлан(Команда)
ПолучитьПерспективныйПланНаСервере();
Элементы.Сформировать.Доступность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТипСправочникаПриИзменении(Элемент)
Элементы.СписокГруппМПЗ.Видимость = ?(ТипСправочника = 1,Истина,Ложь);
Элементы.СписокВидовКанбанов.Видимость = ?(ТипСправочника = 1,Ложь,Истина);
КонецПроцедуры
