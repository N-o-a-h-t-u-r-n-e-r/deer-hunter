extends Node3D

@onready var animation_player : AnimationPlayer = $BearTrapAnimation
@onready var trap_close : AudioStreamPlayer3D = $ClampSound
@onready var disarm_lable : Label3D = $DisarmLabel

enum State{OPEN, CLOSED, DEACTIVATED}
var curr_state:State = State.OPEN
var character : CharacterBody3D

func trigger():
	animation_player.play("Clamp")
	trap_close.play()
	curr_state = State.CLOSED
	disarm_lable.visible = true
	
	
func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("Player"):
		character = body
		curr_state = State.CLOSED
		var progress_bar: ProgressBar = character.get_node("Progress/ProgressBar")
		trigger()
		character.set_physics_process(false)
		progress_bar.visible = true
		

func _on_progress_bar_value_changed(value: float) -> void:
	if value == 100:
		curr_state = State.DEACTIVATED
		character.set_physics_process(true)
		self.queue_free()
