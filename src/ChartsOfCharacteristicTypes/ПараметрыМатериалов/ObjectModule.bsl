
Процедура ПередЗаписью(Отказ)
	Если ЭтоНовый() Тогда
	Выборка = ПланыВидовХарактеристик.ПараметрыМатериалов.Выбрать(,Новый Структура("Наименование",Наименование));
		Пока Выборка.Следующий() Цикл
			Если Не Выборка.Запрещенный Тогда
			Сообщить(Наименование + " - наименование разрешенного параметра существует!");	
			Отказ = Истина;
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли;
КонецПроцедуры
