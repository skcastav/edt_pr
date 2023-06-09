
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
ВидОтчёта = 1;
РасчётПо = 1;
КонецПроцедуры

&НаСервере
Функция НазваниеМесяца(НомерМесяца)

ТекМесяц = Лев(НомерМесяца,2);
ТекГод = Сред(НомерМесяца,4);
	Если ТекМесяц = "01" Тогда
	Возврат("Январь "+ТекГод);	
	ИначеЕсли ТекМесяц = "02" Тогда
	Возврат("Февраль "+ТекГод);
	ИначеЕсли ТекМесяц = "03" Тогда
	Возврат("Март "+ТекГод);
	ИначеЕсли ТекМесяц = "04" Тогда
	Возврат("Апрель "+ТекГод);
	ИначеЕсли ТекМесяц = "05" Тогда
	Возврат("Май "+ТекГод);
	ИначеЕсли ТекМесяц = "06" Тогда
	Возврат("Июнь "+ТекГод);
	ИначеЕсли ТекМесяц = "07" Тогда
	Возврат("Июль "+ТекГод);
	ИначеЕсли ТекМесяц = "08" Тогда
	Возврат("Август "+ТекГод);
	ИначеЕсли ТекМесяц = "09" Тогда
	Возврат("Сентябрь "+ТекГод);
	ИначеЕсли ТекМесяц = "10" Тогда
	Возврат("Октябрь "+ТекГод);
	ИначеЕсли ТекМесяц = "11" Тогда
	Возврат("Ноябрь "+ТекГод);
	ИначеЕсли ТекМесяц = "12" Тогда
	Возврат("Декабрь "+ТекГод);	
	КонецЕсли;

КонецФункции

&НаСервере
Процедура СформироватьПоКанбанамНаСервере()
ТабДок.Очистить();
Запрос = Новый Запрос;
ТаблицаОборачиваемости = Новый ТаблицаЗначений;

ТаблицаОборачиваемости.Колонки.Добавить("Месяц",Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(7)));
ТаблицаОборачиваемости.Колонки.Добавить("Количество",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(14,3)));

ТекДата = Отчет.Период.ДатаНачала;
	Пока ТекДата <= Отчет.Период.ДатаОкончания Цикл
	ТекМесяц = Формат(Месяц(ТекДата),"ЧЦ=2; ЧВН=")+"."+Формат(Год(ТекДата),"ЧЦ=4; ЧГ=0");
	Выборка = ТаблицаОборачиваемости.НайтиСтроки(Новый Структура("Месяц",ТекМесяц));
		Если Выборка.Количество() = 0 Тогда
		ТЧ = ТаблицаОборачиваемости.Добавить();
		ТЧ.Месяц = ТекМесяц;
		КонецЕсли;
	ТекДата = ТекДата + 86400;
    КонецЦикла;
ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("МакетПоКанбанам");
ОблШапкаОбщие = Макет.ПолучитьОбласть("Шапка|Общие");	
ОблШапкаМесяц = Макет.ПолучитьОбласть("Шапка|Месяц");
ОблШапкаИтого = Макет.ПолучитьОбласть("Шапка|Итого");
ОблМПЗОбщие = Макет.ПолучитьОбласть("МПЗ|Общие");	
ОблМПЗМесяц = Макет.ПолучитьОбласть("МПЗ|Месяц");
ОблМПЗИтого = Макет.ПолучитьОбласть("МПЗ|Итого");
ОблКонецОбщие = Макет.ПолучитьОбласть("Конец|Общие");	
ОблКонецМесяц = Макет.ПолучитьОбласть("Конец|Месяц");
ОблКонецИтого = Макет.ПолучитьОбласть("Конец|Итого");

ОблШапкаОбщие.Параметры.ДатаНач = Отчет.Период.ДатаНачала;
ОблШапкаОбщие.Параметры.ДатаКон = Отчет.Период.ДатаОкончания;
ОблШапкаОбщие.Параметры.Подразделение = Отчет.Подразделение;
ОблШапкаОбщие.Параметры.ВидОтчёта = "По местам хранения (расчёт по канбанам поставщика)";
ТабДок.Вывести(ОблШапкаОбщие);
	Для каждого ТЧ Из ТаблицаОборачиваемости Цикл
	ОблШапкаМесяц.Параметры.Месяц = НазваниеМесяца(ТЧ.Месяц);
	ТабДок.Присоединить(ОблШапкаМесяц);
	КонецЦикла;
