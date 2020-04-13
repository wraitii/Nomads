extends 'res://source/Interface.gd'

## ResourceGatherer
# Allows entities to pick up resources and store it in their carry.
# Entities need a carry for this to mean something.

const _INTERFACE = "resource_gatherer"

func _init(p, data=null).(p, data):
	_entity.stats.add('rg_1', {"gather_food": 1})

func _get_possible_actions(target):
	if _can_gather(target):
		return [["gather", 2]]
	return []

# Returns whether an entity can gather from something,
# not considering carry limitations (TODO?)
func _can_gather(target):
	var supply = target._i("resource_supply")
	if not supply or not _entity._i("carry"):
		return false
	for res in supply._current_supply:
		if _entity.stats['gather_' + res]:
			return true
	return false

func gather(target):
	_entity.fsm.switch_state("unit_ai_gathering", {
		"target": target
	})
	return _FSM.ORDER.OK

class Gathering extends 'res://source/MSMState.gd':
	func get_class():
		return ["unit_ai", "gathering"]

	func in_range(target):
		if target._i("area_detection")._area.overlaps_body(parent.body):
			return true
		return false

	func enter_state():
		if not itf("resource_gatherer")  or not itf("resource_gatherer")._can_gather(order_data.target):
			return fsm.ORDER.FAILURE
		
		if not in_range(order_data.target):
			if not itf("motion"):
				return fsm.ORDER.FAILURE
			if not itf("motion").move_to(order_data.target):
				return fsm.ORDER.FAILURE
			return fsm.switch_state("unit_ai_going_gathering", order_data)
		
		return fsm.ORDER.OK

	func _physics_process(delta):
		if not itf("resource_gatherer") or not itf("resource_gatherer")._can_gather(order_data.target):
			pop_if_active()
			return fsm.ORDER.IGNORE
		
		for res in order_data.target._i("resource_supply")._current_supply:
			if not 'gather_' + res in parent.stats:
				continue
			var amount = parent.stats['gather_' + res] / (1.0/delta)
			var available_amt = order_data.target._i("resource_supply")._current_supply[res]
			amount = min(amount, available_amt)
			itf("carry")._store('ress_' + res, amount)
			order_data.target._i("resource_supply")._current_supply[res] -= amount
		return fsm.ORDER.IGNORE


class GoingGathering extends 'res://source/MSMState.gd':
	func get_class():
		return ["unit_ai", "going_gathering"]

	func on_at_destination():
		return fsm.switch_state("unit_ai_gathering", order_data)

