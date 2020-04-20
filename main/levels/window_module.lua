local board_module = require("main.levels.board_module")
local render_data = require("main.levels.render_data")

local M = {}

function M.build_board_config(self)
	
	local screen_width = render_data.width
	local screen_height = render_data.height

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
	M.bottom_margin = (screen_height - M.rows * M.block_size) / 2
	
end

return M