extends Control

onready var label_position = get_node("Panel/EntityList/position")
onready var label_attack = get_node("Panel/EntityList/attack")
onready var label_movement = get_node("Panel/EntityList/movement")

var entity
var new_position
var position
var path
var popup
var map
var flag_neighbours = false

func _ready():
	popup = load("res://src/interface/PopInfo.tscn")
	popup = popup.instance()
	add_child(popup)
	var move_button = popup.get_node("PopupEntityAction/VBoxContainer/MoveButton")
	var attack_button = popup.get_node("PopupEntityAction/VBoxContainer/AttackButton")
	move_button.connect("pressed", self, "_on_move_pressed")
	attack_button.connect("pressed", self, "_on_attack_pressed")

func get_flag_neighbours():
	return flag_neighbours

func set_flag_neighbours(_flag_neighbours):
	flag_neighbours = _flag_neighbours

func _on_move_pressed():
	var neighbours = map.get_movement_range(position, entity.get_movement_range())
	map.set_flag_movement_range(true)
	map.emit_signal("show_movement_range", neighbours)
	flag_neighbours = true
	popup.get_child(0).hide()

func _on_attack_pressed():
	var neighbours = map.get_attack_range(position, entity.get_attack_range())
	map.emit_signal("show_enemy", neighbours)
	map.set_flag_attack_range(true)
	flag_neighbours = true
	popup.get_child(0).hide()

func set_map(_map):
	map = _map

func has_entity():
	return entity != null
	
func set_entity(_entity):
	entity = _entity
	if entity != null:
		label_position.text = str(entity.get_local_position())
		label_attack.text = str(entity.attack_range)
		label_movement.text = str(entity.movement_range)
	else:
		label_position.text = "No entity"
		label_attack.text = str("")
		label_movement.text = str("")

func entity_actions(_position):
	position = _position
	popup.get_child(0).rect_position = get_global_mouse_position()
	popup.get_child(0).popup()
	
func display_actions(_position, _path):
	new_position = _position
	path = _path
	popup.get_child(0).rect_position = get_global_mouse_position()
	popup.get_child(0).popup()