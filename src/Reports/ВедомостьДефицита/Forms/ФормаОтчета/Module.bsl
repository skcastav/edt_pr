
&НаСервере
Перем оптЗапросНорм, оптСоотРезультатов, оптЗапросАналогов, оптСоотРезультатовАналогов;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Отчет.НаДату = ТекущаяДата();
ПериодПП.ДатаНачала = НачалоМесяца(ТекущаяДата());
ПериодПП.ДатаОкончания = КонецМесяца(ТекущаяДата());
РаскрытьНа = 1;
	Если Параметры.Свойство("Номенклатура") Тогда
	ТЧ = Отчет.Номенклатура.Добавить();
	ТЧ.Номенклатура = Параметры.Номенклатура;
	ТЧ.Количество = Параметры.Количество;
	ТЧ.РК = ПолучитьРК(Параметры.Номенклатура);
	КонецЕсли;  
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
ВидПППриИзменении(Неопределено);
РаскрытьНаПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура РаскрытьНаПриИзменении(Элемент)
Элементы.НеРаскрыватьУзлыИДетали.Видимость = ?(РаскрытьНа = 1,Истина,Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ВидПППриИзменении(Элемент)
	Если ВидПП < 3 Тогда
	Элементы.Группа6.Видимость = Истина;
	Элементы.Группа7.Видимость = Истина;
	Элементы.СреднемесячнаяПотребность.Видимость = Истина;		
	Иначе
	Элементы.Группа6.Видимость = Ложь;
	Элементы.Группа7.Видимость = Ложь;
	Элементы.СреднемесячнаяПотребность.Видимость = Ложь;	
	КонецЕсли;
		Если ВидПП = 1 Тогда
		Элементы.СписокПроектов.Видимость = Ложь;
		Иначе
		Элементы.СписокПроектов.Видимость = Истина;	
		КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПринадлежитСпискуГруппНоменклатуры(ПФ)
	Для каждого ГруппаНомен Из ИсключитьСписокГруппНоменклатуры Цикл
		Если ПФ.ПринадлежитЭлементу(ГруппаНомен.Значение) Тогда
		Возврат(Истина);
		КонецЕсли; 
	КонецЦикла; 
Возврат(Ложь);
КонецФункции 
                  
&НаСервере                                 
Функция ПолучитьПФРедизайна(ЭлементЗамены,ПроектРедизайна)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Редизайн.ЭлементНовый КАК ЭлементНовый
	|ИЗ
	|	РегистрСведений.Редизайн КАК Редизайн
	|ГДЕ
	|	Редизайн.Проект = &Проект
	|	И Редизайн.ЭлементЗамены = &ЭлементЗамены";
Запрос.УстановитьПараметр("Проект", ПроектРедизайна);
Запрос.УстановитьПараметр("ЭлементЗамены", ЭлементЗамены);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Возврат(ВыборкаДетальныеЗаписи.ЭлементНовый);
	КонецЦикла;
Возврат(ЭлементЗамены);
КонецФункции
              
&НаСервере       
Процедура ПолучитьАналогиНабора(ЭтапСпецификации,КолУзла,СписокАналогов)
ВыборкаДетальныеЗаписи = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_М(ЭтапСпецификации,Отчет.НаДату);
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	СписокАналогов.Добавить(ВыборкаДетальныеЗаписи.Элемент,Строка(ОбщегоНазначенияПовтИсп.ПолучитьБазовоеКоличествоБезОкругленияПИ(ВыборкаДетальныеЗаписи.Норма,ВыборкаДетальныеЗаписи.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла));
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура РаскрытьНаМПЗ(ТаблицаМПЗ,ТаблицаАналогов,ЭтапСпецификации,КолУзла,ПроектРедизайна = Неопределено)
	Если оптЗапросНорм = Неопределено Тогда 
	оптЗапросНорм = ОбщийМодульВызовСервера.ПолучитьЗапросНормРасходовПоВладельцу_Н_М(Отчет.НаДату,СписокГруппМПЗ);
	КонецЕсли;
		Если оптСоотРезультатов = Неопределено Тогда
		оптСоотРезультатов = Новый Соответствие;
		КонецЕсли;
			Если оптСоотРезультатов.Получить(ЭтапСпецификации) = Неопределено Тогда 
			Запрос = оптЗапросНорм;
			Запрос.УстановитьПараметр("Владелец", ЭтапСпецификации);
			РезультатЗапроса = Запрос.Выполнить();
			оптСоотРезультатов.Вставить(ЭтапСпецификации, РезультатЗапроса);
			Иначе
			РезультатЗапроса = оптСоотРезультатов[ЭтапСпецификации];
			КонецЕсли;
ВыборкаНР = РезультатЗапроса.Выбрать();
	Пока ВыборкаНР.Следующий() Цикл
		Если ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Материалы") Тогда
			Если РаскрытьНа = 1 Тогда 
			ТЧ = ТаблицаМПЗ.Добавить();
			ТЧ.ГруппаМПЗ = ПолучитьВерхнегоРодителя(ВыборкаНР.Элемент);
			ТЧ.МПЗ = ВыборкаНР.Элемент;
			ТЧ.Количество = ПолучитьБазовоеКоличествоБезОкругления(ВыборкаНР.Норма,ВыборкаНР.ЭлементОЕИ)*КолУзла;
				Если оптЗапросАналогов = Неопределено Тогда
				оптЗапросАналогов = Новый Запрос;

				оптЗапросАналогов.Текст = 
					"ВЫБРАТЬ
					|	АналогиНормРасходовСрезПоследних.АналогНормыРасходов.ВидЭлемента КАК ВидЭлемента,
					|	АналогиНормРасходовСрезПоследних.АналогНормыРасходов.Элемент КАК Элемент,
					|	АналогиНормРасходовСрезПоследних.АналогНормыРасходов.Элемент.ОсновнаяЕдиницаИзмерения КАК ЭлементОЕИ,
					|	АналогиНормРасходовСрезПоследних.Норма КАК Норма
					|ИЗ
					|	РегистрСведений.АналогиНормРасходов.СрезПоследних(&НаДату, Владелец = &Владелец) КАК АналогиНормРасходовСрезПоследних
					|ГДЕ
					|	АналогиНормРасходовСрезПоследних.Норма > 0
					|	И АналогиНормРасходовСрезПоследних.АналогНормыРасходов.ПометкаУдаления = ЛОЖЬ";	
				оптЗапросАналогов.УстановитьПараметр("НаДату", Отчет.НаДату);
				КонецЕсли;
					Если оптСоотРезультатовАналогов = Неопределено Тогда
					оптСоотРезультатовАналогов = Новый Соответствие;
					КонецЕсли;
						Если оптСоотРезультатовАналогов.Получить(ВыборкаНР.Ссылка) = Неопределено Тогда 
						ЗапросАналога = оптЗапросАналогов;
						ЗапросАналога.УстановитьПараметр("Владелец", ВыборкаНР.Ссылка);
						РезультатЗапросаАналога = ЗапросАналога.Выполнить();
						оптСоотРезультатовАналогов.Вставить(ВыборкаНР.Ссылка, РезультатЗапросаАналога);
						Иначе
						РезультатЗапросаАналога = оптСоотРезультатовАналогов[ВыборкаНР.Ссылка];
						КонецЕсли;
			ВыборкаАНР = РезультатЗапросаАналога.Выбрать();
				Пока ВыборкаАНР.Следующий() Цикл
					Если ВыборкаАНР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Набор Тогда 
					СписокАналогов = Новый СписокЗначений;

					ПолучитьАналогиНабора(ВыборкаАНР.Элемент,ПолучитьБазовоеКоличествоБезОкругления(ВыборкаАНР.Норма,ВыборкаАНР.ЭлементОЕИ)*КолУзла,СписокАналогов);
						Для каждого Аналог Из СписокАналогов Цикл
						ТЧ = ТаблицаАналогов.Добавить();
						ТЧ.МПЗ = ВыборкаНР.Элемент;
						ТЧ.Аналог = Аналог.Значение;
						ТЧ.Количество = Число(Аналог.Представление);					
						КонецЦикла;					
					Иначе	
					ТЧ = ТаблицаАналогов.Добавить();
					ТЧ.МПЗ = ВыборкаНР.Элемент;
					ТЧ.Аналог = ВыборкаАНР.Элемент;
					ТЧ.Количество = ПолучитьБазовоеКоличествоБезОкругления(ВыборкаАНР.Норма,ВыборкаАНР.ЭлементОЕИ)*КолУзла;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли; 					
		Иначе
			Если ПроектРедизайна = Неопределено Тогда
			Элемент = ВыборкаНР.Элемент;
			Иначе	
			Элемент = ПолучитьПФРедизайна(ВыборкаНР.Элемент,ПроектРедизайна);			
			КонецЕсли;
				Если ИсключитьСписокГруппНоменклатуры.Количество() > 0 Тогда
					Если ПринадлежитСпискуГруппНоменклатуры(Элемент) Тогда
					Продолжить;
					КонецЕсли; 
				КонецЕсли;
		БазовоеКоличество = ПолучитьБазовоеКоличествоБезОкругления(ВыборкаНР.Норма,Элемент.ОсновнаяЕдиницаИзмерения);
			Если РаскрытьНа = 1 Тогда
				Если НеРаскрыватьУзлыИДетали Тогда
					Если ВыборкаНР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Основа Тогда
					РаскрытьНаМПЗ(ТаблицаМПЗ,ТаблицаАналогов,Элемент,БазовоеКоличество*КолУзла,ПроектРедизайна);
					КонецЕсли; 
				Иначе	
				РаскрытьНаМПЗ(ТаблицаМПЗ,ТаблицаАналогов,Элемент,БазовоеКоличество*КолУзла,ПроектРедизайна);
				КонецЕсли;
			ИначеЕсли РаскрытьНа = 2 Тогда
				Если Не Элемент.Канбан.Пустая() Тогда
					Если СписокВидовКанбанов.Количество() > 0 Тогда
						Если СписокВидовКанбанов.НайтиПоЗначению(Элемент.Канбан) <> Неопределено Тогда
						ТЧ = ТаблицаМПЗ.Добавить();
						ТЧ.ГруппаМПЗ = ПолучитьВерхнегоРодителя(Элемент);
						ТЧ.МПЗ = Элемент;
						ТЧ.Количество = БазовоеКоличество*КолУзла;							
						КонецЕсли;
					Иначе
					ТЧ = ТаблицаМПЗ.Добавить();
					ТЧ.ГруппаМПЗ = ПолучитьВерхнегоРодителя(Элемент);
					ТЧ.МПЗ = Элемент;
					ТЧ.Количество = БазовоеКоличество*КолУзла;					
					КонецЕсли; 						
				КонецЕсли; 				
			РаскрытьНаМПЗ(ТаблицаМПЗ,ТаблицаАналогов,Элемент,БазовоеКоличество*КолУзла,ПроектРедизайна);
			Иначе
				Если ВыборкаНР.ВидЭлемента = Перечисления.ВидыЭлементовНормРасходов.Основа Тогда
				РаскрытьНаМПЗ(ТаблицаМПЗ,ТаблицаАналогов,Элемент,БазовоеКоличество*КолУзла,ПроектРедизайна);
				Иначе
				ТЧ = ТаблицаМПЗ.Добавить();
				ТЧ.ГруппаМПЗ = ПолучитьВерхнегоРодителя(Элемент);
				ТЧ.МПЗ = Элемент;
				ТЧ.Количество = БазовоеКоличество*КолУзла;
				КонецЕсли; 			
			КонецЕсли;  
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура РаскрытьНаМПЗОжидаемыйРасход(ТаблицаРасходаМПЗ,СписокМПЗ,Номенклатура,ЭтапСпецификации,КолУзла)
	Если оптСоотРезультатов.Получить(ЭтапСпецификации) = Неопределено Тогда 
	Запрос = оптЗапросНорм;
	Запрос.УстановитьПараметр("Владелец", ЭтапСпецификации);
	РезультатЗапроса = Запрос.Выполнить();
	оптСоотРезультатов.Вставить(ЭтапСпецификации, РезультатЗапроса);
	Иначе
	РезультатЗапроса = оптСоотРезультатов[ЭтапСпецификации];
	КонецЕсли;	
ВыборкаНР = РезультатЗапроса.Выбрать();
	Пока ВыборкаНР.Следующий() Цикл
	Количество = ОбщегоНазначенияПовтИсп.ПолучитьБазовоеКоличествоБезОкругленияПИ(ВыборкаНР.Норма,ВыборкаНР.ЭлементОЕИ)*КолУзла;
		Если ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Материалы")Тогда           
		РаскрытьНаМПЗОжидаемыйРасход(ТаблицаРасходаМПЗ,СписокМПЗ,Номенклатура,ВыборкаНР.Элемент,Количество); 
			Если СписокМПЗ.НайтиПоЗначению(ВыборкаНР.Элемент) = Неопределено Тогда	
			Продолжить;				
			КонецЕсли;  
		Выборка = ТаблицаРасходаМПЗ.НайтиСтроки(Новый Структура("МПЗ",ВыборкаНР.Элемент));
			Если Выборка.Количество() = 0 Тогда			
			ТЧ = ТаблицаРасходаМПЗ.Добавить();
			ТЧ.МПЗ = ВыборкаНР.Элемент;
			ТЧ.КоличествоОжидаемыйРасход = Количество;
			Иначе 
			Выборка[0].КоличествоОжидаемыйРасход = Выборка[0].КоличествоОжидаемыйРасход + Количество;
			КонецЕсли;					
		Иначе
			Если ВыборкаНР.Элемент.ПереходНаРедизайн Тогда
			Результат = ОбщийМодульРаботаСРегистрами.ПолучитьПФРедизайна(Номенклатура,ВыборкаНР.Элемент);
				Если Результат <> Неопределено Тогда
				РаскрытьНаМПЗОжидаемыйРасход(ТаблицаРасходаМПЗ,СписокМПЗ,Номенклатура,Результат.ЭлементНовый,Количество); 
				Продолжить;
				КонецЕсли;	
			КонецЕсли;
		РаскрытьНаМПЗОжидаемыйРасход(ТаблицаРасходаМПЗ,СписокМПЗ,Номенклатура,ВыборкаНР.Элемент,Количество);
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПодсчётОжидаемогоРасхода(ТаблицаРасходаМПЗ,СписокМПЗ)
ТаблицаПродукции = ОбщийМодульВызовСервера.ПолучитьТаблицуПриборовОжидаемогоРасхода(СписокПодразделений,Ложь,Ложь);
	Для каждого ТЧ Из ТаблицаПродукции Цикл 
	РаскрытьНаМПЗОжидаемыйРасход(ТаблицаРасходаМПЗ,СписокМПЗ,ТЧ.Продукция,ТЧ.Продукция,ТЧ.Количество);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура РаскрытьНаМПЗВсюСпецификацию(ТаблицаРасходаМПЗ,СписокМПЗ,ЭтапСпецификации,КолУзла)
	Если оптСоотРезультатов.Получить(ЭтапСпецификации) = Неопределено Тогда 
	Запрос = оптЗапросНорм;
	Запрос.УстановитьПараметр("Владелец", ЭтапСпецификации);
	РезультатЗапроса = Запрос.Выполнить();
	оптСоотРезультатов.Вставить(ЭтапСпецификации, РезультатЗапроса);
	Иначе
	РезультатЗапроса = оптСоотРезультатов[ЭтапСпецификации];
	КонецЕсли;
ВыборкаНР = РезультатЗапроса.Выбрать();
	Пока ВыборкаНР.Следующий() Цикл
		Если ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Материалы")Тогда
			Если СписокМПЗ.НайтиПоЗначению(ВыборкаНР.Элемент) = Неопределено Тогда	
			Продолжить;				
			КонецЕсли; 
		Выборка = ТаблицаРасходаМПЗ.НайтиСтроки(Новый Структура("МПЗ",ВыборкаНР.Элемент)); 
			Если Выборка.Количество() = 0 Тогда			
			ТЧ = ТаблицаРасходаМПЗ.Добавить();
			ТЧ.МПЗ = ВыборкаНР.Элемент;
			ТЧ.КоличествоРК = ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.ЭлементОЕИ)*КолУзла;
			Иначе
			Выборка[0].КоличествоРК = Выборка[0].КоличествоРК + ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.ЭлементОЕИ)*КолУзла;
			КонецЕсли;					
		Иначе
		РаскрытьНаМПЗВсюСпецификацию(ТаблицаРасходаМПЗ,СписокМПЗ,ВыборкаНР.Элемент,ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.ЭлементОЕИ)*КолУзла);				
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПодсчётРезервКомплектов(ТаблицаРасходаМПЗ,СписокМПЗ)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПерспективныеПланы.МПЗ,
	|	ПерспективныеПланы.РезКм
	|ИЗ
	|	РегистрСведений.ПерспективныеПланы КАК ПерспективныеПланы
	|ГДЕ
	|	ПерспективныеПланы.Период = &НаДату
	|	И ПерспективныеПланы.РезКм > 0";
