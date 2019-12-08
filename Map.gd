extends Spatial

signal click
signal click_outside
signal show_neighbours
const HEX_SCALE = 5
const knight = preload("res://assets/characters/knight/Knight.tscn")
var selected_hex
func _ready():
	create(3)

func get_selected_hex():
	return selected_hex

func set_selected_hex(position):
	selected_hex = position
	
func create(levels):
	var hex
	var all_hex = []
	var all_local_positions = {}
	var global_position = Vector3(0, 0, 0)
	var local_position = Vector3(0, 0, 0)
	var base_position = global_position
	# Initialize the center (and first) hexagon tile
	hex = load("res://Hexagon.gd").new(global_position, local_position, HEX_SCALE)
	add_child(hex)
	connect("click", hex, "_on_click")
	connect("click_outside", hex, "_on_click_outside")
	connect("show_neighbours", hex, "_on_show_neighbours")
	all_hex.push_back(global_position)
	all_local_positions[global_position] = local_position
	var new_hex = []
	var old_hex = []
	for n in range(0, levels):
		if n == 0:
			old_hex.push_back(global_position)
		for base_hex in old_hex:
			for i in range(1, 7):
				var local_vector = all_local_positions.get(base_hex)
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
					
				if !all_local_positions.has(global_position):
					hex = load("res://Hexagon.gd").new(global_position, local_position, HEX_SCALE)
					add_child(hex)
					connect("click", hex, "_on_click")
					connect("click_outside", hex, "_on_click_outside")
					connect("show_neighbours", hex, "_on_show_neighbours")
					hex.translate(global_position)
					new_hex.push_back(global_position)
					all_local_positions[global_position] = local_position
					
					# Add Figure over Hex
					var kn = knight.instance()
					add_child(kn)
					kn.translate(global_position)
		all_hex += new_hex
		old_hex = new_hex
		new_hex = []
		print(all_hex.size())

func get_neighbours(local_vector):
	var neighbours = []
	neighbours.push_back(local_vector + Vector3(1, -1, 0))
	neighbours.push_back(local_vector + + Vector3(0, -1, 1))
	neighbours.push_back(local_vector + Vector3(-1, 0, 1))
	neighbours.push_back(local_vector + Vector3(-1, 1, 0))
	neighbours.push_back(local_vector + Vector3(0, 1, -1))
	neighbours.push_back(local_vector + Vector3(1, 0, -1))
	return neighbours

func get_distance(pos1, pos2):
	var distance = (abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y) + abs(pos1.z - pos2.z))/2
	return distance

func hex_round(hex):
	var rx = round(hex.x)
	var ry = round(hex.y)
	var rz = round(hex.z)
	
	var x_diff = abs(rx - hex.x)
	var y_diff = abs(ry - hex.y)
	var z_diff = abs(rz - hex.z)
	
	if x_diff > y_diff and x_diff > z_diff:
		rx = -ry-rz
	elif y_diff > z_diff:
		ry = -rx-rz
	else:
		rz = -rx-ry
	
	return Vector3(rx, ry, rz)

func general_lerp(a, b, t):
	return a + (b - a) * t

func hex_lerp(a, b, t):
	return Vector3(general_lerp(a.x, b.x, t), 
				general_lerp(a.y, b.y, t), 
				general_lerp(a.z, b.z, t))

func hex_linedraw(a, b):
	var N = get_distance(a, b)
	var results = []
	for i in range(0, N+1):
		results.push_back(hex_round(hex_lerp(a, b, 1.0/N * i)))
	return results