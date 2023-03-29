
Процедура СоздатьТаблицуМПЗ(ТаблицаМПЗ,ДокументОснование)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтруктураПодчиненности.Ссылка
	|ИЗ
	|	КритерийОтбора.ПодчиненныеДокументы(&ЗначениеКритерияОтбора) КАК СтруктураПодчиненности
	|ГДЕ
	|	СтруктураПодчиненности.Ссылка.ПометкаУдаления = ЛОЖЬ";
Запрос.УстановитьПараметр("ЗначениеКритерияОтбора", ДокументОснование);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.Ссылка = Ссылка Тогда
		Продолжить;
		КонецЕсли; 
			Если ТипЗнч(ВыборкаДетальныеЗаписи.Ссылка) = Тип("ДокументСсылка.ПоступлениеМПЗ") Тогда
				Для каждого ТЧ Из ВыборкаДетальныеЗаписи.Ссылка.ТабличнаяЧасть Цикл
				ТЧ_П = ТаблицаМПЗ.Добавить();
				ТЧ_П.МПЗ = ТЧ.МПЗ;
				ТЧ_П.Количество = ТЧ.Количество; 		
				КонецЦикла;	
			КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)Экспорт
Автор = ПараметрыСеанса.Пользователь;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда	
	ДокументОснование = ДанныеЗаполнения.Ссылка;
	Контрагент = ДанныеЗаполнения.Контрагент;
	Договор = ДанныеЗаполнения.Договор;
	Курс = ДанныеЗаполнения.Курс;

	Запрос = Новый Запрос;

	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказыПоставщикамОстатки.МПЗ,
		|	ЗаказыПоставщикамОстатки.КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.ЗаказыПоставщикам.Остатки(&НаДату, ) КАК ЗаказыПоставщикамОстатки
		|ГДЕ
		|	ЗаказыПоставщикамОстатки.ЗаказПоставщику = &ЗаказПоставщику";
	Запрос.УстановитьПараметр("ЗаказПоставщику", ДанныеЗаполнения.Ссылка);
	Запрос.УстановитьПараметр("НаДату", ТекущаяДата());
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
		Для Каждого ТекСтрокаТабличнаяЧасть Из ДанныеЗаполнения.ТабличнаяЧасть Цикл	
		ВыборкаДетальныеЗаписи.Сбросить();
			Если ВыборкаДетальныеЗаписи.НайтиСледующий(Новый Структура("МПЗ",ТекСтрокаТабличнаяЧасть.МПЗ)) Тогда
			НоваяСтрока = ТабличнаяЧасть.Добавить();
			НоваяСтрока.ВидМПЗ = ТекСтрокаТабличнаяЧасть.ВидМПЗ;
			НоваяСтрока.МПЗ = ТекСтрокаТабличнаяЧасть.МПЗ;
			НоваяСтрока.ЕдиницаИзмерения = ТекСтрокаТабличнаяЧасть.ЕдиницаИзмерения;
			НоваяСтрока.НЦ = ТекСтрокаТабличнаяЧасть.НЦ;
			НоваяСтрока.Количество = ВыборкаДетальныеЗаписи.КоличествоОстаток/ТекСтрокаТабличнаяЧасть.ЕдиницаИзмерения.Коэффициент;
			НоваяСтрока.ЦенаВалюта = ТекСтрокаТабличнаяЧасть.ЦенаВалюта;
			НоваяСтрока.СуммаВалюта = ТекСтрокаТабличнаяЧасть.ЦенаВалюта*НоваяСтрока.Количество;
			НоваяСтрока.ВсегоВалюта = ТекСтрокаТабличнаяЧасть.ЦенаВалюта*НоваяСтрока.Количество;		
			НоваяСтрока.Цена = ТекСтрокаТабличнаяЧасть.Цена;
			НоваяСтрока.Сумма = ТекСтрокаТабличнаяЧасть.Цена*НоваяСтрока.Количество;
				Если Не Договор.БезНДС Тогда
				НоваяСтрока.СтавкаНДС = ТекСтрокаТабличнаяЧасть.СтавкаНДС;
				НоваяСтрока.НДС = НоваяСтрока.Сумма*НоваяСтрока.СтавкаНДС.Ставка/100;
				НоваяСтрока.Всего = НоваяСтрока.Сумма + НоваяСтрока.НДС;				
				Иначе
				НоваяСтрока.Всего = НоваяСтрока.Сумма; 	
				КонецЕсли; 
			КонецЕсли;  
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Реализация") Тогда	
	ДокументОснование = ДанныеЗаполнения.Ссылка;
	Контрагент = ДанныеЗаполнения.Контрагент;
	Договор = ДанныеЗаполнения.Договор;
	МестоХранения = ДанныеЗаполнения.МестоХранения;
	Курс = 1;
	ТаблицаМПЗ = Новый ТаблицаЗначений;

	ТаблицаМПЗ.Колонки.Добавить("МПЗ");
	ТаблицаМПЗ.Колонки.Добавить("Количество");
	СоздатьТаблицуМПЗ(ТаблицаМПЗ,ДанныеЗаполнения.Ссылка);
	ТаблицаМПЗ.Свернуть("МПЗ","Количество");
		Для Каждого ТЧ Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
		Выборка = ТаблицаМПЗ.Найти(ТЧ.Товар,"МПЗ");
			Если Выборка <> Неопределено Тогда
			Кол = ТЧ.Количество - Выборка.Количество;
			Иначе	
			Кол = ТЧ.Количество;
			КонецЕсли; 
				Если Кол > 0 Тогда
				НоваяСтрока = ТабличнаяЧасть.Добавить();
				НоваяСтрока.ВидМПЗ = ТЧ.ВидТовара;
				НоваяСтрока.МПЗ = ТЧ.Товар;
				НоваяСтрока.ЕдиницаИзмерения = ТЧ.ЕдиницаИзмерения;
				НоваяСтрока.Количество = Кол;		
				НоваяСтрока.Цена = ТЧ.Цена;
				НоваяСтрока.Сумма = ТЧ.Сумма;
				НоваяСтрока.СтавкаНДС = ТЧ.СтавкаНДС;
				НоваяСтрока.НДС = ТЧ.НДС;
				НоваяСтрока.Всего = ТЧ.Всего;		
				КонецЕсли; 
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Номер = "" Тогда
	УстановитьНовыйНомер(ПрисвоитьПрефикс(Подразделение,Дата));
	КонецЕсли;
