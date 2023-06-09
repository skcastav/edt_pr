
&НаСервере
Процедура ПолучитьДанныеПоСтендуНаСервере()
Объект.Стенд.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаНачала,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.Изделие,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.БарКод,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.Ремонт,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто В(&СписокРабочихМестСтенд)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Статус <> 2
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.НомерОчереди";
Запрос.УстановитьПараметр("СписокРабочихМестСтенд",СписокРабочихМестСтенд);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если Не ВыборкаДетальныеЗаписи.Ремонт Тогда
		ДПН = Справочники.ДополнительныеПараметрыНоменклатуры.Выбрать(,ВыборкаДетальныеЗаписи.Изделие);
		СТ_ПР = 0;
			Пока ДПН.Следующий() Цикл
			СТ_ПР = ДПН.СТ_ПР;
			КонецЦикла; 
		ЗапросСП = Новый Запрос;
		ЗапросСП.Текст = 
			"ВЫБРАТЬ
			|	СтендовыйПрогонСрезПоследних.ДатаПоступления,
			|	СтендовыйПрогонСрезПоследних.ДатаПостановки,
			|	СтендовыйПрогонСрезПоследних.Прогон,
			|	СтендовыйПрогонСрезПоследних.Стенд
			|ИЗ
			|	РегистрСведений.СтендовыйПрогон.СрезПоследних КАК СтендовыйПрогонСрезПоследних
			|ГДЕ
			|	СтендовыйПрогонСрезПоследних.ПЗ = &ПЗ
			|	И СтендовыйПрогонСрезПоследних.ДатаСнятия = ДАТАВРЕМЯ(1,1,1,0,0,0)";		
		ЗапросСП.УстановитьПараметр("ПЗ", ВыборкаДетальныеЗаписи.ПЗ);	
		РезультатЗапросаСП = ЗапросСП.Выполнить();	
		ВыборкаДетальныеЗаписиСП = РезультатЗапросаСП.Выбрать();	
			Пока ВыборкаДетальныеЗаписиСП.Следующий() Цикл
			ТЧ = Объект.Стенд.Добавить();
			ТЧ.ПроизводственноеЗадание = ВыборкаДетальныеЗаписи.ПЗ;
			ТЧ.РабочееМесто = ВыборкаДетальныеЗаписи.РабочееМесто;
			ТЧ.БарКод = ВыборкаДетальныеЗаписи.БарКод;
			БК = РегистрыСведений.БарКоды.ПолучитьПоследнее(,Новый Структура("ПЗ",ВыборкаДетальныеЗаписи.ПЗ));
			ТЧ.КодDanfoss = БК.КодDanfoss;	
			ТЧ.Ремонт = ВыборкаДетальныеЗаписи.Ремонт;
			ТЧ.Стенд = ВыборкаДетальныеЗаписиСП.Стенд;
			ТЧ.Прогон = ВыборкаДетальныеЗаписиСП.Прогон;
			ТЧ.Поступление = ВыборкаДетальныеЗаписиСП.ДатаПоступления;
			ТЧ.Постановка = ВыборкаДетальныеЗаписиСП.ДатаПостановки;
				Если ВыборкаДетальныеЗаписиСП.Прогон > 1 Тогда
				СТ_ПР = 1440;
				КонецЕсли; 
			ТЧ.Снятие = ВыборкаДетальныеЗаписиСП.ДатаПостановки+СТ_ПР*60;
			Напряжение = РегистрыСведений.НапряжениеБатарейки.ПолучитьПоследнее(,Новый Структура("ПЗ",ВыборкаДетальныеЗаписи.ПЗ));
			ТЧ.Напряжение = Напряжение.НапряжениеНаСтенде; 				
			КонецЦикла;	
		Иначе
		ТЧ = Объект.Стенд.Добавить();
		ТЧ.ПроизводственноеЗадание = ВыборкаДетальныеЗаписи.ПЗ;
		ТЧ.РабочееМесто = ВыборкаДетальныеЗаписи.РабочееМесто;
		ТЧ.БарКод = ВыборкаДетальныеЗаписи.БарКод;
		БК = РегистрыСведений.БарКоды.ПолучитьПоследнее(,Новый Структура("ПЗ",ВыборкаДетальныеЗаписи.ПЗ));
		ТЧ.КодDanfoss = БК.КодDanfoss;
		ТЧ.Ремонт = ВыборкаДетальныеЗаписи.Ремонт;
		КонецЕсли; 
	КонецЦикла;
