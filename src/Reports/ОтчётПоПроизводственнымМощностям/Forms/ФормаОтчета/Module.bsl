
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Не Линейка.Пустая() Тогда
	ЛинейкаПриИзмененииНаСервере();
	КонецЕсли;
КонецПроцедуры
    
&НаСервере
Процедура ЛинейкаПриИзмененииНаСервере()
ТаблицаРабочихМест.Очистить();          
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РабочиеМестаЛинеек.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.РабочиеМестаЛинеек КАК РабочиеМестаЛинеек
	|ГДЕ
	|	РабочиеМестаЛинеек.Линейка = &Линейка
	|	И РабочиеМестаЛинеек.Авторизовано = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	РабочиеМестаЛинеек.Код";
Запрос.УстановитьПараметр("Линейка", Линейка);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = ТаблицаРабочихМест.Добавить();
	ТЧ.РабочееМесто = ВыборкаДетальныеЗаписи.Ссылка;
	ТЧ.Количество = 1;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЛинейкаПриИзменении(Элемент)
ЛинейкаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Функция СоздатьСписокРабочихМест(Изделие,НаДату)
Этапы.Очистить();
СписокРабочихМест.Очистить(); 
ОбщийМодульВызовСервера.ПолучитьТаблицуЭтаповСпецификации(Этапы,Изделие,1,Ложь,НаДату);
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РабочиеМестаТабличнаяЧасть.ГруппаНоменклатуры,
	|	РабочиеМестаТабличнаяЧасть.Ссылка,
	|	РабочиеМестаТабличнаяЧасть.Ссылка.Код КАК Код
	|ИЗ
	|	Справочник.РабочиеМестаЛинеек.ТабличнаяЧасть КАК РабочиеМестаТабличнаяЧасть
	|ГДЕ
	|	РабочиеМестаТабличнаяЧасть.Ссылка.Линейка = &Линейка
	|	И РабочиеМестаТабличнаяЧасть.ГруппаНоменклатуры В(&СписокГруппНоменклатуры)
	|	И РабочиеМестаТабличнаяЧасть.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И РабочиеМестаТабличнаяЧасть.Ссылка.Авторизовано = ИСТИНА";	
Запрос.УстановитьПараметр("Линейка", Линейка); 
Запрос.УстановитьПараметр("СписокГруппНоменклатуры", Этапы.Выгрузить(,"ГруппаНоменклатуры"));
РезультатЗапроса = Запрос.Выполнить();	
ВыборкаРабочиеМеста = РезультатЗапроса.Выбрать();
	Для каждого ТЧ Из Этапы Цикл
	ВыборкаРабочиеМеста.Сбросить();
	флНайден = Ложь;
		Пока ВыборкаРабочиеМеста.НайтиСледующий(Новый Структура("ГруппаНоменклатуры",ТЧ.ГруппаНоменклатуры)) Цикл
		флНайден = Истина;
			Если СписокРабочихМест.НайтиПоЗначению(ВыборкаРабочиеМеста.Ссылка) = Неопределено Тогда
			СписокРабочихМест.Добавить(ВыборкаРабочиеМеста.Ссылка,Формат(ВыборкаРабочиеМеста.Код,"ЧЦ=2; ЧВН="));		
			КонецЕсли;		
		КонецЦикла; 
			Если Не флНайден Тогда
			Возврат(Ложь);
			КонецЕсли;  	
	КонецЦикла;
СписокРабочихМест.СортироватьПоПредставлению();	
Возврат(Истина); 
КонецФункции
         
&НаСервере
Функция ПолучитьСписокПройденныхРМ(ПЗ)
СписокПройденныхРМ = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданий.РабочееМесто КАК РабочееМесто
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий КАК ЭтапыПроизводственныхЗаданий
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданий.ПЗ = &ПЗ
	|	И ЭтапыПроизводственныхЗаданий.ДатаОкончания <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
Запрос.УстановитьПараметр("ПЗ", ПЗ);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	СписокПройденныхРМ.Добавить(ВыборкаДетальныеЗаписи.РабочееМесто);
	КонецЦикла;
Возврат(СписокПройденныхРМ);
КонецФункции
     
&НаСервере
Функция ПолучитьКоличествоВЛинейке(ТО)
Запрос = Новый Запрос;
   
КоличествоВхождений = 0;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РабочиеМестаЛинеекТехОперации.ТехОперация КАК ТехОперация
	|ИЗ
	|	Справочник.РабочиеМестаЛинеек.ТехОперации КАК РабочиеМестаЛинеекТехОперации
	|ГДЕ
	|	РабочиеМестаЛинеекТехОперации.Ссылка.Линейка = &Линейка";
Запрос.УстановитьПараметр("Линейка", Линейка);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 
		Если ВыборкаДетальныеЗаписи.ТехОперация.ЭтоГруппа Тогда
			Если ТО.ПринадлежитЭлементу(ВыборкаДетальныеЗаписи.ТехОперация) Тогда
			КоличествоВхождений = КоличествоВхождений + 1;
			КонецЕсли;
		Иначе	
			Если ВыборкаДетальныеЗаписи.ТехОперация = ТО Тогда
			КоличествоВхождений = КоличествоВхождений + 1;
			КонецЕсли;		
		КонецЕсли;
	КонецЦикла;
Возврат(КоличествоВхождений);
КонецФункции

