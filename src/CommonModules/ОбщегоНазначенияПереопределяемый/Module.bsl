////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает соответствие имен параметров сеанса и обработчиков для их инициализации.
//
// Для задания обработчиков параметров сеанса следует использовать шаблон:
// Обработчики.Вставить("<ИмяПараметраСеанса>|<НачалоИмениПараметраСеанса*>", "Обработчик");
//
// Примечание. Символ '*'используется в конце имени параметра сеанса и обозначает,
//             что один обработчик будет вызван для инициализации всех параметров сеанса
//             с именем, начинающимся на слово НачалоИмениПараметраСеанса
//
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
	//ПодключаемоеОборудование
	Обработчики.Вставить("РабочееМестоКлиента", "МенеджерОборудованияВызовСервера.УстановитьПараметрыСеансаПодключаемогоОборудования");
	//Конец ПодключаемоеОборудование
	
	//РегламентированнаяОтчетность
	ОбщегоНазначенияБРО.ОбработчикиИнициализацииПараметровСеанса(Обработчики);
	//Конец РегламентированнаяОтчетность
	
КонецПроцедуры

// Объекты метаданных, содержимое которых не должно учитывается в бизнес-логике приложения.
//
// Описание:
//   Для документа "Реализация товаров и услуг" настроены подсистемы "Версионирование объектов" и "Свойства".
//   При этом документ может быть указан в других объектах метаданных - документах или регистрах.
//   Часть ссылок имеют значение для бизнес-логики (например движения по регистрам) и должны выводиться пользователю.
//   Другая часть ссылок - "техногенные" ссылки на документ из данных подсистем "Версионирование объектов" и "Свойства",
//     должны скрываться от пользователя при поиске ссылок на объект. 
//     Например, при анализе мест использования или в подсистеме запрета редактирования ключевых реквизитов.
//   Список таких "техногенных" объектов нужно перечислить в этой процедуре.
//
// Важно:
//   Для избежания появления пустых "битых" ссылок рекомендуется предусмотреть процедуру очистки указанных объектов
//   метаданных.
//   Для измерений регистров сведений - с помощью установки флажка "Ведущее",
//     тогда запись регистра сведений будет удалена вместе с удалением ссылки, указанной в измерении.
//   Для других реквизитов указанных объектов - с помощью подписки на событие ПередУдалением всех типов объектов
//   метаданных, которые могут быть записаны в реквизиты указанных объектов метаданных.
//     В обработчике необходимо найти "техногенные" объекты, в реквизитах которых указана ссылка удаляемого объекта,
//     и выбрать как именно очищать ссылку: очищать значение реквизита, удалять строку таблицы или удалять весь объект.
//
// Параметры:
//  ИсключенияПоискаСсылок - Массив - Объекты метаданных или их реквизиты, содержимое которых не должно учитывается в
//                                    бизнес-логике приложения.
//   * ОбъектМетаданных - Объект метаданных или его реквизит.
//   * Строка - Полное имя объекта метаданных или его реквизита.
//
// Примеры:
//	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов);
//	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов.Реквизиты.АвторВерсии);
//	ИсключенияПоискаСсылок.Добавить("РегистрСведений.ВерсииОбъектов");
//
Процедура ПриДобавленииИсключенийПоискаСсылок(ИсключенияПоискаСсылок) Экспорт
	
КонецПроцедуры

// Устанавливает текстовое описание предмета.
//
// Параметры:
//  СсылкаНаПредмет  - ЛюбаяСсылка - объект ссылочного типа.
//  Представление	 - Строка - сюда необходимо поместить текстовое описание.
Процедура УстановитьПредставлениеПредмета(СсылкаНаПредмет, Представление) Экспорт
	
КонецПроцедуры

