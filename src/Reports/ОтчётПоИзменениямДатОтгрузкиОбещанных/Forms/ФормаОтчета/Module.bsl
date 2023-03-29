
&НаСервере
Функция ПолучитьКоличествоЗарезервированоВсего(ЗНП,Продукция)
Запрос = Новый Запрос;
СписокМестХранения = Новый СписокЗначений;

СписокМестХранения.Добавить(Константы.МестоХраненияТНП.Получить());
СписокМестХранения.Добавить(Константы.МестоХраненияНеликвидов.Получить());
СписокМестХранения.Добавить(Константы.МестоХраненияПерепрогон.Получить());

Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(РезервированиеГПОбороты.КоличествоПриход) КАК КоличествоПриход
	|ИЗ
	|	РегистрНакопления.РезервированиеГП.Обороты КАК РезервированиеГПОбороты
	|ГДЕ
	|	РезервированиеГПОбороты.Документ = &Документ
	|	И РезервированиеГПОбороты.Продукция = &Продукция
	|	И РезервированиеГПОбороты.МестоХранения В(&СписокМестХранения)";
Запрос.УстановитьПараметр("Документ", ЗНП);
Запрос.УстановитьПараметр("Продукция", Продукция);
Запрос.УстановитьПараметр("СписокМестХранения", СписокМестХранения);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат(ВыборкаДетальныеЗаписи.КоличествоПриход);
	КонецЦикла;
Возврат(0);
КонецФункции

&НаСервере
Функция ПолучитьДатуПоследнегоВыпуска(ЗНП,Продукция)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВыпускПродукцииПоступление.Ссылка.Дата КАК Дата
	|ИЗ
	|	Документ.ВыпускПродукции.Поступление КАК ВыпускПродукцииПоступление
	|ГДЕ
	|	ВыпускПродукцииПоступление.Ссылка.ДокументОснование.ДокументОснование.ДокументОснование = &ДокументОснование
	|	И ВыпускПродукцииПоступление.Ссылка.Проведен = ИСТИНА
	|	И ВыпускПродукцииПоступление.Ссылка.НаСклад = ИСТИНА
	|	И ВыпускПродукцииПоступление.Номенклатура = &Номенклатура";
Запрос.УстановитьПараметр("ДокументОснование",ЗНП);	
Запрос.УстановитьПараметр("Номенклатура",Продукция);	
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
    Возврат(ВыборкаДетальныеЗаписи.Дата);
	КонецЦикла;
Возврат(Дата(1,1,1));
КонецФункции

&НаСервере
Функция ПолучитьДатуПоследнегоРезервирования(ЗНП,Продукция)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РезервированиеТабличнаяЧасть.Ссылка.Дата КАК Дата
	|ИЗ
	|	Документ.Резервирование.ТабличнаяЧасть КАК РезервированиеТабличнаяЧасть
	|ГДЕ
	|	РезервированиеТабличнаяЧасть.Ссылка.ДокументОснование = &ДокументОснование
	|	И РезервированиеТабличнаяЧасть.Продукция = &Продукция
	|	И РезервированиеТабличнаяЧасть.Ссылка.Проведен = ИСТИНА";
Запрос.УстановитьПараметр("ДокументОснование",ЗНП);	
Запрос.УстановитьПараметр("Продукция",Продукция);	
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
    Возврат(ВыборкаДетальныеЗаписи.Дата);
	КонецЦикла;
Возврат(Дата(1,1,1));
КонецФункции

