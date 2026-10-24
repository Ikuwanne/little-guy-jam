extends Node2D

@export var points: Array[Marker2D]
@export var duree: float = 2.0

func _ready() -> void:
	var tween := create_tween().set_loops()
	for point in points:
		tween.tween_property(self, "global_position", point.global_position, duree)