ТабДок.Присоединить(ОблШапкаИтого);  

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаХраненияОстаткиИОбороты.МПЗ КАК МПЗ,
	|	МестаХраненияОстаткиИОбороты.КоличествоНачальныйОстаток,
	|	МестаХраненияОстаткиИОбороты.КоличествоРасход,
	|	МестаХраненияОстаткиИОбороты.Регистратор,
	|	МестаХраненияОстаткиИОбороты.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток
	|ИЗ
	|	РегистрНакопления.МестаХранения.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор, , ) КАК МестаХраненияОстаткиИОбороты
	|ГДЕ
	|	МестаХраненияОстаткиИОбороты.МестоХранения В(&СписокМестХранения)
	|	И МестаХраненияОстаткиИОбороты.МПЗ В(&СписокМПЗ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	МестаХраненияОстаткиИОбороты.МПЗ.Наименование
	|ИТОГИ
	|	СУММА(КоличествоКонечныйОстаток)
	|ПО
	|	МПЗ";	
Запрос.УстановитьПараметр("ДатаНач",Отчет.Период.ДатаНачала);
Запрос.УстановитьПараметр("ДатаКон",Отчет.Период.ДатаОкончания);
Запрос.УстановитьПараметр("СписокМестХранения",СписокМестХранения);
Запрос.УстановитьПараметр("СписокМПЗ",СписокМПЗ);
Результат = Запрос.Выполнить();
ВыборкаМПЗ = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаМПЗ.Следующий() Цикл
	Изделие = ВыборкаМПЗ.МПЗ;
	ОблМПЗОбщие.Параметры.Статус = ПолучитьСтатус(Изделие,ТекущаяДата());
	ОблМПЗОбщие.Параметры.МПЗ = Изделие;
		Если ТипЗнч(Изделие) = Тип("СправочникСсылка.Номенклатура") Тогда
		ОблМПЗОбщие.Параметры.ВидКанбана = Изделие.Канбан;
		КолЯчеек = Изделие.КолКанбан;
		КолВЯчейке = Изделие.КолВКанбане;
		Иначе
		КолЯчеек = 0;
		КолВЯчейке = 0;		
		КонецЕсли; 
	ОблМПЗОбщие.Параметры.КолЯчеек = КолЯчеек;
	ОблМПЗОбщие.Параметры.КолВЯчейке = КолВЯчейке;
	ТаблицаОборачиваемости.ЗаполнитьЗначения(0,"Количество");
	ОблМПЗОбщие.Параметры.Остаток = ВыборкаМПЗ.КоличествоКонечныйОстаток/Изделие.ОсновнаяЕдиницаИзмерения.Коэффициент;
	Себестоимость = РегистрыСведений.Себестоимость.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("Номенклатура,Подразделение",Изделие,Отчет.Подразделение));
	ОблМПЗОбщие.Параметры.Себестоимость = Себестоимость.СебестоимостьПолная;
	ОблМПЗОбщие.Параметры.СебестоимостьПартии = Себестоимость.СебестоимостьПолная*КолВЯчейке*КолЯчеек; 
	ТабДок.Вывести(ОблМПЗОбщие);
	Выборка  = ВыборкаМПЗ.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.КоличествоРасход = 0 Тогда
			Продолжить;
			КонецЕсли; 	
		ТекМесяц = Формат(Месяц(Выборка.Регистратор.Дата),"ЧЦ=2; ЧВН=")+"."+Формат(Год(Выборка.Регистратор.Дата),"ЧЦ=4; ЧГ=0");
		СтрокаТаблицы = ТаблицаОборачиваемости.НайтиСтроки(Новый Структура("Месяц",ТекМесяц));
			Если СтрокаТаблицы.Количество() > 0 Тогда
			СтрокаТаблицы[0].Количество = СтрокаТаблицы[0].Количество + Выборка.КоличествоРасход/Изделие.ОсновнаяЕдиницаИзмерения.Коэффициент; 
			КонецЕсли;			
		КонецЦикла;  
			Для каждого ТЧ Из ТаблицаОборачиваемости Цикл
			ОблМПЗМесяц.Параметры.КолВМесяц = ТЧ.Количество;
				Если КолВЯчейке > 0 Тогда
				ОблМПЗМесяц.Параметры.КолКОЯ = Окр(ТЧ.Количество/КолВЯчейке,1,1);
				Иначе
				ОблМПЗМесяц.Параметры.КолКОЯ = 0;
				КонецЕсли;
					Если КолЯчеек*КолВЯчейке > 0 Тогда
					ОблМПЗМесяц.Параметры.КолКОК = Окр(ТЧ.Количество/(КолЯчеек*КолВЯчейке),1,1);
					Иначе
					ОблМПЗМесяц.Параметры.КолКОК = 0;
					КонецЕсли;
			ТабДок.Присоединить(ОблМПЗМесяц);
			КонецЦикла;
	КолИтого = ТаблицаОборачиваемости.Итог("Количество");
		Если КолВЯчейке > 0 Тогда
		КолКОЯИтого = Окр(КолИтого/КолВЯчейке,1,1);
		Иначе
		КолКОЯИтого = 0;
		КонецЕсли; 
			Если КолЯчеек*КолВЯчейке > 0 Тогда
			КолКОКИтого = Окр(КолИтого/(КолЯчеек*КолВЯчейке),1,1);
			Иначе
			КолКОКИтого = 0;
			КонецЕсли;
	ОблМПЗИтого.Параметры.КолИтого = КолИтого;
	ОблМПЗИтого.Параметры.КолКОЯИтого = КолКОЯИтого;
	ОблМПЗИтого.Параметры.КолКОКИтого = КолКОКИтого;
	ТабДок.Присоединить(ОблМПЗИтого);
	КонецЦикла;
ТабДок.Вывести(ОблКонецОбщие);
	Для каждого ТЧ Из ТаблицаОборачиваемости Цикл
	ТабДок.Присоединить(ОблКонецМесяц);
	КонецЦикла;
ТабДок.Присоединить(ОблКонецИтого); 
ТабДок.ФиксацияСверху = 4;
ТабДок.ФиксацияСлева = 2;
КонецПроцедуры

