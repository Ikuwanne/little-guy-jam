extends Sprite2D

@export var task_id : int
@export var package_sprite: Sprite2D

const TYPES := ["Boot", "Shoe", "Sneaker"]
const COLORS := ["Brown", "Red", "Blue"]
const PACKAGES := [null, preload("res://assets/package_1.png"), preload("res://assets/package_2.png")]

var base_scale: Vector2
var tween: Tween

@export var slot: Sprite2D

var slot_base_scale: Vector2
var slot_tween: Tween
var base_position: Vector2

func _ready() -> void:
	print("hi")
	base_scale = scale
	base_position = position
	if slot:
		slot_base_scale = slot.scale
	GlobalVariables.task_completed.connect(_on_task_completed)
	update_display()
	
func update_display() -> void:
	var n: int = GlobalVariables.shoe_task[task_id] - 1
	var color: int = n / 9
	var type: int = (n % 9) / 3
	var package: int = n % 3
	
	texture = load("res://assets/Shoes/%s%s.png" % [COLORS[color], TYPES[type]])
	if package_sprite:
		package_sprite.texture = PACKAGES[package]

func _on_task_completed(index: int) -> void:
	if index != task_id:
		return
	play_success()


	
func play_success() -> void:
	if tween and tween.is_valid():
		tween.kill()
	
	# Reset propre si on enchaîne les validations
	scale = base_scale
	position = base_position
	modulate = Color.WHITE
	if slot:
		slot.scale = slot_base_scale
		slot.modulate = Color.WHITE
	
	tween = create_tween()
	
	# 1) Anticipation : tout se tasse légèrement
	tween.tween_property(self, "scale", base_scale * 0.9, 0.08)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if slot:
		tween.parallel().tween_property(slot, "scale", slot_base_scale * 0.97, 0.08)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# 2) Validation : l'icône pop, le slot gonfle et passe au vert
	tween.tween_property(self, "scale", base_scale * 1.2, 0.14)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate", Color(1.3, 1.6, 1.3), 0.14)
	if slot:
		tween.parallel().tween_property(slot, "scale", slot_base_scale * 1.12, 0.14)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(slot, "modulate", Color(0.7, 1.4, 0.7), 0.14)
	
	# 3) Temps de lecture : le joueur voit que c'est validé
	tween.tween_interval(0.12)
	
	# 4) Sortie : l'icône monte et s'efface, le slot se détend
	tween.tween_property(self, "position", base_position + Vector2(0, -14), 0.15)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "scale", base_scale * 0.7, 0.15)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.15)
	if slot:
		tween.parallel().tween_property(slot, "scale", slot_base_scale, 0.15)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(slot, "modulate", Color.WHITE, 0.25)
	
	# 5) Nouvelle tâche, placée sous le slot, invisible
	tween.tween_callback(func():
		update_display()
		position = base_position + Vector2(0, 14)
		scale = base_scale * 0.7
		modulate = Color(1, 1, 1, 0)
	)
	
	# 6) Entrée : l'icône monte à sa place avec un léger rebond
	tween.tween_property(self, "position", base_position, 0.35)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "scale", base_scale, 0.35)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.2)
	
	# 7) Le slot "accueille" la nouvelle icône avec une petite pulsation
	if slot:
		tween.parallel().tween_property(slot, "scale", slot_base_scale * 1.04, 0.12)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(slot, "scale", slot_base_scale, 0.2)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
func _process(delta):
	
	var shoe_id = GlobalVariables.shoe_task[task_id]
	
	
	if shoe_id in [2,5,8,11,14,17,20,23,26]:
		self.get_child(0).texture = preload("res://assets/package_1.png")
	if shoe_id in [3,6,9,12,15,18,21,24,27]:
		self.get_child(0).texture = preload("res://assets/package_2.png")
	
	if shoe_id in [1,2,3]:
		self.texture = preload("res://assets/Shoes/BrownBoot.png")
	elif shoe_id in [4,5,6]:
		self.texture = preload("res://assets/Shoes/BrownShoe.png")
	elif shoe_id in [7,8,9]:
		self.texture = preload("res://assets/Shoes/BrownSneaker.png")
	
	if shoe_id in [10,11,12]:
		self.texture = preload("res://assets/Shoes/RedBoot.png")
	elif shoe_id in [13,14,15]:
		self.texture = preload("res://assets/Shoes/RedShoe.png")
	elif shoe_id in [16,17,18]:
		self.texture = preload("res://assets/Shoes/RedSneaker.png")
		
	if shoe_id in [19,20,21]:
		self.texture = preload("res://assets/Shoes/BlueBoot.png")
	elif shoe_id in [22,23,24]:
		self.texture = preload("res://assets/Shoes/BlueShoe.png")
	elif shoe_id in [25,26,27]:
		self.texture = preload("res://assets/Shoes/BlueSneaker.png")
