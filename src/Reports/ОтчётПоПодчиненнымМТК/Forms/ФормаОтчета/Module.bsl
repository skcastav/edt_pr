
&НаСервере
Функция ПолучитьПЗ(МТК)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПроизводственноеЗадание.Ссылка
	|ИЗ
	|	Документ.ПроизводственноеЗадание КАК ПроизводственноеЗадание
	|ГДЕ
	|	ПроизводственноеЗадание.ДокументОснование = &ДокументОснование";

Запрос.УстановитьПараметр("ДокументОснование", МТК);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
КонецФункции

&НаСервере
Процедура ВывестиПодчиненныеМТК(МТК,Уровень)
Уровень = Уровень + "   ";
ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблПодчМТК = Макет.ПолучитьОбласть("ПодчМТК");

Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаршрутнаяКарта.Ссылка
	|ИЗ
	|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
	|ГДЕ
	|	МаршрутнаяКарта.ДокументОснование = &ДокументОснование";
Запрос.УстановитьПараметр("ДокументОснование",МТК);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.Ссылка.Статус = 0 Тогда
		Статус = "В ожидании";
		ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка.Статус = 1 Тогда
		Статус = "В работе";			
		ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка.Статус = 2 Тогда
		Статус = "Остановлена";
		ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка.Статус = 3 Тогда
		Статус = "Завершена";
		ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка.Статус = 4 Тогда
		Статус = "Запущена";		
		КонецЕсли;
	ОблПодчМТК.Параметры.Статус = Статус;
	ОблПодчМТК.Параметры.Уровень = Уровень;
	ОблПодчМТК.Параметры.МТК = ВыборкаДетальныеЗаписи.Ссылка;
	ПЗ = ПолучитьПЗ(ВыборкаДетальныеЗаписи.Ссылка);
	ОблПодчМТК.Параметры.Оборудование = ?(ПЗ.Оборудование.Количество() > 0,"Назначено","");
	ОблПодчМТК.Параметры.Линейка = ВыборкаДетальныеЗаписи.Ссылка.Линейка;
	ОблПодчМТК.Параметры.Наименование = СокрЛП(ВыборкаДетальныеЗаписи.Ссылка.Номенклатура.Наименование);
	ОблПодчМТК.Параметры.МПЗ = ВыборкаДетальныеЗаписи.Ссылка.Номенклатура;
	ОблПодчМТК.Параметры.Количество = ВыборкаДетальныеЗаписи.Ссылка.Количество;
	ТекОбл = ТабДок.Вывести(ОблПодчМТК);
		Если ВыборкаДетальныеЗаписи.Ссылка.Статус = 0 Тогда
		ТабДок.Область(ТекОбл.Верх, ТекОбл.Лево, ТекОбл.Низ, ТекОбл.Право).ЦветТекста = WebЦвета.Красный;
		ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка.Статус = 1 Тогда
		ТабДок.Область(ТекОбл.Верх, ТекОбл.Лево, ТекОбл.Низ, ТекОбл.Право).ЦветТекста = WebЦвета.Красный;			
		ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка.Статус = 2 Тогда
		ТабДок.Область(ТекОбл.Верх, ТекОбл.Лево, ТекОбл.Низ, ТекОбл.Право).ЦветТекста = WebЦвета.Красный;
		ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка.Статус = 4 Тогда
		ТабДок.Область(ТекОбл.Верх, ТекОбл.Лево, ТекОбл.Низ, ТекОбл.Право).ЦветТекста = WebЦвета.Красный;
		КонецЕсли;
	ТабДок.НачатьГруппуСтрок("ПодчМТК",Истина);
	ВывестиПодчиненныеМТК(ВыборкаДетальныеЗаписи.Ссылка,Уровень);
	ТабДок.ЗакончитьГруппуСтрок();
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ЕстьПодчиненныеМТК(МТК)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	МаршрутнаяКарта.Ссылка
	|ИЗ
	|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
	|ГДЕ
	|	МаршрутнаяКарта.ДокументОснование = &ДокументОснование";
Запрос.УстановитьПараметр("ДокументОснование",МТК);
РезультатЗапроса = Запрос.Выполнить();
Возврат(Не РезультатЗапроса.Пустой());
КонецФункции

