extends 'res://source/Interface.gd'

## ResourceConsumer
# This interface makes entities require a steady supply
# of given resources, or die.

const _INTERFACE = "resource_consumer"
var _current_supply = {}

func _init(p, data=null).(p, data):
	_entity.stats.add('rc_food1', {"res_cons_rate_food": 1})
	_entity.stats.add('rc_food3', {"res_eating_rate_food": 3})
	_entity.stats.add('rc_food2', {"max_food": 10})
	
	_current_supply['food'] = _entity.stats['max_food']

func _get_possible_actions(target):
	if _can_eat(target):
		return [["eat", 1]]
	return []

func eat(target):
	_entity.fsm.switch_state("unit_ai_eating", {
		"target": target
	})
	return _FSM.ORDER.OK

func _can_eat(target):
	return _can_eat_from_supply(target) or _can_eat_from_carry(target)

func _can_eat_from_supply(target, ress = null):
	var supply = target._i("resource_supply")
	if not supply:
		return false
	for res in _current_supply:
		if ress and res != ress:
			continue
		if _current_supply[res] >= _entity.stats['max_food']:
			continue
		if res in supply._current_supply and supply._current_supply[res] > 0:
			return true
	return false

func _can_eat_from_carry(target, ress = null):
	# TODO: check we are allowed to eat from that carry
	var carry = target._i("carry")
	if not carry:
		return false
	for res in _current_supply:
		if ress and res != ress:
			continue
		if _current_supply[res] >= _entity.stats['max_food']:
			continue
		if carry._has_stored('ress_' + res):
			return true
	return false

class Idle extends 'res://source/MSMState.gd':
	func get_class():
		return ["resource_consumer", "idle"]
	
	func is_default_state():
		return true
	
	func debug():
		var tx = PoolStringArray()
		for res in itf()._current_supply:
			tx.push_back(res + ':' + str(itf()._current_supply[res]))
		return tx.join('/')

	func _physics_process(delta):
		var starving = false
		for res in itf()._current_supply:
			if not 'res_cons_rate_' + res in parent.stats:
				continue
			itf()._current_supply[res] -= parent.stats['res_cons_rate_' + res] / (1.0/delta)
			
			if itf()._current_supply[res] <= 2:
				if itf("carry") and itf("carry")._has_stored('ress_' + res):
					if fsm.get_slot_state('unit_ai') != "unit_ai_eating":
						fsm.push_state_front('unit_ai_eating', { "target": parent })
					elif fsm.get_slot_state('unit_ai') != "unit_ai_going_eating":
						fsm.push_state_front('unit_ai_eating', { "target": parent })
			if itf()._current_supply[res] <= 0:
				itf()._current_supply[res] = 0
				starving = true
		if starving:
			return fsm.switch_state('resource_consumer_starving')
		return fsm.ORDER.IGNORE

class Starving extends 'res://source/MSMState.gd':
	func get_class():
		return ["resource_consumer", "starving"]

	func _physics_process(delta):
		var still_starving = false
		for res in itf()._current_supply:
			if itf()._current_supply[res] <= 0:
				still_starving = true
		if not still_starving:
			fsm.switch_state("resource_consumer_idle")
			return fsm.ORDER.IGNORE
		
		if not itf("health"):
			return fsm.ORDER.IGNORE
		
		itf("health")._take_damage(1);
		
		return fsm.ORDER.IGNORE

class AIEating extends 'res://source/MSMState.gd':
	func get_class():
		return ["unit_ai", "eating"]

	func in_range(target):
		if target == parent:
			return true
		if target._i("area_detection")._area.overlaps_body(parent.body):
			return true
		return false

	func enter_state():
		if not itf("resource_consumer") or not itf("resource_consumer")._can_eat(order_data.target):
			return fsm.ORDER.FAILURE
		
		if not in_range(order_data.target):
			if not itf("motion"):
				return fsm.ORDER.FAILURE
			if not itf("motion").move_to(order_data.target):
				return fsm.ORDER.FAILURE
			return fsm.switch_state("unit_ai_going_eating", order_data)
		
		return fsm.ORDER.OK

	func _physics_process(delta):
		if not itf("resource_consumer") or not itf("resource_consumer")._can_eat(order_data.target):
			fsm.switch_state("resource_consumer_idle")
			return fsm.ORDER.IGNORE

		for res in itf("resource_consumer")._current_supply:
			if not 'res_eating_rate_' + res in parent.stats:
				continue
			var amount = parent.stats['res_eating_rate_' + res] / (1.0/delta)

			if itf('resource_consumer')._can_eat_from_supply(order_data.target, res):
				var available_amt = order_data.target._i("resource_supply")._current_supply[res]
				amount = min(amount, available_amt)
				itf("resource_consumer")._current_supply[res] += amount
				order_data.target._i("resource_supply")._current_supply[res] -= amount
			elif itf('resource_consumer')._can_eat_from_carry(order_data.target, res):
				var available_amt = order_data.target._i("carry")._get_stored('ress_' + res)
				amount = min(amount, available_amt)
				itf("resource_consumer")._current_supply[res] += amount
				order_data.target._i("carry")._unload('ress_' + res, amount)
		return fsm.ORDER.IGNORE


class AI_waiting_Eating extends 'res://source/MSMState.gd':
	func get_class():
		return ["unit_ai", "going_eating"]

	func on_at_destination():
		return fsm.switch_state("unit_ai_eating", order_data)

