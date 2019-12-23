extends "res://src/characters/Character.gd"

const archer = preload("res://entities/archer/archer.tscn")
const circle = preload("res://entities/circle/circle.tscn")
var archer_instance
var circle_instance

func _init():
	# Add instance of the archer scene
	archer_instance = archer.instance()
	circle_instance = circle.instance()
	add_child(archer_instance)
	add_child(circle_instance)
	circle_instance.translate(Vector3(0, 0.1, 0))
	# Set default values for archer character
	movement_range = 2
	attack_range = 1
	life = 3
	
func set_circle_color(color):
	var circle_mesh = circle_instance.get_child(2)
	var material = SpatialMaterial.new()
	material.albedo_color = color
	circle_mesh.set_material_override(material)
	
func is_obstacle():
	return false

func is_attackable():
	return true
 
