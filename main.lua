-- $Name: Zavodoi$
-- $Version: 0.02$
-- $Author: Algeron$
instead_version "2.4.0"

require "hideinv"
require "para" -- для оформления
require "dash"
require "quotes"
require "dbg" -- для отладки
require "./modules/keyboard"
require "xact"

game.forcedsc = true; -- атрибут, чтобы описание сцены не пряталось *без game можно добавлять в каждой сцене)

global {
	
	dolgota = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q'};
	cells = list {};
	youarehere = 0;
	turn = 0;
	time = 4;
	time_list = {'Утр', 'Дно', 'Ночер', 'Ночь'};
	
	food = 100;
	hunger = 4;
	
	water = 100;
	thirst = 0;
	
	confidence = 0;
	sympathy = 0;
	}
	
stead.phrase_prefix = '* ';
																	--[[ ФУНКЦИИ ]]--
 
function dowser_dreams()
	if thirst > 2 then
		p 'Фальшивый сон лозоходца'
	else
		p 'Нормальный сон лозоходца'
	end
end 


function my_sympathy(x)
	local temp_s = sympathy + x
	if temp_s <= 0 then
		sympathy = 0
	elseif temp_s >= 2 then
		sympathy = 2
	else
		sympathy = temp_s
	end
end

function my_confidence(x)
	local temp_c = confidence + x
	if temp_c <= 0 then
		confidence = 0
	elseif temp_c >= 2 then
		confidence = 2
	else
		confidence = temp_c
	end
end


																--[[ ГЕНЕРАТОР КАРТЫ ]]--