&НаСервере
Функция ПолучитьКоличествоВЛинейкеБудущее(ГруппаРабочихМест,ТО)
КоличествоВхождений = 0;
	Для каждого ТЧ Из ТаблицаРабочихМест Цикл
		Если ТЧ.РабочееМесто.ГруппаРабочихМест = ГруппаРабочихМест Тогда	
			Для каждого ТЧ_ТО Из ТЧ.РабочееМесто.ТехОперации Цикл
				Если ТЧ_ТО.ТехОперация.ЭтоГруппа Тогда
					Если ТО.ПринадлежитЭлементу(ТЧ_ТО.ТехОперация) Тогда
					КоличествоВхождений = КоличествоВхождений + ТЧ.Количество;
					КонецЕсли;
				Иначе	
					Если ТЧ_ТО.ТехОперация = ТО Тогда
					КоличествоВхождений = КоличествоВхождений + ТЧ.Количество;
					КонецЕсли;		
				КонецЕсли;
			КонецЦикла;		
		КонецЕсли;
	КонецЦикла;
Возврат(КоличествоВхождений);
КонецФункции

&НаСервере
Функция ПолучитьКоличествоНаРабочемМесте(РабочееМесто,ТО)
КоличествоВхождений = 0;
	Для каждого ТЧ Из ТаблицаРабочихМест Цикл
		Если ТЧ.РабочееМесто = РабочееМесто Тогда	
			Для каждого ТЧ_ТО Из ТЧ.РабочееМесто.ТехОперации Цикл
				Если ТЧ_ТО.ТехОперация.ЭтоГруппа Тогда
					Если ТО.ПринадлежитЭлементу(ТЧ_ТО.ТехОперация) Тогда
					КоличествоВхождений = КоличествоВхождений + ТЧ.Количество;
					КонецЕсли;
				Иначе	
					Если ТЧ_ТО.ТехОперация = ТО Тогда
					КоличествоВхождений = КоличествоВхождений + ТЧ.Количество;
					КонецЕсли;		
				КонецЕсли;
			КонецЦикла;		
		КонецЕсли;
	КонецЦикла;
Возврат(КоличествоВхождений);
КонецФункции

&НаСервере
Функция ПолучитьСписокТОДатчика(Изделие,НаДату)
Запрос = Новый Запрос;
СписокТО = Новый СписокЗначений;
   
Запрос.Текст = 
	"ВЫБРАТЬ
	|	НормыРасходов.Элемент КАК Элемент
	|ИЗ
	|	РегистрСведений.НормыРасходов.СрезПоследних(&НаДату, ) КАК НормыРасходовСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НормыРасходов КАК НормыРасходов
	|		ПО НормыРасходовСрезПоследних.НормаРасходов = НормыРасходов.Ссылка
	|ГДЕ
	|	НормыРасходов.ПометкаУдаления = ЛОЖЬ
	|	И НормыРасходов.Владелец = &Владелец
	|	И ТИПЗНАЧЕНИЯ(НормыРасходов.Элемент) = ТИП(Справочник.ТехОперации)
	|	И НормыРасходовСрезПоследних.Норма > 0";
Запрос.УстановитьПараметр("НаДату", НаДату);
Запрос.УстановитьПараметр("Владелец", Изделие);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаНР = РезультатЗапроса.Выбрать();
	Пока ВыборкаНР.Следующий() Цикл
	КоличествоВЛинейке = ПолучитьКоличествоВЛинейке(ВыборкаНР.Элемент);
    СписокТО.Добавить(ВыборкаНР.Элемент,КоличествоВЛинейке);
		Если КоличествоВЛинейке = 0 Тогда
		Сообщить(СокрЛП(ВыборкаНР.Элемент.Наименование) + " - не указана ни в одном рабочем месте линейки!");
		КонецЕсли;
	КонецЦикла;
Возврат(СписокТО);
КонецФункции

&НаСервере
Функция ПолучитьСписокТОДатчикаТекущий(Изделие,НаДату)
Запрос = Новый Запрос;
СписокТО = Новый СписокЗначений;
   
Запрос.Текст = 
	"ВЫБРАТЬ
	|	НормыРасходов.Элемент КАК Элемент
	|ИЗ
	|	РегистрСведений.НормыРасходов.СрезПоследних(&НаДату, ) КАК НормыРасходовСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НормыРасходов КАК НормыРасходов
	|		ПО НормыРасходовСрезПоследних.НормаРасходов = НормыРасходов.Ссылка
	|ГДЕ
	|	НормыРасходов.ПометкаУдаления = ЛОЖЬ
	|	И НормыРасходов.Владелец = &Владелец
	|	И ТИПЗНАЧЕНИЯ(НормыРасходов.Элемент) = ТИП(Справочник.ТехОперации)
	|	И НормыРасходовСрезПоследних.Норма > 0";
Запрос.УстановитьПараметр("НаДату", НаДату);
Запрос.УстановитьПараметр("Владелец", Изделие);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаНР = РезультатЗапроса.Выбрать();
	Пока ВыборкаНР.Следующий() Цикл
 	СписокТО.Добавить(ВыборкаНР.Элемент);
	КонецЦикла;
Возврат(СписокТО);
КонецФункции

&НаСервере
Процедура ПолучитьППНаСервере()
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПерспективныеПланы.МПЗ КАК МПЗ,
	|	ПерспективныеПланы.Количество КАК Количество,
	|	ПерспективныеПланы.РезКм КАК РезКм,
	|	ПерспективныеПланы.Проект КАК Проект
	|ИЗ
	|	РегистрСведений.ПерспективныеПланы КАК ПерспективныеПланы
	|ГДЕ
	|	ПерспективныеПланы.Период МЕЖДУ &ДатаНач И &ДатаКон
	|	И ПерспективныеПланы.МПЗ.Линейка = &Линейка
	|	И ТИПЗНАЧЕНИЯ(ПерспективныеПланы.МПЗ) = ТИП(Справочник.Номенклатура)
	|	И ПерспективныеПланы.Количество > 0";
	Если Не Изделие.Пустая() Тогда
	Запрос.Текст = Запрос.Текст + " И ПерспективныеПланы.МПЗ = &Изделие";
	Запрос.УстановитьПараметр("Изделие", Изделие);
	КонецЕсли;
