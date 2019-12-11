extends KinematicBody

const knight = preload("res://entities/knight/knight.tscn")
var knight_instance
var global_position
var local_position

func _init():
	create()

func create():
	knight_instance = knight.instance()
	add_child(knight_instance)

func get_local_position():
	return local_position

func set_local_position(_local_position):
	local_position = _local_position
	
func get_global_position():
	return global_position

func set_global_position(_global_position):
	global_position = _global_position
	knight_instance.translate(global_position)
