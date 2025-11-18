@tool
extends Node3D
@export var speed:float = 1.0

func _process(delta: float) -> void:
	rotate_y(delta * speed)  # spin nicely
