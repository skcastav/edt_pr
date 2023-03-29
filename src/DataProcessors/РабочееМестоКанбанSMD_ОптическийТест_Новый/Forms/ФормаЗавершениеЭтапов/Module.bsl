
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
ПолучитьТаблицуЭтапов(Параметры.ПроизводственноеЗадание.Изделие);
КонецПроцедуры

&НаСервере
Функция ПолучитьВыполненноеКоличество(Этап)	
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВыполнениеЭтаповПроизводства.МТК КАК МТК,
	|	ВыполнениеЭтаповПроизводства.Количество КАК Количество
	|ИЗ
	|	РегистрСведений.ВыполнениеЭтаповПроизводства КАК ВыполнениеЭтаповПроизводства
	|ГДЕ
	|	ВыполнениеЭтаповПроизводства.МТК = &МТК
	|	И ВыполнениеЭтаповПроизводства.РабочееМесто = &РабочееМесто
	|	И ВыполнениеЭтаповПроизводства.Спецификация = &Спецификация
	|ИТОГИ
	|	СУММА(Количество)
	|ПО
	|	МТК";
Запрос.УстановитьПараметр("МТК", Параметры.ПроизводственноеЗадание.ДокументОснование);
Запрос.УстановитьПараметр("РабочееМесто", Параметры.РабочееМесто);
Запрос.УстановитьПараметр("Спецификация", Этап);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаВЭП = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаВЭП.Следующий() Цикл
	Возврат(ВыборкаВЭП.Количество);
	КонецЦикла;
Возврат(0);
КонецФункции

&НаСервере
Процедура ПолучитьТаблицуЭтапов(ЭтапСпецификации)
	Если СокрЛП(ЭтапСпецификации.Канбан.Наименование) <> "Канбан УПЭА SMD ГСС" Тогда 
	ТЧ = ТаблицаЭтапов.Вставить(0);
	ТЧ.Этап = ЭтапСпецификации;
	ТЧ.Количество = Параметры.ПроизводственноеЗадание.Количество - ПолучитьВыполненноеКоличество(ЭтапСпецификации);
	КонецЕсли;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	НормыРасходовСрезПоследних.Элемент КАК Элемент
	|ИЗ
	|	РегистрСведений.НормыРасходов.СрезПоследних(
	|			&НаДату,
	|			Владелец = &Владелец
	|				И НормаРасходов.ВидЭлемента = &ВидЭлемента) КАК НормыРасходовСрезПоследних
	|ГДЕ
	|	НормыРасходовСрезПоследних.Норма > 0
	|	И НормыРасходовСрезПоследних.НормаРасходов.ПометкаУдаления = ЛОЖЬ";
Запрос.УстановитьПараметр("НаДату", Объект.ПроизводственноеЗадание.ДатаЗапуска);
Запрос.УстановитьПараметр("Владелец", ЭтапСпецификации);
Запрос.УстановитьПараметр("ВидЭлемента", Перечисления.ВидыЭлементовНормРасходов.Основа);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаНР = РезультатЗапроса.Выбрать();
	Пока ВыборкаНР.Следующий() Цикл
	ПолучитьТаблицуЭтапов(ВыборкаНР.Элемент);  
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ЗавершениеЭтапов()
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	флПолноеЗавершение = Истина;	
		Для каждого ТЧ Из ТаблицаЭтапов Цикл	
			Если ТЧ.Количество <> ТЧ.КоличествоВыполнено Тогда	
			флПолноеЗавершение = Ложь;
			КонецЕсли;
				Если ТЧ.КоличествоВыполнено <> 0 Тогда	
				ОбщийМодульРаботаСРегистрами.ЗафиксироватьИсполнениеЭтапаПроизводственногоЗадания(Параметры.ПроизводственноеЗадание,Параметры.РабочееМесто,ТЧ.Этап,ТЧ.КоличествоВыполнено,Параметры.Исполнитель);				
				КонецЕсли;  
		КонецЦикла;	
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат(Неопределено);
	КонецПопытки;
Возврат(флПолноеЗавершение); 
КонецФункции

&НаКлиенте
Процедура КнопкаОК(Команда)
Результат = ЗавершениеЭтапов();
	Если Результат <> Неопределено Тогда
	ЭтаФорма.Закрыть(Результат);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОтмена(Команда)
ЭтаФорма.Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЭтаповКоличествоВыполненоПриИзменении(Элемент)
	Если Элементы.ТаблицаЭтапов.ТекущиеДанные.КоличествоВыполнено > Элементы.ТаблицаЭтапов.ТекущиеДанные.Количество Тогда
	Элементы.ТаблицаЭтапов.ТекущиеДанные.КоличествоВыполнено = 0;
	Сообщить("Выпущенное кол-во не может быть больше кол-ва в ПЗ!");
	КонецЕсли; 
КонецПроцедуры
