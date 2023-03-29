
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
МетаСправочники = Метаданные.Справочники;
	Для Каждого МетаОбъект Из МетаСправочники Цикл
		Если МетаОбъект.Владельцы.Количество() = 0 Тогда
		СписокСправочников.Добавить(МетаОбъект.Имя,МетаОбъект.Синоним);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПроверитьНаОграничение(ЭлементСправочника)
	Для каждого ТЧ Из ТаблицаРеквизитов Цикл
	 	Если ЗначениеЗаполнено(ТЧ.ЗначениеСравнения) Тогда
			Если ТЧ.Реквизит = "ВнутреннийКод" Тогда
			ЗначениеРеквизита = ЗначениеВСтрокуВнутр(ЭлементСправочника);
			Иначе	 
			ЗначениеРеквизита = ЭлементСправочника[ТЧ.Реквизит];
			КонецЕсли;
				Если ТЧ.ВидСравнения = ВидСравнения.Содержит Тогда
					Если Найти(ЗначениеРеквизита,ТЧ.ЗначениеСравнения) = 0 Тогда	
					Возврат(Ложь);
					КонецЕсли; 
				ИначеЕсли ТЧ.ВидСравнения = ВидСравнения.НеСодержит Тогда
					Если Найти(ЗначениеРеквизита,ТЧ.ЗначениеСравнения) > 0 Тогда	
					Возврат(Ложь);
					КонецЕсли;
				ИначеЕсли ТЧ.ВидСравнения = ВидСравнения.Равно Тогда
					Если ЗначениеРеквизита <> ТЧ.ЗначениеСравнения Тогда	
					Возврат(Ложь);
					КонецЕсли;
				ИначеЕсли ТЧ.ВидСравнения = ВидСравнения.НеРавно Тогда
					Если ЗначениеРеквизита = ТЧ.ЗначениеСравнения Тогда	
					Возврат(Ложь);
					КонецЕсли;
				ИначеЕсли ТЧ.ВидСравнения = ВидСравнения.ВСписке Тогда
					Если ТЧ.ЗначениеСравнения.НайтиПоЗначению(ЗначениеРеквизита) = Неопределено Тогда	
					Возврат(Ложь);
					КонецЕсли;
				ИначеЕсли ТЧ.ВидСравнения = ВидСравнения.НеВСписке Тогда
					Если ТЧ.ЗначениеСравнения.НайтиПоЗначению(ЗначениеРеквизита) <> Неопределено Тогда	
					Возврат(Ложь);
					КонецЕсли;
				ИначеЕсли ТЧ.ВидСравнения = ВидСравнения.Больше Тогда
					Если ЗначениеРеквизита <= ТЧ.ЗначениеСравнения Тогда	
					Возврат(Ложь);
					КонецЕсли;
				ИначеЕсли ТЧ.ВидСравнения = ВидСравнения.БольшеИлиРавно Тогда
					Если ЗначениеРеквизита < ТЧ.ЗначениеСравнения Тогда	
					Возврат(Ложь);
					КонецЕсли;
				ИначеЕсли ТЧ.ВидСравнения = ВидСравнения.Меньше Тогда
					Если ЗначениеРеквизита >= ТЧ.ЗначениеСравнения Тогда	
					Возврат(Ложь);
					КонецЕсли;
				ИначеЕсли ТЧ.ВидСравнения = ВидСравнения.МеньшеИлиРавно Тогда
					Если ЗначениеРеквизита > ТЧ.ЗначениеСравнения Тогда	
					Возврат(Ложь);
					КонецЕсли;
				КонецЕсли;
		КонецЕсли;  	
	КонецЦикла;
Возврат(Истина);   
КонецФункции 

&НаСервере
Процедура СформироватьНаСервере()
ТабДок.Очистить();
ОбъектЗн = РеквизитФормыВЗначение("Отчет");
Макет = ОбъектЗн.ПолучитьМакет("Макет");

ОблШапка = Макет.ПолучитьОбласть("Шапка|Реквизит");
ОблГруппа = Макет.ПолучитьОбласть("Группа|Реквизит");
ОблСтрока = Макет.ПолучитьОбласть("Строка|Реквизит");

