
&НаСервере
Функция ПолучитьСпецификацию(Наименование)
Возврат(Справочники.Номенклатура.НайтиПоНаименованию(Наименование,Истина));
КонецФункции

&НаКлиенте
Процедура Соединиться(Команда)
ТаблицаМТК.Очистить();
НастройкиОбменаДанными = ОбщийМодульСинхронизации.ПолучитьНастройкиОбменаДанными(Объект.ОбменДанными);
V7 = ОбщийМодульКлиент.ПодключитьсяК1С77(НастройкиОбменаДанными.ПутьКБазеДанных,Объект.ИмяПользователя,Объект.Пароль);
	Если V7 = Неопределено Тогда
	Возврат;	
	КонецЕсли;
Подразд = V7.CreateObject("Справочник.Подразделения");
Док = V7.CreateObject("Документ.Заказ");
Запрос = V7.CreateObject("Запрос");
	
ПериодЗапроса = "Период с '"+ Формат(Объект.Период.ДатаНачала,"ДФ=dd.MM.yy")+"' по '"+Формат(Объект.Период.ДатаОкончания,"ДФ=dd.MM.yy")+"';";
	Текст = "//{{ЗАПРОС(Заказ)
	|" + ПериодЗапроса + "
	|
	|ОбрабатыватьДокументы Непроведенные;
	|Обрабатывать НеПомеченныеНаУдаление;
	|	
	|Док 			= Документ.МаршрутнаяКарта.ТекущийДокумент;
	|
	|Группировка Док;                                                                     
	|";
Запрос.Выполнить(Текст);
		Пока Запрос.Группировка(1) = 1 Цикл
			Если Запрос.Док.ДокументОснование.Вид() <> "ПланВыпуска" Тогда
			Продолжить;
			КонецЕсли;
				Если Найти(Запрос.Док.ДокументОснование.Комментарий,"УД КАНБАН") > 0 Тогда
				Продолжить;
				КонецЕсли;
					Если СокрЛП(Запрос.Док.Спецификация.ЛинейкаПроизводства.НаименованиеНовое) <> СокрЛП(Линейка) Тогда
					Продолжить;
		            КонецЕсли;  
		Состояние("Обработка...",,"Поиск МТК "+Запрос.Док.НомерДок+"...");
		ТЧ = ТаблицаМТК.Добавить();
		ТЧ.НомерМТК = Запрос.Док.НомерДок;
		ТЧ.ДатаМТК = Запрос.Док.ДатаДок;
		ТЧ.Счёт = Запрос.Док.Счёт;
		ТЧ.ДатаОтгрузки = Запрос.Док.ДатаОтгрузки;
		ТЧ.Комментарий = Запрос.Док.Комментарий;
		ТЧ.Изделие = СокрЛП(Запрос.Док.Спецификация.Наименование);
		ТЧ.Спецификация = ПолучитьСпецификацию(ТЧ.Изделие);
		ТЧ.Пометка = ЗначениеЗаполнено(ТЧ.Спецификация); 
		ТЧ.Количество = Запрос.Док.Количество; 
	    КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СоздатьМТКНаСервере(Стр)
СтдКомм = Справочники.СтандартныеКомментарии.НайтиПоНаименованию("Заказанные датчики от клиентов",Истина);
ТЧ = ТаблицаМТК.НайтиПоИдентификатору(Стр);
МТК = ОбщийМодульСозданиеДокументов.СоздатьМТК(ТЧ.Спецификация.Линейка,ТЧ.Спецификация,ТЧ.Количество,СтдКомм,Справочники.Проекты.ПустаяСсылка(),Ложь,Истина,"",ТЧ.Счёт,ТЧ.ДатаОтгрузки);
ТЧ.Ссылка = МТК;	
КонецПроцедуры

&НаСервере
Функция ПолучитьНомерМТК(МТК)
Возврат("МТК изделия по 1С8: "+МТК.Номер + " от " + МТК.Дата);
КонецФункции

