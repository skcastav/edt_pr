
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Номер = "" Тогда
	УстановитьНовыйНомер(Формат(Дата,"ДФ=гг")+"-");
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
Автор = ПараметрыСеанса.Пользователь;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Для Каждого ТЧ Из ТабличнаяЧасть Цикл
	// регистр ЗаказыНаПроизводство Расход
	КолОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоЗаказуНаПроизводство(ДокументОснование,ТЧ.Продукция,Дата);
		Если КолОстаток >= ТЧ.Количество Тогда
		Движения.ЗаказыНаПроизводство.Записывать = Истина;
		Движение = Движения.ЗаказыНаПроизводство.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Продукция = ТЧ.Продукция;
		Движение.Количество = ТЧ.Количество;
		Движение.Документ = ДокументОснование;
			Если КолОстаток = ТЧ.Количество Тогда
				Если Не ДокументОснование.ВнутренниеСчета Тогда
				ДВПЗ = РегистрыСведений.ДатыВыполненияПоПозициямЗНП.СоздатьМенеджерЗаписи();
				ДВПЗ.НомерЗНП = ДокументОснование.Номер;
				ДВПЗ.КодТовара = ТЧ.Товар.Код;
				ДВПЗ.ДатаВыполнения = Дата;
				ДВПЗ.Записать(Истина);
				КонецЕсли; 
			КонецЕсли;
		Иначе
		Отказ = Истина;
		Сообщить("Продукция: "+СокрЛП(ТЧ.Продукция.Наименование)+" зарезервировано: "+ТЧ.Количество+" в заказе на пр-во недостаёт: "+Строка(ТЧ.Количество-КолОстаток));
		КонецЕсли;
	//регистр Резервирование ГП Приход
	Движения.РезервированиеГП.Записывать = Истина;
	Движение = Движения.РезервированиеГП.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.МестоХранения = МестоХранения;
	Движение.Продукция = ТЧ.Продукция;
	Движение.Документ = ДокументОснование;
	Движение.Количество = ТЧ.Количество;		
	КонецЦикла;
КонецПроцедуры
