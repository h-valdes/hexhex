extends Spatial

var id
var data
var mesh
var static_body
class_name Square

func _init(new_id):
	mesh = generate_mesh()
	id = new_id
	data = {
		"id": id,
		"type": "square",
		"selected": false,
	}	
	static_body = mesh.get_child(0)
	static_body.set_meta("data", data)
	
	add_child(mesh)

func _on_click(signal_data):
	var is_selected = data["selected"]
	if data["id"] == signal_data["id"] && !is_selected:
		var material = SpatialMaterial.new()
		print("Clicked id: " + str(data["id"]))
		material.albedo_color = Color(0.8, 0.4, 0.0)
		mesh.set_material_override(material)
		data["selected"] = true
		static_body.set_meta("data", data)
	elif data["id"] != signal_data["id"] && is_selected:
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
	st.add_vertex(Vector3(0.5, 0.0, -0.25)) # P4
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.25, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, -0.25)) # P0
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.0, 0.5))
	st.add_vertex(Vector3(0.0, 0.0, -0.5)) # P5	

	# Triangle 2
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 1.0))
	st.add_vertex(Vector3(0.5, 0.0, 0.25)) # P3
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.25, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, -0.25)) # P0

	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.25, 1.0))
	st.add_vertex(Vector3(0.5, 0, -0.25)) # P4	

	# Triangle 3
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.25, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, -0.25)) # P0
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 1.0))
	st.add_vertex(Vector3(0.5, 0.0, 0.25)) # P3

	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, 0.25)) # P1	

	# Triangle 4
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, 0.25)) # P1
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 1.0))
	st.add_vertex(Vector3(0.5, 0.0, 0.25)) # P3

	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(1.0, 0.5))
	st.add_vertex(Vector3(0.0, 0.0, 0.5)) # P2	

	st.index()
	
	var mesh = Mesh.new()
	st.commit(mesh)
	var mesh_inst = MeshInstance.new()
	mesh_inst.mesh = mesh
	mesh_inst.create_trimesh_collision()
	
	return mesh_inst
