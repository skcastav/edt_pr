
&НаСервере
Процедура РаскрытьНаМПЗ(ВыбСпецификация,КолИзделия,Линейка,ТаблицаМПЗ,флПЗ)
НормРасх = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_М(ВыбСпецификация,ТекущаяДата());
	Пока НормРасх.Следующий() Цикл			
		Если ТипЗнч(НормРасх.Элемент) = Тип("СправочникСсылка.Номенклатура") Тогда
			Если НормРасх.Элемент.Канбан.Пустая() Тогда			
			РаскрытьНаМПЗ(НормРасх.Элемент,ПолучитьБазовоеКоличество(НормРасх.Норма,НормРасх.Элемент.ОсновнаяЕдиницаИзмерения)*КолИзделия,Линейка,ТаблицаМПЗ,флПЗ);	
			Продолжить;
			КонецЕсли;
				Если ВидМПЗ = 1 Тогда
				Продолжить;
				КонецЕсли; 
					Если СписокГруппПФ.Количество() > 0 Тогда
					флНайден = Ложь;
						Для каждого Стр Из СписокГруппПФ Цикл
							Если НормРасх.Элемент.ПринадлежитЭлементу(Стр.Значение) Тогда
							флНайден = Истина;	
							Прервать;	
							КонецЕсли; 									
						КонецЦикла;	
							Если Не флНайден Тогда
							Продолжить;
							КонецЕсли; 
					КонецЕсли; 						
		Иначе
			Если ВидМПЗ = 2 Тогда
			Продолжить;
			КонецЕсли; 
				Если СписокГруппМПЗ.Количество() > 0 Тогда
				флНайден = Ложь;
					Для каждого Стр Из СписокГруппМПЗ Цикл
						Если НормРасх.Элемент.ПринадлежитЭлементу(Стр.Значение) Тогда
						флНайден = Истина;	
						Прервать;	
						КонецЕсли; 									
					КонецЦикла;	
						Если Не флНайден Тогда
						Продолжить;
						КонецЕсли; 
				КонецЕсли; 
		КонецЕсли;
	ТЧ = ТаблицаМПЗ.Добавить();
	ТЧ.Линейка = Линейка;
	ТЧ.МПЗ = НормРасх.Элемент;
		Если флПЗ Тогда
		ТЧ.КолПЗ = ПолучитьБазовоеКоличество(НормРасх.Норма,НормРасх.Элемент.ОсновнаяЕдиницаИзмерения)*КолИзделия;
		Иначе
		ТЧ.КолИзд = ПолучитьБазовоеКоличество(НормРасх.Норма,НормРасх.Элемент.ОсновнаяЕдиницаИзмерения)*КолИзделия;
		КонецЕсли;		
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();

ТаблицаМПЗ = Новый ТаблицаЗначений;
Массив = Новый Массив;

Массив.Добавить(Тип("СправочникСсылка.Номенклатура"));
Массив.Добавить(Тип("СправочникСсылка.Материалы"));
ОписаниеТиповСправочников = Новый ОписаниеТипов(Массив);

ТаблицаМПЗ.Колонки.Добавить("Линейка",Новый ОписаниеТипов("СправочникСсылка.Линейки"));
ТаблицаМПЗ.Колонки.Добавить("МПЗ",ОписаниеТиповСправочников);
ТаблицаМПЗ.Колонки.Добавить("КолПЗ",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(9,3)));
ТаблицаМПЗ.Колонки.Добавить("КолИзд",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(9,3)));

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблМПЗ = Макет.ПолучитьОбласть("МПЗ");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.НаДату = ТекущаяДата();
ТабДок.Вывести(ОблШапка);

Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПроизводственноеЗадание.Изделие КАК Изделие,
	|	ПроизводственноеЗадание.Ссылка КАК Ссылка,
	|	ПроизводственноеЗадание.Линейка КАК Линейка
	|ИЗ
	|	Документ.ПроизводственноеЗадание КАК ПроизводственноеЗадание
	|ГДЕ
	|	ПроизводственноеЗадание.Линейка В(&СписокЛинеек)
	|	И ПроизводственноеЗадание.ДатаЗапуска = &ДатаЗапуска
	|ИТОГИ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Ссылка)
	|ПО
	|	Линейка,
	|	Изделие";
Запрос.УстановитьПараметр("СписокЛинеек",СписокЛинеек);
Запрос.УстановитьПараметр("ДатаЗапуска",Дата(1,1,1));
РезультатЗапроса = Запрос.Выполнить();
ВыборкаЛинейка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаЛинейка.Следующий() Цикл
	Выборка = ВыборкаЛинейка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока Выборка.Следующий() Цикл
		РаскрытьНаМПЗ(Выборка.Изделие,Выборка.Ссылка,ВыборкаЛинейка.Линейка,ТаблицаМПЗ,Истина);
		КонецЦикла;
	КонецЦикла;
