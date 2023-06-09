
&НаСервере
Функция ПроверитьНаПСИ(МТК)	
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПроизводственноеЗадание.Ссылка
	|ИЗ
	|	Документ.ПроизводственноеЗадание КАК ПроизводственноеЗадание
	|ГДЕ
	|	ПроизводственноеЗадание.ДокументОснование  = &ДокументОснование
	|	И ПроизводственноеЗадание.НаПСИ = ИСТИНА";
Запрос.УстановитьПараметр("ДокументОснование",МТК);
РезультатЗапроса = Запрос.Выполнить();
Возврат(Не РезультатЗапроса.Пустой());
КонецФункции

&НаСервере
Процедура НайтиЗаказыНаСервере()
ТаблицаЗаказов.Очистить();

Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаршрутнаяКарта.Ссылка,
	|	МаршрутнаяКарта.Номенклатура,
	|	МаршрутнаяКарта.Количество
	|ИЗ
	|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
	|ГДЕ
	|	МаршрутнаяКарта.СтандартныйКомментарий = &СтандартныйКомментарий
	|	И МаршрутнаяКарта.Выгружено = ЛОЖЬ";
Запрос.УстановитьПараметр("СтандартныйКомментарий",СтандартныйКомментарий);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = ТаблицаЗаказов.Добавить();
	ТЧ.Счёт = ВыборкаДетальныеЗаписи.Ссылка.Счёт;
	ТЧ.Номенклатура = ВыборкаДетальныеЗаписи.Ссылка.Номенклатура;
	ТЧ_ТЧ = ТЧ.ТаблицаМТК.Добавить();
	ТЧ_ТЧ.МТК = ВыборкаДетальныеЗаписи.Ссылка;
	флВыполнено = ?(ТЧ_ТЧ.МТК.Статус = 3,Истина,Ложь); 
	ТЧ.Выполнено = флВыполнено;
	ТЧ.НаПСИ = ПроверитьНаПСИ(ВыборкаДетальныеЗаписи.Ссылка);
		Если (ТЧ.Выполнен) и (Не ТЧ.НаПСИ) Тогда
		ТЧ.Пометка = Истина;
		Иначе
		ТЧ.Пометка = Ложь;
		КонецЕсли;
	ТЧ.Пометка = флВыполнено;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НайтиЗаказы(Команда)
НайтиЗаказыНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьНаСервере()
БазаСбыта = ОбщийМодульСинхронизации.УстановитьCOMСоединение(Константы.БазаДанных1ССбыт.Получить());
	Если БазаСбыта = Неопределено Тогда
	Сообщить("Не открыто соединение с базой сбыта!");
	Возврат;
	КонецЕсли;
Запрос = Новый Запрос;

