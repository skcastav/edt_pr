
&НаСервере
Функция ЕстьПрефиксЭтапа(ГруппаНоменклатуры)
Возврат(ЗначениеЗаполнено(ГруппаНоменклатуры.Префикс));
КонецФункции

&НаКлиенте
Процедура ТабличнаяЧастьГруппаНоменклатурыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Не ЕстьПрефиксЭтапа(ВыбранноеЗначение) Тогда
	Сообщить("Выберите группу номенклатуры с префиксом этапа!");
	СтандартнаяОбработка = Ложь;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПроверитьПрименениеРМ()
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданий.ПЗ
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий КАК ЭтапыПроизводственныхЗаданий
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданий.РабочееМесто = &РабочееМесто
	|	И ЭтапыПроизводственныхЗаданий.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
Запрос.УстановитьПараметр("РабочееМесто", Объект.Ссылка);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сообщить(ВыборкаДетальныеЗаписи.ПЗ);
		КонецЦикла;
	Возврат(Ложь);
	Иначе
	Возврат(Истина);
	КонецЕсли; 
КонецФункции

&НаКлиенте
Процедура АвторизованоПриИзменении(Элемент)
	//Если Не Объект.Авторизовано Тогда
	//	Если Не ПроверитьПрименениеРМ() Тогда
	//	Объект.Авторизовано = Истина;
	//	Сообщить("Перед снятием флага авторизации следует изменить текущее рабочее место у выше перечисленных производственных заданий!");
	//	КонецЕсли;
	//КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ДобавлениеПодбором(Команда)
ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор", Ложь, Истина);
ОткрытьФорму("Справочник.ТехОперации.ФормаВыбора", ПараметрыПодбора, Элементы.ТехОперации);
КонецПроцедуры

&НаСервере
Процедура ДобавитьТОНаСервере(ВыбранноеЗначение)
	Для Каждого Значение Из ВыбранноеЗначение Цикл
		Если Объект.ТехОперации.НайтиСтроки(Новый Структура("ТехОперация", Значение)).Количество() = 0 Тогда
      	ТЧ = Объект.ТехОперации.Добавить();
      	ТЧ.ТехОперация = Значение;
    	КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ТехОперацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
ДобавитьТОНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
СписокТО = Новый СписокЗначений;

	Для каждого ТЧ Из Объект.ТехОперации Цикл
		Если ТЧ.ТехОперация.ЭтоГруппа Тогда
		ТО = Справочники.ТехОперации.ВыбратьИерархически(ТЧ.ТехОперация);
			Пока ТО.Следующий() Цикл
		    	Если Не ТО.ЭтоГруппа Тогда
					Если СписокТО.НайтиПоЗначению(ТО.Ссылка) = Неопределено Тогда	
					СписокТО.Добавить(ТО.Ссылка);
					Иначе
					Сообщить(""+СокрЛП(ТО.Ссылка.Наименование)+" - уже была добавлена в список ТО!");				
					Отказ = Истина;
					КонецЕсли;
				КонецЕсли;				
			КонецЦикла; 
		Иначе					
			Если СписокТО.НайтиПоЗначению(ТЧ.ТехОперация) = Неопределено Тогда	
			СписокТО.Добавить(ТЧ.ТехОперация);
			Иначе
			Сообщить(""+СокрЛП(ТЧ.ТехОперация.Наименование)+" - уже была добавлена в список ТО!");
			Отказ = Истина;				
			КонецЕсли;				
		КонецЕсли;
	КонецЦикла; 
КонецПроцедуры
