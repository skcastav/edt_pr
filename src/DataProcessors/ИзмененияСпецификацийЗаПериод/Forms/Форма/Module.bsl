
&НаСервере
Процедура СформироватьНаСервере()
тДерево = РеквизитФормыВЗначение("ДеревоСпецификаций");
тДерево.Строки.Очистить();
 
Запрос = Новый Запрос;

Раздел = тДерево.Строки.Добавить();
Раздел.Спецификация = "По основным элементам спецификаций";
Запрос.Текст = 
	"ВЫБРАТЬ
	|	НормыРасходов.НормаРасходов КАК НормаРасходов,
	|	НормыРасходов.Норма КАК Норма,
	|	НормыРасходов.Период КАК Период,
	|	НормыРасходов.НормаРасходов.Владелец КАК Владелец,
	|	НормыРасходов.НормаРасходов.Позиция КАК Позиция
	|ИЗ
	|	РегистрСведений.НормыРасходов КАК НормыРасходов
	|ГДЕ
	|	НормыРасходов.Период МЕЖДУ &ДатаНач И &ДатаКон
	|	И НормыРасходов.НормаРасходов.Владелец В ИЕРАРХИИ(&СписокНоменклатуры)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Владелец,
	|	Позиция
	|ИТОГИ ПО
	|	Владелец";
Запрос.УстановитьПараметр("ДатаНач", Объект.Период.ДатаНачала);
Запрос.УстановитьПараметр("ДатаКон", Объект.Период.ДатаОкончания);
Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаВладелец = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаВладелец.Следующий() Цикл
	ВыборкаДетальныеЗаписи = ВыборкаВладелец.Выбрать();
	НомСтр = 0;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если ВыборкаВладелец.Владелец.ДатаСозданияСпецификации <> ВыборкаДетальныеЗаписи.Период Тогда
			НомСтр = НомСтр + 1;
				Если НомСтр = 1 Тогда
				Стр = Раздел.Строки.Добавить();
				Стр.Спецификация = ВыборкаВладелец.Владелец;
				КонецЕсли; 
			СтрЭлемент = Стр.Строки.Добавить();
			СтрЭлемент.Спецификация = ВыборкаВладелец.Владелец;
			СтрЭлемент.Позиция = ВыборкаДетальныеЗаписи.Позиция;
			СтрЭлемент.Элемент = ВыборкаДетальныеЗаписи.НормаРасходов;
			СтрЭлемент.Количество = ВыборкаДетальныеЗаписи.Норма;
			СтрЭлемент.ДатаИзменения = ВыборкаДетальныеЗаписи.Период;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
Раздел = тДерево.Строки.Добавить();
Раздел.Спецификация = "По аналогам в спецификациях";
Запрос.Текст = 
	"ВЫБРАТЬ
	|	НормыРасходов.Норма КАК Норма,
	|	НормыРасходов.Период КАК Период,
	|	НормыРасходов.НормаРасходов.Владелец.Владелец КАК Владелец,
	|	НормыРасходов.НормаРасходов.Владелец.Позиция КАК Позиция,
	|	НормыРасходов.НормаРасходов.Владелец КАК НормаРасходов,
	|	НормыРасходов.НормаРасходов КАК Аналог
	|ИЗ
	|	РегистрСведений.НормыРасходов КАК НормыРасходов
	|ГДЕ
	|	НормыРасходов.Период МЕЖДУ &ДатаНач И &ДатаКон
	|	И НормыРасходов.НормаРасходов.Владелец.Владелец В ИЕРАРХИИ(&СписокНоменклатуры)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Владелец,
	|	НормаРасходов
	|ИТОГИ ПО
	|	Владелец";
Запрос.УстановитьПараметр("ДатаНач", Объект.Период.ДатаНачала);
Запрос.УстановитьПараметр("ДатаКон", Объект.Период.ДатаОкончания);
Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаВладелец = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаВладелец.Следующий() Цикл
	ВыборкаДетальныеЗаписи = ВыборкаВладелец.Выбрать();
	НомСтр = 0;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если ВыборкаВладелец.Владелец.ДатаСозданияСпецификации <> ВыборкаДетальныеЗаписи.Период Тогда
			НомСтр = НомСтр + 1;
				Если НомСтр = 1 Тогда
				Стр = Раздел.Строки.Добавить();
				Стр.Спецификация = ВыборкаВладелец.Владелец;
				КонецЕсли; 
			СтрЭлемент = Стр.Строки.Добавить();
			СтрЭлемент.Спецификация = ВыборкаВладелец.Владелец;
			СтрЭлемент.Позиция = ВыборкаДетальныеЗаписи.Позиция;
			СтрЭлемент.Элемент = ВыборкаДетальныеЗаписи.НормаРасходов;
			СтрЭлемент.Аналог = ВыборкаДетальныеЗаписи.Аналог;
			СтрЭлемент.Количество = ВыборкаДетальныеЗаписи.Норма;
			СтрЭлемент.ДатаИзменения = ВыборкаДетальныеЗаписи.Период;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
ЗначениеВРеквизитФормы(тДерево, "ДеревоСпецификаций");
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
СформироватьНаСервере();
КонецПроцедуры
