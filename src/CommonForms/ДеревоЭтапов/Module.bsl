
&НаКлиенте
Процедура ПриОткрытии(Отказ)
Результат = ПолучитьДеревоНаСервере(Ложь);
тЭлементы = ДеревоПодчиненности.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл 
   Элементы.ДеревоПодчиненности.Развернуть(тСтр.ПолучитьИдентификатор(), Истина);
   КонецЦикла;
СвернутьРекурсия(тЭлементы);
КонецПроцедуры

&НаСервере
Функция ПодчинениеНоменклатуры(СтрДерево,ЭтапСпецификации,НаДату,Предыдущий,ВсеЭтапы)
Запрос = Новый Запрос;
СписокСпецификаций = Новый СписокЗначений;

Номенклатура = Справочники.Номенклатура.ПустаяСсылка();
	Если Предыдущий Тогда
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НормыРасходовСрезПоследних.НормаРасходов.ВидЭлемента КАК ВидЭлемента,
		|	НормыРасходовСрезПоследних.Элемент КАК Элемент,
		|	СтатусыМПЗСрезПоследних.Статус КАК Статус
		|ИЗ
		|	РегистрСведений.НормыРасходов.СрезПоследних(
		|			&НаДату,
		|			Владелец = &Владелец
		|				И Элемент ССЫЛКА Справочник.Номенклатура) КАК НормыРасходовСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыМПЗ.СрезПоследних(&НаДату, ) КАК СтатусыМПЗСрезПоследних
		|		ПО НормыРасходовСрезПоследних.Элемент = СтатусыМПЗСрезПоследних.МПЗ
		|ГДЕ
		|	НормыРасходовСрезПоследних.Норма > 0
		|	И НормыРасходовСрезПоследних.НормаРасходов.ПометкаУдаления = ЛОЖЬ";
	Запрос.УстановитьПараметр("Владелец", ЭтапСпецификации);
	Запрос.УстановитьПараметр("НаДату", КонецДня(НаДату));
	Иначе	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НормыРасходовСрезПоследних.НормаРасходов.ВидЭлемента КАК ВидЭлемента,
		|	НормыРасходовСрезПоследних.Владелец КАК Элемент,
		|	СтатусыМПЗСрезПоследних.Статус КАК Статус
		|ИЗ
		|	РегистрСведений.НормыРасходов.СрезПоследних(&НаДату, Элемент = &Элемент) КАК НормыРасходовСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыМПЗ.СрезПоследних(&НаДату, ) КАК СтатусыМПЗСрезПоследних
		|		ПО НормыРасходовСрезПоследних.Элемент = СтатусыМПЗСрезПоследних.МПЗ
		|ГДЕ
		|	НормыРасходовСрезПоследних.Норма > 0
		|	И НормыРасходовСрезПоследних.НормаРасходов.ПометкаУдаления = ЛОЖЬ";
	Запрос.УстановитьПараметр("Элемент", ЭтапСпецификации);
	Запрос.УстановитьПараметр("НаДату", КонецДня(НаДату));
	КонецЕсли; 
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если СписокСпецификаций.НайтиПоЗначению(ВыборкаДетальныеЗаписи.Элемент) = Неопределено Тогда
			СписокСпецификаций.Добавить(ВыборкаДетальныеЗаписи.Элемент);
			СтрЗнч = СтрДерево.Строки.Добавить();
			СтрЗнч.Номенклатура = ВыборкаДетальныеЗаписи.Элемент;
			СтрЗнч.Статус = ВыборкаДетальныеЗаписи.Статус;
			СтрЗнч.ВидЭлемента = ВыборкаДетальныеЗаписи.ВидЭлемента;
			СтрЗнч.Наименование = глНаименованиеВСкобкахБезЭтапа(ВыборкаДетальныеЗаписи.Элемент.Наименование);
				Если ВсеЭтапы Тогда
				ПодчинениеНоменклатуры(СтрЗнч,ВыборкаДетальныеЗаписи.Элемент,НаДату,Предыдущий,ВсеЭтапы);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
