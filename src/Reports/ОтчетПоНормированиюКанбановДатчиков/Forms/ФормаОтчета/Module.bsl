
&НаСервере
Процедура ПолучитьСписокТОИзделия(ТаблицаТОИзделия,Изделие,КолУзла)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	НормыРасходов.Элемент,
	|	НормыРасходовСрезПоследних.Норма,
	|	НормыРасходов.ВидЭлемента
	|ИЗ
	|	РегистрСведений.НормыРасходов.СрезПоследних(&НаДату, ) КАК НормыРасходовСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НормыРасходов КАК НормыРасходов
	|		ПО НормыРасходовСрезПоследних.НормаРасходов = НормыРасходов.Ссылка
	|ГДЕ
	|	НормыРасходов.ПометкаУдаления = ЛОЖЬ
	|	И НормыРасходов.Владелец = &Владелец
	|	И (ТИПЗНАЧЕНИЯ(НормыРасходов.Элемент) = ТИП(Справочник.ТехОперации)
	|			ИЛИ ТИПЗНАЧЕНИЯ(НормыРасходов.Элемент) = ТИП(Справочник.Номенклатура))
	|	И НормыРасходовСрезПоследних.Норма > 0";
Запрос.УстановитьПараметр("НаДату", Отчет.Период.ДатаОкончания);
Запрос.УстановитьПараметр("Владелец", Изделие);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.ТехОперация Тогда
		ТЧ = ТаблицаТОИзделия.Добавить();
		ТЧ.ТО = ВыборкаДетальныеЗаписи.Элемент;
		ТЧ.Количество = ВыборкаДетальныеЗаписи.Норма*КолУзла;		
		ИначеЕсли ВыборкаДетальныеЗаписи.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Набор Тогда
		ПолучитьСписокТОИзделия(ТаблицаТОИзделия,ВыборкаДетальныеЗаписи.Элемент,ПолучитьБазовоеКоличество(ВыборкаДетальныеЗаписи.Норма,ВыборкаДетальныеЗаписи.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла);
		Иначе
			Если ВыборкаДетальныеЗаписи.Элемент.Канбан.Пустая() Тогда
			ПолучитьСписокТОИзделия(ТаблицаТОИзделия,ВыборкаДетальныеЗаписи.Элемент,ПолучитьБазовоеКоличество(ВыборкаДетальныеЗаписи.Норма,ВыборкаДетальныеЗаписи.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла);
			//Иначе
			//	Если ВыборкаДетальныеЗаписи.Элемент.Канбан.Служебный Тогда
			//	ПолучитьСписокТОИзделия(ТаблицаТОИзделия,ВыборкаДетальныеЗаписи.Элемент,ПолучитьБазовоеКоличество(ВыборкаДетальныеЗаписи.Норма,ВыборкаДетальныеЗаписи.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла);
			//	КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 		
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьГруппуТО(ТО)
ГруппаТО = ТО.Родитель;
	Пока ГруппаТО.Уровень() > 1 Цикл
	ГруппаТО = ГруппаТО.Родитель;
	КонецЦикла; 
Возврат(ГруппаТО);
КонецФункции

&НаСервере
Процедура СформироватьНаСервере()
Запрос = Новый Запрос;
СписокТО = Новый СписокЗначений;
ТаблицаИзделий = Новый ТаблицаЗначений;
ТаблицаТО = Новый ТаблицаЗначений;
ТаблицаТОИзделия = Новый ТаблицаЗначений;

ТаблицаИзделий.Колонки.Добавить("Изделие",Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
ТаблицаИзделий.Колонки.Добавить("Количество",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(14,3)));

ТаблицаТО.Колонки.Добавить("ТО",Новый ОписаниеТипов("СправочникСсылка.ТехОперации"));
ТаблицаТО.Колонки.Добавить("СуммаТО",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(14,2)));

ТаблицаТОИзделия.Колонки.Добавить("ТО",Новый ОписаниеТипов("СправочникСсылка.ТехОперации"));
ТаблицаТОИзделия.Колонки.Добавить("Количество",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(14,3)));

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РабочиеМестаЛинеекТехОперации.ТехОперация,
	|	РабочиеМестаЛинеекТехОперации.Ссылка.Код КАК Код
	|ИЗ
	|	Справочник.РабочиеМестаЛинеек.ТехОперации КАК РабочиеМестаЛинеекТехОперации
	|ГДЕ
	|	РабочиеМестаЛинеекТехОперации.Ссылка.Линейка В ИЕРАРХИИ(&Линейки)";
