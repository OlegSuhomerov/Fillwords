local board_module = require("main.levels.board_module")
local window_module = require("main.levels.window_module")
local hashmodule = require("main.levels.hashmodule")


local M = {}

local input_order = {}


local function hit_node(x, y, i, j)
	local bc = board_module.button_cord[i][j]
	local bs = window_module.block_size
	local board = board_module.board.data[i][j]
	return not board.pressed and 
	not board.guessed and
	x < bc.pos_x + bs / 2 and 
	x > bc.pos_x - bs / 2 and 
	y > bc.pos_y - bs / 2 and 
	y < bc.pos_y + bs / 2
end
		

	
function M.on_input(action,action_id, on_success, on_fail, on_move)
	local board = board_module.board.data
	local words = board_module.board.words
	if action_id == hashmodule.touch and action.value == 1 then
		for i in ipairs(board) do
			for j in ipairs(board[i]) do
				if hit_node(action.x, action.y, i, j) and not board[j][j].pressed then
					board[i][j].pressed = true
					board[i][j].input_order = input_order
					local prev = input_order[#input_order]
					table.insert(input_order, {i = i, j = j})
					on_move(i,j)
				end
			end
		end		
	elseif action.released and action.value == 0 then
		local guessed = false
		for i in ipairs(board) do 
			for j in ipairs(board[i]) do 
				board.pressed = false 
			end
		end	
		if #input_order == 0 then
			return
		end
		local start_word_num = board[input_order[1].i][input_order[1].j].word_num
		local result_word = ''
		for _, order in ipairs(input_order) do
			if board[order.i][order.j].word_num ~= start_word_num then
				break
			end
			result_word = result_word .. board[order.i][order.j].char
		end
		pprint(words[start_word_num])
		if words[start_word_num] == result_word then
			for i in ipairs(input_order) do 
				for j in ipairs(input_order[i]) do 
					board[i][j].guessed = true 
				end
			end
			guessed = true
		end
		input_order = {}

		if guessed then
			on_success(start_word_num)
		else
			on_fail()
		end
	end
end	

return M