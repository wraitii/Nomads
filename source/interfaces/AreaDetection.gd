extends ComponentInterface

## AreaDetection
# Provides an area to detect collisions with for the object.

const _INTERFACE = "area_detection"

var _area = null

func _init(p, data=null).(p, data):
	var _body = p.get_parent()
	assert (_body is Spatial)
	_area = Area.new()
	_area.input_ray_pickable = false
	var so = _area.create_shape_owner(_area)
	var shape = SphereShape.new()
	shape.radius = 2.0
	_area.shape_owner_add_shape(so, shape)
	_body.add_child(_area)
	
#	_area.connect("body_entered", self, "on_entered")

#func on_entered(body):
#	p.fsm.process("on_collision", [body])
