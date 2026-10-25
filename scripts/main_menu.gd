extends Node2D

@export_file("*.tscn") var game_scene: String = "res://scenes/main.tscn"

@export_group("Titre")
@export var float_height := 8.0
@export var float_duration := 1.4
@export var tilt_degrees := 1.5

@export_group("Bouton Play")
@export var hover_scale := 1.12
@export var hover_color := Color("ffffff74")

@onready var title: Node2D = $HUD/Title
@onready var play_button: Control = $HUD/PlayTextButton

var hover_tween: Tween

func _ready() -> void:
	_start_title_float()
	
	play_button.pivot_offset = play_button.size / 2.0
	play_button.mouse_entered.connect(_on_hover.bind(true))
	play_button.mouse_exited.connect(_on_hover.bind(false))
	play_button.focus_entered.connect(_on_hover.bind(true))
	play_button.focus_exited.connect(_on_hover.bind(false))
	play_button.gui_input.connect(_on_button_input)

func _start_title_float() -> void:
	var base_y := title.position.y
	var base_rot := title.rotation
	var tilt := deg_to_rad(tilt_degrees)
	
	var t := create_tween().set_loops()
	t.tween_property(title, "position:y", base_y - float_height, float_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	t.tween_property(title, "position:y", base_y + float_height, float_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	var r := create_tween().set_loops()
	r.tween_property(title, "rotation", base_rot + tilt, float_duration * 1.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	r.tween_property(title, "rotation", base_rot - tilt, float_duration * 1.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_hover(hovered: bool) -> void:
	if hover_tween and hover_tween.is_valid():
		hover_tween.kill()
	hover_tween = create_tween().set_parallel(true)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	var target_scale := Vector2.ONE * (hover_scale if hovered else 1.0)
	var target_color := hover_color if hovered else Color.WHITE
	hover_tween.tween_property(play_button, "scale", target_scale, 0.18)
	hover_tween.tween_property(play_button, "modulate", target_color, 0.18)\
		.set_trans(Tween.TRANS_SINE)

func _on_button_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_start_game()

func _start_game() -> void:
	get_tree().change_scene_to_file(game_scene)
