
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.Период.ДатаНачала = НачалоМесяца(ТекущаяДата());
Объект.Период.ДатаОкончания = ТекущаяДата();
КонецПроцедуры

&НаСервере
Функция ИмеетНестандартныеДетали(Спецификация,Результат)
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н(Спецификация,ТекущаяДата());
	Пока ВыборкаНР.Следующий() Цикл
		Если ЗначениеЗаполнено(ВыборкаНР.Элемент.Канбан) Тогда
			Если ВыборкаНР.Элемент.Канбан.Служебный Тогда
            Результат = Истина;
			Результат = ИмеетНестандартныеДетали(ВыборкаНР.Элемент,Результат);
			КонецЕсли;
		Иначе
		Результат = ИмеетНестандартныеДетали(ВыборкаНР.Элемент,Результат);		
		КонецЕсли; 
	КонецЦикла;
Возврат(Результат);
КонецФункции 

&НаСервере
Функция ИмеетПодчиненныеДокументы(МТК)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	МаршрутнаяКарта.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
	|ГДЕ
	|	МаршрутнаяКарта.ДокументОснование = &ДокументОснование";
Запрос.УстановитьПараметр("ДокументОснование", МТК);	
РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ДвижениеМПЗ.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ДвижениеМПЗ КАК ДвижениеМПЗ
		|ГДЕ
		|	ДвижениеМПЗ.ДокументОснование = &ДокументОснование";
	Запрос.УстановитьПараметр("ДокументОснование", МТК);	
	РезультатЗапроса = Запрос.Выполнить();	
	Возврат(Не РезультатЗапроса.Пустой());
	Иначе	
	Возврат(Истина);
	КонецЕсли; 
КонецФункции 

&НаСервере
Функция ПолучитьКоличествоКПеремещению(Номенклатура,Требуется)
Выборка = ТаблицаОстатков.НайтиСтроки(Новый Структура("Номенклатура",Номенклатура));
	Если Выборка.Количество() > 0 Тогда
	Количество = Выборка[0].Количество;
		Если Количество > Требуется Тогда
		Выборка[0].Количество = Количество - Требуется;
		Возврат(Требуется);
		Иначе	
		Выборка[0].Количество = 0;
		Возврат(Количество);		
		КонецЕсли;	
	Иначе
	Возврат(0);
	КонецЕсли; 
КонецФункции 

&НаСервере
Процедура ДобавитьПодчиненныеДетали(Стр,Номенклатура,Норма)
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н(Номенклатура,ТекущаяДата());
	Пока ВыборкаНР.Следующий() Цикл
	КоличествоСоздать = ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*Стр.КоличествоСоздать*Норма;
		Если ЗначениеЗаполнено(ВыборкаНР.Элемент.Канбан) Тогда
			Если ВыборкаНР.Элемент.Канбан.Служебный Тогда
			СтрПодч = Стр.Строки.Добавить();
			СтрПодч.Уровень = Стр.Уровень+1;
			СтрПодч.Номенклатура = ВыборкаНР.Элемент;
			СтрПодч.Линейка = ПолучитьЛинейкуКанбана(Стр.Линейка,СтрПодч.Номенклатура.Канбан);
			СтрПодч.Количество = ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*Стр.Количество*Норма;
				Если КоличествоСоздать > 0 Тогда
				СтрПодч.КоличествоКПеремещению = ПолучитьКоличествоКПеремещению(ВыборкаНР.Элемент,КоличествоСоздать);
				СтрПодч.КоличествоСоздать = КоличествоСоздать - СтрПодч.КоличествоКПеремещению;
				КонецЕсли;
			ДобавитьПодчиненныеДетали(СтрПодч,ВыборкаНР.Элемент,ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*Норма);
			КонецЕсли;
		Иначе
		ДобавитьПодчиненныеДетали(Стр,ВыборкаНР.Элемент,ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*Норма);		
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокНоменклатурыНаСервере()
тДерево = РеквизитФормыВЗначение("ДеревоНоменклатуры");
тДерево.Строки.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаршрутнаяКарта.Ссылка КАК Ссылка,
	|	МаршрутнаяКарта.Номенклатура КАК Номенклатура,
	|	МаршрутнаяКарта.Количество КАК Количество
	|ИЗ
	|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
	|ГДЕ
	|	(МаршрутнаяКарта.Статус = 0
	|			ИЛИ МаршрутнаяКарта.Статус = 2)
	|	И МаршрутнаяКарта.Подразделение В(&СписокПодразделений)
	|	И МаршрутнаяКарта.Дата МЕЖДУ &ДатаНач И &ДатаКон";
	Если СписокЛинеек.Количество() > 0 Тогда
	Запрос.Текст = Запрос.Текст + " И МаршрутнаяКарта.Линейка В(&СписокЛинеек)";
	Запрос.УстановитьПараметр("СписокЛинеек",СписокЛинеек);
	КонецЕсли; 
Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО МаршрутнаяКарта.НомерОчереди,МаршрутнаяКарта.Дата";
Запрос.УстановитьПараметр("СписокПодразделений",СписокПодразделений);
Запрос.УстановитьПараметр("ДатаНач",НачалоДня(Объект.Период.ДатаНачала));
Запрос.УстановитьПараметр("ДатаКон",КонецДня(Объект.Период.ДатаОкончания));
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ИмеетНестандартныеДетали(ВыборкаДетальныеЗаписи.Номенклатура,Ложь) Тогда
			Если ИмеетПодчиненныеДокументы(ВыборкаДетальныеЗаписи.Ссылка) Тогда
			Продолжить;
			КонецЕсли; 
		Стр = тДерево.Строки.Добавить();
		Стр.МТК = ВыборкаДетальныеЗаписи.Ссылка;
		Стр.Статус = Стр.МТК.Статус;
		Стр.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
		Стр.Линейка = Стр.МТК.Линейка;
		Стр.Уровень = 0;
		Стр.Количество = ВыборкаДетальныеЗаписи.Количество;
		Стр.КоличествоСоздать = Стр.Количество;
		ДобавитьПодчиненныеДетали(Стр,Стр.Номенклатура,1);		
		КонецЕсли; 
	КонецЦикла;
