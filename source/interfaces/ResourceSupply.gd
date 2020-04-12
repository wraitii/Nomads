extends 'res://source/Interface.gd'

## ResourceSupply
# Entities can provide resources.

const _INTERFACE = "resource_supply"
var _current_supply = {}

func _init(p, data=null).(p, data):
	_current_supply['food'] = 10