&НаСервере
Процедура СформироватьПоЯчейкамНаСервере()
ТабДок.Очистить();
Запрос = Новый Запрос;		
ТаблицаОборачиваемости = Новый ТаблицаЗначений;

ТаблицаОборачиваемости.Колонки.Добавить("Месяц",Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(7)));
ТаблицаОборачиваемости.Колонки.Добавить("Количество",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(14,3)));

ТекДата = Отчет.Период.ДатаНачала;
	Пока ТекДата <= Отчет.Период.ДатаОкончания Цикл
	ТекМесяц = Формат(Месяц(ТекДата),"ЧЦ=2; ЧВН=")+"."+Формат(Год(ТекДата),"ЧЦ=4; ЧГ=0");
	Выборка = ТаблицаОборачиваемости.НайтиСтроки(Новый Структура("Месяц",ТекМесяц));
		Если Выборка.Количество() = 0 Тогда
		ТЧ = ТаблицаОборачиваемости.Добавить();
		ТЧ.Месяц = ТекМесяц;
		КонецЕсли;
	ТекДата = ТекДата + 86400;
    КонецЦикла;
ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("МакетПоЯчейкам"); 
ОблШапкаОбщие = Макет.ПолучитьОбласть("Шапка|Общие");	
ОблШапкаМесяц = Макет.ПолучитьОбласть("Шапка|Месяц");
ОблШапкаИтого = Макет.ПолучитьОбласть("Шапка|Итого");
ОблМПЗОбщие = Макет.ПолучитьОбласть("МПЗ|Общие");	
ОблМПЗМесяц = Макет.ПолучитьОбласть("МПЗ|Месяц");
ОблМПЗИтого = Макет.ПолучитьОбласть("МПЗ|Итого");
ОблКонецОбщие = Макет.ПолучитьОбласть("Конец|Общие");	
ОблКонецМесяц = Макет.ПолучитьОбласть("Конец|Месяц");
ОблКонецИтого = Макет.ПолучитьОбласть("Конец|Итого");

ОблШапкаОбщие.Параметры.ДатаНач = Отчет.Период.ДатаНачала;
ОблШапкаОбщие.Параметры.ДатаКон = Отчет.Период.ДатаОкончания;
ОблШапкаОбщие.Параметры.Подразделение = Отчет.Подразделение;
ОблШапкаОбщие.Параметры.ВидОтчёта = "По местам хранения (расчёт по ячейкам мест хранения)";
ТабДок.Вывести(ОблШапкаОбщие);
	Для каждого ТЧ Из ТаблицаОборачиваемости Цикл
	ОблШапкаМесяц.Параметры.Месяц = НазваниеМесяца(ТЧ.Месяц);
	ТабДок.Присоединить(ОблШапкаМесяц);
	КонецЦикла;
ТабДок.Присоединить(ОблШапкаИтого);  

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаХраненияОстаткиИОбороты.МестоХранения КАК МестоХранения,
	|	МестаХраненияОстаткиИОбороты.МПЗ КАК МПЗ,
	|	МестаХраненияОстаткиИОбороты.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	|	МестаХраненияОстаткиИОбороты.КоличествоРасход КАК КоличествоРасход,
	|	МестаХраненияОстаткиИОбороты.Регистратор КАК Регистратор,
	|	МестаХраненияОстаткиИОбороты.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток
	|ИЗ
	|	РегистрНакопления.МестаХранения.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор, , ) КАК МестаХраненияОстаткиИОбороты
	|ГДЕ
	|	МестаХраненияОстаткиИОбороты.МестоХранения В(&СписокМестХранения)
	|	И МестаХраненияОстаткиИОбороты.МПЗ В(&СписокМПЗ)
	|УПОРЯДОЧИТЬ ПО
	|	МестаХраненияОстаткиИОбороты.МПЗ.Наименование
	|ИТОГИ
	|	СУММА(КоличествоКонечныйОстаток)
	|ПО
	|	МПЗ";		
