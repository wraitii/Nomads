extends ComponentInterface

const _INTERFACE = "carry"

var _carrying = {};

signal store(ent_carry, item_type, amount)
signal unload(ent_carry, item_type, amount)

func _init(p, data=null).(p, data):
	pass

func _debug():
	return str(_carrying)

func _store(item_type, amount):
	if not (item_type in _carrying):
		_carrying[item_type] = 0
	_carrying[item_type] += amount
	emit_signal('store', self, item_type, amount)

func _unload(item_type, amount):
	if not (item_type in _carrying):
		return false
	if _carrying[item_type] + 0.001 < amount:
		return false
	_carrying[item_type] -= amount;
	if _carrying[item_type] <= 0:
		_carrying.erase(item_type)
	emit_signal('unload', self, item_type, amount)
	return true

func _has_stored(item_type, amount = null):
	if not (item_type in _carrying):
		return false
	return not amount or _carrying[item_type] >= amount

func _get_stored(item_type):
	if not (item_type in _carrying):
		return 0
	return _carrying[item_type]

func _empty():
	return len(_carrying) == 0

func _item_types():
	return _carrying.keys()