Присоединить = Ложь; 
	Для каждого ТЧ Из ТаблицаРеквизитов Цикл
		Если ТЧ.Пометка Тогда
		ОблШапка.Параметры.Реквизит = ТЧ.Синоним;
			Если Не Присоединить Тогда
			ТабДок.Вывести(ОблШапка);
			Присоединить = Истина;
			Иначе	
			ТабДок.Присоединить(ОблШапка);
			КонецЕсли; 
		КонецЕсли; 	
	КонецЦикла;
		Если Метаданные.Справочники.Найти(ВыбСправочник).Иерархический Тогда
			Если ЗначениеЗаполнено(ГруппаСправочника) Тогда
			Выборка = Справочники[ВыбСправочник].ВыбратьИерархически(ГруппаСправочника);
			Иначе	
			Выборка = Справочники[ВыбСправочник].ВыбратьИерархически();
			КонецЕсли;			
		Иначе	
			Если ЗначениеЗаполнено(ГруппаСправочника) Тогда
			Выборка = Справочники[ВыбСправочник].Выбрать(ГруппаСправочника);
			Иначе	
			Выборка = Справочники[ВыбСправочник].Выбрать();
			КонецЕсли;			
		КонецЕсли;
			Если (ЗначениеЗаполнено(ГруппаСправочника))и(Не ВыводитьБезГрупп) Тогда
			Присоединить = Ложь;
				Для каждого ТЧ Из ТаблицаРеквизитов Цикл
					Если ТЧ.Пометка Тогда
						Если Не Присоединить Тогда
						ОблГруппа.Параметры.Группа = ГруппаСправочника;
						ТабДок.Вывести(ОблГруппа);
						Присоединить = Истина;
						Иначе	
						ОблГруппа.Параметры.Группа = "";
						ТабДок.Присоединить(ОблГруппа);
						КонецЕсли; 
					КонецЕсли; 	
				КонецЦикла;
			ТабДок.НачатьГруппуСтрок(0,Истина);
			КонецЕсли;
ТекГруппа = Неопределено;
ТекУровень = 0; 	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ЭтоГруппа Тогда
			Если Не ВыводитьБезГрупп Тогда
				Если ТекГруппа <> Неопределено Тогда
					Если Выборка.УровеньВВыборке() <= ТекУровень Тогда
						Пока ТекУровень >= Выборка.УровеньВВыборке() Цикл
						ТабДок.ЗакончитьГруппуСтрок();
						ТекУровень = ТекУровень - 1;
						КонецЦикла; 
					КонецЕсли; 		
				КонецЕсли; 
			Присоединить = Ложь;
				Для каждого ТЧ Из ТаблицаРеквизитов Цикл
					Если ТЧ.Пометка Тогда
						Если Не Присоединить Тогда
						ОблГруппа.Параметры.Группа = Выборка["Наименование"];
						ТабДок.Вывести(ОблГруппа);
						Присоединить = Истина;
						Иначе
						ОблГруппа.Параметры.Группа = "";	
						ТабДок.Присоединить(ОблГруппа);
						КонецЕсли; 
					КонецЕсли; 	
				КонецЦикла;
			ТекГруппа = Выборка;
			ТекУровень = Выборка.УровеньВВыборке();
			ТабДок.НачатьГруппуСтрок(ТекУровень,Истина);
			КонецЕсли;					
		Иначе
			Если Не ВыводитьБезГрупп Тогда
				Если ТекГруппа <> Неопределено Тогда
					Если Выборка.УровеньВВыборке() <= ТекУровень Тогда
						Пока ТекУровень >= Выборка.УровеньВВыборке() Цикл
						ТабДок.ЗакончитьГруппуСтрок();
						ТекУровень = ТекУровень - 1;
						КонецЦикла; 
					КонецЕсли;
				КонецЕсли;
					Если Выборка.УровеньВВыборке() = 0 Тогда
					ТекГруппа = Неопределено;
					КонецЕсли; 
			КонецЕсли;
				Если Не ПроверитьНаОграничение(Выборка) Тогда
				Продолжить;
				КонецЕсли;
		Присоединить = Ложь; 
			Для каждого ТЧ Из ТаблицаРеквизитов Цикл
				Если ТЧ.Пометка Тогда
					Если ТЧ.Реквизит = "ВнутреннийКод" Тогда
					ОблСтрока.Параметры.Реквизит = ЗначениеВСтрокуВнутр(Выборка.Ссылка);
					Иначе	 
					ОблСтрока.Параметры.Реквизит = Выборка[ТЧ.Реквизит];
					КонецЕсли;
						Если Не Присоединить Тогда
						ТабДок.Вывести(ОблСтрока);
						Присоединить = Истина;
						Иначе	
						ТабДок.Присоединить(ОблСтрока);
						КонецЕсли; 
				КонецЕсли; 	
			КонецЦикла;
		КонецЕсли; 				
	КонецЦикла;
		Если ЗначениеЗаполнено(ГруппаСправочника) Тогда
			Если Не ВыводитьБезГрупп Тогда
			ТабДок.ЗакончитьГруппуСтрок();
			КонецЕсли;
		Иначе
			Если Не ВыводитьБезГрупп Тогда
				Если ТекГруппа <> Неопределено Тогда
					Если Выборка.УровеньВВыборке() < ТекУровень Тогда
						Пока ТекУровень > Выборка.УровеньВВыборке() Цикл
						ТабДок.ЗакончитьГруппуСтрок();
						ТекУровень = ТекУровень - 1;
						КонецЦикла; 
					КонецЕсли;		
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	СформироватьНаСервере();
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	Для каждого ТЧ Из ТаблицаРеквизитов Цикл
	ТЧ.Пометка = Истина;	
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе(Команда)
	Для каждого ТЧ Из ТаблицаРеквизитов Цикл
	ТЧ.Пометка = Ложь;	
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СправочникПриИзмененииНаСервере()
ТаблицаРеквизитов.Очистить();
ТЧ = ТаблицаРеквизитов.Добавить();	
ТЧ.Реквизит = "ВнутреннийКод";
ТЧ.Синоним = "Внутренний код";                                                                                                     
ТЧ.ТипЗначения = Новый ОписаниеТипов("Строка");
	Для каждого Реквизит Из Метаданные.Справочники.Найти(ВыбСправочник).СтандартныеРеквизиты Цикл
	ТЧ = ТаблицаРеквизитов.Добавить();
	ТЧ.Реквизит = Реквизит.Имя;
	ТЧ.Синоним = Реквизит.Имя;	
	ТЧ.ТипЗначения = Реквизит.Тип;
	КонецЦикла;
		Для Каждого ОбщРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
		ОбщийРеквизит = ОбщРеквизит.Состав.Найти(Метаданные.Справочники.Найти(ВыбСправочник));
			Если ОбщийРеквизит <> Неопределено Тогда 
				Если ОбщийРеквизит.Использование = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать Тогда
				ТЧ = ТаблицаРеквизитов.Добавить();
				ТЧ.Реквизит = ОбщРеквизит.Имя;
				ТЧ.Синоним = ОбщРеквизит.Имя;	
				ТЧ.ТипЗначения = ОбщРеквизит.Тип;
				КонецЕсли; 
			КонецЕсли;
		КонецЦикла; 
			Для каждого Реквизит Из Метаданные.Справочники.Найти(ВыбСправочник).Реквизиты Цикл
			ТЧ = ТаблицаРеквизитов.Добавить();	
			ТЧ.Реквизит = Реквизит.Имя;
			ТЧ.Синоним = Реквизит.Синоним;	
			ТЧ.ТипЗначения = Реквизит.Тип;
			КонецЦикла;
Элементы.ГруппаСправочника.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка."+ВыбСправочник);
КонецПроцедуры

&НаКлиенте
Процедура СправочникПриИзменении(Элемент)
СправочникПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыбСправочникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
ВыбСправочник = СписокСправочников.ВыбратьЭлемент("Выберите справочник",ВыбСправочник).Значение;
	Если ЗначениеЗаполнено(ВыбСправочник) Тогда
	СправочникПриИзмененииНаСервере();
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРеквизитовЗначениеСравненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если (Элементы.ТаблицаРеквизитов.ТекущиеДанные.ВидСравнения = ВидСравнения.ВСписке)или
		 (Элементы.ТаблицаРеквизитов.ТекущиеДанные.ВидСравнения = ВидСравнения.НеВСписке)или
		 (Элементы.ТаблицаРеквизитов.ТекущиеДанные.ВидСравнения = ВидСравнения.ВСпискеПоИерархии)или
		 (Элементы.ТаблицаРеквизитов.ТекущиеДанные.ВидСравнения = ВидСравнения.НеВСпискеПоИерархии) Тогда
	СЗ = Новый СписокЗначений;

	СЗ.ТипЗначения = Элементы.ТаблицаРеквизитов.ТекущиеДанные.ТипЗначения;	
	Элементы.ТаблицаРеквизитов.ТекущиеДанные.ЗначениеСравнения = СЗ;
	Иначе
	Элементы.ТаблицаРеквизитов.ТекущиеДанные.ЗначениеСравнения = Элементы.ТаблицаРеквизитов.ТекущиеДанные.ТипЗначения.ПривестиЗначение();
	КонецЕсли; 
КонецПроцедуры
