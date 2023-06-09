
&НаСервере
Процедура РаскрытьНаМПЗ(ЭтапСпецификации,КолУзла)
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_М(ЭтапСпецификации,Объект.ДокументОснование.Дата);
	Пока ВыборкаНР.Следующий() Цикл
		Если ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Материалы") Тогда
		ТЧ = Объект.ТабличнаяЧасть.Добавить();
		ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
		ТЧ.МПЗ = ВыборкаНР.Элемент;
		ТЧ.Количество = ВыборкаНР.Норма*КолУзла;
		ТЧ.ЕдиницаИзмерения = ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения;					
		Иначе
			Если Не ВыборкаНР.Элемент.Канбан.Пустая() Тогда
			ТЧ = Объект.ТабличнаяЧасть.Добавить();
			ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;
			ТЧ.МПЗ = ВыборкаНР.Элемент;
			ТЧ.Количество = ВыборкаНР.Норма*КолУзла;
			ТЧ.ЕдиницаИзмерения = ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения;					
			Продолжить;						
			КонецЕсли; 				
		РаскрытьНаМПЗ(ВыборкаНР.Элемент,ПолучитьБазовоеКоличество(ВыборкаНР.Норма,ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения)*КолУзла);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура РаскрытьНаНормыРасходов(ЭтапСпецификации,КолУзла)
ВыборкаНР = ОбщийМодульВызовСервера.ПолучитьНормыРасходовПоВладельцу_Н_М(ЭтапСпецификации,Объект.Дата);
	Пока ВыборкаНР.Следующий() Цикл
	ТЧ = Объект.ТабличнаяЧасть.Добавить();
		Если ТипЗнч(ВыборкаНР.Элемент) = Тип("СправочникСсылка.Материалы") Тогда
		ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;
		Иначе	
		ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;
		КонецЕсли;
	ТЧ.МПЗ = ВыборкаНР.Элемент;
	ТЧ.Количество = ВыборкаНР.Норма*КолУзла;
	ТЧ.ЕдиницаИзмерения = ВыборкаНР.Элемент.ОсновнаяЕдиницаИзмерения;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьОставшеесяКоличество()
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоступлениеИзПереработки.Количество
	|ИЗ
	|	Документ.ПоступлениеИзПереработки КАК ПоступлениеИзПереработки
	|ГДЕ
	|	ПоступлениеИзПереработки.ДокументОснование = &ДокументОснование
	|	И ПоступлениеИзПереработки.Проведен = ИСТИНА";
Запрос.УстановитьПараметр("ДокументОснование", Объект.ДокументОснование);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
Количество = 0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Количество = Количество + ВыборкаДетальныеЗаписи.Количество;
	КонецЦикла;
Возврат(Объект.ДокументОснование.Количество - Количество);
КонецФункции 

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
КоличествоПриИзмененииНаСервере(); 
КонецПроцедуры

&НаСервере
Процедура КоличествоПриИзмененииНаСервере()
Объект.ТабличнаяЧасть.Очистить();	
ОставшеесяКоличество = ПолучитьОставшеесяКоличество();
	Если Объект.Количество > ОставшеесяКоличество Тогда
	Объект.Количество = ОставшеесяКоличество;
	КонецЕсли;
		Если ОставшеесяКоличество > 0 Тогда
		    Если Объект.ДокументОснование.БезСпецификации Тогда
			ТЧ = Объект.ТабличнаяЧасть.Добавить();
				Если ТипЗнч(Объект.Номенклатура) = Тип("СправочникСсылка.Материалы") Тогда
				ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;	
				Иначе	
				ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;	
				КонецЕсли; 
			ТЧ.МПЗ = Объект.Номенклатура;
			ТЧ.Количество = Объект.Количество;
			ТЧ.ЕдиницаИзмерения = Объект.Номенклатура.ОсновнаяЕдиницаИзмерения;			
			Иначе	
				Если ТипЗнч(Объект.Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
				РаскрытьНаМПЗ(Объект.Номенклатура,Объект.Количество);
				Иначе
				РаскрытьНаНормыРасходов(Объект.Номенклатура,Объект.Количество);		
				КонецЕсли;		
			КонецЕсли; 
		Иначе
		Сообщить("Изделие поступило из переработки полностью!");
		КонецЕсли; 
КонецПроцедуры


&НаКлиенте
Процедура ВозвратИзПереработки1МПЗПриИзменении(Элемент)
	Если Не Элементы.ВозвратИзПереработки1.ТекущиеДанные.МПЗ.Пустая() Тогда
	ВозвратИзПереработки1МПЗПриИзмененииНаСервере(Элементы.ВозвратИзПереработки1.ТекущаяСтрока);
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ВозвратИзПереработки1МПЗПриИзмененииНаСервере(Стр)
ТЧ = Объект.ВозвратИзПереработки.НайтиПоИдентификатору(Стр);
ТЧ.ЕдиницаИзмерения = ТЧ.МПЗ.ОсновнаяЕдиницаИзмерения;
	Если ТипЗнч(ТЧ.МПЗ) = Тип("СправочникСсылка.Материалы") Тогда
	ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Материалы;	
	Иначе
	ТЧ.ВидМПЗ = Перечисления.ВидыМПЗ.Полуфабрикаты;	
	КонецЕсли;
КонецПроцедуры
