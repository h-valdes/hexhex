extends Control

var entity
var label_local_position

func _ready():
	label_local_position = get_node("Panel/EntityList/local_position")

func set_entity(_entity):
	entity = _entity
	if entity != null:
		label_local_position.text = str(entity.get_local_position())
		var popup = load("res://src/interface/PopInfo.tscn")
		popup = popup.instance()
		add_child(popup)
		popup.get_child(0).rect_position = get_global_mouse_position()
		popup.get_child(0).popup()
	else:
		label_local_position.text = "No entity"