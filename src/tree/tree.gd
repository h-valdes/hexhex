extends KinematicBody

const tree = preload("res://entities/tree/tree.tscn")
var tree_instance
var local_position

func _init():
	tree_instance = tree.instance()
	add_child(tree_instance)

func get_local_position():
	return local_position

func set_local_position(_local_position):
	local_position = _local_position
 