// Доопределяет переименования тех объектов метаданных, которые невозможно
// автоматически найти по типу, но ссылки на которые требуется сохранять
// в базе данных (например: подсистемы, роли).
//
// Подробнее см. комментарий к процедуре ДобавитьПереименование общего модуля ОбщегоНазначения.
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	Библиотека = Метаданные.Имя;
	
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ХозяйственныеОперации",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ВедениеУчета",
		Библиотека);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.УчетНалогиОтчетность.Подсистема.РегистрыФормированияОтчетныхДанных",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НалогНаПрибыль.Подсистема.РегистрыФормированияОтчетныхДанных",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.УчетНалогиОтчетность.Подсистема.РегистрыПромежуточныхРасчетов",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НалогНаПрибыль.Подсистема.РегистрыПромежуточныхРасчетов",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.УчетНалогиОтчетность.Подсистема.РегистрыУчетаСостоянияЕдиницыНалоговогоУчета",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НалогНаПрибыль.Подсистема.РегистрыУчетаСостоянияЕдиницыНалоговогоУчета",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.УчетНалогиОтчетность.Подсистема.РегистрыУчетаХозяйственныхОпераций",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НалогНаПрибыль.Подсистема.РегистрыУчетаХозяйственныхОпераций",
		Библиотека);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.ОтчетыДляРуководителя",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ОтчетыДляРуководителя",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.ОтчетыДляРуководителя.Подсистема.Продажи",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ОтчетыДляРуководителя.Подсистема.Продажи",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПокупателями",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПокупателями",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.13.3",
		"Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПоставщиками",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПоставщиками",
		Библиотека);
	
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.БанкИКасса",
		"Подсистема.БанкИКасса82",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.БанкИКасса.Подсистема.Банк",
		"Подсистема.БанкИКасса82.Подсистема.Банк",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.БанкИКасса.Подсистема.Касса",
		"Подсистема.БанкИКасса82.Подсистема.Касса",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.БанкИКасса.Подсистема.ДенежныеДокументы",
		"Подсистема.БанкИКасса82.Подсистема.ДенежныеДокументы",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.БанкИКасса.Подсистема.СправочникиИНастройки",
		"Подсистема.БанкИКасса82.Подсистема.СправочникиИНастройки",
		Библиотека);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ПокупкиИПродажи",
		"Подсистема.ПокупкиИПродажи82",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ПокупкиИПродажи.Подсистема.Продажи",
		"Подсистема.ПокупкиИПродажи82.Подсистема.Продажи",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ПокупкиИПродажи.Подсистема.Покупки",
		"Подсистема.ПокупкиИПродажи82.Подсистема.Покупки",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ПокупкиИПродажи.Подсистема.РасчетыСКонтрагентами",
		"Подсистема.ПокупкиИПродажи82.Подсистема.РасчетыСКонтрагентами",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ПокупкиИПродажи.Подсистема.АвизоРасчеты",
		"Подсистема.ПокупкиИПродажи82.Подсистема.АвизоРасчеты",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ПокупкиИПродажи.Подсистема.СправочникиИНастройки",
		"Подсистема.ПокупкиИПродажи82.Подсистема.СправочникиИНастройки",
		Библиотека);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.Производство",
		"Подсистема.Производство82",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.Производство.Подсистема.ВыпускПродукции",
		"Подсистема.Производство82.Подсистема.ВыпускПродукции",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.Производство.Подсистема.Переработка",
		"Подсистема.Производство82.Подсистема.Переработка",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.Производство.Подсистема.ПередачаВПереработку",
		"Подсистема.Производство82.Подсистема.ПередачаВПереработку",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.Производство.Подсистема.СправочникиИНастройки",
		"Подсистема.Производство82.Подсистема.СправочникиИНастройки",
		Библиотека);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ОсновныеСредстваИНМА",
		"Подсистема.ОсновныеСредстваИНМА82",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ОсновныеСредстваИНМА.Подсистема.ПоступлениеОсновныхСредств",
		"Подсистема.ОсновныеСредстваИНМА82.Подсистема.ПоступлениеОсновныхСредств",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ОсновныеСредстваИНМА.Подсистема.УчетОсновныхСредств",
		"Подсистема.ОсновныеСредстваИНМА82.Подсистема.УчетОсновныхСредств",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ОсновныеСредстваИНМА.Подсистема.ВыбытиеОсновныхСредств",
		"Подсистема.ОсновныеСредстваИНМА82.Подсистема.ВыбытиеОсновныхСредств",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ОсновныеСредстваИНМА.Подсистема.АмортизацияОС",
		"Подсистема.ОсновныеСредстваИНМА82.Подсистема.АмортизацияОС",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ОсновныеСредстваИНМА.Подсистема.АвизоОС",
		"Подсистема.ОсновныеСредстваИНМА82.Подсистема.АвизоОС",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ОсновныеСредстваИНМА.Подсистема.НематериальныеАктивы",
		"Подсистема.ОсновныеСредстваИНМА82.Подсистема.НематериальныеАктивы",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ОсновныеСредстваИНМА.Подсистема.АмортизацияНМА",
		"Подсистема.ОсновныеСредстваИНМА82.Подсистема.АмортизацияНМА",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.ОсновныеСредстваИНМА.Подсистема.СправочникиИНастройки",
		"Подсистема.ОсновныеСредстваИНМА82.Подсистема.СправочникиИНастройки",
		Библиотека);
	
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СотрудникиИЗарплата",
		"Подсистема.СотрудникиИЗарплата82",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СотрудникиИЗарплата.Подсистема.КадровыйУчет",
		"Подсистема.СотрудникиИЗарплата82.Подсистема.КадровыйУчет",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СотрудникиИЗарплата.Подсистема.ОбменДаннымиСЗУП",
		"Подсистема.СотрудникиИЗарплата82.Подсистема.ОбменДаннымиСЗУП",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СотрудникиИЗарплата.Подсистема.Зарплата",
		"Подсистема.СотрудникиИЗарплата82.Подсистема.Зарплата",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СотрудникиИЗарплата.Подсистема.НДФЛ",
		"Подсистема.СотрудникиИЗарплата82.Подсистема.НДФЛ",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СотрудникиИЗарплата.Подсистема.СтраховыеВзносы",
		"Подсистема.СотрудникиИЗарплата82.Подсистема.СтраховыеВзносы",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СотрудникиИЗарплата.Подсистема.ЗарплатныеПроекты",
		"Подсистема.СотрудникиИЗарплата82.Подсистема.ЗарплатныеПроекты",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СотрудникиИЗарплата.Подсистема.ОбменДаннымиСЗиК",
		"Подсистема.СотрудникиИЗарплата82.Подсистема.ОбменДаннымиСЗиК",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СотрудникиИЗарплата.Подсистема.СправочникиИНастройки",
		"Подсистема.СотрудникиИЗарплата82.Подсистема.СправочникиИНастройки",
		Библиотека);
	
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность",
		"Подсистема.УчетНалогиОтчетность82",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ВедениеУчета",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ВедениеУчета",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.АвизоПрочее",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.АвизоПрочее",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ЗакрытиеПериода",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ЗакрытиеПериода",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ЗакрытиеПериода.Подсистема.СправкиРасчеты",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ЗакрытиеПериода.Подсистема.СправкиРасчеты",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ЗакрытиеПериода.Подсистема.СправкиРасчеты.Подсистема.БухгалтерскийУчет",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ЗакрытиеПериода.Подсистема.СправкиРасчеты.Подсистема.БухгалтерскийУчет",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ЗакрытиеПериода.Подсистема.СправкиРасчеты.Подсистема.БухгалтерскийИНалоговыйУчет",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ЗакрытиеПериода.Подсистема.СправкиРасчеты.Подсистема.БухгалтерскийИНалоговыйУчет",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ЗакрытиеПериода.Подсистема.СправкиРасчеты.Подсистема.НалоговыйУчетПоНалогуНаПрибыль",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ЗакрытиеПериода.Подсистема.СправкиРасчеты.Подсистема.НалоговыйУчетПоНалогуНаПрибыль",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.Отчетность",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.Отчетность",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НДС",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.НДС",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.УСН",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.УСН",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.Патент",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.Патент",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ДоходыИРасходыИП",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ДоходыИРасходыИП",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.СтраховыеВзносыИП",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.СтраховыеВзносыИП",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НалогНаПрибыль",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.НалогНаПрибыль",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НалогНаПрибыль.Подсистема.РегистрыФормированияОтчетныхДанных",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.НалогНаПрибыль.Подсистема.РегистрыФормированияОтчетныхДанных",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НалогНаПрибыль.Подсистема.РегистрыПромежуточныхРасчетов",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.НалогНаПрибыль.Подсистема.РегистрыПромежуточныхРасчетов",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НалогНаПрибыль.Подсистема.РегистрыУчетаСостоянияЕдиницыНалоговогоУчета",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.НалогНаПрибыль.Подсистема.РегистрыУчетаСостоянияЕдиницыНалоговогоУчета",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НалогНаПрибыль.Подсистема.РегистрыУчетаХозяйственныхОпераций",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.НалогНаПрибыль.Подсистема.РегистрыУчетаХозяйственныхОпераций",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.НалогНаИмущество",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.НалогНаИмущество",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ТранспортныйНалог",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ТранспортныйНалог",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ОтчетыДляРуководителя",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ОтчетыДляРуководителя",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ОтчетыДляРуководителя.Подсистема.Продажи",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ОтчетыДляРуководителя.Подсистема.Продажи",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ОтчетыДляРуководителя.Подсистема.ДенежныеСредства",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ОтчетыДляРуководителя.Подсистема.ДенежныеСредства",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПокупателями",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПокупателями",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПоставщиками",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПоставщиками",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ОтчетыДляРуководителя.Подсистема.ОбщиеПоказатели",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ОтчетыДляРуководителя.Подсистема.ОбщиеПоказатели",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.КонтролируемыеСделки",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.КонтролируемыеСделки",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.КалендарьБухгалтера",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.КалендарьБухгалтера",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.РегистрыБУСубъектовМалогоПредпринимательства",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.РегистрыБУСубъектовМалогоПредпринимательства",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.УчетНалогиОтчетность.Подсистема.ЗаполнениеФормСтатистики",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ЗаполнениеФормСтатистики",
		Библиотека);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СправочникиИНастройкиУчета",
		"Подсистема.СправочникиИНастройкиУчета82",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СправочникиИНастройкиУчета.Подсистема.НастройкиУчета",
		"Подсистема.СправочникиИНастройкиУчета82.Подсистема.НастройкиУчета",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СправочникиИНастройкиУчета.Подсистема.НачальныеОстатки",
		"Подсистема.СправочникиИНастройкиУчета82.Подсистема.НачальныеОстатки",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СправочникиИНастройкиУчета.Подсистема.ДоходыИРасходы",
		"Подсистема.СправочникиИНастройкиУчета82.Подсистема.ДоходыИРасходы",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СправочникиИНастройкиУчета.Подсистема.ПереходСПредыдущихВерсий",
		"Подсистема.СправочникиИНастройкиУчета82.Подсистема.ПереходСПредыдущихВерсий",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.СправочникиИНастройкиУчета.Подсистема.ИзменениеНалоговогоРежима",
		"Подсистема.СправочникиИНастройкиУчета82.Подсистема.ИзменениеНалоговогоРежима",
		Библиотека);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.НоменклатураИСклад",
		"Подсистема.НоменклатураИСклад82",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.НоменклатураИСклад.Подсистема.Склад",
		"Подсистема.НоменклатураИСклад82.Подсистема.Склад",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.НоменклатураИСклад.Подсистема.Инвентаризация",
		"Подсистема.НоменклатураИСклад82.Подсистема.Инвентаризация",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.НоменклатураИСклад.Подсистема.Цены",
		"Подсистема.НоменклатураИСклад82.Подсистема.Цены",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.НоменклатураИСклад.Подсистема.СпецодеждаИИнвентарь",
		"Подсистема.НоменклатураИСклад82.Подсистема.СпецодеждаИИнвентарь",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.НоменклатураИСклад.Подсистема.АвизоМПЗ",
		"Подсистема.НоменклатураИСклад82.Подсистема.АвизоМПЗ",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.30.1",
		"Подсистема.НоменклатураИСклад.Подсистема.СправочникиИНастройки",
		"Подсистема.НоменклатураИСклад82.Подсистема.СправочникиИНастройки",
		Библиотека);
	
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ОтчетыДляРуководителя",
		"Подсистема.Руководителю82",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ОтчетыДляРуководителя.Подсистема.Продажи",
		"Подсистема.Руководителю82.Подсистема.Продажи",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ОтчетыДляРуководителя.Подсистема.ДенежныеСредства",
		"Подсистема.Руководителю82.Подсистема.ДенежныеСредства",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПокупателями",
		"Подсистема.Руководителю82.Подсистема.РасчетыСПокупателями",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПоставщиками",
		"Подсистема.Руководителю82.Подсистема.РасчетыСПоставщиками",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.УчетНалогиОтчетность82.Подсистема.ОтчетыДляРуководителя.Подсистема.ОбщиеПоказатели",
		"Подсистема.Руководителю82.Подсистема.ОбщиеПоказатели",
		Библиотека);
	
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.Отчеты.Подсистема.ОтчетыДляРуководителя",
		"Подсистема.Руководителю",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.Отчеты.Подсистема.ОтчетыДляРуководителя.Подсистема.Продажи",
		"Подсистема.Руководителю.Подсистема.Продажи",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.Отчеты.Подсистема.ОтчетыДляРуководителя.Подсистема.ДенежныеСредства",
		"Подсистема.Руководителю.Подсистема.ДенежныеСредства",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.Отчеты.Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПокупателями",
		"Подсистема.Руководителю.Подсистема.РасчетыСПокупателями",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.Отчеты.Подсистема.ОтчетыДляРуководителя.Подсистема.РасчетыСПоставщиками",
		"Подсистема.Руководителю.Подсистема.РасчетыСПоставщиками",
		Библиотека);
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"3.0.33.1",
		"Подсистема.Отчеты.Подсистема.ОтчетыДляРуководителя.Подсистема.ОбщиеПоказатели",
		"Подсистема.Руководителю.Подсистема.ОбщиеПоказатели",
		Библиотека);
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователей.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	// Конец ИнтернетПоддержкаПользователей
	
	// БЗКБ
	ЗарплатаКадры.ЗаполнитьТаблицуПереименованияОбъектовМетаданных(Итог);
	
