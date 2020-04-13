extends Node

## MultiStateMachine
# A State Machine that can be in multiple states at once.
# Intended for AI

enum ORDER {
	FAILURE = 0,
	OK,
	IGNORE,
	POP
}

var _registered_orders = {}
var _registered_states = {}
var _slot_for_state = {}
var _registered_transitions = {}
var _slot_default_state = {}

var entity = null
var _state_slots = {}


func _init(ent):
	entity = ent

func register_order(order, who):
	if not (order in _registered_orders):
		_registered_orders[order] = []
	_registered_orders[order].push_back(who)

func register_state(obj):
	var identifier = obj.new().identifier()
	assert(not(identifier in _registered_states))
	_registered_states[identifier] = obj
	_slot_for_state[identifier] = obj.new().slot()
	_state_slots[obj.new().slot()] = []
	if obj.new().is_default_state():
		var slot = obj.new().slot()
		assert(not(slot in _slot_default_state))
		_slot_default_state[slot] = obj.new().identifier()

# TODO: switch to Lambda in 4.0
func register_transition(from, to, who):
	if not (from in _registered_transitions):
		_registered_transitions[from] = {}
	_registered_transitions[from][to] = who
	
func _init_state(state_identifier, data=null):
	var state = _registered_states[state_identifier].new()
	state._set_data(data)
	state.parent = entity
	state.fsm = self
	return state

func get_slot_state(slot):
	if not (slot in _state_slots):
		return null
	if _state_slots[slot].empty():
		return null
	return _state_slots[slot][0]

# Pushes a new state in front of the current state, inactivating the current state
# but it will be resumed once this new state is popped.
# This is implemented by duplicating the current state which is a terrible idea.
# Keeps the queue alive.
func push_state_front(state_id, data=null):
	var slot = _state_slots[_slot_for_state[state_id]]
	if slot.empty():
		return switch_state(state_id, data)
	slot.insert(1, _init_state(slot[0].identifier(), slot[0].order_data))
	return switch_state(state_id, data)

# Insert a new state after the current state and pop, entering that state.
# Keeps the queue alive.
func switch_state(state_id, data=null):
	var slot = _state_slots[_slot_for_state[state_id]]
	var state = _init_state(state_id, data)
	if slot.empty():
		slot.push_back(state)
		var ret = state._enter_state()
		if ret == ORDER.FAILURE:
			slot.pop_back()._leave_state()
		return ret
	else:
		slot.insert(1, state)
		return pop_slot(slot)

# Pop the first order and enter the new one.
# This returns whatever the _enter_state of that new state returned
# or OK if there was no new state.
func pop_slot(slot):
	var popped = slot.pop_front()
	if not slot.empty():
		var ret = null
		var trans = get_transition(popped, slot[0])
		if trans:
			ret = trans[0].callv(trans[1], [popped, slot[0]])
		else:
			popped._leave_state()
			ret = slot[0]._enter_state()
		if ret == ORDER.FAILURE:
			slot.pop_front()._leave_state()
		return ret
	else:
		popped._leave_state()
	return ORDER.OK

func process(fun, args = []):
	for slot in _state_slots:
		if _state_slots[slot].empty():
			continue
		var st = _state_slots[slot][0]
		if not st.has_method(fun):
			continue
		var ret = st.callv(fun, args)
		assert(ret != null, "No return in " + fun + " of " + st.identifier())
		if ret == ORDER.IGNORE:
			continue
		return ret

	# if here, try registered orders
	if fun in _registered_orders:
		for callb in _registered_orders[fun]:
			var ret = callb.callv(fun, args)
			assert(ret != null)
			if ret == ORDER.IGNORE:
				continue
			return ret
	
	return ORDER.IGNORE

func clear():
	for slot in _state_slots:
		if not _state_slots[slot].empty():
			_state_slots[slot][0]._leave_state()
		_state_slots[slot] = []
	_slot_default_state = {}

func _physics_process(delta):
	process('_physics_process', [delta])
	for slot in _state_slots:
		if _state_slots[slot].empty():
			if slot in _slot_default_state:
				switch_state(_slot_default_state[slot])
			continue
		if _state_slots[slot][0].active:
			continue
		if _state_slots[slot][0]._enter_state() == ORDER.FAILURE:
			_state_slots[slot].pop_front()._leave_state()


func _integrate_forces(state):
	process('_integrate_forces', [state])

func get_transition(from, to):
	if not(from in _registered_transitions):
		return
	if not(to in _registered_transitions[from]):
		return
	var t_name = "t__" + from + "__" + to
	return [_registered_transitions[from][to], t_name]
