
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Элементы.Операции.Видимость = РольДоступна("Администратор") или РольДоступна("ВводДанных");
Элементы.НормыРасходовКонтекстноеМенюИзменение.Видимость = РольДоступна("Администратор") или РольДоступна("ВводДанных"); 
НаДату = ТекущаяДата();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
ОписаниеОшибки = "";
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
   Если Не МенеджерОборудованияКлиент.ПодключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО, ОписаниеОшибки) Тогда
      ТекстСообщения = НСтр("ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
      ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , ОписаниеОшибки);
      Сообщить(ТекстСообщения);
   КонецЕсли;
НормыРасходов.Параметры.УстановитьЗначениеПараметра("НаДату",КонецДня(НаДату));
Список.Параметры.УстановитьЗначениеПараметра("НаДату",КонецДня(НаДату));
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
ПоддерживаемыеТипыВО = Новый Массив();
ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
НормыРасходов.Отбор.Элементы.Очистить();
ЭлементОтбора = НормыРасходов.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
ЭлементОтбора.Использование = Истина;
ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
ЭлементОтбора.ПравоеЗначение = Элементы.Список.ТекущаяСтрока;
	Если СкрытьНеАктуальные Тогда
	ЭлементОтбора = НормыРасходов.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Норма");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.ПравоеЗначение = 0;	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьСписок()
спНомен = Новый СписокЗначений;
Выборка = Справочники.НормыРасходов.Выбрать(,Элементы.Список.ТекущаяСтрока);
	Пока Выборка.Следующий() Цикл
	Нормы = РегистрыСведений.НормыРасходов.ПолучитьПоследнее(КонецДня(НаДату),Новый Структура("НормаРасходов",Выборка.Ссылка));
		Если Нормы.Норма > 0 Тогда
			Если ТипЗнч(Выборка.Элемент) = Тип("СправочникСсылка.Номенклатура") Тогда
			спНомен.Добавить(Выборка.Элемент.Ссылка,"["+ПолучитьСтатус(Выборка.Элемент,НаДату)+"] "+Выборка.ВидЭлемента+", "+СокрЛП(Выборка.Элемент.Наименование));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
Возврат(спНомен);
КонецФункции	

&НаКлиенте
Процедура ПредыдущийЭтап(Команда)
Результат = ОткрытьФормуМодально("ОбщаяФорма.ДеревоЭтапов",Новый Структура("Номенклатура,НаДату,Предыдущий",Элементы.Список.ТекущаяСтрока,НаДату,Истина));
	Если Результат <> Неопределено Тогда
	Элементы.Список.ТекущаяСтрока = Результат;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура СледующийЭтап(Команда)
Результат = ОткрытьФормуМодально("ОбщаяФорма.ДеревоЭтапов",Новый Структура("Номенклатура,НаДату,Предыдущий",Элементы.Список.ТекущаяСтрока,НаДату,Ложь));
	Если Результат <> Неопределено Тогда
	ТекФорма = ПолучитьФорму(ПолучитьМетаданные(ТипЗнч(Результат))+".ФормаСписка");
	ТекФорма.Открыть();
	ТекФорма.Элементы.Список.ТекущаяСтрока = Результат;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьМетаданные(ВыбТип)
Возврат(Метаданные.НайтиПоТипу(ВыбТип).ПолноеИмя());
КонецФункции

&НаСервере
Функция ПолучитьЭлементНормыРасходов(НР)
Возврат(НР.Элемент);
КонецФункции

&НаКлиенте
Процедура НормыРасходовПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущийЭлемент.Имя = "НормыРасходовСтатусПорядок" Тогда 
	Отказ = Истина;
	ЭлементНР = ПолучитьЭлементНормыРасходов(Элементы.НормыРасходов.ТекущиеДанные.Ссылка);
	ТекФорма = ПолучитьФорму(ПолучитьМетаданные(ТипЗнч(ЭлементНР))+".ФормаСписка");
	ТекФорма.Открыть();
	ТекФорма.Элементы.Список.ТекущаяСтрока = ЭлементНР;
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "Аналоги" Тогда 
	Отказ = Истина;
	Форма = ПолучитьФорму("Справочник.АналогиНормРасходов.ФормаСписка");
	Форма.Список.Параметры.УстановитьЗначениеПараметра("НаДату",КонецДня(НаДату));
	ЭлементОтбора = Форма.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.ПравоеЗначение = Элементы.НормыРасходов.ТекущиеДанные.Ссылка;
	Форма.Открыть();
	Иначе
	Отказ = Истина;
	//Форма = ПолучитьФорму("Справочник.НормыРасходов.ФормаОбъекта",Новый Структура("Ключ",Элементы.НормыРасходов.ТекущиеДанные.Ссылка));
	//Форма.ОткрытьМодально();
	//Элементы.НормыРасходов.Обновить();	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНеАктуальныеПриИзменении(Элемент)
СписокПриАктивизацииСтроки(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
ОткрытьФорму("Отчет.ПечатьСпецификации.Форма.ФормаОтчета",Новый Структура("Спецификация",Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура ПечатьДляSMD(Команда)
ОткрытьФорму("Отчет.ПечатьСпецификации.Форма.ФормаОтчета",Новый Структура("Спецификация,ДляSMD",Элементы.Список.ТекущаяСтрока,Истина));
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЕСКД(Команда)
ОткрытьФорму("Отчет.ПечатьСпецификацииЕСКД.Форма.ФормаОтчета",Новый Структура("Спецификация",Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура КопироватьСпецификацию(Команда)
ОткрытьФормуМодально("Обработка.КопированиеСпецификации.Форма",Новый Структура("Спецификация,НаДату",Элементы.Список.ТекущаяСтрока,НаДату),ЭтаФорма);
Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНормуРасхода(Команда)
П = Новый Структура("Владелец",Элементы.Список.ТекущаяСтрока);
ФормаНовогоЭлемента = ПолучитьФорму("Справочник.НормыРасходов.Форма.ФормаЭлемента",П, Элементы.Список.ТекущаяСтрока, );
ФормаНовогоЭлемента.ОткрытьМодально(); 
Элементы.НормыРасходов.Обновить();
КонецПроцедуры

&НаСервере
Процедура ОбнулитьНРНаСервере(НР,ВыбДата) 
	Если ВыбДата = НачалоДня(ТекущаяДата()) Тогда
	ДатаИзм = ТекущаяДата();
	Иначе	
	ДатаИзм = ВыбДата;	
	КонецЕсли;
ТаблицаАналогов = ОбщегоНазначенияПовтИсп.ПолучитьАналогиНормРасходов(НР,КонецДня(ВыбДата),Истина);
	Для каждого ТЧ Из ТаблицаАналогов Цикл
	РАНР = РегистрыСведений.АналогиНормРасходов.СоздатьМенеджерЗаписи();
	РАНР.Период = ДатаИзм;
	РАНР.Владелец = ТЧ.Ссылка.Владелец;
	РАНР.АналогНормыРасходов = ТЧ.Ссылка;
	РАНР.Норма = 0;
	РАНР.Записать();	
	КонецЦикла;	
РНР = РегистрыСведений.НормыРасходов.СоздатьМенеджерЗаписи();
РНР.Период = ДатаИзм;
РНР.Владелец = НР.Владелец; 
РНР.Элемент = НР.Элемент;
РНР.НормаРасходов = НР;
РНР.Норма = 0;
РНР.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ОбнулитьНорму(Команда)
ВыбДата = ТекущаяДата();
	Если ВвестиДату(ВыбДата,"Введите дату обнуления нормы",ЧастиДаты.Дата) Тогда
	ОбнулитьНРНаСервере(Элементы.НормыРасходов.ТекущиеДанные.Ссылка,ВыбДата);
	Элементы.НормыРасходов.Обновить();
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура УдалитьНаСервере(НР)
УдаляемыйЭлемент = НР.ПолучитьОбъект(); 
УдаляемыйЭлемент.Удалить();
КонецПроцедуры 

&НаКлиенте
Процедура Удалить(Команда)
	Если Вопрос("Вы действительно хотите удалить норму расхода без истории?", РежимДиалогаВопрос.ДаНет, 0) = КодВозвратаДиалога.Нет Тогда
    Возврат;
	КонецЕсли;
		Для каждого ТекСтрока из Элементы.НормыРасходов.ВыделенныеСтроки Цикл
		УдалитьНаСервере(Элементы.НормыРасходов.ДанныеСтроки(ТекСтрока).Ссылка);
		КонецЦикла;
Элементы.НормыРасходов.Обновить(); 
КонецПроцедуры

&НаСервере
Процедура КопированиеНаСервере(ВыбВладелец,НР,ВыбПозиция)
	Если НаДату = НачалоДня(ТекущаяДата()) Тогда
	ДатаИзм = ТекущаяДата();
	Иначе	
	ДатаИзм = НаДату;	
	КонецЕсли;
НоваяНР = НР.Скопировать();
НоваяНР.Владелец = ВыбВладелец;
НоваяНР.Позиция = ВыбПозиция;
НоваяНР.Записать();
Нормы = РегистрыСведений.НормыРасходов.ПолучитьПоследнее(КонецДня(НаДату),Новый Структура("НормаРасходов",НР));
РНР = РегистрыСведений.НормыРасходов.СоздатьМенеджерЗаписи();
РНР.Период = ДатаИзм;
РНР.Владелец = НоваяНР.Владелец; 
РНР.Элемент = НоваяНР.Элемент;
РНР.НормаРасходов = НоваяНР.Ссылка;
РНР.Норма = Нормы.Норма;
РНР.Записать();
КонецПроцедуры

&НаКлиенте
Процедура Копировать(Команда)
ВыбПозиция = СокрЛП(Элементы.НормыРасходов.ТекущиеДанные.Позиция);
	Если ВвестиСтроку(ВыбПозиция,"Введите новое позиционное обозначение",20) Тогда
	КопированиеНаСервере(Элементы.Список.ТекущаяСтрока,Элементы.НормыРасходов.ТекущиеДанные.Ссылка,ВыбПозиция);
	Элементы.НормыРасходов.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьНа(Команда)
	Если ОткрытьФормуМодально("Справочник.Номенклатура.Форма.ФормаИзмененияНормыРасходов",Новый Структура("НаДату,Спецификация,НормаРасходов,Норма",НаДату,Элементы.Список.ТекущаяСтрока,Элементы.НормыРасходов.ТекущиеДанные.Ссылка,Элементы.НормыРасходов.ТекущиеДанные.Норма)) <> Неопределено Тогда
	Элементы.НормыРасходов.Обновить();	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьНаБезИстории(Команда)
	Если ОткрытьФормуМодально("Справочник.Номенклатура.Форма.ФормаИзмененияНормыРасходовБезИстории",Новый Структура("Спецификация,НормаРасходов",Элементы.Список.ТекущаяСтрока,Элементы.НормыРасходов.ТекущиеДанные.Ссылка)) <> Неопределено Тогда
	Элементы.НормыРасходов.Обновить();	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КопироватьВ(Команда)
Результат = ОткрытьФормуМодально("ОбщаяФорма.КопироватьПеренестиВ",Новый Структура("НаДату,ИсходнаяСпецификация,СписокМПЗ",НаДату,Элементы.Список.ТекущаяСтрока,Элементы.НормыРасходов.ВыделенныеСтроки));
	Если Результат <> Неопределено Тогда	
	СписокПриАктивизацииСтроки(Элементы.Список.ТекущаяСтрока);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьИзвещениеНаСервере(ВыбСпец,ВыбИзвещение)
Извещение = РегистрыСведений.ИзвещенияОбИзменениях.СоздатьМенеджерЗаписи();
Извещение.Период = ТекущаяДата();
Извещение.Элемент = ВыбСпец;
Извещение.Извещение = ВыбИзвещение;
Извещение.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзвещение(Команда)
ФормаИзвещения = ПолучитьФорму("Справочник.ИзвещенияОбИзменениях.ФормаВыбора");
Результат = ФормаИзвещения.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
	ДобавитьИзвещениеНаСервере(Элементы.Список.ТекущаяСтрока,Результат);
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрИзвещений(Команда)
ОткрытьФорму("Отчет.ПросмотрИзвещений.Форма.ФормаОтчета",Новый Структура("Элемент",Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНовуюСпецификацию(Команда)
ОткрытьФорму("Обработка.ЗагрузкаНовойСпецификации.Форма");
КонецПроцедуры

&НаСервере
Функция ПолучитьНачальныйЭтап(ЭтапСпецификации,Основа)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	НормыРасходовСрезПоследних.НормаРасходов.ВидЭлемента КАК ВидЭлемента,
	|	НормыРасходовСрезПоследних.Элемент КАК Элемент,
	|	СтатусыМПЗСрезПоследних.Статус КАК Статус
	|ИЗ
	|	РегистрСведений.НормыРасходов.СрезПоследних(&НаДату, Владелец = &Владелец) КАК НормыРасходовСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыМПЗ.СрезПоследних(&НаДату, ) КАК СтатусыМПЗСрезПоследних
	|		ПО НормыРасходовСрезПоследних.Элемент = СтатусыМПЗСрезПоследних.МПЗ
	|ГДЕ
	|	НормыРасходовСрезПоследних.НормаРасходов.ВидЭлемента = &ВидЭлемента
	|	И НормыРасходовСрезПоследних.Норма > 0
	|	И НормыРасходовСрезПоследних.НормаРасходов.ПометкаУдаления = ЛОЖЬ";
Запрос.УстановитьПараметр("НаДату", КонецДня(НаДату));
Запрос.УстановитьПараметр("Владелец", ЭтапСпецификации);
Запрос.УстановитьПараметр("ВидЭлемента", Перечисления.ВидыЭлементовНормРасходов.Основа);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
    Основа = ВыборкаДетальныеЗаписи.Элемент;
	ПолучитьНачальныйЭтап(ВыборкаДетальныеЗаписи.Элемент,Основа);
	КонецЦикла;
Возврат(Основа);
КонецФункции

&НаКлиенте
Процедура КНачальномуЭтапу(Команда)
Элементы.Список.ТекущаяСтрока = ПолучитьНачальныйЭтап(Элементы.Список.ТекущаяСтрока,Элементы.Список.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Функция ПолучитьКонечныйЭтап(ЭтапСпецификации)
спНомен = Новый СписокЗначений;
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	НормыРасходовСрезПоследних.НормаРасходов.ВидЭлемента КАК ВидЭлемента,
	|	НормыРасходовСрезПоследних.Владелец КАК Владелец,
	|	СтатусыМПЗСрезПоследних.Статус КАК Статус
	|ИЗ
	|	РегистрСведений.НормыРасходов.СрезПоследних(&НаДату, Элемент = &Элемент) КАК НормыРасходовСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыМПЗ.СрезПоследних(&НаДату, ) КАК СтатусыМПЗСрезПоследних
	|		ПО НормыРасходовСрезПоследних.Элемент = СтатусыМПЗСрезПоследних.МПЗ
	|ГДЕ
	|	НормыРасходовСрезПоследних.НормаРасходов.ВидЭлемента = &ВидЭлемента
	|	И НормыРасходовСрезПоследних.Норма > 0
	|	И НормыРасходовСрезПоследних.НормаРасходов.ПометкаУдаления = ЛОЖЬ";
Запрос.УстановитьПараметр("НаДату", КонецДня(НаДату));
Запрос.УстановитьПараметр("Элемент", ЭтапСпецификации);
Запрос.УстановитьПараметр("ВидЭлемента", Перечисления.ВидыЭлементовНормРасходов.Основа);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	спНомен.Добавить(ВыборкаДетальныеЗаписи.Владелец,"["+ВыборкаДетальныеЗаписи.Статус+"] "+ВыборкаДетальныеЗаписи.ВидЭлемента+", "+СокрЛП(ВыборкаДетальныеЗаписи.Владелец.Наименование));	 
	КонецЦикла;
Возврат(спНомен);
КонецФункции

&НаКлиенте
Процедура ККонечномуЭтапу(Команда)
спНомен = Новый СписокЗначений;

спНомен.Добавить(Элементы.Список.ТекущаяСтрока);
	Пока спНомен.Количество() > 0 Цикл
		Если спНомен.Количество() > 1 Тогда
		Результат = спНомен.ВыбратьЭлемент("Выберите ветку этапов");
			Если Результат <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = Результат.Значение;
			спНомен = ПолучитьКонечныйЭтап(Результат.Значение);
			Продолжить;
			Иначе
			Возврат;
			КонецЕсли; 		
		КонецЕсли; 
	Элементы.Список.ТекущаяСтрока = спНомен[0].Значение;
	спНомен = ПолучитьКонечныйЭтап(спНомен[0].Значение);
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтатус(Команда)
ОткрытьФорму("Обработка.ИзменениеСтатусовСпецификаций.Форма",Новый Структура("ГруппаСпецификаций",Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура НаДатуПриИзменении(Элемент)
НормыРасходов.Параметры.УстановитьЗначениеПараметра("НаДату",КонецДня(НаДату));
Список.Параметры.УстановитьЗначениеПараметра("НаДату",КонецДня(НаДату));
КонецПроцедуры

&НаСервере
Функция НайтиПоБарКодуНаСервере(БарКод)
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Товар.Код = &Код";
	Если СтрДлина(СокрЛП(БарКод)) = 18 Тогда
	Запрос.УстановитьПараметр("Код", Число(Лев(БарКод,6)));
	Иначе	
	Запрос.УстановитьПараметр("Код", Число(Лев(БарКод,5)));	
	КонецЕсли;
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат(ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
	Иначе
	Возврат(Справочники.Номенклатура.ПустаяСсылка());
	КонецЕсли; 
КонецФункции

&НаКлиенте
Процедура НайтиПоБарКоду(Команда)
БарКод = "";
	Если ВвестиСтроку(БарКод,"Введите бар-код",18) Тогда
	Ссылка = НайтиПоБарКодуНаСервере(БарКод);	
		Если Не Ссылка.Пустая() Тогда
		Элементы.Список.ТекущаяСтрока = Ссылка;
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если ЭтаФорма.ВводДоступен() Тогда
	НайтиПоБарКодуНаСервере(Данные);
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПолучитьТоварнуюГруппу(Номенклатура)
Возврат(Номенклатура.Товар.ТоварнаяГруппа);
КонецФункции

&НаКлиенте
Процедура ПоказатьШаблоныПечати(Команда)
Ф = ПолучитьФорму("Справочник.ТоварныеГруппы.ФормаОбъекта",Новый Структура("Ключ",ПолучитьТоварнуюГруппу(Элементы.Список.ТекущаяСтрока)));
Ф.Открыть();
Ф.Элементы.Страницы.ТекущаяСтраница = Ф.Элементы.Шаблоны;
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоМестамХранения(Команда)
ИмяОтчета = "ОтчётПоРегиструМестаХранения";
ПараметрыФормы = Новый Структура;
ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,ТекущаяДата(),ТекущаяДата(),Новый Структура("МПЗ",Элементы.Список.ТекущаяСтрока),"ОстаткиПоСкладам"));
ПараметрыФормы.Вставить("КлючВарианта","ОстаткиПоСкладам"); 
ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы,,Истина);
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИзмененияСтатусов(Команда)
ИмяОтчета = "ОтчетПоРегиструСтатусыМПЗ";
ПараметрыФормы = Новый Структура;
ПараметрыФормы.Вставить("СформироватьПриОткрытии",Истина);
ПараметрыФормы.Вставить("ПользовательскиеНастройки",ОбщийМодульВызовСервера.ЗаполнитьПользовательскиеНастройкиОтчетаСКД(ИмяОтчета,НачалоГода(ТекущаяДата()),ТекущаяДата(),Новый Структура("МПЗ",Элементы.Список.ТекущаяСтрока),"Основной"));
ПараметрыФормы.Вставить("КлючВарианта","Основной"); 
ОткрытьФорму("Отчет." + ИмяОтчета + ".Форма", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ВедомостьДефицита(Команда)
ОткрытьФорму("Отчет.ВедомостьДефицита.Форма",Новый Структура("Номенклатура,Количество",Элементы.Список.ТекущаяСтрока,1));
КонецПроцедуры

&НаКлиенте
Процедура СравнитьСпецификации(Команда)
	Если Элементы.Список.ВыделенныеСтроки.Количество() > 1 Тогда
	ОткрытьФорму("Отчет.СравнениеСпецификаций.Форма",Новый Структура("Спецификация1,Спецификация2",Элементы.Список.ВыделенныеСтроки[0],Элементы.Список.ВыделенныеСтроки[1]));
	Иначе	
	ОткрытьФорму("Отчет.СравнениеСпецификаций.Форма",Новый Структура("Спецификация1",Элементы.Список.ВыделенныеСтроки[0]));
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПоНормативамРасходов(Команда)
ОткрытьФорму("Отчет.ОтчётПоНормативамРасходов.Форма",Новый Структура("Спецификация",Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПоИзменениямВСпецификации(Команда)
ОткрытьФорму("Отчет.ОтчётПоИзменениямВСпецификации.Форма",Новый Структура("Спецификация",Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзмененияПараметров(Команда)
ОткрытьФорму("Обработка.ЗагрузкаПараметровНоменклатуры.Форма");
КонецПроцедуры

&НаСервере
Функция ПолучитьГруппуНоменклатуры(Номен)
	Если Номен.ЭтоГруппа Тогда
	Возврат(Номен);	
	Иначе	
	Возврат(Номен.Родитель);
	КонецЕсли; 	
КонецФункции

&НаКлиенте
Процедура ИзменитьВидКанбана(Команда)
ОткрытьФорму("Обработка.ИзменениеВидовКанбанов.Форма",Новый Структура("ГруппаНоменклатуры",ПолучитьГруппуНоменклатуры(Элементы.Список.ТекущаяСтрока)));
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьКорневыеЭлементы(Команда)
ОткрытьФорму("Обработка.ЗафиксироватьКорневыеЭлементыСпецификации.Форма",Новый Структура("Спецификация",Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКорневыеХарактеристики(Команда)
ОткрытьФорму("Обработка.ЗагрузкаКорневыхХарактеристик.Форма",Новый Структура("Спецификация",Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПроект(Команда)
ОткрытьФорму("Обработка.ДобавлениеПроектаСпецификациям.Форма");
КонецПроцедуры

