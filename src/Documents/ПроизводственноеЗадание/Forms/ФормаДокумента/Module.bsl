
&НаКлиенте
Процедура ПриОткрытии(Отказ)
ЭтотОбъект.ТолькоПросмотр = ОбщийМодульСозданиеДокументов.ЗапретРедактирования(Объект.Ссылка,Истина,Ложь);
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокОборудования(СписокОборудования,ТехОперация)
	Для каждого ТЧ Из ТехОперация.Оборудование Цикл
	СписокОборудования.Добавить(ТЧ.Оборудование);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокТО(ЭтапСпецификации,СписокТО)
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_ТО(ЭтапСпецификации,Объект.ДатаЗапуска);
	Пока ВыборкаНР.Следующий() Цикл
		Если ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Номенклатура") Тогда
			Если ВыборкаНР.Элемент.Канбан.Пустая() Тогда
			ПолучитьСписокТО(ВыборкаНР.Элемент,СписокТО);
			КонецЕсли;
		Иначе	
    	СписокТО.Добавить(ВыборкаНР.Элемент);		
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеТехОперацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;

СписокТО = Новый СписокЗначений;

ПолучитьСписокТО(Объект.Изделие,СписокТО);
ТО = СписокТО.ВыбратьЭлемент("Выберите тех. операцию");
	Если ТО <> Неопределено Тогда
	Элементы.Оборудование.ТекущиеДанные.ТехОперация = ТО.Значение; 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеОборудованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
СписокОборудования = Новый СписокЗначений;

ПолучитьСписокОборудования(СписокОборудования, Элементы.Оборудование.ТекущиеДанные.ТехОперация);
ВыбОборудование = СписокОборудования.ВыбратьЭлемент("Выберите оборудование");
	Если ВыбОборудование <> Неопределено Тогда
	Элементы.Оборудование.ТекущиеДанные.Оборудование = ВыбОборудование.Значение;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ОборудованиеТехОперацияПриИзмененииНаСервере(Стр)
ТЧ = Объект.Оборудование.НайтиПоИдентификатору(Стр);
ТЧ.Оборудование = Справочники.ТехОснастка.ПустаяСсылка();
ТЧ.Исполнитель = Справочники.Сотрудники.ПустаяСсылка();
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеТехОперацияПриИзменении(Элемент)
ОборудованиеТехОперацияПриИзмененииНаСервере(Элементы.Оборудование.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокИсполнителей(ТО)
СписокИсполнителей = Новый СписокЗначений;

	Для каждого ТЧ Из ТО.Оборудование Цикл	
	СписокИсполнителей.Добавить(ТЧ.Сотрудник,СокрЛП(ТЧ.Сотрудник.Наименование)+" ("+СокрЛП(ТЧ.Оборудование.Наименование)+")");
	КонецЦикла;
Возврат(СписокИсполнителей); 
КонецФункции

&НаСервере
Функция ПолучитьОборудование(ТО,Исполнитель)
	Для каждого ТЧ Из ТО.Оборудование Цикл	
		Если ТЧ.Сотрудник = Исполнитель Тогда
		Возврат(ТЧ.Оборудование);
		КонецЕсли;
	КонецЦикла;
Возврат(Справочники.Сотрудники.ПустаяСсылка()); 
КонецФункции 

&НаКлиенте
Процедура ОборудованиеИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
СписокИсполнителей = ПолучитьСписокИсполнителей(Элементы.Оборудование.ТекущиеДанные.ТехОперация);
Исполнитель = СписокИсполнителей.ВыбратьЭлемент("Выберите исполнителя");
	Если Исполнитель <> Неопределено Тогда
	Элементы.Оборудование.ТекущиеДанные.Исполнитель = Исполнитель.Значение; 
	Элементы.Оборудование.ТекущиеДанные.Оборудование = ПолучитьОборудование(Элементы.Оборудование.ТекущиеДанные.ТехОперация,Исполнитель.Значение);
	КонецЕсли;
КонецПроцедуры