Запрос.УстановитьПараметр("НаДату", НачалоМесяца(ТекущаяДата())); 
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	РаскрытьНаМПЗВсюСпецификацию(ТаблицаРасходаМПЗ,СписокМПЗ,ВыборкаДетальныеЗаписи.МПЗ,ВыборкаДетальныеЗаписи.РезКм);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
ТабДок = Новый ТабличныйДокумент;
Запрос = Новый Запрос;
ТаблицаМПЗ = Новый ТаблицаЗначений;
ТаблицаАналогов = Новый ТаблицаЗначений;

ТаблицаМПЗ.Колонки.Добавить("МПЗ");
ТаблицаМПЗ.Индексы.Добавить("МПЗ");
ТаблицаМПЗ.Колонки.Добавить("ГруппаМПЗ");
ТаблицаМПЗ.Колонки.Добавить("Количество");

ТаблицаАналогов.Колонки.Добавить("МПЗ");
ТаблицаАналогов.Индексы.Добавить("МПЗ");
ТаблицаАналогов.Колонки.Добавить("Аналог");
ТаблицаАналогов.Колонки.Добавить("Количество");

ТаблицаРасходаМПЗ = Новый ТаблицаЗначений;

ТаблицаРасходаМПЗ.Колонки.Добавить("МПЗ");
ТаблицаРасходаМПЗ.Индексы.Добавить("МПЗ");
ТаблицаРасходаМПЗ.Колонки.Добавить("КоличествоОжидаемыйРасход", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(14,3)));
ТаблицаРасходаМПЗ.Колонки.Добавить("КоличествоРК", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(14,3)));

