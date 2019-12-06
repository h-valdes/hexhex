extends Spatial

signal click
signal click_outside
const HEX_SCALE = 5
const knight = preload("res://assets/characters/knight/Knight.tscn")
func _ready():
	create(2)
	
func create(levels):
	var hex
	var all_hex = []
	var all_local_positions = {}
	var global_position = Vector3(0, 0, 0)
	var local_position = Vector3(0, 0, 0)
	var base_position = global_position
	hex = load("res://Hexagon.gd").new(global_position, local_position, HEX_SCALE)
	add_child(hex)
	connect("click", hex, "_on_click")
	connect("click_outside", hex, "_on_click_outside")
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