
&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Если Вопрос("После удаления строки очистите дату окончания у последнего этапа!", РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.Отмена Тогда
	Отказ = Истина;
	КонецЕсли; 
КонецПроцедуры
