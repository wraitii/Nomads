extends StaticBody

## The map is basically just flat desert.

const mat = preload('res://data/materials/desert_ground.tres')

const SCALE = 100
const VSCALE = SCALE/50
const POINTS = 10

var piece_x = 0
var piece_y = 0

func _generate(map_gen):
	var vertices = PoolVector3Array()
	var normals = PoolVector3Array()
	var uvs = PoolVector2Array()
	var indices = PoolIntArray()
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.add_smooth_group(true)
	
	for x in range(-1, POINTS+2):
		for z in range(-1, POINTS+2):
			st.add_uv(Vector2(x,z))
			var pt = Vector3(x - POINTS/2.0, 0, z - POINTS/2.0) * (SCALE / 2) / (POINTS/2)
			pt.y = map_gen.get_height(piece_x, x, piece_y, z)*VSCALE
			st.add_vertex(pt)

	# Skip the surrounding vertices which are there to generate correct normals
	for x in range(1,POINTS+1):
		for z in range(1,POINTS+1):
			st.add_index(x * (POINTS+3) + z)
			st.add_index((x+1) * (POINTS+3) + z)
			st.add_index(x * (POINTS+3) + z + 1)
			st.add_index(x * (POINTS+3) + z + 1)
			st.add_index((x+1) * (POINTS+3) + z)
			st.add_index((x+1) * (POINTS+3) + z + 1)
	
	st.generate_normals()
	
	# Initialize the ArrayMesh.
	var arr_mesh = st.commit()
	var m = MeshInstance.new()
	m.mesh = arr_mesh
	var shape = m.mesh.create_trimesh_shape()
	var own = create_shape_owner(m)
	shape_owner_add_shape(own, shape)
#	body.add_child(shape)
	m.mesh.surface_set_material(0, mat)
	add_child(m)

func _input_event(camera, event, click_position, click_normal, shape_idx):
	pass
#	if event.is_action_released("object_order"):
#		if GS.selection.empty():
#			pass
#		for item in GS.selection.selection:
#			GS.selection.do_action(click_position)
#	if event.is_action_released("object_select"):
#		GS.selection.clear()
#	elif event.is_action("object_select") and event.doubleclick:
#		GS.world.get_node('GameScene/Camera').move_to(click_position)
#
#	GS.selection.current_possible_action = "move_to_position"
