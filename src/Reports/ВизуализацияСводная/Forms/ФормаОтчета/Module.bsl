 
&НаКлиенте
Перем КлючФЗ,КлючВХ,НачалоЗамера;

&НаКлиенте
Процедура ПриОткрытии(Отказ)
КлючУникальности = Новый УникальныйИдентификатор();
ЭтаФорма.Заголовок = "Визуализация "+СписокЛинеек;
КонецПроцедуры

&НаСервере   
Функция ПолучитьСостояниеФЗ(Ключ) 
Возврат(ФоновоеВыполнение.НайтиЗадание(Ключ));
КонецФункции 
           
&НаСервере
Процедура ПолучитьРезультатФЗ(КлючВХ)
ТабДок = ПолучитьИзВременногоХранилища(КлючВХ);
ТабДок.ПоказатьУровеньГруппировокСтрок(Не СвернутьПоМТК);
ТабДок.ПоказатьУровеньГруппировокКолонок(ИнформацияПоВыпускам);                                      
КонецПроцедуры

&НаКлиенте   
Функция СостояниеФЗ() Экспорт 
Результат = ПолучитьСостояниеФЗ(КлючФЗ);
	Если Результат.Выполняется Тогда
	ВремяФормирования = "Формирование отчёта...";
	ИначеЕсли Результат.Успех Тогда
	ОтключитьОбработчикОжидания("СостояниеФЗ");
	ПолучитьРезультатФЗ(КлючВХ);   
	Элементы.Сформировать.Доступность = Истина;
	ВремяФормирования = Формат((ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЗамера)/60000,"ЧДЦ=1")+" мин.";	
	Иначе
   	ВремяФормирования = Результат.Ошибка;
	ОтключитьОбработчикОжидания("СостояниеФЗ");
	КонецЕсли;
Возврат(Не Результат.Выполняется);
КонецФункции

&НаСервере      
Функция СформироватьОтчёт(Адрес)
ОбъектЗн = РеквизитФормыВЗначение("Отчет");
ТекстФоновойПроцедуры = "ФоновоеВыполнение.СформироватьВизуализациюСводную(Макет,СписокЛинеек,СписокНоменклатуры,Адрес);";                                                                                                                                                                                                                        
ПараметрыФЗ = Новый Структура("Макет,СписокЛинеек,СписокНоменклатуры,Адрес",ОбъектЗн.ПолучитьМакет("Визуализация"),СписокЛинеек,СписокНоменклатуры,Адрес);
Ключ = ФоновоеВыполнение.ЗапуститьФоновоеВыполнение(ТекстФоновойПроцедуры,ПараметрыФЗ);
Возврат(Ключ);
КонецФункции

&НаКлиенте
Процедура Сформировать(Команда)
НачалоЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах();
Элементы.Сформировать.Доступность = Ложь;
ВремяФормирования = "Формирование отчёта...";   
КлючВХ = ПоместитьВоВременноеХранилище(Неопределено,ЭтаФорма.КлючУникальности);
КлючФЗ = СформироватьОтчёт(КлючВХ);
ПодключитьОбработчикОжидания("СостояниеФЗ",5,Ложь);
КонецПроцедуры

&НаСервере
Функция ПолучитьЛО(Расшифровка)
СписокЛО = Новый СписокЗначений;
ЗапросЛО = Новый Запрос;

ЗапросЛО.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ЛьготнаяОчередь.Период) КАК Период,
	|	ЛьготнаяОчередь.НормаРасходов.Элемент КАК МПЗ
	|ИЗ
	|	РегистрСведений.ЛьготнаяОчередь КАК ЛьготнаяОчередь
	|ГДЕ
	|	ЛьготнаяОчередь.Изделие = &Изделие
	|	И ЛьготнаяОчередь.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЛьготнаяОчередь.НормаРасходов.Элемент";
ЗапросЛО.УстановитьПараметр("Изделие",Расшифровка);
РезультатЗапроса = ЗапросЛО.Выполнить();
ВыборкаЛО = РезультатЗапроса.Выбрать();
	Пока ВыборкаЛО.Следующий() Цикл
	СписокЛО.Добавить(ВыборкаЛО.МПЗ,СокрЛП(ВыборкаЛО.МПЗ.Наименование)+" ("+ВыборкаЛО.Период+")"); 
	КонецЦикла;
Возврат(СписокЛО);
КонецФункции

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
ИмяКолонки = СокрЛП(Сред(Элемент.ТекущаяОбласть.Имя,Найти(Элемент.ТекущаяОбласть.Имя,"C"))); 
НомерКолонки = Сред(ИмяКолонки,2);
	Если Найти(НомерКолонки,":") > 0 Тогда
	НомерКолонки = Число(Лев(НомерКолонки,Найти(НомерКолонки,":")-1));	
	Иначе
    НомерКолонки = Число(НомерКолонки);
	КонецЕсли;
		Если НомерКолонки = 9 Тогда
		СтандартнаяОбработка = Ложь;
		СписокЛО = ПолучитьЛО(Расшифровка);
		Выборка = СписокЛО.ВыбратьЭлемент("Льготная очередь");
			Если Выборка <> Неопределено Тогда
			ИмяОтчета = "ОтчётПоРегиструЛьготнойОчереди";
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
			ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,НачалоГода(ТекущаяДата()),ТекущаяДата(),Новый Структура("Изделие,НормаРасходовЭлемент",Расшифровка,Выборка.Значение),"ТекущаяЛьготнаяОчередь"));
			ПараметрыФормы.Вставить("КлючВарианта","ТекущаяЛьготнаяОчередь"); 
			ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы);
			КонецЕсли; 						
		ИначеЕсли НомерКолонки = 10 Тогда
		СтандартнаяОбработка = Ложь;
		П = Новый Структура("ПЗ",Расшифровка);
		ОткрытьФорму("Отчет.ОтчетПоРемонту.Форма.ФормаОтчета",П);
		КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура СписокЛинеекПриИзменении(Элемент)
ЭтаФорма.Заголовок = "Визуализация "+СписокЛинеек;
КонецПроцедуры

&НаСервере
Процедура ВыбратьГруппуЛинеекНаСервере(ГруппаЛинеек)
СписокЛинеек.Очистить();
Выборка = Справочники.Линейки.Выбрать(ГруппаЛинеек);
	Пока Выборка.Следующий() Цикл
	СписокЛинеек.Добавить(Выборка.Ссылка);
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьГруппуЛинеек(Команда)
Результат = ОткрытьФормуМодально("Справочник.Линейки.ФормаВыбораГруппы");
	Если Результат <> Неопределено Тогда
	ВыбратьГруппуЛинеекНаСервере(Результат);
	ЭтаФорма.Заголовок = "Визуализация "+СписокЛинеек;	
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура СвернутьПоМТКПриИзменении(Элемент)
ТабДок.ПоказатьУровеньГруппировокСтрок(Не СвернутьПоМТК); 
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияПоВыпускамПриИзменении(Элемент)
ТабДок.ПоказатьУровеньГруппировокКолонок(ИнформацияПоВыпускам);
КонецПроцедуры