Запрос.УстановитьПараметр("Линейки", СписокЛинеек);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.ТехОперация.ЭтоГруппа Тогда
		ВыборкаТО = Справочники.ТехОперации.ВыбратьИерархически(ВыборкаДетальныеЗаписи.ТехОперация);
			Пока ВыборкаТО.Следующий() Цикл
				Если Не ВыборкаТО.ПометкаУдаления Тогда
				 	Если Не ВыборкаТО.ЭтоГруппа Тогда
						Если СписокТО.НайтиПоЗначению(ВыборкаТО.Ссылка) = Неопределено Тогда						
						СписокТО.Добавить(ВыборкаТО.Ссылка,Формат(ВыборкаДетальныеЗаписи.Код,"ЧЦ=3; ЧВН=")+ВыборкаТО.Код);
						ТЧ_ТО = ТаблицаТО.Добавить();
						ТЧ_ТО.ТО = ВыборкаТО.Ссылка;
						КонецЕсли;
					КонецЕсли; 
				КонецЕсли;
			КонецЦикла; 		
		Иначе	
			Если СписокТО.НайтиПоЗначению(ВыборкаДетальныеЗаписи.ТехОперация) = Неопределено Тогда						
			СписокТО.Добавить(ВыборкаДетальныеЗаписи.ТехОперация,Формат(ВыборкаДетальныеЗаписи.Код,"ЧЦ=3; ЧВН=")+ВыборкаДетальныеЗаписи.ТехОперация.Код);
			ТЧ_ТО = ТаблицаТО.Добавить();
			ТЧ_ТО.ТО = ВыборкаДетальныеЗаписи.ТехОперация;
			КонецЕсли;		
		КонецЕсли; 
	КонецЦикла; 
СписокТО.СортироватьПоПредставлению();
ТабДок.Очистить();

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
	Если ЗначениеЗаполнено(ЭтаФорма.Параметры.Документ) Тогда
	Макет = ОбъектЗн.ПолучитьМакет("МакетДляДокумента");
	Иначе
	Макет = ОбъектЗн.ПолучитьМакет("Макет");
	КонецЕсли;

ОблШапкаОбщая = Макет.ПолучитьОбласть("Шапка|Общая");
ОблШапкаТехОперация = Макет.ПолучитьОбласть("Шапка|ТехОперация");
ОблШапкаИтого = Макет.ПолучитьОбласть("Шапка|Итого");
ОблИзделиеОбщая = Макет.ПолучитьОбласть("Изделие|Общая");
ОблИзделиеТехОперация = Макет.ПолучитьОбласть("Изделие|ТехОперация");
ОблИзделиеИтого = Макет.ПолучитьОбласть("Изделие|Итого");
ОблКонецОбщая = Макет.ПолучитьОбласть("Конец|Общая");
ОблКонецТехОперация = Макет.ПолучитьОбласть("Конец|ТехОперация");
ОблКонецИтого = Макет.ПолучитьОбласть("Конец|Итого");

