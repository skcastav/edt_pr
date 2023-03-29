
&НаКлиенте
Процедура ПриОткрытии(Отказ)
КлючУникальности = Новый УникальныйИдентификатор();
ЭтаФорма.Заголовок = "Визуализация канбанов"+Отчет.Линейка;
ПолучитьСписокРМ();
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокЛинеек(МТК)
СписокЛинеек = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Линейки.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Линейки КАК Линейки
	|ГДЕ
	|	Линейки.ПометкаУдаления = ЛОЖЬ
	|	И Линейки.МестоХраненияКанбанов = &МестоХраненияКанбанов";
Запрос.УстановитьПараметр("МестоХраненияКанбанов", МТК.МестоХраненияПотребитель);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	СписокЛинеек.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
Возврат(СписокЛинеек);
КонецФункции	

&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить(); 
	Для каждого ТЧ Из ТаблицаРМ Цикл
	ТЧ.КоличествоВсего = 0;		
	КонецЦикла;
ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Визуализация");

ОблШапкаОбщие = Макет.ПолучитьОбласть("Шапка|Общие");
ОблШапкаВыпуски = Макет.ПолучитьОбласть("Шапка|Выпуски");
ОблШапкаОстановки = Макет.ПолучитьОбласть("Шапка|Остановки");	
ОблШапкаРабочееМесто = Макет.ПолучитьОбласть("Шапка|РабочееМестоПередано");
ОблШапкаРемонт = Макет.ПолучитьОбласть("Шапка|Ремонт");

ОблПериодОбщие = Макет.ПолучитьОбласть("Период|Общие");
ОблПериодВыпуски = Макет.ПолучитьОбласть("Период|Выпуски");
ОблПериодОстановки = Макет.ПолучитьОбласть("Период|Остановки");	
ОблПериодРабочееМесто = Макет.ПолучитьОбласть("Период|РабочееМестоПередано");
ОблПериодРемонт = Макет.ПолучитьОбласть("Период|Ремонт"); 

ОблПЗОбщие = Макет.ПолучитьОбласть("ПЗ|Общие");	
ОблПЗВыпуски = Макет.ПолучитьОбласть("ПЗ|Выпуски");
ОблПЗОстановки = Макет.ПолучитьОбласть("ПЗ|Остановки");
ОблПЗРабочееМестоПередано = Макет.ПолучитьОбласть("ПЗ|РабочееМестоПередано");
ОблПЗРабочееМестоВРаботе = Макет.ПолучитьОбласть("ПЗ|РабочееМестоВРаботе");
ОблПЗРабочееМестоЗавершено = Макет.ПолучитьОбласть("ПЗ|РабочееМестоЗавершено");
ОблПЗРемонт = Макет.ПолучитьОбласть("ПЗ|Ремонт");

ОблПустоРабочееМесто = Макет.ПолучитьОбласть("Пусто|РабочееМестоПередано");
ОблПустоРемонт = Макет.ПолучитьОбласть("Пусто|Ремонт");

ОблВсегоОбщие = Макет.ПолучитьОбласть("Всего|Общие");
ОблВсегоВыпуски = Макет.ПолучитьОбласть("Всего|Выпуски");
ОблВсегоОстановки = Макет.ПолучитьОбласть("Всего|Остановки");	
ОблВсегоРабочееМесто = Макет.ПолучитьОбласть("Всего|РабочееМестоПередано");
ОблВсегоРемонт = Макет.ПолучитьОбласть("Всего|Ремонт");

ОблШапкаОбщие.Параметры.Линейка = ""+Отчет.Линейка+" ("+Отчет.Линейка.Комментарий+")";
ОблШапкаОбщие.Параметры.ТекДата = ТекущаяДата();
Результат = ОбщийМодульВызовСервера.ЛинейкаОстановленаПричины(Отчет.Линейка);
	Если Результат <> Неопределено Тогда
	ОблШапкаОстановки.Параметры.ОстановкаЛинейки = "Остановлена по причине: "+Результат.Примечание+" ("+Результат.Причина+")";
	КонецЕсли; 
ТабДок.Вывести(ОблШапкаОбщие);
	Если ИнформацияПоВыпускам Тогда
	ТабДок.Присоединить(ОблШапкаВыпуски);
	КонецЕсли;
