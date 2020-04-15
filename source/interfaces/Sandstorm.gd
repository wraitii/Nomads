extends 'res://source/Interface.gd'

## Sandstorm component.
# Manages a bunch of hurting sub-components.
# Auto-moves around the map

const _INTERFACE = "sandstorm"

const _Entity = preload('res://source/Entity.gd')

var _sub_storms = []

func _init(p, data=null).(p, data):
	for i in range(randi() % 3 + 4):
		var sub_storm = _Entity.new()
		GS.world.add_child(sub_storm)
		sub_storm.add_interface_by_script("Body.gd", { "scene": "SandStorm" })
		sub_storm.add_interface_by_script("TrampleDamage.gd")
		sub_storm._i("physics")._move_to(rand_range(-5, 5),rand_range(-5, 5))
		_sub_storms.append(sub_storm)
