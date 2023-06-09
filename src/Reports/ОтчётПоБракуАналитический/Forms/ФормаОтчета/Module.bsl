
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
ВидОтчёта = 1;
ВидРасчёта = 1;
РасшифроватьПо = 1;
СортироватьПо = 1;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
Элементы.СписокЛинеекДляРасчёта.Доступность = ?(ВидРасчёта = 1,Истина,Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ВидРасчётаПриИзменении(Элемент)
Элементы.СписокЛинеекДляРасчёта.Доступность = ?(ВидРасчёта = 1,Истина,Ложь);
КонецПроцедуры

&НаСервере
Функция ПолучитьМестаХраненияКанбанов()
СписокМестХранения = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Линейки.МестоХраненияКанбанов КАК МестоХраненияКанбанов
	|ИЗ
	|	Справочник.Линейки КАК Линейки
	|ГДЕ
	|	Линейки.Подразделение В ИЕРАРХИИ(&СписокПодразделений)
	|	И Линейки.ЭтоГруппа = ЛОЖЬ";
Запрос.УстановитьПараметр("СписокПодразделений", СписокПодразделений);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если СписокМестХранения.НайтиПоЗначению(ВыборкаДетальныеЗаписи.МестоХраненияКанбанов) = Неопределено Тогда
		СписокМестХранения.Добавить(ВыборкаДетальныеЗаписи.МестоХраненияКанбанов);
		КонецЕсли; 
	КонецЦикла;
Возврат(СписокМестХранения);
КонецФункции

&НаСервере
Процедура ПолучитьКоличествоВыпущенных()
СписокОбщихКоличеств.Очистить();
Запрос = Новый Запрос;
ТаблицаДокументов.Очистить();

ЕдиницаИзмерения = Справочники.ЕдиницыИзмерений.НайтиПоНаименованию("шт",Истина);

	Для каждого Период Из СписокПериодов Цикл
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВыпускПродукцииКанбан.Количество КАК Количество,
		|	ВыпускПродукцииКанбан.Изделие КАК Изделие,
		|	ВыпускПродукцииКанбан.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ВыпускПродукцииКанбан КАК ВыпускПродукцииКанбан
		|ГДЕ
		|	ВыпускПродукцииКанбан.Дата МЕЖДУ &ДатаНач И &ДатаКон
		|	И ВыпускПродукцииКанбан.ДокументОснование.ДокументОснование.Ремонт = ЛОЖЬ";
	Если Не Подразделение.Пустая() Тогда
	Запрос.Текст = Запрос.Текст + " И ВыпускПродукцииКанбан.Подразделение = &Подразделение";	
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	КонецЕсли;
		Если СписокЛинеекДляРасчёта.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + " И ВыпускПродукцииКанбан.ДокументОснование.Линейка В ИЕРАРХИИ(&СписокЛинеек)";	
		Запрос.УстановитьПараметр("СписокЛинеек", СписокЛинеекДляРасчёта);
		КонецЕсли; 
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Период.Значение.ДатаНачала));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(Период.Значение.ДатаОкончания));
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	КолВып = 0;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		КолВып = КолВып + ?(ВыборкаДетальныеЗаписи.Изделие.ЕдиницаИзмерения <> ЕдиницаИзмерения,1,ВыборкаДетальныеЗаписи.Количество);
		Выборка = ТаблицаДокументов.НайтиСтроки(Новый Структура("Период",Период.Значение)); 
			Если Выборка.Количество() = 0 Тогда
			ТЧ = ТаблицаДокументов.Добавить();
			ТЧ.Период = Период.Значение;
			ТЧ.Документы.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
			Иначе
				Если Выборка[0].Документы.НайтиПоЗначению(ВыборкаДетальныеЗаписи.Ссылка) = Неопределено Тогда
				Выборка[0].Документы.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВыпускПродукцииПоступление.Количество КАК Количество,
		|	ВыпускПродукцииПоступление.Номенклатура КАК Номенклатура,
		|	ВыпускПродукцииПоступление.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ВыпускПродукции.Поступление КАК ВыпускПродукцииПоступление
		|ГДЕ
		|	ВыпускПродукцииПоступление.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
		|	И ВыпускПродукцииПоступление.Ссылка.НаСклад = ИСТИНА
		|	И ВыпускПродукцииПоступление.Ссылка.ДокументОснование.ДокументОснование.Ремонт = ЛОЖЬ";
	Если Не Подразделение.Пустая() Тогда
	Запрос.Текст = Запрос.Текст + " И ВыпускПродукцииПоступление.Ссылка.ДокументОснование.Подразделение = &Подразделение";	
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	КонецЕсли;
		Если СписокЛинеекДляРасчёта.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + " И ВыпускПродукцииПоступление.Ссылка.ДокументОснование.Линейка В ИЕРАРХИИ(&СписокЛинеек)";	
		Запрос.УстановитьПараметр("СписокЛинеек", СписокЛинеекДляРасчёта);
		КонецЕсли; 
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Период.Значение.ДатаНачала));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(Период.Значение.ДатаОкончания));
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		КолВып = КолВып + ?(ВыборкаДетальныеЗаписи.Номенклатура.ЕдиницаИзмерения <> ЕдиницаИзмерения,1,ВыборкаДетальныеЗаписи.Количество);
		Выборка = ТаблицаДокументов.НайтиСтроки(Новый Структура("Период",Период.Значение)); 
			Если Выборка.Количество() = 0 Тогда
			ТЧ = ТаблицаДокументов.Добавить();
			ТЧ.Период = Период.Значение;
			ТЧ.Документы.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
			Иначе
				Если Выборка[0].Документы.НайтиПоЗначению(ВыборкаДетальныеЗаписи.Ссылка) = Неопределено Тогда
				Выборка[0].Документы.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	СписокОбщихКоличеств.Добавить(КолВып);
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура ПолучитьКоличествоПереданных()
ТаблицаДокументов.Очистить();
СписокОбщихКоличеств.Очистить();
Запрос = Новый Запрос;

