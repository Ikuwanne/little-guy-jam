extends Marker2D

@export var shoes: PackedScene
@export var path_follower: PackedScene
@export var path: Path2D

func _on_shoes_spawn_timeout() -> void:
	var follower = path_follower.instantiate()
	path.add_child(follower)
	follower.add_child(shoes.instantiate())
