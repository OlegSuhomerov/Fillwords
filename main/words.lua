M = {}

local library_3 = {"кот", "кит", "лом", "лис", "поп", "ром", "шар","бур","бар","вор","душ","дуб","ерш","ель","жир","жук","зуб","луч","меч","нож","рак","рой","рис","сон","таз","ухо","усы","фея","хор","шея","щит","лук","куб"}
local library_5 = {"абзац", "автор","адрес","буран","ворон","живот","камин","мысль","сфера","талон","узник","школа","щенок","алмаз","дождь","берег","гамак","дверь","закон","знамя","колье","кофта","месяц","номер","рация","страж","сабля","уголь","уксус","финал","фрукт","халат","центр","порох","эскиз","юноша"}
local library_6 = {"молоко", "бумага","бандит","вахтер","валюта","гавань","жалюзи","кресло","кружка","казино","миксер","малина","ноготь","посуда","ремонт","стекло","абажур","авария","алтарь","журнал","желудь","жемчуг","гончар","лесной","миксер","чеснок"}
local library_7 = {"абрикос","граница","дворник","диктант","доспехи","задание","игрушка","китобой","ловушка","огнемет","рисунок","рудокоп","стрелок","табурет","студент","танкист","форпост","церковь","царство","шоколад"}
local library_9 = {"небоскреб","аллигатор","баскетбол","жемчужина","журналист","захватчик","канделябр","миллионер","молодость","насекомое","храбрость","санаторий","противник","олимпиада","наволочка","президент","мышеловка","лекартсво","спасатель","нагрудник","поросенок","опасность","массажист","лечебница","штурмовик"}

local utf8 = require("utf8.utf8")
local word1 = {}
local word2 = {}
local word3 = {}

local function shuffle(tbl)
	math.randomseed(tonumber(hash_to_hex(hash(tostring({}))):sub(4, 8), 16))
	for i = #tbl, 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end


function M.words_print_level1(self)
	local tbl = shuffle(library_3)
	
	utf8.gsub(tbl[1], ".", function(char) word1[#word1 + 1] = char end)
	utf8.gsub(tbl[2], ".", function(char) word2[#word2 + 1] = char end)
	utf8.gsub(tbl[3], ".", function(char) word3[#word3 + 1] = char end)
	return word1, word2, word3
end

function M.words_print_level3(self)

	local tbl = shuffle(library_5)
	utf8.gsub(tbl[1], ".", function(char) word1[#word1 + 1] = char end)
	utf8.gsub(tbl[2], ".", function(char) word2[#word2 + 1] = char end)
	local tbl = shuffle(library_6)
	utf8.gsub(tbl[1], ".", function(char) word3[#word3 + 1] = char end)
	return word1, word2, word3
end

function M.words_print_level5(self)
	local tbl = shuffle(library_9)
	utf8.gsub(tbl[1], ".", function(char) word1[#word1 + 1] = char end)
	utf8.gsub(tbl[2], ".", function(char) word2[#word2 + 1] = char end)
	local tbl = shuffle(library_7)
	utf8.gsub(tbl[1], ".", function(char) word3[#word3 + 1] = char end)
	return word1, word2, word3
end

function M.typing_word(self, level_cord, edge, level, click_x, click_y)
	for i in ipairs(level_cord) do
		for j in ipairs(level_cord[i]) do
			if click_x > level_cord[i][j].position_x - edge and click_x < level_cord[i][j].position_x + edge and click_y > level_cord[i][j].position_y - edge and click_y < level_cord[i][j].position_y + edge then
				local node = gui.get_node('button_' .. i .. '_' .. j) 
				if gui.get_flipbook(node) == hash("red") then
					gui.set_texture(node, "bricks")
					gui.play_flipbook(node, "blue") 
					self.level[i][j].started = true
					input_length = input_length + 1
					self.level[i][j].input_order = input_length 
				end
			end
		end
	end
end

function M.word_check(self, level, level_cord)
	for i in ipairs(level) do
		for j in ipairs(level[i]) do
			if level[i][j].started and level[i][j].word_length == input_length and level[i][j].order == level[i][j].input_order then 
				local node = gui.get_node('button_' .. i .. '_' .. j)
				gui.set_texture(node, "bricks")
				gui.play_flipbook(node, "green") 
				self.level[i][j].input_order = 0  
				self.level[i][j].started = false
				self.level[i][j].finished = true  
			elseif level[i][j].started and finished ~= true then 
				local node = gui.get_node('button_' .. i .. '_' .. j)
				if gui.get_flipbook(node) ~= hash("green") then 
					gui.set_texture(node, "bricks")	
					gui.play_flipbook(node, "red")
					self.level[i][j].input_order = 0  
				end
			end
		end
	end
	for i in ipairs(level) do
		for j in ipairs(level[i]) do
			if level[i][j].finished == true then 
				passing_level = passing_level + 1 
				if passing_level == number_tiles then 
					msg.post("#gui", "level_completed") 
					self.completed = true
				end
			end
		end
	end
end

return M