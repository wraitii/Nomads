extends ComponentInterface

## Builder
# Lets entities build stuff.
# This both means showing the building interface and actually building stuff.
# Though the building interface may be visible otherwise (TODO?)

const _INTERFACE = "builder"

func _init(p, data=null).(p, data):
	pass

func _get_possible_buildings():
	return ["shelter"]
