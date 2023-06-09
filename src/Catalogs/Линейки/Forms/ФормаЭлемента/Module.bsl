
&НаСервере
Функция ПолучитьКаталогСхем()
Возврат(Константы.КаталогДокументовИПрограмм.Получить()+"СхемыЛинеек\"+Константы.КодБазы.Получить());
КонецФункции

&НаСервере
Функция ПолучитьЦвет()
	Если ЗначениеЗаполнено(Объект.Цвет) Тогда
	Возврат(ЗначениеИзСтрокиВнутр(Объект.Цвет));
	Иначе
	Возврат("");
	КонецЕсли; 
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    Попытка
    КОМОбъект = Новый COMОбъект ("WScript.Network");
    Принтеры = КОМОбъект.EnumPrinterConnections();
    к = 0;
        Пока к < Принтеры.Count()-1 Цикл
        СписокПринтеров.Добавить(Принтеры.Item(к+1), Принтеры.Item(к+1));
        к = к + 2;
        КонецЦикла;
    Исключение
    Сообщить(ОписаниеОшибки());
    КонецПопытки;
		Попытка
		СхемаЛинейки.Прочитать(ПолучитьКаталогСхем()+СокрЛП(Объект.Наименование)+".grs");
		Исключение
		
		КонецПопытки;
Цвет = ПолучитьЦвет();
КонецПроцедуры

&НаКлиенте
Процедура ПринтерыПринтерНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
ЭлементСписка = СписокПринтеров.ВыбратьЭлемент("Выберите принтер",ЭлементСписка);
ПринтерыПринтерОбработкаВыбора(Элемент, ЭлементСписка.Значение, Истина);  
КонецПроцедуры

&НаКлиенте
Процедура ПринтерыПринтерОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
Элементы.Принтеры.ТекущиеДанные.Принтер = ВыбранноеЗначение;
КонецПроцедуры

&НаСервере
Функция ЦветВСтрокуВнутр()
Возврат(ЗначениеВСтрокуВнутр(Цвет));
КонецФункции

&НаКлиенте
Процедура ЦветПриИзменении(Элемент)
Объект.Цвет = ЦветВСтрокуВнутр();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Объект.ВидЛинейки = Перечисления.ВидыЛинеек.Канбан Тогда
		Если Объект.ВидыКанбанов.Количество() = 0 Тогда
		Отказ =  Истина;
		Сообщить("Не заполнены виды канбанов!");
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры
