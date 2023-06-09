
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.Исполнитель = ПараметрыСеанса.Пользователь;
Объект.РабочееМесто = Справочники.РабочиеМестаЛинеек.НайтиПоНаименованию("Ремонтник",Истина);
	Если Объект.Исполнитель.ЛинейкиПроизводства.Количество() > 0 Тогда
		Для каждого ТЧ Из Объект.Исполнитель.ЛинейкиПроизводства Цикл
		СписокЛинеек.Добавить(ТЧ.Линейка);
		КонецЦикла; 
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
		Если СписокЛинеек.Количество() > 0 Тогда
		НачатьМониторингНаСервере();
		РазвернутьДерево(Неопределено);
		Иначе
		Сообщить("Сотрудник не распределён ни на одну из линеек!");		
		КонецЕсли;
ПодключитьОбработчикОжидания("ПолучитьОтложенныеЗадания", 240);
КонецПроцедуры 

&НаКлиенте
Процедура ПриЗакрытии()
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево(Команда)
тЭлементы = ДеревоМПЗ.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл
   Элементы.ДеревоМПЗ.Развернуть(тСтр.ПолучитьИдентификатор(), Истина);
   КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СвернутьДерево(Команда)
тЭлементы = ДеревоМПЗ.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл
   Элементы.ДеревоМПЗ.Свернуть(тСтр.ПолучитьИдентификатор());
   КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ДобавитьАналоги(НР,КоличествоТребуется,Стр,НаДату,СписокМестХранения,РемонтнаяКарта)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	АналогиНормРасходов.Ссылка КАК Ссылка,
	|	АналогиНормРасходов.ВидЭлемента КАК ВидЭлемента,
	|	АналогиНормРасходов.Элемент КАК Элемент,
	|	АналогиНормРасходовСрезПоследних.Норма КАК Норма
	|ИЗ
	|	РегистрСведений.АналогиНормРасходов.СрезПоследних(&НаДату, ) КАК АналогиНормРасходовСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.АналогиНормРасходов КАК АналогиНормРасходов
	|		ПО АналогиНормРасходовСрезПоследних.АналогНормыРасходов = АналогиНормРасходов.Ссылка
	|ГДЕ
	|	АналогиНормРасходов.Владелец = &Владелец
	|	И АналогиНормРасходовСрезПоследних.Норма > 0";