КонецПроцедуры

// Возвращает структуру параметров, необходимых для работы клиентского кода
// при запуске конфигурации, т.е. в обработчиках событий
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
// Важно: при запуске недопустимо использовать команды сброса кэша
// повторно используемых модулей, иначе запуск может привести
// к непредсказуемым ошибкам и лишним серверным вызовам
//
// Параметры:
//   Параметры - Структура - (возвращаемое значение) структура параметров работы клиента при запуске.
//
// Пример реализации:
//   Для установки параметров работы клиента можно использовать шаблон:
//
//     Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
//
Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователей.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	// Конец ИнтернетПоддержкаПользователей
	
	ОбщегоНазначенияБП.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	
	ОбщегоНазначенияБРО.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	
КонецПроцедуры

// Возвращает структуру параметров, необходимых для работы клиентского кода
// конфигурации.
//
// Параметры:
//   Параметры - Структура - (возвращаемое значение) структура параметров работы клиента.
//
// Пример реализации:
//   Для установки параметров работы клиента можно использовать шаблон:
//
//     Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПараметрыРаботыКлиента(Параметры) Экспорт
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователей.ПараметрыРаботыКлиента(Параметры);
	// Конец ИнтернетПоддержкаПользователей
	
КонецПроцедуры

// Возвращает структуру параметров, необходимых для работы клиентского кода
// конфигурации при завершении, т.е. в обработчиках:
// - ПередЗавершениемРаботыСистемы,
// - ПриЗавершенииРаботыСистемы
//
// Параметры:
//   Параметры - Структура - (возвращаемое значение) структура параметров работы клиента при завершении.
//
// Пример реализации:
//   Для установки параметров работы клиента при завершении можно использовать шаблон:
//
//     Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПараметрыРаботыКлиентаПриЗавершении(Параметры) Экспорт
	
