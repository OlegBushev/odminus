
Функция РазобратьПараметрыЗапроса(Знач Параметры) Экспорт

	Результат = Новый Соответствие;

	Пары = СтрРазделить(Сред(Параметры,2), "&");
	Для Каждого Пара Из Пары Цикл
		Поз = СтрНайти(Пара, "=");
		Если Поз <> 0 Тогда
			Ключ = Лев(Пара, Поз-1);
			Значение = Сред(Пара, Поз+1);
			Результат.Вставить(Ключ, Значение);
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;
КонецФункции

Функция УстановитьЗаголовок(Знач Контроллер, Знач Заголовок = "") Экспорт
	
	Если ПустаяСтрока(Заголовок) Тогда
		Заголовок = "Odminus";
	КонецЕсли;

	Контроллер.ДанныеПредставления["title"] = Заголовок;

КонецФункции