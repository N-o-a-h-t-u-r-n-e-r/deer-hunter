extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer3D


func trigger():
	animation_player.play("Clamp")
	audio_player.play()
	


func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("Player"):
		trigger()