ТекДата = ТекущаяДата();
	Если флСортировка = 1 Тогда
	Объект.Стенд.Сортировать("Поступление");
	ИначеЕсли флСортировка = 2 Тогда
	Объект.Стенд.Сортировать("Снятие");
	Иначе
	Объект.Стенд.Сортировать("ПроизводственноеЗадание");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеПоСтенду()
ПолучитьДанныеПоСтендуНаСервере();
КонецПроцедуры
 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.Исполнитель = ПараметрыСеанса.Пользователь;
	Если Объект.Исполнитель.Пустая() Тогда
	Элементы.СписокЛинеек.Доступность = Ложь;
	Сообщить("Вы не внесены в справочник Сотрудников! Работа невозможна!");
	КонецЕсли; 
флСортировка = 1;
КонецПроцедуры

&НаСервере
Процедура ОчиститьПЗНаСервере()
Объект.ПроизводственноеЗадание = Документы.ПроизводственноеЗадание.ПустаяСсылка();
КонецПроцедуры 

&НаСервере
Функция ПолучитьРМ()
Объект.РабочееМесто = Справочники.РабочиеМестаЛинеек.ПустаяСсылка();
СписокРабочихМестСтенд.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РабочиеМестаЛинеек.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.РабочиеМестаЛинеек КАК РабочиеМестаЛинеек
	|ГДЕ
	|	РабочиеМестаЛинеек.Линейка В ИЕРАРХИИ(&СписокЛинеек)
	|	И РабочиеМестаЛинеек.ГруппаРабочихМест.Префикс = &Префикс";
Запрос.УстановитьПараметр("СписокЛинеек", СписокЛинеек);
Запрос.УстановитьПараметр("Префикс", "СТ");
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	СписокРабочихМестСтенд.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
		Если СписокРабочихМестСтенд.Количество() > 0 Тогда
			Если СписокРабочихМестСтенд[0].Значение.Стенд.СБуфером Тогда
			Элементы.ЗавершитьЗадание.Видимость = Истина;
			КонецЕсли;
		Возврат(Истина);
		Иначе
		Сообщить("Не найдено ни одного рабочего места!");
		Возврат(Ложь);
		КонецЕсли;
КонецФункции 

&НаСервере
Функция МожноРаботатьВАРМ()
	Если ОбщийМодульВызовСервера.МожноВыполнить(СписокРабочихМестСтенд[0].Значение.Линейка) Тогда	
	Возврат(Истина);
	Иначе
	СписокЛинеек.Очистить();
	СписокРабочихМестСтенд.Очистить();
	Сообщить("Работа АРМ запрещена в этой базе!");
	Возврат(Ложь);
	КонецЕсли;
КонецФункции 

&НаКлиенте
Процедура СписокЛинеекПриИзменении(Элемент)
Элементы.ЗавершитьЗадание.Видимость = Ложь;
	Если ПолучитьРМ() Тогда
		Если Не МожноРаботатьВАРМ() Тогда
		Возврат;
		КонецЕсли;
	ПолучитьДанныеПоСтендуНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьЗадания(Команда)
ПолучитьДанныеПоСтендуНаСервере();
	Если Объект.ИнтервалОбновления > 0 Тогда
	ПодключитьОбработчикОжидания("ПолучитьДанныеПоСтенду", Объект.ИнтервалОбновления*60);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалОбновленияПриИзменении(Элемент)
ОтключитьОбработчикОжидания("ПолучитьДанныеПоСтенду");
	Если Объект.ИнтервалОбновления > 0 Тогда
	ПодключитьОбработчикОжидания("ПолучитьДанныеПоСтенду", Объект.ИнтервалОбновления*60);
	КонецЕсли;  
КонецПроцедуры

&НаСервере
Функция ПолучитьИзделиеРемонта(РабочееМесто)
	Для каждого ТЧ_Этап Из Этапы Цикл
	ЭтапАРМ = РабочееМесто.ТабличнаяЧасть.Найти(ТЧ_Этап.ГруппаНоменклатуры,"ГруппаНоменклатуры");
		Если ЭтапАРМ = Неопределено Тогда
		Продолжить;
		ИначеЕсли ЭтапАРМ.Комплектация Тогда
	    Продолжить;
		КонецЕсли;
			Если ТЧ_Этап.ЭтапСпецификации.Виртуальный Тогда
			Продолжить;
			КонецЕсли;
	Возврат(Новый Структура("Изделие,Количество",ТЧ_Этап.ЭтапСпецификации,ТЧ_Этап.Количество));
	КонецЦикла;
КонецФункции