Запрос.Текст = Запрос.Текст + " ИТОГИ
								|	СУММА(Количество)
								|ПО
								|	МПЗ";
Запрос.УстановитьПараметр("ДатаНач", Период.ДатаНачала); 
Запрос.УстановитьПараметр("ДатаКон", Период.ДатаОкончания);   
Запрос.УстановитьПараметр("Линейка", Линейка);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаМПЗ = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаМПЗ.Следующий() Цикл
	ТЧ = ТаблицаНоменклатуры.Добавить();
	ТЧ.Номенклатура = ВыборкаМПЗ.МПЗ;
	ТЧ.Количество = ВыборкаМПЗ.Количество; 
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();
ТаблицаНоменклатуры.Очистить();
ТаблицаТО.Очистить();

	Если ВидОтчёта = 0 Тогда
	НаДату = Период.ДатаОкончания;
	Иначе
	НаДату = ТекущаяДата();
	КонецЕсли; 

ПаспортЛинейки = РегистрыСведений.ПаспортЛинейки.ПолучитьПоследнее(НаДату,Новый Структура("Линейка",Линейка));

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапкаОбщая = Макет.ПолучитьОбласть("Шапка|Общая");
ОблШапкаТО = Макет.ПолучитьОбласть("Шапка|ТО");
ОблШапкаТОИтого = Макет.ПолучитьОбласть("Шапка|ТОИтого");
ОблШапкаТОВсего = Макет.ПолучитьОбласть("Шапка|ТОВсего");
ОблСтрокаОбщая = Макет.ПолучитьОбласть("Строка|Общая");
ОблСтрокаТО = Макет.ПолучитьОбласть("Строка|ТО");
ОблСтрокаТОИтого = Макет.ПолучитьОбласть("Строка|ТОИтого");
ОблСтрокаТОВсего = Макет.ПолучитьОбласть("Строка|ТОВсего");
ОблКонецОбщая = Макет.ПолучитьОбласть("Конец|Общая");
ОблКонецТО = Макет.ПолучитьОбласть("Конец|ТО");
ОблКонецТОИтого = Макет.ПолучитьОбласть("Конец|ТОИтого");
ОблКонецТОВсего = Макет.ПолучитьОбласть("Конец|ТОВсего");
                                          
Запрос = Новый Запрос;
СписокТО = Новый СписокЗначений; 