Запрос.УстановитьПараметр("НаДату", НаДату);
Запрос.УстановитьПараметр("Владелец", НР);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаАНР = РезультатЗапроса.Выбрать();
	Пока ВыборкаАНР.Следующий() Цикл
	СтрМПЗ = Стр.Строки.Добавить();
	СтрМПЗ.Наименование = ВыборкаАНР.Ссылка.Наименование;
	СтрМПЗ.Линейка = РемонтнаяКарта.Линейка; 
	СтрМПЗ.РемонтнаяКарта = РемонтнаяКарта;
	СтрМПЗ.НРРемонта = ВыборкаАНР.Ссылка;
	СтрМПЗ.НР = НР;
	СтрМПЗ.СтатусМТК = -1;
	СтрМПЗ.ЕдиницаИзмерения = ВыборкаАНР.Ссылка.Элемент.ЕдиницаИзмерения;
	СтрМПЗ.КоличествоТребуется = КоличествоТребуется;
	СтрМПЗ.КоличествоСклад = ОбщийМодульВызовСервера.ПолучитьСводныйОстатокПоМестамХранения(СписокМестХранения,ВыборкаАНР.Ссылка.Элемент);	
	СтрМПЗ.Аналог = Истина;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПолучитьОтложенныеРемонтныеКарты(тДеревоМПЗ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РемонтнаяКарта.Ссылка,
	|	РемонтнаяКарта.Дата,
	|	РемонтнаяКарта.Изделие,
	|	РемонтнаяКарта.Линейка,
	|	РемонтнаяКарта.ДокументОснование
	|ИЗ
	|	Документ.РемонтнаяКарта КАК РемонтнаяКарта
	|ГДЕ
	|	РемонтнаяКарта.ПометкаУдаления = ЛОЖЬ
	|	И РемонтнаяКарта.Проведен = ЛОЖЬ
	|	И РемонтнаяКарта.ДатаНачала <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
	Если ОтобратьПоЛинейке.Пустая() Тогда
	Запрос.Текст = Запрос.Текст + " И РемонтнаяКарта.Линейка В ИЕРАРХИИ(&СписокЛинеек)";
	Запрос.УстановитьПараметр("СписокЛинеек",СписокЛинеек);	
	Иначе
	Запрос.Текст = Запрос.Текст + " И РемонтнаяКарта.Линейка = &Линейка";
	Запрос.УстановитьПараметр("Линейка",ОтобратьПоЛинейке);
	КонецЕсли;
Запрос.Текст = Запрос.Текст + " ИТОГИ ПО Линейка";
Результат = Запрос.Выполнить();
ВыборкаЛинейки = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаЛинейки.Следующий() Цикл
	СтрЛинейка = тДеревоМПЗ.Строки.Добавить();
	СтрЛинейка.Наименование = ВыборкаЛинейки.Линейка.Наименование;
	СтрЛинейка.Линейка = ВыборкаЛинейки.Линейка;
	СтрЛинейка.СтатусМТК = -1;
	ВыборкаРемонтнаяКарта = ВыборкаЛинейки.Выбрать();
		Пока ВыборкаРемонтнаяКарта.Следующий() Цикл
		СтрПЗ = СтрЛинейка.Строки.Добавить();
			Если Не ЗначениеЗаполнено(ВыборкаРемонтнаяКарта.ДокументОснование) Тогда
				Если ВыборкаРемонтнаяКарта.Ссылка.ЗаменяемыеЭлементы.Количество() > 0 Тогда	
				СтрПЗ.Наименование = ВыборкаРемонтнаяКарта.Ссылка.Номер+" от "+ВыборкаРемонтнаяКарта.Ссылка.Дата+" (дилерский ремонт)";
				Иначе
				СтрПЗ.Наименование = ВыборкаРемонтнаяКарта.Ссылка.Номер+" от "+ВыборкаРемонтнаяКарта.Ссылка.Дата+" (дилерский ремонт, нет заменяемых элементов)";
				КонецЕсли;			
			Иначе
				Если ВыборкаРемонтнаяКарта.Ссылка.ЗаменяемыеЭлементы.Количество() > 0 Тогда	
				СтрПЗ.Наименование = ВыборкаРемонтнаяКарта.Ссылка.Номер+" от "+ВыборкаРемонтнаяКарта.Ссылка.Дата;
				Иначе
				СтрПЗ.Наименование = ВыборкаРемонтнаяКарта.Ссылка.Номер+" от "+ВыборкаРемонтнаяКарта.Ссылка.Дата+" (нет заменяемых элементов)";
				КонецЕсли;
			КонецЕсли; 
		СтрПЗ.Линейка = ВыборкаЛинейки.Линейка;
		СтрПЗ.СтатусМТК = -1;
		СтрПЗ.РемонтнаяКарта = ВыборкаРемонтнаяКарта.Ссылка;
		СписокМестХранения.Очистить();
			Если ТипЗнч(ВыборкаРемонтнаяКарта.ДокументОснование) = Тип("ДокументСсылка.ПроизводственноеЗадание") Тогда
			СтрПЗ.ВозвратнаяТара = ВыборкаРемонтнаяКарта.Ссылка.ВозвратнаяТара;
			СтрПЗ.БарКод = ВыборкаРемонтнаяКарта.Ссылка.БарКод;
			СтрПЗ.КодDanfoss = ОбщийМодульВызовСервера.ПолучитьКодDanfoss(ВыборкаРемонтнаяКарта.Ссылка.БарКод);
			ДатаЗапуска = ВыборкаРемонтнаяКарта.ДокументОснование.ДатаЗапуска;
			Подразделение = ВыборкаЛинейки.Линейка.Подразделение;
			СписокМестХранения.Добавить(ВыборкаЛинейки.Линейка.МестоХраненияКанбанов);
			Иначе	
			ДатаЗапуска = ТекущаяДата();
			Подразделение = ВыборкаРемонтнаяКарта.Ссылка.Изделие.Канбан.Подразделение;
			КонецЕсли;
				Если ВыборкаРемонтнаяКарта.Ссылка.ЗаменяемыеЭлементы.Количество() > 0 Тогда
				СписокМестХраненияДляМониторинга = ОбщийМодульВызовСервера.ПолучитьСписокМестХраненияДляМониторинга(Подразделение);
					Для каждого МестоХранения Из СписокМестХраненияДляМониторинга Цикл
						Если СписокМестХранения.НайтиПоЗначению(МестоХранения.Значение) = Неопределено Тогда
						СписокМестХранения.Добавить(МестоХранения.Значение);
						КонецЕсли;
					КонецЦикла;
				СписокМестХранения.Добавить(Подразделение.МестоХраненияПоУмолчанию); 
				флЕстьНеобработанныеЗаменяемыеЭдементы = Ложь;
					Для каждого ТЧ Из ВыборкаРемонтнаяКарта.Ссылка.ЗаменяемыеЭлементы Цикл
						Если ТипЗнч(ТЧ.Документ) = Тип("ДокументСсылка.СписаниеМПЗПрочее") Тогда
						Продолжить;
						КонецЕсли;
					флЕстьНеобработанныеЗаменяемыеЭдементы = Истина; 
							Если ТипЗнч(ТЧ.НормаРасхода) = Тип("СправочникСсылка.АналогиНормРасходов") Тогда
							НР = ТЧ.НормаРасхода.Владелец;
							Иначе
							НР = ТЧ.НормаРасхода;
							КонецЕсли; 
					СтрМПЗ = СтрПЗ.Строки.Добавить();
					СтрМПЗ.Линейка = ВыборкаЛинейки.Линейка; 
					СтрМПЗ.РемонтнаяКарта = ВыборкаРемонтнаяКарта.Ссылка;
					СтрМПЗ.СтатусМТК = -1;
					СтрМПЗ.НРРемонта = ТЧ.НормаРасхода;
						Если НР <> Неопределено Тогда
							Если Не НР.Пустая() Тогда
							СтрМПЗ.Наименование = НР.Наименование;
							СтрМПЗ.НР = НР;
							СтрМПЗ.ЕдиницаИзмерения = НР.Элемент.ЕдиницаИзмерения;
							СтрМПЗ.КоличествоТребуется = ПолучитьБазовоеКоличество(ТЧ.Количество,НР.Элемент.ОсновнаяЕдиницаИзмерения);
							СтрМПЗ.КоличествоСклад = ОбщийМодульВызовСервера.ПолучитьСводныйОстатокПоМестамХранения(СписокМестХранения,НР.Элемент);
							ДобавитьАналоги(НР,СтрМПЗ.КоличествоТребуется,СтрМПЗ,ДатаЗапуска,СписокМестХранения,ВыборкаРемонтнаяКарта.Ссылка);
							Иначе
							СтрМПЗ.Наименование = ТЧ.МПЗ.Наименование;
							СтрМПЗ.НР = ТЧ.МПЗ;
							СтрМПЗ.ЕдиницаИзмерения = ТЧ.МПЗ.ЕдиницаИзмерения;
							СтрМПЗ.КоличествоТребуется = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения);
							СтрМПЗ.КоличествоСклад = ОбщийМодульВызовСервера.ПолучитьСводныйОстатокПоМестамХранения(СписокМестХранения,ТЧ.МПЗ);						
							КонецЕсли;						
						Иначе	
						СтрМПЗ.Наименование = ТЧ.МПЗ.Наименование;
						СтрМПЗ.НР = ТЧ.МПЗ;
						СтрМПЗ.ЕдиницаИзмерения = ТЧ.МПЗ.ЕдиницаИзмерения;
						СтрМПЗ.КоличествоТребуется = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения);
						СтрМПЗ.КоличествоСклад = ОбщийМодульВызовСервера.ПолучитьСводныйОстатокПоМестамХранения(СписокМестХранения,ТЧ.МПЗ);						
						КонецЕсли;
					СтрМПЗ.МТК = ТЧ.Документ;
						Если ЗначениеЗаполнено(СтрМПЗ.МТК) Тогда
						СтрМПЗ.СтатусМТК = ТЧ.Документ.Статус;
						КонецЕсли; 
					КонецЦикла;
						Если Не флЕстьНеобработанныеЗаменяемыеЭдементы Тогда
						СтрПЗ.Наименование = СтрПЗ.Наименование+" (нет заменяемых элементов)";
						КонецЕсли; 
				КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура НачатьМониторингНаСервере()
