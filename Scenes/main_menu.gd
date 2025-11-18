extends Control


func _on_sin_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/LoadingScreen.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
