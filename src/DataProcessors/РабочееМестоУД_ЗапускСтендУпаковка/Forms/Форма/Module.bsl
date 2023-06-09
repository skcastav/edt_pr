
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
ДатаВыпуска = ТекущаяДата();
ДатаВыпускаТекущая = ДатаВыпуска;
Объект.Исполнитель = ПараметрыСеанса.Пользователь;
	Если Константы.КодБазы.Получить() = "БГР" Тогда
	ИзменитьПоМаске = Истина;
	КонецЕсли; 
		Если Объект.Исполнитель.Пустая() Тогда
		Элементы.РабочееМесто.Доступность = Ложь;
		Сообщить("Вы не внесены в справочник Сотрудников! Работа невозможна!");
		КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ДатаВыпускаПриИзменении(Элемент)
ДатаВыпускаТекущая = ДатаВыпуска;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДерево(ЭтапСпецификации)
Объект.Спецификация.Сортировать("ТипСправочника Убыв,ВидМПЗ,Позиция,МПЗ");
тДерево = РеквизитФормыВЗначение("ДеревоСпецификации");
тДерево.Строки.Очистить();
ТипСпр = "";
	Для каждого ТЧ Из Объект.Спецификация Цикл
		Если ТЧ.ЭтапСпецификации <> ЭтапСпецификации Тогда
		Продолжить;		
		КонецЕсли; 
			Если ТипСпр <> ТЧ.ТипСправочника Тогда
			Стр = тДерево.Строки.Добавить();
			Стр.ТипСправочника = ТЧ.ТипСправочника;
			ТипСпр = ТЧ.ТипСправочника;
			КонецЕсли; 
	СтрЗнч = Стр.Строки.Добавить();
	СтрЗнч.Позиция = ТЧ.Позиция;
	СтрЗнч.ВидЭлемента = ТЧ.ВидМПЗ;
	СтрЗнч.МПЗ = ТЧ.МПЗ;
	СтрЗнч.Количество = ТЧ.Количество;
	СтрЗнч.ЕдиницаИзмерения = ТЧ.ЕдиницаИзмерения;
	СтрЗнч.Аналог = ТЧ.Аналог;
	СтрЗнч.Примечание = ТЧ.Примечание;
		Если ТЧ.Владелец <> Неопределено Тогда
		СтрЗнч.Владелец = ТЧ.Владелец.Элемент;
		КонецЕсли;		 
	КонецЦикла;
ЗначениеВРеквизитФормы(тДерево, "ДеревоСпецификации");
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКомплектацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
ЗаполнитьДерево(Элемент.ТекущиеДанные.ЭтапСпецификации);
РазвернутьДерево(Неопределено);
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокЛО(ЭтапСпецификации,СписокНезавершенных,СписокЛО)
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н(ЭтапСпецификации,ТекущаяДата());
	Пока ВыборкаНР.Следующий() Цикл
		Если ВыборкаНР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Набор Тогда	
		ПолучитьСписокЛО(ВыборкаНР.Элемент,СписокНезавершенных,СписокЛО);
		Иначе
			Если СписокНезавершенных.НайтиПоЗначению(ВыборкаНР.Элемент) <> Неопределено Тогда
			СписокЛО.Добавить(ВыборкаНР.Ссылка);
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры 

&НаСервере
Функция ПолучитьВТ(МТК)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПроизводственноеЗадание.Ссылка КАК ПЗ
	|ИЗ
	|	Документ.ПроизводственноеЗадание КАК ПроизводственноеЗадание
	|ГДЕ
	|	ПроизводственноеЗадание.ДокументОснование = &ДокументОснование";
Запрос.УстановитьПараметр("ДокументОснование", МТК);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл  
	Возврат(ВыборкаДетальныеЗаписи.ПЗ.ВозвратнаяТара);
	КонецЦикла;
Возврат("");
КонецФункции

&НаСервере
Функция ПеремещеноНаСкладЛинейки(МТК)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДвижениеМПЗ.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ДвижениеМПЗ КАК ДвижениеМПЗ
	|ГДЕ
	|	ДвижениеМПЗ.ДокументОснование.ДокументОснование = &ДокументОснование
	|	И ДвижениеМПЗ.Проведен = ИСТИНА";
Запрос.УстановитьПараметр("ДокументОснование", МТК);
РезультатЗапроса = Запрос.Выполнить();
Возврат(Не РезультатЗапроса.Пустой());
КонецФункции 

&НаСервере
Процедура ПолучитьПодчиненныеДокументы(ПЗ)
ТаблицаПодчиненныхДокументов.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаршрутнаяКарта.Ссылка КАК Ссылка,
	|	МаршрутнаяКарта.Номенклатура КАК Номенклатура
	|ИЗ
	|	Документ.МаршрутнаяКарта КАК МаршрутнаяКарта
	|ГДЕ
	|	МаршрутнаяКарта.ДокументОснование = &ДокументОснование";
