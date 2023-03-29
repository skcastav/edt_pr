
&НаСервере
Функция НайтиСоздатьНоменклатуру(БухБаза, Элемент, бсдГруппаПоУмолчанию)
бсдГруппа = бсдГруппаПоУмолчанию;
	Если Элемент.Уровень()>1 Тогда
	г = БухБаза.Справочники.Номенклатура.НайтиПоНаименованию(Элемент.Родитель.Наименование,-1);
		Если БухБаза.ЗначениеЗаполнено(г) Тогда
		бсдГруппа = г;	
		КонецЕсли;
	КонецЕсли;
ПолныйКод = СтрЗаменить(Элемент.ПолныйКод(),"/","-");
ПолныйКод = СокрЛП(СтрЗаменить(ПолныйКод,Символы.НПП,""));	
Ном = БухБаза.Справочники.Номенклатура.НайтиПоРеквизиту("Артикул", ПолныйКод);
	Если Не БухБаза.ЗначениеЗаполнено(Ном) Тогда		
	НомОбъект = БухБаза.Справочники.Номенклатура.СоздатьЭлемент();
 	НомОбъект.Артикул 				= ПолныйКод;
 	НомОбъект.Родитель 				= бсдГруппа;					
	НомОбъект.ПометкаУдаления 		= Элемент.ПометкаУдаления;
  	НомОбъект.НаименованиеПолное 	= Элемент.ПолнНаименование;
 	НомОбъект.Наименование 			= Элемент.Наименование;	
 	ЕдИзм = БухБаза.Справочники.КлассификаторЕдиницИзмерения.НайтиПоНаименованию(Элемент.ЕдиницаИзмерения.Наименование);
	 	Если Не БухБаза.ЗначениеЗаполнено(ЕдИзм) Тогда
 		ЕдИзмОбъект = БухБаза.Справочники.КлассификаторЕдиницИзмерения.СоздатьЭлемент(); 		
 	    ЕдИзмОбъект.Наименование 		= Элемент.ЕдиницаИзмерения.Наименование;
 	    ЕдИзмОбъект.НаименованиеПолное 	= Элемент.ЕдиницаИзмерения.ПолнНаименование;
 	    ЕдИзмОбъект.Код 				= Элемент.ЕдиницаИзмерения.Код;
 		ЕдИзмОбъект.Записать();
 		ЕдИзм = ЕдИзмОбъект.Ссылка;
	 	КонецЕсли;	 	
 	НомОбъект.ЕдиницаИзмерения = ЕдИзм;	
 	НомОбъект.ВидСтавкиНДС =  БухБаза.Перечисления.ВидыСтавокНДС.Общая;
 	НомОбъект.Записать(); 
 	Сообщить("Выгружен МПЗ "+ НомОбъект.Наименование + " ("+ПолныйКод+")");	
 	Возврат НомОбъект.Ссылка;
 	Иначе
	Возврат Ном;
 	КонецЕсли;	
КонецФункции

&НаСервере
Процедура ВыгрузитьНаСервере()
БухБаза = ОбщийМодульСинхронизации.УстановитьCOMСоединение(Объект.БазаДанных);
	Если БухБаза = Неопределено Тогда
	Возврат;
	КонецЕсли; 
бсдМенеджерНоменклатура = БухБаза.Справочники.Номенклатура;
бсдМенеджерСклады		= БухБаза.Справочники.Склады;
	Если ЗначениеЗаполнено(Объект.ГруппаНоменклатурыКод) Тогда
	бсдГрНомПоУмолчанию = бсдМенеджерНоменклатура.НайтиПоКоду(СокрЛП(Объект.ГруппаНоменклатурыКод));
	Иначе
	бсдГрНомПоУмолчанию = бсдМенеджерНоменклатура.ПустаяСсылка();	
	КонецЕсли;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.МестоХранения КАК МестоХранения,
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.МестоХраненияВ КАК МестоХраненияВ,
	|	ДвижениеМПЗТабличнаяЧасть.МПЗ КАК МПЗ,
	|	ДвижениеМПЗТабличнаяЧасть.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ДвижениеМПЗТабличнаяЧасть.Количество КАК Количество
	|ИЗ
	|	Документ.ДвижениеМПЗ.ТабличнаяЧасть КАК ДвижениеМПЗТабличнаяЧасть
	|ГДЕ
	|	ДвижениеМПЗТабличнаяЧасть.Ссылка.Проведен = ИСТИНА
	|	И ДвижениеМПЗТабличнаяЧасть.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И ДвижениеМПЗТабличнаяЧасть.Ссылка.МестоХранения В ИЕРАРХИИ(&СписокМестХранения)
	|	И ДвижениеМПЗТабличнаяЧасть.Ссылка.МестоХраненияВ В ИЕРАРХИИ(&СписокМестХраненияВ)
	|	И ДвижениеМПЗТабличнаяЧасть.ВидМПЗ = &ВидМПЗ
	|ИТОГИ
	|	СУММА(Количество)
	|ПО
	|	МестоХранения,
	|	МестоХраненияВ,
	|	МПЗ,
	|	ЕдиницаИзмерения";