ОблШапкаОбщая.Параметры.ДатаНач = Формат(Отчет.Период.ДатаНачала,"ДФ=dd.MM.yyyy");
ОблШапкаОбщая.Параметры.ДатаКон = Формат(Отчет.Период.ДатаОкончания,"ДФ=dd.MM.yyyy");
ОблШапкаОбщая.Параметры.ВидОтчёта = ?(БезУчётаВыходныхДней,"Без учёта выходных дней: "+СписокВыходныхДней,"");
	Если ЗначениеЗаполнено(ЭтаФорма.Параметры.Документ) Тогда
	ОблШапкаОбщая.Параметры.ВидДокумента = ТипЗнч(ЭтаФорма.Параметры.Документ);
	ОблШапкаОбщая.Параметры.Подразделение = ЭтаФорма.Параметры.Документ.Подразделение;
	ОблШапкаОбщая.Параметры.Комментарий = ЭтаФорма.Параметры.Документ.Комментарий;
	КонецЕсли;
ТабДок.Вывести(ОблШапкаОбщая);
	Для каждого ТО Из СписокТО Цикл
	ОблШапкаТехОперация.Параметры.ГруппаТО = ПолучитьГруппуТО(ТО.Значение);	
	ОблШапкаТехОперация.Параметры.ТО = ТО.Значение;
	ТабДок.Присоединить(ОблШапкаТехОперация);				
	КонецЦикла;
ТабДок.Присоединить(ОблШапкаИтого);

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВыпускПродукцииКанбан.Изделие,
	|	ВыпускПродукцииКанбан.Количество,
	|	ВыпускПродукцииКанбан.Изделие.Наименование КАК ИзделиеНаименование
	|ИЗ
	|	Документ.ВыпускПродукцииКанбан КАК ВыпускПродукцииКанбан
	|ГДЕ
	|	ВыпускПродукцииКанбан.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И ВыпускПродукцииКанбан.ДокументОснование.Линейка В ИЕРАРХИИ(&СписокЛинеек)";
	Если Не ГруппаНоменклатуры.Пустая() Тогда
	Запрос.Текст = Запрос.Текст + " И ВыпускПродукцииКанбан.Изделие В ИЕРАРХИИ(&ГруппаНоменклатуры)";
	Запрос.УстановитьПараметр("ГруппаНоменклатуры", ГруппаНоменклатуры);
	КонецЕсли;
		Если ОтобратьПо = 1 Тогда
		Запрос.Текст = Запрос.Текст + " И ВыпускПродукцииКанбан.Изделие.Канбан.Служебный = &Служебный";
		Запрос.УстановитьПараметр("Служебный", Ложь);
		ИначеЕсли ОтобратьПо = 2 Тогда	
		Запрос.Текст = Запрос.Текст + " И ВыпускПродукцииКанбан.Изделие.Канбан.Служебный = &Служебный";
		Запрос.УстановитьПараметр("Служебный", Истина);	
		КонецЕсли;
			Если БезУчётаВыходныхДней Тогда	
			Запрос.Текст = Запрос.Текст + " И НЕ НАЧАЛОПЕРИОДА(ВыпускПродукцииКанбан.Дата, ДЕНЬ) В (&СписокВыходныхДней)";
	        Запрос.УстановитьПараметр("СписокВыходныхДней", СписокВыходныхДней);
			КонецЕсли; 
Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО ИзделиеНаименование
								|ИТОГИ
								|	СУММА(Количество)
								|ПО
								|	Изделие"; 
Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Отчет.Период.ДатаНачала));
Запрос.УстановитьПараметр("ДатаКон", КонецДня(Отчет.Период.ДатаОкончания));
Запрос.УстановитьПараметр("СписокЛинеек", СписокЛинеек);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаИзделия = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаИзделия.Следующий() Цикл
	ТЧ = ТаблицаИзделий.Добавить();
	ТЧ.Изделие = ВыборкаИзделия.Изделие;
	ТЧ.Количество = ВыборкаИзделия.Количество;
	КонецЦикла;