ТабДок.Присоединить(ОблШапкаОстановки);
	Для каждого ТЧ Из ТаблицаРМ Цикл
	ОблШапкаРабочееМесто.Параметры.РабочееМесто = ТЧ.РМ;
	ТабДок.Присоединить(ОблШапкаРабочееМесто);
	КонецЦикла;
ТабДок.Присоединить(ОблШапкаРемонт);

ЗапросЛО = Новый Запрос;

ЗапросЛО.Текст = 
	"ВЫБРАТЬ
	|	ЛьготнаяОчередь.ПЗ
	|ИЗ
	|	РегистрСведений.ЛьготнаяОчередь КАК ЛьготнаяОчередь
	|ГДЕ
	|	ЛьготнаяОчередь.Линейка = &Линейка
	|	И ЛьготнаяОчередь.ДатаОкончания = ДАТАВРЕМЯ(1,1,1,0,0,0)";
	Если Не Изделие.Пустая() Тогда
	ЗапросЛО.Текст = ЗапросЛО.Текст + " И ЛьготнаяОчередь.Изделие = &Изделие";
	ЗапросЛО.УстановитьПараметр("Изделие",Изделие);
	КонецЕсли;
ЗапросЛО.УстановитьПараметр("Линейка",Отчет.Линейка);
РезультатЗапроса = ЗапросЛО.Выполнить();
ВыборкаЛО = РезультатЗапроса.Выбрать();

ЗапросВыпуск = Новый Запрос;

ЗапросВыпуск.Текст = 
	"ВЫБРАТЬ
	|	ПланыВыпускаОстаткиИОбороты.МаршрутнаяКарта,
	|	ПланыВыпускаОстаткиИОбороты.КоличествоРасход,
	|	ПланыВыпускаОстаткиИОбороты.КоличествоКонечныйОстаток
	|ИЗ
	|	РегистрНакопления.ПланыВыпуска.ОстаткиИОбороты(&ДатаНач, &ДатаКон, , , ) КАК ПланыВыпускаОстаткиИОбороты
	|ГДЕ
	|	ПланыВыпускаОстаткиИОбороты.МаршрутнаяКарта.Линейка = &Линейка";
	Если Не Изделие.Пустая() Тогда
	ЗапросВыпуск.Текст = ЗапросВыпуск.Текст + " И ПланыВыпускаОстаткиИОбороты.Номенклатура = &Изделие";
	ЗапросВыпуск.УстановитьПараметр("Изделие",Изделие);
	КонецЕсли; 
ЗапросВыпуск.УстановитьПараметр("ДатаНач", НачалоДня(ТекущаяДата()));
ЗапросВыпуск.УстановитьПараметр("ДатаКон", ТекущаяДата());
ЗапросВыпуск.УстановитьПараметр("Линейка",Отчет.Линейка);
РезультатЗапроса = ЗапросВыпуск.Выполнить();
ВыборкаВыпуск = РезультатЗапроса.Выбрать();

Запрос = Новый Запрос;
ЗапросРемонт = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ КАК ПЗ,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Дата КАК Период,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.Ремонт
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.Линейка = &Линейка
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
	Если Не ЛинияSMD.Пустая() Тогда
	Запрос.Текст = Запрос.Текст + " И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ЛинияSMD = &Линия";
	Запрос.УстановитьПараметр("Линия",ЛинияSMD);
	КонецЕсли; 
		Если Не Изделие.Пустая() Тогда
		Запрос.Текст = Запрос.Текст + " И ЭтапыПроизводственныхЗаданийСрезПоследних.Изделие = &Изделие";
		Запрос.УстановитьПараметр("Изделие",Изделие);
		КонецЕсли;
			Если СписокМестХраненияПотребителей.Количество() > 0 Тогда
			Запрос.Текст = Запрос.Текст + " И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.МестоХраненияПотребитель В(&СписокМестХраненияПотребитель)";
			Запрос.УстановитьПараметр("СписокМестХраненияПотребитель",СписокМестХраненияПотребителей);
			КонецЕсли;
Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО
								|ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Номер,
								|ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.Номер
								|ИТОГИ ПО
								|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Дата ПЕРИОДАМИ(ДЕНЬ, , )";	
