
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
Автор = ПараметрыСеанса.Пользователь;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПередачаНаЛинейку") Тогда	
	ДокументОснование = ДанныеЗаполнения.Ссылка;
	Подразделение = ДанныеЗаполнения.Подразделение;
	МестоХранения = ДанныеЗаполнения.МестоХраненияКанбанов;
	НомерЯчейки = ДанныеЗаполнения.НомерЯчейки;
	МПЗ = ДанныеЗаполнения.МПЗ;
	Количество = ДанныеЗаполнения.Количество;
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Номер = "" Тогда
	УстановитьНовыйНомер(ПрисвоитьПрефикс(Подразделение,Дата));
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	Если ТипЗнч(МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
	ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
	Иначе
	ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;
	КонецЕсли;
// регистр МестаХранения Приход
Движения.МестаХранения.Записывать = Истина;
Движение = Движения.МестаХранения.Добавить();
Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
Движение.Период = Дата;
Движение.МестоХранения = МестоХранения;
Движение.ВидМПЗ = ВидМПЗ; 
Движение.МПЗ = МПЗ;
Движение.Количество = Количество;

Фильтр   = Новый Структура;
Фильтр.Вставить("МестоХранения",МестоХранения);
Фильтр.Вставить("НомерЯчейки", НомерЯчейки);
Фильтр.Вставить("ВидМПЗ", ВидМПЗ);
Фильтр.Вставить("МПЗ", МПЗ);
Фильтр.Вставить("ПередачаНаЛинейку", ДокументОснование);
Остаток = РегистрыНакопления.ПередачиНаЛинейки.Остатки(Дата,Фильтр,"МестоХранения,НомерЯчейки,ВидМПЗ,МПЗ,ПередачаНаЛинейку", "Количество");
	Если Остаток.Количество() > 0 Тогда
		Если Остаток[0].Количество < Количество Тогда
		Отказ = Истина;
		Сообщить("МПЗ "+МПЗ+" требуется оприходовать: "+Количество+" передали: "+Остаток[0].Количество);
		КонецЕсли; 		
	Иначе	
	Отказ = Истина;
	Сообщить("МПЗ "+МПЗ+" требуется оприходовать: "+Количество+" передали: 0");		
	КонецЕсли;
// регистр ПередачиНаЛинейки Расход
Движения.ПередачиНаЛинейки.Записывать = Истина;
Движение = Движения.ПередачиНаЛинейки.Добавить();
Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
Движение.Период = Дата;
Движение.МестоХранения = МестоХранения;
Движение.НомерЯчейки = НомерЯчейки;
Движение.ВидМПЗ = ВидМПЗ;
Движение.МПЗ = МПЗ;
Движение.Количество = Количество;
Движение.ПередачаНаЛинейку = ДокументОснование;
СписокМПЗ = Новый СписокЗначений;

СписокМПЗ.Добавить(МПЗ);
ОбщийМодульРаботаСРегистрами.СнятиеСЛьготнойОчереди(СписокМПЗ,МестоХранения,Дата);
КонецПроцедуры
