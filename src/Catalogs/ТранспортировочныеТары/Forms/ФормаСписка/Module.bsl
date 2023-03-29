
&НаСервере
Функция ПечатьQRКодыНаСервере(СписокТары)
ТабДок = Новый ТабличныйДокумент;

Макет = ПолучитьОбщийМакет("QRКодТары");
ОблQRКод = Макет.ПолучитьОбласть("Этикетка");

	Для каждого Тара Из СписокТары Цикл
	QRCode = "Тара;"+ЗначениеВСтрокуВнутр(Тара.Значение);
	ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(QRCode, 0, 100);	
		Если ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
		КартинкаQRКода = Новый Картинка(ДанныеQRКода);
		ОблQRКод.Рисунки.QRCode.Картинка = КартинкаQRКода;
		Иначе
		Сообщить("Не удалось сформировать QR-код!");
		КонецЕсли;
	ОблQRКод.Параметры.Наименование = СокрЛП(Тара.Значение.Наименование); 
	ОблQRКод.Параметры.МестоХранения = СокрЛП(Тара.Значение.МестоХранения.Наименование);
	ТабДок.Вывести(ОблQRКод);
	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЦикла;   
ТабДок.РазмерСтраницы = "Custom";
ТабДок.ВысотаСтраницы = 101;
ТабДок.ШиринаСтраницы = 57;
ТабДок.ПолеСлева = 0;
ТабДок.ПолеСверху = 0;
ТабДок.ПолеСнизу = 0;
ТабДок.ПолеСправа = 0;
ТабДок.РазмерКолонтитулаСверху = 0;
ТабДок.РазмерКолонтитулаСнизу = 0;
Возврат(ТабДок);
КонецФункции

&НаКлиенте
Процедура ПечатьQRКоды(Команда)
СписокТары = Новый СписокЗначений;

	Для каждого ТЧ из Элементы.Список.ВыделенныеСтроки Цикл
	СписокТары.Добавить(ТЧ); 
	КонецЦикла;
ТД = ПечатьQRКодыНаСервере(СписокТары);
	Если ТД <> Неопределено Тогда
	ТД.Показать("QR-коды транспортировочных тар");
	КонецЕсли; 
КонецПроцедуры
