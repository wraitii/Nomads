extends Control

var pdata;

var switch = 0

func _ready():
	$Map.texture = load('res://data/tests/9_ismusRM.png')
	pdata = $Map.texture.get_data()
	$Map.connect("gui_input", self, "on_input")
	$Button.connect("button_up", self, "open_dialog")
	$FileDialog.connect("confirmed", self, "on_sel")
	$FileDialog.connect("file_selected", self, "on_sel")

func open_dialog():
	$FileDialog.popup_centered()
	
func on_sel(f):
	$Map.texture = load('res://data/tests/' + $FileDialog.current_file)
	pdata = $Map.texture.get_data()

func on_input(event):
	if not (event is InputEventMouseButton):
		return
	if event.pressed == true:
		return
	
	var scale = pdata.get_width() / $Map.rect_size.x;

	if switch == 0:
		$Map/Start.margin_left = event.position.x - 3
		$Map/Start.margin_top = event.position.y - 3
		$Map/Start.margin_right = event.position.x + 3
		$Map/Start.margin_bottom = event.position.y + 3
		switch = 1
	elif switch == 1:
		$Map/End.margin_left = event.position.x - 3
		$Map/End.margin_top = event.position.y - 3
		$Map/End.margin_right = event.position.x + 3
		$Map/End.margin_bottom = event.position.y + 3
		switch = 2
	else:
		SimpleGridPathfinder.new(pdata.duplicate()).async_astar(self, "on_path",
			($Map/Start.margin_left + 3) * scale,
			($Map/Start.margin_top + 3) * scale,
			($Map/End.margin_left + 3) * scale,
			($Map/End.margin_top + 3) * scale
		)
		switch = 0
		
func on_path(path):
	pdata.unlock()
	var scale = pdata.get_width() / $Map.rect_size.x;
	if path:
		$Label.text += str(len(path)) + "\n"
		var i = 0
		var l = Line2D.new()
		for node in path:
			l.add_point(Vector2(node[0], node[1])/scale)
		add_child(l)
		l.translate($Map.rect_global_position)
