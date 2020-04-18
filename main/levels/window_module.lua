local M = {}

local default_blocksize = 128

function M.window_change(self)
	
	msg.post("@render:", "use_fixed_fit_projection", { near = -1, far = 1 })
	
	local screen_width, screen_heigth = 360, 720 -- window.get_size()
	local board_size = screen_width
	M.rows = #self.board.data
	M.cols = #self.board.data[1]

	if M.rows < M.cols then
		M.block_scale = board_size / M.cols / default_blocksize
		
	else 
		M.block_scale = board_size / M.rows / default_blocksize
		
	end

	M.block_size = default_blocksize * M.block_scale
	M.left_margin = (screen_width - M.cols * M.block_size) / 2
	M.bottom_margin = (screen_heigth - M.rows * M.block_size) / 2
	
end

return M