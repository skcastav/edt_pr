
&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();

Массив = Новый Массив;
ТаблицаМПЗ = Новый ТаблицаЗначений;

Массив.Добавить(Тип("СправочникСсылка.Номенклатура"));
Массив.Добавить(Тип("СправочникСсылка.Материалы"));

ТаблицаМПЗ.Колонки.Добавить("МПЗ",Новый ОписаниеТипов(Массив));
ТаблицаМПЗ.Колонки.Добавить("Документ",Новый ОписаниеТипов("ДокументСсылка.ДвижениеМПЗ"));
ТаблицаМПЗ.Колонки.Добавить("Дата",Новый ОписаниеТипов("Дата"));
ТаблицаМПЗ.Колонки.Добавить("Количество",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(14,3)));
ТаблицаМПЗ.Колонки.Добавить("Комментарий",Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(255)));
 
Макет = Отчеты.ОтчетПоБракуКомплектующих.ПолучитьМакет("Макет"); 
ОблШапка = Макет.ПолучитьОбласть("Шапка");	
ОблМПЗ = Макет.ПолучитьОбласть("МПЗ");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.ДатаНач = Формат(Отчет.Период.ДатаНачала,"ДФ=dd.MM.yyyy");
ОблШапка.Параметры.ДатаКон = Формат(Отчет.Период.ДатаОкончания,"ДФ=dd.MM.yyyy");
ОблШапка.Параметры.МестоХраненияБрака = Отчет.МестоХраненияБрака.Наименование;
ТабДок.Вывести(ОблШапка); 

Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаХраненияОстаткиИОбороты.КоличествоПриход,
	|	МестаХраненияОстаткиИОбороты.МПЗ КАК МПЗ,
	|	МестаХраненияОстаткиИОбороты.Регистратор КАК Регистратор,
	|	МестаХраненияОстаткиИОбороты.Регистратор.Комментарий КАК Комментарий
	|ИЗ
	|	РегистрНакопления.МестаХранения.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор, , ) КАК МестаХраненияОстаткиИОбороты
	|ГДЕ
	|	МестаХраненияОстаткиИОбороты.МестоХранения = &МестоХранения";
Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Отчет.Период.ДатаНачала));
Запрос.УстановитьПараметр("ДатаКон", КонецДня(Отчет.Период.ДатаОкончания));
Запрос.УстановитьПараметр("МестоХранения", Отчет.МестоХраненияБрака);  
	Если ЗначениеЗаполнено(МПЗ) Тогда
	Запрос.Текст = Запрос.Текст + " И МестаХраненияОстаткиИОбороты.МПЗ = &МПЗ";
 	Запрос.УстановитьПараметр("МПЗ", МПЗ);
	КонецЕсли;
		Если ЗначениеЗаполнено(Документ) Тогда
		Запрос.Текст = Запрос.Текст + " И МестаХраненияОстаткиИОбороты.Регистратор = &Документ";
	 	Запрос.УстановитьПараметр("Документ", Документ);
		КонецЕсли; 
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ЗначениеЗаполнено(ПодстрокаКомментария) Тогда
			Если Найти(ВРег(ВыборкаДетальныеЗаписи.Комментарий),Врег(ПодстрокаКомментария)) = 0 Тогда
			Продолжить;
			КонецЕсли;	
		КонецЕсли;
	ТЧ = ТаблицаМПЗ.Добавить();
	ТЧ.МПЗ = ВыборкаДетальныеЗаписи.МПЗ;
	ТЧ.Документ = ВыборкаДетальныеЗаписи.Регистратор;
	ТЧ.Количество = ВыборкаДетальныеЗаписи.КоличествоПриход;
	ТЧ.Комментарий = ВыборкаДетальныеЗаписи.Комментарий;			
	КонецЦикла;
		Если СортироватьПо = 1 Тогда
		ТаблицаМПЗ.Сортировать("МПЗ");
		ИначеЕсли СортироватьПо = 2 Тогда
		ТаблицаМПЗ.Сортировать("Документ");
		ИначеЕсли СортироватьПо = 3 Тогда
		ТаблицаМПЗ.Сортировать("Комментарий");	
		КонецЕсли; 
			Для каждого ТЧ Из ТаблицаМПЗ Цикл
			ОблМПЗ.Параметры.Наименование = СокрЛП(ТЧ.МПЗ.Наименование);
			ОблМПЗ.Параметры.МПЗ = ТЧ.МПЗ;
			ОблМПЗ.Параметры.Документ = ТЧ.Документ;
			ОблМПЗ.Параметры.Количество = ТЧ.Количество;
			ОблМПЗ.Параметры.ЕдиницаИзмерения = ТЧ.МПЗ.ЕдиницаИзмерения;
			ОблМПЗ.Параметры.Комментарий = ТЧ.Комментарий;
			ОблМПЗ.Параметры.ФИО = ТЧ.Документ.Автор;
			ОблМПЗ.Параметры.СкладОтправитель = ТЧ.Документ.МестоХранения;
			ТабДок.Вывести(ОблМПЗ);		
			КонецЦикла;
ОблКонец.Параметры.КоличествоИтого = ТаблицаМПЗ.Итог("Количество"); 
ТабДок.Вывести(ОблКонец);
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
СортироватьПо = 1;
КонецПроцедуры
