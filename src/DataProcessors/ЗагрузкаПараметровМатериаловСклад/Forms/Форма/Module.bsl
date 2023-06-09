
&НаСервере
Процедура ИзменитьНаСервере(Запись)
Наимен = СтрЗаменить(Запись.Наименование,"?","±");
Выбор = Справочники.Материалы.НайтиПоНаименованию(Наимен,Истина);
	Если Не Выбор.Пустая() Тогда
	Мат = Выбор.ПолучитьОбъект();
	флИзменен = Ложь;
    ЗначениеПараметра = Неопределено;
    	Если Запись.Свойство("ЗонаХранения",ЗначениеПараметра) Тогда
			Если ЗначениеПараметра = "Горячая" Тогда
			ЗонаХранения = Перечисления.ЗоныХранения.Горячая;
			ИначеЕсли ЗначениеПараметра = "Теплая" Тогда
			ЗонаХранения = Перечисления.ЗоныХранения.Теплая;	
			ИначеЕсли ЗначениеПараметра = "Холодная" Тогда
			ЗонаХранения = Перечисления.ЗоныХранения.Холодная;
			ИначеЕсли ЗначениеПараметра = "Невостребованная" Тогда
			ЗонаХранения = Перечисления.ЗоныХранения.Невостребованная;
			ИначеЕсли ЗначениеПараметра = "Проектная" Тогда
			ЗонаХранения = Перечисления.ЗоныХранения.Проектная;
			КонецЕсли; 
				Если Мат.ЗонаХранения <> ЗонаХранения Тогда
				Мат.ЗонаХранения = ЗонаХранения;
				флИзменен = Истина;			
				КонецЕсли; 
		КонецЕсли;
	ЗначениеПараметра = Неопределено;
    	Если Запись.Свойство("НормативРабочейЯчейки",ЗначениеПараметра) Тогда
			Если Мат.НормативРабочейЯчейки <> ЗначениеПараметра Тогда
			Мат.НормативРабочейЯчейки = ЗначениеПараметра;
			флИзменен = Истина;
			КонецЕсли; 
		КонецЕсли; 
	ЗначениеПараметра = Неопределено;
    	Если Запись.Свойство("КоличествоУпаковок",ЗначениеПараметра) Тогда
			Если Мат.КоличествоУпаковок <> ЗначениеПараметра Тогда
			Мат.КоличествоУпаковок = ЗначениеПараметра;
			флИзменен = Истина;
			КонецЕсли; 
		КонецЕсли;
	ЗначениеПараметра = Неопределено;
    	Если Запись.Свойство("КратностьГрупповойУпаковки",ЗначениеПараметра) Тогда
			Если Мат.КратностьГрупповойУпаковки <> ЗначениеПараметра Тогда
			Мат.КратностьГрупповойУпаковки = ЗначениеПараметра;
			флИзменен = Истина;
			КонецЕсли; 
		КонецЕсли;
	ЗначениеПараметра = Неопределено;
    	Если Запись.Свойство("КратностьИндивидуальнойУпаковки",ЗначениеПараметра) Тогда
			Если Мат.КратностьИндивидуальнойУпаковки <> ЗначениеПараметра Тогда
			Мат.КратностьИндивидуальнойУпаковки = ЗначениеПараметра;
			флИзменен = Истина;
			КонецЕсли; 
		КонецЕсли;
	ЗначениеПараметра = Неопределено;
    	Если Запись.Свойство("ПризнакНеделимойУпаковки",ЗначениеПараметра) Тогда
			Если Мат.ПризнакНеделимойУпаковки <> ЗначениеПараметра Тогда
			Мат.ПризнакНеделимойУпаковки = ЗначениеПараметра;
			флИзменен = Истина;
			КонецЕсли; 
		КонецЕсли;
	ЗначениеПараметра = Неопределено;			
    	Если Запись.Свойство("Фасовка",ЗначениеПараметра) Тогда
			Если Мат.Фасовка <> ЗначениеПараметра Тогда
			Мат.Фасовка = ЗначениеПараметра;
			флИзменен = Истина;		
			КонецЕсли; 
		КонецЕсли;
	ЗначениеПараметра = Неопределено;
    	Если Запись.Свойство("Возвратный",ЗначениеПараметра) Тогда
		Возвратный = ?(ЗначениеПараметра = "1",Истина,Ложь);
			Если Мат.Возвратный <> Возвратный Тогда
			Мат.Возвратный = Возвратный;
			флИзменен = Истина;
			КонецЕсли; 
		КонецЕсли;
			Если флИзменен Тогда
			Мат.Записать();
			КонецЕсли;
	Иначе
    Сообщить(Запись.Наименование+" не найден!");
	КонецЕсли; 
КонецПроцедуры 

&НаКлиенте
Процедура Изменить(Команда)
	Для каждого ТЧ Из ТаблицаПараметров Цикл
		Если СокрЛП(ТЧ.Параметр) = "выберите соответствие" Тогда
		Сообщить("Не все колонки идентифицированы!");
		Возврат;
		КонецЕсли;	
	КонецЦикла;
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл c параметрами материалов (склад)",ИмяФайла);
	Если Результат <> Неопределено Тогда
	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок;
	КолКолонок = Результат.КоличествоКолонок;
	    Для к = 2 по КолСтрок Цикл
		Состояние("Обработка...",к*100/КолСтрок,"Загрузка параметров из файла..."); 
		Запись = Новый Структура();

		Запись.Вставить("Наименование",СокрЛП(ExcelЛист.Cells(к,1).Value));
			Для л = 0 по КолКолонок - 2 Цикл
            Запись.Вставить(ТаблицаПараметров[л].Параметр,СокрЛП(ExcelЛист.Cells(к,л+2).Value));
			КонецЦикла;	
        ИзменитьНаСервере(Запись);
	    КонецЦикла;
	Результат.Excel.Quit();
	КонецЕсли;
 КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;            
ТаблицаПараметров.Очистить();
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл c параметрами материалов");
	Если Результат <> Неопределено Тогда
	ExcelЛист = Результат.ExcelЛист;
	ИмяФайла = Результат.ПолноеИмяФайла;
		Для к = 2 По Результат.КоличествоКолонок Цикл
		ТЧ = ТаблицаПараметров.Добавить();
		ТЧ.НомерКолонки = к;
		ТЧ.НаименованиеВфайле = СокрЛП(ExcelЛист.Cells(1,к).Value);
		ВыбЗнач = Элементы.ТаблицаПараметровПараметр.СписокВыбора.НайтиПоЗначению(ТЧ.НаименованиеВфайле);
			Если ВыбЗнач <> Неопределено Тогда
			ТЧ.Параметр = ВыбЗнач.Значение;
			Иначе
			ТЧ.Параметр = "выберите соответствие";			
			КонецЕсли;
		КонецЦикла;
	Результат.Excel.Quit();
	КонецЕсли;
КонецПроцедуры
