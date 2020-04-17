extends ComponentInterface

const _INTERFACE = "actionnable"

func _init(p, data=null).(p, data):
	# The Map is an entity, but it doesn't have object_picking.
	if not p._i("object_picking"):
		return
	
	#p._i("object_picking")._picking_area.connect("input_event", self, "_input_event")
	p._i("object_picking")._picking_area.connect("mouse_entered", self, "_mouse_entered")
	p._i("object_picking")._picking_area.connect("mouse_exited", self, "_mouse_exited")

func _mouse_entered():
	GS.action.set_hovered(self)

func _mouse_exited():
	GS.action.leave_hovered(self)