&НаСервере
Функция ЗавершеныВсеПодчиненныеМТК(МТК)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	МаршрутнаяКарта.Ссылка
	|ИЗ
	|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
	|ГДЕ
	|	МаршрутнаяКарта.ДокументОснование = &ДокументОснование
	|	И МаршрутнаяКарта.Статус <> 3";
Запрос.УстановитьПараметр("ДокументОснование",МТК);
РезультатЗапроса = Запрос.Выполнить();
Возврат(РезультатЗапроса.Пустой());
КонецФункции

&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблМТК = Макет.ПолучитьОбласть("МТК");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ТабДок.Вывести(ОблШапка);

Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаршрутнаяКарта.Ссылка
	|ИЗ
	|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
	|ГДЕ
	|	МаршрутнаяКарта.Статус <> 3";
	Если ЗначениеЗаполнено(Отчет.Период.ДатаНачала) Тогда	
	Запрос.Текст = Запрос.Текст + " И МаршрутнаяКарта.Дата МЕЖДУ &ДатаНач И &ДатаКон";
	Запрос.УстановитьПараметр("ДатаНач",НачалоДня(Отчет.Период.ДатаНачала));
	Запрос.УстановитьПараметр("ДатаКон",КонецДня(Отчет.Период.ДатаОкончания));	
	КонецЕсли; 
		Если Не Подразделение.Пустая() Тогда
		Запрос.Текст = Запрос.Текст + " И МаршрутнаяКарта.Подразделение = &Подразделение";
		Запрос.УстановитьПараметр("Подразделение",Подразделение);
		КонецЕсли;
			Если СписокЛинеек.Количество() > 0 Тогда
			Запрос.Текст = Запрос.Текст + " И МаршрутнаяКарта.Линейка В(&СписокЛинеек)";
			Запрос.УстановитьПараметр("СписокЛинеек",СписокЛинеек);
			Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО МаршрутнаяКарта.Линейка,МаршрутнаяКарта.Дата";
			Иначе
			Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО МаршрутнаяКарта.Дата";
			КонецЕсли;  
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ТолькоСПодчиненнымиМТК Тогда
			Если Не ЕстьПодчиненныеМТК(ВыборкаДетальныеЗаписи.Ссылка) Тогда
			Продолжить;
			КонецЕсли;
		КонецЕсли; 
			Если НеПоказыватьСЗавершеннымиПодчиненнымиМТК Тогда	
				Если ЗавершеныВсеПодчиненныеМТК(ВыборкаДетальныеЗаписи.Ссылка) Тогда
				Продолжить;
				КонецЕсли; 
			КонецЕсли; 
				Если ВыборкаДетальныеЗаписи.Ссылка.Статус = 0 Тогда
				Статус = "В ожидании";
				ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка.Статус = 1 Тогда
				Статус = "В работе";			
				ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка.Статус = 2 Тогда
				Статус = "Остановлена";
				ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка.Статус = 3 Тогда
				Статус = "Завершена";
				ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка.Статус = 4 Тогда
				Статус = "Запущена";		
				КонецЕсли; 
	ОблМТК.Параметры.Статус = Статус;
	ОблМТК.Параметры.НомерСтатуса = ВыборкаДетальныеЗаписи.Ссылка.Статус;
	ОблМТК.Параметры.МТК = ВыборкаДетальныеЗаписи.Ссылка;
	ОблМТК.Параметры.Линейка = ВыборкаДетальныеЗаписи.Ссылка.Линейка;
	ОблМТК.Параметры.Наименование = СокрЛП(ВыборкаДетальныеЗаписи.Ссылка.Номенклатура.Наименование);
	ОблМТК.Параметры.МПЗ = ВыборкаДетальныеЗаписи.Ссылка.Номенклатура;
	ОблМТК.Параметры.Количество = ВыборкаДетальныеЗаписи.Ссылка.Количество;
	ТабДок.Вывести(ОблМТК);
	ТабДок.НачатьГруппуСтрок("МТК",Истина);
	ВывестиПодчиненныеМТК(ВыборкаДетальныеЗаписи.Ссылка,"");
	ТабДок.ЗакончитьГруппуСтрок();	
	КонецЦикла;
ТабДок.Вывести(ОблКонец);
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	СформироватьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Отчет.Период.ДатаНачала = НачалоМесяца(ТекущаяДата());
Отчет.Период.ДатаОкончания = ТекущаяДата();
КонецПроцедуры