КонецПроцедуры

// Позволяет настроить общие параметры подсистемы.
//
// Параметры:
//  ОбщиеПараметры - Структура - структура со свойствами:
//      * ИмяФормыПерсональныхНастроек            - Строка - имя формы для редактирования персональных настроек.
//                                                           Ранее определялись в ОбщегоНазначенияПереопределяемый.ИмяФормыПерсональныхНастроек.
//      * МинимальноНеобходимаяВерсияПлатформы    - Строка - полный номер версии платформы для запуска программы. Например, "8.3.4.365".
//                                                           Ранее определялись в ОбщегоНазначенияПереопределяемый.ПолучитьМинимальноНеобходимуюВерсиюПлатформы.
//      * РаботаВПрограммеЗапрещена               - Булево - Начальное значение Ложь.
//      * ЗапрашиватьПодтверждениеПриЗавершенииПрограммы - Булево - по умолчанию Истина. Если установить Ложь, то 
//                                                                  подтверждение при завершении работы программы не будет запрашиваться, 
//                                                                  если явно не разрешить в персональных настройках программы.
//      * ОтключитьСправочникИдентификаторыОбъектовМетаданных - Булево - отключает заполнение справочника
//              ИдентификаторыОбъектовМетаданных, процедуры выгрузки и загрузки элементов справочника в узлах РИБ.
//              Для частичного встраивании отдельных функций библиотеки в конфигурации без постановки на поддержку.
//
Процедура ПриОпределенииОбщихПараметровБазовойФункциональности(ОбщиеПараметры) Экспорт
	
	ОбщиеПараметры.Вставить("МинимальноНеобходимаяВерсияПлатформы", "8.3.5.1383");
	ОбщиеПараметры.Вставить("РаботаВПрограммеЗапрещена", Истина);
