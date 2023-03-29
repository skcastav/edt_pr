
&НаКлиенте
Процедура ПриОткрытии(Отказ)
Элементы.ЗагрузитьСпискомИзБазыСбыта.Доступность = ОбщийМодульВызовСервера.ДоступностьРоли("Администратор");
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
	ПараметрыТоварныхГрупп.Параметры.УстановитьЗначениеПараметра("ТоварнаяГруппа",ПолучитьТоварнуюГруппу(Элементы.Список.ТекущаяСтрока));
	ДополнительныеХарактериастикиТоваров.Параметры.УстановитьЗначениеПараметра("Товар",Элементы.Список.ТекущаяСтрока);
	ШаблоныПечатныхДокументов.Параметры.УстановитьЗначениеПараметра("ТоварнаяГруппа",ПолучитьТоварнуюГруппу(Элементы.Список.ТекущаяСтрока));
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПерейтиКСпецификацииНаСервере(Товар)
СписокМПЗ = Новый СписокЗначений;

Выборка = Справочники.Номенклатура.Выбрать(,,Новый Структура("Товар",Товар));
	Пока Выборка.Следующий() Цикл
	СписокМПЗ.Добавить(Выборка.Ссылка);
	КонецЦикла;
Выборка = Справочники.Материалы.Выбрать(,,Новый Структура("Товар",Товар));
	Пока Выборка.Следующий() Цикл
	СписокМПЗ.Добавить(Выборка.Ссылка);
	КонецЦикла;		 
Возврат(СписокМПЗ);
КонецФункции

&НаКлиенте
Процедура ПерейтиКСпецификации(Команда)
спНомен = ПерейтиКСпецификацииНаСервере(Элементы.Список.ТекущаяСтрока);
	Если спНомен.Количество() = 1 Тогда
	ВыбЭлемент = спНомен[0];
	ИначеЕсли спНомен.Количество() > 0 Тогда
	ВыбЭлемент = спНомен.ВыбратьЭлемент();
	Иначе
	Возврат;
	КонецЕсли;
		Если ВыбЭлемент <> Неопределено Тогда
			Если ТипЗнч(ВыбЭлемент.Значение) = Тип("СправочникСсылка.Номенклатура") Тогда
			ТекФорма = ПолучитьФорму("Справочник.Номенклатура.Форма.ФормаСписка");
			Иначе	
			ТекФорма = ПолучитьФорму("Справочник.Материалы.Форма.ФормаСписка");	
			КонецЕсли;
		ТекФорма.Открыть();
		ТекФорма.Элементы.Список.ТекущаяСтрока = ВыбЭлемент.Значение;
		КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПодобратьТоварнуюГруппуНаСервере(Товар)
Запрос = Новый Запрос;
СписокТоварныхГрупп.Очистить();

Наименование = Товар.Наименование;
	Если Лев(Наименование,1) = "2" Тогда
	Часть1 = Лев(Наименование,4);
	Иначе	
	Часть1 = Лев(Наименование,3);	
	КонецЕсли;
Наименование = Сред(Наименование,Найти(Наименование,"-")+1);
Часть2 = Лев(Наименование,Найти(Наименование,".")-1);
Наименование = Сред(Наименование,Найти(Наименование,".")+1);
Часть3 = Лев(Наименование,Найти(Наименование,".")-1);
Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТоварныеГруппы.Ссылка
	|ИЗ
	|	Справочник.ТоварныеГруппы КАК ТоварныеГруппы
	|ГДЕ
	|	ТоварныеГруппы.ЭтоГруппа = ЛОЖЬ
	|	И ТоварныеГруппы.Наименование ПОДОБНО &Наименование";
Запрос.УстановитьПараметр("Наименование", "%"+Часть1+"%"+Часть2+"%"+Часть3+"%");
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	СписокТоварныхГрупп.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ДобавитьТоварнуюГруппу(Товар,ТГ)
Товар_Объект = Товар.ПолучитьОбъект();
Товар_Объект.ТоварнаяГруппа = ТГ;
Товар_Объект.Записать();
КонецПроцедуры
 
&НаКлиенте
Процедура ПодобратьТоварнуюГруппу(Команда)
ПодобратьТоварнуюГруппуНаСервере(Элементы.Список.ТекущаяСтрока);
ТоварнаГруппа = СписокТоварныхГрупп.ВыбратьЭлемент("Выберите товарную группу",ТоварнаГруппа);
	Если ТоварнаГруппа <> Неопределено Тогда
	ДобавитьТоварнуюГруппу(Элементы.Список.ТекущаяСтрока,ТоварнаГруппа.Значение);	
	КонецЕсли; 	
