extends StaticBody2D

const open_texture = preload("res://Textures/ammo_open_lowres.png")
const closed_texture = preload("res://Textures/ammo_closed_lowres.png")
const bullet = preload("res://Scenes/bullet.tscn")


func _on_mouse_entered() -> void:
	$AmmoBoxTexture.texture = open_texture
	$Bullet.visible = true

func _on_mouse_exited() -> void:
	$AmmoBoxTexture.texture = closed_texture
	$Bullet.visible = false


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var bullet_obj = bullet.instantiate()
			bullet_obj.position = get_global_mouse_position()
			add_sibling(bullet_obj)