СписокМПЗ.Очистить();
	Если ВидПП < 3 Тогда
		Для каждого ТЧ Из Отчет.Номенклатура Цикл
		РаскрытьНаМПЗ(ТаблицаМПЗ,ТаблицаАналогов,ТЧ.Номенклатура,ТЧ.Количество);	
		КонецЦикла;	
	Иначе	
		Для каждого ТЧ Из Отчет.Номенклатура Цикл
		РаскрытьНаМПЗ(ТаблицаМПЗ,ТаблицаАналогов,ТЧ.Номенклатура,ТЧ.Количество,ТЧ.Проект);	
		КонецЦикла;	
	КонецЕсли;
ТаблицаМПЗ.Свернуть("ГруппаМПЗ,МПЗ","Количество");
ТаблицаМПЗ.Сортировать("ГруппаМПЗ,МПЗ");
ТаблицаАналогов.Свернуть("МПЗ,Аналог","Количество");
ТаблицаАналогов.Сортировать("МПЗ,Аналог");
	Для каждого ТЧ Из ТаблицаМПЗ Цикл	
	СписокМПЗ.Добавить(ТЧ.МПЗ);
	КонецЦикла;
		Для каждого ТЧ Из ТаблицаАналогов Цикл
			Если СписокМПЗ.НайтиПоЗначению(ТЧ.Аналог) = Неопределено Тогда
			СписокМПЗ.Добавить(ТЧ.Аналог);			
			КонецЕсли; 
		КонецЦикла;
