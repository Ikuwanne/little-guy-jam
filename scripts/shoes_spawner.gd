extends Marker2D

@export var shoes: PackedScene
@export var path_follower: PackedScene
@export var path: Path2D
var shoes_count: int

func _process(delta: float) -> void:
	shoes_count = get_tree().get_nodes_in_group("shoes").size()

func _on_shoes_spawn_timeout() -> void:
	if shoes_count >= 3:
		return
	else:
		var follower = path_follower.instantiate()
		path.add_child(follower)
		follower.add_child(shoes.instantiate())
	
