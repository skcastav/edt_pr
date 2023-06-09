
&НаСервере
Процедура ПолучитьСообщения()
Макет = Обработки.ФормаСообщения.ПолучитьМакет("Макет"); 
ОблСообщение = Макет.ПолучитьОбласть("Сообщение");
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	СообщенияПользователям.Отправитель,
	|	СообщенияПользователям.Получатель,
	|	СообщенияПользователям.Сообщение,
	|	СообщенияПользователям.ТекстСообщения,
	|	СообщенияПользователям.Время,
	|	СообщенияПользователям.Период
	|ИЗ
	|	РегистрСведений.СообщенияПользователям КАК СообщенияПользователям
	|ГДЕ
	|	(СообщенияПользователям.Получатель = &Сотрудник
	|			ИЛИ СообщенияПользователям.Получатель = &ПустойСотрудник)
	|	И СообщенияПользователям.Время <= &ТекущееВремя";
Запрос.УстановитьПараметр("ПустойСотрудник", Справочники.Сотрудники.ПустаяСсылка());
Запрос.УстановитьПараметр("Сотрудник", ПараметрыСеанса.Пользователь);
Запрос.УстановитьПараметр("ТекущееВремя", ТекущаяДата());
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если Не ВыборкаДетальныеЗаписи.Получатель.Пустая() Тогда
			Если ВыборкаДетальныеЗаписи.Получатель <> ПараметрыСеанса.Пользователь Тогда
			Продолжить;
			КонецЕсли;			
		КонецЕсли; 
	ОблСообщение.Параметры.Отправитель = ВыборкаДетальныеЗаписи.Отправитель;
	ОблСообщение.Параметры.ДатаСообщения = ВыборкаДетальныеЗаписи.Время;
	ОблСообщение.Параметры.Сообщение = ВыборкаДетальныеЗаписи.Сообщение;
	ОблСообщение.Параметры.ТекстСообщения = ВыборкаДетальныеЗаписи.ТекстСообщения;
	ПараметрыСообщения = Новый Структура("Отправитель,Тема",ВыборкаДетальныеЗаписи.Отправитель,ВыборкаДетальныеЗаписи.Сообщение);
	ОблСообщение.Параметры.ПараметрыСообщения = ПараметрыСообщения;
	ТабДок.Вывести(ОблСообщение);
	Получатель = ВыборкаДетальныеЗаписи.Получатель;
	Объект.Отправитель = ВыборкаДетальныеЗаписи.Отправитель;
		Если Не Получатель.Пустая() Тогда
		НаборЗаписей = РегистрыСведений.СообщенияПользователям.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Период.Установить(ВыборкаДетальныеЗаписи.Период);
		НаборЗаписей.Отбор.Отправитель.Установить(Объект.Отправитель);
		НаборЗаписей.Отбор.Получатель.Установить(Получатель);
		НаборЗаписей.Записать();  	
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
КлючУникальности = Новый УникальныйИдентификатор();
ПолучитьСообщения();
КонецПроцедуры

&НаСервере
Процедура ОтправитьСообщение(ТекстСообщения,ПараметрыСообщения)
Сообщение = РегистрыСведений.СообщенияПользователям.СоздатьМенеджерЗаписи();
Сообщение.Период = ТекущаяДата();
Сообщение.Отправитель = ПараметрыСеанса.Пользователь;
Сообщение.Получатель = ПараметрыСообщения.Отправитель;
Сообщение.Сообщение = "Re: "+ПараметрыСообщения.Тема;
Сообщение.ТекстСообщения = ТекстСообщения;
Сообщение.Время = ТекущаяДата();
Сообщение.Срок = 0;
Сообщение.Записать(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
ТекстСообщения = "";
	Если ВвестиСтроку(ТекстСообщения,"Введите сообщение",0,Истина) Тогда
	ОтправитьСообщение(ТекстСообщения,Расшифровка);	
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеЗакрытияОповещения(Параметры) Экспорт
Ф = ПолучитьФорму("Обработка.ФормаСообщения.Форма.Форма");
Ф.Открыть();	 
КонецПроцедуры
