
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Не ОбщийМодульВызовСервера.ДоступностьРоли("Администратор") Тогда
	Отказ = Истина;
	Сообщить("У Вас нет права на изменение регистра в ручном режиме!");	
	КонецЕсли; 
КонецПроцедуры