КоличествоВсего = 0;
СуммаИтогоВсего = 0;
	Для каждого ТЧ Из ТаблицаИзделий Цикл
		Если ТЧ.Количество <= 0 Тогда
		Продолжить;
		КонецЕсли;
	ТаблицаТОИзделия.Очистить(); 
	ПолучитьСписокТОИзделия(ТаблицаТОИзделия,ТЧ.Изделие,1);
	ТаблицаТОИзделия.Свернуть("ТО","Количество");
	НВИтого = 0;
	СтоимостьИтого = 0;
	СуммаИтого = 0;
	ОблИзделиеОбщая.Параметры.Наименование = СокрЛП(ТЧ.Изделие.Наименование);
	ОблИзделиеОбщая.Параметры.Изделие = ТЧ.Изделие;
	ОблИзделиеОбщая.Параметры.Количество = ТЧ.Количество;
	ТабДок.Вывести(ОблИзделиеОбщая);
	КоличествоВсего = КоличествоВсего + ТЧ.Количество;
		Для каждого ТО Из СписокТО Цикл
		ВыборкаТО = ТаблицаТОИзделия.Найти(ТО.Значение,"ТО");
			Если ВыборкаТО <> Неопределено Тогда
			НормыТО = РегистрыСведений.НормыТО.ПолучитьПоследнее(Отчет.Период.ДатаНачала,Новый Структура("ТехОперация",ТО.Значение));
			Стоимость = Окр(НормыТО.Норма/60*НормыТО.Стоимость,2,РежимОкругления.Окр15как20);
			ОблИзделиеТехОперация.Параметры.НВ = НормыТО.Норма;
			ОблИзделиеТехОперация.Параметры.Стоимость = Стоимость;
			КС = 1;
			ОблИзделиеТехОперация.Параметры.КС = КС;			
			Сумма = Стоимость*ВыборкаТО.Количество*ТЧ.Количество*КС;
			ОблИзделиеТехОперация.Параметры.Сумма = Сумма;
			ТабДок.Присоединить(ОблИзделиеТехОперация);
			НВИтого = НВИтого + НормыТО.Норма;
			СтоимостьИтого = СтоимостьИтого + Стоимость;
			СуммаИтого = СуммаИтого + Сумма;
			Выборка = ТаблицаТО.НайтиСтроки(Новый Структура("ТО",ТО.Значение));
			Выборка[0].СуммаТО = Выборка[0].СуммаТО + Сумма;
			Иначе
			ОблИзделиеТехОперация.Параметры.НВ = 0;
			ОблИзделиеТехОперация.Параметры.Стоимость = 0;
			ОблИзделиеТехОперация.Параметры.КС = 0;
			ОблИзделиеТехОперация.Параметры.Сумма = 0;
			ТабДок.Присоединить(ОблИзделиеТехОперация);			
			КонецЕсли;				
		КонецЦикла;
	ОблИзделиеИтого.Параметры.НВИтого = НВИтого;
	ОблИзделиеИтого.Параметры.СтоимостьИтого = СтоимостьИтого;
	ОблИзделиеИтого.Параметры.СуммаИтого = СуммаИтого;
	ТабДок.Присоединить(ОблИзделиеИтого);
	СуммаИтогоВсего = СуммаИтогоВсего + СуммаИтого;
	КонецЦикла;
ОблКонецОбщая.Параметры.КоличествоВсего = КоличествоВсего;
	Если ЗначениеЗаполнено(ЭтаФорма.Параметры.Документ) Тогда
	ОблКонецОбщая.Параметры.Мастер = ЭтаФорма.Параметры.Документ.Автор;
	ОблКонецОбщая.Параметры.ЗаместительНачальникаПоУправлениюРесурсами = ОбщийМодульВызовСервера.ПолучитьСотрудникаПоДолжности("Заместитель начальника по управлению ресурсами");
	ОблКонецОбщая.Параметры.НачальникПЭО = ОбщийМодульВызовСервера.ПолучитьСотрудникаПоДолжности("Начальник ПЭО");
	КонецЕсли;
