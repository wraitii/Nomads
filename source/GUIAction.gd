extends 'res://source/MSMState.gd'
class_name GUIAction

## Common interface to define actions that the player can do.
# This provides two conveniences:
# - hovered keeps track of the object being hovered
# - selection_actions keeps tracks of possible actions over objects.

# Ordered list of possible selection actions
var selection_actions = []


func get_class():
	return ["gui_action", "__"]

func tooltip():
	return ""

# Sort actions from highest priority to lowest
func _sort_actions(a, b):
	return b[1] <= a[1]

func get_selection_actions(hovered):
	var actions = []
	if GS.selection.selection.empty():
		return actions
	if not hovered or not hovered._entity:
		return actions
	for ent in GS.selection.selection:
		actions += ent.get_possible_actions(hovered._entity)
	actions.sort_custom(self, '_sort_actions')
	return actions

func hovered_itf(itf):
	if not GS.action.hovered or not GS.action.hovered._entity:
		return null
	return GS.action.hovered._entity._i(itf)

################################################
### Functions below are called using 'process'
func on_input(event):
	return fsm.ORDER.OK
	
func on_selection_change():
	selection_actions = get_selection_actions(GS.action.hovered)
	return fsm.ORDER.OK

func on_hovered_change():
	selection_actions = get_selection_actions(GS.action.hovered)
	return fsm.ORDER.OK

