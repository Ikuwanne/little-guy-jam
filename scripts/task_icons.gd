extends Node

@export var task_id : int

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
