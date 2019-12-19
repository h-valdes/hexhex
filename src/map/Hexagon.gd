extends Spatial
class_name Hexagon

var data
var mesh
var static_body

func _init(global_position, local_position, HEX_SCALE):
	# Local position is using cube coordinates
	mesh = generate_mesh(HEX_SCALE)
	data = {
		"type": "hexagon",
		"is_selected": false,
		"is_obstacle": false,
		"local_position": local_position,
		"global_position": global_position
	}	
	static_body = mesh.get_child(0)
	static_body.set_meta("data", data)
	add_child(mesh)

func set_color(color):
	# Change color of the mesh
	var material = SpatialMaterial.new()
	material.albedo_color = color
	mesh.set_material_override(material)

func _on_click(signal_data):
	var is_selected = data["is_selected"]
	if data["local_position"] == signal_data["local_position"] && !is_selected:
		set_color(Color(0.8, 0.4, 0.0))
		data["is_selected"] = true
		static_body.set_meta("data", data)
	elif data["local_position"] != signal_data["local_position"] && is_selected:
		set_color(Color(0.0, 0.69, 0.2))
		data["is_selected"] = false
		static_body.set_meta("data", data)

func _on_click_outside():
	# Change to default color if the mouse clicked outside of the map
	set_color(Color(0.0, 0.69, 0.2))
	data["is_selected"] = false
	static_body.set_meta("data", data)

func _on_show_movement_range(neighbours):
	if neighbours.has(data["local_position"]):
		set_color(Color(0, 0.5, 0.0))
	elif !data["is_selected"]:
		set_color(Color(0.0, 0.69, 0.2))

func _on_show_attack_range(neighbours):
	if neighbours.has(data["local_position"]):
		set_color(Color(0.9, 0.0, 0.0))
	elif !data["is_selected"]:
		set_color(Color(0.0, 0.69, 0.2))

func _on_show_line(members):
	if members.has(data["local_position"]):
		set_color(Color(0, 0.5, 0.5))
	elif !data["is_selected"]:
		set_color(Color(0.0, 0.69, 0.2))

func generate_mesh(HEX_SCALE):
	var st = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var material = SpatialMaterial.new()
	material.albedo_color = Color(0.0, 0.69, 0.2)
	st.set_material(material)
	
	# Triangle 1
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.25, 1.0))
	st.add_vertex(Vector3(0.5, 0.0, -0.25)*HEX_SCALE) # P4
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.25, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, -0.25)*HEX_SCALE) # P0
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.0, 0.5))
	st.add_vertex(Vector3(0.0, 0.0, -0.5)*HEX_SCALE) # P5	

	# Triangle 2
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 1.0))
	st.add_vertex(Vector3(0.5, 0.0, 0.25)*HEX_SCALE) # P3
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.25, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, -0.25)*HEX_SCALE) # P0

	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.25, 1.0))
	st.add_vertex(Vector3(0.5, 0, -0.25)*HEX_SCALE) # P4	

	# Triangle 3
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.25, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, -0.25)*HEX_SCALE) # P0
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 1.0))
	st.add_vertex(Vector3(0.5, 0.0, 0.25)*HEX_SCALE) # P3

	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, 0.25)*HEX_SCALE) # P1	

	# Triangle 4
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 0.0))
	st.add_vertex(Vector3(-0.5, 0.0, 0.25)*HEX_SCALE) # P1
	
	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(0.75, 1.0))
	st.add_vertex(Vector3(0.5, 0.0, 0.25)*HEX_SCALE) # P3

	st.add_normal(Vector3(0, 1, 0))
	st.add_uv(Vector2(1.0, 0.5))
	st.add_vertex(Vector3(0.0, 0.0, 0.5)*HEX_SCALE) # P2	

	st.index()
	
	var new_mesh = Mesh.new()
	st.commit(new_mesh)
	var mesh_inst = MeshInstance.new()
	mesh_inst.mesh = new_mesh
	mesh_inst.create_trimesh_collision()
	
	return mesh_inst