Запрос.УстановитьПараметр("ДокументОснование", ПЗ.ДокументОснование);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = ТаблицаПодчиненныхДокументов.Добавить();
	ТЧ.ВозвратнаяТара = ПолучитьВТ(ВыборкаДетальныеЗаписи.Ссылка);
	ТЧ.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
		Если ВыборкаДетальныеЗаписи.Ссылка.Статус = 3 Тогда		
			Если Не ПеремещеноНаСкладЛинейки(ВыборкаДетальныеЗаписи.Ссылка) Тогда
			ТЧ.Незавершена = Истина;
			КонецЕсли 
		Иначе
		ТЧ.Незавершена = Истина;
		КонецЕсли;
	КонецЦикла;
Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка КАК Ссылка,
	|	ДвижениеМПЗТабличнаяЧасть.МПЗ КАК Номенклатура
	|ИЗ
	|	Документ.ДвижениеМПЗ.ТабличнаяЧасть КАК ДвижениеМПЗТабличнаяЧасть
	|ГДЕ
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.ДокументОснование = &ДокументОснование";
Запрос.УстановитьПараметр("ДокументОснование", ПЗ.ДокументОснование);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = ТаблицаПодчиненныхДокументов.Добавить();
	ТЧ.ВозвратнаяТара = ВыборкаДетальныеЗаписи.Ссылка.ВозвратнаяТара;
	ТЧ.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПроверитьПодчиненныеМТК(ПЗ)
	Если Константы.КодБазы.Получить() = "БГР" Тогда
	СписокЛО = Новый СписокЗначений;
	СписокНезавершенных = Новый СписокЗначений;

		Для каждого ТЧ Из ТаблицаПодчиненныхДокументов Цикл
			Если ТЧ.Незавершена Тогда
			СписокНезавершенных.Добавить(ТЧ.Номенклатура);
			КонецЕсли;	
		КонецЦикла;
			Если СписокНезавершенных.Количество() > 0 Тогда
				Для каждого ТЧ Из Этапы Цикл
				ПолучитьСписокЛО(ТЧ.ЭтапСпецификации,СписокНезавершенных,СписокЛО);
				КонецЦикла;		
					Если СписокЛО.Количество() > 0 Тогда
					ОбщийМодульРаботаСРегистрами.ОбработкаЛьготнойОчереди(ПЗ,СписокЛО);
					КонецЕсли;
			Возврат(Ложь);			
			КонецЕсли;
	КонецЕсли;
Возврат(Истина);
КонецФункции

&НаСервере
Функция ПолучитьЗаданиеНаСервере()
Результат = ОбщийМодульАРМ.ПолучитьНезавершенноеЗаданиеПоСпискуРабочихМест(Этапы,ЭтапыАРМ,СписокРабочихМест,Объект.Исполнитель);
	Если Результат <> Неопределено Тогда 
	Объект.ПроизводственноеЗадание = Результат.ПЗ;
	Объект.РабочееМесто = Результат.РабочееМесто;
	ПолучитьПодчиненныеДокументы(Объект.ПроизводственноеЗадание);
	Возврат(1);
	КонецЕсли;
     
СписокИзделийЛО = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаНачала,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто
	|ИЗ
	|	РегистрСведений.ЭтапыПроизводственныхЗаданий.СрезПоследних КАК ЭтапыПроизводственныхЗаданийСрезПоследних
	|ГДЕ
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.РабочееМесто В(&СписокРабочихМест)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.Ремонт = ЛОЖЬ
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ДатаОкончания = ДАТАВРЕМЯ(1,1,1,0,0,0)
	|	И ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.Статус <> 2
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.НомерОчереди,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование.ДатаОтгрузки,
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.Номер
	|ИТОГИ ПО
	|	ЭтапыПроизводственныхЗаданийСрезПоследних.ПЗ.ДокументОснование";	
Запрос.УстановитьПараметр("СписокРабочихМест",СписокРабочихМест);
Результат = Запрос.Выполнить();

