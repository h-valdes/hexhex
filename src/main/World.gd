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

	map.load_characters()