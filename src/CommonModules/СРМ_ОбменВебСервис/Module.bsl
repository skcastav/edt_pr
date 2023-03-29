
Функция ПолучитьМассивУзловПолучателей(ИмяПланаОбмена) Экспорт

	МассивПолучателей = Новый Массив;	
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	CRM_ОбменАвтосервисCRM.Ссылка
		|ИЗ
		|	ПланОбмена.[ИмяПланаОбмена] КАК CRM_ОбменАвтосервисCRM
		|ГДЕ
		|	CRM_ОбменАвтосервисCRM.Ссылка <> &ЭтотУзел");
	
	Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена[ИмяПланаОбмена].ЭтотУзел());
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "[ИмяПланаОбмена]", ИмяПланаОбмена);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивПолучателей.Добавить(Выборка.Ссылка);
	КонецЦикла;

	Возврат МассивПолучателей;
	
КонецФункции // ПолучитьМассивПолучателей()

Процедура СериализоватьОтправитьОбъект(СтрокаХМЛ, Удаление = Ложь) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	//Для фона
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаХМЛ);
	Ссылка = ПрочитатьXML(ЧтениеXML);
	//Дляфона
	ТекстОшибки="";
	ЧтоЭто = Строка(ТипЗнч(Ссылка));
	ЧтоЭто = СтрЗаменить(ЧтоЭто,"Information register Record set","Регистр сведений набор записей");
	ЧтоЭто = СтрЗаменить(ЧтоЭто,"Document Object","Документ объект");
	ЧтоЭто = СтрЗаменить(ЧтоЭто,"Catalog Object","Справочник объект");
	ЧтоЭто = СтрЗаменить(ЧтоЭто,"Object deletion","Удаление объекта");
	//сразу регаем в план обмена 
    //РегистрацияВПланОбмена(ЧтоЭто,Ссылка);
	
	Прокси = СРМ_ОбменВебСервисПовтИсп.ПолучитьПрокси(ТекстОшибки);
	Если Прокси = Неопределено Тогда
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Интеграция с учетной системой'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
		КонецЕсли;
		РегистрацияВПланОбмена(ЧтоЭто,Ссылка);
		Если ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбмена") тогда
			ЗаписьРегистрацияОшибок(ЧтоЭто, Ссылка, СтрокаХМЛ, ТекстОшибки);
		КонецЕсли;
		Возврат;		
	КонецЕсли;
	
	Данные = Новый Структура;
	Данные.Вставить("СтрокаХМЛ", СтрокаХМЛ);
	Данные.Вставить("Удаление", Удаление);
	Попытка
		Результат = Прокси.ВыгрузитьОбъект(Новый ХранилищеЗначения(Данные, Новый СжатиеДанных(9)));	
	Исключение
		СтрокаОшибки = ОписаниеОшибки();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Интеграция с учетной системой'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			СтрокаОшибки); 
		РегистрацияВПланОбмена(ЧтоЭто,Ссылка);
		Если ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбмена") тогда
			ЗаписьРегистрацияОшибок(ЧтоЭто, Ссылка, СтрокаХМЛ, СтрокаОшибки);
		КонецЕсли;
		Возврат;
	КонецПопытки; 
	
	СтруктураРезультата = Результат.Получить();
	
	Если НЕ СтруктураРезультата.КонечноеСообщение = "Данные выгружены в учетную систему" тогда
		РегистрацияВПланОбмена(ЧтоЭто,Ссылка);
		Если ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбмена") тогда
			ЗаписьРегистрацияОшибок(ЧтоЭто, Ссылка, СтрокаХМЛ, СтруктураРезультата.СообщениеОбОшибке);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Процедура ЗаписьРегистрацияОшибок(ЧтоЭто, Ссылка, СтрокаХМЛ, Причина)
		Если Найти(ЧтоЭто,"Регистр накопления") = 0 И Найти(ЧтоЭто,"Accumulation register") = 0 тогда
			Запись = РегистрыСведений.РегистрацияОшибокОбмена.СоздатьМенеджерЗаписи();
			Запись.ИмяОбъекта = ЧтоЭто;
			Хеш = Новый ХешированиеДанных(ХешФункция.CRC32);
			Хеш.Добавить(СтрокаХМЛ);
			Запись.ХешСумма = Хеш.ХешСумма;
			Запись.ДатаРегистрации = ТекущаяДата();
			//Запись.ПричинаОшибки = СтруктураРезультата.СообщениеОбОшибке;
			Запись.ПричинаОшибки = Причина;
			Если Найти(ЧтоЭто,"Регистр сведений") = 0 И Найти(ЧтоЭто,"Information register") = 0 тогда
				Запись.Ссылка = Ссылка.Ссылка;
			КонецЕсли;
			//записываем файл на диск
			ТекДок = Новый ТекстовыйДокумент();
			ТекДок.УстановитьТекст(СтрокаХМЛ);
			Каталог = Константы.КаталогЛогирования.Получить();
			Подкаталог = Строка(формат(Запись.ДатаРегистрации,"ДФ=dd.MM.yyyy"));
			Каталог = Каталог+"\ОшибкиРегистрации\"+Подкаталог;
			ДляПроверки = Новый Файл(Каталог);
			Если НЕ ДляПроверки.Существует() тогда
			   СоздатьКаталог(Каталог);
			КонецЕсли;
			ПолноеИмяФайла = Каталог+"\"+Строка(Хеш.ХешСумма)+".xml";
			Попытка
				ТекДок.Записать(ПолноеИмяФайла, "UTF-8");
			    Запись.ПутьКФайлу = ПолноеИмяФайла;
			Исключение
			КонецПопытки;
			Запись.Записать();
		КонецЕсли;
