
Функция ПолучитьНезавершенноеЗадание(Этапы,ЭтапыАРМ,РабочееМесто,Исполнитель,ПроизводственноеЗадание = Неопределено) Экспорт
Запрос = Новый Запрос;

НаДату = ТекущаяДата()+1;
Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ КАК ПЗ
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних(&НаДату, РабочееМесто = &РабочееМесто) КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаНачала <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.Ремонт = ЛОЖЬ
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Статус <> 2
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаНачала";
Запрос.УстановитьПараметр("НаДату",НаДату);
Запрос.УстановитьПараметр("РабочееМесто",РабочееМесто);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.ПЗ <> ПроизводственноеЗадание Тогда
			Если ОбщийМодульВызовСервера.СоздатьТаблицуЭтаповПроизводства(ВыборкаДетальныеЗаписи.ПЗ,Этапы,ЭтапыАРМ,РабочееМесто,Исполнитель) Тогда	
			Возврат(Новый Структура("ПЗ,ВозвратнаяТара",ВыборкаДетальныеЗаписи.ПЗ,ВыборкаДетальныеЗаписи.ПЗ.ВозвратнаяТара));			
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;                               
		Если РабочееМесто.Код = 1 Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ КАК ПЗ
			|ИЗ
			|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних(&НаДату, РабочееМесто = &РабочееМесто) КАК ЭтапыПроизводственныхЗаданийСрезПоследних
			|ГДЕ
			|	ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
			|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДатаЗапуска <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
			|	И ЭтапыПроизводственныхЗаданийСрезПоследних.Ремонт = ЛОЖЬ
			|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Статус <> 2
			|
			|УПОРЯДОЧИТЬ ПО
			|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДатаЗапуска";
		Запрос.УстановитьПараметр("НаДату",НаДату);
		Запрос.УстановитьПараметр("РабочееМесто",РабочееМесто);
		Результат = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 
				Если ВыборкаДетальныеЗаписи.ПЗ <> ПроизводственноеЗадание Тогда
					Если ОбщийМодульВызовСервера.СоздатьТаблицуЭтаповПроизводства(ВыборкаДетальныеЗаписи.ПЗ,Этапы,ЭтапыАРМ,РабочееМесто,Исполнитель) Тогда	
					Возврат(Новый Структура("ПЗ,ВозвратнаяТара",ВыборкаДетальныеЗаписи.ПЗ,ВыборкаДетальныеЗаписи.ПЗ.ВозвратнаяТара));			
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
Возврат(Неопределено);
КонецФункции 

Функция ПолучитьНезавершенноеЗаданиеПоСпискуРабочихМест(Этапы,ЭтапыАРМ,СписокРабочихМест,Исполнитель,ПроизводственноеЗадание = Неопределено) Экспорт
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ КАК ПЗ,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто КАК РабочееМесто
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних(, РабочееМесто В(&СписокРабочихМест)) КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ                                                                                   
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаНачала <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.Ремонт = ЛОЖЬ
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Статус <> 2
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаНачала";
Запрос.УстановитьПараметр("СписокРабочихМест",СписокРабочихМест);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
        Если ВыборкаДетальныеЗаписи.ПЗ <> ПроизводственноеЗадание Тогда
			Если ОбщийМодульВызовСервера.СоздатьТаблицуЭтаповПроизводства(ВыборкаДетальныеЗаписи.ПЗ,Этапы,ЭтапыАРМ,ВыборкаДетальныеЗаписи.РабочееМесто,Исполнитель) Тогда	
			Возврат(Новый Структура("ПЗ,РабочееМесто,ВозвратнаяТара",ВыборкаДетальныеЗаписи.ПЗ,ВыборкаДетальныеЗаписи.РабочееМесто,ВыборкаДетальныеЗаписи.ПЗ.ВозвратнаяТара));			
			КонецЕсли;
		КонецЕсли;		
	КонецЦикла;
		Если СписокРабочихМест[0].Значение.Код = 1 Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ КАК ПЗ,
			|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто КАК РабочееМесто
			|ИЗ
			|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних(, РабочееМесто В(&СписокРабочихМест)) КАК ЭтапыПроизводственныхЗаданийСрезПоследних
			|ГДЕ                                                                                   
			|	ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
			|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДатаЗапуска <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
			|	И ЭтапыПроизводственныхЗаданийСрезПоследних.Ремонт = ЛОЖЬ
			|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Статус <> 2
			|
			|УПОРЯДОЧИТЬ ПО
			|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДатаЗапуска";
		Запрос.УстановитьПараметр("СписокРабочихМест",СписокРабочихМест);
		Результат = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		        Если ВыборкаДетальныеЗаписи.ПЗ <> ПроизводственноеЗадание Тогда
					Если ОбщийМодульВызовСервера.СоздатьТаблицуЭтаповПроизводства(ВыборкаДетальныеЗаписи.ПЗ,Этапы,ЭтапыАРМ,ВыборкаДетальныеЗаписи.РабочееМесто,Исполнитель) Тогда	
					Возврат(Новый Структура("ПЗ,РабочееМесто,ВозвратнаяТара",ВыборкаДетальныеЗаписи.ПЗ,ВыборкаДетальныеЗаписи.РабочееМесто,ВыборкаДетальныеЗаписи.ПЗ.ВозвратнаяТара));			
					КонецЕсли;
				КонецЕсли;		
			КонецЦикла;
		КонецЕсли;
