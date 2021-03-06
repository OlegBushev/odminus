Перем Лог;

Функция Index() Экспорт
	
	Кластер = ОбщегоНазначения.ПолучитьКластерПоИД(ЭтотОбъект);
	Если Кластер = Неопределено Тогда
		Возврат КодСостояния(404);
	КонецЕсли;
	
	Возврат Представление(Кластер);
	
КонецФункции

Функция Edit() Экспорт
	
	Кластер = ОбщегоНазначения.ПолучитьКластерПоИД(ЭтотОбъект);
	Если Кластер = Неопределено Тогда
		Возврат КодСостояния(404);
	КонецЕсли;
	
	База = Кластер.ИнформационныеБазы().Получить(ЗначенияМаршрута["id"]);
	Если База = Неопределено Тогда
		Возврат КодСостояния(404);
	КонецЕсли;
	
	Возврат Представление("objectEdit", База);
	
КонецФункции

Функция Add() Экспорт
	
	Возврат Представление("НеРеализовано");
	
КонецФункции

Функция Auth() Экспорт
	
	Метод = ЗапросHTTP.Метод;
	Лог.Информация("Текущий метод вызова: " + Метод);
	Если Метод = "GET" Тогда
		
		// get - проверить авторизация
		Кластер = ОбщегоНазначения.ПолучитьКластерПоИД(ЭтотОбъект);
		ИнформационнаяБаза_Идентификатор = ОбщегоНазначения.ПолучитьИдентификаторИнформационнойБазыИзПараметровЗапроса(ЭтотОбъект);
		ИнформационнаяБаза = ОбщегоНазначения.ПолучитьИнформационнуюБазуПоИд(ЭтотОбъект, ИнформационнаяБаза_Идентификатор, Кластер);
		АвторизацияБазы = Новый АвторизацияИБ(ЭтотОбъект, Кластер, ИнформационнаяБаза);
		
		ТекстОшибкиАвторизации = "";
		Если АвторизацияБазы.АвторизацияПройдена(ТекстОшибкиАвторизации) Тогда
			Возврат Содержимое("Ok");
		Иначе
			ТекстОтвета = "Ошибка авторизации: " + ОбщегоНазначения.ПолучитьОписаниеОшибки(ТекстОшибкиАвторизации);
			Возврат Содержимое(ТекстОтвета);
		КонецЕсли;
		
	ИначеЕсли Метод = "POST" Тогда
		
		ТелоЗапроса = ОбщегоНазначения.ПолучитьТелоЗапросаИзПотока(ЗапросHTTP);
		Парсер = Новый ПарсерJSON;
		Данные = Парсер.ПрочитатьJSON(ТелоЗапроса);

		Кластер = ОбщегоНазначения.ПолучитьКластерПоИД(ЭтотОбъект);
		ИнформационнаяБаза_Идентификатор = ОбщегоНазначения.ПолучитьИдентификаторИнформационнойБазыИзПараметровЗапроса(ЭтотОбъект);
		ИнформационнаяБаза = ОбщегоНазначения.ПолучитьИнформационнуюБазуПоИд(ЭтотОбъект, ИнформационнаяБаза_Идентификатор, Кластер);
		АвторизацияБазы = Новый АвторизацияИБ(ЭтотОбъект, Кластер, ИнформационнаяБаза);
		АвторизацияБазы.УстановитьАдминистратораИБ(Данные.Получить("Пользователь"), Данные.Получить("Пароль"));
		ТекстОшибкиАвторизации = "";
		Если АвторизацияБазы.АвторизацияПройдена(ТекстОшибкиАвторизации) Тогда
			Возврат Содержимое("Ok");
		Иначе
			ТекстОтвета = "Ошибка авторизации: " + ОбщегоНазначения.ПолучитьОписаниеОшибки(ТекстОшибкиАвторизации);
			Возврат Содержимое(ТекстОтвета);
		КонецЕсли;
		
		Возврат Содержимое(ТелоЗапроса);
		
	КонецЕсли;
	
	Возврат КодСостояния(404);
	
КонецФункции

Лог = Логирование.ПолучитьЛог("osweb.odminus.infobase");