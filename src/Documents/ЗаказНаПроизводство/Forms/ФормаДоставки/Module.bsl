
&НаКлиенте
Процедура КнопкаОК(Команда)
ЭтаФорма.Закрыть(Новый Структура("Грузополучатель,КартаДоставки,ТранспортнаяКомпания",Грузополучатель,КартаДоставки,ТранспортнаяКомпания));
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
Грузополучатель = Параметры.Грузополучатель;
КонецПроцедуры
