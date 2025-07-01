extends Node3D

@export var cam : Node3D
@export var x_offset := 0.35
@export var y_offset := 0.4
@export var z_offset := 0.1
@export var ads_speed := 1.0
@export var sway_speed := 0.01
@export var weapon_sway := 30.0
@export var weapon_sway_speed := 5.0
@export var cam_sway := 50.0
@export var ads_offset := -0.35
@export var crosshair: Control
@export var coll_ray : RayCast3D
@export var recoil = 1.5
var aim_pos
var hip_pos
var rot
var prev_rot
var sway = 0.0
var ads_cam
var ads_cam_rot
var cam_offset


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aim_pos = position + Vector3(-x_offset, y_offset, z_offset)
	hip_pos = position
	rot = rotation
	prev_rot = cam.global_transform.basis.get_euler()
	ads_cam = get_node("SubViewport/CamContainer/ADSCamera") as Camera3D
	ads_cam_rot = ads_cam.rotation



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sway += delta
	var offset_hip_pos = hip_pos + Vector3(sin(sway - 0.5) * (sway_speed), sin(sway) * sway_speed, 0.0)
	
	#get camera pivot rotation for weapon swaying
	var cam_rotation = cam.global_transform.basis.get_euler() - prev_rot 
	var offset_rotation = cam_rotation 
	prev_rot = cam.global_transform.basis.get_euler()
	
	if(coll_ray.is_colliding()):
		offset_rotation.x = -(rot.z + 1.0 * 85.0)

	if(Input.is_action_just_pressed("shoot")):
		rotation.z = -(rot.z + 1.0 * recoil)
		position.z = -(position.z + 1.0)
	
	if(Input.is_action_pressed("ads")):
		crosshair.visible = false
		position = position.move_toward(aim_pos, ads_speed * delta)	
		cam_offset = ads_cam_rot.y
			
	else:
		crosshair.visible = true
		position = position.move_toward(offset_hip_pos, ads_speed * delta)
		cam_offset = ads_cam_rot.y - ads_offset


	rotation.y = lerp_angle(rotation.y, -offset_rotation.y * weapon_sway + rot.y, weapon_sway_speed * delta)
	#For some reason the x axis of the camera pivot is this nodes z axis?
	rotation.z = lerp_angle(rotation.z, -offset_rotation.x * weapon_sway * 5.0 + rot.x, weapon_sway_speed * delta )
	
	ads_cam.rotation.y = lerp_angle(ads_cam.rotation.y, -offset_rotation.y * cam_sway + cam_offset, ads_speed * 2.0 * delta)
	ads_cam.rotation.x = lerp_angle(ads_cam.rotation.x, -offset_rotation.x * cam_sway * 5.0 + ads_cam_rot.x , ads_speed * 2.0 * delta)

	
