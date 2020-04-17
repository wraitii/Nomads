extends Control

## Action Manager
# FSM to handle the current "action" state.
# The default state lets user selects entities and such.
# Might switch into 'building-mode' or drag and drop or whatever
# At the moment of writing this I'm not sold on whether instant
# actions need to be states, but probably.

# This is implemented as an FSM for large context switches,
# but note that selection is important state regardless.


const FSM = preload('res://source/MultiStateMachine.gd')

var action_state = FSM.new(self)

func _init():
	var actions = Directory.new()
	actions.open('res://source/actions')
	actions.list_dir_begin(true, true)
	var file = actions.get_next()
	while file:
		action_state.register_state(load("res://source/actions/" + file))
		file = actions.get_next()

func _enter_tree():
	add_child(action_state)
	GS.selection.connect("selection_changed", self, "on_selection_change")

func _unhandled_input(event):
	action_state.process('on_input', [event])

func set_hovered(hov):
	action_state.process('set_hovered', [hov])

func leave_hovered(hov):
	action_state.process('leave_hovered', [hov])

func on_selection_change():
	action_state.process("on_selection_change")
