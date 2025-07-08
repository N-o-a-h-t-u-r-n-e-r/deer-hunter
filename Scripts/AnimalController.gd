extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var hitbox

func _ready() -> void:
	hitbox = $Hitbox as CollisionShape3D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if(!hitbox.disabled):
		move_and_slide()
	else:
		pass
