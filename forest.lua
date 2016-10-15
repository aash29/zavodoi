


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

