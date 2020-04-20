local board_module = require("main.levels.board_module")
local window_module = require("main.levels.window_module")
local hashmodule = require("main.levels.hashmodule")


local M = {}

local input_order = {}


local function hit_node(x, y, i, j)
	local bc = board_module.button_cord[i][j]
	local bs = window_module.block_size
	local board = board_module.board.data[i][j]
	return not board.pressed and not board.guessed and
	x < bc.pos_x + bs / 2 and 
	x > bc.pos_x - bs / 2 and 
	y > bc.pos_y - bs / 2 and 
	y < bc.pos_y + bs / 2
end



local moving = false


function M.on_input(action,action_id, on_success, on_fail, on_move)
	local board = board_module.board.data
	local words = board_module.board.words

	if action_id == hashmodule.touch then
		if action.pressed or (moving and not action.released) then
			moving = true
			for i in ipairs(board) do
				for j in ipairs(board[i]) do
					if hit_node(action.x, action.y, i, j) then
						local add_char = true

						if #input_order > 0 then
							local prev = input_order[#input_order]
							if math.abs(i - prev.i) > 1 or math.abs(j - prev.j) > 1 and
							not board[i][j].pressed then
								add_char = false
							end

							if math.abs(i - prev.i) == 1 and math.abs(j - prev.j) == 1 and
							not board[prev.i][j].pressed and add_char then
								board[prev.i][j].pressed = true
								table.insert(input_order, {i = prev.i, j = j})
								on_move(prev.i, j)
							end
						end

						if add_char then
							board[i][j].pressed = true
							table.insert(input_order, {i = i, j = j})

							local attempt_word = ''
							for _, order in ipairs(input_order) do
								attempt_word = attempt_word .. board[order.i][order.j].char
							end

							on_move(i,j, attempt_word)
						end
					end
				end
			end
		elseif action.released then
			board_module.input_text = ''
			moving = false
			local guessed = false
			for i in ipairs(board) do 
				for j in ipairs(board[i]) do 
					board[i][j].pressed = false 
				end
			end  
			if #input_order == 0 then
				return
			end
			local start_word_num = board[input_order[1].i][input_order[1].j].word_num
			local result_word = ''
			for _, order in ipairs(input_order) do
				if board[order.i][order.j].word_num == start_word_num then
					result_word = result_word .. board[order.i][order.j].char
				else
					result_word = ''
					break
				end
			end
			if words[start_word_num] == result_word then
				for _, order in ipairs(input_order) do 
					board[order.i][order.j].guessed = true 
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
end

return M