Возврат(Неопределено);
КонецФункции

Процедура ПолучитьКомплектациюИСпецификациюСАналогами(ТаблицаКомплектации,ТаблицаСпецификации,ПЗ,Спецификация,ЭтапСпецификации,КолУзла,флКомплектация,Владелец = "",НаборАналогов = Неопределено) Экспорт
ТаблицаАналогов = ?(ПЗ.Линейка.ВидЛинейки = Перечисления.ВидыЛинеек.Канбан,ПЗ.ДокументОснование.Аналоги,ПЗ.Аналоги); 
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Все(ЭтапСпецификации,ПЗ.ДатаЗапуска);
	Пока ВыборкаНР.Следующий() Цикл
	ТипЗнач = ТипЗнч(ВыборкаНР.Элемент);
		Если ТипЗнач = Тип("СправочникСсылка.Материалы")Тогда
		ВыбАналог = ТаблицаАналогов.НайтиСтроки(Новый Структура("Спецификация,НормаРасходов",Спецификация,ВыборкаНР.Ссылка)); 
			Если ВыбАналог.Количество() = 0 Тогда
			НР = ВыборкаНР.Ссылка;
			Количество = ВыборкаНР.Норма*КолУзла; 
			Аналог = ?(НаборАналогов <> Неопределено,Истина,Ложь);
			Иначе
			НР = ВыбАналог[0].АналогНормыРасходов;
			НормыАНР = РегистрыСведений.АналогиНормРасходов.ПолучитьПоследнее(ПЗ.ДатаЗапуска,Новый Структура("АналогНормыРасходов",НР));
			Количество = НормыАНР.Норма*КолУзла;
			Аналог = Истина; 
				Если НР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Набор Тогда
				ПолучитьКомплектациюИСпецификациюСАналогами(ТаблицаКомплектации,ТаблицаСпецификации,ПЗ,Спецификация,НР.Элемент,Количество,флКомплектация,ВыборкаНР.Ссылка,НР.Ссылка);
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ТипЗнач = Тип("СправочникСсылка.Номенклатура") Тогда
			Если ВыборкаНР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Набор Тогда
			ПолучитьКомплектациюИСпецификациюСАналогами(ТаблицаКомплектации,ТаблицаСпецификации,ПЗ,Спецификация,ВыборкаНР.Элемент,ВыборкаНР.Норма*КолУзла,флКомплектация,ВыборкаНР.Ссылка);
			Продолжить;
			КонецЕсли;
		ВыбАналог = ТаблицаАналогов.НайтиСтроки(Новый Структура("Спецификация,НормаРасходов",Спецификация,ВыборкаНР.Ссылка));  
			Если ВыбАналог.Количество() = 0 Тогда
			НР = ВыборкаНР.Ссылка;
			Количество = ВыборкаНР.Норма*КолУзла; 
			Аналог = Ложь;
				Если флКомплектация Тогда
					Если Не ВыборкаНР.Элемент.Канбан.Пустая() Тогда
					Выборка = ТаблицаКомплектации.НайтиСтроки(Новый Структура("ЭтапСпецификации,Комплектация",Спецификация,ВыборкаНР.Элемент));
						Если Выборка.Количество() = 0 Тогда
			            ТЧТК = ТаблицаКомплектации.Добавить();
						ТЧТК.ЭтапСпецификации = Спецификация;
						ТЧТК.ВидЭлемента = ВыборкаНР.ВидЭлемента;
						ТЧТК.Комплектация = ВыборкаНР.Элемент;
				        ТЧТК.Количество = ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла;
						ТЧТК.ЕдиницаИзмерения = ВыборкаНР.Элемент.ЕдиницаИзмерения;
						ТЧТК.Компл = флКомплектация;
							Если Не ВыборкаНР.Элемент.Канбан.Пустая() Тогда	
							ТЧТК.КанбанБезРезервирования = Не ВыборкаНР.Элемент.Канбан.РезервироватьВПроизводстве; 					
							КонецЕсли; 
						Иначе
						Выборка[0].Количество = Выборка[0].Количество + ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла;
						КонецЕсли;
					КонецЕсли;
				Иначе
	 			Выборка = ТаблицаКомплектации.НайтиСтроки(Новый Структура("ЭтапСпецификации,Комплектация",Спецификация,ВыборкаНР.Элемент));
					Если Выборка.Количество() = 0 Тогда
		            ТЧТК = ТаблицаКомплектации.Добавить();
					ТЧТК.ЭтапСпецификации = Спецификация;
					ТЧТК.ВидЭлемента = ВыборкаНР.ВидЭлемента;
					ТЧТК.Комплектация = ВыборкаНР.Элемент;
			        ТЧТК.Количество = ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла;
					ТЧТК.ЕдиницаИзмерения = ВыборкаНР.Элемент.ЕдиницаИзмерения;
					ТЧТК.Компл = флКомплектация;
						Если Не ВыборкаНР.Элемент.Канбан.Пустая() Тогда	
						ТЧТК.КанбанБезРезервирования = Не ВыборкаНР.Элемент.Канбан.РезервироватьВПроизводстве; 					
						КонецЕсли; 
					Иначе
					Выборка[0].Количество = Выборка[0].Количество + ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла;
					КонецЕсли;
				КонецЕсли;
			Иначе
			НР = ВыбАналог[0].АналогНормыРасходов;
			НормыАНР = РегистрыСведений.АналогиНормРасходов.ПолучитьПоследнее(ПЗ.ДатаЗапуска,Новый Структура("АналогНормыРасходов",НР));
			Количество = НормыАНР.Норма*КолУзла;
			Аналог = Истина;
			КонецЕсли;	
		ИначеЕсли ТипЗнач = Тип("СправочникСсылка.Документация")Тогда
		НР = ВыборкаНР.Ссылка;
		Количество = 0;
		Аналог = Ложь;
			Если флКомплектация Тогда
            ТЧТК = ТаблицаКомплектации.Добавить();
			ТЧТК.ЭтапСпецификации = Спецификация;
			ТЧТК.ВидЭлемента = ВыборкаНР.ВидЭлемента;
			ТЧТК.Комплектация = ВыборкаНР.Элемент;
			ТЧТК.Компл = флКомплектация;
	        КонецЕсли;
		Иначе
		Продолжить;
		КонецЕсли;
			Если Не флКомплектация Тогда 
			ТЧ = ТаблицаСпецификации.Добавить();
			ТЧ.Владелец = ?(НаборАналогов = Неопределено,Владелец,НаборАналогов);	
			ТЧ.ЭтапСпецификации = Спецификация;
				Если ЗначениеЗаполнено(Владелец) Тогда
					Если Не ЗначениеЗаполнено(Владелец.Позиция) Тогда
					ТЧ.Позиция = ВыборкаНР.Позиция;
					Иначе	
					ТЧ.Позиция = СокрЛП(Владелец.Позиция)+":"+ВыборкаНР.Позиция;
					КонецЕсли;
				Иначе
				ТЧ.Позиция = ВыборкаНР.Позиция;
				КонецЕсли;
			ТЧ.ТипСправочника = ТипЗнч(НР.Элемент);
			ТЧ.ВидМПЗ = НР.ВидЭлемента;
			ТЧ.МПЗ = НР.Элемент;
			ТЧ.Количество = Количество;
				Попытка
				ТЧ.ЕдиницаИзмерения = НР.Элемент.ОсновнаяЕдиницаИзмерения;
				Исключение
				КонецПопытки;
			ТЧ.Примечание = НР.Примечание;
			ТЧ.Аналог = Аналог;
			КонецЕсли;		
	КонецЦикла;		