ЗначениеВРеквизитФормы(тДерево, "ДеревоНоменклатуры");
КонецПроцедуры

&НаСервере
Процедура ПолучитьТаблицуОстатков()
ТаблицаОстатков.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаХраненияОстатки.МПЗ КАК Номенклатура,
	|	МестаХраненияОстатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.МестаХранения.Остатки(&НаДату, МестоХранения = &МестоХранения) КАК МестаХраненияОстатки";
Запрос.УстановитьПараметр("НаДату", ТекущаяДата());
Запрос.УстановитьПараметр("МестоХранения", МестоХранения);
РезультатЗапроса = Запрос.Выполнить();
Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
	ТЧ = ТаблицаОстатков.Добавить();
	ТЧ.Номенклатура = Выборка.Номенклатура;
	ТЧ.Количество = Выборка.Количество;
	КонецЦикла;
КонецПроцедуры 

&НаКлиенте
Процедура ПолучитьСписокНоменклатуры(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	ПолучитьТаблицуОстатков();
	ПолучитьСписокНоменклатурыНаСервере();
	РазвернутьДерево(Неопределено);
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПолучитьЛинейкуКанбана(Линейка,ВидКанбана)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЛинейкиЛинейкиПотребители.Ссылка
	|ИЗ
	|	Справочник.Линейки.ЛинейкиПотребители КАК ЛинейкиЛинейкиПотребители
	|ГДЕ
	|	ЛинейкиЛинейкиПотребители.Линейка = &Линейка
	|	И ЛинейкиЛинейкиПотребители.Ссылка.ПометкаУдаления = ЛОЖЬ";
Запрос.УстановитьПараметр("Линейка", Линейка);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныхЗаписей = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
		Если ВыборкаДетальныхЗаписей.Ссылка.ВидыКанбанов.Найти(ВидКанбана,"ВидКанбана") <> Неопределено Тогда
		Возврат(ВыборкаДетальныхЗаписей.Ссылка);
		КонецЕсли;
	КонецЦикла; 
Возврат(Неопределено);
КонецФункции

&НаСервере
Функция СоздатьПеремещение(МТК,Номенклатура,Количество,ВозвратнаяТара)
	Попытка
	Перемещение = Документы.ДвижениеМПЗ.СоздатьДокумент();
	Перемещение.Дата = ТекущаяДата();
	Перемещение.УстановитьНовыйНомер(ПрисвоитьПрефикс(МестоХранения.Подразделение));
	Перемещение.Автор = ПараметрыСеанса.Пользователь;
	Перемещение.ДокументОснование = МТК;
	Перемещение.Подразделение = МестоХранения.Подразделение;
	Перемещение.МестоХранения = МестоХранения;
	Перемещение.МестоХраненияВ = МТК.Линейка.МестоХраненияКанбанов; 
	Перемещение.ВозвратнаяТара = ВозвратнаяТара;
	Перемещение.Комментарий = "Перемещение со склада невостребованных п.ф.";
	ТЧ_П = Перемещение.ТабличнаяЧасть.Добавить();
	ТЧ_П.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;
	ТЧ_П.МПЗ = Номенклатура;
	ТЧ_П.Количество = Количество/Номенклатура.ОсновнаяЕдиницаИзмерения.Коэффициент;
	ТЧ_П.ЕдиницаИзмерения = Номенклатура.ОсновнаяЕдиницаИзмерения;	
	Перемещение.Записать(РежимЗаписиДокумента.Проведение);
	Возврат(Перемещение.Ссылка);
	Исключение
	Сообщить(ОписаниеОшибки());
	Возврат(Документы.ДвижениеМПЗ.ПустаяСсылка());
	КонецПопытки;
КонецФункции 

&НаСервере
Процедура СоздатьПодчиненнуюМТК(тДерево,Результат)
   	Для Каждого тСтр Из тДерево.Строки Цикл
	тСтр.Комментарий = "";
		Если Не Результат Тогда
		Возврат;
		КонецЕсли; 
			Если тСтр.КоличествоСоздать > 0 Тогда
			ЛинейкаКанбана = ПолучитьЛинейкуКанбана(тДерево.МТК.Линейка,тСтр.Номенклатура.Канбан);
				Если ЛинейкаКанбана <> Неопределено Тогда
				тСтр.МТК = ОбщийМодульСозданиеДокументов.СоздатьМТККанбан(ЛинейкаКанбана,тДерево.МТК.Линейка.МестоХраненияКанбанов,1,тСтр.Номенклатура,тСтр.КоличествоСоздать,Ложь,тДерево.МТК);
					Если тСтр.МТК.Пустая() Тогда
					Результат = Ложь;
					тСтр.Комментарий = "МТК не создана";
					Возврат;
					КонецЕсли; 
				Иначе
				тСтр.Комментарий = "не найдена линейка-поставщик канбана для "+тДерево.МТК.Линейка;
				Результат = Ложь;
				Возврат;
				КонецЕсли;
			КонецЕсли;
				Если тСтр.КоличествоКПеремещению > 0 Тогда
					Если ЗначениеЗаполнено(тСтр.ВозвратнаяТара) Тогда
					тСтр.ДвижениеМПЗ = СоздатьПеремещение(тДерево.МТК,тСтр.Номенклатура,тСтр.КоличествоКПеремещению,тСтр.ВозвратнаяТара);
						Если тСтр.ДвижениеМПЗ.Пустая() Тогда
						Результат = Ложь;
						тСтр.Комментарий = "Движение МПЗ не создано";
						Возврат;
						КонецЕсли;
					Иначе	
					тСтр.Комментарий = "не задана возвратная тара";
					Результат = Ложь;
					Возврат;						
					КонецЕсли; 
				КонецЕсли; 
	СоздатьПодчиненнуюМТК(тСтр,Результат);
   	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОчиститьСсылкиНаДокументы(тДерево)
   	Для Каждого тСтр Из тДерево.Строки Цикл
		Если тСтр.Уровень > 0 Тогда
		тСтр.МТК = Документы.МаршрутнаяКарта.ПустаяСсылка();
		тСтр.ДвижениеМПЗ = Документы.ДвижениеМПЗ.ПустаяСсылка();		
		КонецЕсли;  
	ОчиститьСсылкиНаДокументы(тСтр);
   	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СоздатьПодчиненныеМТКНаСервере()
тДерево = РеквизитФормыВЗначение("ДеревоНоменклатуры");
   	Для Каждого тСтр Из тДерево.Строки Цикл
		Если Не тСтр.Обработано Тогда
			Попытка
			НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
			Результат = Истина;
			СоздатьПодчиненнуюМТК(тСтр,Результат);
				Если Результат Тогда
				ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
				тСтр.Обработано = Истина;
				Иначе
				ОчиститьСсылкиНаДокументы(тСтр);
				ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);	
				КонецЕсли; 
			Исключение
			ОчиститьСсылкиНаДокументы(тСтр);
			Сообщить(ОписаниеОшибки());
			ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);	
			КонецПопытки;
		КонецЕсли;
   	КонецЦикла;
