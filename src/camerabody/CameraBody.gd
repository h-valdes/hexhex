extends KinematicBody

var velocity = Vector3(0, 0, 0)
const SPEED = 10
var angle = 0.1
var camera 
var world_dimensions

func _ready():
	camera = get_node("/root/World/CameraBody/Camera")

func _unhandled_input(event):
	var camera_position = camera.global_transform.origin
	if event is InputEventMouseButton:
		# Zoom control
		if event.button_index == BUTTON_WHEEL_UP:
			if event.pressed:
				if camera_position.y > 4:
					camera.translate(Vector3(0, 0, -1)/4)
		if event.button_index == BUTTON_WHEEL_DOWN:
			if event.pressed:
				if camera_position.y < 20:
					camera.translate(Vector3(0, 0, 1)/4)

func _physics_process(delta):
	world_dimensions = camera.get_meta("world_dimension")
	var angle_camera = (PI * 55) / 180
	var camera_position = camera.global_transform.origin
	# Move Camera
	if Input.is_action_pressed("ui_right"):
		if camera_position.x < world_dimensions["max_x"]:
			camera.translate(Vector3(1, 0, 0)/4)
	elif Input.is_action_pressed("ui_left"):
		if camera_position.x > world_dimensions["min_x"]:
			camera.translate(Vector3(-1, 0, 0)/4)

	if Input.is_action_pressed("ui_up"):
		if camera_position.z > world_dimensions["min_z"] / 2:
			camera.translate(Vector3(0, 1, -1)/4)
	elif Input.is_action_pressed("ui_down"):
		if camera_position.z < world_dimensions["max_z"] + 10:
			camera.translate(Vector3(0, -1, 1)/4)
	
	# Rotate Camera
	if Input.is_action_pressed("rotation_right"):
		var old_pos = global_transform.origin
		angle = 0.1
		var new_pos = Vector3(
			old_pos.x * cos(angle) + old_pos.z * sin(angle),
			old_pos.y,
			(-1) * old_pos.x * sin(angle) + old_pos.z * cos(angle) 
		)
		global_transform.origin = new_pos
		camera.rotate(Vector3(0, 1, 0)/4, 0.1)
	elif Input.is_action_pressed("rotation_left"):
		var old_pos = global_transform.origin
		angle = -0.1
		var new_pos = Vector3(
			old_pos.x * cos(angle) + old_pos.z * sin(angle),
			old_pos.y,
			(-1) * old_pos.x * sin(angle) + old_pos.z * cos(angle) 
		)
		global_transform.origin = new_pos
		camera.rotate(Vector3(0, 1, 0)/4, -0.1)
				