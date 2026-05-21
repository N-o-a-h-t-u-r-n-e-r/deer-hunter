extends CharacterBody3D

@export var walk_speed: float = 1.0
@export var run_speed: float = 4.0
@export var player: CharacterBody3D
@onready var animal_model: Node3D = $model
@onready var hitbox: CollisionShape3D = $Hitbox
@onready var is_dead: bool = false
var Fleeing : bool = false

signal died

func _ready() -> void:
	#$DeerBreathingFMOD.play()
	pass
func _physics_process(delta: float) -> void:
	
	if(animal_model.state != animal_model.State.DEAD && Fleeing):
		#Calculate Distance between Player and Deer
		var distance = self.global_position.distance_squared_to(player.global_position)
		distance = clamp(distance, 0, 100)

		#Use that information to set the distance parameter in the music.
		#$"../../MusicFMOD".set_parameter("DistanceFromDeer", distance)
	
	
	#Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()*2 * delta

	if(!hitbox.disabled):	
		if(animal_model.state != animal_model.State.IDLE and velocity != Vector3.ZERO):
			
			var flat_vel = velocity
			flat_vel.y = 0
			 	
			if flat_vel.length() > 0.001:
				look_at(global_position + velocity, Vector3.UP, true)
				align_with_surface()
		
		move_and_slide()
	else:
		return

func align_with_surface():
	if(!$SurfaceNormal.is_colliding()):
		return
		
	var normal = $SurfaceNormal.get_collision_normal() as Vector3
	var basis_new = Basis()
	var scale_base = basis.get_scale()

	#Linear algebra bullshit
	basis_new.x = normal.cross(global_basis.z)
	basis_new.y = normal
	basis_new.z = global_basis.x.cross(normal)
	
	basis_new = basis_new.orthonormalized()
	
	basis_new.x *= scale_base.x 
	basis_new.y *= scale_base.y
	basis_new.z *= scale_base.z 
	
	global_basis = basis_new

func _on_area_3d_body_entered(body: PhysicsBody3D) -> void:
	if(body == player and animal_model.state != animal_model.State.DEAD):
		animal_model.change_state(animal_model.State.FLEE)
		Fleeing = true
		print("enter")
		#$"../../MusicFMOD".set_parameter("DeerAlert", 1)
		
#func footstepSound():
	#$DeerFootstepFMOD.play_one_shot()

func die():
	#Play DeerGrunt, stop Deer Breathing, and set parameter DeerAlert to 0
	#$DeerGruntFMOD.play_one_shot()
	#$DeerBreathingFMOD.stop()
	#$"../../MusicFMOD".set_parameter("DeerAlert", 0)
	#Fleeing = false
	set_collision_layer_value(5, true)
	set_collision_mask_value(6, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	hitbox.rotation_degrees = Vector3(0, 0, -80)
	hitbox.position = Vector3(0, -0.1, 0)

	

	is_dead = true
	emit_signal("died")
