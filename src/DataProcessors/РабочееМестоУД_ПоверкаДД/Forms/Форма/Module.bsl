
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.Исполнитель = ПараметрыСеанса.Пользователь;
	Если Объект.Исполнитель.Пустая() Тогда
	Элементы.СписокРабочихМест.Доступность = Ложь;
	Сообщить("Вы не внесены в справочник Сотрудников! Работа невозможна!");
	КонецЕсли; 
флСортировка = 1;
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
		Если СписокРабочихМест.Количество() > 0 Тогда
		СписокРабочихМестПриИзменении(Неопределено);
		КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеПоПоверкеНаСервере()
тДеревоЗаданий = РеквизитФормыВЗначение("ДеревоЗаданий");
тДеревоЗаданий.Строки.Очистить();

Запрос = Новый Запрос;
ЗапросСП = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаНачала,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.Изделие,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.БарКод,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.Ремонт,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.Линейка КАК Линейка
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто В (&СписокРабочихМест)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Статус <> 2
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.Изделие.Товар.Наименование,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.Номер
	|ИТОГИ ПО
	|	Линейка";
Запрос.УстановитьПараметр("СписокРабочихМест",СписокРабочихМест);
Результат = Запрос.Выполнить();
ВыборкаЛинейки = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаЛинейки.Следующий() Цикл
	СтрЛинейка = тДеревоЗаданий.Строки.Добавить();
	СтрЛинейка.Линейка = ВыборкаЛинейки.Линейка;
	ВыборкаДетальныеЗаписи = ВыборкаЛинейки.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрПЗ = СтрЛинейка.Строки.Добавить();
		СтрПЗ.Линейка = ВыборкаДетальныеЗаписи.ПЗ.Линейка;
		СтрПЗ.Ремонт = ВыборкаДетальныеЗаписи.Ремонт;
		СтрПЗ.ПроизводственноеЗадание = ВыборкаДетальныеЗаписи.ПЗ;
		СтрПЗ.ВозвратнаяТара = ВыборкаДетальныеЗаписи.ПЗ.ВозвратнаяТара;
		СтрПЗ.Товар = СокрЛП(ВыборкаДетальныеЗаписи.Изделие.Товар.Наименование);
		СтрПЗ.РабочееМесто = ВыборкаДетальныеЗаписи.РабочееМесто;
		СтрПЗ.Постановка = ВыборкаДетальныеЗаписи.ДатаНачала;
		КонецЦикла;
	КонецЦикла;
ЗначениеВРеквизитФормы(тДеревоЗаданий, "ДеревоЗаданий");
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеПоПоверке() Экспорт
ПолучитьДанныеПоПоверкеНаСервере();
КонецПроцедуры
 
&НаСервере
Функция МожноРаботатьВАРМ()
	Если ОбщийМодульВызовСервера.МожноВыполнить(СписокРабочихМест[0].Значение.Линейка) Тогда	
	Возврат(Истина);
	Иначе
	СписокРабочихМест.Очистить();
	Сообщить("Работа АРМ запрещена в этой базе!");
	Возврат(Ложь);
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура СписокРабочихМестПриИзменении(Элемент)
	Если Не МожноРаботатьВАРМ() Тогда
	Возврат;
	КонецЕсли;
ПолучитьДанныеПоПоверкеНаСервере();
	Если Объект.ИнтервалОбновления > 0 Тогда
	ПодключитьОбработчикОжидания("ПолучитьДанныеПоПоверке", Объект.ИнтервалОбновления*60);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалОбновленияПриИзменении(Элемент)
ОтключитьОбработчикОжидания("ПолучитьДанныеПоПоверке");
	Если Объект.ИнтервалОбновления > 0 Тогда
	ПодключитьОбработчикОжидания("ПолучитьДанныеПоПоверке", Объект.ИнтервалОбновления*60);
	КонецЕсли;  
КонецПроцедуры