КонецПроцедуры

&НаСервере
Функция ПолучитьТоварнуюГруппу(Товар)
Возврат(Товар.ТоварнаяГруппа);
КонецФункции

&НаСервере
Процедура ОчиститьТабличныйДокумент()
ТабДок.Очистить();
КонецПроцедуры 

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда 
	ПараметрыТоварныхГрупп.Параметры.УстановитьЗначениеПараметра("ТоварнаяГруппа",ПолучитьТоварнуюГруппу(Элементы.Список.ТекущаяСтрока));
	ДополнительныеХарактериастикиТоваров.Параметры.УстановитьЗначениеПараметра("Товар",Элементы.Список.ТекущаяСтрока);
	ШаблоныПечатныхДокументов.Параметры.УстановитьЗначениеПараметра("ТоварнаяГруппа",ПолучитьТоварнуюГруппу(Элементы.Список.ТекущаяСтрока));
	ОчиститьТабличныйДокумент();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокТоваров(СтрокаПоиска)
СписокТоваров = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст =		
	"ВЫБРАТЬ
	|	Номенклатура._Description,
	|	Номенклатура.Артикул,
	|	Номенклатура._Folder
	|ИЗ
	|	ВнешнийИсточникДанных.БазаСбыта.Таблица.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура._Description ПОДОБНО &_Description";		
Запрос.УстановитьПараметр("_Description",СтрокаПоиска+"%");
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если СокрЛП(ВыборкаДетальныеЗаписи._Folder) <> "00" Тогда
		СписокТоваров.Добавить(ВыборкаДетальныеЗаписи.Артикул,ВыборкаДетальныеЗаписи._Description);
		КонецЕсли; 
	КонецЦикла;
СписокТоваров.СортироватьПоПредставлению();
Возврат(СписокТоваров);
КонецФункции

&НаСервере
Процедура ПеренестиТовар(Код,Наименование)
	Если Справочники.Товары.НайтиПоКоду(Число(Код)).Пустая() Тогда
	Товар = Справочники.Товары.СоздатьЭлемент();
	Товар.Код = Число(Код);
	Товар.Наименование = Наименование;
	Товар.Записать();
	Иначе
	Сообщить(Наименование + " - существует в товарном справочнике!");	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиИзБазыСбыта(Команда)
