class_name AStarPathfinding

static func path_find(goal, from, d_map)->Array[Vector2]:
	var open_set:PriorityQueue = PriorityQueue.new()
	var f_map:Array[Array] = []
	for x in d_map.size():
		f_map.push_back([])
		f_map[x].resize(d_map[x].size())
		for y in d_map[x].size():
			f_map[x][y] = 99999
	f_map[from.x][from.y] = 0
	open_set.insert(from, 0)
	var path = {}
	while not open_set.empty():
		var pos = open_set.extract()
		if pos == goal: return extract_path(from, goal, path)
		for n in get_neighbors(pos, d_map):
			var score = d_map[n.x][n.y]+f_map[pos.x][pos.y]
			var swapped = false
			if score < f_map[n.x][n.y]:
				f_map[n.x][n.y] = score
				path[n] = pos
				swapped = true
			if swapped: open_set.insert(n, score)
		pass
	return []
	
static func extract_path(from, goal, path):
	var n_path:Array[Vector2] = []
	var current = goal
	while current != from:
		n_path.push_front(current)
		current = path[current]
	return n_path
	
static func get_neighbors(pos, map)->Array[Vector2]:
	var neighbors:Array[Vector2] = []
	var x = pos.x
	var y = pos.y
	if 0 < x: neighbors.push_back(Vector2(x-1, y))
	if map.size() > x+1: neighbors.push_back(Vector2(x+1, y))
	if 0 < y: neighbors.push_back(Vector2(x, y-1))
	if map[x].size() > y+1: neighbors.push_back(Vector2(x, y+1))
	return neighbors
