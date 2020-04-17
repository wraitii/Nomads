extends ComponentInterface

## ObjectPicking
# Adds a pickable area to the object
# Intended for other components to rely on for interaction,
# such as Actionnable or Selectable.
# Should on principle be the only pickable body of the entity, or things will break weirdly.

const _INTERFACE = "object_picking"

var _picking_area = null

func _init(p, data=null).(p, data):
	var _body = p.get_parent()
	assert (_body is Spatial)
	_picking_area = Area.new()
	var so = _picking_area.create_shape_owner(_picking_area)
	var shape = SphereShape.new()
	shape.radius = 2.5
	_picking_area.shape_owner_add_shape(so, shape)
	_body.add_child(_picking_area)
