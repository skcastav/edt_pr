
&НаСервере
Функция ПолучитьКодПроекта()
Возврат(Объект.Проект.Код);
КонецФункции

&НаСервере
Функция ПолучитьНаименованиеПроекта()
Возврат(Объект.Проект.Наименование);
КонецФункции

&НаКлиенте
Процедура ПроектПриИзменении(Элемент)
Объект.Код = ПолучитьКодПроекта();
Объект.Наименование = ПолучитьНаименованиеПроекта();
КонецПроцедуры
