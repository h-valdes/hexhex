extends Spatial

const MapUtils = preload("res://src/map/MapUtils.gd")

signal click
signal click_outside
signal show_neighbours
signal show_line
signal move_entity

const HEX_SCALE = 5

var selected_hex
var global_positions = {}
var local_positions = {}
var entities = {}
var pathfinder
var map_limits = {
	"max_x": 0,
	"min_x": 0,
	"max_z": 0,
	"min_z": 0,
}

func _init(levels):
	create(levels)
	connect("move_entity", self, "_on_move_entity")
	pathfinder = load("res://src/map/Pathfinder.gd").new(local_positions)

func get_selected_hex():
	return selected_hex

func set_selected_hex(position):
	selected_hex = position

func get_map_limits():
	return map_limits

func get_local_positions():
	return local_positions

func get_global_positions():
	return global_positions

func has_entity(position):
	return entities.keys().has(position)

func get_entities():
	return entities

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
		var angle = atan2(direction_vector.z, direction_vector.x)
		
		entity.global_translate(direction_vector)
		
		yield(get_tree().create_timer(0.1), "timeout")
	set_selected_hex(null)
	emit_signal("click_outside")

func get_entity(position):
	return entities[position]
	
func create(levels):
	var hex
	var global_position = Vector3(0, 0, 0)
	var local_position = Vector3(0, 0, 0)
	
	# Initialize the center (and first) hexagon tile
	hex = load("res://src/map/Hexagon.gd").new(global_position, local_position, HEX_SCALE)
	add_child(hex)
	connect("click", hex, "_on_click")
	connect("click_outside", hex, "_on_click_outside")
	connect("show_neighbours", hex, "_on_show_neighbours")
	connect("show_line", hex, "_on_show_line")	
	
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
					connect("click", hex, "_on_click")
					connect("click_outside", hex, "_on_click_outside")
					connect("show_neighbours", hex, "_on_show_neighbours")
					connect("show_line", hex, "_on_show_line")
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

func get_neighbours(local_vector):
	return MapUtils.get_neighbours(local_vector, local_positions, entities.keys())
	
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
	
func hex_linedraw(a, b):
	var N = MapUtils.get_distance(a, b)
	var results = []
	for i in range(0, N+1):
		results.push_back(MapUtils.hex_round(MapUtils.hex_lerp(a, b, 1.0/N * i)))
	return results

func get_shortest_path(start, goal):
	return pathfinder.find(start, goal, entities.keys())