КонецПроцедуры	

Функция ПолучаемСтрокуХМЛ(Ссылка)
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписатьXML(ЗаписьXML, Ссылка, НазначениеТипаXML.Явное);
	СтрокаХМЛ = ЗаписьXML.Закрыть();
	Возврат СтрокаХМЛ;
КонецФункции	

Процедура РегистрацияВПланОбмена(ЧтоЭто,Ссылка)
	
	//регистрируем в план обмена все кроме РС
		МассивПолучателей = ПолучитьМассивУзловПолучателей("ПланОбменаЛинейкаГлавная");
		Если Найти(ЧтоЭто,"Регистр сведений") > 0 тогда
			Если Ссылка.Количество()=0 тогда
				попытка
					ПланыОбмена.ЗарегистрироватьИзменения(МассивПолучателей, Ссылка);
				исключение
					//ЗаписьЖурналаРегистрации(НСтр("ru = 'Регистрация для веб-обмена'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					//УровеньЖурналаРегистрации.Предупреждение,,,
					//ОписаниеОшибки()); 
				КонецПопытки;
			иначе	
				Метадан = Ссылка.Метаданные();
				ОсновнойОтбор = ОсновнойОтборРегистраСведений(Метадан);
				Для каждого Запись из Ссылка цикл
					НаборЗаписей = РегистрыСведений[Метадан.Имя].СоздатьНаборЗаписей();
					Для Каждого ИмяИзмерения Из ОсновнойОтбор Цикл
						
						НаборЗаписей.Отбор[ИмяИзмерения].Значение = Запись[ИмяИзмерения];
						НаборЗаписей.Отбор[ИмяИзмерения].Использование = Истина;
						
					КонецЦикла;
					ПланыОбмена.ЗарегистрироватьИзменения(МассивПолучателей, НаборЗаписей);
				КонецЦикла;	
			КонецЕсли;	
		иначе	
			ПланыОбмена.ЗарегистрироватьИзменения(МассивПолучателей, Ссылка); 
		КонецЕсли;
КонецПроцедуры

