
&НаСервере
Функция ПолучитьСписок()
спНомен = Новый СписокЗначений;
Выборка = Справочники.НормыРасходов.Выбрать(,Элементы.Список.ТекущаяСтрока);
	Пока Выборка.Следующий() Цикл
	ОтборНорм = Новый Структура("НормаРасходов",Выборка.Ссылка);
	Нормы = РегистрыСведений.НормыРасходов.ПолучитьПоследнее(ТекущаяДата(),ОтборНорм);
		Если Нормы.Норма = 0 Тогда
		Продолжить;	
		КонецЕсли;
			Если ТипЗнч(Выборка.Элемент) = Тип("СправочникСсылка.Номенклатура") Тогда
			спНомен.Добавить(Выборка.Элемент.Ссылка,""+Выборка.ВидЭлемента+", "+Выборка.Элемент.Наименование);
			КонецЕсли;
	КонецЦикла;
Возврат(спНомен);
КонецФункции	

&НаКлиенте
Процедура ПредыдущийЭтап(Команда)
Результат = ОткрытьФормуМодально("ОбщаяФорма.ДеревоЭтапов",Новый Структура("Номенклатура,НаДату,Предыдущий",Элементы.Список.ТекущаяСтрока,ТекущаяДата(),Истина));
	Если Результат <> Неопределено Тогда
	Элементы.Список.ТекущаяСтрока = Результат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СледующийЭтап(Команда)
Результат = ОткрытьФормуМодально("ОбщаяФорма.ДеревоЭтапов",Новый Структура("Номенклатура,НаДату,Предыдущий",Элементы.Список.ТекущаяСтрока,ТекущаяДата(),Ложь));
	Если Результат <> Неопределено Тогда
	Элементы.Список.ТекущаяСтрока = Результат;
	КонецЕсли;
КонецПроцедуры