КонецПроцедуры

Функция ПолучитьСпецификациюЭтапов(ПЗ,РабочееМесто,Этапы,ТаблицаСпецификации,ТаблицаКомплектации,ТаблицаПодчиненныхДокументов = Неопределено) Экспорт
СписокЭтапов = Новый СписокЗначений;

	Для каждого ТЧ Из Этапы Цикл
	ЭтапРМ = РабочееМесто.ТабличнаяЧасть.Найти(ТЧ.ГруппаНоменклатуры,"ГруппаНоменклатуры");
		Если ЭтапРМ <> Неопределено Тогда
		ПолучитьКомплектациюИСпецификациюСАналогами(ТаблицаКомплектации,ТаблицаСпецификации,ПЗ,ТЧ.ЭтапСпецификации,ТЧ.ЭтапСпецификации,ТЧ.Количество,ЭтапРМ.Комплектация);
			Если Не ЭтапРМ.Комплектация Тогда
			Выборка = ТаблицаКомплектации.НайтиСтроки(Новый Структура("ЭтапСпецификации",ТЧ.ЭтапСпецификации));
				Если Выборка.Количество() = 0 Тогда	
				ТЧТК = ТаблицаКомплектации.Добавить();
				ТЧТК.ЭтапСпецификации = ТЧ.ЭтапСпецификации;
				ТЧТК.Комплектация = ТЧ.ЭтапСпецификации;
				ТЧТК.Количество = ТЧ.Количество;
				ТЧТК.ЕдиницаИзмерения = ТЧ.ЭтапСпецификации.ЕдиницаИзмерения;
				КонецЕсли;
			СписокЭтапов.Добавить(ТЧ.ЭтапСпецификации);
			КонецЕсли;	 
		КонецЕсли;	
	КонецЦикла;
		Если ТаблицаПодчиненныхДокументов <> Неопределено Тогда
			Если ТаблицаПодчиненныхДокументов.Количество() > 0 Тогда	
				Для каждого ТЧ Из ТаблицаКомплектации Цикл
				Выборка = ТаблицаПодчиненныхДокументов.НайтиСтроки(Новый Структура("Номенклатура",ТЧ.Комплектация));
					Если Выборка.Количество() > 0 Тогда
						Для к = 0 По Выборка.ВГраница() Цикл
						ТЧ.ВозвратнаяТара = ТЧ.ВозвратнаяТара + Выборка[к].ВозвратнаяТара + ";";
						КонецЦикла;				
					КонецЕсли; 			
				КонецЦикла; 
			КонецЕсли;
		КонецЕсли;    
			Если ОбщийМодульВызовСервера.ПроверитьОстановкуКанбана(ПЗ,ТаблицаСпецификации) Тогда
			ТаблицаКомплектации.Сортировать("Компл,ЭтапСпецификации,ВидЭлемента,Комплектация");
			ТаблицаСпецификации.Сортировать("ЭтапСпецификации,ВидМПЗ,Позиция,МПЗ");
				Если ТаблицаКомплектации.Количество() = 0 Тогда
			    ТЧТК = ТаблицаКомплектации.Добавить();
				ТЧТК.ЭтапСпецификации = СписокЭтапов[0].Значение; 
				ТЧТК.Комплектация = СписокЭтапов[0].Значение;
				КонецЕсли;
			Возврат(Истина);
			Иначе	
			Возврат(Ложь);
			КонецЕсли; 
КонецФункции

