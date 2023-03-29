
&НаКлиенте
Процедура ВыбратьВсе(Команда)
	Для каждого ТЧ Из ТаблицаТехОпераций Цикл
		Если Не ТЧ.ТехОперация.Пустая() Тогда
		ТЧ.Пометка = Истина; 
		КонецЕсли;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе(Команда)
	Для каждого ТЧ Из ТаблицаТехОпераций Цикл
	ТЧ.Пометка = Ложь;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе1(Команда)
	Для каждого ТЧ Из ТаблицаТехОперацийСпецификации Цикл
	ТЧ.Пометка = Истина;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе1(Команда)
	Для каждого ТЧ Из ТаблицаТехОперацийСпецификации Цикл
	ТЧ.Пометка = Ложь;
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура ЛинейкаПриИзмененииНаСервере()
ТаблицаТехОпераций.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РабочиеМестаЛинеекТехОперации.ТехОперация,
	|	РабочиеМестаЛинеекТехОперации.Ссылка
	|ИЗ
	|	Справочник.РабочиеМестаЛинеек.ТехОперации КАК РабочиеМестаЛинеекТехОперации
	|ГДЕ
	|	РабочиеМестаЛинеекТехОперации.Ссылка.Линейка = &Линейка
	|
	|УПОРЯДОЧИТЬ ПО
	|	РабочиеМестаЛинеекТехОперации.Ссылка.Код";
Запрос.УстановитьПараметр("Линейка", Объект.Линейка);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ_ТО = ТаблицаТехОпераций.Добавить();
	ТЧ_ТО.РабочееМесто = ВыборкаДетальныеЗаписи.Ссылка;
		Если ВыборкаДетальныеЗаписи.ТехОперация.ЭтоГруппа Тогда
		ТЧ_ТО.ГруппаТО = ВыборкаДетальныеЗаписи.ТехОперация;
		Иначе
		ТЧ_ТО.ТехОперация = ВыборкаДетальныеЗаписи.ТехОперация;
		ТЧ_ТО.НормаВремени = ПолучитьНормуВремени(ВыборкаДетальныеЗаписи.ТехОперация);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЛинейкаПриИзменении(Элемент)
ЛинейкаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
ТаблицаТехОперацийСпецификации.Параметры.УстановитьЗначениеПараметра("ВидЭлемента",ПолучитьВидЭлементаТО());
ТаблицаТехОперацийСпецификации.Параметры.УстановитьЗначениеПараметра("МПЗ",Неопределено);
КонецПроцедуры

&НаСервере
Функция ПолучитьВидЭлементаТО()
Возврат(Перечисления.ВидыЭлементовНормРасходов.ТехОперация);
КонецФункции

&НаКлиенте
Процедура СписокНоменклатурыПриАктивизацииСтроки(Элемент)
	Если СписокНоменклатуры.Количество() > 0 Тогда
	ТаблицаТехОперацийСпецификации.Параметры.УстановитьЗначениеПараметра("ВидЭлемента",ПолучитьВидЭлементаТО());
	ТаблицаТехОперацийСпецификации.Параметры.УстановитьЗначениеПараметра("МПЗ",Элементы.СписокНоменклатуры.ТекущиеДанные.Значение);	
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПриИзменении(Элемент)
	Если Элементы.СписокНоменклатуры.ТекущаяСтрока <> Неопределено Тогда
	ТаблицаТехОперацийСпецификации.Параметры.УстановитьЗначениеПараметра("ВидЭлемента",ПолучитьВидЭлементаТО());
	ТаблицаТехОперацийСпецификации.Параметры.УстановитьЗначениеПараметра("МПЗ",Элементы.СписокНоменклатуры.ТекущиеДанные.Значение);
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ТОСуществует(Спецификация,ТО)
Запрос = Новый Запрос;
Результат = Новый Структура("НормРасх,Норма",Неопределено,0); 

