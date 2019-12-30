extends KinematicBody
class_name Character

var local_position setget set_local_position, get_local_position
var movement_range setget , get_movement_range
var attack_range setget , get_attack_range
var life
var is_active = true

func _ready():
	pass

func deactivate():
	is_active = false
	self.hide()

func get_local_position():
	return local_position

func set_local_position(_local_position):
	local_position = _local_position

func get_movement_range():
	return movement_range

func get_attack_range():
	return attack_range
