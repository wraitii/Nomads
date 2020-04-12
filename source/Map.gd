extends StaticBody

## The map is basically just flat desert.

const mat = preload('res://data/materials/desert_ground.tres')

const SCALE = 100

func _ready():
	var vertices = PoolVector3Array()
	var normals = PoolVector3Array()
	var uvs = PoolVector2Array()
	var indices = PoolIntArray()
	
	var pts = 10
	for x in range(0,pts):
		for z in range(0,pts):
			vertices.push_back(Vector3(x - pts/2.0, 0, z - pts/2.0) * SCALE / pts)
			normals.push_back(Vector3(0.0,1.0,0))
			uvs.push_back(Vector2(x,z))
			
	
	for x in range(0,9):
		for z in range(0,9):
			indices.push_back(x * 10 + z)
			indices.push_back((x+1) * 10 + z)
			indices.push_back(x * 10 + z + 1)
			indices.push_back(x * 10 + z + 1)
			indices.push_back((x+1) * 10 + z)
			indices.push_back((x+1) * 10 + z + 1)
	
	
	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_NORMAL] = normals
	arrays[ArrayMesh.ARRAY_TEX_UV] = uvs
	arrays[ArrayMesh.ARRAY_INDEX] = indices
	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var m = MeshInstance.new()
	m.mesh = arr_mesh
	var shape = m.mesh.create_trimesh_shape()
	var own = create_shape_owner(m)
	shape_owner_add_shape(own, shape)
#	body.add_child(shape)
	m.mesh.surface_set_material(0, mat)
	add_child(m)

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event.is_action_released("object_order"):
		if GS.selection.empty():
			pass
		for item in GS.selection.selection:
			GS.selection.do_action(click_position)
	if event.is_action_released("object_select"):
		GS.selection.clear()

	GS.selection.current_possible_action = "move_to_position"
