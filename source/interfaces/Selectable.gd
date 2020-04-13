extends 'res://source/Interface.gd'

const _INTERFACE = "selectable"

var _select_area = null
var _selection_aura

func _init(p, data=null).(p, data):
	var _body = p.get_parent()
	assert (_body is Spatial)
	_select_area = Area.new()
	var so = _select_area.create_shape_owner(_select_area)
	var shape = SphereShape.new()
	shape.radius = 2.5
	_select_area.shape_owner_add_shape(so, shape)
	_body.add_child(_select_area)

	_selection_aura = CSGSphere.new()
	_selection_aura.radius = 2.5
	_selection_aura.visible = false
	_selection_aura.material = preload('res://data/materials/selection.tres')
	_select_area.add_child(_selection_aura)
	
	_select_area.connect("input_event", self, "_input_event")
	_select_area.connect("mouse_entered", self, "_mouse_entered")
	_select_area.connect("mouse_exited", self, "_mouse_exited")

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event.is_action_released("object_select"):
		GS.selection.replace(_entity)
	elif event.is_action_released("object_order"):
		GS.selection.do_action(_entity)

func _mouse_entered():
	_selection_aura.visible = true
	GS.selection.current_possible_action = GS.selection.get_possible_action(_entity)

func _mouse_exited():
	_selection_aura.visible = false
	GS.selection.current_possible_action = null
