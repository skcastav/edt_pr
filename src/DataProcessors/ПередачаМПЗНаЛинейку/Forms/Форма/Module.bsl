
&НаКлиенте
Процедура ПриОткрытии(Отказ)
ОписаниеОшибки = "";
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
   Если Не МенеджерОборудованияКлиент.ПодключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО, ОписаниеОшибки) Тогда
      ТекстСообщения = НСтр("ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
      ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , ОписаниеОшибки);
      Сообщить(ТекстСообщения);
   КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
КонецПроцедуры 
            
&НаСервере
Функция ПолучитьМестоХраненияКанбанов(Линейка)
Возврат(Линейка.МестоХраненияКанбанов);
КонецФункции
         
&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если ЭтаФорма.ВводДоступен() Тогда                                  
	Массив = ОбщийМодульВызовСервера.РазложитьСтрокуВМассив(Данные,";");
		Если Массив[0] = "3" Тогда
		ЗначениеПараметра1 = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[1]);
			Если ЗначениеПараметра1 = Неопределено Тогда
			Сообщить("Линейка или место хранения не найдена!");
			Возврат;	
			КонецЕсли;
		МестоХраненияОтправитель = ОбщийМодульВызовСервера.ПолучитьМестоХраненияПоКоду(Массив[2]);
		Канбан = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[3]);
			Если Канбан = Неопределено Тогда
			Сообщить(Массив[3]+" - канбан не найден!");
			Возврат;	
			КонецЕсли;
				Если ТипЗнч(ЗначениеПараметра1) = Тип("СправочникСсылка.Линейки") Тогда
				МестоХраненияКанбанов = ПолучитьМестоХраненияКанбанов(ЗначениеПараметра1);
				Иначе
				МестоХраненияКанбанов = ЗначениеПараметра1;			
				КонецЕсли;
		Количество = Число(Массив[4]);
        НомерЯчейки = Число(Массив[5]);
		ИначеЕсли Массив[0] = "7" Тогда
		Линейка = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[1]);
		МестоХраненияОтправитель = ОбщийМодульВызовСервера.ПолучитьЗначениеРеквизита(Линейка,"МестоХраненияГП");
		МестоХраненияКанбанов = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[2]);
        Канбан = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[3]);
		Количество = Число(Массив[4]);
        НомерЯчейки = Число(Массив[5]);
		Иначе
		Сотрудник = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Данные);
		Возврат;	
		КонецЕсли;
	Выборка = ТаблицаКанбанов.НайтиСтроки(Новый Структура("Канбан,МестоХранения,МестоХраненияКанбанов,НомерЯчейки",Канбан,МестоХраненияОтправитель,МестоХраненияКанбанов,НомерЯчейки));
		Если Выборка.Количество() = 0 Тогда
		ТЧ = ТаблицаКанбанов.Добавить();
		ТЧ.НомерСтроки = ТаблицаКанбанов.Количество();         
		ТЧ.Канбан = Канбан;
		ТЧ.МестоХранения = МестоХраненияОтправитель;
		ТЧ.МестоХраненияКанбанов = МестоХраненияКанбанов;   
		ТЧ.Количество = Количество;
		ТЧ.НомерЯчейки = НомерЯчейки;
		Иначе
        Сообщить("Канбан уже отсканирован в таблицу!");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
          
&НаСервере
Процедура ВхождениеВСпецификации(СписокЛинеек,Элемент)
спНомен = ОбщийМодульВызовСервера.ПолучитьСписокВхождений(Элемент,ТекущаяДата());
	Для каждого Строка Из спНомен Цикл
		Если Не Строка.Значение.Товар.Пустая() Тогда
			Если СписокЛинеек.НайтиПоЗначению(Строка.Значение.Линейка) = Неопределено Тогда
			СписокЛинеек.Добавить(Строка.Значение.Линейка); 		
			КонецЕсли;	
		КонецЕсли;
	ВхождениеВСпецификации(СписокЛинеек,Строка.Значение);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокЛинеек(МПЗ)
