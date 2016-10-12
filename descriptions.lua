globals = {
	wasteland_dsc_visited ="мы тут уже были",
	direction_deal=false
}

wasteland_descriptions = {
 ['1,1'] = 
	{
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
	};

function constructDescription(node)
	result=""
	time_of_day = getTimeOfDay(turn)
	print(time_list[time_of_day])
	if confidence == -1 then
		result=result .. wasteland_descriptions[node][angry]
	elseif confidence == 0 then
		if (time_list[time_of_day]== 'Утр') or (time_list[time_of_day]== 'Дно') then
			result=result .. wasteland_descriptions[node].neutral .. '\n'
			print(result)
		end
		if (time_list[time_of_day]== 'Ночер') or (time_list[time_of_day]== 'Ночь') then
			result=result .. wasteland_descriptions[node].neutral_night .. '\n'
			print(result)
		end
	elseif confidence == 1 then
		if (time_list[time_of_day]== 'Утр') then 
			result=result .. wasteland_descriptions[node].kindly_morning .. '\n'
			print(result)
		end
		if (time_list[time_of_day]== 'Дно') then 
			result=result .. wasteland_descriptions[node].kindly_day.. '\n'
			print(result)
		end
		if (time_list[time_of_day]== 'Ночер') then
			result=result .. wasteland_descriptions[node].kindly_evening.. '\n'
			print(result)
		end
		if (time_list[time_of_day]== 'Ночь') then
			result=result .. wasteland_descriptions[node].kindly_night.. '\n'
			print(result)
		end
	end

	if sympathy==-1 then
		result=result .. wasteland_descriptions[node].insult.. '\n'
		print(result)
	else
		result=result .. wasteland_descriptions[node].comment.. '\n'
		print(result)

		if (sympathy==1)  and (direction_deal) then
			result=result .. wasteland_descriptions[node].subdirections.. '\n'
			print(result)
		end
			
		if (confidence ~= -1) and (sympathy ~= -1)  then -- and локация уже посещалась:
			result=result .. wasteland_descriptions[node].visited.. '\n'
			print(result)
		end
	end
	return result
	--if дополнительное условие:
	--	extra в стек
end