Запрос.УстановитьПараметр("Линейка",Отчет.Линейка);
КолНеВыпущенныхВсего = 0;
КолВсего = 0;
КолБракВсего = 0; 
КолВыпВсего = 0;
КолЛОИзготВсего = 0;
КолИЛОИзготВсего = 0;
КолЛОПотрВсего = 0;
КолОстановкаВсего = 0;
КолРемонтВсего = 0;
КолНезапущенныхВсего = 0;
Результат = Запрос.Выполнить();
ТекущийПериод = "01.01.2001";
ВыборкаПериоды = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПериоды.Следующий() Цикл
		Если ТекущийПериод <> Формат(ВыборкаПериоды.Период,"ДФ=dd.MM.yyyy") Тогда
		ОблПериодОбщие.Параметры.Период = Формат(ВыборкаПериоды.Период,"ДФ=dd.MM.yyyy"); 
		ТабДок.Вывести(ОблПериодОбщие);
			Если ИнформацияПоВыпускам Тогда
			ТабДок.Присоединить(ОблПериодВыпуски);
			КонецЕсли;
		ТабДок.Присоединить(ОблПериодОстановки);
			Для каждого ТЧ Из ТаблицаРМ Цикл
			ТабДок.Присоединить(ОблПериодРабочееМесто);
			КонецЦикла;
		ТабДок.Присоединить(ОблПериодРемонт);			
		ТекущийПериод = Формат(ВыборкаПериоды.Период,"ДФ=dd.MM.yyyy")
		КонецЕсли;
	ВыборкаДетальныеЗаписи = ВыборкаПериоды.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ПЗ = ВыборкаДетальныеЗаписи.ПЗ;
			Для каждого ТЧ Из ТаблицаРМ Цикл
			ТЧ.Количество = 0;
			ТЧ.Статус = 0;		
			КонецЦикла;
		КолНеВыпущенных = 0; 	
		КолЛОИзгот = 0;
		КолИЛОИзгот = 0;
		КолЛОПотр = 0;
		КолОстановка = 0;
		КолРемонт = 0;
		КолНезапущенных = 0;
		КолБрак = ОбщийМодульВызовСервера.ПолучитьКоличествоВБраке(ПЗ.ДокументОснование);
		КолБракВсего = КолБракВсего + КолБрак;
		КолВсего = КолВсего + ПЗ.Количество; 
		ВыборкаВыпуск.Сбросить();
			Если ВыборкаВыпуск.НайтиСледующий(Новый Структура("МаршрутнаяКарта",ПЗ.ДокументОснование)) Тогда
			КолВып = ПЗ.ДокументОснование.Количество - ВыборкаВыпуск.КоличествоКонечныйОстаток;
			КолВыпВсего = КолВыпВсего + КолВып;	
			Иначе
			КолВып = ПЗ.ДокументОснование.Количество;
			КонецЕсли;
		ЗапросЛО.Текст = 
			"ВЫБРАТЬ
			|	ЛьготнаяОчередь.ПЗ КАК ПЗ
			|ИЗ
			|	РегистрСведений.ЛьготнаяОчередь КАК ЛьготнаяОчередь
			|ГДЕ
			|	ЛьготнаяОчередь.Линейка В(&СписокЛинеек)
			|	И ЛьготнаяОчередь.НормаРасходов.Элемент = &МПЗ
			|	И ЛьготнаяОчередь.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
		ЗапросЛО.УстановитьПараметр("МПЗ",ПЗ.Изделие);
		ЗапросЛО.УстановитьПараметр("СписокЛинеек",ПолучитьСписокЛинеек(ПЗ.ДокументОснование));
		РезультатЗапросаЛО = ЗапросЛО.Выполнить();
			Если Не РезультатЗапросаЛО.Пустой() Тогда
			КолЛОПотрВсего = КолЛОПотрВсего + ПЗ.ДокументОснование.Количество;				
			КонецЕсли;
		Кол = ОбщийМодульВызовСервера.ПолучитьКоличествоИзделияНаРабочемМесте(ПЗ,ВыборкаДетальныеЗаписи.РабочееМесто);
		КолНеВыпущенных = КолНеВыпущенных + Кол;
		КолНеВыпущенныхВсего = КолНеВыпущенныхВсего + Кол; 
		ЛОИзгот = "";
		СтатусРемонта = Перечисления.СтатусыРемонта.ПустаяСсылка();
			Если ЗначениеЗаполнено(ПЗ.ДатаЗапуска) Тогда
				Если ВыборкаДетальныеЗаписи.Ремонт Тогда	
				ЗапросРемонт.Текст = 
					"ВЫБРАТЬ
					|	РемонтнаяКарта.Ссылка
					|ИЗ
					|	Документ.РемонтнаяКарта КАК РемонтнаяКарта
					|ГДЕ
					|	РемонтнаяКарта.ДокументОснование = &ДокументОснование
					|	И РемонтнаяКарта.Проведен = ЛОЖЬ";			
				ЗапросРемонт.УстановитьПараметр("ДокументОснование", ПЗ);		
				РезультатЗапросаРемонт = ЗапросРемонт.Выполнить();			
				ВыборкаДетальныеЗаписиРемонт = РезультатЗапросаРемонт.Выбрать();			
					Пока ВыборкаДетальныеЗаписиРемонт.Следующий() Цикл
					СтатусРемонта = Перечисления.СтатусыРемонта.Ремонт;
					КолРемонт = КолРемонт + Кол;
					КолРемонтВсего = КолРемонтВсего + Кол;
					КонецЦикла;
				КонецЕсли;
					Для каждого ТЧ Из ТаблицаРМ Цикл
					//Выборка = ТаблицаРМ.НайтиСтроки(Новый Структура("РМ",ТЧ.РМ));
					ЗапросЭП = Новый Запрос;

					ЗапросЭП.Текст = 
						"ВЫБРАТЬ
						|	ЭтапыПроизводственныхЗаданий.Исполнитель КАК Исполнитель,
						|	ЭтапыПроизводственныхЗаданий.ДатаОкончания КАК ДатаОкончания,
						|	ЭтапыПроизводственныхЗаданий.ДатаНачала КАК ДатаНачала
						|ИЗ
						|	РегистрСведений.ЭтапыПроизводственныхЗаданий КАК ЭтапыПроизводственныхЗаданий
						|ГДЕ
						|	ЭтапыПроизводственныхЗаданий.ПЗ = &ПЗ
						|	И ЭтапыПроизводственныхЗаданий.РабочееМесто = &РабочееМесто";
					ЗапросЭП.УстановитьПараметр("ПЗ", ПЗ);
					ЗапросЭП.УстановитьПараметр("РабочееМесто", ТЧ.РМ);
					РезультатЗапросаЭП = ЗапросЭП.Выполнить();
					ВыборкаЭП = РезультатЗапросаЭП.Выбрать();
						Если ВыборкаЭП.Количество() > 0 Тогда
							Пока ВыборкаЭП.Следующий() Цикл
								Если Не ЗначениеЗаполнено(ВыборкаЭП.ДатаОкончания) Тогда
								    Если ЗначениеЗаполнено(ПЗ.ДатаЗапуска) Тогда
										Если ВыборкаЭП.Исполнитель.Пустая() Тогда
										ТЧ.Статус = 1; //Передано										
										Иначе
										ТЧ.Статус = 2; //В работе											
										КонецЕсли;
									Кол = ОбщийМодульВызовСервера.ПолучитьКоличествоИзделияНаРабочемМесте(ПЗ,ТЧ.РМ);
									ТЧ.Количество = ТЧ.Количество + Кол;
									ТЧ.КоличествоВсего = ТЧ.КоличествоВсего + Кол;
									Иначе
										Если ЗначениеЗаполнено(ВыборкаЭП.ДатаНачала) Тогда
										ТЧ.Статус = 1; //Передано
										Иначе	
										ТЧ.Статус = 0; //Пусто										
										КонецЕсли; 
									КонецЕсли;
								Иначе
								ДатаОкончания = ВыборкаЭП.ДатаОкончания; 
								ТЧ.ДатаВремя = ВыборкаЭП.ДатаОкончания;
								ТЧ.Статус = 3; //Завершено
								КонецЕсли; 
							КонецЦикла;
						Иначе
					    ТЧ.Статус = 0; //Пусто
						КонецЕсли;
					КонецЦикла;
			Иначе
			ТЧ = ТаблицаРМ[0];
			ЗапросЭП = Новый Запрос;

			ЗапросЭП.Текст = 
				"ВЫБРАТЬ
				|	ЭтапыПроизводственныхЗаданий.ДатаНачала КАК ДатаНачала
				|ИЗ
				|	РегистрСведений.ЭтапыПроизводственныхЗаданий КАК ЭтапыПроизводственныхЗаданий
				|ГДЕ
				|	ЭтапыПроизводственныхЗаданий.ПЗ = &ПЗ
				|	И ЭтапыПроизводственныхЗаданий.РабочееМесто.Код = 1";
			ЗапросЭП.УстановитьПараметр("ПЗ", ПЗ);
			РезультатЗапросаЭП = ЗапросЭП.Выполнить();
			ВыборкаЭП = РезультатЗапросаЭП.Выбрать();
				Если ВыборкаЭП.Количество() > 0 Тогда
					Пока ВыборкаЭП.Следующий() Цикл
						Если ЗначениеЗаполнено(ВыборкаЭП.ДатаНачала) Тогда
						ТЧ.Статус = 1; //Передано
						Иначе	
						ТЧ.Статус = 0; //Пусто										
						КонецЕсли;
					КонецЦикла;
				Иначе
			    ТЧ.Статус = 0; //Пусто
				КонецЕсли;
			ВыборкаЛО.Сбросить();
				Если ВыборкаЛО.НайтиСледующий(Новый Структура("ПЗ",ПЗ)) Тогда
				ИЛО = ОбщийМодульВызовСервера.ИстиннаяЛьготнаяОчередь(ПЗ);
				КолНезав = ОбщийМодульВызовСервера.ПолучитьНезапущенноеКоличество(ПЗ.ДокументОснование);
					Если ИЛО Тогда
					ЛОИзгот = "ИЛО";					
					КолИЛОИзгот = КолИЛОИзгот + КолНезав;
					КолИЛОИзготВсего = КолИЛОИзготВсего + КолНезав;
					Иначе	
					ЛОИзгот = "ЛО";
					КолЛОИзгот = КолЛОИзгот + КолНезав;
					КолЛОИзготВсего = КолЛОИзготВсего + КолНезав;
					КонецЕсли;				
				КонецЕсли; 
			КолНезапущенных = КолНезапущенных + Кол;
			КолНезапущенныхВсего = КолНезапущенныхВсего + Кол;
			КонецЕсли;
	    ОблПЗОбщие.Параметры.ПЗ = ПЗ;
		ОблПЗОбщие.Параметры.НомерПЗ = ПЗ.Номер;
	    ОблПЗОбщие.Параметры.НО = ПЗ.НомерОчереди;
		ОблПЗОбщие.Параметры.Наименование = СокрЛП(ПЗ.Изделие.Наименование);
		ОблПЗОбщие.Параметры.Статус = ПолучитьСтатус(ПЗ.Изделие,ТекущаяДата());
		ОблПЗОбщие.Параметры.Количество = ПЗ.Количество;
		ОблПЗОбщие.Параметры.Линия = ПЗ.ЛинияSMD;
			Если (ПЗ.Остановлено)или(ПЗ.ДокументОснование.Статус = 2) Тогда
			Остановка = Истина;
			ТекОбл = ТабДок.Вывести(ОблПЗОбщие);
			ТабДок.Область(ТекОбл.Верх, ТекОбл.Лево, ТекОбл.Низ, ТекОбл.Право).ЦветФона = Новый Цвет(255,0,0);
			ТабДок.Область(ТекОбл.Верх, ТекОбл.Лево, ТекОбл.Низ, ТекОбл.Право).ЦветТекста = Новый Цвет(255,255,255);
			Иначе
			Остановка = Ложь;
			ТабДок.Вывести(ОблПЗОбщие);
			КонецЕсли;
				Если ИнформацияПоВыпускам Тогда
				ОблПЗВыпуски.Параметры.КолНеВыпущенных = КолНеВыпущенных;
				ОблПЗВыпуски.Параметры.КолНезапущенных = КолНезапущенных;
				ОблПЗВыпуски.Параметры.КолВып = КолВып;
				ТабДок.Присоединить(ОблПЗВыпуски);
				КонецЕсли;
		ОблПЗОстановки.Параметры.Остановка = ?(Остановка,"О","");
		ОблПЗОстановки.Параметры.ПЗ = ПЗ;
		ОблПЗОстановки.Параметры.ЛОИзгот = ЛОИзгот;
		ОблПЗОстановки.Параметры.ЛОПотр = ?(РезультатЗапросаЛО.Пустой(),"","ЛО");
			Если ПЗ.Остановлено Тогда
			ТекОбл = ТабДок.Присоединить(ОблПЗОстановки);
			ТабДок.Область(ТекОбл.Верх, ТекОбл.Лево, ТекОбл.Низ, ТекОбл.Лево).ЦветФона = Новый Цвет(255,0,0);
			ТабДок.Область(ТекОбл.Верх, ТекОбл.Лево, ТекОбл.Низ, ТекОбл.Лево).ЦветТекста = Новый Цвет(255,255,255);
				Если КолОстановка = 0 Тогда
				КолОстановка = ПЗ.Количество;
				КолОстановкаВсего = КолОстановкаВсего + КолОстановка;
				КонецЕсли;
			Иначе
			ТабДок.Присоединить(ОблПЗОстановки);
			КонецЕсли;
				Для каждого ТЧ Из ТаблицаРМ Цикл
					Если ТЧ.Статус = 0 Тогда
					ТабДок.Присоединить(ОблПустоРабочееМесто);
					ИначеЕсли ТЧ.Статус = 1 Тогда	
					ТабДок.Присоединить(ОблПЗРабочееМестоПередано);
					ИначеЕсли ТЧ.Статус = 2 Тогда	
					ТабДок.Присоединить(ОблПЗРабочееМестоВРаботе);
					ИначеЕсли ТЧ.Статус = 3 Тогда
					ОблПЗРабочееМестоЗавершено.Параметры.Время = ДатаОкончания;	
					ТабДок.Присоединить(ОблПЗРабочееМестоЗавершено);
					КонецЕсли; 	
				КонецЦикла;
					Если Не СтатусРемонта.Пустая() Тогда 
					ОблПЗРемонт.Параметры.ПЗ = ПЗ;
					ОблПЗРемонт.Параметры.ВидКанбана = СокрЛП(ПЗ.Изделие.Канбан.Наименование);
					ОблПЗРемонт.Параметры.МестоХраненияПотребитель = ПЗ.ДокументОснование.МестоХраненияПотребитель;
					ТабДок.Присоединить(ОблПЗРемонт);
					Иначе
					ОблПустоРемонт.Параметры.ВидКанбана = СокрЛП(ПЗ.Изделие.Канбан.Наименование);
					ОблПустоРемонт.Параметры.МестоХраненияПотребитель = ПЗ.ДокументОснование.МестоХраненияПотребитель;
					ТабДок.Присоединить(ОблПустоРемонт);			
					КонецЕсли; 			
		КонецЦикла;
	КонецЦикла;
