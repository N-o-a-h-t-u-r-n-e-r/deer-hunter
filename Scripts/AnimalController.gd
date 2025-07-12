extends CharacterBody3D

@export var walk_speed: float = 1.0
@export var run_speed: float = 2.0
@export var player: CharacterBody3D
@onready var animal: Node3D = $deer
@onready var hitbox: CollisionShape3D = $Hitbox


func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	
	#Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()*2 * delta

	if(!hitbox.disabled):	
		if(animal.state != animal.State.IDLE and velocity != Vector3.ZERO):
			#IMPORTANT: set the rotation before aligning with surface normal
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
	if(body == player and animal.state != animal.State.DEAD):
		animal.change_state(animal.State.FLEE)
