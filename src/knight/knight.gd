extends KinematicBody

const knight = preload("res://entities/knight/knight.tscn")
var knight_instance
var local_position
var movement_range = 2
var attack_range = 1

func _init():
	knight_instance = knight.instance()
	add_child(knight_instance)

func get_local_position():
	return local_position

func set_local_position(_local_position):
	local_position = _local_position

func get_movement_range():
	return movement_range

func get_attack_range():
	return attack_range

func is_obstacle():
	return false

func is_attackable():
	return true