&НаСервере
Процедура ОтправкаВРемонтНаСервере(Стр,ПричиныРемонта)
ТЧ = Объект.Стенд.НайтиПоИдентификатору(Стр);
Этапы.Очистить();
ОбщийМодульВызовСервера.ПолучитьТаблицуЭтаповСпецификации(Этапы,ТЧ.ПроизводственноеЗадание.Изделие,1,Ложь,ТЧ.ПроизводственноеЗадание.ДатаЗапуска);
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
		Если Не ОбщийМодульСозданиеДокументов.СоздатьРемонтнуюКарту(ТЧ.ПроизводственноеЗадание,ТЧ.РабочееМесто,ПолучитьИзделиеРемонта(ТЧ.РабочееМесто),Объект.Исполнитель,Перечисления.ВидыРемонта.Общий,ПричиныРемонта) Тогда
		Сообщить("Ремонтная карта не создана!");
		ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
		Возврат;
		КонецЕсли;	
	ОбщийМодульРаботаСРегистрами.ИзменитьЭтапПроизводственногоЗадания(ТЧ.ПроизводственноеЗадание,Новый Структура("РабочееМесто,Ремонт",ТЧ.РабочееМесто,Истина));
	НаборЗаписей = РегистрыСведений.ЭтапыПроизводственныхЗаданий.СоздатьНаборЗаписей();
	НаборЗаписей = РегистрыСведений.СтендовыйПрогон.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПЗ.Установить(ТЧ.ПроизводственноеЗадание);
	НаборЗаписей.Прочитать();
	    Для Каждого Запись Из НаборЗаписей Цикл 
			Если Запись.Прогон = ТЧ.Прогон Тогда
			Запись.ИсполнительСнятие = Объект.Исполнитель;
			Запись.ДатаСнятия = ТекущаяДата();
			Запись.Ремонт = Истина;
			Прервать; 			
			КонецЕсли; 
	    КонецЦикла;
	НаборЗаписей.Записать();
	ТЧ.Ремонт = Истина;
	ТЧ.Поступление = Дата(1,1,1);
	ТЧ.Постановка = Дата(1,1,1);
	ТЧ.Снятие = Дата(1,1,1);
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;	
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	КонецПопытки;
КонецПроцедуры

&НаСервере
Функция ПолучитьТекущееРабочееМесто(Стр)
ТЧ = Объект.Стенд.НайтиПоИдентификатору(Стр);
Возврат(ТЧ.РабочееМесто);
КонецФункции

&НаКлиенте
Процедура ОтправкаВРемонт(Команда,БарКод = "")
	Если Не ЗначениеЗаполнено(БарКод) Тогда
		Если Не ВвестиСтроку(БарКод,"Введите бар-код",18) Тогда
		Возврат;
		КонецЕсли; 
	КонецЕсли;
ОтключитьОбработчикОжидания("ПолучитьДанныеПоСтенду");
	Если СтрДлина(СокрЛП(БарКод)) > 16 Тогда
	Отбор = Новый Структура("БарКод",БарКод); 		
	Иначе
	Отбор = Новый Структура("КодDanfoss",БарКод);
	КонецЕсли; 
Выборка = Объект.Стенд.НайтиСтроки(Отбор);
	Если Выборка.Количество() > 0 Тогда	
	Стр = Выборка[0].ПолучитьИдентификатор();
		Если Не Выборка[0].Ремонт Тогда
		Результат = ОткрытьФормуМодально("ОбщаяФорма.ВыборПричинРемонта",Новый Структура("РабочееМесто",ПолучитьТекущееРабочееМесто(Стр)));
			Если Результат <> Неопределено Тогда
			ОтправкаВРемонтНаСервере(Стр,Результат);	
			КонецЕсли;	
		Иначе
		Сообщить("Изделие уже находится в ремонте!");
		КонецЕсли; 
	Иначе
	Сообщить("Бар-код не найден!");
	КонецЕсли; 
		Если Объект.ИнтервалОбновления > 0 Тогда
		ПодключитьОбработчикОжидания("ПолучитьДанныеПоСтенду", Объект.ИнтервалОбновления*60);
		КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НайтиПоБарКоду(Команда)
