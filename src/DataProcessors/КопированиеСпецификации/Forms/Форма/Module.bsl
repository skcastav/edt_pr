
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Объект.НаДату = ТекущаяДата();
Объект.ДатаСоздания = ТекущаяДата();
КопироватьАналоги = Истина;
	Если Параметры.Свойство("Спецификация") <> Неопределено Тогда
	Объект.НаДату = Параметры.НаДату;
	Объект.ДатаСоздания = Параметры.НаДату;
	Объект.Спецификация = Параметры.Спецификация;
	ПолучитьНаименование();
	ВыбСтатус = РегистрыСведений.СтатусыМПЗ.ПолучитьПоследнее(ТекущаяДата(),Новый Структура("МПЗ",Объект.Спецификация));
	Объект.Статус = ВыбСтатус.Статус;
	Объект.Проект = Объект.Спецификация.Проект;
	РаскрытьНаЭтапы(Объект.Спецификация);
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура НумераторОчистка(Элемент, СтандартнаяОбработка)
Элементы.Обозначение.Доступность = Истина;
КонецПроцедуры

&НаСервере
Процедура РаскрытьНаЭтапы(Этап)
ТЧ = Объект.ТабличнаяЧасть.Вставить(0);
ТЧ.ИсходнаяСпецификация = Этап;
ТЧ.Группа = Этап.Родитель;
	Если Этап = Объект.Спецификация Тогда
	ТЧ.Пометка = Истина;
	КонецЕсли; 
Выборка = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н(Этап,ТекущаяДата());
	Пока Выборка.Следующий() Цикл
		Если Выборка.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Основа Тогда		
		РаскрытьНаЭтапы(Выборка.Элемент);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПолучитьНаименование()
Объект.Обозначение = Лев(Объект.Спецификация.Наименование,Найти(Объект.Спецификация.Наименование,"(")-1);
Объект.Наименование = глНаименованиеВСкобкахБезЭтапа(Объект.Спецификация.Наименование);
КонецПроцедуры

&НаКлиенте
Процедура СпецификацияПриИзменении(Элемент)
РаскрытьНаЭтапы(Объект.Спецификация);
ПолучитьНаименование();	
КонецПроцедуры

&НаКлиенте
Процедура НумераторПриИзменении(Элемент)
	Если Объект.Нумератор.Пустая() Тогда
	Объект.Обозначение = "";
	Элементы.Обозначение.Доступность = Истина;	
	Иначе	
	Объект.Обозначение = "Присваивается нумератором";
	Элементы.Обозначение.Доступность = Ложь;	
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПолучитьИсходныеГруппы()
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
		Если ТЧ.Пометка Тогда
		ТЧ.Группа = ТЧ.ИсходнаяСпецификация.Родитель;
		КонецЕсли; 
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ИсходнаяГруппа(Команда)
ПолучитьИсходныеГруппы();
КонецПроцедуры

&НаСервере
Процедура ПолучитьРодителейГрупп()
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
		Если ТЧ.Пометка Тогда
		ТЧ.Группа = ТЧ.Группа.Родитель;
		КонецЕсли; 
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура РодительГруппы(Команда)
ПолучитьРодителейГрупп();
КонецПроцедуры

&НаСервере
Процедура СоздатьНовыеГруппы(ВыбГруппа)
	Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
		Если ТЧ.Пометка Тогда
		ТекГруппа = Справочники.Номенклатура.НайтиПоНаименованию(ПолучитьПрефиксЭтапаПроизводства(ТЧ.Группа)+"-"+ВыбГруппа,Истина,ТЧ.Группа);
			Если ЗначениеЗаполнено(ТекГруппа) Тогда
			ТЧ.Группа = ТекГруппа;
			Иначе	
			НоваяГруппа = Справочники.Номенклатура.СоздатьГруппу();
			НоваяГруппа.Родитель = ТЧ.Группа;
			НоваяГруппа.Наименование = ПолучитьПрефиксЭтапаПроизводства(ТЧ.Группа)+"-"+ВыбГруппа;
			НоваяГруппа.Записать();
			ТЧ.Группа = НоваяГруппа.Ссылка;			
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла; 	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовуюГруппу(Команда)
ВыбГруппа = Объект.Наименование;
	Если ВвестиСтроку(ВыбГруппа,"Введите наименование новой группы",100) Тогда
	СоздатьНовыеГруппы(ВыбГруппа);
	КонецЕсли; 
