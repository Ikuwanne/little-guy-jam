extends Node

signal penalty_at_zero
signal task_completed(index: int)

# --- Sons ---
# Renomme tes fichiers (sans espaces ni majuscules) depuis le FileSystem de Godot
# pour que les références se mettent à jour, puis vérifie ces chemins.
const SOUNDS := {
	"interact": preload("res://assets/sfx/Interact.wav"),
	"good": preload("res://assets/sfx/Confirm 1.wav"),
	"bad": preload("res://assets/sfx/Damage1.wav"),
	"tick": preload("res://assets/sfx/tic.wav"),
}
const POOL_SIZE := 12

# --- Vitesse du tapis ---
@export var start_speed := 80.0
@export var end_speed := 200.0
## Durée (en secondes) pour atteindre la vitesse max
@export var ramp_duration := 240.0

# --- État de la partie ---
var shoe_task: Array[int] = [2, 5, 8]
var score: int = 0
var game_time := 0.0

var sfx_players: Array[AudioStreamPlayer] = []

func _ready() -> void:
	# Pas de process_mode ALWAYS sur l'autoload : game_time doit s'arrêter pendant la pause.
	# Seuls les lecteurs audio ignorent la pause.
	for i in POOL_SIZE:
		var p := AudioStreamPlayer.new()
		# p.bus = "SFX"   # décommente seulement si le bus "SFX" existe dans ton layout audio
		add_child(p)
		sfx_players.append(p)

func _process(delta: float) -> void:
	game_time += delta

# --- Vitesse ---
func get_speed() -> float:
	return lerpf(start_speed, end_speed, clampf(game_time / ramp_duration, 0.0, 1.0))

# --- Partie ---
## À appeler dans le _ready() de la scène de jeu et au restart
func reset_run() -> void:
	get_tree().paused = false
	game_time = 0.0
	score = 0
	shoe_task = [2, 5, 8]

func random_task() -> int:
	return randi_range(2, 27)

func validate_shoe(id: int) -> bool:
	var index := shoe_task.find(id)
	if index == -1:
		return false
	shoe_task[index] = random_task()
	task_completed.emit(index)
	return true

func regenerate_all() -> void:
	shoe_task = [2, 5, 8]

# --- Audio ---
func play_sfx(sound_name: String, volume_db := 0.0, pitch := 1.0, random_pitch := 0.0) -> void:
	if not SOUNDS.has(sound_name):
		push_warning("Son inconnu : " + sound_name)
		return
	
	# On prend un lecteur libre ; sinon on réutilise le premier
	var player: AudioStreamPlayer = sfx_players[0]
	for p in sfx_players:
		if not p.playing:
			player = p
			break
	
	player.stream = SOUNDS[sound_name]
	player.volume_db = volume_db
	player.pitch_scale = pitch + randf_range(-random_pitch, random_pitch)
	player.play()
