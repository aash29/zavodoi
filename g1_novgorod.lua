																	--[[ КОНФИГ ]]--


map_novgorod = cells[141]
goto_novgorod = vroom ('Войти в город', 'novgorod')
map_novgorod.way:add(goto_novgorod)


	
																	--[[ ТЕКСТЫ ]]--


stead.add_var { 
	novgorod_dsc = {
		prae = '';
		by_confidence = {
			'Мы вошли в город, кольчец.',
			'Слышишь, довольно много всякого шума? Они собирают свои шатры и гремят банками. Пришли недавно. Скоро уйдут. Тысячи гнусных уродцев.',
			'Ты помни: это не настоящий город. Хрупкий.'
		};
		by_sympathy = {
			'Противно быть с тобой, да еще и тут.',
			'Если ты голоден, здесь можно добыть еды.',
			'Если ты голоден, здесь можно добыть еды. Я был здесь, когда города не было. Было тихо и я ловил кроликов. Там, где идет город, становится хуже.'
		};
		post = '';
	}  
}

																	--[[ ФУНКЦИИ ]]--


contac_dsc = function ()
		p(novgorod_dsc.prae)
		p( table.concat(novgorod_dsc.by_confidence, ' ', 1, confidence+1) )
		p(novgorod_dsc.by_sympathy[sympathy+1])
		p(novgorod_dsc.post)
end;

																	--[[ ЛОКАЦИИ ]]--


novgorod = quest_room {
	nam = 'Новгород';
	dsc = function (s)
		contac_dsc()
	end;
	
	enter = function (s)
		if gvar_novgorod_arrested == nil then
			novgorod.obj:add(vway("дальше", "Так, тихо. {К нам идут.}", 'arrest'))
			s.way:disable_all()
			stead.add_var { gvar_novgorod_arrested = true }
		else
			s.way:enable_all()
		end
	end;
	
	way = { 
		vroom('К Хозяину', 'novgorod_master'),
		vroom('К Александру', 'novgorod_opp'),
		vroom('Сыграть в лотерею', 'novgorod_game'),
		vroom('Пройтись', 'novgorod_walk'),
		vroom('В Полношь', 'cells[141]'),
		};
	}
	
novgorod_master = quest_room {
	nam = 'Старт';
	dsc = 'Стартовый квест и обучающие диалоги';
	way = { };
	obj = { }
	}	
novgorod_opp = quest_room {
	nam = 'Старт';
	dsc = 'Стартовый квест и обучающие диалоги';
	way = { };
	obj = { }
	}	
novgorod_walk = quest_room {
	nam = 'Старт';
	dsc = 'Стартовый квест и обучающие диалоги';
	way = { };
	obj = { }
	}	
novgorod_game = quest_room {
	nam = 'Старт';
	dsc = 'Стартовый квест и обучающие диалоги';
	way = { };
	obj = { }
	}
	
bunker = quest_room {
	nam = 'q1';
	dsc = 'бункер';
	way = { vroom('На старт', 'cells[162]') };
	}	
	
cache2 = quest_room {
	nam = 'Схрон c2';
	dsc = 'Ну привет';
	entered = function (s, f)
		food = food + 5
		p ('Мы нашли еду, слюнявчик')
	end;
	way = { vroom('Назад', 'cells[194]') };
	}

																	--[[ ДИАЛОГИ ]]--

	
