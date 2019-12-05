extends Spatial
signal click
signal click_outside

func _ready():
	var hex
	var all_hex = []
	var global_position = Vector3(0, 0, 0)
	var local_position = Vector3(0, 0, 0)
	var base_position = global_position
	hex = load("res://Hexagon.gd").new(global_position, local_position)
	add_child(hex)
	connect("click", hex, "_on_click")
	connect("click_outside", hex, "_on_click_outside")
	all_hex.push_back([global_position, local_position])
	var n = 0
	for base_hex in all_hex:
		if n == 5:
			break		
		for i in range(1, 7):
			if i == 1:
				global_position = base_hex[0] + Vector3(1, 0, 0)
				local_position = base_hex[1] + Vector3(1, -1, 0)
			elif i == 2:
				global_position = base_hex[0] + Vector3(0.5, 0, 0.75)
				local_position = base_hex[1] + Vector3(0, -1, 1)
			elif i == 3:
				global_position = base_hex[0] +Vector3(-0.5, 0, -0.75)
				local_position = base_hex[1] + Vector3(-1, 0, 1)
			elif i == 4:
				global_position = base_hex[0] + Vector3(-1, 0, 0)
				local_position = base_hex[1] + Vector3(-1, 1, 0)
			elif i == 5:
				global_position = base_hex[0] + Vector3(-0.5, 0, 0.75)
				local_position = base_hex[1] + Vector3(0, 1, -1)
			elif i == 6:
				global_position = base_hex[0] + Vector3(0.5, 0, -0.75)
				local_position = base_hex[1] + Vector3(1, 0, -1)
			
			if !all_hex.has([global_position, local_position]):
				hex = load("res://Hexagon.gd").new(global_position, local_position)
				add_child(hex)
				connect("click", hex, "_on_click")
				connect("click_outside", hex, "_on_click_outside")
				hex.translate(global_position)
				all_hex.push_back([global_position, local_position])
		
		n += 1
	
	print(all_hex)

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
	if collider_dict:
		if collider_dict["collider"].has_meta("data"):
			var data = collider_dict["collider"].get_meta("data")
			emit_signal("click", data)
	else:
		emit_signal("click_outside")
	