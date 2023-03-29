
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
Автор = ПараметрыСеанса.Пользователь;
Номер = ДанныеЗаполнения.Ссылка.Номер;
Подразделение = ДанныеЗаполнения.ДокументОснование.Подразделение;
ДокументОснование = ДанныеЗаполнения.Ссылка;
КонецПроцедуры

Процедура УстановитьДатуГрупповойУпаковки(МТК)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПроизводственноеЗадание.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ПроизводственноеЗадание КАК ПроизводственноеЗадание
	|ГДЕ
	|	ПроизводственноеЗадание.ДокументОснование = &ДокументОснование";
Запрос.УстановитьПараметр("ДокументОснование", МТК);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ПЗ = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
	ПЗ.ДатаГрупповойУпаковки = ТекущаяДата();
	ПЗ.Записать();
	КонецЦикла;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Номер = "" Тогда
	УстановитьНовыйНомер(ПрисвоитьПрефикс(Подразделение,Дата));
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
МТК = ДокументОснование.ДокументОснование;
МестоХраненияКанбанов = ДокументОснование.Линейка.МестоХраненияКанбанов;
// регистр ПередачиВПроизводство
Движения.ПередачиВПроизводство.Записывать = Истина;
// регистр МестаХранения Приход
Движения.МестаХранения.Записывать = Истина;
ВиртуальнаяТабличнаяЧасть = Списание.Выгрузить();
ВиртуальнаяТабличнаяЧасть.Свернуть("ВидМПЗ,МПЗ,ЕдиницаИзмерения","Количество");
	Для Каждого ТЧ Из ВиртуальнаяТабличнаяЧасть Цикл
	Требуется = ПолучитьБазовоеКоличество(ТЧ.Количество,ТЧ.ЕдиницаИзмерения);
		Если ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты Тогда
			Если Не ТЧ.МПЗ.Канбан.Пустая() Тогда	
				Если Не ТЧ.МПЗ.Канбан.РезервироватьВПроизводстве Тогда		
				КолОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоМестуХранения(МестоХраненияКанбанов,ТЧ.МПЗ,Дата);
					Если КолОстаток >= Требуется Тогда
					Движение = Движения.МестаХранения.Добавить();
					Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
					Движение.Период = Дата;
					Движение.МестоХранения = МестоХраненияКанбанов;
					Движение.ВидМПЗ = ТЧ.ВидМПЗ;
					Движение.МПЗ = ТЧ.МПЗ;
					Движение.Количество = Требуется;
					Иначе
					Отказ = Истина;
					Сообщить("Канбан без резервирования "+СокрЛП(ТЧ.МПЗ.Наименование)+" требуется: "+Требуется+" недостаёт на складе: "+Строка(Требуется-КолОстаток)+" (Оформите излишки!)");
					КонецЕсли; 		
				Продолжить; 
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;	
	КолОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПП(ДокументОснование,ТЧ.ВидМПЗ,ТЧ.МПЗ,Дата);	
		Если КолОстаток >= Требуется Тогда
		Движение = Движения.ПередачиВПроизводство.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Документ = ДокументОснование;
		Движение.ВидМПЗ = ТЧ.ВидМПЗ;
		Движение.МПЗ = ТЧ.МПЗ;
		Движение.Количество = Требуется;
		Иначе
		Отказ = Истина;
		Сообщить("МПЗ: "+СокрЛП(ТЧ.МПЗ.Наименование)+" требуется: "+Требуется+" недостаёт в производстве: "+Строка(Требуется-КолОстаток));
		КонецЕсли;				 	
	КонецЦикла;
		Если Отказ Тогда
		Возврат;
		КонецЕсли; 
			Если НаСклад Тогда
			// регистр МестаХранения выпуск продукции
			Движения.МестаХранения.Записывать = Истина;
			// регистр ПланыВыпуска выпуск готовой продукции
			Движения.ПланыВыпуска.Записывать = Истина;
			// регистр РезервированиеГП приход	
			Движения.РезервированиеГП.Записывать = Истина;
				Для Каждого ТЧ Из Поступление Цикл
				Движение = Движения.МестаХранения.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
				Движение.Период = Дата;
				Движение.МестоХранения = МестоХранения;
				Движение.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;
				Движение.МПЗ = ТЧ.Номенклатура;
				Движение.Количество = ТЧ.Количество;
				
				КолОстПВ = ОбщийМодульВызовСервера.ПолучитьНезавершённоеКоличество(Дата,МТК);
					Если КолОстПВ >= ТЧ.Количество Тогда
					Движение = Движения.ПланыВыпуска.Добавить();
					Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
					Движение.Период = Дата;
					Движение.Подразделение = Подразделение;
					Движение.Линейка = МТК.Линейка;
					Движение.Номенклатура = ТЧ.Номенклатура;
					Движение.МаршрутнаяКарта = МТК;
					Движение.Количество = ТЧ.Количество; 
					ДокОснМТК = МТК.ДокументОснование;
						Если ЗначениеЗаполнено(ДокОснМТК) Тогда
							Если ТипЗнч(ДокОснМТК) = Тип("ДокументСсылка.ЗаказНаПроизводство") Тогда
							Движение = Движения.РезервированиеГП.Добавить();
							Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
							Движение.Период = Дата;
							Движение.МестоХранения = МестоХранения;
							Движение.Продукция = ТЧ.Номенклатура;
							Движение.Документ = ДокОснМТК;
							Движение.Количество = ТЧ.Количество;
								Если КолОстПВ = ТЧ.Количество Тогда
								КолОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоЗаказуНаПроизводство(ДокОснМТК,ТЧ.Номенклатура,Дата);
									Если КолОстаток = МТК.Количество Тогда
										Если Не ДокОснМТК.ВнутренниеСчета Тогда
										ДВПЗ = РегистрыСведений.ДатыВыполненияПоПозициямЗНП.СоздатьМенеджерЗаписи();
										ДВПЗ.НомерЗНП = ДокОснМТК.Номер;
										ДВПЗ.КодТовара = ТЧ.Номенклатура.Товар.Код;
										ДВПЗ.ДатаВыполнения = Дата;
										ДВПЗ.ЗапрещеноКОтгрузке = ТЧ.Номенклатура.ЗапрещеноКОтгрузке;
										ДВПЗ.Записать(Истина);
										КонецЕсли; 
									КонецЕсли;
								КонецЕсли;
							ИначеЕсли ТипЗнч(ДокОснМТК) = Тип("ДокументСсылка.СписаниеМПЗПрочее") Тогда
								Если ТипЗнч(ДокОснМТК.ДокументОснование) = Тип("ДокументСсылка.ЗаказНаПроизводство") Тогда
								Движение = Движения.РезервированиеГП.Добавить();
								Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
								Движение.Период = Дата;
								Движение.МестоХранения = МестоХранения;
								Движение.Продукция = ТЧ.Номенклатура;
								Движение.Документ = ДокОснМТК.ДокументОснование;
								Движение.Количество = ТЧ.Количество;
									Если КолОстПВ = ТЧ.Количество Тогда
									КолОстаток = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоЗаказуНаПроизводство(ДокОснМТК.ДокументОснование,ТЧ.Номенклатура,Дата);
										Если КолОстаток = МТК.Количество Тогда
											Если Не ДокОснМТК.ДокументОснование.ВнутренниеСчета Тогда
											ДВПЗ = РегистрыСведений.ДатыВыполненияПоПозициямЗНП.СоздатьМенеджерЗаписи();
											ДВПЗ.НомерЗНП = ДокОснМТК.ДокументОснование.Номер;
											ДВПЗ.КодТовара = ТЧ.Номенклатура.Товар.Код;
											ДВПЗ.ДатаВыполнения = Дата;
											ДВПЗ.ЗапрещеноКОтгрузке = ТЧ.Номенклатура.ЗапрещеноКОтгрузке;
											ДВПЗ.Записать(Истина);
											КонецЕсли; 
										КонецЕсли;
									КонецЕсли;
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
							Если КолОстПВ = ТЧ.Количество Тогда
							МТКОбъект = МТК.ПолучитьОбъект();
							МТКОбъект.Статус = 3;
							МТКОбъект.Записать(РежимЗаписиДокумента.Проведение);
								Если ТЧ.Номенклатура.Товар.ТоварнаяГруппа.ГрупповаяУпаковка Тогда
								УстановитьДатуГрупповойУпаковки(ДокументОснование.ДокументОснование); 
								КонецЕсли;
							КонецЕсли; 
					Иначе
					Отказ = Истина;
					Сообщить("Изделие: "+СокрЛП(ТЧ.Номенклатура.Наименование)+" выпускается: "+ТЧ.Количество+", недостаёт в МТК: "+Строка(ТЧ.Количество-КолОстПВ));
					КонецЕсли; 
				КонецЦикла;	
			Иначе
			// регистр ПередачиВПроизводство выпуск полуфабрикатов
			Движения.ПередачиВПроизводство.Записывать = Истина;
				Для Каждого ТЧ Из Поступление Цикл
				Движение = Движения.ПередачиВПроизводство.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
				Движение.Период = Дата;
				Движение.Документ = ДокументОснование;
				Движение.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;
				Движение.МПЗ = ТЧ.Номенклатура;
				Движение.Количество = ТЧ.Количество;
				КонецЦикла;	
			КонецЕсли; 	
КонецПроцедуры