Возврат(Новый Структура("Количество,Номенклатура",2,Номенклатура));
КонецФункции

&НаСервере
Функция ПолучитьДеревоНаСервере(ВсеЭтапы)
тДерево = РеквизитФормыВЗначение("ДеревоПодчиненности");
тДерево.Строки.Очистить();
Стр = тДерево.Строки.Добавить();
Стр.Номенклатура = Параметры.Номенклатура;
Стр.Статус = ПолучитьСтатус(Параметры.Номенклатура);
Стр.Наименование = глНаименованиеВСкобкахБезЭтапа(Параметры.Номенклатура.Наименование); 
Результат = ПодчинениеНоменклатуры(Стр,Параметры.Номенклатура,Параметры.НаДату,Параметры.Предыдущий,ВсеЭтапы);
тДерево.Строки.Сортировать("Наименование",Истина);
ЗначениеВРеквизитФормы(тДерево, "ДеревоПодчиненности");
Возврат(Результат);
КонецФункции

&НаСервере
Функция ПолучитьДеревоОтВыбранного(ВсеЭтапы,ВыбЭлемент)
тДерево = РеквизитФормыВЗначение("ДеревоПодчиненности");
тДерево.Строки.Очистить();
Стр = тДерево.Строки.Добавить();
Стр.Номенклатура = ВыбЭлемент;
Стр.Статус = ПолучитьСтатус(ВыбЭлемент);
Стр.Наименование = глНаименованиеВСкобкахБезЭтапа(ВыбЭлемент.Наименование); 
Результат = ПодчинениеНоменклатуры(Стр,ВыбЭлемент,Параметры.НаДату,Параметры.Предыдущий,ВсеЭтапы);
тДерево.Строки.Сортировать("Наименование",Истина);
ЗначениеВРеквизитФормы(тДерево, "ДеревоПодчиненности");
Возврат(Результат);
КонецФункции

&НаКлиенте
Процедура ПоказатьВсёДерево(Команда)
Результат = ПолучитьДеревоНаСервере(Истина);
тЭлементы = ДеревоПодчиненности.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл 
   Элементы.ДеревоПодчиненности.Развернуть(тСтр.ПолучитьИдентификатор(), Истина);
   КонецЦикла;
СвернутьРекурсия(тЭлементы);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДеревоОтВыбранногоЭлемента(Команда)
Результат = ПолучитьДеревоОтВыбранного(Истина,Элементы.ДеревоПодчиненности.ТекущиеДанные.Номенклатура);
тЭлементы = ДеревоПодчиненности.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл 
   Элементы.ДеревоПодчиненности.Развернуть(тСтр.ПолучитьИдентификатор(), Истина);
   КонецЦикла;
СвернутьРекурсия(тЭлементы);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодчиненностиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
ЭтаФорма.Закрыть(Элементы.ДеревоПодчиненности.ТекущиеДанные.Номенклатура);
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево()
тЭлементы = ДеревоПодчиненности.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл 
   Элементы.ДеревоПодчиненности.Развернуть(тСтр.ПолучитьИдентификатор(), Истина);
   КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СвернутьДерево()
тЭлементы = ДеревоПодчиненности.ПолучитьЭлементы();
СвернутьРекурсия(тЭлементы);
КонецПроцедуры
 
&НаКлиенте
Процедура СвернутьРекурсия(тЭлементы)
	Для Каждого тСтр Из тЭлементы Цикл
   	тСтрЭлементы = тСтр.ПолучитьЭлементы();
   	СвернутьРекурсия(тСтрЭлементы);
		Если тЭлементы.Количество() > 1 Тогда
		Элементы.ДеревоПодчиненности.Свернуть(тСтр.ПолучитьИдентификатор());		
		КонецЕсли; 
   	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура Развернуть(Команда)
РазвернутьДерево();
КонецПроцедуры

&НаКлиенте
Процедура Свернуть(Команда)
СвернутьДерево();
КонецПроцедуры
