extends Camera

var zoom_level = 40
var angle = 0

var position = Vector3(0,0,0)

var track = null

func move_to(x):
	position = x
	track = null

func _lookat_delta():
	return Vector3(-1, 1, -1) * zoom_level

func _physics_process(delta):
	var basis = Basis.rotated(Vector3(0,1,0), angle)

	if Input.is_action_pressed("camera_rotate_clock"):
		angle -= PI/2 /(1.0/delta)
	elif Input.is_action_pressed("camera_rotate_counterclock"):
		angle += PI/2 /(1.0/delta)

	if not track:
		look_at_from_position(position + basis.xform(_lookat_delta()), position, Vector3(0,1,0))
	else:
		look_at_from_position(track.translation + basis.xform(_lookat_delta()), track.translation, Vector3(0,1,0))

func _unhandled_input(event):
	if event is InputEventPanGesture:
		# Add some leeway for one-directional movements.
		if abs(event.delta.y) > 0.1:
			zoom_level += event.delta.y
		if abs(event.delta.x) > 0.1:
			angle -= event.delta.x / 15.0