arrest = dlg {
	nam = 'В городе';
        --hideinv = true;
	entered = [[ЗЛОЙ БАС: Эй, выродки. Идёте с нами, быстро.^
				* возня *^
				ПА: Да ты че, скот, меня трогать?..^
				* возня *^
				]];
	phr = {
	    { always = true, 
			'Па, не надо. Мы идем с вами.', 
					code [[ 
						if confidence > 0 then
							p 'БАС: Ну и слава водам, пошли!^ Па: Ты уверен, кольчец? Они пытались взять нас... Смотри, я мог бы умять их.^ БАС: Поговори мне тут еще. Идём.'
						else
							p 'БАС: Ну и слава...^ Па [пыхтя]: Нет уж, сопелка, я им дам!^ [Возня, ругань и страшная тряска]^ Па: А-а-а-а-р-г-хх!..^ [всё кружится, вонючее чужое дыхание рядом]^ БАС: Вот же сука... Большого тащи к нам, говорящего я понес куда надо. [шепотом] И не рыпайся, падаль, твоему выручалке хуже будет';
						end
						pjump 'arrested'
					]]};
	    { 10,
			'Эй, что там? Кто вы?', 
				'ЗЛОЙ БАС: Да стража Хозяина, глядь! Хватит толкаться, пшли быстро.',
					code = [[ pon(11) ]]};
		{ 11, false, 
			'Что за Хозяин? Ваш? Кто это?', 
				'ДРУГОЙ ЗЛОЙ БАС: На месте узнаешь, хр...^ * Па рычит, кто-то пыхтит, всё сильно трясется *',
					code = [[prem (11) ]] };
	    { 12, 
			'Стойте! Куда мы идем?', 
                'ЗЛОЙ БАС: К Хозяину, глядь, идем! Уйми уже своего маммонта.',
					code = [[ pon(11) ]]};
		{ 'Отпустите нас, гнусные идиоты!', 
				'БАС: Зараза мелкая, я тебе дам подзуживать!^ [звук сильного удара, Па рычит и стонет]',
					[[ poff(10, 12, 14); pon(15) ]] };
		{ 14, 
			'[ Подождать ]', 
				 '[Возня, ругань и страшная тряска]^ Па: А-а-а-а-р-г-хх!..^ [всё кружится, вонючее чужое дыхание рядом]^ БАС: Вот сука. Большого тащи к нам, говорящего я понес куда надо. [шепотом] И не рыпайся, падаль, твоему выручалке хуже будет', 
					[[ pjump 'arrested' ]] };
		{ 15, false, 
			'Бей их, Па!', 
				 '[Возня, ругань и страшная тряска]^ Па: А-а-а-а-р-г-хх!..^ [всё кружится, вонючее чужое дыхание рядом]^ БАС: Вот сука. Большого тащи к нам, говорящего я понес куда надо. [шепотом] И не рыпайся, падаль, твоему выручалке хуже будет', 
					[[ pjump 'arrested' ]] };
					
		 { tag = 'arrested'};
		 { '[ слушать и ждать ]', 
				'Можно было успеть досчитать до трехсот. Было много случайных голосов вокруг, и вот -- остановились.^ Тот же голос: Ваше-ство...^ Строгий голос, из-за преграды: Привели? Иду. Вы трое, останьтесь [приближается] Ну здравствуй, лозоносец. Никогда не видел таких, как ты. Выглядишь гнусно. Кажется, раньше вы бывали крупнее, а ушей было больше. Что, подсела ваша деревенька на сухой паёк?' };
		{ 
			'Куда вы дели Поводыря? (если того оглушили при аресте)',
				'',
					code = [[  ]]};
					
		{ 
			'база: о НовГороде',
				'',
					code = [[  ]]};
								
		{ 
			'доп: как устроено с водой у них. "Ты, наверное, сходишь с ума от воплей лозы в голове"',
				'',
					code = [[  ]]};
								
		{ 
			'доп: об оппозиции',
				'',
					code = [[  ]]};
								
		{ 
			'о ГорГороде. доп: о гнильцах на кладбище и способах борьбы с ними',
				'',
					code = [[  ]]};
								
		{ 
			'доп: Хозяин - фанатик, не знающий, что на самом деле в пустене и не очень знающий, что делать с городом, если не Поход',
				'',
					code = [[  ]]};
								
		{ 
			'вы можете набрать у нас воды, если нужно',
				'',
					code = [[  ]]};
								
		{ 
			'если Па оглушен: хозяин расскажет немного о наркотиках',
				'',
					code = [[  ]]};								
		{ 
			'доп (?): вы сидели на жопе горы и брали из нее воду, обойдите гору и спросите спереди',
				'',
					code = [[  ]]};								
		{ 
			'доп: с2 - самый южный пост, дальше никто никогда не ходил; поройся там, кстати',
				'',
					code = [[  ]]};								
		{ 
			'выдача квеста q2: на случай, если уже был там',
				'',
					code = [[  ]]};								
		{ 
			'f',
				'',
					code = [[  ]]};
					
	 };
};

																
																	
																	 --[[ q1_bunker ]]--
																	 

																	  --[[ ПЕРЕМЕННЫЕ ]]--
																	  
