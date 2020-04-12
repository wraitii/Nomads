extends Node

const Map = preload('res://source/Map.tscn')
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
	
	
	GS.world = $GameGUI/VC/Viewport
	
	var cam = Camera.new()
	cam.look_at_from_position(Vector3(-25,25,-25), Vector3(0,0,0), Vector3(0,1,0))
	cam.current = true
	cam.far = 1000
	GS.world.add_child(cam)
	
	var l = DirectionalLight.new()
	l.look_at_from_position(Vector3(0, 50, 0), Vector3(0,0,0), Vector3(1,0,0))
	GS.world.add_child(l)
	
	var map = Map.instance()
	GS.world.add_child(map)
	
	var character = Entity.new()
	GS.world.add_child(character)
	character.add_interface_by_script("Body.gd", { "scene": "Character" })
	character.add_interface_by_script("InertialessMotion.gd")
	character.add_interface_by_script("ResourceConsumer.gd")
	character.add_interface_by_script("Selectable.gd")

	#character.translation = Vector3(0,1,0)

func _unhandled_key_input(event):
	if not event.is_action_released('create_food'):
		return
	
	var food_piece = Entity.new()
	GS.world.add_child(food_piece)
	food_piece.add_interface_by_script("Body.gd")
	food_piece._i("physics")._body.translation = Vector3(rand_range(-50, 50),0,rand_range(-50, 50))
	food_piece.add_interface_by_script("AreaDetection.gd")
	food_piece.add_interface_by_script("Selectable.gd")
	food_piece.add_interface_by_script("ResourceSupply.gd")