Запрос.УстановитьПараметр("ДатаНач",Отчет.Период.ДатаНачала);
Запрос.УстановитьПараметр("ДатаКон",Отчет.Период.ДатаОкончания);
Запрос.УстановитьПараметр("СписокМестХранения",СписокМестХранения);
Запрос.УстановитьПараметр("СписокМПЗ", СписокМПЗ);
Результат = Запрос.Выполнить();
ВыборкаМПЗ = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаМПЗ.Следующий() Цикл
	Изделие = ВыборкаМПЗ.МПЗ;
	ОблМПЗОбщие.Параметры.Статус = ПолучитьСтатус(Изделие,ТекущаяДата());
	ОблМПЗОбщие.Параметры.МПЗ = Изделие;
			Если ТипЗнч(Изделие) = Тип("СправочникСсылка.Номенклатура") Тогда
			ОблМПЗОбщие.Параметры.ВидКанбана = Изделие.Канбан;
			КонецЕсли; 
		Для каждого МестоХранения Из СписокМестХранения Цикл
		ОблМПЗОбщие.Параметры.МестоХранения = МестоХранения.Значение;
		ЯчейкиКомплектации = ОбщийМодульРаботаСРегистрами.ПолучитьЯчейкуКомплектацииПоМестуХранения(МестоХранения.Значение,Изделие);
			Если ЯчейкиКомплектации.КоличествоЯчеек = 0 Тогда	
			Продолжить;
			КонецЕсли; 
		КолЯчеек = ЯчейкиКомплектации.КоличествоЯчеек;
		КолВЯчейке = ЯчейкиКомплектации.КоличествоВЯчейке;
		ОблМПЗОбщие.Параметры.КолЯчеек = КолЯчеек;
		ОблМПЗОбщие.Параметры.КолВЯчейке = КолВЯчейке;
		ТаблицаОборачиваемости.ЗаполнитьЗначения(0,"Количество");
		КолОст = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоМестуХранения(МестоХранения.Значение,Изделие);
		ОблМПЗОбщие.Параметры.Остаток = КолОст/Изделие.ОсновнаяЕдиницаИзмерения.Коэффициент; 
		Себестоимость = РегистрыСведений.Себестоимость.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("Номенклатура,Подразделение",Изделие,Отчет.Подразделение));
		ОблМПЗОбщие.Параметры.Себестоимость = Себестоимость.СебестоимостьПолная;
		ОблМПЗОбщие.Параметры.СебестоимостьПартии = Себестоимость.СебестоимостьПолная*КолВЯчейке*КолЯчеек;
		ТабДок.Вывести(ОблМПЗОбщие);
		Выборка  = ВыборкаМПЗ.Выбрать();
			Пока Выборка.Следующий() Цикл
				Если Выборка.МестоХранения <> МестоХранения.Значение Тогда
				Продолжить;				
				КонецЕсли; 
					Если Выборка.КоличествоРасход = 0 Тогда
					Продолжить;
					КонецЕсли; 	
			ТекМесяц = Формат(Месяц(Выборка.Регистратор.Дата),"ЧЦ=2; ЧВН=")+"."+Формат(Год(Выборка.Регистратор.Дата),"ЧЦ=4; ЧГ=0");
			СтрокаТаблицы = ТаблицаОборачиваемости.НайтиСтроки(Новый Структура("Месяц",ТекМесяц));
				Если СтрокаТаблицы.Количество() > 0 Тогда
				СтрокаТаблицы[0].Количество = СтрокаТаблицы[0].Количество + Выборка.КоличествоРасход/Изделие.ОсновнаяЕдиницаИзмерения.Коэффициент; 
				КонецЕсли;			
			КонецЦикла;  
				Для каждого ТЧ Из ТаблицаОборачиваемости Цикл
				ОблМПЗМесяц.Параметры.КолВМесяц = ТЧ.Количество;
					Если КолВЯчейке > 0 Тогда
					ОблМПЗМесяц.Параметры.КолКОЯ = Окр(ТЧ.Количество/КолВЯчейке,1,1);
					Иначе
					ОблМПЗМесяц.Параметры.КолКОЯ = 0;
					КонецЕсли;
						Если КолЯчеек*КолВЯчейке > 0 Тогда
						ОблМПЗМесяц.Параметры.КолКОК = Окр(ТЧ.Количество/(КолЯчеек*КолВЯчейке),1,1);
						Иначе
						ОблМПЗМесяц.Параметры.КолКОК = 0;
						КонецЕсли;
				ТабДок.Присоединить(ОблМПЗМесяц);
				КонецЦикла;
		КолИтого = ТаблицаОборачиваемости.Итог("Количество");
			Если КолВЯчейке > 0 Тогда
			КолКОЯИтого = Окр(КолИтого/КолВЯчейке,1,1);
			Иначе
			КолКОЯИтого = 0;
			КонецЕсли; 
				Если КолЯчеек*КолВЯчейке > 0 Тогда
				КолКОКИтого = Окр(КолИтого/(КолЯчеек*КолВЯчейке),1,1);
				Иначе
				КолКОКИтого = 0;
				КонецЕсли;
		ОблМПЗИтого.Параметры.КолИтого = КолИтого;
		ОблМПЗИтого.Параметры.КолКОЯИтого = КолКОЯИтого;
		ОблМПЗИтого.Параметры.КолКОКИтого = КолКОКИтого;
		ТабДок.Присоединить(ОблМПЗИтого);
		КонецЦикла; 
	КонецЦикла;
ТабДок.Вывести(ОблКонецОбщие);
	Для каждого ТЧ Из ТаблицаОборачиваемости Цикл
	ТабДок.Присоединить(ОблКонецМесяц);
	КонецЦикла;
ТабДок.Присоединить(ОблКонецИтого); 
ТабДок.ФиксацияСверху = 4;
ТабДок.ФиксацияСлева = 2;
КонецПроцедуры

&НаСервере
Процедура РаскрытьНаМПЗВсюСпецификацию(Спецификация,КолУзла,ТаблицаМПЗ,НомерПериода)
НормРасх = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_М(Спецификация,ТекущаяДата());
	Пока НормРасх.Следующий() Цикл			
		Если ТипЗнч(НормРасх.Элемент) = Тип("СправочникСсылка.Номенклатура")Тогда
		СтрокаТаблицы = ТаблицаМПЗ.Найти(НормРасх.Элемент,"МПЗ");
			Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы[НомерПериода] = СтрокаТаблицы[НомерПериода] + ПолучитьБазовоеКоличество(НормРасх.Норма,НормРасх.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла;				
			КонецЕсли; 					
		РаскрытьНаМПЗВсюСпецификацию(НормРасх.Элемент,ПолучитьБазовоеКоличество(НормРасх.Норма,НормРасх.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла,ТаблицаМПЗ,НомерПериода);				
		Иначе
		СтрокаТаблицы = ТаблицаМПЗ.Найти(НормРасх.Элемент,"МПЗ");
			Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы[НомерПериода] = СтрокаТаблицы[НомерПериода] + ПолучитьБазовоеКоличество(НормРасх.Норма,НормРасх.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла;				
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПодсчётПерспективныхПланов(ТаблицаМПЗ)
Запрос = Новый Запрос;

НомерПериода = 1;
	Для каждого Стр Из СписокПериодов Цикл
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПерспективныеПланыСрезПоследних.МПЗ,
		|	ПерспективныеПланыСрезПоследних.Количество
		|ИЗ
		|	РегистрСведений.ПерспективныеПланы.СрезПоследних(&НаДату, ) КАК ПерспективныеПланыСрезПоследних";
		Если СписокЛинеек.Количество() > 0 Тогда
			Если СписокЛинеек[0].Значение.ЭтоГруппа Тогда	
			Запрос.Текст = Запрос.Текст + " ГДЕ ПерспективныеПланыСрезПоследних.МПЗ.Линейка В ИЕРАРХИИ(&СписокЛинеек)";			
			Иначе
			Запрос.Текст = Запрос.Текст + " ГДЕ ПерспективныеПланыСрезПоследних.МПЗ.Линейка В (&СписокЛинеек)";
			КонецЕсли;		
		Запрос.УстановитьПараметр("СписокЛинеек", СписокЛинеек);
		КонецЕсли; 
	Запрос.УстановитьПараметр("НаДату", НачалоМесяца(Стр.Значение));
		Если СписокГруппНоменклатуры.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + " И ПерспективныеПланыСрезПоследних.МПЗ В ИЕРАРХИИ(&СписокГруппНоменклатуры)";
		Запрос.УстановитьПараметр("СписокГруппНоменклатуры", СписокГруппНоменклатуры);
		КонецЕсли; 
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		РаскрытьНаМПЗВсюСпецификацию(ВыборкаДетальныеЗаписи.МПЗ,ВыборкаДетальныеЗаписи.Количество,ТаблицаМПЗ,НомерПериода);
		КонецЦикла;
	НомерПериода = НомерПериода + 1;
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура СформироватьПоПППоКанбанамНаСервере()
ТабДок.Очистить();
СписокПериодов.Очистить();
Запрос = Новый Запрос;
ТаблицаМПЗ = Новый ТаблицаЗначений;
МассивМПЗ = Новый Массив;

МассивМПЗ.Добавить(Тип("СправочникСсылка.Номенклатура"));
МассивМПЗ.Добавить(Тип("СправочникСсылка.Материалы"));

ТаблицаМПЗ.Колонки.Добавить("МПЗ",Новый ОписаниеТипов(МассивМПЗ));
	Для каждого МПЗ Из СписокМПЗ Цикл
	ТЧ = ТаблицаМПЗ.Добавить();
	ТЧ.МПЗ = МПЗ.Значение;	
	КонецЦикла;	
Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаХраненияОстатки.МестоХранения,
	|	МестаХраненияОстатки.МПЗ,
	|	МестаХраненияОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.МестаХранения.Остатки(&НаДату, ) КАК МестаХраненияОстатки
	|ГДЕ
	|	МестаХраненияОстатки.МестоХранения В(&СписокМестХранения)
	|	И МестаХраненияОстатки.МПЗ В(&СписокМПЗ)";	
Запрос.УстановитьПараметр("НаДату",ТекущаяДата());
Запрос.УстановитьПараметр("СписокМестХранения",СписокМестХранения);
Запрос.УстановитьПараметр("СписокМПЗ",СписокМПЗ);
Результат = Запрос.Выполнить();
ВыборкаМПЗ = Результат.Выбрать();

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("МакетПоКанбанам");
ОблШапкаОбщие = Макет.ПолучитьОбласть("Шапка|Общие");	
ОблШапкаМесяц = Макет.ПолучитьОбласть("Шапка|Месяц");
ОблШапкаИтого = Макет.ПолучитьОбласть("Шапка|Итого");
ОблМПЗОбщие = Макет.ПолучитьОбласть("МПЗ|Общие");	
ОблМПЗМесяц = Макет.ПолучитьОбласть("МПЗ|Месяц");
ОблМПЗИтого = Макет.ПолучитьОбласть("МПЗ|Итого");
ОблКонецОбщие = Макет.ПолучитьОбласть("Конец|Общие");	
ОблКонецМесяц = Макет.ПолучитьОбласть("Конец|Месяц");
ОблКонецИтого = Макет.ПолучитьОбласть("Конец|Итого");

ОблШапкаОбщие.Параметры.ДатаНач = Отчет.Период.ДатаНачала;
ОблШапкаОбщие.Параметры.ДатаКон = Отчет.Период.ДатаОкончания;
ОблШапкаОбщие.Параметры.Подразделение = Отчет.Подразделение;
ОблШапкаОбщие.Параметры.ВидОтчёта = "По перспективному плану (расчёт по канбанам поставщика)";
ТабДок.Вывести(ОблШапкаОбщие);
ТекДата = Отчет.Период.ДатаНачала;
ТекМесяц = "";
	Пока ТекДата <= Отчет.Период.ДатаОкончания Цикл
	ВыбМесяц = Формат(Месяц(ТекДата),"ЧЦ=2; ЧВН=")+"."+Формат(Год(ТекДата),"ЧЦ=4; ЧГ=0");
		Если ТекМесяц <> ВыбМесяц Тогда
		СписокПериодов.Добавить(НачалоМесяца(ТекДата));
		ТаблицаМПЗ.Колонки.Добавить("Д"+СписокПериодов.Количество(),Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(14,3)));			
		ОблШапкаМесяц.Параметры.Месяц = НазваниеМесяца(ВыбМесяц);
		ТабДок.Присоединить(ОблШапкаМесяц);
		ТекМесяц = ВыбМесяц;
		КонецЕсли; 
	ТекДата = ТекДата + 86400;
    КонецЦикла;
ТабДок.Присоединить(ОблШапкаИтого); 

ПодсчётПерспективныхПланов(ТаблицаМПЗ);

	Для каждого ТЧ Из ТаблицаМПЗ Цикл
	КолИтого = 0;
		Для к = 1 По СписокПериодов.Количество() Цикл
		КолИтого = КолИтого + ТЧ[к];
		КонецЦикла; 
			Если КолИтого = 0 Тогда
			Продолжить;			
			КонецЕсли; 
	Изделие = ТЧ.МПЗ;
	ОблМПЗОбщие.Параметры.Статус = ПолучитьСтатус(Изделие,ТекущаяДата());
	ОблМПЗОбщие.Параметры.МПЗ = Изделие;
		Если ТипЗнч(Изделие) = Тип("СправочникСсылка.Номенклатура") Тогда
		ОблМПЗОбщие.Параметры.ВидКанбана = Изделие.Канбан;
		КолЯчеек = Изделие.КолКанбан;
		КолВЯчейке = Изделие.КолВКанбане;
		Иначе
		КолЯчеек = 0;
		КолВЯчейке = 0;		
		КонецЕсли;
	ОблМПЗОбщие.Параметры.КолЯчеек = КолЯчеек;
	ОблМПЗОбщие.Параметры.КолВЯчейке = КолВЯчейке; 
	ВыборкаМПЗ.Сбросить();
	КолОст = 0;
		Пока ВыборкаМПЗ.НайтиСледующий(Новый Структура("МПЗ",Изделие)) Цикл
		КолОст = КолОст + ВыборкаМПЗ.КоличествоОстаток;		
		КонецЦикла;
	ОблМПЗОбщие.Параметры.Остаток = КолОст/Изделие.ОсновнаяЕдиницаИзмерения.Коэффициент;
	Себестоимость = РегистрыСведений.Себестоимость.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("Номенклатура,Подразделение",Изделие,Отчет.Подразделение));
	ОблМПЗОбщие.Параметры.Себестоимость = Себестоимость.СебестоимостьПолная;
	ОблМПЗОбщие.Параметры.СебестоимостьПартии = Себестоимость.СебестоимостьПолная*КолВЯчейке*КолЯчеек;
	ТабДок.Вывести(ОблМПЗОбщие);
		Для к = 1 По СписокПериодов.Количество() Цикл
		КолВМесяц = ТЧ[к];
		ОблМПЗМесяц.Параметры.КолВМесяц = КолВМесяц;
			Если КолВЯчейке > 0 Тогда
			ОблМПЗМесяц.Параметры.КолКОЯ = Окр(КолВМесяц/КолВЯчейке,1,1);
			Иначе
			ОблМПЗМесяц.Параметры.КолКОЯ = 0;
			КонецЕсли;
				Если КолЯчеек*КолВЯчейке > 0 Тогда
				ОблМПЗМесяц.Параметры.КолКОК = Окр(КолВМесяц/(КолЯчеек*КолВЯчейке),1,1);
				Иначе
				ОблМПЗМесяц.Параметры.КолКОК = 0;
				КонецЕсли;
		ТабДок.Присоединить(ОблМПЗМесяц);
		КонецЦикла;
			Если КолВЯчейке > 0 Тогда
			КолКОЯИтого = Окр(КолИтого/КолВЯчейке,1,1);
			Иначе
			КолКОЯИтого = 0;
			КонецЕсли; 
				Если КолЯчеек*КолВЯчейке > 0 Тогда
				КолКОКИтого = Окр(КолИтого/(КолЯчеек*КолВЯчейке),1,1);
				Иначе
				КолКОКИтого = 0;
				КонецЕсли;
	ОблМПЗИтого.Параметры.КолИтого = КолИтого;
	ОблМПЗИтого.Параметры.КолКОЯИтого = КолКОЯИтого;
	ОблМПЗИтого.Параметры.КолКОКИтого = КолКОКИтого;
	ТабДок.Присоединить(ОблМПЗИтого);
	КонецЦикла;
ТабДок.Вывести(ОблКонецОбщие);
	Для каждого Стр Из СписокПериодов Цикл
	ТабДок.Присоединить(ОблКонецМесяц);
	КонецЦикла;
ТабДок.Присоединить(ОблКонецИтого); 
ТабДок.ФиксацияСверху = 4;
ТабДок.ФиксацияСлева = 2;
КонецПроцедуры

&НаСервере
Процедура СформироватьПоПППоЯчейкамНаСервере()
ТабДок.Очистить();
СписокПериодов.Очистить();
Запрос = Новый Запрос;
ТаблицаМПЗ = Новый ТаблицаЗначений;
МассивМПЗ = Новый Массив;

МассивМПЗ.Добавить(Тип("СправочникСсылка.Номенклатура"));
МассивМПЗ.Добавить(Тип("СправочникСсылка.Материалы"));

ТаблицаМПЗ.Колонки.Добавить("МПЗ",Новый ОписаниеТипов(МассивМПЗ));
	Для каждого МПЗ Из СписокМПЗ Цикл
	ТЧ = ТаблицаМПЗ.Добавить();
	ТЧ.МПЗ = МПЗ.Значение;	
	КонецЦикла;	
ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("МакетПоЯчейкам"); 
ОблШапкаОбщие = Макет.ПолучитьОбласть("Шапка|Общие");	
ОблШапкаМесяц = Макет.ПолучитьОбласть("Шапка|Месяц");
ОблШапкаИтого = Макет.ПолучитьОбласть("Шапка|Итого");
ОблМПЗОбщие = Макет.ПолучитьОбласть("МПЗ|Общие");	
ОблМПЗМесяц = Макет.ПолучитьОбласть("МПЗ|Месяц");
ОблМПЗИтого = Макет.ПолучитьОбласть("МПЗ|Итого");
ОблКонецОбщие = Макет.ПолучитьОбласть("Конец|Общие");	
ОблКонецМесяц = Макет.ПолучитьОбласть("Конец|Месяц");
ОблКонецИтого = Макет.ПолучитьОбласть("Конец|Итого");

ОблШапкаОбщие.Параметры.ДатаНач = Отчет.Период.ДатаНачала;
ОблШапкаОбщие.Параметры.ДатаКон = Отчет.Период.ДатаОкончания;
ОблШапкаОбщие.Параметры.Подразделение = Отчет.Подразделение;
ОблШапкаОбщие.Параметры.ВидОтчёта = "По перспективному плану (расчёт по ячейкам мест хранения)";
ТабДок.Вывести(ОблШапкаОбщие);
ТекДата = Отчет.Период.ДатаНачала;
ТекМесяц = "";
	Пока ТекДата <= Отчет.Период.ДатаОкончания Цикл
	ВыбМесяц = Формат(Месяц(ТекДата),"ЧЦ=2; ЧВН=")+"."+Формат(Год(ТекДата),"ЧЦ=4; ЧГ=0");
		Если ТекМесяц <> ВыбМесяц Тогда
		СписокПериодов.Добавить(НачалоМесяца(ТекДата));
		ТаблицаМПЗ.Колонки.Добавить("Д"+СписокПериодов.Количество(),Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(14,3)));			
		ОблШапкаМесяц.Параметры.Месяц = НазваниеМесяца(ВыбМесяц);
		ТабДок.Присоединить(ОблШапкаМесяц);
		ТекМесяц = ВыбМесяц;
		КонецЕсли; 
	ТекДата = ТекДата + 86400;
    КонецЦикла;
ТабДок.Присоединить(ОблШапкаИтого); 

ПодсчётПерспективныхПланов(ТаблицаМПЗ);

	Для каждого ТЧ Из ТаблицаМПЗ Цикл
	КолИтого = 0;
		Для к = 1 По СписокПериодов.Количество() Цикл
		КолИтого = КолИтого + ТЧ[к];
		КонецЦикла; 
			Если КолИтого = 0 Тогда
			Продолжить;			
			КонецЕсли; 
	Изделие = ТЧ.МПЗ;
	ОблМПЗОбщие.Параметры.Статус = ПолучитьСтатус(Изделие,ТекущаяДата());
	ОблМПЗОбщие.Параметры.МПЗ = Изделие;
			Если ТипЗнч(Изделие) = Тип("СправочникСсылка.Номенклатура") Тогда
			ОблМПЗОбщие.Параметры.ВидКанбана = Изделие.Канбан;	
			КонецЕсли; 
		Для каждого МестоХранения Из СписокМестХранения Цикл
		ОблМПЗОбщие.Параметры.МестоХранения = МестоХранения.Значение;
		ЯчейкиКомплектации = ОбщийМодульРаботаСРегистрами.ПолучитьЯчейкуКомплектацииПоМестуХранения(МестоХранения.Значение,Изделие);
			Если ЯчейкиКомплектации.КоличествоЯчеек = 0 Тогда
			Продолжить;
			КонецЕсли; 
		КолЯчеек = ЯчейкиКомплектации.КоличествоЯчеек;
		КолВЯчейке = ЯчейкиКомплектации.КоличествоВЯчейке;
		ОблМПЗОбщие.Параметры.КолЯчеек = КолЯчеек;
		ОблМПЗОбщие.Параметры.КолВЯчейке = КолВЯчейке;
		КолОст = ОбщийМодульРаботаСРегистрами.ПолучитьОстатокПоМестуХранения(МестоХранения.Значение,Изделие);
		ОблМПЗОбщие.Параметры.Остаток = КолОст/Изделие.ОсновнаяЕдиницаИзмерения.Коэффициент;
		Себестоимость = РегистрыСведений.Себестоимость.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("Номенклатура,Подразделение",Изделие,Отчет.Подразделение));
		ОблМПЗОбщие.Параметры.Себестоимость = Себестоимость.СебестоимостьПолная;
		ОблМПЗОбщие.Параметры.СебестоимостьПартии = Себестоимость.СебестоимостьПолная*КолВЯчейке*КолЯчеек;
		ТабДок.Вывести(ОблМПЗОбщие);
			Для к = 1 По СписокПериодов.Количество() Цикл
			КолВМесяц = ТЧ[к];
			ОблМПЗМесяц.Параметры.КолВМесяц = КолВМесяц;
				Если КолВЯчейке > 0 Тогда
				ОблМПЗМесяц.Параметры.КолКОЯ = Окр(КолВМесяц/КолВЯчейке,1,1);
				Иначе
				ОблМПЗМесяц.Параметры.КолКОЯ = 0;
				КонецЕсли;
					Если КолЯчеек*КолВЯчейке > 0 Тогда
					ОблМПЗМесяц.Параметры.КолКОК = Окр(КолВМесяц/(КолЯчеек*КолВЯчейке),1,1);
					Иначе
					ОблМПЗМесяц.Параметры.КолКОК = 0;
					КонецЕсли;
			ТабДок.Присоединить(ОблМПЗМесяц);
			КонецЦикла;
				Если КолВЯчейке > 0 Тогда
				КолКОЯИтого = Окр(КолИтого/КолВЯчейке,1,1);
				Иначе
				КолКОЯИтого = 0;
				КонецЕсли; 
					Если КолЯчеек*КолВЯчейке > 0 Тогда
					КолКОКИтого = Окр(КолИтого/(КолЯчеек*КолВЯчейке),1,1);
					Иначе
					КолКОКИтого = 0;
					КонецЕсли;
		ОблМПЗИтого.Параметры.КолИтого = КолИтого;
		ОблМПЗИтого.Параметры.КолКОЯИтого = КолКОЯИтого;
		ОблМПЗИтого.Параметры.КолКОКИтого = КолКОКИтого;
		ТабДок.Присоединить(ОблМПЗИтого);
		КонецЦикла;
	КонецЦикла;
