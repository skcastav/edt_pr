
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
	Если Не Объект.РабочееМесто.Пустая() Тогда
		Если Не МожноРаботатьВАРМ() Тогда
		Возврат;
		КонецЕсли;
	ПолучитьДанныеПоСтендуНаСервере();
		Если Объект.ИнтервалОбновления > 0 Тогда
		ПодключитьОбработчикОжидания("ПолучитьДанныеПоСтенду", Объект.ИнтервалОбновления*60);
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция МожноРаботатьВАРМ()
	Если ОбщийМодульВызовСервера.МожноВыполнить(Объект.РабочееМесто.Линейка) Тогда	
	Возврат(Истина);
	Иначе
	Объект.РабочееМесто = Справочники.РабочиеМестаЛинеек.ПустаяСсылка();
	Сообщить("Работа АРМ запрещена в этой базе!");
	Возврат(Ложь);
	КонецЕсли;
КонецФункции 

&НаКлиенте
Процедура РабочееМестоПриИзменении(Элемент)
	Если Не МожноРаботатьВАРМ() Тогда
	Возврат;
	КонецЕсли;
ОчиститьСсылкуНаПЗ();
ПолучитьДанныеПоСтендуНаСервере();
	Если Объект.ИнтервалОбновления > 0 Тогда
	ПодключитьОбработчикОжидания("ПолучитьДанныеПоСтенду", Объект.ИнтервалОбновления*60);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОчиститьСсылкуНаПЗ()
Объект.ПроизводственноеЗадание = Документы.ПроизводственноеЗадание.ПустаяСсылка();
Этапы.Очистить();
ЭтапыАРМ.Очистить();
Объект.Спецификация.Очистить();
Элементы.ПростойЛинейки.Доступность = Истина;
КонецПроцедуры 

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
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.Ремонт
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто = &РабочееМесто
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1,1,1,0,0,0)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Статус <> 2
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.НомерОчереди";
Запрос.УстановитьПараметр("РабочееМесто",Объект.РабочееМесто);
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
			ТЧ.Линейка = ВыборкаДетальныеЗаписи.ПЗ.Линейка;
			ТЧ.ПроизводственноеЗадание = ВыборкаДетальныеЗаписи.ПЗ;
			ТЧ.Изделие = ВыборкаДетальныеЗаписи.Изделие;
			ТЧ.БарКод = ВыборкаДетальныеЗаписи.БарКод;	
			ТЧ.Ремонт = ВыборкаДетальныеЗаписи.Ремонт;
			ТЧ.Стенд = ВыборкаДетальныеЗаписиСП.Стенд;
			ТЧ.Прогон = ВыборкаДетальныеЗаписиСП.Прогон;
			ТЧ.Поступление = ВыборкаДетальныеЗаписиСП.ДатаПоступления;
			ТЧ.Постановка = ВыборкаДетальныеЗаписиСП.ДатаПостановки;
				Если ВыборкаДетальныеЗаписиСП.Прогон > 1 Тогда
				СТ_ПР = 1440;
				КонецЕсли; 
			ТЧ.Снятие = ВыборкаДетальныеЗаписиСП.ДатаПостановки+СТ_ПР*60;				
			КонецЦикла;	
		Иначе
		ТЧ = Объект.Стенд.Добавить();
		ТЧ.Линейка = ВыборкаДетальныеЗаписи.ПЗ.Линейка;
		ТЧ.ПроизводственноеЗадание = ВыборкаДетальныеЗаписи.ПЗ;
		ТЧ.Изделие = ВыборкаДетальныеЗаписи.Изделие;
		ТЧ.БарКод = ВыборкаДетальныеЗаписи.БарКод;	
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
	Сообщить("Вы не внесены в справочник Сотрудников! Работа невозможна!");
	КонецЕсли; 
флСортировка = 1;
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалОбновленияПриИзменении(Элемент)
ОтключитьОбработчикОжидания("ПолучитьДанныеПоСтенду");
	Если Объект.ИнтервалОбновления > 0 Тогда
	ПодключитьОбработчикОжидания("ПолучитьДанныеПоСтенду", Объект.ИнтервалОбновления*60);
	КонецЕсли;  
КонецПроцедуры

&НаСервере
Функция ПолучитьВидРемонтаОбщий()
Возврат(Перечисления.ВидыРемонта.Общий);
КонецФункции

&НаСервере
Функция ПолучитьИзделиеРемонта()
	Для каждого ТЧ_Этап Из Этапы Цикл
	ЭтапАРМ = Объект.РабочееМесто.ТабличнаяЧасть.Найти(ТЧ_Этап.ГруппаНоменклатуры,"ГруппаНоменклатуры");
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

