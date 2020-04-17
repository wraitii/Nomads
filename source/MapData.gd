extends Entity

## This class holds all map-related data and helpers
# It is an Entity, more on a technicality than anything else.

const PIECE = preload('Map.gd')

const data = [
	[0, 1, 2, 5, 2, 1, 6],
	[1, 2, 2, 3, 1, 1, 1],
	[1, 1, 1, 3, 1, 1, 1],
	[1, 1, 1, 3, 1, 1, 1],
	[1, 1, 6, 8, 6, 1, 1],
]

var noise = OpenSimplexNoise.new()

func _init():
	# for now an empty shell
	add_interface_by_script('Map.gd')
	# map pieces will trigger this directly.
	add_interface_by_script('Actionnable.gd')
	
	# Configure
	noise.seed = randi()
	noise.octaves = 3
	noise.period = PIECE.SCALE / 5
	noise.persistence = 0.5

func _generate():
	var map = Spatial.new()
	for y in range(0,len(data)):
		for x in range(0, len(data[y])):
			var piece = PIECE.new()
			piece.piece_x = x
			piece.piece_y = y
			piece._generate(self)
			piece.translation.x = piece.SCALE * x - piece.SCALE * len(data[y])/2
			piece.translation.z = piece.SCALE * y - piece.SCALE * len(data)/2
			map.add_child(piece)
	return map

func _data(x, y):
	if y >= len(data):
		y = len(data) - 1
	elif y < 0:
		y = 0
	if x >= len(data[0]):
		x = len(data[0]) - 1
	elif x < 0:
		x = 0
	return data[y][x]

func get_height(px, x, py, y):
	var coefs = []
	var heights = []
	var tc = 0.0
	for yy in range(-1, 2):
		for xx in range(-1, 2):
			var tx = PIECE.POINTS/2 + PIECE.POINTS * xx
			var ty = PIECE.POINTS/2 + PIECE.POINTS * yy
			var inf = PIECE.POINTS - (Vector2(tx, ty) - Vector2(x, y)).length()
			inf = clamp(inf/PIECE.POINTS, 0, 1)
			coefs.push_back(inf)
			heights.push_back(_data(px+xx, py+yy))
			tc += inf
	var act = 0
	for i in range(0, len(coefs)):
		act += coefs[i] * heights[i]
	return act / tc + height_variation(px, x, py, y)

func height_variation(px, x, py, y):
	var rx = px * PIECE.POINTS + x
	var ry = py * PIECE.POINTS + y
	return noise.get_noise_2d(rx, ry)
	
