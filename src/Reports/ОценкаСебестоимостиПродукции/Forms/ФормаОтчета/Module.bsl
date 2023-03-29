
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Период.ДатаНачала = ТекущаяДата();
Период.ДатаОкончания = ТекущаяДата();
КонецПроцедуры

&НаСервере
Процедура ПериодПриИзмененииНаСервере()
	Для каждого ТЧ Из ТаблицаМПЗ Цикл
	Цены = РегистрыСведений.Цены.ПолучитьПоследнее(Период.ДатаОкончания,Новый Структура("МПЗ",ТЧ.МПЗ));
	ТЧ.ЦенаПоследнейЗакупки = Цены.Цена;
	Цены = РегистрыСведений.ЦеныИзменение.ПолучитьПоследнее(Период.ДатаОкончания,Новый Структура("МПЗ",ТЧ.МПЗ));
	ТЧ.ЦенаИзмененная = Цены.Цена*ОбщийМодульВызовСервера.КурсДляВалюты(Цены.Валюта,Период.ДатаОкончания);
	ТЧ.Спецификации.Очистить();	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
ПериодПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗаПериодНаСервере()
ТаблицаМПЗ.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЦеныИзменение.МПЗ КАК МПЗ,
	|	ЦеныИзменение.Цена КАК Цена
	|ИЗ
	|	РегистрСведений.ЦеныИзменение КАК ЦеныИзменение
	|ГДЕ
	|	ЦеныИзменение.Период МЕЖДУ &ДатаНач И &ДатаКон
	|
	|УПОРЯДОЧИТЬ ПО
	|	МПЗ,
	|	ЦеныИзменение.Период УБЫВ
	|ИТОГИ ПО
	|	МПЗ";
Запрос.УстановитьПараметр("ДатаНач", Период.ДатаНачала);
Запрос.УстановитьПараметр("ДатаКон", Период.ДатаОкончания);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаМПЗ = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаМПЗ.Следующий() Цикл
	ВыборкаДетальныеЗаписи = ВыборкаМПЗ.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ТЧ = ТаблицаМПЗ.Добавить();
		ТЧ.МПЗ = ВыборкаМПЗ.МПЗ;
		Цены = РегистрыСведений.Цены.ПолучитьПоследнее(Период.ДатаОкончания,Новый Структура("МПЗ",ТЧ.МПЗ));
		ТЧ.ЦенаПоследнейЗакупки = Цены.Цена;
		Цены = РегистрыСведений.ЦеныИзменение.ПолучитьПоследнее(Период.ДатаОкончания,Новый Структура("МПЗ",ТЧ.МПЗ));
		ТЧ.ЦенаИзмененная = Цены.Цена*ОбщийМодульВызовСервера.КурсДляВалюты(Цены.Валюта,Период.ДатаОкончания);	
		Прервать;	
		КонецЦикла; 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗаПериод(Команда)
ЗаполнитьЗаПериодНаСервере();
КонецПроцедуры

