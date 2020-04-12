extends ViewportContainer

# Fix for object picking
func _gui_input(event):
	get_node('Viewport').unhandled_input(event)
