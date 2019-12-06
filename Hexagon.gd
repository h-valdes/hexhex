extends Spatial

var id
var data
var mesh
var static_body
class_name Hexagon
const SCALE = Vector3(2, 0, 2)

func _init(global_position, local_position):
	# Local position is using cube coordinates
	mesh = generate_mesh()
	data = {
		"type": "hexagon",
		"selected": false,
		"local_position": local_position,
		"global_position": global_position
	}	
	static_body = mesh.get_child(0)
	static_body.set_meta("data", data)
	
	add_child(mesh)

func _on_click(signal_data):
	var is_selected = data["selected"]
	if data["local_position"] == signal_data["local_position"] && !is_selected:
		var material = SpatialMaterial.new()
		print(data["local_position"])
		material.albedo_color = Color(0.8, 0.4, 0.0)
		mesh.set_material_override(material)
		data["selected"] = true
		static_body.set_meta("data", data)
	elif data["local_position"] != signal_data["local_position"] && is_selected:
		var material = SpatialMaterial.new()
		material.albedo_color = Color(0.8, 0.0, 0.0)
		mesh.set_material_override(material)
		data["selected"] = false
		static_body.set_meta("data", data)

func _on_click_outside():
	if data["selected"]:
		var material = SpatialMaterial.new()
		material.albedo_color = Color(0.8, 0.0, 0.0)
		mesh.set_material_override(material)
		data["selected"] = false
		static_body.set_meta("data", data)

func generate_mesh():
	var st = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var material = SpatialMaterial.new()
	material.albedo_color = Color(0.8, 0.0, 0.0)
	st.set_material(material)
	
	# Triangle 1
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.25, 1.0))
	st.add_vertex(Vector3(0.5, 0.0, -0.25)*SCALE) # P4
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.25, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, -0.25)*SCALE) # P0
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.0, 0.5))
	st.add_vertex(Vector3(0.0, 0.0, -0.5)*SCALE) # P5	

	# Triangle 2
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 1.0))
	st.add_vertex(Vector3(0.5, 0.0, 0.25)*SCALE) # P3
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.25, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, -0.25)*SCALE) # P0

	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.25, 1.0))
	st.add_vertex(Vector3(0.5, 0, -0.25)*SCALE) # P4	

	# Triangle 3
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.25, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, -0.25)*SCALE) # P0
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 1.0))
	st.add_vertex(Vector3(0.5, 0.0, 0.25)*SCALE) # P3

	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, 0.25)*SCALE) # P1	

	# Triangle 4
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, 0.25)*SCALE) # P1
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 1.0))
	st.add_vertex(Vector3(0.5, 0.0, 0.25)*SCALE) # P3

	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(1.0, 0.5))
	st.add_vertex(Vector3(0.0, 0.0, 0.5)*SCALE) # P2	

	st.index()
	
	var mesh = Mesh.new()
	st.commit(mesh)
	var mesh_inst = MeshInstance.new()
	mesh_inst.mesh = mesh
	mesh_inst.create_trimesh_collision()
	
	return mesh_inst