СписокМПЗ.СортироватьПоЗначению();
ПодсчётОжидаемогоРасхода(ТаблицаРасходаМПЗ,СписокМПЗ);
ПодсчётРезервКомплектов(ТаблицаРасходаМПЗ,СписокМПЗ);

ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблГруппаМПЗ = Макет.ПолучитьОбласть("ГруппаМПЗ");
ОблМПЗ = Макет.ПолучитьОбласть("МПЗ");
ОблАналог = Макет.ПолучитьОбласть("Аналог");
ОблЯчейкаКомплектации = Макет.ПолучитьОбласть("ЯчейкаКомплектации");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.НаДату = Формат(Отчет.НаДату,"ДФ=dd.MM.yyyy");
ТабДок.Вывести(ОблШапка);

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаХраненияОстатки.МПЗ КАК МПЗ,
	|	МестаХраненияОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.МестаХранения.Остатки КАК МестаХраненияОстатки";
	Если СписокМестХранения.Количество() > 0 Тогда
	Запрос.Текст = Запрос.Текст + " ГДЕ МестаХраненияОстатки.МестоХранения В ИЕРАРХИИ(&СписокМестХранения)";	
	Запрос.УстановитьПараметр("СписокМестХранения", СписокМестХранения);
	КонецЕсли;
Запрос.Текст = Запрос.Текст + " ИТОГИ СУММА(КоличествоОстаток) ПО МПЗ"; 
РезультатЗапроса = Запрос.Выполнить();
ВыборкаМПЗ = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПередачиВПроизводствоОстатки.МПЗ КАК МПЗ,
	|	ПередачиВПроизводствоОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ПередачиВПроизводство.Остатки КАК ПередачиВПроизводствоОстатки
	|ИТОГИ
	|	СУММА(КоличествоОстаток)
	|ПО
	|	МПЗ"; 
РезультатЗапроса = Запрос.Выполнить();
ВыборкаПП = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказыПоставщикамОстаткиИОбороты.МПЗ КАК МПЗ,
	|	ЗаказыПоставщикамОстаткиИОбороты.ЗаказПоставщику,
	|	ЗаказыПоставщикамОстаткиИОбороты.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор, , ) КАК ЗаказыПоставщикамОстаткиИОбороты
	|ИТОГИ
	|	СУММА(КоличествоКонечныйОстаток)
	|ПО
	|	МПЗ";
Запрос.УстановитьПараметр("ДатаНач", НачалоГода(ТекущаяДата()));
Запрос.УстановитьПараметр("ДатаКон", ТекущаяДата());
РезультатЗапроса = Запрос.Выполнить();
ВыборкаЗаказы = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Если ПоказатьЯчейкиКомплектации Тогда
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЯчейкиКомплектацииСрезПоследних.МПЗ КАК МПЗ,
		|	ЯчейкиКомплектацииСрезПоследних.МестоХранения КАК МестоХранения,
		|	ЯчейкиКомплектацииСрезПоследних.КоличествоЯчеек КАК КоличествоЯчеек,
		|	ЯчейкиКомплектацииСрезПоследних.КоличествоВЯчейке КАК КоличествоВЯчейке
		|ИЗ
		|	РегистрСведений.ЯчейкиКомплектации.СрезПоследних(&НаДату, ) КАК ЯчейкиКомплектацииСрезПоследних
		|ГДЕ
		|	ЯчейкиКомплектацииСрезПоследних.КоличествоЯчеек > 0
		|ИТОГИ ПО
		|	МПЗ";
	Запрос.УстановитьПараметр("НаДату", Отчет.НаДату);
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаЯК = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	КонецЕсли; 

