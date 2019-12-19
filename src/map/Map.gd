extends Spatial

const MapUtils = preload("res://src/map/MapUtils.gd")

signal click
signal click_outside
signal show_movement_range
signal show_attack_range
signal show_line
signal move_entity

const HEX_SCALE = 5

var selected_hex
var global_positions = {}
var local_positions = {}
var entities = {}
var pathfinder
var flag_movement_range = false
var map_limits = {
	"max_x": 0,
	"min_x": 0,
	"max_z": 0,
	"min_z": 0,
}

var camera
var gui

func _init(levels, _camera, _gui):
	create(levels)
	connect("move_entity", self, "_on_move_entity")
	pathfinder = load("res://src/map/Pathfinder.gd").new(local_positions)
	camera = _camera
	gui = _gui

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				if selected_hex == null:
					select_entity(event.position)
				elif (selected_hex != null) && (flag_movement_range == true):
					select_position(event.position)
				else:
					select_entity(event.position)

func select_position(position):
	if raycast_collider(position):
		var collider_dict = raycast_collider(position)["collider"].get_meta("data")
		var reference_hex = selected_hex
		if (reference_hex != null) && collider_dict:
			if collider_dict["type"] == "hexagon":
				var new_hex = collider_dict["local_position"]
				if reference_hex != new_hex:
					var entity = entities[reference_hex]
					var neighbours = get_movement_range(reference_hex, entity.get_movement_range())
					if neighbours.has(new_hex):
						var path = pathfinder.find(reference_hex, new_hex, entities.keys())
						if path.size() > 1:
							emit_signal("show_line", path)
							if gui.get_flag_neighbours():
								emit_signal("move_entity", entity, path)
								flag_movement_range = false

func select_entity(position):
	var collider_dict = raycast_collider(position)
	if collider_dict:
		if collider_dict["collider"].has_meta("data"):
			var data = collider_dict["collider"].get_meta("data")
			emit_signal("click", data)
			if data["type"] == "hexagon":
				# If the collider is of the type hexagon, show the neighbours
				var local_position = data["local_position"]
				if has_entity(local_position):
					var entity = entities[local_position]
					if !entity.is_obstacle():
						selected_hex = local_position
						gui.set_entity(entity)
						gui.entity_actions(local_position)
					else:
						default_click_outside()
				else:
					default_click_outside()
	else:
		default_click_outside()

func default_click_outside():
	selected_hex = null
	gui.set_entity(null)
	gui.set_flag_neighbours(false)
	emit_signal("click_outside")

func raycast_collider(position):
	# Detect which element is colliding with the ray cast. Return a collider dict
	var ray_length = 1000
	var from = camera.project_ray_origin(position)
	var to = from + camera.project_ray_normal(position) * ray_length
	var space_state = get_world().direct_space_state
	var collider_dict = space_state.intersect_ray(from, to, [self])
	return collider_dict

func set_flag_movement_range(flag):
	flag_movement_range = flag

func has_entity(position):
	return entities.keys().has(position)

func add_entity(new_entity, new_local_position):
	entities[new_local_position] = new_entity

func _on_move_entity(entity, path):
	for pos in path:
		var old_global_position = global_positions[entity.get_local_position()]
		var new_global_position = global_positions[pos]
		
		entities.erase(entity.get_local_position())
		entities[pos] = entity
		entity.set_local_position(pos)
		
		var direction_vector = new_global_position - old_global_position
		# var angle = atan2(direction_vector.z, direction_vector.x)
		
		entity.global_translate(direction_vector)
		
		yield(get_tree().create_timer(0.1), "timeout")
	selected_hex = null
	emit_signal("click_outside")

func create(levels):
	var hex
	var global_position = Vector3(0, 0, 0)
	var local_position = Vector3(0, 0, 0)
	
	# Initialize the center (and first) hexagon tile
	hex = load("res://src/map/Hexagon.gd").new(global_position, local_position, HEX_SCALE)
	add_child(hex)
	connect_hex(hex)
	
	global_positions[local_position] = global_position
	local_positions[global_position] = local_position
	var new_hex = []
	var old_hex = []
	for n in range(0, levels):
		if n == 0:
			old_hex.push_back(global_position)
		for base_hex in old_hex:
			for i in range(1, 7):
				var local_vector = local_positions.get(base_hex)
				var offset1 = Vector3(1, 0, 0) / 5
				var offset2 = Vector3(0.5, 0, 0.75) / 5
				var offset3 = Vector3(-0.5, 0, 0.75) / 5
				if i == 1:
					global_position = base_hex+ Vector3(1, 0, 0) * HEX_SCALE + offset1
					local_position =  local_vector + Vector3(1, -1, 0)
				elif i == 2:
					global_position = base_hex + Vector3(0.5, 0, 0.75) * HEX_SCALE + offset2
					local_position =  local_vector + + Vector3(0, -1, 1)
				elif i == 3:
					global_position = base_hex +Vector3(-0.5, 0, 0.75) * HEX_SCALE + offset3
					local_position =  local_vector + Vector3(-1, 0, 1)
				elif i == 4:
					global_position = base_hex + Vector3(-1, 0, 0) * HEX_SCALE - offset1
					local_position =  local_vector + Vector3(-1, 1, 0)
				elif i == 5:
					global_position = base_hex + Vector3(-0.5, 0, -0.75) * HEX_SCALE - offset2
					local_position =  local_vector + Vector3(0, 1, -1)
				elif i == 6:
					global_position = base_hex + Vector3(0.5, 0, -0.75) * HEX_SCALE - offset3
					local_position =  local_vector + Vector3(1, 0, -1)
					
				if !local_positions.has(global_position):
					hex = load("res://src/map/Hexagon.gd").new(global_position, local_position, HEX_SCALE)
					add_child(hex)
					connect_hex(hex)
					hex.translate(global_position)
					new_hex.push_back(global_position)
					
					local_positions[global_position] = local_position
					global_positions[local_position] = global_position
					
					# Determine min, max values
					if global_position.x > map_limits["max_x"]:
						map_limits["max_x"] = global_position.x
					if global_position.x < map_limits["min_x"]:
						map_limits["min_x"]= global_position.x
					if global_position.z > map_limits["max_z"]:
						map_limits["max_z"] = global_position.z
					if global_position.z < map_limits["min_z"]:
						map_limits["min_z"] = global_position.z
						
		old_hex = new_hex
		new_hex = []

func connect_hex(hex):
	# Connect an Hexagon to all the signals
	connect("click", hex, "_on_click")
	connect("click_outside", hex, "_on_click_outside")
	connect("show_movement_range", hex, "_on_show_movement_range")
	connect("show_attack_range", hex, "_on_show_attack_range")
	connect("show_line", hex, "_on_show_line")
	
func get_movement_range(position, distance):
	var all_movement_range = MapUtils.get_movement_range(position, distance)
	var results = []
	for hex in all_movement_range:
		if !entities.keys().has(hex):
			var distance_to_hex = pathfinder.find(position, hex, entities.keys())
			distance_to_hex = distance_to_hex.size()
			if (distance_to_hex <= distance + 1) && (distance_to_hex > 1):
				results.push_back(hex)
	return results

func get_attack_range(position, distance):
	pass
