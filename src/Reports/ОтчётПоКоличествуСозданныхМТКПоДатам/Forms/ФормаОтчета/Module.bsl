
&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();

СписокПериодов = Новый СписокЗначений;
Запрос = Новый Запрос;

ТекДата = Отчет.Период.ДатаНачала;
	Пока ТекДата <= Отчет.Период.ДатаОкончания Цикл
	СписокПериодов.Добавить(ТекДата,"0");			
	ТекДата = ТекДата + 86400;
	КонецЦикла;
	
ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");
 
ОблШапкаОбщая = Макет.ПолучитьОбласть("Шапка|Общая");
ОблШапкаПериод = Макет.ПолучитьОбласть("Шапка|Период");
ОблШапкаИтого = Макет.ПолучитьОбласть("Шапка|Итого");
ОблСтрокаОбщая = Макет.ПолучитьОбласть("Строка|Общая");
ОблСтрокаПериод = Макет.ПолучитьОбласть("Строка|Период");
ОблСтрокаИтого = Макет.ПолучитьОбласть("Строка|Итого");
ОблКонецОбщая = Макет.ПолучитьОбласть("Конец|Общая");
ОблКонецПериод = Макет.ПолучитьОбласть("Конец|Период");
ОблКонецИтого = Макет.ПолучитьОбласть("Конец|Итого");

ОблШапкаОбщая.Параметры.ДатаНач = Формат(Отчет.Период.ДатаНачала,"ДФ=dd.MM.yyyy");
ОблШапкаОбщая.Параметры.ДатаКон = Формат(Отчет.Период.ДатаОкончания,"ДФ=dd.MM.yyyy");
ТабДок.Вывести(ОблШапкаОбщая);
	Для каждого Период Из СписокПериодов Цикл
	ОблШапкаПериод.Параметры.Период = Формат(Период.Значение,"ДФ=dd.MM.yyyy"); 	
	ТабДок.Присоединить(ОблШапкаПериод);		
	КонецЦикла;
ТабДок.Присоединить(ОблШапкаИтого);
Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаршрутнаяКарта.Ссылка КАК Ссылка,
	|	МаршрутнаяКарта.Дата КАК Период,
	|	МаршрутнаяКарта.Номенклатура КАК Номенклатура
	|ИЗ
	|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
	|ГДЕ
	|	МаршрутнаяКарта.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И МаршрутнаяКарта.СтандартныйКомментарий = &СтандартныйКомментарий";
	Если Не Отчет.Подразделение.Пустая() Тогда	
	Запрос.Текст = Запрос.Текст + " И МаршрутнаяКарта.Подразделение = &Подразделение";
	Запрос.УстановитьПараметр("Подразделение", Отчет.Подразделение);
	КонецЕсли;
Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО МаршрутнаяКарта.Номенклатура.Товар.Наименование 
								| ИТОГИ ПО Номенклатура"; 
Запрос.УстановитьПараметр("ДатаНач", Отчет.Период.ДатаНачала);
Запрос.УстановитьПараметр("ДатаКон", Отчет.Период.ДатаОкончания);
Запрос.УстановитьПараметр("СтандартныйКомментарий", Отчет.СтандартныйКомментарий);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаНоменклатура = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
КолВсего = 0;
	Пока ВыборкаНоменклатура.Следующий() Цикл
	КолИтого = 0;
	ОблСтрокаОбщая.Параметры.Наименование = СокрЛП(ВыборкаНоменклатура.Номенклатура.Наименование);
	ОблСтрокаОбщая.Параметры.Изделие = ВыборкаНоменклатура.Номенклатура;
	ТабДок.Вывести(ОблСтрокаОбщая);
	ВыборкаДетельныхЗаписей = ВыборкаНоменклатура.Выбрать();
		Для каждого Период Из СписокПериодов Цикл
		ВыборкаДетельныхЗаписей.Сбросить();
		Кол = 0;
			Пока ВыборкаДетельныхЗаписей.Следующий() Цикл
				Если НачалоДня(ВыборкаДетельныхЗаписей.Период) = Период.Значение Тогда
				Кол = Кол + 1;
				Период.Представление = Число(Период.Представление) + 1;			
				КонецЕсли; 	
			КонецЦикла;
		ОблСтрокаПериод.Параметры.Количество = Кол; 		
		ТабДок.Присоединить(ОблСтрокаПериод);
		КолИтого = КолИтого + Кол;
		КонецЦикла;
	ОблСтрокаИтого.Параметры.КоличествоИтого = КолИтого;	
	ТабДок.Присоединить(ОблСтрокаИтого);
	КонецЦикла;
ТабДок.Вывести(ОблКонецОбщая);
	Для каждого Период Из СписокПериодов Цикл
	ОблКонецПериод.Параметры.КоличествоПериод = Период.Представление; 	
	ТабДок.Присоединить(ОблКонецПериод);
	КолВсего = КолВсего + Число(Период.Представление);		
	КонецЦикла;
ОблКонецИтого.Параметры.КоличествоВсего = КолВсего;
ТабДок.Присоединить(ОблКонецИтого);
ТабДок.ФиксацияСверху = 2;
ТабДок.ФиксацияСлева = 1;	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
СформироватьНаСервере();
КонецПроцедуры
