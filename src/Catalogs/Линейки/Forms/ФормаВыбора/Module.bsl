
//&НаСервере
//Функция ПолучитьСписокПодразделений()
//СписокПодразделений = Новый СписокЗначений;

//	Если ПараметрыСеанса.Пользователь.Подразделения.Количество() > 0 Тогда
//		Для каждого ТЧ Из ПараметрыСеанса.Пользователь.Подразделения Цикл	
//		СписокПодразделений.Добавить(ТЧ.Подразделение);
//		КонецЦикла; 	
//	Иначе	
//	Выборка = Справочники.Подразделения.Выбрать();
//		Пока Выборка.Следующий() Цикл
//			Если Не Выборка.ПометкаУдаления Тогда
//				Если Не Выборка.ЭтоГруппа Тогда				
//				СписокПодразделений.Добавить(Выборка.Ссылка);
//				КонецЕсли;
//			КонецЕсли;		
//		КонецЦикла; 
//	КонецЕсли;
//Возврат(СписокПодразделений);
//КонецФункции
// 
//&НаКлиенте
//Процедура ПриОткрытии(Отказ)
//Список.Параметры.УстановитьЗначениеПараметра("СписокПодразделений",ПолучитьСписокПодразделений());
//КонецПроцедуры

//&НаСервере
//Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//Список.Параметры.УстановитьЗначениеПараметра("СписокПодразделений",ПолучитьСписокПодразделений());
//КонецПроцедуры
