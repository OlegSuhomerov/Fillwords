local board_module = require("main.levels.board_module")

local M = {}

function M.window_change(self)
	
	msg.post("@render:", "use_fixed_fit_projection", { near = -1, far = 1 })
	
	local screen_width, screen_heigth = 360, 720
	local board_size = screen_width
	M.rows = #board_module.board.data
	M.cols = #board_module.board.data[1]

	if M.rows < M.cols then
		M.block_scale = board_size / M.cols / board_module.default_blocksize
		
	else 
		M.block_scale = board_size / M.rows / board_module.default_blocksize
		
	end

	M.block_size = board_module.default_blocksize * M.block_scale
	M.left_margin = (screen_width - M.cols * M.block_size) / 2
	M.bottom_margin = (screen_heigth - M.rows * M.block_size) / 2
	
end

return M