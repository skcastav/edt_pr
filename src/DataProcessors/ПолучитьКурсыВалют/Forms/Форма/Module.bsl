
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.Период.ДатаНачала = ТекущаяДата();
Объект.Период.ДатаОкончания = ТекущаяДата();
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокВалют()
Запрос = Новый Запрос;

ТекстЗапроса = 
	"ВЫБРАТЬ
   |	Валюты.Ссылка КАК Ссылка,
   |	Валюты.Код КАК КодЧисловой
   |ИЗ
   |	Справочник.Валюты КАК Валюты
   |ГДЕ
   |	Валюты.Ссылка <> &Ссылка
   |
   |УПОРЯДОЧИТЬ ПО
   |	Валюты.Код";
Запрос.УстановитьПараметр("Ссылка",Константы.ОсновнаяВалюта.Получить());
Запрос.Текст = ТекстЗапроса; 	
Выборка = Запрос.Выполнить().Выгрузить();
Возврат Выборка;
КонецФункции

&НаСервере
Процедура ПолучитьКурсыВалютДляУкраины(НаДату)
СписокВалют = ПолучитьСписокВалют();
СписокВалют.Колонки.Добавить("Курс");
АдресЦБ = "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?date=" + Формат(НаДату, "ДФ=yyyyMMdd");

Чт = Новый ЧтениеXML;
    Попытка
    Чт.ОткрытьФайл(АдресЦБ);
    Исключение
	Сообщить(ОписаниеОшибки());
    Возврат;
    КонецПопытки;
КодВалюты = "";
	Пока Чт.Прочитать() Цикл
		Если Чт.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Если Чт.Имя = "r030" Тогда
			Атриб = "r030";
			ИначеЕсли Чт.Имя = "rate" Тогда
			Атриб = "rate";
			КонецЕсли;	
		ИначеЕсли Чт.ТипУзла = ТипУзлаXML.Текст Тогда
			Если Атриб = "r030" Тогда
			КодВалюты = Чт.Значение;
			ИначеЕсли Атриб = "rate" Тогда
			ВыбВалюта = СписокВалют.Найти(КодВалюты,"КодЧисловой");
				Если ВыбВалюта <> Неопределено Тогда
				ВыбВалюта.Курс = Чт.Значение;
				КонецЕсли;			 
			КонецЕсли;
		ИначеЕсли Чт.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
		Атриб = "";
        КонецЕсли; 
    КонецЦикла;
НаборЗаписей = РегистрыСведений.КурсыВалют.СоздатьНаборЗаписей();
НаборЗаписей.Отбор.Период.Установить(НаДату); 
	Для Каждого Строка Из СписокВалют Цикл	
		Если (ЗначениеЗаполнено(Строка.Курс)) Тогда
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Период = НаДату;
		НоваяЗапись.Валюта = Строка.Ссылка; 
		НоваяЗапись.Курс = Число(Строка.Курс);
		НоваяЗапись.Кратность = 1;
		КонецЕсли;
	КонецЦикла;
НаборЗаписей.Записать();
КонецПроцедуры
 
&НаСервере
Процедура ПолучитьКурсыВалютНаСервере(НаДату)
СписокВалют = ПолучитьСписокВалют();
СписокВалют.Колонки.Добавить("Курс");
СписокВалют.Колонки.Добавить("Кратность");
// АдресЦБРФ равен путь к файлу XML + КурсНаДату
// КурсНаДату должен содержать дату вида "01.01.2009" 
АдресЦБРФ = "http://www.cbr.ru/scripts/XML_daily.asp?date_req=" + Формат(НаДату, "ДФ = дд.ММ.гггг");

// Пробуем загрузить XML-файл с курсами валют
// В случае исключение возвращаем значение Неопределено
Чт = Новый ЧтениеXML;
    Попытка
    Чт.ОткрытьФайл(АдресЦБРФ);
    Исключение
    Возврат;
    КонецПопытки;
КодВалюты = "";
	Пока Чт.Прочитать() Цикл
		Если Чт.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Если Чт.Имя = "NumCode" Тогда
			Атриб = "NumCode";
			ИначеЕсли Чт.Имя = "Value" Тогда
			Атриб = "Value";
			ИначеЕсли Чт.Имя = "Nominal" Тогда
			Атриб = "Nominal";
			КонецЕсли;	
		ИначеЕсли Чт.ТипУзла = ТипУзлаXML.Текст Тогда
			Если Атриб = "NumCode" Тогда
			КодВалюты = Чт.Значение;
			ИначеЕсли Атриб = "Value" Тогда
			ВыбВалюта = СписокВалют.Найти(КодВалюты,"КодЧисловой");
				Если ВыбВалюта <> Неопределено Тогда
				ВыбВалюта.Курс = Чт.Значение;
				КонецЕсли;
			ИначеЕсли Атриб = "Nominal" Тогда
			ВыбВалюта = СписокВалют.Найти(КодВалюты,"КодЧисловой");
				Если ВыбВалюта <> Неопределено Тогда
				ВыбВалюта.Кратность = Чт.Значение;
				КонецЕсли;			 
			КонецЕсли;
		ИначеЕсли Чт.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
		Атриб = "";
        КонецЕсли; 
    КонецЦикла;
НаборЗаписей = РегистрыСведений.КурсыВалют.СоздатьНаборЗаписей();
НаборЗаписей.Отбор.Период.Установить(НаДату); 
	Для Каждого Строка Из СписокВалют Цикл	
		Если (ЗначениеЗаполнено(Строка.Курс)) Тогда
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Период = НаДату;
		НоваяЗапись.Валюта = Строка.Ссылка; 
		НоваяЗапись.Курс = Число(Строка.Курс);
		НоваяЗапись.Кратность = Число(Строка.Кратность);
		КонецЕсли;
	КонецЦикла;
НаборЗаписей.Записать();
КонецПроцедуры 
 
&НаСервере
Функция ЭтоРоссия()
Возврат(?(Константы.КодБазы.Получить() = "БГР",Истина,Ложь));
КонецФункции

&НаКлиенте
Процедура ПолучитьКурсыВалют(Команда)
НаДату = НачалоДня(Объект.Период.ДатаНачала);
	Пока НаДату <= Объект.Период.ДатаОкончания Цикл
		Если ЭтоРоссия() Тогда
		ПолучитьКурсыВалютНаСервере(НаДату);
		Иначе
		ПолучитьКурсыВалютДляУкраины(НаДату);
		КонецЕсли;		
	НаДату = НаДату + 86400;
	КонецЦикла; 
//ЭтотОбъект.Закрыть();
КонецПроцедуры
