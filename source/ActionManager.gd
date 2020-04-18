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

# This is the 'actionnable' interface of the object being hovered.
var hovered = null

# Unhandled click doesn't do double-click so re-implement manually.
var last_click_ent = null
var last_click_time = null

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
	if event is InputEventMouseButton and not event.pressed:
		var e = hovered
		var t = OS.get_ticks_msec()
		if e == last_click_ent and last_click_time and t - last_click_time < 300:
			# TODO: handle on my own
			event.doubleclick = true
		last_click_ent = e
		last_click_time = t
	
	var handling = action_state.process('on_input', [event])
	if handling != FSM.ORDER.IGNORE:
		accept_event()

func set_hovered(hov):
	hovered = hov
	return action_state.process("on_hovered_change")

func leave_hovered(hov):
	if hovered == hov:
		hovered = null
		return action_state.process("on_hovered_change")

func on_selection_change():
	action_state.process("on_selection_change")
