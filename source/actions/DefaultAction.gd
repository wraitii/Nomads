extends GUIAction

## Default action
# Normal state of the user actions.
# Allows selection by clicking, moving the camera, etc.

func get_class():
	return ["gui_action", "default"]

func is_default_state():
	return true

func tooltip():
	return ""

func _physics_process(delta):
	for action in selection_actions:
		if len(action) > 3 and action[3]:
			selection_actions = get_selection_actions(hovered)
			return fsm.ORDER.IGNORE
	return fsm.ORDER.IGNORE

func on_input(event):
	if event.is_action_released("object_select"):
		if hovered_itf("map"):
			GS.selection.clear()
			return fsm.ORDER.OK
		if not hovered_itf("selection_aura"):
			return fsm.ORDER.IGNORE
		if event.doubleclick:
			GS.world.get_node('GameScene/Camera').track = hovered._entity
		else:
			GS.selection.replace(hovered._entity)
		return fsm.ORDER.OK

	if event.is_action_released("object_order"):
		if selection_actions.empty():
			return fsm.ORDER.IGNORE
		GS.selection.do_action(selection_actions[0][0], selection_actions[0][2])
		return fsm.ORDER.OK
	
	return fsm.ORDER.IGNORE
