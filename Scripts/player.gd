extends CharacterBody3D

#Exports
@export var speed = 5.0
@export var sensetivity = 0.05
@export var aim_sensetivity = 0.1
@export var bob_speed = 0.5
@export var bob_amount = 0.5
#Constants
const JUMP_VELOCITY = 4.5
const FRICTION = 1.0

#Global Variables
var vertical_rotation = 0.0
var cam : Camera3D
var cam_pos
var bob_timer = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam = $CameraPivot/Camera3D
	cam_pos = cam.position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		bob_timer += bob_speed * delta
		#Use move towrad to ease into movement
		velocity.x = move_toward(velocity.x, direction.x * speed, FRICTION)
		velocity.z = move_toward(velocity.z, direction.z * speed, FRICTION)
	else:
		bob_timer = 0.0
		#Used to smoothly stop the player, the lower the delta, the slower the player will come to a stop
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		velocity.z = move_toward(velocity.z, 0, FRICTION)
	
	
	cam.position.y = move_toward(cam.position.y, (sin(bob_timer) * bob_amount) + cam_pos.y, 1.0 * delta)
	move_and_slide()
	
	
func _input(event: InputEvent) -> void:
	
	#If the input event is mouse movement. event.relative is how much the mouse has moved since the last frame.
	if(event is InputEventMouseMotion):
		
		#get the mouse x movement and rotate around the player's y axis (Horizontal Movement)
		rotate_y(deg_to_rad(-event.relative.x * aim_sensetivity))
		
		#calculate the vertical rotation by subtracting the current rotation from the relative y mouse movement
		vertical_rotation = clamp(vertical_rotation - event.relative.y * aim_sensetivity, -90, 90)
		$CameraPivot.rotation_degrees.x = vertical_rotation
		
		
func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventKey and event.pressed):
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		
	
