extends ComponentInterface

const _INTERFACE = "health"

var _hitpoints = 100;

func _init(p, data=null).(p, data):
	pass

func _debug():
	return str(_hitpoints)

func _take_damage(amount):
	if _entity._i('resistance'):
		amount = _entity._i('resistance')._reduce_damage(amount)
	for t in amount:
		_hitpoints -= amount[t]
	if _hitpoints <= 0:
		_entity.destroy()
