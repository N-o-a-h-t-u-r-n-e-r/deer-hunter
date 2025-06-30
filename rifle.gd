extends Node3D

@export var player : CharacterBody3D
@export var x_offset := 0.35
@export var y_offset := 0.4
@export var z_offset := 0.1
@export var ads_speed := 1.0
@export var sway_speed := 0.01

var aim_pos
var hip_pos
var rot
var sway = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aim_pos = position + Vector3(-x_offset, y_offset, z_offset)
	hip_pos = position
	print(position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sway += delta
	var offset_hip_pos = hip_pos + Vector3(sin(sway - 0.1) * (sway_speed), sin(sway) * sway_speed, 0.0) 

	
	if(Input.is_action_pressed("ads")):
		position = position.move_toward(aim_pos, ads_speed * delta)		
		
	else:
		position = position.move_toward(offset_hip_pos, ads_speed * delta)

		
	pass
