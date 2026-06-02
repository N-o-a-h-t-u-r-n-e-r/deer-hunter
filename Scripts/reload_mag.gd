extends Control

@onready var ammo_count := $ReloadUI/AmmoBox/AmmoCount
signal reload

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		body.queue_free()
		
		emit_signal("reload")


func _update_text(curr_ammo):
	if curr_ammo == 0:
		ammo_count.text = "(Empty)"
	else:
		ammo_count.text = curr_ammo
