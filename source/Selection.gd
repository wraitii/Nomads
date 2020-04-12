extends Node

var selection = []
var current_possible_action = null

signal selection_changed



func replace(object):
	selection = [object]
	emit_signal("selection_changed")

func clear():
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
