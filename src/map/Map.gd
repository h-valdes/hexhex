extends Spatial

const MapUtils = preload("res://src/map/MapUtils.gd")

signal click
signal click_outside
signal show_neighbours
signal show_line
const HEX_SCALE = 5

var selected_hex
var all_hex = []
var local_positions = {}
var obstacle_positions = []
var pathfinder
var map_limits = {
	"max_x": 0,
	"min_x": 0,
	"max_z": 0,
	"min_z": 0,
}

func _init(levels):
	create(levels)
	pathfinder = load("res://src/map/Pathfinder.gd").new(local_positions, obstacle_positions)
	add_random_knights(10)

func get_selected_hex():
	return selected_hex

func set_selected_hex(position):
	selected_hex = position

func get_map_limits():
	return map_limits

func get_local_positions():
	return local_positions
	
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
	
	all_hex.push_back(global_position)
	local_positions[global_position] = local_position
	var new_hex = []
	var old_hex = []
	for n in range(0, levels):
		if n == 0:
			old_hex.push_back(global_position)
		for base_hex in old_hex:
			for i in range(1, 7):
				var local_vector = local_positions.get(base_hex)
				if i == 1:
					global_position = base_hex+ Vector3(1, 0, 0) * HEX_SCALE
					local_position =  local_vector + Vector3(1, -1, 0)
				elif i == 2:
					global_position = base_hex + Vector3(0.5, 0, 0.75) * HEX_SCALE
					local_position =  local_vector + + Vector3(0, -1, 1)
				elif i == 3:
					global_position = base_hex +Vector3(-0.5, 0, 0.75) * HEX_SCALE
					local_position =  local_vector + Vector3(-1, 0, 1)
				elif i == 4:
					global_position = base_hex + Vector3(-1, 0, 0) * HEX_SCALE
					local_position =  local_vector + Vector3(-1, 1, 0)
				elif i == 5:
					global_position = base_hex + Vector3(-0.5, 0, -0.75) * HEX_SCALE
					local_position =  local_vector + Vector3(0, 1, -1)
				elif i == 6:
					global_position = base_hex + Vector3(0.5, 0, -0.75) * HEX_SCALE
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
					
					# Determine min, max values
					if global_position.x > map_limits["max_x"]:
						map_limits["max_x"] = global_position.x
					if global_position.x < map_limits["min_x"]:
						map_limits["min_x"]= global_position.x
					if global_position.z > map_limits["max_z"]:
						map_limits["max_z"] = global_position.z
					if global_position.z < map_limits["min_z"]:
						map_limits["min_z"] = global_position.z
						
		all_hex += new_hex
		old_hex = new_hex
		new_hex = []

func get_neighbours(local_vector):
	return MapUtils.get_neighbours(local_vector, local_positions, obstacle_positions)

func hex_linedraw(a, b):
	var N = MapUtils.get_distance(a, b)
	var results = []
	for i in range(0, N+1):
		results.push_back(MapUtils.hex_round(MapUtils.hex_lerp(a, b, 1.0/N * i)))
	return results

func get_shortest_path(start, goal):
	return pathfinder.find(start, goal)

func add_random_knights(count):
	while count > 0:
		var knight = load("res://entities/knight/knight.gd").new()
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var random_index = rng.randi_range(0, all_hex.size() - 1)
		var kn_global_position = all_hex[random_index]
		var kn_local_position = local_positions[kn_global_position]
		if !obstacle_positions.has(kn_local_position):
			add_child(knight)
			knight.translate(kn_global_position)
			obstacle_positions.push_back(kn_local_position)
			count -= 1