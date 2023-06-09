
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	КонечноеСообщение = ПеренестиНаСервере(ПараметрКоманды);
	Предупреждение(КонечноеСообщение);
КонецПроцедуры

&НаСервере
Функция ПеренестиНаСервере(Ссылка)
	Источник = Ссылка.ПолучитьОбъект();
	СокращенныйСписок = СРМ_ОбменВебСервисПовтИсп.ПолучитьСписокДокументовДляОбмена();
	Если  НЕ СокращенныйСписок = Неопределено тогда
		ИмяИсточника = Источник.Метаданные().Имя;
		Результат = СокращенныйСписок.Найти(ИмяИсточника);
		Если НЕ Результат = Неопределено тогда
			ЗаписьXML = Новый ЗаписьXML;
			ЗаписьXML.УстановитьСтроку();
			ЗаписьXML.ЗаписатьОбъявлениеXML();
			ЗаписатьXML(ЗаписьXML, Источник, НазначениеТипаXML.Явное);
			СтрокаХМЛ = ЗаписьXML.Закрыть();
			СРМ_ОбменВебСервис.СериализоватьОтправитьОбъект(СтрокаХМЛ);
			Для каждого Набор из Источник.Движения цикл
				Набор.Прочитать();
				ЗаписьXML = Новый ЗаписьXML;
				ЗаписьXML.УстановитьСтроку();
				ЗаписьXML.ЗаписатьОбъявлениеXML();
				ЗаписатьXML(ЗаписьXML, Набор, НазначениеТипаXML.Явное);
				СтрокаХМЛ = ЗаписьXML.Закрыть();
				СРМ_ОбменВебСервис.СериализоватьОтправитьОбъект(СтрокаХМЛ);
			КонецЦикла;
		Иначе
			КонечноеСообщение = "Документ не предназначен для выгрузки!";
		КонецЕсли;
	КонецЕсли; 
	
	Возврат КонечноеСообщение;
КонецФункции
