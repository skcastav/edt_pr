
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
НаДату = ТекущаяДата();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
Список.Параметры.УстановитьЗначениеПараметра("НаДату",НаДату);
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
Процедура НаДатуПриИзменении(Элемент)
Список.Параметры.УстановитьЗначениеПараметра("НаДату",НаДату);
КонецПроцедуры

&НаКлиенте
Процедура ПечатьОтчётПоТехОснастке(Команда)
ИмяОтчета = "ОтчётПоТехОснастке";
ПараметрыФормы = Новый Структура;
ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,ТекущаяДата(),ТекущаяДата(),Новый Структура("Ссылка",Элементы.Список.ТекущаяСтрока),"Основной"));
ПараметрыФормы.Вставить("КлючВарианта","Основной"); 
ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы,,Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрИзвещений(Команда)
ОткрытьФорму("Отчет.ПросмотрИзвещений.Форма.ФормаОтчета",Новый Структура("Элемент",Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаСервере
Процедура ДобавитьИзвещениеНаСервере(ТО,ВыбИзвещение)
Извещение = РегистрыСведений.ИзвещенияОбИзменениях.СоздатьМенеджерЗаписи();
Извещение.Период = ТекущаяДата();
Извещение.Элемент = ТО;
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

&НаСервере
Функция ПечатьНомеровОстасткиА4(ТО,НомерОснастки,КоличествоОснасток)
ТабДок = Новый ТабличныйДокумент;

Макет = ПолучитьОбщийМакет("QRКод_45х13_Оснастка");
ОблQRКод = Макет.ПолучитьОбласть("Бирка|Колонка"); 
НомерКолонки = 1;
	Для к = 0 По КоличествоОснасток - 1 Цикл
	НО = НомерОснастки+к;
	QRCode = ЗначениеВСтрокуВнутр(ТО)+";"+НО;
	ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(QRCode, 0, 100);	
		Если ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
		КартинкаQRКода = Новый Картинка(ДанныеQRКода);
		ОблQRКод.Рисунки.QRCode.Картинка = КартинкаQRКода;
		Иначе
		Сообщить("Не удалось сформировать QR-код!");
		КонецЕсли;
	ОблQRКод.Параметры.Номер = НО;  
		Если НомерКолонки = 1 Тогда
		ТабДок.Вывести(ОблQRКод);
		НомерКолонки = НомерКолонки + 1;
		ИначеЕсли НомерКолонки < 4 Тогда	
		ТабДок.Присоединить(ОблQRКод);
        НомерКолонки = НомерКолонки + 1;
		Иначе
 		ТабДок.Присоединить(ОблQRКод);
        НомерКолонки = 1; 
		КонецЕсли;
	КонецЦикла;  
ТабДок.РазмерСтраницы = "A4";
ТабДок.ПолеСлева = 0;
ТабДок.ПолеСверху = 0;
ТабДок.ПолеСнизу = 0;
ТабДок.ПолеСправа = 0;
ТабДок.РазмерКолонтитулаСверху = 0;
ТабДок.РазмерКолонтитулаСнизу = 0;
Возврат(ТабДок);
КонецФункции

&НаСервере
Функция ПечатьНомеровОстасткиZebra(ТО,НомерОснастки,КоличествоОснасток)
ТабДок = Новый ТабличныйДокумент;

Макет = ПолучитьОбщийМакет("QRКод_45х13_Оснастка");
ОблQRКод = Макет.ПолучитьОбласть("Бирка");
	Для к = 0 По КоличествоОснасток - 1 Цикл
	НО = НомерОснастки+к;
	QRCode = ЗначениеВСтрокуВнутр(ТО)+";"+НО;
	ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(QRCode, 0, 100);	
		Если ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
		КартинкаQRКода = Новый Картинка(ДанныеQRКода);
		ОблQRКод.Рисунки.QRCode.Картинка = КартинкаQRКода;
		Иначе
		Сообщить("Не удалось сформировать QR-код!");
		КонецЕсли;
	ОблQRКод.Параметры.Номер = НО;
	ТабДок.Вывести(ОблQRКод);
	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЦикла;  
ТабДок.РазмерСтраницы = "Custom";
ТабДок.ВысотаСтраницы = 13;
ТабДок.ШиринаСтраницы = 45;
ТабДок.ПолеСлева = 0;
ТабДок.ПолеСверху = 0;
ТабДок.ПолеСнизу = 0;
ТабДок.ПолеСправа = 0;
ТабДок.РазмерКолонтитулаСверху = 0;
ТабДок.РазмерКолонтитулаСнизу = 0;
Возврат(ТабДок);
КонецФункции

&НаКлиенте
Процедура ПечатьНомеровОстастки(Команда)
СписокФорматов = Новый СписокЗначений;

СписокФорматов.Добавить("А4");
СписокФорматов.Добавить("Zebra");
НомерОснастки = 1;
КоличествоОснасток = 1;
ФорматПринтера = СписокФорматов.ВыбратьЭлемент("Выберите формат принтера");
	Если ФорматПринтера <> Неопределено Тогда
		Если ВвестиЧисло(НомерОснастки,"Введите начальный номер оснастки",4,0) Тогда 
			Если ВвестиЧисло(КоличествоОснасток,"Введите кол-во номеров оснасток",2,0) Тогда
				Если ФорматПринтера.Значение = "А4" Тогда
				ТабДок = ПечатьНомеровОстасткиА4(Элементы.Список.ТекущаяСтрока,НомерОснастки,КоличествоОснасток);
				Иначе
				ТабДок = ПечатьНомеровОстасткиZebra(Элементы.Список.ТекущаяСтрока,НомерОснастки,КоличествоОснасток);
				КонецЕсли;
			ТабДок.Показать("QR-коды номеров оснасток");
			КонецЕсли;		
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаНормОборудования(Команда)
ОткрытьФорму("Обработка.ЗагрузкаНормОборудования.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ПечатьВыгрузкаДанных(Команда)
ИмяОтчета = "ОтчётПоТехОснастке";
ПараметрыФормы = Новый Структура;
ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,ТекущаяДата(),ТекущаяДата(),Новый Структура("Ссылка",Элементы.Список.ТекущаяСтрока),"ВыгрузкаДанныхОборудования"));
ПараметрыФормы.Вставить("КлючВарианта","ВыгрузкаДанныхОборудования"); 
ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы,,Истина);
КонецПроцедуры
