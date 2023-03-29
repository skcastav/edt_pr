
&НаСервере
Процедура ДобавитьНаСервере(TYPE,NAME,NUM,POSITION,DEFIN,ETAP)
ТЧ = Объект.Спецификация.Добавить();
ТЧ.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов[СокрЛП(TYPE)];
	Если (ТЧ.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Материал)или
		 (ТЧ.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.МатериалВспомогательный) Тогда
	Выбор = Справочники.Материалы.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.Элемент = NAME;
		ТЧ.НетВСправочниках = Истина;
		Иначе
        ТЧ.Элемент = Выбор;
		ТЧ.Статус = ПолучитьСтатус(Выбор,ТекущаяДата());
		ТЧ.ЕИ = Выбор.ОсновнаяЕдиницаИзмерения;
		КонецЕсли; 
	ИначеЕсли ТЧ.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Деталь Тогда
	Выбор = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.Элемент = NAME;
		ТЧ.НетВСправочниках = Истина;
		Иначе
        ТЧ.Элемент = Выбор;
		ТЧ.Статус = ПолучитьСтатус(Выбор,ТекущаяДата());
		ТЧ.ЕИ = Выбор.ОсновнаяЕдиницаИзмерения;
		КонецЕсли;
	ИначеЕсли ТЧ.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Узел Тогда
	Выбор = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.Элемент = NAME;
		ТЧ.НетВСправочниках = Истина;
		Иначе
        ТЧ.Элемент = Выбор;
		ТЧ.Статус = ПолучитьСтатус(Выбор,ТекущаяДата());
		ТЧ.ЕИ = Выбор.ОсновнаяЕдиницаИзмерения;
		КонецЕсли;
	ИначеЕсли ТЧ.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Набор Тогда
	Выбор = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.Элемент = NAME;
		ТЧ.НетВСправочниках = Истина;
		Иначе
        ТЧ.Элемент = Выбор;
		ТЧ.Статус = ПолучитьСтатус(Выбор,ТекущаяДата());
		ТЧ.ЕИ = Выбор.ОсновнаяЕдиницаИзмерения;
		КонецЕсли;
	ИначеЕсли ТЧ.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Основа Тогда
	Выбор = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.Элемент = NAME;
		ТЧ.НетВСправочниках = Истина;
		Иначе
        ТЧ.Элемент = Выбор;
		ТЧ.Статус = ПолучитьСтатус(Выбор,ТекущаяДата());
		ТЧ.ЕИ = Выбор.ОсновнаяЕдиницаИзмерения;
		КонецЕсли;
	ИначеЕсли ТЧ.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.ТехОперация Тогда
	Выбор = Справочники.ТехОперации.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.Элемент = NAME;
		ТЧ.НетВСправочниках = Истина;
		Иначе
        ТЧ.Элемент = Выбор;
		КонецЕсли;
	ИначеЕсли ТЧ.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.ТехОснастка Тогда
	Выбор = Справочники.ТехОснастка.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.Элемент = NAME;
		ТЧ.НетВСправочниках = Истина;
		Иначе
        ТЧ.Элемент = Выбор;
		КонецЕсли;
	ИначеЕсли ТЧ.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Документ Тогда
	Выбор = Справочники.Документация.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.Элемент = NAME;
		ТЧ.НетВСправочниках = Истина;
		Иначе
        ТЧ.Элемент = Выбор;
		КонецЕсли;
	ИначеЕсли ТЧ.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Программа Тогда		
	Выбор = Справочники.Документация.НайтиПоНаименованию(СокрЛП(NAME),Истина);
		Если Выбор.Пустая() Тогда
        ТЧ.Элемент = NAME;
		ТЧ.НетВСправочниках = Истина;
		Иначе
        ТЧ.Элемент = Выбор;
		КонецЕсли;
	КонецЕсли; 
ТЧ.Количество = NUM;
ТЧ.Позиция = POSITION;
ТЧ.Примечание = DEFIN;
ВыборЭтапа = Справочники.Номенклатура.НайтиПоНаименованию(СокрЛП(ETAP),Истина);
	Если Не ВыборЭтапа.Пустая() Тогда
    ТЧ.ЭтапПроизводства = ВыборЭтапа;
	ЭтапПр = Объект.ЭтапыПроизводства.НайтиСтроки(Новый Структура("ЭтапПроизводства", ВыборЭтапа));
		Если ЭтапПр.Количество() = 0 Тогда
		Этап = Объект.ЭтапыПроизводства.Добавить();
		Этап.ЭтапПроизводства = ВыборЭтапа;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьИсполнение(Номер,Наименование)
