
&НаСервере
Процедура СформироватьНаСервере()
ТаблицаМПЗ.Очистить();
ТаблицаМПЗКопия = Новый ТаблицаЗначений;
ТабДок.Очистить();

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблМПЗ = Макет.ПолучитьОбласть("МПЗ");
ОблМестоХранения = Макет.ПолучитьОбласть("МестоХранения");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ТабДок.Вывести(ОблШапка);

	Для каждого Док Из СписокИнвентаризаций Цикл
	МестоХранения = Док.Значение.МестоХранения;
		Для каждого ТЧ Из Док.Значение.ТабличнаяЧасть Цикл
		Выборка = ТаблицаМПЗ.НайтиСтроки(Новый Структура("МПЗ,МестоХранения",ТЧ.МПЗ,МестоХранения));
			Если Выборка.Количество() = 0 Тогда
			ТЧ_МПЗ = ТаблицаМПЗ.Добавить();
			ТЧ_МПЗ.МестоХранения = МестоХранения;
			ТЧ_МПЗ.ВидМПЗ = ТЧ.ВидМПЗ;
			ТЧ_МПЗ.МПЗ = ТЧ.МПЗ;
				Если ТЧ.КоличествоУчет - ТЧ.Количество > 0 Тогда
				ТЧ_МПЗ.КоличествоНедостача = ТЧ.КоличествоУчет - ТЧ.Количество;				
				Иначе	
				ТЧ_МПЗ.КоличествоИзлишек = ТЧ.Количество - ТЧ.КоличествоУчет;
				КонецЕсли;
			Иначе
				Если ТЧ.КоличествоУчет - ТЧ.Количество > 0 Тогда
				Выборка[0].КоличествоНедостача = Выборка[0].КоличествоНедостача + (ТЧ.КоличествоУчет - ТЧ.Количество);				
				Иначе	
				Выборка[0].КоличествоИзлишек = Выборка[0].КоличествоИзлишек + (ТЧ.Количество - ТЧ.КоличествоУчет);
				КонецЕсли;						
			КонецЕсли; 			
		КонецЦикла; 
	КонецЦикла;
ТаблицаМПЗ.Сортировать("ВидМПЗ,МПЗ,МестоХранения");
ТаблицаМПЗКопия = ТаблицаМПЗ.Выгрузить();
ТекМПЗ = Неопределено;
	Для каждого ТЧ Из ТаблицаМПЗ Цикл
	флИзлишек = ?(ТЧ.КоличествоИзлишек > 0,Истина,Ложь);
	флНедостача = ?(ТЧ.КоличествоНедостача > 0,Истина,Ложь);
	Выборка = ТаблицаМПЗКопия.НайтиСтроки(Новый Структура("МПЗ",ТЧ.МПЗ));		
	флВыводРазрешен = Ложь;
		Если Выборка.Количество() > 1 Тогда
			Для каждого ТЧ_Копия Из Выборка Цикл	
				Если ТЧ.МестоХранения <> ТЧ_Копия.МестоХранения Тогда
					Если флИзлишек и (ТЧ_Копия.КоличествоНедостача > 0) Тогда
					флВыводРазрешен = Истина;				
					Прервать;
					ИначеЕсли флНедостача и (ТЧ_Копия.КоличествоИзлишек > 0) Тогда
					флВыводРазрешен = Истина;				
					Прервать;
					КонецЕсли; 
				КонецЕсли; 
			КонецЦикла;
				Если флВыводРазрешен Тогда
					Если ТекМПЗ <> ТЧ.МПЗ Тогда		
					ОблМПЗ.Параметры.ВидМПЗ = ТЧ.ВидМПЗ;
					ОблМПЗ.Параметры.Наименование = СокрЛП(ТЧ.МПЗ.Наименование);
					ОблМПЗ.Параметры.МПЗ = ТЧ.МПЗ;
					ТабДок.Вывести(ОблМПЗ);
					ТекМПЗ = ТЧ.МПЗ;					
					КонецЕсли; 
				ОблМестоХранения.Параметры.МестоХранения = ТЧ.МестоХранения;
				ОблМестоХранения.Параметры.КоличествоИзлишек = ТЧ.КоличествоИзлишек;
				ОблМестоХранения.Параметры.КоличествоНедостача = ТЧ.КоличествоНедостача;
				ТабДок.Вывести(ОблМестоХранения);
				КонецЕсли;
		КонецЕсли;   		
	КонецЦикла; 
ТабДок.Вывести(ОблКонец);
ТабДок.ФиксацияСверху = 2;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
СформироватьНаСервере();
КонецПроцедуры
