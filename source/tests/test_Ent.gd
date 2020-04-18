extends Node

const Entity = preload('res://source/Entity.gd')

func _init():
	var ent = Entity.new(self)
	ent.set_name("test_node")

	print_tree_pretty()

	#ent.add_interface_by_script("Body.gd")
	ent.add_interface_by_script("Sandstorm.gd")
	print_tree_pretty()
