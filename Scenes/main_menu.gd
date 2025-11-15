extends Control



func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_sin_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Terrain.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit() 