Запрос.Текст = 
	"ВЫБРАТЬ
	|	НезапущенныеИзделия.Изделие КАК Изделие,
	|	НезапущенныеИзделия.Количество КАК Количество,
	|	НезапущенныеИзделия.Линейка КАК Линейка
	|ИЗ
	|	Справочник.НезапущенныеИзделия КАК НезапущенныеИзделия
	|ГДЕ
	|	НезапущенныеИзделия.Линейка В(&СписокЛинеек)
	|ИТОГИ
	|	СУММА(Количество)
	|ПО
	|	Линейка,
	|	Изделие";
Запрос.УстановитьПараметр("СписокЛинеек",СписокЛинеек);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаЛинейка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаЛинейка.Следующий() Цикл
	Выборка = ВыборкаЛинейка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока Выборка.Следующий() Цикл
		РаскрытьНаМПЗ(Выборка.Изделие,Выборка.Количество,ВыборкаЛинейка.Линейка,ТаблицаМПЗ,Ложь);
		КонецЦикла;
	КонецЦикла;
ТаблицаМПЗ.Свернуть("Линейка,МПЗ","КолПЗ,КолИзд");
ТаблицаМПЗ.Сортировать("Линейка,МПЗ");
	Для каждого ТЧ Из ТаблицаМПЗ Цикл
	КолСклад = 0;
	Фильтр   = Новый Структура;
	Фильтр.Вставить("МестоХранения", ТЧ.Линейка.МестоХраненияКанбанов);
	Фильтр.Вставить("ВидМПЗ",Перечисления.ВидыМПЗ.Материалы);
	Фильтр.Вставить("МПЗ",ТЧ.МПЗ);	
	табОстатков = РегистрыНакопления.МестаХранения.Остатки(ТекущаяДата(),Фильтр);
		Если табОстатков.Количество() > 0 Тогда
			Для Каждого ТЧ_Ост из табОстатков Цикл
			КолСклад = КолСклад + ТЧ_Ост.Количество;
			КонецЦикла;
		КонецЕсли;
			Если ТолькоДефицит Тогда
				Если КолСклад - ТЧ.КолПЗ + ТЧ.КолИзд > 0 Тогда
				Продолжить;
				КонецЕсли; 
			КонецЕсли; 
	Отбор = Новый Структура("МПЗ",ТЧ.МПЗ);
	СтатусыМПЗ = РегистрыСведений.СтатусыМПЗ.ПолучитьПоследнее(ТекущаяДата(),Отбор); 
	ОблМПЗ.Параметры.Линейка = ТЧ.Линейка;		
	ОблМПЗ.Параметры.Наименование = СокрЛП(ТЧ.МПЗ.Наименование);
	ОблМПЗ.Параметры.МПЗ = ТЧ.МПЗ;
	ОблМПЗ.Параметры.ЕдИзм = ТЧ.МПЗ.ЕдиницаИзмерения;
	ОблМПЗ.Параметры.Статус = СтатусыМПЗ.Статус;
	ОблМПЗ.Параметры.КолПЗ = ТЧ.КолПЗ;
	ОблМПЗ.Параметры.КолИзд = ТЧ.КолИзд;

	ОблМПЗ.Параметры.КолСклад = КолСклад;
	ОблМПЗ.Параметры.КолДефицит = КолСклад - ТЧ.КолПЗ + ТЧ.КолИзд;
	ТабДок.Вывести(ОблМПЗ);
	КонецЦикла; 
ТабДок.Вывести(ОблКонец);
ТабДок.ФиксацияСверху = 4;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	СформироватьНаСервере();
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ВидМПЗПриИзменении(Элемент)
ВидМПЗПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВидМПЗПриИзмененииНаСервере()
	Если ВидМПЗ = 1 Тогда
	Элементы.СписокГруппМПЗ.Видимость = Истина;
	Элементы.СписокГруппПФ.Видимость = Ложь;
	Иначе
	Элементы.СписокГруппМПЗ.Видимость = Ложь;
	Элементы.СписокГруппПФ.Видимость = Истина;	
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
ПриОткрытииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	Если ВидМПЗ = 1 Тогда
	Элементы.СписокГруппМПЗ.Видимость = Истина;
	Иначе
	Элементы.СписокГруппПФ.Видимость = Истина;	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
ВидМПЗ = 1;
КонецПроцедуры
