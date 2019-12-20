extends "res://src/characters/Character.gd"

const knight = preload("res://entities/knight/knight.tscn")
const circle = preload("res://entities/circle/circle.tscn")
var knight_instance
var circle_instance

func _init():
	# Add instance of the knight scene
	knight_instance = knight.instance()
	circle_instance = circle.instance()
	add_child(knight_instance)
	add_child(circle_instance)
	circle_instance.translate(Vector3(0, 0.1, 0))
	# Set default values for knight character
	movement_range = 2
	attack_range = 1
	life = 3
	
func set_circle_color(color):
	var circle_mesh = circle_instance.get_child(2)
	print(circle_mesh.get_surface_material(0))
	var material = SpatialMaterial.new()
	material.albedo_color = color
	circle_mesh.set_material_override(material)
	
func is_obstacle():
	return false

func is_attackable():
	return true