ТЧ = ТаблицаИсполнений.Добавить();
ТЧ.Исполнение = Наименование;
ТЧ.Номер = Номер;
КонецПроцедуры

&НаСервере
Функция ПолучитьНаименование(Файл)
Возврат(глНаименованиеВСкобкахБезЭтапа(Файл));
КонецФункции
 
&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл с эскизом спецификации",,1);
	Если Результат <> Неопределено Тогда
	ИмяФайла = Результат.ПолноеИмяФайла;
	ТаблицаИсполнений.Очистить();
	Объект.Обозначение = Неопределено;
	Объект.Наименование = "";
	Объект.Спецификация.Очистить();
	Объект.ЭтапыПроизводства.Очистить();
	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок;
	КоличествоКолонок = Результат.КоличествоКолонок;
		Если КоличествоКолонок = 2 Тогда
		    Для к = 2 по КолСтрок Цикл
			Состояние("Обработка...",к*100/КолСтрок,"Загрузка исполнений спецификаций из файла..."); 
			ДобавитьИсполнение(Строка(ExcelЛист.Cells(к,1).Value),Строка(ExcelЛист.Cells(к,2).Value));
		    КонецЦикла;		
		Иначе	
		ДобавитьИсполнение("",Результат.Файл);
			Если Найти(Результат.Файл,"(") > 0 Тогда
			Объект.Обозначение = Лев(Результат.Файл,Найти(Результат.Файл,"(")-1);
			Объект.Наименование = ПолучитьНаименование(Результат.Файл);
			Иначе
			Объект.Наименование = Результат.Файл;
			КонецЕсли;
		НомерИсполнения = "-";
		    Для к = 2 по КолСтрок Цикл
			Состояние("Обработка...",к*100/КолСтрок,"Загрузка эскиза спецификации из файла...");
				Если ЗначениеЗаполнено(ExcelЛист.Cells(к,7).Value) Тогда
					Если ExcelЛист.Cells(к,7).Value <> НомерИсполнения Тогда
					Продолжить;
					КонецЕсли;			
				КонецЕсли;  
			ДобавитьНаСервере(ExcelЛист.Cells(к,2).Value,ExcelЛист.Cells(к,3).Value,ExcelЛист.Cells(к,4).Value,ExcelЛист.Cells(к,1).Value,ExcelЛист.Cells(к,6).Value,ExcelЛист.Cells(к,5).Value);
		    КонецЦикла;
		Объект.Спецификация.Сортировать("ВидЭлемента,Позиция");
		КонецЕсли;
	Результат.Excel.Quit();
	КонецЕсли;  
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаИсполненийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если КоличествоКолонок > 2 Тогда
	Возврат;
	КонецЕсли; 
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("",ИмяФайла,2);
	Если Результат <> Неопределено Тогда
	Объект.Спецификация.Очистить();
	Объект.ЭтапыПроизводства.Очистить();
	Исполнение = Элементы.ТаблицаИсполнений.ТекущиеДанные.Исполнение;
		Если Найти(Исполнение,"(") > 0 Тогда
		Объект.Обозначение = Лев(Исполнение,Найти(Исполнение,"(")-1);
		Объект.Наименование = ПолучитьНаименование(Исполнение);
		Иначе
		Объект.Обозначение = Неопределено;
		Объект.Наименование = Исполнение;
		КонецЕсли;
	Объект.Наименование = Элементы.ТаблицаИсполнений.ТекущиеДанные.Исполнение;
	НомерИсполнения = Элементы.ТаблицаИсполнений.ТекущиеДанные.Номер;
	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок;
	    Для к = 2 по КолСтрок Цикл
		Состояние("Обработка...",к*100/КолСтрок,"Загрузка эскиза спецификации из файла...");
			Если ЗначениеЗаполнено(ExcelЛист.Cells(к,7).Value) Тогда
				Если Строка(ExcelЛист.Cells(к,7).Value) <> НомерИсполнения Тогда
				Продолжить;
				КонецЕсли;			
			КонецЕсли;  
		ДобавитьНаСервере(ExcelЛист.Cells(к,2).Value,ExcelЛист.Cells(к,3).Value,ExcelЛист.Cells(к,4).Value,ExcelЛист.Cells(к,1).Value,ExcelЛист.Cells(к,6).Value,ExcelЛист.Cells(к,5).Value);
	    КонецЦикла;
	Результат.Excel.Quit();
	Объект.Спецификация.Сортировать("ВидЭлемента,Позиция");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПроверитьНаСервере()
	Для каждого ТЧ Из Объект.Спецификация Цикл
		Если ТЧ.НетВСправочниках Тогда
		Возврат(Ложь);
		КонецЕсли; 
			Если ТипЗнч(ТЧ.Элемент) = Тип("СправочникСсылка.Материалы") Тогда
				Если ТЧ.Статус = Перечисления.СтатусыМПЗ.Запрещённая Тогда
				Возврат(Ложь);
				КонецЕсли; 
			ИначеЕсли ТипЗнч(ТЧ.Элемент) = Тип("СправочникСсылка.Номенклатура") Тогда		
				Если ТЧ.Статус = Перечисления.СтатусыСпецификаций.Запрещённая Тогда
				Возврат(Ложь);
				КонецЕсли;			
			КонецЕсли;  
	КонецЦикла;	
