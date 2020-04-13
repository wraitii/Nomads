extends Node

var selection = []
var current_possible_action = null

signal selection_changed

func _unsubscribe_to_selection():
	for ent in selection:
		ent.disconnect('entity_destroyed', self, '_on_destroyed')

func _subscribe_to_selection():
	for ent in selection:
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

func do_action(target):
	for item in selection:
		item.fsm.process(current_possible_action, [target])

func _sort_actions(a, b):
	return b[1] <= a[1]

func get_possible_action(target):
	if selection.empty():
		return null
	for item in selection:
		var actions = item.get_possible_actions(target)
		actions.sort_custom(self, '_sort_actions')
		print(actions)
		if actions:
			return actions[0][0]
