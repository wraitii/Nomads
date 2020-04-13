extends Reference

var parent = null
var fsm = null

var order_data = null

var active = false

func get_class():
	return null

func identifier():
	return get_class()[0] + "_" + get_class()[1]

func slot():
	return get_class()[0]

func is_default_state():
	return false

func _init():
	assert(get_class() != null)

func _set_data(data=null):
	order_data = data
	return self

func debug():
	return identifier()

func _enter_state():
	active = true
	return enter_state()

func enter_state():
	return fsm.ORDER.OK

func _leave_state():
	leave_state()
	active = false

func leave_state():
	pass

func pop_if_active():
	if fsm._state_slots[slot()].empty():
		return
	if fsm._state_slots[slot()][0] != self:
		return
	fsm.pop_slot(fsm._state_slots[slot()])

func itf(interface = null):
	if not interface:
		return parent._interfaces[slot()]
	else:
		return parent._interfaces[interface]