ТабДок.Вывести(ОблКонецОбщая);
	Для каждого ТО Из СписокТО Цикл
	Выборка = ТаблицаТО.Найти(ТО.Значение,"ТО");
	ОблКонецТехОперация.Параметры.СуммаВсего = Выборка.СуммаТО;
	ТабДок.Присоединить(ОблКонецТехОперация);				
	КонецЦикла;
ОблКонецИтого.Параметры.СуммаИтогоВсего = СуммаИтогоВсего;
ТабДок.Присоединить(ОблКонецИтого);
ТабДок.ФиксацияСверху = 5;
ТабДок.ФиксацияСлева = 2;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
		Если ОбщийМодульВызовСервера.РазрешенныйСписокЛинеек(СписокЛинеек) Тогда
		СформироватьНаСервере();		
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыДокумента(Документ)
Парам = Новый Структура("Линейка,ЭтоГруппа,Дата,ВедомостьВыходногоДня,БезУчётаВыходныхДней,Проектные",Документ.Линейка,Документ.Линейка.ЭтоГруппа,Документ.Дата,Документ.ВедомостьВыходногоДня,Документ.БезУчётаВыходныхДней,Документ.Проектные);
Возврат(Парам);
КонецФункции

&НаСервере
Функция ПолучитьСписокВыходныхДней(Документ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИндивидуальнаяСделка.Дата
	|ИЗ
	|	Документ.ИндивидуальнаяСделка КАК ИндивидуальнаяСделка
	|ГДЕ
	|	ИндивидуальнаяСделка.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И ИндивидуальнаяСделка.Подразделение = &Подразделение
	|	И ИндивидуальнаяСделка.ВедомостьВыходногоДня = ИСТИНА
	|	И ИндивидуальнаяСделка.ПометкаУдаления = ЛОЖЬ
	|	И ИндивидуальнаяСделка.Комментарий ПОДОБНО &Комментарий";
Запрос.УстановитьПараметр("ДатаНач", НачалоМесяца(Документ.Дата));
Запрос.УстановитьПараметр("ДатаКон", КонецМесяца(Документ.Дата));
Запрос.УстановитьПараметр("Подразделение", Документ.Подразделение);
Запрос.УстановитьПараметр("Комментарий", Документ.Комментарий);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	СписокВыходныхДней.Добавить(ВыборкаДетальныеЗаписи.Дата);
	КонецЦикла;
КонецФункции

&НаСервере
Функция ПолучитьСписокЛинеек(ГруппаЛинеек,Проектные)
Линейки = Справочники.Линейки.Выбрать(ГруппаЛинеек);
	Пока Линейки.Следующий() Цикл
		Если Линейки.Проектная = Проектные Тогда
		СписокЛинеек.Добавить(Линейки.Ссылка);
		КонецЕсли;			
	КонецЦикла;
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(ЭтаФорма.Параметры.Документ) Тогда
	ПараметрыДокумента = ПолучитьПараметрыДокумента(ЭтаФорма.Параметры.Документ);	
	СписокЛинеек.Очистить();
    ПолучитьСписокЛинеек(ПараметрыДокумента.Линейка,ПараметрыДокумента.Проектные);	
		Если ПараметрыДокумента.ВедомостьВыходногоДня Тогда        
		Отчет.Период.ДатаНачала = ПараметрыДокумента.Дата;			
		Отчет.Период.ДатаОкончания = ПараметрыДокумента.Дата;
		Иначе
		Отчет.Период.ДатаНачала = НачалоМесяца(ПараметрыДокумента.Дата);			
		Отчет.Период.ДатаОкончания = КонецМесяца(ПараметрыДокумента.Дата);		
		КонецЕсли;
	БезУчётаВыходныхДней = ПараметрыДокумента.БезУчётаВыходныхДней;
		Если БезУчётаВыходныхДней Тогда
		СписокВыходныхДней.Очистить();
		ПолучитьСписокВыходныхДней(ЭтаФорма.Параметры.Документ);		
		КонецЕсли;
	Сформировать(Неопределено);   	
	КонецЕсли; 
КонецПроцедуры