КонецПроцедуры
            
&НаСервере
Функция КопироватьЭтап(ВыбЭтап,ВыбГруппа,ВыбОснова)
НоваяСпецификация = Справочники.Номенклатура.СоздатьЭлемент();
НоваяСпецификация.Родитель = ВыбГруппа;
	Если Не Объект.Нумератор.Пустая() Тогда
	 	Если ЗначениеЗаполнено(ПрефиксОбозначения) Тогда
		НоваяСпецификация.Наименование = ""+Объект.Нумератор.Код+"."+Формат(Объект.Нумератор.СледующийНомер,"ЧЦ=6; ЧВН=; ЧГ=")+ПрефиксОбозначения+" ("+ПолучитьПрефиксЭтапаПроизводства(ВыбГруппа)+"-"+СокрЛП(Объект.Наименование)+")";
		Иначе
		НоваяСпецификация.Наименование = ""+Объект.Нумератор.Код+"."+Формат(Объект.Нумератор.СледующийНомер,"ЧЦ=6; ЧВН=; ЧГ=")+" ("+ПолучитьПрефиксЭтапаПроизводства(ВыбГруппа)+"-"+СокрЛП(Объект.Наименование)+")";
		КонецЕсли;
	НовыйНумератор = Объект.Нумератор.ПолучитьОбъект();
	НовыйНумератор.СледующийНомер = НовыйНумератор.СледующийНомер + 1;
	НовыйНумератор.Записать(); 
	Иначе
		Если ЗначениеЗаполнено(Объект.Обозначение) Тогда
			Если ЗначениеЗаполнено(ПрефиксОбозначения) Тогда
			НоваяСпецификация.Наименование = СокрЛП(Объект.Обозначение)+ПрефиксОбозначения+" ("+ПолучитьПрефиксЭтапаПроизводства(ВыбГруппа)+"-"+СокрЛП(Объект.Наименование)+")";
			Иначе	
			НоваяСпецификация.Наименование = СокрЛП(Объект.Обозначение)+" ("+ПолучитьПрефиксЭтапаПроизводства(ВыбГруппа)+"-"+СокрЛП(Объект.Наименование)+")";
			КонецЕсли; 
		Иначе
		Преф = ПолучитьПрефиксЭтапаПроизводства(ВыбГруппа);
			Если ЗначениеЗаполнено(Преф) Тогда
			Преф = Преф + "-";
			КонецЕсли; 
		НоваяСпецификация.Наименование = Преф+СокрЛП(Объект.Наименование);
		КонецЕсли; 
	КонецЕсли;
		Если Не НеПроверятьУникальность Тогда	
		ТекОснова = Справочники.Номенклатура.НайтиПоНаименованию(НоваяСпецификация.Наименование,Истина,ВыбГруппа);
			Если ЗначениеЗаполнено(ТекОснова) Тогда
			Возврат(ТекОснова);
			КонецЕсли; 		
		КонецЕсли;