Возврат(Истина);
КонецФункции

&НаСервере
Процедура СоздатьСпецификациюНаСервере()
ЭтапОснова = Справочники.Номенклатура.ПустаяСсылка();
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;	
		Для каждого Этап Из Объект.ЭтапыПроизводства Цикл
			Если Этап.ЭтапСпецификации <> Справочники.Номенклатура.ПустаяСсылка() Тогда
	    	ЭтапОснова = Этап.ЭтапСпецификации;
			Сообщить(СокрЛП(ЭтапОснова.Наименование)+" - спецификация существует!");
			Продолжить;
			КонецЕсли;
				Если Не ЗначениеЗаполнено(Объект.Обозначение) Тогда
					Если ИспользоватьПрефиксЭтапа Тогда
					НовоеНаименование = ПолучитьПрефиксЭтапаПроизводства(Этап.ЭтапПроизводства)+"-"+СокрЛП(Объект.Наименование);					
					Иначе	
					НовоеНаименование = СокрЛП(Объект.Наименование);
					КонецЕсли;						
				ИначеЕсли ТипЗнч(Объект.Обозначение) = Тип("Строка") Тогда
					Если ИспользоватьПрефиксЭтапа Тогда
					НовоеНаименование = СокрЛП(Объект.Обозначение)+" ("+ПолучитьПрефиксЭтапаПроизводства(Этап.ЭтапПроизводства)+"-"+СокрЛП(Объект.Наименование)+")";
					Иначе	
					НовоеНаименование = СокрЛП(Объект.Обозначение)+" ("+СокрЛП(Объект.Наименование)+")";
					КонецЕсли;	        
				Иначе
					Если ИспользоватьПрефиксЭтапа Тогда
					НовоеНаименование = ""+Объект.Обозначение.Код+"."+Формат(Объект.Обозначение.СледующийНомер,"ЧЦ=6; ЧВН=; ЧГ=")+" ("+ПолучитьПрефиксЭтапаПроизводства(Этап.ЭтапПроизводства)+"-"+СокрЛП(Объект.Наименование)+")";
					Иначе	
					НовоеНаименование = ""+Объект.Обозначение.Код+"."+Формат(Объект.Обозначение.СледующийНомер,"ЧЦ=6; ЧВН=; ЧГ=")+" ("+СокрЛП(Объект.Наименование)+")";
					КонецЕсли;
				НовыйНумератор = Объект.Обозначение.ПолучитьОбъект();
				НовыйНумератор.СледующийНомер = НовыйНумератор.СледующийНомер + 1;
				НовыйНумератор.Записать();			
				КонецЕсли;
		Спецификация = Справочники.Номенклатура.НайтиПоНаименованию(НовоеНаименование,Истина,Этап.ГруппаСпецификации);
			Если Спецификация = Справочники.Номенклатура.ПустаяСсылка() Тогда
			Спецификация = Справочники.Номенклатура.СоздатьЭлемент();
		    Спецификация.Родитель = Этап.ГруппаСпецификации;
			Спецификация.Наименование = НовоеНаименование;
			Спецификация.ПолнНаименование = НовоеНаименование;
			Спецификация.ДатаСозданияСпецификации = Объект.ДатаСоздания;
			Спецификация.ЕдиницаИзмерения = Справочники.ЕдиницыИзмерений.НайтиПоНаименованию("шт",Истина);	
			Спецификация.Записать();
			НовыйСтатус = РегистрыСведений.СтатусыМПЗ.СоздатьМенеджерЗаписи();
			НовыйСтатус.Период = Объект.ДатаСоздания;
			НовыйСтатус.МПЗ = Спецификация.Ссылка;
			НовыйСтатус.Статус = Объект.Статус;	
			НовыйСтатус.Записать();
			ОснЕИ = Справочники.ОсновныеЕдиницыИзмерений.СоздатьЭлемент();
			ОснЕИ.Владелец = Спецификация.Ссылка;
			ОснЕИ.Наименование = "шт";
			ОснЕИ.ЕдиницаИзмерения = Спецификация.ЕдиницаИзмерения;
			ОснЕИ.Коэффициент = 1;
			ОснЕИ.Записать();
			Спецификация.ОсновнаяЕдиницаИзмерения = ОснЕИ.Ссылка;
			Спецификация.Записать();
			Иначе
	    	ЭтапОснова = Спецификация.Ссылка;
			Этап.ЭтапСпецификации = Спецификация.Ссылка;
			Сообщить(СокрЛП(ЭтапОснова.Наименование)+" - спецификация существует!");
			Продолжить;
			КонецЕсли; 
				Если ЭтапОснова <> Справочники.Номенклатура.ПустаяСсылка() Тогда
				НР = Справочники.НормыРасходов.СоздатьЭлемент();
				НР.Владелец = Спецификация.Ссылка;	
				НР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Основа;
				НР.Элемент = ЭтапОснова;	
				НР.Наименование = "Основа, "+ЭтапОснова.Наименование;
				НР.Записать();
				РНР = РегистрыСведений.НормыРасходов.СоздатьМенеджерЗаписи();
				РНР.Период = Объект.ДатаСоздания;
				РНР.Владелец = НР.Владелец;
				РНР.Элемент = НР.Элемент;
				РНР.НормаРасходов = НР.Ссылка;
				РНР.Норма = 1;			
				РНР.Записать();		
				КонецЕсли;
		Выборка = Объект.Спецификация.НайтиСтроки(Новый Структура("ЭтапПроизводства", Этап.ЭтапПроизводства));
			Для каждого ВыбЭлемент Из Выборка Цикл 
			НР = Справочники.НормыРасходов.СоздатьЭлемент();
			НР.Владелец = Спецификация.Ссылка;
			НР.Позиция  = ВыбЭлемент.Позиция;
			НР.Примечание = ВыбЭлемент.Примечание;	
			НР.ВидЭлемента = ВыбЭлемент.ВидЭлемента;
				Если ТипЗнч(ВыбЭлемент.Элемент) <> Тип("Строка") Тогда
				НР.Элемент = ВыбЭлемент.Элемент;	
					Если ВыбЭлемент.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Материал Тогда
					НР.Наименование = "Материал, "+ВыбЭлемент.Элемент;
					ИначеЕсли ВыбЭлемент.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.МатериалВспомогательный Тогда
					НР.Наименование = "Материал вспомогательный, "+ВыбЭлемент.Элемент;
					ИначеЕсли ВыбЭлемент.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.ТехОперация Тогда	
					НР.Наименование = "Тех. операция, "+ВыбЭлемент.Элемент;
					ИначеЕсли ВыбЭлемент.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.ТехОснастка Тогда	
					НР.Наименование = "Тех. оснастка, "+ВыбЭлемент.Элемент;	
					ИначеЕсли (ВыбЭлемент.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Документ)или
							  (ВыбЭлемент.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Программа)Тогда	
					НР.Наименование = Строка(ВыбЭлемент.Элемент.ВидДокумента)+", "+ВыбЭлемент.Элемент;	
					Иначе
					НР.Наименование = Строка(ВыбЭлемент.ВидЭлемента)+", "+ВыбЭлемент.Элемент;			
					КонецЕсли;
				Иначе
				НР.Наименование = "нет в базе данных";
				КонецЕсли; 
			НР.Записать();
			РНР = РегистрыСведений.НормыРасходов.СоздатьМенеджерЗаписи();
			РНР.Период = Объект.ДатаСоздания;
			РНР.Владелец = НР.Владелец;
			РНР.Элемент = НР.Элемент;
			РНР.НормаРасходов = НР.Ссылка;
			РНР.Норма = ВыбЭлемент.Количество;			
			РНР.Записать();		
			КонецЦикла;
		ЭтапОснова = Спецификация.Ссылка; 
		Этап.ЭтапСпецификации = Спецификация.Ссылка;
		КонецЦикла;
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Исключение
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Сообщить(ОписаниеОшибки());
	КонецПопытки; 
