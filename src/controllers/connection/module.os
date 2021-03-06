
Функция Index() Экспорт
	
	ОбщегоНазначения.УстановитьЗаголовокСтраницы(ЭтотОбъект, "Соединения");
	
	Кластер = ОбщегоНазначения.ПолучитьКластерПоИД(ЭтотОбъект);
	ИнформационнаяБаза_Идентификатор = ОбщегоНазначения.ПолучитьИдентификаторИнформационнойБазыИзПараметровЗапроса(ЭтотОбъект);

	ПараметрыМодели = Новый Структура;
	ПараметрыМодели.Вставить("Кластер_Идентификатор", ?(Кластер = Неопределено, "", Кластер.Ид()));
	ПараметрыМодели.Вставить("ИнформационнаяБаза_Идентификатор", ?(ИнформационнаяБаза_Идентификатор = Неопределено, "", ИнформационнаяБаза_Идентификатор));
	ПараметрыМодели.Вставить("СписокИнформационныхБаз", ОбщегоНазначения.ПолучитьСписокИнформационныхБазПоКластеру(ЭтотОбъект, Кластер));
	ПараметрыМодели.Вставить("МодельДанных", ПолучитьМодельСписка());
	
	Возврат Представление("index", ПараметрыМодели);
	
КонецФункции

Функция GetModelDataList() Экспорт
	ПолучитьТолькоСтруктуру = ОбщегоНазначения.ПолучитьЗначениеПараметраЗапроса(ЭтотОбъект, "empty") <> Неопределено;
	Возврат Содержимое(ПолучитьДанныеДляСписка(ПолучитьТолькоСтруктуру));
КонецФункции

Функция CloseConnection() Экспорт

	Метод = ЗапросHTTP.Метод;
	Если Метод = "POST" Тогда

		Ответ = "";

		Кластер = ОбщегоНазначения.ПолучитьКластерПоИД(ЭтотОбъект);		
		ИнформационнаяБаза_ИД = ОбщегоНазначения.ПолучитьЗначениеПараметраЗапроса(ЭтотОбъект, "db");
		ИнформационнаяБаза = ОбщегоНазначения.ПолучитьИнформационнуюБазуПоИд(ЭтотОбъект, ИнформационнаяБаза_ИД, Кластер);
		АвторизацияБазы = Новый АвторизацияИБ(ЭтотОбъект, Кластер, ИнформационнаяБаза);
		НомерСоединения = ОбщегоНазначения.ПолучитьЗначениеПараметраЗапроса(ЭтотОбъект, "connection");
		Соединения = ИнформационнаяБаза.Соединения().Список(Новый Структура("Ид", НомерСоединения));
		Если Соединения.Количество() > 0 Тогда
			Соединение = Соединения[0]; 
			Попытка
				Соединение.Отключить();
			Исключение
				// todo: есть подозрения, что завершение работает некорректно
			КонецПопытки;
			Ответ = "ok";
		Иначе
			Ответ = "data-not-found";
		КонецЕсли;
		//Попытка
			Соединения.Отключить(НомерСоединения);
		//Исключение
		//КонецПопытки;
		Ответ = "ok";

	Иначе
		Попытка
			ВызватьИсключение("Метод: " + Метод + " не поддерживается");
		Исключение
			Ответ = ОписаниеОшибки();
		КонецПопытки;
	КонецЕсли;

	Возврат Содержимое(Ответ);

КонецФункции

Функция ПолучитьДанныеДляСписка(ТолькоСтруктура)
	
	Возврат РаботаСЭлементамиФорм.ПолучитьДанныеИнформационнойБазыДляСписка(ЭтотОбъект, "connection", ПолучитьМодельСписка(), ТолькоСтруктура);
	
КонецФункции

Функция ПолучитьМодельСписка()

	МодельСписка = Новый ПредставлениеСписка;

	МодельСписка.ПолеИдентификатора = "Ид"; 

	МодельСписка.Колонки.Добавить("НомерСоединения");
	МодельСписка.Колонки.Добавить("НомерСеанса");
	МодельСписка.Колонки.Добавить("Приложение");
	МодельСписка.Колонки.Добавить("НачалоРаботы");
	МодельСписка.Колонки.Добавить("Заблокировано");
	МодельСписка.Колонки.Добавить("Action");

	// Действия
	МодельСписка.Действия.Добавить("terminate");

	Возврат МодельСписка;
КонецФункции