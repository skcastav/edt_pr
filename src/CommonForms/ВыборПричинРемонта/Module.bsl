
&НаСервере
Функция ПолучитьНаименованиеСтдКомм()
Возврат(СокрЛП(ПричинаРемонта.Наименование));
КонецФункции

&НаКлиенте
Процедура ОК(Команда)
	Если ЗначениеЗаполнено(ПричинаРемонта) Тогда
		Если ПолучитьНаименованиеСтдКомм() = "Прочее" Тогда
			Если Не ЗначениеЗаполнено(Комментарий) Тогда
			Сообщить("Введите расширенный комментарий к ремонту.");
			Возврат;
			КонецЕсли; 	
		КонецЕсли;
	Иначе
	Сообщить("Выберите причину отправки в ремонт.");
	Возврат;	
	КонецЕсли;
ЭтаФорма.Закрыть(Новый Структура("ПричинаРемонта,Комментарий",ПричинаРемонта,Комментарий));
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
ЭтаФорма.Закрыть();
КонецПроцедуры

&НаСервере
Функция ПолучитьГруппуПричинРемонта(РабочееМесто)
Возврат(РабочееМесто.ГруппаРабочихМест.ГруппаПричинРемонта);
КонецФункции

&НаКлиенте
Процедура ПричинаРемонтаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
ОткрытьФорму("Справочник.ПричиныРемонта.Форма.ФормаВыбораПоГруппе",Новый Структура("Родитель",ПолучитьГруппуПричинРемонта(ЭтаФорма.Параметры.РабочееМесто)),,,,, Новый ОписаниеОповещения("ПричинаРемонтаНачалоВыбораЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура ПричинаРемонтаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
	ПричинаРемонта = Результат;
	КонецЕсли;
КонецПроцедуры

