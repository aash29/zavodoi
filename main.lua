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
	sympathy = -1;

	maxX =17;
	maxY =12;

	water_wells = {{5,1},{5,9},{9,6},{14,3},{17,10}};
	forest = {{1,5},{1,6},{1,7}, {2,6},{2,7}, {3,6},{3,7}, {4,5},{4,6},{4,7}, {5,5},{5,6}, {13,12},{14,11},{14,12},{15,11}};

	}
	
stead.phrase_prefix = '* ';
																	--[[ ФУНКЦИИ ]]--

dofile("descriptions.lua")
dofile("forest.lua")
 
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
	v.visited=false
	v.nam =   tostring(x)..",".. tostring(y)
	--v.dsc = 'Мы где-то в пустоши.'
	v.dsc = constructDescription

	
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

	
	v.entered = function (s)

		youarehere[1]=s.x
		youarehere[2]=s.y

		hunger = hunger + 1
		turn = turn + 1;
		
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
		if  hunger < 4 then
			--s.obj:enable('withe_w')
			switchDowse(cells[s.x][s.y],1)
		elseif  hunger > 3 then
			pn ('Я слишком голоден, чтобы видеть.')
			--s.obj:disable('withe_w')
			--print(s.x,s.y)
			switchDowse(cells[s.x][s.y],0)
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
				s.obj:enable('Dowse')
				s.obj:disable('StrongDowse')
			elseif glitch == 2 then
				s.obj:disable('Dowse')
				s.obj:enable('StrongDowse')
			else
				s.obj:disable('StrongDowse')
				s.obj:disable('Dowse')
			end
			
		elseif thirst >= 5 then	--сбросить жажду до 2, чтобы не росла бесконечно
			pn ('Я пою тебя своей кровью, сука')
			thirst = 2
			my_sympathy(-1)
		end
		
	end
	
	v.exit = function (s, f)
		--youarehere = s.x,s.y
		s.visited=true
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


function getTimeOfDay(turn)
	day = math.ceil (turn / 4)
	time_of_day = turn - day * 4 + 4
	return time_of_day
end

status_map = stat {
        nam = 'статус';
	disp = function(s)
		--day = math.ceil (turn / 4)
		--time_of_day = turn - day * 4 + 4
		time_of_day=getTimeOfDay(turn)
		print('time of day'.. tostring(time_of_day))
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

function populateDowseCell(ci,cj,i,j)  -- "населить"" клетку объектами лозы. Вода в ci,cj
	d=((i-ci)^2 + (j-cj)^2)^(1/2)

	if (d<0.5) then
		v = new [[obj {nam = 'VeryStrongDowse', dsc='{Очень cильно трепещут чесалки.}', act = dowser_dreams, tags='dowse' } ]] 
	end
	if (d>0.5) and (d<1.5) then
		v = new [[obj {nam = 'StrongDowse', dsc='{Сильно трепещут чесалки.}', act = dowser_dreams, tags='dowse' } ]] 
	end

	if (d>1.5) and (d<2.5) then
		v = new [[obj {nam = 'Dowse', dsc='{Трепещут чесалки.}', act = dowser_dreams, tags='dowse' } ]] 
	end
    
	if (d>2.5) then
		v = new [[obj {nam = 'WeakDowse', dsc='Что-то не так.', tags='dowse'} ]]
	end
	if (ci==17) and (cj==10) then
		v.dsc=v.dsc..' Подозрительно.'
	end

    objs(cells[i][j]):add(v)
end

function depopulateDowseCell(ci,cj,i,j)  -- удалить все следы воды из ячейки
	l1 = getObjectsByTag(cells[i][j],"dowse")
	for k,v in pairs(l1) do
		objs(cells[i][j]):purge(v.nam)
	end
end;

function forNearestCells(ci,cj, f)  -- применить функцию f ко всем соседним с ci,cj клеткам
	for i =ci-2,ci+2 do
		for j =cj-2,cj+2 do
			if (cells[i]) then
				if (cells[i][j]) then
					f(ci,cj,i,j)
				end
			end
		end 
	end 
end

function switchDowse(room,on)  -- включить или выключить лозу в комнате room
	l1 = getObjectsByTag(room,"dowse")
	for k,v in pairs(l1) do
		if on==0 then
			objs(room):disable(v.nam)
		end
		if on==1 then
			objs(room):enable(v.nam)
		end
		print(v.nam)
	end 

end


function getObjectsByTag(room,tag) -- найти в клетке room все объекты с тегом tag
	result={}
	for i = 1,10 do
		if (objs(room)[i]) then
			obj1=objs(room)[i]
			print(obj1.nam,obj1.tags)
			if (obj1.tags==tag) then
				--objs(room):disable(obj1.nam)
				table.insert(result,obj1)
				print("inserted")
			end
		end
	end
	return result
end

for k,v in pairs(water_wells) do
	forNearestCells(v[1],v[2],populateDowseCell)
end


for k,v in pairs(forest) do
	print(v[1],v[2])
    scrambleDirections(cells[v[1]][v[2]])
end

main=cells[2][2]
path('Север', main):disable();
--main.way:zap()
--main.way:add(vroom("Север",cells[2][1]))
--print(main.way)
--print(wasteland_dsc_visited)





--forNearestCells(5,1,depopulateDowseCell)

--print(getObjectsByTag(cells[5][1],"dowse"))

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


