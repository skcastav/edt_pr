
&НаСервере
Функция СоздатьНаСервере()
Запрос = Новый Запрос;
ТЗ = Новый ТаблицаЗначений;

	Попытка
	Реализация = Документы.Реализация.СоздатьДокумент();
	Реализация.Внутренняя = Истина;
	Реализация.Дата = ТекущаяДата();
	Реализация.Подразделение = Подразделение;
	Реализация.ПодразделениеПолучатель = ПодразделениеПолучатель;
	Реализация.МестоХранения = МестоХраненияГП;
	Реализация.Контрагент = Контрагент; 
	Реализация.Договор = Договор;
	Реализация.Коэфф = 1;
		Если СоздаватьИз = 1 Тогда
		Реализация.Комментарий = "Передачи на склады линеек со склада ГП УЛиШИ за период с "+НачалоДня(Объект.НаДату)+" по "+КонецДня(Объект.НаДату);
		Иначе 	
		Реализация.Комментарий = "Перемещения со склада ГП УЛиШИ на склады подразделения "+СокрЛП(ПодразделениеПолучатель.Наименование)+" за период с "+НачалоДня(Объект.НаДату)+" по "+КонецДня(Объект.НаДату);
		КонецЕсли;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МестаХраненияОбороты.Регистратор,
		|	МестаХраненияОбороты.МПЗ,
		|	МестаХраненияОбороты.КоличествоРасход
		|ИЗ
		|	РегистрНакопления.МестаХранения.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК МестаХраненияОбороты
		|ГДЕ
		|	МестаХраненияОбороты.ВидМПЗ = &ВидМПЗ
		|	И МестаХраненияОбороты.МестоХранения = &МестоХранения";
	Запрос.УстановитьПараметр("МестоХранения",МестоХраненияГП); 
	Запрос.УстановитьПараметр("ДатаНач",НачалоДня(Объект.НаДату)); 
	Запрос.УстановитьПараметр("ДатаКон",КонецДня(Объект.НаДату)); 
		Если ВидМПЗ = 1 Тогда
		Запрос.УстановитьПараметр("ВидМПЗ",Перечисления.ВидыМПЗ.Материалы);
		Иначе	
		Запрос.УстановитьПараметр("ВидМПЗ",Перечисления.ВидыМПЗ.Полуфабрикаты);
		КонецЕсли;
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если СоздаватьИз = 1 Тогда	
				Если ТипЗнч(Выборка.Регистратор) <> Тип("ДокументСсылка.ПередачаНаЛинейку") Тогда	
				Продолжить;
				КонецЕсли;
					Если Выборка.Регистратор.МестоХраненияКанбанов.Подразделение <> ПодразделениеПолучатель Тогда
					Продолжить;
					КонецЕсли;
			Иначе
				Если ТипЗнч(Выборка.Регистратор) <> Тип("ДокументСсылка.ДвижениеМПЗ") Тогда
				Продолжить;
				КонецЕсли;
					Если Выборка.Регистратор.МестоХраненияВ.Подразделение <> ПодразделениеПолучатель Тогда
					Продолжить;
					КонецЕсли; 
			КонецЕсли;  
		ТЧ = Реализация.ТабличнаяЧасть.Добавить();
			Если ВидМПЗ = 1 Тогда
			ТЧ.ВидТовара = Перечисления.ВидыМПЗ.Материалы;
			Иначе
			ТЧ.ВидТовара = Перечисления.ВидыМПЗ.Полуфабрикаты;
			КонецЕсли;  
		ТЧ.Товар = Выборка.МПЗ;
		ТЧ.ЕдиницаИзмерения = ТЧ.Товар.ОсновнаяЕдиницаИзмерения;
		ТЧ.Количество = Выборка.КоличествоРасход/ТЧ.ЕдиницаИзмерения.Коэффициент;
		КонецЦикла;	
			Если Реализация.ТабличнаяЧасть.Количество() > 0 Тогда
			ТЗ = Реализация.ТабличнаяЧасть.Выгрузить();
			ТЗ.Свернуть("ВидТовара,Товар,ЕдиницаИзмерения","Количество");
			ТЗ.Сортировать("Товар");
			Реализация.ТабличнаяЧасть.Загрузить(ТЗ);
				Для каждого ТЧ Из Реализация.ТабличнаяЧасть Цикл
				ТЧ.Цена = ОбщийМодульРаботаСРегистрами.ПолучитьЦенуДП(Реализация.Договор,1,ТЧ.Товар,Объект.НаДату);
					Если ТЧ.Цена = 0 Тогда
					Сообщить(СокрЛП(ТЧ.Товар.Наименование)+" - договорная позиция не найдена!");		
					КонецЕсли; 
				ТЧ.Сумма = ТЧ.Цена*ТЧ.Количество;	
					Если Реализация.Договор.БезНДС Тогда
					ТЧ.СтавкаНДС = Справочники.СтавкиНДС.ПустаяСсылка();
					ТЧ.НДС = 0;
					ТЧ.Всего = ТЧ.Сумма;
					Иначе
					ТЧ.СтавкаНДС = Константы.ОсновнаяСтавкаНДС.Получить();
					ТЧ.НДС = ТЧ.Сумма*ТЧ.СтавкаНДС.Ставка/100;
					ТЧ.Всего = ТЧ.Сумма + ТЧ.НДС;		
					КонецЕсли;
				КонецЦикла; 
			Реализация.Записать(РежимЗаписиДокумента.Запись);
			Возврат(Реализация.Ссылка);
			Иначе
			Сообщить("Табличная часть документа реализации пустая! Документ не создан!");
			Возврат(Документы.Реализация.ПустаяСсылка());
			КонецЕсли; 
	Исключение
	Сообщить(ОписаниеОшибки());
	Возврат(Документы.Реализация.ПустаяСсылка());
	КонецПопытки;
КонецФункции

&НаКлиенте
Процедура Создать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	Результат = СоздатьНаСервере();
		Если Не Результат.Пустая() Тогда	
		ПоказатьОповещениеПользователя("ВНИМАНИЕ!",ПолучитьНавигационнуюСсылку(Результат),"Создан документ "+Результат,БиблиотекаКартинок.Пользователь,СтатусОповещенияПользователя.Информация);		
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
ВидМПЗ = 1;
СоздаватьИз = 1;
Объект.НаДату = ТекущаяДата();
КонецПроцедуры
