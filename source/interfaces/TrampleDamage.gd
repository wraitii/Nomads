extends ComponentInterface

## TrampleDamage
# Damages all bodies inside the given area.

const _INTERFACE = "trample_damage"

var _damage_area = null
var _dps : Dictionary = {}

func _init(p, data=null).(p, data):
	
	_dps = data.damage
	
	var _body = p.get_parent()
	assert (_body is Spatial)
	_damage_area = Area.new()
	_damage_area.input_ray_pickable = false
	var so = _damage_area.create_shape_owner(_damage_area)
	var shape = SphereShape.new()
	shape.radius = 10.0
	_damage_area.shape_owner_add_shape(so, shape)
	_body.add_child(_damage_area)

func _physics_process(delta):
	var bodies = _damage_area.get_overlapping_bodies()
	for body in bodies:
		if not body.has_meta("entity"):
			continue
		var ent = body.get_meta("entity")
		if not ent or not ent._i("health"):
			continue
		ent._i("health")._take_damage(Damage.mul(_dps, delta))

