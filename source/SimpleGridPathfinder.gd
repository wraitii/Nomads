extends Reference
class_name SimpleGridPathfinder

var data : Image

const NEIGHB = [
	[0, 1, 1],
	[0,-1, 1],
	[ 1,0, 1],
	[-1,0, 1],
	[1, 1, 1.412],
	[-1, 1, 1.412],
	[1, -1, 1.412],
	[-1, -1, 1.412],
]

func _init(d):
	data = d

func dist(s_x, s_y, e_x, e_y):
	return (Vector2(s_x, s_y) - Vector2(e_x, e_y)).length()

func astar(s_x: int, s_y: int, g_x: int, g_y: int):
	data.lock()
	var ret = _astar(s_x, s_y, g_x, g_y)
	data.unlock()
	return ret
	
func _astar(s_x: int, s_y: int, g_x: int, g_y: int):
	
	# TODO: use a better data structure
	# Stores "Node" -> "Best F"
	var open_set = { s_x + s_y * data.get_width(): 0 }

	var node_parent = {}

	# cost from start to here
	var g_score = {
		s_x + s_y * data.get_width(): 0
	}
	# F score is recorded directly in the open set
#	f_score = {
#		s_x + s_y * data.get_width(): dist(s_x, s_y, g_x, g_y)
#	}
	#print([s_x, s_y])
	#print([g_x, g_y])
	
	# Simple optimisation for the best (and somewhat usual)
	# case of having run into the new best fscore over the last iteration.
	var shortcut = null
	var current_node = null
	var best_f = null
	while not open_set.empty():
		# This is where a better structure would be better
		best_f = null
		if shortcut:
			current_node = shortcut
			best_f = open_set[shortcut]
			shortcut = null
		else:
			for node in open_set:
				if best_f == null or open_set[node] < best_f:
					best_f = open_set[node]
					current_node = node

		if current_node == g_x + g_y * data.get_width():
			return reconstruct_path(node_parent, current_node)

		open_set.erase(current_node)
		
		var cx = current_node % data.get_width()
		var cy = int(current_node / data.get_width())
		
		#print("picked" + str([cx, cy]))

		for neighb in NEIGHB:
			var nx = cx + neighb[0]
			var ny = cy + neighb[1]
			if nx < 0 or nx >= data.get_width():
				continue
			if ny < 0 or ny >= data.get_width():
				continue

			if data.get_pixel(nx, ny).r < 0.9:
				continue

			var nn = nx + ny * data.get_width()
			
			var gs = g_score[current_node] + neighb[2]
			if not(nn in g_score) or gs < g_score[nn]:
				node_parent[nn] = current_node
				g_score[nn] = gs
				# Add to open set and update f_score (since my open set is my fscore map)
				var fs = gs + dist(nx, ny, g_x, g_y) * 1.2
				open_set[nn] = fs
				if fs < best_f:
					shortcut = nn
					best_f = fs
				#print("new best for " + str([nx, ny]) + " at " + str(gs))

	return null

func reconstruct_path(node_parent, current_node):
	var path = [[current_node % data.get_width(), int(current_node / data.get_width())]]
	while current_node in node_parent:
		current_node = node_parent[current_node]
		path.push_back([current_node % data.get_width(), int(current_node / data.get_width())])
	path.invert()
	return path

func _thread_astar(data):
	var ret = astar(data[1][0], data[1][1], data[1][2], data[1][3])
	data[0][0].call_deferred(data[0][1], ret)
	# Yeah this is as ugly as it looks
	data[0][2].unreference()
	self.unreference()

func async_astar(who, callback, sx, sy, ex, ey):
	var thread = Thread.new()
	thread.reference()
	reference()
	thread.start(self, "_thread_astar", [[who, callback, thread], [sx, sy, ex, ey]])
