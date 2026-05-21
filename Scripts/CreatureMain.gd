extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $iteration29/AnimationPlayer


func _ready() -> void:
	animation_player.play("Idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	move_and_slide()
