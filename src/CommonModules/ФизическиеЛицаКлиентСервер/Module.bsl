////////////////////////////////////////////////////////////////////////////////
// Подсистема "Физические лица".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция раскладывает ФИО в структуру.
//
// Параметры:
//	 ФИО - строка - наименование.
//
// Возвращаемое значение:
//	 Структура - со свойствами: 
//     * Фамилия  - Строка
//     * Имя      - Строка
//     * Отчество - Строка
//
Функция ФамилияИмяОтчество(Знач ФИО) Экспорт
	
	СтруктураФИО = Новый Структура("Фамилия, Имя, Отчество");
	
	МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ФИО, " ");
	
	Если МассивПодстрок.Количество() > 0 Тогда
		СтруктураФИО.Вставить("Фамилия", МассивПодстрок[0]);
		Если МассивПодстрок.Количество() > 1 Тогда
			СтруктураФИО.Вставить("Имя", МассивПодстрок[1]);
		КонецЕсли;
		Если МассивПодстрок.Количество() > 2 Тогда
			Отчество = "";
			Для Шаг = 2 По МассивПодстрок.Количество()-1 Цикл
				Отчество = Отчество + МассивПодстрок[Шаг] + " ";
			КонецЦикла;
			СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Отчество, 1);
			СтруктураФИО.Вставить("Отчество", Отчество);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруктураФИО;
	
КонецФункции

// Формирует фамилию и инициалы либо по переданным строкам.
//
// Параметры:
//  ФИОСтрокой	- Строка - если указан это параметр, то остальные игнорируются.
//  Фамилия		- Строка - фамилия физического лица.
//  Имя			- Строка - имя физического лица.
//  Отчество	- Строка - отчество физического лица.
//
// Возвращаемое значение:
//  Строка - фамилия и инициалы одной строкой. 
//  В параметрах Фамилия, Имя и Отчество записываются вычисленные части.
//
// Пример:
//  Результат = ФамилияИнициалыФизЛица("Иванов Иван Иванович"); // Результат = "Иванов И. И."
//
Функция ФамилияИнициалыФизЛица(ФИОСтрокой = "", Фамилия = " ", Имя = " ", Отчество = " ") Экспорт

	ТипОбъекта = ТипЗнч(ФИОСтрокой);
	Если ТипОбъекта = Тип("Строка") Тогда
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(ФИОСтрокой), " ");
		
	Иначе
		// Используем возможно переданные отдельные строки.
		Возврат ?(Не ПустаяСтрока(Фамилия), 
		          Фамилия + ?(Не ПустаяСтрока(Имя), " " + Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество,1) + ".", ""), ""),
		          "");
	КонецЕсли;
	
	КоличествоПодстрок = ФИО.Количество();
	Фамилия            = ?(КоличествоПодстрок > 0, ФИО[0], "");
	Имя                = ?(КоличествоПодстрок > 1, ФИО[1], "");
	Отчество           = ?(КоличествоПодстрок > 2, ФИО[2], "");
	
	Если КоличествоПодстрок > 3 Тогда
		ДополнительныеЧастиОтчества = Новый Массив;
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'оглы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'улы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'уулу'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'кызы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'гызы'"));
		
		Если ДополнительныеЧастиОтчества.Найти(НРег(ФИО[3])) <> Неопределено Тогда
			Отчество = Отчество + " " + ФИО[3];
		КонецЕсли;
	КонецЕсли;
	
	Возврат ?(Не ПустаяСтрока(Фамилия), 
	          Фамилия + ?(Не ПустаяСтрока(Имя), " " + Лев(Имя, 1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество, 1) + ".", ""), ""),
	          "");
	
КонецФункции

// Проверяет верно ли написано ФИО.
// ФИО может быть написано либо только на кириллице, либо только на латинице.
// Также можно указать, что ФИО может быть верным только в кириллице.
//
// Параметры:
//		СтрокаПараметр - строка - ФИО.
//		ДопустимаТолькоКириллица - если Истина, то ФИО проверяется на кириллицу, латиница в этом случае считается ошибкой.
//									Ложь - ФИО считается верным, если оно написано либо на латинице, либо на кириллице.
//
// Возвращаемое значение:
//		Истина - ФИО написано верно, иначе Ложь.
//
Функция ФИОНаписаноВерно(Знач СтрокаПараметр, ТолькоКириллица = Ложь) Экспорт
	
	ДопустимыеСимволы = "-";
	
	Возврат (НЕ ТолькоКириллица И СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(СтрокаПараметр, Ложь, ДопустимыеСимволы)) Или
			СтроковыеФункцииКлиентСервер.ТолькоКириллицаВСтроке(СтрокаПараметр, Ложь, ДопустимыеСимволы);
	
КонецФункции

// Устарела. Следует использовать функцию ОбщегоНазначения.Просклонять.
// Функция не работает на клиенте.
Функция Просклонять(Знач ФИО, Падеж, Результат, Пол = Неопределено) Экспорт
	#Если Сервер Тогда
	Возврат ОбщегоНазначения.Просклонять(ФИО, Падеж, Результат, Пол);
	#Иначе
	Результат = ФИО;
	Возврат Ложь;
	#КонецЕсли
КонецФункции

#КонецОбласти
