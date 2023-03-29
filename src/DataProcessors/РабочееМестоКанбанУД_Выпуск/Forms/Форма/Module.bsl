
&НаСервере
Процедура ПриСозданииНаСервере()
Объект.Исполнитель = ПараметрыСеанса.Пользователь;
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
Процедура ПолучитьДанныеНаСервере()

КонецПроцедуры
 
&НаСервере
Функция КанбанИзготовлен()
Запрос = Новый Запрос;

	Для каждого ТЧ Из Объект.ПроизводственноеЗадание.Оборудование Цикл	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВыполнениеЭтаповПроизводства.Оборудование,
		|	ВыполнениеЭтаповПроизводства.Количество
		|ИЗ
		|	РегистрСведений.ВыполнениеЭтаповПроизводства КАК ВыполнениеЭтаповПроизводства
		|ГДЕ
		|	ВыполнениеЭтаповПроизводства.МТК = &МТК
		|	И ВыполнениеЭтаповПроизводства.Оборудование = &Оборудование";
	Запрос.УстановитьПараметр("МТК", Объект.ПроизводственноеЗадание.ДокументОснование);
	Запрос.УстановитьПараметр("Оборудование", ТЧ.Оборудование);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	КолВсего = 0;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		КолВсего = КолВсего + ВыборкаДетальныеЗаписи.Количество;
		КонецЦикла;		
			Если КолВсего < Объект.ПроизводственноеЗадание.ДокументОснование.Количество Тогда	
	        Возврат(Ложь);
			КонецЕсли; 
	КонецЦикла;
Возврат(Истина);
КонецФункции 

&НаСервере
Функция МожноЗаписатьКанбан(Оборудование,Количество)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВыполнениеЭтаповПроизводства.Оборудование,
	|	ВыполнениеЭтаповПроизводства.Количество
	|ИЗ
	|	РегистрСведений.ВыполнениеЭтаповПроизводства КАК ВыполнениеЭтаповПроизводства
	|ГДЕ
	|	ВыполнениеЭтаповПроизводства.МТК = &МТК
	|	И ВыполнениеЭтаповПроизводства.Оборудование = &Оборудование";
Запрос.УстановитьПараметр("МТК", Объект.ПроизводственноеЗадание.ДокументОснование);
Запрос.УстановитьПараметр("Оборудование", Оборудование);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
КолВсего = 0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	КолВсего = КолВсего + ВыборкаДетальныеЗаписи.Количество;
	КонецЦикла;		
		Если КолВсего + Количество <= Объект.ПроизводственноеЗадание.ДокументОснование.Количество Тогда	
        Возврат(Истина);
		Иначе
		Возврат(Ложь);
		КонецЕсли;
КонецФункции 

&НаСервере
Функция ЗавершитьНаСервере()
КудаПередать = "";
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	ДатаОкончания = ТекущаяДата();
	ОбщийМодульРаботаСРегистрами.ИзменитьЭтапПроизводственногоЗадания(Объект.ПроизводственноеЗадание,Новый Структура("РабочееМесто,ДатаОкончания",Объект.РабочееМесто,ДатаОкончания));
		Если Не ОбщийМодульСозданиеДокументов.СоздатьВыпускПродукцииКанбан(Объект.ПроизводственноеЗадание,ДатаОкончания) Тогда
		Сообщить("Документ выпуска по ПЗ "+Объект.ПроизводственноеЗадание.Номер+" не создан!");
		ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
		Возврат(Неопределено);
		КонецЕсли;
			Если Объект.ПроизводственноеЗадание.Линейка.МестоХраненияГП.СоздаватьПередачуНаЛинейкуПотребитель Тогда	
				Если Не ОбщийМодульСозданиеДокументов.СоздатьПередачуНаЛинейку(Объект.ПроизводственноеЗадание.ДокументОснование,ДатаОкончания+1) Тогда
				Сообщить("Документ передачи на линейку не создан!");
				ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
				Возврат(Неопределено);				
				КонецЕсли;			
			КонецЕсли;
				Если флИзменено Тогда
				ПЗОбъект = Объект.ПроизводственноеЗадание.ПолучитьОбъект();
				ПЗОбъект.Оборудование.Очистить();
					Для каждого ТЧ Из ТаблицаТО Цикл
					ТЧ_О = ПЗОбъект.Оборудование.Добавить();
					ТЧ_О.ТехОперация = ТЧ.ТехОперация;
					ТЧ_О.Оборудование = ТЧ.Оборудование;
					ТЧ_О.Исполнитель = ТЧ.Исполнитель;
					ТЧ_О.Количество = ТЧ.Количество;
					КонецЦикла;
				ПЗОбъект.Записать(РежимЗаписиДокумента.Запись);
				КонецЕсли;
					Если Элементы.ВозвратнаяТара.Видимость Тогда
						Если ЗначениеЗаполнено(ВозвратнаяТара) Тогда
						ПЗОбъект = Объект.ПроизводственноеЗадание.ПолучитьОбъект();
						ПЗОбъект.ВозвратнаяТара = ВозвратнаяТара;
						ПЗОбъект.Записать(РежимЗаписиДокумента.Запись);
						Иначе
						Сообщить("Возвратная тара не указана!");
						ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
						Возврат(Неопределено);
						КонецЕсли; 
					КонецЕсли;  
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
		Если Объект.ПроизводственноеЗадание.ДокументОснование.Ремонт Тогда
		КудаПередать = "ремонтнику";
		Иначе	
		КудаПередать = "на линейку-потребитель";		
		КонецЕсли; 
	Объект.ПроизводственноеЗадание = Документы.ПроизводственноеЗадание.ПустаяСсылка();
	Объект.РабочееМесто = Справочники.РабочиеМестаЛинеек.ПустаяСсылка();
	ВозвратнаяТара = "";
	ТаблицаТО.Очистить();
	флИзменено = Ложь;	
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат(Неопределено);
	КонецПопытки;
