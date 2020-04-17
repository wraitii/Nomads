extends Node
class_name ComponentInterface

const _FSM = preload('res://source/MultiStateMachine.gd')
var _entity = null

func _register_with_fsm():
	for prop in get_script().get_script_constant_map():
		if prop.begins_with('_'):
			continue
		if get_script().get_script_constant_map()[prop] is GDScript:
			var type = get(prop).new().get_class()
			assert(type != null, "FSM State " + prop + " has no defined get_class")
			_entity.fsm.register_state(get(prop))

	var props = get_script().get_script_method_list()
	for prop in props:
		if prop.name.begins_with("_"):
			continue
		if prop.name.begins_with("t_"):
			var middle = prop.name.find('__',3)
			var from = prop.name.substr(3, middle - 3)
			var to = prop.name.substr(middle + 2)
			_entity.fsm.register_transition(from, to, self)
		else:
			_entity.fsm.register_order(prop.name, self)

func _init(ent, data=null):
	_entity = ent
	_register_with_fsm()

func _deinit():
	pass

func _debug():
	return null
