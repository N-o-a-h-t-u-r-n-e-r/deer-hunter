extends RigidBody2D

@export var x_bounds := 80
@export var y_bounds := 20

var dragging := false
var drag_offset := Vector2.ZERO


func _ready() -> void:
	dragging=true



func _process(delta: float) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging = false
		queue_free()


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			dragging = true


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if dragging:

	
		state.linear_velocity = (get_global_mouse_position() - global_position) * 10.0

		rotation_degrees = 0
