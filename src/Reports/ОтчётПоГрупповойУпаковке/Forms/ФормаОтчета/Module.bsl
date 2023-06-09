
&НаСервере
Процедура СформироватьНаСервере() 
ТабДок.Очистить();

СписокМестХранения = Новый СписокЗначений;

	Для каждого Стр Из СписокЛинеек Цикл
	СписокМестХранения.Добавить(Стр.Значение.МестоХраненияГП);
	КонецЦикла; 
ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка");
ОблПЗ = Макет.ПолучитьОбласть("ПЗ");
ОблИзделие = Макет.ПолучитьОбласть("Изделие");
ОблИтого = Макет.ПолучитьОбласть("Итого");
ОблКонец = Макет.ПолучитьОбласть("Конец");

ОблШапка.Параметры.ДатаНач = Отчет.ДатаНач;
ОблШапка.Параметры.ДатаКон = Отчет.ДатаКон;
ОблШапка.Параметры.СписокЛинеек = СписокЛинеек;
ТабДок.Вывести(ОблШапка);

Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаХраненияОбороты.МПЗ КАК МПЗ,
	|	МестаХраненияОбороты.КоличествоПриход КАК КоличествоПриход,
	|	МестаХраненияОбороты.Регистратор КАК Регистратор,
	|	МестаХраненияОбороты.МПЗ.Родитель.Наименование КАК МПЗРодительНаименование,
	|	МестаХраненияОбороты.Регистратор.ДокументОснование КАК РегистраторДокументОснование
	|ИЗ
	|	РегистрНакопления.МестаХранения.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК МестаХраненияОбороты
	|ГДЕ
	|	МестаХраненияОбороты.МестоХранения В(&СписокМестХранения)
	|	И ТИПЗНАЧЕНИЯ(МестаХраненияОбороты.Регистратор) <> ТИП(Документ.Перепрогон)
	|
	|УПОРЯДОЧИТЬ ПО
	|	МПЗРодительНаименование,
	|	РегистраторДокументОснование
	|ИТОГИ
	|	СУММА(КоличествоПриход)
	|ПО
	|	МПЗ";	
Запрос.УстановитьПараметр("ДатаНач",Отчет.ДатаНач);
Запрос.УстановитьПараметр("ДатаКон",Отчет.ДатаКон);
Запрос.УстановитьПараметр("СписокМестХранения",СписокМестХранения);
Результат = Запрос.Выполнить();
ВыборкаИзделия = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
НомСтр = 0;
КолВсего = 0;
	Пока ВыборкаИзделия.Следующий() Цикл
	ОблИзделие.Параметры.Наимен = СокрЛП(ВыборкаИзделия.МПЗ.Наименование);
	ОблИзделие.Параметры.Кол = ВыборкаИзделия.КоличествоПриход;
	КолВсего = КолВсего + ВыборкаИзделия.КоличествоПриход;
	ТабДок.Вывести(ОблИзделие);
	ВыборкаВыпуск = ВыборкаИзделия.Выбрать();
		Пока ВыборкаВыпуск.Следующий() Цикл
		НомСтр = НомСтр + 1;
		ОблПЗ.Параметры.НомСтр = НомСтр;
		ОблПЗ.Параметры.НомерПЗ = ВыборкаВыпуск.Регистратор.ДокументОснование.Номер;
		ОблПЗ.Параметры.ПЗ = ВыборкаВыпуск.Регистратор.ДокументОснование;
		ОблПЗ.Параметры.Наимен = СокрЛП(ВыборкаВыпуск.МПЗ.Наименование);
		ОблПЗ.Параметры.Счёт = ВыборкаВыпуск.Регистратор.ДокументОснование.ДокументОснование.Счёт;
		ОблПЗ.Параметры.БарКод = ВыборкаВыпуск.Регистратор.ДокументОснование.БарКод;
		ОблПЗ.Параметры.ЗавНомер = ВыборкаВыпуск.Регистратор.ДокументОснование.БарКод;
		ТабДок.Вывести(ОблПЗ);			
		КонецЦикла;	
	КонецЦикла;
ОблИтого.Параметры.КолВсего = КолВсего;
ТабДок.Вывести(ОблИтого);
ТабДок.РазмерСтраницы = "A4";
ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
ТабДок.ПолеСверху = 0;
ТабДок.ПолеСлева = 0;
ТабДок.ПолеСнизу = 0;
ТабДок.ПолеСправа = 0;
ТабДок.РазмерКолонтитулаСверху = 0;
ТабДок.РазмерКолонтитулаСнизу = 0;			
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Отчет.ДатаНач = НачалоДня(ТекущаяДата());
Отчет.ДатаКон = ТекущаяДата();
КонецПроцедуры
