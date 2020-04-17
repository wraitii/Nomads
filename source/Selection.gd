extends Node

var selection = []

signal selection_changed

func _unsubscribe_to_selection():
	for ent in selection:
		ent.fsm.process("on_unselected")
		ent.disconnect('entity_destroyed', self, '_on_destroyed')

func _subscribe_to_selection():
	for ent in selection:
		ent.fsm.process("on_selected")
		ent.connect('entity_destroyed', self, '_on_destroyed')

func _on_destroyed(ent):
	selection.erase(ent)

func replace(object):
	_unsubscribe_to_selection()
	selection = [object]
	_subscribe_to_selection()
	emit_signal("selection_changed")

func clear():
	_unsubscribe_to_selection()
	selection = []
	emit_signal("selection_changed")

func empty():
	return selection.empty()

func do_action(action, data_array):
	for item in GS.selection.selection:
		item.fsm.process(action, data_array)
