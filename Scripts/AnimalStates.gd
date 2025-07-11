extends Node3D

enum State{IDLE, WALK, FLEE}
var state 
var timer: float

@export var animal: CharacterBody3D
@onready var navigation_agent: NavigationAgent3D = get_node("../NavigationAgent3D")


func _ready() -> void:
	change_state(State.WALK)
	
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	
	actor_setup.call_deferred()

func _physics_process(delta: float) -> void:
	
	if(timer <= 0):
		change_state(State.WALK)
	
	match state:
		State.IDLE: _idle_state(delta)
		State.WALK: _walk_state(delta)
		State.FLEE: _flee_state(delta)
	
	if navigation_agent.is_navigation_finished():
		change_state(State.IDLE)
		timer -= delta
		return
	
	
		
func change_state(s):
	if(state == s):
		return
	if(s == State.WALK):
		timer = 10.0
		var movement_target_position = Vector3(global_position.x + randf_range(-10.0, 10.0), global_position.y, global_position.z + randf_range(-10.0, 10.0))
		set_movement_target(movement_target_position)
	state = s

func _idle_state(delta):
	animal.velocity = Vector3.ZERO

	
func _walk_state(delta):

	
	var current_animal_position: Vector3 = animal.global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	animal.velocity = current_animal_position.direction_to(next_path_position) * animal.walk_speed
	
func _flee_state(delta):
	pass
	
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame


func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)
	
