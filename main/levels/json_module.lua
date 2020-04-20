local board_module = require("main.levels.board_module")
local M = {}

function M.get_level_data()
	local json_matrix = sys.load_resource("/main/levels/json/level_" .. board_module.current_level ..".json")
	return json.decode(json_matrix)
end

return M