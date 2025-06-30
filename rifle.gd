extends Node3D

@export var cam : Node3D
@export var x_offset := 0.35
@export var y_offset := 0.4
@export var z_offset := 0.1
@export var ads_speed := 1.0
@export var sway_speed := 0.01
@export var weapon_swway := 30.0

var aim_pos
var hip_pos
var rot
var prev_rot
var sway = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aim_pos = position + Vector3(-x_offset, y_offset, z_offset)
	hip_pos = position
	rot = rotation
	prev_rot = cam.global_transform.basis.get_euler()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sway += delta
	var offset_hip_pos = hip_pos + Vector3(sin(sway - 0.5) * (sway_speed), sin(sway) * sway_speed, 0.0)
	
	#get camera pivot rotation for weapon swaying
	var cam_rotation = cam.global_transform.basis.get_euler() - prev_rot 
	var offset_rotation = cam_rotation 
	prev_rot = cam.global_transform.basis.get_euler()
	
	if(Input.is_action_pressed("ads")):
		position = position.move_toward(aim_pos, ads_speed * delta)		

	else:
		position = position.move_toward(offset_hip_pos, ads_speed * delta)

	rotation.y = lerp_angle(rotation.y, -offset_rotation.y * weapon_swway + rot.y, 0.005)
	#For some reason the x axis of the camera pivot is this nodes z axis?
	rotation.z = lerp_angle(rotation.z, -offset_rotation.x * weapon_swway*5 + rot.x, 0.005)
