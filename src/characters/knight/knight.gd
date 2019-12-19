extends "res://src/characters/Character.gd"

const knight = preload("res://entities/knight/knight.tscn")

func _init():
	# Add instance of the knight scene
	add_child(knight.instance())
	
	# Set default values for knight character
	movement_range = 2
	attack_range = 2
	life = 3

func is_obstacle():
	return false

func is_attackable():
	return true
