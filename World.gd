extends Spatial
signal click
signal click_outside
const SCALE = Vector3(2, 0, 2)

func _ready():
	var hex
	var all_hex = []
	var all_local_positions = {}
	var global_position = Vector3(0, 0, 0)
	var local_position = Vector3(0, 0, 0)
	var base_position = global_position
	hex = load("res://Hexagon.gd").new(global_position, local_position)
	add_child(hex)
	connect("click", hex, "_on_click")
	connect("click_outside", hex, "_on_click_outside")
	all_hex.push_back(global_position)
	all_local_positions[global_position] = local_position
	var new_hex = []
	var old_hex = []
	for n in range(0, 2):
		if n == 0:
			old_hex.push_back(global_position)

		for base_hex in old_hex:
			for i in range(1, 7):
				var local_vector = all_local_positions.get(base_hex)
				if i == 1:
					global_position = base_hex+ Vector3(1, 0, 0) * SCALE
					local_position =  local_vector + Vector3(1, -1, 0)
				elif i == 2:
					global_position = base_hex + Vector3(0.5, 0, 0.75) * SCALE
					local_position =  local_vector + + Vector3(0, -1, 1)
				elif i == 3:
					global_position = base_hex +Vector3(-0.5, 0, 0.75) * SCALE
					local_position =  local_vector + Vector3(-1, 0, 1)
				elif i == 4:
					global_position = base_hex + Vector3(-1, 0, 0) * SCALE
					local_position =  local_vector + Vector3(-1, 1, 0)
				elif i == 5:
					global_position = base_hex + Vector3(-0.5, 0, -0.75) * SCALE
					local_position =  local_vector + Vector3(0, 1, -1)
				elif i == 6:
					global_position = base_hex + Vector3(0.5, 0, -0.75) * SCALE
					local_position =  local_vector + Vector3(1, 0, -1)
					
				if !all_local_positions.has(global_position):
					hex = load("res://Hexagon.gd").new(global_position, local_position)
					add_child(hex)
					connect("click", hex, "_on_click")
					connect("click_outside", hex, "_on_click_outside")
					hex.translate(global_position)
					new_hex.push_back(global_position)
					all_local_positions[global_position] = local_position
		all_hex += new_hex
		old_hex = new_hex
		new_hex = []
		print(all_hex.size())

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				raycast_click(event.position)
			
func raycast_click(position):
	var ray_length = 1000
	var camera = get_node("/root/World/CameraBody/Camera")
	var from = camera.project_ray_origin(position)
	var to = from + camera.project_ray_normal(position) * ray_length
	var space_state = get_world().direct_space_state
	var collider_dict = space_state.intersect_ray(from, to, [self])
	print(collider_dict)
	if collider_dict:		
		if collider_dict["collider"].has_meta("data"):
			var data = collider_dict["collider"].get_meta("data")
			emit_signal("click", data)
	else:
		emit_signal("click_outside")
	