extends GUIAction

## Building action
# User's mouse should show a preview of the building and helpful info
# Clicking plops down a plan. Right-clicking discards.

var preview

func get_class():
	return ["gui_action", "building"]

func tooltip():
	return "Left-click to build"

func enter_state():
	preview = CSGCylinder.new()
	preview.radius = 4.0
	preview.translation = GS.camera.raycast()
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
	preview.translation = GS.camera.raycast()
	return fsm.ORDER.IGNORE

func on_input(event):
	if event.is_action_released("object_select"):
		# TODO: plot down building plans instead of actual buildings
		var building = Entity.new().from_ress(order_data)
		building._i("physics")._body.translation = GS.camera.raycast()

		return pop_if_active()
	elif event.is_action_released("object_order"):
		return pop_if_active()
	return fsm.ORDER.IGNORE