ЕдиницаИзмерения = Справочники.ЕдиницыИзмерений.НайтиПоНаименованию("шт",Истина);
СписокМестХранения = ПолучитьМестаХраненияКанбанов();
	Для каждого Период Из СписокПериодов Цикл
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПередачаВПроизводствоСпецификация.Количество КАК Количество,
		|	ПередачаВПроизводствоСпецификация.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ПередачаВПроизводствоСпецификация.МПЗ КАК МПЗ,
		|	ПередачаВПроизводствоСпецификация.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ПередачаВПроизводство.Спецификация КАК ПередачаВПроизводствоСпецификация
		|ГДЕ
		|	ПередачаВПроизводствоСпецификация.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
		|	И ПередачаВПроизводствоСпецификация.Ссылка.МестоХранения В(&СписокМестХранения)
		|	И ПередачаВПроизводствоСпецификация.МПЗ.Канбан.Подразделение = &Подразделение";
		Если СписокНоменклатуры.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + " И НЕ ПередачаВПроизводствоСпецификация.МПЗ В ИЕРАРХИИ (&СписокМПЗ)";	
		Запрос.УстановитьПараметр("СписокМПЗ", СписокНоменклатуры);		
		КонецЕсли; 
	Запрос.УстановитьПараметр("ДатаНач", Период.Значение.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаКон", Период.Значение.ДатаОкончания);
	Запрос.УстановитьПараметр("СписокМестХранения", СписокМестХранения);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	КолПереданных = 0;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		КолПереданных = КолПереданных + ?(ВыборкаДетальныеЗаписи.ЕдиницаИзмерения.ЕдиницаИзмерения <> ЕдиницаИзмерения,1,ВыборкаДетальныеЗаписи.Количество);
		Выборка = ТаблицаДокументов.НайтиСтроки(Новый Структура("Период",Период.Значение)); 
			Если Выборка.Количество() = 0 Тогда
			ТЧ = ТаблицаДокументов.Добавить();
			ТЧ.Период = Период.Значение;
			ТЧ.Документы.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
			Иначе
				Если Выборка[0].Документы.НайтиПоЗначению(ВыборкаДетальныеЗаписи.Ссылка) = Неопределено Тогда
				Выборка[0].Документы.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СписаниеМПЗПрочееТабличнаяЧасть.Количество КАК Количество,
		|	СписаниеМПЗПрочееТабличнаяЧасть.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	СписаниеМПЗПрочееТабличнаяЧасть.МПЗ КАК МПЗ,
		|	СписаниеМПЗПрочееТабличнаяЧасть.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.СписаниеМПЗПрочее.ТабличнаяЧасть КАК СписаниеМПЗПрочееТабличнаяЧасть
		|ГДЕ
		|	СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
		|	И СписаниеМПЗПрочееТабличнаяЧасть.МПЗ.Канбан.Подразделение = &Подразделение
		|	И СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.МестоХранения В(&СписокМестХранения)";
		Если СписокНоменклатуры.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + " И НЕ СписаниеМПЗПрочееТабличнаяЧасть.МПЗ В ИЕРАРХИИ (&СписокМПЗ)";	
		Запрос.УстановитьПараметр("СписокМПЗ", СписокНоменклатуры);		
		КонецЕсли; 
	Запрос.УстановитьПараметр("ДатаНач", Период.Значение.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаКон", Период.Значение.ДатаОкончания);
	Запрос.УстановитьПараметр("СписокМестХранения", СписокМестХранения);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 
		КолПереданных = КолПереданных + ?(ВыборкаДетальныеЗаписи.ЕдиницаИзмерения.ЕдиницаИзмерения <> ЕдиницаИзмерения,1,ВыборкаДетальныеЗаписи.Количество);
		Выборка = ТаблицаДокументов.НайтиСтроки(Новый Структура("Период",Период.Значение)); 
			Если Выборка.Количество() = 0 Тогда
			ТЧ = ТаблицаДокументов.Добавить();
			ТЧ.Период = Период.Значение;
			ТЧ.Документы.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
			Иначе
				Если Выборка[0].Документы.НайтиПоЗначению(ВыборкаДетальныеЗаписи.Ссылка) = Неопределено Тогда
				Выборка[0].Документы.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
				КонецЕсли;
			КонецЕсли; 
		КонецЦикла;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДвижениеМПЗТабличнаяЧасть.Количество КАК Количество,
		|	ДвижениеМПЗТабличнаяЧасть.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ДвижениеМПЗТабличнаяЧасть.МПЗ КАК МПЗ,
		|	ДвижениеМПЗТабличнаяЧасть.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ДвижениеМПЗ.ТабличнаяЧасть КАК ДвижениеМПЗТабличнаяЧасть
		|ГДЕ
		|	ДвижениеМПЗТабличнаяЧасть.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
		|	И ДвижениеМПЗТабличнаяЧасть.Ссылка.МестоХранения В(&СписокМестХранения)
		|	И ДвижениеМПЗТабличнаяЧасть.Ссылка.МестоХраненияВ = &МестоХраненияБрака
		|	И ДвижениеМПЗТабличнаяЧасть.МПЗ.Канбан.Подразделение = &Подразделение";
		Если СписокНоменклатуры.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + " И НЕ ДвижениеМПЗТабличнаяЧасть.МПЗ В ИЕРАРХИИ (&СписокМПЗ)";	
		Запрос.УстановитьПараметр("СписокМПЗ", СписокНоменклатуры);		
		КонецЕсли;
	Запрос.УстановитьПараметр("ДатаНач", Период.Значение.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаКон", Период.Значение.ДатаОкончания);
	Запрос.УстановитьПараметр("СписокМестХранения", СписокМестХранения);
	Запрос.УстановитьПараметр("МестоХраненияБрака", Подразделение.МестоХраненияБрака);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		КолПереданных = КолПереданных + ?(ВыборкаДетальныеЗаписи.ЕдиницаИзмерения.ЕдиницаИзмерения <> ЕдиницаИзмерения,1,ВыборкаДетальныеЗаписи.Количество);
		Выборка = ТаблицаДокументов.НайтиСтроки(Новый Структура("Период",Период.Значение)); 
			Если Выборка.Количество() = 0 Тогда
			ТЧ = ТаблицаДокументов.Добавить();
			ТЧ.Период = Период.Значение;
			ТЧ.Документы.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
			Иначе
				Если Выборка[0].Документы.НайтиПоЗначению(ВыборкаДетальныеЗаписи.Ссылка) = Неопределено Тогда
				Выборка[0].Документы.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	СписокОбщихКоличеств.Добавить(КолПереданных);
	КонецЦикла;
КонецПроцедуры 

&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();
ТаблицаРемонта = Новый ТаблицаЗначений;
Массив = Новый Массив;
СписокРемонтов = Новый СписокЗначений;

//ЕдиницаИзмерения = Справочники.ЕдиницыИзмерений.НайтиПоНаименованию("шт",Истина);

	Если ВидРасчёта = 1 Тогда
	ПолучитьКоличествоВыпущенных();
	Иначе	
	ПолучитьКоличествоПереданных();
	КонецЕсли;

Массив.Добавить(Тип("СправочникСсылка.Номенклатура"));
Массив.Добавить(Тип("СправочникСсылка.РабочиеМестаЛинеек"));
Массив.Добавить(Тип("СправочникСсылка.ВидыБрака"));
Массив.Добавить(Тип("СправочникСсылка.ПричиныРемонта"));
Массив.Добавить(Тип("СправочникСсылка.Материалы"));
Массив.Добавить(Тип("СправочникСсылка.ЭтапыЖизненногоЦикла"));
Массив.Добавить(Тип("Null"));
Массив.Добавить(Тип("Неопределено"));

ОписаниеТиповСправочников = Новый ОписаниеТипов(Массив);

ТаблицаРемонта.Колонки.Добавить("Параметр",ОписаниеТиповСправочников);

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапкаОбщие = Макет.ПолучитьОбласть("Шапка|Общие");
ОблПараметрОбщие = Макет.ПолучитьОбласть("Параметр|Общие");
ОблРасшифровкаОбщие = Макет.ПолучитьОбласть("Расшифровка|Общие");
ОблКонецОбщие = Макет.ПолучитьОбласть("Конец|Общие");
ОблШапкаПериод = Макет.ПолучитьОбласть("Шапка|Период");
ОблПараметрПериод = Макет.ПолучитьОбласть("Параметр|Период");
ОблРасшифровкаПериод = Макет.ПолучитьОбласть("Расшифровка|Период");
ОблКонецПериод = Макет.ПолучитьОбласть("Конец|Период");
	
СписокКолонокСуммирования = "";
Отчет.Период.ДатаНачала = ТекущаяДата();
Отчет.Период.ДатаОкончания = Дата(1,1,1);
Стр = 1;
	Для каждого Период Из СписокПериодов Цикл
	Отчет.Период.ДатаНачала = Мин(Отчет.Период.ДатаНачала,Период.Значение.ДатаНачала);
	Отчет.Период.ДатаОкончания = Макс(Отчет.Период.ДатаОкончания,Период.Значение.ДатаОкончания);
	ТаблицаРемонта.Колонки.Добавить("к"+Стр,Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(7,0)));
	СписокКолонокСуммирования = СписокКолонокСуммирования+"к"+Стр+",";
	Стр = Стр + 1;
	КонецЦикла; 
СписокКолонокСуммирования = Лев(СписокКолонокСуммирования,СтрДлина(СписокКолонокСуммирования)-1);

ОблШапкаОбщие.Параметры.ДатаНач = Отчет.Период.ДатаНачала;
ОблШапкаОбщие.Параметры.ДатаКон = Отчет.Период.ДатаОкончания;
ТабДок.Вывести(ОблШапкаОбщие);
Стр = 1;
	Для каждого Период Из СписокПериодов Цикл
	ОблШапкаПериод.Параметры.Период = Период.Значение;
	ОблШапкаПериод.Параметры.КоличествоДляРасчёта = СписокОбщихКоличеств[Стр-1].Значение;
	Выборка = ТаблицаДокументов.НайтиСтроки(Новый Структура("Период",Период.Значение));
		Если Выборка.Количество() > 0 Тогда
		ОблШапкаПериод.Параметры.Документы = Выборка[0].Документы;
		КонецЕсли; 
	ТабДок.Присоединить(ОблШапкаПериод);
	Стр = Стр + 1;
	КонецЦикла;

Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РемонтнаяКартаНеисправности.Ссылка КАК Ссылка,
	|	РемонтнаяКартаНеисправности.Ссылка.РабочееМесто КАК РабочееМесто,
	|	РемонтнаяКартаНеисправности.Ссылка.РабочееМесто.Наименование КАК РабочееМестоНаим,
	|	РемонтнаяКартаНеисправности.Ссылка.ДокументОснование.Изделие КАК Изделие,
	|	РемонтнаяКартаНеисправности.Ссылка.ДокументОснование.Изделие.Наименование КАК ИзделиеНаим,
	|	РемонтнаяКартаНеисправности.Ссылка.ДатаОкончания КАК Дата,
	|	РемонтнаяКартаНеисправности.НеисправныйМПЗ КАК МПЗ,
	|	РемонтнаяКартаНеисправности.НеисправныйМПЗ.Наименование КАК НеисправныйМПЗНаим,
	|	РемонтнаяКартаНеисправности.ВидБрака КАК ВидБрака,
	|	РемонтнаяКартаНеисправности.ВидБрака.Наименование КАК ВидБракаНаим,
	|	РемонтнаяКартаНеисправности.ЭтапЖизненногоЦикла КАК ЭтапЖизненногоЦикла,
	|	РемонтнаяКартаНеисправности.ЭтапЖизненногоЦикла.Наименование КАК ЭтапЖизненногоЦиклаНаим,
	|	РемонтнаяКартаНеисправности.МестоНахожденияБрака КАК МестоНахожденияБрака,
	|	РемонтнаяКартаНеисправности.МестоНахожденияБрака.Наименование КАК МестоНахожденияБракаНаим,
	|	РемонтнаяКартаНеисправности.Ссылка.ПричинаРемонта КАК ПричинаРемонта,
	|	РемонтнаяКартаНеисправности.Ссылка.ПричинаРемонта.Наименование КАК ПричинаРемонтаНаим,
	|	РемонтнаяКартаНеисправности.Количество КАК Количество,
	|	РемонтнаяКартаНеисправности.НеисправныйМПЗ.ОсновнаяЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	РемонтнаяКартаНеисправности.ПозицияМестаНахожденияБрака КАК ПозицияМестаНахожденияБрака
	|ИЗ
	|	Документ.РемонтнаяКарта.Неисправности КАК РемонтнаяКартаНеисправности
	|ГДЕ
	|	РемонтнаяКартаНеисправности.Ссылка.ДатаОкончания МЕЖДУ &ДатаНач И &ДатаКон
	|	И РемонтнаяКартаНеисправности.Ссылка.ПометкаУдаления = ЛОЖЬ";
	Если СписокПодразделений.Количество() > 0 Тогда
	Запрос.Текст = Запрос.Текст + " И РемонтнаяКартаНеисправности.Ссылка.Линейка.Подразделение В(&СписокПодразделений)";
	Запрос.УстановитьПараметр("СписокПодразделений",СписокПодразделений);
	КонецЕсли;
		Если СписокЛинеек.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + " И РемонтнаяКартаНеисправности.Ссылка.Линейка В ИЕРАРХИИ(&СписокЛинеек)";
		Запрос.УстановитьПараметр("СписокЛинеек",СписокЛинеек);
		КонецЕсли;
			Если СписокРабочихМест.Количество() > 0 Тогда
			Запрос.Текст = Запрос.Текст + " И РемонтнаяКартаНеисправности.Ссылка.РабочееМесто В ИЕРАРХИИ(&СписокРабочихМест)";
			Запрос.УстановитьПараметр("СписокРабочихМест",СписокРабочихМест);
			КонецЕсли;
				Если СписокЭтаповЖизненногоЦикла.Количество() > 0 Тогда
				Запрос.Текст = Запрос.Текст + " И РемонтнаяКартаНеисправности.ЭтапЖизненногоЦикла В ИЕРАРХИИ(&СписокЭтаповЖизненногоЦикла)";
				Запрос.УстановитьПараметр("СписокЭтаповЖизненногоЦикла",СписокЭтаповЖизненногоЦикла);
				КонецЕсли;		
					Если СписокГруппСпецификаций.Количество() > 0 Тогда
					Запрос.Текст = Запрос.Текст + " И РемонтнаяКартаНеисправности.Ссылка.ДокументОснование.Изделие В ИЕРАРХИИ(&СписокГруппСпецификаций)";
					Запрос.УстановитьПараметр("СписокГруппСпецификаций",СписокГруппСпецификаций);
					КонецЕсли;
						Если СписокГруппМПЗ.Количество() > 0 Тогда
						Запрос.Текст = Запрос.Текст + " И РемонтнаяКартаНеисправности.МестоНахожденияБрака В ИЕРАРХИИ(&СписокГруппМПЗ)";
						Запрос.УстановитьПараметр("СписокГруппМПЗ",СписокГруппМПЗ);
						КонецЕсли;
Запрос.Текст = Запрос.Текст + "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка,
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.РабочееМесто,
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.РабочееМесто.Наименование,
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.ДокументОснование.Изделие,
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.ДокументОснование.Изделие.Наименование,
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.Дата КАК Дата,
	|	ДвижениеМПЗТабличнаяЧасть.МПЗ,
	|	ДвижениеМПЗТабличнаяЧасть.МПЗ.Наименование,
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.ВидБрака,
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.ВидБрака.Наименование,
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.ЭтапЖизненногоЦикла,
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.ЭтапЖизненногоЦикла.Наименование,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ДвижениеМПЗТабличнаяЧасть.Количество,
	|	ДвижениеМПЗТабличнаяЧасть.ЕдиницаИзмерения,
	|	NULL
	|ИЗ
	|	Документ.ДвижениеМПЗ.ТабличнаяЧасть КАК ДвижениеМПЗТабличнаяЧасть
	|ГДЕ
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И ДвижениеМПЗТабличнаяЧасть.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И ТИПЗНАЧЕНИЯ(ДвижениеМПЗТабличнаяЧасть.Ссылка.ВидБрака) = ТИП(Справочник.ВидыБрака)";
	Если СписокПодразделений.Количество() > 0 Тогда
	Запрос.Текст = Запрос.Текст + " И ДвижениеМПЗТабличнаяЧасть.Ссылка.РабочееМесто.Линейка.Подразделение В(&СписокПодразделений)";
	Запрос.УстановитьПараметр("СписокПодразделений",СписокПодразделений);
	КонецЕсли;
		Если СписокЛинеек.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + " И ДвижениеМПЗТабличнаяЧасть.Ссылка.РабочееМесто.Линейка В ИЕРАРХИИ(&СписокЛинеек)";
		Запрос.УстановитьПараметр("СписокЛинеек",СписокЛинеек);
		КонецЕсли;
			Если СписокРабочихМест.Количество() > 0 Тогда
			Запрос.Текст = Запрос.Текст + " И ДвижениеМПЗТабличнаяЧасть.Ссылка.РабочееМесто В ИЕРАРХИИ(&СписокРабочихМест)";
			Запрос.УстановитьПараметр("СписокРабочихМест",СписокРабочихМест);
			КонецЕсли;
				Если СписокЭтаповЖизненногоЦикла.Количество() > 0 Тогда
				Запрос.Текст = Запрос.Текст + " И ДвижениеМПЗТабличнаяЧасть.Ссылка.ЭтапЖизненногоЦикла В ИЕРАРХИИ(&СписокЭтаповЖизненногоЦикла)";
				Запрос.УстановитьПараметр("СписокЭтаповЖизненногоЦикла",СписокЭтаповЖизненногоЦикла);
				КонецЕсли;		
					Если СписокГруппСпецификаций.Количество() > 0 Тогда
					Запрос.Текст = Запрос.Текст + " И ДвижениеМПЗТабличнаяЧасть.Ссылка.ДокументОснование.Изделие В ИЕРАРХИИ(&СписокГруппСпецификаций)";
					Запрос.УстановитьПараметр("СписокГруппСпецификаций",СписокГруппСпецификаций);
					КонецЕсли;	
Запрос.Текст = Запрос.Текст + "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СписаниеМПЗПрочееТабличнаяЧасть.Ссылка,
	|	СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.РабочееМесто,
	|	СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.РабочееМесто.Наименование,
	|	СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.ДокументОснование.Изделие,
	|	СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.ДокументОснование.Изделие.Наименование,
	|	СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.Дата КАК Дата,
	|	СписаниеМПЗПрочееТабличнаяЧасть.МПЗ,
	|	СписаниеМПЗПрочееТабличнаяЧасть.МПЗ.Наименование,
	|	СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.ВидБрака,
	|	СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.ВидБрака.Наименование,
	|	СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.ЭтапЖизненногоЦикла,
	|	СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.ЭтапЖизненногоЦикла.Наименование,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	СписаниеМПЗПрочееТабличнаяЧасть.Количество,
	|	СписаниеМПЗПрочееТабличнаяЧасть.ЕдиницаИзмерения,
	|	NULL	
	|ИЗ
	|	Документ.СписаниеМПЗПрочее.ТабличнаяЧасть КАК СписаниеМПЗПрочееТабличнаяЧасть
	|ГДЕ
	|	СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И ТИПЗНАЧЕНИЯ(СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.ВидБрака) = ТИП(Справочник.ВидыБрака)";
	Если СписокПодразделений.Количество() > 0 Тогда
	Запрос.Текст = Запрос.Текст + " И СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.РабочееМесто.Линейка.Подразделение В(&СписокПодразделений)";
	Запрос.УстановитьПараметр("СписокПодразделений",СписокПодразделений);
	КонецЕсли;
		Если СписокЛинеек.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + " И СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.РабочееМесто.Линейка В ИЕРАРХИИ(&СписокЛинеек)";
		Запрос.УстановитьПараметр("СписокЛинеек",СписокЛинеек);
		КонецЕсли;
			Если СписокРабочихМест.Количество() > 0 Тогда
			Запрос.Текст = Запрос.Текст + " И СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.РабочееМесто В ИЕРАРХИИ(&СписокРабочихМест)";
			Запрос.УстановитьПараметр("СписокРабочихМест",СписокРабочихМест);
			КонецЕсли;
				Если СписокЭтаповЖизненногоЦикла.Количество() > 0 Тогда
				Запрос.Текст = Запрос.Текст + " И СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.ЭтапЖизненногоЦикла В ИЕРАРХИИ(&СписокЭтаповЖизненногоЦикла)";
				Запрос.УстановитьПараметр("СписокЭтаповЖизненногоЦикла",СписокЭтаповЖизненногоЦикла);
				КонецЕсли;		
					Если СписокГруппСпецификаций.Количество() > 0 Тогда
					Запрос.Текст = Запрос.Текст + " И СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.ДокументОснование.Изделие В ИЕРАРХИИ(&СписокГруппСпецификаций)";
					Запрос.УстановитьПараметр("СписокГруппСпецификаций",СписокГруппСпецификаций);
					КонецЕсли;
						Если СортироватьПо = 1 Тогда
							Если ВидОтчёта = 1 Тогда	
							Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО Изделие";
							ИначеЕсли ВидОтчёта = 2 Тогда	
							Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО РабочееМестоНаим";	
							ИначеЕсли ВидОтчёта = 3 Тогда	
							Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО ВидБракаНаим";
							ИначеЕсли ВидОтчёта = 4 Тогда	
							Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО НеисправныйМПЗНаим";
							ИначеЕсли ВидОтчёта = 5 Тогда	
							Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО МестоНахожденияБракаНаим";
							ИначеЕсли ВидОтчёта = 6 Тогда	
							Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО ЭтапЖизненногоЦиклаНаим";
							ИначеЕсли ВидОтчёта = 7 Тогда	
							Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО ПричинаРемонтаНаим";
							КонецЕсли; 
								Если РасшифроватьПо = 1 Тогда	
								Запрос.Текст = Запрос.Текст + ",Изделие";
								ИначеЕсли РасшифроватьПо = 2 Тогда	
								Запрос.Текст = Запрос.Текст + ",РабочееМестоНаим";	
								ИначеЕсли РасшифроватьПо = 3 Тогда	
								Запрос.Текст = Запрос.Текст + ",ВидБракаНаим";
								ИначеЕсли РасшифроватьПо = 4 Тогда	
								Запрос.Текст = Запрос.Текст + ",НеисправныйМПЗНаим";
								ИначеЕсли РасшифроватьПо = 5 Тогда	
								Запрос.Текст = Запрос.Текст + ",МестоНахожденияБракаНаим";
								ИначеЕсли РасшифроватьПо = 6 Тогда	
								Запрос.Текст = Запрос.Текст + ",ЭтапЖизненногоЦиклаНаим";
								ИначеЕсли РасшифроватьПо = 7 Тогда	
								Запрос.Текст = Запрос.Текст + ",ПричинаРемонтаНаим";
								ИначеЕсли РасшифроватьПо = 8 Тогда	
								Запрос.Текст = Запрос.Текст + ",ПозицияМестаНахожденияБрака";								
								КонецЕсли;
						ИначеЕсли СортироватьПо = 2 Тогда
						Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО Количество";
						ИначеЕсли СортироватьПо = 3 Тогда
						Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО Количество УБЫВ";			
						КонецЕсли; 
Запрос.Текст = Запрос.Текст + "	ИТОГИ СУММА(Количество) ПО ОБЩИЕ";
	Если ВидОтчёта = 1 Тогда	
	Запрос.Текст = Запрос.Текст + ",Изделие";
	ИначеЕсли ВидОтчёта = 2 Тогда	
	Запрос.Текст = Запрос.Текст + ",РабочееМесто";	
	ИначеЕсли ВидОтчёта = 3 Тогда	
	Запрос.Текст = Запрос.Текст + ",ВидБрака";
	ИначеЕсли ВидОтчёта = 4 Тогда	
	Запрос.Текст = Запрос.Текст + ",МПЗ";
	ИначеЕсли ВидОтчёта = 5 Тогда	
	Запрос.Текст = Запрос.Текст + ",МестоНахожденияБрака";
	ИначеЕсли ВидОтчёта = 6 Тогда	
	Запрос.Текст = Запрос.Текст + ",ЭтапЖизненногоЦикла";
	ИначеЕсли ВидОтчёта = 7 Тогда	
	Запрос.Текст = Запрос.Текст + ",ПричинаРемонта";
	КонецЕсли; 
		Если РасшифроватьПо = 1 Тогда	
		Запрос.Текст = Запрос.Текст + ",Изделие";
		ИначеЕсли РасшифроватьПо = 2 Тогда	
		Запрос.Текст = Запрос.Текст + ",РабочееМесто";	
		ИначеЕсли РасшифроватьПо = 3 Тогда	
		Запрос.Текст = Запрос.Текст + ",ВидБрака";
		ИначеЕсли РасшифроватьПо = 4 Тогда	
		Запрос.Текст = Запрос.Текст + ",МПЗ";
		ИначеЕсли РасшифроватьПо = 5 Тогда	
		Запрос.Текст = Запрос.Текст + ",МестоНахожденияБрака";
		ИначеЕсли РасшифроватьПо = 6 Тогда	
		Запрос.Текст = Запрос.Текст + ",ЭтапЖизненногоЦикла";
		ИначеЕсли РасшифроватьПо = 7 Тогда	
		Запрос.Текст = Запрос.Текст + ",ПричинаРемонта";
		ИначеЕсли РасшифроватьПо = 8 Тогда	
		Запрос.Текст = Запрос.Текст + ",ПозицияМестаНахожденияБрака"		
		КонецЕсли;
Запрос.УстановитьПараметр("ДатаНач",НачалоДня(Отчет.Период.ДатаНачала));
Запрос.УстановитьПараметр("ДатаКон",КонецДня(Отчет.Период.ДатаОкончания));
Результат = Запрос.Выполнить();

Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
	ВыборкаПараметр = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПараметр.Следующий() Цикл
		СписокРемонтов.Очистить();
			Если ВидОтчёта = 1 Тогда
			Параметр = ВыборкаПараметр.Изделие;
			ИначеЕсли ВидОтчёта = 2 Тогда	
			Параметр = ВыборкаПараметр.РабочееМесто;	
			ИначеЕсли ВидОтчёта = 3 Тогда	
			Параметр = ВыборкаПараметр.ВидБрака;
			ИначеЕсли ВидОтчёта = 4 Тогда	
			Параметр = ВыборкаПараметр.МПЗ;
			ИначеЕсли ВидОтчёта = 5 Тогда	
			Параметр = ВыборкаПараметр.МестоНахожденияБрака;
			ИначеЕсли ВидОтчёта = 6 Тогда	
			Параметр = ВыборкаПараметр.ЭтапЖизненногоЦикла;
			ИначеЕсли ВидОтчёта = 7 Тогда	
			Параметр = ВыборкаПараметр.ПричинаРемонта;
			КонецЕсли;
					//Если ТипЗнч(Параметр) = Тип("Null") Тогда	
					//Продолжить;
					//КонецЕсли; 		
				Если РасшифроватьПо > 0 Тогда
			    ВыборкаРасш = ВыборкаПараметр.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Пока ВыборкаРасш.Следующий() Цикл
	                ВыборкаДаты = ВыборкаРасш.Выбрать(ОбходРезультатаЗапроса.Прямой);
						Пока ВыборкаДаты.Следующий() Цикл
							Если СписокРемонтов.НайтиПоЗначению(ВыборкаДаты.Ссылка) = Неопределено Тогда	
							СписокРемонтов.Добавить(ВыборкаДаты.Ссылка);
							КонецЕсли;					
						Стр = 1;
							Для каждого Период Из СписокПериодов Цикл	
								Если (ВыборкаДаты.Дата >= Период.Значение.ДатаНачала) и (ВыборкаДаты.Дата <= Период.Значение.ДатаОкончания) Тогда
								ТЧ = ТаблицаРемонта.Добавить();
								ТЧ.Параметр = Параметр;									
								//ТЧ.Установить(Стр,?(ВыборкаДаты.ЕдиницаИзмерения.ЕдиницаИзмерения <> ЕдиницаИзмерения,1,ВыборкаДаты.Количество));	
								ТЧ.Установить(Стр,ВыборкаДаты.Количество);
								Прервать;	
								КонецЕсли; 
							Стр = Стр + 1;
							КонецЦикла; 
						КонецЦикла;						
					КонецЦикла;
				Иначе
				ВыборкаДаты = ВыборкаПараметр.Выбрать(ОбходРезультатаЗапроса.Прямой);	
					Пока ВыборкаДаты.Следующий() Цикл
						Если СписокРемонтов.НайтиПоЗначению(ВыборкаДаты.Ссылка) = Неопределено Тогда	
						СписокРемонтов.Добавить(ВыборкаДаты.Ссылка);
						КонецЕсли; 
					Стр = 1;
						Для каждого Период Из СписокПериодов Цикл	
							Если (ВыборкаДаты.Дата >= Период.Значение.ДатаНачала) и (ВыборкаДаты.Дата <= Период.Значение.ДатаОкончания) Тогда
							ТЧ = ТаблицаРемонта.Добавить();
							ТЧ.Параметр = Параметр;	
							//ТЧ.Установить(Стр,?(ВыборкаДаты.ЕдиницаИзмерения.ЕдиницаИзмерения <> ЕдиницаИзмерения,1,ВыборкаДаты.Количество));									
							ТЧ.Установить(Стр,ВыборкаДаты.Количество);
							Прервать;	
							КонецЕсли; 
						Стр = Стр + 1;
						КонецЦикла;
					КонецЦикла;					
				КонецЕсли;
		КонецЦикла;
	КонецЦикла;
ТаблицаРемонта.Свернуть("Параметр",СписокКолонокСуммирования);	
	
Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
	ВыборкаПараметр = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПараметр.Следующий() Цикл
		КолНесоответствийВсего = ВыборкаПараметр.Ссылка;
			Если ВидОтчёта = 1 Тогда
			ОблПараметрОбщие.Параметры.Наименование = СокрЛП(ВыборкаПараметр.Изделие);
			ОблПараметрОбщие.Параметры.Расшифровка = ВыборкаПараметр.Изделие;		
			ИначеЕсли ВидОтчёта = 2 Тогда	
			ОблПараметрОбщие.Параметры.Наименование = СокрЛП(ВыборкаПараметр.РабочееМесто);	
			ОблПараметрОбщие.Параметры.Расшифровка = ВыборкаПараметр.РабочееМесто;				
			ИначеЕсли ВидОтчёта = 3 Тогда	
			ОблПараметрОбщие.Параметры.Наименование = СокрЛП(ВыборкаПараметр.ВидБрака);
			ОблПараметрОбщие.Параметры.Расшифровка = ВыборкаПараметр.ВидБрака;			
			ИначеЕсли ВидОтчёта = 4 Тогда	
			ОблПараметрОбщие.Параметры.Наименование = СокрЛП(ВыборкаПараметр.МПЗ);
			ОблПараметрОбщие.Параметры.Расшифровка = ВыборкаПараметр.МПЗ;
			ИначеЕсли ВидОтчёта = 5 Тогда	
			ОблПараметрОбщие.Параметры.Наименование = ВыборкаПараметр.МестоНахожденияБрака;
			ОблПараметрОбщие.Параметры.Расшифровка = ВыборкаПараметр.МестоНахожденияБрака;		
			ИначеЕсли ВидОтчёта = 6 Тогда	
			ОблПараметрОбщие.Параметры.Наименование = СокрЛП(ВыборкаПараметр.ЭтапЖизненногоЦикла);
			ОблПараметрОбщие.Параметры.Расшифровка = ВыборкаПараметр.ЭтапЖизненногоЦикла;
			ИначеЕсли ВидОтчёта = 7 Тогда	
			ОблПараметрОбщие.Параметры.Наименование = СокрЛП(ВыборкаПараметр.ПричинаРемонта);
			ОблПараметрОбщие.Параметры.Расшифровка = ВыборкаПараметр.ПричинаРемонта;				
			КонецЕсли;
				//Если ТипЗнч(ОблПараметрОбщие.Параметры.Расшифровка) = Тип("Null") Тогда	
				//Продолжить;
				//КонецЕсли; 
		ТЧ = ТаблицаРемонта.Найти(ОблПараметрОбщие.Параметры.Расшифровка,"Параметр");
			Если ТипЗнч(ОблПараметрОбщие.Параметры.Расшифровка) = Тип("Неопределено") Тогда
			ОблПараметрОбщие.Параметры.Наименование = "не выбран";
			ОблПараметрОбщие.Параметры.Расшифровка = "#";
			ИначеЕсли ТипЗнч(ОблПараметрОбщие.Параметры.Расшифровка) = Тип("Null") Тогда
			ОблПараметрОбщие.Параметры.Наименование = "реквизит не предусмотрен";
			ИначеЕсли ОблПараметрОбщие.Параметры.Расшифровка.Пустая() Тогда
			ОблПараметрОбщие.Параметры.Наименование = "не выбран";
			КонецЕсли; 
		ТабДок.Вывести(ОблПараметрОбщие);
		Стр = 1;
			Для каждого Период Из СписокПериодов Цикл
			КоличествоДляРасчёта = СписокОбщихКоличеств[Стр-1].Значение;
			ОблПараметрПериод.Параметры.КолНесоответствий = ?(ТЧ <> Неопределено,ТЧ.Получить(Стр),0);
			ОблПараметрПериод.Параметры.Процент = ?(ТаблицаРемонта.Итог("к"+Стр) > 0,Формат(ОблПараметрПериод.Параметры.КолНесоответствий*100/ТаблицаРемонта.Итог("к"+Стр),"ЧЦ=6; ЧДЦ=2"),0);
			ОблПараметрПериод.Параметры.КолНесоответствийНа100 = Формат(?(КоличествоДляРасчёта > 0,ОблПараметрПериод.Параметры.КолНесоответствий*100/КоличествоДляРасчёта,0),"ЧЦ=6; ЧДЦ=2");
			ТабДок.Присоединить(ОблПараметрПериод);
			Стр = Стр + 1;
			КонецЦикла; 			
				Если РасшифроватьПо > 0 Тогда
				ТабДок.НачатьГруппуСтрок("По параметру", Истина);
			    ВыборкаРасш = ВыборкаПараметр.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Пока ВыборкаРасш.Следующий() Цикл
						Если РасшифроватьПо = 1 Тогда	
						ОблРасшифровкаОбщие.Параметры.Наименование = СокрЛП(ВыборкаРасш.Изделие);
						ОблРасшифровкаОбщие.Параметры.Расшифровка = ВыборкаРасш.Изделие;			
						ИначеЕсли РасшифроватьПо = 2 Тогда	
						ОблРасшифровкаОбщие.Параметры.Наименование = СокрЛП(ВыборкаРасш.РабочееМесто);
						ОблРасшифровкаОбщие.Параметры.Расшифровка = ВыборкаРасш.РабочееМесто;						
						ИначеЕсли РасшифроватьПо = 3 Тогда	
						ОблРасшифровкаОбщие.Параметры.Наименование = СокрЛП(ВыборкаРасш.ВидБрака);
						ОблРасшифровкаОбщие.Параметры.Расшифровка = ВыборкаРасш.ВидБрака;						
						ИначеЕсли РасшифроватьПо = 4 Тогда	
						ОблРасшифровкаОбщие.Параметры.Наименование = СокрЛП(ВыборкаРасш.МПЗ);
						ОблРасшифровкаОбщие.Параметры.Расшифровка = ВыборкаРасш.МПЗ;
						ИначеЕсли РасшифроватьПо = 5 Тогда	
						ОблРасшифровкаОбщие.Параметры.Наименование = ВыборкаРасш.МестоНахожденияБрака;//СокрЛП(ВыборкаРасш.МестоНахожденияБрака.Наименование);
						ОблРасшифровкаОбщие.Параметры.Расшифровка = ВыборкаРасш.МестоНахожденияБрака;	
						ИначеЕсли РасшифроватьПо = 6 Тогда	
						ОблРасшифровкаОбщие.Параметры.Наименование = СокрЛП(ВыборкаРасш.ЭтапЖизненногоЦикла);
						ОблРасшифровкаОбщие.Параметры.Расшифровка = ВыборкаРасш.ЭтапЖизненногоЦикла;
						ИначеЕсли РасшифроватьПо = 7 Тогда	
						ОблРасшифровкаОбщие.Параметры.Наименование = СокрЛП(ВыборкаРасш.ПричинаРемонта);
						ОблРасшифровкаОбщие.Параметры.Расшифровка = ВыборкаРасш.ПричинаРемонта;
						ИначеЕсли РасшифроватьПо = 8 Тогда	
						ОблРасшифровкаОбщие.Параметры.Наименование = СокрЛП(ВыборкаРасш.ПозицияМестаНахожденияБрака);
						ОблРасшифровкаОбщие.Параметры.Расшифровка = ВыборкаРасш.ПозицияМестаНахожденияБрака;						
						КонецЕсли;
					ТабДок.Вывести(ОблРасшифровкаОбщие);
					ВыборкаДаты = ВыборкаРасш.Выбрать(ОбходРезультатаЗапроса.Прямой);
					Стр = 1;
						Для каждого Период Из СписокПериодов Цикл
						КоличествоДляРасчёта = СписокОбщихКоличеств[Стр-1].Значение;
						Кол = ?(ТЧ <> Неопределено,ТЧ.Получить(Стр),0);
						СписокРемонтов.Очистить();
						КолНесоответствий = 0;
						ВыборкаДаты.Сбросить();	
							Пока ВыборкаДаты.Следующий() Цикл
								Если СписокРемонтов.НайтиПоЗначению(ВыборкаДаты.Ссылка) = Неопределено Тогда	
								СписокРемонтов.Добавить(ВыборкаДаты.Ссылка);
								КонецЕсли; 
									Если (ВыборкаДаты.Дата >= Период.Значение.ДатаНачала) и (ВыборкаДаты.Дата <= Период.Значение.ДатаОкончания) Тогда
									КолНесоответствий = КолНесоответствий + ВыборкаДаты.Количество;	
									КонецЕсли;
							КонецЦикла; 
						ОблРасшифровкаПериод.Параметры.КолНесоответствий = КолНесоответствий;
						ОблРасшифровкаПериод.Параметры.Процент = ?(ТаблицаРемонта.Итог("к"+Стр) > 0,Формат(КолНесоответствий*100/ТаблицаРемонта.Итог("к"+Стр),"ЧЦ=6; ЧДЦ=2"),0);
						ОблРасшифровкаПериод.Параметры.КолНесоответствийНа100 = ?(КоличествоДляРасчёта > 0,Формат(КолНесоответствий*100/КоличествоДляРасчёта,"ЧЦ=6; ЧДЦ=2"),0);
						ТабДок.Присоединить(ОблРасшифровкаПериод);
						Стр = Стр + 1;
						КонецЦикла;						
					КонецЦикла;
				ТабДок.ЗакончитьГруппуСтрок();	
				КонецЕсли; 
		КонецЦикла;
	КонецЦикла;
ТабДок.Вывести(ОблКонецОбщие);
Стр = 1;
	Для каждого Период Из СписокПериодов Цикл
	КоличествоДляРасчёта = СписокОбщихКоличеств[Стр-1].Значение;
	ОблКонецПериод.Параметры.КолНесоответствийВсего = ТаблицаРемонта.Итог("к"+Стр);
	ОблКонецПериод.Параметры.КолНесоответствийНа100Всего = ?(КоличествоДляРасчёта > 0,Формат(ОблКонецПериод.Параметры.КолНесоответствийВсего*100/КоличествоДляРасчёта,"ЧЦ=6; ЧДЦ=2"),0);
	ТабДок.Присоединить(ОблКонецПериод);
	Стр = Стр + 1;
	КонецЦикла; 
ТабДок.ФиксацияСверху = 4;	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
		Если ВидРасчёта = 1 Тогда
			Если Подразделение.Пустая() и СписокЛинеекДляРасчёта.Количество() = 0 Тогда
		    Сообщить("Выберите подразделение или список линеек для расчёта!");
			Возврат;
			КонецЕсли;
		Иначе
			Если Подразделение.Пустая() Тогда
		    Сообщить("Выберите подразделение для расчёта!");
			Возврат;
			КонецЕсли;		
		КонецЕсли;
	СформироватьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПоказатьДокументы(СписокДокументов)
ТабДок1 = Новый ТабличныйДокумент;

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Документы");

ОблДокумент = Макет.ПолучитьОбласть("Документ");
	Для каждого Документ Из СписокДокументов Цикл	
	ОблДокумент.Параметры.Документ = Документ.Значение;
	ТабДок1.Вывести(ОблДокумент);		
	КонецЦикла;	
Возврат(ТабДок1);
КонецФункции 

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
	Если ТипЗнч(Расшифровка) = Тип("СписокЗначений") Тогда
	ТД = ПоказатьДокументы(Расшифровка);
	ТД.Показать("Список документов");
	ТД.Защита = Истина; 
	Возврат;
	КонецЕсли; 
Период = СписокПериодов[0].Значение;
СписокПараметров = Новый Структура();
	Если СписокЛинеек.Количество() > 0 Тогда
	СписокПараметров.Вставить("Линейка",СписокЛинеек);	
	КонецЕсли;
		Если СписокРабочихМест.Количество() > 0 Тогда
		СписокПараметров.Вставить("РабочееМесто",СписокРабочихМест);	
		КонецЕсли;
			Если СписокПодразделений.Количество() > 0 Тогда
			СписокПараметров.Вставить("Подразделение",СписокПодразделений);
			КонецЕсли; 
				Если СписокЭтаповЖизненногоЦикла.Количество() > 0 Тогда
				СписокПараметров.Вставить("ЭтапЖизненногоЦикла",СписокЭтаповЖизненногоЦикла);
				КонецЕсли;   
					Если ВидОтчёта = 1 Тогда
					СписокПараметров.Вставить("Изделие",Расшифровка);
					ВариантОтчёта = "ПоИзделиям";
					ИначеЕсли ВидОтчёта = 2 Тогда
					СписокПараметров.Вставить("РабочееМесто",Расшифровка);
					ВариантОтчёта = "ПоРабочимМестам";
					ИначеЕсли ВидОтчёта = 3 Тогда
					СписокПараметров.Вставить("ВидБрака",Расшифровка);
					ВариантОтчёта = "ПоВидамБрака";
					ИначеЕсли ВидОтчёта = 4 Тогда
					СписокПараметров.Вставить("НеисправныйМПЗ",Расшифровка);
					ВариантОтчёта = "ПоНеисправнымЭлементам";
					ИначеЕсли ВидОтчёта = 5 Тогда
					СписокПараметров.Вставить("МестоНахожденияБрака",Расшифровка);
					ВариантОтчёта = "ПоМестамНахожденияБрака";
					ИначеЕсли ВидОтчёта = 6 Тогда
					СписокПараметров.Вставить("ЭтапЖизненногоЦикла",Расшифровка);
					ВариантОтчёта = "ПоЭтапамЖизненногоЦикла";
					ИначеЕсли ВидОтчёта = 7 Тогда
					СписокПараметров.Вставить("ПричинаРемонта",Расшифровка);
					ВариантОтчёта = "ПоПричинамРемонта";
					КонецЕсли;
	Для каждого Период Из СписокПериодов Цикл
	ИмяОтчета = "ОтчётПоРемонтуПолный_СКД";
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,Период.Значение.ДатаНачала,Период.Значение.ДатаОкончания,СписокПараметров,ВариантОтчёта));
	ПараметрыФормы.Вставить("КлючВарианта",ВариантОтчёта); 
	ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы,,Истина);
	КонецЦикла; 
КонецПроцедуры