КонецПроцедуры

&НаСервере
Функция ПроверитьЭтапыНаСервере()
	Для каждого ТЧ Из Объект.ЭтапыПроизводства Цикл	
		Если ТЧ.ГруппаСпецификации.Пустая() Тогда
		Возврат(Ложь);
		КонецЕсли; 
	КонецЦикла;
Возврат(Истина);
КонецФункции 

&НаКлиенте
Процедура СоздатьСпецификацию(Команда)
	Если ПроверитьНаСервере() Тогда
		Если ПроверитьЭтапыНаСервере() Тогда
		СоздатьСпецификациюНаСервере();
		Иначе
		Сообщить("Имеются не заполненные группы спецификаций в таблице этапов.");
		КонецЕсли;
	Иначе
	Сообщить("Имеются не найденные или запрещённые элементы! Загрузка запрещена!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.ДатаСоздания = ТекущаяДата();
Объект.Статус = Перечисления.СтатусыМПЗ.ОНР;
ИспользоватьПрефиксЭтапа = Истина;
КонецПроцедуры

&НаСервере
Функция ПолучитьМетаданные(ВыбТип)
Возврат(Метаданные.НайтиПоТипу(ВыбТип).ПолноеИмя());
КонецФункции

&НаКлиенте
Процедура ЭтапыПроизводстваПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущийЭлемент.Имя = "ЭтапыПроизводстваЭтапСпецификации" Тогда 
	Отказ = Истина;
	ТекФорма = ПолучитьФорму(ПолучитьМетаданные(ТипЗнч(Элементы.ЭтапыПроизводства.ТекущиеДанные.ЭтапСпецификации))+".ФормаСписка");
	ТекФорма.Открыть();
	ТекФорма.Элементы.Список.ТекущаяСтрока = Элементы.ЭтапыПроизводства.ТекущиеДанные.ЭтапСпецификации;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СпецификацияЭлементПриИзменении(Элемент)
СпецификацияЭлементПриИзмененииНаСервере(Элементы.Спецификация.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура СпецификацияЭлементПриИзмененииНаСервере(Стр)
ТЧ = Объект.Спецификация.НайтиПоИдентификатору(Стр);
	Если ТипЗнч(ТЧ.Элемент) = Тип("Строка") Тогда
	ТЧ.НетВСправочниках = Истина;		
	Иначе
	ТЧ.НетВСправочниках = Ложь;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПолучитьВидНормыРасходов(Стр)
Возврат(Перечисления.ВидыЭлементовНормРасходов[Стр]);
КонецФункции 

&НаКлиенте
Процедура СпецификацияЭлементНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
	Если Элементы.Спецификация.ТекущиеДанные.ВидЭлемента = ПолучитьВидНормыРасходов("Материал") Тогда
	Элементы.Спецификация.ТекущиеДанные.Элемент = ОткрытьФормуМодально("Справочник.Материалы.ФормаВыбора",Новый Структура("ТекущаяСтрока",Элементы.Спецификация.ТекущиеДанные.Элемент));
	ИначеЕсли Элементы.Спецификация.ТекущиеДанные.ВидЭлемента = ПолучитьВидНормыРасходов("ТехОперация") Тогда	
	Элементы.Спецификация.ТекущиеДанные.Элемент = ОткрытьФормуМодально("Справочник.ТехОперации.ФормаВыбора",Новый Структура("ТекущаяСтрока",Элементы.Спецификация.ТекущиеДанные.Элемент));
	ИначеЕсли Элементы.Спецификация.ТекущиеДанные.ВидЭлемента = ПолучитьВидНормыРасходов("ТехОснастка") Тогда	
	Элементы.Спецификация.ТекущиеДанные.Элемент = ОткрытьФормуМодально("Справочник.ТехОснастка.ФормаВыбора",Новый Структура("ТекущаяСтрока",Элементы.Спецификация.ТекущиеДанные.Элемент));	
	ИначеЕсли (Элементы.Спецификация.ТекущиеДанные.ВидЭлемента = ПолучитьВидНормыРасходов("Документ"))или
			  (Элементы.Спецификация.ТекущиеДанные.ВидЭлемента = ПолучитьВидНормыРасходов("Программа"))Тогда	
	Элементы.Спецификация.ТекущиеДанные.Элемент = ОткрытьФормуМодально("Справочник.Документация.ФормаВыбора",Новый Структура("ТекущаяСтрока",Элементы.Спецификация.ТекущиеДанные.Элемент));	
	Иначе
	Элементы.Спецификация.ТекущиеДанные.Элемент = ОткрытьФормуМодально("Справочник.Номенклатура.ФормаВыбора",Новый Структура("ТекущаяСтрока",Элементы.Спецификация.ТекущиеДанные.Элемент));			
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция НайтиГруппуСпецификации(ВыбГруппа,Родитель)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.ЭтоГруппа = ИСТИНА
	|	И Номенклатура.Родитель = &Родитель
	|	И Номенклатура.Наименование = &Наименование";
Запрос.УстановитьПараметр("Наименование", ВыбГруппа);
Запрос.УстановитьПараметр("Родитель", Родитель);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
Возврат(Справочники.Номенклатура.ПустаяСсылка());
КонецФункции

&НаСервере
Процедура СоздатьГруппуНаСервере(ВыбГруппа)
	Для каждого ТЧ Из Объект.ЭтапыПроизводства Цикл
	СокрЭтапПроизводства = ПолучитьПрефиксЭтапаПроизводства(ТЧ.ЭтапПроизводства);
		Если ИспользоватьПрефиксЭтапа Тогда
		ГруппаСпецификации = НайтиГруппуСпецификации(СокрЭтапПроизводства+"-"+ВыбГруппа,?(ТЧ.ГруппаСпецификации.Пустая(),ТЧ.ЭтапПроизводства,ТЧ.ГруппаСпецификации));
		Иначе	
		ГруппаСпецификации = НайтиГруппуСпецификации(ВыбГруппа,?(ТЧ.ГруппаСпецификации.Пустая(),ТЧ.ЭтапПроизводства,ТЧ.ГруппаСпецификации));
		КонецЕсли;
			Если ГруппаСпецификации.Пустая() Тогда
			ГруппаСпецификации = Справочники.Номенклатура.СоздатьГруппу();
				Если ТЧ.ГруппаСпецификации.Пустая() Тогда
				ГруппаСпецификации.Родитель = ТЧ.ЭтапПроизводства;			
				Иначе	
				ГруппаСпецификации.Родитель = ТЧ.ГруппаСпецификации;
				КонецЕсли;
					Если ИспользоватьПрефиксЭтапа Тогда
					ГруппаСпецификации.Наименование = СокрЭтапПроизводства+"-"+ВыбГруппа;
					Иначе
					ГруппаСпецификации.Наименование = ВыбГруппа;
					КонецЕсли;
			ГруппаСпецификации.Записать();
			КонецЕсли; 
	ТЧ.ГруппаСпецификации = ГруппаСпецификации.Ссылка;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьГруппу(Команда)
ВыбГруппа = Объект.Наименование;
	Если ВвестиСтроку(ВыбГруппа,"Введите наименование группы (без префикса)",100,Ложь) Тогда
	СоздатьГруппуНаСервере(СокрЛП(ВыбГруппа));
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура НумераторПриИзменении(Элемент)
Объект.Обозначение = "используется нумератор";
КонецПроцедуры
