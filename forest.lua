wasteland_descriptions['1,7'].neutral = 'Лес'
wasteland_descriptions['1,6'].neutral = 'Лес'
wasteland_descriptions['1,5'].neutral = 'Лес'

math.randomseed(os.time())

function shuffle(list)
    -- make and fill array of indices
    local indices = {}
    for i = 1, #list do
        indices[#indices+1] = i
    end

    -- create shuffled list
    local shuffled = {}
    for i = 1, #list do
        -- get a random index
        local index = math.random(#indices)

        -- get the value
        local value = list[indices[index]]

        -- remove it from the list so it won't be used again
        table.remove(indices, index)

        -- insert into shuffled array
        shuffled[#shuffled+1] = value
    end

    return shuffled
end


function scrambleDirections(room)
	return (shuffle(room.way))
end