extends Spatial
signal click
signal click_outside

func _ready():
	var hex
	hex = load("res://Hexagon.gd").new(Vector3(0, 0, 0))
	add_child(hex)
	connect("click", hex, "_on_click")
	connect("click_outside", hex, "_on_click_outside")
	
	for i in range(1, 7):
		var position
		if i == 1:
			position = Vector3(0.5, 0, 0.75)
		elif i == 2:
			position = Vector3(0.5, 0, -0.75)
		elif i == 3:
			position = Vector3(1, 0, 0)
		elif i == 4:
			position = Vector3(-1, 0, 0)
		elif i == 5:
			position = Vector3(-0.5, 0, -0.75)
		elif i == 6:
			position = Vector3(-0.5, 0, 0.75)
		hex = load("res://Hexagon.gd").new(position)
		add_child(hex)
		connect("click", hex, "_on_click")
		connect("click_outside", hex, "_on_click_outside")
		hex.translate(position)

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
			emit_signal("click", data)
	else:
		emit_signal("click_outside")
	