@tool
extends Node3D

@export var stag_scene: PackedScene
@export var spawn_count: int = 8
@export var spawn_radius: int = 100
@export var raycast_height : float = 100.0

const LAYER_TERRAIN := 1 << 1        # layer 2 in the editor
const LAYER_WATER_BLOCKER := 1 << 3 

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = 100
	var space_state = get_world_3d().direct_space_state
	spawn_count = 8
	
	if stag_scene:
		while spawn_count > 0:
			
			var x = rng.randf_range(-spawn_radius, spawn_radius)
			var z = rng.randf_range(-spawn_radius, spawn_radius)

			var from = global_transform.origin + Vector3(x, raycast_height, z)
			var to = global_transform.origin + Vector3(x, -raycast_height, z)

			var query = PhysicsRayQueryParameters3D.create(from, to)

			query.collision_mask = LAYER_TERRAIN | LAYER_WATER_BLOCKER
			query.collide_with_bodies = true
			query.collide_with_areas = true 

			var result = space_state.intersect_ray(query)
		
			if not result:
				continue

			var collider = result["collider"]

			# Skip water blocker hits
			if (collider.collision_layer & LAYER_WATER_BLOCKER) != 0:
				continue

			# Only accept terrain hits
			if (collider.collision_layer & LAYER_TERRAIN) == 0:
				continue
				

			var pos = to_local(result["position"]) + Vector3.UP
			
			
			var stag:CharacterBody3D = stag_scene.instantiate()
			stag.player = get_node("../FPSCharacter/Player")
			stag.transform = Transform3D((Basis(Vector3.UP, rng.randf() * TAU)),pos)
			add_child(stag)
			spawn_count-=1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
