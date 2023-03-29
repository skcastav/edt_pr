
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.ВидТоваров = 1;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНаСервере(Наименование,КодТНВЭД,ВесНетто,ВесБрутто)
	Если Объект.ВидТоваров = 1 Тогда
	Товар = Справочники.Материалы.НайтиПоНаименованию(Наименование,Истина);
	Иначе	
	Товар = Справочники.Номенклатура.НайтиПоНаименованию(Наименование,Истина);	
	КонецЕсли;
		Если Не Товар.Пустая() Тогда
		ПДО = РегистрыСведений.ПараметрыДляОтгрузки.СоздатьМенеджерЗаписи();
	    ПДО.Товар = Товар.Ссылка;
		ПДО.КодТНВЭД = КодТНВЭД;
		ПДО.ВесНетто = ВесНетто;
		ПДО.ВесБрутто = ВесБрутто;
		ПДО.Записать(Истина);
		Иначе	
		Сообщить(Наименование + " - не найден в справочнике!");
		КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл c параметрами для отгрузки");
	Если Результат <> Неопределено Тогда
	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок;
	    Для к = 2 по КолСтрок Цикл
		Состояние("Обработка...",к*100/КолСтрок,"Загрузка параметров для отгрузки..."); 
        ЗагрузитьНаСервере(СокрЛП(ExcelЛист.Cells(к,1).Value),ExcelЛист.Cells(к,2).Value,ExcelЛист.Cells(к,3).Value,ExcelЛист.Cells(к,4).Value);
	    КонецЦикла;
	Результат.Excel.Quit();
	КонецЕсли;
КонецПроцедуры