&НаСервере
Функция НайтиЭтапСтенд(Спецификация,ЭтапСТ)
НР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н(Спецификация,ТекущаяДата());
	Пока НР.Следующий() Цикл
		Если НР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Основа Тогда
			Если Найти(НР.Элемент.Наименование,"СТ-") > 0 Тогда
			ЭтапСТ = НР.Элемент;
			Прервать;
			Иначе
			НайтиЭтапСтенд(НР.Элемент,ЭтапСТ);
			КонецЕсли; 	
		КонецЕсли; 
	КонецЦикла;
Возврат(ЭтапСТ);	
КонецФункции

&НаСервере
Функция ПолучитьНомерРазукомплектовки(ПЗ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Разукомплектовка.Ссылка
	|ИЗ
	|	Документ.Разукомплектовка КАК Разукомплектовка
	|ГДЕ
	|	Разукомплектовка.ДокументОснование = &ДокументОснование";
Запрос.УстановитьПараметр("ДокументОснование", ПЗ);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
Возврат(ВыборкаДетальныеЗаписи.Количество()+1); 
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
Функция ПолучитьВидРемонтаОбщий()
Возврат(Перечисления.ВидыРемонта.Общий);	
КонецФункции

&НаСервере
Функция ПечатьРемонтнойБирки(ПЗ,Комментарии,Количество,НомерРемонтнойТары)
ТабДок = Новый ТабличныйДокумент;

Макет = ПолучитьОбщийМакет("Бирка_Ремонтная");
ОблБирка = Макет.ПолучитьОбласть("Бирка");
ОблБирка.Параметры.НомерМТК = ПЗ.ДокументОснование.Номер;
ОблБирка.Параметры.Линейка = СокрЛП(ПЗ.ДокументОснование.Линейка.Наименование);
ОблБирка.Параметры.Наименование = СокрЛП(ПЗ.Изделие.Наименование);
ОблБирка.Параметры.Количество = Количество;
ОблБирка.Параметры.ВозвратнаяТара = НомерРемонтнойТары;
ОблБирка.Параметры.ПричинаРемонта = Комментарии.ПричинаРемонта;
ОблБирка.Параметры.Комментарий = Комментарии.Комментарий;
ТабДок.Вывести(ОблБирка);
Возврат(ТабДок);
КонецФункции

&НаСервере
Функция ПолучитьСписокПЗПоВозвратнойТаре(ВозвратнаяТара)
СписокПЗ = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.Изделие
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто В ИЕРАРХИИ(&СписокРабочихМест)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Статус <> 2
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.Ремонт = ЛОЖЬ
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ВозвратнаяТара = &ВозвратнаяТара
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.Номер";
Запрос.УстановитьПараметр("СписокРабочихМест",СписокРабочихМест);
Запрос.УстановитьПараметр("ВозвратнаяТара",ВозвратнаяТара);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	СписокПЗ.Добавить(ВыборкаДетальныеЗаписи.ПЗ,ВыборкаДетальныеЗаписи.ПЗ.БарКод);
	КонецЦикла;
Возврат(СписокПЗ);
КонецФункции 

&НаСервере
Функция ПолучитьРабочееМестоВПЗ(ПЗ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ = &ПЗ";
Запрос.УстановитьПараметр("ПЗ",ПЗ);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат(ВыборкаДетальныеЗаписи.РабочееМесто);
	КонецЦикла;
КонецФункции

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

&НаКлиенте
Процедура Ремонт(Команда,НомерВТ = "")
	Если НомерВТ = "" Тогда
		Если Не ВвестиСтроку(НомерВТ,"Введите номер возвратной тары",4,Ложь) Тогда	
		Сообщить("Не введён номер возвратной тары!");
		Возврат;
		КонецЕсли;
	КонецЕсли;
СписокПЗ = ПолучитьСписокПЗПоВозвратнойТаре(НомерВТ);
	Если СписокПЗ.ОтметитьЭлементы("Выберите ПЗ для отправки в ремонт") Тогда
	Результат = ОткрытьФормуМодально("ОбщаяФорма.ВыборПричинРемонта",Новый Структура("РабочееМесто",ПолучитьРабочееМестоВПЗ(СписокПЗ[0].Значение)));
		Если Результат <> Неопределено Тогда
		НомерРемонтнойТары = "";
			Если ВвестиСтроку(НомерРемонтнойТары,"Введите номер ремонтной тары",4) Тогда
			КоличествоВРемонт = 0;
				Для каждого ПЗ Из СписокПЗ Цикл			
					Если ПЗ.Пометка Тогда
					КоличествоВРемонт = КоличествоВРемонт + 1;
					ТекущееРабочееМесто = ПолучитьРабочееМестоВПЗ(ПЗ.Значение);
					ПолучитьЭтапыСпецификации(ПЗ.Значение,ТекущееРабочееМесто);
					ОбщийМодульСозданиеДокументов.СоздатьРемонтнуюКарту(ПЗ.Значение,ТекущееРабочееМесто,ПолучитьИзделиеРемонта(ТекущееРабочееМесто),Объект.Исполнитель,ПолучитьВидРемонтаОбщий(),Результат,,НомерРемонтнойТары);				
					КонецЕсли; 
				КонецЦикла;
			ТД = ПечатьРемонтнойБирки(СписокПЗ[0].Значение,Результат,КоличествоВРемонт,НомерРемонтнойТары);
			ТД.Показать("Ремонтная бирка"); 
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли;
ПолучитьДанныеПоПоверкеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
ПолучитьДанныеПоПоверкеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
КонецПроцедуры

&НаСервере
Процедура ПолучитьФайлы(СписокФайлов,ПЗ,ЭтапСпецификации)
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_Д(ЭтапСпецификации,ПЗ.ДатаЗапуска);
	Пока ВыборкаНР.Следующий() Цикл
		Если ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Документация") Тогда
			Если Найти(ВыборкаНР.Ссылка.Владелец.Наименование,"СБ-") Тогда
				Если Найти(ВыборкаНР.Элемент.Наименование,"СБ") Тогда
				СписокФайлов.Добавить(ВыборкаНР.Элемент);
				КонецЕсли;
			КонецЕсли;				
		Иначе 
		ПолучитьФайлы(СписокФайлов,ПЗ,ВыборкаНР.Элемент);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьИзделие(ПЗ)
Возврат(ПЗ.Изделие);
КонецФункции 

&НаКлиенте
Процедура ОткрытьФайл(Команда)
СписокФайлов = Новый СписокЗначений;

ПолучитьФайлы(СписокФайлов,Элементы.ДеревоЗаданий.ТекущиеДанные.ПроизводственноеЗадание,ПолучитьИзделие(Элементы.ДеревоЗаданий.ТекущиеДанные.ПроизводственноеЗадание));
	Если СписокФайлов.Количество() > 0 Тогда
	Док = СписокФайлов[0].Значение;
		Если Док <> Неопределено Тогда
		ОбщийМодульКлиент.ОткрытьФайлДокумента(Док);
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция НайтиПоВозвратнойТареВДереве(КоллекцияСтрокДереваОдногоУровня,НомерВТ,Идентификатор = Неопределено) 
    Для Каждого Стр Из КоллекцияСтрокДереваОдногоУровня Цикл
        Если Стр.ВозвратнаяТара = НомерВТ Тогда
		Идентификатор = Стр.ПолучитьИдентификатор();
		Прервать;
        КонецЕсли;
    НайтиПоВозвратнойТареВДереве(Стр.ПолучитьЭлементы(),НомерВТ,Идентификатор);
    КонецЦикла;
Возврат(Идентификатор);   
КонецФункции

&НаСервере
Процедура НайтиПоВозвратнойТареНаСервере(НомерВТ) 
Элементы.ДеревоЗаданий.ТекущаяСтрока = НайтиПоВозвратнойТареВДереве(ДеревоЗаданий.ПолучитьЭлементы(),НомерВТ); 
КонецПроцедуры 

&НаКлиенте
Процедура НайтиПоВозвратнойТаре(Команда)
НомерВТ = "";
	Если ВвестиСтроку(НомерВТ,"Введите номер возвратной тары",4,Ложь) Тогда	
	НайтиПоВозвратнойТареНаСервере(НомерВТ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьСпецификации(Команда)
ОткрытьФорму("Отчет.ПечатьСпецификации.Форма.ФормаОтчета",Новый Структура("ПЗ",Элементы.ДеревоЗаданий.ТекущиеДанные.ПроизводственноеЗадание));
КонецПроцедуры

&НаСервере
Процедура ПолучитьПомеченныеЗаданияПодчиненные(тДерево,СписокИзделий)
   	Для Каждого тСтр Из тДерево.Строки Цикл
		Если тСтр.Пометка Тогда
		СписокИзделий.Добавить(тСтр.Товар,тСтр.ВозвратнаяТара);
		КонецЕсли;
   	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьПомеченныеЗадания()
СписокИзделий = Новый СписокЗначений;

тДерево = РеквизитФормыВЗначение("ДеревоЗаданий");
   	Для Каждого тСтр Из тДерево.Строки Цикл
	ПолучитьПомеченныеЗаданияПодчиненные(тСтр,СписокИзделий);
   	КонецЦикла;
Возврат(СписокИзделий);
КонецФункции

&НаКлиенте
Процедура РазвернутьДерево(Команда)
тЭлементы = ДеревоЗаданий.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл
   Элементы.ДеревоЗаданий.Развернуть(тСтр.ПолучитьИдентификатор(), Истина);
   КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СвернутьДерево(Команда)
тЭлементы = ДеревоЗаданий.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл
   Элементы.ДеревоЗаданий.Свернуть(тСтр.ПолучитьИдентификатор());
   КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОтменитьВсеПодчиненныеНаСервере(тДерево)
   	Для Каждого тСтр Из тДерево.Строки Цикл
   	тСтр.Пометка = Ложь;
	ОтменитьВсеПодчиненныеНаСервере(тСтр);
   	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОтменитьВсеНаСервере()
тДерево = РеквизитФормыВЗначение("ДеревоЗаданий");
   	Для Каждого тСтр Из тДерево.Строки Цикл
	ОтменитьВсеПодчиненныеНаСервере(тСтр);
   	КонецЦикла;
ЗначениеВРеквизитФормы(тДерево, "ДеревоЗаданий");
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе(Команда)
ОтменитьВсеНаСервере();
РазвернутьДерево(Неопределено);
КонецПроцедуры

&НаСервере
Процедура ВыбратьВсеПодчиненныеНаСервере(тДерево,НомерВТ,Пометка)
   	Для Каждого тСтр Из тДерево.Строки Цикл
		Если тСтр.ВозвратнаяТара = НомерВТ Тогда
			Если Не тСтр.Ремонт Тогда
			тСтр.Пометка = Пометка;
			КонецЕсли;
		КонецЕсли; 
	ВыбратьВсеПодчиненныеНаСервере(тСтр,НомерВТ,Пометка);
   	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ВыбратьПоНомеруВТНаСервере(Стр)
ТЧ = ДеревоЗаданий.НайтиПоИдентификатору(Стр);
тДерево = РеквизитФормыВЗначение("ДеревоЗаданий");
   	Для Каждого тСтр Из тДерево.Строки Цикл
	ВыбратьВсеПодчиненныеНаСервере(тСтр,ТЧ.ВозвратнаяТара,ТЧ.Пометка);
   	КонецЦикла;
ЗначениеВРеквизитФормы(тДерево, "ДеревоЗаданий");
КонецПроцедуры

&НаСервере
Функция НайтиВДереве(КоллекцияСтрокДереваОдногоУровня,ПЗ,Идентификатор = Неопределено)
    Для Каждого Стр Из КоллекцияСтрокДереваОдногоУровня Цикл
        Если Стр.ПроизводственноеЗадание = ПЗ Тогда
		Идентификатор = Стр.ПолучитьИдентификатор();
        КонецЕсли;
    НайтиВДереве(Стр.ПолучитьЭлементы(),ПЗ,Идентификатор);
    КонецЦикла;
Возврат(Идентификатор);   
КонецФункции

&НаСервере
Процедура НайтиНаСервере(ПЗ)
Элементы.ДеревоЗаданий.ТекущаяСтрока = НайтиВДереве(ДеревоЗаданий.ПолучитьЭлементы(),ПЗ); 
КонецПроцедуры 

&НаКлиенте
Процедура ДеревоЗаданийПометкаПриИзменении(Элемент)
ПЗ = Элементы.ДеревоЗаданий.ТекущиеДанные.ПроизводственноеЗадание;
ВыбратьПоНомеруВТНаСервере(Элементы.ДеревоЗаданий.ТекущаяСтрока);
НайтиНаСервере(ПЗ);
КонецПроцедуры

&НаСервере
Процедура ПринятьНаПоверкуПомеченные(КоллекцияСтрокДереваОдногоУровня)
	Для Каждого Стр Из КоллекцияСтрокДереваОдногоУровня Цикл
        Если Стр.Пометка Тогда
		ДатаНачала = ТекущаяДата();
		Парам = Новый Структура("РабочееМесто,Исполнитель,ДатаНачала",Стр.РабочееМесто,Объект.Исполнитель,ДатаНачала);
			Попытка
			ОбщийМодульРаботаСРегистрами.ИзменитьЭтапПроизводственногоЗадания(Стр.ПроизводственноеЗадание,Парам);
			Стр.Постановка = ДатаНачала;
			Стр.Пометка = Ложь;	
			Исключение
			Сообщить(ОписаниеОшибки());
			КонецПопытки;		
        КонецЕсли;
    ПринятьНаПоверкуПомеченные(Стр.ПолучитьЭлементы());
    КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПринятьНаПоверкуНаСервере()
ПринятьНаПоверкуПомеченные(ДеревоЗаданий.ПолучитьЭлементы());
КонецФункции

&НаКлиенте
Процедура ПринятьНаПоверку(Команда)
ПринятьНаПоверкуНаСервере();
КонецПроцедуры

&НаСервере
Функция ЗавершитьЗаданиеПомеченные(КоллекцияСтрокДереваОдногоУровня)
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;    
		Для Каждого Стр Из КоллекцияСтрокДереваОдногоУровня Цикл
	        Если Стр.Пометка Тогда
				Если Не ЗначениеЗаполнено(Стр.Постановка) Тогда	
				Сообщить(""+Стр.ПроизводственноеЗадание.БарКод+" - не принято на поверку!");
				Продолжить;
				КонецЕсли; 
			ПолучитьЭтапыСпецификации(Стр.ПроизводственноеЗадание,Стр.РабочееМесто);
				Если Не ОбщийМодульСозданиеДокументов.СоздатьВыпускПродукции(Стр.ПроизводственноеЗадание,Стр.РабочееМесто,Объект.Спецификация,Этапы,ТекущаяДата()) Тогда
				Сообщить("Документ выпуска по производственному заданию "+Стр.ПроизводственноеЗадание.Номер+" не создан!");
				ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
				Возврат(Ложь);
				КонецЕсли;
			Парам = Новый Структура("РабочееМесто,ДатаОкончания",Стр.РабочееМесто,ТекущаяДата());
			ОбщийМодульРаботаСРегистрами.ИзменитьЭтапПроизводственногоЗадания(Стр.ПроизводственноеЗадание,Парам);
			ОбщийМодульРаботаСРегистрами.СоздатьЭтапПроизводственногоЗадания(Стр.ПроизводственноеЗадание,ОбщийМодульВызовСервера.ПолучитьСледующееРабочееМесто(Стр.РабочееМесто),Неопределено,Неопределено);
	        КонецЕсли;
	    ЗавершитьЗаданиеПомеченные(Стр.ПолучитьЭлементы());
	    КонецЦикла;
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	КонецПопытки;  
Возврат(Истина);   
КонецФункции

&НаСервере
Функция ЗавершитьЗаданиеНаСервере()
Возврат(ЗавершитьЗаданиеПомеченные(ДеревоЗаданий.ПолучитьЭлементы()));
КонецФункции

&НаКлиенте
Процедура ЗавершитьЗадание(Команда)
	Если ЗавершитьЗаданиеНаСервере() Тогда
	ПоказатьОповещениеПользователя("ВНИМАНИЕ!",,"Передайте изделия на следующее АРМ",БиблиотекаКартинок.Пользователь);
	ПолучитьДанныеПоПоверкеНаСервере();	
	КонецЕсли;
КонецПроцедуры
