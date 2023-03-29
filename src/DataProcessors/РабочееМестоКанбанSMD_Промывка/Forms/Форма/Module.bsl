
&НаСервере
Процедура ПриСозданииНаСервере()
Объект.Исполнитель =  ПараметрыСеанса.Пользователь; 
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
	Если Не Объект.РабочееМесто.Пустая() Тогда
	РабочееМестоПриИзменении(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеПоПромывкеНаСервере()
Объект.ТаблицаЗаданий.Очистить();
Запрос = Новый Запрос;
ЗапросЛО = Новый Запрос;

КоличествоПринятыхПЗ = 0;
Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаНачала,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.Период КАК Период,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.Количество,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.Изделие
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто = &РабочееМесто
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период";
Запрос.УстановитьПараметр("РабочееМесто",Объект.РабочееМесто);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = Объект.ТаблицаЗаданий.Добавить();
	ТЧ.ПроизводственноеЗадание = ВыборкаДетальныеЗаписи.ПЗ;
	ТЧ.Количество = ВыборкаДетальныеЗаписи.Количество;
	ТЧ.КоличествоБрак = ОбщийМодульВызовСервера.ПолучитьКоличествоВБракеПоПЗ(ВыборкаДетальныеЗаписи.ПЗ,Объект.РабочееМесто);
	ТЧ.Приоритет = ?(ВыборкаДетальныеЗаписи.ПЗ.НомерОчереди > 0,Истина,Ложь);
	ТЧ.НомерОчереди = ВыборкаДетальныеЗаписи.ПЗ.НомерОчереди;
	ТЧ.ДатаПередачи = ВыборкаДетальныеЗаписи.Период;
	ТЧ.ДатаНачала = ВыборкаДетальныеЗаписи.ДатаНачала;
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ДатаНачала) Тогда
		КоличествоПринятыхПЗ = КоличествоПринятыхПЗ + 1;
		КонецЕсли; 
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
	КонецЦикла;
Объект.ТаблицаЗаданий.Сортировать("Приоритет Убыв,НомерОчереди,ДатаПередачи");
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
ПолучитьДанныеПоПромывкеНаСервере();
	Если Объект.ИнтервалОбновления > 0 Тогда
	ПодключитьОбработчикОжидания("ПолучитьДанныеПоПромывке", Объект.ИнтервалОбновления*60);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьКодРабочегоМеста(РабочееМесто)
Возврат(РабочееМесто.Код);
КонецФункции

&НаКлиенте
Процедура ПолучитьДанныеПоПромывке() Экспорт
ПолучитьДанныеПоПромывкеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
ПолучитьДанныеПоПромывкеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПринятьНаПромывкуНаСервере(Стр)
ТЧ = Объект.ТаблицаЗаданий.НайтиПоИдентификатору(Стр);
	Если ЗначениеЗаполнено(ТЧ.ДатаНачала) Тогда
	Сообщить("Производственное задание уже принято на промывку!");
	Возврат;
	КонецЕсли;
НепринятоеПЗ = Документы.ПроизводственноеЗадание.ПустаяСсылка();
	Для каждого ТЧ_ПЗ Из Объект.ТаблицаЗаданий Цикл
		Если Не ЗначениеЗаполнено(ТЧ_ПЗ.ДатаНачала) Тогда			
		НепринятоеПЗ = ТЧ_ПЗ.ПроизводственноеЗадание;
		Прервать;
		КонецЕсли; 	
	КонецЦикла; 
		Если НепринятоеПЗ <> ТЧ.ПроизводственноеЗадание Тогда
		Сообщить("Имеются производственные задания с более высоким приоритетом принятия!");
		Возврат;
		КонецЕсли;  
