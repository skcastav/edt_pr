
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.Исполнитель = ПараметрыСеанса.Пользователь;
	Если Объект.Исполнитель.ЛинейкиПроизводства.Количество() > 0 Тогда
		Для каждого ТЧ Из Объект.Исполнитель.ЛинейкиПроизводства Цикл
			Если ТЧ.Линейка.ВидЛинейки = Перечисления.ВидыЛинеек.Канбан Тогда
			СписокЛинеек.Добавить(ТЧ.Линейка);
			КонецЕсли; 
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
Процедура СоздатьДеревоМПЗ(тДеревоМПЗ)
Запрос = Новый Запрос;
ЗапросМестаХранения = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РемонтЭлементыРемонта.НовыйЭлемент КАК НовыйЭлемент,
	|	РемонтЭлементыРемонта.Количество КАК Количество,
	|	РемонтЭлементыРемонта.Ссылка.Линейка КАК Линейка,
	|	РемонтЭлементыРемонта.Ссылка.ПроизводственноеЗадание КАК ДокументРемонта,
	|	РемонтЭлементыРемонта.НР,
	|	РемонтЭлементыРемонта.Ссылка,
	|	РемонтЭлементыРемонта.ВидНеисправности,
	|	РемонтЭлементыРемонта.ЗаменаЭлемента,
	|	РемонтЭлементыРемонта.Документ
	|ИЗ
	|	Справочник.Ремонт.ЭлементыРемонта КАК РемонтЭлементыРемонта
	|ГДЕ
	|	РемонтЭлементыРемонта.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И РемонтЭлементыРемонта.Ссылка.ВидРемонта = &ВидРемонта
	|	И РемонтЭлементыРемонта.Ссылка.Линейка В(&СписокЛинеек)
	|	И РемонтЭлементыРемонта.Ссылка.Статус = &Статус
	|ИТОГИ ПО
	|	Линейка,
	|	Ссылка";