ТабДок.Вывести(ОблКонецОбщие);
	Для каждого Стр Из СписокПериодов Цикл
	ТабДок.Присоединить(ОблКонецМесяц);
	КонецЦикла;
ТабДок.Присоединить(ОблКонецИтого); 
ТабДок.ФиксацияСверху = 4;
ТабДок.ФиксацияСлева = 2;
КонецПроцедуры

&НаСервере
Функция СоздатьСписокМПЗ()
СписокМПЗ.Очистить();
Запрос = Новый Запрос;

	Если ВидМПЗ = 0 Тогда
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Материалы.Ссылка
		|ИЗ
		|	Справочник.Материалы КАК Материалы
		|ГДЕ
		|	Материалы.ЭтоГруппа = ЛОЖЬ";
		Если СписокМатериалов.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + " И Материалы.Ссылка В ИЕРАРХИИ(&СписокМатериалов)";		
		Запрос.УстановитьПараметр("СписокМатериалов", СписокМатериалов);
		КонецЕсли; 	
	Иначе	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Канбан.Подразделение = &Подразделение";
	Запрос.УстановитьПараметр("Подразделение", Отчет.Подразделение);	
	КонецЕсли;
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	СписокМПЗ.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
		Если СписокМПЗ.Количество() = 0 Тогда
		Сообщить("В списке нет ни одного канбана по выбранному подразделению!");
		Возврат(Ложь);
		КонецЕсли;