ТекГруппаМПЗ = Неопределено;
	Для каждого ТЧ Из ТаблицаМПЗ Цикл
		Если ТекГруппаМПЗ <> ТЧ.ГруппаМПЗ Тогда
			Если ТекГруппаМПЗ <> Неопределено Тогда
			ТабДок.ЗакончитьГруппуСтрок();
			КонецЕсли; 
		ОблГруппаМПЗ.Параметры.ГруппаМПЗ = ТЧ.ГруппаМПЗ;
		ТабДок.Вывести(ОблГруппаМПЗ);
		ТабДок.НачатьГруппуСтрок("ГруппыМПЗ", Истина);
		ТекГруппаМПЗ = ТЧ.ГруппаМПЗ;
		КонецЕсли;
	ВыборкаРасход = ТаблицаРасходаМПЗ.НайтиСтроки(Новый Структура("МПЗ",ТЧ.МПЗ)); 
		Если ВыборкаРасход.Количество() > 0 Тогда
		КоличествоРК = ВыборкаРасход[0].КоличествоРК;
		КоличествоОжидаемыйРасход = ВыборкаРасход[0].КоличествоОжидаемыйРасход;
		Иначе	
		КоличествоРК = 0;
		КоличествоОжидаемыйРасход = 0;	
		КонецЕсли;	
	Кол = ТЧ.Количество;
	ОблМПЗ.Параметры.Статус = ПолучитьСтатус(ТЧ.МПЗ);
		Если РаскрытьНа = 1 Тогда
		ОблМПЗ.Параметры.ГруппаПоЗакупкам = ТЧ.МПЗ.ГруппаПоЗакупкам;
		ОблМПЗ.Параметры.ТипРиска = Строка(ТЧ.МПЗ.ТипРиска);
		КонецЕсли; 	
	ОблМПЗ.Параметры.МПЗ = ТЧ.МПЗ;
	ОблМПЗ.Параметры.Кол = Кол;
	ОблМПЗ.Параметры.КолРК = КоличествоРК;
	ОблМПЗ.Параметры.ЕдиницаИзмерения = ТЧ.МПЗ.ЕдиницаИзмерения;
	ОблМПЗ.Параметры.Цена = ОбщийМодульВызовСервера.ПолучитьПоследнююЦену(ТЧ.МПЗ,ТекущаяДата());
		Если РаскрытьНа = 1 и НеснижаемыйЗапас Тогда
		ОблМПЗ.Параметры.КолНЗ = ТЧ.МПЗ.МинОстаток;
		Иначе	
		ОблМПЗ.Параметры.КолНЗ = 0;
		КонецЕсли; 
	ВыборкаМПЗ.Сбросить();
	КолНаСкладе = 0;
		Пока ВыборкаМПЗ.НайтиСледующий(Новый Структура("МПЗ",ТЧ.МПЗ)) Цикл
		КолНаСкладе = КолНаСкладе + ВыборкаМПЗ.КоличествоОстаток;	
		КонецЦикла;
	ОблМПЗ.Параметры.КолНаСкладе = КолНаСкладе;
	КолВПроизводстве = 0;
	ВыборкаПП.Сбросить();
		Пока ВыборкаПП.НайтиСледующий(Новый Структура("МПЗ",ТЧ.МПЗ)) Цикл
		КолВПроизводстве = ВыборкаПП.КоличествоОстаток;	
		КонецЦикла;
	ОблМПЗ.Параметры.КоличествоВПроизводстве = КолВПроизводстве; 
	ОблМПЗ.Параметры.КоличествоОжидаемыйРасход = КоличествоОжидаемыйРасход;
	КолЗаказано = 0;
	ВыборкаЗаказы.Сбросить();
		Пока ВыборкаЗаказы.НайтиСледующий(Новый Структура("МПЗ",ТЧ.МПЗ)) Цикл
		КолЗаказано = ВыборкаЗаказы.КоличествоКонечныйОстаток;
		КонецЦикла;
	ОблМПЗ.Параметры.КолЗаказано = КолЗаказано;
	ОблМПЗ.Параметры.КолДефицит = КолНаСкладе-Кол-КоличествоРК-ОблМПЗ.Параметры.КолНЗ-КолВПроизводстве-КоличествоОжидаемыйРасход+КолЗаказано;
	ОблМПЗ.Параметры.СвободныйОстаток = КолНаСкладе+КолВПроизводстве-КоличествоОжидаемыйРасход-КоличествоРК;
	ТекОбл = ТабДок.Вывести(ОблМПЗ);
		Если ПоказыватьПроцентОтНЗ Тогда
			Если ОблМПЗ.Параметры.КолНЗ > 0 Тогда			
				Если ((ОблМПЗ.Параметры.Кол*100)/ОблМПЗ.Параметры.КолНЗ) > ПроцентОтНЗ Тогда
				ТабДок.Область(ТекОбл.Верх, 7, ТекОбл.Низ, 7).ЦветФона = WebЦвета.Красный;			
				КонецЕсли; 
			КонецЕсли;
		КонецЕсли;
			Если ПоказатьЯчейкиКомплектации Тогда
			ТабДок.НачатьГруппуСтрок("ЯК", Истина);
			ВыборкаЯК.Сбросить();
				Пока ВыборкаЯК.НайтиСледующий(Новый Структура("МПЗ",ТЧ.МПЗ)) Цикл
				ВыборкаДетальныеЗаписи = ВыборкаЯК.Выбрать();		
					Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					ОблЯчейкаКомплектации.Параметры.МестоХранения = ВыборкаДетальныеЗаписи.МестоХранения;
					ОблЯчейкаКомплектации.Параметры.КоличествоЯчеек = ВыборкаДетальныеЗаписи.КоличествоЯчеек;
					ОблЯчейкаКомплектации.Параметры.КоличествоВЯчейке = ВыборкаДетальныеЗаписи.КоличествоВЯчейке;
					ТабДок.Вывести(ОблЯчейкаКомплектации);
					КонецЦикла;
				КонецЦикла;
			ТабДок.ЗакончитьГруппуСтрок();
			КонецЕсли;  
	ТабДок.НачатьГруппуСтрок("Аналоги", Ложь);
	ВыборкаАналогов = ТаблицаАналогов.НайтиСтроки(Новый Структура("МПЗ",ТЧ.МПЗ));
		Для к = 0 По ВыборкаАналогов.Количество()-1 Цикл
		Аналог = ВыборкаАналогов[к].Аналог;
		Кол = ВыборкаАналогов[к].Количество;
		ВыборкаРасход = ТаблицаРасходаМПЗ.НайтиСтроки(Новый Структура("МПЗ",Аналог)); 
			Если ВыборкаРасход.Количество() > 0 Тогда
			КоличествоРК = ВыборкаРасход[0].КоличествоРК;
			КоличествоОжидаемыйРасход = ВыборкаРасход[0].КоличествоОжидаемыйРасход;
			Иначе	
			КоличествоРК = 0;
			КоличествоОжидаемыйРасход = 0;	
			КонецЕсли;
		ОблАналог.Параметры.МПЗ = Аналог;
			Если ТипЗнч(Аналог) = Тип("СправочникСсылка.Номенклатура") Тогда
			ОблАналог.Параметры.ПФ = "(п.ф.) ";
			Иначе	
			ОблАналог.Параметры.ПФ = "";
			КонецЕсли;
		ОблАналог.Параметры.Кол = Кол;
		ОблАналог.Параметры.КолРК = КоличествоРК;
		ОблАналог.Параметры.КоличествоОжидаемыйРасход = КоличествоОжидаемыйРасход;
		ОблАналог.Параметры.ЕдиницаИзмерения = Аналог.ЕдиницаИзмерения;
		ОблАналог.Параметры.Цена = ОбщийМодульВызовСервера.ПолучитьПоследнююЦену(Аналог,ТекущаяДата()); 
			Если ТипЗнч(Аналог) = Тип("СправочникСсылка.Материалы") Тогда
			ОблАналог.Параметры.ТипРиска = Строка(Аналог.ТипРиска);			
			КонецЕсли;
				Если РаскрытьНа = 1 и НеснижаемыйЗапас Тогда
				ОблАналог.Параметры.КолНЗ = Аналог.МинОстаток;
				Иначе	
				ОблАналог.Параметры.КолНЗ = 0;
				КонецЕсли;
		ВыборкаМПЗ.Сбросить();
		КолНаСкладе = 0;
			Пока ВыборкаМПЗ.НайтиСледующий(Новый Структура("МПЗ",Аналог)) Цикл
			КолНаСкладе = ВыборкаМПЗ.КоличествоОстаток;	
			КонецЦикла;
		ОблАналог.Параметры.КолНаСкладе = КолНаСкладе;
		КолВПроизводстве = 0;
		ВыборкаПП.Сбросить();
			Пока ВыборкаПП.НайтиСледующий(Новый Структура("МПЗ",Аналог)) Цикл
			КолВПроизводстве = ВыборкаПП.КоличествоОстаток;	
			КонецЦикла;
		ОблАналог.Параметры.КоличествоВПроизводстве = КолВПроизводстве; 
		КолЗаказано = 0;
		ВыборкаЗаказы.Сбросить();
			Пока ВыборкаЗаказы.НайтиСледующий(Новый Структура("МПЗ",Аналог)) Цикл
			КолЗаказано = ВыборкаЗаказы.КоличествоКонечныйОстаток;
			КонецЦикла;
		ОблАналог.Параметры.КолЗаказано = КолЗаказано;
		ОблАналог.Параметры.КолДефицит = КолНаСкладе-Кол-КоличествоРК-ОблАналог.Параметры.КолНЗ-КолВПроизводстве+КолЗаказано;
		ОблАналог.Параметры.СвободныйОстаток = КолНаСкладе+КолВПроизводстве-КоличествоРК;
		ТекОбл = ТабДок.Вывести(ОблАналог);
			Если ПоказыватьПроцентОтНЗ Тогда
				Если ОблАналог.Параметры.КолНЗ > 0 Тогда			
					Если ((ОблАналог.Параметры.Кол*100)/ОблАналог.Параметры.КолНЗ) > ПроцентОтНЗ Тогда
					ТабДок.Область(ТекОбл.Верх, 7, ТекОбл.Низ, 7).ЦветФона = WebЦвета.Красный;			
					КонецЕсли; 
				КонецЕсли;
			КонецЕсли;
				Если ПоказатьЯчейкиКомплектации Тогда
				ТабДок.НачатьГруппуСтрок("ЯКАналоги", Истина);
				ВыборкаЯК.Сбросить();
					Пока ВыборкаЯК.НайтиСледующий(Новый Структура("МПЗ",Аналог)) Цикл
					ВыборкаДетальныеЗаписи = ВыборкаЯК.Выбрать();		
						Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
						ОблЯчейкаКомплектации.Параметры.МестоХранения = ВыборкаДетальныеЗаписи.МестоХранения;
						ОблЯчейкаКомплектации.Параметры.КоличествоЯчеек = ВыборкаДетальныеЗаписи.КоличествоЯчеек;
						ОблЯчейкаКомплектации.Параметры.КоличествоВЯчейке = ВыборкаДетальныеЗаписи.КоличествоВЯчейке;
						ТабДок.Вывести(ОблЯчейкаКомплектации);
						КонецЦикла;
					КонецЦикла;
				ТабДок.ЗакончитьГруппуСтрок();
				КонецЕсли; 
		КонецЦикла;
	ТабДок.ЗакончитьГруппуСтрок(); 
	КонецЦикла;
		Если ТекГруппаМПЗ <> Неопределено Тогда
		ТабДок.ЗакончитьГруппуСтрок();
		КонецЕсли; 