КоличествоИзделийВсего = 0;

	Если ВидОтчёта = 0 Тогда
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВыпускПродукции.ДокументОснование.Изделие КАК Изделие,
		|	ВыпускПродукции.ДокументОснование.Количество КАК Количество,
		|	ВыпускПродукции.ДокументОснование.Ссылка КАК ПЗ
		|ИЗ
		|	Документ.ВыпускПродукции КАК ВыпускПродукции
		|ГДЕ
		|	ВыпускПродукции.ДокументОснование.Линейка = &Линейка
		|	И ВыпускПродукции.НаСклад = ИСТИНА
		|	И ВыпускПродукции.Дата МЕЖДУ &ДатаНач И &ДатаКон";
		Если Не Изделие.Пустая() Тогда
		Запрос.Текст = Запрос.Текст + " И ВыпускПродукции.ДокументОснование.Изделие = &Изделие";
		Запрос.УстановитьПараметр("Изделие", Изделие);
		КонецЕсли;
    Запрос.Текст = Запрос.Текст + " ИТОГИ
									|	СУММА(Количество)
									|ПО
									|	Изделие";            
	Запрос.УстановитьПараметр("ДатаНач", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаКон", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("Линейка", Линейка);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаИзделия = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаИзделия.Следующий() Цикл
		КоличествоИзделийВсего = КоличествоИзделийВсего + ВыборкаИзделия.Количество;
		СписокТО.Очистить();
			Если СокрЛП(Линейка.Подразделение.Наименование) = "Богородицк УПЭА" Тогда			
			НормыВремени = РегистрыСведений.НормыВремени.СрезПоследних(НаДату,Новый Структура("МПЗ",ВыборкаИзделия.Изделие));
			    Для Каждого НВ Из НормыВремени Цикл 
					Если НВ.НормаВремени = 0 Тогда
					Продолжить;
					КонецЕсли;
				КоличествоВЛинейке = ПолучитьКоличествоВЛинейке(НВ.ТехОперация); 
	            СписокТО.Добавить(НВ.ТехОперация,КоличествоВЛинейке);
					Если КоличествоВЛинейке = 0 Тогда
					Сообщить(СокрЛП(НВ.ТехОперация.Наименование) + " - не указана ни в одном рабочем месте линейки!");
					КонецЕсли;
			    КонецЦикла;				
			Иначе			
            СписокТО = ПолучитьСписокТОДатчика(ВыборкаИзделия.Изделие,НаДату);
			КонецЕсли;
		ТЧ = ТаблицаНоменклатуры.Добавить();
		ТЧ.Номенклатура = ВыборкаИзделия.Изделие;
 		ТЧ.Количество = ВыборкаИзделия.Количество;
		ВыборкаДетальныеЗаписи = ВыборкаИзделия.Выбрать();
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЭтапыПЗ = РегистрыСведений.ЭтапыПроизводственныхЗаданий.СоздатьНаборЗаписей();
			ЭтапыПЗ.Отбор.ПЗ.Установить(ВыборкаДетальныеЗаписи.ПЗ);
			ЭтапыПЗ.Прочитать();              
				Для каждого ТО Из СписокТО Цикл 
					Если ТЧ.ТаблицаТО.Количество() > 0 Тогда
						Для каждого ТЧ_ТО_Ф Из ТЧ.ТаблицаТО Цикл
						ТЧ_ТО_Ф.флПЗ = Ложь;						
						КонецЦикла;
					КонецЕсли;
					Для Каждого ЭтапПЗ Из ЭтапыПЗ Цикл 
					    Для Каждого ТО_ПЗ Из ЭтапПЗ.РабочееМесто.ТехОперации Цикл 
							Если ТО_ПЗ.ТехОперация.ЭтоГруппа Тогда
								Если Не ТО.Значение.ПринадлежитЭлементу(ТО_ПЗ.ТехОперация) Тогда							
								Продолжить;
								КонецЕсли;	
							Иначе	
								Если ТО.Значение <> ТО_ПЗ.ТехОперация Тогда
								Продолжить;
								КонецЕсли;
							КонецЕсли;
						Выборка = ТЧ.ТаблицаТО.НайтиСтроки(Новый Структура("ГруппаРМ,ТО",ЭтапПЗ.РабочееМесто.ГруппаРабочихМест,ТО.Значение)); 
							Если Выборка.Количество() = 0 Тогда
							ВыборкаТТО = ТаблицаТО.НайтиСтроки(Новый Структура("ГруппаРМ,ТО",ЭтапПЗ.РабочееМесто.ГруппаРабочихМест,ТО.Значение));
								Если ВыборкаТТО.Количество() = 0 Тогда
								ТЧ_ТТО = ТаблицаТО.Добавить();
								ТЧ_ТТО.ГруппаРМ = ЭтапПЗ.РабочееМесто.ГруппаРабочихМест;	
								ТЧ_ТТО.КодГРМ = ЭтапПЗ.РабочееМесто.ГруппаРабочихМест.Код;	
								ТЧ_ТТО.ТО = ТО.Значение;
								КонецЕсли;
			                ТЧ_ТО = ТЧ.ТаблицаТО.Добавить();
							ТЧ_ТО.ГруппаРМ = ЭтапПЗ.РабочееМесто.ГруппаРабочихМест;	
							ТЧ_ТО.КодГРМ = ЭтапПЗ.РабочееМесто.ГруппаРабочихМест.Код;	
							ТЧ_ТО.ТО = ТО.Значение;
								Если СокрЛП(Линейка.Подразделение.Наименование) = "Богородицк УПЭА" Тогда
								НормыВремени = РегистрыСведений.НормыВремени.ПолучитьПоследнее(НаДату,Новый Структура("МПЗ,ТехОперация",ВыборкаИзделия.Изделие,ТО.Значение));
								ТЧ_ТО.НВ = НормыВремени.НормаВремени;
								Иначе
								НормыВремени = РегистрыСведений.НормыТО.ПолучитьПоследнее(НаДату,Новый Структура("ТехОперация",ТО.Значение));
								ТЧ_ТО.НВ = НормыВремени.Норма;
								КонецЕсли;
							ТЧ_ТО.Количество = 1;
								Если Не ТЧ_ТО.флПЗ Тогда
								ТЧ_ТО.флПЗ = Истина;
								ТЧ_ТО.КоличествоПЗ = 1;								
								КонецЕсли;																		
							Иначе	
							Выборка[0].Количество = Выборка[0].Количество + 1;
								Если Не Выборка[0].флПЗ Тогда
								Выборка[0].флПЗ = Истина;
								Выборка[0].КоличествоПЗ = Выборка[0].КоличествоПЗ + 1;								
								КонецЕсли;
							КонецЕсли;						
						КонецЦикла;
					КонецЦикла; 
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	ИначеЕсли ВидОтчёта = 1 Тогда 
	КолПЗ = 0;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ КАК ПЗ,
		|	ЭтапыПроизводственныхЗаданийСрезПоследних.Изделие КАК Изделие,
		|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.Количество КАК Количество
		|ИЗ
		|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних КАК ЭтапыПроизводственныхЗаданийСрезПоследних
		|ГДЕ
		|	ЭтапыПроизводственныхЗаданийСрезПоследних.Линейка = &Линейка
		|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Номер,
		|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.НомерОчереди,
		|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ";
		Если Не Изделие.Пустая() Тогда
		Запрос.Текст = Запрос.Текст + " И ЭтапыПроизводственныхЗаданийСрезПоследних.Изделие = &Изделие";
		Запрос.УстановитьПараметр("Изделие", Изделие);
		КонецЕсли;
	Запрос.УстановитьПараметр("Линейка", Линейка);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать(); 
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 
			Если Не СоздатьСписокРабочихМест(ВыборкаДетальныеЗаписи.Изделие,?(ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ПЗ.ДатаЗапуска),ВыборкаДетальныеЗаписи.ПЗ.ДатаЗапуска,ТекущаяДата())) Тогда
			Сообщить(СокрЛП(ВыборкаДетальныеЗаписи.Изделие.Наименование)+" - не создан список рабочих мест!");	
			Продолжить;			
			КонецЕсли;
		КолПЗ = КолПЗ + 1; 
			Если КолПЗ > КоличествоПЗ Тогда
			Прервать;
			КонецЕсли;
		СписокТО.Очистить();
			Если СокрЛП(Линейка.Подразделение.Наименование) = "Богородицк УПЭА" Тогда			
			НормыВремени = РегистрыСведений.НормыВремени.СрезПоследних(НаДату,Новый Структура("МПЗ",ВыборкаДетальныеЗаписи.Изделие));
			    Для Каждого НВ Из НормыВремени Цикл 
					Если НВ.НормаВремени = 0 Тогда
					Продолжить;
					КонецЕсли;
				КоличествоВЛинейке = ПолучитьКоличествоВЛинейке(НВ.ТехОперация); 
	            СписокТО.Добавить(НВ.ТехОперация,КоличествоВЛинейке);
					Если КоличествоВЛинейке = 0 Тогда
					Сообщить(СокрЛП(НВ.ТехОперация.Наименование) + " - не указана ни в одном рабочем месте линейки!");
					КонецЕсли;
			    КонецЦикла;				
			Иначе			
            СписокТО = ПолучитьСписокТОДатчика(ВыборкаДетальныеЗаписи.Изделие,НаДату);
			КонецЕсли;
		КоличествоИзделийВсего = КоличествоИзделийВсего + ВыборкаДетальныеЗаписи.Количество; 
		Выборка = ТаблицаНоменклатуры.НайтиСтроки(Новый Структура("Номенклатура",ВыборкаДетальныеЗаписи.Изделие));
			Если Выборка.Количество() = 0 Тогда
			ТЧ = ТаблицаНоменклатуры.Добавить();
			ТЧ.Номенклатура = ВыборкаДетальныеЗаписи.Изделие;
            ТЧ.Количество = ВыборкаДетальныеЗаписи.Количество;
			Иначе
			ТЧ = Выборка[0];
            ТЧ.Количество = ТЧ.Количество + ВыборкаДетальныеЗаписи.Количество;
			КонецЕсли;
		СписокПройденныхРМ = ПолучитьСписокПройденныхРМ(ВыборкаДетальныеЗаписи.ПЗ);         
			Для каждого ТО Из СписокТО Цикл 
				Если ТЧ.ТаблицаТО.Количество() > 0 Тогда
					Для каждого ТЧ_ТО_Ф Из ТЧ.ТаблицаТО Цикл
					ТЧ_ТО_Ф.флПЗ = Ложь;						
					КонецЦикла;
				КонецЕсли; 
			    	Для каждого РабочееМесто Из СписокРабочихМест Цикл
						Если СписокПройденныхРМ.НайтиПоЗначению(РабочееМесто.Значение) <> Неопределено Тогда
						Продолжить;
						КонецЕсли;
						    Для Каждого ТО_ПЗ Из РабочееМесто.Значение.ТехОперации Цикл 
								Если ТО_ПЗ.ТехОперация.ЭтоГруппа Тогда
									Если Не ТО.Значение.ПринадлежитЭлементу(ТО_ПЗ.ТехОперация) Тогда							
									Продолжить;
									КонецЕсли;	
								Иначе	
									Если ТО.Значение <> ТО_ПЗ.ТехОперация Тогда
									Продолжить;
									КонецЕсли;
								КонецЕсли;
							Выборка = ТЧ.ТаблицаТО.НайтиСтроки(Новый Структура("ГруппаРМ,ТО",РабочееМесто.Значение.ГруппаРабочихМест,ТО.Значение)); 
								Если Выборка.Количество() = 0 Тогда
								ВыборкаТТО = ТаблицаТО.НайтиСтроки(Новый Структура("ГруппаРМ,ТО",РабочееМесто.Значение.ГруппаРабочихМест,ТО.Значение));
									Если ВыборкаТТО.Количество() = 0 Тогда
									ТЧ_ТТО = ТаблицаТО.Добавить();
									ТЧ_ТТО.ГруппаРМ = РабочееМесто.Значение.ГруппаРабочихМест;	
									ТЧ_ТТО.КодГРМ = РабочееМесто.Значение.ГруппаРабочихМест.Код;	
									ТЧ_ТТО.ТО = ТО.Значение;
									КонецЕсли;
				                ТЧ_ТО = ТЧ.ТаблицаТО.Добавить();
								ТЧ_ТО.ГруппаРМ = РабочееМесто.Значение.ГруппаРабочихМест;	
								ТЧ_ТО.КодГРМ = РабочееМесто.Значение.ГруппаРабочихМест.Код;	
								ТЧ_ТО.ТО = ТО.Значение;
									Если СокрЛП(Линейка.Подразделение.Наименование) = "Богородицк УПЭА" Тогда
									НормыВремени = РегистрыСведений.НормыВремени.ПолучитьПоследнее(НаДату,Новый Структура("МПЗ,ТехОперация",ВыборкаДетальныеЗаписи.Изделие,ТО.Значение));
									ТЧ_ТО.НВ = НормыВремени.НормаВремени;
									Иначе
									НормыВремени = РегистрыСведений.НормыТО.ПолучитьПоследнее(НаДату,Новый Структура("ТехОперация",ТО.Значение));
									ТЧ_ТО.НВ = НормыВремени.Норма;
									КонецЕсли;
								ТЧ_ТО.Количество = 1;
									Если Не ТЧ_ТО.флПЗ Тогда
									ТЧ_ТО.флПЗ = Истина;
									ТЧ_ТО.КоличествоПЗ = 1;								
									КонецЕсли;																		
								Иначе	
								Выборка[0].Количество = Выборка[0].Количество + 1;
									Если Не Выборка[0].флПЗ Тогда
									Выборка[0].флПЗ = Истина;
									Выборка[0].КоличествоПЗ = Выборка[0].КоличествоПЗ + 1;								
									КонецЕсли;
								КонецЕсли;						
							КонецЦикла;						
					КонецЦикла;
			КонецЦикла;
		КонецЦикла;		
	Иначе
    ПолучитьППНаСервере();
		Для каждого ТЧ Из ТаблицаНоменклатуры Цикл
		СписокТО.Очистить();
			Если СокрЛП(Линейка.Подразделение.Наименование) = "Богородицк УПЭА" Тогда			
			НормыВремени = РегистрыСведений.НормыВремени.СрезПоследних(НаДату,Новый Структура("МПЗ",ТЧ.Номенклатура));
			    Для Каждого НВ Из НормыВремени Цикл
					Если НВ.НормаВремени = 0 Тогда
					Продолжить;
					КонецЕсли;
 				СписокТО.Добавить(НВ.ТехОперация);
			    КонецЦикла;				
			Иначе			
            СписокТО = ПолучитьСписокТОДатчикаТекущий(ТЧ.Номенклатура,НаДату);
			КонецЕсли;
				Если Не СоздатьСписокРабочихМест(ТЧ.Номенклатура,НаДату) Тогда
				Сообщить(СокрЛП(ТЧ.Номенклатура.Наименование)+" - не создан список рабочих мест!");	
				Продолжить;			
				КонецЕсли;
		КоличествоИзделийВсего = КоличествоИзделийВсего + ТЧ.Количество;	
			Для каждого ТО Из СписокТО Цикл 
				Если ТЧ.ТаблицаТО.Количество() > 0 Тогда
					Для каждого ТЧ_ТО_Ф Из ТЧ.ТаблицаТО Цикл
					ТЧ_ТО_Ф.флПЗ = Ложь;						
					КонецЦикла;
				КонецЕсли; 
			    	Для каждого РабочееМесто Из СписокРабочихМест Цикл 
					ВыборкаТРМ = ТаблицаРабочихМест.НайтиСтроки(Новый Структура("РабочееМесто",РабочееМесто.Значение));
					КоличествоРабочихМест = ВыборкаТРМ[0].Количество;
					    Для Каждого ТО_ПЗ Из РабочееМесто.Значение.ТехОперации Цикл 
							Если ТО_ПЗ.ТехОперация.ЭтоГруппа Тогда
								Если Не ТО.Значение.ПринадлежитЭлементу(ТО_ПЗ.ТехОперация) Тогда							
								Продолжить;
								КонецЕсли;	
							Иначе	
								Если ТО.Значение <> ТО_ПЗ.ТехОперация Тогда
								Продолжить;
								КонецЕсли;
							КонецЕсли;
						Выборка = ТЧ.ТаблицаТО.НайтиСтроки(Новый Структура("ГруппаРМ,ТО",РабочееМесто.Значение.ГруппаРабочихМест,ТО.Значение)); 
							Если Выборка.Количество() = 0 Тогда
							ВыборкаТТО = ТаблицаТО.НайтиСтроки(Новый Структура("ГруппаРМ,ТО",РабочееМесто.Значение.ГруппаРабочихМест,ТО.Значение));
								Если ВыборкаТТО.Количество() = 0 Тогда
								ТЧ_ТТО = ТаблицаТО.Добавить();
								ТЧ_ТТО.ГруппаРМ = РабочееМесто.Значение.ГруппаРабочихМест;	
								ТЧ_ТТО.КодГРМ = РабочееМесто.Значение.ГруппаРабочихМест.Код;	
								ТЧ_ТТО.ТО = ТО.Значение;
								КонецЕсли;
			                ТЧ_ТО = ТЧ.ТаблицаТО.Добавить();
							ТЧ_ТО.ГруппаРМ = РабочееМесто.Значение.ГруппаРабочихМест;	
							ТЧ_ТО.КодГРМ = РабочееМесто.Значение.ГруппаРабочихМест.Код;	
							ТЧ_ТО.ТО = ТО.Значение;
								Если СокрЛП(Линейка.Подразделение.Наименование) = "Богородицк УПЭА" Тогда
								НормыВремени = РегистрыСведений.НормыВремени.ПолучитьПоследнее(НаДату,Новый Структура("МПЗ,ТехОперация",ТЧ.Номенклатура,ТО.Значение));
								ТЧ_ТО.НВ = НормыВремени.НормаВремени;
								Иначе
								НормыВремени = РегистрыСведений.НормыТО.ПолучитьПоследнее(НаДату,Новый Структура("ТехОперация",ТО.Значение));
								ТЧ_ТО.НВ = НормыВремени.Норма;
								КонецЕсли;
							ТЧ_ТО.Количество = КоличествоРабочихМест;
								Если Не ТЧ_ТО.флПЗ Тогда
								ТЧ_ТО.флПЗ = Истина;
								ТЧ_ТО.КоличествоПЗ = ТЧ.Количество;								
								КонецЕсли;																		
							Иначе	
							Выборка[0].Количество = Выборка[0].Количество + КоличествоРабочихМест;
								Если Не Выборка[0].флПЗ Тогда
								Выборка[0].флПЗ = Истина;
								Выборка[0].КоличествоПЗ = Выборка[0].КоличествоПЗ + ТЧ.Количество;								
								КонецЕсли;
							КонецЕсли;						
						КонецЦикла;						
					КонецЦикла;
			КонецЦикла;	
		КонецЦикла;
	КонецЕсли;
