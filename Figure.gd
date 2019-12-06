extends StaticBody
class_name Figure

func _init():
	var myMesh = MeshInstance.new()
	myMesh.mesh = CubeMesh.new()
	myMesh.create_trimesh_collision()
	add_child(myMesh)
	
func _ready():
	pass
