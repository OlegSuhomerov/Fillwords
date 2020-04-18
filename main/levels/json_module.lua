local M = {}

local function shuffle(tbl)
	math.randomseed(tonumber(hash_to_hex(hash(tostring({}))):sub(4, 8), 16))
	for x = #tbl, 2, -1 do
		local y = math.random(x)
		tbl[x], tbl[y] = tbl[y], tbl[x]
	end
	return tbl
end

local function random_json(matrix)
	local words_json = sys.load_resource("/main/levels/json/words.json")
	local words = json.decode(words_json)
	words = words.dictionary
	for i in ipairs(matrix.content) do
		for j in ipairs(words) do
			if matrix.content[i].library == words[j].library then
				pprint(words[j].library_word)
				local tbl = words[j].library_word
				pprint(matrix.content[i].word)
			end
		end
	end	
	--pprint(words.library[1].library)
	--pprint(words.library[1].library_3[1])
end


function M.get_level_data(self)
	local json_matrix = sys.load_resource("/main/levels/json/level_" .. self.current_level ..".json")
	local matrix = json.decode(json_matrix)
	--local mat = random_json(matrix)
	return matrix
end

return M