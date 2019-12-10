extends Spatial
var map
var camera
func _ready():
	camera = get_node("/root/World/CameraBody/Camera")
	# Generate the hexagon grid map and add it as a child of the scene
	map = load("res://Map.gd").new()
	camera.set_meta("world_dimension", map.get_map_limits())
	add_child(map)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				right_click(event.position)
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				left_click(event.position)

func raycast_collider(position):
	# Detect which element is colliding with the ray cast. Return a collider dict
	var ray_length = 1000
	var from = camera.project_ray_origin(position)
	var to = from + camera.project_ray_normal(position) * ray_length
	var space_state = get_world().direct_space_state
	var collider_dict = space_state.intersect_ray(from, to, [self])
	return collider_dict

func left_click(position):
	# Function for the left click (mouse) event
	var collider_dict = raycast_collider(position)["collider"].get_meta("data")
	var reference_hex = map.get_selected_hex()
	if reference_hex && collider_dict:
		if collider_dict["type"] == "hexagon":
			var new_hex = collider_dict["local_position"]
			if reference_hex != new_hex:
				# var line_members = map.hex_linedraw(reference_hex, new_hex)
				var line_members = map.pathfinding(reference_hex, new_hex)
				map.emit_signal("show_line", line_members)
				
			
func right_click(position):
	# Function for the right click (mouse) event
	var collider_dict = raycast_collider(position)
	if collider_dict:
		if collider_dict["collider"].has_meta("data"):
			var data = collider_dict["collider"].get_meta("data")
			map.emit_signal("click", data)
			if data["type"] == "hexagon":
				# If the collider is of the type hexagon, show the neighbours
				var neighbours = map.get_neighbours(data["local_position"])
				map.emit_signal("show_neighbours", neighbours)
				map.set_selected_hex(data["local_position"])
	else:
		map.emit_signal("click_outside")