ДатаНачала = ТекущаяДата();
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	Парам = Новый Структура("РабочееМесто,ДатаНачала",Объект.РабочееМесто,ТекущаяДата());
	ОбщийМодульРаботаСРегистрами.ИзменитьЭтапПроизводственногоЗадания(ТЧ.ПроизводственноеЗадание,Парам);	
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	ТЧ.ДатаНачала = ДатаНачала;
	КоличествоПринятыхПЗ = КоличествоПринятыхПЗ + 1;
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ПринятьНаПромывку(Команда)
	Если КоличествоПринятыхПЗ < 5 Тогда
		Если Элементы.ТаблицаЗаданий.ТекущаяСтрока <> Неопределено Тогда			
		ПринятьНаПромывкуНаСервере(Элементы.ТаблицаЗаданий.ТекущаяСтрока);	
		Иначе
		Сообщить("Выберите производственное задание!");
		КонецЕсли;
	Иначе
    Сообщить("Нельзя принять в работу больше 5 производственных заданий!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЗавершитьЭтапНаСервере(Стр)
ТЧ = Объект.ТаблицаЗаданий.НайтиПоИдентификатору(Стр);
НеотданноеПЗ = Документы.ПроизводственноеЗадание.ПустаяСсылка();
	Для каждого ТЧ_ПЗ Из Объект.ТаблицаЗаданий Цикл
		Если ЗначениеЗаполнено(ТЧ_ПЗ.ДатаНачала) Тогда			
		НеотданноеПЗ = ТЧ_ПЗ.ПроизводственноеЗадание;
		Прервать;
		КонецЕсли; 	
	КонецЦикла; 
		Если НеотданноеПЗ <> ТЧ.ПроизводственноеЗадание Тогда
		Сообщить("Имеются производственные задания с более высоким приоритетом выпуска с промывки!");
		Возврат(Ложь);
		КонецЕсли;
ПЗ = ТЧ.ПроизводственноеЗадание;
	Попытка
	Парам = Новый Структура("РабочееМесто,Исполнитель,ДатаОкончания",Объект.РабочееМесто,Объект.Исполнитель,ТекущаяДата());
	ОбщийМодульРаботаСРегистрами.ИзменитьЭтапПроизводственногоЗадания(ПЗ,Парам);
	Парам = Новый Структура("РабочееМесто,Количество",ОбщийМодульВызовСервера.ПолучитьСледующееРабочееМесто(Объект.РабочееМесто),ТЧ.Количество-ТЧ.КоличествоБрак);
	ОбщийМодульРаботаСРегистрами.СоздатьЭтапПроизводственногоЗаданияКанбан(ПЗ,Парам);
	Объект.ТаблицаЗаданий.Удалить(ТЧ);
	Исключение
	Сообщить(ОписаниеОшибки());
	Возврат(Ложь);
	КонецПопытки;
Возврат(Истина);
КонецФункции

&НаКлиенте
Процедура ЗавершитьИПередатьНаЭлектроконтроль(Команда)
	Если Элементы.ТаблицаЗаданий.ТекущаяСтрока <> Неопределено Тогда
		Если ЗначениеЗаполнено(Элементы.ТаблицаЗаданий.ТекущиеДанные.ДатаНачала) Тогда
			Если ЗавершитьЭтапНаСервере(Элементы.ТаблицаЗаданий.ТекущаяСтрока) Тогда
			КоличествоПринятыхПЗ = КоличествоПринятыхПЗ - 1;		
			КонецЕсли; 
		Иначе
		Сообщить("Производственное задание не принято на промывку!");
		КонецЕсли;	
	Иначе
	Сообщить("Выберите производственное задание!");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалОбновленияПриИзменении(Элемент)
ОтключитьОбработчикОжидания("ПолучитьДанныеПоПромывке");
	Если Объект.ИнтервалОбновления > 0 Тогда
	ПодключитьОбработчикОжидания("ПолучитьДанныеПоПромывке", Объект.ИнтервалОбновления*60);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОформитьБрак(Команда)
	Если Элементы.ТаблицаЗаданий.ТекущаяСтрока <> Неопределено Тогда
		Если ЗначениеЗаполнено(Элементы.ТаблицаЗаданий.ТекущиеДанные.ДатаНачала) Тогда
		Результат = ОткрытьФормуМодально("ОбщаяФорма.ОформлениеБракаКанбан",Новый Структура("РабочееМесто,ПЗ,КоличествоИзделия",Объект.РабочееМесто,Элементы.ТаблицаЗаданий.ТекущиеДанные.ПроизводственноеЗадание,Элементы.ТаблицаЗаданий.ТекущиеДанные.Количество-Элементы.ТаблицаЗаданий.ТекущиеДанные.КоличествоБрак));
			Если Результат <> 0 Тогда
			Элементы.ТаблицаЗаданий.ТекущиеДанные.КоличествоБрак = ОбщийМодульВызовСервера.ПолучитьКоличествоВБракеПоПЗ(Элементы.ТаблицаЗаданий.ТекущиеДанные.ПроизводственноеЗадание,Объект.РабочееМесто);		
			КонецЕсли;
		Иначе
		Сообщить("Производственное задание не принято на промывку!");
		КонецЕсли;	
	Иначе
	Сообщить("Выберите производственное задание!");
	КонецЕсли;   
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
КонецПроцедуры
