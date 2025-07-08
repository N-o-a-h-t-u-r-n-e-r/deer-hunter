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
var bolting = false
var cooldown
var bullet
var bullet_pos
var bullet_rot
var mouse_delta := Vector2.ZERO


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
	
func _ready() -> void:
	aim_pos = position + Vector3(-x_offset, y_offset, z_offset)
	hip_pos = position
	rot = rotation
	prev_rot = cam.global_transform.basis.get_rotation_quaternion().normalized()
	ads_cam = get_node("SubViewport/CamContainer/ADSCamera") as Camera3D
	ads_cam_rot = ads_cam.rotation
	cooldown = rate_of_fire
	bullet = $Bullet as MeshInstance3D
	bullet_pos = bullet.position
	bullet_rot = bullet.rotation

func _process(delta: float) -> void:
	
	#set a variable that always increases for the sin function
	sway += delta
	
	if(reloading or bolting):
		cooldown -= delta	
		
	if(reloading):
		rotation.y = lerp_angle(rotation.y, rotation.y + deg_to_rad(90.0), delta * weapon_sway_speed)
		position.y = move_toward(position.y, hip_pos.y - 0.2, delta * weapon_sway_speed)
	
	if((cooldown <= rate_of_fire * 0.3) and bolting):
		if(!$RifleBolt.playing):
			$RifleBolt.play()
			
	if((cooldown <= rate_of_fire * 0.2) and bolting):
		
		bullet.position = bullet.position.move_toward(bullet_pos + -(Vector3(0.0, sin(-cooldown/2.0) + 1.0, 3.0)), delta * 5.0)
		bullet.rotation = bullet.rotation.move_toward(bullet_rot + -(Vector3(10.0, 10.0, 10.0)), delta * 20.0)
		
	if(cooldown <= 0.0):
		bullet.position = bullet_pos
		bullet.rotation = bullet_rot
		cooldown = rate_of_fire
		reloading = false
		bolting = false
	
	var offset_hip_pos = hip_pos + Vector3(sin(sway - 0.5) * (hip_sway_speed), sin(sway) * hip_sway_speed, 0.0)
	
	#Divide by delta because the mouse delta will be higher at lower frame rates. Multiply by 500.0 because delta is very small
	var offset_rotation = Vector3(-deg_to_rad(mouse_delta.y), deg_to_rad(mouse_delta.x), 0) / (delta*500.0)
	

	if(coll_ray.is_colliding()):
		offset_rotation.x = -(rot.z + 1.0 * 85.0)
		position.z = move_toward(position.z, hip_pos.z + 0.2, weapon_sway_speed * delta)
	
	elif(bolting and cooldown <= rate_of_fire * 0.75):
		move_to_base(offset_hip_pos, delta)

	else:
		#Set crosshair not visisble and move rifle to aim position
		if(Input.is_action_pressed("ads") and !reloading):
			crosshair.visible = false
			position = position.move_toward(aim_pos, ads_speed * delta)	
			cam_offset = ads_cam_rot.y
			
			#Handle shooting input, only called if player is ads
			if(Input.is_action_just_pressed("shoot")):	
				#Little check to make sure rifle cant shoot many times in a row
				if(bolting):
					print('bolting')
				else:
					shoot()
		elif(Input.is_action_just_pressed("reload") and !bolting and !reloading):
			reloading = true
			$RifleReload.play()
			
		
		else:
			move_to_base(offset_hip_pos, delta)

	rifle_sway(offset_rotation, delta)	
	mouse_delta = Vector2.ZERO	
			
#logic for setting rifle to default position
func move_to_base(offset_hip_pos, delta):
	crosshair.visible = true
	position = position.move_toward(offset_hip_pos, ads_speed * delta)
	cam_offset = ads_cam_rot.y - ads_offset


#Handles shooting logic for the rifle including rotation and raycasting
func shoot():
	rotation.z = (rotation.z + 1.0) * 0.1 * recoil
	position.z = -((position.z + position.z) + 1.0 * recoil)
	var hit_range = $HitRange
	if((hit_range.is_colliding())):
		var collider = hit_range.get_collider()
		if(collider.is_in_group("Animal")):
			print("Hit")
			var body = collider.get_node("Hitbox") as CollisionShape3D
			body.disabled = true
			collider.get_node("deer/Armature/Skeleton3D/AnimalBones").ragdoll()
		
		
	if(!$RifleShoot.playing):
		$RifleShoot.play()
	bolting = true
		
		
func rifle_sway(offset_rotation, delta):
	rotation.y = lerp_angle(rotation.y, rot.y + offset_rotation.y * weapon_sway, weapon_sway_speed * delta)
	rotation.z = lerp_angle(rotation.z, rot.x + -offset_rotation.x * weapon_sway, weapon_sway_speed * delta)


	ads_cam.rotation.y = lerp_angle(ads_cam.rotation.y, -offset_rotation.y * cam_sway + cam_offset, weapon_sway_speed * delta)
	ads_cam.rotation.x = lerp_angle(ads_cam.rotation.x, -offset_rotation.x * cam_sway + ads_cam_rot.x , weapon_sway_speed * delta)
