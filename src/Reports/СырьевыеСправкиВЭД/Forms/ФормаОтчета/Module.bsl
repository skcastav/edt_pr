
&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
Диалог.Заголовок = "Выберите файл с данными";  
Диалог.Фильтр = "Книга Excel(*.xlsx)|*.xlsx|Excel(*.xls)|*.xls"; 
Диалог.МножественныйВыбор = Ложь;
Диалог.ПолноеИмяФайла = ПутьКФайлу;
	Если Диалог.Выбрать() Тогда
	ПутьКФайлу = Диалог.ПолноеИмяФайла; 
	КонецЕсли;
КонецПроцедуры
   
&НаСервере      
Функция ПолучитьТовар()
Возврат(СокрЛП(Спецификация.Товар.Наименование));
КонецФункции

&НаКлиенте
Процедура СпецификацияПриИзменении(Элемент)
ПолноеНаименование = "";
Описание = "";
ТНВЭД = "";
	Если ЗначениеЗаполнено(ПутьКФайлу) Тогда
	Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл с данными по товарам",ПутьКФайлу);
		Если Результат <> Неопределено Тогда
		Состояние("Обработка...",,"Поиск данных по товару...");
		ExcelЛист = Результат.ExcelЛист;
		КолСтрок = Результат.КоличествоСтрок;
		    Для к = 2 по КолСтрок Цикл
				Если СокрЛП(ExcelЛист.Cells(к,1).Value) = ПолучитьТовар() Тогда
				ПолноеНаименование = СокрЛП(ExcelЛист.Cells(к,2).Value);
				Описание = СокрЛП(ExcelЛист.Cells(к,3).Value);
				ТНВЭД = СокрЛП(ExcelЛист.Cells(к,4).Value);				
				Прервать;								
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьПоследнееПоступление(МПЗ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПоступлениеМПЗТабличнаяЧасть.Ссылка.Договор КАК Договор,
	|	ПоступлениеМПЗТабличнаяЧасть.Цена КАК Цена,
	|	ПоступлениеМПЗТабличнаяЧасть.ГТД.Страна КАК ГТДСтрана,
	|	ПоступлениеМПЗТабличнаяЧасть.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|ИЗ
	|	Документ.ПоступлениеМПЗ.ТабличнаяЧасть КАК ПоступлениеМПЗТабличнаяЧасть
	|ГДЕ
	|	ПоступлениеМПЗТабличнаяЧасть.Ссылка.Дата <= &ДатаКон
	|	И ПоступлениеМПЗТабличнаяЧасть.МПЗ = &МПЗ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПоступлениеМПЗТабличнаяЧасть.Ссылка.Дата УБЫВ";
Запрос.УстановитьПараметр("ДатаКон", КонецДня(НаДату));	
Запрос.УстановитьПараметр("МПЗ", МПЗ);	
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат(ВыборкаДетальныеЗаписи);
	КонецЦикла;
Возврат(Неопределено);
КонецФункции

&НаСервере
Процедура РаскрытьНаМПЗ(ТаблицаМПЗ,ЭтапСпецификации,КолУзла)
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_М(ЭтапСпецификации,НаДату);
	Пока ВыборкаНР.Следующий() Цикл
		Если ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Материалы") Тогда   
		МПЗ = ВыборкаНР.Элемент;
		Цена = ОбщийМодульВызовСервера.ПолучитьПоследнююЦену(МПЗ,КонецДня(НаДату));
			Если Цена > 0 Тогда
			Выборка = ТаблицаМПЗ.НайтиСтроки(Новый Структура("МПЗ",МПЗ));
				Если Выборка.Количество() = 0 Тогда
				ТЧ = ТаблицаМПЗ.Добавить();
				ТЧ.МПЗ = МПЗ;
				ТЧ.Количество = ПолучитьБазовоеКоличествоБезОкругления(ВыборкаНР.Норма,МПЗ.ОсновнаяЕдиницаИзмерения)*КолУзла;
				ТЧ.Цена = Цена;
				Результат = ПолучитьПоследнееПоступление(МПЗ);
					Если Результат <> Неопределено Тогда
					ТЧ.Контрагент = Результат.Договор.Владелец.Наименование;
						Если ЗначениеЗаполнено(Результат.ГТДСтрана) Тогда						
						ТЧ.Комплектующие = 1;
						ТЧ.Страна = Результат.ГТДСтрана.Наименование;
						Иначе
						ТЧ.Комплектующие = 0;
						ТЧ.Страна = "Россия";	
						КонецЕсли;
					Иначе
					ТЧ.Комплектующие = 1;
					ТЧ.Страна = "нет данных";										
					КонецЕсли;
				Иначе
				Выборка[0].Количество = Выборка[0].Количество + ПолучитьБазовоеКоличествоБезОкругления(ВыборкаНР.Норма,МПЗ.ОсновнаяЕдиницаИзмерения)*КолУзла;
				КонецЕсли; 
			Иначе 
			флНайден = Ложь;
			ТаблицаАналогов = ОбщегоНазначенияПовтИсп.ПолучитьАналогиНормРасходов(ВыборкаНР.Ссылка,ТекущаяДата(),Истина);
				Для каждого ТЧ_ТА Из ТаблицаАналогов Цикл
				АналогМПЗ = ТЧ_ТА.Элемент;
				Цена = ОбщийМодульВызовСервера.ПолучитьПоследнююЦену(АналогМПЗ,КонецДня(НаДату));
					Если Цена > 0 Тогда
					флНайден = Истина;
					Выборка = ТаблицаМПЗ.НайтиСтроки(Новый Структура("МПЗ",АналогМПЗ));
						Если Выборка.Количество() = 0 Тогда
						ТЧ = ТаблицаМПЗ.Добавить();
						ТЧ.МПЗ = АналогМПЗ;
						ТЧ.Количество = ПолучитьБазовоеКоличествоБезОкругления(ТЧ_ТА.Норма,АналогМПЗ.ОсновнаяЕдиницаИзмерения)*КолУзла;
						ТЧ.Цена = Цена;
						Результат = ПолучитьПоследнееПоступление(АналогМПЗ);
							Если Результат <> Неопределено Тогда
							ТЧ.Контрагент = Результат.Договор.Владелец;
							ТЧ.Страна = Результат.ГТДСтрана;
								Если ЗначениеЗаполнено(Результат.ГТДСтрана) Тогда						
								ТЧ.Комплектующие = 1;
								Иначе
								ТЧ.Страна = "Россия";
								ТЧ.Комплектующие = 0;	
								КонецЕсли;	
							Иначе
							ТЧ.Комплектующие = 1;
							ТЧ.Страна = "нет данных";				
							КонецЕсли;
						Иначе
						Выборка[0].Количество = Выборка[0].Количество + ПолучитьБазовоеКоличествоБезОкругления(ТЧ_ТА.Норма,АналогМПЗ.ОсновнаяЕдиницаИзмерения)*КолУзла;
						КонецЕсли;
					Прервать; 
					КонецЕсли;
						Если Не флНайден Тогда
						Выборка = ТаблицаМПЗ.НайтиСтроки(Новый Структура("МПЗ",МПЗ));
							Если Выборка.Количество() = 0 Тогда
							ТЧ = ТаблицаМПЗ.Добавить();
							ТЧ.МПЗ = МПЗ;
							ТЧ.Количество = ПолучитьБазовоеКоличествоБезОкругления(ВыборкаНР.Норма,МПЗ.ОсновнаяЕдиницаИзмерения)*КолУзла;
							ТЧ.Цена = 0;
							Результат = ПолучитьПоследнееПоступление(МПЗ);
								Если Результат <> Неопределено Тогда
								ТЧ.Контрагент = Результат.Договор.Владелец.Наименование;
									Если ЗначениеЗаполнено(Результат.ГТДСтрана) Тогда						
									ТЧ.Комплектующие = 1;
									ТЧ.Страна = Результат.ГТДСтрана.Наименование;
									Иначе
									ТЧ.Комплектующие = 0;
									ТЧ.Страна = "Россия";	
									КонецЕсли;
								Иначе
								ТЧ.Комплектующие = 1;
								ТЧ.Страна = "нет данных";										
								КонецЕсли;
							Иначе
							Выборка[0].Количество = Выборка[0].Количество + ПолучитьБазовоеКоличествоБезОкругления(ВыборкаНР.Норма,МПЗ.ОсновнаяЕдиницаИзмерения)*КолУзла;
							КонецЕсли;
						КонецЕсли;
				КонецЦикла; 					
			КонецЕсли;
		Иначе 
			Если СписокВидовКанбанов.Количество() > 0 Тогда	
				Если Не ВыборкаНР.Элемент.Канбан.Пустая() Тогда
					Если СписокВидовКанбанов.НайтиПоЗначению(ВыборкаНР.Элемент.Канбан) <> Неопределено Тогда	
					ТЧ = ТаблицаМПЗ.Добавить();
					ТЧ.Страна = "Россия";
					ТЧ.МПЗ = ВыборкаНР.Элемент;
					ТЧ.Количество = ПолучитьБазовоеКоличествоБезОкругления(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла;					
					ТЧ.Цена = ОбщийМодульВызовСервера.ПолучитьПоследнююЦену(ВыборкаНР.Элемент,КонецДня(НаДату)); 
					ТЧ.Комплектующие = 0;
                    Продолжить;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
	 	РаскрытьНаМПЗ(ТаблицаМПЗ,ВыборкаНР.Элемент,ПолучитьБазовоеКоличествоБезОкругления(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();
              
Запрос = Новый Запрос;
ТаблицаМПЗ = Новый ТаблицаЗначений;

ТаблицаМПЗ.Колонки.Добавить("МПЗ");
ТаблицаМПЗ.Индексы.Добавить("МПЗ");
ТаблицаМПЗ.Колонки.Добавить("Контрагент");
ТаблицаМПЗ.Колонки.Добавить("Страна");
ТаблицаМПЗ.Колонки.Добавить("Количество");
ТаблицаМПЗ.Колонки.Добавить("Цена");
ТаблицаМПЗ.Колонки.Добавить("Комплектующие");

РаскрытьНаМПЗ(ТаблицаМПЗ,Спецификация,1);
ТаблицаМПЗ.Сортировать("Комплектующие,МПЗ");

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");
                    
ОблОписание = Макет.ПолучитьОбласть("Описание");
ОблТО = Макет.ПолучитьОбласть("ТО");
ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблКомплектующие = Макет.ПолучитьОбласть("Комплектующие");    
ОблМПЗ = Макет.ПолучитьОбласть("МПЗ");
ОблКонец = Макет.ПолучитьОбласть("Конец");
ОблКонецИмпорт = Макет.ПолучитьОбласть("КонецИмпорт");
ОблПодвал = Макет.ПолучитьОбласть("Подвал");
            
ОблОписание.Параметры.Товар = СокрЛП(ПолноеНаименование);
ОблОписание.Параметры.Описание = СокрЛП(Описание);
ТабДок.Вывести(ОблОписание);
	Если СокрЛП(Спецификация.Линейка.Подразделение.Наименование) = "Богородицк УПЭА" Тогда
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НормыВремениСрезПоследних.ТехОперация.Наименование КАК ТехОперацияНаименование
		|ИЗ
		|	РегистрСведений.НормыВремени.СрезПоследних(&НаДату, ) КАК НормыВремениСрезПоследних
		|ГДЕ
		|	НормыВремениСрезПоследних.МПЗ = &МПЗ
		|	И НормыВремениСрезПоследних.НормаВремени > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	НормыВремениСрезПоследних.ТехОперация.Код";
	Запрос.УстановитьПараметр("НаДату", НаДату);
	Запрос.УстановитьПараметр("МПЗ", Спецификация);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОблТО.Параметры.ТО = СокрЛП(ВыборкаДетальныеЗаписи.ТехОперацияНаименование);
		ТабДок.Вывести(ОблТО);		
		КонецЦикла;
	Иначе
	ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_ТО(Спецификация,НаДату);
		Пока ВыборкаНР.Следующий() Цикл
		ОблТО.Параметры.ТО = СокрЛП(ВыборкаНР.ЭлементНаименование);
		ТабДок.Вывести(ОблТО);
		КонецЦикла;	
	КонецЕсли;
ТабДок.Вывести(ОблШапка);
СуммаИтого = 0;
Комплектующие = Неопределено;
	Для каждого ТЧ Из ТаблицаМПЗ Цикл
		Если Комплектующие <> ТЧ.Комплектующие Тогда
		ОблКомплектующие.Параметры.Комплектующие = ?(ТЧ.Комплектующие = 0,"Российские комплектующие","Импортные комплектующие");	
		ТабДок.Вывести(ОблКомплектующие);
		Комплектующие = ТЧ.Комплектующие;
		СуммаИтого = 0;
		КонецЕсли;
	ОблМПЗ.Параметры.Наименование = СокрЛП(ТЧ.МПЗ.Родитель.Наименование)+" "+СокрЛП(ТЧ.МПЗ.Наименование);
	ОблМПЗ.Параметры.Контрагент = СокрЛП(ТЧ.Контрагент)+", "+СокрЛП(ТЧ.Страна);	
	ОблМПЗ.Параметры.МПЗ = ТЧ.МПЗ;	     
	ОблМПЗ.Параметры.Количество = ТЧ.Количество;
		Если Комплектующие = 1 Тогда
		ОблМПЗ.Параметры.Цена = ТЧ.Цена; 
		Сумма = ОблМПЗ.Параметры.Цена*ТЧ.Количество;
		ОблМПЗ.Параметры.Сумма = Сумма;
		СуммаИтого = СуммаИтого + Сумма;
		КонецЕсли;
	ТабДок.Вывести(ОблМПЗ);		
	КонецЦикла;
		Если Комплектующие = 0 Тогда
		ТабДок.Вывести(ОблКонец);	
		Иначе	
		ОблКонецИмпорт.Параметры.Сумма = СуммаИтого;
		ТабДок.Вывести(ОблКонецИмпорт);	
		КонецЕсли;  
ОблПодвал.Параметры.Товар = СокрЛП(ПолноеНаименование);
ОблПодвал.Параметры.ТоварКратко = СокрЛП(Спецификация.Товар.Наименование); 
ОблПодвал.Параметры.Код = СокрЛП(ТНВЭД);
ТабДок.Вывести(ОблПодвал); 
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
СформироватьНаСервере();
КонецПроцедуры
 