ТабДок.Вывести(ОблКонец);
ТабДок.ФиксацияСверху = 2;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	Элементы.ВсеНастройки.Скрыть();
	Элементы.ГруппаПП.Скрыть();
	НачалоЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах(); 
	Состояние("Обработка...",,"Формирование таблицы отчёта...");
	СформироватьНаСервере();
	ОкончаниеЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах();
	Элементы.ВсеНастройки.ЗаголовокСвернутогоОтображения = "Сформирован за "+Окр((ОкончаниеЗамера - НачалоЗамера)/1000/60,1)+" мин.";
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПолучитьППНаСервере()
	Если СреднемесячнаяПотребность Тогда
	КолМесяцев = ПолучитьКоличествоМесяцевВПериоде(ПериодПП);
	Иначе	
	КолМесяцев = 1;
	КонецЕсли;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПерспективныеПланы.МПЗ КАК МПЗ,
	|	ПерспективныеПланы.Количество КАК Количество,
	|	ПерспективныеПланы.РезКм КАК РезКм,
	|	ПерспективныеПланы.Проект КАК Проект
	|ИЗ
	|	РегистрСведений.ПерспективныеПланы КАК ПерспективныеПланы
	|ГДЕ
	|	ПерспективныеПланы.Период МЕЖДУ &ДатаНач И &ДатаКон
	|	И ТИПЗНАЧЕНИЯ(ПерспективныеПланы.МПЗ) = ТИП(Справочник.Номенклатура)
	|	И ПерспективныеПланы.Проект = &ПустойПроект
	|	И ПерспективныеПланы.Количество > 0";
	Если СписокГруппНоменклатуры.Количество() > 0 Тогда
	Запрос.Текст = Запрос.Текст + " И ПерспективныеПланы.МПЗ В ИЕРАРХИИ(&СписокГруппНоменклатуры)";
	Запрос.УстановитьПараметр("СписокГруппНоменклатуры", СписокГруппНоменклатуры);
	КонецЕсли;
		Если СписокЛинеек.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + " И ПерспективныеПланы.МПЗ.Линейка В ИЕРАРХИИ(&СписокЛинеек)";
		Запрос.УстановитьПараметр("СписокЛинеек", СписокЛинеек);
		КонецЕсли; 
Запрос.Текст = Запрос.Текст + " ИТОГИ СУММА(Количество) ПО МПЗ";
Запрос.УстановитьПараметр("ДатаНач", ПериодПП.ДатаНачала); 
Запрос.УстановитьПараметр("ДатаКон", ПериодПП.ДатаОкончания);   
Запрос.УстановитьПараметр("ПустойПроект", Справочники.Проекты.ПустаяСсылка());
РезультатЗапроса = Запрос.Выполнить();
ВыборкаМПЗ = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаМПЗ.Следующий() Цикл
		Если СписокСтатусов.Количество() > 0 Тогда	
			Если СписокСтатусов.НайтиПоЗначению(ПолучитьСтатус(ВыборкаМПЗ.МПЗ)) = Неопределено Тогда
			Продолжить;
			КонецЕсли; 
		КонецЕсли; 
	ВыборкаДетальныхЗаписей = ВыборкаМПЗ.Выбрать();
	РезКм = 0;
		Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
		РезКм = РезКм + ВыборкаДетальныхЗаписей.РезКм;
		КонецЦикла; 
	ТЧ = Отчет.Номенклатура.Добавить();
	ТЧ.Номенклатура = ВыборкаМПЗ.МПЗ;
	ТЧ.Количество = Окр(ВыборкаМПЗ.Количество/КолМесяцев,0,РежимОкругления.Окр15как20);
		Если ТЧ.Количество = 0 Тогда		
		ТЧ.Количество = 1;
		КонецЕсли; 
	ТЧ.РК = РезКм; 
	КонецЦикла;
КонецПроцедуры 

&НаСервере
Процедура ПолучитьПППроектыНаСервере()
	Если СреднемесячнаяПотребность Тогда
	КолМесяцев = ПолучитьКоличествоМесяцевВПериоде(ПериодПП);
	Иначе	
	КолМесяцев = 1;
	КонецЕсли;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПерспективныеПланы.МПЗ КАК МПЗ,
	|	ПерспективныеПланы.Количество КАК Количество,
	|	ПерспективныеПланы.РезКм КАК РезКм,
	|	ПерспективныеПланы.Проект КАК Проект,
	|	ПерспективныеПланы.Период КАК Период
	|ИЗ
	|	РегистрСведений.ПерспективныеПланы КАК ПерспективныеПланы
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(ПерспективныеПланы.МПЗ) = ТИП(Справочник.Номенклатура)
	|	И ПерспективныеПланы.Количество > 0";
	Если СписокГруппНоменклатуры.Количество() > 0 Тогда
	Запрос.Текст = Запрос.Текст + " И ПерспективныеПланы.МПЗ В ИЕРАРХИИ(&СписокГруппНоменклатуры)";
	Запрос.УстановитьПараметр("СписокГруппНоменклатуры", СписокГруппНоменклатуры);
	КонецЕсли;
		Если СписокЛинеек.Количество() > 0 Тогда
		Запрос.Текст = Запрос.Текст + " И ПерспективныеПланы.МПЗ.Линейка В ИЕРАРХИИ(&СписокЛинеек)";
		Запрос.УстановитьПараметр("СписокЛинеек", СписокЛинеек);
		КонецЕсли;
			Если СписокПроектов.Количество() > 0 Тогда
			Запрос.Текст = Запрос.Текст + " И ПерспективныеПланы.Проект В(&СписокПроектов)";
			Запрос.УстановитьПараметр("СписокПроектов", СписокПроектов);
			Иначе
			Запрос.Текст = Запрос.Текст + " И ПерспективныеПланы.Проект <> &ПустойПроект";				
			Запрос.УстановитьПараметр("ПустойПроект", Справочники.Проекты.ПустаяСсылка());
			КонецЕсли;			
Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО
								|	МПЗ,Проект,ПерспективныеПланы.Период
								|ИТОГИ
								|	СУММА(Количество)
								|ПО
								|	МПЗ,Проект";
