extends ComponentInterface

const _INTERFACE = "selection_aura"

var _selection_aura = null
var _select = 0

func _init(p, data=null).(p, data):
	assert(p._i("object_picking"))
	
	_selection_aura = CSGSphere.new()
	_selection_aura.radius = 2.5
	_selection_aura.visible = false
	_selection_aura.material = preload('res://data/materials/selection.tres')
	p.add_child(_selection_aura)

	p._i("object_picking")._picking_area.connect("mouse_entered", self, "_mouse_entered")
	p._i("object_picking")._picking_area.connect("mouse_exited", self, "_mouse_exited")

func on_selected():
	_select += 1
	if _select:
		_selection_aura.visible = true
	return _FSM.ORDER.OK

func on_unselected():
	_select -= 1
	if not _select:
		_selection_aura.visible = false
	return _FSM.ORDER.OK

func _mouse_entered():
	_select += 1
	if _select:
		_selection_aura.visible = true

func _mouse_exited():
	_select -= 1
	if not _select:
		_selection_aura.visible = false

