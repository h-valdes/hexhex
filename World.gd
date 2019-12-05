extends Spatial
signal click
signal click_outside

func _ready():
	var hex
	var count = 0
	hex = load("res://Hexagon.gd").new(0)
	add_child(hex)
	connect("click", hex, "_on_click")
	connect("click_outside", hex, "_on_click_outside")
	
	hex = load("res://Hexagon.gd").new(1)
	add_child(hex)
	connect("click", hex, "_on_click")
	connect("click_outside", hex, "_on_click_outside")
	hex.translate(Vector3(0.5, 0, 0.75))
	
	hex = load("res://Hexagon.gd").new(2)
	add_child(hex)
	connect("click", hex, "_on_click")
	connect("click_outside", hex, "_on_click_outside")
	hex.translate(Vector3(0.5, 0, -0.75))
	
	hex = load("res://Hexagon.gd").new(3)
	add_child(hex)
	connect("click", hex, "_on_click")
	connect("click_outside", hex, "_on_click_outside")
	hex.translate(Vector3(1, 0, 0))
	
	hex = load("res://Hexagon.gd").new(4)
	add_child(hex)
	connect("click", hex, "_on_click")
	connect("click_outside", hex, "_on_click_outside")
	hex.translate(Vector3(-1, 0, 0))
	
	hex = load("res://Hexagon.gd").new(5)
	add_child(hex)
	connect("click", hex, "_on_click")
	connect("click_outside", hex, "_on_click_outside")
	hex.translate(Vector3(-0.5, 0, -0.75))
	
	hex = load("res://Hexagon.gd").new(6)
	add_child(hex)
	connect("click", hex, "_on_click")
	connect("click_outside", hex, "_on_click_outside")
	hex.translate(Vector3(-0.5, 0, 0.75))
#	for i in range(0, 3):
#		for j in range(0, 3):
#			hex = load("res://Hexagon.gd").new(count)
#			add_child(hex)
#			count += 1
#			connect("click", hex, "_on_click")
#			connect("click_outside", hex, "_on_click_outside")
#			if(j%2):
#				hex.translate(Vector3(i, 0, 0.75*j))
#			else:
#				hex.translate(Vector3(0.5+i, 0, 0.75*j))
	

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
			print(collider_dict["position"])
			emit_signal("click", data)
	else:
		emit_signal("click_outside")
	