&НаКлиенте
Процедура ОтправкаВРемонт(Команда)
ОтключитьОбработчикОжидания("ПолучитьДанныеПоСтенду");
Результат = ОткрытьФормуМодально("ОбщаяФорма.ВыборПричинРемонта",Новый Структура("РабочееМесто",Объект.РабочееМесто));
	Если Результат <> Неопределено Тогда
		Если ОбщийМодульСозданиеДокументов.СоздатьРемонтнуюКарту(Объект.ПроизводственноеЗадание,Объект.РабочееМесто,ПолучитьИзделиеРемонта(),Объект.Исполнитель,ПолучитьВидРемонтаОбщий(),Результат) Тогда
		ОчиститьСсылкуНаПЗ();
		ПолучитьДанныеПоСтендуНаСервере();
		КонецЕсли;
	КонецЕсли;
		Если Объект.ИнтервалОбновления > 0 Тогда
		ПодключитьОбработчикОжидания("ПолучитьДанныеПоСтенду", Объект.ИнтервалОбновления*60);
		КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НайтиПоБарКоду(Команда)
БарКод = "";
	Если ВвестиСтроку(БарКод,"Введите бар-код",18) Тогда
	Отбор = Новый Структура("БарКод",БарКод);		
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

&НаКлиенте
Процедура ПолучитьСписокПО(Команда)
СписокПО = Новый СписокЗначений();
РаскрытьНаПО(Элементы.Стенд.ТекущиеДанные.ПроизводственноеЗадание,Элементы.Стенд.ТекущиеДанные.Изделие,СписокПО);
СписокПО.СортироватьПоЗначению();
СписокПО.ВыбратьЭлемент("Список программного обеспечения");
КонецПроцедуры
 
&НаСервере
Функция МожноВыпуститьНаСтенде()
	Если Найти(Объект.ПроизводственноеЗадание.Изделие,"(СТ-") > 0 Тогда
	Возврат(Истина);
	Иначе
	Возврат(Ложь);		
	КонецЕсли; 
КонецФункции

&НаСервере
Процедура ПолучитьЭтапыСпецификации()
Этапы.Очистить();
Объект.Спецификация.Очистить();
ОбщийМодульВызовСервера.ПолучитьТаблицуЭтаповСпецификации(Этапы,Объект.ПроизводственноеЗадание.Изделие,1,Ложь,Объект.ПроизводственноеЗадание.ДатаЗапуска);

	Для каждого ТЧ Из Этапы Цикл
		Если Объект.РабочееМесто.ТабличнаяЧасть.Найти(ТЧ.ГруппаНоменклатуры,"ГруппаНоменклатуры") = Неопределено Тогда
		Продолжить;
		КонецЕсли;
	ОбщийМодульВызовСервера.ПолучитьСпецификациюСАналогами(Объект.Спецификация,Объект.ПроизводственноеЗадание,ТЧ.ЭтапСпецификации,ТЧ.ЭтапСпецификации,ТЧ.Количество);	
	КонецЦикла;
Объект.Спецификация.Сортировать("ЭтапСпецификации,ВидМПЗ,Позиция,МПЗ");
КонецПроцедуры

&НаСервере
Функция ВыпускПродукцииНаСервере()
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	ДатаОкончания = ТекущаяДата();
	НаборЗаписей = РегистрыСведений.СтендовыйПрогон.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПЗ.Установить(Объект.ПроизводственноеЗадание);
	НаборЗаписей.Отбор.БарКод.Установить(Объект.ПроизводственноеЗадание.БарКод);
	НаборЗаписей.Отбор.Изделие.Установить(Объект.ПроизводственноеЗадание.Изделие);
	НаборЗаписей.Прочитать();
	    Для Каждого Запись Из НаборЗаписей Цикл
			Если Не ЗначениеЗаполнено(Запись.ДатаСнятия) Тогда
			Запись.ИсполнительСнятие = Объект.Исполнитель;
			Запись.ДатаСнятия = ДатаОкончания;
			Прервать; 
			КонецЕсли;  
	    КонецЦикла;
	НаборЗаписей.Записать();

	НаборЗаписей = РегистрыСведений.ЭтапыПроизводственныхЗаданий.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПЗ.Установить(Объект.ПроизводственноеЗадание);
	НаборЗаписей.Прочитать();
	    Для Каждого Запись Из НаборЗаписей Цикл 
	    	Если Запись.РабочееМесто = Объект.РабочееМесто Тогда
				Если Не ЗначениеЗаполнено(Запись.ДатаОкончания) Тогда
				Запись.Исполнитель = Объект.Исполнитель;
				Запись.ДатаОкончания = ДатаОкончания;					
				КонецЕсли; 
			Прервать;
			КонецЕсли;  
	    КонецЦикла;
	НаборЗаписей.Записать();
	ПолучитьЭтапыСпецификации();
		Если Не ОбщийМодульСозданиеДокументов.СоздатьВыпускПродукции(Объект.ПроизводственноеЗадание,Объект.РабочееМесто,Объект.Спецификация,Этапы,ДатаОкончания) Тогда
		Сообщить("Документ выпуска по производственному заданию "+Объект.ПроизводственноеЗадание.Номер+" не создан!");
		ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
		Возврат(Ложь);
		КонецЕсли;
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Возврат(Истина);	
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат(Ложь);	
	КонецПопытки;
КонецФункции

&НаКлиенте
Процедура ВыпускПродукции(Команда)
	Если Объект.ПроизводственноеЗадание.Пустая() Тогда
	Сообщить("Выберите производственное задание!");
	Возврат;
	КонецЕсли; 
ОтключитьОбработчикОжидания("ПолучитьДанныеПоСтенду");
	Если МожноВыпуститьНаСтенде() Тогда
		Если ВыпускПродукцииНаСервере() Тогда
		ОчиститьСсылкуНаПЗ();
		ПолучитьДанныеПоСтендуНаСервере();		
		КонецЕсли; 		
	Иначе
	Сообщить("Изделие не может быть выпущено на склад на этапе стенд!");
	КонецЕсли; 
		Если Объект.ИнтервалОбновления > 0 Тогда
		ПодключитьОбработчикОжидания("ПолучитьДанныеПоСтенду", Объект.ИнтервалОбновления*60);
		КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьЗаданиеНаСервере()
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто = &РабочееМесто
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.Ремонт = ЛОЖЬ
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДатаЗапуска = ДАТАВРЕМЯ(1,1,1,0,0,0)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Статус <> 2
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.НомерОчереди,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.Номер
	|ИТОГИ ПО
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование";	
Запрос.УстановитьПараметр("РабочееМесто",Объект.РабочееМесто);
Результат = Запрос.Выполнить();

ВыборкаМТК = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаМТК.Следующий() Цикл
	ВыборкаДетальныеЗаписи = ВыборкаМТК.Выбрать(ОбходРезультатаЗапроса.Прямой);
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если Не ОбщийМодульВызовСервера.СоздатьТаблицуЭтаповПроизводства(ВыборкаДетальныеЗаписи.ПЗ,Этапы,ЭтапыАРМ,Объект.РабочееМесто,Объект.Исполнитель) Тогда	
			Прервать; //Переходим к следующей МТК			
			КонецЕсли; 
				Если Не ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ПЗ.ДатаЗапуска) Тогда
				ОбщийМодульВызовСервера.ПроверитьНаличиеНаСкладе(ВыборкаДетальныеЗаписи.ПЗ.Линейка.МестоХраненияКанбанов,Этапы,ТаблицаМПЗ,Объект.ТаблицаРезервирования,СписокЛО);
				ОбщийМодульРаботаСРегистрами.ОбработкаЛьготнойОчереди(ВыборкаДетальныеЗаписи.ПЗ,СписокЛО);
					Если СписокЛО.Количество() > 0 Тогда
					Прервать; //Переходим к следующей МТК
					КонецЕсли; 
				КонецЕсли; 
		Объект.ПроизводственноеЗадание = ВыборкаДетальныеЗаписи.ПЗ;
		Возврат(Истина);
		КонецЦикла;
	КонецЦикла;
Возврат(Ложь);
КонецФункции

&НаСервере
Функция СоздатьПередачуВПроизводство(ДатаНачала)
	Попытка
	НаборЗаписей = РегистрыСведений.ЭтапыПроизводственныхЗаданий.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПЗ.Установить(Объект.ПроизводственноеЗадание);
	НаборЗаписей.Прочитать();
	    Для Каждого Запись Из НаборЗаписей Цикл 
	    	Если Запись.РабочееМесто = Объект.РабочееМесто Тогда
			Запись.Исполнитель = Объект.Исполнитель;
			Запись.ДатаНачала = ДатаНачала;
			Прервать;
			КонецЕсли;  
	    КонецЦикла;
	НаборЗаписей.Записать();
	СП = РегистрыСведений.СтендовыйПрогон.СоздатьМенеджерЗаписи();
	СП.Период = ТекущаяДата();
	СП.ПЗ = Объект.ПроизводственноеЗадание;
	СП.Изделие = Объект.ПроизводственноеЗадание.Изделие;
	СП.БарКод = Объект.ПроизводственноеЗадание.БарКод;
	СП.Стенд = Объект.РабочееМесто.Стенд;
	СП.Прогон = 1;
	СП.ИсполнительПоступление = Объект.Исполнитель;
	СП.ДатаПоступления = ДатаНачала;
	СП.ИсполнительПостановка = Объект.Исполнитель;
	СП.ДатаПостановки = ДатаНачала;
	СП.Записать();
	Возврат(ОбщийМодульСозданиеДокументов.СоздатьПередачуВПроизводство(Объект.ПроизводственноеЗадание,Объект.ТаблицаРезервирования));
	Исключение
	Сообщить(ОписаниеОшибки());
	Возврат(Ложь);
	КонецПопытки;
