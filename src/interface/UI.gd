extends Control

var entity
var label_local_position

func _ready():
	label_local_position = get_node("Panel/EntityList/local_position")

func set_entity(_entity):
	entity = _entity
	if entity != null:
		label_local_position.text = str(entity.get_local_position())
	else:
		label_local_position.text = "No entity"