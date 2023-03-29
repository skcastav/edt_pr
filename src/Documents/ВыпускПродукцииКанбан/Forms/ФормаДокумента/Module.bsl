
&НаКлиенте
Процедура ПриОткрытии(Отказ)
ЭтотОбъект.ТолькоПросмотр = ОбщийМодульСозданиеДокументов.ЗапретРедактирования(Объект.Ссылка,Истина,Ложь);
	Если Не ОбщийМодульВызовСервера.ДоступностьРоли("Администратор") Тогда
	Элементы.ФормаПересчитатьТабличнуюЧасть.Видимость = Ложь;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура КоличествоПриИзмененииНаСервере(СтароеКоличество)
	Для каждого ТЧ Из Объект.Списание Цикл	
	ТЧ.Количество = ТЧ.Количество/СтароеКоличество*Объект.Количество;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьТабличнуюЧасть(Команда)
СтароеКоличество = 1;
		Если ВвестиЧисло(СтароеКоличество,"Введите кол-во, на которое расчитана табличная часть.",14,3) Тогда
		КоличествоПриИзмененииНаСервере(СтароеКоличество);
		КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ВидБракаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
СтандартнаяОбработка = Ложь;
Ф = ПолучитьФорму("Справочник.КомментарииНеисправностей.ФормаВыбора");
Ф.Список.Параметры.УстановитьЗначениеПараметра("РабочееМесто",Объект.РабочееМесто);
Результат = Ф.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
	Объект.ВидБрака = Результат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
Отказ = Не ЭтаФорма.ПроверитьЗаполнение();
КонецПроцедуры