Запрос.УстановитьПараметр("ВидРемонта",ВидРемонта);
Запрос.УстановитьПараметр("СписокЛинеек",СписокЛинеек);
Запрос.УстановитьПараметр("Статус",Перечисления.СтатусыРемонта.Отложен);
Результат = Запрос.Выполнить();
ВыборкаЛинейки = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаЛинейки.Следующий() Цикл
	СтрЛинейка = тДеревоМПЗ.Строки.Добавить();
	СтрЛинейка.Наименование = ВыборкаЛинейки.Линейка.Наименование;
	СтрЛинейка.Линейка = ВыборкаЛинейки.Линейка;
	ВыборкаРемонтнаяКарта = ВыборкаЛинейки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаРемонтнаяКарта.Следующий() Цикл
		СтрПЗ = СтрЛинейка.Строки.Добавить();
		СтрПЗ.Наименование = "Ремонтная карта по документу " + ВыборкаРемонтнаяКарта.ДокументРемонта;
		СтрПЗ.Линейка = ВыборкаЛинейки.Линейка;
		СтрПЗ.ДокументРемонта = ВыборкаРемонтнаяКарта.ДокументРемонта; 
		ВыборкаДетальныеЗаписи = ВыборкаРемонтнаяКарта.Выбрать();
		флНайденОтложенныйЭлементРемонта = Ложь;
		СписокМестХранения.Очистить();
			Если ТипЗнч(ВыборкаРемонтнаяКарта.ДокументРемонта) = Тип("ДокументСсылка.ПроизводственноеЗадание") Тогда
			ДатаЗапуска = ВыборкаРемонтнаяКарта.ДокументРемонта.ДатаЗапуска;
			Подразделение = ВыборкаЛинейки.Линейка.Подразделение;
			СписокМестХранения.Добавить(ВыборкаЛинейки.Линейка.МестоХраненияКанбанов);
			ИначеЕсли ТипЗнч(ВыборкаРемонтнаяКарта.ДокументРемонта) = Тип("ДокументСсылка.ВыпускПродукцииКанбан") Тогда
			ДатаЗапуска = ТекущаяДата();
			Подразделение = ВыборкаЛинейки.Линейка.Подразделение;
			СписокМестХранения.Добавить(ВыборкаЛинейки.Линейка.МестоХраненияКанбанов);
			Иначе	
			ДатаЗапуска = ТекущаяДата();
			Подразделение = ВыборкаРемонтнаяКарта.Ссылка.Изделие.Канбан.Подразделение;
			КонецЕсли;
		СписокМестХраненияДляМониторинга = ОбщийМодульВызовСервера.ПолучитьСписокМестХраненияДляМониторинга(Подразделение);
			Для каждого МестоХранения Из СписокМестХраненияДляМониторинга Цикл
				Если СписокМестХранения.НайтиПоЗначению(МестоХранения.Значение) = Неопределено Тогда
				СписокМестХранения.Добавить(МестоХранения.Значение);
				КонецЕсли;
			КонецЦикла;
		СписокМестХранения.Добавить(Подразделение.МестоХраненияПоУмолчанию);
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Если ВыборкаДетальныеЗаписи.ЗаменаЭлемента Тогда
					Если ВыборкаДетальныеЗаписи.Документ <> Неопределено Тогда
					Продолжить;				
					КонецЕсли; 
				флНайденОтложенныйЭлементРемонта = Истина;
					Если ТипЗнч(ВыборкаДетальныеЗаписи.НР) = Тип("СправочникСсылка.АналогиНормРасходов") Тогда
					НР = ВыборкаДетальныеЗаписи.НР.Владелец;
					Иначе
					НР = ВыборкаДетальныеЗаписи.НР;
					КонецЕсли; 
				СтрМПЗ = СтрПЗ.Строки.Добавить();
				СтрМПЗ.Наименование = НР.Наименование;
				СтрМПЗ.Линейка = ВыборкаЛинейки.Линейка;
				СтрМПЗ.ДокументРемонта = ВыборкаРемонтнаяКарта.ДокументРемонта; 
				СтрМПЗ.Ремонт = ВыборкаРемонтнаяКарта.Ссылка;
				СтрМПЗ.НРРемонта = ВыборкаДетальныеЗаписи.НР;
				СтрМПЗ.НР = НР;
				СтрМПЗ.ЕдиницаИзмерения = НР.Элемент.ЕдиницаИзмерения;
				СтрМПЗ.КоличествоТребуется = ПолучитьБазовоеКоличество(ВыборкаДетальныеЗаписи.Количество,НР.Элемент.ОсновнаяЕдиницаИзмерения);
				СтрМПЗ.КоличествоСклад = ОбщийМодульВызовСервера.ПолучитьСводныйОстатокПоМестамХранения(СписокМестХранения,НР.Элемент);
				СтрМПЗ.ВидНеисправности = ВыборкаДетальныеЗаписи.ВидНеисправности;
				ТаблицаАналогов = ОбщегоНазначенияПовтИсп.ПолучитьАналогиНормРасходов(НР,ДатаЗапуска,Истина);
					Для каждого ТЧ_ТА Из ТаблицаАналогов Цикл
					СтрМПЗ = СтрПЗ.Строки.Добавить();
					СтрМПЗ.Наименование = ТЧ_ТА.Ссылка.Наименование;
					СтрМПЗ.Линейка = ВыборкаЛинейки.Линейка;
					СтрМПЗ.ДокументРемонта = ВыборкаРемонтнаяКарта.ДокументРемонта;
					СтрМПЗ.Ремонт = ВыборкаРемонтнаяКарта.Ссылка;
					СтрМПЗ.НРРемонта = ВыборкаДетальныеЗаписи.НР;
					СтрМПЗ.НР = ТЧ_ТА.Ссылка;
					СтрМПЗ.ЕдиницаИзмерения = ТЧ_ТА.Элемент.ЕдиницаИзмерения;
					СтрМПЗ.КоличествоТребуется = ПолучитьБазовоеКоличество(ТЧ_ТА.Норма,ТЧ_ТА.Элемент.ОсновнаяЕдиницаИзмерения);
					СтрМПЗ.КоличествоСклад = ОбщийМодульВызовСервера.ПолучитьСводныйОстатокПоМестамХранения(СписокМестХранения,ТЧ_ТА.Элемент);
					СтрМПЗ.ВидНеисправности = ВыборкаДетальныеЗаписи.ВидНеисправности;
					СтрМПЗ.Аналог = Истина;
					КонецЦикла;		
				Иначе
				флНайденОтложенныйЭлементРемонта = Истина;
				СтрМПЗ = СтрПЗ.Строки.Добавить();
				СтрМПЗ.Наименование = ВыборкаДетальныеЗаписи.НР.Наименование;
				СтрМПЗ.Линейка = ВыборкаЛинейки.Линейка;
				СтрМПЗ.ДокументРемонта = ВыборкаРемонтнаяКарта.ДокументРемонта; 
				СтрМПЗ.Ремонт = ВыборкаРемонтнаяКарта.Ссылка;
				СтрМПЗ.НРРемонта = ВыборкаДетальныеЗаписи.НР;
				СтрМПЗ.НР = ВыборкаДетальныеЗаписи.НР;
				СтрМПЗ.ЕдиницаИзмерения = ВыборкаДетальныеЗаписи.НР.Элемент.ЕдиницаИзмерения;
				КонецЕсли; 
			КонецЦикла;
				Если Не флНайденОтложенныйЭлементРемонта Тогда
				СтрМПЗ = СтрПЗ.Строки.Добавить();
				СтрМПЗ.Наименование = "Нет отложенных элементов ремонта!";
				СтрМПЗ.Линейка = ВыборкаЛинейки.Линейка;
				СтрМПЗ.ДокументРемонта = ВыборкаРемонтнаяКарта.ДокументРемонта; 
				СтрМПЗ.Ремонт = ВыборкаРемонтнаяКарта.Ссылка;
				КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПолучитьПустыеОтложенныеРемонты()
Отложенные.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Ремонт.Ссылка,
	|	Ремонт.ДатаНачала
	|ИЗ
	|	Справочник.Ремонт КАК Ремонт
	|ГДЕ
	|	Ремонт.ПометкаУдаления = ЛОЖЬ
	|	И Ремонт.Статус = &Статус
	|	И Ремонт.ВидРемонта = &ВидРемонта
 	|   И Ремонт.Линейка В(&СписокЛинеек)";
Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО Ремонт.ПроизводственноеЗадание.НомерОчереди";
Запрос.УстановитьПараметр("Статус",Перечисления.СтатусыРемонта.Отложен);
Запрос.УстановитьПараметр("ВидРемонта",ВидРемонта);
Запрос.УстановитьПараметр("ПроизводственноеЗадание",Неопределено);
Запрос.УстановитьПараметр("СписокЛинеек",СписокЛинеек);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.Ссылка.ЭлементыРемонта.Количество() > 0 Тогда
		Продолжить;
		КонецЕсли; 
	ОтложенноеПЗ = Отложенные.Добавить();
	ОтложенноеПЗ.Линейка = ВыборкаДетальныеЗаписи.Ссылка.Линейка;
	ОтложенноеПЗ.Ремонт = ВыборкаДетальныеЗаписи.Ссылка;
	ОтложенноеПЗ.ДатаНачала = ВыборкаДетальныеЗаписи.ДатаНачала;
	КонецЦикла;
Отложенные.Сортировать("Линейка,ДатаНачала");
КонецПроцедуры

&НаСервере
Процедура НачатьМониторингНаСервере()
тДеревоМПЗ = РеквизитФормыВЗначение("ДеревоМПЗ");
тДеревоМПЗ.Строки.Очистить();
СоздатьДеревоМПЗ(тДеревоМПЗ);
ЗначениеВРеквизитФормы(тДеревоМПЗ, "ДеревоМПЗ");
ПолучитьПустыеОтложенныеРемонты(); 
КонецПроцедуры

&НаСервере
Функция ПолучитьЗаданиеНаСервере()
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Ремонт.Ссылка,
	|	Ремонт.ДатаНачала,
	|	Ремонт.Изделие
	|ИЗ
	|	Справочник.Ремонт КАК Ремонт
	|ГДЕ
	|	Ремонт.ПометкаУдаления = ЛОЖЬ
	|	И Ремонт.ВидРемонта = &ВидРемонта
	|	И Ремонт.Статус = &Статус";
	Если ВидРемонта = Перечисления.ВидыРемонта.БракКанбан Тогда
	Запрос.Текст = Запрос.Текст + " И Ремонт.Изделие.Канбан.Подразделение = &Подразделение";
	Запрос.УстановитьПараметр("Подразделение",СписокЛинеек[0].Значение.Подразделение);
	Иначе
	Запрос.Текст = Запрос.Текст + " И Ремонт.Линейка В(&СписокЛинеек)";
	Запрос.УстановитьПараметр("СписокЛинеек",СписокЛинеек);
	КонецЕсли;
