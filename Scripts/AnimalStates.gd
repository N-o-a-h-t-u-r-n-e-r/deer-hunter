extends Node3D

enum State{IDLE, WALK, FLEE, DEAD}
var state 
var timer: float

@export var animal: CharacterBody3D
@onready var navigation_agent: NavigationAgent3D = get_node("../NavigationAgent3D")
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	change_state(State.WALK)
	
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	
	actor_setup.call_deferred()

func _physics_process(delta: float) -> void:

	if navigation_agent.is_navigation_finished():
		change_state(State.IDLE)
		timer -= delta
		return


	match state:
		State.IDLE: _idle_state()
		State.WALK: _walk_state()
		State.FLEE: _flee_state()
		State.DEAD: pass
		
	
	if(timer <= 0):
		change_state(State.WALK)
	
	
		
func change_state(s):
	
	if(state == s):
		return
	match s: 
		State.WALK: 
			set_movement_target(100.0)
			animation_player.speed_scale = 1.5
			animation_player.play("Walk")
			
		State.FLEE:
			set_movement_target(500.0)
			animation_player.speed_scale = 3.0
			animation_player.play("Gallop")
			
		State.IDLE:
			animation_player.speed_scale = 1.2
			animation_player.play("Idle")
			
		State.DEAD:
			print("dead")
			animation_player.play("Death")

	
	state = s

func _idle_state():
	animal.velocity = Vector3.ZERO
	
func _walk_state():

	var current_animal_position: Vector3 = animal.global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	animal.velocity = current_animal_position.direction_to(next_path_position) * animal.walk_speed
	
func _flee_state():
	
	var current_animal_position: Vector3 = animal.global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	animal.velocity = current_animal_position.direction_to(next_path_position) * animal.run_speed
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame


func set_movement_target(distance: float):
	timer = 10.0
	var movement_target_position = Vector3(global_position.x + randf_range(-distance, distance), 
											global_position.y, 
											global_position.z + randf_range(-distance, distance))
											
	navigation_agent.set_target_position(movement_target_position)
	