РезультатЗапроса = Запрос.Выполнить();
ВыборкаМПЗ = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаМПЗ.Следующий() Цикл
		Если СписокСтатусов.Количество() > 0 Тогда	
			Если СписокСтатусов.НайтиПоЗначению(ПолучитьСтатус(ВыборкаМПЗ.МПЗ)) = Неопределено Тогда
			Продолжить;
			КонецЕсли; 
		КонецЕсли;
	ВыборкаПроекты = ВыборкаМПЗ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам); 
		Пока ВыборкаПроекты.Следующий() Цикл
		ВыборкаДетальныхЗаписей = ВыборкаПроекты.Выбрать();
		ВыборкаДетальныхЗаписей.Следующий();
		ДатаНач = ВыборкаДетальныхЗаписей.Период;
		РезКм = 0;
		Количество = 0;
			Для к = 0 По 5 Цикл
			ВыборкаДетальныхЗаписей.Сбросить();			
				Если ВыборкаДетальныхЗаписей.НайтиСледующий(Новый Структура("Период",ДобавитьМесяц(ДатаНач,к))) Тогда
				Количество = Количество + ВыборкаДетальныхЗаписей.Количество;
				РезКм = РезКм + ВыборкаДетальныхЗаписей.РезКм;
				КонецЕсли;	
			КонецЦикла; 
		ТЧ = Отчет.Номенклатура.Добавить();
		ТЧ.Номенклатура = ВыборкаМПЗ.МПЗ;
		ТЧ.Проект = ВыборкаПроекты.Проект;
		ТЧ.Количество = Окр(Количество/КолМесяцев,0,РежимОкругления.Окр15как20);
			Если ТЧ.Количество = 0 Тогда		
			ТЧ.Количество = 1;
			КонецЕсли; 
		ТЧ.РК = РезКм;
		КонецЦикла; 
	КонецЦикла;
КонецПроцедуры
     
&НаСервере
Процедура ВхождениеВСпецификации(Проект,Элемент,СписокНоменклатуры)
спНомен = ОбщийМодульВызовСервера.ПолучитьСписокВхождений(Элемент,ТекущаяДата());
	Для каждого Строка Из спНомен Цикл
		Если Не Строка.Значение.Товар.Пустая() Тогда 
		флИсключение = Ложь;
			Для каждого ТЧ Из Проект.ИсключенияРедизайна Цикл
				Если ТЧ.Товар.ЭтоГруппа Тогда
					Если Строка.Значение.Товар.ПринадлежитЭлементу(ТЧ.Товар) Тогда
					флИсключение = Истина;
					Прервать;
					КонецЕсли;	
				Иначе	
					Если ТЧ.Товар = Строка.Значение.Товар Тогда
					флИсключение = Истина;
					Прервать;
					КонецЕсли;
				КонецЕсли;		
			КонецЦикла;
				Если Не флИсключение Тогда
					Если СписокНоменклатуры.НайтиПоЗначению(Строка.Значение) = Неопределено Тогда
					СписокНоменклатуры.Добавить(Строка.Значение);
					КонецЕсли;
				КонецЕсли;
		КонецЕсли; 
    ВхождениеВСпецификации(Проект,Строка.Значение,СписокНоменклатуры);
	КонецЦикла;
КонецПроцедуры
      
&НаСервере
Процедура ПолучитьППРедизайнаНаСервере()
Запрос = Новый Запрос;
СписокНоменклатуры = Новый СписокЗначений;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Редизайн.Проект КАК Проект,
	|	Редизайн.ЭлементЗамены КАК ЭлементЗамены
	|ИЗ
	|	РегистрСведений.Редизайн КАК Редизайн
	|ГДЕ
	|	Редизайн.Проект В(&СписокПроектов)
	|ИТОГИ ПО
	|	Проект";
Запрос.УстановитьПараметр("СписокПроектов", СписокПроектов);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаПроекты = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПроекты.Следующий() Цикл
	СписокНоменклатуры.Очистить();
	ВыборкаПФ = ВыборкаПроекты.Выбрать();
		Пока ВыборкаПФ.Следующий() Цикл
   		ВхождениеВСпецификации(ВыборкаПроекты.Проект,ВыборкаПФ.ЭлементЗамены,СписокНоменклатуры);		
		КонецЦикла;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПерспективныеПланы.МПЗ КАК МПЗ,
		|	СУММА(ПерспективныеПланы.Количество) КАК Количество,
		|	СУММА(ПерспективныеПланы.РезКм) КАК РезКм
		|ИЗ
		|	РегистрСведений.ПерспективныеПланы КАК ПерспективныеПланы
		|ГДЕ
		|	ПерспективныеПланы.Период МЕЖДУ &ДатаНач И &ДатаКон
		|	И ПерспективныеПланы.МПЗ В(&СписокНоменклатуры)
		|	И ПерспективныеПланы.Количество > 0
		|
		|СГРУППИРОВАТЬ ПО
		|	ПерспективныеПланы.МПЗ
		|
		|УПОРЯДОЧИТЬ ПО
		|	МПЗ"; 
	Запрос.УстановитьПараметр("ДатаНач", ВыборкаПроекты.Проект.ДатаРедизайна); 
	Запрос.УстановитьПараметр("ДатаКон", КонецМесяца(ДобавитьМесяц(ВыборкаПроекты.Проект.ДатаРедизайна,5)));
	Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры); 
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныхЗаписей = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныхЗаписей.Следующий() Цикл     
		Кол = Окр(ВыборкаДетальныхЗаписей.Количество,0,РежимОкругления.Окр15как20);
			Если Кол = 0 Тогда		
			Кол = 1;
			КонецЕсли;            
		Выборка = Отчет.Номенклатура.НайтиСтроки(Новый Структура("Номенклатура",ВыборкаДетальныхЗаписей.МПЗ));
			Если Выборка.Количество() = 0 Тогда
			ТЧ = Отчет.Номенклатура.Добавить();
			ТЧ.Номенклатура = ВыборкаДетальныхЗаписей.МПЗ;
			ТЧ.Количество = Кол; 
			ТЧ.РК = ВыборкаДетальныхЗаписей.РезКм;
			ТЧ.Проект = ВыборкаПроекты.Проект;			
			Иначе	
			Выборка[0].Количество = Выборка[0].Количество + Кол;
			Выборка[0].РК = Выборка[0].РК + ВыборкаДетальныхЗаписей.РезКм;	
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьПП(Команда)
Отчет.Номенклатура.Очистить();
	Если ВидПП = 0 Тогда 
	ПолучитьППНаСервере();
	ПолучитьПППроектыНаСервере();
	ИначеЕсли ВидПП = 1 Тогда 
	ПолучитьППНаСервере();       
	ИначеЕсли ВидПП = 2 Тогда 
	ПолучитьПППроектыНаСервере();	
	Иначе
		Если СписокПроектов.Количество() > 0 Тогда
		ПолучитьППРедизайнаНаСервере();		
		Иначе	
		Сообщить("Список проектов редизайна пуст!");
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьРК(Номенклатура)
РезКм = 0;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПерспективныеПланы.МПЗ КАК МПЗ,
	|	ПерспективныеПланы.РезКм
	|ИЗ
	|	РегистрСведений.ПерспективныеПланы КАК ПерспективныеПланы
	|ГДЕ
	|	ПерспективныеПланы.Период = &НаДату
	|	И ПерспективныеПланы.МПЗ = &МПЗ";
