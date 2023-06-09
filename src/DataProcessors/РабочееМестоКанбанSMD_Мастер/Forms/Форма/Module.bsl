
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.Исполнитель = ПараметрыСеанса.Пользователь; 
ПоказатьВсе = Истина;
КонецПроцедуры

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
	Если Не Объект.Линейка.Пустая() Тогда
	ЛинейкаПриИзменении(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПриИзменении(Элемент)
ПроверитьТаблицуЗаданий();
	Если ПоказатьВсе и ЛинияSMD.Пустая() и СортироватьПо = 1 Тогда
	Элементы.ПолучитьЗадания.Доступность = Истина;
	Иначе
	Элементы.ПолучитьЗадания.Доступность = Ложь; 
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПолучитьПервоеРабочееМесто()
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РабочиеМестаЛинеек.Ссылка
	|ИЗ
	|	Справочник.РабочиеМестаЛинеек КАК РабочиеМестаЛинеек
	|ГДЕ
	|	РабочиеМестаЛинеек.Линейка = &Линейка
	|	И РабочиеМестаЛинеек.ПометкаУдаления = ЛОЖЬ
	|	И РабочиеМестаЛинеек.ЭтоГруппа = ЛОЖЬ
	|	И РабочиеМестаЛинеек.Код = 1";
Запрос.УстановитьПараметр("Линейка", Объект.Линейка);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Объект.РабочееМесто = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция МожноРаботатьВАРМ()
	Если ОбщийМодульВызовСервера.МожноВыполнить(Объект.Линейка) Тогда	
	Возврат(Истина);
	Иначе
	Объект.Линейка = Справочники.Линейки.ПустаяСсылка();
	Сообщить("Работа АРМ запрещена в этой базе!");
	Возврат(Ложь);
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ЛинейкаПриИзменении(Элемент)
	Если Не МожноРаботатьВАРМ() Тогда
	Возврат;
	КонецЕсли;
ПолучитьПервоеРабочееМесто();
ПолучитьДанныеПоЗаданиямНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеПоЗаданиямНаСервере()
ТаблицаЗаданий.Очистить();
Запрос = Новый Запрос;
ЗапросЛО = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПервых.ПЗ,
	|	ЭтапыПроизводственныхЗаданийСрезПервых.Изделие,
	|	ЭтапыПроизводственныхЗаданийСрезПервых.ДатаНачала
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПервых КАК ЭтапыПроизводственныхЗаданийСрезПервых
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПервых.Линейка = &Линейка
	|	И ЭтапыПроизводственныхЗаданийСрезПервых.ПЗ.ДокументОснование.Статус <> 3
	|	И ЭтапыПроизводственныхЗаданийСрезПервых.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
Запрос.УстановитьПараметр("Линейка",Объект.Линейка);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл   
    ТЧ = ТаблицаЗаданий.Добавить();
	ТЧ.Спецификация = ВыборкаДетальныеЗаписи.Изделие;
	ТЧ.Статус = ПолучитьСтатус(ВыборкаДетальныеЗаписи.Изделие);
	ТЧ.СтатусМТК = ВыборкаДетальныеЗаписи.ПЗ.ДокументОснование.Статус;
	ТЧ.ПЗ = ВыборкаДетальныеЗаписи.ПЗ;
	ТЧ.ДатаПЗ = ВыборкаДетальныеЗаписи.ПЗ.Дата;
	ТЧ.ДатаЗапуска = ВыборкаДетальныеЗаписи.ПЗ.ДатаЗапуска;
	ТЧ.Приоритет = ?(ВыборкаДетальныеЗаписи.ПЗ.НомерОчереди > 0,Истина,Ложь);
	ТЧ.НомерОчереди = ВыборкаДетальныеЗаписи.ПЗ.НомерОчереди;
	ТЧ.МестоХраненияПотребитель = ВыборкаДетальныеЗаписи.ПЗ.ДокументОснование.МестоХраненияПотребитель;
	ТЧ.Количество = ВыборкаДетальныеЗаписи.ПЗ.Количество;
	ТЧ.Линия = ВыборкаДетальныеЗаписи.ПЗ.ЛинияSMD;
	ТЧ.ДатаНачала = ВыборкаДетальныеЗаписи.ДатаНачала;
		Для каждого ТЧ_Линии Из ВыборкаДетальныеЗаписи.Изделие.ЛинииSMD Цикл	
		ТЧ.Линии.Добавить(ТЧ_Линии.Линия);
		КонецЦикла;
	ЗапросЛО.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЛьготнаяОчередь.Период КАК Период
		|ИЗ
		|	РегистрСведений.ЛьготнаяОчередь КАК ЛьготнаяОчередь
		|ГДЕ
		|	ЛьготнаяОчередь.НормаРасходов.Элемент = &МПЗ
		|	И ЛьготнаяОчередь.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период";
	ЗапросЛО.УстановитьПараметр("МПЗ",ВыборкаДетальныеЗаписи.Изделие);
	РезультатЗапросаЛО = ЗапросЛО.Выполнить();
	ВыборкаЛО = РезультатЗапросаЛО.Выбрать();
		Пока ВыборкаЛО.Следующий() Цикл
		ТЧ.ЛОПриборов = Истина;
		ТЧ.ДатаЛО = ВыборкаЛО.Период;
		КонецЦикла;
	ЗапросЛО.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЛьготнаяОчередь.НормаРасходов.Элемент КАК МПЗ
		|ИЗ
		|	РегистрСведений.ЛьготнаяОчередь КАК ЛьготнаяОчередь
		|ГДЕ
		|	ЛьготнаяОчередь.ПЗ = &ПЗ
		|	И ЛьготнаяОчередь.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
	ЗапросЛО.УстановитьПараметр("ПЗ",ВыборкаДетальныеЗаписи.ПЗ);
	РезультатЗапросаЛО = ЗапросЛО.Выполнить();
	ТЧ.ЛОSMD = Не РезультатЗапросаЛО.Пустой();		    
	КонецЦикла;
		Если СортироватьПо = 1 Тогда
		ТаблицаЗаданий.Сортировать("ЛОПриборов Убыв,ДатаЛО,ДатаПЗ");
		ИначеЕсли СортироватьПо = 2 Тогда
		ТаблицаЗаданий.Сортировать("Приоритет Убыв,НомерОчереди,ЛОПриборов Убыв,ДатаЛО,ДатаПЗ");		
		Иначе
		ТаблицаЗаданий.Сортировать("Спецификация,ЛОПриборов Убыв,ДатаЛО,ДатаПЗ");			
		КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьЗадания(Команда)
ПолучитьДанныеПоЗаданиямНаСервере();
ПроверитьТаблицуЗаданий();
Состояние("Обработка...",,"Получение остатков по местам хранения");
ПолучитьТаблицуСклада();
	Если ТаблицаСклада.Количество() > 0 Тогда
		Для каждого ТЧ Из ТаблицаЗаданий Цикл
			Если Не ЗначениеЗаполнено(ТЧ.ДатаЗапуска) Тогда
			Состояние("Обработка...",,"Проверка на ЛО "+ТЧ.ПЗ);
			СохранитьТаблицуСклада();
			ТЧ.ЛОSMD = ПроверитьНаЛОНаСервере(ТЧ.ПЗ,ТЧ.Спецификация,ТЧ.Количество);
				Если ТЧ.ЛОSMD Тогда
				ВосстановитьТаблицуСклада();
				КонецЕсли; 
			КонецЕсли; 	
		КонецЦикла;	
	Иначе
	Сообщить("Таблица остатков по местам хранения пустая!");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьСпецификации(Команда)
	Если Элементы.ТаблицаЗаданий.ТекущаяСтрока <> Неопределено Тогда
	ОткрытьФорму("Отчет.ПечатьСпецификации.Форма.ФормаОтчета",Новый Структура("Спецификация,УникальныеНомера",Элементы.ТаблицаЗаданий.ТекущиеДанные.Спецификация,Истина));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура НазначитьЛиниюНаСервере(ПЗ,ЛинияSMD)
ПЗОбъект = ПЗ.ПолучитьОбъект();
ПЗОбъект.ЛинияSMD = ЛинияSMD;
ПЗОбъект.Записать();
КонецПроцедуры

&НаСервере
Функция ПолучитьСтатусМТК(ПЗ)
Возврат(ПЗ.ДокументОснование.Статус);
КонецФункции

&НаКлиенте
Процедура НазначитьЛинии(Команда)
	Для каждого ТЧ Из ТаблицаЗаданий Цикл
		Если ТЧ.Пометка Тогда
			Если ПолучитьСтатусМТК(ТЧ.ПЗ) = 0 Тогда
				Если Не ТЧ.ЛОSMD Тогда
				НазначитьЛиниюНаСервере(ТЧ.ПЗ,ЛинияSMD);
				ТЧ.Линия = ЛинияSMD;
				ТЧ.Пометка = Ложь;					
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция УстановитьНомерОчередиПЗ(ПЗ,НО)
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	МТКОбъект = ПЗ.ДокументОснование.ПолучитьОбъект();
	МТКОбъект.НомерОчереди = НО;
	МТКОбъект.Записать();
	//ОбщийМодульРаботаСРегистрами.ИзменитьНомерОчереди(МТКОбъект.Ссылка,НО);
	ПЗОбъект = ПЗ.ПолучитьОбъект();
	ПЗОбъект.НомерОчереди = НО;
	ПЗОбъект.Записать();
	//ОбщийМодульРаботаСРегистрами.ИзменитьНомерОчереди(ПЗОбъект.Ссылка,НО);
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат(Ложь);
	КонецПопытки;
Возврат(Истина);
КонецФункции

&НаСервере
Функция ПолучитьПустуюЛиниюSMD()
Возврат(Справочники.ЛинииSMD.ПустаяСсылка());
КонецФункции

&НаСервере
Процедура ОтменитьЛинииНаСервере()
ЛинияSMD = ПолучитьПустуюЛиниюSMD();
	Для каждого ТЧ Из ТаблицаЗаданий Цикл
		Если ТЧ.Пометка Тогда
			Если ТЧ.ПЗ.ДокументОснование.Статус = 0 Тогда
			НазначитьЛиниюНаСервере(ТЧ.ПЗ,ЛинияSMD);
			ТЧ.Линия = ЛинияSMD;
			ТЧ.Пометка = Ложь;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;			
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьЛинии(Команда)
ОтменитьЛинииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПроверитьТаблицуЗаданий()
	Если СортироватьПо = 1 Тогда
	ТаблицаЗаданий.Сортировать("ЛОПриборов Убыв,ДатаЛО,ДатаПЗ");
	ИначеЕсли СортироватьПо = 2 Тогда
	ТаблицаЗаданий.Сортировать("Приоритет Убыв,НомерОчереди,ЛОПриборов Убыв,ДатаЛО,ДатаПЗ");		
	Иначе
	ТаблицаЗаданий.Сортировать("Спецификация,ЛОПриборов Убыв,ДатаЛО,ДатаПЗ");			
	КонецЕсли;	
		Для каждого ТЧ Из ТаблицаЗаданий Цикл
		ТЧ.Показать = Ложь;
			Если ПоказатьВсе Тогда
			ТЧ.Показать = Истина;
			Иначе
				Если Показать = 0 Тогда
	 				Если ТЧ.Линия.Пустая() Тогда
						Если Не ЛинияSMD.Пустая() Тогда
							Если ТЧ.Линии.НайтиПоЗначению(ЛинияSMD) <> Неопределено Тогда
							ТЧ.Показать = Истина;
							КонецЕсли;
						Иначе
						ТЧ.Показать = Истина;
						КонецЕсли;  	
					КонецЕсли;
				ИначеЕсли Показать = 1 Тогда
					Если Не ТЧ.Линия.Пустая() Тогда
						Если Не ЛинияSMD.Пустая() Тогда	
							Если ТЧ.Линия = ЛинияSMD Тогда
							ТЧ.Показать = Истина;
							КонецЕсли; 
						Иначе
						ТЧ.Показать = Истина;
						КонецЕсли;	
					КонецЕсли; 
				ИначеЕсли Показать = 2 Тогда
					Если Значениезаполнено(ТЧ.ДатаНачала) Тогда
						Если Не ЛинияSMD.Пустая() Тогда	
							Если ТЧ.Линия = ЛинияSMD Тогда
							ТЧ.Показать = Истина;
							КонецЕсли; 
						Иначе
						ТЧ.Показать = Истина;
						КонецЕсли;	
					КонецЕсли; 
				Иначе
					Если ТЧ.ЛОSMD = Истина Тогда
						Если Не ЛинияSMD.Пустая() Тогда
							Если ТЧ.Линии.НайтиПоЗначению(ЛинияSMD) <> Неопределено Тогда
							ТЧ.Показать = Истина;
							КонецЕсли;
						Иначе
						ТЧ.Показать = Истина;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;	
		КонецЦикла;
Отбор = Новый Структура("Показать", Истина);
Элементы.ТаблицаЗаданий.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВсеПриИзменении(Элемент)
Элементы.Показать.Доступность = Не ПоказатьВсе; 
	Если ПоказатьВсе и ЛинияSMD.Пустая() и СортироватьПо = 1 Тогда
	Элементы.ПолучитьЗадания.Доступность = Истина;
	Иначе
	Элементы.ПолучитьЗадания.Доступность = Ложь; 
	КонецЕсли; 
ПроверитьТаблицуЗаданий();
КонецПроцедуры

&НаСервере
Функция ПроверитьНаСкладеНаСервере(МПЗ,Количество)
Выборка = ТаблицаСклада.НайтиСтроки(Новый Структура("МПЗ",МПЗ));
	Если Выборка.Количество() > 0 Тогда
		Если Выборка[0].Количество >= Количество Тогда
		Выборка[0].Количество = Выборка[0].Количество - Количество;
		Возврат(Истина);
		КонецЕсли;
	КонецЕсли;
Возврат(Ложь);
КонецФункции

&НаСервере
Процедура РаскрытьНаМПЗиПроверить(Узел,ЭтапСпецификации,КолУзла)
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_М(ЭтапСпецификации,ТекущаяДата());
	Пока ВыборкаНР.Следующий() Цикл
		Если ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Номенклатура")Тогда
			Если ВыборкаНР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Набор Тогда
			РаскрытьНаМПЗиПроверить(Узел,ВыборкаНР.Элемент,ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла);
			Продолжить;
			ИначеЕсли Не ВыборкаНР.Элемент.Канбан.Пустая() Тогда
				Если Не ВыборкаНР.Элемент.Канбан.РезервироватьВПроизводстве Тогда		
				Продолжить;
				КонецЕсли;			
			КонецЕсли;
		Выборка = Этапы.НайтиСтроки(Новый Структура("ЭтапСпецификации",ВыборкаНР.Элемент));
        	Если Выборка.Количество() > 0 Тогда
			Продолжить;
			КонецЕсли;
		КонецЕсли;
	ТаблицаМПЗ.Очистить();	
	ТЧ = ТаблицаМПЗ.Добавить();
	ТЧ.МПЗ = ВыборкаНР.Элемент;
	ТЧ.Количество = ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла;
	ТЧ.Приоритет = 1;
	ТаблицаАналогов = ОбщегоНазначенияПовтИсп.ПолучитьАналогиНормРасходов(ВыборкаНР.Ссылка,ТекущаяДата(),Истина);
		Для каждого ТЧ_ТА Из ТаблицаАналогов Цикл
		ТЧ = ТаблицаМПЗ.Добавить();
		ТЧ.МПЗ = ТЧ_ТА.Элемент;
		ТЧ.Количество = ТЧ_ТА.Норма*КолУзла;
		ТЧ.Приоритет = ?(ПолучитьСтатус(ТЧ_ТА.Элемент) = Перечисления.СтатусыМПЗ.ДоИсчерпанияЗапасов,0,ТЧ_ТА.Ссылка.Приоритет + 1); 
		КонецЦикла;
	ТаблицаМПЗ.Сортировать("Приоритет");
	флЗарезервирован = Ложь;
		Для каждого ТЧ Из ТаблицаМПЗ Цикл
			Если ПроверитьНаСкладеНаСервере(ТЧ.МПЗ,ТЧ.Количество) Тогда 
			флЗарезервирован = Истина;
			Прервать;				
			КонецЕсли; 
		КонецЦикла;
			Если Не флЗарезервирован Тогда
			СписокЛО.Добавить(ВыборкаНР.Ссылка);
			КонецЕсли;  		
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Функция ПроверитьНаЛОНаСервере(ПЗ,Спецификация,Количество)
СписокЛО.Очистить();
Этапы.Очистить();
ЭтапыАРМ.Очистить();	
РезультатПроверки = ОбщийМодульСозданиеДокументов.ПроверитьЭтапыСпецификации(Объект.Линейка,Спецификация);
	Если РезультатПроверки.Пустая() Тогда
	ОбщийМодульВызовСервера.ПолучитьТаблицуЭтаповСпецификации(Этапы,Спецификация,Количество,Ложь,ТекущаяДата());
		Для каждого ТЧ_Этап Из Этапы Цикл
		РаскрытьНаМПЗиПроверить(ТЧ_Этап.ЭтапСпецификации,ТЧ_Этап.ЭтапСпецификации,ТЧ_Этап.Количество);
		КонецЦикла;
	ОбщийМодульРаботаСРегистрами.ОбработкаЛьготнойОчереди(ПЗ,СписокЛО);
		Если СписокЛО.Количество() > 0 Тогда
		Возврат(Истина);
		КонецЕсли; 
	Иначе
	Сообщить("Не найдено рабочее место для "+РезультатПроверки);
	КонецЕсли;
Возврат(Ложь);
КонецФункции 

&НаСервере
Процедура ПолучитьТаблицуСклада()
ТаблицаСклада.Очистить();
СписокМестХранения = Новый СписокЗначений;
Запрос = Новый Запрос;

СписокМестХранения.Добавить(Объект.Линейка.Подразделение.МестоХраненияПоУмолчанию);
СписокМестХранения.Добавить(Объект.Линейка.Подразделение.МестоХраненияДополнительный);
СписокМестХранения.Добавить(Объект.Линейка.МестоХраненияКанбанов); 
Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаХраненияОстатки.МПЗ КАК МПЗ,
	|	МестаХраненияОстатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.МестаХранения.Остатки(&НаДату, ) КАК МестаХраненияОстатки
	|ГДЕ
	|	МестаХраненияОстатки.МестоХранения В(&СписокМестХранения)
	|ИТОГИ
	|	СУММА(Количество)
	|ПО
	|	МПЗ";
Запрос.УстановитьПараметр("СписокМестХранения", СписокМестХранения);
Запрос.УстановитьПараметр("НаДату", ТекущаяДата());
РезультатЗапроса = Запрос.Выполнить();
Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
	ТЧ = ТаблицаСклада.Добавить();
	ТЧ.МПЗ = Выборка.МПЗ;
	ТЧ.Количество = Выборка.Количество;	
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура СохранитьТаблицуСклада()
ТаблицаСкладаКопия.Очистить();
	Для каждого ТЧ_МПЗ Из ТаблицаСклада Цикл
	ТЧ = ТаблицаСкладаКопия.Добавить();
	ТЧ.МПЗ = ТЧ_МПЗ.МПЗ;
	ТЧ.Количество = ТЧ_МПЗ.Количество;
	КонецЦикла; 
КонецПроцедуры 

&НаСервере
Процедура ВосстановитьТаблицуСклада()
ТаблицаСклада.Очистить();
	Для каждого ТЧ_МПЗ Из ТаблицаСкладаКопия Цикл
	ТЧ = ТаблицаСклада.Добавить();
	ТЧ.МПЗ = ТЧ_МПЗ.МПЗ;
	ТЧ.Количество = ТЧ_МПЗ.Количество;
	КонецЦикла; 
КонецПроцедуры 

&НаСервере
Процедура ВыбратьПЗНаСервере()
	Для каждого ТЧ Из ТаблицаЗаданий Цикл
	ТЧ.Пометка = Ложь;
		Если ТЧ.ПЗ.ДокументОснование.Статус = 0 Тогда
			Если Не ТЧ.ЛОSMD Тогда
				Если ТЧ.Линия.Пустая() Тогда
					Если ТЧ.Линии.НайтиПоЗначению(ЛинияSMD) <> Неопределено Тогда			
					ТЧ.Пометка = Истина;
					КонецЕсли;
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПЗ(Команда)
ВыбратьПЗНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗаданийПометкаПриИзменении(Элемент)
	Если Элементы.ТаблицаЗаданий.ТекущиеДанные.Пометка Тогда
		Если ЗначениеЗаполнено(Элементы.ТаблицаЗаданий.ТекущиеДанные.ДатаНачала) Тогда
		Элементы.ТаблицаЗаданий.ТекущиеДанные.Пометка = Ложь;
		ИначеЕсли Элементы.ТаблицаЗаданий.ТекущиеДанные.Линии.НайтиПоЗначению(ЛинияSMD) = Неопределено Тогда
		Элементы.ТаблицаЗаданий.ТекущиеДанные.Пометка = Ложь;
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВОжиданииПриИзменении(Элемент)
ПроверитьТаблицуЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРаспределенныеПриИзменении(Элемент)
ПроверитьТаблицуЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВРаботеПриИзменении(Элемент)
ПроверитьТаблицуЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура НеПоказыватьЛОSMDПриИзменении(Элемент)
ПроверитьТаблицуЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура ЛинияSMDПриИзменении(Элемент)
	Если ПоказатьВсе и ЛинияSMD.Пустая() и СортироватьПо = 1 Тогда
	Элементы.ПолучитьЗадания.Доступность = Истина;
	Иначе
	Элементы.ПолучитьЗадания.Доступность = Ложь; 
	КонецЕсли;
ПроверитьТаблицуЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьНомерОчереди(Команда)
НО = Элементы.ТаблицаЗаданий.ТекущиеДанные.НомерОчереди;
	Если ВвестиЧисло(НО,"Введите номер очереди",6,0) Тогда
		Если УстановитьНомерОчередиПЗ(Элементы.ТаблицаЗаданий.ТекущиеДанные.ПЗ,НО) Тогда
		Элементы.ТаблицаЗаданий.ТекущиеДанные.НомерОчереди = НО;
		Элементы.ТаблицаЗаданий.ТекущиеДанные.Приоритет = ?(НО > 0,Истина,Ложь);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоПриИзменении(Элемент)
	Если СортироватьПо = 1 Тогда
	ТаблицаЗаданий.Сортировать("ЛОПриборов Убыв,ДатаЛО,ДатаПЗ");
	ИначеЕсли СортироватьПо = 2 Тогда
	ТаблицаЗаданий.Сортировать("Приоритет Убыв,НомерОчереди,ЛОПриборов Убыв,ДатаЛО,ДатаПЗ");		
	Иначе
	ТаблицаЗаданий.Сортировать("Спецификация,ЛОПриборов Убыв,ДатаЛО,ДатаПЗ");			
	КонецЕсли;
		Если ПоказатьВсе и ЛинияSMD.Пустая() и СортироватьПо = 1 Тогда
		Элементы.ПолучитьЗадания.Доступность = Истина;
		Иначе
		Элементы.ПолучитьЗадания.Доступность = Ложь; 
		КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПереназначитьЛинию(Команда)
	Если ЗначениеЗаполнено(Элементы.ТаблицаЗаданий.ТекущиеДанные.ДатаНачала) Тогда
	Сообщить("Производственное задание взято в работу!");
	Возврат;
	КонецЕсли;  
ВыбЛинияSMD = Элементы.ТаблицаЗаданий.ТекущиеДанные.Линия;
ВыбЛинияSMD = Элементы.ТаблицаЗаданий.ТекущиеДанные.Линии.ВыбратьЭлемент("Выберите новую линию SMD",ВыбЛинияSMD);
	Если ВыбЛинияSMD <> Неопределено Тогда
	НазначитьЛиниюНаСервере(Элементы.ТаблицаЗаданий.ТекущиеДанные.ПЗ,ВыбЛинияSMD.Значение);
	Элементы.ТаблицаЗаданий.ТекущиеДанные.Линия = ВыбЛинияSMD.Значение;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
КонецПроцедуры
