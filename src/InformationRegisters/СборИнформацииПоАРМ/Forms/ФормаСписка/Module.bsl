
&НаСервере
Процедура УдалитьЗаписиПоНаСервере(ВыбДата)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	СборИнформацииПоАРМ.Период,
	|	СборИнформацииПоАРМ.ВидОперации,
	|	СборИнформацииПоАРМ.Линейка,
	|	СборИнформацииПоАРМ.РабочееМесто,
	|	СборИнформацииПоАРМ.Изделие
	|ИЗ
	|	РегистрСведений.СборИнформацииПоАРМ КАК СборИнформацииПоАРМ
	|ГДЕ
	|	СборИнформацииПоАРМ.Период <= &Период";
Запрос.УстановитьПараметр("Период", КонецДня(ВыбДата));
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Рег = РегистрыСведений.СборИнформацииПоАРМ.СоздатьНаборЗаписей();
	Рег.Отбор.Период.Установить(ВыборкаДетальныеЗаписи.Период);
	Рег.Отбор.ВидОперации.Установить(ВыборкаДетальныеЗаписи.ВидОперации);
	Рег.Отбор.Линейка.Установить(ВыборкаДетальныеЗаписи.Линейка);
	Рег.Отбор.РабочееМесто.Установить(ВыборкаДетальныеЗаписи.РабочееМесто);
	Рег.Отбор.Изделие.Установить(ВыборкаДетальныеЗаписи.Изделие);
	Рег.Записать();
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗаписиПо(Команда)
ВыбДата = НачалоМесяца(ТекущаяДата())-1;
	Если ВвестиДату(ВыбДата,"Выберите дату, включая которую будут удалены записи",ЧастиДаты.Дата) Тогда
	УдалитьЗаписиПоНаСервере(ВыбДата);
	КонецЕсли;
КонецПроцедуры