stead.add_var{ bunker_enter_password = '123' }	
																  
stead.add_var{ bunker = list {
						con1 = list {};
						con2 = list {};
						con3 = list {};
						con4 = list {};
						buttons = list {};
						power = {
							entrance = false;
							passage = false;
							storage = false;
							toilet = false;
							hall = false;
							admin = false;
							library = false;
						};
						generalpower = false;
			 }
}																	  



																	  --[[ КОНСТРУКТОРЫ ]]--
																	  
																
																	  
function q1_panel_constructor()				--генератор "щитков"
	local v = {}
	local label = 'Щ-'..rnd(50)
	
	local x = 0
	local buttonslist = {}
	local buttons = rnd(10)+2
	for x = 1, buttons do
		table.insert(buttonslist, rnd(100))
	end
	
	v.nam = label
	v.nam2 = 'я открываю щиток...'
	v.dsc = '{'..label..'}^'

	v.buttonslist = buttonslist
	

	v.act = function(s, w)
		p 'hey'
		p (s.nam2)
		p (table.concat(s.buttonslist, ' '))
		
		q1_entrance.obj:disable_all()
			
		for x = 1, #s.buttonslist do
			q1_entrance.obj:enable(bunker.buttons[buttonslist[x]])
		end
		
		q1_entrance.obj:del(q1_con1_back)									-- "закрыть панель 1" off
		q1_entrance.obj:add(q1_con1_panel_back)							-- "закрыть щиток" on
		q1_entrance.obj:enable(q1_con1_panel_back)						-- туда же
	end;
	
	return obj(v)
end	

function q1_button_constructor(btnnum)			--генератор "кнопок"-плейсхолдеров
	local v = {}
	local label = 'Кнопочка '..btnnum..'.'
	v.nam = label
	v.dsc = '{'..label..'}'
	v.act = 'Я нажал кнопочку #'..btnnum
	return obj(v)
end
																	  
																		--[[ ФУНКЦИИ ]]--


q1_powerswitcher = function(pwrbtn)
	local value = nil
	local on = 0
	local fullboard = bunker.power
	for _, s in pairs(fullboard) do
		if s == true then
			on = on + 1
		end
	end
	
	if pwrbtn == true then
		value = false
	elseif pwrbtn == false and on >= 3 then
		bunker.power = {
							entrance = false;
							passage = false;
							storage = false;
							toilet = false;
							hall = false;
							admin = false;
							library = false;
						};
		value = false
		pn ' херак! перегруз и все отключилось'
	else
		value = true
	end
	return value
end
																	  
																	  --[[ ОБЪЕКТЫ ]]--
																	  
password = keyboard {
	nam = 'Вход в бункер';
	msg = 'ГОЛОС БЕЗ ИНТОНАЦИЙ: Внимание включен режим отладки активирован голосовой ввод и вывод вводите команды громко четко если вы обладаете постоянным или временным дефектом речи обратитесь к старшему по смене введите пароль.^';
	
}			

q1_console_1 = obj {
	nam = 'console1';
	dsc = 'Где-то в стороне у стены гудит то, что Па называет "{компьютер}".';
	obj = list {};
	act = function()
		if #bunker.con1 == 0 then		--если мы тут первый раз и панель еще не наполнена
			local panels = {}
			x = 0
			counter = rnd(5) + 3
			while x <= counter do
				x = x+1
				local newpanel = new([[q1_panel_constructor()]])		-- генерим щитки
				bunker.con1:add(newpanel)
			end
			bunker.con1:cat ({q1_powerswitch}, 4)							-- ВРЕМЕННО ТУТ Щ-57 todo

			q1_entrance.obj:disable_all()

			for x = 1, #bunker.con1 do
				q1_entrance.obj:add(bunker.con1[x])
			end;
			
		else																					--иначе
			for x = 1, #bunker.con1 do
				q1_entrance.obj:enable(bunker.con1[x])			--включаем все щитки
			end;
			
		end
		
		p 'Вот список панелей в этом шкафу:'

		q1_entrance.obj:add(q1_con1_back)								-- "закрыть консоль" on
		q1_entrance.obj:enable(q1_con1_back)							-- туда же
		q1_entrance.obj:del(q1_con1_panel_back)						-- "закрыть щиток" off
		q1_entrance.obj:disable(q1_console_1)							-- "консоль" off
	
		
	end;
}
	
