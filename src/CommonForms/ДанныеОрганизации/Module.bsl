&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//Руководитель = ПолучитьЗначениеПериодическойКонстанты("Руководитель",ТекущаяДата());
//ГлавныйБухгалтер = ПолучитьЗначениеПериодическойКонстанты("ГлавныйБухгалтер",ТекущаяДата());
//ЗаместительДиректораПоПроизводству = ПолучитьЗначениеПериодическойКонстанты("ЗаместительДиректораПоПроизводству",ТекущаяДата());
//НачальникСТК = ПолучитьЗначениеПериодическойКонстанты("НачальникСТК",ТекущаяДата());
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
 //   Если ПолучитьЗначениеПериодическойКонстанты("Руководитель",ТекущаяДата()) <> Руководитель Тогда
 //   ПериодическиеКонстанты = РегистрыСведений.ПериодическиеКонстанты.СоздатьМенеджерЗаписи();
 //   ПериодическиеКонстанты.Период = ТекущаяДата();
 //   ПериодическиеКонстанты.ПериодическаяКонстанта = Перечисления.ПериодическиеКонстанты.Руководитель;
 //   ПериодическиеКонстанты.ЗначениеКонстанты = Руководитель;
 //   ПериодическиеКонстанты.Записать(Истина);	
 //   КонецЕсли;

 //   Если ПолучитьЗначениеПериодическойКонстанты("ГлавныйБухгалтер",ТекущаяДата()) <> ГлавныйБухгалтер Тогда
 //   ПериодическиеКонстанты = РегистрыСведений.ПериодическиеКонстанты.СоздатьМенеджерЗаписи();
 //   ПериодическиеКонстанты.Период = ТекущаяДата();
 //   ПериодическиеКонстанты.ПериодическаяКонстанта = Перечисления.ПериодическиеКонстанты.ГлавныйБухгалтер;
 //   ПериодическиеКонстанты.ЗначениеКонстанты = ГлавныйБухгалтер;
 //   ПериодическиеКонстанты.Записать(Истина);
 //   КонецЕсли;
 //
 //   Если ПолучитьЗначениеПериодическойКонстанты("ЗаместительДиректораПоПроизводству",ТекущаяДата()) <> ЗаместительДиректораПоПроизводству Тогда 
 //   ПериодическиеКонстанты = РегистрыСведений.ПериодическиеКонстанты.СоздатьМенеджерЗаписи();
 //   ПериодическиеКонстанты.Период = ТекущаяДата();
 //   ПериодическиеКонстанты.ПериодическаяКонстанта = Перечисления.ПериодическиеКонстанты.ЗаместительДиректораПоПроизводству;
 //   ПериодическиеКонстанты.ЗначениеКонстанты = ЗаместительДиректораПоПроизводству;
 //   ПериодическиеКонстанты.Записать(Истина);
 //   КонецЕсли;

 //   Если ПолучитьЗначениеПериодическойКонстанты("НачальникСТК",ТекущаяДата()) <> НачальникСТК Тогда 
 //   ПериодическиеКонстанты = РегистрыСведений.ПериодическиеКонстанты.СоздатьМенеджерЗаписи();
 //   ПериодическиеКонстанты.Период = ТекущаяДата();
 //   ПериодическиеКонстанты.ПериодическаяКонстанта = Перечисления.ПериодическиеКонстанты.НачальникСТК;
 //   ПериодическиеКонстанты.ЗначениеКонстанты = НачальникСТК;
 //   ПериодическиеКонстанты.Записать(Истина);
 //   КонецЕсли;
КонецПроцедуры