Процедура УдалениеРегистрацииИзПланаОбмена(ЧтоЭто,Ссылка)
	
	//регистрируем в план обмена все кроме РС
		МассивПолучателей = ПолучитьМассивУзловПолучателей("ПланОбменаЛинейкаГлавная");
		Если Найти(ЧтоЭто,"Регистр сведений") > 0 тогда
			Если Ссылка.Количество()=0 тогда
				попытка
					ПланыОбмена.УдалитьРегистрациюИзменений(МассивПолучателей, Ссылка);
				исключение
					ЗаписьЖурналаРегистрации(НСтр("ru = 'Регистрация для веб-обмена'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Предупреждение,,,
					ОписаниеОшибки()); 
				КонецПопытки;
			иначе	
				Метадан = Ссылка.Метаданные();
				ОсновнойОтбор = ОсновнойОтборРегистраСведений(Метадан);
				Для каждого Запись из Ссылка цикл
					НаборЗаписей = РегистрыСведений[Метадан.Имя].СоздатьНаборЗаписей();
					Для Каждого ИмяИзмерения Из ОсновнойОтбор Цикл
						
						НаборЗаписей.Отбор[ИмяИзмерения].Значение = Запись[ИмяИзмерения];
						НаборЗаписей.Отбор[ИмяИзмерения].Использование = Истина;
						
					КонецЦикла;
					ПланыОбмена.УдалитьРегистрациюИзменений(МассивПолучателей, НаборЗаписей);
				КонецЦикла;	
			КонецЕсли;	
		иначе	
			ПланыОбмена.УдалитьРегистрациюИзменений(МассивПолучателей, Ссылка); 
		КонецЕсли;
КонецПроцедуры

Функция ОсновнойОтборРегистраСведений(ОбъектМетаданных)
	
	Результат = Новый Массив;
	
	Если ОбъектМетаданных.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический  
		И ОбъектМетаданных.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.ПозицияРегистратора тогда
		
		Результат.Добавить("Период");
		
	КонецЕсли;
	
	Для Каждого Измерение Из ОбъектМетаданных.Измерения Цикл
		
		Если Измерение.ОсновнойОтбор Тогда
			
			Результат.Добавить(Измерение.Имя);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Процедура ОтложенныйОбменДанными() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	ТекстОшибки="";
	Адрес = Константы.АдресВебСервиса.Получить();
	Если ПустаяСтрока(Адрес) тогда
		Возврат;
	КонецЕсли;	
	Прокси = СРМ_ОбменВебСервисПовтИсп.ПолучитьПрокси(ТекстОшибки);
	Если Прокси = Неопределено тогда
		Профиль = Новый ИнтернетПочтовыйПрофиль;
		Профиль.АдресСервераIMAP = "mail.owen.ru";
		Профиль.АдресСервераSMTP = "mail.owen.ru";
		Профиль.ИспользоватьSSLIMAP = Истина;
		Профиль.ПортSMTP = 587;
		Профиль.ПортIMAP = 993;
		Профиль.Пользователь = "web_1c@owen.ru";
		Профиль.Пароль = "kWaqnhYG6z";
		Профиль.ПользовательSMTP = "web_1c@owen.ru";
		Профиль.ПарольSMTP = "kWaqnhYG6z"; 
		Профиль.АутентификацияSMTP = СпособSMTPАутентификации.Login;
		
		Почта = Новый ИнтернетПочта;
		
		Письмо = Новый ИнтернетПочтовоеСообщение;
		УстановкиВеба = СРМ_ОбменВебСервисПовтИсп.ПолучитьУстановкиПрокси();
		Текст = Письмо.Тексты.Добавить("Веб-сервис недоступен по адресу: "+УстановкиВеба.Адрес);
		Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
		Письмо.Тема = "Ошибка веб-сервиса"; 
		Письмо.Отправитель = "web_1c@owen.ru";
		Письмо.ИмяОтправителя = "Производство (1.0) ОВЕН";
		Письмо.УведомитьОДоставке  = Истина;
		Письмо.УведомитьОПрочтении = Истина;
		Письмо.Получатели.Добавить("web_1c_err@owen.ru");
		
		Попытка
			Почта.Подключиться(Профиль);
		    Почта.Послать(Письмо);
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка сообщения о недоступности веб-сервиса'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ОписаниеОшибки()); 
		КонецПопытки;
		
		Почта.Отключиться();
		
		Возврат;
	КонецЕсли;	
	Узел = ПолучитьМассивУзловПолучателей("ПланОбменаЛинейкаГлавная")[0];
	Выборка = ПланыОбмена.ВыбратьИзменения(Узел,0);
	//счетчик =0;
	Пока Выборка.Следующий() цикл
		ОбъектВыборки = Выборка.Получить();
		СтрокаХМЛ = ПолучаемСтрокуХМЛ(ОбъектВыборки);
		СериализоватьОтправитьОбъект(СтрокаХМЛ);
		//счетчик = счетчик + 1;
		
		ПланыОбмена.УдалитьРегистрациюИзменений(Узел, ОбъектВыборки);
	КонецЦикла;
	//ЗаписьЖурналаРегистрации(НСтр("ru = 'Отложенный обмен'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
	//		УровеньЖурналаРегистрации.Информация,,,
	//		"Выгружено объектов: "+Строка(счетчик)); 
	 УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Процедура ОтправкаПослеТранзакции() Экспорт
	  //ФоновыеЗадания.Выполнить("СРМ_ОбменВебСервис.ОтправкаПослеТранзакцииФон");
УстановитьПривилегированныйРежим(Истина);
МассивОбъектов = ПараметрыСеанса.ОбъектыСозданныеВТранзакции.Получить();
ТекстОшибки="";

Для Каждого СтрокаХМЛ Из МассивОбъектов Цикл
	СериализоватьОтправитьОбъект(СтрокаХМЛ);
КонецЦикла;	

ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры	

Функция СверкаБаз(ДанныеОтправки) Экспорт
	ТекстОшибки="";
	Прокси = СРМ_ОбменВебСервисПовтИсп.ПолучитьПрокси(ТекстОшибки);
	Если Прокси = Неопределено Тогда
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Интеграция с учетной системой'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
		КонецЕсли;
		Возврат "Недоступен веб-сервис";		
	КонецЕсли;
	Попытка
		Результат = Прокси.СравнитьБазы(Новый ХранилищеЗначения(ДанныеОтправки, Новый СжатиеДанных(9)));	
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Интеграция с учетной системой'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ОписаниеОшибки()); 
		Возврат "Ошибка при обмене с веб-сервисом";
	КонецПопытки; 
	СтруктураРезультата = Результат.Получить();
	Возврат СтруктураРезультата;
КонецФункции

Процедура ПоискБитыхСсылок() Экспорт
	ТекстОшибки="";
	Прокси = СРМ_ОбменВебСервисПовтИсп.ПолучитьПрокси(ТекстОшибки);
	Если Прокси = Неопределено Тогда
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Поиск битых ссылок'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
		КонецЕсли;
		Возврат;		
	КонецЕсли;
	
	Данные = Новый Структура;
	Попытка
		Результат = Прокси.ПолучитьБитыеСсылки(Новый ХранилищеЗначения(Данные, Новый СжатиеДанных(9)));	
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поиск битых ссылок'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ОписаниеОшибки()); 
		Возврат;
	КонецПопытки; 
	Если НЕ Результат = Неопределено тогда
		СтруктураРезультата = Результат.Получить();
		Если НЕ СтруктураРезультата.БитыеСсылки = Неопределено тогда
			УстановитьПривилегированныйРежим(Истина);
			МассивПолучателей = ПолучитьМассивУзловПолучателей("ПланОбменаЛинейкаГлавная");
			
			Для Каждого БитаяСсылка Из СтруктураРезультата.БитыеСсылки цикл
				СсылкаНаОбъект = Неопределено;
				УИД = Новый УникальныйИдентификатор(БитаяСсылка.ЗначениеУИ);
				Выполнить("СсылкаНаОбъект = "+БитаяСсылка.Реквизит+".ПолучитьСсылку(УИД);");
				Если Найти(ВРег(Строка(СсылкаНаОбъект)), "<ОБЪЕКТ НЕ НАЙДЕН>") = 0 тогда
					ПланыОбмена.ЗарегистрироватьИзменения(МассивПолучателей, СсылкаНаОбъект); 
				КонецЕсли;	
			КонецЦикла;
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

Процедура ЧисткаКонтроляОбмена() Экспорт
		ОбработкаКонфы = Обработки.СравнениеРезультатовЗапросов.Создать();
		Результат = ОбработкаКонфы.СравнитьРезультатыУдалитьОдинаковые();
КонецПроцедуры

//подписки++ 
Процедура ОтправкаВебСервисПриЗаписи(Источник, Отказ) Экспорт
	Если Источник.ОбменДанными.Загрузка тогда  
		Возврат;
	КонецЕсли;
	СокращенныйСписок = СРМ_ОбменВебСервисПовтИсп.ПолучитьСписокСправочниковДляОбмена();
	Если  НЕ СокращенныйСписок = Неопределено тогда
		ИмяИсточника = Источник.Метаданные().Имя;
		Результат = СокращенныйСписок.Найти(ИмяИсточника);
		Если НЕ Результат = Неопределено тогда
			Если ПараметрыСеанса.АктивнаТранзакция > 0  тогда
				НовыйМассив = ПараметрыСеанса.ОбъектыСозданныеВТранзакции.Получить();
				СтрокаХМЛ = ПолучаемСтрокуХМЛ(Источник);
				НовыйМассив.Добавить(СтрокаХМЛ);
				ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(НовыйМассив);
			Иначе
				ПараметрыФон = Новый Массив;
				СтрокаХМЛ = ПолучаемСтрокуХМЛ(Источник);
				ПараметрыФон.Добавить(СтрокаХМЛ); 
				ФоновыеЗадания.Выполнить("СРМ_ОбменВебСервис.СериализоватьОтправитьОбъект",ПараметрыФон);
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

Процедура ОтправкаВебСервисРегистрыПриЗаписи(Источник, Отказ, Замещение) Экспорт
	Если Источник.ОбменДанными.Загрузка тогда  
		Возврат;
	КонецЕсли;
	
	//СокращенныйСписок = СРМ_ОбменВебСервисПовтИсп.ПолучитьСписокРегистровДляОбмена();
	//Если  НЕ СокращенныйСписок = Неопределено тогда
	//	ИмяИсточника = Источник.Метаданные().Имя;
	//	Результат = СокращенныйСписок.Найти(ИмяИсточника);
	//	Если НЕ Результат = Неопределено тогда
	//		Если ПараметрыСеанса.АктивнаТранзакция > 0  тогда
	//			НовыйМассив = ПараметрыСеанса.ОбъектыСозданныеВТранзакции.Получить();
	//			Если Источник.Количество()=0 тогда
	//				СтрокаХМЛ = ПолучаемСтрокуХМЛ(Источник);
	//			    НовыйМассив.Добавить(СтрокаХМЛ);
	//			иначе	
	//				Метадан = Источник.Метаданные();
	//				ОсновнойОтбор = ОсновнойОтборРегистраСведений(Метадан);
	//				Для каждого Запись из Источник цикл
	//					НаборЗаписей = РегистрыСведений[Метадан.Имя].СоздатьНаборЗаписей();
	//					Для Каждого ИмяИзмерения Из ОсновнойОтбор Цикл
	//						НаборЗаписей.Отбор[ИмяИзмерения].Значение = Запись[ИмяИзмерения];
	//						НаборЗаписей.Отбор[ИмяИзмерения].Использование = Истина;
	//					КонецЦикла;
	//					НовыйМассив.Добавить(СтрокаХМЛ);
	//				КонецЦикла;	
	//			КонецЕсли;	
	//			ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(НовыйМассив);
	//		Иначе	
	//			Если Источник.Количество()=0 тогда
	//				ПараметрыФон = Новый Массив;
	//				СтрокаХМЛ = ПолучаемСтрокуХМЛ(Источник);
	//				ПараметрыФон.Добавить(СтрокаХМЛ); 
	//				ФоновыеЗадания.Выполнить("СРМ_ОбменВебСервис.СериализоватьОтправитьОбъект",ПараметрыФон);
	//			иначе	
	//				Метадан = Источник.Метаданные();
	//				ОсновнойОтбор = ОсновнойОтборРегистраСведений(Метадан);
	//				Для каждого Запись из Источник цикл
	//					НаборЗаписей = РегистрыСведений[Метадан.Имя].СоздатьНаборЗаписей();
	//					Для Каждого ИмяИзмерения Из ОсновнойОтбор Цикл
	//						НаборЗаписей.Отбор[ИмяИзмерения].Значение = Запись[ИмяИзмерения];
	//						НаборЗаписей.Отбор[ИмяИзмерения].Использование = Истина;
	//					КонецЦикла;
	//					ПараметрыФон = Новый Массив;
	//					СтрокаХМЛ = ПолучаемСтрокуХМЛ(НаборЗаписей);
	//					ПараметрыФон.Добавить(СтрокаХМЛ); 
	//					ФоновыеЗадания.Выполнить("СРМ_ОбменВебСервис.СериализоватьОтправитьОбъект",ПараметрыФон);
	//				КонецЦикла;	
	//			КонецЕсли;	
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЕсли;
	
	
	
	
	СокращенныйСписок = СРМ_ОбменВебСервисПовтИсп.ПолучитьСписокРегистровДляОбмена();
	Если  НЕ СокращенныйСписок = Неопределено тогда
		ИмяИсточника = Источник.Метаданные().Имя;
		Результат = СокращенныйСписок.Найти(ИмяИсточника);
		Если НЕ Результат = Неопределено тогда
			Если ПараметрыСеанса.АктивнаТранзакция > 0  тогда
				НовыйМассив = ПараметрыСеанса.ОбъектыСозданныеВТранзакции.Получить();
				СтрокаХМЛ = ПолучаемСтрокуХМЛ(Источник);
				НовыйМассив.Добавить(СтрокаХМЛ);
				ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(НовыйМассив);
			Иначе	
				ПараметрыФон = Новый Массив;
				СтрокаХМЛ = ПолучаемСтрокуХМЛ(Источник);
				ПараметрыФон.Добавить(СтрокаХМЛ); 
				СериализоватьОтправитьОбъект(СтрокаХМЛ);
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтправкаВебСервисДокументПриЗаписи(Источник, Отказ) Экспорт
	Если Источник.ОбменДанными.Загрузка тогда  
		Возврат;
	КонецЕсли;
	
	СокращенныйСписок = СРМ_ОбменВебСервисПовтИсп.ПолучитьСписокДокументовДляОбмена();
	Если  НЕ СокращенныйСписок = Неопределено тогда
		ИмяИсточника = Источник.Метаданные().Имя;
		Результат = СокращенныйСписок.Найти(ИмяИсточника);
		Если НЕ Результат = Неопределено тогда
			Если ПараметрыСеанса.АктивнаТранзакция > 0  тогда
				НовыйМассив = ПараметрыСеанса.ОбъектыСозданныеВТранзакции.Получить();
				СтрокаХМЛ = ПолучаемСтрокуХМЛ(Источник);
				НовыйМассив.Добавить(СтрокаХМЛ);
				ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(НовыйМассив);
			Иначе	
				ПараметрыФон = Новый Массив;
				СтрокаХМЛ = ПолучаемСтрокуХМЛ(Источник);
				ПараметрыФон.Добавить(СтрокаХМЛ); 
				//ПараметрыФон.Добавить(Ложь);
				ФоновыеЗадания.Выполнить("СРМ_ОбменВебСервис.СериализоватьОтправитьОбъект",ПараметрыФон);
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

Процедура ОтправкаВебСервисДвиженияОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
	Если Источник.ОбменДанными.Загрузка тогда
		Возврат;
	КонецЕсли;
	СокращенныйСписок = СРМ_ОбменВебСервисПовтИсп.ПолучитьСписокДокументовДляОбмена();
	Если  НЕ СокращенныйСписок = Неопределено тогда
		ИмяИсточника = Источник.Метаданные().Имя;
		Результат = СокращенныйСписок.Найти(ИмяИсточника);
		Если НЕ Результат = Неопределено тогда
			Для каждого Набор из Источник.Движения цикл
				Если ПараметрыСеанса.АктивнаТранзакция > 0  тогда
					НовыйМассив = ПараметрыСеанса.ОбъектыСозданныеВТранзакции.Получить();
					СтрокаХМЛ = ПолучаемСтрокуХМЛ(Набор);
					НовыйМассив.Добавить(СтрокаХМЛ);
					ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(НовыйМассив);
				Иначе	
				ПараметрыФон = Новый Массив;
				СтрокаХМЛ = ПолучаемСтрокуХМЛ(Набор);
				ПараметрыФон.Добавить(СтрокаХМЛ); 
				//ПараметрыФон.Добавить(Ложь);
				ФоновыеЗадания.Выполнить("СРМ_ОбменВебСервис.СериализоватьОтправитьОбъект",ПараметрыФон);
				КонецЕсли;	
			КонецЦикла;	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОтправкаВебСервисДокументУдалениеПередУдалением(Источник, Отказ) Экспорт
	Если Источник.ОбменДанными.Загрузка тогда
		Возврат;
	КонецЕсли;
	СокращенныйСписок = СРМ_ОбменВебСервисПовтИсп.ПолучитьСписокДокументовДляОбмена();
	Если  НЕ СокращенныйСписок = Неопределено тогда
		ИмяИсточника = Источник.Метаданные().Имя;
		Результат = СокращенныйСписок.Найти(ИмяИсточника);
		Если НЕ Результат = Неопределено тогда
				ПараметрыФон = Новый Массив;
				СтрокаХМЛ = ПолучаемСтрокуХМЛ(Новый УдалениеОбъекта(Источник.Ссылка));
				ПараметрыФон.Добавить(СтрокаХМЛ);
				ФоновыеЗадания.Выполнить("СРМ_ОбменВебСервис.СериализоватьОтправитьОбъект",ПараметрыФон);
			//КонечноеСообщение = СериализоватьОтправитьОбъект(Новый УдалениеОбъекта(Источник.Ссылка), Истина);
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

Процедура ОтправкаВебСервисСправочникУдалениеПередУдалением(Источник, Отказ) Экспорт
	Если Источник.ОбменДанными.Загрузка тогда
		Возврат;
	КонецЕсли;
	СокращенныйСписок = СРМ_ОбменВебСервисПовтИсп.ПолучитьСписокСправочниковДляОбмена();
	Если  НЕ СокращенныйСписок = Неопределено тогда
		ИмяИсточника = Источник.Метаданные().Имя;
		Результат = СокращенныйСписок.Найти(ИмяИсточника);
		Если НЕ Результат = Неопределено тогда
				ПараметрыФон = Новый Массив;
				СтрокаХМЛ = ПолучаемСтрокуХМЛ(Новый УдалениеОбъекта(Источник.Ссылка));
				ПараметрыФон.Добавить(СтрокаХМЛ);
				ФоновыеЗадания.Выполнить("СРМ_ОбменВебСервис.СериализоватьОтправитьОбъект",ПараметрыФон);
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

Процедура ОтправкаВебСервисПланХарактеристикПриЗаписи(Источник, Отказ) Экспорт
	Если Источник.ОбменДанными.Загрузка тогда  
		Возврат;
	КонецЕсли;
	Если ПараметрыСеанса.АктивнаТранзакция > 0  тогда
		НовыйМассив = ПараметрыСеанса.ОбъектыСозданныеВТранзакции.Получить();
		СтрокаХМЛ = ПолучаемСтрокуХМЛ(Источник);
		НовыйМассив.Добавить(СтрокаХМЛ);
		ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(НовыйМассив);
	Иначе
		ПараметрыФон = Новый Массив;
		СтрокаХМЛ = ПолучаемСтрокуХМЛ(Источник);
		ПараметрыФон.Добавить(СтрокаХМЛ); 
		ФоновыеЗадания.Выполнить("СРМ_ОбменВебСервис.СериализоватьОтправитьОбъект",ПараметрыФон);
	КонецЕсли;	
КонецПроцедуры
//подписки--

//=====================================================================================================
//для регламентного задания

// Находит регламентное задание по GUID.
//
// Параметры:
//  УникальныйНомерЗадания - Строка - строка с GUID регламентного задания.
// 
// Возвращаемое значение:
//  Неопределено        - если поиск регламентного задания по GUID не дал результатов или.
//  РегламентноеЗадание - найденное по GUID регламентное задание.
//
Функция НайтиРегламентноеЗаданиеПоПараметру(Знач УникальныйНомерЗадания) Экспорт
	
	Если ПустаяСтрока(УникальныйНомерЗадания) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("УникальныйИдентификатор", Новый УникальныйИдентификатор(УникальныйНомерЗадания));
	
	УстановитьПривилегированныйРежим(Истина);
	Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	
	Если Задания.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат Задания[0];
	
КонецФункции

Процедура ВыгрузкаРезультатовЗапросов(КодЗапроса) Экспорт
	
	//ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ВыгрузкаРезультатовЗапросов);

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Код", КодЗапроса);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	АЭМ_Запросы.ТекстЗапроса КАК ТекстЗапроса,
	|	АЭМ_Запросы.Параметры.(
	|		ИмяПараметра КАК ИмяПараметра,
	|		ЗначениеПараметра КАК ЗначениеПараметра
	|	) КАК Параметры,
	|	АЭМ_Запросы.Наименование КАК Наименование
	|ИЗ
	|	Справочник.Запросы КАК АЭМ_Запросы
	|ГДЕ
	|	АЭМ_Запросы.Код = &Код";
	
	ВыборкаЗапрос = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаЗапрос.Следующий() Тогда
			
		ОбработкаКонфы = Обработки.СравнениеРезультатовЗапросов.Создать();
		ОбработкаКонфы.ТекстЗапроса = ВыборкаЗапрос.ТекстЗапроса;
		
		ПараметрыЗапроса = ВыборкаЗапрос.Параметры.Выгрузить();
		
		СтрокаСТекущейДатой = ПараметрыЗапроса.Найти("ТекущаяДата","ИмяПараметра");
		Если НЕ СтрокаСТекущейДатой = Неопределено тогда
			СтрокаСТекущейДатой.ЗначениеПараметра = ТекущаяДата();
		КонецЕсли;
		
		СтрокаСВчерашнейДатой = ПараметрыЗапроса.Найти("Вчера","ИмяПараметра");
		Если НЕ СтрокаСВчерашнейДатой = Неопределено тогда
			СтрокаСВчерашнейДатой.ЗначениеПараметра = ТекущаяДата() - 86400;
		КонецЕсли;
		
		ОбработкаКонфы.Параметры.Загрузить(ПараметрыЗапроса); 
		Результат = ОбработкаКонфы.СравнитьРезультатыЗапросов();
		
		Если НЕ Результат.ОтчетСравнения = Неопределено тогда
			Путь = ПолучитьИмяВременногоФайла();
			Файл = Новый Файл(Путь);
			ПутьКФайлу = Файл.Путь;
			УдалитьФайлы(Файл);
			ИмяФайла = "" + ПутьКФайлу + "\Отчет" + СокрЛП(ВыборкаЗапрос.Наименование) + ".xls";
			Результат.ОтчетСравнения.Записать(ИмяФайла,ТипФайлаТабличногоДокумента.xls);
		КонецЕсли;
		
		Профиль = Новый ИнтернетПочтовыйПрофиль;
		Профиль.АдресСервераIMAP = "mail.owen.ru";
		Профиль.АдресСервераSMTP = "mail.owen.ru";
		Профиль.ИспользоватьSSLIMAP = Истина;
		Профиль.ПортSMTP = 587;
		Профиль.ПортIMAP = 993;
		Профиль.Пользователь = "web_1c@owen.ru";
		Профиль.Пароль = "kWaqnhYG6z";
		Профиль.ПользовательSMTP = "web_1c@owen.ru";
		Профиль.ПарольSMTP = "kWaqnhYG6z"; 
		Профиль.АутентификацияSMTP = СпособSMTPАутентификации.Login;
		
		Почта = Новый ИнтернетПочта;
		
		Письмо = Новый ИнтернетПочтовоеСообщение;
			
		Текст = Письмо.Тексты.Добавить(Результат.Ошибка);
		Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
		Письмо.Тема = "Отчеты по сравнению баз"; 
		Письмо.Отправитель = "web_1c@owen.ru";
		Письмо.ИмяОтправителя = "Производство (1.0) ОВЕН";
		Если НЕ Результат.ОтчетСравнения = Неопределено тогда
			Письмо.Вложения.Добавить(ИмяФайла,"Отчет по запросу "+СокрЛП(ВыборкаЗапрос.Наименование));
		КонецЕсли;
		Письмо.УведомитьОДоставке  = Истина;
		Письмо.УведомитьОПрочтении = Истина;
		Письмо.Получатели.Добавить("web_1c_err@owen.ru");
		
		Попытка
			Почта.Подключиться(Профиль);
		    Почта.Послать(Письмо);
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка сообщения о недоступности веб-сервиса'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ОписаниеОшибки()); 
		КонецПопытки;
		
		Почта.Отключиться();

	КонецЕсли;
	
КонецПроцедуры

Функция РасписаниеРегламентногоЗаданияПоУмолчанию() Экспорт
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ДниНедели                = ДниНедели;
	Расписание.ПериодПовтораВТечениеДня = 900; // 15 минут
	Расписание.ПериодПовтораДней        = 1; // каждый день
	Расписание.Месяцы                   = Месяцы;
	
	Возврат Расписание;
КонецФункции

//====================== для УТ11.1
Процедура УстановкаСтатусаСобранПриЗаписи(Источник, Отказ, Замещение) Экспорт
	//Для каждого Запись из Источник цикл
	//	Если Запись.Статус = Перечисления.СтатусыНакладнойНаСборку.Собран тогда
	//		МассивПараметров = Новый Массив;
	//		МассивПараметров.Добавить(Запись.НакладнаяНаСборку);
	//		ФоновыеЗадания.Выполнить("СРМ_ОбменВебСервис.СоздатьПоступлениеВ_УТ11", МассивПараметров);
	//	КонецЕсли;	
	//КонецЦикла;
КонецПроцедуры

Процедура СоздатьПоступлениеВ_УТ11(ННС) Экспорт
	//сразу регаем
	УстановитьПривилегированныйРежим(Истина);
	//ННС = Документы.НакладнаяНаСборку.НайтиПоНомеру(бсНовДок.НакладнаяНаСборку);
	МассивУзлов = ПолучитьМассивУзловПолучателей("ОбменСТорговлей");
	ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, ННС);
	ТекстОшибки = "";
	Прокси = СРМ_ОбменВебСервисПовтИсп.ПолучитьПроксиУТ11(ТекстОшибки);
	Если Прокси = Неопределено Тогда
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Интеграция с Управление торговлей 11.1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
		КонецЕсли;
		Возврат;		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПРЕДСТАВЛЕНИЕ(ГТД.Товар) КАК Продукция,
	               |	ПРЕДСТАВЛЕНИЕ(ГТД.НомерГТД) КАК ГТД,
	               |	ПРЕДСТАВЛЕНИЕ(ГТД.НомерГТД.Страна) КАК Страна,
	               |	ГТД.Количество КАК Количество
	               |ИЗ
	               |	РегистрНакопления.ГТД КАК ГТД
	               |ГДЕ
	               |	ГТД.Регистратор = &Регистратор
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	НакладнаяНаСборкуТабличнаяЧасть.ЗаказНаПроизводство.Номер КАК НомерЗаказа,
	               |	НакладнаяНаСборкуТабличнаяЧасть.ЗаказНаПроизводство.Дата КАК ДатаЗаказа,
	               |	НакладнаяНаСборкуТабличнаяЧасть.Количество КАК Количество,
	               |	НакладнаяНаСборкуТабличнаяЧасть.Товар.Код КАК КодТовара,
	               |	ПРЕДСТАВЛЕНИЕ(НакладнаяНаСборкуТабличнаяЧасть.Продукция) КАК Продукция
	               |ИЗ
	               |	Документ.НакладнаяНаСборку.ТабличнаяЧасть КАК НакладнаяНаСборкуТабличнаяЧасть
	               |ГДЕ
	               |	НакладнаяНаСборкуТабличнаяЧасть.Ссылка = &Регистратор";
	
	Запрос.УстановитьПараметр("Регистратор", ННС);	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ТаблицаГТД = РезультатЗапроса[0].Выгрузить();
	ТабличнаяЧастьННС = РезультатЗапроса[1].Выгрузить();;
	
	бсНовДок = Новый Структура();
	бсНовДок.Вставить("НакладнаяНаСборку", ННС.Номер);
	бсНовДок.Вставить("НомераТары",ННС.НомераТары);
	бсНовДок.Вставить("ЛинейкаУпаковки",Строка(ННС.ЛинейкаУпаковки));
	бсНовДок.Вставить("ТаблицаГТД",ТаблицаГТД);
	бсНовДок.Вставить("ТабличнаяЧасть",ТабличнаяЧастьННС);
	
	
	Попытка
	   РезультатПрокси = Прокси.СозданиеПоступленияИзННС(Новый ХранилищеЗначения(бсНовДок, Новый СжатиеДанных(9)));
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Интеграция с Управление торговлей 11.1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ОписаниеОшибки()); 
		Возврат;
	КонецПопытки; 
	//Результат  = Новый Структура("СозданиеУспешно, ТекстОшибки", Ложь, "") 
	РезультатСтруктура = РезультатПрокси.Получить();
	Если РезультатСтруктура.СозданиеУспешно тогда
		СННС = РегистрыСведений.СтатусыНакладныхНаСборку.СоздатьМенеджерЗаписи();
		СННС.Период = ТекущаяДата();
		СННС.НакладнаяНаСборку = ННС;
		СННС.Статус = Перечисления.СтатусыНакладнойНаСборку.НаУпаковке;
		СННС.Записать();
		//удаляем из регистрации если все ок
	    ПланыОбмена.УдалитьРегистрациюИзменений(МассивУзлов,ННС);
		//удаляем записи об ошибках, если были 
		НаборЗаписей = РегистрыСведений.КонтрольСозданияПоступленийИзННС.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ННС = ННС;
		НаборЗаписей.Записать();
	Иначе
		//ЗаписьЖурналаРегистрации(НСтр("ru = 'Интеграция с Управление торговлей 11.1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		//	УровеньЖурналаРегистрации.Ошибка,,,РезультатСтруктура.ТекстОшибки);
		Запись = РегистрыСведений.КонтрольСозданияПоступленийИзННС.СоздатьМенеджерЗаписи();
		Запись.ННС = ННС;
		Запись.Ошибка = РезультатСтруктура.ТекстОшибки;
		Запись.Записать(Истина);
	КонецЕсли;	
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры	