ОблВсегоВыпуски.Параметры.КолНеВыпущенных = КолНеВыпущенныхВсего;
ОблВсегоВыпуски.Параметры.КолБрак = КолБракВсего;
ОблВсегоВыпуски.Параметры.КолНезапущенных = КолНезапущенныхВсего;
ОблВсегоВыпуски.Параметры.КолВып = КолВыпВсего;
ОблВсегоОстановки.Параметры.КолЛОИзгот = КолЛОИзготВсего;
ОблВсегоОстановки.Параметры.КолИЛОИзгот = КолИЛОИзготВсего;
ОблВсегоОстановки.Параметры.КолЛОПотр = КолЛОПотрВсего;
ОблВсегоОстановки.Параметры.КолОстановка = КолОстановкаВсего;
ОблВсегоОбщие.Параметры.КолВсего = КолВсего;
ТабДок.Вывести(ОблВсегоОбщие);
	Если ИнформацияПоВыпускам Тогда
	ТабДок.Присоединить(ОблВсегоВыпуски);
	КонецЕсли;
ТабДок.Присоединить(ОблВсегоОстановки);
	Для каждого ТЧ Из ТаблицаРМ Цикл
	ОблВсегоРабочееМесто.Параметры.КолРМ = ТЧ.КоличествоВсего;
	ТабДок.Присоединить(ОблВсегоРабочееМесто);
	КонецЦикла;
