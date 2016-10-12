global {
wasteland_dsc_visited ="мы тут уже были",
wasteland_no_dsc="мы в пустоши",
direction_deal=false,
insults={'ну ты и мудак',
		'я тебя ненавижу',
		'чтоб ты сдох',
		'иди на хрен'
		}
}


wasteland_descriptions = {
	};


for i=1,maxX do
	for j=1,maxY do
		wasteland_descriptions[tostring(i)..','..tostring(j)] = {
		angry = 'angry',
		neutral = 'neutral',
		neutral_night = 'neutral_night',
		kindly_morning = 'kindly_morning',
		kindly_day = 'kindly_day',
		kindly_evening = 'kindly_evening',
		kindly_night = 'kindly_night',
		insult = 'insult',
		comment = 'comment',
		subdirections = 'subdirections',
		visited = 'visited',
		extra = 'extra',
		extra_rule = [[]]
	}
	end
end


-- тут можно писать конкретные описания. Можно сделать для этого отдельный файл.


function processDescription(dsc)
	if dsc.neutral=='' then dsc.neutral=wasteland_no_dsc end
	if dsc.angry=='' then dsc.angry=dsc.neutral end
	if dsc.neutral_night=='' then dsc.neutral_night=dsc.neutral end
	if dsc.kindly_day=='' then dsc.kindly_day=dsc.neutral end
	if dsc.kindly_morning=='' then dsc.kindly_morning=dsc.kindly_day end
	if dsc.kindly_night=='' then dsc.kindly_night=dsc.kindly_day end
	if dsc.kindly_evening=='' then dsc.kindly_evening=dsc.kindly_night end
	if dsc.visited=='' then dsc.visited=dsc.wasteland_dsc_visited end
	dsc.insult = insults[math.random(1, #insults)]
	return dsc
--[[	comment пропускаем
	subdirections пропускаем
	extra пропускаем
	]]--

end

function constructDescription(room)
	node=tostring(room.x)..','..tostring(room.y)
	print(node)
	dsc = processDescription(wasteland_descriptions[node])
	result=""
	time_of_day = getTimeOfDay(turn)
	--print(time_list[time_of_day])
	if confidence == -1 then
		result=result .. dsc[angry]
	elseif confidence == 0 then
		if (time_list[time_of_day]== 'Утр') or (time_list[time_of_day]== 'Дно') then
			result=result .. dsc.neutral .. '\n'
			--print(result)
		end
		if (time_list[time_of_day]== 'Ночер') or (time_list[time_of_day]== 'Ночь') then
			result=result .. dsc.neutral_night .. '\n'
			--print(result)
		end
	elseif confidence == 1 then
		if (time_list[time_of_day]== 'Утр') then 
			result=result .. dsc.kindly_morning .. '\n'
			--print(result)
		end
		if (time_list[time_of_day]== 'Дно') then 
			result=result .. dsc.kindly_day.. '\n'
			--print(result)
		end
		if (time_list[time_of_day]== 'Ночер') then
			result=result .. dsc.kindly_evening.. '\n'
			--print(result)
		end
		if (time_list[time_of_day]== 'Ночь') then
			result=result .. dsc.kindly_night.. '\n'
			--print(result)
		end
	end

	if sympathy==-1 then
		result=result .. dsc.insult.. '\n'
		--print(result)
	else
		result=result .. dsc.comment.. '\n'
		--print(result)

		if (sympathy==1)  and (direction_deal) then
			result=result .. dsc.subdirections.. '\n'
			--print(result)
		end
			
		if (confidence ~= -1) and (sympathy ~= -1) and (room.visited)  then -- and локация уже посещалась:
			result=result .. dsc.visited.. '\n'
			--print(result)
		end
	end
	return result
	--if дополнительное условие:
	--	extra в стек
end