КонецПроцедуры

// Обработчик события "Перед загрузкой идентификаторов объектов метаданных в подчиненном РИБ узле".
// Выполняет заполнение настроек размещения сообщения обмена данными или
// нестандартную загрузку идентификаторов объектов метаданных из главного узла.
//
// Параметры:
//  СтандартнаяОбработка - Булево, начальное значение Истина, если установить Ложь, тогда стандартная загрузка
//                идентификаторов объектов метаданных с помощью подсистемы ОбменДанными будет пропущена (тоже
//                будет и в случае, если подсистемы ОбменДанными нет).
//
Процедура ПередЗагрузкойИдентификаторовОбъектовМетаданныхВПодчиненномРИБУзле(СтандартнаяОбработка) Экспорт
	
	ГлавныйУзел = ПланыОбмена.ГлавныйУзел();
	Если ЗначениеЗаполнено(ГлавныйУзел) Тогда 
		ОбменДаннымиОбновлениеСПредыдущейРедакции.ПеренестиНастройкиОбменаДанными(ГлавныйУзел, ГлавныйУзел);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет структуру массивами поддерживаемых версий всех подлежащих версионированию программных интерфейсов,
// используя в качестве ключей имена программных интерфейсов.
// Обеспечивает функциональность Web-сервиса InterfaceVersion.
// При внедрении надо поменять тело процедуры так, чтобы она возвращала актуальные наборы версий (см. пример.ниже).
//
// Параметры:
// СтруктураПоддерживаемыхВерсий - Структура:
//  Ключ - Имя программного интерфейса,
//  Значение - Массив(Строка) - поддерживаемые версии программного интерфейса.
//
// Пример реализации:
//
//  // СервисПередачиФайлов
//  МассивВерсий = Новый Массив;
//  МассивВерсий.Добавить("1.0.1.1");
//  МассивВерсий.Добавить("1.0.2.1"); 
//  СтруктураПоддерживаемыхВерсий.Вставить("СервисПередачиФайлов", МассивВерсий);
//  // Конец СервисПередачиФайлов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(СтруктураПоддерживаемыхВерсий) Экспорт
	
	//РегламентированнаяОтчетность
	ОбщегоНазначенияБРО.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(СтруктураПоддерживаемыхВерсий);
	// Конец РегламентированнаяОтчетность
	
	// СтатистикаПоПоказателям
	СтатистикаПоПоказателямСлужебный.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(СтруктураПоддерживаемыхВерсий);
	// Конец СтатистикаПоПоказателям
	