ОблВсегоРемонт.Параметры.КолРемонт = КолРемонтВсего; 
ТабДок.Присоединить(ОблВсегоРемонт); 
ТабДок.ФиксацияСверху = 2;
ТабДок.ФиксацияСлева = 4;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокРМ()
	Если Отчет.Линейка.Пустая() Тогда
	Возврат;
	КонецЕсли;
ТаблицаРМ.Очистить(); 
Запрос = Новый Запрос;
Запрос.Текст = 
	"ВЫБРАТЬ
	|	РабочиеМестаЛинеек.Ссылка,
	|	РабочиеМестаЛинеек.ПометкаУдаления,
	|	РабочиеМестаЛинеек.Код КАК Код,
	|	РабочиеМестаЛинеек.Линейка,
	|	РабочиеМестаЛинеек.Наименование
	|ИЗ
	|	Справочник.РабочиеМестаЛинеек КАК РабочиеМестаЛинеек
	|ГДЕ
	|	РабочиеМестаЛинеек.Линейка = &Линейка
	|	И РабочиеМестаЛинеек.ПометкаУдаления = ЛОЖЬ
	|	И РабочиеМестаЛинеек.ЭтоГруппа = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код";
Запрос.УстановитьПараметр("Линейка", Отчет.Линейка);
Результат = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = ТаблицаРМ.Добавить();
	ТЧ.РМ = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЛинейкаПриИзменении(Элемент)
