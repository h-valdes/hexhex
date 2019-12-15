extends Spatial
var map
var camera
var gui

func _ready():
	# Add GUI scene to game
	gui = load("res://src/interface/UI.tscn")
	gui = gui.instance()
	add_child(gui)
	
	camera = get_node("/root/World/CameraBody/Camera")
	
	# Generate the hexagon grid map and add it as a child of the scene
	map = load("res://src/map/Map.gd").new(3)
	add_child(map)
	
	gui.set_map(map)
	
	camera.set_meta("world_dimension", map.get_map_limits())

	load_characters()

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
	if raycast_collider(position):
		var collider_dict = raycast_collider(position)["collider"].get_meta("data")
		var reference_hex = map.get_selected_hex()
		if (reference_hex != null) && collider_dict:
			if collider_dict["type"] == "hexagon":
				var new_hex = collider_dict["local_position"]
				if reference_hex != new_hex:
					# var line_members = map.hex_linedraw(reference_hex, new_hex)
					var path = map.get_shortest_path(reference_hex, new_hex)
					map.emit_signal("show_line", path)
					if gui.has_entity():
						gui.display_actions(new_hex, path)
					
func right_click(position):
	# Function for the right click (mouse) event
	var collider_dict = raycast_collider(position)
	if collider_dict:
		if collider_dict["collider"].has_meta("data"):
			var data = collider_dict["collider"].get_meta("data")
			map.emit_signal("click", data)
			if data["type"] == "hexagon":
				# If the collider is of the type hexagon, show the neighbours
				var local_position = data["local_position"]
				if map.has_entity(local_position):
					var entity = map.get_entity(local_position)
					if !entity.is_obstacle():
						var neighbours = map.get_neighbours(local_position)
						map.emit_signal("show_neighbours", neighbours)
						map.set_selected_hex(local_position)
						gui.set_entity(entity)
					else:
						map.emit_signal("click_outside")
				else:
					gui.set_entity(null)
					map.emit_signal("click_outside")
	else:
		map.emit_signal("click_outside")

func load_characters():
	var global_positions = map.get_global_positions()
	var local_positions = map.get_local_positions()
	var entities = map.get_entities()

	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_index = rng.randi_range(0, global_positions.size() - 1)
	
	var global_position = global_positions.values()[random_index]
	var local_position = local_positions[global_position]

	if !entities.keys().has(local_position):
		var knight = load("res://src/knight/knight.gd").new()
		add_child(knight)
		knight.translate(global_position)
		knight.set_local_position(local_position)
		map.add_entity(knight, local_position)
	
	for x in range(0, 10):
		entities = map.get_entities()
		rng = RandomNumberGenerator.new()
		rng.randomize()
		random_index = rng.randi_range(0, global_positions.size() - 1)
		
		global_position = global_positions.values()[random_index]
		local_position = local_positions[global_position]

		if !entities.keys().has(local_position):
			var tree = load("res://src/tree/tree.gd").new()
			add_child(tree)
			tree.translate(global_position)
			tree.set_local_position(local_position)
			map.add_entity(tree, local_position)