КонецПроцедуры

// Параметры функциональных опций, действие которых распространяется на командный интерфейс и рабочий стол.
//   Например, если значения функциональной опции хранятся в ресурсах регистра сведений,
//   то параметры функциональных опций могут определять условия отборов по измерениям регистра,
//   которые будут применяться при чтении значения этой функциональной опции.
//
// Параметры:
//   ОпцииИнтерфейса - Структура - Значения параметров функциональных опций, установленных для командного интерфейса.
//       Ключ элемента структуры определяет имя параметра, а значение элемента - текущее значение параметра.
//
// См. также:
//   Методы глобального контекста ПолучитьФункциональнуюОпциюИнтерфейса(),
//   УстановитьПараметрыФункциональныхОпцийИнтерфейса() и ПолучитьПараметрыФункциональныхОпцийИнтерфейса().
//
Процедура ПриОпределенииПараметровФункциональныхОпцийИнтерфейса(ОпцииИнтерфейса) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Устаревший программный интерфейс.

// Устарела. Будет удалена в следующей редакции. См. ПриОпределенииОбщихПараметровБазовойФункциональности.
Процедура ИмяФормыПерсональныхНастроек(ИмяФормы) Экспорт
	
КонецПроцедуры

// Устарела. Будет удалена в следующей редакции. См. ПриОпределенииОбщихПараметровБазовойФункциональности.
Процедура ПолучитьМинимальноНеобходимуюВерсиюПлатформы(ПараметрыПроверки) Экспорт
	