ЭтаФорма.Заголовок = "Визуализация "+Отчет.Линейка;
ПолучитьСписокРМ();
КонецПроцедуры

&НаКлиенте
Процедура ЛинейкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Не ОбщийМодульВызовСервера.ЭтоЛинейкаКанбан(ВыбранноеЗначение) Тогда
	СтандартнаяОбработка = Ложь;
	Сообщить("Выберите канбанную линейку!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьЛО(ПЗ)
СписокЛО = Новый СписокЗначений;
ЗапросЛО = Новый Запрос;

ЗапросЛО.Текст = 
	"ВЫБРАТЬ
	|	ЛьготнаяОчередь.Период,
	|	ЛьготнаяОчередь.НормаРасходов.Элемент КАК МПЗ
	|ИЗ
	|	РегистрСведений.ЛьготнаяОчередь КАК ЛьготнаяОчередь
	|ГДЕ
	|	ЛьготнаяОчередь.ПЗ = &ПЗ
	|	И ЛьготнаяОчередь.ДатаОкончания = ДАТАВРЕМЯ(1,1,1,0,0,0)";
ЗапросЛО.УстановитьПараметр("ПЗ",ПЗ);
РезультатЗапроса = ЗапросЛО.Выполнить();
ВыборкаЛО = РезультатЗапроса.Выбрать();
	Пока ВыборкаЛО.Следующий() Цикл
	СписокЛО.Добавить(СокрЛП(ВыборкаЛО.МПЗ.Наименование)+" ("+ВыборкаЛО.Период+")");
	КонецЦикла;
Возврат(СписокЛО);
КонецФункции

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	Если ТипЗнч(Расшифровка) = Тип("ДокументСсылка.ПроизводственноеЗадание") Тогда
	ИмяКолонки = СокрЛП(Сред(Элемент.ТекущаяОбласть.Имя,Найти(Элемент.ТекущаяОбласть.Имя,"C")));
	НомерКолонки = Число(Сред(ИмяКолонки,2));
		Если ИнформацияПоВыпускам Тогда
			Если НомерКолонки > 10 Тогда
			СтандартнаяОбработка = Ложь;
			П = Новый Структура("ПЗ",Расшифровка);
			ОткрытьФорму("Отчет.ОтчетПоРемонту.Форма.ФормаОтчета",П);
	        ИначеЕсли НомерКолонки = 10 Тогда
			СтандартнаяОбработка = Ложь;
			СписокЛО = ПолучитьЛО(Расшифровка);
			СписокЛО.ВыбратьЭлемент("Льготная очередь");
			КонецЕсли;
		Иначе
			Если НомерКолонки > 7 Тогда
			СтандартнаяОбработка = Ложь;
			П = Новый Структура("ПЗ",Расшифровка);
			ОткрытьФорму("Отчет.ОтчетПоРемонту.Форма.ФормаОтчета",П);
	        ИначеЕсли НомерКолонки = 7 Тогда
			СтандартнаяОбработка = Ложь;
			СписокЛО = ПолучитьЛО(Расшифровка);
			СписокЛО.ВыбратьЭлемент("Льготная очередь");
			КонецЕсли;					
		КонецЕсли; 	
	КонецЕсли; 
КонецПроцедуры