Возврат(КудаПередать);
КонецФункции

&НаКлиенте
Процедура Завершить(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
		Если ОбщийМодульВызовСервера.МТКОстановлена(Объект.ПроизводственноеЗадание) Тогда
		Сообщить("По выбранному производственному заданию остановлена МТК!");
		Возврат;
		КонецЕсли;
	Результат = ЗавершитьНаСервере();	
		Если Результат <> Неопределено Тогда
		ПоказатьОповещениеПользователя("ВНИМАНИЕ!",,"Передайте изделие "+Результат,БиблиотекаКартинок.Пользователь);
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПолучитьПЗ(Значение)
ПЗ = ЗначениеИзСтрокиВнутр(Значение);
	Если ПЗ.ДокументОснование.Статус = 4 Тогда
	Объект.ПроизводственноеЗадание = ПЗ;
	Элементы.ВозвратнаяТара.Видимость = ТребуетсяВозвратнаяТара();
	Иначе
	Сообщить("Производственное задание не запущено в производство!");
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПолучитьЯчейкуХранения(Значение)
ВозвратнаяТара = ЗначениеИзСтрокиВнутр(Значение);
КонецПроцедуры

&НаСервере
Процедура ПолучитьРабочееМесто()
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ = &ПЗ";
Запрос.УстановитьПараметр("ПЗ", Объект.ПроизводственноеЗадание);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Объект.РабочееМесто = ВыборкаДетальныеЗаписи.РабочееМесто;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция МожноРаботатьВАРМ()
	Если ОбщийМодульВызовСервера.МожноВыполнить(Объект.РабочееМесто.Линейка) Тогда	
	Возврат(Истина);
	Иначе
	Объект.РабочееМесто = Справочники.РабочиеМестаЛинеек.ПустаяСсылка();
	Объект.ПроизводственноеЗадание = Документы.ПроизводственноеЗадание.ПустаяСсылка();
	Сообщить("Работа АРМ запрещена в этой базе!");
	Возврат(Ложь);
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если ЭтаФорма.ВводДоступен() Тогда
	Массив = ОбщийМодульВызовСервера.РазложитьСтрокуВМассив(Данные,";");
		Если Массив[0] = "4" Тогда	
		ПолучитьПЗ(Массив[1]);
			Если Не Объект.ПроизводственноеЗадание.Пустая() Тогда
			ПолучитьРабочееМесто();
				Если Не МожноРаботатьВАРМ() Тогда
				Возврат;
				КонецЕсли;
			ПолучитьТехОперации();
			КонецЕсли;
		Иначе
		ВозвратнаяТара = Массив[0];	
		КонецЕсли;
	ЭтаФорма.ТекущийЭлемент = Элементы.Завершить;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПолучитьТехОперации()
ТаблицаТО.Очистить();
	Для каждого ТЧ Из Объект.ПроизводственноеЗадание.Оборудование Цикл	
	ТЧ_ТО = ТаблицаТО.Добавить();
	ТЧ_ТО.ТехОперация = ТЧ.ТехОперация;
	ТЧ_ТО.Оборудование = ТЧ.Оборудование;
	ТЧ_ТО.Исполнитель = ТЧ.Исполнитель;
	ТЧ_ТО.Количество = ТЧ.Количество;
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Функция ТребуетсяВозвратнаяТара()
	Если Константы.КодБазы.Получить() = "БГР" Тогда
	Док = Объект.ПроизводственноеЗадание.ДокументОснование.ДокументОснование;
		Если ТипЗнч(Док) = Тип("ДокументСсылка.МаршрутнаяКарта") Тогда
		Возврат(Истина);
		ИначеЕсли ТипЗнч(Док) = Тип("ДокументСсылка.РемонтнаяКарта") Тогда
		Возврат(Истина);
		КонецЕсли; 
	КонецЕсли;
Возврат(Ложь);
КонецФункции 

&НаСервере
Функция ПолучитьСписокСотрудников(Оборудование)
СписокСотрудников = Новый СписокЗначений;

	Для каждого ТЧ Из Оборудование.Сотрудники Цикл	
	СписокСотрудников.Добавить(ТЧ.Сотрудник);	
	КонецЦикла;
Возврат(СписокСотрудников);
КонецФункции

&НаСервере
Функция ПолучитьСписокИсполнителей(ТО)
СписокИсполнителей = Новый СписокЗначений;

	Для каждого ТЧ Из ТО.Оборудование Цикл	
	СписокИсполнителей.Добавить(ТЧ.Сотрудник,СокрЛП(ТЧ.Сотрудник.Наименование)+" ("+СокрЛП(ТЧ.Оборудование.Наименование)+")");
	КонецЦикла;
Возврат(СписокИсполнителей); 
КонецФункции

&НаСервере
Функция ПолучитьОборудование(ТО,Исполнитель)
	Для каждого ТЧ Из ТО.Оборудование Цикл	
		Если ТЧ.Сотрудник = Исполнитель Тогда
		Возврат(ТЧ.Оборудование);
		КонецЕсли;
	КонецЦикла;
Возврат(Справочники.Сотрудники.ПустаяСсылка()); 
КонецФункции 

&НаКлиенте
Процедура ТаблицаОборудованияИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
СписокИсполнителей = ПолучитьСписокИсполнителей(Элементы.ТаблицаТО.ТекущиеДанные.ТехОперация);
Исполнитель = СписокИсполнителей.ВыбратьЭлемент("Выберите исполнителя");
	Если Исполнитель <> Неопределено Тогда
	Элементы.ТаблицаТО.ТекущиеДанные.Исполнитель = Исполнитель.Значение; 
	Элементы.ТаблицаТО.ТекущиеДанные.Оборудование = ПолучитьОборудование(Элементы.ТаблицаТО.ТекущиеДанные.ТехОперация,Исполнитель.Значение);
	флИзменено = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПЗ(Команда)
	Если ВвестиЗначение(Объект.ПроизводственноеЗадание,"Выберите производственное задание") Тогда	
	ЭтаФорма.ТекущийЭлемент = Элементы.Завершить;
	Элементы.ВозвратнаяТара.Видимость = ТребуетсяВозвратнаяТара();
	ПолучитьРабочееМесто();
		Если Не МожноРаботатьВАРМ() Тогда
		Возврат;
		КонецЕсли;
	ПолучитьТехОперации();
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ВозвратнаяТараПриИзменении(Элемент)
ЭтаФорма.ТекущийЭлемент = Элементы.Завершить;
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокОборудования(СписокОборудования,ТехОперация)
	Для каждого ТЧ Из ТехОперация.Оборудование Цикл
	СписокОборудования.Добавить(ТЧ.Оборудование);
	КонецЦикла;
КонецПроцедуры 

&НаКлиенте
Процедура ТаблицаТООборудованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
СписокОборудования = Новый СписокЗначений;

ПолучитьСписокОборудования(СписокОборудования, Элементы.ТаблицаТО.ТекущиеДанные.ТехОперация);
ВыбОборудование = СписокОборудования.ВыбратьЭлемент("Выберите оборудование");
	Если ВыбОборудование <> Неопределено Тогда
	Элементы.ТаблицаТО.ТекущиеДанные.Оборудование = ВыбОборудование.Значение;
	флИзменено = Истина;
	КонецЕсли; 
КонецПроцедуры