&НаСервере
Процедура СформироватьОтчет(СписокПодчиненных)
ТабДок.Очистить();
ОбъектЗн = РеквизитФормыВЗначение("Объект");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблСтрока = Макет.ПолучитьОбласть("Строка");
	Для каждого Стр Из СписокПодчиненных Цикл
	ОблСтрока.Параметры.МТКПодчиненная = Стр.Значение;
	ОблСтрока.Параметры.МТК = Стр.Представление;
	ТабДок.Вывести(ОблСтрока);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Перенести(Команда)
НастройкиОбменаДанными = ОбщийМодульСинхронизации.ПолучитьНастройкиОбменаДанными(Объект.ОбменДанными);
V7 = ОбщийМодульКлиент.ПодключитьсяК1С77(НастройкиОбменаДанными.ПутьКБазеДанных,Объект.ИмяПользователя,Объект.Пароль);
	Если V7 = Неопределено Тогда
	Возврат;	
	КонецЕсли;
СписокПодчиненных = Новый СписокЗначений;

Док = V7.CreateObject("Документ.МаршрутнаяКарта");
ДокЗаказ = V7.CreateObject("Документ.План");
ДокПередача = V7.CreateObject("Документ.ТребованиеНакладная");
ДокВыпуск = V7.CreateObject("Документ.ВыпускПродукцииПоНормам");
ДокТехОперации = V7.CreateObject("Документ.ТехОперации");
ПодчДок = V7.CreateObject("Документ");
	Для каждого ТЧ Из ТаблицаМТК Цикл
		Если ТЧ.Пометка Тогда
		Состояние("Обработка...",,"Обработка МТК "+ТЧ.НомерМТК+"...");
		СоздатьМТКНаСервере(ТЧ.ПолучитьИдентификатор());
			Если ЗначениеЗаполнено(ТЧ.Ссылка) Тогда
				Если Док.НайтиПоНомеру(СокрЛП(ТЧ.НомерМТК),ТЧ.ДатаМТК) = 1 Тогда
				Док.Удалить(0);
				Док.ВыбратьСтроки();
					Пока Док.ПолучитьСтроку() = 1 Цикл
						Если V7.ПустоеЗначение(Док.ДокЗаказ) = 0 Тогда
						ДокЗаказ.НайтиДокумент(Док.ДокЗаказ);
						ДокЗаказ.Удалить(0);
						КонецЕсли; 
							Если V7.ПустоеЗначение(Док.ДокПередача) = 0 Тогда
							ДокПередача.НайтиДокумент(Док.ДокПередача);
							ДокПередача.Удалить(0);
							КонецЕсли; 
								Если V7.ПустоеЗначение(Док.ДокВыпуск) = 0 Тогда
								ДокВыпуск.НайтиДокумент(Док.ДокВыпуск);
								ДокВыпуск.Удалить(0);
								КонецЕсли;
					КонецЦикла;  
					Если ПодчДок.ВыбратьПодчиненныеДокументы(НачалоГода(ТекущаяДата()),ТекущаяДата(),Док.ТекущийДокумент()) = 1 Тогда
						Пока ПодчДок.ПолучитьДокумент() = 1 Цикл
							Если ПодчДок.ПометкаУдаления() = 1 Тогда
							Продолжить;	
							КонецЕсли;
								Если ПодчДок.Вид() = "МаршрутнаяКарта" Тогда
								СписокПодчиненных.Добавить(ПодчДок.НомерДок,ПолучитьНомерМТК(ТЧ.Ссылка));
								Проведен = ПодчДок.Проведен();
								ПодчДок.ДокументОснование = "";
								ПодчДок.Комментарий = ПолучитьНомерМТК(ТЧ.Ссылка);
								ПодчДок.Записать();
									Если Проведен Тогда
									ПодчДок.Провести();								
									КонецЕсли;
								ИначеЕсли ПодчДок.Вид() = "ТехОперации" Тогда
								ПодчДок.Удалить(0);
								КонецЕсли;
						КонецЦикла;					
					КонецЕсли;
				КонецЕсли;	
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
СформироватьОтчет(СписокПодчиненных); 
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	Для каждого ТЧ Из ТаблицаМТК Цикл	
	ТЧ.Пометка = Истина;
	КонецЦикла; 	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе(Команда)
	Для каждого ТЧ Из ТаблицаМТК Цикл	
	ТЧ.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры
