extends Panel

func _ready():
	GS.selection.connect("selection_changed", self, "update")

func _process(delta):
	update()

func update():
	var tx = ""
	if GS.selection.current_possible_action:
		tx += GS.selection.current_possible_action + '\n'
	tx += "Selected:\n"
	for item in GS.selection.selection:
		tx += str(item) + '\n'
		for st in item.fsm._state_slots:
			tx += "Slot " + st + '\n'
			if not item.fsm._state_slots[st].empty():
				tx += "  " + item.fsm._state_slots[st][0].debug() + '\n'
	$Debug.text = tx
