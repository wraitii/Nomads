extends ComponentInterface

const _INTERFACE = "health"

var _hitpoints = 100;

func _init(p, data=null).(p, data):
	pass

func _debug():
	return str(_hitpoints)

func _take_damage(amount):
	_hitpoints -= amount
	if _hitpoints <= 0:
		_entity.destroy()