КонецПроцедуры

Функция ВыгрузитьВБазуСбыта()
БазаСбыта = ОбщийМодульСинхронизации.УстановитьCOMСоединение(Константы.БазаДанных1ССбыт.Получить());
	Если БазаСбыта = Неопределено Тогда
	Сообщить("Не открыто соединение с базой сбыта!");
	Возврат(Ложь);
	КонецЕсли;
флОшибки = Ложь;
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	бсСклад = БазаСбыта.Справочники.Склады.НайтиПоНаименованию("СД 423",Истина);
		Если Найти(Контрагент.ИНН,"\") > 0 Тогда
		ИНН = Лев(Контрагент.ИНН,Найти(Контрагент.ИНН,"\")-1);
		ИначеЕсли Найти(Контрагент.ИНН,"/") > 0 Тогда
		ИНН = Лев(Контрагент.ИНН,Найти(Контрагент.ИНН,"/")-1);			
		Иначе
		ИНН = СокрЛП(Контрагент.ИНН);
		КонецЕсли; 
	бсКонтрагент = БазаСбыта.Справочники.Контрагенты.НайтиПоРеквизиту("ИНН",ИНН);
		Если бсКонтрагент.Пустая() Тогда
		Сообщить(СокрЛП(Контрагент.Наименование) + " (ИНН: " + ИНН + ") - контрагент не найден в базе сбыта!");
		ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
		Возврат(Ложь);
		КонецЕсли;
			Если бсКонтрагент.Партнер.Пустая() Тогда
			Сообщить(СокрЛП(Контрагент.Наименование) + " (ИНН: " + ИНН + ") - контрагент не привязан к справочнику Партнеры в базе сбыта!");
			ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
			Возврат(Ложь);
			КонецЕсли;  

	бсНовДок = БазаСбыта.Документы.ПоступлениеТоваровУслуг.СоздатьДокумент();
	бсНовДок.Дата = Дата;
	//бсНовДок.УстановитьНовыйНомер("ПБ-");
	бсНовДок.Организация = БазаСбыта.Справочники.Организации.НайтиПоКоду("02");
	бсНовДок.Партнер = бсКонтрагент.Партнер;
	бсНовДок.Склад = бсСклад;
	бсНовДок.ХозяйственнаяОперация = БазаСбыта.Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
	бсНовДок.НалогообложениеНДС = БазаСбыта.Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	бсНовДок.БанковскийСчетОрганизации = БазаСбыта.ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(бсНовДок.Организация);
	бсНовДок.Валюта = БазаСбыта.Справочники.Валюты.НайтиПоКоду("643");
	бсНовДок.ВалютаВзаиморасчетов = БазаСбыта.Справочники.Валюты.НайтиПоКоду("643");
		Для каждого ТЧ_МПЗ Из ТабличнаяЧасть Цикл
			Если ТЧ_МПЗ.МПЗ.Товар.Пустая() Тогда
			флОшибки = Истина;
			Сообщить(СокрЛП(ТЧ_МПЗ.МПЗ.Наименование)+" - не заполнен реквизит соответствия с товаром!");
			Продолжить;				
			КонецЕсли; 
		Артикул = ОбщийМодульВызовСервера.ПолучитьАртикулПоКодуТовара(ТЧ_МПЗ.МПЗ.Товар.Код);
		бсНомен = БазаСбыта.Справочники.Номенклатура.НайтиПоРеквизиту("Артикул",Артикул);
			Если бсНомен.Пустая() Тогда
			флОшибки = Истина;
			Сообщить(СокрЛП(ТЧ_МПЗ.МПЗ.Наименование)+" - товар с артикулом "+Артикул+" не найден в торговой базе!");
			Продолжить;
			КонецЕсли;
		ТЧ = бсНовДок.Товары.Добавить();
			Если Не ТЧ_МПЗ.ГТД.Пустая() Тогда
			бсНомерГТД = БазаСбыта.Справочники.НомераГТД.НайтиПоКоду(ТЧ_МПЗ.ГТД.Наименование);
				Если бсНомерГТД.Пустая() Тогда	
				бсНомерГТД = БазаСбыта.Справочники.НомераГТД.СоздатьЭлемент();
				бсНомерГТД.Код = ТЧ_МПЗ.ГТД.Наименование;
				//Страна = БазаСбыта.Справочники.СтраныМира.ПустаяСсылка();
				//ВыборкаСтрана = БазаСбыта.Справочники.СтраныМира.Выбрать(,,Новый Структура("Код",ТЧ_МПЗ.ГТД.Страна.Код));
				//	Пока ВыборкаСтрана.Следующий() Цикл
				//		Если ВыборкаСтрана.ПометкаУдаления = Ложь Тогда
				//		Страна = ВыборкаСтрана.Ссылка;
				//		Прервать;
				//		КонецЕсли; 
				//	КонецЦикла; 
				бсНомерГТД.СтранаПроисхождения = БазаСбыта.Справочники.СтраныМира.НайтиПоКоду(ТЧ_МПЗ.ГТД.Страна.Код);
				бсНомерГТД.Записать();
				КонецЕсли;
			ТЧ.НомерГТД = бсНомерГТД.Ссылка;
			КонецЕсли; 
		БазовоеКоличество = ПолучитьБазовоеКоличество(ТЧ_МПЗ.Количество,ТЧ_МПЗ.ЕдиницаИзмерения); 
		Выборка =  бсНовДок.Товары.Найти(бсНомен,"Номенклатура");
		ТЧ.Склад = бсСклад;	
		ТЧ.Номенклатура = бсНомен;
		ТЧ.КоличествоУпаковок = БазовоеКоличество;
		//ТЧ.ИмКоличествоЗарегистрировано = БазовоеКоличество;
		ТЧ.Количество = БазовоеКоличество;
		ТЧ.СтавкаНДС = бсНомен.СтавкаНДС;
		ТЧ.Цена = ТЧ_МПЗ.Цена;
		ТЧ.Сумма = ТЧ.КоличествоУпаковок*ТЧ.Цена;
			Если БазаСбыта.Перечисления.СтавкиНДС.Индекс(ТЧ.СтавкаНДС) = БазаСбыта.Перечисления.СтавкиНДС.Индекс(БазаСбыта.Перечисления.СтавкиНДС.НДС18) Тогда
			ТЧ.СуммаНДС = ТЧ.Сумма*0.18;
			ТЧ.СуммаСНДС = ТЧ.Сумма + ТЧ.СуммаНДС;
			ИначеЕсли БазаСбыта.Перечисления.СтавкиНДС.Индекс(ТЧ.СтавкаНДС) = БазаСбыта.Перечисления.СтавкиНДС.Индекс(БазаСбыта.Перечисления.СтавкиНДС.НДС20) Тогда
			ТЧ.СуммаНДС = ТЧ.Сумма*0.2;
			ТЧ.СуммаСНДС = ТЧ.Сумма + ТЧ.СуммаНДС;
			Иначе	
			ТЧ.СуммаСНДС = ТЧ.Сумма;
			КонецЕсли;
		//ТЧ = бсНовДок.Штрихкоды.Добавить();	
		//ТЧ.Номенклатура = бсНомен;
		//ТЧ.ШК = ВыборкаДетальныеЗаписи.БарКод;
		КонецЦикла;
			Если флОшибки Тогда
			ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
			Возврат(Ложь);
			КонецЕсли; 
	бсНовДок.Комментарий = "&ТОВ Выгрузка ТНП из производственной базы от "+ТекущаяДата();
	бсНовДок.Записать();  
	Выгружено = Истина;
	Записать();
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат(Ложь);
	КонецПопытки;
Возврат(Истина);
КонецФункции

Функция ПолучитьДатуПоставки(ЗаказПоставщику,МПЗ)
Возврат(ЗаказПоставщику.ТабличнаяЧасть.Найти(МПЗ,"МПЗ").ДатаПоставки);
КонецФункции

Процедура ПочтоваяРассылка(ВиртуальнаяТабличнаяЧасть)
	Если Константы.ТестоваяБаза.Получить() Тогда
	Возврат;
	КонецЕсли;
	Попытка
	Сообщение = Новый ИнтернетПочтовоеСообщение;
	ИПП = Новый ИнтернетПочтовыйПрофиль; 

	НастройкиПочты = ОбщийМодульВызовСервера.ПолучитьНастройкиПочты();
	ИПП.АдресСервераSMTP = НастройкиПочты.АдресСервераSMTP; 
	ИПП.ПортSMTP = НастройкиПочты.ПортSMTP;
	ИПП.ВремяОжидания = 60; 
	ИПП.Пароль = НастройкиПочты.ПарольПочтовогоСервера; 
	ИПП.Пользователь = ПараметрыСеанса.Пользователь;
	Сообщение.Отправитель.Адрес = ПараметрыСеанса.Пользователь.Email; 
	Сообщение.Получатели.Добавить("stolupak@owen.ru");
	Сообщение.Получатели.Добавить("d.sokolova@owen.ru");
	Сообщение.Получатели.Добавить("e.krylova@owen.ru");
	Сообщение.Получатели.Добавить("m.moshkina@owen.ru");

	Сообщение.Тема = "Автоматическая рассылка по критичным материалам!"; 
	Текст = "Здравствуйте!";
	Текст = Текст + Символы.ПС + "";
	Текст = Текст + Символы.ПС + "На склад "+СокрЛП(МестоХранения.Наименование)+" поступили следующие критичные материалы:";	
		Для каждого ТЧ Из ВиртуальнаяТабличнаяЧасть Цикл
			Если ТЧ.МПЗ.Критичный Тогда
			Текст = Текст + Символы.ПС + СокрЛП(ТЧ.МПЗ.Наименование) + " (" + ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.ЕдиницаИзмерения) + " " + СокрЛП(ТЧ.ЕдиницаИзмерения.Наименование) + ")";
			КонецЕсли; 	
		КонецЦикла; 
	Текст = Текст + Символы.ПС + "Служба автоматической рассылки производственной базы!";
	Сообщение.Тексты.Добавить(Текст);
	
	// Подключиться и отправить. 
	Почта = Новый ИнтернетПочта; 
	Почта.Подключиться(ИПП);
	Почта.Послать(Сообщение); 
	Почта.Отключиться();
	Исключение

	КонецПопытки;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	Если Найти(МестоХранения.Наименование,"Склад ТНП") > 0 Тогда
		Если Не Выгружено Тогда
		 	Если Не ВыгрузитьВБазуСбыта() Тогда	
			Отказ = Истина;
			Возврат;
			КонецЕсли; 
		КонецЕсли; 	
	КонецЕсли;
флКритичный = Ложь;

ВиртуальнаяТабличнаяЧасть = ТабличнаяЧасть.Выгрузить();
ВиртуальнаяТабличнаяЧасть.Свернуть("ВидМПЗ,МПЗ,ЕдиницаИзмерения,Цена","Количество"); 
// регистр МестаХранения Приход
Движения.МестаХранения.Записывать = Истина;
	Для Каждого ТЧ Из ВиртуальнаяТабличнаяЧасть Цикл
		Если ТипЗнч(ТЧ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
			Если ТЧ.МПЗ.Критичный Тогда
			флКритичный = Истина;
			КонецЕсли; 
		КонецЕсли; 
	Движение = Движения.МестаХранения.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.МестоХранения = МестоХранения;
	Движение.ВидМПЗ = ТЧ.ВидМПЗ;
	Движение.МПЗ = ТЧ.МПЗ;
	Движение.Количество = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.ЕдиницаИзмерения);
	
	// регистр Цены Изменение
	ВыбЦена = РегистрыСведений.Цены.ПолучитьПоследнее(Дата,Новый Структура("МПЗ",ТЧ.МПЗ));
	БазоваяЦена = Окр(ТЧ.Цена/ТЧ.ЕдиницаИзмерения.Коэффициент,2,1);
		Если ВыбЦена.Цена <> БазоваяЦена Тогда
		Движения.Цены.Записывать = Истина;
		Движение = Движения.Цены.Добавить();
		Движение.Период = Дата;
		Движение.МПЗ = ТЧ.МПЗ;
		Движение.Цена = БазоваяЦена;		
		КонецЕсли; 
	КонецЦикла;
		Если ЗначениеЗаполнено(ДокументОснование) Тогда
			Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
			ЗаказыПоставщикам = РегистрыНакопления.ЗаказыПоставщикам;
			// регистр ЗаказыПоставщикам Расход
			Движения.ЗаказыПоставщикам.Записывать = Истина;
				Для Каждого ТЧ Из ВиртуальнаяТабличнаяЧасть Цикл
				ДатаПоставки = ПолучитьДатуПоставки(ДокументОснование,ТЧ.МПЗ);
				Фильтр   = Новый Структура;
				Фильтр.Вставить("МПЗ", ТЧ.МПЗ);
				Фильтр.Вставить("Контрагент",Контрагент);
				Фильтр.Вставить("Договор", Договор);
				Фильтр.Вставить("ДатаИсполнения", ДатаПоставки);
				Фильтр.Вставить("ЗаказПоставщику", ДокументОснование);
				Остаток = ЗаказыПоставщикам.Остатки(Дата,Фильтр,"МПЗ,Контрагент,Договор,ДатаИсполнения,ЗаказПоставщику", "Количество");
				БазовоеКоличество = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.ЕдиницаИзмерения);
					Если Остаток.Количество() > 0 Тогда
						Если Остаток[0].Количество < БазовоеКоличество Тогда
						Отказ = Истина;
						Сообщить("МПЗ "+ТЧ.МПЗ+" поступило: "+БазовоеКоличество+" требуется по заказу: "+Остаток[0].Количество);
						Продолжить;
						КонецЕсли; 		
					Иначе	
					Отказ = Истина;
					Сообщить("МПЗ "+ТЧ.МПЗ+" поступило: "+БазовоеКоличество+" требуется по заказу: 0");		
					КонецЕсли;
				Движение = Движения.ЗаказыПоставщикам.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = Дата;
				Движение.ДатаИсполнения = ДатаПоставки;
				Движение.МПЗ = ТЧ.МПЗ;
				Движение.Контрагент = Контрагент;
				Движение.Договор = Договор;
				Движение.Количество = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.ЕдиницаИзмерения);
				Движение.ЗаказПоставщику = ДокументОснование;
				КонецЦикла;
			КонецЕсли; 		
		КонецЕсли;
// регистр ГТД Приход
Движения.ГТД.Записывать = Истина;
	Для Каждого ТЧ Из ТабличнаяЧасть Цикл
		Если Не ТЧ.ГТД.Пустая() Тогда
		Движение = Движения.ГТД.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Товар = ТЧ.МПЗ;
		Движение.НомерГТД = ТЧ.ГТД;
		Движение.Количество = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.ЕдиницаИзмерения);
		КонецЕсли; 
	КонецЦикла;
		Если Не Отказ Тогда
			Если флКритичный Тогда
			ПочтоваяРассылка(ВиртуальнаяТабличнаяЧасть);
			КонецЕсли;
		КонецЕсли; 
КонецПроцедуры
