extends 'res://source/Interface.gd'

const _INTERFACE = "selectable"

func _init(p, data=null).(p, data):
	var itf = p._i('area_detection')
	if itf:
		itf = itf._area
	else:
		itf = p._i('physics')
		if itf:
			itf = itf._body
		else:
			return
	
	itf.connect("input_event", self, "_input_event")
	itf.connect("mouse_entered", self, "_mouse_entered")
	itf.connect("mouse_exited", self, "_mouse_exited")

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event.is_action_released("object_select"):
		GS.selection.replace(_entity)
	elif event.is_action_released("object_order"):
		GS.selection.do_action(_entity)

func _mouse_entered():
	GS.selection.current_possible_action = GS.selection.get_possible_action(_entity)

func _mouse_exited():
	GS.selection.current_possible_action = null
