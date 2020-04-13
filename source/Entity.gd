extends Node

const FSM = preload('res://source/MultiStateMachine.gd')
const Stats = preload('res://source/Stats.gd')


signal entity_destroyed(ent)

var _interfaces = {}

var fsm = FSM.new(self)
var stats = Stats.new()

func _init():
	add_child(fsm)

func add_interface_by_script(itf_name, data=null):
	add_interface(load("res://source/interfaces/" + itf_name), data)

func add_interface(itf, data=null):
	_interfaces[itf._INTERFACE] = itf.new(self, data)
	add_child(_interfaces[itf._INTERFACE])

func get_possible_actions(target):
	var acts = []
	for _i in _interfaces:
		var itf = _interfaces[_i]
		if itf.has_method("_get_possible_actions"):
			acts += itf._get_possible_actions(target)
	return acts

func _i(x):
	if x in _interfaces:
		return _interfaces[x]

# Delete an entity
func destroy():
	emit_signal("entity_destroyed", self)
	fsm.clear()
	for _i in _interfaces:
		_interfaces[_i]._deinit()
	get_parent().call_deferred("remove_child", self)
	call_deferred("queue_delete", self)

## Below are some useful shortcuts

var translation setget fake_setter, get_translation
var body setget fake_setter, get_body

func fake_setter(x):
	assert(false, "Not implemented")

func get_translation():
	return _i('physics')._body.translation

func get_body():
	return _i('physics')._body