&НаСервере
Процедура ТаблицаМПЗМПЗПриИзмененииНаСервере(Стр)
ТЧ = ТаблицаМПЗ.НайтиПоИдентификатору(Стр);
Цены = РегистрыСведений.Цены.ПолучитьПоследнее(Период.ДатаОкончания,Новый Структура("МПЗ",ТЧ.МПЗ));
ТЧ.ЦенаПоследнейЗакупки = Цены.Цена;
Цены = РегистрыСведений.ЦеныИзменение.ПолучитьПоследнее(Период.ДатаОкончания,Новый Структура("МПЗ",ТЧ.МПЗ));
ТЧ.ЦенаИзмененная = Цены.Цена*ОбщийМодульВызовСервера.КурсДляВалюты(Цены.Валюта,Период.ДатаОкончания);                                                        
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаМПЗМПЗПриИзменении(Элемент)
ТаблицаМПЗМПЗПриИзмененииНаСервере(Элементы.ТаблицаМПЗ.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ПодборМПЗНаСервере(ТаблицаПодбораМПЗ)
	Для каждого ТЧ_МПЗ Из ТаблицаПодбораМПЗ Цикл
	ТЧ = ТаблицаМПЗ.Добавить();
		Если ТипЗнч(ТЧ_МПЗ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
		ТЧ.МПЗ = ТЧ_МПЗ.МПЗ;
		Цены = РегистрыСведений.Цены.ПолучитьПоследнее(Период.ДатаОкончания,Новый Структура("МПЗ",ТЧ.МПЗ));
		ТЧ.ЦенаПоследнейЗакупки = Цены.Цена;
		Цены = РегистрыСведений.ЦеныИзменение.ПолучитьПоследнее(Период.ДатаОкончания,Новый Структура("МПЗ",ТЧ.МПЗ));
		ТЧ.ЦенаИзмененная = Цены.Цена*ОбщийМодульВызовСервера.КурсДляВалюты(Цены.Валюта,Период.ДатаОкончания);		
		КонецЕсли;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
ТаблицаПодбораМПЗ = ОткрытьФормуМодально("ОбщаяФорма.ПодборМПЗ", Новый Структура("МестоХранения",Неопределено));
	Если ТаблицаПодбораМПЗ <> Неопределено Тогда
	ПодборМПЗНаСервере(ТаблицаПодбораМПЗ);
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьИзФайлаНаСервере(Наименование, Цена)
Матер = Справочники.Материалы.НайтиПоНаименованию(Наименование,Истина);
	Если Не Матер.Пустая() Тогда
	ТЧ = ТаблицаМПЗ.Добавить();
	ТЧ.МПЗ = Матер;
	ТЧ.ЦенаИзмененная = Цена;
	Цены = РегистрыСведений.Цены.ПолучитьПоследнее(Период.ДатаОкончания,Новый Структура("МПЗ",ТЧ.МПЗ));
	ТЧ.ЦенаПоследнейЗакупки = Цены.Цена; 
	Иначе
	Сообщить(""+Наименование+" - материал не найден!");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
ТаблицаМПЗ.Очистить();
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл со списком МПЗ");
	Если Результат <> Неопределено Тогда
	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок;
	    Для к = 2 по КолСтрок Цикл
		Состояние("Обработка...",к*100/КолСтрок,"Загрузка списка МПЗ с измененными ценами...");
		ЗагрузитьИзФайлаНаСервере(СокрЛП(ExcelЛист.Cells(к,1).Value),Число(ExcelЛист.Cells(к,2).Value));
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПолучитьКонечноеПрименение(ТЧ,Элемент,Норма)
спНомен = ОбщийМодульВызовСервера.ПолучитьСписокВхожденийСНормой(Элемент,Период.ДатаОкончания);
	Для каждого Номен Из спНомен Цикл
		Если ПолучитьСтатус(Номен.Значение) <> Перечисления.СтатусыСпецификаций.Запрещённая Тогда
			Если Не Номен.Значение.Товар.Пустая() Тогда
				Если ТипЗнч(Номен.Значение) = Тип("СправочникСсылка.Номенклатура") Тогда
				ТЧ_Н = ТЧ.Спецификации.Добавить();
				ТЧ_Н.Номенклатура = Номен.Значение;
				ТЧ_Н.Норма = Норма*Число(Номен.Представление);			
				КонецЕсли;
			КонецЕсли; 
		ПолучитьКонечноеПрименение(ТЧ,Номен.Значение,Норма*Число(Номен.Представление));
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура ПолучитьНоменклатуруНаСервере()
	Для каждого ТЧ Из ТаблицаМПЗ Цикл
	ТЧ.Спецификации.Очистить();
	ПолучитьКонечноеПрименение(ТЧ,ТЧ.МПЗ,1);
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Функция ПолучитьСебестоимостиГТ(ТЗ,ТоварнаяГруппа)
Парам = Новый Структура();

СебестоимостьГТ = 0;
СебестоимостьИзмененнаяГТ = 0;
СебестоимостьПолнаяГТ = 0;
СебестоимостьПолнаяИзмененнаяГТ = 0;
Выборка = ТЗ.НайтиСтроки(Новый Структура("ТоварнаяГруппа",ТоварнаяГруппа));
	Для к = 0 По Выборка.ВГраница() Цикл	
	СебестоимостьГТ = СебестоимостьГТ + Выборка[к].Себестоимость;
	СебестоимостьИзмененнаяГТ = СебестоимостьИзмененнаяГТ + Выборка[к].СебестоимостьИзмененная;
	СебестоимостьПолнаяГТ = СебестоимостьПолнаяГТ + Выборка[к].СебестоимостьПолная;
	СебестоимостьПолнаяИзмененнаяГТ = СебестоимостьПолнаяИзмененнаяГТ +Выборка[к].СебестоимостьПолнаяИзмененная;	
	КонецЦикла; 
Парам.Вставить("СебестоимостьГТ",СебестоимостьГТ);
Парам.Вставить("СебестоимостьИзмененнаяГТ",СебестоимостьИзмененнаяГТ);
Парам.Вставить("СебестоимостьПолнаяГТ",СебестоимостьПолнаяГТ);
Парам.Вставить("СебестоимостьПолнаяИзмененнаяГТ",СебестоимостьПолнаяИзмененнаяГТ);
Возврат(Парам);
КонецФункции

&НаСервере
Функция ПолучитьСебестоимостиПолнуюМатПоНомен(ТЗ,ТоварнаяГруппа,Номенклатура)
СебестоимостьПолнаяИзмененная = 0;
Выборка = ТЗ.НайтиСтроки(Новый Структура("ТоварнаяГруппа,Номенклатура",ТоварнаяГруппа,Номенклатура));
	Для к = 0 По Выборка.ВГраница() Цикл	
	СебестоимостьПолнаяИзмененная = СебестоимостьПолнаяИзмененная + Выборка[к].ЦенаИзмененная * Выборка[к].Норма;	
	КонецЦикла;
Возврат(СебестоимостьПолнаяИзмененная);
КонецФункции

&НаСервере
Функция ПолучитьСебестоимостиПолнуюМатПоГТ(ТЗ,ТоварнаяГруппа)
СебестоимостьПолнаяИзмененная = 0;
Выборка = ТЗ.НайтиСтроки(Новый Структура("ТоварнаяГруппа",ТоварнаяГруппа));
	Для к = 0 По Выборка.ВГраница() Цикл	
	СебестоимостьПолнаяИзмененная = СебестоимостьПолнаяИзмененная + Выборка[к].ЦенаИзмененная * Выборка[к].Норма;	
	КонецЦикла;
Возврат(СебестоимостьПолнаяИзмененная);
КонецФункции

&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();
ТаблицаЦенИзмененных = Новый ТаблицаЗначений;
ТЗ = Новый ТаблицаЗначений;

ТаблицаЦенИзмененных.Колонки.Добавить("МПЗ");
ТаблицаЦенИзмененных.Индексы.Добавить("МПЗ");
ТаблицаЦенИзмененных.Колонки.Добавить("ЦенаИзмененная");

ТЗ.Колонки.Добавить("МПЗ");
ТЗ.Колонки.Добавить("ТоварнаяГруппа");
ТЗ.Колонки.Добавить("Номенклатура");
ТЗ.Колонки.Добавить("ЦенаПоследнейЗакупки");
ТЗ.Колонки.Добавить("ЦенаИзмененная");
ТЗ.Колонки.Добавить("Норма");
ТЗ.Колонки.Добавить("Себестоимость");
ТЗ.Колонки.Добавить("СебестоимостьИзмененная");
ТЗ.Колонки.Добавить("СебестоимостьПолная");
ТЗ.Колонки.Добавить("СебестоимостьПолнаяИзмененная");

ПолучитьНоменклатуруНаСервере();

	Для каждого ТЧ Из ТаблицаМПЗ Цикл
	ТЧ_ЦИ = ТаблицаЦенИзмененных.Добавить();
	ТЧ_ЦИ.МПЗ = ТЧ.МПЗ;
	ТЧ_ЦИ.ЦенаИзмененная = ТЧ.ЦенаИзмененная;
		Для каждого ТЧ_Номен Из ТЧ.Спецификации Цикл	
		ТЧ_ТЗ = ТЗ.Добавить();
		ТЧ_ТЗ.ТоварнаяГруппа =  ТЧ_Номен.Номенклатура.Товар.ТоварнаяГруппа;
		ТЧ_ТЗ.МПЗ = ТЧ.МПЗ;
		ТЧ_ТЗ.Номенклатура = ТЧ_Номен.Номенклатура;
		ТЧ_ТЗ.ЦенаПоследнейЗакупки = ТЧ.ЦенаПоследнейЗакупки;
		ТЧ_ТЗ.ЦенаИзмененная = ТЧ.ЦенаИзмененная;
		ТЧ_ТЗ.Номенклатура = ТЧ_Номен.Номенклатура;
		ТЧ_ТЗ.Норма = ПолучитьБазовоеКоличество(ТЧ_Номен.Норма,ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения);
		Себестоимость = 0;
		СебестоимостьИзмененная = 0;
		ОбщийМодульВызовСервера.ПолучитьСебестоимостьНоменклатурыСИзмененнымиЦенами(ТЧ_Номен.Номенклатура,1,Период.ДатаОкончания,Себестоимость,СебестоимостьИзмененная,ТаблицаЦенИзмененных);
		ТЧ_ТЗ.Себестоимость = Себестоимость;
		ТЧ_ТЗ.СебестоимостьИзмененная = СебестоимостьИзмененная;
		ТЧ_ТЗ.СебестоимостьПолная = РегистрыСведений.Себестоимость.ПолучитьПоследнее(Период.ДатаОкончания,Новый Структура("Номенклатура,Подразделение",ТЧ_Номен.Номенклатура,ТЧ_Номен.Номенклатура.Линейка.Подразделение)).СебестоимостьПолная;
		ТЧ_ТЗ.СебестоимостьПолнаяИзмененная = ТЧ_ТЗ.СебестоимостьПолная - Себестоимость + СебестоимостьИзмененная;
		КонецЦикла;
	КонецЦикла;
ТЗ.Свернуть("ТоварнаяГруппа,Номенклатура,МПЗ,ЦенаПоследнейЗакупки,ЦенаИзмененная,Себестоимость,СебестоимостьИзмененная,СебестоимостьПолная,СебестоимостьПолнаяИзмененная","Норма");
ТЗ.Сортировать("ТоварнаяГруппа,Номенклатура,МПЗ");
ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблТоварнаяГруппа = Макет.ПолучитьОбласть("ТоварнаяГруппа");
ОблНоменклатура = Макет.ПолучитьОбласть("Номенклатура");
ОблМатериал = Макет.ПолучитьОбласть("Материал");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.НаДату = Формат(Период.ДатаОкончания,"ДФ=dd.MM.yyyy");
ТабДок.Вывести(ОблШапка);
ТекТоварнаяГруппа = Неопределено;
ТекНоменклатура = Неопределено;
	Для каждого ТЧ Из ТЗ Цикл
		Если ТекТоварнаяГруппа <> ТЧ.ТоварнаяГруппа Тогда
			Если ТекНоменклатура <> Неопределено Тогда
			ТабДок.ЗакончитьГруппуСтрок();
			КонецЕсли;
				Если ТекТоварнаяГруппа <> Неопределено Тогда
				ТабДок.ЗакончитьГруппуСтрок();
				КонецЕсли;
		ОблТоварнаяГруппа.Параметры.ТоварнаяГруппа = ТЧ.ТоварнаяГруппа;
		Парам = ПолучитьСебестоимостиГТ(ТЗ,ТЧ.ТоварнаяГруппа);
		ОблТоварнаяГруппа.Параметры.Себестоимость = Парам.СебестоимостьГТ;
		ОблТоварнаяГруппа.Параметры.СебестоимостьИзмененная = Парам.СебестоимостьИзмененнаяГТ;
		ОблТоварнаяГруппа.Параметры.СебестоимостьПолная = Парам.СебестоимостьПолнаяГТ;
		ОблТоварнаяГруппа.Параметры.СебестоимостьПолнаяИзмененная = Парам.СебестоимостьПолнаяИзмененнаяГТ;
		ОблТоварнаяГруппа.Параметры.Дельта = ?(ОблТоварнаяГруппа.Параметры.Себестоимость <> 0,(ОблТоварнаяГруппа.Параметры.СебестоимостьИзмененная-ОблТоварнаяГруппа.Параметры.Себестоимость)/ОблТоварнаяГруппа.Параметры.Себестоимость*100,0);	 
		ОблТоварнаяГруппа.Параметры.ВлияниеЦены = ?(ОблТоварнаяГруппа.Параметры.СебестоимостьПолнаяИзмененная <> 0,ПолучитьСебестоимостиПолнуюМатПоГТ(ТЗ,ТЧ.ТоварнаяГруппа)/ОблТоварнаяГруппа.Параметры.СебестоимостьПолнаяИзмененная*ОблТоварнаяГруппа.Параметры.Дельта,0);
		ТабДок.Вывести(ОблТоварнаяГруппа);
		ТекТоварнаяГруппа = ТЧ.ТоварнаяГруппа;
		ТабДок.НачатьГруппуСтрок("ТоварныеГруппы",Истина);
		ОблНоменклатура.Параметры.НаименованиеНоменклатура = СокрЛП(ТЧ.Номенклатура.Наименование);
		ОблНоменклатура.Параметры.Номенклатура = ТЧ.Номенклатура;
		ОблНоменклатура.Параметры.Себестоимость = ТЧ.Себестоимость;
		ОблНоменклатура.Параметры.СебестоимостьИзмененная = ТЧ.СебестоимостьИзмененная;
		ОблНоменклатура.Параметры.СебестоимостьПолная = ТЧ.СебестоимостьПолная;
		ОблНоменклатура.Параметры.СебестоимостьПолнаяИзмененная = ТЧ.СебестоимостьПолнаяИзмененная;
		ОблНоменклатура.Параметры.Дельта = ?(ОблНоменклатура.Параметры.Себестоимость <> 0,(ОблНоменклатура.Параметры.СебестоимостьИзмененная-ОблНоменклатура.Параметры.Себестоимость)/ОблНоменклатура.Параметры.Себестоимость*100,0);
		ОблНоменклатура.Параметры.ВлияниеЦены = ?(ОблНоменклатура.Параметры.СебестоимостьПолнаяИзмененная <> 0,ПолучитьСебестоимостиПолнуюМатПоНомен(ТЗ,ТЧ.ТоварнаяГруппа,ТЧ.Номенклатура)/ОблНоменклатура.Параметры.СебестоимостьПолнаяИзмененная*ОблНоменклатура.Параметры.Дельта,0);
		ТабДок.Вывести(ОблНоменклатура);
		ТекНоменклатура = ТЧ.Номенклатура;
		ТабДок.НачатьГруппуСтрок("Номенклатура",Истина);
		Иначе
			Если ТекНоменклатура <> ТЧ.Номенклатура Тогда
				Если ТекНоменклатура <> Неопределено Тогда
				ТабДок.ЗакончитьГруппуСтрок();
				КонецЕсли;
			ОблНоменклатура.Параметры.НаименованиеНоменклатура = СокрЛП(ТЧ.Номенклатура.Наименование); 
			ОблНоменклатура.Параметры.Номенклатура = ТЧ.Номенклатура;
			ОблНоменклатура.Параметры.Себестоимость = ТЧ.Себестоимость;
			ОблНоменклатура.Параметры.СебестоимостьИзмененная = ТЧ.СебестоимостьИзмененная;
			ОблНоменклатура.Параметры.СебестоимостьПолная = ТЧ.СебестоимостьПолная;
			ОблНоменклатура.Параметры.СебестоимостьПолнаяИзмененная = ТЧ.СебестоимостьПолнаяИзмененная;
			ОблНоменклатура.Параметры.Дельта = ?(ОблНоменклатура.Параметры.Себестоимость <> 0,(ОблНоменклатура.Параметры.СебестоимостьИзмененная-ОблНоменклатура.Параметры.Себестоимость)/ОблНоменклатура.Параметры.Себестоимость*100,0);
			ОблНоменклатура.Параметры.ВлияниеЦены = ?(ОблНоменклатура.Параметры.СебестоимостьПолнаяИзмененная <> 0,ПолучитьСебестоимостиПолнуюМатПоНомен(ТЗ,ТЧ.ТоварнаяГруппа,ТЧ.Номенклатура)/ОблНоменклатура.Параметры.СебестоимостьПолнаяИзмененная*ОблНоменклатура.Параметры.Дельта,0);
			ТабДок.Вывести(ОблНоменклатура);
			ТекНоменклатура = ТЧ.Номенклатура;
			ТабДок.НачатьГруппуСтрок("Номенклатура",Истина);
			КонецЕсли;
		КонецЕсли;
	ОблМатериал.Параметры.Наименование = СокрЛП(ТЧ.МПЗ.Наименование);
	ОблМатериал.Параметры.Материал = ТЧ.МПЗ;
	ОблМатериал.Параметры.ГруппаПоЗакупкам = ТЧ.МПЗ.ГруппаПоЗакупкам;
	ОблМатериал.Параметры.ЕИ = СокрЛП(ТЧ.МПЗ.ЕдиницаИзмерения.Наименование);
	ОблМатериал.Параметры.Норма = ТЧ.Норма;
	ОблМатериал.Параметры.ЦенаИзмененная = ТЧ.ЦенаИзмененная;
	ОблМатериал.Параметры.ЦенаПоследнейЗакупки = ТЧ.ЦенаПоследнейЗакупки;
	ОблМатериал.Параметры.Себестоимость = ТЧ.ЦенаПоследнейЗакупки*ТЧ.Норма;
	ОблМатериал.Параметры.СебестоимостьИзмененная = ТЧ.ЦенаИзмененная*ТЧ.Норма;
	ОблМатериал.Параметры.СебестоимостьПолная = ТЧ.ЦенаПоследнейЗакупки*ТЧ.Норма;
	ОблМатериал.Параметры.СебестоимостьПолнаяИзмененная = ТЧ.ЦенаИзмененная*ТЧ.Норма;
	ОблМатериал.Параметры.Дельта = ?(ОблМатериал.Параметры.Себестоимость <> 0,(ОблМатериал.Параметры.СебестоимостьИзмененная-ОблМатериал.Параметры.Себестоимость)/ОблМатериал.Параметры.Себестоимость*100,0);
	ОблМатериал.Параметры.ВлияниеЦены = ?(ОблНоменклатура.Параметры.СебестоимостьПолнаяИзмененная <> 0,ОблМатериал.Параметры.СебестоимостьПолнаяИзмененная/ОблНоменклатура.Параметры.СебестоимостьПолнаяИзмененная*ОблМатериал.Параметры.Дельта,0);
	ТабДок.Вывести(ОблМатериал);	
	КонецЦикла;
		Если ТекТоварнаяГруппа <> Неопределено Тогда
		ТабДок.ЗакончитьГруппуСтрок();
		ТабДок.ЗакончитьГруппуСтрок();		
		КонецЕсли;
ТабДок.Вывести(ОблКонец);
ТабДок.ФиксацияСверху = 2; 
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
Состояние("Обработка...",,"Формирование таблицы отчёта...");
СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОчиститьНаСервере()
ТабДок.Очистить();
ТаблицаМПЗ.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
ОчиститьНаСервере();
КонецПроцедуры

&НаСервере
Функция ПолучитьEmailСотрудника()
Возврат(ПараметрыСеанса.Пользователь.Email);
КонецФункции

&НаСервере
Функция ПолучитьEmailПолучателя(Сотрудник)
Возврат(Сотрудник.Email);
КонецФункции

&НаКлиенте
Процедура ПочтоваяРассылка(Команда)
	Если СписокПочтовойРассылки.Количество() = 0 Тогда
	Сообщить("Нет списка почтовой рассылки!");
	Возврат;
	КонецЕсли;
EmailСотрудника = ПолучитьEmailСотрудника();
Сообщение = Новый ИнтернетПочтовоеСообщение;
ИПП = Новый ИнтернетПочтовыйПрофиль; 

НастройкиПочты = ОбщийМодульВызовСервера.ПолучитьНастройкиПочты();
ИПП.АдресСервераSMTP = НастройкиПочты.АдресСервераSMTP; 
ИПП.ПортSMTP = НастройкиПочты.ПортSMTP;
ИПП.ВремяОжидания = 60; 
ИПП.Пароль = НастройкиПочты.ПарольПочтовогоСервера; 
ИПП.Пользователь = EmailСотрудника; 
	Для каждого Стр Из СписокПочтовойРассылки Цикл
    Сообщение.Получатели.Добавить(ПолучитьEmailПолучателя(Стр.Значение));
	КонецЦикла; 
Сообщение.Отправитель.Адрес = EmailСотрудника;
Сообщение.Тема = "Оценка себестоимости продукции на "+Формат(Период.ДатаОкончания,"ДФ=dd.MM.yyyy"); 
Текст = "Здравствуйте!";
Текст = Текст + Символы.ПС+ "";
Текст = Текст + Символы.ПС+ "Произведена оценка себестоимости продукции. Период с "+Период.ДатаНачала+" по "+Период.ДатаОкончания;
Текст = Текст + Символы.ПС+ "";
Текст = Текст + Символы.ПС+ "С уважением, email: "+EmailСотрудника;
Сообщение.Тексты.Добавить(Текст);	
ИмяФайла = ПолучитьИмяВременногоФайла("xls");
ТабДок.Записать(ИмяФайла,ТипФайлаТабличногоДокумента.XLS);
Сообщение.Вложения.Добавить(ИмяФайла,"Оценка себестоимости продукции"); 	
// Подключиться и отправить. 
Почта = Новый ИнтернетПочта; 
Почта.Подключиться(ИПП);
Почта.Послать(Сообщение); 
Почта.Отключиться();
ПоказатьОповещениеПользователя("Сообщение отправлено!");
КонецПроцедуры
