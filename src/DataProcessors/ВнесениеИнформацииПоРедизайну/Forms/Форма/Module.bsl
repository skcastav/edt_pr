
&НаСервере
Процедура ВнестиИзмененияНаСервере()
Проект = Объект.Проект.ПолучитьОбъект();
Проект.ДатаРедизайна = ДатаРедизайна;
Проект.ИсключенияРедизайна.Очистить();
	Для каждого ТЧ Из ИсключенияРедизайна Цикл
	ТЧ_ИР = Проект.ИсключенияРедизайна.Добавить();
   	ТЧ_ИР.Товар = ТЧ.Товар;	
	КонецЦикла;
Проект.Записать();	
Редизайн = РегистрыСведений.Редизайн.СоздатьНаборЗаписей();
Редизайн.Отбор.Проект.Установить(Объект.Проект);
Редизайн.Записать();
	Для каждого ТЧ Из Объект.ТаблицаИзменений Цикл 
	Редизайн = РегистрыСведений.Редизайн.СоздатьМенеджерЗаписи();
	Редизайн.Проект = Объект.Проект;
	Редизайн.ЭлементЗамены = ТЧ.ЭлементЗамены;
	Редизайн.ЭлементНовый = ТЧ.ЭлементНовый;
	Редизайн.Записать(Истина);
	ТЧ.Внесено = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВнестиИзменения(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда
	ВнестиИзмененияНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПроектПриИзмененииНаСервере()
ДатаРедизайна = Объект.Проект.ДатаРедизайна;
Объект.ТаблицаИзменений.Очистить();
Запрос = Новый Запрос;

Запрос.Текст = 
	"ВЫБРАТЬ
	|	Редизайн.ЭлементЗамены КАК ЭлементЗамены,
	|	Редизайн.ЭлементНовый КАК ЭлементНовый
	|ИЗ
	|	РегистрСведений.Редизайн КАК Редизайн
	|ГДЕ
	|	Редизайн.Проект = &Проект";
Запрос.УстановитьПараметр("Проект", Объект.Проект);
РезультатЗапроса = Запрос.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	ТЧ = Объект.ТаблицаИзменений.Добавить();
	ТЧ.ЭлементЗамены = ВыборкаДетальныеЗаписи.ЭлементЗамены;
	ТЧ.ЭлементНовый = ВыборкаДетальныеЗаписи.ЭлементНовый;
	ТЧ.Внесено = Истина;
	КонецЦикла;                     
ИсключенияРедизайна.Очистить();
	Для каждого ТЧ Из Объект.Проект.ИсключенияРедизайна Цикл
	ТЧ_ИР = ИсключенияРедизайна.Добавить();
   	ТЧ_ИР.Товар = ТЧ.Товар;	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПроектПриИзменении(Элемент)
ПроектПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаРедизайнаПриИзменении(Элемент)
ДатаРедизайна = НачалоМесяца(ДатаРедизайна);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаИзмененийЭлементЗаменыПриИзменении(Элемент)
Элементы.ТаблицаИзменений.ТекущиеДанные.Внесено = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаИзмененийЭлементНовыйПриИзменении(Элемент)
Элементы.ТаблицаИзменений.ТекущиеДанные.Внесено = Ложь;
КонецПроцедуры
