extends Panel


func _ready():
	GS.selection.connect("selection_changed", self, "on_selection_change")

var items = {}

func on_selection_change():
	var show = false
	for ent in GS.selection.selection:
		if ent._i('builder'):
			var bdgs = ent._i('builder')._get_possible_buildings()
			for bd in bdgs:
				items[bd] = true
			show = true
			break
	visible = show
	update()

func update():
	for child in $GridContainer.get_children():
		$GridContainer.remove_child(child)
		child.queue_free()
	for building in items.keys():
		var n = $BuildingIcon.duplicate()
		n.get_node("Building").text = building
		n.visible = true
		$GridContainer.add_child(n)