ТаблицаНоменклатуры.Сортировать("Номенклатура");
ТаблицаТО.Сортировать("КодГРМ,ГруппаРМ,ТО");
	Если ВидОтчёта = 0 Тогда
	ОблШапкаОбщая.Параметры.ВидОтчёта = "Ретроспективный за период с "+Формат(Период.ДатаНачала,"ДФ=dd.MM.yyyy")+" по "+Формат(Период.ДатаОкончания,"ДФ=dd.MM.yyyy");
	ИначеЕсли ВидОтчёта = 1 Тогда
	ОблШапкаОбщая.Параметры.ВидОтчёта = "Текущая мощность на "+Формат(НаДату,"ДФ=dd.MM.yyyy");
	Иначе
	ОблШапкаОбщая.Параметры.ВидОтчёта = "Будущая мощность за период с "+Формат(Период.ДатаНачала,"ДФ=dd.MM.yyyy")+" по "+Формат(Период.ДатаОкончания,"ДФ=dd.MM.yyyy");
	КонецЕсли;
ТабДок.Вывести(ОблШапкаОбщая);
ТекГруппаРМ = Неопределено;
	Для каждого ТЧ Из ТаблицаТО Цикл
		Если ТекГруппаРМ <> ТЧ.ГруппаРМ Тогда
			Если ТекГруппаРМ <> Неопределено Тогда
			ТабДок.Присоединить(ОблШапкаТОИтого);
			КонецЕсли;
		ТекГруппаРМ = ТЧ.ГруппаРМ;
		КонецЕсли;
	ОблШапкаТО.Параметры.ГруппаРМ = СокрЛП(ТЧ.ГруппаРМ.Наименование);
	ОблШапкаТО.Параметры.ТО = СокрЛП(ТЧ.ТО.Наименование);
	ТабДок.Присоединить(ОблШапкаТО);	
	КонецЦикла;
		Если ТекГруппаРМ <> Неопределено Тогда
		ТабДок.Присоединить(ОблШапкаТОИтого);
		КонецЕсли;
