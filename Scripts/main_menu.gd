extends Control


func _on_sin_button_pressed() -> void:
	$ButtonClickFMOD.play_one_shot()
	get_tree().change_scene_to_file("res://Scenes/LoadingScreen.tscn")


func _on_quit_button_pressed() -> void:
	$ButtonClickFMOD.play_one_shot()
	get_tree().quit()


func _on_options_button_pressed() -> void:
	$ButtonClickFMOD.play_one_shot()


func _on_options_button_mouse_entered() -> void:
	$ButtonHoverFMOD.play()


func _on_sin_button_mouse_entered() -> void:
	$ButtonHoverFMOD.play()


func _on_quit_button_mouse_entered() -> void:
	$ButtonHoverFMOD.play()


func _on_sin_button_mouse_exited() -> void:
	$ButtonHoverFMOD.stop()


func _on_options_button_mouse_exited() -> void:
	$ButtonHoverFMOD.stop()


func _on_quit_button_mouse_exited() -> void:
	$ButtonHoverFMOD.stop()