КонецФункции

&НаСервере
Функция ПолучитьДополнительныеПараметрыНоменклатуры()
ДПН = Справочники.ДополнительныеПараметрыНоменклатуры.Выбрать(,Объект.ПроизводственноеЗадание.Изделие);
	Пока ДПН.Следующий() Цикл
	Возврат(ДПН.СТ_ПР);
	КонецЦикла;
Возврат(0);
КонецФункции

&НаСервере
Функция ПолучитьЛинейку()
Возврат(Объект.ПроизводственноеЗадание.Линейка);
КонецФункции

&НаСервере
Функция ПолучитьИзделие()
Возврат(Объект.ПроизводственноеЗадание.Изделие);
КонецФункции

&НаСервере
Функция ПолучитьБарКодИзделия()
Возврат(Объект.ПроизводственноеЗадание.БарКод);
КонецФункции

&НаСервере
Функция ПолучитьСтенд()
Возврат(Объект.РабочееМесто.Стенд);
КонецФункции

&НаКлиенте
Процедура ПолучитьЗадание(Команда)
	Если ОбщийМодульВызовСервера.ОстановкаЛинейки(Объект.РабочееМесто) Тогда
		Если Вопрос("Линейка остановлена! Снять остановку?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			Если Не ОбщийМодульРаботаСРегистрами.СнятьОстановкуЛинейки(ОбщийМодульВызовСервера.ПолучитьЛинейкуПоРабочемуМесту(Объект.РабочееМесто)) Тогда	
			Возврат;
			КонецЕсли;
		Иначе
		Возврат;			
		КонецЕсли;
	КонецЕсли;
		Если ПолучитьЗаданиеНаСервере() Тогда
		ДатаНачала = ТекущаяДата();
			Если СоздатьПередачуВПроизводство(ДатаНачала) Тогда
			ТЧ = Объект.Стенд.Добавить();
			ТЧ.Линейка = ПолучитьЛинейку();
			ТЧ.ПроизводственноеЗадание = Объект.ПроизводственноеЗадание;
			ТЧ.Изделие = ПолучитьИзделие();
			ТЧ.БарКод = ПолучитьБарКодИзделия();
			ТЧ.Стенд = ПолучитьСтенд();
			ТЧ.Прогон = 1;
			ТЧ.Поступление = ДатаНачала;
			ТЧ.Постановка = ДатаНачала;
			ТЧ.Снятие = ДатаНачала+ПолучитьДополнительныеПараметрыНоменклатуры()*60;
			КонецЕсли;
		Элементы.ПростойЛинейки.Доступность = Ложь; 
		Иначе
		Сообщить("Нет производственных заданий!");
		КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьДокументов(Команда)
	Если Объект.ПроизводственноеЗадание.Пустая() Тогда
	Сообщить("Выберите производственное задание!");
	Возврат;
	КонецЕсли;
ОткрытьФорму("Обработка.СозданныеБарКоды.Форма.Форма",Новый Структура("ПЗ,РабочееМесто",Объект.ПроизводственноеЗадание,Объект.РабочееМесто));
КонецПроцедуры

&НаКлиенте
Процедура СтендВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	Если ОбщийМодульВызовСервера.ОстановкаЛинейки(Объект.РабочееМесто) Тогда
		Если Вопрос("Линейка остановлена! Снять остановку?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			Если Не ОбщийМодульРаботаСРегистрами.СнятьОстановкуЛинейки(ОбщийМодульВызовСервера.ПолучитьЛинейкуПоРабочемуМесту(Объект.РабочееМесто)) Тогда	
			Возврат;
			КонецЕсли;
		Иначе
		Возврат;			
		КонецЕсли;
	КонецЕсли;
		Если Не Элементы.Стенд.ТекущиеДанные.Ремонт Тогда
		Объект.ПроизводственноеЗадание = Элементы.Стенд.ТекущиеДанные.ПроизводственноеЗадание;
		Иначе
		Сообщить("Изделие находится в ремонте!");
		КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
КонецПроцедуры

&НаКлиенте
Процедура ПростойЛинейки(Команда)
Линейка = ОбщийМодульВызовСервера.ПолучитьЛинейкуПоРабочемуМесту(Объект.РабочееМесто);
	Если Не ОбщийМодульВызовСервера.ЛинейкаОстановлена(Линейка) Тогда
	ОткрытьФормуМодально("ОбщаяФорма.ОформлениеПростояЛинейки",Новый Структура("Линейка",Линейка));
	КонецЕсли;
КонецПроцедуры
