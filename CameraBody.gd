extends KinematicBody

var velocity = Vector3(0, 0, 0)
const SPEED = 10

func _ready():
	pass

func _physics_process(delta):
#	# Move Camera
#	if Input.is_action_pressed("ui_right"):
#		velocity.x = SPEED
#	elif Input.is_action_pressed("ui_left"):
#		velocity.x = -SPEED
#	else:
#		velocity.x = 0
#
#	if Input.is_action_pressed("ui_up"):
#		velocity.z = -SPEED
#	elif Input.is_action_pressed("ui_down"):
#		velocity.z = SPEED
#	else:
#		velocity.z = 0
#
#	move_and_slide(velocity)
	var camera = get_node("/root/World/CameraBody/Camera")
	
	# Rotate Camera
	if Input.is_action_pressed("rotation") && Input.is_action_pressed("ui_right"):
		# rotate(Vector3(0, 1, 0), 0.1)
		var old_pos = global_transform.origin
		var angle = 0.1
		var new_pos = Vector3(
			old_pos.x * cos(angle) + old_pos.z * sin(angle),
			old_pos.y,
			(-1) * old_pos.x * sin(angle) + old_pos.z * cos(angle) 
		)
		print(new_pos)
		global_transform.origin = new_pos
		camera.rotate(Vector3(0, 1, 0), 0.1)
	elif Input.is_action_pressed("rotation") && Input.is_action_pressed("ui_left"):
		# rotate(Vector3(0, 1, 0), -0.1)
		var old_pos = global_transform.origin
		var angle = -0.1
		var new_pos = Vector3(
			old_pos.x * cos(angle) + old_pos.z * sin(angle),
			old_pos.y,
			(-1) * old_pos.x * sin(angle) + old_pos.z * cos(angle) 
		)
		print(new_pos)
		global_transform.origin = new_pos
		camera.rotate(Vector3(0, 1, 0), -0.1)
				