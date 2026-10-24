extends PathFollow2D


@export var speed = 200

func _process(delta: float) -> void:
	progress += delta * speed
	if progress_ratio >= 1.0 and get_child_count() > 0:
		var shoe = get_child(0)
		
		shoe.queue_free()
