extends ComponentInterface

## Aura
# Handles giving aura(s) to entities
# Auras are basically Area triggering modifiers

const _INTERFACE = "aura"

var _aura_areas = {}
var _aura_modifiers = {}

func _init(p, data=null).(p, data):
	for area_def in data.areas:
		var _body = p.get_parent()
		assert (_body is Spatial)
		var area = Area.new()
		area.input_ray_pickable = false
		var so = area.create_shape_owner(area)
		var shape = SphereShape.new()
		shape.radius = 5.0
		area.shape_owner_add_shape(so, shape)
		area.visible=true
		_body.add_child(area)
		_aura_areas[area_def['name']] = area

	for aura in data.auras:
		_aura_modifiers[aura['name']] = aura['modifiers']
		assert(aura['area'] in _aura_areas)
		_aura_areas[aura['area']].connect('body_entered', self, "_on_body_entered", [aura['name']])
		_aura_areas[aura['area']].connect('body_exited', self, "_on_body_exited", [aura['name']])

func _on_body_entered(body, aura_name):
	if not body.has_meta("entity"):
		return
	var i = 0
	for mod in _aura_modifiers[aura_name]:
		body.get_meta("entity").stats.add(aura_name + str(i), mod)
		i += 1

func _on_body_exited(body, aura_name):
	if not body.has_meta("entity"):
		return
	var i = 0
	for mod in _aura_modifiers[aura_name]:
		body.get_meta("entity").stats.remove(aura_name + str(i))
		i += 1
