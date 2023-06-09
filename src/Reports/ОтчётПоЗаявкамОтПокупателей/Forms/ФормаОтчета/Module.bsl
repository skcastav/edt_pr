
&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();

ТаблицаИзделий = Новый ТаблицаЗначений;

ТаблицаИзделий.Колонки.Добавить("Линейка",Новый ОписаниеТипов("СправочникСсылка.Линейки"));
ТаблицаИзделий.Колонки.Добавить("Изделие",Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
ТаблицаИзделий.Колонки.Добавить("КолПроизв",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(9,3)));
ТаблицаИзделий.Колонки.Добавить("КолНезап",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(9,3)));
ТаблицаИзделий.Колонки.Добавить("КолПЭО",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(9,3)));


ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблЗаявка = Макет.ПолучитьОбласть("Заявка");
ОблМПЗ = Макет.ПолучитьОбласть("МПЗ");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.ДатаНач = Формат(Отчет.Период.ДатаНачала,"ДФ=dd.MM.yyyy");
ОблШапка.Параметры.ДатаКон = Формат(Отчет.Период.ДатаОкончания,"ДФ=dd.MM.yyyy");
ТабДок.Вывести(ОблШапка);

Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаявкиОтПокупателейОстаткиИОбороты.ЗаявкаОтПокупателя КАК ЗаявкаОтПокупателя,
	|	ЗаявкиОтПокупателейОстаткиИОбороты.МПЗ КАК МПЗ,
	|	ЗаявкиОтПокупателейОстаткиИОбороты.КоличествоНачальныйОстаток,
	|	ЗаявкиОтПокупателейОстаткиИОбороты.КоличествоКонечныйОстаток,
	|	ЗаявкиОтПокупателейОстаткиИОбороты.КоличествоПриход,
	|	ЗаявкиОтПокупателейОстаткиИОбороты.КоличествоРасход,
	|	ЗаявкиОтПокупателейОстаткиИОбороты.Регистратор
	|ИЗ
	|	РегистрНакопления.ЗаявкиОтПокупателей.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор, , ) КАК ЗаявкиОтПокупателейОстаткиИОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаявкиОтПокупателейОстаткиИОбороты.ЗаявкаОтПокупателя.Номер,
	|	МПЗ
	|ИТОГИ ПО
	|	ЗаявкаОтПокупателя";
Запрос.УстановитьПараметр("ДатаНач",НачалоДня(Отчет.Период.ДатаНачала));
Запрос.УстановитьПараметр("ДатаКон",КонецДня(Отчет.Период.ДатаОкончания));
РезультатЗапроса = Запрос.Выполнить();
ВыборкаЗаявки = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаЗаявки.Следующий() Цикл
	ОблЗаявка.Параметры.НомерЗаявки = ВыборкаЗаявки.ЗаявкаОтПокупателя.Номер;
	ОблЗаявка.Параметры.ДатаЗаявки = ВыборкаЗаявки.ЗаявкаОтПокупателя.Дата;
	ОблЗаявка.Параметры.Заявка = ВыборкаЗаявки.ЗаявкаОтПокупателя;
	ТабДок.Вывести(ОблЗаявка);
	ВыборкаДетальнойЗаписи = ВыборкаЗаявки.Выбрать();
		Пока ВыборкаДетальнойЗаписи.Следующий() Цикл
		ОблМПЗ.Параметры.Наименование = ВыборкаДетальнойЗаписи.МПЗ.Наименование;
		ОблМПЗ.Параметры.МПЗ = ВыборкаДетальнойЗаписи.МПЗ;
		ОблМПЗ.Параметры.НО = ВыборкаДетальнойЗаписи.КоличествоНачальныйОстаток;
		ОблМПЗ.Параметры.Заявлено = ВыборкаДетальнойЗаписи.КоличествоПриход;
		ОблМПЗ.Параметры.Отгружено = ВыборкаДетальнойЗаписи.КоличествоРасход;
			Если ЗначениеЗаполнено(ОблМПЗ.Параметры.ДатаОтгрузки) Тогда
			ОблМПЗ.Параметры.ДатаОтгрузки = Формат(ВыборкаДетальнойЗаписи.Регистратор.Дата,"ДФ=dd.MM.yyyy");
			КонецЕсли;
		ОблМПЗ.Параметры.КО = ВыборкаДетальнойЗаписи.КоличествоКонечныйОстаток;
		ТабДок.Вывести(ОблМПЗ);
		КонецЦикла;
	КонецЦикла;
ТабДок.Вывести(ОблКонец);
ТабДок.ФиксацияСверху = 2;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	СформироватьНаСервере();
	КонецЕсли; 
КонецПроцедуры
