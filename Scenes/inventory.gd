extends Node3D

@onready var inventory: Dictionary 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory = {"Deer":0, "Bunny":0}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
