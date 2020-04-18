W = {}

local default_blocksize = 128

function W.window_change(self, rows)
	
	msg.post("@render:", "use_fixed_fit_projection", { near = -1, far = 1 })
	
	local screen_width, screen_heigth = 360, 720 -- window.get_size()
	local board_size = screen_width
	local rows, cols = #self.board.data, #self.board.data[1]

	if rows < cols then
		self.block_scale = board_size / cols / default_blocksize
		
	else 
		self.block_scale = board_size / rows / default_blocksize
		
	end

	self.block_size = default_blocksize * self.block_scale
	self.left_margin = (screen_width - cols * self.block_size) / 2
	self.bottom_margin = (screen_heigth - rows * self.block_size) / 2
	
end

return W