бсСклад = БазаСбыта.Справочники.Склады.НайтиПоНаименованию("СД 423",Истина);
	Для каждого ТЧ Из ТаблицаЗаказов Цикл
		Если ТЧ.Пометка Тогда
			Попытка
			НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
			бсНовДок = БазаСбыта.Документы.ПоступлениеТоваровУслуг.СоздатьДокумент();
			бсНовДок.Дата = ТекущаяДата();
			бсНовДок.Организация = БазаСбыта.Справочники.Организации.НайтиПоКоду("02");
			бсНовДок.Партнер = БазаСбыта.Справочники.Партнеры.НайтиПоКоду("00-00000010");
			бсНовДок.Склад = бсСклад;
			бсНовДок.ХозяйственнаяОперация = БазаСбыта.Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
			бсНовДок.НалогообложениеНДС = БазаСбыта.Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
			бсНовДок.БанковскийСчетОрганизации = БазаСбыта.ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(бсНовДок.Организация);
			бсНовДок.Валюта = БазаСбыта.Справочники.Валюты.НайтиПоКоду("643");
			бсНовДок.ВалютаВзаиморасчетов = БазаСбыта.Справочники.Валюты.НайтиПоКоду("643");

			Артикул = ОбщийМодульВызовСервера.ПолучитьАртикулПоКодуТовара(ТЧ.Номенклатура.Товар.Код);
			бсНомен = БазаСбыта.Справочники.Номенклатура.НайтиПоРеквизиту("Артикул",Артикул);
				Если бсНомен.Пустая() Тогда
				Сообщить(СокрЛП(ТЧ.Номенклатура.Товар.Наименование)+" - товар с артикулом "+Артикул+" не найден в торговой базе!");				
				Продолжить;
				КонецЕсли;
			ТЧ_Т = бсНовДок.Товары.Добавить();
			ТЧ_Т.Склад = бсСклад;	
			ТЧ_Т.Номенклатура = бсНомен;
			ТЧ_Т.ИМНомерЗаказаЗаказнойТовар = ТЧ.Счёт;
			ТЧ_Т.КоличествоУпаковок = ТЧ.Количество;
			ТЧ_Т.ИмКоличествоЗарегистрировано = ТЧ.Количество;
			ТЧ_Т.Количество = ТЧ.Количество;
			ТЧ_Т.СтавкаНДС = бсНомен.СтавкаНДС;
			ТЧ_Т.Цена = бсНомен.ИмЦена;
			ТЧ_Т.Сумма = ТЧ_Т.КоличествоУпаковок*ТЧ_Т.Цена;
				Если БазаСбыта.Перечисления.СтавкиНДС.Индекс(ТЧ_Т.СтавкаНДС) = БазаСбыта.Перечисления.СтавкиНДС.Индекс(БазаСбыта.Перечисления.СтавкиНДС.НДС18) Тогда
				ТЧ_Т.СуммаНДС = ТЧ_Т.Сумма*0.18;
				ТЧ_Т.СуммаСНДС = ТЧ_Т.Сумма + ТЧ_Т.СуммаНДС;
				ИначеЕсли БазаСбыта.Перечисления.СтавкиНДС.Индекс(ТЧ_Т.СтавкаНДС) = БазаСбыта.Перечисления.СтавкиНДС.Индекс(БазаСбыта.Перечисления.СтавкиНДС.НДС20) Тогда
				ТЧ_Т.СуммаНДС = ТЧ_Т.Сумма*0.2;
				ТЧ_Т.СуммаСНДС = ТЧ_Т.Сумма + ТЧ_Т.СуммаНДС;
				Иначе	
				ТЧ_Т.СуммаСНДС = ТЧ_Т.Сумма;
				КонецЕсли;
					Для каждого ТЧ_МТК Из ТЧ.ТаблицаМТК Цикл
					Подразделение = ТЧ_МТК.МТК.Подразделение;
					Запрос.Текст = 
						"ВЫБРАТЬ
						|	БарКоды.БарКод
						|ИЗ
						|	РегистрСведений.БарКоды КАК БарКоды
						|ГДЕ
						|	БарКоды.ПЗ.ДокументОснование = &ДокументОснование";
					Запрос.УстановитьПараметр("ДокументОснование", ТЧ_МТК.МТК);
					РезультатЗапроса = Запрос.Выполнить();
					ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
						Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
						ТЧ_ШК = бсНовДок.Штрихкоды.Добавить();	
						ТЧ_ШК.Номенклатура = бсНомен;
						ТЧ_ШК.ШК = ВыборкаДетальныеЗаписи.БарКод;
						КонецЦикла;
					МТК = ТЧ_МТК.МТК.ПолучитьОбъект();
					МТК.Выгружено = Истина;
					МТК.Записать(РежимЗаписиДокумента.Проведение);
					КонецЦикла;
						Если Найти(Подразделение.Наименование,"УПЭА") > 0 Тогда
						бсНовДок.Комментарий = "Выгрузка УПЭА из производственной базы от "+ТекущаяДата();
						Иначе	
						бсНовДок.Комментарий = "&ДД Выгрузка УД из производственной базы от "+ТекущаяДата();
						КонецЕсли;
			бсНовДок.Записать();
			бсНовДок.Записать(БазаСбыта.РежимЗаписиДокумента.Проведение);			 
			ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
			Исключение
			Сообщить(ОписаниеОшибки());
			ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
			КонецПопытки;
		КонецЕсли;		
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Выгрузить(Команда)
ВыгрузитьНаСервере();
НайтиЗаказыНаСервере()
КонецПроцедуры
