extends Node

const MapData = preload('res://source/MapData.gd')
const Entity = preload('res://source/Entity.gd')

func _ready():
	InputMap.add_action("object_select")
	var cl = InputEventMouseButton.new()
	cl.button_index = 1
	InputMap.action_add_event("object_select", cl)

	InputMap.add_action("object_order")
	cl = InputEventMouseButton.new()
	cl.button_index = 2
	InputMap.action_add_event("object_order", cl)
	
	InputMap.add_action("create_food")
	cl = InputEventKey.new()
	cl.scancode = KEY_C
	InputMap.action_add_event("create_food", cl)

	InputMap.add_action("debug")
	cl = InputEventKey.new()
	cl.scancode = KEY_D
	InputMap.action_add_event("debug", cl)

	
	GS.world = $GameGUI/VC/Viewport
	
	GS.world.add_child(load('res://source/GameScene.tscn').instance())
	
	var pnode = load('res://source/PathfinderNode.tscn').instance()
	pnode.add_to_group("PathfinderNode")
	GS.world.add_child(pnode)
	
	GS.world.add_child(GS.action)

	GS.map_data = MapData.new()
	GS.world.add_child(GS.map_data._generate())
	
	var character = Entity.new()
	character.add_interface_by_script("Body", { "scene": "Character" })
	character.add_interface_by_script("InertialessMotion")
	character.add_interface_by_script("ResourceConsumer")
	character.add_interface_by_script("ObjectPicking")
	character.add_interface_by_script("Actionnable")
	character.add_interface_by_script("SelectionAura")
	character.add_interface_by_script("Health")
	character.add_interface_by_script("Gatherer")
	character.add_interface_by_script("InfiniteCarry")
	character.add_interface_by_script("Builder")
	character.add_interface_by_script("Resistance")
	
	var cast = RayCast.new()
	character._i("physics")._body.add_child(cast)
	cast.translation = Vector3(25,1000,25)
	cast.cast_to = Vector3(25, -10000, 25)
	cast.enabled = true
	cast.force_raycast_update()
	character._i('physics')._body.translation = cast.get_collision_point()
	
	$GameGUI/VC/Viewport/GameScene/Camera.move_to(cast.get_collision_point())

	var ss = Entity.new()
	ss.add_interface_by_script("Sandstorm")
	
func _unhandled_key_input(event):
	if event.is_action_released('debug'):
		var nodes = get_tree().get_nodes_in_group("PathfinderNode")
		for node in nodes:
			node.get_node("Debug").visible = !node.get_node("Debug").visible
		return

	if not event.is_action_released('create_food'):
		return
	
	var food_piece = Entity.new()
	food_piece.add_interface_by_script("Body")
	food_piece._i("physics")._move_by(rand_range(-50, 50),rand_range(-50, 50))
	food_piece.add_interface_by_script("AreaDetection")
	food_piece.add_interface_by_script("ObjectPicking")
	food_piece.add_interface_by_script("SelectionAura")
	food_piece.add_interface_by_script("Actionnable")
	food_piece.add_interface_by_script("InfiniteCarry")
	food_piece.add_interface_by_script("LifecycleSupply")
	food_piece._i("carry")._store('food', 5)