ЗначениеВРеквизитФормы(тДерево, "ДеревоНоменклатуры");		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПодчиненныеМТК(Команда)
СоздатьПодчиненныеМТКНаСервере();
РазвернутьДерево(Неопределено); 
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНоменклатурыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
ТекФорма = ПолучитьФорму("Справочник.Номенклатура.ФормаСписка");
ТекФорма.Открыть();
ТекФорма.Элементы.Список.ТекущаяСтрока = Элементы.ТаблицаНоменклатуры.ТекущиеДанные.Номенклатура;
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево(Команда)
тЭлементы = ДеревоНоменклатуры.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл
   Элементы.ДеревоНоменклатуры.Развернуть(тСтр.ПолучитьИдентификатор(), Истина);
   КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СвернутьДерево(Команда)
тЭлементы = ДеревоНоменклатуры.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл
   Элементы.ДеревоНоменклатуры.Свернуть(тСтр.ПолучитьИдентификатор());
   КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ВыбратьВсеПодчиненныеНаСервере(тДерево)
   	Для Каждого тСтр Из тДерево.Строки Цикл
		Если тСтр.МТК.Пустая() Тогда
   		тСтр.Пометка = Истина;
		КонецЕсли; 
	ВыбратьВсеПодчиненныеНаСервере(тСтр);
   	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ВыбратьВсеНаСервере()
тДерево = РеквизитФормыВЗначение("ДеревоНоменклатуры");
   	Для Каждого тСтр Из тДерево.Строки Цикл
	ВыбратьВсеПодчиненныеНаСервере(тСтр);
   	КонецЦикла;
ЗначениеВРеквизитФормы(тДерево, "ДеревоНоменклатуры");
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
ВыбратьВсеНаСервере();
РазвернутьДерево(Неопределено);
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
тДерево = РеквизитФормыВЗначение("ДеревоНоменклатуры");
   	Для Каждого тСтр Из тДерево.Строки Цикл
	ОтменитьВсеПодчиненныеНаСервере(тСтр);
   	КонецЦикла;
ЗначениеВРеквизитФормы(тДерево, "ДеревоНоменклатуры");
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе(Команда)
ОтменитьВсеНаСервере();
РазвернутьДерево(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоНоменклатурыКоличествоКПеремещениюПриИзменении(Элемент)
Элементы.ДеревоНоменклатуры.ТекущиеДанные.КоличествоСоздать = Элементы.ДеревоНоменклатуры.ТекущиеДанные.Количество - Элементы.ДеревоНоменклатуры.ТекущиеДанные.КоличествоКПеремещению;
КонецПроцедуры

&НаСервере
Процедура ВывестиНоменклатуру(тДерево,ТабДок)
ОбъектЗн = РеквизитФормыВЗначение("Объект");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблНоменклатура = Макет.ПолучитьОбласть("Номенклатура");

   	Для Каждого тСтр Из тДерево.Строки Цикл
		Если тСтр.КоличествоКПеремещению > 0 Тогда
		ОблНоменклатура.Параметры.Наименование = СокрЛП(тСтр.Номенклатура.Наименование);
		ОблНоменклатура.Параметры.Номенклатура = тСтр.Номенклатура;
		ОблНоменклатура.Параметры.Линейка = тДерево.Линейка;
		ОблНоменклатура.Параметры.Количество = тСтр.КоличествоКПеремещению;
		ТабДок.Вывести(ОблНоменклатура);
		КонецЕсли;  
	ВывестиНоменклатуру(тСтр,ТабДок);
   	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПечатьНаСервере(ТабДок)
ОбъектЗн = РеквизитФормыВЗначение("Объект");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ТабДок.Вывести(ОблШапка);
тДерево = РеквизитФормыВЗначение("ДеревоНоменклатуры");
   	Для Каждого тСтр Из тДерево.Строки Цикл
	ВывестиНоменклатуру(тСтр,ТабДок); 
   	КонецЦикла;
ТабДок.Вывести(ОблКонец);
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
ТабДок = Новый ТабличныйДокумент;

ПечатьНаСервере(ТабДок);
ТабДок.Показать("Список перемещаемых полуфабрикатов");
КонецПроцедуры