ВыборкаМТК = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаМТК.Следующий() Цикл
	ВыборкаДетальныеЗаписи = ВыборкаМТК.Выбрать(ОбходРезультатаЗапроса.Прямой);
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если СписокИзделийЛО.НайтиПоЗначению(ВыборкаДетальныеЗаписи.ПЗ.Изделие) <> Неопределено Тогда
			Прервать; //Переходим к следующей МТК
			КонецЕсли;
				Если Не ОбщийМодульВызовСервера.СоздатьТаблицуЭтаповПроизводства(ВыборкаДетальныеЗаписи.ПЗ,Этапы,ЭтапыАРМ,ВыборкаДетальныеЗаписи.РабочееМесто,Объект.Исполнитель) Тогда	
				Прервать; //Переходим к следующей МТК			
				КонецЕсли;
		ПолучитьПодчиненныеДокументы(ВыборкаДетальныеЗаписи.ПЗ);
			Если ВыборкаДетальныеЗаписи.РабочееМесто.Код = 1 Тогда
				Если Не ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ПЗ.ДатаЗапуска) Тогда
					Если ТаблицаПодчиненныхДокументов.Количество() > 0 Тогда
						Если Не ПроверитьПодчиненныеМТК(ВыборкаДетальныеЗаписи.ПЗ) Тогда						
						Прервать; //Переходим к следующей МТК
						КонецЕсли;
					Иначе
						Если ОбщийМодульВызовСервера.ИмеетНестандартныеДетали(ВыборкаДетальныеЗаписи.ПЗ.Изделие,Ложь) Тогда
						Прервать; //Переходим к следующей МТК
						КонецЕсли; 
					КонецЕсли; 
				Результат = ОбщийМодульВызовСервера.ЗапуститьВПроизводство(ВыборкаДетальныеЗаписи.ПЗ,ВыборкаДетальныеЗаписи.РабочееМесто,Этапы);
					Если Результат = 0 Тогда
					СписокИзделийЛО.Добавить(ВыборкаДетальныеЗаписи.ПЗ.Изделие);
					Прервать; //Переходим к следующей МТК
					ИначеЕсли Результат = -1 Тогда
					Возврат(-1);
					КонецЕсли; 
				КонецЕсли;
			КонецЕсли;   
		Объект.ПроизводственноеЗадание = ВыборкаДетальныеЗаписи.ПЗ;
		Объект.РабочееМесто = ВыборкаДетальныеЗаписи.РабочееМесто; 
			Если СокрЛП(Объект.РабочееМесто.ГруппаРабочихМест.Префикс) = "СТ" Тогда
			СуществующийСП = РегистрыСведений.СтендовыйПрогон.ПолучитьПоследнее(,Новый Структура("ПЗ",Объект.ПроизводственноеЗадание));
			СП = РегистрыСведений.СтендовыйПрогон.СоздатьМенеджерЗаписи();
			СП.Период = ТекущаяДата();
			СП.ПЗ = Объект.ПроизводственноеЗадание;
			СП.Изделие = Объект.ПроизводственноеЗадание.Изделие;
			СП.БарКод = Объект.ПроизводственноеЗадание.БарКод;
			СП.Стенд = Объект.РабочееМесто.Стенд;
			СП.Прогон = СуществующийСП.Прогон+1;
			СП.ИсполнительПоступление = Объект.РабочееМесто.Стенд.Исполнитель;
			СП.ДатаПоступления = ТекущаяДата();
			СП.ИсполнительПостановка = Объект.РабочееМесто.Стенд.Исполнитель;
			СП.ДатаПостановки = ТекущаяДата();
			СП.Записать();
			Иначе
			ОбщийМодульРаботаСРегистрами.ИзменитьЭтапПроизводственногоЗадания(Объект.ПроизводственноеЗадание,Новый Структура("РабочееМесто,Исполнитель,ДатаНачала",Объект.РабочееМесто,Объект.Исполнитель,ТекущаяДата())); 
			КонецЕсли;
		Возврат(1);
		КонецЦикла;
	КонецЦикла;
Возврат(0);
КонецФункции

&НаСервере
Функция ПолучитьСпецификациюЭтапов()
Возврат(ОбщийМодульАРМ.ПолучитьСпецификациюЭтапов(Объект.ПроизводственноеЗадание,Объект.РабочееМесто,Этапы,Объект.Спецификация,ТаблицаКомплектации,ТаблицаПодчиненныхДокументов)); 
КонецФункции
 