ТабДок.Присоединить(ОблШапкаТОВсего);	
	Для каждого ТЧ Из ТаблицаНоменклатуры Цикл
	НВ_Средняя_Всего = 0;
	НВ_Средняя_Кол_Всего = 0;
	ОблСтрокаОбщая.Параметры.НаименованиеИзделия = СокрЛП(ТЧ.Номенклатура.Наименование);
	ОблСтрокаОбщая.Параметры.Изделие = ТЧ.Номенклатура;
	ОблСтрокаОбщая.Параметры.Количество = ТЧ.Количество;	
	ТабДок.Вывести(ОблСтрокаОбщая);
	ТекГруппаРМ = Неопределено;
	НВ_Средняя_Итого = 0;
	НВ_Средняя_Кол_Итого = 0;
	Кол = 2;
		Для каждого ТЧ_ТО Из ТаблицаТО Цикл 
			Если ТекГруппаРМ <> ТЧ_ТО.ГруппаРМ Тогда
				Если ТекГруппаРМ <> Неопределено Тогда
				ОблСтрокаТОИтого.Параметры.НВ_Средняя = НВ_Средняя_Итого;
				ОблСтрокаТОИтого.Параметры.НВ_Средняя_Кол = НВ_Средняя_Кол_Итого;
				ТекОбл = ТабДок.Присоединить(ОблСтрокаТОИтого);
					Если НВ_Средняя_Итого > ПаспортЛинейки.ВремяТактаМаксимальное Тогда
					ТабДок.Область(ТекОбл.Верх, Кол + 1, ТекОбл.Низ, Кол + 1).ЦветТекста = WebЦвета.Красный;					
					ИначеЕсли НВ_Средняя_Итого < ПаспортЛинейки.ВремяТактаМинимальное Тогда
					ТабДок.Область(ТекОбл.Верх, Кол + 1, ТекОбл.Низ, Кол + 1).ЦветТекста = WebЦвета.Зеленый;					
					КонецЕсли;
				Кол = Кол + 2;	
				КонецЕсли;
			ТекГруппаРМ = ТЧ_ТО.ГруппаРМ;
			НВ_Средняя_Итого = 0;
			НВ_Средняя_Кол_Итого = 0;
			КонецЕсли;
		Выборка = ТЧ.ТаблицаТО.НайтиСтроки(Новый Структура("ГруппаРМ,ТО",ТЧ_ТО.ГруппаРМ,ТЧ_ТО.ТО)); 
			Если Выборка.Количество() > 0 Тогда
				Если ВидОтчёта = 0 Тогда
			 	ОблСтрокаТО.Параметры.НВ_Средняя = Выборка[0].НВ/(Выборка[0].Количество/Выборка[0].КоличествоПЗ);
				ИначеЕсли ВидОтчёта = 1 Тогда
				КоличествоВЛинейке = ПолучитьКоличествоВЛинейкеБудущее(ТЧ_ТО.ГруппаРМ,ТЧ_ТО.ТО);
				ОблСтрокаТО.Параметры.НВ_Средняя = (Выборка[0].НВ*Выборка[0].Количество)/(КоличествоВЛинейке*КоличествоВЛинейке*Выборка[0].КоличествоПЗ);
				ОблСтрокаТО.Параметры.НВ_Средняя = Выборка[0].НВ/КоличествоВЛинейке;
				Иначе
				КоличествоВЛинейке = ПолучитьКоличествоВЛинейкеБудущее(ТЧ_ТО.ГруппаРМ,ТЧ_ТО.ТО);
				ОблСтрокаТО.Параметры.НВ_Средняя = Выборка[0].НВ/КоличествоВЛинейке;
				КонецЕсли;
			ОблСтрокаТО.Параметры.НВ_Средняя_Кол = ОблСтрокаТО.Параметры.НВ_Средняя*ТЧ.Количество;
			НВ_Средняя_Итого = НВ_Средняя_Итого + ОблСтрокаТО.Параметры.НВ_Средняя;
			НВ_Средняя_Кол_Итого = НВ_Средняя_Кол_Итого + ОблСтрокаТО.Параметры.НВ_Средняя_Кол;
			НВ_Средняя_Всего = НВ_Средняя_Всего + ОблСтрокаТО.Параметры.НВ_Средняя;
			НВ_Средняя_Кол_Всего = НВ_Средняя_Кол_Всего + ОблСтрокаТО.Параметры.НВ_Средняя_Кол;
           	Иначе
			ОблСтрокаТО.Параметры.НВ_Средняя = 0;
			ОблСтрокаТО.Параметры.НВ_Средняя_Кол = 0;
			КонецЕсли;
		ТабДок.Присоединить(ОблСтрокаТО);
		Кол = Кол + 2;	
		КонецЦикла; 
			Если ТекГруппаРМ <> Неопределено Тогда
			ОблСтрокаТОИтого.Параметры.НВ_Средняя = НВ_Средняя_Итого;
			ОблСтрокаТОИтого.Параметры.НВ_Средняя_Кол = НВ_Средняя_Кол_Итого; 
			ТекОбл = ТабДок.Присоединить(ОблСтрокаТОИтого);
				Если НВ_Средняя_Итого > ПаспортЛинейки.ВремяТактаМаксимальное Тогда
				ТабДок.Область(ТекОбл.Верх, Кол + 1, ТекОбл.Низ, Кол + 1).ЦветТекста = WebЦвета.Красный;					
				ИначеЕсли НВ_Средняя_Итого < ПаспортЛинейки.ВремяТактаМинимальное Тогда
				ТабДок.Область(ТекОбл.Верх, Кол + 1, ТекОбл.Низ, Кол + 1).ЦветТекста = WebЦвета.Зеленый;					
				КонецЕсли;
			КонецЕсли;
	ОблСтрокаТОВсего.Параметры.НВ_Средняя = НВ_Средняя_Всего;
	ОблСтрокаТОВсего.Параметры.НВ_Средняя_Кол = НВ_Средняя_Кол_Всего;
	ТабДок.Присоединить(ОблСтрокаТОВсего);			
	КонецЦикла;
