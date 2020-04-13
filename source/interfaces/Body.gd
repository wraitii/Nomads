extends 'res://source/Interface.gd'

## Body
# Provides a physical emanation of an object.
# This will create a cord physics object and place the entity as a child of that.

const _INTERFACE = "physics"

var _body = null

func _init(p, data).(p, data):
	if not data:
		_body = CSGBox.new()
	else:
		if 'scene' in data:
			_body = load("res://data/actors/" + data.scene + ".tscn").instance()
		else:
			_body = data.type.new()
	p.get_parent().add_child(_body)
	p.get_parent().remove_child(p)
	_body.add_child(p)

func _deinit():
	var tl = _body.get_parent()
	_entity.get_parent().remove_child(_entity)
	tl.remove_child(_body)
	tl.add_child(_entity)
	
