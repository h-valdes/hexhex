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
	map = load("res://src/map/Map.gd").new(3, camera, gui)
	add_child(map)
	
	gui.set_map(map)
	
	camera.set_meta("world_dimension", map.map_limits)

	load_characters()

func load_characters():
	var global_positions = map.global_positions
	var local_positions = map.local_positions
	var entities = map.entities
	
	for x in range(0, 10):
		entities = map.entities
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var random_index = rng.randi_range(0, global_positions.size() - 1)
		
		var global_position = global_positions.values()[random_index]
		var local_position = local_positions[global_position]

		if !entities.keys().has(local_position):
			var knight = load("res://src/characters/knight/knight.gd").new()
			add_child(knight)
			knight.translate(global_position)
			knight.set_local_position(local_position)
			map.add_entity(knight, local_position)