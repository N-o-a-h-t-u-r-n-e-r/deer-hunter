extends Node3D

@export var cam : Node3D
@export var x_offset := 0.35
@export var y_offset := 0.4
@export var z_offset := 0.1
@export var ads_speed := 1.0
@export var hip_sway_speed := 0.01
@export var weapon_sway := 30.0
@export var weapon_sway_speed := 5.0
@export var cam_sway := 50.0
@export var ads_offset := -0.35
@export var crosshair: Control
@export var coll_ray : RayCast3D
@export var recoil = 1.5
@export var range = 100.0
@export var rate_of_fire = 3.0
var aim_pos
var hip_pos
var rot
var prev_rot
var sway = 0.0
var ads_cam
var ads_cam_rot
var cam_offset
var reloading = false
var cooldown
var bullet
var bullet_pos


func _ready() -> void:
	aim_pos = position + Vector3(-x_offset, y_offset, z_offset)
	hip_pos = position
	rot = rotation
	prev_rot = cam.global_transform.basis.get_euler()
	ads_cam = get_node("SubViewport/CamContainer/ADSCamera") as Camera3D
	ads_cam_rot = ads_cam.rotation
	cooldown = rate_of_fire
	bullet = $Bullet as MeshInstance3D
	bullet_pos = bullet.position
	
	
func _process(delta: float) -> void:
	
	if(reloading):
		cooldown -= delta	
	
	if(cooldown <= 0.0):
		
		cooldown = rate_of_fire
		reloading = false
		
	#set a variable that always increases for the sin function
	sway += delta
	var offset_hip_pos = hip_pos + Vector3(sin(sway - 0.5) * (hip_sway_speed), sin(sway) * hip_sway_speed, 0.0)
	
	#get camera pivot rotation for weapon swaying
	var cam_rotation = cam.global_transform.basis.get_euler() - prev_rot 
	var offset_rotation = cam_rotation 
	prev_rot = cam.global_transform.basis.get_euler()
	
	if(coll_ray.is_colliding()):
		offset_rotation.x = -(rot.z + 1.0 * 85.0)
		position.z = move_toward(position.z, hip_pos.z + 0.2, weapon_sway_speed * delta)
	
	if(reloading and cooldown <= rate_of_fire * 0.75):
		move_to_base(offset_hip_pos, delta)

	else:
		#Set crosshair not visisble and move rifle to aim position
		if(Input.is_action_pressed("ads")):
			crosshair.visible = false
			position = position.move_toward(aim_pos, ads_speed * delta)	
			cam_offset = ads_cam_rot.y
			
			#Handle shooting input, only called if player is ads
			if(Input.is_action_just_pressed("shoot")):	
				#Little check to make sure rifle cant shoot many times in a row
				if(reloading):
					print('reloading')
				else:
					rotation.z = (rotation.z + 1.0) * 0.1 * recoil
					position.z = -((position.z + position.z) + 1.0 * recoil)
					var hit_range = $HitRange
					if((hit_range.is_colliding())):
						print('HIT')
					reloading = true
			
		else:
			move_to_base(offset_hip_pos, delta)


	rotation.y = lerp_angle(rotation.y, -offset_rotation.y * weapon_sway + rot.y, weapon_sway_speed * delta)
	#For some reason the x axis of the camera pivot is this nodes z axis?
	rotation.z = lerp_angle(rotation.z, -offset_rotation.x * weapon_sway * 5.0 + rot.x, weapon_sway_speed * delta )
	
	ads_cam.rotation.y = lerp_angle(ads_cam.rotation.y, -offset_rotation.y * cam_sway + cam_offset, ads_speed * 2.0 * delta)
	ads_cam.rotation.x = lerp_angle(ads_cam.rotation.x, -offset_rotation.x * cam_sway * 5.0 + ads_cam_rot.x , ads_speed * 2.0 * delta)

#logic for setting rifle to default position
func move_to_base(offset_hip_pos, delta):
	crosshair.visible = true
	position = position.move_toward(offset_hip_pos, ads_speed * delta)
	cam_offset = ads_cam_rot.y - ads_offset
