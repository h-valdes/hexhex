extends Spatial
var map
func _ready():
	map = load("res://Map.gd").new()
	add_child(map)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				right_click(event.position)
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				left_click(event.position)

func raycast_collider(position):
	var ray_length = 1000
	var camera = get_node("/root/World/CameraBody/Camera")
	var from = camera.project_ray_origin(position)
	var to = from + camera.project_ray_normal(position) * ray_length
	var space_state = get_world().direct_space_state
	var collider_dict = space_state.intersect_ray(from, to, [self])
	return collider_dict

func left_click(position):
	pass
			
func right_click(position):
	var collider_dict = raycast_collider(position)
	if collider_dict:
		if collider_dict["collider"].has_meta("data"):
			var data = collider_dict["collider"].get_meta("data")
			map.emit_signal("click", data)
			if data["type"] == "hexagon":
				var neighbours = map.get_neighbours(data["local_position"])
				map.emit_signal("show_neighbours", neighbours)
	else:
		map.emit_signal("click_outside")