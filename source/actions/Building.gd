extends GUIAction

## Building action
# User's mouse should show a preview of the building and helpful info
# Clicking plops down a plan. Right-clicking discards.

var preview

func get_class():
	return ["gui_action", "building"]

func tooltip():
	return "Left-click to build"

func get_mouse_pos():
	var scrpos = GS.world.get_viewport().get_mouse_position()
	var origin = GS.world.get_viewport().get_camera().project_ray_origin(scrpos)
	var normal =  GS.world.get_viewport().get_camera().project_ray_normal(scrpos)
	var rc = RayCast.new()
	GS.world.add_child(rc)
	rc.translation = origin
	rc.cast_to = normal*10000
	rc.enabled = true
	rc.force_raycast_update()
	return rc.get_collision_point()

func enter_state():
	preview = CSGCylinder.new()
	preview.radius = 4.0
	preview.translation = get_mouse_pos()
	GS.world.add_child(preview)
	return fsm.ORDER.OK

func leave_state():
	GS.world.remove_child(preview)
	preview.queue_free()
	preview = null
	return fsm.ORDER.OK

func _physics_process(delta):
	if not preview:
		return fsm.ORDER.IGNORE
	preview.translation = get_mouse_pos()
	return fsm.ORDER.IGNORE

func on_input(event):
	if event.is_action_released("object_select"):
		var building_plan = Entity.new()
		GS.world.add_child(building_plan)
		building_plan.add_interface_by_script("Body.gd", { "scene": "BuildingPlan" })
		building_plan._i("physics")._body.translation = get_mouse_pos()

		return pop_if_active()
	elif event.is_action_released("object_order"):
		return pop_if_active()
	return fsm.ORDER.IGNORE
