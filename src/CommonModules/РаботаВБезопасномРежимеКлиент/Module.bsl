////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Серверные процедуры и функции общего назначения:
// - Поддержка профилей безопасности.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Применяет ранее сохраненные в информационной базе запросы на использование внешних ресурсов.
//
// Параметры:
//  Идентификаторы - Массив(УникальныйИдентификатор) - идентификаторы запросов, которые требуется применить,
//  ФормаВладелец - УправляемаяФорма - форма, которая должна блокироваться до окончания применения разрешений,
//  ОповещениеОЗакрытии - ОписаниеОповещения - которое будет вызвано при успешном предоставлении разрешений.
//
Процедура ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Знач Идентификаторы, ФормаВладелец, ОповещениеОЗакрытии) Экспорт
	
	СтандартнаяОбработка = Истина;
	
	ОбработчикиСобытия = ОбщегоНазначенияКлиент.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов");
	
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		
		Обработчик.Модуль.ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов(Идентификаторы, ФормаВладелец, ОповещениеОЗакрытии, СтандартнаяОбработка);
		
		Если Не СтандартнаяОбработка Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если СтандартнаяОбработка Тогда
		
		РаботаВБезопасномРежимеКлиентПереопределяемый.ПриПодтвержденииЗапросовНаИспользованиеВнешнихРесурсов(
			Идентификаторы, ФормаВладелец, ОповещениеОЗакрытии, СтандартнаяОбработка);
		
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда
		
		НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент.НачатьИнициализациюЗапросаРазрешенийНаИспользованиеВнешнихРесурсов(
			Идентификаторы, ФормаВладелец, ОповещениеОЗакрытии);
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает диалог настройки режима использования профилей безопасности для
// текущей информационной базы.
//
Процедура ОткрытьДиалогНастройкиИспользованияПрофилейБезопасности() Экспорт
	
	ОткрытьФорму(
		"Обработка.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.Форма.НастройкиИспользованияПрофилейБезопасности",
		,
		,
		"Обработка.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.Форма.НастройкиИспользованияПрофилейБезопасности",
		,
		,
		,
		РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

#КонецОбласти