КонецПроцедуры

// Устарела. Будет удалена в следующей редакции. См. ПриДобавленииПереименованийОбъектовМетаданных.
Процедура ЗаполнитьТаблицуПереименованияОбъектовМетаданных(Итог) Экспорт
	
КонецПроцедуры

// Устарела. Следует использовать ПриДобавленииОбработчиковУстановкиПараметровСеанса.
// Возвращает соответствие имен параметров сеанса и обработчиков для их инициализации.
//
Функция ОбработчикиИнициализацииПараметровСеанса() Экспорт
	
	// Для задания обработчиков параметров сеанса следует использовать шаблон:
	// Обработчики.Вставить("<ИмяПараметраСеанса>|<НачалоИмениПараметраСеанса*>", "Обработчик");
	//
	// Примечание. Символ '*'используется в конце имени параметра сеанса и обозначает,
	//             что один обработчик будет вызван для инициализации всех параметров сеанса
	//             с именем, начинающимся на слово НачалоИмениПараметраСеанса.
	//
	
	Обработчики = Новый Соответствие;
	
	Возврат Обработчики;
	
КонецФункции

// Устарела. Следует использовать ПриДобавленииИсключенийПоискаСсылок.
//
// Объекты метаданных, содержимое которых не должно учитывается в бизнес-логике приложения.
//
// Описание:
//   Для документа "Реализация товаров и услуг" настроены подсистемы "Версионирование объектов" и "Свойства".
//   При этом документ может быть указан в других объектах метаданных - документах или регистрах.
//   Часть ссылок имеют значение для бизнес-логики (например движения по регистрам) и должны выводиться пользователю.
//   Другая часть ссылок - "техногенные" ссылки на документ из данных подсистем "Версионирование объектов" и "Свойства",
//     должны скрываться от пользователя при поиске ссылок на объект. 
//     Например, при анализе мест использования или в подсистеме запрета редактирования ключевых реквизитов.
//   Список таких "техногенных" объектов нужно перечислить в этой функции.
//
// Важно:
//   Для избежания появления пустых "битых" ссылок рекомендуется предусмотреть процедуру очистки указанных объектов
//   метаданных.
//   Для измерений регистров сведений - с помощью установки флажка "Ведущее",
//     тогда запись регистра сведений будет удалена вместе с удалением ссылки, указанной в измерении.
//   Для других реквизитов указанных объектов - с помощью подписки на событие ПередУдалением всех типов объектов
//   метаданных, которые могут быть записаны в реквизиты указанных объектов метаданных.
//     В обработчике необходимо найти "техногенные" объекты, в реквизитах которых указана ссылка удаляемого объекта,
//     и выбрать как именно очищать ссылку: очищать значение реквизита, удалять строку таблицы или удалять весь объект.
//
// Например:
//	Массив.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов);
//	Массив.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов.Реквизиты.АвторВерсии);
//	Массив.Добавить("РегистрСведений.ВерсииОбъектов");
//
// Возвращаемое значение:
//   Массив - Объекты метаданных или их реквизиты, содержимое которых не должно учитывается в бизнес-логике приложения.
//       * ОбъектМетаданных - Объект метаданных или его реквизит.
//       * Строка - Полное имя объекта метаданных или его реквизита.
//
Функция ПолучитьИсключенияПоискаСсылок() Экспорт
	
	Массив = Новый Массив;
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти
