
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Элементы.Операции.Видимость = РольДоступна("Администратор") или РольДоступна("ВводДанных"); 
КонецПроцедуры
 
&НаКлиенте
Процедура ДобавитьДокументы(Команда)
ОткрытьФорму("Обработка.ДобавлениеДокумента.Форма.Форма",Новый Структура("Элемент",Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура Применение(Команда)
Результат = ОткрытьФормуМодально("ОбщаяФорма.ДеревоЭтапов",Новый Структура("Номенклатура,НаДату,Предыдущий",Элементы.Список.ТекущаяСтрока,ТекущаяДата(),Ложь));
	Если Результат <> Неопределено Тогда
	ТекФорма = ПолучитьФорму("Справочник.Номенклатура.ФормаСписка");
	ТекФорма.Открыть();
	ТекФорма.Элементы.Список.ТекущаяСтрока = Результат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДокументыИзЛокальногоКаталога(Команда)
ОткрытьФорму("Обработка.ДобавлениеДокументов.Форма.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрИзвещений(Команда)
ОткрытьФорму("Отчет.ПросмотрИзвещений.Форма.ФормаОтчета",Новый Структура("Элемент",Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаСервере
Процедура ДобавитьИзвещениеНаСервере(Документ,ВыбИзвещение)
Извещение = РегистрыСведений.ИзвещенияОбИзменениях.СоздатьМенеджерЗаписи();
Извещение.Период = ТекущаяДата();
Извещение.Элемент = Документ;
Извещение.Извещение = ВыбИзвещение;
Извещение.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзвещение(Команда)
ФормаИзвещения = ПолучитьФорму("Справочник.ИзвещенияОбИзменениях.ФормаВыбора");
Результат = ФормаИзвещения.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
	ДобавитьИзвещениеНаСервере(Элементы.Список.ТекущаяСтрока,Результат);
	КонецЕсли; 
КонецПроцедуры
