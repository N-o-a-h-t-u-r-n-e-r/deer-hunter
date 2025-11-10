extends Node3D


func _process(delta: float) -> void:
	rotate_y(delta * 1.0)  # spin nicely
