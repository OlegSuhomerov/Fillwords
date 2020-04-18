local M = {}

local input_order = {}

function input(self, action_id, action)
	for i in ipairs(self.button_cord) do
		for j in ipairs(self.button_cord[i]) do
			if action.x < self.button_cord[i][j].pos_x + self.block_size / 2 and action.x > self.button_cord[i][j].pos_x - self.block_size / 2 and action.y > self.button_cord[i][j].pos_y - self.block_size / 2 and action.y < self.button_cord[i][j].pos_y + self.block_size / 2 and not self.board.data[i][j].pressed then
				msg.post(self.board.data[i][j].id, "play_animation", {id = hash("blue")})
				self.board.data[i][j].pressed = true
				self.board.data[i][j].input_order = input_order
				table.insert(input_order, {i = i, j = j})
			end
		end
	end
end

function check(self)
--	local start_word_num = node[input_order[1].i][input_order[1].j].word_num
end	

return M