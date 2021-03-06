extends ComponentInterface

## Sandstorm component.
# Manages a bunch of hurting sub-components.
# Auto-moves around the map

const _INTERFACE = "sandstorm"

const _Entity = preload('res://source/Entity.gd')

var _sub_storms = []
var _vel = Vector2(0, 0)

func _init(p, data=null).(p, data):
	p.add_interface_by_script("Body", { "type": Spatial })
	p._i('physics')._move_by(rand_range(-5, 5),rand_range(-5, 5))
	
	var angle = rand_range(PI, -PI)
	_vel = Vector2(cos(angle), sin(angle)) * rand_range(0.4, 1.6) * 2

	var width = rand_range(3,6)
	var height = rand_range(3,6)
	for x in width:
		for z in height:
			var sub_storm = _Entity.new(p)
			sub_storm.add_interface_by_script("Body", { "scene": "SandStorm" })
			sub_storm.add_interface_by_script("TrampleDamage", { "damage": {
				"sandstorm": 1
			}})
			sub_storm._i("physics")._move_by(x*10 + rand_range(-5, 5), z * 10 + rand_range(-5, 5))
			_sub_storms.append(sub_storm)


func _physics_process(delta):
	_vel += Vector2(rand_range(0.3, -0.3), rand_range(0.3, -0.3)) * delta
	_entity._i('physics')._move_by(_vel.x * delta, _vel.y * delta)