function myconstructor()
	local v = {}
	v.x = adress[2]
	v.y = adress[3]
	v.idx = adress[4]
	v.adress = adress[1]
	youarehere = adress[4]
	v.nam = table.concat(adress, ' ')
	v.dsc = 'Мы где-то в пустоши.'

	
	local north = vroom('Север', 'cells['..tostring(youarehere-17)..']')
	local south = vroom('Юг', 'cells['..tostring(youarehere+17)..']')
	local west = vroom('Запад', 'cells['..tostring(youarehere-1)..']')
	local east = vroom('Восток', 'cells['..tostring(youarehere+1)..']')
	local hunger_scene = vroom('Голод', 'hunger_scene')

	local no_north = { 'b2', 'h2', 'j2', 'k2', 'l2', 'm3', 'n3', 'o4', 'p5', 'f6', 'q6', 'g7', "h8", "i8", "j8", 'a9' }
	local no_south = { 'f4', 'g4', 'h4', 'j4', 'i6', 'a7', '', '', '', '', '', '', '', '', '', '',  }
	local no_west = { 'c1', 'i1', 'i5', 'i6', 'k5', 'k6', 'k7', 'b8', '', '', '', '', '', '', '', '', '', '',  }
	local no_east = { 'a1', 'g1', 'i1', 'l2', 'n3', 'o4', 'p5', 'e5', 'i5', 'f6', 'i6', 'g7', '', '', '', '', '', '',  }
	
	local glowing_weak = {'c7', 'c8', 'c9', 'c10', 'c11', 'd7', 'd11', 'e7', 'e11', 'f7', 'f11', 'g7', 'g8', 'g9', 'g10', 'g11', 'h8', 'i8', 'j8', 'k8', 'k7', 'k6', 'k5', 'k4', 'j4', 'i4', 'h4', 'g4', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', }
	local glowing_strong = {'d8', 'd9', 'd10', 'e8', 'e10', 'f8', 'f9', 'f10', 'i5', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''}
	

	v.obj = list {'withe_s', 'withe_w'}
	v.obj:disable('withe_s')
	v.obj:disable('withe_w')

	
	for _,c in pairs(glowing_weak) do
		if c == v.adress then
			v.glowing_weak = true
			v.obj:enable('withe_w')
			break
		end
	end
		
	for _,c in pairs(glowing_strong) do
		if c == v.adress then
			v.glowing_strong = true
			v.obj:enable('withe_s')
			break
		end
	end

	

	for _,c in pairs(no_north) do
		if c == v.adress then
			north = nil
			break
		elseif v.y == 1 then
			north = nil
		end
	end
	for _,c in pairs(no_south) do
		if c == v.adress then
			south = nil
			break
		elseif v.y == 12 then
			south = nil
		end
	end
	for _,c in pairs(no_west) do
		if c == v.adress then
			west = nil
			break
		elseif v.x == 1 then
			west = nil
		end
	end
	for _,c in pairs(no_east) do
		if c == v.adress then
			east = nil
			break
		elseif v.x == 17 then
			east = nil
		end
	end
	
	v.way = {west, north, south, east, hunger_scene}

	
	v.entered = function (s, f)
		hunger = hunger + 1
		turn = turn + 1;
		
		--профилактически выкл. лозу
		s.obj:disable('withe_w')
		s.obj:disable('withe_s')

		--выключение выхода в Голод
		if hunger < 7 then
			s.way:enable_all()
			s.way:disable(hunger_scene)
		end	

		--Голод
		if hunger >= 3 and food > 0 then
			food = food - 1
			hunger = 0
		elseif hunger == 4 then
			pn ('Хочется кушать...')
		elseif hunger == 5 then
			pn ('Очень хочется кушать...')
		elseif hunger == 6 then
			pn ('Ненавижу тебя, сука.')
			my_confidence(-1)
		elseif hunger >= 7 then
			pn ('Жди здесь, я за едой.')
			s.way:disable_all()
			s.way:enable(hunger_scene)
		end

		--включение-выключение слабой лозы
		if s.glowing_weak == true and hunger < 4 then
			s.obj:enable('withe_w')
		elseif s.glowing_weak == true and hunger > 3 then
			pn ('Я слишком голоден, чтобы видеть.')
			s.obj:disable('withe_w')
		else 
			s.obj:disable('withe_w')
		end
		
		--включение-выключение сильной лозы
		if s.glowing_strong == true and hunger < 4 then
			s.obj:enable('withe_s')
		elseif s.glowing_strong == true and hunger > 3 then
			pn ('Я слишком голоден, чтобы видеть.')
			s.obj:disable('withe_s')
		else 
			s.obj:disable('withe_s')
		end

		--расход воды
		if water > 0 then
			water = water - 1
		else
			thirst = thirst + 1
		end
	
		--жажда
		if thirst >=3 and thirst < 5 then		--если жажда больше 2
			pn ('У нас серьезные проблемы с водой')
			local glitch = math.random(0, 2)	--рандомно включать лозу
			if glitch == 1 then
				s.obj:enable('withe_w')
				s.obj:disable('withe_s')
			elseif glitch == 2 then
				s.obj:disable('withe_w')
				s.obj:enable('withe_s')
			else
				s.obj:disable('withe_w')
				s.obj:disable('withe_s')
			end
			
		elseif thirst >= 5 then	--сбросить жажду до 2, чтобы не росла бесконечно
			pn ('Я пою тебя своей кровью, сука')
			thirst = 2
			my_sympathy(-1)
		end
		
	end

	
	v.exit = function (s, f)
		youarehere = s.idx
	end	
	
	
	return room(v)
end

--комнаты не-пустоши
quest_room = function(v)
	v.exit = function ()
		take(status_map)
		drop(status_quest)
	end

	v.entered = function ()
		take(status_quest)
		drop(status_map)
	end

	
	return room(v)
end
																	--[[ ОБЪЕКТЫ ]]--
	
withe_w = obj {
	nam = "Лоза1",
	dsc = "{Слабая Лоза}",
	act = function (s)
		dowser_dreams()
	end
 };
 
withe_s = obj {
	nam = "Лоза2",
	dsc = "{Сильная Лоза}",
	act = function (s)
		dowser_dreams()
	end
		}; 

confidenser = menu {
	nam = "ДОВ +",
	menu = function (s)
		if confidence < 2 then
			my_confidence(1)
		else
			my_confidence(-2)
		end
		p('+ дов')
	end
		}; 

sympathiser = menu {
	nam = 'СИМП +';
	menu = function (s)
		if sympathy < 2 then
			my_sympathy(1)
		else
			my_sympathy(-2)
		end
		p('+ симп')
	end;
	}		
		
	
																	--[[ КОМНАТЫ ]]--
hunger_scene = room {
	nam = 'Голод';
	dsc = 'Пришлось потратить немного времени';
	entered = function (s, f)
		turn = turn + rnd(4)
		food = rnd(2) + 1
		hunger = 0;
		hunger_scene.way:add(vroom('Продолжить путь', 'cells['..tostring(youarehere)..']'));
	end;
	left = function (s, f)
		hunger_scene.way:zap()
	end;
	way = {};
	}

main = room {
	nam = 'Старт';
	dsc = 'Начало игры';
	way = { 
		vroom('В Полношь', 'cells[109]'),
		};
	obj = { 
			vway("дальше", "{Прыг!}", 'novgorod'),
			vway("фыва", "{в бункер}^", 'q1_entrance'),
			vway("фыва", "{диалог в бункере}^", 'q1_dlg_panel'),
		};
	}

	
																	--[[ СТАРТ ]]--

status_map = stat {
        nam = 'статус';
	disp = function(s)
		day = math.ceil (turn / 4)
		time_of_day = turn - day * 4 + 4
		pn ('Ход: ', turn)
		pn ('День: ', day)
		pn ('Время: ', time_list[time_of_day])
		pn ('Еда: ', food)
		pn ('Голод: ', hunger)
		pn ('Вода: ', water)
		pn ('Жажда: ', thirst)
	end
}

status_relationship = stat {
        nam = 'статус';
	disp = function(s)
		pn ('Доверие: ', confidence)
		pn ('Симпатия: ', sympathy)
	end
}


status_quest = stat {
        nam = 'статус';
	disp = function(s)
		day = math.ceil (turn / 4)
		time_of_day = turn - day * 4 + 4
		pn ('Еда: ', food)
		pn ('Голод: ', hunger)
		pn ('Вода: ', water)
		pn ('Жажда: ', thirst)
	end
}

-- фабрика клеток Полноши
counter = 0
for y = 1, 12 do
	for x = 1, #dolgota do
		counter = counter + 1
		adress = {dolgota[x]..y, x, y, counter}
		local newroom = new([[myconstructor()]])
		cells:add(newroom)
	end
end

take(status_map)
take(status_relationship)

take('sympathiser')
take('confidenser')

-- bla = cells[194]
-- bla.way:add('cache2')

																  --[[ ФАЙЛЫ ИГРЫ ]]--

dofile "g1_novgorod.lua"