Процедура ОтложенныйОбменННС() Экспорт
	УстановитьПривилегированныйРежим(Ложь);
	Узел = ПолучитьМассивУзловПолучателей("ОбменСТорговлей")[0];
	Выборка = ПланыОбмена.ВыбратьИзменения(Узел,0);
	Пока Выборка.Следующий() цикл
		ОбъектВыборки = Выборка.Получить();
		СоздатьПоступлениеВ_УТ11(ОбъектВыборки.Ссылка)
	КонецЦикла;
	 УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Функция СтруктураННС(ННС)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПРЕДСТАВЛЕНИЕ(ГТД.Товар) КАК Продукция,
	               |	ПРЕДСТАВЛЕНИЕ(ГТД.НомерГТД) КАК ГТД,
	               |	ПРЕДСТАВЛЕНИЕ(ГТД.НомерГТД.Страна) КАК Страна,
	               |	ГТД.Количество КАК Количество
	               |ИЗ
	               |	РегистрНакопления.ГТД КАК ГТД
	               |ГДЕ
	               |	ГТД.Регистратор = &Регистратор
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	НакладнаяНаСборкуТабличнаяЧасть.ЗаказНаПроизводство.Номер КАК НомерЗаказа,
	               |	НакладнаяНаСборкуТабличнаяЧасть.ЗаказНаПроизводство.Дата КАК ДатаЗаказа,
	               |	НакладнаяНаСборкуТабличнаяЧасть.Количество КАК Количество,
	               |	НакладнаяНаСборкуТабличнаяЧасть.Товар.Код КАК КодТовара,
	               |	ПРЕДСТАВЛЕНИЕ(НакладнаяНаСборкуТабличнаяЧасть.Продукция) КАК Продукция
	               |ИЗ
	               |	Документ.НакладнаяНаСборку.ТабличнаяЧасть КАК НакладнаяНаСборкуТабличнаяЧасть
	               |ГДЕ
	               |	НакладнаяНаСборкуТабличнаяЧасть.Ссылка = &Регистратор";
	
	Запрос.УстановитьПараметр("Регистратор", ННС);	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ТаблицаГТД = РезультатЗапроса[0].Выгрузить();
	ТабличнаяЧастьННС = РезультатЗапроса[1].Выгрузить();;
	
	бсНовДок = Новый Структура();
	бсНовДок.Вставить("НакладнаяНаСборку", ННС.Номер);
	бсНовДок.Вставить("НомераТары",ННС.НомераТары);
	бсНовДок.Вставить("ЛинейкаУпаковки",Строка(ННС.ЛинейкаУпаковки));
	бсНовДок.Вставить("ТаблицаГТД",ТаблицаГТД);
	бсНовДок.Вставить("ТабличнаяЧасть",ТабличнаяЧастьННС);
	
	Возврат бсНовДок;
КонецФункции	

