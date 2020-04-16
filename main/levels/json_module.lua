M = {}
function M.get_level_data(self)
	local json_matrix = sys.load_resource("/main/levels/json/level_" .. self.current_level ..".json")
	local matrix = json.decode(json_matrix)
	return matrix
end

return M