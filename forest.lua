


math.randomseed(os.time())

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end



function scrambleDirections(room)
    list1=deepcopy(room.way)
    -- make and fill array of indices
    local indices = {}
    for i = 1, #list1-1 do
        indices[#indices+1] = i
    end
    room.way:zap()
    -- create shuffled list

    for i = 1, #list1-1 do
        -- get a random index
        local index = math.random(#indices)

        -- get the value
        local value = list1[indices[index]]
       --for k,v in pairs(value) do
       --     print(k,v)
       -- end
       print(value.nam)
       print(value.where)

        -- remove it from the list so it won't be used again
        table.remove(indices, index)

        -- insert into shuffled array
        room.way:add(vroom(list1[i].nam,value.where))

    end
    
    room.way:add(hunger_scene)  
    --room.way:disable(hunger_scene)
end

harpies = list {}


harpiesAct = function(s)
        p( s.replies[s.cr]);
        s.cr=s.cr+1
        if (s.cr > #s.replies) then
                walk(harpiesAttack)
        end
end



harpies[1] = new [[obj {
        nam = 'harpy1',
        replies={"ответ 1 гарпии 1",
        "ответ 2 гарпии 1",
        "ответ 3 гарпии 1"},
        --replies[2] = "ответ 2 гарпии 1",
        cr = 1,
        dsc = '{Гарпия №1 }',
        act = harpiesAct
    } ]] 



harpies[2] = new [[obj {
        nam = 'harpy2',
        replies={"ответ 1 гарпии 2",
        "ответ 2 гарпии 2",
        "ответ 3 гарпии 2"},
        cr = 1,
        dsc = '{Гарпия №2 }',
        act = harpiesAct
    } ]] 


harpies[3] = new [[obj {
        nam = 'harpy3',
        replies={"ответ 1 гарпии 3",
        "ответ 2 гарпии 3"},
        cr = 1,
        dsc = '{Гарпия №3 }',
        act = harpiesAct
    } ]] 

harpies[4] = new [[obj {
        nam = 'harpy4',
        replies={"ответ 1 гарпии 4",
        "ответ 2 гарпии 4",
        "ответ 3 гарпии 4",
        "ответ 4 гарпии 4"},
        cr = 1,
        dsc = '{Гарпия №4 }',
        act = harpiesAct
    } ]] 

harpies[5] = new [[obj {
        nam = 'harpy5',
        replies={"ответ 1 гарпии 5"},
        cr = 1,
        dsc = '{Гарпия №5 }',
        act = harpiesAct
    } ]] 


harpiesAttack = room {
    nam = 'Гарпии напали';
    dsc = 'Гарпии напали';
}

harpiesScene = room {
    nam = 'Гарпии';
    dsc = 'Кругом гарпии';
    entered = function (s, f)

        local indices = {}
        for i = 1, 5 do
            indices[#indices+1] = i
        end

        numHarpiesInScene=3

        objs():zap()

        for i = 1, numHarpiesInScene do
            local index = math.random(#indices)
        -- remove it from the list so it won't be used again
            objs():add(harpies[indices[index]])
            table.remove(indices, index)

        end


        
    end;
    left = function (s, f)
    end;
    obj={};
    way = {};
}


