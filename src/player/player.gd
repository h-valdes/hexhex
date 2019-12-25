extends Spatial
class_name Player

var player_name
var entities = {}
var color

func _init(_name, _color):
	player_name = _name
	color = _color

func add_entity(entity):
	entities[entity] = null
	entity.set_circle_color(color)

func remove_entity(entity):
	entities.erase(entity)