&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();
ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблЗНП = Макет.ПолучитьОбласть("ЗНП");
ОблТовар = Макет.ПолучитьОбласть("Товар");
ОблДатаОтгрузки = Макет.ПолучитьОбласть("ДатаОтгрузки");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.ДатаНач = Отчет.Период.ДатаНачала;
ОблШапка.Параметры.ДатаКон = Отчет.Период.ДатаОкончания;
ТабДок.Вывести(ОблШапка);

Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИзменениеДатыОтгрузкиОбещанной.ЗНП КАК ЗНП,
	|	ИзменениеДатыОтгрузкиОбещанной.Товар КАК Товар,
	|	ИзменениеДатыОтгрузкиОбещанной.ДатаОтгрузкиОбещанная КАК ДатаОтгрузкиОбещанная,
	|	ИзменениеДатыОтгрузкиОбещанной.ДатаОтгрузкиНовая КАК ДатаОтгрузкиНовая,
	|	ИзменениеДатыОтгрузкиОбещанной.Причина КАК Причина,
	|	ИзменениеДатыОтгрузкиОбещанной.ДатаОбработки КАК ДатаОбработки,
	|	ИзменениеДатыОтгрузкиОбещанной.Период КАК Период,
	|	ЗаказНаПроизводствоЗаказ.Количество КАК КоличествоКПроизводству,
	|	ЗаказНаПроизводствоЗаказ.КоличествоВЗаказе КАК КоличествоВЗаказе,
	|	ЗаказНаПроизводствоЗаказ.Продукция КАК Продукция
	|ИЗ
	|	РегистрСведений.ИзменениеДатыОтгрузкиОбещанной КАК ИзменениеДатыОтгрузкиОбещанной
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаПроизводство.Заказ КАК ЗаказНаПроизводствоЗаказ
	|		ПО ИзменениеДатыОтгрузкиОбещанной.ЗНП = ЗаказНаПроизводствоЗаказ.Ссылка
	|			И ИзменениеДатыОтгрузкиОбещанной.Товар = ЗаказНаПроизводствоЗаказ.Товар
	|ГДЕ
	|	ИзменениеДатыОтгрузкиОбещанной.Период МЕЖДУ &ДатаНач И &ДатаКон";
	Если СтатусЗНП = 1 Тогда
	Запрос.Текст = Запрос.Текст + " И ИзменениеДатыОтгрузкиОбещанной.ЗНП.Закрыт";
	ИначеЕсли СтатусЗНП = 2 Тогда
	Запрос.Текст = Запрос.Текст + " И Не ИзменениеДатыОтгрузкиОбещанной.ЗНП.Закрыт";		
	КонецЕсли;
		Если Не ЗНП.Пустая() Тогда
		Запрос.Текст = Запрос.Текст + " И ИзменениеДатыОтгрузкиОбещанной.ЗНП = &ЗНП";
		Запрос.УстановитьПараметр("ЗНП",ЗНП);
		КонецЕсли;
			Если СписокЛинеек.Количество() > 0 Тогда
			Запрос.Текст = Запрос.Текст + " И ЗаказНаПроизводствоЗаказ.Продукция.Линейка В ИЕРАРХИИ(&СписокЛинеек)";
			Запрос.УстановитьПараметр("СписокЛинеек",СписокЛинеек);
			КонецЕсли;
				Если Не Товар.Пустая() Тогда
				Запрос.Текст = Запрос.Текст + " И ИзменениеДатыОтгрузкиОбещанной.Товар = &Товар";
				Запрос.УстановитьПараметр("Товар",Товар);		
				КонецЕсли;
					Если Не Причина.Пустая() Тогда
					Запрос.Текст = Запрос.Текст + " И ИзменениеДатыОтгрузкиОбещанной.Причина = &Причина";
					Запрос.УстановитьПараметр("Причина",Причина);
					КонецЕсли;
Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО
								|	ИзменениеДатыОтгрузкиОбещанной.ЗНП.Дата,
								|	ИзменениеДатыОтгрузкиОбещанной.Товар.Наименование
								|ИТОГИ СУММА(КоличествоКПроизводству),СУММА(КоличествоВЗаказе)
								|   ПО	ЗНП,Товар,Продукция"; 