Запрос.УстановитьПараметр("ВидРемонта",ВидРемонта);
Запрос.УстановитьПараметр("Статус",Перечисления.СтатусыРемонта.Ремонт);
Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО Ремонт.ДатаНачала";
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Ремонт = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
	Ремонт.Исполнитель = Объект.Исполнитель;
	Ремонт.Записать();
	Возврат(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
Возврат(Неопределено);
КонецФункции

&НаКлиенте
Процедура ПолучитьЗадание(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	РемонтСсылка = ПолучитьЗаданиеНаСервере();
		Если РемонтСсылка <> Неопределено Тогда
		П = Новый Структура("Ключ",РемонтСсылка);
		Оп = Новый ОписаниеОповещения("ОбновитьОтложенныеЗадания", ЭтотОбъект,Истина);
		ОткрытьФорму("Справочник.Ремонт.ФормаОбъекта",П,,,,,Оп,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
		Предупреждение("Нет заданий на ремонт!");
		КонецЕсли;
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
Процедура ВидРемонтаПриИзменении(Элемент)
НачатьМониторингНаСервере();
РазвернутьДерево(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
НачатьМониторингНаСервере();
РазвернутьДерево(Неопределено);
КонецПроцедуры 

&НаСервере
Функция ДобавитьЗаменуВРемонтНаСервере(Ремонт,НР,НовыйЭлемент,БракПоставщика,Документ)
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	флЗаменён = Ложь;
	РемонтОбъект = Ремонт.ПолучитьОбъект();
		Для каждого ТЧ Из РемонтОбъект.ЭлементыРемонта Цикл
			Если ТЧ.ЗаменаЭлемента Тогда
				Если ТЧ.НР = НР Тогда
				ТЧ.НовыйЭлемент = НовыйЭлемент;
				ТЧ.Документ = Документ;
				флЗаменён = Истина;	
				Прервать;		
				КонецЕсли; 
			КонецЕсли; 		
		КонецЦикла; 
			Если Не флЗаменён Тогда
			Сообщить("Элемент не найден в карточке ремонта!");
			ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
			Возврат(Ложь);
			КонецЕсли;
	РемонтОбъект.Записать();
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Возврат(Истина);
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат(Ложь);
	КонецПопытки;
КонецФункции

&НаКлиенте
Процедура ДеревоМПЗВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.ДеревоМПЗ.ТекущаяСтрока = Неопределено Тогда
	Сообщить("Выберите МПЗ замены!");
	Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(Элементы.ДеревоМПЗ.ТекущиеДанные.НР) Тогда	
		Если Найти(Элементы.ДеревоМПЗ.ТекущиеДанные.Наименование,"Нет ") = 0 Тогда	
		Возврат;
		КонецЕсли;	
	КонецЕсли;
		Если Элементы.ДеревоМПЗ.ТекущиеДанные.КоличествоТребуется = 0 Тогда
		П = Новый Структура("Ключ",Элементы.ДеревоМПЗ.ТекущиеДанные.Ремонт);
		Оп = Новый ОписаниеОповещения("ОбновитьОтложенныеЗадания", ЭтотОбъект,Истина);
		ОткрытьФорму("Справочник.Ремонт.ФормаОбъекта",П,,,,,Оп,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);		
		Возврат;
		ИначеЕсли Элементы.ДеревоМПЗ.ТекущиеДанные.КоличествоТребуется > Элементы.ДеревоМПЗ.ТекущиеДанные.КоличествоСклад Тогда
		П = Новый Структура("Ключ",Элементы.ДеревоМПЗ.ТекущиеДанные.Ремонт);
		Оп = Новый ОписаниеОповещения("ОбновитьОтложенныеЗадания", ЭтотОбъект,Истина);
		ОткрытьФорму("Справочник.Ремонт.ФормаОбъекта",П,,,,,Оп,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Возврат;
		КонецЕсли; 
Результат = ОткрытьФормуМодально("ОбщаяФорма.ЗаменаЭлементаПриРемонте",Новый Структура("Ссылка,НормаРасходов,ВидНеисправности,Количество",Элементы.ДеревоМПЗ.ТекущиеДанные.Ремонт,Элементы.ДеревоМПЗ.ТекущиеДанные.НР,Элементы.ДеревоМПЗ.ТекущиеДанные.ВидНеисправности,Элементы.ДеревоМПЗ.ТекущиеДанные.КоличествоТребуется));
	Если Результат <> Неопределено Тогда
		Если Результат.Документ <> Неопределено Тогда
			Если ДобавитьЗаменуВРемонтНаСервере(Элементы.ДеревоМПЗ.ТекущиеДанные.Ремонт,Элементы.ДеревоМПЗ.ТекущиеДанные.НР,Результат.НовыйЭлемент,Результат.БракПоставщика,Результат.Документ) Тогда
			П = Новый Структура("Ключ",Элементы.ДеревоМПЗ.ТекущиеДанные.Ремонт);
			Оп = Новый ОписаниеОповещения("ОбновитьОтложенныеЗадания", ЭтотОбъект,Истина);
			ОткрытьФорму("Справочник.Ремонт.ФормаОбъекта",П,,,,,Оп,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);		
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ОтложенныеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
П = Новый Структура("Ключ",Элементы.Отложенные.ТекущиеДанные.Ремонт);
Оп = Новый ОписаниеОповещения("ОбновитьОтложенныеЗадания", ЭтотОбъект,Истина);
ОткрытьФорму("Справочник.Ремонт.ФормаОбъекта",П,,,,,Оп,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры
