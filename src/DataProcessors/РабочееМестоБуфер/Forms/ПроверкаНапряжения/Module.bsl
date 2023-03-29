
&НаКлиенте
Процедура ОК(Команда)
	Если флРемонт Тогда
	Закрыть(0);
	Иначе
	Закрыть(1);	
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
Закрыть(-1);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
ПЗ = Параметры.ПЗ;
НапряжениеПослеБуфера = Параметры.НапряжениеПослеБуфера;
НаборЗаписей = РегистрыСведений.НапряжениеБатарейки.СоздатьНаборЗаписей();
НаборЗаписей.Отбор.ПЗ.Установить(ПЗ);
НаборЗаписей.Прочитать();
    Для Каждого Запись Из НаборЗаписей Цикл 
  	НапряжениеНаСтенде = Запись.НапряжениеНаСтенде;
    ДатаНапряжениеНаСтенде = Запись.Период;
    КонецЦикла; 
РазницаНапряжений = НапряжениеНаСтенде - НапряжениеПослеБуфера;
КолДней = Окр((ТекущаяДата() - ДатаНапряжениеНаСтенде)/86400,0,1);
	Если КолДней < 6 Тогда
	МинимальноеНапряжение = 3.1;
		Если НапряжениеПослеБуфера >= МинимальноеНапряжение Тогда
		Ограничение = 0.1;
			Если РазницаНапряжений > Ограничение Тогда
			Элементы.Результат.Заголовок = "Падение напряжения на батарейке больше "+Ограничение+" В! Отправляем в ремонт!";
			Элементы.Результат.ЦветТекста = Новый Цвет(255,0,0);
			флРемонт = Истина;
			Иначе
			Элементы.Результат.Заголовок = "Батарейка пригодна для использования! Передаём на упаковку!";
			КонецЕсли;
		Иначе
		Элементы.Результат.Заголовок = "Напряжение батарейки меньше "+МинимальноеНапряжение+" В! Отправляем в ремонт!";
		Элементы.Результат.ЦветТекста = Новый Цвет(255,0,0);
		флРемонт = Истина;
		КонецЕсли;
	ИначеЕсли (КолДней >= 6)и(КолДней <= 15) Тогда
	МинимальноеНапряжение = 3.10-0.01*(КолДней-5);
		Если НапряжениеПослеБуфера >= МинимальноеНапряжение Тогда
		Ограничение = 0.1+0.01*(КолДней-5);
			Если РазницаНапряжений > Ограничение Тогда
			Элементы.Результат.Заголовок = "Падение напряжения на батарейке больше "+Ограничение+" В! Отправляем в ремонт!";
			Элементы.Результат.ЦветТекста = Новый Цвет(255,0,0);
			флРемонт = Истина;
			Иначе
			Элементы.Результат.Заголовок = "Батарейка пригодна для использования! Передаём на упаковку!";
			КонецЕсли;
		Иначе
		Элементы.Результат.Заголовок = "Напряжение батарейки меньше "+МинимальноеНапряжение+" В! Отправляем в ремонт!";
		Элементы.Результат.ЦветТекста = Новый Цвет(255,0,0);
		флРемонт = Истина;
		КонецЕсли;
	Иначе
	МинимальноеНапряжение = 3.0;
		Если НапряжениеПослеБуфера >= МинимальноеНапряжение Тогда
		Элементы.Результат.Заголовок = "Батарейка пригодна для использования! Передаём на упаковку!";
		Иначе
		Элементы.Результат.Заголовок = "Напряжение батарейки меньше "+МинимальноеНапряжение+" В! Отправляем в ремонт!";
		Элементы.Результат.ЦветТекста = Новый Цвет(255,0,0);
		флРемонт = Истина;
		КонецЕсли;
    КонецЕсли;
КонецПроцедуры
