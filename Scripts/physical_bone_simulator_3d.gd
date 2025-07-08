extends PhysicalBoneSimulator3D


# Called when the node enters the scene tree for the first time.
func ragdoll() -> void:
	active = true
	physical_bones_start_simulation()

func _ready() -> void:
	#physical_bones_start_simulation()
	pass
