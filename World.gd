extends Spatial
signal click
signal click_outside

func _ready():
	var square
	var count = 0
	for i in range(0, 3):
		for j in range(0, 3):
			square = load("res://Square.gd").new(count)
			add_child(square)
			count += 1
			connect("click", square, "_on_click")
			connect("click_outside", square, "_on_click_outside")
			if(j%2):
				square.translate(Vector3(i, 0, 0.75*j))
			else:
				square.translate(Vector3(0.5+i, 0, 0.75*j))
	

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
	