q1_console_2 = obj {
	nam = 'console2';
	dsc = 'Справа стены гудит то, что Па называет "{компьютер}".';
	act = code [[ walk(panel_dlg) ]];
}
	
q1_console_3 = obj {
	nam = 'console3';
	dsc = 'Слева у стены гудит то, что Па называет "{компьютер}".';
	act = code [[ walk(panel_dlg) ]];
}
	
q1_console_4 = obj {
	nam = 'console4';
	dsc = 'В глубине зала гудит то, что Па называет "{компьютер}".';
	act = code [[ walk(panel_dlg) ]];
}

																	-- настоящий электрощиток

q1_powerswitch = obj {
	nam = 'powerswitch';
	dsc = '{Щ-57}^';
	act = function()
		p ' Йумг напрягается и раздается режущий ушки скрежет, сверху ссыпается и щиплет кожу мелкий мусор. Это какая-то панель управления или что-то вроде электрощитка -- под руками несколько механических переключателей...'
		q1_entrance.obj:disable_all()

		q1_entrance.obj:enable(q1_pwrbtn_entrance)
		q1_entrance.obj:enable(q1_pwrbtn_passage)
		q1_entrance.obj:enable(q1_pwrbtn_toilet)
		q1_entrance.obj:enable(q1_pwrbtn_storage)
		q1_entrance.obj:enable(q1_pwrbtn_hall)
		q1_entrance.obj:enable(q1_pwrbtn_admin)
		q1_entrance.obj:enable(q1_pwrbtn_library)
		q1_entrance.obj:enable(q1_pwrbtn_general)

		q1_entrance.obj:del(q1_con1_back)									-- "закрыть панель 1" off
		q1_entrance.obj:add(q1_con1_panel_back)							-- "закрыть щиток" on
		q1_entrance.obj:enable(q1_con1_panel_back)						-- туда же
	end;
}

q1_pwrbtn_entrance =  obj {
	nam = 'автомат на входе';
	dsc = function ()
		local base = '{Небольшой рубильник}'
		local arg = 'повернутый вниз'
		if bunker.power.entrance == true then
			arg = 'повернутый вверх'
		end;
	return base..', '..arg..'.^'
	end;
	
	act = function()
		pn 'я нажал ее!'
		bunker.power.entrance = q1_powerswitcher(bunker.power.entrance)
	end;
}

q1_pwrbtn_passage =  obj {
	nam = 'автомат в коридоре';
	dsc = function ()
		local base = '{Липкий от смазки металлический рычожок}'
		local arg = 'повернутый вниз'
		if bunker.power.passage == true then
			arg = 'повернутый вверх'
		end;
	return base..', '..arg..'.^'
	end;
	
	act = function()
		pn 'я нажал ее!'
		bunker.power.passage = q1_powerswitcher(bunker.power.passage)
	end;
}

q1_pwrbtn_storage =  obj {
	nam = 'автомат на складе';
	dsc = function ()
		local base = '{Пластиковый тумблер}, кажется, с пружинным взводом'
		local arg = 'в положении "вниз"'
		if bunker.power.storage == true then
			arg = 'в положении "вверх"'
		end;
	return base..', '..arg..'.^'
	end;
	
	act = function()
		pn 'я нажал ее!'
		bunker.power.storage = q1_powerswitcher(bunker.power.storage)
	end;
}

q1_pwrbtn_toilet =  obj {
	nam = 'автомат в туалете';
	dsc = function ()
		local base = '{Пластиковый тумблер}, кажется, с пружинным взводом'
		local arg = 'в положении "вниз"'
		if bunker.power.toilet == true then
			arg = 'в положении "вверх"'
		end;
	return base..', '..arg..'.^'
	end;
	
	act = function()
		pn 'я нажал ее!'
		bunker.power.toilet = q1_powerswitcher(bunker.power.toilet)
	end;
}

