
&НаСервере
Функция ПолучитьКоличествоОстатков(ЗОП,МПЗ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДвижениеМПЗТабличнаяЧасть.Количество КАК Количество
	|ИЗ
	|	Документ.ДвижениеМПЗ.ТабличнаяЧасть КАК ДвижениеМПЗТабличнаяЧасть
	|ГДЕ
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.ДокументОснование = &ДокументОснование
	|	И ДвижениеМПЗТабличнаяЧасть.Ссылка.Проведен = ИСТИНА
	|	И ДвижениеМПЗТабличнаяЧасть.МПЗ = &МПЗ";
Запрос.УстановитьПараметр("ДокументОснование", ЗОП);
Запрос.УстановитьПараметр("МПЗ", МПЗ);
РезультатЗапроса = Запрос.Выполнить();
Количество = 0;
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Количество = Количество + ВыборкаДетальныеЗаписи.Количество;
	КонецЦикла;
Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеализацияТабличнаяЧасть.Количество КАК Количество
	|ИЗ
	|	Документ.Реализация.ТабличнаяЧасть КАК РеализацияТабличнаяЧасть
	|ГДЕ
	|	РеализацияТабличнаяЧасть.Ссылка.ДокументОснование = &ДокументОснование
	|	И РеализацияТабличнаяЧасть.Ссылка.Проведен = ИСТИНА
	|	И РеализацияТабличнаяЧасть.Товар = &МПЗ";
Запрос.УстановитьПараметр("ДокументОснование", ЗОП);
Запрос.УстановитьПараметр("МПЗ", МПЗ);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Количество = Количество - ВыборкаДетальныеЗаписи.Количество;
	КонецЦикла;
Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписаниеМПЗПрочееТабличнаяЧасть.Количество КАК Количество
	|ИЗ
	|	Документ.СписаниеМПЗПрочее.ТабличнаяЧасть КАК СписаниеМПЗПрочееТабличнаяЧасть
	|ГДЕ
	|	СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.ДокументОснование = &ДокументОснование
	|	И СписаниеМПЗПрочееТабличнаяЧасть.Ссылка.Проведен = ИСТИНА
	|	И СписаниеМПЗПрочееТабличнаяЧасть.МПЗ = &МПЗ";
Запрос.УстановитьПараметр("ДокументОснование", ЗОП);
Запрос.УстановитьПараметр("МПЗ", МПЗ);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Количество = Количество - ВыборкаДетальныеЗаписи.Количество;
	КонецЦикла;
Возврат(Количество);
КонецФункции

&НаСервере
Функция ПолучитьКоличествоПоРазборкам(ЗОП,МПЗ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	РазборкаТабличнаяЧасть.Количество КАК Количество
	|ИЗ
	|	Документ.Разборка.ТабличнаяЧасть КАК РазборкаТабличнаяЧасть
	|ГДЕ
	|	РазборкаТабличнаяЧасть.Ссылка.ДокументОснование = &ДокументОснование
	|	И РазборкаТабличнаяЧасть.Ссылка.Проведен = ИСТИНА
	|	И РазборкаТабличнаяЧасть.МПЗ = &МПЗ";
Запрос.УстановитьПараметр("ДокументОснование", ЗОП);
Запрос.УстановитьПараметр("МПЗ", МПЗ);
РезультатЗапроса = Запрос.Выполнить();
Количество = 0;
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Количество = Количество + ВыборкаДетальныеЗаписи.Количество;
	КонецЦикла;
Возврат(Количество);
КонецФункции

&НаСервере
Функция ПолучитьКоличествоПоМТК(ЗОП,Номенклатура)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаршрутнаяКарта.Количество КАК Количество
	|ИЗ
	|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
	|ГДЕ
	|	МаршрутнаяКарта.ДокументОснование = &ДокументОснование
	|	И МаршрутнаяКарта.Статус = 3
	|	И МаршрутнаяКарта.Номенклатура = &Номенклатура";
Запрос.УстановитьПараметр("ДокументОснование", ЗОП);
Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
РезультатЗапроса = Запрос.Выполнить();
Количество = 0;
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Количество = Количество + ВыборкаДетальныеЗаписи.Количество;
	КонецЦикла;
Возврат(Количество);
КонецФункции

&НаСервере
Процедура ПроверитьНаСервере()
тДерево = РеквизитФормыВЗначение("ДеревоЗаявок");
тДерево.Строки.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаявкиОтПокупателейОстатки.ЗаявкаОтПокупателя КАК ЗаявкаОтПокупателя,
	|	ЗаявкиОтПокупателейОстатки.МПЗ КАК МПЗ,
	|	ЗаявкиОтПокупателейОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ЗаявкиОтПокупателей.Остатки КАК ЗаявкиОтПокупателейОстатки
	|ГДЕ
	|	ЗаявкиОтПокупателейОстатки.Контрагент В ИЕРАРХИИ(&СписокКонтрагентов)";
	Если ВидМПЗ = 1 Тогда	
	Запрос.Текст = Запрос.Текст + " И ТИПЗНАЧЕНИЯ(ЗаявкиОтПокупателейОстатки.МПЗ) = ТИП(Справочник.Материалы)";	
	ИначеЕсли ВидМПЗ = 2 Тогда	
	Запрос.Текст = Запрос.Текст + " И ТИПЗНАЧЕНИЯ(ЗаявкиОтПокупателейОстатки.МПЗ) = ТИП(Справочник.Номенклатура)";
	КонецЕсли; 
Запрос.Текст = Запрос.Текст + "	УПОРЯДОЧИТЬ ПО
								|	ЗаявкиОтПокупателейОстатки.ЗаявкаОтПокупателя.Номер,
								|	ЗаявкиОтПокупателейОстатки.МПЗ.Наименование
								|ИТОГИ
								|	СУММА(КоличествоОстаток)
								|ПО
								|	ЗаявкаОтПокупателя,
								|	МПЗ";
Запрос.УстановитьПараметр("СписокКонтрагентов", СписокКонтрагентов);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаЗаявки = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаЗаявки.Следующий() Цикл
	Стр = тДерево.Строки.Добавить();
	Стр.ЗаявкаОтПокупателя = ВыборкаЗаявки.ЗаявкаОтПокупателя;
	ВыборкаМПЗ = ВыборкаЗаявки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаМПЗ.Следующий() Цикл
		ВыборкаДетальныеЗаписи = ВыборкаМПЗ.Выбрать();
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СтрМПЗ = Стр.Строки.Добавить();
			СтрМПЗ.МПЗ = ВыборкаМПЗ.МПЗ;
			СтрМПЗ.Количество = ВыборкаДетальныеЗаписи.КоличествоОстаток;
			СтрМПЗ.КоличествоНаСкладе = ПолучитьКоличествоОстатков(ВыборкаЗаявки.ЗаявкаОтПокупателя,ВыборкаМПЗ.МПЗ)+ПолучитьКоличествоПоМТК(ВыборкаЗаявки.ЗаявкаОтПокупателя,ВыборкаМПЗ.МПЗ)+ПолучитьКоличествоПоРазборкам(ВыборкаЗаявки.ЗаявкаОтПокупателя,ВыборкаМПЗ.МПЗ);
			Выборка = Стр.ЗаявкаОтПокупателя.ТабличнаяЧасть.Найти(ВыборкаМПЗ.МПЗ,"МПЗ");
				Если Выборка <> Неопределено Тогда
				СтрМПЗ.Комментарий = Выборка.Комментарий;
				КонецЕсли; 			
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
ЗначениеВРеквизитФормы(тДерево, "ДеревоЗаявок");
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
ПроверитьНаСервере();
КонецПроцедуры