ОблКонецОбщая.Параметры.Количество = КоличествоИзделийВсего;
ТабДок.Вывести(ОблКонецОбщая);
ТекГруппаРМ = Неопределено; 
НВ_Средняя_Кол_Итого = 0;
	Для каждого ТЧ_ТО Из ТаблицаТО Цикл           
	НВ_Средняя_Кол = 0;
		Если ТекГруппаРМ <> ТЧ_ТО.ГруппаРМ Тогда
			Если ТекГруппаРМ <> Неопределено Тогда
			ОблКонецТОИтого.Параметры.НВ_Средняя_Кол = НВ_Средняя_Кол_Итого;
			ОблКонецТОИтого.Параметры.Эффективность = НВ_Средняя_Кол_Итого/(РабочееВремя*?(РазмерностьРВ = 0,1,60));
			ОблКонецТОИтого.Параметры.ВремяТактаСреднее = НВ_Средняя_Кол_Итого/КоличествоИзделийВсего;
			ТабДок.Присоединить(ОблКонецТОИтого);
			КонецЕсли;
		ТекГруппаРМ = ТЧ_ТО.ГруппаРМ;
		НВ_Средняя_Кол_Итого = 0;
		КонецЕсли;
			Для каждого ТЧ Из ТаблицаНоменклатуры Цикл
			Выборка = ТЧ.ТаблицаТО.НайтиСтроки(Новый Структура("ГруппаРМ,ТО",ТЧ_ТО.ГруппаРМ,ТЧ_ТО.ТО)); 
				Если Выборка.Количество() > 0 Тогда
					Если ВидОтчёта = 0 Тогда
				 	НВ_Средняя = Выборка[0].НВ/(Выборка[0].Количество/Выборка[0].КоличествоПЗ);
					ИначеЕсли ВидОтчёта = 1 Тогда	
					КоличествоВЛинейке = ПолучитьКоличествоВЛинейкеБудущее(ТЧ_ТО.ГруппаРМ,ТЧ_ТО.ТО);
					//НВ_Средняя = (Выборка[0].НВ*Выборка[0].Количество)/(КоличествоВЛинейке*КоличествоВЛинейке*Выборка[0].КоличествоПЗ); 
					НВ_Средняя = Выборка[0].НВ/КоличествоВЛинейке;
					Иначе
					КоличествоВЛинейке = ПолучитьКоличествоВЛинейкеБудущее(ТЧ_ТО.ГруппаРМ,ТЧ_ТО.ТО);
					НВ_Средняя = Выборка[0].НВ/КоличествоВЛинейке;
					КонецЕсли;
				НВ_Средняя_Кол = НВ_Средняя_Кол + НВ_Средняя*ТЧ.Количество;
				НВ_Средняя_Кол_Итого = НВ_Средняя_Кол_Итого + НВ_Средняя*ТЧ.Количество;
				КонецЕсли;
			КонецЦикла;	
	ОблКонецТО.Параметры.Эффективность = НВ_Средняя_Кол/(РабочееВремя*?(РазмерностьРВ = 0,1,60));
	ТабДок.Присоединить(ОблКонецТО);
	КонецЦикла;
		Если ТекГруппаРМ <> Неопределено Тогда
		ОблКонецТОИтого.Параметры.НВ_Средняя_Кол = НВ_Средняя_Кол_Итого;
		ОблКонецТОИтого.Параметры.Эффективность = НВ_Средняя_Кол_Итого/(РабочееВремя*?(РазмерностьРВ = 0,1,60));
		ОблКонецТОИтого.Параметры.ВремяТактаСреднее = НВ_Средняя_Кол_Итого/КоличествоИзделийВсего;
		ТабДок.Присоединить(ОблКонецТОИтого);
		КонецЕсли;
ТабДок.Присоединить(ОблКонецТОВсего);
ТабДок.ФиксацияСверху = 3;
ТабДок.ФиксацияСлева = 2;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	СформироватьНаСервере();
	КонецЕсли;
КонецПроцедуры