СписокЛинеек = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	АналогиНормРасходов.Владелец.Владелец КАК ЭтапСпецификации
	|ИЗ
	|	РегистрСведений.НормыРасходов.СрезПоследних(&НаДату, ) КАК НормыРасходовСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.АналогиНормРасходов КАК АналогиНормРасходов
	|		ПО НормыРасходовСрезПоследних.НормаРасходов = АналогиНормРасходов.Владелец
	|ГДЕ
	|	АналогиНормРасходов.Элемент = &Элемент
	|	И НормыРасходовСрезПоследних.Норма > 0";
Запрос.УстановитьПараметр("Элемент", МПЗ);
Запрос.УстановитьПараметр("НаДату", ТекущаяДата());
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
    ВхождениеВСпецификации(СписокЛинеек,ВыборкаДетальныеЗаписи.ЭтапСпецификации);
	КонецЦикла;
Возврат(СписокЛинеек);
КонецФункции
      
&НаСервере      
Функция СформироватьОтчётПоОстаткам(ДатаПередачи)
ТабДок = Новый ТабличныйДокумент;

ТЗ = ТаблицаКанбанов.Выгрузить();
ТЗ.Свернуть("Канбан,МестоХранения,МестоХраненияКанбанов,Комментарий","Количество");

ОбъектЗн = РеквизитФормыВЗначение("Объект");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблМПЗ = Макет.ПолучитьОбласть("МПЗ");
ОблАналог = Макет.ПолучитьОбласть("Аналог");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.НаДату = ДатаПередачи;
ТабДок.Вывести(ОблШапка);                 
флНайден = Ложь;
	Для каждого ТЧ Из ТЗ Цикл
		Если ЗначениеЗаполнено(ТЧ.Комментарий) Тогда
		Продолжить;
		КонецЕсли; 
	КоличествоОстаток = ОбщийМодульВызовСервера.ПолучитьОстатокПоМестуХранения(ТЧ.МестоХранения,ТЧ.Канбан,ДатаПередачи);
	ЯчейкиКомплектации = ОбщийМодульРаботаСРегистрами.ПолучитьЯчейкуКомплектацииПоМестуХранения(ТЧ.МестоХраненияКанбанов,ТЧ.Канбан);
	КоличествоВЯчейке = ЯчейкиКомплектации.КоличествоВЯчейке;
		Если ЯчейкиКомплектации.КоличествоЯчеек = 1 Тогда
			Если КоличествоВЯчейке = 0 Тогда
			КоличествоВЯчейке = 1;			
			КонецЕсли;
		КонецЕсли;
			Если КоличествоОстаток < КоличествоВЯчейке Тогда
			флНайден = Истина;	
			ОблМПЗ.Параметры.НаименованиеМПЗ = СокрЛП(ТЧ.Канбан.Наименование);
			ОблМПЗ.Параметры.МПЗ = ТЧ.Канбан;
			ОблМПЗ.Параметры.ВидМПЗ = ?(ТипЗнч(ТЧ.Канбан) = Тип("СправочникСсылка.Материалы"),"Материал","Полуфабрикат");
			ОблМПЗ.Параметры.МестоХраненияКанбанов = СокрЛП(ТЧ.МестоХраненияКанбанов.Наименование);
			ОблМПЗ.Параметры.Статус = ПолучитьСтатус(ТЧ.Канбан);
				Если ТипЗнч(ТЧ.Канбан) = Тип("СправочникСсылка.Материалы") Тогда
				ОблМПЗ.Параметры.ГруппаПоЗакупкам = ТЧ.Канбан.ГруппаПоЗакупкам;
				КонецЕсли;
			ОблМПЗ.Параметры.КоличествоВыдано = ТЧ.Количество;
			ОблМПЗ.Параметры.КоличествоОстаток = КоличествоОстаток;
			ТабДок.Вывести(ОблМПЗ);
			ТабДок.НачатьГруппуСтрок("МПЗ",Истина);		                       
			СписокАналогов = ОбщийМодульВызовСервера.ПолучитьСписокВозможныхАналогов(ТЧ.Канбан,ТекущаяДата());  
				Для каждого Аналог Из СписокАналогов Цикл
				ОблАналог.Параметры.НаименованиеМПЗ = СокрЛП(Аналог.Значение.Наименование);
				ОблАналог.Параметры.МПЗ = Аналог.Значение;
				ОблАналог.Параметры.ВидМПЗ = ?(ТипЗнч(Аналог.Значение) = Тип("СправочникСсылка.Материалы"),"Материал","Полуфабрикат");
				ОблАналог.Параметры.Статус = ПолучитьСтатус(Аналог.Значение);
					Если ТипЗнч(Аналог.Значение) = Тип("СправочникСсылка.Материалы") Тогда
					ОблАналог.Параметры.ГруппаПоЗакупкам = Аналог.Значение.ГруппаПоЗакупкам;
					КонецЕсли;
				ОблАналог.Параметры.КоличествоОстаток = ОбщийМодульВызовСервера.ПолучитьОстатокПоМестуХранения(ТЧ.МестоХранения,Аналог.Значение);
				СписокЛинеек = ПолучитьСписокЛинеек(Аналог.Значение);
				Линейки = "";
					Для каждого Линейка Из СписокЛинеек Цикл
						Если ЗначениеЗаполнено(Линейка.Значение) Тогда
						Линейки = Линейки + СокрЛП(Линейка.Значение.Наименование) + "; ";
						КонецЕсли;			
					КонецЦикла;
				ОблАналог.Параметры.Линейки = Линейки;
				ТабДок.Вывести(ОблАналог);
				КонецЦикла;
			СписокОсновныхМПЗ = ОбщийМодульВызовСервера.ПолучитьСписокПримененияВКачествеАналога(ТЧ.Канбан,ТекущаяДата());
				Для каждого ОснМПЗ Из СписокОсновныхМПЗ Цикл
				ОблАналог.Параметры.НаименованиеМПЗ = "(О) "+СокрЛП(ОснМПЗ.Значение.Наименование);
				ОблАналог.Параметры.МПЗ = ОснМПЗ.Значение;
				ОблАналог.Параметры.ВидМПЗ = ?(ТипЗнч(Аналог.Значение) = Тип("СправочникСсылка.Материалы"),"Материал","Полуфабрикат");
				ОблАналог.Параметры.Статус = ПолучитьСтатус(ОснМПЗ.Значение);
					Если ТипЗнч(ОснМПЗ.Значение) = Тип("СправочникСсылка.Материалы") Тогда
					ОблАналог.Параметры.ГруппаПоЗакупкам = ОснМПЗ.Значение.ГруппаПоЗакупкам;
					КонецЕсли;
				ОблАналог.Параметры.КоличествоОстаток = ОбщийМодульВызовСервера.ПолучитьОстатокПоМестуХранения(ТЧ.МестоХранения,ОснМПЗ.Значение);
				СписокЛинеек = ПолучитьСписокЛинеек(ОснМПЗ.Значение);
				Линейки = "";
					Для каждого Линейка Из СписокЛинеек Цикл
						Если ЗначениеЗаполнено(Линейка.Значение) Тогда
						Линейки = Линейки + СокрЛП(Линейка.Значение.Наименование) + "; ";
						КонецЕсли;			
					КонецЦикла;
				ОблАналог.Параметры.Линейки = Линейки;
				ТабДок.Вывести(ОблАналог);
				КонецЦикла;
		ТабДок.ЗакончитьГруппуСтрок();
		КонецЕсли;	
	КонецЦикла; 	          
