extends Camera

var zoom_level = 40
var angle = 0

var position = Vector3(0,0,0)

var track = null

var screencast = null

func move_to(x):
	position = x
	track = null

func raycast(force = false):
	if force:
		screencast.force_raycast_update()
	return screencast.get_collision_point()

func _lookat_delta():
	return Vector3(-1, 1, -1) * zoom_level

func _enter_tree():
	screencast = RayCast.new()
	screencast.enabled = true
	GS.world.add_child(screencast)
	_update_screencast()
	if current:
		GS.camera = self

func _leave_tree():
	GS.world.remove_child(screencast)
	screencast.queue_free()

func _update_screencast():
	var scrpos = get_viewport().get_mouse_position()
	var origin = project_ray_origin(scrpos)
	var normal =  project_ray_normal(scrpos)
	screencast.translation = origin
	screencast.cast_to = normal*10000
	#rc.force_raycast_update()

func _physics_process(delta):
	_update_screencast()

	var basis = Basis.rotated(Vector3(0,1,0), angle)

	if Input.is_action_pressed("camera_rotate_clock"):
		angle -= PI/2 /(1.0/delta)
	elif Input.is_action_pressed("camera_rotate_counterclock"):
		angle += PI/2 /(1.0/delta)

	if not track:
		look_at_from_position(position + basis.xform(_lookat_delta()), position, Vector3(0,1,0))
	else:
		look_at_from_position(track.body.translation + basis.xform(_lookat_delta()), track.body.translation, Vector3(0,1,0))

func _unhandled_input(event):
	if event is InputEventPanGesture:
		# Add some leeway for one-directional movements.
		if abs(event.delta.y) > 0.1:
			zoom_level += event.delta.y
		if abs(event.delta.x) > 0.1:
			angle -= event.delta.x / 15.0
