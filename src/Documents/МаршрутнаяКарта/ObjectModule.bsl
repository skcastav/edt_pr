
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Номер = "" Тогда
	УстановитьНовыйНомер(ПрисвоитьПрефикс(Подразделение,Дата));
	КонецЕсли;			   
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
Автор = ПараметрыСеанса.Пользователь;
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	//Если Ссылка.Статус = 0 Тогда
		//Попытка
		//НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
		//Запрос = Новый Запрос;

		//Запрос.Текст = 
		//	"ВЫБРАТЬ
		//	|	СтруктураПодчиненности.Ссылка
		//	|ИЗ
		//	|	КритерийОтбора.ПодчиненныеДокументы(&ЗначениеКритерияОтбора) КАК СтруктураПодчиненности";
		//Запрос.УстановитьПараметр("ЗначениеКритерияОтбора", Ссылка);
		//РезультатЗапроса = Запрос.Выполнить();
		//ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
		//	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		//	УдаляемыйДок = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		//	УдаляемыйДок.Удалить();
		//	КонецЦикла;
		//ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли; 
		//Исключение
		//Сообщить(ОписаниеОшибки());
		//ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
		//Отказ = Истина;
		//КонецПопытки;
	//Иначе
	//Отказ = Истина;
	//Сообщить("Документ находится в работе!");
	//КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
// регистр ПланыВыпуска Приход
Движения.ПланыВыпуска.Записывать = Истина;
Движение = Движения.ПланыВыпуска.Добавить();
Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
Движение.Период = Дата;
Движение.Подразделение = Подразделение;
Движение.Линейка = Линейка;
Движение.Номенклатура = Номенклатура;
Движение.МаршрутнаяКарта = Ссылка;
Движение.Количество = Количество;
	Если Статус = 3 Тогда
		Если ЗначениеЗаполнено(ДокументОснование) Тогда
			Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаказНаПроизводство") Тогда
			Выборка = ДокументОснование.Заказ.Найти(Номенклатура,"Продукция");
				Если Выборка <> Неопределено Тогда
					Если Не Выборка.РучнойЗапуск Тогда
					// регистр ЗаказыНаПроизводство Расход
					КолОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоЗаказуНаПроизводство(ДокументОснование,Номенклатура,Дата);
						Если КолОстаток >= Количество Тогда
						Движения.ЗаказыНаПроизводство.Записывать = Истина;
						Движение = Движения.ЗаказыНаПроизводство.Добавить();
						Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
						Движение.Период = Дата;
						Движение.Продукция = Номенклатура;
						Движение.Количество = Количество;
						Движение.Документ = ДокументОснование;
						Иначе
						Отказ = Истина;
						Сообщение = Новый СообщениеПользователю;
						Сообщение.УстановитьДанные(ЭтотОбъект);
						Сообщение.Текст = "Номенклатура: "+СокрЛП(Номенклатура.Наименование)+" по МТК: "+Количество+" в заказе на пр-во недостаёт: "+Строка(Количество-КолОстаток);
						Сообщение.Сообщить();
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;					
			КонецЕсли;		
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