ТабДок.Вывести(ОблКонец); 
Возврат(?(флНайден,ТабДок,Неопределено));
КонецФункции

&НаСервере
Функция СоздатьПередачуНаЛинейку(ТЧ,ДатаПередачи)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПередачиНаЛинейкиОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ПередачиНаЛинейки.Остатки(&НаДату, ) КАК ПередачиНаЛинейкиОстатки
	|ГДЕ
	|	ПередачиНаЛинейкиОстатки.МестоХранения = &МестоХраненияКанбанов
	|	И ПередачиНаЛинейкиОстатки.НомерЯчейки = &НомерЯчейки
	|	И ПередачиНаЛинейкиОстатки.МПЗ = &МПЗ";
Запрос.УстановитьПараметр("НаДату", ДатаПередачи);
Запрос.УстановитьПараметр("МестоХраненияКанбанов", ТЧ.МестоХраненияКанбанов);
Запрос.УстановитьПараметр("МПЗ", ТЧ.Канбан);
Запрос.УстановитьПараметр("НомерЯчейки", ТЧ.НомерЯчейки);
РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Попытка
		НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
		Передача = Документы.ПередачаНаЛинейку.СоздатьДокумент();
		Передача.Дата = ДатаПередачи;
		Передача.Автор = Сотрудник;
		Передача.Подразделение = ТЧ.МестоХранения.Подразделение;
		Передача.УстановитьНовыйНомер(ПрисвоитьПрефикс(ТЧ.МестоХранения.Подразделение));
		Передача.НомерЯчейки = ТЧ.НомерЯчейки;
		Передача.МестоХранения = ТЧ.МестоХранения;
		Передача.МестоХраненияКанбанов = ТЧ.МестоХраненияКанбанов;
		Передача.МПЗ = ТЧ.Канбан;
		Передача.Количество = ТЧ.Количество;
	    Передача.Записать(РежимЗаписиДокумента.Проведение);
			Если ТипЗнч(ТЧ.Канбан) = Тип("СправочникСсылка.Номенклатура") Тогда
				Если Не ТЧ.Канбан.Канбан.Пустая() Тогда
					Если ТЧ.Канбан.Канбан.Подразделение.ОформлятьПустыеКанбаны > 0 Тогда
						Если Не ОбщийМодульРаботаСРегистрами.ОформитьПередачуКанбанаПоМестуХранения(ТЧ.МестоХранения,ТЧ.МестоХраненияКанбанов,ТЧ.Канбан,ТЧ.НомерЯчейки,Передача.Автор,Передача.Количество,ДатаПередачи) Тогда
						ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
						Возврат("Передача не оформлена!");				
						КонецЕсли; 
					КонецЕсли; 	
				КонецЕсли;
			Иначе
				Если Константы.МестоХраненияОсновное.Получить().Подразделение.ОформлятьПустыеКанбаны > 0 Тогда
					Если Не ОбщийМодульРаботаСРегистрами.ОформитьПередачуКанбанаПоМестуХранения(ТЧ.МестоХранения,ТЧ.МестоХраненияКанбанов,ТЧ.Канбан,ТЧ.НомерЯчейки,Передача.Автор,Передача.Количество,ДатаПередачи) Тогда
					ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
					Возврат("Передача не оформлена!");				
					КонецЕсли; 
				КонецЕсли;
			КонецЕсли;
		ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
		Возврат(Неопределено);
		Исключение
		ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
		Возврат(ОписаниеОшибки());
		КонецПопытки;
	Иначе
	Возврат("Не оприходована на линейке!");
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПередатьНаЛинейкуНаСервере()
СписокУдаления = Новый СписокЗначений;
    
ДатаПередачи = ТекущаяДата();
	Для каждого ТЧ Из ТаблицаКанбанов Цикл 
	Результат = СоздатьПередачуНаЛинейку(ТЧ,ДатаПередачи);
		Если Результат = Неопределено Тогда	
		СписокУдаления.Добавить(ТЧ);
		Иначе
		ТЧ.Комментарий = Результат;
		КонецЕсли;
	ДатаПередачи = ДатаПередачи + 1;
	КонецЦикла; 
ТабДок = СформироватьОтчётПоОстаткам(ДатаПередачи+1);
	Для каждого Стр Из СписокУдаления Цикл
	ТаблицаКанбанов.Удалить(Стр.Значение);
	КонецЦикла; 
Сотрудник = Справочники.Сотрудники.ПустаяСсылка();
Возврат(ТабДок);
КонецФункции

&НаКлиенте
Процедура ПередатьНаЛинейку(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	ТабДок = ПередатьНаЛинейкуНаСервере();
		Если ТабДок <> Неопределено Тогда
		ТабДок.Показать("Отчёт по остаткам");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТаблицу(Команда)
ТаблицаКанбанов.Очистить();
КонецПроцедуры