&НаСервере
Процедура ПолучитьДатуВыпускаПоМаске()
ДатаВыпуска = ДатаВыпускаТекущая;
//Наименование = СокрЛП(Объект.ПроизводственноеЗадание.Изделие.Наименование);
	//Если Найти(Наименование,"ДТС") > 0 Тогда
	//	Если Найти(Наименование,".И") > 0 Тогда
	//		Если Найти(Наименование,"5Е") > 0 Тогда
	//			Если Найти(Наименование,"ЕХI") > 0 Тогда
	//			ДатаВыпуска = Дата(2021,5,28,0,0,0);
	//		    КонецЕсли;
	//		ИначеЕсли Найти(Наименование,"5Д") > 0 Тогда
	//			Если Найти(Наименование,"ЕХD") > 0 Тогда
	//			ДатаВыпуска = Дата(2021,5,28,0,0,0);
	//		    КонецЕсли;
	//		КонецЕсли;
	//	Иначе
	//		Если Найти(Наименование,"4-") > 0 Тогда
	//			Если Найти(Наименование,"ЕХI") > 0 Тогда
	//			ДатаВыпуска = Дата(2022,6,7,0,0,0);
	//		    КонецЕсли;
	//		ИначеЕсли Найти(Наименование,"5-") > 0 Тогда
	//			Если Найти(Наименование,"ЕХI") > 0 Тогда
	//			ДатаВыпуска = Дата(2022,6,7,0,0,0);
	//		    КонецЕсли;
	//		ИначеЕсли Найти(Наименование,"5Л") > 0 Тогда
	//			Если Найти(Наименование,"ЕХI") > 0 Тогда
	//			ДатаВыпуска = Дата(2022,6,7,0,0,0);
	//		    КонецЕсли;			
	//		КонецЕсли;
	//	КонецЕсли;
	//ИначеЕсли Найти(Наименование,"ДТП") > 0 Тогда
	//	Если Найти(Наименование,".И") > 0 Тогда
	//		Если Найти(Наименование,"5Е") > 0 Тогда
	//			Если Найти(Наименование,"ЕХI") > 0 Тогда
	//			ДатаВыпуска = Дата(2021,7,14,0,0,0);
	//		    КонецЕсли;
	//		ИначеЕсли Найти(Наименование,"5Д") > 0 Тогда
	//			Если Найти(Наименование,"ЕХD") > 0 Тогда
	//			ДатаВыпуска = Дата(2021,7,14,0,0,0);
	//		    КонецЕсли;
	//		КонецЕсли;
	//	КонецЕсли;	
	//КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьЗадание(Команда)
	Если ОбщийМодульВызовСервера.ОстановкаЛинейки(СписокРабочихМест[0].Значение) Тогда
		Если ПолучитьКодРабочегоМеста() = 1 Тогда
			Если Вопрос("Линейка остановлена! Снять остановку?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
				Если Не ОбщийМодульРаботаСРегистрами.СнятьОстановкуЛинейки(ОбщийМодульВызовСервера.ПолучитьЛинейкуПоРабочемуМесту(СписокРабочихМест[0].Значение)) Тогда	
				Возврат;
				КонецЕсли;
			Иначе
			Возврат;			
			КонецЕсли;
		Иначе
		Возврат; 
		КонецЕсли;
	КонецЕсли;
Состояние("Обработка...",,"Получение задания...");
Результат = ПолучитьЗаданиеНаСервере(); 
	Если Результат = 1 Тогда
	ПолучитьСпецификациюЭтапов();
		Если ТипЗнч(ТаблицаКомплектации[0].Комплектация) = Тип("СправочникСсылка.Номенклатура") Тогда
		Элементы.ТаблицаКомплектации.ТекущаяСтрока = ТаблицаКомплектации[0].ПолучитьИдентификатор();
		ТаблицаКомплектацииВыборЗначения(Элементы.ТаблицаКомплектации,Элементы.ТаблицаКомплектации.ТекущаяСтрока,Истина);
		КонецЕсли;
			Если ИзменитьПоМаске Тогда
			ПолучитьДатуВыпускаПоМаске();
			КонецЕсли;
				Если ОбщийМодульВызовСервера.ПолучитьПрефиксРабочегоМеста(Объект.РабочееМесто) = "УП" Тогда
				ОткрытьФорму("Обработка.СозданныеБарКоды.Форма.Форма",Новый Структура("ПЗ,РабочееМесто,ДатаВыпуска,ДатаПоверки",Объект.ПроизводственноеЗадание,Объект.РабочееМесто,ДатаВыпуска,ТекущаяДата()));
				КонецЕсли;
	Элементы.Завершить.КнопкаПоУмолчанию = Истина;
	Элементы.ПолучитьЗадание.Доступность = Ложь;
	Элементы.ПростойЛинейки.Доступность = Ложь;
	Элементы.ПечатьДокументов.Доступность = Истина;
	Элементы.Завершить.Доступность = Истина;
	ИначеЕсли Результат = 0 Тогда
	Сообщить("Нет производственных заданий!");
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ОчиститьСсылкуНаПЗ()
Объект.ПроизводственноеЗадание = Документы.ПроизводственноеЗадание.ПустаяСсылка();
Этапы.Очистить();
ЭтапыАРМ.Очистить();
ТаблицаКомплектации.Очистить();
Объект.Спецификация.Очистить();
тДерево = РеквизитФормыВЗначение("ДеревоСпецификации");
тДерево.Строки.Очистить();
ЗначениеВРеквизитФормы(тДерево,"ДеревоСпецификации");
Элементы.ПолучитьЗадание.КнопкаПоУмолчанию = Истина;
Элементы.ПолучитьЗадание.Доступность = Истина;
Элементы.ПростойЛинейки.Доступность = Истина;
Элементы.ПечатьДокументов.Доступность = Ложь;
Элементы.Завершить.Доступность = Ложь;
флПечать = Ложь;
КонецПроцедуры  

&НаСервере
Функция ПолучитьКодРабочегоМеста()
Возврат(СписокРабочихМест[0].Значение.Код);
КонецФункции 

&НаСервере
Функция МожноРаботатьВАРМ()
	Если ОбщийМодульВызовСервера.МожноВыполнить(СписокРабочихМест[0].Значение.Линейка) Тогда	
	Возврат(Истина);
	Иначе
	СписокРабочихМест.Очистить();
	Сообщить("Работа АРМ запрещена в этой базе!");
	Возврат(Ложь);
	КонецЕсли;
КонецФункции 

&НаКлиенте
Процедура СписокРабочихМестПриИзменении(Элемент)
ОчиститьСсылкуНаПЗ();
	Если СписокРабочихМест.Количество() > 0 Тогда
		Если Не МожноРаботатьВАРМ() Тогда
		Возврат;
		КонецЕсли;
	Элементы.Завершить.Заголовок = "Завершить и передать на следующее АРМ"; 
	Элементы.ПечатьДокументов.Видимость = Ложь;
	Элементы.ПростойЛинейки.Видимость = ?(ПолучитьКодРабочегоМеста() = 1,Истина,Ложь);
	ПрефиксРМ = ОбщийМодульВызовСервера.ПолучитьПрефиксРабочегоМеста(СписокРабочихМест[0].Значение);
		Если ПрефиксРМ = "УП" Тогда
		Элементы.Завершить.Заголовок = "Выпустить на склад линейки";
		Элементы.ПечатьДокументов.Видимость = Истина;
		КонецЕсли;	
	КонецЕсли;    
КонецПроцедуры

&НаСервере
Функция ЗавершитьЗаданиеНаСервере()
	Попытка
	НачатьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция + 1;
	ОбщийМодульРаботаСРегистрами.ИзменитьЭтапПроизводственногоЗадания(Объект.ПроизводственноеЗадание,Новый Структура("РабочееМесто,ДатаОкончания",Объект.РабочееМесто,ТекущаяДата()));
		Если СокрЛП(Объект.РабочееМесто.ГруппаРабочихМест.Префикс) = "СТ" Тогда
		НаборЗаписей = РегистрыСведений.СтендовыйПрогон.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ПЗ.Установить(Объект.ПроизводственноеЗадание);
		НаборЗаписей.Прочитать();
		    Для Каждого Запись Из НаборЗаписей Цикл
				Если Не ЗначениеЗаполнено(Запись.ДатаСнятия) Тогда
				Запись.ИсполнительСнятие = Запись.ИсполнительПоступление;
				Запись.ДатаСнятия = ТекущаяДата();
				Прервать; 
				КонецЕсли;  
		    КонецЦикла;
		НаборЗаписей.Записать();		
		ОбщийМодульРаботаСРегистрами.СоздатьЭтапПроизводственногоЗадания(Объект.ПроизводственноеЗадание,ОбщийМодульВызовСервера.ПолучитьСледующееРабочееМесто(Объект.РабочееМесто),Неопределено,Неопределено);
		МестоПередачи = "на Упаковку";
		КонецЕсли; 
			Если Не ОбщийМодульСозданиеДокументов.СоздатьВыпускПродукции(Объект.ПроизводственноеЗадание,Объект.РабочееМесто,Объект.Спецификация,Этапы,ТекущаяДата()) Тогда
			Сообщить("Документ выпуска не создан!");
			ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
			Возврат("");
			КонецЕсли;
				Если СокрЛП(Объект.РабочееМесто.ГруппаРабочихМест.Префикс) = "УП" Тогда
				Испытания = Объект.ПроизводственноеЗадание.Испытания;
					Если Испытания = 0 Тогда
						Если Объект.ПроизводственноеЗадание.ДокументОснование.МестоХраненияПотребитель.Пустая() Тогда
						МестоПередачи = "на склад линейки";
						Иначе	
						МестоПередачи = "на склад "+СокрЛП(Объект.ПроизводственноеЗадание.ДокументОснование.МестоХраненияПотребитель.Наименование);
						КонецЕсли;					
					ИначеЕсли Испытания = 1 Тогда
					МестоПередачи = "Отложите изделие для ПСИ!";
					ИначеЕсли Испытания = 2 Тогда	
					МестоПередачи = "Отложите изделие для поверки!";
					КонецЕсли;			
				КонецЕсли;  		
	ЗафиксироватьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;Если ПараметрыСеанса.АктивнаТранзакция = 0 тогда СРМ_ОбменВебСервис.ОтправкаПослеТранзакции();КонецЕсли;
	Возврат(МестоПередачи);
	Исключение
	Сообщить(ОписаниеОшибки());
	ОтменитьТранзакцию();ПараметрыСеанса.АктивнаТранзакция = ПараметрыСеанса.АктивнаТранзакция-1;ПараметрыСеанса.ОбъектыСозданныеВТранзакции = Новый ХранилищеЗначения(Новый Массив);
	Возврат("");
	КонецПопытки;
КонецФункции

&НаСервере
Функция ПолучитьБарКод()
Возврат(Объект.ПроизводственноеЗадание.БарКод);
КонецФункции

&НаКлиенте
Процедура ЗавершитьЗадание(Команда)
	Если ОбщийМодульВызовСервера.ЛинейкаОстановлена(ОбщийМодульВызовСервера.ПолучитьЛинейкуПоРабочемуМесту(Объект.РабочееМесто)) Тогда
	Возврат;
	КонецЕсли;
МестоПередачи = ЗавершитьЗаданиеНаСервере();
	Если МестоПередачи <> "" Тогда
		Если Найти(МестоПередачи,"Отложите") > 0 Тогда
		Предупреждение(МестоПередачи,,"ВНИМАНИЕ!");
		Иначе	
		ПоказатьОповещениеПользователя("ВНИМАНИЕ!",,"Передайте изделие "+МестоПередачи,БиблиотекаКартинок.Пользователь);
		КонецЕсли; 
	ОчиститьСсылкуНаПЗ();
	КонецЕсли;  
КонецПроцедуры

&НаСервере
Функция ЭтоПереупаковка(РабочееМесто)
	Если РабочееМесто.Линейка.ВидЛинейки = Перечисления.ВидыЛинеек.Переупаковка Тогда
	Возврат(Истина);
	Иначе	
	Возврат(Ложь);
	КонецЕсли; 
КонецФункции

&НаКлиенте
Процедура РабочееМестоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ЭтоПереупаковка(ВыбранноеЗначение) Тогда
	Сообщить("Выберите рабочее место из основной или проектной линейки!");
	СтандартнаяОбработка = Ложь;
	Возврат;
	КонецЕсли; 
		Если Не Объект.ПроизводственноеЗадание.Пустая() Тогда
			Если Вопрос("Задание не завершено. Вы действительно хотите авторизоваться?",РежимДиалогаВопрос.ДаНет,,,"ВНИМАНИЕ!") = КодВозвратаДиалога.Нет Тогда
			СтандартнаяОбработка = Ложь;
			КонецЕсли; 
		КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокЭтапов()
СписокЭтапов = Новый СписокЗначений;
	Для каждого ТЧ Из ТаблицаКомплектации Цикл
		Если СписокЭтапов.НайтиПоЗначению(ТЧ.ЭтапСпецификации) = Неопределено Тогда
		СписокЭтапов.Добавить(ТЧ.ЭтапСпецификации);
		КонецЕсли; 
	КонецЦикла;
Возврат(СписокЭтапов);
КонецФункции 

&НаКлиенте
Процедура ПечатьДокументов(Команда)
	Если флПечать Тогда
		Если Вопрос("Распечатать повторно?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Возврат;
		КонецЕсли; 
	КонецЕсли;
ОткрытьФорму("Обработка.СозданныеБарКоды.Форма.Форма",Новый Структура("ПЗ,РабочееМесто,ДатаВыпуска,ДатаПоверки",Объект.ПроизводственноеЗадание,Объект.РабочееМесто,ДатаВыпуска,ТекущаяДата())); 
флПечать = Истина;
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево(Команда)
тЭлементы = ДеревоСпецификации.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл
   	Элементы.ДеревоСпецификации.Развернуть(тСтр.ПолучитьИдентификатор(), Истина);
   КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СвернутьДерево(Команда)
тЭлементы = ДеревоСпецификации.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл
   Элементы.ДеревоСпецификации.Свернуть(тСтр.ПолучитьИдентификатор());
   КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСпецификацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ТипЗнч(Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ) = Тип("СправочникСсылка.Документация") Тогда
	ОбщийМодульКлиент.ОткрытьФайлДокумента(Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКомплектацииВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
ЗаполнитьДерево(Элемент.ТекущиеДанные.ЭтапСпецификации);
РазвернутьДерево(Неопределено);
КонецПроцедуры

&НаСервере
Функция ЭтоКанбанБезРезервирования(МПЗ)
	Если Не МПЗ.Канбан.Пустая() Тогда
	 	Если Не МПЗ.Канбан.РезервироватьВПроизводстве Тогда
		Возврат(Истина);
		КонецЕсли;
	КонецЕсли; 
Возврат(Ложь);
КонецФункции 

&НаКлиенте
Процедура ОформитьПустойКанбан(Команда)
	Если Этаформа.ТекущийЭлемент = Этаформа.Элементы.ДеревоСпецификации Тогда
	МПЗ = Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ;
	Иначе
	МПЗ = Элементы.ТаблицаКомплектации.ТекущиеДанные.Комплектация;
	КонецЕсли;
		Если ТипЗнч(МПЗ) = Тип("СправочникСсылка.Номенклатура") Тогда
			Если ОбщийМодульВызовСервера.МожноОформитьПустойКанбан(МПЗ) Тогда
			П = Новый Структура("МестоХраненияКанбанов,МПЗ",ОбщийМодульВызовСервера.ПолучитьМестоХраненияПоРабочемуМесту(Объект.РабочееМесто),МПЗ);
			ОткрытьФорму("ОбщаяФорма.ОформлениеПустыхКанбанов",П,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
			КонецЕсли;
		КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЭтоКанбан(МПЗ)
Возврат(МПЗ.Канбан);
КонецФункции 

&НаКлиенте
Процедура ОформитьНедостачу(Команда)
	Если Этаформа.ТекущийЭлемент = Этаформа.Элементы.ДеревоСпецификации Тогда
	МПЗ = Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ;
	Иначе
	МПЗ = Элементы.ТаблицаКомплектации.ТекущиеДанные.Комплектация;
	КонецЕсли;
		Если ТипЗнч(МПЗ) = Тип("СправочникСсылка.Номенклатура") Тогда
			Если ЭтоКанбан(МПЗ).Пустая() Тогда	
			Сообщить("Выберите МПЗ ячейки канбана!");
			Возврат;
			КонецЕсли;
		ИначеЕсли ТипЗнч(МПЗ) <> Тип("СправочникСсылка.Материалы")Тогда	
		Сообщить("Выберите МПЗ ячейки канбана!");
		Возврат;
		КонецЕсли; 
П = Новый Структура("ВидОперации,МестоХраненияКанбанов,ПЗ,МПЗ",1,ОбщийМодульВызовСервера.ПолучитьМестоХраненияПоРабочемуМесту(Объект.РабочееМесто),Объект.ПроизводственноеЗадание,МПЗ);
	Если ОткрытьФормуМодально("ОбщаяФорма.ОформлениеНедостачиИзлишков",П) Тогда
		Если ОбщийМодульВызовСервера.МТКОстановлена(Объект.ПроизводственноеЗадание) Тогда
		ОчиститьСсылкуНаПЗ();
		ПоказатьОповещениеПользователя("ВНИМАНИЕ!",,"МТК остановлена по причине недостачи комплектации. Отложите изготавливаемый полуфабрикат!",БиблиотекаКартинок.Пользователь);
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ОформитьИзлишки(Команда)
	Если Этаформа.ТекущийЭлемент = Этаформа.Элементы.ДеревоСпецификации Тогда
	МПЗ = Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ;
	Иначе
	МПЗ = Элементы.ТаблицаКомплектации.ТекущиеДанные.Комплектация;
	КонецЕсли;
		Если ТипЗнч(МПЗ) = Тип("СправочникСсылка.Номенклатура") Тогда
			Если ЭтоКанбан(МПЗ).Пустая() Тогда	
			Сообщить("Выберите МПЗ ячейки канбана!");
			Возврат;
			КонецЕсли;
		ИначеЕсли ТипЗнч(МПЗ) <> Тип("СправочникСсылка.Материалы")Тогда	
		Сообщить("Выберите МПЗ ячейки канбана!");
		Возврат;
		КонецЕсли; 
П = Новый Структура("ВидОперации,МестоХраненияКанбанов,ПЗ,МПЗ",2,ОбщийМодульВызовСервера.ПолучитьМестоХраненияПоРабочемуМесту(Объект.РабочееМесто),Объект.ПроизводственноеЗадание,МПЗ);
ОткрытьФорму("ОбщаяФорма.ОформлениеНедостачиИзлишков",П,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ОформитьБрак(Команда)
	Если Этаформа.ТекущийЭлемент = Этаформа.Элементы.ДеревоСпецификации Тогда
	МПЗ = Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ;
	Количество = Элементы.ДеревоСпецификации.ТекущиеДанные.Количество;
	Иначе
	МПЗ = Элементы.ТаблицаКомплектации.ТекущиеДанные.Комплектация;
	Количество = Элементы.ТаблицаКомплектации.ТекущиеДанные.Количество;
	КонецЕсли;
		Если ОбщийМодульВызовСервера.МожноПеремещатьВБрак(МПЗ) Тогда
		П = Новый Структура("РабочееМесто,ПЗ,ЭтапСпецификации,МПЗ,Количество",Объект.РабочееМесто,Объект.ПроизводственноеЗадание,Элементы.ТаблицаКомплектации.ТекущиеДанные.ЭтапСпецификации,МПЗ,Количество);
		ОткрытьФорму("ОбщаяФорма.ОформлениеБракаНовый",П,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
		Иначе
		Сообщить("Выбранную МПЗ запрещено перемещать в брак!");
		КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ОстановкаЛинейкиНаСервере(МПЗ)
ОбщийМодульРаботаСРегистрами.ОстановитьЛинейку(Объект.РабочееМесто.Линейка,МПЗ);
КонецФункции

&НаКлиенте
Процедура ОстановкаЛинейки(Команда)
	Если Этаформа.ТекущийЭлемент = Этаформа.Элементы.ДеревоСпецификации Тогда
	МПЗ = Элементы.ДеревоСпецификации.ТекущиеДанные.МПЗ;
	Иначе
	МПЗ = Элементы.ТаблицаКомплектации.ТекущиеДанные.Комплектация;
	КонецЕсли;
		Если ТипЗнч(МПЗ) = Тип("СправочникСсылка.Номенклатура") Тогда
			Если ЭтоКанбанБезРезервирования(МПЗ) Тогда
				Если Вопрос("Вы уверены, что хотите остановить линейку?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
				ОстановкаЛинейкиНаСервере(МПЗ);
				КонецЕсли;
			Иначе
			Сообщить("Выберите МПЗ ячейки канбана без резервирования!");
			КонецЕсли;
		Иначе	
		Сообщить("Выберите МПЗ ячейки канбана без резервирования!");
		КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПолучитьВидРемонтаРазукомплектовка()
Возврат(Перечисления.ВидыРемонта.Разукомплектовка);
КонецФункции

&НаСервере
Функция ПолучитьИзделиеРемонта()
	Для каждого ТЧ_Этап Из Этапы Цикл
	ЭтапАРМ = Объект.РабочееМесто.ТабличнаяЧасть.Найти(ТЧ_Этап.ГруппаНоменклатуры,"ГруппаНоменклатуры");
		Если ЭтапАРМ = Неопределено Тогда
		Продолжить;
		ИначеЕсли ЭтапАРМ.Комплектация Тогда
	    Продолжить;
		КонецЕсли;
			Если ТЧ_Этап.ЭтапСпецификации.Виртуальный Тогда
			Продолжить;
			КонецЕсли;
	Возврат(Новый Структура("Изделие,Количество",ТЧ_Этап.ЭтапСпецификации,ТЧ_Этап.Количество));
	КонецЦикла;
КонецФункции 

&НаКлиенте
Процедура Разукомплектовка(Команда)
	Если Объект.ПроизводственноеЗадание.Пустая() Тогда
	Возврат;
	КонецЕсли;
Результат = ОткрытьФормуМодально("ОбщаяФорма.ВыборПричинРемонта",Новый Структура("РабочееМесто",Объект.РабочееМесто));
	Если Результат <> Неопределено Тогда
	НомерБирки = "";
		Если ВвестиСтроку(НомерБирки,"Введите номер бирки",4) Тогда
			Если ОбщийМодульСозданиеДокументов.СоздатьРемонтнуюКарту(Объект.ПроизводственноеЗадание,Объект.РабочееМесто,ПолучитьИзделиеРемонта(),Объект.Исполнитель,ПолучитьВидРемонтаРазукомплектовка(),Результат,,НомерБирки) Тогда
			ОчиститьСсылкуНаПЗ();
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПростойЛинейки(Команда)
Линейка = ОбщийМодульВызовСервера.ПолучитьЛинейкуПоРабочемуМесту(СписокРабочихМест[0].Значение);
	Если Не ОбщийМодульВызовСервера.ЛинейкаОстановлена(Линейка) Тогда
	ОткрытьФормуМодально("ОбщаяФорма.ОформлениеПростояЛинейки",Новый Структура("Линейка",Линейка));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьМестоХранения(Линейка)
Возврат(Линейка.МестоХраненияКанбанов);
КонецФункции 

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если ЭтаФорма.ВводДоступен() Тогда
	Массив = ОбщийМодульВызовСервера.РазложитьСтрокуВМассив(Данные,";");
		Если Массив[0] = "3" Тогда
		ЗначениеПараметра1 = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[1]);
			Если ЗначениеПараметра1 = Неопределено Тогда
			Сообщить("Линейка или место хранения не найдена!");
			Возврат;	
			КонецЕсли; 
		МПЗ = ОбщийМодульВызовСервера.ПолучитьЗначениеИзСтрокиВнутр(Массив[3]);
			Если МПЗ = Неопределено Тогда
			Сообщить(Массив[3]+" - МПЗ не найдена!");
			Возврат;	
			КонецЕсли;
				Если ТипЗнч(ЗначениеПараметра1) = Тип("СправочникСсылка.Линейки") Тогда
				МестоХранения = ПолучитьМестоХранения(ЗначениеПараметра1);
				Иначе
				МестоХранения = ЗначениеПараметра1;			
				КонецЕсли;
		МестоХраненияОтправитель = ОбщийМодульВызовСервера.ПолучитьМестоХраненияПоКоду(Массив[2]);
		П = Новый Структура("МестоХраненияОтправитель,МестоХраненияКанбанов,МПЗ,НомерЯчейки,Сотрудник",МестоХраненияОтправитель,МестоХранения,МПЗ,Массив[5],Объект.Исполнитель);
		ОткрытьФорму("ОбщаяФорма.ОформлениеПустыхКанбанов",П,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
