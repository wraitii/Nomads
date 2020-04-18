extends Panel

func _ready():
	GS.selection.connect("selection_changed", self, "update")

func _process(delta):
	update()

func update():
	var tx = ""
	var action_state = GS.action.action_state.get_slot_state('gui_action')
	if action_state:
		if action_state.selection_actions:
			tx += str(action_state.selection_actions) + '\n'
	tx += "Selected:\n"
	for item in GS.selection.selection:
		tx += str(item) + '\n'
		for _i in item._interfaces:
			var db = item._interfaces[_i]._debug()
			if db:
				tx += "Interface " + _i + '\n'
				tx += "  " + db + '\n'
		for st in item.fsm._state_slots:
			tx += "Slot " + st + '\n'
			if not item.fsm._state_slots[st].empty():
				tx += "  " + item.fsm._state_slots[st][0].debug() + '\n'
	$Debug.text = tx
