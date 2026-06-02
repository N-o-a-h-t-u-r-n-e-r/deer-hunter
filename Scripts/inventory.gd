extends Node3D

@onready var inventory: Dictionary 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory = {"Deer":0, "Bunny":0, "total_ammo":24, "current_ammo":6}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reload_bullet() -> void:
	inventory["total_ammo"] -= 1
	inventory["current_ammo"] += 1
	
func shoot_bullet() -> void:
	inventory["current_ammo"] -= 1
	
func collect_bullets() -> void:
	inventory["total_ammo"] += 6