СтрокаПоиска = "";
	Если ВвестиСтроку(СтрокаПоиска,"Введите строку для поиска",50) Тогда	
	СписокТоваров = ПолучитьСписокТоваров(СтрокаПоиска);
		Если СписокТоваров.ОтметитьЭлементы("Выберите товары для переноса") <> Неопределено Тогда	
			Для каждого Товар Из СписокТоваров Цикл
				Если Товар.Пометка Тогда
				ПеренестиТовар(Товар.Значение,Товар.Представление);
				КонецЕсли; 
			КонецЦикла; 
		КонецЕсли; 
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоказатьШаблонНаСервере(Стр)
ТабДок.Очистить();
	Если Стр.Внешний Тогда
	Макет = Новый ТабличныйДокумент;
	
	Макет.Прочитать(Константы.КаталогДокументовИПрограмм.Получить()+"532 (Паспорта)\Шаблоны\Шаблоны1С8\"+СокрЛП(Стр.Шаблон));
	Иначе	
	Макет = ПолучитьОбщийМакет(Стр.Шаблон);
	КонецЕсли;
		Если Стр.КоличествоРядов > 1 Тогда
		ОблШаблон = Макет.ПолучитьОбласть(,1,,1);
		Иначе	
		ОблШаблон = Макет.ПолучитьОбласть(,,,);
		КонецЕсли; 
Индекс = 0;
	Для каждого Парам Из Макет.Параметры Цикл
	ОблШаблон.Параметры.Установить(Индекс,"*****");
	Индекс = Индекс + 1;
	КонецЦикла;
ТабДок.Вывести(ОблШаблон);
	Если Стр.КоличествоРядов > 1 Тогда
		Для к = 1 По Стр.КоличествоРядов-1 Цикл
		ТабДок.Присоединить(ОблШаблон);
		КонецЦикла; 
	КонецЕсли; 
ТабДок.РазмерСтраницы = Стр.РазмерСтраницы;
ТабДок.ПолеСлева = Стр.ПолеСлева;
ТабДок.ПолеСверху = Стр.ПолеСверху;
ТабДок.ПолеСнизу = Стр.ПолеСнизу;
ТабДок.ПолеСправа = Стр.ПолеСправа;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьШаблон(Команда)
ПоказатьШаблонНаСервере(Элементы.ШаблоныПечатныхДокументов.ТекущиеДанные.Шаблон);
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныПечатныхДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
ПоказатьШаблонНаСервере(Элементы.ШаблоныПечатныхДокументов.ТекущиеДанные.Шаблон);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьКратностьЗапусковНаСервере(КодТовара,КратностьЗапуска)
Товар = Справочники.Товары.НайтиПоКоду(КодТовара);
	Если Не Товар.Пустая() Тогда
		Если Не Товар.ЭтоГруппа Тогда
		ТоварОбъект = Товар.ПолучитьОбъект();
		ТоварОбъект.КратностьЗапуска = КратностьЗапуска;
		ТоварОбъект.Записать();
		КонецЕсли; 
	Иначе
	Сообщить("Товар с кодом "+КодТовара+" не найден!");	
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКратностьЗапусков(Команда)
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл c кратностью запусков");
	Если Результат <> Неопределено Тогда
	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок;
	    Для к = 2 по КолСтрок Цикл
		Состояние("Обработка...",к*100/КолСтрок,"Загрузка кратности запусков из файла..."); 
        ЗагрузитьКратностьЗапусковНаСервере(Число(ExcelЛист.Cells(к,1).Value),Число(ExcelЛист.Cells(к,2).Value));
	    КонецЦикла;
	Результат.Excel.Quit();
	Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСпискомИзБазыСбытаНаСервере(СписокТоваров)
	Если Константы.КодБазы.Получить() = "ХРК" Тогда
	БазаСбыта = ОбщийМодульСинхронизации.УстановитьCOMСоединение(Справочники.ОбменДанными.НайтиПоНаименованию("База сбыта Харьков", Истина));
	Иначе	
	БазаСбыта = ОбщийМодульСинхронизации.УстановитьCOMСоединение(Константы.БазаДанных1ССбыт.Получить());
	КонецЕсли; 
		Если БазаСбыта = Неопределено Тогда
		Сообщить("Не открыто соединение с базой сбыта!");
		Возврат;
		КонецЕсли;
			Для каждого Артикул Из СписокТоваров Цикл	
			Код = ОбщийМодульВызовСервера.ПолучитьАртикулПоКодуТовара(Артикул.Значение);
			бсНомен = БазаСбыта.Справочники.Номенклатура.НайтиПоРеквизиту("Артикул",Код);
				Если Не бсНомен.Пустая() Тогда
				Товар = Справочники.Товары.НайтиПоКоду(Артикул.Значение);
					Если Товар.Пустая() Тогда
					Товар = Справочники.Товары.СоздатьЭлемент();
					Товар.Код = Число(Артикул.Значение);
				    Товар.Наименование = бсНомен.Наименование;
						Если Найти(бсНомен.Наименование,"[") > 0 Тогда
						СтрокаПоиска = СокрЛП(Лев(бсНомен.Наименование,Найти(бсНомен.Наименование,"[")-1));
						Иначе	
						СтрокаПоиска = СокрЛП(бсНомен.Наименование);
						КонецЕсли;
							Если Найти(бсНомен.НаименованиеПолное,СтрокаПоиска) > 0 Тогда
							Товар.ПолнНаименование = СокрЛП(Лев(бсНомен.НаименованиеПолное,Найти(бсНомен.НаименованиеПолное,СтрокаПоиска)-1));						
							Иначе	
							Товар.ПолнНаименование = СокрЛП(бсНомен.НаименованиеПолное);
							КонецЕсли; 			
								Если бсНомен.ИмСерийностьТовара = БазаСбыта.Перечисления.имСерийность.Стандартный Тогда
								Товар.Стандартный = Истина;
								Иначе	
								Товар.Стандартный = Ложь;
								КонецЕсли;
					Товар.КратностьЗапуска = бсНомен.КратностьЗапуска;
					Товар.КратностьПродажи = бсНомен.ИмКратностьПродажи;
					Товар.EAN = бсНомен.ИмEAN;
					Товар.ЕАС = бсНомен.EAC;
					Товар.СИ = бсНомен.СИ;
					Товар.Статус = Перечисления.СтатусыТоваров.Получить(БазаСбыта.Перечисления.ИмСтатусыТовара.Индекс(бсНомен.ИмСтатусТовара));
					Товар.Записать();
					Иначе
					флИзменен = Ложь;
						Если (Товар.EAN <> бсНомен.ИмEAN)или
							 (Товар.ЕАС <> бсНомен.EAC)или
							 (Товар.СИ <> бсНомен.СИ)или
							 (Товар.Статус <> Перечисления.СтатусыТоваров.Получить(БазаСбыта.Перечисления.ИмСтатусыТовара.Индекс(бсНомен.ИмСтатусТовара)))Тогда
						флИзменен = Истина;
						КонецЕсли;                                                                 
							Если Найти(бсНомен.Наименование,"[") > 0 Тогда                         
							СтрокаПоиска = СокрЛП(Лев(бсНомен.Наименование,Найти(бсНомен.Наименование,"[")-1));
							Иначе	
							СтрокаПоиска = СокрЛП(бсНомен.Наименование);
							КонецЕсли;
								Если Найти(бсНомен.НаименованиеПолное,СтрокаПоиска) > 0 Тогда
								ПолнНаименование = СокрЛП(Лев(бсНомен.НаименованиеПолное,Найти(бсНомен.НаименованиеПолное,СтрокаПоиска)-1));						
								Иначе	
								ПолнНаименование = СокрЛП(бсНомен.НаименованиеПолное);
								КонецЕсли;
									Если СокрЛП(Товар.ПолнНаименование) <> ПолнНаименование Тогда
									флИзменен = Истина;
									КонецЕсли; 
										Если флИзменен Тогда
										ТоварОбъект = Товар.ПолучитьОбъект();
										ТоварОбъект.EAN = бсНомен.ИмEAN;
										ТоварОбъект.ЕАС = бсНомен.EAC;
										ТоварОбъект.СИ = бсНомен.СИ;
										ТоварОбъект.Статус = Перечисления.СтатусыТоваров.Получить(БазаСбыта.Перечисления.ИмСтатусыТовара.Индекс(бсНомен.ИмСтатусТовара));
										ТоварОбъект.ПолнНаименование = ПолнНаименование;
										ТоварОбъект.Записать();
										КонецЕсли; 	
					Сообщить(СокрЛП(Товар.Наименование)+" - найден в производстве!");
					КонецЕсли;				
				Иначе
				Сообщить("Товар с артикулом "+Артикул+" не найден в торговой базе!");
				КонецЕсли;  
			КонецЦикла; 	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСпискомИзБазыСбыта(Команда)
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл со списком товаров");
	Если Результат <> Неопределено Тогда
	СписокТоваров = Новый СписокЗначений;
	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок;
	    Для к = 2 по КолСтрок Цикл
		Состояние("Обработка...",к*100/КолСтрок,"Создание списка товаров из из файла...");
		СписокТоваров.Добавить(ExcelЛист.Cells(к,1).Value);
		КонецЦикла;
	Состояние("Обработка...",,"Загрузка товаров из базы сбыта по списку...");
	ЗагрузитьСпискомИзБазыСбытаНаСервере(СписокТоваров);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура КопироватьХарактеристикиНаСервере(Товар)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДополнительныеХарактеристикиТовара.Наименование КАК Наименование,
	|	ДополнительныеХарактеристикиТовара.Значение КАК Значение
	|ИЗ
	|	Справочник.ДополнительныеХарактеристикиТовара КАК ДополнительныеХарактеристикиТовара
	|ГДЕ
	|	ДополнительныеХарактеристикиТовара.Владелец = &Владелец";
Запрос.УстановитьПараметр("Владелец", Товар);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ДХТ = Справочники.ДополнительныеХарактеристикиТовара.СоздатьЭлемент();
	ДХТ.Владелец = Элементы.Список.ТекущаяСтрока;
	ДХТ.Наименование = ВыборкаДетальныеЗаписи.Наименование;
	ДХТ.Значение = ВыборкаДетальныеЗаписи.Значение;
	ДХТ.Записать();
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КопироватьХарактеристики(Команда)
Товар = Элементы.Список.ТекущаяСтрока;
	Если ВвестиЗначение(Товар,"Выберите товар",Новый ОписаниеТипов("СправочникСсылка.Товары")) Тогда
	КопироватьХарактеристикиНаСервере(Товар);
	Элементы.ДополнительныеХарактериастикиТоваров.Обновить();
	КонецЕсли;	
КонецПроцедуры