тДеревоМПЗ = РеквизитФормыВЗначение("ДеревоМПЗ");
тДеревоМПЗ.Строки.Очистить();
ПолучитьОтложенныеРемонтныеКарты(тДеревоМПЗ);
ЗначениеВРеквизитФормы(тДеревоМПЗ, "ДеревоМПЗ"); 
КонецПроцедуры

&НаСервере
Функция ПолучитьЗаданиеНаСервере(БарКод)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РемонтнаяКарта.Ссылка КАК Ссылка,
	|	РемонтнаяКарта.Дата КАК Дата,
	|	РемонтнаяКарта.Изделие КАК Изделие
	|ИЗ
	|	Документ.РемонтнаяКарта КАК РемонтнаяКарта
	|ГДЕ
	|	РемонтнаяКарта.ДатаНачала = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И РемонтнаяКарта.ПометкаУдаления = ЛОЖЬ
	|	И РемонтнаяКарта.Проведен = ЛОЖЬ
	|	И РемонтнаяКарта.Линейка В ИЕРАРХИИ(&СписокЛинеек)";
	Если ЗначениеЗаполнено(БарКод) Тогда
	Запрос.Текст = Запрос.Текст + " И РемонтнаяКарта.БарКод = &БарКод";
	Запрос.УстановитьПараметр("БарКод",БарКод);
	КонецЕсли;
