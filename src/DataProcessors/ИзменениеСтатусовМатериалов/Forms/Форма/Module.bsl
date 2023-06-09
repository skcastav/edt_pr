
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
НаДату = ТекущаяДата();
КонецПроцедуры

&НаСервере
Процедура ДобавитьМатериал(Наименование)
Мат = Справочники.Материалы.НайтиПоНаименованию(Наименование,Истина);
	Если Не Мат.Пустая() Тогда
	СписокМатериалов.Добавить(Мат);
	Иначе	
	Сообщить(Наименование+" - материал не найден!");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьМатериалыИзФайла(Команда)
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл c материалами");
	Если Результат <> Неопределено Тогда
	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок; 
	    Для к = 2 по КолСтрок Цикл
		Состояние("Обработка...",к*100/КолСтрок,"Загрузка материалов из файла...");
		ДобавитьМатериал(СокрЛП(ExcelЛист.Cells(к,1).Value)); 
	    КонецЦикла;
	Результат.Excel.Quit();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПрисвоитьСтатусНаСервере()
	Для каждого Мат Из СписокМатериалов Цикл	
	ВыбСтатус = РегистрыСведений.СтатусыМПЗ.ПолучитьПоследнее(НаДату,Новый Структура("МПЗ",Мат.Значение));
		Если НовыйСтатус <> ВыбСтатус.Статус Тогда
		СМ = РегистрыСведений.СтатусыМПЗ.СоздатьМенеджерЗаписи();
		СМ.Период = НаДату;
		СМ.МПЗ = Мат.Значение;
		СМ.Статус = НовыйСтатус;
		СМ.Записать();
		ИОИ = РегистрыСведений.ИзвещенияОбИзменениях.СоздатьМенеджерЗаписи();
		ИОИ.Элемент = Мат.Значение;
		ИОИ.Извещение = Извещение;
		ИОИ.Записать();
		Иначе
		Сообщить(""+Мат.Значение+" - уже имеет выбранный статус!");	
		КонецЕсли;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ПрисвоитьСтатус(Команда)
ПрисвоитьСтатусНаСервере();
КонецПроцедуры