Запрос.Текст = 
	"ВЫБРАТЬ
	|	НормыРасходов.Ссылка КАК Ссылка,
	|	НормыРасходовСрезПоследних.Норма КАК Норма
	|ИЗ
	|	РегистрСведений.НормыРасходов.СрезПоследних КАК НормыРасходовСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НормыРасходов КАК НормыРасходов
	|		ПО НормыРасходовСрезПоследних.НормаРасходов = НормыРасходов.Ссылка
	|ГДЕ
	|	НормыРасходов.Владелец = &Владелец
	|	И НормыРасходов.Элемент = &Элемент
	|	И НормыРасходов.ПометкаУдаления = ЛОЖЬ";
Запрос.УстановитьПараметр("Владелец", Спецификация);
Запрос.УстановитьПараметр("Элемент", ТО);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Результат.НормРасх = ВыборкаДетальныеЗаписи.Ссылка;
	Результат.Норма = ВыборкаДетальныеЗаписи.Норма;
	КонецЦикла;
Возврат(Результат);
КонецФункции

&НаСервере
Процедура ДобавитьВСпецификацииНаСервере()
	Для каждого Спецификация Из СписокНоменклатуры Цикл	
		Если Спецификация.Пометка Тогда
			Для каждого ТЧ Из ТаблицаТехОпераций Цикл
				Если ТЧ.Пометка Тогда
				Результат = ТОСуществует(Спецификация.Значение,ТЧ.ТехОперация);	
					Если Результат.НормРасх = Неопределено Тогда
					НР = Справочники.НормыРасходов.СоздатьЭлемент();
					НР.Владелец = Спецификация.Значение;
					НР.Наименование = "Тех. операции, "+СокрЛП(ТЧ.ТехОперация.Наименование);
					НР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.ТехОперация;
					НР.Элемент = ТЧ.ТехОперация;
					НР.Записать();
					РНР = РегистрыСведений.НормыРасходов.СоздатьМенеджерЗаписи();
					РНР.Период = НачалоМесяца(Объект.ВноситьНаДату);
					РНР.Владелец = НР.Владелец;
					РНР.Элемент = НР.Элемент;
					РНР.НормаРасходов = НР.Ссылка;
					РНР.Норма = 1;
					РНР.Записать(Истина);
					ИначеЕсли Результат.Норма = 0 Тогда
					РНР = РегистрыСведений.НормыРасходов.СоздатьМенеджерЗаписи();
					РНР.Период = НачалоМесяца(Объект.ВноситьНаДату);
 					РНР.Владелец = Результат.НормРасх.Владелец;
					РНР.Элемент = Результат.НормРасх.Элемент;
					РНР.НормаРасходов = Результат.НормРасх;
					РНР.Норма = 1;
					РНР.Записать(Истина);
					КонецЕсли;
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли; 	
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВСпецификации(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	ДобавитьВСпецификацииНаСервере();
	ТаблицаТехОперацийСпецификации.Параметры.УстановитьЗначениеПараметра("ВидЭлемента",ПолучитьВидЭлементаТО());
	ТаблицаТехОперацийСпецификации.Параметры.УстановитьЗначениеПараметра("МПЗ",Элементы.СписокНоменклатуры.ТекущиеДанные.Значение);
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ДобавитьНоменклатуру(НаименованиеТовара)
Товар = Справочники.Товары.НайтиПоНаименованию(НаименованиеТовара,Истина);
	Если Не Товар.Пустая() Тогда
	флНайдена = Ложь;
	Запрос = Новый Запрос;

	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Товар = &Товар";
	Запрос.УстановитьПараметр("Товар", Товар);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СписокНоменклатуры.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		флНайдена = Истина;
		Прервать;
		КонецЦикла;
			Если Не флНайдена Тогда
			Сообщить(НаименованиеТовара +" - спецификация не найдена!");	
			КонецЕсли; 
	Иначе
	Сообщить(НаименованиеТовара +" - товар не найден!");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
СписокНоменклатуры.Очистить();
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл c товарами");
	Если Результат <> Неопределено Тогда
	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок;
	    Для к = 2 по КолСтрок Цикл
		Состояние("Обработка...",к*100/КолСтрок,"Загрузка номенклатуры по товарам из файла..."); 
		ДобавитьНоменклатуру(СокрЛП(ExcelЛист.Cells(к,1).Value));
	    КонецЦикла;
	Результат.Excel.Quit();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокТО(ГруппаТО)
СписокТО = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТехОперации.Ссылка
	|ИЗ
	|	Справочник.ТехОперации КАК ТехОперации
	|ГДЕ
	|	ТехОперации.Родитель = &Родитель";
Запрос.УстановитьПараметр("Родитель", ГруппаТО);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	СписокТО.Добавить(ВыборкаДетальныеЗаписи.Ссылка,ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
Возврат(СписокТО);
КонецФункции 

&НаКлиенте
Процедура Обновить(Команда)
ЛинейкаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Функция ПолучитьНормуВремени(ТО)
Возврат(РегистрыСведений.НормыТО.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("ТехОперация",ТО)).Норма);
КонецФункции 

&НаКлиенте
Процедура ТаблицаТехОперацийТехОперацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
	Если Не Элементы.ТаблицаТехОпераций.ТекущиеДанные.ГруппаТО.Пустая() Тогда
	СписокТО = ПолучитьСписокТО(Элементы.ТаблицаТехОпераций.ТекущиеДанные.ГруппаТО);
		Если СписокТО.Количество() > 0 Тогда
		ТО = Неопределено;
		ТО = СписокТО.ВыбратьЭлемент("Выберите тех. операцию",ТО);
			Если ТО <> Неопределено Тогда
			Элементы.ТаблицаТехОпераций.ТекущиеДанные.Пометка = Истина;
			Элементы.ТаблицаТехОпераций.ТекущиеДанные.ТехОперация = ТО.Значение;
			Элементы.ТаблицаТехОпераций.ТекущиеДанные.НормаВремени = ПолучитьНормуВремени(ТО.Значение);
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.ВноситьНаДату = НачалоМесяца(ТекущаяДата());
КонецПроцедуры

&НаСервере
Процедура ИзменитьНормуРасхода(НР,Количество)	
РНР = РегистрыСведений.НормыРасходов.СоздатьМенеджерЗаписи();
РНР.Период = Объект.ВноситьНаДату;
РНР.Владелец = НР.Владелец;
РНР.Элемент = НР.Элемент;
РНР.НормаРасходов = НР;
РНР.Норма = Количество;
РНР.Записать(Истина);
КонецПроцедуры  

&НаКлиенте
Процедура ТаблицаТехОперацийСпецификацииПередНачаломИзменения(Элемент, Отказ)
Отказ = Истина;
ВыбКоличество = 0;
	Если ВвестиЧисло(ВыбКоличество,"Введите кол-во тех. операции",7,3) Тогда	
	ИзменитьНормуРасхода(Элемент.ТекущаяСтрока,ВыбКоличество);
	Элементы.ТаблицаТехОперацийСпецификации.Обновить();
	КонецЕсли; 	
КонецПроцедуры

&НаСервере
Функция ПринадлежитВыбраннойЛинейке(Спецификация)
Возврат(?(Объект.Линейка = Спецификация.Линейка,Истина,Ложь));
КонецФункции 

&НаСервере
Процедура УстановитьПометку(Идентификатор,Пометка)
СписокНоменклатуры.НайтиПоИдентификатору(Идентификатор).Пометка = Пометка;
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПометкаПриИзменении(Элемент)
	Если Элементы.СписокНоменклатуры.ТекущиеДанные.Пометка Тогда
	Пометка = ПринадлежитВыбраннойЛинейке(Элементы.СписокНоменклатуры.ТекущиеДанные.Значение);	
	УстановитьПометку(Элементы.СписокНоменклатуры.ТекущаяСтрока,Пометка); 
		Если Не Пометка Тогда
		Сообщить("Спецификация не принадлежит выбранной линейке!");
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

