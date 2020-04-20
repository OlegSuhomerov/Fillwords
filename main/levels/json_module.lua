local board_module = require("main.levels.board_module")
local M = {}

function M.get_level_data(matrix)
	local json_matrix = sys.load_resource("/main/levels/json/level_" .. board_module.current_level ..".json")
	local matrix = json.decode(json_matrix)
	return matrix
end

return M