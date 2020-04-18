extends Viewport

var cam_pos = Vector3(0,100,0)
var cam_size = 512;

var grid : Image;

func _enter_tree():
	$Camera.translation = get_parent().translation + cam_pos
	$Camera.size = cam_size

	var r = Timer.new()
	add_child(r)
	r.start(1)
	r.connect("timeout", self, "rerender")
	rerender()

func rerender():
	render_target_update_mode = UPDATE_ONCE
	grid = get_texture().get_data()
	#print(grid.x)
	#grid.save_png("res://test.png")
