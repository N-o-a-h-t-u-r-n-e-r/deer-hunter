extends RigidBody2D

@export var x_bounds := 80
@export var y_bounds := 20

var dragging := false
var drag_offset := Vector2.ZERO




func _input(event):
	if dragging and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			dragging = false
			linear_velocity = drag_offset


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dragging = true


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if dragging:

	
		state.linear_velocity = (get_global_mouse_position() - global_position) * 10.0

		rotation_degrees = 0

		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		queue_free()