Запрос.УстановитьПараметр("ДатаНач",Отчет.Период.ДатаНачала);
Запрос.УстановитьПараметр("ДатаКон",Отчет.Период.ДатаОкончания);
Результат = Запрос.Выполнить();
ВыборкаЗНП = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаЗНП.Следующий() Цикл
	флВыведен = Ложь;
	ВыборкаТовары = ВыборкаЗНП.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаТовары.Следующий() Цикл
			Если Не флВыведен Тогда
			ОблЗНП.Параметры.ЗНП = ВыборкаЗНП.ЗНП;
			ТабДок.Вывести(ОблЗНП);
			ТабДок.НачатьГруппуСтрок("ЗНП",Истина);
			флВыведен = Истина;
			КонецЕсли; 
		ОблТовар.Параметры.НаименованиеТовар = СокрЛП(ВыборкаТовары.Товар.Наименование);
		ОблТовар.Параметры.Товар = ВыборкаТовары.Товар;
		ВыборкаПродукция = ВыборкаТовары.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПродукция.Следующий() Цикл
				Если Не ЗначениеЗаполнено(ВыборкаПродукция.Продукция) Тогда
				ОблТовар.Параметры.НаименованиеПродукция = "";
				ОблТовар.Параметры.Парам = "";
				ОблТовар.Параметры.ДатаПоследнегоДокумента = Дата(1,1,1);
				ОблТовар.Параметры.КоличествоКПроизв = ВыборкаПродукция.КоличествоВЗаказе;
				ОблТовар.Параметры.КоличествоНеВыполненных = ВыборкаПродукция.КоличествоВЗаказе; 
				ИначеЕсли ТипЗнч(ВыборкаПродукция.Продукция) = Тип("СправочникСсылка.Номенклатура") Тогда
				ОблТовар.Параметры.НаименованиеПродукция = СокрЛП(ВыборкаПродукция.Продукция.Наименование);
				ОблТовар.Параметры.Парам = Новый Структура("ЗНП,Продукция",ВыборкаЗНП.ЗНП,ВыборкаПродукция.Продукция);
				КоличествоНеСозданных = ВыборкаПродукция.КоличествоКПроизводству - ПолучитьКоличествоСозданых(ВыборкаЗНП.ЗНП,ВыборкаПродукция.Продукция);
				ОблТовар.Параметры.КоличествоКПроизв = ВыборкаПродукция.КоличествоКПроизводству;
				ОблТовар.Параметры.КоличествоНеВыполненных = ОбщПолучитьКоличествоВПроизводстве(ВыборкаЗНП.ЗНП,ВыборкаПродукция.Продукция) + КоличествоНеСозданных;			
					Если ОблТовар.Параметры.КоличествоНеВыполненных = 0 Тогда
					ОблТовар.Параметры.ДатаПоследнегоДокумента = ПолучитьДатуПоследнегоВыпуска(ВыборкаЗНП.ЗНП,ВыборкаПродукция.Продукция);
					КонецЕсли; 
				Иначе
				ОблТовар.Параметры.НаименованиеПродукция = СокрЛП(ВыборкаПродукция.Продукция.Наименование);
				ОблТовар.Параметры.Парам = Новый Структура("ЗНП,Продукция",ВыборкаЗНП.ЗНП,ВыборкаПродукция.Продукция);	
				ОблТовар.Параметры.КоличествоКПроизв = ВыборкаПродукция.КоличествоКПроизводству;
				ОблТовар.Параметры.КоличествоНеВыполненных = ВыборкаПродукция.КоличествоКПроизводству - ПолучитьКоличествоЗарезервированоВсего(ВыборкаЗНП.ЗНП,ВыборкаПродукция.Продукция);			
					Если ОблТовар.Параметры.КоличествоНеВыполненных = 0 Тогда
					ОблТовар.Параметры.ДатаПоследнегоДокумента = ПолучитьДатуПоследнегоРезервирования(ВыборкаЗНП.ЗНП,ВыборкаПродукция.Продукция);
					КонецЕсли; 
				КонецЕсли;
			КоличествоИзменений = 0;
			ВыборкаДетальныхЗаписей = ВыборкаПродукция.Выбрать();
				Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
				КоличествоИзменений = КоличествоИзменений + 1;	
				КонецЦикла;
			ОблТовар.Параметры.КоличествоИзменений = КоличествоИзменений;		
			ТабДок.Вывести(ОблТовар);
			ТабДок.НачатьГруппуСтрок("Товары",Истина);
			ВыборкаДетальныхЗаписей.Сбросить();
				Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
				ОблДатаОтгрузки.Параметры.ДатаОтгрузкиОбещанная = ВыборкаДетальныхЗаписей.ДатаОтгрузкиОбещанная;
				ОблДатаОтгрузки.Параметры.ДатаОтгрузкиНовая = ВыборкаДетальныхЗаписей.ДатаОтгрузкиНовая;
				ОблДатаОтгрузки.Параметры.ДатаОбработки = ВыборкаДетальныхЗаписей.ДатаОбработки;
				ОблДатаОтгрузки.Параметры.Причина = ВыборкаДетальныхЗаписей.Причина;
				ТабДок.Вывести(ОблДатаОтгрузки);	
				КонецЦикла;
			КонецЦикла;    
		ТабДок.ЗакончитьГруппуСтрок();
		КонецЦикла;
			Если флВыведен Тогда
			ТабДок.ЗакончитьГруппуСтрок();
			КонецЕсли;
	КонецЦикла; 
ТабДок.Вывести(ОблКонец);	
ТабДок.ФиксацияСверху = 2;	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	Состояние("Обработка...",,"Формирования таблицы отчёта...");
	СформироватьНаСервере();
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ВывестиПоДокументам(Расшифровка)
Запрос = Новый Запрос;
ТД = Новый ТабличныйДокумент;

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет2");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблДокумент = Макет.ПолучитьОбласть("Документ");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.Документ = Расшифровка.ЗНП;
ОблШапка.Параметры.Продукция = Расшифровка.Продукция;
ТД.Вывести(ОблШапка);

	Если Расшифровка.Продукция = Неопределено Тогда 
	ИначеЕсли ТипЗнч(Расшифровка.Продукция) = Тип("СправочникСсылка.Номенклатура") Тогда
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МаршрутнаяКарта.Ссылка КАК Ссылка,
		|	МаршрутнаяКарта.Количество КАК Количество
		|ИЗ
		|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
		|ГДЕ
		|	МаршрутнаяКарта.ДокументОснование = &ДокументОснование
		|	И МаршрутнаяКарта.Номенклатура = &Продукция
		|
		|УПОРЯДОЧИТЬ ПО
		|	МаршрутнаяКарта.Дата";
	Запрос.УстановитьПараметр("ДокументОснование",Расшифровка.ЗНП);	
	Запрос.УстановитьПараметр("Продукция",Расшифровка.Продукция);	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОблДокумент.Параметры.Документ = ВыборкаДетальныеЗаписи.Ссылка;
		ОблДокумент.Параметры.Линейка = ВыборкаДетальныеЗаписи.Ссылка.Линейка;
		Статус = ВыборкаДетальныеЗаписи.Ссылка.Статус;
			Если Статус = 0 Тогда
			ОблДокумент.Параметры.Статус = "ОЖ";			
			ИначеЕсли Статус = 1 Тогда
			ОблДокумент.Параметры.Статус = "Р";				
			ИначеЕсли Статус = 2 Тогда
			ОблДокумент.Параметры.Статус = "О";
			ИначеЕсли Статус = 3 Тогда
			ОблДокумент.Параметры.Статус = "ЗАВ";
			ИначеЕсли Статус = 4 Тогда
			ОблДокумент.Параметры.Статус = "ЗАП";			
			КонецЕсли;
		ОблДокумент.Параметры.Комментарий = ВыборкаДетальныеЗаписи.Ссылка.СтандартныйКомментарий;
		ОблДокумент.Параметры.Количество = ВыборкаДетальныеЗаписи.Количество;
		ТД.Вывести(ОблДокумент);	    
		КонецЦикла;				
	Иначе	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РезервированиеТабличнаяЧасть.Ссылка КАК Ссылка,
		|	РезервированиеТабличнаяЧасть.Количество КАК Количество
		|ИЗ
		|	Документ.Резервирование.ТабличнаяЧасть КАК РезервированиеТабличнаяЧасть
		|ГДЕ
		|	РезервированиеТабличнаяЧасть.Ссылка.ДокументОснование = &ДокументОснование
		|	И РезервированиеТабличнаяЧасть.Продукция = &Продукция
		|
		|УПОРЯДОЧИТЬ ПО
		|	РезервированиеТабличнаяЧасть.Ссылка.Дата";
	Запрос.УстановитьПараметр("ДокументОснование",Расшифровка.ЗНП);	
	Запрос.УстановитьПараметр("Продукция",Расшифровка.Продукция);	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОблДокумент.Параметры.Документ = ВыборкаДетальныеЗаписи.Ссылка;
		ОблДокумент.Параметры.Линейка = "";
		ОблДокумент.Параметры.Статус = "";			
		ОблДокумент.Параметры.Комментарий = ВыборкаДетальныеЗаписи.Ссылка.Комментарий;
		ОблДокумент.Параметры.Количество = ВыборкаДетальныеЗаписи.Количество;
		ТД.Вывести(ОблДокумент);	    
		КонецЦикла;				
	КонецЕсли;
ТД.Вывести(ОблКонец);
ТД.Защита = Истина; 
Возврат(ТД);
КонецФункции

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
		Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		ТД = ВывестиПоДокументам(Расшифровка);
		ТД.Показать("По документам");
		КонецЕсли;
КонецПроцедуры
