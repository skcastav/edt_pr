
&НаКлиенте
Процедура ПриОткрытии(Отказ)
ДокументPDF.Прочитать(Параметры.ИмяФайла);
КраткоеИмяФайла = Параметры.ИмяФайла;
	Пока Найти(КраткоеИмяФайла,"\") > 0 Цикл
	КраткоеИмяФайла = Сред(КраткоеИмяФайла,Найти(КраткоеИмяФайла,"\")+1);
	КонецЦикла;
ЭтаФорма.Заголовок = КраткоеИмяФайла;
КонецПроцедуры