БарКод = "";
	Если ВвестиСтроку(БарКод,"Введите бар-код",18) Тогда
		Если СтрДлина(СокрЛП(БарКод)) > 16 Тогда
		Отбор = Новый Структура("БарКод",БарКод);		
		Иначе
		Отбор = Новый Структура("КодDanfoss",БарКод);
		КонецЕсли; 
	Выборка = Объект.Стенд.НайтиСтроки(Отбор);
		Если Выборка.Количество() > 0 Тогда	
		Элементы.Стенд.ТекущаяСтрока = Выборка[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВсёОРемонте(Команда)
П = Новый Структура("ПЗ",Объект.Стенд.НайтиПоИдентификатору(Элементы.Стенд.ТекущаяСтрока).ПроизводственноеЗадание);
ОткрытьФорму("Отчет.ОтчетПоРемонту.Форма.ФормаОтчета",П);
КонецПроцедуры

&НаКлиенте
Процедура флСортировкаПриИзменении(Элемент)
флСортировкаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура флСортировкаПриИзмененииНаСервере()
	Если флСортировка = 1 Тогда
	Объект.Стенд.Сортировать("Поступление");
	ИначеЕсли флСортировка = 2 Тогда
	Объект.Стенд.Сортировать("Снятие");
	Иначе
	Объект.Стенд.Сортировать("ПроизводственноеЗадание");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
ПолучитьДанныеПоСтендуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если ЭтаФорма.ВводДоступен() Тогда
	СписокДействий = Новый СписокЗначений;

		Если Элементы.ЗавершитьЗадание.Видимость Тогда 
		СписокДействий.Добавить(5,"Завершить и передать на другое АРМ");
		КонецЕсли; 
	СписокДействий.Добавить(1,"Отправить в ремонт");
	СписокДействий.Добавить(4,"Выпустить на склад");
	СписокДействий.Добавить(2,"Перепрогон");
	СписокДействий.Добавить(3,"Ввести напряжение батарейки"); 
	Действие = 1;
	Действие = СписокДействий.ВыбратьЭлемент("Выберите действие",Действие);
		Если Действие.Значение = 1 Тогда
		ОтправкаВРемонт(Неопределено,СокрЛП(Данные));
		ИначеЕсли Действие.Значение = 2 Тогда
	 	Перепрогон(Неопределено,СокрЛП(Данные));
		ИначеЕсли Действие.Значение = 3 Тогда
		ВвестиНапряжениеБатарейки(Неопределено,СокрЛП(Данные));
		ИначеЕсли Действие.Значение = 4 Тогда
		ВыпускПродукции(Неопределено,СокрЛП(Данные));
		ИначеЕсли Действие.Значение = 5 Тогда
		ЗавершитьЗадание(Неопределено,СокрЛП(Данные));
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура РаскрытьНаПО(ПЗ,Спецификация,СписокПО)
НР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_Д(Спецификация,ПЗ.ДатаЗапуска);
	Пока НР.Следующий() Цикл	
		Если ТипЗнч(НР.Элемент) = Тип("СправочникСсылка.Номенклатура") Тогда
        РаскрытьНаПО(ПЗ,НР.Элемент,СписокПО);
		Иначе
			Если НР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Программа Тогда
				Если СписокПО.НайтиПоЗначению(НР.Элемент) = Неопределено Тогда
				СписокПО.Добавить(НР.Элемент);
				КонецЕсли; 
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СтендИзделиеОткрытие(Элемент, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
ПолучитьСписокПО(Неопределено);
КонецПроцедуры

&НаСервере
Функция ПолучитьИзделие(ПЗ)
Возврат(ПЗ.Изделие);
КонецФункции 

&НаКлиенте
Процедура ПолучитьСписокПО(Команда)
СписокПО = Новый СписокЗначений();
РаскрытьНаПО(Элементы.Стенд.ТекущиеДанные.ПроизводственноеЗадание,ПолучитьИзделие(Элементы.Стенд.ТекущиеДанные.ПроизводственноеЗадание),СписокПО);
СписокПО.СортироватьПоЗначению();
СписокПО.ВыбратьЭлемент("Список программного обеспечения");
КонецПроцедуры

&НаСервере
Процедура ПерепрогонНаСервере(Стр)
ТЧ = Объект.Стенд.НайтиПоИдентификатору(Стр);
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	НаборЗаписей = РегистрыСведений.СтендовыйПрогон.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПЗ.Установить(ТЧ.ПроизводственноеЗадание);
	НаборЗаписей.Отбор.БарКод.Установить(ТЧ.БарКод);
	НаборЗаписей.Отбор.Стенд.Установить(ТЧ.Стенд);
	НаборЗаписей.Отбор.Изделие.Установить(ТЧ.ПроизводственноеЗадание.Изделие);
	НаборЗаписей.Прочитать();
	    Для Каждого Запись Из НаборЗаписей Цикл 
			Если Запись.Прогон = ТЧ.Прогон Тогда
			Запись.ИсполнительСнятие = Объект.Исполнитель;
			Запись.ДатаСнятия = ТекущаяДата();
			Прогон = ТЧ.Прогон; 
			Прервать; 			
			КонецЕсли; 
	    КонецЦикла;
	НаборЗаписей.Записать();
	СП = РегистрыСведений.СтендовыйПрогон.СоздатьМенеджерЗаписи();
	СП.Период = ТекущаяДата();
	СП.ПЗ = ТЧ.ПроизводственноеЗадание;
	СП.Изделие = ТЧ.ПроизводственноеЗадание.Изделие;
	СП.БарКод = ТЧ.БарКод;
	СП.Стенд = ТЧ.Стенд;
	СП.Прогон = Прогон + 1;
	СП.ИсполнительПоступление = Объект.Исполнитель;
	СП.ДатаПоступления = ТекущаяДата();
	СП.ИсполнительПостановка = Объект.Исполнитель;
	СП.ДатаПостановки = ТекущаяДата();
	СП.Записать();
	ТЧ.Поступление = ТекущаяДата();
	ТЧ.Постановка = ТекущаяДата();
	ТЧ.Прогон = Прогон + 1;
	ДПН = Справочники.ДополнительныеПараметрыНоменклатуры.Выбрать(,ТЧ.ПроизводственноеЗадание.Изделие);
	СТ_ПР = 0;
		Пока ДПН.Следующий() Цикл
		СТ_ПР = ДПН.СТ_ПР;
		КонецЦикла;
	ТЧ.Снятие = ТЧ.Постановка+СТ_ПР*60;
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;	
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	КонецПопытки;
КонецПроцедуры
 
&НаКлиенте
Процедура Перепрогон(Команда,БарКод = "")
	Если Не ЗначениеЗаполнено(БарКод) Тогда
		Если Не ВвестиСтроку(БарКод,"Введите бар-код",18) Тогда
		Возврат;
		КонецЕсли; 
	КонецЕсли;
ОтключитьОбработчикОжидания("ПолучитьДанныеПоСтенду");
	Если СтрДлина(СокрЛП(БарКод)) > 16 Тогда
	Отбор = Новый Структура("БарКод",БарКод);		
	Иначе
	Отбор = Новый Структура("КодDanfoss",БарКод);
	КонецЕсли; 
Выборка = Объект.Стенд.НайтиСтроки(Отбор);
	Если Выборка.Количество() > 0 Тогда	
		Если Не Выборка[0].Ремонт Тогда
		ПерепрогонНаСервере(Выборка[0].ПолучитьИдентификатор());
		Иначе
		Сообщить("Изделие находится в ремонте!");
		КонецЕсли; 	
	Иначе
	Сообщить("Бар-код не найден!");
	КонецЕсли;
		Если Объект.ИнтервалОбновления > 0 Тогда
		ПодключитьОбработчикОжидания("ПолучитьДанныеПоСтенду", Объект.ИнтервалОбновления*60);
		КонецЕсли;	 	
КонецПроцедуры

&НаСервере
Процедура СохранитьНапряжениеБатарейки(Стр,Напряжение)	
ТЧ = Объект.Стенд.НайтиПоИдентификатору(Стр);
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;		
	НапряжениеБаратейки = РегистрыСведений.НапряжениеБатарейки.СоздатьМенеджерЗаписи();
	НапряжениеБаратейки.Период = ТекущаяДата();
	НапряжениеБаратейки.ПЗ = ТЧ.ПроизводственноеЗадание;
	НапряжениеБаратейки.НапряжениеНаСтенде = Напряжение;
	НапряжениеБаратейки.Записать();
	ТЧ.Напряжение = Напряжение;
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	КонецПопытки;
КонецПроцедуры 

&НаКлиенте
Процедура ВвестиНапряжениеБатарейки(Команда,БарКод = "")
	Если Не ЗначениеЗаполнено(БарКод) Тогда
		Если Не ВвестиСтроку(БарКод,"Введите бар-код",18) Тогда
		Возврат;
		КонецЕсли; 
	КонецЕсли;
ОтключитьОбработчикОжидания("ПолучитьДанныеПоСтенду");
	Если СтрДлина(СокрЛП(БарКод)) > 16 Тогда
	Отбор = Новый Структура("БарКод",БарКод);		
	Иначе
	Отбор = Новый Структура("КодDanfoss",БарКод);
	КонецЕсли; 
Выборка = Объект.Стенд.НайтиСтроки(Отбор);
	Если Выборка.Количество() > 0 Тогда
		Если Не Выборка[0].Ремонт Тогда
		Напряжение = 0;
			Если ВвестиЧисло(Напряжение,"Введите напряжение батарейки",3,2) Тогда
				Если Напряжение > 0 Тогда
				СохранитьНапряжениеБатарейки(Выборка[0].ПолучитьИдентификатор(),Напряжение);
				Иначе	
				Сообщить("Введите напряжение батарейки отличное от нуля!");
				КонецЕсли; 
			Иначе
			Сообщить("Введите напряжение батарейки отличное от нуля!");
			КонецЕсли; 
		Иначе
		Сообщить("Изделие находится в ремонте!");
		КонецЕсли; 	
	Иначе
	Сообщить("Бар-код не найден!");
	КонецЕсли;
		Если Объект.ИнтервалОбновления > 0 Тогда
		ПодключитьОбработчикОжидания("ПолучитьДанныеПоСтенду", Объект.ИнтервалОбновления*60);
		КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПолучитьСерийныйНомерEnLogicНаСервере()
ТЧ = Объект.Стенд.НайтиПоИдентификатору(Элементы.Стенд.ТекущаяСтрока);
	Если ТЧ.ПроизводственноеЗадание.Изделие.Товар.ТребуетсяСерийныйНомерEnLogic Тогда
		Попытка
		НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1; 
		НаборЗаписей = РегистрыСведений.БарКоды.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ПЗ.Установить(ТЧ.ПроизводственноеЗадание);
		НаборЗаписей.Прочитать();
		    Для Каждого Запись Из НаборЗаписей Цикл
				Если Не ЗначениеЗаполнено(Запись.СерийныйНомерEnLogic) Тогда
				СерийныйНомерEnLogic = "";
				Выборка = Справочники.СерийныеНомераEnLogic.Выбрать();
					Пока Выборка.Следующий() Цикл
					СерийныйНомерEnLogic = Выборка.Код;
					Прервать;
					КонецЦикла; 
						Если ЗначениеЗаполнено(СерийныйНомерEnLogic) Тогда
						Запись.СерийныйНомерEnLogic = СерийныйНомерEnLogic;						
						Иначе
						Сообщить("Нет свободных серийных номеров EnLogic!");
						ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
						Возврат;						
						КонецЕсли;  
				Иначе
				СерийныйНомерEnLogic = Запись.СерийныйНомерEnLogic;
				КонецЕсли;  
		    КонецЦикла;
		НаборЗаписей.Записать(Истина);
		КодEnLogic = Справочники.СерийныеНомераEnLogic.НайтиПоКоду(СерийныйНомерEnLogic);
			Если Не КодEnLogic.Пустая() Тогда
			ЭлементУдаления = КодEnLogic.ПолучитьОбъект();
			ЭлементУдаления.Удалить();
			КонецЕсли; 
		ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
		Сообщить(Лев(СерийныйНомерEnLogic,16));
		Сообщить(Сред(СерийныйНомерEnLogic,17));
		Исключение
		Сообщить(ОписаниеОшибки());
		ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
		КонецПопытки;		
	Иначе
	Сообщить("Изделию не требуется серийный номер EnLogic!");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСерийныйНомерEnLogic(Команда)
ПолучитьСерийныйНомерEnLogicНаСервере();
КонецПроцедуры

&НаСервере
Функция МожноВыпуститьНаСтенде(Стр)
ТЧ = Объект.Стенд.НайтиПоИдентификатору(Стр);
	Если Найти(ТЧ.ПроизводственноеЗадание.Изделие,"(СТ-") > 0 Тогда
	Возврат(Истина);
	Иначе
	Возврат(Ложь);		
	КонецЕсли; 
КонецФункции

&НаСервере
Процедура ПолучитьЭтапыСпецификации(ПЗ,РабочееМесто)
Этапы.Очистить();
Объект.Спецификация.Очистить();
ОбщийМодульВызовСервера.ПолучитьТаблицуЭтаповСпецификации(Этапы,ПЗ.Изделие,1,Ложь,ПЗ.ДатаЗапуска);
	Для каждого ТЧ Из Этапы Цикл
		Если РабочееМесто.ТабличнаяЧасть.Найти(ТЧ.ГруппаНоменклатуры,"ГруппаНоменклатуры") = Неопределено Тогда
		Продолжить;
		КонецЕсли;
	ОбщийМодульВызовСервера.ПолучитьСпецификациюСАналогами(Объект.Спецификация,ПЗ,ТЧ.ЭтапСпецификации,ТЧ.ЭтапСпецификации,ТЧ.Количество);	
	КонецЦикла;
Объект.Спецификация.Сортировать("ЭтапСпецификации,ВидМПЗ,Позиция,МПЗ");
КонецПроцедуры

&НаСервере
Процедура ВыпускПродукцииНаСервере(Стр)
ТЧ = Объект.Стенд.НайтиПоИдентификатору(Стр);
	Попытка
	ДатаОкончания = ТекущаяДата();
	НаборЗаписей = РегистрыСведений.СтендовыйПрогон.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПЗ.Установить(ТЧ.ПроизводственноеЗадание);
	НаборЗаписей.Отбор.БарКод.Установить(ТЧ.БарКод);
	НаборЗаписей.Отбор.Изделие.Установить(ТЧ.ПроизводственноеЗадание.Изделие);
	НаборЗаписей.Прочитать();
	    Для Каждого Запись Из НаборЗаписей Цикл
			Если Не ЗначениеЗаполнено(Запись.ДатаСнятия) Тогда
			Запись.ИсполнительСнятие = Объект.Исполнитель;
			Запись.ДатаСнятия = ДатаОкончания;
			Прервать; 
			КонецЕсли;  
	    КонецЦикла;
	НаборЗаписей.Записать();
	
	Парам = Новый Структура("РабочееМесто,Исполнитель,ДатаОкончания",ТЧ.РабочееМесто,Объект.Исполнитель,ДатаОкончания);
	ОбщийМодульРаботаСРегистрами.ИзменитьЭтапПроизводственногоЗадания(ТЧ.ПроизводственноеЗадание,Парам);
	ПолучитьЭтапыСпецификации(ТЧ.ПроизводственноеЗадание,ТЧ.РабочееМесто);
		Если Не ОбщийМодульСозданиеДокументов.СоздатьВыпускПродукции(ТЧ.ПроизводственноеЗадание,ТЧ.РабочееМесто,Объект.Спецификация,Этапы,ДатаОкончания) Тогда
		Сообщить("Документ выпуска по производственному заданию "+ТЧ.ПроизводственноеЗадание.Номер+" не создан!");
		ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
		Возврат;
		КонецЕсли;
	Объект.Стенд.Удалить(ТЧ);	
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);	
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ВыпускПродукции(Команда,БарКод = "")
	Если Не ЗначениеЗаполнено(БарКод) Тогда
		Если Не ВвестиСтроку(БарКод,"Введите бар-код",18) Тогда
		Возврат;
		КонецЕсли; 
	КонецЕсли;
ОтключитьОбработчикОжидания("ПолучитьДанныеПоСтенду");
	Если СтрДлина(СокрЛП(БарКод)) > 16 Тогда
	Отбор = Новый Структура("БарКод",БарКод);		
	Иначе
	Отбор = Новый Структура("КодDanfoss",БарКод);
	КонецЕсли; 
Выборка = Объект.Стенд.НайтиСтроки(Отбор);
	Если Выборка.Количество() > 0 Тогда
		Если МожноВыпуститьНаСтенде(Выборка[0].ПолучитьИдентификатор()) Тогда
		ВыпускПродукцииНаСервере(Выборка[0].ПолучитьИдентификатор()); 		
		Иначе
		Сообщить("Изделие не может быть выпущено на склад на этапе стенд!");
		КонецЕсли; 
	Иначе
	Сообщить("Бар-код не найден!");
	КонецЕсли; 
		Если Объект.ИнтервалОбновления > 0 Тогда
		ПодключитьОбработчикОжидания("ПолучитьДанныеПоСтенду", Объект.ИнтервалОбновления*60);
		КонецЕсли;
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
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
КонецПроцедуры

&НаСервере
Функция ЗавершитьЗаданиеНаСервере(Стр)
ТЧ = Объект.Стенд.НайтиПоИдентификатору(Стр);
СледующееРабочееМесто = ОбщийМодульВызовСервера.ПолучитьСледующееРабочееМесто(ТЧ.РабочееМесто);
	Если Не СледующееРабочееМесто.Пустая() Тогда
		Попытка
		НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
		НаборЗаписей = РегистрыСведений.ЭтапыПроизводственныхЗаданий.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ПЗ.Установить(ТЧ.ПроизводственноеЗадание);
		НаборЗаписей.Прочитать();
		    Для Каждого Запись Из НаборЗаписей Цикл 
		    	Если Запись.РабочееМесто = ТЧ.РабочееМесто Тогда
				Запись.ДатаОкончания = ТекущаяДата();
				Прервать;
				КонецЕсли;  
		    КонецЦикла;
		ЭПЗ = НаборЗаписей.Добавить();
		ЭПЗ.Период = ТекущаяДата();
		ЭПЗ.ПЗ = ТЧ.ПроизводственноеЗадание; 
		ЭПЗ.Линейка = ТЧ.ПроизводственноеЗадание.Линейка;
		ЭПЗ.Изделие = ТЧ.ПроизводственноеЗадание.Изделие;
		ЭПЗ.Количество = 1;
		ЭПЗ.БарКод = ТЧ.БарКод;
		ЭПЗ.РабочееМесто = СледующееРабочееМесто;
		НаборЗаписей.Записать();	
		НаборЗаписей = РегистрыСведений.СтендовыйПрогон.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ПЗ.Установить(ТЧ.ПроизводственноеЗадание);
		НаборЗаписей.Прочитать();
		    Для Каждого Запись Из НаборЗаписей Цикл
				Если Не ЗначениеЗаполнено(Запись.ДатаСнятия) Тогда
				Запись.ИсполнительСнятие = ТЧ.РабочееМесто.Стенд.Исполнитель;
				Запись.ДатаСнятия = ТекущаяДата();
				Прервать; 
				КонецЕсли;  
		    КонецЦикла;
		НаборЗаписей.Записать();
			Если ТЧ.РабочееМесто.ГруппаРабочихМест <> СледующееРабочееМесто.ГруппаРабочихМест Тогда
			ПолучитьЭтапыСпецификации(ТЧ.ПроизводственноеЗадание,ТЧ.РабочееМесто);
				Если Не ОбщийМодульСозданиеДокументов.СоздатьВыпускПродукции(ТЧ.ПроизводственноеЗадание,ТЧ.РабочееМесто,Объект.Спецификация,Этапы,ТекущаяДата()) Тогда
				Сообщить("Документ выпуска не создан!");
				ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
				Возврат("");
				КонецЕсли; 		
			КонецЕсли;
		Объект.Стенд.Удалить(ТЧ);
		ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
		Исключение
		Сообщить(ОписаниеОшибки());
		ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
		Возврат(Ложь);
		КонецПопытки;
	Иначе
	Сообщить("Сделующее рабочее место не найдено!");	
	Возврат(Ложь);	
	КонецЕсли; 

Возврат(Истина);
КонецФункции

&НаСервере
Функция ЭтоСтендСБуфером(РабочееМесто)
Возврат(РабочееМесто.Стенд.СБуфером);
КонецФункции

&НаКлиенте
Процедура ЗавершитьЗадание(Команда,БарКод = "")
	Если Не ЗначениеЗаполнено(БарКод) Тогда
		Если Не ВвестиСтроку(БарКод,"Введите бар-код",18) Тогда
		Возврат;
		КонецЕсли; 
	КонецЕсли;
ОтключитьОбработчикОжидания("ПолучитьДанныеПоСтенду");
	Если СтрДлина(СокрЛП(БарКод)) > 16 Тогда
	Отбор = Новый Структура("БарКод",БарКод);		
	Иначе
	Отбор = Новый Структура("КодDanfoss",БарКод);
	КонецЕсли; 
Выборка = Объект.Стенд.НайтиСтроки(Отбор);
	Если Выборка.Количество() > 0 Тогда	
		Если Не Выборка[0].Ремонт Тогда
			Если ЭтоСтендСБуфером(Элементы.Стенд.ТекущиеДанные.РабочееМесто) Тогда
			ЗавершитьЗаданиеНаСервере(Выборка[0].ПолучитьИдентификатор());
			Иначе
			Сообщить("Выбранное производственное задание закрывается Упаковщиком!");
			КонецЕсли; 
		Иначе
		Сообщить("Изделие находится в ремонте!");
		КонецЕсли; 	
	Иначе
	Сообщить("Бар-код не найден!");
	КонецЕсли;
		Если Объект.ИнтервалОбновления > 0 Тогда
		ПодключитьОбработчикОжидания("ПолучитьДанныеПоСтенду", Объект.ИнтервалОбновления*60);
		КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьСпецификации(Команда)
ОткрытьФорму("Отчет.ПечатьСпецификации.Форма.ФормаОтчета",Новый Структура("ПЗ",Элементы.Стенд.ТекущиеДанные.ПроизводственноеЗадание));
КонецПроцедуры