Возврат(Истина);
КонецФункции

&НаКлиенте
Процедура Сформировать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	Состояние("Обработка...",,"Создание списка МПЗ...");
		Если СоздатьСписокМПЗ() Тогда
		Состояние("Обработка...",,"Формирование таблицы отчёта...");
			Если ВидОтчёта = 1 Тогда
				Если РасчётПо = 1 Тогда
				СформироватьПоКанбанамНаСервере();		
				Иначе	
				СформироватьПоЯчейкамНаСервере();			
				КонецЕсли; 
			Иначе
				Если РасчётПо = 1 Тогда
				СформироватьПоПППоКанбанамНаСервере();		
				Иначе	
				СформироватьПоПППоЯчейкамНаСервере();			
				КонецЕсли; 	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;  
КонецПроцедуры

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
ИмяКолонки = СокрЛП(Сред(Элемент.ТекущаяОбласть.Имя,Найти(Элемент.ТекущаяОбласть.Имя,"C")));
НомерКолонки = Число(Сред(ИмяКолонки,2));
	Если РасчётПо = 1 Тогда
		Если НомерКолонки = 6 Тогда
		СтандартнаяОбработка = Ложь;
		ИмяОтчета = "ОтчётПоРегиструМестаХранения";
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
		ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,ТекущаяДата(),ТекущаяДата(),Новый Структура("МПЗ,МестоХранения",Расшифровка,СписокМестХранения),"ОстаткиПоСкладам"));
		ПараметрыФормы.Вставить("КлючВарианта","ОстаткиПоСкладам"); 
		ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы);
		КонецЕсли;	
	Иначе		
		Если НомерКолонки = 7 Тогда
		СтандартнаяОбработка = Ложь;
		ИмяОтчета = "ОтчётПоРегиструМестаХранения";
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
		ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,ТекущаяДата(),ТекущаяДата(),Новый Структура("МПЗ,МестоХранения",Расшифровка,СписокМестХранения),"ОстаткиПоСкладам"));
		ПараметрыФормы.Вставить("КлючВарианта","ОстаткиПоСкладам"); 
		ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы);
		КонецЕсли;	
	КонецЕсли; 
КонецПроцедуры