Запрос.УстановитьПараметр("ВидМПЗ", Перечисления.ВидыМПЗ.Материалы);
Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Объект.Период.ДатаНачала));
Запрос.УстановитьПараметр("ДатаКон", КонецДня(Объект.Период.ДатаОкончания));
Запрос.УстановитьПараметр("СписокМестХранения", СписокМестХраненияОткуда);
Запрос.УстановитьПараметр("СписокМестХраненияВ", СписокМестХраненияКуда);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаМХ = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаМХ.Следующий() Цикл
	Склад = бсдМенеджерСклады.НайтиПоКоду(СокрЛП(ВыборкаМХ.МестоХранения.КодВБухБазе));
		Если Склад.Пустая() Тогда
		Сообщить("Склад с кодом "+СокрЛП(ВыборкаМХ.МестоХранения.КодВБухБазе)+" не найден в бух. базе!");
		Продолжить;
		КонецЕсли;
	ВыборкаМХВ = ВыборкаМХ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаМХВ.Следующий() Цикл
		СкладВ = бсдМенеджерСклады.НайтиПоКоду(СокрЛП(ВыборкаМХВ.МестоХраненияВ.КодВБухБазе));
			Если СкладВ.Пустая() Тогда
			Сообщить("Склад с кодом "+СокрЛП(ВыборкаМХВ.МестоХраненияВ.КодВБухБазе)+" не найден в бух. базе!");
			Продолжить;
			КонецЕсли;
		бсНовДок = БухБаза.Документы.ПеремещениеТоваров.СоздатьДокумент();
		бсНовДок.Дата = НачалоДня(Объект.Период.ДатаОкончания)+75600;
		бсНовДок.Организация = БухБаза.Справочники.Организации.НайтиПоРеквизиту("ИНН","7112011490");
		бсНовДок.СкладОтправитель = Склад;
		бсНовДок.СкладПолучатель = СкладВ;
		бсНовДок.НДСвСтоимостиТоваров = БухБаза.Перечисления.ДействиеНДСВСтоимостиТоваров.НеИзменять;
		бсНовДок.Комментарий = "Выгрузка движений МПЗ из производственной базы за период "+Формат(Объект.Период.ДатаНачала,"ДФ=dd.MM.yyyy")+" по "+Формат(Объект.Период.ДатаОкончания,"ДФ=dd.MM.yyyy");
		ВыборкаМПЗ = ВыборкаМХВ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаМПЗ.Следующий() Цикл
			бсдНоменклатура = НайтиСоздатьНоменклатуру(БухБаза, ВыборкаМПЗ.МПЗ, бсдГрНомПоУмолчанию);	
				Если Не БухБаза.ЗначениеЗаполнено(бсдНоменклатура) Тогда
				Сообщить("Не найден МПЗ "+ВыборкаМПЗ.МПЗ);
				Продолжить;	                                     
				КонецЕсли;
			Количество = 0;
			ВыборкаЕИ = ВыборкаМПЗ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаЕИ.Следующий() Цикл
				ВыборкаДетальныхЗаписей = ВыборкаЕИ.Выбрать();
					Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
					Количество = Количество + ПолучитьБазовоеКоличество(ВыборкаДетальныхЗаписей.Количество,ВыборкаЕИ.ЕдиницаИзмерения);
					КонецЦикла;				
				КонецЦикла;
			ТЧ_П = бсНовДок.Товары.Добавить();
			ТЧ_П.Номенклатура = бсдНоменклатура;
			ТЧ_П.ЕдиницаИзмерения = бсдНоменклатура.ЕдиницаИзмерения;
			ТЧ_П.Количество = Количество;
			КонецЦикла;
				Если бсНовДок.Товары.Количество() > 0 Тогда
				БухБаза.Документы.ПеремещениеТоваров.ЗаполнитьСчетаУчетаВТабличнойЧасти(бсНовДок, "Товары");
				бсНовДок.Записать();
				Сообщить("Создан документ Перемещение товаров №"+бсНовДок.Номер+" от "+бсНовДок.Дата);		
				КонецЕсли;
		КонецЦикла;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура Выгрузить(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	Состояние("Обработка...",,"Выгрузка в выбранную базу данных...");	
	ВыгрузитьНаСервере();	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВыбратьЭлемент(СписокЭлементов, Таблица, ТолькоГруппы = Ложь)
БухБаза = ОбщийМодульСинхронизации.УстановитьCOMСоединение(Объект.БазаДанных);
	Если БухБаза = Неопределено Тогда
	Возврат;
	КонецЕсли;
ТекстУсловия = ?(БухБаза.String(БухБаза.Метаданные.НайтиПоПолномуИмени(Таблица).ВидИерархии) = "ИерархияГруппИЭлементов",
			   ?(Не ТолькоГруппы,"И НЕ  Таблица.ЭтоГруппа","И Таблица.ЭтоГруппа"), "");
бсдЗапрос = БухБаза.NewObject("Запрос");
бсдЗапрос.Текст =
"ВЫБРАТЬ
|	Таблица.Код + "" | "" + Таблица.Наименование КАК Представление,
|	Таблица.Код КАК Код,
|	Таблица.Наименование КАК Наименование
|ИЗ
|	"+Таблица+" КАК Таблица
|ГДЕ
|	НЕ Таблица.ПометкаУдаления
|	"+ТекстУсловия+"
|
|УПОРЯДОЧИТЬ ПО
|	Наименование";	
бсдВыборка = бсдЗапрос.Выполнить().Выбрать();
	Пока бсдВыборка.Следующий() Цикл
	СписокЭлементов.Добавить(бсдВыборка.Код,бсдВыборка.Представление);
	КонецЦикла;		
КонецПроцедуры

&НаКлиенте
Процедура ГруппаНоменклатурыПоУмолчаниюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
Состояние("Обработка...",,"Получение данных из бухгалтерской базы");
СписокЭлементов = Новый СписокЗначений;
ВыбратьЭлемент(СписокЭлементов, "Справочник.Номенклатура", Истина);
Элемент = СписокЭлементов.ВыбратьЭлемент("Выберите группу номенклатуры",Элемент);
	Если Элемент <> Неопределено Тогда
	Объект.ГруппаНоменклатуры = Элемент.Представление;
	Объект.ГруппаНоменклатурыКод = Элемент.Значение;
	КонецЕсли;
КонецПроцедуры
