extends Control

var entity
var label_local_position
var new_position
var path
var popup
var map

func _ready():
	label_local_position = get_node("Panel/EntityList/local_position")
	popup = load("res://src/interface/PopInfo.tscn")
	popup = popup.instance()
	add_child(popup)
	var move_button = popup.get_node("PopupEntityAction/VBoxContainer/MoveButton")
	var attack_button = popup.get_node("PopupEntityAction/VBoxContainer/AttackButton")
	move_button.connect("pressed", self, "_on_move_pressed")
	attack_button.connect("pressed", self, "_on_attack_pressed")

func _on_move_pressed():
	print("move you fool!")
	map.emit_signal("move_entity", entity, new_position, path)

func _on_attack_pressed():
	print("attack you fool!")

func set_map(_map):
	map = _map

func has_entity():
	return entity != null
	
func set_entity(_entity):
	entity = _entity
	if entity != null:
		label_local_position.text = str(entity.get_local_position())
	else:
		label_local_position.text = "No entity"

func display_actions(_position, _path):
	new_position = _position
	path = _path
	popup.get_child(0).rect_position = get_global_mouse_position()
	popup.get_child(0).popup()