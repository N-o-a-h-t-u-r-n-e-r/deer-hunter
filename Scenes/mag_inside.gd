extends RigidBody2D

@export var x_pos := 908.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Lock the X axis by forcing its velocity to 0
	var velocity = state.linear_velocity
	velocity.x = 0
	state.linear_velocity = velocity
