Функция ПолучитьУстановкиПрокси() Экспорт	
	УстановитьПривилегированныйРежим(Истина);
	//Пользователь = "Миронова Наталия Игоревна";
	//Пароль       = "123456";
	//Адрес 		 = "http://013d03-app.owen.ru/mnf83/ws/Rarus_DataExchange?wsdl";
	Установки = Новый Структура;
	Установки.Вставить("Пользователь", Константы.ПользовательВебСервиса.Получить());
	Установки.Вставить("Адрес", Константы.АдресВебСервиса.Получить());
	Установки.Вставить("Пароль", Константы.ПарольВебСервиса.Получить());
	УстановитьПривилегированныйРежим(Ложь);

	Возврат Установки;
КонецФункции

Функция ПолучитьСписокДокументовДляОбмена() Экспорт	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДокументыДляОбменаВебСервис.СписокДокументов КАК Список
		|ИЗ
		|	РегистрСведений.ДокументыДляОбменаВебСервис КАК ДокументыДляОбменаВебСервис";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СписокИзЗаписи = Выборка.Список.Получить(); 
	КонецЦикла;
	Если СписокИзЗаписи = Неопределено тогда
		Возврат Неопределено
	иначе	
		Возврат СписокИзЗаписи.Скопировать(Новый Структура("Обмен",Истина));
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
КонецФункции

Функция ПолучитьСписокСправочниковДляОбмена() Экспорт	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДокументыДляОбменаВебСервис.СписокСправочников КАК Список
		|ИЗ
		|	РегистрСведений.ДокументыДляОбменаВебСервис КАК ДокументыДляОбменаВебСервис";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СписокИзЗаписи = Выборка.Список.Получить(); 
	КонецЦикла;
	Если СписокИзЗаписи = Неопределено тогда
		Возврат Неопределено
	иначе	
		Возврат СписокИзЗаписи.Скопировать(Новый Структура("Обмен",Истина));
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
КонецФункции

Функция ПолучитьСписокРегистровДляОбмена() Экспорт	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДокументыДляОбменаВебСервис.СписокРегистров КАК Список
		|ИЗ
		|	РегистрСведений.ДокументыДляОбменаВебСервис КАК ДокументыДляОбменаВебСервис";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СписокИзЗаписи = Выборка.Список.Получить(); 
	КонецЦикла;
	Если СписокИзЗаписи = Неопределено тогда
		Возврат Неопределено
	иначе	
		Возврат СписокИзЗаписи.Скопировать(Новый Структура("Обмен",Истина));
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
КонецФункции

Функция ПолучитьПрокси(СообщениеОбОшибке = "") Экспорт	
	УстановкиВеба = СРМ_ОбменВебСервисПовтИсп.ПолучитьУстановкиПрокси();
	Пользователь = УстановкиВеба.Пользователь;
	Пароль       = УстановкиВеба.Пароль;
	Адрес 		 = УстановкиВеба.Адрес;
	
	Если ПустаяСтрока(Адрес) Тогда
		Возврат Неопределено;
	Конецесли;
	
	Попытка
		Определения = Новый WSОпределения(Адрес, Пользователь, Пароль);
		Прокси = Новый WSПрокси(Определения, "http://www.skca.ru/SKCADataExchange", "Rarus_DataExchange", "Rarus_DataExchangeSoap");
		Прокси.Пользователь = Пользователь;
		Прокси.Пароль = Пароль;
		Возврат Прокси;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Описание = Инфо.Причина.Описание;
		Если Найти(Описание, "При создании описания сервиса произошла ошибка")
			ИЛИ Найти(Описание, "Ошибка HTTP") Тогда
			СообщениеОбОшибке = НСтр("ru='По указанному адресу сервис недоступен.';en='The service is not available.'");
		Иначе
			СообщениеОбОшибке = Инфо.Причина.Описание;
		КонецЕсли;
		Возврат Неопределено;
	КонецПопытки;
	УстановитьПривилегированныйРежим(Ложь);
КонецФункции

Функция ПолучитьПроксиУТ11(СообщениеОбОшибке = "") Экспорт	
	
	Узел = СРМ_ОбменВебСервис.ПолучитьМассивУзловПолучателей("ОбменСТорговлей")[0];

	Пользователь = Узел.Пользователь; //"Рарус";
	Пароль       = Узел.Пароль; //"14789632";
	Адрес 		 = Узел.Адрес; //"http://013d04-app.owen.ru/sales/ws/Rarus_DataExchange?wsdl";
	
	Если ПустаяСтрока(Адрес) Тогда
		Возврат Неопределено;
	Конецесли;
	
	Попытка
		Определения = Новый WSОпределения(Адрес, Пользователь, Пароль);
		Прокси = Новый WSПрокси(Определения, "http://www.skca.ru/SKCADataExchange", "Rarus_DataExchange", "Rarus_DataExchangeSoap");
		Прокси.Пользователь = Пользователь;
		Прокси.Пароль = Пароль;
		Возврат Прокси;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Описание = Инфо.Причина.Описание;
		Если Найти(Описание, "При создании описания сервиса произошла ошибка")
			ИЛИ Найти(Описание, "Ошибка HTTP") Тогда
			СообщениеОбОшибке = НСтр("ru='По указанному адресу сервис недоступен.';en='The service is not available.'");
		Иначе
			СообщениеОбОшибке = Инфо.Причина.Описание;
		КонецЕсли;
		Возврат Неопределено;
	КонецПопытки;
КонецФункции