Запрос.УстановитьПараметр("СписокЛинеек",СписокЛинеек);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	РемонтнаяКарта = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
	РемонтнаяКарта.Автор = Объект.Исполнитель;
	РемонтнаяКарта.ДатаНачала = ТекущаяДата();
	РемонтнаяКарта.Записать();
	Возврат(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
Возврат(Неопределено);
КонецФункции

&НаКлиенте
Процедура ПолучитьЗадание(Команда,БарКод = "")
РемонтнаяКарта = ПолучитьЗаданиеНаСервере(БарКод);
	Если РемонтнаяКарта <> Неопределено Тогда
	П = Новый Структура("Ключ",РемонтнаяКарта);
	Оп = Новый ОписаниеОповещения("ОбновитьОтложенныеЗадания", ЭтотОбъект,Истина);
	ОткрытьФорму("Документ.РемонтнаяКарта.ФормаОбъекта",П,,,,,Оп,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
	Предупреждение("Нет заданий на ремонт!");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтложенныеЗадания(Ответ,Отказ) Экспорт
НачатьМониторингНаСервере();
РазвернутьДерево(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьОтложенныеЗадания() Экспорт
НачатьМониторингНаСервере();
РазвернутьДерево(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
НачатьМониторингНаСервере();
РазвернутьДерево(Неопределено);
КонецПроцедуры 

&НаСервере
Функция ДобавитьЗаменуВРемонтНаСервере(РемонтнаяКарта,НР,НРРемонта)
	Если ТипЗнч(НР) <> Тип("СправочникСсылка.Номенклатура") Тогда
		Попытка
		НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
		флЗаменён = Ложь;
		РемонтнаяКартаОбъект = РемонтнаяКарта.ПолучитьОбъект();
			Для каждого ТЧ Из РемонтнаяКартаОбъект.ЗаменяемыеЭлементы Цикл
				Если ТЧ.НормаРасхода = НР Тогда
				ТЧ.МПЗ = НРРемонта.Элемент;
				флЗаменён = Истина;	
				Прервать;		
				КонецЕсли;		
			КонецЦикла; 
				Если Не флЗаменён Тогда
				Сообщить("Элемент не найден в ремонтной карте!");
				ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
				Возврат(Ложь);
				КонецЕсли;
		РемонтнаяКартаОбъект.Записать();
		ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
		Исключение
		Сообщить(ОписаниеОшибки());
		ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
		Возврат(Ложь);
		КонецПопытки;
	КонецЕсли;
Возврат(Истина);
КонецФункции

&НаСервере
Функция ПолучитьНРРемонта(Стр)
Возврат(ДеревоМПЗ.НайтиПоИдентификатору(Стр).НРРемонта);
КонецФункции

&НаКлиенте
Процедура ДеревоМПЗВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.ДеревоМПЗ.ТекущаяСтрока = Неопределено Тогда
	Сообщить("Выберите строку с заменяемым элементом!");
	Возврат;
	ИначеЕсли Элементы.ДеревоМПЗ.ТекущиеДанные.НР = Неопределено Тогда
		Если Найти(Элементы.ДеревоМПЗ.ТекущиеДанные.Наименование,"нет заменяемых элементов") = 0 Тогда
		Сообщить("Выберите строку с заменяемым элементом!");
		Возврат;
		КонецЕсли;
	КонецЕсли;
		Если (ЗначениеЗаполнено(Элементы.ДеревоМПЗ.ТекущиеДанные.МТК)) И (Элементы.ДеревоМПЗ.ТекущиеДанные.СтатусМТК <> 3) Тогда
		П = Новый Структура("Ключ",Элементы.ДеревоМПЗ.ТекущиеДанные.РемонтнаяКарта);
		Оп = Новый ОписаниеОповещения("ОбновитьОтложенныеЗадания", ЭтотОбъект,Истина);
		ОткрытьФорму("Документ.РемонтнаяКарта.ФормаОбъекта",П,,,,,Оп,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Возврат;
		КонецЕсли;  
			Если Элементы.ДеревоМПЗ.ТекущиеДанные.КоличествоТребуется > Элементы.ДеревоМПЗ.ТекущиеДанные.КоличествоСклад Тогда
			П = Новый Структура("Ключ",Элементы.ДеревоМПЗ.ТекущиеДанные.РемонтнаяКарта);
			Оп = Новый ОписаниеОповещения("ОбновитьОтложенныеЗадания", ЭтотОбъект,Истина);
			ОткрытьФорму("Документ.РемонтнаяКарта.ФормаОбъекта",П,,,,,Оп,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			Возврат;
			КонецЕсли; 
				Если Элементы.ДеревоМПЗ.ТекущиеДанные.КоличествоТребуется > 0 Тогда
					Если ДобавитьЗаменуВРемонтНаСервере(Элементы.ДеревоМПЗ.ТекущиеДанные.РемонтнаяКарта,Элементы.ДеревоМПЗ.ТекущиеДанные.НР,Элементы.ДеревоМПЗ.ТекущиеДанные.НРРемонта) Тогда
					П = Новый Структура("Ключ",Элементы.ДеревоМПЗ.ТекущиеДанные.РемонтнаяКарта);
					Оп = Новый ОписаниеОповещения("ОбновитьОтложенныеЗадания", ЭтотОбъект,Истина);
					ОткрытьФорму("Документ.РемонтнаяКарта.ФормаОбъекта",П,,,,,Оп,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);		
					КонецЕсли;
				Иначе
				П = Новый Структура("Ключ",Элементы.ДеревоМПЗ.ТекущиеДанные.РемонтнаяКарта);
				Оп = Новый ОписаниеОповещения("ОбновитьОтложенныеЗадания", ЭтотОбъект,Истина);
				ОткрытьФорму("Документ.РемонтнаяКарта.ФормаОбъекта",П,,,,,Оп,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
				КонецЕсли;  
КонецПроцедуры

&НаКлиенте
Процедура ОтобратьПоЛинейкеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если СписокЛинеек.НайтиПоЗначению(ВыбранноеЗначение) = Неопределено Тогда
	СтандартнаяОбработка =  Ложь;
	Сообщить("Выберите разрешённую линейку!");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтобратьПоЛинейкеПриИзменении(Элемент)
НачатьМониторингНаСервере();
РазвернутьДерево(Неопределено);
КонецПроцедуры

&НаСервере
Функция ДилерскийРемонтПрибораНаСервере(БарКод,Спецификация,ПричиныРемонта)
	Попытка	
	РемонтнаяКарта = Документы.РемонтнаяКарта.СоздатьДокумент();
	РемонтнаяКарта.Дата = ТекущаяДата();
	РемонтнаяКарта.ДатаНачала = ТекущаяДата();	
	РемонтнаяКарта.Подразделение = Спецификация.Линейка.Подразделение;
	РемонтнаяКарта.УстановитьНовыйНомер("ДР"+Формат(РемонтнаяКарта.Дата,"ДФ=гг")+"-");
	РемонтнаяКарта.Автор = Объект.Исполнитель;	
	РемонтнаяКарта.Товар = Спецификация.Товар;
	РемонтнаяКарта.Изделие = Спецификация;
	РемонтнаяКарта.Количество = 1;	
	РемонтнаяКарта.ВидРемонта = Перечисления.ВидыРемонта.Дилерский;
	РемонтнаяКарта.БарКод = БарКод;
	РемонтнаяКарта.Линейка = Спецификация.Линейка;
 	РемонтнаяКарта.РабочееМесто = Объект.РабочееМесто;
	РемонтнаяКарта.ПричинаРемонта = ПричиныРемонта.ПричинаРемонта;
	РемонтнаяКарта.Комментарий = ПричиныРемонта.Комментарий;
	РемонтнаяКарта.Записать(РежимЗаписиДокумента.Запись);	
	Исключение
	Сообщить(ОписаниеОшибки());
	Возврат(Неопределено);
	КонецПопытки;
Возврат(РемонтнаяКарта.Ссылка);
КонецФункции

&НаСервере
Функция ПолучитьСписокСпецификаций(БарКод)
СписокСпецификаций = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	БарКоды.Изделие,
	|	БарКоды.БарКод,
	|	БарКоды.Товар,
	|	БарКоды.Период,
	|	БарКоды.ПЗ
	|ИЗ
	|	РегистрСведений.БарКоды КАК БарКоды
	|ГДЕ
	|	БарКоды.БарКод = &БарКод";	
Запрос.УстановитьПараметр("БарКод", БарКод);	
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СписокСпецификаций.Добавить(ВыборкаДетальныеЗаписи.Изделие);
		КонецЦикла;
	Иначе
		Если СтрДлина(СокрЛП(БарКод)) = 18 Тогда
		КодТовара = Лев(БарКод,6);
		Иначе	
		КодТовара = Лев(БарКод,5);	
		КонецЕсли;
	Товар = Справочники.Товары.НайтиПоКоду(Число(КодТовара));
		Если Не Товар.Пустая() Тогда 
		Выборка = Справочники.Номенклатура.Выбрать(,,Новый Структура("Товар",Товар)); 
			Пока Выборка.Следующий() Цикл 
			СписокСпецификаций.Добавить(Выборка.Ссылка);
			КонецЦикла;				
		Иначе
		Сообщить("Товар не найден!");
		КонецЕсли; 
	КонецЕсли;
Возврат(СписокСпецификаций);
КонецФункции 

&НаКлиенте
Процедура ДилерскийРемонтПрибора(Команда)
БарКод = "";
	Если Не ВвестиСтроку(БарКод,"Введите бар-код прибора",18) Тогда
	Возврат;
	КонецЕсли;
СписокСпецификаций = Новый СписокЗначений;

СписокСпецификаций = ПолучитьСписокСпецификаций(БарКод);
	Если СписокСпецификаций.Количество() > 1 Тогда
	ВыбСпецификация = СписокСпецификаций.ВыбратьЭлемент("Выберите спецификацию для дилерского ремонта");
	ИначеЕсли СписокСпецификаций.Количество() = 0 Тогда
	Сообщить("Спецификация для выбранного товара не найдена!");
	Возврат;
	Иначе
	ВыбСпецификация = СписокСпецификаций[0];
	КонецЕсли;
Результат = ОткрытьФормуМодально("ОбщаяФорма.ВыборПричинРемонта",Новый Структура("РабочееМесто",Объект.РабочееМесто));
	Если Результат <> Неопределено Тогда
	Ремонт = ДилерскийРемонтПрибораНаСервере(БарКод,ВыбСпецификация.Значение,Результат);
		Если Ремонт <> Неопределено Тогда
		П = Новый Структура("Ключ",Ремонт);
		Оп = Новый ОписаниеОповещения("ОбновитьОтложенныеЗадания", ЭтотОбъект,Истина);
		ОткрытьФорму("Документ.РемонтнаяКарта.ФормаОбъекта",П,,,,,Оп,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ДилерскийРемонтПолуфабрикатаНаСервере(Линейка,Спецификация,ПричиныРемонта)
	Попытка
	РемонтнаяКарта = Документы.РемонтнаяКарта.СоздатьДокумент();
	РемонтнаяКарта.Дата = ТекущаяДата();
	РемонтнаяКарта.ДатаНачала = ТекущаяДата();	
	РемонтнаяКарта.Подразделение = Линейка.Подразделение;
	РемонтнаяКарта.УстановитьНовыйНомер("ДР"+Формат(РемонтнаяКарта.Дата,"ДФ=гг")+"-");
	РемонтнаяКарта.Автор = Объект.Исполнитель;	
	РемонтнаяКарта.Товар = Спецификация.Товар;
	РемонтнаяКарта.Изделие = Спецификация;
	РемонтнаяКарта.Количество = 1;	
	РемонтнаяКарта.ВидРемонта = Перечисления.ВидыРемонта.Дилерский;
	РемонтнаяКарта.Линейка = Линейка;
 	РемонтнаяКарта.РабочееМесто = Объект.РабочееМесто;
	РемонтнаяКарта.ПричинаРемонта = ПричиныРемонта.ПричинаРемонта;
	РемонтнаяКарта.Комментарий = ПричиныРемонта.Комментарий;
	РемонтнаяКарта.Записать(РежимЗаписиДокумента.Запись);
	Исключение
	Сообщить(ОписаниеОшибки());
	Возврат(Неопределено);
	КонецПопытки;
Возврат(РемонтнаяКарта.Ссылка);
КонецФункции

&НаКлиенте
Процедура ДилерскийРемонтПолуфабриката(Команда)
Перем ВыбЛинейка, ВыбСпецификация;

	Если Не ВвестиЗначение(ВыбЛинейка,"Выберите линейку производства",Новый ОписаниеТипов("СправочникСсылка.Линейки")) Тогда
	Возврат;
	КонецЕсли;
		Если Не ВвестиЗначение(ВыбСпецификация,"Выберите спецификацию",Новый ОписаниеТипов("СправочникСсылка.Номенклатура")) Тогда
		Возврат;
		КонецЕсли;
Результат = ОткрытьФормуМодально("ОбщаяФорма.ВыборПричинРемонта",Новый Структура("РабочееМесто",Объект.РабочееМесто));
	Если Результат <> Неопределено Тогда
	Ремонт = ДилерскийРемонтПолуфабрикатаНаСервере(ВыбЛинейка,ВыбСпецификация,Результат);
		Если Ремонт <> Неопределено Тогда
		П = Новый Структура("Ключ",Ремонт);	
		Оп = Новый ОписаниеОповещения("ОбновитьОтложенныеЗадания", ЭтотОбъект,Истина);
		ОткрытьФорму("Документ.РемонтнаяКарта.ФормаОбъекта",П,,,,,Оп,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура НайтиВДереве(КоллекцияСтрокДереваОдногоУровня,Код,Иден) 
    Для Каждого Стр Из КоллекцияСтрокДереваОдногоУровня Цикл
        Если СокрЛП(Стр.БарКод) = Код Тогда
       	Иден = Стр.ПолучитьИдентификатор();
        КонецЕсли;
    НайтиВДереве(Стр.ПолучитьЭлементы(),Код,Иден);
    КонецЦикла;   
КонецПроцедуры

&НаСервере
Функция НайтиПоКоду(Код)
Иден = Неопределено;
НайтиВДереве(ДеревоМПЗ.ПолучитьЭлементы(),Код,Иден);
Возврат(Иден);
КонецФункции

&НаКлиенте
Процедура НайтиПоБарКоду(Команда)
БарКод = "";
	Если ВвестиСтроку(БарКод,"Введите бар-код",18) Тогда
	Элементы.ДеревоМПЗ.ТекущаяСтрока = НайтиПоКоду(БарКод);	
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура НайтиПоКодуDanfoss(Команда)
КодDanfoss = "";
	Если ВвестиСтроку(КодDanfoss,"Введите код Danfoss",8) Тогда
	БарКод = ОбщийМодульВызовСервера.ПолучитьБарКодПоКодуDanfoss(СокрЛП(КодDanfoss));
		Если ЗначениеЗаполнено(БарКод) Тогда
		Элементы.ДеревоМПЗ.ТекущаяСтрока = НайтиПоКоду(БарКод);
		КонецЕсли; 
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьБарКодИзРемонта(Ремонт)
Возврат(СокрЛП(Ремонт.БарКод));
КонецФункции
           
&НаКлиенте
Процедура ПолучитьДанные(Ответ, Отказ) Экспорт
НачатьМониторингНаСервере();
РазвернутьДерево(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если ЭтаФорма.ВводДоступен() Тогда
   	Элементы.ДеревоМПЗ.ТекущаяСтрока = НайтиПоКоду(Данные);
		Если Элементы.ДеревоМПЗ.ТекущаяСтрока <> Неопределено Тогда
		П = Новый Структура("Ключ",Элементы.ДеревоМПЗ.ТекущиеДанные.РемонтнаяКарта);
		Оп = Новый ОписаниеОповещения("ПолучитьДанные",ЭтотОбъект,Истина);	
		ОткрытьФорму("Документ.РемонтнаяКарта.ФормаОбъекта",П,,,,,Оп,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
		ПолучитьЗадание(Неопределено,Данные);	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
