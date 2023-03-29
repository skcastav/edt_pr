
&НаСервере
Функция ПолучитьБазовоеКоличествоИзделия(Количество,ОсновнаяЕдиницаИзмерения) Экспорт
Коэффициент = ?(ОсновнаяЕдиницаИзмерения.Коэффициент = 0, 1, ОсновнаяЕдиницаИзмерения.Коэффициент);
Возврат(Количество*Коэффициент);	
КонецФункции

&НаСервере
Функция РасчитатьСебестоимостьКанбана(Спецификация,КолКанбана,КолУзла,Стоимость)	
	Если Отчет.ВидОбработки = 0 Тогда
	НаДату = Отчет.Период.ДатаОкончания;
	Иначе	
	НаДату = Отчет.НаДату;
	КонецЕсли;
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_М(Спецификация,НаДату);
	Пока ВыборкаНР.Следующий() Цикл
	БазовоеКоличество = ПолучитьБазовоеКоличествоИзделия(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла;
		Если ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Материалы")Тогда
		Цены = РегистрыСведений.Цены.ПолучитьПоследнее(НаДату,Новый Структура("МПЗ",ВыборкаНР.Элемент));
		Стоимость = Стоимость + БазовоеКоличество*Цены.Цена;
		Иначе
			Если ВыборкаНР.Элемент.Канбан.Пустая() Тогда
			РасчитатьСебестоимостьКанбана(ВыборкаНР.Элемент,БазовоеКоличество*КолКанбана,БазовоеКоличество,Стоимость);			
			Иначе
				Если ВыборкаНР.Элемент.Канбан.Пустая() Тогда
				РасчитатьСебестоимостьКанбана(ВыборкаНР.Элемент,БазовоеКоличество*КолКанбана,БазовоеКоличество,Стоимость);			
				Иначе
				ТЧ = ТаблицаКанбанов.Добавить();
				ТЧ.МПЗ = ВыборкаНР.Элемент;
				ТЧ.Количество = БазовоеКоличество*КолКанбана;
				ТЧ.Стоимость = РасчитатьСебестоимостьКанбана(ВыборкаНР.Элемент,БазовоеКоличество*КолКанбана,1,0); 
				КонецЕсли;	 
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
Возврат(Стоимость);
КонецФункции

&НаСервере
Функция ПринадлежитСписку(МПЗ)
	Для каждого Группа Из СписокГруппНоменклатурыБезРасчёта Цикл	
		Если МПЗ.ПринадлежитЭлементу(Группа.Значение) Тогда
		Возврат(Истина);
		КонецЕсли; 
	КонецЦикла; 
Возврат(Ложь);
КонецФункции 

&НаСервере
Функция РасчитатьСебестоимость(Спецификация,КолУзла,Стоимость)	
	Если Отчет.ВидОбработки = 0 Тогда
	НаДату = Отчет.Период.ДатаОкончания;
	Иначе	
	НаДату = Отчет.НаДату;
	КонецЕсли;
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_М(Спецификация,НаДату);
	Пока ВыборкаНР.Следующий() Цикл
	БазовоеКоличество = ПолучитьБазовоеКоличествоИзделия(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла;			
		Если ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Материалы")Тогда
		Цены = РегистрыСведений.Цены.ПолучитьПоследнее(НаДату,Новый Структура("МПЗ",ВыборкаНР.Элемент));
		Стоимость = Стоимость + БазовоеКоличество*Цены.Цена;
		ИначеЕсли ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Номенклатура")Тогда
			Если ВыборкаНР.Элемент.Канбан.Пустая() Тогда
			РасчитатьСебестоимость(ВыборкаНР.Элемент,БазовоеКоличество,Стоимость);			
			Иначе
				Если Не ПринадлежитСписку(ВыборкаНР.Элемент) Тогда
					Если СписокОбъединяемыхПодразделений.НайтиПоЗначению(ВыборкаНР.Элемент.Канбан.Подразделение) <> Неопределено Тогда	
					РасчитатьСебестоимость(ВыборкаНР.Элемент,БазовоеКоличество,Стоимость);
					Иначе
					ТЧ = ТаблицаКанбанов.Добавить();
					ТЧ.МПЗ = ВыборкаНР.Элемент;
					ТЧ.Количество = БазовоеКоличество;
					ТЧ.Стоимость = РасчитатьСебестоимостьКанбана(ВыборкаНР.Элемент,БазовоеКоличество,1,0);
					КонецЕсли;
				Иначе
				ТЧ = ТаблицаКанбанов.Добавить();
				ТЧ.МПЗ = ВыборкаНР.Элемент;
				ТЧ.Количество = БазовоеКоличество;
				ТЧ.Стоимость = 0;
				КонецЕсли; 
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
Возврат(Стоимость);
КонецФункции

&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();
ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Выгрузка");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблИзделие = Макет.ПолучитьОбласть("Изделие");
ОблСтрока = Макет.ПолучитьОбласть("Строка");
 
ТабДок.Вывести(ОблШапка);

Запрос = Новый Запрос;

	Если Отчет.ВидОбработки = 0 Тогда
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МестаХраненияОбороты.МПЗ,
		|	МестаХраненияОбороты.КоличествоПриход КАК Количество,
		|	МестаХраненияОбороты.МПЗ.Родитель.Наименование КАК МПЗРодитель
		|ИЗ
		|	РегистрНакопления.МестаХранения.Обороты(&ДатаНач, &ДатаКон, , ) КАК МестаХраненияОбороты
		|ГДЕ
		|	МестаХраненияОбороты.МестоХранения В ИЕРАРХИИ(&СписокМестХранения)";
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Отчет.Период.ДатаНачала));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(Отчет.Период.ДатаОкончания));
	Запрос.УстановитьПараметр("СписокМестХранения", СписокМестХранения);
		Если СписокНоменклатуры.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + " И МестаХраненияОбороты.МПЗ В ИЕРАРХИИ(&СписокНоменклатуры)";
		Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры);
		КонецЕсли;
	Иначе
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МестаХраненияОстатки.МПЗ,
		|	МестаХраненияОстатки.КоличествоОстаток КАК Количество,
		|	МестаХраненияОстатки.МПЗ.Родитель.Наименование КАК МПЗРодитель
		|ИЗ
		|	РегистрНакопления.МестаХранения.Остатки(&НаДату, ) КАК МестаХраненияОстатки
		|ГДЕ
		|	МестаХраненияОстатки.МестоХранения В ИЕРАРХИИ(&СписокМестХранения)";
	Запрос.УстановитьПараметр("НаДату", КонецДня(Отчет.НаДату));
	Запрос.УстановитьПараметр("СписокМестХранения", СписокМестХранения);
		Если СписокНоменклатуры.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + " И МестаХраненияОстатки.МПЗ В ИЕРАРХИИ(&СписокНоменклатуры)";
		Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры);
		КонецЕсли;
	КонецЕсли;  
Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО МПЗРодитель";
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТаблицаКанбанов.Очистить();	
	ОблИзделие.Параметры.Наименование = СокрЛП(ВыборкаДетальныеЗаписи.МПЗ.Наименование);
	ОблИзделие.Параметры.МПЗ = ВыборкаДетальныеЗаписи.МПЗ;
	ОблИзделие.Параметры.Количество = ВыборкаДетальныеЗаписи.Количество;
	ОблИзделие.Параметры.Производство = "Затраты УПЭА";
	ОблИзделие.Параметры.Полуфабрикат = 0;
	ОблИзделие.Параметры.КоличествоПФ = 0;
	ОблИзделие.Параметры.Стоимость = Окр(РасчитатьСебестоимость(ВыборкаДетальныеЗаписи.МПЗ,1,0),2,1);
	ТабДок.Вывести(ОблИзделие);
	ТЗ = ТаблицаКанбанов.Выгрузить();
	ТЗ.Свернуть("МПЗ,Стоимость","Количество");
	ТЗ.Сортировать("МПЗ");
		Для каждого ТЧ Из ТЗ Цикл
		ОблСтрока.Параметры.Наименование = СокрЛП(ВыборкаДетальныеЗаписи.МПЗ.Наименование);
		ОблСтрока.Параметры.МПЗ = ВыборкаДетальныеЗаписи.МПЗ;
		ОблСтрока.Параметры.Количество = ВыборкаДетальныеЗаписи.Количество;
		ОблСтрока.Параметры.Производство = "Затраты участков";
		ОблСтрока.Параметры.НаименованиеПолуфабриката = СокрЛП(ТЧ.МПЗ.Наименование);
		ОблСтрока.Параметры.Полуфабрикат = ТЧ.МПЗ;
		ОблСтрока.Параметры.КоличествоПФ = ТЧ.Количество;
		ОблСтрока.Параметры.Стоимость = Окр(ТЧ.Стоимость*ТЧ.Количество,2,1);
		ТабДок.Вывести(ОблСтрока);
		КонецЦикла; 
	КонецЦикла;
ТабДок.ФиксацияСверху = 1;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	СформироватьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидОбработкиПриИзменении(Элемент)
	Если Отчет.ВидОбработки = 0 Тогда
	Элементы.Период.Видимость = Истина;
	Элементы.НаДату.Видимость = Ложь;
	Иначе
	Элементы.Период.Видимость = Ложь;
	Элементы.НаДату.Видимость = Истина;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
ВидОбработкиПриИзменении(Неопределено);
КонецПроцедуры