НоваяСпецификация.ПолнНаименование = НоваяСпецификация.Наименование; 
НоваяСпецификация.ДатаСозданияСпецификации = Объект.ДатаСоздания;
НоваяСпецификация.ЕдиницаИзмерения = ВыбЭтап.ЕдиницаИзмерения;
НоваяСпецификация.Записать();
ОснЕИ = Справочники.ОсновныеЕдиницыИзмерений.СоздатьЭлемент();
ОснЕИ.Владелец = НоваяСпецификация.Ссылка;
ОснЕИ.Наименование = ВыбЭтап.ОсновнаяЕдиницаИзмерения.Наименование;
ОснЕИ.ЕдиницаИзмерения = ВыбЭтап.ОсновнаяЕдиницаИзмерения.ЕдиницаИзмерения;
ОснЕИ.Коэффициент = ВыбЭтап.ОсновнаяЕдиницаИзмерения.Коэффициент;
ОснЕИ.Записать();
НоваяСпецификация.ОсновнаяЕдиницаИзмерения = ОснЕИ.Ссылка;
НоваяСпецификация.Записать();
НовыйСтатус = РегистрыСведений.СтатусыМПЗ.СоздатьМенеджерЗаписи();
НовыйСтатус.Период = Объект.ДатаСоздания;
НовыйСтатус.МПЗ = НоваяСпецификация.Ссылка;
НовыйСтатус.Статус = Объект.Статус;
НовыйСтатус.Записать();
НР = Справочники.НормыРасходов.Выбрать(,ВыбЭтап,,"Код");
	Пока НР.Следующий() Цикл
		Если НР.ПометкаУдаления Тогда
		Продолжить;
		КонецЕсли;
	НормыНР = РегистрыСведений.НормыРасходов.ПолучитьПоследнее(Объект.НаДату,Новый Структура("НормаРасходов",НР.Ссылка));
		Если НормыНР.Норма = 0 Тогда
		Продолжить;
		КонецЕсли;
			Если ТипЗнч(НР.Элемент) = Тип("СправочникСсылка.ТехОперации") Тогда
			Продолжить;
			КонецЕсли; 
    НоваяНР = Справочники.НормыРасходов.СоздатьЭлемент();
	НоваяНР.Владелец = НоваяСпецификация.Ссылка;
	НоваяНР.ВидЭлемента = НР.ВидЭлемента;
		Если НоваяНР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Основа Тогда
			Если ВыбОснова.Пустая() Тогда
			НоваяНР.Элемент = НР.Элемент;
			НоваяНР.Наименование = НР.Наименование;			
			Иначе	
			НоваяНР.Элемент = ВыбОснова;
			НоваяНР.Наименование = "Основа, "+ВыбОснова.Наименование;			
			КонецЕсли; 
		Иначе
		НоваяНР.Элемент = НР.Элемент;
		НоваяНР.Наименование = НР.Наименование;
		КонецЕсли; 
    НоваяНР.Позиция = НР.Позиция;
	НоваяНР.Примечание = НР.Примечание;
	НоваяНР.Записать();
	РНР = РегистрыСведений.НормыРасходов.СоздатьМенеджерЗаписи();
	РНР.Период = Объект.ДатаСоздания;
	РНР.Владелец = НоваяНР.Владелец; 
	РНР.Элемент = НоваяНР.Элемент;
	РНР.НормаРасходов = НоваяНР.Ссылка;
	РНР.Норма = НормыНР.Норма;
	РНР.Записать();
		Если КопироватьАналоги Тогда 
		ТаблицаАналогов = ОбщегоНазначенияПовтИсп.ПолучитьАналогиНормРасходов(НР.Ссылка,Объект.НаДату,Истина);
			Для каждого ТЧ_ТА Из ТаблицаАналогов Цикл
			НовыйАНР = Справочники.АналогиНормРасходов.СоздатьЭлемент();
			НовыйАНР.Владелец = НоваяНР.Ссылка;
			НовыйАНР.Наименование = ТЧ_ТА.Ссылка.Наименование;
			НовыйАНР.ВидЭлемента = ТЧ_ТА.ВидЭлемента;
			НовыйАНР.Элемент = ТЧ_ТА.Элемент;
			НовыйАНР.Приоритет = ТЧ_ТА.Ссылка.Приоритет;
		    НовыйАНР.Записать();		
			РАНР = РегистрыСведений.АналогиНормРасходов.СоздатьМенеджерЗаписи();
			РАНР.Период = Объект.ДатаСоздания; 
			РАНР.Владелец = НовыйАНР.Владелец;
			РАНР.АналогНормыРасходов = НовыйАНР.Ссылка;
			РАНР.Норма = ТЧ_ТА.Норма;
			РАНР.Записать();
			КонецЦикла;		
		КонецЕсли;
	КонецЦикла;
Возврат(НоваяСпецификация.Ссылка);
КонецФункции

&НаСервере
Функция КопироватьНаСервере()
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1; 
	ТекОснова = Справочники.Номенклатура.ПустаяСсылка();
		Для каждого ТЧ Из Объект.ТабличнаяЧасть Цикл
			Если ТЧ.Пометка Тогда
			ТекОснова = КопироватьЭтап(ТЧ.ИсходнаяСпецификация,ТЧ.Группа,ТекОснова);
			КонецЕсли; 
		КонецЦикла;
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Возврат(ТекОснова);
	Исключение
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Сообщить(ОписаниеОшибки());
	Возврат(Неопределено);
	КонецПопытки;
КонецФункции

&НаКлиенте
Процедура Копировать(Команда)
Результат = КопироватьНаСервере();
	Если Результат <> Неопределено Тогда
	ОповеститьОЗаписиНового(Результат);
	Закрыть();
	КонецЕсли;
КонецПроцедуры
