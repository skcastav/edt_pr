
&НаКлиенте
Процедура Применение(Команда)
Результат = ОткрытьФормуМодально("ОбщаяФорма.ДеревоЭтапов",Новый Структура("Номенклатура,НаДату,Предыдущий",Элементы.Список.ТекущаяСтрока,ТекущаяДата(),Ложь));
	Если Результат <> Неопределено Тогда
	ТекФорма = ПолучитьФорму("Справочник.Номенклатура.ФормаСписка");
	ТекФорма.Открыть();
	ТекФорма.Элементы.Список.ТекущаяСтрока = Результат;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
НаДату = ТекущаяДата();
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныТО(Команда)
ОткрытьФорму("Справочник.ШаблоныТехОпераций.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
Список.Параметры.УстановитьЗначениеПараметра("НаДату",НаДату);
КонецПроцедуры

&НаКлиенте
Процедура НаДатуПриИзменении(Элемент)
Список.Параметры.УстановитьЗначениеПараметра("НаДату",НаДату);
КонецПроцедуры

&НаКлиенте
Процедура ПечатьОтчётПоТехОперациям(Команда)
ИмяОтчета = "ОтчётПоТехОперациям";
ПараметрыФормы = Новый Структура;
ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,ТекущаяДата(),ТекущаяДата(),Новый Структура("Ссылка",Элементы.Список.ТекущаяСтрока),"Основной"));
ПараметрыФормы.Вставить("КлючВарианта","Основной"); 
ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы,,Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПечатьВыгрузкаДанных(Команда)
ИмяОтчета = "ОтчётПоТехОперациям";
ПараметрыФормы = Новый Структура;
ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,ТекущаяДата(),ТекущаяДата(),Новый Структура("Ссылка",Элементы.Список.ТекущаяСтрока),"ВыгрузкаДанных"));
ПараметрыФормы.Вставить("КлючВарианта","ВыгрузкаДанных"); 
ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы,,Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаНормТехОпераций(Команда)
ОткрытьФорму("Обработка.ЗагрузкаНормТехОпераций.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ПечатьОборудование(Команда)
ИмяОтчета = "ОтчётПоТехОперациям";
ПараметрыФормы = Новый Структура;
ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,ТекущаяДата(),ТекущаяДата(),Новый Структура("Ссылка",Элементы.Список.ТекущаяСтрока),"Оборудование"));
ПараметрыФормы.Вставить("КлючВарианта","Оборудование"); 
ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы,,Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПечатьОтчётПоШаблонамТехОпераций(Команда)
Линейка = Неопределено;
	Если ВвестиЗначение(Линейка,"Выберите линейку УД",Тип("СправочникСсылка.Линейки")) Тогда 
	ОткрытьФорму("Отчет.ОтчетПоШаблонамТехОпераций.Форма.ФормаОтчета",Новый Структура("Линейка",Линейка));
	КонецЕсли;
КонецПроцедуры
