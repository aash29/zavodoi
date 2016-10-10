-- $Name: Zavodoi2$
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

	cells = list {};
	youarehere = list {1,1};
	turn = 0;
	time1 = 4;
	time_list = {'Утр', 'Дно', 'Ночер', 'Ночь'};
	
	food = 5;
	hunger = 4;
	
	water = 100;
	thirst = 0;
	
	confidence = 0;
	sympathy = 0;

	maxX =17;
	maxY =12;

	water_wells = {{5,1},{5,9},{9,6}, {14,3},{17,10}};

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

function myconstructor(x,y)
	local v={};
	v.x = x
	v.y = y
	v.nam =   tostring(x)..",".. tostring(y)
	v.dsc = 'Мы где-то в пустоши.'

	
	local north = vroom('Север', 'cells['..tostring(x)..']'..'['..tostring(y-1)..']')
	local south = vroom('Юг', 'cells['..tostring(x)..']'..'['..tostring(y+1)..']')
	local west = vroom('Запад', 'cells['..tostring(x-1)..']'..'['..tostring(y)..']')
	local east = vroom('Восток', 'cells['..tostring(x+1)..']'..'['..tostring(y)..']')

	v.way=list {}
	if x>1 then
		table.insert(v.way,west)
	end

	if x<maxX then
		table.insert(v.way,east)
	end
	

	if y>1 then
		table.insert(v.way,north)
	end

	if y<maxY then
		table.insert(v.way,south)
	end

	table.insert(v.way,'hunger_scene')

	v.obj={}

	
	v.entered = function (s, f)

		youarehere[1]=s.x
		youarehere[2]=s.y

		hunger = hunger + 1
		turn = turn + 1;
		
		--профилактически выкл. лозу
		--s.obj:disable('withe_w')
		--s.obj:disable('withe_s')

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
			s.way:enable('hunger_scene')
		end

		--включение-выключение слабой лозы
		if exist('withe_w') and hunger < 4 then
			s.obj:enable('withe_w')
		elseif exist('withe_w') and hunger > 3 then
			pn ('Я слишком голоден, чтобы видеть.')
			s.obj:disable('withe_w')
		end
		
		--включение-выключение сильной лозы
		if exist('withe_s') and hunger < 4 then
			s.obj:enable('withe_s')
		elseif exist('withe_s') and hunger > 3 then
			pn ('Я слишком голоден, чтобы видеть.')
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
	--[[
	v.exit = function (s, f)
		youarehere = s.x,s.y
	end	
	]]--
	
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

withe_ww = obj {
	nam = "Лоза0",
	dsc = "Что-то здесь не так",
	act = function (s)
		dowser_dreams()
	end
 };
	
withe_w = obj {
	nam = "Лоза1",
	dsc = "{Трепещут чесалки}",
	act =function (s)
	 print ("Act is here! "..stead.deref(s));
	end;
 };
 
withe_s = obj {
	nam = "Лоза2",
	dsc = "{Сильно трепещут чесалки}",
	act = function (s)
		dowser_dreams()
	end
		}; 


withe_ss = obj {
	nam = "Лоза3",
	dsc = "{Очень cильно трепещут чесалки}",
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
		hunger_scene.way:add(vroom('Продолжить путь', 'cells['..tostring(youarehere[1])..']['..tostring(youarehere[2])..']'));
	end;
	left = function (s, f)
		hunger_scene.way:zap()
	end;
	way = {};
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
for x = 1, maxX do
	cells[x]={};
	for y = 1, maxY do
		--adress = {dolgota[x]..y, x, y, counter}
 		--cells[x][y] = room(myconstructor(x,y))
 		cells[x][y] = new('myconstructor('..tostring(x)..','..tostring(y)..')')
	end
end
--stead.add_var {cells}

main=cells[1][1]

for k,v in pairs(water_wells) do
	for i =v[1]-2,v[1]+2 do
		for j =v[2]-2,v[2]+2 do
			if (cells[i]) then
				if (cells[i][j]) then
					d=((i-v[1])^2 + (j-v[2])^2)^(1/2)

					if (d<0.5) then
						objs(cells[i][j]):add('withe_ss')   --очень сильная лоза
					end
					if (d>0.5) and (d<1.5) then
						--put(new [[obj {nam = 'test', dsc='test' } ]],cells[i][j]);
						objs(cells[i][j]):add('withe_s')   --сильная лоза
						print (i..','..j..','..'сильная лоза')
					end

					if (d>1.5) and (d<2.5) then
						--put(new [[obj {nam = 'test', dsc='test' } ]],cells[i][j]);
						objs(cells[i][j]):add('withe_w')  --слабая лоза
						print (i..','..j..','..'слабая лоза')
					end
				    
					if (d>2.5) then
						--put(new [[obj {nam = 'test', dsc='test' } ]],cells[i][j]);
				    	objs(cells[i][j]):add('withe_ww'); -- совсем слабая лоза
				    	print (i..','..j..','..'совсем слабая лоза')
				    end
				end
			end
		end 
	end 
end

--objs(cells[2][2]):add(withe_w)

--[[x
cells[1][1] = room {
	nam = 'Старт';
	dsc = 'Начало игры';
	way = { 
		vroom('В Полношь', 'cells[109]'),
		};

	}
]]--




take(status_map)
take(status_relationship)

take('sympathiser')
take('confidenser')