Запрос.УстановитьПараметр("НаДату", НачалоМесяца(Отчет.НаДату));
Запрос.УстановитьПараметр("МПЗ", Номенклатура); 
РезультатЗапроса = Запрос.Выполнить();
Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
	РезКм = РезКм + Выборка.РезКм;
	КонецЦикла;
Запрос.Текст = 
	"ВЫБРАТЬ
	|	КрупныеЗаказы.Продукция КАК Продукция,
	|	КрупныеЗаказы.Количество КАК Количество
	|ИЗ
	|	РегистрСведений.КрупныеЗаказы КАК КрупныеЗаказы
	|ГДЕ
	|	КрупныеЗаказы.Обработан = ЛОЖЬ
	|	И КрупныеЗаказы.ДатаРезерва <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И КрупныеЗаказы.Продукция = &Продукция";
Запрос.УстановитьПараметр("Продукция", Номенклатура); 
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	РезКм = РезКм + ВыборкаДетальныеЗаписи.Количество;
	КонецЦикла;
Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказыНаПроизводствоОстатки.Документ КАК Документ,
	|	ЗаказыНаПроизводствоОстатки.Продукция КАК Продукция,
	|	ЗаказыНаПроизводствоОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ЗаказыНаПроизводство.Остатки КАК ЗаказыНаПроизводствоОстатки
	|ГДЕ
	|	ЗаказыНаПроизводствоОстатки.Продукция = &Продукция
	|	И ЗаказыНаПроизводствоОстатки.Документ.Закрыт = ЛОЖЬ";
Запрос.УстановитьПараметр("Продукция", Номенклатура);	
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Продукция = ВыборкаДетальныеЗаписи.Продукция;
		Для каждого ТЧ_Заказ Из ВыборкаДетальныеЗаписи.Документ.Заказ Цикл	
			Если ТЧ_Заказ.Продукция = Продукция Тогда
				Если ТЧ_Заказ.РучнойЗапуск = 0 Тогда
					Если ТЧ_Заказ.КрупныйЗаказ Тогда
					КоличествоНеСоздано = ТЧ_Заказ.Количество - ПолучитьКоличествоСозданых(ВыборкаДетальныеЗаписи.Документ,Продукция);
						Если КоличествоНеСоздано > 0 Тогда
						РезКм = РезКм + КоличествоНеСоздано;
						КонецЕсли;	
					КонецЕсли;  
				КонецЕсли; 	
			Прервать;
			КонецЕсли; 
		КонецЦикла; 
	КонецЦикла;
Возврат(РезКм);
КонецФункции

&НаКлиенте
Процедура НоменклатураНоменклатураПриИзменении(Элемент)
Элементы.Номенклатура.ТекущиеДанные.РК = ПолучитьРК(Элементы.Номенклатура.ТекущиеДанные.Номенклатура);
КонецПроцедуры

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
ИмяКолонки = СокрЛП(Сред(Элемент.ТекущаяОбласть.Имя,Найти(Элемент.ТекущаяОбласть.Имя,"C")));
	Если Найти(ИмяКолонки,":") > 0 Тогда
	ИмяКолонки = Лев(ИмяКолонки,Найти(ИмяКолонки,":")-1);
	КонецЕсли;
НомерКолонки = Число(Сред(ИмяКолонки,2));
	Если НомерКолонки = 9 Тогда
	СтандартнаяОбработка = Ложь;
	ИмяОтчета = "ОтчётПоРегиструМестаХранения";
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
		Если СписокМестХранения.Количество() > 0 Тогда
		ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,Отчет.НаДату,Отчет.НаДату,Новый Структура("МПЗ,МестоХранения",Расшифровка,СписокМестХранения),"ОстаткиПоСкладам"));		
		Иначе	
		ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,Отчет.НаДату,Отчет.НаДату,Новый Структура("МПЗ",Расшифровка),"ОстаткиПоСкладам"));
		КонецЕсли; 
	ПараметрыФормы.Вставить("КлючВарианта","ОстаткиПоСкладам"); 
	ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы);
	ИначеЕсли НомерКолонки = 12 Тогда
	СтандартнаяОбработка = Ложь;
	Отбор = Новый Структура("МПЗ",Расшифровка);
	ИмяОтчета = "ОтчётПоРегиструЗаказыПоставщикам";
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,НачалоГода(ТекущаяДата()),ТекущаяДата(),Отбор,"ПоПоставщикамВРазрезеЗаказов"));
	ПараметрыФормы.Вставить("КлючВарианта","ПоПоставщикамВРазрезеЗаказов"); 
	ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы);	 
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьИзФайлаНаСервере(Наименование, Количество)
Номен = Справочники.Номенклатура.НайтиПоНаименованию(Наименование,Истина);
	Если Не Номен.Пустая() Тогда
	ТЧ = Отчет.Номенклатура.Добавить();
	ТЧ.Номенклатура = Номен.Ссылка;
	ТЧ.Количество = Количество;	
	Иначе		
	Сообщить(Наименование + " - не найдена в справочнике номенклатуры!");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
Отчет.Номенклатура.Очистить();
Результат = ОбщийМодульКлиент.ОткрытьФайлExcel("Выберите файл cо списком номенклатуры");
	Если Результат <> Неопределено Тогда
	ExcelЛист = Результат.ExcelЛист;
	КолСтрок = Результат.КоличествоСтрок;
	    Для к = 2 по КолСтрок Цикл
		Состояние("Обработка...",к*100/КолСтрок,"Загрузка номенклатуры из файла...");
       	ЗагрузитьИзФайлаНаСервере(СокрЛП(ExcelЛист.Cells(к,1).Value),Число(ExcelЛист.Cells(к,2).Value));
	    КонецЦикла;
	Результат.Excel.Quit();
	КонецЕсли;
КонецПроцедуры

