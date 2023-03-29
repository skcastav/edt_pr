
&НаСервере
Процедура ВыполнитьВыгрузкуНаСервере()
	
	ПодключеннаяБаза = Новый COMОбъект("V77.Application");
	Открыта = ПодключеннаяБаза.Initialize(ПодключеннаяБаза.RMTrade, "/d\\kh-1c\Bases$\1CBases\pub_owen\ /NObmen /P1212","");	
	Если Не Открыта Тогда
		Сообщить("Ошибка подключения к базе 1с 77",СтатусСообщения.ОченьВажное);
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВыпускПродукцииПоступление.Номенклатура КАК Номенклатура,
		|	СУММА(ВыпускПродукцииПоступление.Количество) КАК Количество
		|ИЗ
		|	Документ.ВыпускПродукции.Поступление КАК ВыпускПродукцииПоступление
		|ГДЕ
		|	ВыпускПродукцииПоступление.Ссылка.МестоХранения.Родитель.Код = &Код
		|	И ВыпускПродукцииПоступление.Ссылка.Дата МЕЖДУ &Дата1 И &Дата2
		|
		|СГРУППИРОВАТЬ ПО
		|	ВыпускПродукцииПоступление.Номенклатура
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВыпускПродукцииПоступление.Номенклатура.Наименование";
	
	Запрос.УстановитьПараметр("Дата1", ПериодВыгрузки.ДатаНачала);
	Запрос.УстановитьПараметр("Дата2", КонецДня(ПериодВыгрузки.ДатаОкончания));
	Запрос.УстановитьПараметр("Код", "02");
	
	ТЗ = Запрос.Выполнить().Выгрузить();;
	Сообщить("Всего товаров для загрузки = "+ТЗ.Количество());
	
	
	
	спрПодразделения = ПодключеннаяБаза.CreateObject("Справочник.Подразделения");
	спрПодразделения.НайтиПоНаименованию("производство",0,1);
	ПодразделениеДок = спрПодразделения.ТекущийЭлемент();
	
	спрВидыДеятельности = ПодключеннаяБаза.CreateObject("Справочник.ВидыДеятельности");
	спрВидыДеятельности.НайтиПоНаименованию("Основная деятельность",0,1);
	ВидДеятельности = спрВидыДеятельности.ТекущийЭлемент();
	
	спрМестаХранения = ПодключеннаяБаза.CreateObject("Справочник.МестаХранения");
	спрМестаХранения.НайтиПоНаименованию("Новый склад",0,1);
	СкладГотовойПродукции = спрМестаХранения.ТекущийЭлемент();
	
	Ном77 = ПодключеннаяБаза.CreateObject("Справочник.ТМЦ");
	
	Док = ПодключеннаяБаза.CreateObject("Документ.ВыпускПродукции");
	Док.Новый();
	Док.ДатаДок = ПериодВыгрузки.ДатаОкончания;
	Док.УстановитьНовыйНомер("ВП-");
	Док.Фирма = ПодключеннаяБаза.Константа.БазФирма;
	Док.Подразделение = ПодразделениеДок;
	Док.МестоХраненияПродукции = СкладГотовойПродукции;
	Док.ВидДеятельности = ВидДеятельности;

	Для каждого Стр Из ТЗ Цикл
		
		ПерИмя = СокрЛП(Стр.Номенклатура.Наименование);
		Если Прав(ПерИмя,1) = ")" Тогда
			ПерИмя = Сред(ПерИмя,1,СтрДлина(ПерИмя)-1);
		КонецЕсли;
		Если НЕ СтрНайти(ПерИмя,"(") = 0 Тогда
			ПерИмя = Сред(ПерИмя,СтрНайти(ПерИмя,"(")+1);
		КонецЕсли;
		ПерИмя = СтрЗаменить(ПерИмя,"УП-","");
		
		Ном77 = ПодключеннаяБаза.CreateObject("Справочник.ТМЦ");
		РезПоиска = Ном77.НайтиПоНаименованию(ПерИмя,0,1);
		
		//Если РезПоиска = 1 и Не Ном77.ВидТМЦ.Идентификатор() = "Продукция" Тогда
		//	
		//	РезПоиска = 0;
		//	
		//	Запрос = ПодключеннаяБаза.CreateObject("Запрос");
		//	ТекстЗапроса = "
		//	|Спр = Справочник.ТМЦ.ТекущийЭлемент;
		//	|Условие (Спр.Наименование = """+ПерИмя+""");
		//	|Группировка Спр Без Групп;";
		//	Запрос.Выполнить(ТекстЗапроса);
		//	Пока Запрос.Группировка(1)=1 Цикл
		//	    Сообщить("9999 = "+Запрос.Спр.Наименование);
		//		Если Запрос.Спр.ВидТМЦ.Идентификатор() = "Продукция" Тогда
		//			Ном77 = Запрос.Спр;
		//			РезПоиска = 1;
		//			Прервать;
		//		КонецЕсли;
		//	КонецЦикла;			
		//	
		//КонецЕсли;
		
		Если РезПоиска = 0 Тогда
			Если Не СоздаватьНенайденныеТМЦ Тогда
				Сообщить("		- НЕ найден ТМЦ:  "+ПерИмя);
				Продолжить;
			КонецЕсли;
			спрСтатьиКалькуляции = ПодключеннаяБаза.CreateObject("Справочник.СтатьиКалькуляции");
			СчтОле=ПодключеннаяБаза.CreateObject("Счет");
			СчтОле.НайтиПоКоду("26");
			спрЕдиницы = ПодключеннаяБаза.CreateObject("Справочник.Единицы");
			спрКлассификаторЕдИзм = ПодключеннаяБаза.CreateObject("Справочник.КлассификаторЕдИзм");
			спрКлассификаторЕдИзм.НайтиПоНаименованию("шт",0,0);
			спрСтавкаНДС = ПодключеннаяБаза.CreateObject("Справочник.ШкалаСтавок");
			спрСтавкаНДС.НайтиПоНаименованию("Без НДС",0,0);
			спрНашаФирма = ПодключеннаяБаза.CreateObject("Справочник.Фирмы");
			спрНашаФирма.НайтиПоКоду("1",0);
			ЕдШтука = спрКлассификаторЕдИзм.ТекущийЭлемент();
			Если Ном77.НайтиПоКоду("ОВ0000000009855") = 0 Тогда
				Сообщить("Не найдена служебная группа с кодом ОВ0000000009855");
				Возврат;
			КонецЕсли;
			грТМЦ = Ном77.ТекущийЭлемент();
			Ном77.ИспользоватьРодителя(грТМЦ);
			
			Ном77.Новый();
			Ном77.Наименование = ПерИмя;
			Ном77.ПолнНаименование = ПерИмя;
			Ном77.БазоваяЕдиница = ЕдШтука;
			Ном77.ВидТМЦ = ПодключеннаяБаза.Перечисление.ВидыТМЦ.Продукция;
			Ном77.Счет = "26";
			//Ном77.ВидЗатрат = Константа.БазВидЗатратТМЦ;
			Ном77.ТипТовара=ПодключеннаяБаза.Перечисление.ТипыТоваров.Штучный;
			Ном77.СтавкаНДС = спрСтавкаНДС.ТекущийЭлемент();
			//Ном77.ВидДеятельности = глВосстановитьЗначение(,"БазВидДеятельности");
			Попытка
				Ном77.Записать();
				Сообщить("		- создана новая карточка ТМЦ:  "+ПерИмя);
			Исключение 
				Сообщить("Ошибка записи нового элемента! Возможно код не уникален...");
			КонецПопытки;
			
			спрЕдиницы.ИспользоватьВладельца(Ном77.ТекущийЭлемент());
			спрЕдиницы.Новый();
			спрЕдиницы.Коэффициент = 1;
			спрЕдиницы.Единица = Ном77.БазоваяЕдиница;
			спрЕдиницы.Наименование = Ном77.БазоваяЕдиница.Наименование;
			Попытка
				спрЕдиницы.Записать();
			Исключение КонецПопытки;
			Ном77.ЕдиницаПоУмолчанию = спрЕдиницы.ТекущийЭлемент();
			Попытка
				Ном77.Записать();
			Исключение КонецПопытки;
			ВыбПриб = Ном77.ТекущийЭлемент();
				
			ДокНормыЗатрыт = ПодключеннаяБаза.CreateObject("Документ.НормыЗатрат");
			ДокНормыЗатрыт.Новый();
			ДокНормыЗатрыт.ДатаДок = ПериодВыгрузки.ДатаНачала;
			
			ДокНормыЗатрыт.Фирма = спрНашаФирма.ТекущийЭлемент();
			ДокНормыЗатрыт.Продукция = ВыбПриб;
			ДокНормыЗатрыт.КвоПродукции = 1;
			ДокНормыЗатрыт.КоэффициентПродукции = 1;
			ДокНормыЗатрыт.ЕдПродукции = спрЕдиницы.ТекущийЭлемент();
			
			ДокНормыЗатрыт.НоваяСтрока();
			ДокНормыЗатрыт.ВидЭлемента = ПодключеннаяБаза.Перечисление.ВидыЭлементовСоставаПродукции.СтатьяКалькуляции;
			Если спрСтатьиКалькуляции.НайтиПоНаименованию("Сырье и материалы (сум)",0,1) = 1 Тогда
				ДокНормыЗатрыт.Элемент = спрСтатьиКалькуляции.ТекущийЭлемент();
			КонецЕсли;
			ДокНормыЗатрыт.Сумма = 50;
			
			ДокНормыЗатрыт.НоваяСтрока();
			ДокНормыЗатрыт.ВидЭлемента = ПодключеннаяБаза.Перечисление.ВидыЭлементовСоставаПродукции.СтатьяКалькуляции;
			Если спрСтатьиКалькуляции.НайтиПоНаименованию("Основная зарплата",0,1) = 1 Тогда
				ДокНормыЗатрыт.Элемент = спрСтатьиКалькуляции.ТекущийЭлемент();
			КонецЕсли;
			ДокНормыЗатрыт.Сумма = 5;
			
			ДокНормыЗатрыт.НоваяСтрока();
			ДокНормыЗатрыт.ВидЭлемента = ПодключеннаяБаза.Перечисление.ВидыЭлементовСоставаПродукции.СтатьяКалькуляции;
			Если спрСтатьиКалькуляции.НайтиПоНаименованию("Дополнительная зарплата",0,1) = 1 Тогда
				ДокНормыЗатрыт.Элемент = спрСтатьиКалькуляции.ТекущийЭлемент();
			КонецЕсли;
			ДокНормыЗатрыт.Сумма = 5;
			
			ДокНормыЗатрыт.НоваяСтрока();
			ДокНормыЗатрыт.ВидЭлемента = ПодключеннаяБаза.Перечисление.ВидыЭлементовСоставаПродукции.СтатьяКалькуляции;
			Если спрСтатьиКалькуляции.НайтиПоНаименованию("Отчисления на соцстрахование",0,1) = 1 Тогда
				ДокНормыЗатрыт.Элемент = спрСтатьиКалькуляции.ТекущийЭлемент();
			КонецЕсли;
			ДокНормыЗатрыт.Сумма = 5;
			
			ДокНормыЗатрыт.НоваяСтрока();
			ДокНормыЗатрыт.ВидЭлемента = ПодключеннаяБаза.Перечисление.ВидыЭлементовСоставаПродукции.СтатьяКалькуляции;
			Если спрСтатьиКалькуляции.НайтиПоНаименованию("Общепроизводственные расходы",0,1) = 1 Тогда
				ДокНормыЗатрыт.Элемент = спрСтатьиКалькуляции.ТекущийЭлемент();
			КонецЕсли;
			ДокНормыЗатрыт.Сумма = 5;
			
			ДокНормыЗатрыт.НоваяСтрока();
			ДокНормыЗатрыт.ВидЭлемента = ПодключеннаяБаза.Перечисление.ВидыЭлементовСоставаПродукции.СтатьяКалькуляции;
			Если спрСтатьиКалькуляции.НайтиПоНаименованию("Расходы на содержание оборудования",0,1) = 1 Тогда
				ДокНормыЗатрыт.Элемент = спрСтатьиКалькуляции.ТекущийЭлемент();
			КонецЕсли;
			ДокНормыЗатрыт.Сумма = 5;
			
			ДокНормыЗатрыт.Записать();
			ДокНормыЗатрыт.Провести();
			
			Ном77.НормыЗатрат.Установить(ДокНормыЗатрыт.ДатаДок, ДокНормыЗатрыт.ТекущийДокумент());
			
		КонецЕсли;
		
		Док.НоваяСтрока();
		Док.Продукция = Ном77.ТекущийЭлемент();
		Док.Кво = Стр.Количество;
		Док.Коэффициент = 1;
		Док.Ед = Док.Продукция.ЕдиницаПоУмолчанию; 
	КонецЦикла;
	
	Док.Примечание = "За период: "+ПредставлениеПериода(ПериодВыгрузки.ДатаНачала,КонецДня(ПериодВыгрузки.ДатаОкончания));
	Док.Записать();

	Сообщить("Создан документ 'Выпуск продукции' №" + Док.НомерДок + " от " + Док.ДатаДок);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыгрузку(Команда)
	Сообщить("Начало обработки: "+ТекущаяДата());
	ВыполнитьВыгрузкуНаСервере();
	Сообщить("Конец обработки:  "+ТекущаяДата());
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПериодВыгрузки.ДатаНачала = НачалоМесяца(ТекущаяДата());
	ПериодВыгрузки.ДатаОкончания = КонецМесяца(ТекущаяДата());
	
	СоздаватьНенайденныеТМЦ = Истина;
	
КонецПроцедуры
