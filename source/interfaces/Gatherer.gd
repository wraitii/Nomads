extends 'res://source/Interface.gd'

## Gatherer
# Allows entities to pick up resources and store it in their carry.
# Entities need a carry for this to mean something.

const _INTERFACE = "gatherer"

func _init(p, data=null).(p, data):
	_entity.stats.add('rg_1', {"gather_food": 1})

func _get_possible_actions(target):
	if _can_gather(target):
		return [["gather", 2]]
	return []

# Returns whether an entity can gather from something,
# not considering own carry limitations (TODO?)
func _can_gather(target, item_type = null):
	var supply = target._i("carry")
	if not supply or not _entity._i("carry"):
		return false
	for res in supply._item_types():
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
		if not itf("gatherer")  or not itf("gatherer")._can_gather(order_data.target):
			return fsm.ORDER.FAILURE
		
		if not in_range(order_data.target):
			if not itf("motion"):
				return fsm.ORDER.FAILURE
			if not itf("motion").move_to(order_data.target):
				return fsm.ORDER.FAILURE
			return fsm.switch_state("unit_ai_going_gathering", order_data)
		
		return fsm.ORDER.OK

	func _physics_process(delta):
		if not itf("gatherer") or not itf("gatherer")._can_gather(order_data.target):
			pop_if_active()
			return fsm.ORDER.IGNORE
		
		for item_type in order_data.target._i("carry")._item_types():
			if not 'gather_' + item_type in parent.stats:
				continue
			var amount = parent.stats['gather_' + item_type] / (1.0/delta)
			var available_amt = order_data.target._i("carry")._get_stored(item_type)
			amount = min(amount, available_amt)
			itf("carry")._store(item_type, amount)
			order_data.target._i("carry")._unload(item_type, amount)
		return fsm.ORDER.IGNORE


class GoingGathering extends 'res://source/MSMState.gd':
	func get_class():
		return ["unit_ai", "going_gathering"]

	func on_at_destination():
		return fsm.switch_state("unit_ai_gathering", order_data)

