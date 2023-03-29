
Функция КомпонентаФормированияQRКода(Отказ)
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Платформа = СистемнаяИнформация.ТипПлатформы;
	
	ТекстОшибки = НСтр("ru = 'Не удалось подключить внешнюю компоненту для генерации QR-кода'");
	
	Попытка
		Если ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаПечатиQRКода", "QR") Тогда
			QRCodeGenerator = Новый("AddIn.QR.QRCodeExtension");
		Иначе
			//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , , , Отказ);
		КонецЕсли
	Исключение
		//ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки + Символы.ПС + ПодробноеПредставлениеОшибки, , , , Отказ);
	КонецПопытки;
	
	Возврат QRCodeGenerator;
	
КонецФункции

// Возвращает двоичные данные для формирования QR кода.
//
// Параметры:
//  QRСтрока         - Строка - данные, которые необходимо разместить в QR-коде.
//
//  УровеньКоррекции - Число - уровень погрешности изображения при котором данный QR-код все еще возможно 100% распознать.
//                     Параметр должен иметь тип целого и принимать одно из 4 допустимых значений:
//                     0(7% погрешности), 1(15% погрешности), 2(25% погрешности), 3(35% погрешности).
//
//  Размер           - Число - определяет длину стороны выходного изображения в пикселях.
//                     Если минимально возможный размер изображения больше этого параметра - код сформирован не будет.
//
//  ТекстОшибки      - Строка - в этот параметр помещается описание возникшей ошибки (если возникла).
//
// Возвращаемое значение:
//  ДвоичныеДанные  - буфер, содержащий байты PNG-изображения QR-кода.
// 
// Пример:
//  
//  //Выводим на печать QR-код, содержащий в себе информацию зашифрованную по УФЭБС
//
//  QRСтрока = УправлениеПечатью.ФорматнаяСтрокаУФЭБС(РеквизитыПлатежа);
//  ТекстОшибки = "";
//  ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(QRСтрока, 0, 190, ТекстОшибки);
//  Если Не ПустаяСтрока(ТекстОшибки)
//      ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
//  КонецЕсли;
//
//  КартинкаQRКода = Новый Картинка(ДанныеQRКода);
//  ОбластьМакета.Рисунки.QRКод.Картинка = КартинкаQRКода;
//
Функция ДанныеQRКода(QRСтрока, УровеньКоррекции, Размер) Экспорт
	
	Отказ = Ложь;
	
	ГенераторQRКода = КомпонентаФормированияQRКода(Отказ);
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		ДвоичныеДанныеКартинки = ГенераторQRКода.GenerateQRCode(QRСтрока, УровеньКоррекции, Размер);
	Исключение
		//ЗаписьЖурналаРегистрации(НСтр("ru = 'Формирование QR-кода'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		//	УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат ДвоичныеДанныеКартинки;
	
КонецФункции