q1_pwrbtn_hall =  obj {
	nam = 'автомат в зале';
	dsc = function ()
		local base = '{Еще один рубильник, покрупнее}'
		local arg = 'повернут вниз'
		if bunker.power.hall == true then
			arg = 'повернут вверх'
		end;
	return base..', '..arg..'.^'
	end;
	
	act = function()
		pn 'я нажал ее!'
		bunker.power.hall = q1_powerswitcher(bunker.power.hall)
	end;
}

q1_pwrbtn_admin =  obj {
	nam = 'автомат в админке';
	dsc = function ()
		local base = '{Поворотный рычаг в форме клювика}'
		local arg = 'который смотрит вниз'
		if bunker.power.admin == true then
			arg = 'который смотрит вверх'
		end;
	return base..', '..arg..'.^'
	end;
	
	act = function()
		pn 'я нажал ее!'
		bunker.power.admin = q1_powerswitcher(bunker.power.admin)
	end;
}

q1_pwrbtn_library =  obj {
	nam = 'автомат в библиотеке';
	dsc = function ()
		local base = '{Еще один рубильник}'
		local arg = 'повернутый вниз'
		if bunker.power.library == true then
			arg = 'повернутый вверх'
		end;
	return base..', '..arg..'.^'
	end;
	
	act = function()
		pn 'я нажал ее!'
		bunker.power.library = q1_powerswitcher(bunker.power.library)
	end;
}

q1_pwrbtn_general =  obj {
	nam = 'общий автомат';
	dsc = function ()
		local base = '{Относительно большой рычаг}, тугая ручка которого обмотана чем-то липким и резиновым на ощупь'
		local arg = 'и повернута вниз'
		if bunker.generalpower == true then
			arg = 'и повернута вверх'
		end;
	return base..arg..'.^'
	end;
	
	act = function()
		pn 'я нажал ее!'
		bunker.power.entrance = q1_powerswitcher(bunker.power.entrance)
	end;
}



																


q1_con1_back = obj {					--объект-кнопка "закрыть консоль 1"
	nam = 'возврат';
	dsc = '{Закрыть панель}';
	act = function()
		p 'я закрыл "компьютер"'
		q1_entrance.obj:enable_all()														--включить все объекты комнаты
		for x = 1, #bunker.con1 do											--выключить все щитки
			q1_entrance.obj:disable(bunker.con1[x])
		end
		for x = 1, #bunker.buttons do
			q1_entrance.obj:disable(bunker.buttons[x])					--включить все кнопки
		end

		q1_entrance.obj:del(q1_con1_back)											-- "закрыть консоль" pff
		q1_entrance.obj:del(q1_con1_panel_back)									-- "закрыть щиток" pff (на всякий случай)
	end
}
		
q1_con1_panel_back = obj {					--объект-кнопка "закрыть щиток в консоли 1"
	nam = 'возврат';
	dsc = '{Закрыть щиток}';
	act = function()
		p 'я вернулся к выбору щитка'
		q1_entrance.obj:disable_all()														--все выключить
		
		for x = 1, #bunker.con1 do
			q1_entrance.obj:enable(bunker.con1[x])						--включить щитки
		end
		
		q1_entrance.obj:del(q1_con1_panel_back)									--"закрыть щиток" off
		q1_entrance.obj:add(q1_con1_back)											--"закрыть консоль" on
		q1_entrance.obj:enable(q1_con1_back)										--туда же
	end
}		

status_bunker = stat {
	nam = 'бункер';
	disp = function(s)
		pn ''
		for r, v in pairs(bunker.power) do
			pn (r, ': ', v)
		end
	end
}

														  
																	  
																	  --[[ ДИАЛОГИ ]]--

																	  
																  
																	  --[[ ЛОКАЦИИ ]]--


q1_outside = quest_room {									--у спуска в бункер
	nam = 'Вход в бункер';
	dsc = function(s)
		if visited(q1_outside) == 1 then
			p "'ГОЛОС БЕЗ ИНТОНАЦИЙ: Внимание включен режим отладки активирован голосовой ввод и вывод вводите команды громко четко если вы обладаете постоянным или временным дефектом речи обратитесь к старшему по смене введите пароль'^ Па: Ты знаешь, что тут нужно делать?^ ГОЛОС БЕЗ ИНТОНАЦИЙ: Введен неверный пароль попыток после последнего входа двести пятьдесят шесть переполнение.^"
			p [[{xwalk(password)|-- Знаю.^}]];
			p [[{xwalk(map_bunker)|-- Нет. Пошли отсюда.}]];
		elseif password.text == bunker_enter_password then
			p 'ГОЛОС БЕЗ ЭМОЦИЙ: Введен правильный пароль добро пожаловать соблюдайте инструкции никому не сообщайте пароль'
			map_bunker.way:del(goto_bunker)	
			goto_bunker = vroom ('Вход в бункер', 'q1_entrance')
			map_bunker.way:add(goto_bunker)	
			walk(q1_entrance)
			p [[{xwalk(q1_entrance)|Войти в бункер.}]];
		else
			p "'Па (шепотом): Сейчас опять будет спрашивать. Ты придумал?^"
			p [[{xwalk(password)|Да.^}]];
			p [[{xwalk(map_bunker)|Нет. Пошли отсюда.}]];
		end
	end;
	
	enter = function(s)
		--xwalk(password)
	end;
	
	way = { 
		};
}
	
q1_entrance = quest_room {										--проходная
	nam = 'Проходная';
	dsc = 'Мы в проходоной';
	obj = list { 'q1_console_1' };
	

	enter = function (s)
		if visited() == nil then
			p 'я здесь первый раз'
			
			for x = 1, 100 do		--создаем сто фейковых кнопок для панелей
				local newbnt = new([[q1_button_constructor(]]..x..[[)]])
				bunker.buttons:add(newbnt)		--пишем их в общий gvar
				s.obj:add(newbnt)									--добавляем в объект комнаты
				s.obj:disable(newbnt)								--выключаем пока				
			end

			local pwrbtns = {q1_pwrbtn_entrance, 
								q1_pwrbtn_passage, 
								q1_pwrbtn_toilet, 
								q1_pwrbtn_storage,
								q1_pwrbtn_hall,
								q1_pwrbtn_admin,
								q1_pwrbtn_library,
								q1_pwrbtn_general}
			
			for btn = 1, #pwrbtns do
				s.obj:add(pwrbtns[btn])					--добавляем в объект комнаты
				s.obj:disable(pwrbtns[btn])					--добавляем в объект комнаты
				bunker.buttons:add(pwrbtns[btn])					--добавляем в объект комнаты
			end
			
		else
			p 'в углу гудит электрошкаф'
		end

		take(status_bunker)

	end;
	
	exit = '';
	
	way = { 
		'q1_passage',
		'map_bunker',
	};
	
}																		
	
q1_passage = quest_room {
	nam = 'Коридор';
	dsc = '';
	obj = { 'q1_console_2',
			'q1_console_3',
		   };
	enter = '';
	exit = '';
	way = { 
		'q1_entrance',
		'q1_storage',
		'q1_toilet',
		'q1_hall',
	};
}		
	
q1_storage = quest_room {
	nam = 'Склад';
	dsc = '';
	obj = { };
	enter = '';
	exit = '';
	way = { 
		'q1_passage',
	};
}																		

q1_toilet = quest_room {
	nam = 'Туалет';
	dsc = '';
	obj = { };
	enter = '';
	exit = '';
	way = { 
		'q1_passage',
	};
}		

q1_hall = quest_room {
	nam = 'Холл';
	dsc = '';
	obj = { 'q1_console_4' };

	enter = '';
	exit = '';
	way = { 
		'q1_administration',
		'q1_library',
		'q1_passage',
	};
}																		

q1_administration = quest_room {
	nam = 'Администрация';
	dsc = '';
	obj = { };
	enter = '';
	exit = '';
	way = { 
		'q1_hall',
	};
}		

q1_library = quest_room {
	nam = 'Библиотека';
	dsc = '';
	obj = { };
	enter = '';
	exit = '';
	way = { 
		'q1_hall',
	};
}		
																	
																

																
map_bunker = cells[109]
goto_bunker = vroom ('Вход в бункер', 'q1_outside')
map_bunker.way:add(goto_bunker)			















						